# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
    return unless user.present? 
      can :edit, User, id: user.id            #editare il proprio profilo
      can :edit, Comment, user_id: user.id    #editare i propri commenti
    if user.has_role? :admin
      can :create, Article                    #pubblicare articoli
      can :update, Proposal                   #aggiornare le proposte
      can :delete, Comment                    #cancellare tutti i commenti
      can :delete, Article, ext_id: nil       #cancellare gli articoli interni
      can :read, Proposal, status: 0           #visualizzare tutte le proposte in attesa
    elsif user.has_role? :user
      can :create, Proposal                   #creare proposte
      can :read, Proposal, user_id: user.id   #leggere le modifiche alle proprie proposte
      can :delete, Proposal, user_id: user.id #eliminare le proprie proposte
          
      can :delete, Comment, user_id: user.id  #cancellare i propri commenti
    end

  end
end
