local class = require "lib/middleclass";
local log = require "lib/logger";
local sti = require "lib/sti";
local gamera = require "lib/gamera";
local bump = require "lib/bump";
local gamestate = require "src/class/gamestate";
local player = require "src/class/player";
local enemylist = require "src/enemylist";

local Game = class("Game", gamestate);

function Game:initialize()
    gamestate.initialize(self, "Game");
    TEsound.play(brogame.assets.sounds["song1"], "gamemusic", 0.2);

    self.objects = {

    }

    --love.graphics.setBackgroundColor (0.2, 0.2, 1)

end

function Game:update(dt)

    self.map:update(dt);
    
    -- actualizam obiectele din self.objects (lista de obiecte)
    for k, v in pairs(self.objects) do
        v:update(dt);
    end  
   
end

function Game:draw()

    brogame.camera:draw(function(l,t,w,h) 
        self.map:draw(-l,-t,1,1); -- muta sprite-urile pentru lume cand se misca camera
        for k, v in pairs(self.objects) do
            v:draw();
        end  
        --self.map:bump_draw(self.world); -- deseneaza coliziunile
    end);

    --love.graphics.print("esti in joc, boss", 30, 30);
    love.graphics.print("player hp: " .. brogame.player.hp, 30, 30);

end

function Game:onEnter()
    log.info("buna ziua bine ati venit la megabro nivelul 1");
    self:changemap("maps/arcadebro");
end

function Game:changemap(mapName)

    log.debug("changing map to %s", mapName);

    local _map = require(mapName); -- extragem numele hartii pentru a procesa datele si pentru a crea camera
    local map_width = _map.width*_map.tilewidth;
    local map_height = _map.height*_map.tileheight;
 

    self.map = sti(mapName, {"bump"});
    brogame.camera = gamera.new(0, 0, map_width, map_height);
    self.world = bump.newWorld(); -- crearea lumea de coliziuni
    self.map:bump_init(self.world); -- pune coliziunile setate in Tiled in lume


    for k, object in pairs(self.map.objects) do -- iteram pentru a determina spawnpoint-ul
        if object.name == "spawnpoint" then
            log.trace("am gasit spawn", object);
            brogame.player = player:new(object.x, object.y);
            brogame.camera:setPosition(object.x, object.y);
        end

        if object.properties["class"] then

            log.trace("am gasit roboto", object);

            local classname = object.properties["class"];
            local roboto = enemylist[classname]:new(object.x, object.y);

        end

    end
    self.map:removeLayer("dynamic");

end

function Game:keyevent(key, isDown)
    if isDown then
        if key == 'escape' then
            brogame.changestate("Menu");
        end
    end
    brogame.player:keyevent(key, isDown);
end

return Game;