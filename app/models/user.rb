class User < ApplicationRecord
  rolify
  has_many :comments
  has_many :articles
  validates :username, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :omniauthable, :omniauth_providers => [:google_oauth2]
  after_create :add_default_role

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
    end
  end
    
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_data"] && session["devise.google_data"]
        ["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  
  def add_default_role
    User.connection
    self.add_role('user')
  end
end
