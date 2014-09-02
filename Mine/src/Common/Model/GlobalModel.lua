require("src/Global")
local GlobalModel = class("GlobalModel")



---------------------------
--@return #nil 构造函数
function GlobalModel:ctor()
	self._userName = "player"
	self._level_pass = 1
	
	
end



---------------------------
--@return #nnumer 检查周围地雷的数量
function GlobalModel:checkMineCount(cl,rw,table_data)
    local p=0
    local m,n
    for key, value in pairs(table_data) do
        m =cl-1
        n =rw-1
        if key == (m..n) and value == MINE_MINE then
            p=p+1
        end
        m=cl-1
        n=rw
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl-1
        n=rw+1
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl
        n=rw-1
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl
        n=rw+1
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl+1
        n=rw-1
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl+1
        n=rw
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl+1
        n=rw+1
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
        m=cl
        n=rw
        if key == (m..n)and value == MINE_MINE then
            p=p+1
        end
    end
    return p
	
end


---------------------------
--@return #table 根据第一次点击位置布雷
function GlobalModel:layMines(col,row,lv,cr)

    local table_re = {}
    local count = math.modf(self:calculateMineCount(lv+4,cr))
    local mcol = lv+MINE_FIRST_NUM
    local mrow = lv+MINE_FIRST_NUM
    --随机种子
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local scol=0
    local srow=0
    local index=0
    while index<count do
        local con=true
        
        scol = math.random(0,mcol-1)
        srow = math.random(0,mrow-1)
        if scol==col and srow==row then
        	con = false
        end
        
        if con then
        	local vha = false
            if table_re[scol..srow] then
        		if table_re[scol..srow]~=MINE_MINE then
        			vha = true
        		end
        	else
                vha = true
        	end
        	
        	if vha == true then
                local ap = self:checkMineCount(scol,srow,table_re)
                if ap<=MINE_MAX_NUM  then
                    table_re[scol..srow] =MINE_MINE
                    index = index +1
                else
                    table_re[scol..srow] =MINE_NORMAL
                    index = index -1
                end
                

        	end
        	
        end
        
        
        
    end
    
    return count,table_re
    
    
end

---------------------------
--@return #nil 计算地雷数量 m代表行列数 n代表难度
function GlobalModel:calculateMineCount(m,n)
    local sum = PARAMETER_MINE_A*m*m-PARAMETER_MINE_B*m+PARAMETER_MINE_C
    return sum/n
end

return GlobalModel