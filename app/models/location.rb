# == Schema Information
#
# Table name: locations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  hero_url    :string(255)
#


class Location < ActiveRecord::Base
end
