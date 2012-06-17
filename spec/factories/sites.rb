# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    sequence( :title ){|n| "Site Title #{n}" }
    latitude 0
    longitude 0
    
    description "Lorem ipsum dolor."
  end
end
