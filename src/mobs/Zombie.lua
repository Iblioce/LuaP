love.graphics.setDefaultFilter("nearest", "nearest")

local Zombie = {}
Zombie.__index = Zombie

function Zombie:new()
    local self = setmetatable({}, Zombie)
    self.x = nil
    self.y = nil
    self.speed = 2
    self.sprite = love.graphics.newImage("res/sprites/cake.png")
    self.width = self.sprite:getWidth() * 1.5  
    self.height = self.sprite:getHeight() * 1.5  
    return self
end

function Zombie:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, 1.5, nil, 8, 8)
end

function Zombie:update(dt)
    -- self:move(dt)
end

function Zombie:move(dt)    
    local dx, dy = 0, 0

    if dx ~= 0 or dy ~= 0 then
        local length = math.sqrt(dx * dx + dy * dy)
        dx = dx / length
        dy = dy / length
    end

    self.x = self.x + dx * self.speed
    self.y = self.y + dy * self.speed
end

return Zombie