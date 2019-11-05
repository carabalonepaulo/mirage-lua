return function(player_index, character)
  return {
    index = player_index,
    name = character.name,
    color = character.color,
    position = {
      x = character.position.x,
      y = character.position.y
    }
  }
end