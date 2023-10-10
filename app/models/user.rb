class User < ApplicationRecord
  rolify
  has_many :comments
  validates :username, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  after_create :add_default_role
  
  def add_default_role
    User.connection
    self.add_role('user')
  end
end
