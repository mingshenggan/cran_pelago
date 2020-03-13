describe TokenizePackageDescriptionService do
  let(:input) { "Package: aaSEA\nType: Package\nTitle: Amino Acid Substitution Effect Analyser\nVersion: 1.1.0\nAuthor: Raja Sekhara Reddy D.M\nMaintainer: Raja Sekhara Reddy D.M <raja.duvvuru@gmail.com>\nDescription: Given a protein multiple sequence alignment, it is daunting task to assess the effects of substitutions along sequence length. 'aaSEA' package is intended to help researchers to rapidly analyse property changes caused by single, multiple and correlated amino acid substitutions in proteins. Methods for identification of co-evolving positions from multiple sequence alignment are as described in :  Pel\xC3\xA9 et al., (2017) <doi:10.4172/2379-1764.1000250>.\nDepends: R(>= 3.4.0)\nImports: DT(>= 0.4), networkD3(>= 0.4), shiny(>= 1.0.5),\n        shinydashboard(>= 0.7.0), magrittr(>= 1.5), Bios2cor(>= 2.0),\n        seqinr(>= 3.4-5), plotly(>= 4.7.1), Hmisc(>= 4.1-1)\nLicense: GPL-3\nEncoding: UTF-8\nLazyData: true\nRoxygenNote: 6.1.1\nSuggests: knitr, rmarkdown\nVignetteBuilder: knitr\nNeedsCompilation: no\nPackaged: 2019-11-09 15:35:46 UTC; sai\nRepository: CRAN\nDate/Publication: 2019-11-09 16:20:02 UTC\n" }

  it "captures Date/Publication" do
    res = described_class.call(input)
    expect(res[:published_at]).to eq("2019-11-09 16:20:02 UTC")
  end

  it "captures title" do
    res = described_class.call(input)
    expect(res[:title]).to eq("Amino Acid Substitution Effect Analyser")
  end

  it "captures description" do
    res = described_class.call(input)
    expect(res[:description]).to eq("Given a protein multiple sequence alignment, it is daunting task to assess the effects of substitutions along sequence length. 'aaSEA' package is intended to help researchers to rapidly analyse property changes caused by single, multiple and correlated amino acid substitutions in proteins. Methods for identification of co-evolving positions from multiple sequence alignment are as described in :  Pel\xC3\xA9 et al., (2017) <doi:10.4172/2379-1764.1000250>.")
  end

  it "captures Maintainer" do
    res = described_class.call(input)
    expect(res[:maintainer]).to eq([
      "Raja Sekhara Reddy D.M",
      "raja.duvvuru@gmail.com",
    ])
  end

  it "captures Author" do
    res = described_class.call(input)
    expect(res[:authors]).to eq(["Raja Sekhara Reddy D.M"])
  end

  context "split_and_remerge" do
    it "handles multi-line descriptions" do
      given_value = "Description: aaSEA is wonderful\n      and nice\nAnother/Label: Here"
      result = described_class.send(:split_and_remerge, given_value)
      expect(result).to eq({
        "Description" => "aaSEA is wonderful and nice",
        "Another/Label" => "Here",
      })
    end
  end
end
