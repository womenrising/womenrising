desc 'Migrate live_in_detroit users to Detroit location'

task :live_in_detroit => :environment do
  location = Location.first_or_create(city: 'Detroit', state: 'MI')
  User.where(live_in_detroit: true).update_all(location_id: location.id)
end
