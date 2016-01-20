def move(snake, direction)
  grow(snake, direction).drop(1)
end

def grow(snake, direction)
  snake + [new_head(snake_head(snake), direction)]
end

def snake_head(snake)
  snake[-1]
end

def new_head(head, direction)
  [head[0] + direction[0], head[1] + direction[1]]
end

def new_food(food, snake, dimensions)
  position = new_position(dimensions)
  while snake.include?(position) or food.include?(position) do
    position = new_position(dimensions)
  end
  position
end

def new_position(dimensions)
  xs = rand(dimensions[:width])
  ys = rand(dimensions[:height])
  [xs, ys]
end

def obstacle_ahead?(snake, direction, dimensions)
  head = new_head(snake_head(snake), direction)
  snake.include?(head) or wall?(head, dimensions)
end

def wall?(position, dimensions)
  return true if position[0] < 0
  return true if position[0] >= dimensions[:width]
  return true if position[1] < 0
  return true if position[1] >= dimensions[:height]
  return false
end

def danger?(snake, direction, dimensions)
  return true if obstacle_ahead?(snake, direction, dimensions)
  next_turn = move(snake, direction)
  obstacle_ahead?(next_turn, direction, dimensions)
end

def new_head(snake, direction)
  old_head = snake[-1]
  [old_head[0] + direction[0], old_head[1] + direction[1]]
end

def new_food(food, snake, dimensions)
  field = new_field(dimensions)
  while snake.include?(field) or food.include?(field) do
    field = new_field(dimensions)
  end
  field
end

def new_field(dimensions)
  xs = rand(dimensions[:width])
  ys = rand(dimensions[:height])
  [xs, ys]
end

def obstacle_ahead?(snake, direction, dimensions)
  head = new_head(snake, direction)
  snake.include?(head) or wall?(head, dimensions)
end

def wall?(head, dimensions)
  return true if head[0] < 0
  return true if head[0] >= dimensions[:width]
  return true if head[1] < 0
  return true if head[1] >= dimensions[:height]
  return false
end

def danger?(snake, direction, dimensions)
  return true if obstacle_ahead?(snake, direction, dimensions)
  next_turn = move(snake, direction)
  obstacle_ahead?(next_turn, direction, dimensions)
end
