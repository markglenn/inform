# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence( :name ) { |n| "Organization #{n}" }
    description "MyText"
    
    factory :organization_with_user do
      ignore do
        user { FactoryGirl.create( :user ) }
        roles []
      end

      after( :create ) do |organization, evaluator|
        organization.organization_users = [FactoryGirl.build( :organization_user, user: evaluator.user, roles: evaluator.roles )]
        organization.save!
      end
    end
  end

end
