class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  USER_PARAMS = %i(name email phone_number address password
    password_confirmation).freeze

  attr_accessor :remember_token

  has_many :posts, dependent: :destroy
  has_many :favorite_lists, dependent: :destroy
  has_many :comments, dependent: :destroy

  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:facebook,
                                                           :google_oauth2]

  enum role: {user: 0, admin: 1}

  validates :name, presence: true, length: {maximum: Settings.user.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.user.email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :address, presence: true, length: {maximum: Settings.user.address}
  validates :phone_number, presence: true, numericality: {only_integer: true},
    length: {maximum: Settings.user.phone_number}
  validates :password, presence: true,
    length: {minimum: Settings.user.password_length}, allow_nil: true
  validates :email_resemble_password, email: true

  before_save :downcase_email
  after_create :assign_default_role

  class << self
    def new_with_session params, session
      super.tap do |user|
        if data = session["devise.facebook_data"] &&
                  session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def from_omniauth auth
      auth_user = User.find_by email: auth.info.email
      return auth_user if auth_user

      omniauth_user auth
    end

    def omniauth_user auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
        user.password_confirmation = user.password
        user.phone_number = Settings.phone
        user.address = Settings.address
        user.confirmed_at = Time.zone.now
      end
    end
  end

  def assign_default_role
    add_role :user if roles.blank?
  end

  private

  def downcase_email
    email.downcase!
  end
end
