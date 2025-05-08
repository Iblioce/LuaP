anim8 = require("libs/anim8")
love.graphics.setDefaultFilter("nearest", "nearest")

local Player = {}
Player.__index = Player

function Player:new()
    local self = setmetatable({}, Player)
    self.direction = "up"
    self.health = 3
    self.invincible = false
    self.invincible_timer = 0
    self.x = 0
    self.y = 0
    self.speed = 5
    self.spriteSheet = love.graphics.newImage("res/sprites/pigMoving.png")
    self.grid = anim8.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animation = {}
    self.animation.left = anim8.newAnimation(self.grid("1-4", 1), 0.2)
    self.animation.right = anim8.newAnimation(self.grid("1-4", 2), 0.2)

    self.width = 16 * 5
    self.height = 16 * 5
    return self
end

function Player:update(dt)
    self:move(dt)
    if self.invincible then
        self.invincible_timer = self.invincible_timer - dt
        if self.invincible_timer <= 0 then
            self.invincible = false
            self.invincible_timer = 0
        end
    end
end

function Player:take_damage(amount)
    if (self.invincible) then
        return
    end
    self.health = self.health - amount
    self.invincible = true
    self.invincible_timer = 1
end

function Player:move(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown("z") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("q") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end
    if dx ~= 0 or dy ~= 0 then
        local length = math.sqrt(dx * dx + dy * dy)
        dx = dx / length
        dy = dy / length
    end

    self.x = self.x + dx * self.speed
    self.y = self.y + dy * self.speed
    if dx < 0 then
        self.animation.left:update(dt)
        self.direction = "left"
    elseif dx > 0 then
        self.animation.right:update(dt)
        self.direction = "right"
    end
end

function Player:draw()
    if self.invincible then
        love.graphics.setColor(125, 64, 0)
    end
    if self.direction == "left" then
        self.animation.left:draw(self.spriteSheet, self.x, self.y, nil, 5, nil, 8, 8)
    else
        self.animation.right:draw(self.spriteSheet, self.x, self.y, nil, 5, nil, 8, 8)
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Health: " .. self.health, self.x - love.graphics.getWidth() / 2,
        self.y - love.graphics.getHeight() / 2)
end

return Player
