require 'rubygems'
require 'json'

# A helper class to load JSON data
#
# This assumes that the JSON data is stored in files called *.json
# and that each line in that file is in JSON format. This means the
# file itself is improper JSON!
class JsonData
	attr_reader :data

	def initialize(dir = nil)
		@data = []
		@dir = dir || `pwd`.strip
		load_files Dir.glob(@dir + '/**/*.json')
	end

	def size
		return @data.size
	end
	
private
	def load_files(files)
		files.each do |f| 
			File.open(f, "r") do |io|
				io.each_line { |line| @data << JSON.parse(line) }
			end
		end
	end
end