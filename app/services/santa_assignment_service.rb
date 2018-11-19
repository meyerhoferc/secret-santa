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
    users = sorted_users
    if @group.exclusion_teams.any?
      assignment_array = inverse_bubble_sort(users)
    else

    end
    # byebug
  end

  def inverse_bubble_sort(array)
    limit = array.length - 1
    loop do
      break if array.size <= 1
      swap_count = 0
      0.upto(limit - 1) do |int|
        if int == 0 || int == limit - 1 # Ends of the array
          if invalid_assignment?(array[int], array[int + 1])
            array[int], array[int + 1] = array[int + 1], array[int]
            swap_count += 1
          end
        else # Middle of array
          if invalid_assignment?(array[int], array[int + 1]) || invalid_assignment?(array[int - 1], array[int]) # Users before and after int
            array[int], array[int + 1] = array[int + 1], array[int]
            swap_count += 1
          end
        end
      end
      break if swap_count == 0
    end
  end

  def invalid_assignment?(user_one, user_two)
    User.find(user_one)
      .exclusion_teams
      .find_by(group_id: @group.id)
      .users
      .include?(User.find(user_two))
  end

  def sorted_users
    user_id_array = []
    sorted_teams = @group.exclusion_teams
      .sort_by { |team| team.users.count }
      .reverse
      .each { |team| user_id_array.push(team.users.pluck(:user_id)) }
    user_id_array.push(@group.no_exclusion_team_users.pluck(:user_id))
    user_id_array.flatten!
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
