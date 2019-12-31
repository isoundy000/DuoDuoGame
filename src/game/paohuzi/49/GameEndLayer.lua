local GameCommon = require("game.paohuzi.GameCommon")
local EventType = require("common.EventType")
local EventMgr = require("common.EventMgr")
local Bit = require("common.Bit")
local StaticData = require("app.static.StaticData")
local Common = require("common.Common")
local GameLogic = require("game.paohuzi.GameLogic")
local GameEndLayer = class("GameEndLayer",function()
    return ccui.Layout:create()
end)

function GameEndLayer:create(pBuffer)
    local view = GameEndLayer.new()
    view:onCreate(pBuffer)
    local function onEventHandler(eventType)  
        if eventType == "enter" then  
            view:onEnter() 
        elseif eventType == "exit" then
            view:onExit()
        elseif eventType == "cleanup" then
            view:onCleanup()
        end  
    end  
    view:registerScriptHandler(onEventHandler)
    return view
end

function GameEndLayer:onEnter()
    EventMgr:registListener(EventType.SUB_GR_MATCH_TABLE_FAILED,self,self.SUB_GR_MATCH_TABLE_FAILED)
end

function GameEndLayer:onExit()
    EventMgr:unregistListener(EventType.SUB_GR_MATCH_TABLE_FAILED,self,self.SUB_GR_MATCH_TABLE_FAILED)
end

function GameEndLayer:onCleanup()

end

