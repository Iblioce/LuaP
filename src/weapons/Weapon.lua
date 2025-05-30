local Weapon = {}
Weapon.__index = Weapon

function Weapon:new(player)
    local self = setmetatable({}, Weapon)
    self.player = player
    self.cooldown = 1
    self.cooldown_timer = 0
    return self
end

function Weapon:update(dt)
    self.cooldown_timer = self.cooldown_timer - dt
end

function Weapon:canFire()
    return self.cooldown_timer <= 0
end

function Weapon:fire()
    self.cooldown_timer = self.cooldown
end

return Weapon
