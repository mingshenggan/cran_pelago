describe FetchPackagesJob, type: :job do
  it "raises error if url is invalid" do
    expect do
      described_class.perform_now("http://cran.r-project.org/src/contrib/PACKAGES")
    end.to raise_error(/leading to/i)
  end

  it "creates a crawler session based on input url" do
    uri = "http://cran.r-project.org/src/contrib/"
    allow_any_instance_of(described_class).to receive(:import_packages!).and_return(nil)

    expect do
      described_class.perform_now(uri)
    end.to change { CrawlerSession.count }.by(1)
  end

  it "creates a list of cran packages" do
    session = create(:crawler_session)

    expect do
      VCR.use_cassette("crawl_packages") do
        described_class.perform_now(session.url)
      end
    end.to change { CranPackage.count }.from(0).to(10)
  end
end
