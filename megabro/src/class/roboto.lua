local class = require "lib/middleclass";
local camera = require "lib/gamera";
local tesound = require "lib/tesound";
local anim8 = require "lib/anim8";
local Actor = require "src/class/actor";
local Bullet = require "src/class/bullet";

local Roboto = class("Roboto", Actor); 


-- animatii
local spritesheet = love.graphics.newImage("sprites/enemyanim.png");
local idlegrid = anim8.newGrid(33, 31, spritesheet:getWidth(), spritesheet:getHeight(), 0, 1, 0);
local walkgrid = anim8.newGrid(33, 31, spritesheet:getWidth(), spritesheet:getHeight(), 33, 1, 0);
spritesheet:setFilter("nearest","nearest");

function Roboto:initialize(x, y)
    
    Actor.initialize(self, "sprites/roboto.png", x, y);

    self.spritesheet = spritesheet;
    self.animations = {

        idleright = anim8.newAnimation(idlegrid(1,1), 2),       -- trebuie sa il fac sa clipeasca, atlfel e inacceptabil
        idleleft = anim8.newAnimation(idlegrid(1,1), 2):clone():flipH(),

        jumpright = anim8.newAnimation(idlegrid(1,1), 2),
        jumpleft = anim8.newAnimation(idlegrid(1,1), 2):clone():flipH(),

        walkright = anim8.newAnimation(walkgrid(1,1, 2,1, 3,1), 0.13),
        walkleft = anim8.newAnimation(walkgrid(1,1, 2,1, 3,1), 0.13):clone():flipH(),

    }

    self.current_animation = "idleright";
    self.direction = 1;
    self.last_turn = os.clock();

end

function Roboto:update(dt)
   
    Actor.update(self, dt);
    if self.last_turn + 2 <= os.clock() then

            self.direction = math.random(-1,1);
            self.last_turn = os.clock();
        
    end  

end

function Roboto:draw()
    Actor.draw(self);
end


return Roboto;