function GameEndLayer:onCreate(pBuffer)
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local csb = cc.CSLoader:createNode("GameLayerYZZiPai_End.csb")
    self:addChild(csb)
    self.root = csb:getChildByName("Panel_root")   

    self.root:setPositionY(visibleSize.height*3/2)
    self.root:runAction(cc.MoveTo:create(0.3,cc.p(visibleSize.width/2, visibleSize.height/2)))
    local uiButton_return = ccui.Helper:seekWidgetByName(self.root,"Button_return")
    uiButton_return:setPressedActionEnabled(true)
    local function onEventReturn(sender,event)
    	if event == ccui.TouchEventType.ended then
            Common:palyButton()
            require("common.SceneMgr"):switchScene(require("app.MyApp"):create():createView("HallLayer"),SCENE_HALL) 
    	end
    end
    uiButton_return:addTouchEventListener(onEventReturn)
    local uiButton_continue = ccui.Helper:seekWidgetByName(self.root,"Button_continue")
    uiButton_continue:setPressedActionEnabled(true)
    local function onEventContinue(sender,event)
    	if event == ccui.TouchEventType.ended then
            Common:palyButton()
            if GameCommon.tableConfig.nTableType > TableType_GoldRoom then
                if GameCommon.tableConfig.wTableNumber == GameCommon.tableConfig.wCurrentNumber then
                    EventMgr:dispatch(EventType.EVENT_TYPE_CACEL_MESSAGE_BLOCK)
                else
                    GameCommon:ContinueGame(GameCommon.tableConfig.cbLevel)
                end
            elseif GameCommon.tableConfig.nTableType == TableType_GoldRoom then 
                GameCommon:ContinueGame(GameCommon.tableConfig.cbLevel)
            else
                require("common.SceneMgr"):switchScene(require("app.MyApp"):create():createView("HallLayer"),SCENE_HALL) 
            end          
    	end
    end
    uiButton_continue:addTouchEventListener(onEventContinue)
    if GameCommon.tableConfig.nTableType > TableType_GoldRoom then
        uiButton_return:setVisible(false)
        uiButton_continue:setPositionX(uiButton_continue:getParent():getContentSize().width/2)
    end
    local uiPanel_look = ccui.Helper:seekWidgetByName(self.root,"Panel_look")
    local uiButton_look = ccui.Helper:seekWidgetByName(self.root,"Button_look")
    GameCommon.uiPanel_showEndCard:setVisible(false)
    Common:addTouchEventListener(uiButton_look,function() 
        if uiPanel_look:isVisible() then
            uiPanel_look:setVisible(false)
            uiButton_look:setBright(false)
            GameCommon.uiPanel_showEndCard:setVisible(true)
        else
            uiPanel_look:setVisible(true)
            uiButton_look:setBright(true)
            GameCommon.uiPanel_showEndCard:setVisible(false)
        end
    end) 
    if CHANNEL_ID == 8 or CHANNEL_ID == 9 then 
        uiButton_look:setPosition(219.63,665)
    end     
    local  integral = nil
	self.WPnumber = 0
	local number = 0
    for i=1 , GameCommon.gameConfig.bPlayerCount do
        if number < pBuffer.lGameScore[i] then 
            number = pBuffer.lGameScore[i]
        end
        print("玩家得分",pBuffer.lGameScore[i],number)    
    end  

    local uiPanel_result = ccui.Helper:seekWidgetByName(self.root,"Panel_result")
    local viewID = GameCommon:getViewIDByChairID(pBuffer.wWinUser)
    
    local uiImage_bg = ccui.Helper:seekWidgetByName(self.root,"Image_bg")
    if viewID == 1 then
        uiImage_bg:loadTexture("yongzhou/ui/yongzhou_gameendying.png")
    end 
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("yongzhou/anim/jiesuanshuying/jiesuanshuying.ExportJson")
    local waitArmature=ccs.Armature:create("jiesuanshuying")
    waitArmature:setPosition(0,-100)            
    if GameCommon.gameConfig.bPlayerCount == 3 then        
        if viewID == 2 then --上家赢      
            waitArmature:getAnimation():playWithIndex(2)
            uiPanel_result:addChild(waitArmature)
        elseif viewID == 1 then --自己赢  
            waitArmature:getAnimation():playWithIndex(0)
            uiPanel_result:addChild(waitArmature) 
        elseif viewID == 3 then --下家赢    
            waitArmature:getAnimation():playWithIndex(1)
            uiPanel_result:addChild(waitArmature)   
        else
            --无放炮
        end       
    elseif GameCommon.gameConfig.bPlayerCount == 4 then             
        if viewID == 2 then --上家赢     
            waitArmature:getAnimation():playWithIndex(2)
            uiPanel_result:addChild(waitArmature)
        elseif viewID == 1 then --自己赢    
            waitArmature:getAnimation():playWithIndex(0)
            uiPanel_result:addChild(waitArmature)
        elseif viewID == 4 then --下家赢
            waitArmature:getAnimation():playWithIndex(1)
            uiPanel_result:addChild(waitArmature)
        elseif viewID == 3 then  --对家赢 
            waitArmature:getAnimation():playWithIndex(3)
            uiPanel_result:addChild(waitArmature)
        else
            --无放炮
        end
    elseif GameCommon.gameConfig.bPlayerCount == 2 then     
        if viewID == 1 then --自己赢 
            waitArmature:getAnimation():playWithIndex(0)
            uiPanel_result:addChild(waitArmature)
        else
            waitArmature:getAnimation():playWithIndex(3)
            uiPanel_result:addChild(waitArmature)
        end
    end   

    local uiText_beilv = ccui.Helper:seekWidgetByName(self.root,"Text_beilv")
    uiText_beilv:setString(string.format("倍率：%d",pBuffer.wBeilv))
    local uiText_xiaohao = ccui.Helper:seekWidgetByName(self.root,"Text_xiaohao")
    uiText_xiaohao:setString(string.format("本局消耗：%d",pBuffer.lGameTax))


    local uiText_room = ccui.Helper:seekWidgetByName(self.root,"Text_room")
    local uiText_num = ccui.Helper:seekWidgetByName(self.root,"Text_num")
    uiText_room:setVisible(false)
    uiText_num:setVisible(false)
    if GameCommon.tableConfig.nTableType ~= TableType_GoldRoom then
        uiText_beilv:setVisible(false)
        uiText_xiaohao:setVisible(false)
        if GameCommon.tableConfig.nTableType >= TableType_GoldRoom then    
            uiText_room:setString(string.format("房间号：%d",GameCommon.tableConfig.wTbaleID)) 
            uiText_num:setString(string.format("局数：%d/%d",GameCommon.tableConfig.wCurrentNumber,GameCommon.tableConfig.wTableNumber))
            uiText_room:setVisible(true)   
            uiText_num:setVisible(true)
        end
    else
        uiText_beilv:setVisible(true)
        uiText_xiaohao:setVisible(true)
    end

    
    --结算信息
    local uiListView_info = ccui.Helper:seekWidgetByName(self.root,"ListView_info")
    local uiPanel_defaultInfo = ccui.Helper:seekWidgetByName(self.root,"Panel_defaultInfo")
    uiPanel_defaultInfo:retain()
    uiListView_info:removeAllItems()
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create("yongzhou/ui/yongzhou_gameend2.png")
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.HuCardInfo.cbHuXiCount),"yongzhou/ui/yongzhou_gameendnum.png",17,24,'0')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create("yongzhou/ui/yongzhou_gameend1.png")
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.wFanCount),"yongzhou/ui/yongzhou_gameendnum.png",17,24,'0')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create("yongzhou/ui/yongzhou_gameend3.png")
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.wTun),"yongzhou/ui/yongzhou_gameendnum.png",17,24,'0')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)
    
    local item = uiPanel_defaultInfo:clone()
    local uiImage_name = ccui.Helper:seekWidgetByName(item,"Image_name")
    uiImage_name = ccui.ImageView:create("yongzhou/ui/yongzhou_gameend4.png")
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(0,uiImage_name:getParent():getContentSize().height/2)
    local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",pBuffer.wTun*pBuffer.wFanCount),"yongzhou/ui/yongzhou_gameendnum.png",17,24,'0')
    item:addChild(uiAtlasLabel_num)
    uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
    uiAtlasLabel_num:setPosition(uiAtlasLabel_num:getParent():getContentSize().width,uiAtlasLabel_num:getParent():getContentSize().height/2)
    uiListView_info:pushBackCustomItem(item)
    uiPanel_defaultInfo:release()
    local ListView_Characterbox = nil
	local ListView_Characterbox4 = ccui.Helper:seekWidgetByName(self.root,"ListView_Characterbox4")
    ListView_Characterbox4:setVisible(false)    
    local ListView_Characterbox3 = ccui.Helper:seekWidgetByName(self.root,"ListView_Characterbox3")
    ListView_Characterbox3:setVisible(false)
    local ListView_Characterbox2 = ccui.Helper:seekWidgetByName(self.root,"ListView_Characterbox2")
    ListView_Characterbox2:setVisible(false)
    
    if GameCommon.gameConfig.bPlayerCount == 3 then
        ListView_Characterbox3:setVisible(true)
        ListView_Characterbox = ListView_Characterbox3
    elseif GameCommon.gameConfig.bPlayerCount == 4 then
        ListView_Characterbox4:setVisible(true)
        ListView_Characterbox = ListView_Characterbox4
    elseif GameCommon.gameConfig.bPlayerCount == 2 then
        ListView_Characterbox2:setVisible(true)
        ListView_Characterbox = ListView_Characterbox2
    end 
    for key, var in pairs(GameCommon.player) do
        local viewID = GameCommon:getViewIDByChairID(var.wChairID)   
        if  viewID == 3 and GameCommon.gameConfig.bPlayerCount == 2 then 
            viewID = 2 
        end        
        local root = ccui.Helper:seekWidgetByName(ListView_Characterbox,string.format("Panel_Characterbox%d",viewID))
        local uiImage_avatar = ccui.Helper:seekWidgetByName(root,"Image_avatar")
        Common:requestUserAvatar(var.dwUserID,var.szPto,uiImage_avatar,"img") 
        local uiText_name = ccui.Helper:seekWidgetByName(root,"Text_name")       
        uiText_name:setString(string.format("%s",var.szNickName)) 
        local uiText_ID = ccui.Helper:seekWidgetByName(root,"Text_ID")       
        uiText_ID:setString(string.format("ID:%s",var.dwUserID)) 
        local uiAtlasLabel_money = ccui.Helper:seekWidgetByName(root,"Text_money")
        if GameCommon.tableConfig.nTableType == TableType_GoldRoom or GameCommon.tableConfig.nTableType  == TableType_SportsRoom then
            uiText_ID:setVisible(false)
        end 
        local dwGold = Common:itemNumberToString(pBuffer.lGameScore[var.wChairID + 1])   
        if pBuffer.lGameScore[var.wChairID + 1] > 0 then 
            uiAtlasLabel_money:setString('+' ..tostring(dwGold))
        else      
            uiAtlasLabel_money:setString(tostring(dwGold))
        end     
    --    uiAtlasLabel_money:setString(string.format("%d",pBuffer.lGameScore[var.wChairID+1] ))
       
        if var.wChairID == GameCommon.meChairID then 
            uiText_name:setColor(cc.c3b(255,255,0))
            uiAtlasLabel_money:setColor(cc.c3b(255,255,0))
        end 

        if GameCommon.gameConfig.bPlayerCount == 4 then
            local uiImage_banker = ccui.Helper:seekWidgetByName(root,"Image_banker")
            uiImage_banker:setVisible(false)
        end
    end
    self:showPaiXing(pBuffer)
    self:showMingTang(pBuffer)
    self:showDiPai(pBuffer)
    local uiText_time = ccui.Helper:seekWidgetByName(self.root,"Text_time")
    -- uiText_time:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.CallFunc:create(function(sender,event) 
        local date = os.date("*t",os.time())
        uiText_time:setString(string.format("%d-%d-%d %02d:%02d:%02d",date.year,date.month,date.day,date.hour,date.min,date.sec))
    -- end),cc.DelayTime:create(1))))
