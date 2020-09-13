local class = require "lib/middleclass";

local GameState = class("GameState");

function GameState:initialize(name)
    self.name = name;
end

function GameState:onEnter()
end

function GameState:update(dt)
end

function GameState:draw()
end

function GameState:onLeave()
end

function GameState:keyevent(key, isDown)
end

return GameState;