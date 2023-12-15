# lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")
# lines2 = File.read(File.expand_path("#{__dir__}/test2.txt")).chomp.split("\n")
lines2 = File.read(File.expand_path("#{__dir__}/input2.txt")).chomp.split("\n")

def short_way(paths, element, instruction)
  left, right = paths[element]
  (instruction == "L") ? left : right
end

def long_way(paths, element, instructions, next_elements_acc = [])
  return next_elements_acc if element == "ZZZ"

  instructions.each_char do |instruction|
    next if next_elements_acc.last == "ZZZ"

    next_element = next_elements_acc.empty? ? short_way(paths, element, instruction) : short_way(paths, next_elements_acc.last, instruction)
    next_elements_acc << next_element
  end

  long_way(paths, next_elements_acc.last, instructions, next_elements_acc)
end

instructions = lines1.shift

paths = lines1.each_with_object({}) do |line, acc|
  next if line.empty?

  route, conditions = line.split(" = ")
  acc[route] = conditions.scan(/[A-Z]+/)
end

result1 = long_way(paths, "AAA", instructions, next_elements_acc = []).count

puts "Part 1: #{result1}"
########################

def find_node_closest_way(paths, node, instructions)
  counter = 0
  next_element = nil

  until next_element && next_element[2] == "Z"
    instructions.each_char do |instruction|
      next if next_element && next_element[2] == "Z"

      counter += 1
      next_element = next_element.nil? ? short_way(paths, node, instruction) : short_way(paths, next_element, instruction)
    end
  end

  counter
end

def long_way2(paths, nodes, instructions)
  filled_nodes = {}

  nodes.each do |node|
    filled_nodes[node] = find_node_closest_way(paths, node, instructions)
  end

  filled_nodes.values.reduce(1) { |acc, n| acc.lcm(n) }
end

instructions = lines2.shift

paths = lines2.each_with_object({}) do |line, acc|
  next if line.empty?

  route, conditions = line.split(" = ")
  acc[route] = conditions.scan(/[0-9A-Z]+/)
end

start_nodes = paths.keys.select { _1[2] == "A" }

result2 = long_way2(paths, start_nodes, instructions)

puts "Part 2: #{result2}"
