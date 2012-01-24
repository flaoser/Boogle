require_relative 'boggle_solver'
require 'enumerator'

board_string = ARGV[0]
board_array = board_string.split(//).map { |l| l == 'q' ? 'qu' : l }.each_slice(4).to_a

t1 = Time.now

dict = BoggleSolver::Dictionary.from_file("words.dict")
board = BoggleSolver::Board.new(board_array)
results = BoggleSolver::Solver.new(dict, board).solve

t2 = Time.now

puts "\nResults:"
puts results

puts "\nStats:"
puts "Found #{results.size} words in %0.4f seconds" % (t2 - t1)