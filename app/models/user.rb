class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  USER_PARAMS = %i(name email phone_number address password
    password_confirmation).freeze

  attr_accessor :remember_token

  has_many :posts, dependent: :destroy
  has_many :favorite_lists, dependent: :destroy
  has_many :comments, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  private

  def downcase_email
    email.downcase!
  end
end
