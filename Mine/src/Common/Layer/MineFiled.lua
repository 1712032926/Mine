--雷区 放置炸弹和方块

require("Common/Global")
require("Common/Model/ModelManager")
require("Utils/UtilManager")

local MineFiled = class("MineFiled",function ()
	return cc.Node:create()
end)

local scheduler = cc.Director:getInstance():getScheduler()

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
    self._regionSize = MINE_EVEN_NUM
    self._Mark_X =0
    self._Mark_Y = 0

	
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
    self._mWidth =0
    self._mHeight = 0
    self._minPos = nil
    if (lv+MINE_FIRST_NUM)>10 then
        local vk = (lv+MINE_FIRST_NUM)%2
        if vk~=0 then
            self._regionSize = MINE_ODD_NUM

        else
            self._regionSize = MINE_EVEN_NUM
        end
   	else
        self._regionSize = (lv+MINE_FIRST_NUM)
    end

    
    
    --  print("等级"..lv.."  创建"..self._col.."*"..self._row.."雷区，".."以"..self._regionSize.."为单位，划分地形")
    logDebug("等级"..lv.."  创建"..self._col.."*"..self._row.."雷区，".."以"..self._regionSize.."为单位，划分地形")
    
    
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
    
  --  scheduler:scheduleScriptFunc(self.updateMine,0.5,false)
    
end



---------------------------
--@return #nil 判断位置更新地雷块
function MineFiled:updateMine(dt)
	print("aaaaaaaa")

end

---------------------------
--@return #table 第一次点击初始化地雷
function MineFiled:initMine(col,row)
	
    local count,tableMine = globalModel:layMines(col,row,self._level,self._cr)
    self._table_mine = tableMine
    self._MineCount = count
	
	logDebug("有"..count.."个炸弹")
	
    return tableMine
end



---------------------------
--@return #nil 根据移动更新显示雷块
function MineFiled:updateMineByMove(dp)
    local tx,ty = functionUtil:posToTile(dp.x,dp.y)
    
    logDebug("tx:"..tx.."  minPos:"..self._minPos.x)
    if tx>self._minPos.x then
        local num = tx-self._minPos.x

        for vi=self._minPos.x,tx do
            local block = self:getMineBlock(vi,self._minPos.y)
            if block then
               
                logDebug("删除第"..block._col..":"..block._row.."个地雷")
                block:removeFromParent()
            end
           
    	end
    	
    	
    	
    	--self._minPos.x = tx
    end
    
    
	
end


---------------------------
--@return #nil 重新生成雷区
function MineFiled:createNewFiled(lv)
	--self:removeAllChildrenWithCleanup()
	--生成方块
--	self._MineCount = self:calculateMineCount
	local mc=self._MineCount 
    local block = require("Common/Layer/Block")
    local mWidth=0
    local mHeight=0
    
    local ostar_i = math.floor((self._col-self._regionSize)/2)
    
    --左下角，最小的一块
    self._minPos = cc.p(ostar_i,ostar_i)
    --遍历生成
    for i=ostar_i, self._regionSize-1+ostar_i do
        mHeight = 0
        for j=ostar_i, self._regionSize-1+ostar_i do
        
        if self._table_block[i..":"..j] then
        	
        else
                local bl = block.new()
                bl:init(self,self._type)
                bl:setColRow(i,j)
                local psize = bl:getContentSize()
                --print(psize.width)
                bl:setPos(i*GRID_WIDTH+psize.width,j*GRID_HEIGHT+psize.height)
                local px,py = bl:getPosition()
                local tx,ty = functionUtil:posToTile(px,py)
                local dx,dy = functionUtil:tileToPos(i,j)
                logDebug("生成位置 col:"..i.."row:"..j.."Pos X:"..px.."  Pos Y"..py.."转换得到的col:"..tx.."  row:"..ty.."  Pos X"..dx.."  Pos Y"..dy)
                if i==tx and j==ty then
                	logDebug("块坐标成功")
                else
                    logDebug("失败=======================================")
                end
                
                if px==dx and py==dy then
                	logDebug("点坐标成功")
                else	
                	logDebug("点坐标失败===============================")
                end
                
                self:addChild(bl)
                bl:setName(i..":"..j)
                mHeight =mHeight+GRID_HEIGHT
        end

        end
        mWidth = mWidth+GRID_WIDTH
    end
    
    self._mWidth = mWidth
    self._mHeight = mHeight
    

    local startX,startY = functionUtil:tileToPos(ostar_i,ostar_i)
    logDebug("初始的生成位置X:"..startX..": Y:"..startY)
    self._Mark_X =startX
    self._Mark_Y = startY
    
    --local pp = self:convertToWorldSpace(cc.p(startX,startY))
    --logDebug("世界位置X:"..pp.x..": Y:"..pp.y-)
    --self:convertToWorldSpace(cc.p(startX,startY))
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