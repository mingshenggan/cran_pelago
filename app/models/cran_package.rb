class CranPackage < ApplicationRecord
  belongs_to :crawler_session

  has_many :cran_packages_people
  has_many :author_relationships, -> { author }, class_name: "CranPackagesPerson"
  has_many :maintainer_relationships, -> { maintainer }, class_name: "CranPackagesPerson"
  has_many :authors,
    class_name: "Person",
    through: :author_relationships,
    source: :person
  has_many :maintainers,
    class_name: "Person",
    through: :maintainer_relationships,
    source: :person
end
