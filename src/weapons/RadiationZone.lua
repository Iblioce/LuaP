local Weapon = require("weapons.Weapon")
local RadiationZone = setmetatable({}, { __index = Weapon })
RadiationZone.__index = RadiationZone
