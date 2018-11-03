require 'rails_helper'

describe Item do
  let(:owner) { User.create(first_name: 'Henry', last_name: 'Pgg', username: 'hpgg', password: '10893420yoiudfs', password_confirmation: '10893420yoiudfs') }
  let(:group) { Group.create(name: 'Testing!', description: 'Wow', owner_id: owner.id, gift_due_date: '2018-12-13') }
  let(:list) { List.create(group_id: group.id, user_id: owner.id) }
  context 'validations' do
    it 'validates name needs to be present' do
      i = Item.new(name: nil, description: 'my lovely gift', size: 'Large', note: 'Apples', list_id: list.id)
      expect(i.valid?).to eq false
    end

    it 'validates description needs to be present' do
      i = Item.new(name: 'Purse', description: nil, size: 'Large', note: 'Apples', list_id: list.id)
      expect(i.valid?).to eq false
    end

    it 'validates size is optional' do
      i = Item.new(name: 'Purse', description: 'my lovely gift', size: '', note: 'Apples', list_id: list.id)
      expect(i.valid?).to eq true
    end

    it 'validates note is optional' do
      i = Item.new(name: 'Purse', description: 'my lovely gift', size: 'Window', note: '', list_id: list.id)
      expect(i.valid?).to eq true
    end
  end

  context 'associations' do
    it 'has one list' do
      assc = Item.reflect_on_association(:list)
      expect(assc.macro).to eq :belongs_to
    end
  end
end