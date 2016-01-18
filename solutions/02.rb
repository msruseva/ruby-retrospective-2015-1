def move(snake, direction)
  snake_new = snake[1..-1]
  grow(snake_new, direction)
end

def grow(snake, direction)
  snake_new = snake.dup
  head = new_head(snake, direction)
  snake_new.push(head)
end
