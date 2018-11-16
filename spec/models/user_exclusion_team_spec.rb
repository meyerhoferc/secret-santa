require 'rails_helper'

describe UserExclusionTeam do
  context 'associations' do
    it 'belongs to users' do
      association = UserExclusionTeam.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to exclusion_teams' do
      association = UserExclusionTeam.reflect_on_association(:exclusion_team)
      expect(association.macro).to eq :belongs_to
    end

    xcontext 'validates' do
      let(:user) { User.create!(first_name: 'Aa', last_name: 'Zzz', username: 'estalh', email: 'emmail@raa.zzz', password: 'pa1203489y132809hsasdfspas1203489y132809hs') }
      let(:group) { Group.create!(name: 'My group creation!', description: 'Whoever wants to join it', gift_due_date: '2018/12/31', owner_id: user.id) }
      subject { UserGroup.create!(user_id: user.id, group_id: group.id) }
      context 'uniqueness of user within groups' do
        it { should validate_uniqueness_of(:user_id).scoped_to(:group_id).with_message('already belongs to this group.') }
      end
    end
  end
end
