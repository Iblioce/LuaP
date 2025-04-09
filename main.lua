_G.love = require("love")

local tick = require 'tick'

local Player = { x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2, scaleX = 1, scaleY = 1, width = 25, height = 25 }

local fps = 0

function love.load()
    love.window.setMode(1080, 720, { resizable = true, vsync = 0, minwidth = 1080, minheight = 720 })
    tick.framerate = 60          -- Limit framerate to 60 frames per second.
    tick.rate = .016666566666666 -- 1/60 seconds per tick.

    PlayerImage = love.graphics.newImage("res/cake.png")
    love.graphics.setBackgroundColor(1, 255, 1)

    local imgW, imgH = PlayerImage:getWidth(), PlayerImage:getHeight()
    Player.scaleX = Player.width / imgW
    Player.scaleY = Player.height / imgH
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(PlayerImage, Player.x, Player.y, 0, Player.scaleX, Player.scaleY, Player.width, Player.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(math.floor(fps), love.graphics.getWidth() - 20, 0)
end

function love.update(dt)
    local winW = love.graphics.getWidth()
    local winH = love.graphics.getHeight()

    local imgW = PlayerImage:getWidth()
    local imgH = PlayerImage:getHeight()

    -- L’image prendra toute la taille de la fenêtre
    Player.scaleX = (winW / imgW) * 0.04
    Player.scaleY = (winH / imgH) * 0.04

    if love.keyboard.isDown("s") then
        Player.y = Player.y + 100 * dt
    end
    if love.keyboard.isDown("z") then
        Player.y = Player.y - 100 * dt
    end
    if love.keyboard.isDown("q") then
        Player.x = Player.x - 100 * dt
    end
    if love.keyboard.isDown("d") then
        Player.x = Player.x + 100 * dt
    end

    fps = 1 / dt
end
