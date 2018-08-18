require 'rails_helper'

describe User do
  it 'has a secure password' do
    # this test is for K's benefit to see an example and some of the basics of what comes with bcrypt + has_secure_password
    u = User.create!(first_name: 'Raz', last_name: 'Z', email: '123@mail.com', password: 'password123')
    expect(u.authenticate('notthepassword')).to be_falsey
    expect(u.authenticate('password123')).to eq u
  end

  describe 'validations' do
    it 'validates email is present' do
      u = User.new(first_name: 'Raz', last_name: 'Z', email: '', password: 'passpass')
      expect(u.valid?).to eq false
    end

    it 'validates first name is present' do
      u = User.new(first_name: nil, last_name: 'Z', email: 'email@email.email', password: 'passpass')
      expect(u.valid?).to be_falsey
    end

    it 'validates last name is present' do
      u = User.new(first_name: 'Razz', last_name: nil, email: 'email@email.email', password: 'passpass')
      expect(u.valid?).to be_falsey
    end

    it 'validates email is unique' do
      User.create(first_name: 'Raz', last_name: 'Z', email: 'email@email.email', password: 'passpass')
      v = User.new(first_name: 'Raz', last_name: 'Z', email: 'email@email.email', password: 'passpass')
      expect(v.valid?).to eq false
    end
  end
end
