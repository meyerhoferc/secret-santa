users = []
groups = []

def receiver_is_sender?(receiver, sender)
  receiver == sender
end

10.times do
  first_name = Faker::ElderScrolls.unique.first_name
  last_name = Faker::Name.unique.last_name
  email = "#{first_name.downcase}@#{last_name.downcase}.com".gsub(' ', '')
  username = "#{last_name.downcase}#{first_name.downcase}".gsub(/\W/i, '')

  user = User.create!(first_name: first_name,
               last_name: last_name,
               email: email,
               username: username,
               password: 'asdf;lkjpoiuqwer',
               password_confirmation: 'asdf;lkjpoiuqwer')

  group = Group.create!(name: Faker::MostInterestingManInTheWorld.unique.quote,
                description: Faker::GameOfThrones.quote,
                owner_id: user.id,
                gift_due_date: "#{Faker::Number.between(2018, 2022)}/#{Faker::Number.between(1, 12)}/#{Faker::Number.between(1, 28)}")

  group.user_ids << user.id
  user.groups << group

  users.push(user)
  groups.push(group)

  list = List.create!(user_id: user.id, group_id: group.id)
  5.times do
    item = Item.create!(name: Faker::LeagueOfLegends.masteries,
                      description: Faker::FamousLastWords.last_words,
                      note: Faker::Myst.quote,
                      size: Faker::Measurement.weight,
                      list_id: list.id)
  end
end

10.times do
  comment = Faker::WorldOfWarcraft.quote
  receiver = users.sample
  sender = users.sample
  while receiver_is_sender?(receiver, sender) do
    receiver = users.sample
    sender = users.sample
  end

  invitation = Invitation.create!(group_id: groups.sample.id,
    receiver_id: receiver.id,
    sender_id: sender.id,
    comment: comment
  )
end
