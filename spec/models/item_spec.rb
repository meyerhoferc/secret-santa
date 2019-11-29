require 'rails_helper'

describe Item do
  context 'validations' do
    let(:owner) { User.create!(first_name: 'Henry', last_name: 'Pgg', username: 'pgghenry', email: 'hpgg@email.org', password: '10893420yoiudfs', password_confirmation: '10893420yoiudfs') }
    let(:group) { Group.create!(name: 'Testing!', description: 'Wow', owner_id: owner.id, gift_due_date: '2018-12-13') }
    let(:list) { List.create!(group_id: group.id, user_id: owner.id) }
    it 'validates name needs to be present' do
      item = Item.new(name: nil, description: 'my lovely gift', size: 'Large', note: 'Apples', list_id: list.id)
      expect(item.valid?).to eq false
    end

    it 'validates description needs to be present' do
      item = Item.new(name: 'Purse', description: nil, size: 'Large', note: 'Apples', list_id: list.id)
      expect(item.valid?).to eq false
    end

    it 'validates size is optional' do
      item = Item.new(name: 'Purse', description: 'my lovely gift', size: '', note: 'Apples', list_id: list.id)
      expect(item.valid?).to eq true
    end

    it 'validates note is optional' do
      item = Item.new(name: 'Purse', description: 'my lovely gift', size: 'Window', note: '', list_id: list.id)
      expect(item.valid?).to eq true
    end
  end

  context 'associations' do
    it 'has one list' do
      assc = Item.reflect_on_association(:list)
      expect(assc.macro).to eq :belongs_to
    end
  end
end

describe Item, type: :model do
  it { should belong_to(:list) }
  it { should have_many(:comments) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
end
