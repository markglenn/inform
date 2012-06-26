# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence( :name ) { |n| "Organization #{n}" }
    description "MyText"
    
    factory :organization_with_user do
      ignore do
        user
      end

      after( :create ) do |organization, evaluator|
        #FactoryGirl.create_list( :user_organization, 1, user: evaluator.user )
      end
    end
  end

end
