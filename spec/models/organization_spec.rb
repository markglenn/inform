require 'spec_helper'

describe Organization do
  describe 'validations' do
    before :each do
      @organization = FactoryGirl.build( :organization )
    end

    it 'should be valid with valid attributes' do
      @organization.should be_valid
    end

    it 'should not be valid with missing name' do
      @organization.name = nil
      @organization.should_not be_valid
    end

    it 'should not be valid with duplicate name' do
      FactoryGirl.create( :organization, name: @organization.name )
      @organization.should_not be_valid
    end

    it 'should be invalid with description length > 3000' do
      @organization.description = 'a' * 3001
      @organization.should_not be_valid
    end
  end
end
