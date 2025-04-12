_G.love = require("love")

local PlayerClass = require("Player")
local player
local BackgroundClass = require("Background")
local background

function love.load()
    player = PlayerClass:new()
    background = BackgroundClass:new()
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    background:draw()
    player:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
end
