require 'rails_helper'

describe SantaAssignment do
  context 'associations' do
    it 'belongs to santa' do
      assc = SantaAssignment.reflect_on_association(:santa)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to recipient' do
      assc = SantaAssignment.reflect_on_association(:recipient)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to group' do
      assc = SantaAssignment.reflect_on_association(:group)
      expect(assc.macro).to eq :belongs_to
    end
  end
end
