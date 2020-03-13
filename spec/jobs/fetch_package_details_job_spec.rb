describe FetchPackageDetailsJob, type: :job do
  it "fetches A3 correctly" do
    package = create(:cran_package, name: "A3", version: "1.0.0")

    VCR.use_cassette("cran_package/a3") do
      package = described_class.perform_now(package)

      expect(package.name).to eq("A3")
      expect(package.version).to eq("1.0.0")
      expect(package.title).to eq("Accurate, Adaptable, and Accessible Error Metrics for Predictive Models")
      expect(package.description).to eq("Supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.")
      expect(package.parsed_at).to be <= (Time.now)
    end
  end
end
