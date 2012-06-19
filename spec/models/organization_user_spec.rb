require 'spec_helper'

describe OrganizationUser do
  describe 'validations' do
    before :each do
      @organization_user = FactoryGirl.build( :organization_user )
    end

    it 'is valid with valid attributes' do
      @organization_user.should be_valid
    end

    it 'should not be valid with missing user' do
      @organization_user.user = nil
      @organization_user.should_not be_valid
    end
  end
end
