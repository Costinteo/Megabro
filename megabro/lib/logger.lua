local logger = {
    levels = {
        "fatal", -- 1
        "error",
        "warn",
        "info",
        "debug",
        "trace" -- 6
    },
    LEVEL = 6
};

for level, name in pairs(logger.levels) do
    logger[name] = function(fmt, ...)
        if (level > logger.LEVEL) then
            return;
        end

        local info = debug.getinfo(2, "Sl");
        local lineinfo = info.short_src .. ":" .. info.currentline;
        io.write(string.format("[%s %s %s]: %s\n", os.date("%H:%M:%S"), string.upper(name), lineinfo, fmt:format(...)));
    end
end

return logger;