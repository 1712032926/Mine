require("Common/Global")

local FunctionUtil = class("FunctionUtil")




---------------------------
--@return #tilePos 点坐标换成块坐标
function FunctionUtil:posToTile(px,py)
	
	local col =math.floor(px / GRID_WIDTH)-1
	local row = math.floor(py / GRID_HEIGHT)-1
	return col,row
	
end


---------------------------
--@return #pos 块坐标换成点坐标
function FunctionUtil:tileToPos(tx,ty)
	
	local dx = tx*GRID_WIDTH+TILE_WIDTH
	local dy = ty*GRID_HEIGHT+TILE_HEIGHT
	return dx,dy
	
end


return FunctionUtil