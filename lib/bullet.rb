class Bullet

  attr_reader :x, :y, :direction, :radius

  def initialize color, x, y, direction, speed, window
    @window = window
    @x, @y, @z = x, y, 0
    @direction = direction
    @radius = 3
    @image = Gosu::Image.new("images/#{color}-bullet.png")
    @speed = speed
  end

  def draw
    @image.draw_rot(@x, @y, @z, @direction)
  end

  def move
    @x += Gosu.offset_x(@direction, @speed)
    @y += Gosu.offset_y(@direction, @speed)
  end

  def on_screen?
    (0 <= x and x <= @window.width) and (0 <= y and y <= @window.height)
  end

end
