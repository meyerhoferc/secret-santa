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
      # byebug
      assignment_array = inverse_bubble_sort(users)
      # byebug
      if assignment_array.empty?
        self.errors = 'Santa Assignments error.'
        self.validity = false
      else
        self.validity = assignment_array
      end
    else

    end
  end

  def inverse_bubble_sort(array)
    limit = array.length - 1
    iteration_limit = array.length * 50
    failsafe = 0
    while failsafe <= iteration_limit do # 50 iterations over the array
      break if array.size <= 1 # Small array failsafe
      swap_count = 0
      0.upto(limit) do |int|
        if int <= 0 # Beginning of the array
          if invalid_assignment?(array[int], array[int + 1])
            array[int], array[int + 1] = array[int + 1], array[int]
            swap_count += 1
          end
        elsif int >= limit # End of the array
          if invalid_assignment?(array[int - int], array[int]) || invalid_assignment?(array[int - 1], array[int]) # Loop back to beginning of array
            array[int], array[int - int] = array[int - int], array[int]
            swap_count += 1
          end
        elsif int >= 1 && int <= limit - 1 # Middle of array
          if invalid_assignment?(array[int], array[int + 1]) || invalid_assignment?(array[int - 1], array[int]) # Users before and after int
            array[int], array[int + 1] = array[int + 1], array[int]
            swap_count += 1
          end
        end
        failsafe += 1
      end

      break if swap_count == 0 # If no swaps have occurred in one iteration
      array = [] if failsafe + 1 >= iteration_limit
    end
    array
  end

  def invalid_assignment?(user_one, user_two)
    teams = User.find(user_one).exclusion_teams.find_by(group_id: @group.id)
    if !teams.nil?
      teams
        .users
        .include?(User.find(user_two))
    else
      false
    end
  end

  def sorted_users
    user_id_array = []
    sorted_teams = @group.exclusion_teams
      .sort_by { |team| team.users.count }
      .reverse
      .each { |team| user_id_array.push(team.users.pluck(:user_id)) }
    user_id_array.push(@group.no_exclusion_team_users.pluck(:id))
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
