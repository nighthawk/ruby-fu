require 'test/unit'
require 'rrr'

class RrrTest < Test::Unit::TestCase

	def test_setup
		rrr = Rrr.new

		assert_equal(true, rrr.self_check)	
	end
end