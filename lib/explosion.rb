class Explosion

  NUM_IMAGES       = 16
  FRAMES_PER_IMAGE = 2

  attr_reader :x, :y, :radius

  def initialize x, y, window
    @x, @y = x, y
    @radius = 30
    @images = Gosu::Image.load_tiles('images/explosion.png', 60, 60)
    @window = window
  end

  def draw
    curr_image = @images.shift if @window.frames % FRAMES_PER_IMAGE == 0
    curr_image&.draw(@x, @y, 1)
  end

  def finished?
    @images.empty?
  end

end
