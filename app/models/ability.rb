class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user.present?
      user.permissions.each do |permission|
        if permission[:can]
          can permission[:action], permission[:entities].camelize.constantize
        else
          cannot permission[:action], permission[:entities].camelize.constantize
        end
      end
      can :update, User, id: user.id
    end
  end
end
