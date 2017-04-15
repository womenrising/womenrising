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
    is_participating_this_month { true }
    waitlist { [true, false].sample }
    linkedin_url { Faker::Internet.url }
  end

  factory :skinny_user, class: User do
    email { generate(:email) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password "testtingstuff"
    password_confirmation {|attrs| attrs[:password]}
    linkedin_url { Faker::Internet.url }

    trait :mentor do
      mentor true
    end

    trait :with_goal do
      current_goal 'Rising the ranks'
    end

    trait :technology_primary_industry do
      primary_industry 'Technology'
    end

    trait :with_interests do
      top_3_interests ['Yoga', 'Hiking', 'Robotics']
    end

    trait :not_on_waitlist do
      primary_industry {["Business", "Technology", "Startup"].sample}
      peer_industry {["Business", "Technology", "Startup"].sample}
      top_3_interests {["Arts", "Music", "Crafting", "Home improvement / Decorating", "Being a mom", "Dogs", "Cats", "Watching Sports", "Outdoors / Hiking", "Exercise", "Biking", "Yoga", "Running", "Beer", "Wine", "Traveling", "Local events", "Reading", "Photography", "Movies", "Cooking / Eating / Being a foodie", "Social issues / volunteering", "Video Games"].sample(3)}
      current_goal {["Rising the ranks / breaking the glass ceiling", "Switching industries", "Finding work/life balance"].sample}
      live_in_detroit 'true'
    end

    trait :groupable do
      not_on_waitlist
      is_participating_this_month 'true'
      is_assigned_peer_group 'false'
    end

    trait :new_to_technology do
      peer_industry 'Technology'
      stage_of_career 1
    end

    trait :likes_tech do
      primary_industry 'Technology'
      peer_industry 'Technology'
    end

    trait :new_to_technology_and_wants_balance do
      new_to_technology
      current_goal 'Finding work/life balance'
    end

    trait :any_stage_of_career do
      stage_of_career {Random.rand(1..5)}
    end
  end
end
