def move(snake, direction)
  snake.drop(1) << head(snake, direction)
end

def grow(snake, direction)
  snake.clone << head(snake, direction)
end

def new_food(food, snake, dimensions)
  new_position_food = [rand(dimensions[:width]), rand(dimensions[:height])]
  if food.include?(new_position_food) || snake.include?(new_position_food)
    return new_food(food, snake, dimensions)
  end
  new_position_food
end

def obstacle_ahead?(snake, direction, dimensions)
  head = head(snake, direction)
  snake.include?(head) || is_on_frame(head, dimensions) || head.include?(-1)
end

def danger?(snake, direction, dimensions)
  next_1_move = obstacle_ahead?(snake, direction, dimensions)
  next_2_move = obstacle_ahead?(grow(snake, direction), direction,dimensions)
  next_1_move || next_2_move
end

private

def is_on_frame(head, dimensions)
  head[0] == dimensions[:width] || head[1] == dimensions[:height]
end

def head(snake, direction)
  snake.last.zip(direction).map {|head| head[0] + head[1]}
end
