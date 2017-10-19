# == Schema Information
#
# Table name: mentor_industries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MentorIndustry < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :mentor_industry_users
end
