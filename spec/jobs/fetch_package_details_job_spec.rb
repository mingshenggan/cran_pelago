describe FetchPackageDetailsJob, type: :job do
  it "skips if package has already been parsed" do
    package = create(:cran_package, parsed_at: Time.now)

    expect(described_class.perform_now(package)).to eq(true)
  end

  it "fetches A3 correctly" do
    package = create(:cran_package, name: "A3", version: "1.0.0")

    VCR.use_cassette("cran_package/a3") do
      package = described_class.perform_now(package)

      expect(package.name).to eq("A3")
      expect(package.version).to eq("1.0.0")
      expect(package.title).to eq("Accurate, Adaptable, and Accessible Error Metrics for Predictive Models")
      expect(package.description).to eq("Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.")
      expect(package.parsed_at).to be <= (Time.now)

      expect(package.authors.count).to eq(1)
      expect(package.maintainers.count).to eq(1)
      expect(package.authors.first.name).to eq("SCOTT FORTMANN-ROE")
      expect(package.maintainers.first.name).to eq("SCOTT FORTMANN-ROE")
      expect(package.maintainers.first.email).to eq("scottfr@berkeley.edu")
    end
  end

  # TODO: Cover a lot more tests and iterate through until I'm more confident in the correctness
end
