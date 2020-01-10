local Games = {
    --id="游戏ID",name="游戏名字",type="游戏类型",friends="是否有好友房>>1好友房>>2休闲场>>3竞技场",number ="金币房人数",playerCount="人数选择",isZuoXing4="是否有4人坐省",isVisible="可见",icon="大厅按钮图片",icon1="大厅按钮图片1",icons="大厅按钮图片2",icon8="八字玩法图片",ruleBtn="规则按钮图片",ruleCSB="规则网页节点",imgSynopsiss="游戏简介图片",imgSynopsis="游戏简介图片",luaCreateRoomFile="游戏创房lua文件",luaGameFile="游戏执行lua文件",imgDesk="游戏桌面图片", rules ="规则",
   
    [25]={ id=25, name="跑得快15张", type=2, clubtype=2, friends=7, number =3, playerCount = "3,2", isZuoXing4=0, isVisible=1, icon="game/puke/25/icon.png", icons="game/puke/25/icon1.png", icon1="game/puke/25/icon2.png", icon8="game/puke/25/icon8.png", ruleBtn="game/puke/25/rule.png;game/puke/25/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/25.html", imgSynopsiss="game/puke/25/names.png", imgSynopsis="game/puke/25/name.png", luaCreateRoomFile="RoomCreateLayer25", luaGameFile="game.puke.25.GameLayer", ruleBtn="game/puke/25/rule.png", imgDesk="game/puke/25/watermark.png", rules ="规则简介：3人玩法，去掉大小王、方块2梅花2红桃2方块A梅花A红\n桃A方块K，共45张牌，每人15张，黑桃3先出（必须带黑桃3）。"}, 
    [26]={ id=26, name="跑得快16张", type=2, clubtype=2, friends=7, number =3, playerCount = "3,2", isZuoXing4=0, isVisible=1, icon="game/puke/26/icon.png", icons="game/puke/26/icon1.png", icon1="game/puke/26/icon2.png", icon8="game/puke/26/icon8.png", ruleBtn="game/puke/26/rule.png;game/puke/26/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/26.html", imgSynopsiss="game/puke/26/names.png", imgSynopsis="game/puke/26/name.png", luaCreateRoomFile="RoomCreateLayer25", luaGameFile="game.puke.26.GameLayer", ruleBtn="game/puke/26/rule.png", imgDesk="game/puke/26/watermark.png", rules ="规则简介：3人玩法，去掉大小王、方块2梅花2红桃2方块A，共48张\n牌，每人16张，首局黑桃3先出。第二局开始由上游先出牌。"}, 
    [47]={ id=47, name="常德红黑点", type=1, clubtype=1, friends=7, number =3, playerCount = "3,2,4", isZuoXing4=1, isVisible=1, icon="game/paohuzi/47/icon.png", icons="game/paohuzi/47/icon1.png", icon1="game/paohuzi/47/icon2.png", icon8="game/paohuzi/47/icon8.png", ruleBtn="game/paohuzi/47/rule.png;game/paohuzi/47/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/47.html", imgSynopsiss="game/paohuzi/47/names.png", imgSynopsis="game/paohuzi/47/name.png", luaCreateRoomFile="RoomCreateLayer47", luaGameFile="game.paohuzi.47.GameLayer", ruleBtn="game/paohuzi/47/rule.png", imgDesk="game/paohuzi/47/watermark.png", rules ="规则简介：15胡起胡，经典玩法，红胡、黑胡、点胡，不能接炮，\n只能胡牌墩上的牌。"}, 
    [48]={ id=48, name="常德全名堂", type=1, clubtype=1, friends=7, number =3, playerCount = "3,2,4", isZuoXing4=1, isVisible=1, icon="game/paohuzi/48/icon.png", icons="game/paohuzi/48/icon1.png", icon1="game/paohuzi/48/icon2.png", icon8="game/paohuzi/48/icon8.png", ruleBtn="game/paohuzi/48/rule.png;game/paohuzi/48/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/48.html", imgSynopsiss="game/paohuzi/48/names.png", imgSynopsis="game/paohuzi/48/name.png", luaCreateRoomFile="RoomCreateLayer48", luaGameFile="game.paohuzi.48.GameLayer", ruleBtn="game/paohuzi/48/rule.png", imgDesk="game/paohuzi/48/watermark.png", rules ="规则简介：15胡起胡，红胡、黑胡、对对胡、大字胡、小子胡、\n黄番、耍猴等多种名堂，不能接炮，只能胡牌墩上的牌。"}, 
    [49]={ id=49, name="常德多红对", type=1, clubtype=1, friends=7, number =3, playerCount = "3,2,4", isZuoXing4=1, isVisible=1, icon="game/paohuzi/49/icon.png", icons="game/paohuzi/49/icon1.png", icon1="game/paohuzi/49/icon2.png", icon8="game/paohuzi/49/icon8.png", ruleBtn="game/paohuzi/49/rule.png;game/paohuzi/49/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/49.html", imgSynopsiss="game/paohuzi/49/names.png", imgSynopsis="game/paohuzi/49/name.png", luaCreateRoomFile="RoomCreateLayer49", luaGameFile="game.paohuzi.49.GameLayer", ruleBtn="game/paohuzi/49/rule.png", imgDesk="game/paohuzi/49/watermark.png", rules ="规则简介：15胡起胡，乌对胡、红对胡等多种特色名堂，\n独特地区玩法，原滋原味，回味无穷。"}, 
    [60]={ id=60, name="汉寿跑胡子", type=1, clubtype=1, friends=7, number =3, playerCount = "3,2,4", isZuoXing4=1, isVisible=1, icon="game/paohuzi/60/icon.png", icons="game/paohuzi/60/icon1.png", icon1="game/paohuzi/60/icon2.png", icon8="game/paohuzi/60/icon8.png", ruleBtn="game/paohuzi/60/rule.png;game/paohuzi/60/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/60.html", imgSynopsiss="game/paohuzi/60/names.png", imgSynopsis="game/paohuzi/60/name.png", luaCreateRoomFile="RoomCreateLayer60", luaGameFile="game.paohuzi.60.GameLayer", ruleBtn="game/paohuzi/60/rule.png", imgDesk="game/paohuzi/60/watermark.png", rules ="规则简介：15胡起胡，红胡、黑胡、对对胡、大字胡、小子胡、\n黄番、耍猴等多种名堂，不能接炮，只能胡牌墩上的牌。"},   
    [68]={ id=68, name="红中麻将", type=3, clubtype=3, friends=7, number =4, playerCount = "4,2,3", isZuoXing4=0, isVisible=1, icon="game/majiang/68/icon.png", icons="game/majiang/68/icon1.png", icon1="game/majiang/68/icon2.png", icon8="game/majiang/68/icon8.png", ruleBtn="game/majiang/68/rule.png;game/majiang/68/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/68.html", imgSynopsiss="game/majiang/68/names.png", imgSynopsis="game/majiang/68/name.png", luaCreateRoomFile="RoomCreateLayer68", luaGameFile="game.majiang.68.GameLayer", ruleBtn="game/majiang/68/rule.png", imgDesk="game/majiang/68/watermark.png", rules ="规则简介：4张红中，红中可以代替任何牌，红中不能打出，\n起手4张红中可以直接胡牌。只能自摸，不准接炮。"},   
    [70]={ id=70, name="长沙麻将", type=3, clubtype=3, friends=7, number =4, playerCount = "4", isZuoXing4=0, isVisible=1, icon="game/majiang/70/icon.png", icons="game/majiang/70/icon1.png", icon1="game/majiang/70/icon2.png", icon8="game/majiang/70/icon8.png", ruleBtn="game/majiang/70/rule.png;game/majiang/70/rule_1.png", ruleCSB="http://share.hy.qilaigame.com/rule/wanfa/70.html", imgSynopsiss="game/majiang/70/names.png", imgSynopsis="game/majiang/70/name.png", luaCreateRoomFile="RoomCreateLayer70", luaGameFile="game.majiang.70.GameLayer", ruleBtn="game/majiang/70/rule.png", imgDesk="game/majiang/70/watermark.png", rules ="规则简介：胡牌必须有二五八做将，可吃、可碰、可杠、\n可补，胡牌名堂多样变化，胡牌分庄家和闲家。"},
  
}

return Games


