require 'rails_helper'

describe Group do
  context 'validations' do
    it 'validates description needs to be present' do
      g = Group.new(name: 'This one Group', description: '', owner_id: 3, gift_due_date: '2018/12/31')
      expect(g.valid?).to eq false
    end

    it 'validates owner_id needs to be present' do
      g = Group.new(name: 'This one Group', description: 'Here is a description', owner_id: nil, gift_due_date: '2018/12/31')
      expect(g.valid?).to eq false
    end

    it 'validates gift_due_date needs to be present' do
      g = Group.new(name: 'This one Group', description: 'Here is a description', owner_id: 3, gift_due_date: '')
      expect(g.valid?).to eq false
    end

    it 'validates name is unique' do
      Group.create(name: 'This one Group', description: 'Here is a description', owner_id: 3, gift_due_date: '2018/12/31')
      g = Group.new(name: 'This one Group', description: 'Here is a description', owner_id: 3, gift_due_date: '2018/12/31')
      expect(g.valid?).to eq false
    end
  end

  context 'associations' do
    it 'has many lists' do
      assc = Group.reflect_on_association(:lists)
      expect(assc.macro).to eq :has_many
    end

    it 'has many user_groups' do
      assc = Group.reflect_on_association(:user_groups)
      expect(assc.macro).to eq :has_many
    end

    it 'has many users' do
      assc = Group.reflect_on_association(:users)
      expect(assc.macro).to eq :has_many
    end

    it 'has many invitations' do
      assc = Group.reflect_on_association(:invitations)
      expect(assc.macro).to eq :has_many
    end

    it 'belongs to user' do
      assc = Group.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
  end
end
