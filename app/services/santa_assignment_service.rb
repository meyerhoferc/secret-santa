class SantaAssignmentService
  attr_reader :validity, :errors

  def initialize(group)
    @errors = []
    @group = group
  end

  def assign
    if exclusion_teams_validity
      self.validity = true
      santa_assignments! # Move to ActiveJob in future
    else
      self.validity = false
    end
    self
  end

  private

  def santa_assignments!
    
  end

  def validity=(value)
    @validity = value
  end

  def errors=(error)
    @errors.push(error)
  end

  def exclusion_teams_validity
    group_exclusion_team_counts
  end

  def group_exclusion_team_counts
    teams_total_users = @group.user_exclusion_team_count
    no_exclusion_team_users_count = @group.no_exclusion_team_users.count
    @group.exclusion_teams&.map do |team|
      team_users = team.users.count
      calc = team_users <= teams_total_users - team_users + no_exclusion_team_users_count
      self.errors = "\"#{team.name}\" has too many users" unless calc
      calc
    end.all?
  end

  def team_user_counts
    @group.exclusion_teams&.map { |team| team.users.count }
  end
end
