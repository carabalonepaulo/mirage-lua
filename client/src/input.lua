Input = {
  init = function(self)
    self.text = Stack()
  end,

  hasText = function(self)
    return self.text.count > 0
  end,

  getText = function(self)
    local text = table.concat(self.text._items)
    self.text:clear()
    return text
  end
}