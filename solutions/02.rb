require 'matrix'

def move(snake, direction)
  snake.drop(1) << head(snake, direction)
end

def grow(snake, direction)
  snake.clone << head(snake, direction)
end

def new_food(food, snake, dimensions)
  width, height = dimensions[:width], dimensions[:height]
  board = Matrix.build(width, height) { |row, col| [row, col]}
  possible_food = board.each.to_a - food - snake
  possible_food.sample
end

def obstacle_ahead?(snake, direction, dimensions)
  head = head(snake, direction)
  snake.member?(head) || !in_board(head, dimensions)
end

def danger?(snake, direction, dimensions)
  next_1_move = obstacle_ahead?(snake, direction, dimensions)
  next_2_move = obstacle_ahead?(grow(snake, direction), direction, dimensions)
  next_1_move || next_2_move
end

private

def in_board(head, dimensions)
  (0..dimensions[:width] - 1).member?(head[0]) &&
    (0..dimensions[:height] - 1).member?(head[1])
end

def head(snake, direction)
  snake.last.zip(direction).map {|head| head[0] + head[1]}
end
