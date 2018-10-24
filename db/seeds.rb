# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do
  first_name = Faker::LordOfTheRings.character
  last_name = Faker::Name.last_name
  user = User.create!(first_name: first_name,
               last_name: last_name,
               email: "#{first_name}@#{last_name}.com",
               password: 'pass',
               password_confirmation: 'pass')

  group = Group.create!(name: Faker::MostInterestingManInTheWorld.unique.quote,
                description: Faker::GameOfThrones.quote,
                owner_id: user.id,
                gift_due_date: "#{Faker::Number.between(2018, 2020)}/#{Faker::Number.between(1, 12)}/#{Faker::Number.between(1, 28)}")

  group.user_ids << user.id
  user.groups << group

  list = List.create!(user_id: user.id, group_id: group.id)
  5.times do
    item = Item.create!(name: Faker::Fallout.character,
                      description: Faker::FamousLastWords.last_words,
                      note: Faker::Myst.quote,
                      size: Faker::Measurement.weight,
                      lists_id: list.id)
  end
end
