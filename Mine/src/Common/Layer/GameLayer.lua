require "Cocos2d"
require("Common/Global")
local GameLayer = class("GameLayer",function ()
	return cc.Layer:create()
end)


---------------------------
--@return #void 构造
function GameLayer:ctor()
	self._col = 5
	self._row = 5
	self._startPos=nil
	
end

---------------------------
--@return #void 初始化
function GameLayer:init()
	local block = require("Common/Layer/Block")
	
	local scaleFactor = 1
	
	--创建雷地
	local mineFile = require("src/Common/Layer/MineFiled").new()
    mineFile:init(18,LEVEL_SIMPLE,1) 
	
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
    ksh = (layerSize.height - ksh)/2
	
	--设置位置
    self:setPosition(ksw,ksh)
	
    local pp = self:convertToWorldSpace(cc.p(mineFile._Mark_X,mineFile._Mark_Y))
    local kx = ksw +mineFile._Mark_X
    local ky = ksh +mineFile._Mark_Y
    
    self._startPos = pp
    
   -- logDebug("世界位置X:"..pp.x..": Y:"..pp.y)
   -- logDebug("世界位置2X:"..kx..": Y:"..ky)
    
    --self:_startPos
    local tp = self:convertToNodeSpace(pp)
  --  logDebug("点2X:"..tp.x..": Y:"..tp.y)
    local tx,ty = functionUtil:posToTile(tp.x,tp.y)
  --  logDebug("====块   :"..tx..": Y:"..ty)
end



---------------------------
--@return #nil 移动
function GameLayer:moveMap(dx,dy)
    local px,py = self:getPosition()    
    
    local newX = px+dx
    local newY = py+dy
    local mineFile = self:getChildByTag(LAYER_MINEFILED)
    if newX>0   then
    	newX=0
    end
    if newY>0 then
    	newY=0
    end
    
    local msize = self:getParent():getContentSize()
    
    local mw = GRID_WIDTH * mineFile._col
    local mh = GRID_HEIGHT* mineFile._row
    local cx = -1*(mw- msize.width)
     local cy = -1*(mh- msize.height)
    logDebug("宽度 w"..mw.."  限制的距离"..cx)
    logDebug("移动的位置  X"..newX.."  Y:"..newY)
    
    if newX < cx  then
    	newX = cx
    end
    
    if  newY < cy then
    	newY = cy
    end
    
    
    self:setPosition(newX,newY)
    
    local tp = self:convertToNodeSpace(self._startPos)
    --logDebug("点2X:"..tp.x..": Y:"..tp.y)
    mineFile:updateMineByMove(tp)
    local tx,ty = functionUtil:posToTile(tp.x,tp.y)
    --logDebug("====块   :"..tx..": Y:"..ty)
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

