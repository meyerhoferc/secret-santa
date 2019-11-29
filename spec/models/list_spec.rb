require 'rails_helper'

describe List do
  context 'validations' do
    it 'validates user_id needs to be present' do
      l = List.new(user_id: nil, group_id: 4)
      expect(l.valid?).to eq false
    end

    it 'validates group_id needs to be present' do
      l = List.new(user_id: 4, group_id: nil)
      expect(l.valid?).to eq false
    end
  end

  context 'associations' do
    it 'belongs to user' do
      assc = List.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to group' do
      assc = List.reflect_on_association(:group)
      expect(assc.macro).to eq :belongs_to
    end
  end
end

describe List, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:group) }
  it { should have_many(:comments) }
  it { should have_many(:items) }
end
