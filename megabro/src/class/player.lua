local class = require "lib/middleclass";
local camera = require "lib/gamera";
local tesound = require "lib/tesound";
local anim8 = require "lib/anim8";
local Actor = require "src/class/actor";
local Bullet = require "src/class/bullet";

local Player = class("Player", Actor); 


-- animatii
local spritesheet = love.graphics.newImage("sprites/playeranim.png");
local idlegrid = anim8.newGrid(21, 24, spritesheet:getWidth(), spritesheet:getHeight(), 0, 0, 1);
local walkgrid = anim8.newGrid(24, 24, spritesheet:getWidth(), spritesheet:getHeight(), 44, 0, 1);
local jumpgrid = anim8.newGrid(26, 30, spritesheet:getWidth(), spritesheet:getHeight(), 129, 0, 1);
local idleshootgrid = anim8.newGrid(32, 25, spritesheet:getWidth(), spritesheet:getHeight(), 0, 32, 0);
local walkshootgrid = anim8.newGrid(30, 26, spritesheet:getWidth(), spritesheet:getHeight(), 32, 31, 1);
local jumpshootgrid = anim8.newGrid(30, 31, spritesheet:getWidth(), spritesheet:getHeight(), 130, 32, 0);
spritesheet:setFilter("nearest","nearest");

local COOLDOWN = 0.2;

function Player:initialize(x, y)
    
    Actor.initialize(self, "sprites/megabro.png", x, y);

    self.spritesheet = spritesheet;
    self.animations = {

        idleright = anim8.newAnimation(idlegrid(1,1, 2,1), {2, 0.2}),
        idleleft = anim8.newAnimation(idlegrid(1,1, 2,1), {2, 0.2}):clone():flipH(),

        walkright = anim8.newAnimation(walkgrid(1,1, 2,1, 3,1), 0.13),
        walkleft = anim8.newAnimation(walkgrid(1,1, 2,1, 3,1), 0.13):clone():flipH(),

        jumpright = anim8.newAnimation(jumpgrid(1,1), 1),
        jumpleft = anim8.newAnimation(jumpgrid(1,1), 1):clone():flipH(),
        
        jumprightshoot = anim8.newAnimation(jumpshootgrid(1,1),1),
        jumpleftshoot = anim8.newAnimation(jumpshootgrid(1,1), 1):clone():flipH(),

        idlerightshoot = anim8.newAnimation(idleshootgrid(1,1), 1),
        idleleftshoot = anim8.newAnimation(idleshootgrid(1,1), 1):clone():flipH(),

        walkrightshoot = anim8.newAnimation(walkshootgrid(1,1, 2,1, 3,1), 0.13),
        walkleftshoot = anim8.newAnimation(walkshootgrid(1,1, 2,1, 3,1), 0.13):clone():flipH(),


    }

    self.current_animation = "idleright";
    self.invuln_time = 1;
    self.invuln_activation = os.clock();

end

function Player:update(dt)
   
    Actor.update(self, dt);
    brogame.camera:setPosition(self.pos.x + self.width*self.SCALE_FACTOR/2, self.pos.y); -- centram camera pe jucator
    print(self.invuln_activation, os.clock())
    local correct_x, correct_y, cols = brogame.state.world:move(self, self.pos.x, self.pos.y);  -- verifica coliziunile
    for k,v in pairs(cols) do
        if v.item.hp and v.other.hp and v.item == brogame.player or v.other == brogame.player then  -- verificam daca coliziunile se produc intre un player si un alt actor
            
            if self.invuln_activation + self.invuln_time < os.clock() then
                self:takeDamage(20);
                self.invuln_activation = os.clock();
            end

        end
    end

end

function Player:draw()
    Actor.draw(self);
end

function Player:keyevent(key, isDown)

    -- retine ultima directie
    if key == 'left' or key == 'right' then
        self.last_direction = self.direction;   -- posibil periculos (isDown?)
    end
    
    -- mers
    if (isDown) then

        if (key == 'left') then
            self.direction = self.direction - 1;
        elseif (key == 'right') then
            self.direction = self.direction + 1;
        end

    else

        if (key == 'left') then
            self.direction = self.direction + 1;
        elseif (key == 'right') then
            self.direction = self.direction - 1;
        end

    end


    -- saritura 
    -- IMPLEMENTARE INSTABILA - incercare de SMB, vezi actor.lua in jur de linia 120
    if key == 'z' and isDown and self.on_floor then
            TEsound.play(brogame.assets.sounds["jump"], "player", 0.4);
            self.jump_velocity = -self.jump_height;
    end

    
    -- pew pew
    if key == 'x' and isDown == true and self.last_shot + COOLDOWN <= os.clock() then
        local dir = self.direction == 0 and self.last_direction or self.direction;
        if dir == 1 then

            -- pozitia unde iese glontul e "hard-coded" si dupa ochi ca mi-e lene
            -- am probleme cu self.width / self.height ca ia din sprite static in loc de sprite de animatie
            -- plus ca originea sprite-ului e mereu in stanga sus si asta creeaza probleme ca trebuie sa scad niste valori cand trag in stanga

            local bullet = Bullet:new(self.pos.x + 35*dir*self.SCALE_FACTOR - 5, self.pos.y + 8*self.SCALE_FACTOR, dir);    
            self.shooting = true;

        else

            local bullet = Bullet:new(self.pos.x + 35*dir*self.SCALE_FACTOR + self.width + 80, self.pos.y + 8*self.SCALE_FACTOR, dir); 
            self.shooting = true;

        end

        self.last_shot = os.clock();

        TEsound.play(brogame.assets.sounds["shoot"], "player", 0.4);
    end

end

return Player;