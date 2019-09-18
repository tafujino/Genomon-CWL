# frozen_string_literal: true

# Describes chromosome regions
#
class ChrRegion
  # @return [Integer]
  attr_reader :chr, :spos, :epos

  def initialize(chr, spos, epos)
    @chr  = chr
    @spos = spos
    @epos = epos
  end

  def ==(other)
    @chr == other.chr && @spos == other.spos && @epos == other.epos
  end

  def eql?(other)
    self == other
  end

  def hash
    [@chr, @spos, @epos].hash
  end

  def to_s
    "chr#{@chr} #{@spos}:#{@epos}"
  end
end
