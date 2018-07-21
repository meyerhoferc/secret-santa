require 'rails_helper'

describe User do
  it 'has a secure password' do
    # this test is for K's benefit to see an example and some of the basics of what comes with bcrypt + has_secure_password
    u = User.create!(first_name: 'Raz', last_name: 'Z', email: '123@mail.com', password: 'password123')
    expect(u.authenticate('notthepassword')).to be_falsey
    expect(u.authenticate('password123')).to eq u
  end
end
