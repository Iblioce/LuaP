-- Player.lua
anim8 = require("libs/anim8")
love.graphics.setDefaultFilter("nearest", "nearest")

local Player = {}
Player.__index = Player

function Player:new()
    local self = setmetatable({}, Player)
    self.x = 0
    self.y = 0
    self.speed = 5
    self.sprite = love.graphics.newImage("res/sprites/cake.png")
    self.spriteSheet = love.graphics.newImage("res/sprites/pigRight.png")
    self.grid = anim8.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animation = {}
    self.animation.right = anim8.newAnimation(self.grid("1-4", 1), 0.2)
    return self
end

function Player:update(dt)
    if love.keyboard.isDown("z") then self.y = self.y - self.speed end
    if love.keyboard.isDown("s") then self.y = self.y + self.speed end
    if love.keyboard.isDown("q") then self.x = self.x - self.speed end
    if love.keyboard.isDown("d") then self.x = self.x + self.speed end
    self.animation.right:update(dt)
end

function Player:draw()
    self.animation.right:draw(self.spriteSheet, self.x, self.y, nil, 10)
end

return Player
