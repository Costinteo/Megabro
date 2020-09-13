local class = require "lib/middleclass";
local gamestate = require "src/class/gamestate";

local Menu = class("Menu", gamestate);

local selection = 0; -- variabila pentru a determina pozitia / butonul pe care ne aflam cu selectia

function Menu:initialize()

    gamestate.initialize(self, "Menu")
    titlescreen = love.graphics.newImage("sprites/megabrotitlescreenmare.png")

    window_w, window_h = love.graphics.getDimensions();

    -- valorile implicite pentru primul buton
    self.button_y = window_h/2 - 50;

    -- retine x, y la care se afla butoanele (pentru a folosi asta la pozitionarea sagetutei de selectie)
    selection_pos = {
        [0] = {x = window_w/2 + 80, y = window_h/2 - 50},
        [1] = {x = window_w/2 + 140, y = window_h/2},
        [2] = {x = window_w/2 + 80, y = window_h/2 + 50},
    }

end

function Menu:update(dt)

    

    if selection < 0 then
        selection = 2;
    end
    if selection > 2 then
        selection = 0;
    end

end

function Menu:draw()

    love.graphics.draw(titlescreen, window_w/2 - titlescreen:getWidth()/2, 10);
    love.graphics.printf("Play", window_w/2 - titlescreen:getWidth()/2, self.button_y, titlescreen:getWidth(), "center");
    love.graphics.printf("Options", window_w/2 - titlescreen:getWidth()/2, self.button_y + 50, titlescreen:getWidth(), "center");
    love.graphics.printf("Exit", window_w/2 - titlescreen:getWidth()/2, self.button_y + 100, titlescreen:getWidth(), "center");
    love.graphics.print("<", selection_pos[selection]["x"], selection_pos[selection]["y"]);

end

-- selectie pentru meniu
function Menu:keyevent(key, isDown)

    print(selection);

    if key == 'down' and isDown == true then
        selection = selection + 1;
    end
    if key == 'up' and isDown == true then
        selection = selection - 1;
    end

    if love.keyboard.isDown('return') then
        if selection == 0 then
            brogame.changestate("Game");
        elseif selection == 1 then
            brogame.changestate("Options");
            selection = 0;
        elseif selection == 2 then
            love.event.quit();
        end
    end

end

return Menu;