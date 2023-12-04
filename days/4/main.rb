# lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")

result1 = lines1.map do |line|
  line.gsub!(/Card\s+\d+:./, "")
  winning_numbers, numbers = line.split(" | ").map { _1.split.map(&:to_i) }
  matches = numbers & winning_numbers

  next 0 if matches.empty?

  2**(matches.size - 1)
end.sum

puts "Part 1: #{result1}"

matches = lines1.map do |line|
  line.gsub!(/Card\s+\d+:./, "")
  winning_numbers, numbers = line.split(" | ").map { _1.split.map(&:to_i) }
  numbers & winning_numbers
end

cards = [1] * matches.size

matches.each_with_index do |match, index|
  match.size.times { |n| cards[index + 1 + n] += cards[index] }
end

result2 = cards.sum

puts "Part 2: #{result2}"
