# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# UserName: admin, Password: admin
User.create(
  email: 'admin',
  crypted_password: '$2a$10$DINI1DCYwrrnJ4aPFFZTF.E7eWe8nd1UD1InSxYyRxN23.Xo1dM42',
  salt: 'sHCXQuNdTKxf162uyPmX',
  is_admin: true,
  is_trainer: true,
  created_at: Time::now,
  updated_at: Time::now
)

