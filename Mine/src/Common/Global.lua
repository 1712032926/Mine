



--雷块类型
BlockType ={"grass","bomb","land"}

--纹理
BlockImage = {grass = "8.png",bomb="26.png",land ="3.png"}


TILE_WIDTH = 101
TILE_HEIGHT =162


LandImage = {}

--默认方格大小
GRID_WIDTH = 101
GRID_HEIGHT = 83


--层的标示
LAYER_MINEFILED = 10

--lua文件
LUA_BLOCK = "Block"

--触控移动偏移范围
TOUCH_OFFSET_X = 4
TOUCH_OFFSET_Y = 4


--雷块类型

MINE_MINE   = 1  -- 地雷
MINE_NORMAL = 2  -- 正常
MINE_OPEN   = 3  -- 打开

--附近雷最大参数
MINE_MAX_NUM = 3
--地雷初始个数
MINE_FIRST_NUM =4


--游戏难度
LEVEL_SIMPLE     = 4 -- 简单
LEVEL_NORMAL     = 3 -- 正常
LEVEL_HARD       = 2 -- 困难
LEVEL_VERYHARD   = 1 -- 非常难(基本不能用，最大难度)


--地雷区域分块
--奇数
MINE_ODD_NUM = 7
--偶数
MINE_EVEN_NUM = 8

--[[
---------------------------
--@return #nil 计算地雷数量
function MineFiled:calculateMineCount(m,n)
local sum = PARAMETER_MINE_A*m*m-PARAMETER_MINE_B*m+PARAMETER_MINE_C
return sum/n
end

m代表行列数
n代表难度   LEVEL_SIMPLE  LEVEL_NORMAL LEVEL_HARD LEVEL_VERYHARD
--]]
--布雷基本参数
PARAMETER_MINE_A = 0.5871
PARAMETER_MINE_B = 0.8886
PARAMETER_MINE_C = 1.1833


--是否调试模式
isDebug = true


---------------------------
--@return #nil 打印
function logDebug(st)
    if isDebug then
        print(st)
    end
	
end


