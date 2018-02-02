class CreateMentorIndustries < ActiveRecord::Migration
  def up
    create_table :mentor_industries do |t|
      t.string :name
    end

    MentorIndustry.create(name: 'Business')
    MentorIndustry.create(name: 'Technology')
    MentorIndustry.create(name: 'Startup')
  end

  def down
    drop_table :mentor_industries
  end
end
