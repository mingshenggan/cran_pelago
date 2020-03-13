describe CranPackage, type: :model do
  it "can have many authors" do
    authors = create_list(:person, 3)
    package = create(:cran_package)

    expect do
      package.authors << authors
    end.to change { package.reload.authors.count }.from(0).to(3)
  end

  it "can have many maintainers" do
    people = create_list(:person, 3)
    package = create(:cran_package)

    expect do
      package.maintainers << people
    end.to change { package.reload.maintainers.count }.from(0).to(3)
  end

  it "can share the same maintainers and authors" do
    maintainer_and_author = create(:person)
    extra_author = create(:person)
    package = create(:cran_package)

    package.maintainers << maintainer_and_author
    package.authors << maintainer_and_author
    package.authors << extra_author

    expect(package.maintainers).to include(maintainer_and_author)
    expect(package.authors).to include(maintainer_and_author)
    expect(package.authors).to include(extra_author)
    expect(package.maintainers).not_to include(extra_author)
  end
end