end

--显示牌型和眼牌
function GameEndLayer:showPaiXing(pBuffer)
    local uiListView_weave = ccui.Helper:seekWidgetByName(self.root,"ListView_weave")
    local uiPanel_defaultWeave = ccui.Helper:seekWidgetByName(self.root,"Panel_defaultWeave")
    uiPanel_defaultWeave:retain()
    uiListView_weave:removeAllChildren()
    for WeaveItemIndex = 1 , pBuffer.HuCardInfo.cbWeaveCount do
        local item = uiPanel_defaultWeave:clone()
        local   WeaveItemArray= clone(pBuffer.HuCardInfo.WeaveItemArray[WeaveItemIndex] )           --组合扑克
        for i = 1 , WeaveItemArray.cbCardCount do
            local data = WeaveItemArray.cbCardList[i]
            local _spt=GameCommon:getDiscardCardAndWeaveItemArray(data)
            _spt:setPosition(cc.p(0,(i-1)*GameCommon.CARD_HUXI_HEIGHT))
            _spt:setAnchorPoint(cc.p(0,0))
            item:addChild(_spt,10-(i-1))
        end

        local WeaveType=self:getSptWeaveType(WeaveItemArray.cbWeaveKind)
        WeaveType:setPosition(cc.p(GameCommon.CARD_HUXI_WIDTH*0.5,5*GameCommon.CARD_HUXI_HEIGHT))
        item:addChild(WeaveType)

        local huxicout=GameLogic:GetWeaveHuXi(clone(WeaveItemArray))
        local Weavecout=cc.Label:createWithSystemFont(string.format("%d",huxicout), "Arial", 30)
        Weavecout:setPosition(cc.p(GameCommon.CARD_HUXI_WIDTH*0.5,-GameCommon.CARD_HUXI_HEIGHT + 20))
        item:addChild(Weavecout)

        uiListView_weave:pushBackCustomItem(item)
    end
    uiPanel_defaultWeave:release()
    --眼牌
    if pBuffer.HuCardInfo.cbWeaveCount <= 6 and pBuffer.HuCardInfo.cbCardEye ~=0 then
        local item = uiPanel_defaultWeave:clone()
        for i = 1 , 2 do
            local data = pBuffer.HuCardInfo.cbCardEye
            local _spt=GameCommon:getDiscardCardAndWeaveItemArray(data)
            _spt:setPosition(cc.p(0,i*GameCommon.CARD_HUXI_HEIGHT-40))
            _spt:setAnchorPoint(cc.p(0,0))
            item:addChild(_spt)
        end
        uiListView_weave:pushBackCustomItem(item)
    end 
