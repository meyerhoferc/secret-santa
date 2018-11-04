class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :lists
  has_many :invitations

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates_uniqueness_of :username
  validates :email, presence: true, on: :update, if: Proc.new { |user| user.email.blank? }
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, unless: Proc.new { |user| user.email.blank? }
  validates_format_of :username, with: /\A\w{1,}\z/i, message: 'must contain only letters, numbers or underscores'
  validates_uniqueness_of :email, allow_blank: true, case_sensitive: false
  has_secure_password
  validates :password, password_strength: { use_dictionary: true, min_entropy: 20 }, if: :should_validate_password?

  def should_validate_password?
    new_record? || !skip_pass_strength
  end

  def skip_pass_strength
    @skip_pass_strength
  end

  def skip_pass_strength=(value)
    @skip_pass_strength = value
  end
end
