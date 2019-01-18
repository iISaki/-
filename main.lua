--[[
	设置搜索路径
]]
local function addSearchPaths()
	local ccFileUtils = cc.FileUtils:getInstance()
	WRITABLE_PATH = string.gsub(ccFileUtils:getWritablePath(), "\\", "/") .. "fishData/"
    AVATAR_IMG_PATH = WRITABLE_PATH .. "avatar_img/"

	ccFileUtils:addSearchPath(WRITABLE_PATH)
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "src/")
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "res/")
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "res/ui/")
	ccFileUtils:addSearchPath(WRITABLE_PATH .. "pb/")
    ccFileUtils:addSearchPath(AVATAR_IMG_PATH)

    ccFileUtils:addSearchPath("res/")
    ccFileUtils:addSearchPath("res/ui/")
	ccFileUtils:addSearchPath("pb/")
	ccFileUtils:addSearchPath("src/")
	ccFileUtils:setPopupNotify(false)
end
addSearchPaths()

print = release_print
print("这个jit的版本号为 ==== ",jit.version,jit.arch)

if jit.arch == "arm64" then 
    cc.LuaLoadChunksFromZIP("game_arm64.zip")
else
    cc.LuaLoadChunksFromZIP("game.zip")
end

local function main()
    require("app.myApp"):create():run()
end

local trace = function(...)
    print(string.format(...))
end


local breakInfoFun,xpcallFun = require("LuaDebug")("localhost", 7003)
--1.断点定时器添加 
cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakInfoFun, 0.3, false)
--2.程序异常监听 
function G__TRACKBACK(errorMessage)
    debugXpCall();
    print("----------------------------------------")
    local msg = debug.traceback(errorMessage, 3)
    print(msg)
    print("----------------------------------------")
end
local status, msg = xpcall(main, G__TRACKBACK)
if not status then
    print(msg)
end
