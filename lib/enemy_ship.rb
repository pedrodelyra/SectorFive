class EnemyShip

  ROTATION_SPEED = 3
  ACCELERATION   = 0.2
  FRICTION       = 0.9
  SHOOT_COOLDOWN = 60
  BULLET_SPEED   = 6

  attr_reader :x, :y, :direction, :radius, :bullets

  def initialize window
    @window = window
    @radius = 20
    @x, @y, @z = rand(@window.width - 2 * @radius) + @radius, rand(@window.height - 2 * @radius) + @radius, 1
    @vx = @vy = 0
    @direction = rand(360)
    @bullets = []
    @image = Gosu::Image.new('images/enemy-ship.png')
    @recent_directions = []
  end

  def draw
    @image.draw_rot(@x, @y, @z, @direction)
  end

  def accelerate
    @vx += Gosu.offset_x(@direction, ACCELERATION)
    @vy += Gosu.offset_y(@direction, ACCELERATION)
  end

  def follow player_ship
    turn_right if Gosu::Physics.cross_product(self, player_ship) > +Gosu::Physics::EPS
    turn_left  if Gosu::Physics.cross_product(self, player_ship) < -Gosu::Physics::EPS
    accelerate
    @x += @vx
    @y += @vy

    @vx *= FRICTION
    @vy *= FRICTION
  end

  def turn_left
    @direction -= ROTATION_SPEED
  end

  def turn_right
    @direction += ROTATION_SPEED
  end

  def stabilized?
    @recent_directions << @direction
    @recent_directions.shift if @recent_directions.size > 10
    @recent_directions.standard_deviation < Gosu::Physics::EPS
  end

  def shoot
    @bullets << Bullet.new(:red, @x, @y, @direction, BULLET_SPEED, @window) unless on_cooldown?
  end

  def on_cooldown?
    @window.frames % SHOOT_COOLDOWN != 0
  end

end
