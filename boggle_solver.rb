require_relative 'trie'
require 'set'

module BoggleSolver

	class Dictionary < Trie::Trie

		def self.from_file(filename)
			dict = Dictionary.new
			File.open(filename) do |file|
				file.each_line do |line|
					dict.insert(line.chomp)
				end
			end
			dict
		end
	end

	class Letter
		attr_accessor :used
		attr_reader :tile

		def initialize(tile)
			@tile = tile
			@used = false
		end
	end

	class Board
		def initialize(contents)
			@size = contents.size
			raise "not square board" unless @size == contents.first.size

			@letters = contents.collect do |row|
				row.collect do |letter|
					Letter.new(letter.downcase)
				end
			end
			count = 0
		end

		def unused_neighbors(letter)
			letter_row = 0
			letter_col = 0
			neighbors = Set.new

			@letters.each_with_index do |row, row_index|
				col_index = row.index(letter)
				if col_index
					letter_row = row_index
					letter_col = col_index
					break
				end
			end

			-1.upto(1) do |row_offset|
				r = letter_row + row_offset
				next unless (0...@size) === r
				-1.upto(1) do |col_offset|
					next if row_offset == 0 and col_offset == 0
					c = letter_col + col_offset
					next unless (0...@size) === c
					neighbors << @letters[r][c]
				end
			end

			return neighbors.reject { |letter| letter.used } 
		end

		def process
			@letters.flatten.each { |letter| yield(letter) }
		end
	end

	class Solver
		def initialize(dict, board)
			@dict = dict
			@board = board
			@results = Set.new
			@solved = false
		end
		
		def solve
			return @results if @solved
			@results = Set.new

			@board.process do |letter|
				find_words(letter, "", @results)
			end

			@solved = true
			@results = @results.to_a.sort_by { |w| [w.size, w] }
		end

		def resolve
			@solved = false
			solve
		end

		private

		def find_words(letter, word, results)
			letter.used = true

			word = word + letter.tile

			if @dict[word].any?
				results << word if word.size >= 2 and @dict.include?(word)

				@board.unused_neighbors(letter).each do |l|
					find_words(l, word, results)
				end
			end

			letter.used = false
		end
	end

end