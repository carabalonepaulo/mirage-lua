return function(player_index, character)
  return {
    index = player_index,
    character = {
      name = character.name,
      color = character.color,
      map_name = character.map.name,
      position = {
        x = character.position.x,
        y = character.position.y
      }
    }
  }
end