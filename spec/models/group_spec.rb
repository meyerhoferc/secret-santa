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

    it 'validates dollar_limit is greater than 0.00' do
      g = Group.new(name: 'This one Group', description: 'Here is a description', owner_id: 3, gift_due_date: '', dollar_limit: 0.00)
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

    it 'belongs to owner' do
      assc = Group.reflect_on_association(:owner)
      expect(assc.macro).to eq :belongs_to
    end

    it 'has many santa_assignments' do
      assc = Group.reflect_on_association(:santa_assignments)
      expect(assc.macro).to eq :has_many
    end

    it 'has many exclusion teams' do
      assc = Group.reflect_on_association(:exclusion_teams)
      expect(assc.macro).to eq :has_many
    end
  end
end

describe Group, type: :model do
  it { should have_many(:user_groups) }
  it { should have_many(:users).through(:user_groups) }
  it { should have_many(:lists) }
  it { should have_many(:invitations) }
  it { should have_many(:exclusion_teams) }
  it { should have_many(:santa_assignments) }
  it { should have_many(:comments) }
  it { should belong_to(:owner).with_foreign_key(:owner_id).class_name('User') }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:owner_id) }
  it { should validate_presence_of(:gift_due_date) }
  it { should validate_numericality_of(:dollar_limit).allow_nil }


  describe 'uniqueness' do
    let(:user) { User.create!(first_name: 'Larry', last_name: 'Lar', username: 'llar', password: 'pioqrey89s9ahf', password_confirmation: 'pioqrey89s9ahf') }
    subject { Group.create(name: 'Larry', gift_due_date: '2020-02-02', owner_id: user.id, description: 'pioqrey89s9ahf') }
    it { should validate_uniqueness_of(:name).with_message('is already in use.') }
  end
end
