require "rails_helper"

describe "womenrising:mentor_matches" do
  include_context "rake"

  let!(:mentors) { create_list :mentor_user, 3 }
  let!(:mentorships) { create_list :mentorship, 3 }

  it "does soemthing", focus: true do
    expect { subject.invoke }.to output("MATCH!\n").to_stdout
  end
end
