# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence( :name ) { |n| "Organization #{n}" }
    description "Example Description"

    ignore do
      user { FactoryGirl.create( :user ) }
      roles ['Administrator']
    end

    after( :create ) do |organization, evaluator|
      organization.organization_users = FactoryGirl.build_list( :organization_user, 1, user: evaluator.user, roles: evaluator.roles )
      organization.save!
    end

    after( :build ) do |organization, evaluator|
      organization.organization_users = FactoryGirl.build_list( :organization_user, 1, user: evaluator.user, roles: evaluator.roles )
    end
  end
end
