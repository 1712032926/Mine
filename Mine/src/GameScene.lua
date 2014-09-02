require "Cocos2d"
require "Cocos2dConstants"

local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)


function GameScene.create()
    local scene = GameScene.new()
    scene:init()
    
    return scene
end



---------------------------
--@return #void 初始化
function GameScene:init()
    --游戏层  
    self._playLayer = require("GameLayer").new()
    self._playLayer:init()
    local winSize = cc.Director:getInstance():getVisibleSize()
    local ww  = winSize.width/2;
    local wh  = winSize.height/2;
 --   self._playLayer:setPosition(-ww/2,wh/29)
    
    
    --控制层
    self._conLayer = require("ControllerLayer").new()
    self._conLayer:init(self._playLayer)
    
    self:addChild(self._playLayer)
    
    self:addChild(self._conLayer)
    
    --UI层
    self._uiLayer = cc.Layer:create()
    self:addChild(self._uiLayer)
    
    self._widget = ccs.GUIReader:getInstance():widgetFromJsonFile("UI/PlayUI/PlayUI.json")
    self._uiLayer:addChild(self._widget)
    
   -- local globaModel = require("Common/Model/GlobalModel").new()
    
   -- local tab,count = globaModel:layMines(2,2,2,1)
    
    

    local layerSize = self._playLayer:getContentSize()
    print(layerSize.width)
    print(layerSize.height)
	
end



return GameScene
