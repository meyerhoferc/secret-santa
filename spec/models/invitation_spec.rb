require 'rails_helper'

describe Invitation do
  context 'validations' do
    it 'validates group_id needs to be present' do
      i = Invitation.new(group_id: nil, sender_id: 7, receiver_id: 5, comment: 'Welcome to the group')
      expect(i.valid?).to eq false
    end

    it 'validates sender_id needs to be present' do
      i = Invitation.new(group_id: 3, sender_id: nil, receiver_id: 5, comment: 'Welcome to the group')
      expect(i.valid?).to eq false
    end

    it 'validates recevier_id needs to be present' do
      i = Invitation.new(group_id: 3, sender_id: 7, receiver_id: nil, comment: 'Welcome to the group')
      expect(i.valid?).to eq false
    end

    it 'validates comment needs to be present' do
      i = Invitation.new(group_id: 3, sender_id: 7, receiver_id: 5, comment: nil)
      expect(i.valid?).to eq false
    end
  end

  context 'associations' do
    it 'belongs to receiver' do
      assc = Invitation.reflect_on_association(:receiver)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to receiver' do
      assc = Invitation.reflect_on_association(:sender)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to group' do
      assc = Invitation.reflect_on_association(:group)
      expect(assc.macro).to eq :belongs_to
    end
  end
end
