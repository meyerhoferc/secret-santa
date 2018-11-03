class User < ApplicationRecord
  include ActiveModel::Validations
  include ActiveModel::Dirty
  attr_accessor :skip_pass_strength

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
  validates :password, password_strength: { use_dictionary: true, min_entropy: 20 }, unless: :skip_pass_strength
                                    # if: Proc.new { |u| !u.password.blank? },
                                    # on: :update do |model, attribute, value|
                                    #   byebug
                                    # end

  # def skip_pass_strength
  #   @skip_pass_strength
  # end
  #
  # def skip_pass_strength=(value)
  #   @skip_pass_strength = (value)
  # end
  # def should_validate_password?
  #   byebug
  #   skip_pass_strength || new_record?
  # end
end
