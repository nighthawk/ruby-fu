require "RSRuby"

# A class representing matrixes for RSRuby
class Matrix
	attr_reader :data

	def initialize(array_of_arrays)
		@data = array_of_arrays
	end

	def as_r
		mode = RSRuby.get_default_mode
		RSRuby.set_default_mode(RSRuby::NO_CONVERSION)
		flat = flatten_for_r
		robj = RSRuby.instance.matrix(flat[0], flat[1])
		RSRuby.set_default_mode(mode)
		robj
	end

private
	def flatten_for_r
		array = []
		return [], {:nrow => 0, :ncol => 0} if nil == @data || @data.count == 0

		sample_row = @data.first
		0.upto(sample_row.count - 1) do |c|
			@data.each { |r| array << r[c] }
		end
		hash = {:nrow => @data.count, :ncol => sample_row.count}
		return array, hash
	end
end