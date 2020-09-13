local class = require "lib/middleclass";
local camera = require "lib/gamera";
local tesound = require "lib/tesound";
local anim8 = require "lib/anim8";
local log = require "lib/logger"
local Actor = require "src/class/actor";

local Bullet = class("Bullet", Actor); 

local spritesheet = love.graphics.newImage("sprites/bullet.png");
local idlegrid = anim8.newGrid(8, 6, spritesheet:getWidth(), spritesheet:getHeight(), 0, 0);

function Bullet:initialize(x, y, direction)
    Actor.initialize(self, "sprites/bullet.png", x, y);
    self.spritesheet = spritesheet;
    self.spritesheet:setFilter("nearest","nearest");
    self.animations = {

        idleright = anim8.newAnimation(idlegrid(1,1), 1),
        idleleft = anim8.newAnimation(idlegrid(1,1), 1):clone():flipH(),

    }
    self.direction = direction;
    self.speed = 800;
    self.hp = 0;
end

function Bullet:update(dt)

    self.current_animation = self.direction == 1 and "idleright" or "idleleft";

    self.pos.x = self.pos.x + self.speed*self.direction*dt;

    local correct_x, correct_y, cols = brogame.state.world:move(self, self.pos.x, self.pos.y); -- verifica coliziunile
    if self.pos.x ~= correct_x or self.pos.y ~= correct_y then
        self:remove();
        TEsound.play(brogame.assets.sounds["hit"], "hit", 0.4);
    end

    for k,v in pairs(cols) do
        if v.item.hp and v.other.hp and v.item ~= brogame.player and v.other ~= brogame.player then

            if v.item == self then
                v.other:takeDamage(20);
            else
                v.item:takeDamage(20);
            end

        end
    end
end

function Bullet:draw()
    Actor.draw(self);
end

return Bullet;