end

--显示名堂
function GameEndLayer:showMingTang(pBuffer)
    self.PHZ_HT_ZIMO = 1              --自　摸   自己摸出的牌胡了    加1囤
    self.PHZ_HT_HONGHU = 2              --红　胡   红字>10只，多一张红字+1番                                                                                                     (X 2倍)
    self.PHZ_HT_ZHENGDIANHU = 4              --点胡    只有一张红字                                                                                                                                          (X 3倍)                                                                          (X 4倍)
    self.PHZ_HT_HEIWU = 32              --黑乌    红字＝0，即全部是黑字                                                                                                                         (X 5倍)
    self.PHZ_HT_DUIDUIHU = 64              --对对胡   全部对子                                                                                                                                           (X 4倍)
--    self.PHZ_HT_DA = 128              --胡牌时，玩家的牌中，大字>=18只  X6（以18只为基数（6番），每多1只大字加1番）                          (x 6倍)
--    self.PHZ_HT_XIAO = 256              --胡牌时，玩家的牌中，小字>=16只 X 8（以16只为基数（8番），每多1只小字加1番）                          (x 8倍)
--    self.PHZ_HT_HAIDI = 512              --玩家所胡的牌是墩中最后的一只牌  平胡加1番，名堂胡加2番                                                                     (X 4倍)
    self.PHZ_HT_TIANHU = 1024              --庄家或闲家所胡的牌为亮张牌 不加番，但息数×2；如果又是名堂胡，则先计算息数，再计算底数，     (X 4倍)
    
    self.PHZ_HT_TINGHU                       = 0x0800              --听胡(6) 起上来.玩家手中的牌有≥15息不进牌直接胡的（只要进牌不打牌出去的）                      (X 6倍)
