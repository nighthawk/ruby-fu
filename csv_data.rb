require 'rubygems'
require 'fastercsv'

# A helper class to load CSV data
#
# This assumes that the CSV data is stored in files called *.csv
# This means that each file needs to be a proper CSV.
class CsvData
  attr_reader :data
  
  def initialize(dir = nil)
    @data = {}
    @dir = dir || `pwd`.strip
    load_files Dir.glob(@dir + '/**/*.csv')
  end
  
  private
    def load_files(files)
      files.each do |f|
        name, rubbish = File.basename(f, ".csv").split('-')
        @data[name] ||= []
        FasterCSV.foreach(f, :headers => true) { |r| @data[name] << r.to_hash }
      end
    end  
end