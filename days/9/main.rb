# lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")

def find_diff(sequence)
  sequence.each_with_index.each_with_object([]) do |(num, idx), difference|
    next if idx == 0

    difference << num - sequence[idx - 1]
  end
end

result1 = lines1.each_with_object([]) do |line, acc|
  matrix = []

  sequence = line.split(" ").map(&:to_i)
  matrix << sequence

  until matrix.last.all?(&:zero?)
    matrix << find_diff(matrix.last)
  end

  matrix.reverse.each_with_index do |row, idx|
    next matrix[idx] = row << 0 if idx == 0

    matrix[idx] = row << matrix[idx - 1].last + row.last
  end

  acc << matrix.last.last
end.sum

puts "Part 1: #{result1}"

result2 = lines1.each_with_object([]) do |line, acc|
  matrix = []

  sequence = line.split(" ").map(&:to_i)
  matrix << sequence

  until matrix.last.all?(&:zero?)
    matrix << find_diff(matrix.last)
  end

  matrix.reverse.each_with_index do |row, idx|
    next matrix[idx] = row.unshift(0) if idx == 0

    matrix[idx] = row.unshift(row[0] - matrix[idx - 1].first)
  end

  acc << matrix.last.first
end.sum

puts "Part 2: #{result2}"
