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
            player:take_damage(1)
        end
    end
end

function Spawner:checkAABBCollision(a, b)
    return a.x < b.x + b.width and
        a.x + a.width > b.x and
        a.y < b.y + b.height and
        a.y + a.height > b.y
end

function Spawner:spawn_mob(mob_class, x, y)
    local mob = mob_class:new()
    mob.x = x
    mob.y = y
    table.insert(self.spawners, mob)
    self.spawner_count = self.spawner_count + 1
end

return Spawner
