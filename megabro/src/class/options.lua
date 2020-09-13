local class = require "lib/middleclass";
local gamestate = require "src/class/gamestate";

local Options = class("Options", gamestate);

local selection = 0; -- variabila pentru a determina pozitia / butonul pe care ne aflam cu selectia
local sizeselect = 1; -- variabila pentru a determina optiunile de marime ale ferestrei

function Options:initialize()

    gamestate.initialize(self, "Menu")
    titlescreen = love.graphics.newImage("sprites/megabrotitlescreenmare.png")

    window_w, window_h = love.graphics.getDimensions();

    self.resolutions = { 
        
        {w=1280, h=720},
        {w=800, h=600}, 
        {w=640, h=480},

    }

    -- valorile implicite pentru primul buton
    self.button_y = window_h/2 - 50;

    -- retine y la care se afla butoanele (pentru a folosi asta la pozitionarea sagetutei de selectie)
    selection_pos = {
        [0] = {x = window_w/2 + 250, y = window_h/2 - 50},
        [1] = {x = window_w/2 + 80, y = window_h/2},
        [2] = {x = window_w/2 + 80, y = window_h/2 + 50},
    }

end

function Options:update(dt)

    if selection < 0 then
        selection = 2;
    end
    if selection > 2 then
        selection = 0;
    end
    if sizeselect < 1 then
        sizeselect = 3;
    end
    if sizeselect > 3 then
        sizeselect = 1;
    end

end

function Options:draw()

    love.graphics.draw(titlescreen, window_w/2 - titlescreen:getWidth()/2, 10);
    love.graphics.printf("Options", window_w/2 - titlescreen:getWidth()/2, self.button_y - 50, titlescreen:getWidth(), "center")
    love.graphics.printf("Window size: " .. self.resolutions[sizeselect]["w"] .. "x" .. self.resolutions[sizeselect]["h"], window_w/2 - titlescreen:getWidth()/2, self.button_y, titlescreen:getWidth(), "center");
    love.graphics.printf("Back", window_w/2 - titlescreen:getWidth()/2, self.button_y + 50, titlescreen:getWidth(), "center");
    love.graphics.printf("Exit", window_w/2 - titlescreen:getWidth()/2, self.button_y + 100, titlescreen:getWidth(), "center");
    love.graphics.print("<", selection_pos[selection]["x"], selection_pos[selection]["y"]);

end

-- selectie pentru meniu
function Options:keyevent(key, isDown)

    if key == 'down' and isDown == true then
        selection = selection + 1;
    end
    if key == 'up' and isDown == true then
        selection = selection - 1;
    end
    if key == 'left' and isDown == true and selection == 0 then
        sizeselect = sizeselect - 1 ;
    end
    if key == 'right'and isDown == true and selection == 0 then
        sizeselect = sizeselect + 1;
    end

    if love.keyboard.isDown('return') then
        if selection == 0 then
            local succes = love.window.updateMode(self.resolutions[sizeselect]["w"] , self.resolutions[sizeselect]["h"]);
            print (succes);
        elseif selection == 1 then
            brogame.changestate("Menu");
            selection = 0;
        elseif selection == 2 then
            love.event.quit();
        end
    end


end

return Options;