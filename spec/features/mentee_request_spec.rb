require 'rails_helper'

feature 'User can request a mentor' do

  xscenario 'a logged in user user can submit a question and request for a mentor' do

    # User requests a mentor by submitting a question and request with form views/mentors/new.html.erb new_mentor_path
    # a request for a mentor is not made unless a question is asked with the request

    # Find all those users who have indicated they will be a mentor-- User.mentors
    # of those, which have NOT been paired? How is this data recorded?

    # if there are more than one availabe mentors, match mentee based on indicators- which?
    # if not, match availabe mentor with mentee
    # how is this data stored?


  end

  xscenario'if a mentor is avaiable, mentee is matched' do
    # mentor and mentee are notified of match-- how does this occur?
  end

  xscenario'if a mentor is unavaiable, mentee is placed on a waitlist' do
    # As a mentee when requesting a mentor, if none are available, you should get a notice that you have been put on a waitlist/queue for mentors. The next time a mentor becomes available, it should automatically match the mentor with the next mentee on the queue.

  end
end
