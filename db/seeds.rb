# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

Reservation.destroy_all
Accommodation.destroy_all
City.destroy_all
User.destroy_all

users_array = []
cities_array = []
accommodations_array = []
reservations_array = []

Faker::Config.locale = 'fr'

20.times do
  user = User.create!(email: Faker::Internet.free_email,
                      phone_number: '0' + Faker::Number.between(from: 100000001, to: 999999999).to_s,
                      description: Faker::Name.unique.first_name + ' ' + Faker::Name.unique.last_name)
  users_array << user
end

10.times do
  city = City.create!(name: Faker::Address.unique.city,
                      zip_code: Faker::Number.between(from: 21, to: 95).to_s + Faker::Number.between(from: 100, to: 999).to_s)
  cities_array << city
end

50.times do
  accommodation = Accommodation.create!(available_beds: Faker::Number.between(from: 1, to: 25),
                                        price: Faker::Number.between(from: 40, to: 2500),
                                        description: Faker::Lorem.words(number: 140, supplemental: true).join(' '),
                                        has_wifi: [true, false].sample,
                                        welcome_message: Faker::Lorem.sentences(number: rand(4)+1).join(' '),
                                        admin_id: User.all.sample.id,
                                        city_id: City.all.sample.id)
  accommodations_array << accommodation
end

n = 5
accommodations_array.length.times do |index|
  begin_date = Faker::Date.between(from: 1.year.ago, to: 6.months.ago)
  end_date = begin_date + 1
  n.times do
    begin_date = Faker::Date.between(from: end_date + 1, to: end_date + 3)
    end_date = Faker::Date.between(from: begin_date + 1, to: begin_date + 3)
    reservation = Reservation.create!(start_date: begin_date,
                                      end_date: end_date,
                                      guest_id: User.all.sample.id,
                                      accommodation_id: accommodations_array[index].id)
    reservations_array << reservation
  end
  
  begin_date = Faker::Date.between(from: 3.days.from_now, to: 5.months.from_now)
  end_date = begin_date + 1
  n.times do
    begin_date = Faker::Date.between(from: end_date + 1, to: end_date + 3)
    end_date = Faker::Date.between(from: begin_date + 1, to: begin_date + 3)
    reservation = Reservation.create!(start_date: begin_date,
                                      end_date: end_date,
                                      guest_id: User.all.sample.id,
                                      accommodation_id: accommodations_array[index].id)
    reservations_array << reservation
  end
end

require 'table_print'

tp.set User, :id, :email, :phone_number, :description
tp.set City, :id, :name, :zip_code
tp.set Accommodation, :id, :available_beds, :price, {:description => {:width => 15}}, :has_wifi, {:welcome_message => {:width => 15}},
                      {"admin.id" => {:width => 8, :display_name => "Admin Id"}}, {"admin.email" => {:width => 25, :display_name => "Admin Email"}},
                      {"admin.description" => {:width => 42, :display_name => "Admin"}}, {"city.id" => {:width => 7, :display_name => "City Id"}},
                      {"city.name" => {:width => 25, :display_name => "City"}}, {"city.zip_code" => {:width => 13, :display_name => "City Zip Code"}}
tp.set Reservation, :id, {start_date: {:width => 10, :time_format => '%Y-%m-%d'}}, {end_date: {:width => 10, :time_format => '%Y-%m-%d'}},
                    {"guest.id" => {:width => 8, :display_name => "Guest Id"}},
                    {"guest.email" => {:width => 25, :display_name => "Guest Email"}}, {"guest.description" => {:width => 42, :display_name => "Guest"}},
                    {"accommodation.id" => {:width => 7, :display_name => "Acc. Id"}}, {"accommodation.available_beds" => {:width => 8, :display_name => "Nb. beds"}},
                    {"accommodation.price" => {:width => 8, :display_name => "Price"}}, {"accommodation.description" => {:width => 15, :display_name => "Accommodation"}},
                    {"accommodation.admin.description" => {:width => 42, :display_name => "Admin"}}, {"accommodation.city.id" => {:width => 7, :display_name => "City Id"}},
                    {"accommodation.city.name" => {:width => 25, :display_name => "City"}}, {"accommodation.city.zip_code" => {:width => 13, :display_name => "City Zip Code"}}

puts "#{users_array.length} users créés :\n"
tp User.all
puts "\n#{cities_array.length} cities créées :\n"
tp City.all
puts "\n#{accommodations_array.length} accommodations créées :\n"
tp Accommodation.all
puts "\n#{reservations_array.length} réservations créées :\n"
tp Reservation.all
puts
