module Trie
	
	class Trie

		def initialize(level = 0)
			@level = level
			@children = Hash.new
			@end = false
		end
		
		def insert(string)
			string = string.to_s
			char = string[@level]
			if char.nil?
				@end = true
			else
				@children[char] = (@children[char] or Trie.new(@level + 1))
				@children[char].insert(string)
			end

			return self
		end

		def include?(string)
			string = string.to_s
			char = string[@level]
			if char.nil?
				return @end
			elsif @children[char].nil?
				return false
			else
				@children[char].include?(string)
			end
		end

		def begin?(string)
			string = string.to_s
			char = string[@level]
			if char.nil?
				return true
			elsif @children[char].nil?
				return false
			else
				@children[char].begin?(string)
			end
		end

		def subtrie(string)
			string = string.to_s
			char = string[@level]
			trie = @children[char]
			if trie.nil?
				trie = @children[char] = Trie.new(@level + 1)
			end

			if @level == string.size - 1
				trie
			else
				trie.subtrie(string)
			end
		end
		alias :[] :subtrie

		def any?
			@children.size > 0
		end

		def to_s
			"< {@children = #{@children.keys}} {@end = #{@end}} >"
		end

	end

end