require 'rails_helper'

RSpec.describe Mentor, :type => :model do
 	it{should belong_to(:mentee).class_name('User').with_foreign_key('mentee_id')}
 	it{should belong_to(:mentoring).class_name('User').with_foreign_key('mentor_id')}
end
