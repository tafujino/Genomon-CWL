# frozen_string_literal: true

# Stores mutation regions in chromosome and their mutation information
#
class MutationMap
  # @return [String]
  attr_reader :name

  # @return [Hash{ ChrRegion => CSV::Row }]
  attr_reader :map

  # @param name [String]
  # @param path [String] mutation result file path
  def initialize(name, path)
    @name = name
    @map  = load_file(path)
    puts "# of entries for #{@name} = #{map.length}"
  end

  # @return [Array<ChrRegion>]
  def regions
    @map.keys
  end

  # @param  [ChrRegion]
  # @return [CSV::Row]
  def [](region)
    @map[region]
  end

  # @param region [ChrRegion]
  # @return       [Boolean]
  def exists_value?(region)
    return true if @map[region]

    puts "#{@name} does not have entry for #{region}"
    return false
  end

  private

  def load_file(path)
    str = File.readlines(path, chomp: true).reject do |line|
      line =~ /^#/
    end.join("\n")

    CSV.new(str, col_sep: "\t", headers: true).group_by do |row|
      ChrRegion.new(row['Chr'], row['Start'], row['End'])
    end.map.to_h do |region, a|
      # tuple (chr, start, end) should be unique
      if a.length > 1
        warn "#{k} is not a unique key: #{path}"
        exit 1
      end
      [region, a.first]
    end
  end
end
