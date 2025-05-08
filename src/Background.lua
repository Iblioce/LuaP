local Background = {}
Background.__index = Background
love.graphics.setDefaultFilter("nearest", "nearest")

function Background:new()
    local self = setmetatable({}, Background)
    self.x = 0
    self.y = 0
    self.tileset = love.graphics.newImage("res/maps/tiles.png")
    self.tileWidth = 64
    self.tileHeight = 64


    self.scaleFactor = 2
    self.scaledTileWidth = self.tileWidth * self.scaleFactor
    self.scaledTileHeight = self.tileHeight * self.scaleFactor

    self.tiles = {}
    local gridWidth = self.tileset:getWidth() / self.tileWidth
    local gridHeight = self.tileset:getHeight() / self.tileHeight
    for y = 0, gridHeight - 1 do
        for x = 0, gridWidth - 1 do
            table.insert(self.tiles,
                love.graphics.newQuad(x * self.tileWidth, y * self.tileHeight, self.tileWidth, self.tileHeight,
                    self.tileset:getDimensions()))
        end
    end

    self.tileMap = {}

    return self
end

function Background:getTileIndex(x, y)
    local key = x .. ":" .. y
    if not self.tileMap[key] then
        math.randomseed(x * 10000 + y)
        self.tileMap[key] = math.random(1, #self.tiles)
    end
    return self.tileMap[key]
end

function Background:draw()
    local camX, camY = camera:position()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local startX = math.floor((camX - width / 2) / self.scaledTileWidth) - 1
    local endX = math.floor((camX + width / 2) / self.scaledTileWidth) + 1
    local startY = math.floor((camY - height / 2) / self.scaledTileHeight) - 1
    local endY = math.floor((camY + height / 2) / self.scaledTileHeight) + 1

    for i = startX, endX do
        for j = startY, endY do
            local tileIndex = self:getTileIndex(i, j)
            local quad = self.tiles[tileIndex]
            love.graphics.draw(self.tileset, quad, i * self.scaledTileWidth, j * self.scaledTileHeight, 0,
                self.scaleFactor, self.scaleFactor)
        end
    end
end

return Background
