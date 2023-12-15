# lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")

times = lines1[0].scan(/\d+/)
distances = lines1[1].scan(/\d+/)

time_distances = {}
times.each_with_index { |time, index| time_distances[time.to_i] = distances[index].to_i }

result1 = time_distances.each_with_object(Hash.new(0)) do |(time, rule_distance), acc|
  positive_attempts = (0..time).each_with_object([]) do |hold_button, counter|
    speed = hold_button * (time - hold_button)
    counter << 1 if speed > rule_distance
  end.count

  acc[time] = positive_attempts
end.values.reduce(:*)

puts "Part 1: #{result1}"

time = lines1[0].scan(/\d+/).join.to_i
distance = lines1[1].scan(/\d+/).join.to_i

result2 = (0..time).each_with_object([]) do |hold_button, counter|
  speed = hold_button * (time - hold_button)
  counter << 1 if speed > distance
end.count

puts "Part 2: #{result2}"
