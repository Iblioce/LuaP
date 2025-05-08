_G.love = require("love")

local PlayerClass = require("src.Player")
local player
local BackgroundClass = require("src.Background")
local background

function love.load()
    camera = require("libs.camera")
    camera = camera()
    player = PlayerClass:new()
    background = BackgroundClass:new()
end

function love.update(dt)
    player:update(dt)
    camera:lookAt(player.x, player.y)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("f") then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
end

function love.draw()
    camera:attach()
    background:draw()
    player:draw()
    camera:detach()
end

function love.mousepressed(x, y, button, istouch, presses)
end