--    self.PHZ_HT_SHUAHOU                      = 0x1000              --耍猴(8) 玩家手中的牌打的只剩一只单调胡牌的  番数：8番                                        (X 8倍)
   self.PHZ_HT_HUANGFAN                     = 0x2000              --黄番(Na)    黄庄了.下把牌继续打所有番番一倍（只适合开房）
    
    local uiListView_player = ccui.Helper:seekWidgetByName(self.root,"ListView_player")
    local uiPanel_defaultPalyer = ccui.Helper:seekWidgetByName(self.root,"Panel_defaultPalyer")
    uiPanel_defaultPalyer:retain()
    uiListView_player:removeAllItems()
    -- 变量定义 
    local wHZCount = 0 
    local wDZCount = 0
    local wXZCount = 0
    local bIsDDH = true
    local sdata = {
        wTun = 0 ,          --囤
        wType = 0 ,         --数据
        wFanCount = 0,      --翻
    }
    --组合牌类型
    for cbIndex = 1 , pBuffer.HuCardInfo.cbWeaveCount do
        --变量定义
        local cbWeaveKind = pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbWeaveKind
        local cbWeaveCardCount = pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardCount

        --合法验证
        if cbWeaveKind ~= 0 then
            --组合内统计
            for cbCardIndex = 1 , cbWeaveCardCount do
                if pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] ~= 0 then
                    --大小字统计
                    if Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_COLOR) == 16 then
                        wDZCount = wDZCount + 1
                    else 
                        wXZCount = wXZCount + 1
                    end

                    --红字统计
                    if Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_VALUE)==2 
                        or Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_VALUE)==7 
                        or Bit:_and(pBuffer.HuCardInfo.WeaveItemArray[cbIndex].cbCardList[cbCardIndex] , GameCommon.MASK_VALUE)==10 then
                        wHZCount = wHZCount + 1
                    end
                end
            end
            --对对胡判断
            if cbWeaveKind== GameCommon.ACK_CHI or cbWeaveKind==GameCommon.ACK_CHI_EX then
                bIsDDH=false
            end
        end
    end
    --眼牌
    if pBuffer.HuCardInfo.cbCardEye~=0 then
        for  i=1 , 2 do
            --大小字统计
            if Bit:_and(pBuffer.HuCardInfo.cbCardEye , GameCommon.MASK_COLOR) == 16 then
                wDZCount = wDZCount + 1

            else 

                wXZCount = wXZCount + 1
            end
            --红字统计
            if Bit:_and(pBuffer.HuCardInfo.cbCardEye , GameCommon.MASK_VALUE)==2  
                or Bit:_and(pBuffer.HuCardInfo.cbCardEye, GameCommon.MASK_VALUE)==7 
                or Bit:_and(pBuffer.HuCardInfo.cbCardEye, GameCommon.MASK_VALUE)==10 then

                wHZCount = wHZCount + 1
            end
        end
    end
    
    --胡牌类型大字胡，小胡子，红乌需要计算基数
    if wHZCount>=10 then
                --红对胡
        if Bit:_and(pBuffer.wType,self.PHZ_HT_DUIDUIHU) ~= 0 then
            -- local item = uiPanel_defaultPalyer:clone() 
            -- self:createMingTang(item,"hongduihu",6 +wHZCount-10,"","fan")
            -- uiListView_player:pushBackCustomItem(item)


            local item = uiPanel_defaultPalyer:clone()
            local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
            uiText_mingTang:setTextColor(cc.c3b(255,165,0))
            local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
            uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
            uiText_mingTang:setString("红对胡")
            uiText_mingTangNumber:setString(string.format("+%d番",6 +wHZCount-10)) 
            uiListView_player:pushBackCustomItem(item)
        else    --红胡
            -- local item = uiPanel_defaultPalyer:clone()
            -- self:createMingTang(item,"honghu",2 +wHZCount-10,"","fan")
            -- uiListView_player:pushBackCustomItem(item)


            local item = uiPanel_defaultPalyer:clone()
            local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
            uiText_mingTang:setTextColor(cc.c3b(255,165,0))
            local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
            uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
            uiText_mingTang:setString("红胡")
            uiText_mingTangNumber:setString(string.format("+%d番",2 +wHZCount-10)) 
            uiListView_player:pushBackCustomItem(item)
        end
    end

    --自摸判断
    if Bit:_and(pBuffer.wType,self.PHZ_HT_ZIMO)~= 0 then
        -- local item = uiPanel_defaultPalyer:clone()
        -- self:createMingTang(item,"zimo",1,"+","tun")
        -- uiListView_player:pushBackCustomItem(item)
        

        local item = uiPanel_defaultPalyer:clone()
        local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
        uiText_mingTang:setTextColor(cc.c3b(255,165,0))
        local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
        uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
        uiText_mingTang:setString("自摸")
        uiText_mingTangNumber:setString("+1囤")
        uiListView_player:pushBackCustomItem(item)
    end    
    --点胡
    if Bit:_and(pBuffer.wType,self.PHZ_HT_ZHENGDIANHU) ~= 0 then
        -- local item = uiPanel_defaultPalyer:clone()
        -- self:createMingTang(item,"dianhu",3,"","fan")
        -- uiListView_player:pushBackCustomItem(item)


        local item = uiPanel_defaultPalyer:clone()
        local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
        uiText_mingTang:setTextColor(cc.c3b(255,165,0))
        local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
        uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
        uiText_mingTang:setString("点胡")
        uiText_mingTangNumber:setString("+3番")
        uiListView_player:pushBackCustomItem(item)
    end
    
    if Bit:_and(pBuffer.wType,self.PHZ_HT_HEIWU) ~= 0 then
                --乌对胡
        if Bit:_and(pBuffer.wType,self.PHZ_HT_DUIDUIHU) ~= 0 then
            -- local item = uiPanel_defaultPalyer:clone() 
            -- self:createMingTang(item,"wuduihu",10,"","fan")
            -- uiListView_player:pushBackCustomItem(item)

            local item = uiPanel_defaultPalyer:clone()
            local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
            uiText_mingTang:setTextColor(cc.c3b(255,165,0))
            local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
            uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
            uiText_mingTang:setString("乌对胡")
            uiText_mingTangNumber:setString("+10番")
            uiListView_player:pushBackCustomItem(item)
        else    --黑胡
            -- local item = uiPanel_defaultPalyer:clone()
            -- self:createMingTang(item,"heihu",5,"","fan")
            -- uiListView_player:pushBackCustomItem(item)

            local item = uiPanel_defaultPalyer:clone()
            local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
            uiText_mingTang:setTextColor(cc.c3b(255,165,0))
            local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
            uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
            uiText_mingTang:setString("黑胡")
            uiText_mingTangNumber:setString("+5番")
            uiListView_player:pushBackCustomItem(item)
        end
    end

    --对对胡=没有吃进的组合、手中没有单牌
    if Bit:_and(pBuffer.wType,self.PHZ_HT_DUIDUIHU) ~= 0 and wHZCount < 10 and Bit:_and(pBuffer.wType,self.PHZ_HT_HEIWU) == 0 then
        -- local item = uiPanel_defaultPalyer:clone() 
        -- self:createMingTang(item,"duiduihu",4,"","fan")
        -- uiListView_player:pushBackCustomItem(item)

        local item = uiPanel_defaultPalyer:clone()
        local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
        uiText_mingTang:setTextColor(cc.c3b(255,165,0))
        local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
        uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
        uiText_mingTang:setString("对对胡")
        uiText_mingTangNumber:setString("+4番")
        uiListView_player:pushBackCustomItem(item)
    end
    -- 黄番
    if Bit:_and(pBuffer.wType,self.PHZ_HT_HUANGFAN) ~= 0 then
        -- local item = uiPanel_defaultPalyer:clone()
        -- self:createMingTang(item,"huangfan",2,"x","bei")
        -- uiListView_player:pushBackCustomItem(item)

        local item = uiPanel_defaultPalyer:clone()
        local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
        uiText_mingTang:setTextColor(cc.c3b(255,165,0))
        local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
        uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
        uiText_mingTang:setString("黄番")
        uiText_mingTangNumber:setString("x2倍")
        uiListView_player:pushBackCustomItem(item)
    end

    --天胡
    if Bit:_and(pBuffer.wType,self.PHZ_HT_TIANHU)~= 0 then
        -- local item = uiPanel_defaultPalyer:clone()
        -- self:createMingTang(item,"tianhu",2,"","fan")
        -- uiListView_player:pushBackCustomItem(item)

        local item = uiPanel_defaultPalyer:clone()
        local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
        uiText_mingTang:setTextColor(cc.c3b(255,165,0))
        local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
        uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
        uiText_mingTang:setString("天胡")
        uiText_mingTangNumber:setString("+2番")
        uiListView_player:pushBackCustomItem(item)
    end
    --地胡
    if Bit:_and(pBuffer.wType,self.PHZ_HT_TINGHU)~= 0 then
        -- local item = uiPanel_defaultPalyer:clone()
        -- self:createMingTang(item,"dihu",2,"","fan")
        -- uiListView_player:pushBackCustomItem(item)

        local item = uiPanel_defaultPalyer:clone()
        local uiText_mingTang = ccui.Helper:seekWidgetByName(item,"Text_mingTang")
        uiText_mingTang:setTextColor(cc.c3b(255,165,0))
        local uiText_mingTangNumber = ccui.Helper:seekWidgetByName(item,"Text_mingTangNumber")
        uiText_mingTangNumber:setTextColor(cc.c3b(255,165,0))
        uiText_mingTang:setString("地胡")
        uiText_mingTangNumber:setString("+2番")
        uiListView_player:pushBackCustomItem(item)
    end

    uiPanel_defaultPalyer:release()
