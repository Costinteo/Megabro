local class = require "lib/middleclass";
local tesound = require "lib/tesound";
local anim8 = require "lib/anim8";
local pprint = require "lib/pprint";

local Actor = class("Actor"); 

-- initializam id
local next_id = 1;

function Actor:initialize(spriteName, x, y)
    
    -- setam id-ul pentru indexare
    self.id = next_id;
    next_id = next_id + 1;
    
    self.pos = { x = x or 0, y = y or 0};
    self.sprite = love.graphics.newImage(spriteName);
    self.sprite:setFilter("nearest","nearest");
    self.width = self.sprite:getWidth();
    self.height = self.sprite:getHeight();
    self.spritesheet = nil;
    self.SCALE_FACTOR = 4;

    brogame.state.world:add(self, self.pos.x, self.pos.y, self.width*self.SCALE_FACTOR, self.height*self.SCALE_FACTOR);

    self.animations = { };
    self.current_animation = nil;

    self.hp = 100;
    self.speed = 350;
    self.jump_height = 1000;
    self.jump_velocity = 0;
    self.direction = 0;
    self.last_direction = 1;
    self.on_floor = false;

    self.shooting = false;
    self.last_shot = os.clock();

    -- adaugam actorii in lista de obiecte din gamestate "Game"
    brogame.state.objects[self.id] = self;

end

function Actor:update(dt)



    local correct_x, correct_y = brogame.state.world:move(self, self.pos.x, self.pos.y); -- verifica coliziunile intre lume si jucator
    self.pos.x = correct_x; -- muta actorul in pozitia corecta
    self.pos.y = correct_y;
    

    -- verificam daca sub noi e podea
    local actualX, actualY, cols, nrcols = brogame.state.world:check(self, self.pos.x, self.pos.y + self.height*self.SCALE_FACTOR)

    if actualY == self.pos.y then
        self.on_floor = true;
    else
        self.on_floor = false;
    end

    -- animatii

    local position = self.animations[self.current_animation].position; -- luam pozitia frame-ului curent

    if self.direction == 0 then

        if self.last_direction == 1 or self.last_direction == 0 then
            if self.shooting then
                self.current_animation = self.on_floor and "idlerightshoot" or "jumprightshoot";
            else
                self.current_animation = self.on_floor and "idleright" or "jumpright";
            end
        elseif self.last_direction == -1 then

            if self.shooting then
                self.current_animation = self.on_floor and "idleleftshoot" or "jumpleftshoot";
            else
                self.current_animation = self.on_floor and "idleleft" or "jumpleft";
            end
        end

    elseif self.direction == 1 then

        if self.shooting then
            self.current_animation = self.on_floor and "walkrightshoot" or "jumprightshoot";
            self.animations[self.current_animation]:gotoFrame(position);
        else

            self.current_animation = self.on_floor and "walkright" or "jumpright";
            
        end

    elseif self.direction == -1 then

        if self.shooting then
            self.current_animation = self.on_floor and "walkleftshoot" or "jumpleftshoot";
            self.animations[self.current_animation]:gotoFrame(position);
        else
            self.current_animation = self.on_floor and "walkleft" or "jumpleft";
        end

    end

    if self.last_shot + 0.2 <= os.clock() then
        self.shooting = false;
    end

    self.animations[self.current_animation]:update(dt);
    
    self.pos.x = self.pos.x + self.speed*self.direction*dt; -- miscare stanga dreapta
    
    if self.jump_velocity < 0 then -- calcule pentru saritura
        self.jump_velocity = self.jump_velocity - brogame.GRAVITY*4*dt;
        self.pos.y = self.pos.y + self.jump_velocity*dt;
    else
        self.jump_velocity = 0;

        if not self.on_floor then
            self.pos.y = self.pos.y - brogame.GRAVITY*dt - brogame.G_ACCEL*dt;
            brogame.G_ACCEL = brogame.G_ACCEL + 100*dt;
        else
            brogame.G_ACCEL = 0;
        end

    end

end

function Actor:draw()

    -- desenam animatiile (sau patrat daca nu avem)
    if self.current_animation then
        self.animations[self.current_animation]:draw(self.spritesheet, self.pos.x, self.pos.y, 0, self.SCALE_FACTOR, self.SCALE_FACTOR);
    else
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.width*self.SCALE_FACTOR, self.height*self.SCALE_FACTOR);
    end

end

function Actor:takeDamage(damage)

    self.hp = self.hp - damage;
    if self.hp <= 0 then
        self:remove();
    end

end

function Actor:remove()

    brogame.state.world:remove(self);
    brogame.state.objects[self.id] = nil;

end

return Actor;