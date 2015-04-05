require 'rails_helper'

RSpec.describe User, :type => :model do
  it{should have_many(:mentees).class_name('Mentor').with_foreign_key('mentee_id')}
  it{should have_many(:mentors).class_name('Mentor').with_foreign_key('mentor_id')}
  it{should have_many(:peer1).class_name('Peer').with_foreign_key('peer1_id')}
  it{should have_many(:peer2).class_name('Peer').with_foreign_key('peer2_id')}
  it{should have_many(:peer3).class_name('Peer').with_foreign_key('peer3_id')}
  it{should have_many(:peer4).class_name('Peer').with_foreign_key('peer4_id')}
end
