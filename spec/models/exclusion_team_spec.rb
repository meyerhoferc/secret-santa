require 'rails_helper'

describe ExclusionTeam do
  context 'associations' do
    it 'has many users' do
      association = ExclusionTeam.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
    end

    it 'has many user_exclusion_teams' do
      association = ExclusionTeam.reflect_on_association(:user_exclusion_teams)
      expect(association.macro).to eq :has_many
    end
    it 'belongs to group' do
      association = ExclusionTeam.reflect_on_association(:group)
      expect(association.macro).to eq :belongs_to
    end
  end
end
