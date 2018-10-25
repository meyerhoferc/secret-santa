require 'rails_helper'

describe Item do
  context 'validations' do
    it 'validates name needs to be present' do
      i = Item.new(name: nil, description: 'my lovely gift', size: 'Large', note: 'Apples')
      expect(i.valid?).to eq false
    end

    it 'validates description needs to be present' do
      i = Item.new(name: 'Purse', description: nil, size: 'Large', note: 'Apples')
      expect(i.valid?).to eq false
    end

    it 'validates size is optional' do
      i = Item.new(name: 'Purse', description: 'my lovely gift', size: '', note: 'Apples')
      expect(i.valid?).to eq true
    end

    it 'validates note is optional' do
      i = Item.new(name: 'Purse', description: 'my lovely gift', size: 'Window', note: '')
      expect(i.valid?).to eq true
    end
  end

  context 'associations' do
    it 'has one list' do
      assc = Item.reflect_on_association(:list)
      expect(assc.macro).to eq :has_one
    end
  end
end
