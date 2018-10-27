require 'rails_helper'

describe User do
  context 'password is' do
    let(:user) { User.create(first_name: 'Raz', last_name: 'Z', username: 'zraZ', email: '123@mail.com', password: 'passw1203489y132809hord123') }
    it 'secure' do
      expect(user.authenticate('notthepassword')).to be_falsey
      expect(user.authenticate(user.password)).to eq user
    end

    it 'strong' do
      u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: 'pa1203489y1328sdfadsf09hsspa1a203489y132809hss')
      expect(u.valid?).to eq true
      expect(u.save).to eq true
    end

    it 'weak' do
      u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: 'pa12aa')
      expect(u.valid?).to eq false
      expect(u.save).to eq false
    end

    context 'common password:' do
      it 'qwerty' do
        u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: 'qwerty')
        expect(u.valid?).to eq false
        expect(u.save).to eq false
      end

      it 'password' do
      u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: 'password')
      expect(u.valid?).to eq false
      expect(u.save).to eq false
      end

      it 'qwertyuiop' do
      u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: 'qwertyuiop')
      expect(u.valid?).to eq false
      expect(u.save).to eq false
      end

      it '1234567890' do
      u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: '1234567890')
      expect(u.valid?).to eq false
      expect(u.save).to eq false
      end

      it 'pass' do
        u = User.new(first_name: 'Any', last_name: 'Y', username: 'YAny', email: 'eamail@email.email', password: 'pass')
        expect(u.valid?).to eq false
        expect(u.save).to eq false
      end
    end

  end

  context 'validations' do
    it 'validates first name needs to be present' do
      u = User.new(first_name: nil, last_name: 'Z', username: 'YAny', email: 'email@email.email', password: 'pa1203489y132809hsspa1203489y132809hss')
      expect(u.valid?).to be false
      expect(u.save).to eq false
    end

    it 'validates last name needs to be present' do
      u = User.new(first_name: 'Razz', last_name: nil, username: 'YAny', email: 'email@email.email', password: 'pa1203489y132809hsspa1203489y132809hss')
      expect(u.valid?).to be false
      expect(u.save).to eq false
    end

    it 'validates email needs to be present' do
      u = User.new(first_name: 'Raz', last_name: 'Z', username: 'YAny', email: '', password: 'pa1203489y132809hsspa1203489y132809hss')
      expect(u.valid?).to eq false
      expect(u.save).to eq false
    end

    it 'validates email is unique' do
      User.create(first_name: 'Raz', last_name: 'Z', username: 'YANNy', email: 'email@email.email', password: 'pa1203489y132809hsspa1203489y132809hss')
      u = User.new(first_name: 'Raz', last_name: 'Z', username: 'YAny', email: 'email@email.email', password: 'pa1203489y132809hsspa1203489y132809hss')
      expect(u.valid?).to eq false
      expect(u.save).to eq false
    end

    it 'validates username is unique' do
      User.create(first_name: 'Raz', last_name: 'Z', username: 'YANNy', email: 'emadsfail@email.email', password: 'pa1203489y132809hsspa1203489y132809hss')
      u = User.new(first_name: 'Raz', last_name: 'Z', username: 'YANNy', email: 'email@email.email', password: 'pa1203489y132809hsspa1203489y132809hss')
      expect(u.valid?).to eq false
    end
  end

  context 'associations' do
    it 'has many lists' do
      assc = User.reflect_on_association(:lists)
      expect(assc.macro).to eq :has_many
    end

    it 'has many groups' do
      assc = User.reflect_on_association(:groups)
      expect(assc.macro).to eq :has_many
    end

    it 'has many invitations' do
      assc = User.reflect_on_association(:invitations)
      expect(assc.macro).to eq :has_many
    end

    it 'has many user_groups' do
      assc = User.reflect_on_association(:user_groups)
      expect(assc.macro).to eq :has_many
    end
  end
end
