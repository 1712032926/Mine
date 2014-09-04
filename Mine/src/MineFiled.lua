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
	self._isFirst = true

	
end





---------------------------
--@return #nil 初始化
function MineFiled:init(lv,cr,type,table_data)

    self._col = lv+MINE_FIRST_NUM
    self._row = lv+MINE_FIRST_NUM
    self._type = type or 3
    self._table_block = table_data or {}
    self._cr = cr
    self._level=lv
    
    local vs = MINE_EVEN_NUM
    local vk = (lv+MINE_FIRST_NUM)%2
    if vk~=0 then
        vs = MINE_ODD_NUM
    end
    
    
  --  print("等级"..lv.."  创建"..self._col.."*"..self._row.."雷区，".."以"..vs.."为单位，划分地形")
    logDebug("等级"..lv.."  创建"..self._col.."*"..self._row.."雷区，".."以"..vs.."为单位，划分地形")
    
    
    --创建底层地块
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
    self:setContentSize(GRID_WIDTH*self._col,self._row*GRID_HEIGHT)

end



---------------------------
--@return #table 第一次点击初始化地雷
function MineFiled:initMine(col,row)
	
    local count,tableMine = globalModel:layMines(col,row,self._level,self._cr)
    self._table_mine = tableMine
    self._MineCount = count
	
    return tableMine
end


---------------------------
--@return #nil 重新生成雷区
function MineFiled:createNewFiled(lv)
	--self:removeAllChildrenWithCleanup()
	--生成方块
--	self._MineCount = self:calculateMineCount
	local mc=self._MineCount 
    local block = require("Block")
   -- local mWidth=0
   -- local mHeight=0
    
   
    for i=0, self._col-1 do
        mHeight = 0
        for j=0, self._row-1 do
        
        if self._table_block[i..":"..j] then
        	
        else
                local bl = block.new()
                bl:init(self,self._type)
                bl:setColRow(i,j)
                local psize = bl:getContentSize()
                --print(psize.width)
                bl:setPos(i*GRID_WIDTH+psize.width,j*GRID_HEIGHT+psize.height)
                self:addChild(bl)
                bl:setName(i..":"..j)
              --  mHeight =mHeight+GRID_HEIGHT	
        end

        end
       -- mWidth = mWidth+GRID_WIDTH
    end
	--self:setContentSize(mWidth,mHeight)
   
	--布置雷区
	--self._table_block ={}
	
    -- math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    --  local co = math.random(0,ico-1)

	

end







---------------------------
--@return #nil 计算地雷数量
function MineFiled:calculateMineCount(m,n)
    local sum = PARAMETER_MINE_A*m*m-PARAMETER_MINE_B*m+PARAMETER_MINE_C
	return sum/n
end


---------------------------
--@return #nil 获取数据生成
function MineFiled:createByData()
 --   self:removeAllChildrenWithCleanup()
    
end



---------------------------
--@return #Node 获取雷块
function MineFiled:getMineBlock(col,row)
    return self:getChildByName(col..":"..row)
	
end


---------------------------
--@return #Node 获取雷块
function MineFiled:getMineBlockByName(na)
    return self:getChildByName(na)

end



return MineFiled