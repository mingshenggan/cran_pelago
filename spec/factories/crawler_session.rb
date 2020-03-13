FactoryBot.define do
  factory :crawler_session do
    # TODO: Randomize / use ffaker
    url { "http://cran.r-project.org/src/contrib/" }
  end
end
