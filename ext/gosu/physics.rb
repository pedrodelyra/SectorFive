module Gosu
  class Physics

    EPS = 1e-6

    def self.cross_product game_obj1, game_obj2
      a, b = Gosu.offset_x(game_obj1.direction, 1), Gosu.offset_y(game_obj1.direction, 1)
      c, d = game_obj2.x - game_obj1.x, game_obj2.y - game_obj1.y
      a * d - b * c
    end

  end
end
