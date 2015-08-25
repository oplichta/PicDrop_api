# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if !User.any?
  User.create(email: 'user@test.com', password: 'password')
  User.create(email: 'user1@test.com', password: 'password1')
  User.create(email: 'user2@test.com', password: 'password2')
  User.create(email: 'user3@test.com', password: 'password3')
  User.create(email: 'user4@test.com', password: 'password4')
  User.create(email: 'user5@test.com', password: 'password5')
end
