class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :lists
  has_many :invitations
  has_many :invitations_received, foreign_key: :receiver_id, class_name: 'Invitation'
  has_many :invitations_sent, foreign_key: :sender_id, class_name: 'Invitation'
  has_many :user_exclusion_teams
  has_many :exclusion_teams, through: :user_exclusion_teams
  has_many :secret_santa, foreign_key: :santa_id, class_name: 'SantaAssignment'
  has_many :santa_recipient, foreign_key: :receiver_id, class_name: 'SantaAssignment'
  has_many :owned_groups, foreign_key: :owner_id, class_name: 'Group'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_format_of :first_name, with: /\A[a-z([-'])]+\z/i, message: 'must contain only letters, apostrophes or dashes'
  validates_format_of :last_name, with: /\A[a-z([-'])]+\z/i, message: 'must contain only letters, apostrophes or dashes'
  validates :username, presence: true
  validates_uniqueness_of :username
  validates :email, presence: true, on: :update, if: Proc.new { |user| user.email.blank? }
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, unless: Proc.new { |user| user.email.blank? }
  validates_format_of :username, with: /\A\w{1,}\z/i, message: 'must contain only letters, numbers or underscores'
  validates_uniqueness_of :email, allow_blank: true, case_sensitive: false
  has_secure_password
  validates :password, password_strength: { use_dictionary: true, min_entropy: 15 }, if: :should_validate_password?

  def full_name
    "#{first_name} #{last_name}"
  end

  def should_validate_password?
    new_record? || !skip_pass_strength
  end

  def skip_pass_strength
    @skip_pass_strength
  end

  def skip_pass_strength=(value)
    @skip_pass_strength = value
  end

  def outstanding_invitations
    Invitation.joins(:group).where('receiver_id = ? AND accepted IS NULL', id).order('gift_due_date asc')
  end

  def invitable_groups(current_user)
    owned_groups_excludes_user = current_user.owned_groups
      .where('santas_assigned IS false')
      .joins(:users)
      .where.not("users.id = #{id}").distinct
    user_invited_groups = Group.joins(:invitations)
      .where("receiver_id = #{id}")
      .where('accepted IS true OR accepted IS NULL')
      .where("group_id = groups.id")
    owned_groups_excludes_user - user_invited_groups
  end
end
