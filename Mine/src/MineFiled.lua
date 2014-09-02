--雷区 放置炸弹和方块

require("Global")
require("Common/Model/ModelManager")

local MineFiled = class("MineFiled",function ()
	return cc.Node:create()
end)



---------------------------
--@return #nil 构造
function MineFiled:ctor()

	self._type=0
	self._col=0
	self._row=0
	self._table_block = {}
	self._table_mine = {}
	self._level=1
	self._cr = 1
	self._MineCount=0
	self._landBatchNode = cc.SpriteBatchNode:create("land/bottomLand.png",50)
	self:addChild(self._landBatchNode)


	
end


---------------------------
--@return #nil 初始化
function MineFiled:init(lv,cr,type,table_data)

    self._col = lv+4
    self._row = lv+4
    self._type = type or 3
    self._table_block = table_data or {}
    self._cr = cr
    
    for i=1, self._col do
    	for j=1, self._row+1 do
    		local sp = cc.Sprite:create("land/bottomLand.png")
    		self._landBatchNode:addChild(sp)
            sp:setPosition(i*sp:getContentSize().width-sp:getContentSize().width/2,j*sp:getContentSize().height-sp:getContentSize().height/2)
    	end
    end
    
    
    local leng = #self._table_block
    
    if #self._table_block>0 then
    	self:createByData()
    else
        self:createNewFiled(lv)
    end
    

    

    

end



---------------------------
--@return #nil 重新生成雷区
function MineFiled:createNewFiled(lv)
	--self:removeAllChildrenWithCleanup()
	--生成方块
--	self._MineCount = self:calculateMineCount
	local mc=self._MineCount 
    local block = require("Block")
    local mWidth=0
    local mHeight=0
    
    local count,tableMine = globalModel:layMines(0,0,lv,self._cr)
    self._table_mine = tableMine
    self._MineCount = count
    
    for i=0, self._col-1 do
        mHeight = 0
        for j=0, self._row-1 do
        local bl = block.new()
        

        bl:init(self,self._type)
        
       
        bl:setColRow(i,j)
        local psize = bl:getContentSize()
        print(psize.width)
        bl:setPos(i*GRID_WIDTH+psize.width,j*GRID_HEIGHT+psize.height)
        self:addChild(bl)
        bl:setName(i..j)
        
        mHeight =mHeight+GRID_HEIGHT
        end
        mWidth = mWidth+GRID_WIDTH
    end
	self:setContentSize(mWidth,mHeight)
	--布置雷区
	self._table_block ={}
	
    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    --  local co = math.random(0,ico-1)

	

end







---------------------------
--@return #nil 计算地雷数量
function MineFiled:calculateMineCount(m,n)
	local sum = 0.5871*m*m-0.8886*m+1.1833
	return sum/n
end


---------------------------
--@return #nil 获取数据生成
function MineFiled:createByData()
 --   self:removeAllChildrenWithCleanup()
    
end



---------------------------
--@return #Node 获取雷块
function MineFiled:getMineBlock(row,col)
    return self:getChildByName(col..row)
	
end




return MineFiled