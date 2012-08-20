require "rubygems"
require "RSRuby"
require "matrix"

# Rrr is Adrian's helper wrapper for RSRuby.
#
# It makes sure that RSRuby is set up properly.
# You can use this class to access RSRuby, e.g.,
# > rrr = Rrr.new
# > rrr.r.plot(...)
#
# Also adds support for matrices.
#
# Installing RSRuby:
# 1) Download OSX build of R in 64-bit, e.g., from http://r.research.att.com/ or r-project.org
# 2) Install RSRuby
# > export R_HOME=/Library/Frameworks/R.framework/Resources
# > sudo gem install rsruby -- --with-R-dir=$R_HOME
# 3) Use in Ruby
#     ENV["R_HOME"] ||= "/Library/Frameworks/R.framework/Resources"
#     @r = RSRuby.instance

class Rrr
	def self.run(&block)
		r = Rrr.new
		yield r
		r.off
	end

	def self.png(title, &block)
		self.run do |r|
			file = "#{title}.png"
			puts "Plotting '#{title}' to #{file}..."
			r.png(file)
			yield r
		end
	end

	def self.pdf(title, &block)
		self.run do |r|
			file = "#{title}.pdf"
			puts "Plotting '#{title}' to #{file}..."
			r.pdf(file)
			yield r
		end
	end

	def initialize
		ENV["R_HOME"] ||= "/Library/Frameworks/R.framework/Resources"
		@r = RSRuby.instance

		# set up support for matrices
		matrix_test_proc = lambda { |x| @r.is_matrix(x) }
		matrix_conv_proc = lambda { |x| Matrix.new(x.to_ruby) }
		@r.proc_table[matrix_test_proc] = matrix_conv_proc;
		@r.matrix.autoconvert(RSRuby::PROC_CONVERSION)
	end

	def off
		@r.eval_R("dev.off()")
	end
	
	def self_check
		# Make sure that RSRuby is set up properly
		nil != @r 
	end

	# Pass everything on to the RSRuby instance
	def method_missing(meth, *args, &block)
		@r.send(meth, *args, &block)
	end
end