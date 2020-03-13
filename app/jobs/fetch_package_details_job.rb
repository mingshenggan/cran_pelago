require "open-uri"
require "rubygems/package"
require "zlib"

class FetchPackageDetailsJob < ApplicationJob
  # Package: A3
  # Type: Package
  # Title: Accurate, Adaptable, and Accessible Error Metrics for Predictive
  #         Models
  # Version: 1.0.0
  # Date: 2015-08-15
  # Author: Scott Fortmann-Roe
  # Maintainer: Scott Fortmann-Roe <scottfr@berkeley.edu>
  # Description: Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.
  # License: GPL (>= 2)
  # Depends: R (>= 2.15.0), xtable, pbapply
  # Suggests: randomForest, e1071
  # NeedsCompilation: no
  # Packaged: 2015-08-16 14:17:33 UTC; scott
  # Repository: CRAN
  # Date/Publication: 2015-08-16 23:05:52

  # FetchPackageDetailsJob.perform_now(CranPackage.first)

  def perform(cran_package)
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

      cran_package.update(details.except(:authors, :maintainer))

      break
    end
    tar_extract.close

    cran_package
  end
end
