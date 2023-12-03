# lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")

class String
  def is_number?
    to_f.to_s == to_s || to_i.to_s == to_s
  end
end

DOT = ".".freeze

def find_neighbors_coordinate(lines, line_index, char_index)
  deltas = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1]
  ]

  deltas.each_with_object([]) do |delta, neighbors|
    x = line_index + delta[0]
    y = char_index + delta[1]

    neighbors << [x, y] if x.between?(0, lines.size - 1) && y.between?(0, lines.first.size - 1)
  end
end

result1 = lines1.each_with_index.each_with_object([]) do |(line, line_index), acc|
  temp_number = ""
  possible_check_coordinates = []

  line.chars.each_with_index do |char, char_index|
    if char.is_number?
      possible_check_coordinates += find_neighbors_coordinate(lines1, line_index, char_index)
      next temp_number << char
    end

    if !char.is_number? && temp_number != ""
      acc << temp_number.to_i if possible_check_coordinates.any? { |x, y| lines1[x][y] != DOT && !lines1[x][y].is_number? }
      temp_number = ""
      possible_check_coordinates = []
    end
  end

  acc << temp_number.to_i if possible_check_coordinates.any? { |x, y| lines1[x][y] != DOT && !lines1[x][y].is_number? }
end.sum

puts "Part 1: #{result1}"

result2 = lines1.each_with_index.each_with_object(Hash.new { |h, k| h[k] = [] }) do |(line, line_index), acc|
  temp_number = ""
  possible_check_coordinates = []

  line.chars.each_with_index do |char, char_index|
    if char.is_number?
      possible_check_coordinates += find_neighbors_coordinate(lines1, line_index, char_index)
      next temp_number << char
    end

    if !char.is_number? && temp_number != ""
      multiplier_coordinates = possible_check_coordinates.find { |x, y| lines1[x][y] == "*" }
      if multiplier_coordinates
        acc[multiplier_coordinates.join] << temp_number.to_i if find_neighbors_coordinate(lines1, multiplier_coordinates[0], multiplier_coordinates[1]).any? { |x, y| lines1[x][y].is_number? }
      end

      temp_number = ""
      possible_check_coordinates = []
    end
  end

  multiplier_coordinates = possible_check_coordinates.find { |x, y| lines1[x][y] == "*" }
  if multiplier_coordinates
    acc[multiplier_coordinates.join] << temp_number.to_i if find_neighbors_coordinate(lines1, multiplier_coordinates[0], multiplier_coordinates[1]).any? { |x, y| lines1[x][y].is_number? }
  end
end.values.select { |v| v.size > 1 }.map { |v| v.reduce(:*) }.sum

puts "Part 2: #{result2}"
