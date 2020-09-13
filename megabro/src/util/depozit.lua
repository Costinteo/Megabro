local class = require "lib/middleclass";

local Depozit = class("Depozit");

function Depozit:initialize()
    self.storage = {};
end

function Depozit:add(nume, obiect)
    self.storage[nume] = obiect;
end

function Depozit:remove(nume)
    self.storage[nume] = nil;
end

function Depozit:get(nume)
    return self.storage[nume];
end

function Depozit:__pairs()
    return next, self.storage, nil;
end

return Depozit;