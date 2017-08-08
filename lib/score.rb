class Score

  attr_reader :score

  def initialize x, y
    @x, @y = x, y
    @score = 0
    @font = Gosu::Font.new 24
  end

  def draw
    @font.draw("Score: #{self}", @x, @y, 2)
  end

  def add points
    @score += points
  end

  def to_s
    @score.to_s
  end

end
