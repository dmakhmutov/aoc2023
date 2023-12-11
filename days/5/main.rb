lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
# lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")
# lines2 = File.read(File.expand_path("#{__dir__}/input2.txt")).chomp.split("\n")

MAPS = %w(
  seed-to-soil
  soil-to-fertilizer
  fertilizer-to-water
  water-to-light
  light-to-temperature
  temperature-to-humidity
  humidity-to-location
).freeze

seeds = lines1[0].scan(/\d+/).map(&:to_i)
raw_mapping = lines1.each.with_object({}) do |line, acc|
  next acc[line.split.first] = [] if MAPS.include?(line.split.first)
  acc[acc.keys.last] << line.split.map(&:to_i) if acc[acc.keys.last] && line.split.size > 1
end


final_mapping = MAPS.each_with_object({}) do |key, acc|
  acc[key] = {}
  raw_mapping[key].map do |array_line|
    from = (array_line[1]..(array_line[1] + array_line[2] - 1)).to_a
    to = (array_line[0]..(array_line[0] + array_line[2] - 1)).to_a

    from.each_with_index do |number, index|
      acc[key][number] = to[index]
    end
  end
end

result1 = seeds.each_with_object({}) do |seed, acc|
  acc[seed] = {}
  final_mapping.each do |name, mapping|
    acc[seed][name] = mapping.fetch(seed, seed)
  end
end

puts result1
# puts result["seed-to-soil"]
