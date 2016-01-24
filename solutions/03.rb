class PrimeSequence
  include Enumerable

  attr_reader :limit

  def initialize(limit)
    @limit = limit
  end

  def to_a
    enum_for(:each_number).lazy.select{ |x| prime?(x) }.take(@limit).to_a
  end

  private

  def each_number
    n = 0
    loop do
      n += 1
      yield n
    end
  end

  def prime?(n)
    return false if n < 2
    (2..n/2).none? {|i| n % i == 0}
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
    @k = []
    @s = collect_numbers
  end

  def to_a
    @k.take(@limit)
  end

  def collect_numbers
    n = Rational(1)
    @k << n
    while @k.size < @limit
      n = denominator(n) if n.denominator == 1
      n = numerator(n) if n.numerator == 1
    end
  end

  def numerator(n)
    n = Rational(n.numerator, n.denominator + 1)
    @k << n
    target = n.denominator
    while n.numerator < target
      n = next_rational_numerator(n.numerator, n.denominator)
      @k << n
    end
    n
  end

  def denominator(n)
    n = Rational(n.numerator + 1, n.denominator)
    @k << n
    target = n.numerator
    while n.denominator < target
      n = next_rational_denominator(n.numerator, n.denominator)
      @k << n
    end
    n
  end

  def next_rational_denominator(n_numerator, n_denominator)
    i = 1
    while @k.include?(Rational(n_numerator-i, n_denominator+i))
      i += 1
    end
    Rational(n_numerator-i, n_denominator+i)
  end

  def next_rational_numerator(n_numerator, n_denominator)
    i = 1
    while @k.include?(Rational(n_numerator+i, n_denominator-i))
      i += 1
    end
    Rational(n_numerator+i, n_denominator-i)
  end
end

class FibonacciSequence
  include Enumerable

  attr_reader :limit

  def initialize(limit, initial_values= {first: 1, second: 1})
    @limit = limit
    @initial_values = initial_values
  end

  def to_a
    enum_for(:each_number).lazy.take(@limit).to_a
  end

  private

  def each_number
    b, a = @initial_values[:first], @initial_values[:second]
    loop do
      yield b
      a, b = a + b, a
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    first_n = RationalSequence.new(n).to_a
    second_group = second_group(first_n)
    first_group = first_n - second_group
    product(first_group) / product(second_group)
  end

  def aimless(n)
    first_n = PrimeSequence.new(n).to_a
    array_rationals = make_pairs(first_n).map {|x| Rational(x[0], x[1])}
    sum_rationals(array_rationals)
  end

  def worthless(n)
    fibonacci_n = FibonacciSequence.new(n).to_a.last
    first_n_rationals = RationalSequence.new(n).to_a
    biggest_slice(fibonacci_n, first_n_rationals)
  end

  def sum_rationals(rationals)
    rationals.reduce{|sum, x| sum + x}
  end

  def biggest_slice(number, rationals)
    while sum_rationals(rationals) > number
      rationals = rationals - [rationals.last]
    end
    rationals
  end

  def split(first_n, equal_to)
    s = []
    first_n.each_index {|x| s << first_n[x] if x % 2 == equal_to }
    s
  end

  def make_pairs(first_n)
    first_group = split(first_n, 0)
    second_group = split(first_n, 1)
    first_group.zip(second_group)
  end

  def product(group)
    group.reduce{|sum, x| sum * x}
  end

  def second_group(first_n)
    first_n.select { |x| !prime?(x.numerator) && !prime?(x.denominator) }
  end

  def prime?(n)
    return false if n < 2
    (2..n/2).none? {|i| n % i == 0}
  end
end
