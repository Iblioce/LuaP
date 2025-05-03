-- Background
local Background = {}
Background.__index = Background
love.graphics.setDefaultFilter("nearest", "nearest")

function Background:new()
    local self = setmetatable({}, Background)
    self.x = 0
    self.y = 0
    self.sprite = love.graphics.newImage("res/maps/backGround.png")
    return self
end

function Background:draw()
    love.graphics.draw(self.sprite, self.x, self.y, 0, love.graphics.getWidth() / self.sprite:getWidth(),
        love.graphics.getHeight() / self.sprite:getHeight())
end

return Background
