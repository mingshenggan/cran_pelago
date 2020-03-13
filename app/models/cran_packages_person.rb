class CranPackagesPerson < ApplicationRecord
  belongs_to :cran_package
  belongs_to :person
  enum relationship: {
    author: "author",
    maintainer: "maintainer",
  }
end
