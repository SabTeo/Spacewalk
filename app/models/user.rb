class User < ApplicationRecord
  rolify
  has_many :comments
  has_many :articles
  has_many :proposals
  validates :username, uniqueness: true
  validate :username_length
  validate :password_complexity

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :confirmable,
        :omniauthable, :omniauth_providers => [:google_oauth2]
  after_create :add_default_role
  after_create :add_default_image

  has_one_attached :image

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
    end
  end

  def add_default_role
    User.connection
    self.add_role('user')
  end

  def add_default_image
    unless image.attached?
      image.attach(io:File.open(Rails.root.join('app','assets','images','astronave.jpeg')),
                    filename:'astronave.jpeg',
                    content_type:'image/jpeg')
    end
  end

  def password_complexity
    if provider.present? then return end
    
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W)./)
      errors.add :password, "la password deve contenere almeno una lettera maiuscola, una minuscola, un numero e un carattere speciale."
    end
  end

  def username_length
    if username.length<4
      errors.add :username, "l'username deve contenere almeno 4 caratteri"
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)

    if (recoverable.persisted? && !recoverable.confirmed?)
     recoverable.errors.add(:email, I18n.t('devise.failure.not_verified'))
    else
      recoverable.send_reset_password_instructions
    end

    recoverable
  end

end
