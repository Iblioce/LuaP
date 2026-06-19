local ExpOrb = require("ExpOrb")

local Spawner = {}
Spawner.__index = Spawner

function Spawner:new()
    local self = setmetatable({}, Spawner)
    self.spawners = {}
    self.spawner_count = 0
    self.exp_orbs = {}
    return self
end

function Spawner:draw()
    for _, mob in ipairs(self.spawners) do
        mob:draw()
    end
    for _, orb in ipairs(self.exp_orbs) do
        orb:draw()
    end
end

function Spawner:update(dt, player)
    -- Mise à jour et collecte des orbes d'EXP
    for i = #self.exp_orbs, 1, -1 do
        local orb = self.exp_orbs[i]
        orb:update(dt)
        local dx = player.x - orb.x
        local dy = player.y - orb.y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < orb.collectRadius then
            player:gainExp(orb.value)
            table.remove(self.exp_orbs, i)
        end
    end

    -- Mise à jour des mobs
    for i = #self.spawners, 1, -1 do
        local mob = self.spawners[i]
        mob:update(dt, player)

        -- Collision mob -> joueur
        if self:checkAABBCollision(mob, player) then
            player:takeDamage(1)
        end

        -- Collision projectiles -> mob
        for _, weapon in ipairs(player.weapons) do
            for j = #weapon.projectiles, 1, -1 do
                local p = weapon.projectiles[j]
                local proj = { x = p.x, y = p.y, width = 16, height = 16 }
                if self:checkAABBCollision(mob, proj) then
                    mob.health = mob.health - 1
                    table.remove(weapon.projectiles, j)
                end
            end
        end

        -- Mort du mob : drop d'EXP + suppression
        if mob.health <= 0 then
            local orb = ExpOrb:new(mob.x, mob.y, mob.exp_drop or 1)
            table.insert(self.exp_orbs, orb)
            table.remove(self.spawners, i)
            self.spawner_count = self.spawner_count - 1
        end
    end
end

function Spawner:checkAABBCollision(a, b)
    return a.x - a.width / 2 < b.x + b.width / 2 and
        a.x + a.width / 2 > b.x - b.width / 2 and
        a.y - a.height / 2 < b.y + b.height / 2 and
        a.y + a.height / 2 > b.y - b.height / 2
end

function Spawner:spawn_mob(mob_class, x, y)
    local mob = mob_class:new()
    mob.x = x
    mob.y = y
    table.insert(self.spawners, mob)
    self.spawner_count = self.spawner_count + 1
end

return Spawner
