_G.love = require("love")

-- Ajout de src/ dans le chemin de recherche des modules
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";src/?.lua;src/?/init.lua")

local PlayerClass = require("Player")
local player
local BackgroundClass = require("Background")
local background
local SpawnerClass = require("Spawner")
local spawner

function love.load()
    camera = require("libs.camera")
    camera = camera()
    player = PlayerClass:new()
    background = BackgroundClass:new()
    spawner = SpawnerClass:new()
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
    spawner:update(dt, player)
    if spawner.spawner_count < 10 then
        spawner:spawn_mob(require("mobs.Zombie"), player.x + math.random(-500, 500),
            player.y + math.random(-500, 500))
    end
end

function love.draw()
    camera:attach()
    background:draw()
    player:draw()
    spawner:draw()
    camera:detach()
end

function love.mousepressed(x, y, button, istouch, presses)
end
