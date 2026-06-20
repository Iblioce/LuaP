local Upgrades = {}

Upgrades.list = {
    {
        name = "Light Boots",
        description = "+1 Movement Speed",
        apply = function(player)
            player.speed = player.speed + 1
        end
    },
    {
        name = "Iron Heart",
        description = "+ 5% Max HP",
        apply = function(player)
            player.max_health = player.max_health * 1.05
            player.health = player.health * 1.05
        end
    },
    {
        name = "Quick Heal",
        description = "Heal 40% of Max HP",
        condition = function(player)
            return player.health < player.max_health
        end,
        apply = function(player)
            player.health = math.min(player.health + (player.max_health * 0.4), player.max_health)
        end
    },
    {
        name = "Massive Orb",
        description = "Increase Orb size by 5% and level up Orb",
        requireWeapon = "Orb",
        apply = function(player)
            for _, weapon in ipairs(player.weapons) do
                if weapon.name == "Orb" then
                    weapon.scale = weapon.scale + weapon.scale * 0.05
                    weapon.level = weapon.level + 1
                end
            end
        end
    },
    {
        name = "Fire Rate",
        description = "Reduce weapon cooldown by 5%",
        apply = function(player)
            for _, weapon in ipairs(player.weapons) do
                if weapon.cooldown then
                    weapon.cooldown = math.max(0.1, weapon.cooldown - weapon.cooldown * 0.05) 
                end
            end
        end
    },
    {
        name = "Orb Splitter",
        description = "Orb projectiles split in two upon hitting an enemy",
        requireWeapon = "Orb",
        requireLevel = 10,
        apply = function(player)
            for _, weapon in ipairs(player.weapons) do
                if weapon.name == "Orb" then
                    weapon.split_unlocked = true
                end
            end
        end
    }
}

function Upgrades.getRandomUpgrades(count, player)
    local selected = {}
    local pool = {}
    local unique_count = 0
    
    for i, upgrade in ipairs(Upgrades.list) do
        local canAdd = true
        
        if upgrade.condition and not upgrade.condition(player) then
            canAdd = false
        end
        
        if upgrade.requireWeapon then
            local hasWeapon = false
            local weaponLevel = 0
            local hasUltimate = false
            for _, w in ipairs(player.weapons) do
                if w.name == upgrade.requireWeapon then
                    hasWeapon = true
                    weaponLevel = w.level
                    if w.split_unlocked then
                        hasUltimate = true
                    end
                    break
                end
            end
            
            if not hasWeapon then 
                canAdd = false 
            end
            
            if hasUltimate then
                canAdd = false
            end
            
            if upgrade.requireLevel and weaponLevel < upgrade.requireLevel then 
                canAdd = false 
            end
        end
        
        if canAdd then
            local weight = 1
            if player.upgrades and player.upgrades[upgrade.name] then
                -- Augment probability if already taken
                weight = weight + (player.upgrades[upgrade.name] * 3)
            end
            for _ = 1, weight do
                table.insert(pool, upgrade)
            end
            unique_count = unique_count + 1
        end
    end
    
    local amount = math.min(count, unique_count)
    for i = 1, amount do
        if #pool == 0 then break end
        
        local randIndex = math.random(1, #pool)
        local selectedUpgrade = pool[randIndex]
        table.insert(selected, selectedUpgrade)
        
        -- Remove all instances of the selected upgrade to avoid duplicates in the choices
        for j = #pool, 1, -1 do
            if pool[j].name == selectedUpgrade.name then
                table.remove(pool, j)
            end
        end
    end
    
    return selected
end

return Upgrades
