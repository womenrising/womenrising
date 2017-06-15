# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Fabricator(:location) do
  city { Faker::Address.city }
  state { Faker::Address.state_abbr }
end

Fabricator(:user) do
  email { Faker::Internet.email}
  password {"testtingstuff"}
  password_confirmation {|attrs| attrs[:password]}
  first_name { Faker::Name.first_name}
  last_name {Faker::Name.last_name}
  mentor {%w(true false).sample}
  primary_industry {["Business", "Technology", "Startup","Other"].sample}
  stage_of_career {%w(1 2 3 4 5).sample}
  mentor_industry {["Business", "Technology", "Startup"].sample}
  peer_industry {["Business", "Technology", "Startup"].sample}
  current_goal {["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample}
  top_3_interests {["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watch    ing Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3)}
  is_participating_this_month {%w(true false).sample}
  location_id { rand(Location.count) }
end

10.times { Fabricate(:location) }
150.times { Fabricate(:user) }


AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
