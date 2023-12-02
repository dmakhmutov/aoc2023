# lines0 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")
lines2 = File.read(File.expand_path("#{__dir__}/input2.txt")).chomp.split("\n")

IMPOSSIBLE_COMBINATIONS_0 = {
  "red" => 12,
  "green" => 13,
  "blue" => 14
}.freeze

possible_games = []

lines1.each do |line|
  game_id = line.scan(/\d+:/).join.scan(/\d+/).first.to_i

  flag = true
  line.scan(/\d+\s\w+/).each_cons(2) do |first, second|
    first_number, first_color = first.scan(/\w+/)
    second_number, second_color = second.scan(/\w+/)

    if first_number.to_i > IMPOSSIBLE_COMBINATIONS_0[first_color] || second_number.to_i > IMPOSSIBLE_COMBINATIONS_0[second_color]
      flag = false
    end
  end

  possible_games << game_id if flag
end

result1 = possible_games.sum
puts "Part 1: #{result1}"

result2 = lines2.map do |line|
  fewest_numbers = line.scan(/\d+\s\w+/).each_cons(2).each_with_object(Hash.new(0)) do |(first, second), acc|
    first_number, first_color = first.scan(/\w+/)
    second_number, second_color = second.scan(/\w+/)

    acc[first_color] = first_number.to_i if first_number.to_i > acc[first_color]
    acc[second_color] = second_number.to_i if second_number.to_i > acc[second_color]
  end

  fewest_numbers.values.reduce(:*)
end.sum

puts "Part 2: #{result2}"
