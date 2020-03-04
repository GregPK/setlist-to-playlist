# Represents a date in ISO 8601
# Internally it's just a Time object, but with the time part ignored.
# Makes working with dates a lot simpler than formatting Time every time it needs a date.
class Date
  def initialize(@time = Time.local)
  end

  def to_s
    time.to_s("%Y-%m-%d")
  end

  def inspect
    to_s
  end

  def cast(other : Time)
    new(other)
  end

  def ==(other : Date) : Bool
    to_s == other.to_s
  end

  def ===(other : Date) : Bool
    to_s === other.to_s
  end

  def <=>(other : Date) : Int32
    to_s <=> other.to_s
  end

  private def time
    @time
  end
end