end

function GameEndLayer:createMingTang(item,mingTang,num,numType,unit)
    local uiImage_name = ccui.ImageView:create(string.format("zipai/table/end_play_%s.png",mingTang))
    item:addChild(uiImage_name)
    uiImage_name:setAnchorPoint(cc.p(0,0.5))
    uiImage_name:setPosition(cc.p(-uiImage_name:getParent():getContentSize().width*0.2,uiImage_name:getParent():getContentSize().height/2))

    if numType == "+" then--加
        local uiAtlasLabel_num = ccui.TextAtlas:create(string.format(".%d",num),"fonts/fonts_9.png",18,27,'.')
        item:addChild(uiAtlasLabel_num)
        uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
        uiAtlasLabel_num:setPosition(cc.p(uiAtlasLabel_num:getParent():getContentSize().width*0.8,uiAtlasLabel_num:getParent():getContentSize().height/2))
    elseif numType == "-" then--减
        local uiAtlasLabel_num = ccui.TextAtlas:create(string.format(".%d",num),"fonts/fonts_10.png",18,27,'.')
        item:addChild(uiAtlasLabel_num)
        uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
        uiAtlasLabel_num:setPosition(cc.p(uiAtlasLabel_num:getParent():getContentSize().width*0.8,uiAtlasLabel_num:getParent():getContentSize().height/2))
    else
        --乘
        local uiAtlasLabel_num = ccui.TextAtlas:create(string.format("%d",num),"fonts/fonts_8.png",18,27,'.')
        item:addChild(uiAtlasLabel_num)
        uiAtlasLabel_num:setAnchorPoint(cc.p(1,0.5))
        uiAtlasLabel_num:setPosition(cc.p(uiAtlasLabel_num:getParent():getContentSize().width*0.8,uiAtlasLabel_num:getParent():getContentSize().height/2))
    end
    if unit ~= "" then
        local uiImage_type = ccui.ImageView:create(string.format("zipai/table/end_play_%s.png",unit))
        item:addChild(uiImage_type)
        uiImage_type:setAnchorPoint(cc.p(0,0.5))
        uiImage_type:setPosition(cc.p(uiImage_type:getParent():getContentSize().width*0.55,uiImage_type:getParent():getContentSize().height/2))
    else
    
    end
