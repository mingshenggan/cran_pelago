require "open-uri"

class FetchPackagesJob < ApplicationJob
  def perform(url, forced: false)
    if !forced
      # TODO: Sanitize + validate url heavily
      raise "Please provide the url leading to the packages directory, not the url to PACKAGES" if url[/PACKAGES$/]
    end

    @session = CrawlerSession.find_or_create_by!(url: url)

    import_packages!
  end

  private def import_packages!
    file = open("#{@session.url}/PACKAGES")

    # ASSUMPTION: text field has a limit of 65536 characters.
    # Background job will make noise if it exceeds.
    packages = []
    file.read.split("\n\n").each do |details|
      basics = details.match(/^Package: (?<package>.*)\nVersion: (?<version>.*)\n/)
      next puts("Unable to parse: [[ #{details} ]]") unless basics
      package = basics["package"]
      version = basics["version"]

      next puts("Unable to find package name in: [[ #{details} ]]") unless package
      next puts("Unable to find package version in: [[ #{details} ]]") unless version
      packages << CranPackage.new(crawler_session_id: @session.id, name: package, version: version, parsed_at: Time.now)
    end

    CranPackage.import(packages, on_duplicate_key_ignore: true)
    @session.update(completed_at: Time.now)
  end
end
