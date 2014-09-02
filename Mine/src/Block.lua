--雷块   
require("Global")

local Block = class("Block",function ()
	return cc.Sprite:create()
end)


function Block:ctor()
	self._blockType = "";
	self._col = 0
	self._row = 0
	self._mineType=MINE_NORMAL
	self:setAnchorPoint(0.5,0.5)
	
	
end

function Block:init(layer,bType)
	self._blockType = bType
	

	
	local imagestr = BlockType[bType]
    local bl = cc.Sprite:create(BlockImage[imagestr])
	self:addChild(bl)
	bl:setTag(100)
	--bl:setAnchorPoint(0.5,0.5)
	local acpoint = bl:getAnchorPoint();
	
	
	--print(acpoint.x..":"..acpoint.y)
	
  --  self:setAnchorPoint(0,0)
  --  self:setContentSize(GRID_WIDTH,GRID_HEIGHT)
	
    
    self:setContentSize(bl:getContentSize())



    function update(dt)
    	local y = self:getPositionY()
        local gy = y/GRID_HEIGHT
        self:setLocalZOrder(gy)
        
    end	
	--self:scheduleUpdateWithPriorityLua(update,0)
end



---------------------------
--@return #type 打开雷块，返回雷块的类型
function Block:openBlock()
	local sp = self:getChildByTag(100)
	if sp then
		sp:setVisible(false)
	end
    return self._mineType
end


---------------------------
--@return #nil 设置行列
function Block:setColRow(col,row)
	self._col = col
	self._row = row
end

---------------------------
--@return #void 设置位置
function Block:setPos(x,y)
    self:setPosition(x,y)
    local gx = x/GRID_WIDTH
    local gy = y/GRID_HEIGHT
	self:setLocalZOrder(1000-gy)
end


---------------------------
--@return #nil 销毁
function Block:destory()
	self:removeAllChildrenWithCleanup()
end



return Block