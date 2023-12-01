lines = File.read(File.expand_path("#{__dir__}/input.txt")).chomp.split("\n")

result1 = lines.map do |row|
  numbers_row = row.scan(/\d/).join
  first_number = numbers_row[0]
  second_number = numbers_row[-1]

  "#{first_number}#{second_number}".to_i
end.sum

puts "Part 1: #{result1}"

NUMBERS = {
  "one" => 1, "two" => 2, "three" => 3, "four" => 4,
  "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9
}.freeze

result2 = lines.map do |row|
  converted_number_row = row.chars.each_with_object("") do |char, acc|
    acc << char
    NUMBERS.each { |word, number| acc.gsub!(word, "#{word[0]}#{number}#{word[-1]}") }
  end

  numbers_row = converted_number_row.scan(/\d/).join
  first_number = numbers_row[0]
  second_number = numbers_row[-1]

  # puts "#{converted_number_row} => #{first_number}#{second_number}"
  "#{first_number}#{second_number}".to_i
end.sum

puts "Part 2: #{result2}"
