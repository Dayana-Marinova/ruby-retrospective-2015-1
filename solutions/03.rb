class Integer
  def prime?
    return false if self < 2
    (2..self / 2).none? {|i| self % i == 0}
  end
end

class Sequence
  include Enumerable

  attr_reader :limit

  def initialize(limit)
    @limit = limit
  end
end

class PrimeSequence < Sequence
  def each
    limit, n = 0, 0
    while limit < @limit
      if n.prime?
        yield n
        limit += 1
      end
      n += 1
    end
  end
end

class RationalSequence < Sequence
  def each
    numerator, denominator, limit = 1, 1, 0
    while limit < @limit
      if numerator.gcd(denominator) == 1
        yield Rational(numerator, denominator)
        limit += 1
      end
      number = next_number(numerator, denominator)
      numerator = number[:numerator]
      denominator = number[:denominator]
    end
  end

  private

  def next_number(numerator, denominator)
    if numerator % 2 == denominator % 2
      numerator += 1
      denominator = [1, denominator.pred].max
    else
      denominator += 1
      numerator = [1, numerator.pred].max
    end
    {denominator: denominator, numerator: numerator}
  end
end

class FibonacciSequence < Sequence
  def initialize(limit, initial_values = {first: 1, second: 1})
    @limit = limit
    @initial_values = initial_values
  end

  def each
    b, a, limit = @initial_values[:first], @initial_values[:second], 0
    while limit < @limit
      yield b
      a, b = a + b, a
      limit += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    groups = RationalSequence.new(n).
      partition {|number| number.numerator.prime? || number.denominator.prime?}
    groups.first.reduce(1, :*) / groups.last.reduce(1, :*)
  end

  def aimless(n)
    rationals = []
    PrimeSequence.new(n).each_slice(2) do |numerator, denominator|
      denominator ||= 1
      rationals << Rational(numerator, denominator)
    end
    rationals.reduce(:+)
  end

  def worthless(n)
    limit = FibonacciSequence.new(n).to_a.last
    rationals = RationalSequence.new(limit).to_a
    biggest_slice(limit, rationals)
  end

  def biggest_slice(limit, rationals)
    while rationals.reduce(:+) > limit
      rationals -= [rationals.last]
    end
    rationals
  end
end
