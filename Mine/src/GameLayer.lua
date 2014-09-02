require "Cocos2d"
require("Global")
local GameLayer = class("GameLayer",function ()
	return cc.Layer:create()
end)


---------------------------
--@return #void 构造
function GameLayer:ctor()
	self._col = 5
	self._row = 5
	
end

---------------------------
--@return #void 初始化
function GameLayer:init()
	local block = require("Block")
	
	local scaleFactor = 1
	
	--创建雷地
	local mineFile = require("MineFiled").new()
	mineFile:init(7,LEVEL_HARD,1) 
	
	self:addChild(mineFile)
    mineFile:setTag(LAYER_MINEFILED) --设置标示
--	mineFile:setPosition(100,200)
    local mineSize = mineFile:getContentSize() --雷地大小
    local layerSize = self:getContentSize()  --界面大小
    
 --   mineFile:setContentSize(100,50)
  --  layerSize = mineFile:getContentSize()
    
    mineFile:setScale(scaleFactor) --缩放

 
    local ly = self:getContentSize()
    
    local ksw = mineSize.width * scaleFactor
    local ksh = mineSize.height * scaleFactor
    ksw = (layerSize.width - ksw)/2
    ksh = (layerSize.height - ksh)/3
	
	--设置位置
    self:setPosition(ksw,ksh)
	

end


---------------------------
--@return #number 获取行
function GameLayer:getCol()
	return self._col
end


---------------------------
--@return #number 获取列
function GameLayer:getRow()
	return self._row
end


return GameLayer

