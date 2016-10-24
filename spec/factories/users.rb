require 'faker'

FactoryGirl.define do
  sequence(:email) {|x| "email-#{x}@example.com"}

  factory :user do
    email { generate(:email) }
    password {"testtingstuff"}
    password_confirmation {|attrs| attrs[:password]}
    first_name { Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    mentor {%w(true false).sample}
    primary_industry {["Business", "Technology", "Startup","Other"].sample}
    stage_of_career {1}
    mentor_industry {["Business", "Technology", "Startup"].sample}
    peer_industry {["Business", "Technology", "Startup"].sample}
    current_goal {["Rising the ranks / breaking the glass ceiling","Switching industries","Finding work/life balance"].sample}
    top_3_interests {["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer","Wine","Traveling"," Local events",    "Reading", "Photography", "Movies","Cooking / Eating / Being a foodie" ,"Social issues / volunteering","Video Games"].sample(3)}
    live_in_detroit {%w(true false).sample}
    is_participating_next_month {[true, false].sample}
    is_participating_this_month {true}
  end
end
