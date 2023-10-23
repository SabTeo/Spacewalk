class User < ApplicationRecord
  rolify
  has_many :comments
  has_many :articles
  has_many :proposals
  has_many :notifications
  validates :username, uniqueness: true
  validate :username_length
  validate :profile_picture_valid
  validate :password_complexity
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :confirmable,
        :omniauthable, :omniauth_providers => [:google_oauth2]
  after_create :add_default_role, unless: :test_user
  after_create :add_default_image, unless: :test_user

  has_one_attached :image

  attr_accessor :test_user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      oauth_name =  auth.info.name
      if  User.where(username: oauth_name).exists? 
        user.username = oauth_name + Random.rand(1111...9999).to_s
      else
        user.username = oauth_name
      end
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

  def profile_picture_valid
    if image.present?
      if image.blob.byte_size > 2000000 #2Mbyte
        errors.add :image, "l'immagine supera la dimensione massima consentita"
        image.delete
      elsif !image.blob.image?
        errors.add :image, "l'immagine è in un formato non supportato"
        image.delete
      end
    end
  end

  def username_length
    if !provider.present?
      if username.strip.length<4 or username.strip.length>30
        errors.add :username, "l'username deve contenere tra 4 e 30 caratteri"
      end
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
