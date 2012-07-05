class Ability
  include CanCan::Ability

  def initialize(user)

    if user
      # Organizations
      can [:read], Organization, Organization.for_user( user ) do |organization|
        organization.roles_for_user( user ) != nil
      end

      can [:update, :destroy], Organization, Organization.for_user( user ) do |organization|
        ( organization.roles_for_user( user ) || [] ).include? 'Administrator'
      end

      can :create, Organization do
        !user.new_record?
      end

      # Sites
      can [:create, :update, :destroy], Site do |site|
        !user.new_record?
      end
    end

    can [:read], Site

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
