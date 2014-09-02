--控制层

require("Cocos2d")
require("Global")
require("Common/Model/ModelManager")


local ControllerLayer = class("ControllerLayer",function ()
    return cc.Sprite:create()
end)


CONTROLLED_NON       = 100    --无状态
CONTROLLED_MOVE      = 101    --移动状态
CONTROLLED_CLICK     = 102    --点击状态



---------------------------
--@return #void 构造
function ControllerLayer:ctor()
	self._pageNode = 0
	self._curPageNode = 0
	self._touchDownPoint = cc.p(0,0)
	self._touchState = CONTROLLED_NON;
	
	
end




---------------------------
--@return #void 设置控制的游戏层
function ControllerLayer:setController(layer)

	self._layer = layer
	

end



---------------------------
--@return #void 初始化
function ControllerLayer:init(layer)
	self:setController(layer)
	
	
	
	
	--开始点击位置
	local touchBeginPoint = nil
	local touchFixedPoint = nil
    ---------------------------
    --@return #nil 触摸开始
    local function onTouchBegan(touch,type)
       local location = touch:getLocation()
       --获取开始的触摸点
       touchBeginPoint = {x=location.x,y=location.y}
       touchFixedPoint= {x=location.x,y=location.y}
        self._touchState = CONTROLLED_CLICK
       return true

    end
    
    ---------------------------
    --@return #nil 触摸移动
    local function onTouchMove(touch,type)
       --获取当前移动的位置
       local location = touch:getLocation()
       
        --判断是否移动状态
        if touchBeginPoint then
           local mineFile = self._layer:getChildByTag(LAYER_MINEFILED)
            local vkpos =mineFile:convertToNodeSpace(self._layer:convertTouchToNodeSpace(touch)) 
            local cx,cy = self._layer:getPosition()
            self._touchState = CONTROLLED_MOVE
            
            local dx = location.x - touchBeginPoint.x
            local dy = location.y - touchBeginPoint.y
            
            local off_x = location.x - touchFixedPoint.x
            local off_y = location.y - touchFixedPoint.y
            local abs_dx = math.abs(off_x)
            local abs_dy = math.abs(off_y)
            
            --移动范围限定，如果移动范围小则判断为点击
            if abs_dx<TOUCH_OFFSET_X and abs_dy<TOUCH_OFFSET_Y then
            	
                self._touchState = CONTROLLED_CLICK
            else
             --   print("移动")
                self._layer:setPosition(cx+dx,cy+dy)
                touchBeginPoint = {x=location.x,y=location.y}
            end
            

            


        end
       
       
    end
    
    ---------------------------
    --@return #nil 触摸结束
    local function onTouchEnded(touch,type)
    	
    	--如果是点击状态，则选中雷块
        if self._touchState==CONTROLLED_CLICK then
            local mineFile = self._layer:getChildByTag(LAYER_MINEFILED)
            --获取点击的雷块
            local block,col,row= self:getBlock_Touch(touch,type)
            if block then
            	
                globalModel._table_open[col..row] = MINE_OPEN
            	
            	if globalModel._isFistFind then
                    globalModel._table_mine= mineFile:initMine(col,row)
            		globalModel._isFistFind = false
            		
                    for key, value in pairs(globalModel._table_mine) do
                        local temp =mineFile:getMineBlockByName(key)
                        if temp then
            				temp:changeBlock(2)
            			end
            		end
            		
            		
            	end
            	
                local num = globalModel:checkMineCount(block._col,block._row,mineFile._table_mine)
               
                if globalModel:checkMine(col,row) then
                    print("这是地雷,爆炸拉")
                else
                    block:openBlock()
                    print("周围有"..num.."个地雷")
                end
            end
          --  block:setVisible(false)
        else
            --如果是移动 状态
            --判断雷地的大小是否超出的屏幕，超出可以移动
        
        end

        
        --触摸完毕，恢复原始值
        self._touchState = CONTROLLED_NON
        touchBeginPoint = nil
        touchFixedPoint = nil
      
    end
    
     

    
    
    --单点触摸的监听器
    local listener = cc.EventListenerTouchOneByOne:create()
    --注册回调监听方法
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMove,cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded ,cc.Handler.EVENT_TOUCH_ENDED)
    --绑定触摸事件
    local eventDispatcher = self:getEventDispatcher()    
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
	
	
end






---------------------------
--@return #block 获取一个位置的雷块
function ControllerLayer:getBlock_Touch(touch,type)
	
    local location = touch:getLocation()
    --local mineFile = require("MineFiled").new()
    --获得雷地
    local mineFile = self._layer:getChildByTag(LAYER_MINEFILED)
    local mx,my= self._layer:getPosition()
    --转换位置
    local vkpos =mineFile:convertToNodeSpace(self._layer:convertTouchToNodeSpace(touch)) 
    local scal = mineFile:getScale()
    --获得行列
    local col =math.abs(math.modf((vkpos.x+mx)/GRID_WIDTH))
    local row = math.abs(math.modf((vkpos.y-GRID_HEIGHT/2+my)/GRID_HEIGHT))
    
   -- print("Pos".. math.modf(vkpos.x)..":".. math.modf(vkpos.y).."Block  ".."Col:"..col.."  Row:"..row)
    --  print(row)
    --local block = require("Block").new()
    local block = mineFile:getMineBlock(col,row)
   -- block:setVisible(false)
    return block,col,row
end



return ControllerLayer