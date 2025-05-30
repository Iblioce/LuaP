local Mob = {}
Mob.__index = Mob

function Mob:new()
    local self = setmetatable({}, Mob)

    self.x = nil
    self.y = nil
    self.health = nil
    self.speed = nil
    self.sprite = nil
    self.width = nil
    self.height = nil

    return self
end

function Mob:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, 1.5, nil, 8, 8)
end

return Mob
