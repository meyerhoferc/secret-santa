require 'rails_helper'

describe ExclusionTeam do
  let(:user) { User.create!(first_name: 'Aa', last_name: 'Zzz', username: 'estalh', email: 'emmail@raa.zzz', password: 'pa1203489y132809hsasdfspas1203489y132809hs') }
  let(:group) { Group.create!(name: 'My group creation!', description: 'Whoever wants to join it', gift_due_date: '2018/12/31', owner_id: user.id) }
  context 'validations' do
    it 'validates name needs to be present' do
      e = ExclusionTeam.new(name: '', group_id: group.id, matched: false)
      expect(e.valid?).to eq false
    end
  end

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