end

--显示底牌
function GameEndLayer:showDiPai(pBuffer)
    local uiListView_diPai1 = ccui.Helper:seekWidgetByName(self.root,"ListView_diPai1")
    local uiListView_diPai2 = ccui.Helper:seekWidgetByName(self.root,"ListView_diPai2")
    for i = 1, pBuffer.bLeftCardCount do
        if pBuffer.bLeftCardDataEx[i] ~= 0 then
            local item = GameCommon:getDiscardCardAndWeaveItemArray(pBuffer.bLeftCardDataEx[i])
            if i<= 17 then
                uiListView_diPai1:pushBackCustomItem(item)
            else
                uiListView_diPai2:pushBackCustomItem(item)
            end
        end
    end
end

function GameEndLayer:getSptWeaveType(type)

    local sptname = ""
    if type == GameCommon.ACK_TI then
        sptname="zipai/table/endlayer11.png"
    elseif type == GameCommon.ACK_PAO then
        sptname="zipai/table/endlayer9.png"
    elseif type == GameCommon.ACK_WEI then
        sptname="zipai/table/endlayer12.png"
    elseif type == GameCommon.ACK_CHI then
        sptname="zipai/table/endlayer8.png"
    elseif type == GameCommon.ACK_PENG then
        sptname="zipai/table/endlayer10.png"
    else
       
    end
    return cc.Sprite:create(sptname)
end

function GameEndLayer:SUB_GR_MATCH_TABLE_FAILED(event)
    local data = event._usedata
    require("common.SceneMgr"):switchScene(require("app.MyApp"):create():createView("HallLayer"),SCENE_HALL) 
    if data.wErrorCode == 0 then
        require("common.MsgBoxLayer"):create(0,nil,"您在游戏中!")
    elseif data.wErrorCode == 1 then
        require("common.MsgBoxLayer"):create(0,nil,"游戏配置发生错误!")
    elseif data.wErrorCode == 2 then
        require("common.MsgBoxLayer"):create(0,nil,"您的金币不足!")
    elseif data.wErrorCode == 3 then
        require("common.MsgBoxLayer"):create(0,nil,"您的金币已超过上限，请前往更高一级匹配!")
    elseif data.wErrorCode == 4 then
        require("common.MsgBoxLayer"):create(0,nil,"房间已满,稍后再试!")
    else
        require("common.MsgBoxLayer"):create(0,nil,"未知错误,请升级版本!") 
    end 
end

return GameEndLayer
