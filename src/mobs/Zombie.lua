love.graphics.setDefaultFilter("nearest", "nearest")

local Zombie = {}
Zombie.__index = Zombie

function Zombie:new()
    local self = setmetatable({}, Zombie)
    self.x = nil
    self.y = nil
    self.health = 1
    self.speed = 2
    self.exp_drop = 5
    self.sprite = love.graphics.newImage("src/res/sprites/cake.png")
    self.width = self.sprite:getWidth() * 1.5
    self.height = self.sprite:getHeight() * 1.5
    return self
end

function Zombie:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, 1.5, nil, 8, 8)
end

function Zombie:update(dt, player)
    self:move(dt, player)
end

function Zombie:move(dt, player)
    if not player then return end
    local dx = player.x - self.x
    local dy = player.y - self.y

    if dx ~= 0 or dy ~= 0 then
        local length = math.sqrt(dx * dx + dy * dy)
        dx = dx / length
        dy = dy / length
    end

    self.x = self.x + dx * self.speed
    self.y = self.y + dy * self.speed
end

return Zombie
