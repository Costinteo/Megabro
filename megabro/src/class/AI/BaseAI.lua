local class = require "lib/middleclass";
local camera = require "lib/gamera";
local tesound = require "lib/tesound";
local anim8 = require "lib/anim8";
local Actor = require "src/class/actor";
local Bullet = require "src/class/bullet";

local BaseAI = class("BaseAI"); 

function BaseAI:initialize()
    --self.actor
end

function BaseAI:update(dt)

end

function BaseAI:draw()

end


return BaseAI;