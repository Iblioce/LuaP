local Weapon = require("weapons.Weapon")
local Orb = setmetatable({}, { __index = Weapon })
Orb.__index = Orb

function Orb:new(player)
    local self = setmetatable(Weapon:new(player, "Orb"), Orb)
    self.projectiles = {}
    self.sprite = love.graphics.newImage("src/res/sprites/orbEye.png")
    self.scale = 1.5
    self.split_unlocked = false
    return self
end

function Orb:update(dt)
    Weapon.update(self, dt)
    if self:canFire() then
        self:fire()
    end

    for i = #self.projectiles, 1, -1 do
        local p = self.projectiles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.lifetime = p.lifetime + dt
        local maxDistance = 1000
        if p.lifetime >= 10 or math.abs(p.x - self.player.x) > maxDistance or math.abs(p.y - self.player.y) > maxDistance then
            table.remove(self.projectiles, i)
        end
    end
end

function Orb:draw()
    for _, p in ipairs(self.projectiles) do
        love.graphics.draw(self.sprite, p.x, p.y, 0, self.scale/2, self.scale/2,
            self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
    end
end

function Orb:fire()
    Weapon.fire(self)

    local mx, my = camera:worldCoords(love.mouse.getX(), love.mouse.getY())

    local dx = mx - self.player.x
    local dy = my - self.player.y

    local length = math.sqrt(dx * dx + dy * dy)
    dx = dx / length
    dy = dy / length

    local speed = 250
    local vx = dx * speed
    local vy = dy * speed

    table.insert(self.projectiles, {
        x = self.player.x,
        y = self.player.y,
        vx = vx,
        vy = vy,
        lifetime = 0
    })
end

return Orb
