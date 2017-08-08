class SpaceShip

  FRICTION       = 0.9
  ACCELERATION   = 0.6
  ROTATION_SPEED = 5
  SHOOT_COOLDOWN = 10
  BULLET_SPEED   = 12

  attr_reader :x, :y, :direction, :radius, :bullets, :hitpoints
  attr_writer :hitpoints

  def initialize window
    @window = window
    @x, @y, @z = 0.5 * @window.width, 0.9 * @window.height, 1
    @vx = @vy = 0
    @direction = 0
    @radius = 20
    @bullets = []
    @hitpoints = 3
  end

  def draw
    curr_image.draw_rot(@x, @y, @z, @direction)
  end

  def curr_image
    Gosu::Image.new("images/ship-#{self.moving? ? 'moving' : 'stationary'}.png")
  end

  def accelerate
    @vx += Gosu.offset_x(@direction, ACCELERATION)
    @vy += Gosu.offset_y(@direction, ACCELERATION)
  end

  def move
    @x = (@x + @vx + @window.width) % @window.width
    @y = (@y + @vy + @window.height) % @window.height
    @vx *= FRICTION
    @vy *= FRICTION
  end

  def moving?
    @vx.abs > 0.1 || @vy.abs > 0.1
  end

  def turn_left
    @direction -= ROTATION_SPEED
  end

  def turn_right
    @direction += ROTATION_SPEED
  end

  def shoot
    @bullets << Bullet.new(:green, @x, @y, @direction, BULLET_SPEED, @window) unless on_cooldown?
  end

  def on_cooldown?
    @window.frames % SHOOT_COOLDOWN != 0
  end

end
