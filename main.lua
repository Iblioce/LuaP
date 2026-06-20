_G.love = require("love")

-- Add src/ to the module search path
love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";src/?.lua;src/?/init.lua")

local PlayerClass = require("Player")
local player
local BackgroundClass = require("Background")
local background
local SpawnerClass = require("Spawner")
local spawner
local Upgrades = require("Upgrades")

local gameState = "playing" -- "playing", "levelup", "paused", "paused_upgrades"
local current_upgrades = {}
local base_width = 800
local base_height = 600
local global_scale = 1

_G.bopSound = nil

function love.load()
    -- Generate synthetic "bop" sound for EXP pickup
    local sampleRate = 44100
    local length = 0.08 -- 80ms
    local samples = math.floor(sampleRate * length)
    local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
    for i = 0, samples - 1 do
        local t = i / sampleRate
        local freq = 600 + 800 * (t / length)
        local amplitude = math.exp(-t * 20) * 0.5
        local sample = math.sin(t * freq * math.pi * 2) * amplitude
        soundData:setSample(i, sample)
    end
    _G.bopSound = love.audio.newSource(soundData)

    camera = require("libs.camera")
    camera = camera()
    player = PlayerClass:new()
    background = BackgroundClass:new()
    spawner = SpawnerClass:new()
end

function love.update(dt)
    -- Update scale calculations dynamically
    local scale_x = love.graphics.getWidth() / base_width
    local scale_y = love.graphics.getHeight() / base_height
    global_scale = math.min(scale_x, scale_y)

    if gameState == "playing" then
        player:update(dt)
        camera:lookAt(player.x, player.y)
        spawner:update(dt, player)
        if spawner.spawner_count < 10 then
            spawner:spawn_mob(require("mobs.Zombie"), player.x + math.random(-500, 500),
                player.y + math.random(-500, 500))
        end

        if player.pending_level_ups > 0 then
            gameState = "levelup"
            current_upgrades = Upgrades.getRandomUpgrades(3, player)
        end
    end
end

function love.draw()
    -- DRAW GAME WORLD
    camera:attach()
    background:draw()
    player:draw()
    spawner:draw()
    camera:detach()

    -- DRAW UI / HUD
    love.graphics.push()
    love.graphics.scale(global_scale, global_scale)

    -- The virtual screen size for UI placement
    local virtual_w = love.graphics.getWidth() / global_scale
    local virtual_h = love.graphics.getHeight() / global_scale

    player:drawHUD()

    if gameState == "levelup" then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, virtual_w, virtual_h)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("LEVEL UP! Choose an upgrade", 0, virtual_h * 0.15, virtual_w, "center")
        
        local box_width = 200
        local box_height = 300
        local spacing = 40
        local total_width = (box_width * 3) + (spacing * 2)
        local start_x = (virtual_w - total_width) / 2
        local start_y = (virtual_h - box_height) / 2
        
        for i, upgrade in ipairs(current_upgrades) do
            local x = start_x + (i - 1) * (box_width + spacing)
            local y = start_y
            
            love.graphics.setColor(0.15, 0.15, 0.15, 1)
            love.graphics.rectangle("fill", x, y, box_width, box_height, 10, 10)
            love.graphics.setColor(0.8, 0.8, 0.8, 1)
            love.graphics.rectangle("line", x, y, box_width, box_height, 10, 10)
            
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(i .. ". " .. upgrade.name, x, y + 20, box_width, "center")
            love.graphics.printf(upgrade.description, x + 10, y + 80, box_width - 20, "center")
        end
    end

    if gameState == "paused" then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, virtual_w, virtual_h)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("PAUSED", 0, virtual_h * 0.2, virtual_w, "center")
        
        local button_w = 300
        local button_h = 50
        local start_x = (virtual_w - button_w) / 2
        
        local options = {
            { text = "Resume", y = virtual_h * 0.4 },
            { text = "View Upgrades", y = virtual_h * 0.5 },
            { text = "Toggle Fullscreen", y = virtual_h * 0.6 },
            { text = "Quit", y = virtual_h * 0.7 }
        }
        
        local mx, my = love.mouse.getPosition()
        local vx, vy = mx / global_scale, my / global_scale
        
        for _, btn in ipairs(options) do
            if vx >= start_x and vx <= start_x + button_w and vy >= btn.y and vy <= btn.y + button_h then
                love.graphics.setColor(0.3, 0.3, 0.3, 1)
            else
                love.graphics.setColor(0.15, 0.15, 0.15, 1)
            end
            
            love.graphics.rectangle("fill", start_x, btn.y, button_w, button_h, 5, 5)
            love.graphics.setColor(0.8, 0.8, 0.8, 1)
            love.graphics.rectangle("line", start_x, btn.y, button_w, button_h, 5, 5)
            
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(btn.text, start_x, btn.y + 18, button_w, "center")
        end
    end

    if gameState == "paused_upgrades" then
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill", 0, 0, virtual_w, virtual_h)
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("YOUR UPGRADES", 0, virtual_h * 0.1, virtual_w, "center")
        
        local y = virtual_h * 0.25
        player.upgrades = player.upgrades or {}
        for name, count in pairs(player.upgrades) do
            love.graphics.printf(name .. " x" .. count, 0, y, virtual_w, "center")
            y = y + 30
            has_upgrades = true
        end
        if not has_upgrades then
            love.graphics.printf("No upgrades taken yet.", 0, y, virtual_w, "center")
        end
        
        local btn_w = 200
        local btn_h = 40
        local btn_x = (virtual_w - btn_w) / 2
        local btn_y = virtual_h * 0.85
        
        local mx, my = love.mouse.getPosition()
        local vx, vy = mx / global_scale, my / global_scale
        if vx >= btn_x and vx <= btn_x + btn_w and vy >= btn_y and vy <= btn_y + btn_h then
            love.graphics.setColor(0.3, 0.3, 0.3, 1)
        else
            love.graphics.setColor(0.15, 0.15, 0.15, 1)
        end
        love.graphics.rectangle("fill", btn_x, btn_y, btn_w, btn_h, 5, 5)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("line", btn_x, btn_y, btn_w, btn_h, 5, 5)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Go Back", btn_x, btn_y + 12, btn_w, "center")
    end

    love.graphics.pop()
