# lines1 = File.read(File.expand_path("#{__dir__}/test.txt")).chomp.split("\n")
lines1 = File.read(File.expand_path("#{__dir__}/input1.txt")).chomp.split("\n")

RANK1 = "AKQJT98765432"
RANK2 = "AKQT98765432J"

HANDS = %w[
  five_of_a_kind
  four_of_a_kind
  full_house
  three_of_a_kind
  two_pairs
  one_pair
  high_card
].freeze

def calc_combo(hand)
  grouped_values = hand.group_by(&:itself).map { |_k, v| v.count }

  return "five_of_a_kind" if grouped_values.include?(5)
  return "four_of_a_kind" if grouped_values.include?(4)
  return "full_house" if grouped_values.include?(3) && grouped_values.include?(2)
  return "three_of_a_kind" if grouped_values.include?(3)
  return "two_pairs" if grouped_values.select { _1 == 2 }.count == 2
  return "one_pair" if grouped_values.include?(2)
  return "high_card" if grouped_values.include?(1)

  raise "wrong_combination"
end

def change_j_to_rank(hand, rank, acc = [])
  target_idx = hand.index("J")

  return [hand] if target_idx.nil?

  rank.split("").map do |rank_letter|
    next if rank_letter == "J"
    new_hand = hand.dup
    new_hand[target_idx] = rank_letter
    acc << new_hand
  end

  acc
end

def calc_all_combination_wo_j(hand)
  return [hand] if !hand.include?("J")

  new_hands = change_j_to_rank(hand, RANK2)
  new_hands.map { _1.include?("J") ? calc_all_combination_wo_j(_1) : [_1] }.flatten(1)
end

def calc_individual(hand, rank)
  reverse_rank = rank.reverse
  hand.map { reverse_rank.index(_1) + 10 }.join
end

def calc_the_best_combo(hand)
  new_hand = calc_all_combination_wo_j(hand).min_by { |combo| HANDS.index(calc_combo(combo)) }
  calc_combo(new_hand)
end

result1 = lines1.each_with_object({}) do |line, acc|
  hand, bid = line.split(" ")
  split_hand = hand.split("")
  acc[bid] = [hand, calc_combo(split_hand), calc_individual(split_hand, RANK1)]
end
  .sort_by { |_bid, (_hand, combo_name, power)| [HANDS.index(combo_name), -power.to_i] }
  .to_h
  .keys
  .reverse
  .map.with_index(1) { |bid, idx| bid.to_i * idx }.sum

puts "Part 1: #{result1}"

result2 = lines1.each_with_object({}) do |line, acc|
  hand, bid = line.split(" ")
  split_hand = hand.split("")
  acc[bid] = [hand, calc_the_best_combo(split_hand), calc_individual(split_hand, RANK2)]
end
  .sort_by { |_bid, (_hand, combo_name, power)| [HANDS.index(combo_name), -power.to_i] }
  .to_h
  .keys
  .reverse
  .map.with_index(1) { |bid, idx| bid.to_i * idx }.sum

puts "Part 2: #{result2}"
