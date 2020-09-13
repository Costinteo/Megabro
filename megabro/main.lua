------___                 __  _       __     ______     _                          ______           __  _           ______               __          
-----/ (_)_______  ____  / /_(_)___ _/ /_   / ____/____(_)___ _____  ________     / ____/___  _____/ /_(_)___      /_  __/__  ____  ____/ /___  _____
----/ / / ___/ _ \/ __ \/ __/ / __ `/ __/  / / __/ ___/ / __ `/ __ \/ ___/ _ \   / /   / __ \/ ___/ __/ / __ \______/ / / _ \/ __ \/ __  / __ \/ ___/
---/ / / /__/  __/ / / / /_/ / /_/ / /_   / /_/ / /  / / /_/ / /_/ / /  /  __/  / /___/ /_/ (__  ) /_/ / / / /_____/ / /  __/ /_/ / /_/ / /_/ / /    
--/_/_/\___/\___/_/ /_/\__/_/\__,_/\__/   \____/_/  /_/\__, /\____/_/   \___/   \____/\____/____/\__/_/_/ /_/     /_/  \___/\____/\__,_/\____/_/     
-----                                                 /____/                                                                                         
------__  __________________    ____  ____  ____ 
-----/  |/  / ____/ ____/   |  / __ )/ __ \/ __ \
----/ /|_/ / __/ / / __/ /| | / __  / /_/ / / / /
---/ /  / / /___/ /_/ / ___ |/ /_/ / _, _/ /_/ / 
--/_/  /_/_____/\____/_/  |_/_____/_/ |_|\____/ 

local bump = require "lib/bump";
local class = require "lib/middleclass";
local gamera = require "lib/gamera";
local tesound = require "lib/tesound";
local vector = require "src/util/vector";
local player = require "src/class/player";


brogame = {
    GRAVITY = -500;
    G_ACCEL = 0;
    G_CAP = -900;
};

brogame.camera = gamera.new(0, 0, 2000, 2000);
brogame.player = nil;
brogame.assets = require "src/assets";



local states = {
    ["Menu"] = require "src/class/menu",
    ["Game"] = require "src/class/game",
    ["Options"] = require "src/class/options",
};



function brogame.changestate(stateName)
    local state = states[stateName];
    if state == nil then
        error("sal boss ai gresit state-ul");
    end
    brogame.state:onLeave();
    TEsound.stop("gamemusic", false);
    brogame.state = state:new();
    brogame.state:onEnter();
end

function brogame.update(dt)
    brogame.state:update(dt);
end

function brogame.draw()
    brogame.state:draw();
end



-- functii love

function love.load()

    -- creem fontul
    font = love.graphics.setNewFont("src/util/megaman_2.ttf", 24);

    -- incarcam chestii specifice ferestrei


    -- incarcam sunete
    for k, v in pairs(brogame.assets.sounds) do
        brogame.assets.sounds[k] = love.sound.newSoundData(v);
    end

    -- setam primul state, implicit, ca fiind "Menu"
    brogame.state = states["Menu"]:new();
    brogame.state:onEnter();
    window_w, window_h = love.graphics.getDimensions();
end
 
function love.update(dt)

    -- pentru biblioteca sonora
    TEsound.cleanup();

    brogame.update(dt);

end
 
function love.draw()

    brogame.draw();

end

-- inregistrarea butoanelor apasate pentru a le folosi ulterior in alte clase

function love.keypressed(key)
    brogame.state:keyevent(key, true);
end

function love.keyreleased(key)
    brogame.state:keyevent(key, false)
end