end

local function applyUpgrade(choice)
    if current_upgrades[choice] then
        local upg = current_upgrades[choice]
        upg.apply(player)
        player.upgrades = player.upgrades or {}
        player.upgrades[upg.name] = (player.upgrades[upg.name] or 0) + 1
        
        player.level = player.level + 1
        player.pending_level_ups = player.pending_level_ups - 1
        
        if player.pending_level_ups > 0 then
            current_upgrades = Upgrades.getRandomUpgrades(3, player)
        else
            gameState = "playing"
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        if gameState == "playing" then
            gameState = "paused"
        elseif gameState == "paused" then
            gameState = "playing"
        elseif gameState == "paused_upgrades" then
            gameState = "paused"
        end
    end

    -- Keep keyboard shortcuts as fallback
    if gameState == "paused" then
        if key == "f" then love.window.setFullscreen(not love.window.getFullscreen()) end
        if key == "q" then love.event.quit() end
        if key == "u" then gameState = "paused_upgrades" end
    elseif gameState == "paused_upgrades" then
        if key == "u" then gameState = "paused" end
    end

    if gameState == "levelup" then
        if key == "1" then applyUpgrade(1) end
        if key == "2" then applyUpgrade(2) end
        if key == "3" then applyUpgrade(3) end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local vx = x / global_scale
        local vy = y / global_scale
        local virtual_w = love.graphics.getWidth() / global_scale
        local virtual_h = love.graphics.getHeight() / global_scale

        if gameState == "levelup" then
            local box_width = 200
            local box_height = 300
            local spacing = 40
            local total_width = (box_width * 3) + (spacing * 2)
            local start_x = (virtual_w - total_width) / 2
            local start_y = (virtual_h - box_height) / 2
            
            for i = 1, #current_upgrades do
                local box_x = start_x + (i - 1) * (box_width + spacing)
                local box_y = start_y
                if vx >= box_x and vx <= box_x + box_width and vy >= box_y and vy <= box_y + box_height then
                    applyUpgrade(i)
                    break
                end
            end
        elseif gameState == "paused" then
            local button_w = 300
            local button_h = 50
            local start_x = (virtual_w - button_w) / 2
            
            local options = {
                { action = "resume", y = virtual_h * 0.4 },
                { action = "upgrades", y = virtual_h * 0.5 },
                { action = "fullscreen", y = virtual_h * 0.6 },
                { action = "quit", y = virtual_h * 0.7 }
            }
            
            for _, btn in ipairs(options) do
                if vx >= start_x and vx <= start_x + button_w and vy >= btn.y and vy <= btn.y + button_h then
                    if btn.action == "resume" then gameState = "playing" end
                    if btn.action == "upgrades" then gameState = "paused_upgrades" end
                    if btn.action == "fullscreen" then love.window.setFullscreen(not love.window.getFullscreen()) end
                    if btn.action == "quit" then love.event.quit() end
                    break
                end
            end
        elseif gameState == "paused_upgrades" then
            local btn_w = 200
            local btn_h = 40
            local btn_x = (virtual_w - btn_w) / 2
            local btn_y = virtual_h * 0.85
            
            if vx >= btn_x and vx <= btn_x + btn_w and vy >= btn_y and vy <= btn_y + btn_h then
                gameState = "paused"
            end
        end
    end
end
