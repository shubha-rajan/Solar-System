require_relative "planet"
require_relative "solar-system"
require "faker"
require "lolcat"
require "colorize"
require "table_flipper"

def add_planet(solar_system)
  # Get user input for new planet's attributes
  puts "\nLet's get some details about the planet you want to add."
  puts "First, what color is your planet?"
  color = gets.chomp
  puts "Okay, what is the mass of your planet in kilograms?"
  mass_kg = gets.chomp.to_f
  puts "Great! How far is your planet from the sun in kilometers?"
  distance_from_sun = gets.chomp.to_f
  puts "Next, enter a fun fact about your planet!"
  fun_fact = gets.chomp
  puts "Finally, what is your planet's name?"
  name = gets.chomp
  # This while loop ensures that planet names are unique.
  # If you're naming two planets the exact same thing, go back to astronomy school :P
  while solar_system.planets.any? { |planet| planet.name.downcase == name.downcase }
    puts "That name is taken! Try entering another name."
    name = gets.chomp
  end

  # Try to make a planet and add it to the solar system and rescue if parameters are invalid
  begin
    new_planet = Planet.new(name, color, mass_kg, distance_from_sun, fun_fact)
    solar_system.add_planet(new_planet)
  rescue ArgumentError => e
    puts "\nFailed to add your planet. Try again."
    puts e.message
  else
    puts "\nSuccessfully added your planet!"
  end
end

def measure_distance(solar_system)
  # Get the names of planets and store the planet objects in variables
  puts "\nWhat is the first planet?"
  planet1_name = gets.chomp
  planet1 = solar_system.find_planet_by_name(planet1_name)
  puts "What is the second planet?"
  planet2_name = gets.chomp
  planet2 = solar_system.find_planet_by_name(planet2_name)

  # If both planet objects exist, calculate the distance, otherwise print error messages
  if planet1 && planet2
    distance = solar_system.distance_between(planet1_name, planet2_name)
    puts "\nThe distance between #{planet1_name} and #{planet2_name} is #{distance} km."
  elsif !planet1 && !planet2
    puts "\n#{planet1_name} and #{planet2_name} are not in the solar system. Try again."
  elsif !planet1
    puts "\n#{planet1_name} is not in the solar system. Try again"
  elsif !planet2
    puts "\n#{planet2_name} is not in the solar system. Try again"
  end
end

def display_details(solar_system)
  # Get a planet name as user input and use find_planet_by_name to retrieve the planet object
  puts "\nWhich planet do you want to learn about?"
  planet_name = gets.chomp
  planet = solar_system.find_planet_by_name(planet_name)
  if planet
    puts planet.summary
  else
    puts "#{planet_name} is not in the solar system! Try again."
  end
end

def control_loop(solar_system)
  input = ""
  possible_inputs = {
                      l: "list planets",
                      d: "display planet details",
                      a: "add planet",
                      m: "measure the distance between 2 planets",
                      q: "exit",
                    }

  while input != "q"
    puts "What would you like to do?"
    possible_inputs.each do |key, value|
      puts "Press #{key} to #{value}"
    end

    input = gets.chomp.downcase.to_sym

    case input
    when :l
      puts solar_system.list_planets
    when :d
      display_details(solar_system)
    when :a
      add_planet(solar_system)
    when :m
      measure_distance(solar_system)
    when :q
      return
    else
      puts "\n#{input} is not one of the options. Try again!"
    end

    puts "\n"
  end
end

def main

  # Make a solar system
  solar_system = SolarSystem.new(Faker::Space.star)

  # Make some planets and add them to the solar system
  puts "Loading planets...."
  4.times do
    new_planet = Planet.new(Faker::Movies::HitchhikersGuideToTheGalaxy.planet,
                            Faker::Color.color_name,
                            (Faker::Number.decimal(1, 3)).to_f * 10 ** (rand(22..24)),
                            (Faker::Number.decimal(1, 3)).to_f * 10 ** (rand(7..9)),
                            "Discovered by #{Faker::FunnyName.name_with_initial} " +
                            "on #{Faker::Date.forward}, this planet is home to the " +
                            "rare #{Faker::Movies::HitchhikersGuideToTheGalaxy.specie}.")
    solar_system.add_planet(new_planet)
  end

  # Start the control loop.
  puts "Welcome to the solar system program."
  control_loop(solar_system)
end

main
