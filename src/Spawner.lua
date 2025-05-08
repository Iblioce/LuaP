local Spawner = {}
Spawner.__index = Spawner

function Spawner:new()
    local self = setmetatable({}, Spawner)
    self.spawners = {}
    self.spawner_count = 0
    return self
end

function Spawner:draw()
    for _, mob in ipairs(self.spawners) do
        mob:draw()
    end
end

function Spawner:update(dt, player)
    for _, mob in ipairs(self.spawners) do
        mob:update(dt)


        if Spawner:checkAABBCollision(mob, player) then
            player:take_damage(1, dt)
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
