require 'csv'
require_relative './restroom'

frequency = 3
facilities_per_restroom = 3
use_duration = 1
population_range = 10..600
DURATION = 9 * 60

data = {}
population_range.step(10).each do |population_size|
  Person.population.clear
  population_size.times { Person.population << Person.new(frequency, use_duration) }
  data[population_size] = []
  restroom = Restroom.new facilities_per_restroom
  DURATION.times do |t|
    data[population_size] << restroom.queue.size
    queue = restroom.queue.clone
    restroom.queue.clear
    restroom.enter queue.shift unless queue.empty?
    Person.population.each do |person|
      restroom.enter person if person.need_to_go?
    end
    restroom.tick
  end
end

CSV.open('simulation1.csv', 'w') do |csv|
  lbl = []
  population_range.step(10).each { |population_size| lbl << population_size }
  csv << lbl

  DURATION.times do |t|
    row = []
    population_range.step(10).each do |population_size|
      row << data[population_size][t]
    end
    csv << row
  end
end