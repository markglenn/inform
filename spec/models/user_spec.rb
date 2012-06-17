require 'spec_helper'

describe User do
  describe 'admin?' do
    it 'should return true if has admin role' do
      u = FactoryGirl.create( :user, roles: [ 'admin' ] )
      u.should be_admin
    end

    it 'should not be true if no role admin' do
      u = FactoryGirl.create( :user, roles: [ ] )
      u.should_not be_admin
    end

    it 'should not be true if nil role' do
      u = FactoryGirl.create( :user )
      u.should_not be_admin
    end
  end
end
