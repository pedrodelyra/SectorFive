class SectorFive < Gosu::Window

  WIDTH                 = 800
  HEIGHT                = 600
  ENEMY_RESPAWN         = 120
  MAX_NUMBER_OF_ENEMIES = 6

  attr_reader :frames

  def initialize
    super(WIDTH, HEIGHT)
    caption = "Sector Five"
    initialize_game
  end

  def draw
    @main_ship.draw unless game_over?
    @main_ship.bullets.each { |bullet| bullet.draw }

    @main_ship.hitpoints.times { |i| @heart.draw(700 + 30 * i, 10, 2) }

    @enemies.each do |enemy|
      enemy.draw
      enemy.bullets.each { |bullet| bullet.draw }
    end

    @explosions.each { |explosion| explosion.draw }

    @score.draw

    @game_over_message.draw(game_over_message, 0.05 * WIDTH, 250, 2) if game_over?
  end

  def update
    if game_over?
      initialize_game if button_down? Gosu::KbSpace
    else
      update_main_ship
      update_enemies_ships
    end
    detect_collisions
    @frames += 1
  end

  private

    def initialize_game
      @main_ship = SpaceShip.new self
      @enemies = [EnemyShip.new(self)]
      @explosions = []
      @score = Score.new 10, 10
      @frames = 0
      @heart = Gosu::Image.new('images/heart.png')
      @game_over = false
      @game_over_message = Gosu::Font.new(30)
    end

    def update_main_ship
      @main_ship.turn_left  if button_down? Gosu::KbLeft
      @main_ship.turn_right if button_down? Gosu::KbRight
      @main_ship.accelerate if button_down? Gosu::KbUp
      @main_ship.shoot      if button_down? Gosu::KbZ
      @main_ship.move

      @main_ship.bullets.each    { |bullet| bullet.move }
      @main_ship.bullets.reject! { |bullet| not bullet.on_screen? }
    end

    def update_enemies_ships
      @enemies << EnemyShip.new(self) if @frames % ENEMY_RESPAWN == 0 && @enemies.size < MAX_NUMBER_OF_ENEMIES

      @enemies.each do |enemy|
        enemy.follow(@main_ship)
        enemy.shoot if !game_over? && (enemy.stabilized? || rand < 0.1)

        enemy.bullets.each    { |bullet| bullet.move }
        enemy.bullets.reject! { |bullet| not bullet.on_screen? }
      end
    end

    def detect_collisions
      @enemies.dup.each do |enemy|
        if Gosu.distance(enemy.x, enemy.y, @main_ship.x, @main_ship.y) < enemy.radius + @main_ship.radius
          @explosions << Explosion.new(@main_ship.x, @main_ship.y, self)
          @enemies.delete enemy
          @main_ship.hitpoints = 0
          @game_over = true if @main_ship.hitpoints == 0
        end
        enemy.bullets.dup.each do |bullet|
          if Gosu.distance(bullet.x, bullet.y, @main_ship.x, @main_ship.y) < bullet.radius + @main_ship.radius
            @explosions << Explosion.new(@main_ship.x, @main_ship.y, self)
            enemy.bullets.delete bullet
            @main_ship.hitpoints -= 1
            @game_over = true if @main_ship.hitpoints == 0
          end
        end

        @main_ship.bullets.dup.each do |bullet|
          if Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y) < enemy.radius + bullet.radius
            @enemies.delete enemy
            @main_ship.bullets.delete bullet
            @explosions << Explosion.new(enemy.x, enemy.y, self)
            @score.add 10
          end
        end
      end

      @explosions.each do |explosion|
        @enemies.dup.each do |enemy|
          if Gosu.distance(enemy.x, enemy.y, explosion.x, explosion.y) < enemy.radius + explosion.radius
            @enemies.delete enemy
            @explosions << Explosion.new(enemy.x, enemy.y, self)
            @score.add 10
          end
        end
      end

      @explosions.reject! { |explosion| explosion.finished? }
    end

    def game_over?
      @game_over
    end

    def game_over_message
      "You scored #{@score} points! Press Space if you want to play again!"
    end
end
