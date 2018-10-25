require 'rails_helper'

describe UserGroup do
  context 'associations' do
    it 'belongs to user' do
      assc = UserGroup.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end

    it 'belongs to group' do
      assc = UserGroup.reflect_on_association(:group)
      expect(assc.macro).to eq :belongs_to
    end
  end
end
