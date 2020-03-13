require "open-uri"
require "rubygems/package"
require "zlib"

class FetchPackageDetailsJob < ApplicationJob
  def perform(cran_package, forced: false)
    return true if cran_package.parsed_at && !forced

    url = "#{cran_package.crawler_session.url}/#{cran_package.name}_#{cran_package.version}.tar.gz"
    file = open(url)

    # Ref: Decompress tar.gz: https://stackoverflow.com/questions/856891/unzip-zip-tar-tag-gz-files-with-ruby
    tar_extract = Gem::Package::TarReader.new(
      Zlib::GzipReader.open(file)
    )
    tar_extract.rewind 
    tar_extract.each do |entry|
      next unless entry.full_name[/DESCRIPTION$/]

      details = TokenizePackageDescriptionService
        .call(entry.read)
        .merge(parsed_at: Time.now)

      CranPackage.transaction do
        cran_package.update(details.except(:authors, :maintainer))

        # In a real world project, I will likely contest the effectiveness of tokenizing info of authors / maintainers
        # Doesn't make much sense because there's no clear identifiers. Best effort = upcase everything when saving
        if details[:authors]
          details[:authors].each do |name|
            author = Person.find_or_create_by(name: name.upcase)
            cran_package.authors << author
          end
        end

        if details[:maintainer]
          name, email = details[:maintainer]
          maintainer = Person.find_or_create_by(name: name.upcase)
          maintainer.update(email: email)
          cran_package.maintainers << maintainer
        end
      end

      break
    end
    tar_extract.close

    cran_package
  rescue Exception => e
    # Understand that rescuing all is a bad practice, but because this is an unstructured task,
    # therefore better to prevent unnecessary retrying and assume logging = reporting to error monitoring framework
    logger.error("Error processing: CranPackage(id: #{cran_package.id}), error message: #{e.message}")
  end
end
