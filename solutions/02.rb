def move(snake, direction)
  snake_new = snake[1..-1]
  grow(snake_new, direction)
end

def grow(snake, direction)
  snake_new = snake.dup
  head = new_head(snake, direction)
  snake_new.push(head)
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
