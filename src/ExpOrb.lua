local ExpOrb = {}
ExpOrb.__index = ExpOrb

function ExpOrb:new(x, y, value)
    local self = setmetatable({}, ExpOrb)
    self.x = x
    self.y = y
    self.value = value or 1
    self.collectRadius = 60 
    self.width = 12
    self.height = 12
    self.floatTimer = 0
    self.floatOffset = 0
    return self
end

function ExpOrb:update(dt)
    self.floatTimer = self.floatTimer + dt
    self.floatOffset = math.sin(self.floatTimer * 3) * 4
end

function ExpOrb:draw()
    -- Placeholder : cercle jaune 
    love.graphics.setColor(0.2, 1, 0.4, 0.9)
    love.graphics.circle("fill", self.x, self.y + self.floatOffset, 6)
    love.graphics.setColor(0.6, 1, 0.7, 0.5)
    love.graphics.circle("line", self.x, self.y + self.floatOffset, 9)
    love.graphics.setColor(1, 1, 1)
end

return ExpOrb
