local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local library = {}
local DEFAULT_TOP_BAR_COLOR = Color3.fromRGB(39, 46, 89)
local TOGGLE_ENABLED_COLOR = Color3.fromRGB(212, 212, 218)
local EMBEDDED_TEMPLATE_JSON = [================[
{"c":["ScreenGui","Frame","UICorner","ImageLabel","TextLabel","UIStroke","ScrollingFrame","TextButton","UIListLayout","UIPadding","TextBox"],"n":["cryptic","main","TopBar","UICorner","TopBar_Extension","Border","Exit_Unload","Title","Minimize","Maximize","AmbientShadow","UmbraShadow","PenumbraShadow","UIStroke","TabButtonContainer","TabButtonContainerExtension","Holder","Home","UIListLayout","TabHolder","_Title","Toggle","ToggleBtnBack","Name","UIPadding","_Border","_Space","Button","Image","Label","Divider","Borderline","Input","InputBox","Slider","slider_bg","slider_dot","Value_Label","Dropdown_Closed","State","Pick","Dropdown_Opened","Options","Option A","Option B","Keybind","notification","title","text","toast"],"p":["Enabled","ClipToDeviceSafeArea","ScreenInsets","DisplayOrder","ResetOnSpawn","IgnoreGuiInset","SafeAreaCompatibility","ZIndexBehavior","LayoutOrder","BorderMode","Interactable","AnchorPoint","SizeConstraint","ZIndex","AutomaticSize","Size","ClipsDescendants","BorderColor3","Active","Visible","Rotation","SelectionOrder","BackgroundTransparency","Position","BorderSizePixel","Selectable","SelectionGroup","BackgroundColor3","CornerRadius","ImageTransparency","SliceCenter","Image","TileSize","ImageRectSize","ResampleMode","ScaleType","ImageColor3","ImageRectOffset","SliceScale","TextWrapped","TextDirection","TextStrokeTransparency","TextTruncate","RichText","TextYAlignment","TextScaled","FontFace","OpenTypeFeatures","TextXAlignment","TextTransparency","Text","LineHeight","TextStrokeColor3","Font","TextSize","MaxVisibleGraphemes","TextColor3","ApplyStrokeMode","LineJoinMode","Color","Transparency","Thickness","ScrollingDirection","CanvasSize","MidImage","CanvasPosition","ElasticBehavior","TopImage","VerticalScrollBarPosition","ScrollBarImageColor3","VerticalScrollBarInset","ScrollBarThickness","ScrollBarImageTransparency","AutomaticCanvasSize","ScrollingEnabled","BottomImage","HorizontalScrollBarInset","Modal","AutoButtonColor","Style","VerticalAlignment","FillDirection","HorizontalAlignment","Wraps","Padding","ItemLineAlignment","SortOrder","PaddingBottom","PaddingTop","PaddingLeft","PaddingRight","TextEditable","MultiLine","ClearTextOnFocus","PlaceholderColor3","PlaceholderText"],"r":[1,1,{"1":true,"2":true,"3":["e","ScreenInsets","DeviceSafeInsets"],"4":0,"5":false,"6":true,"7":["e","SafeAreaCompatibility","FullscreenExtension"],"8":["e","ZIndexBehavior","Sibling"]},[[2,2,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,367,0,302],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.212890625,0,0.6107594966888428,0],"25":0,"26":false,"27":false,"28":["C",0.16862745583057404,0.16862745583057404,0.16862745583057404]},[[2,3,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",0.15294118225574493,0.18039216101169586,0.3490196168422699]},[[3,4,{"29":["u",0,8]},[]],[2,5,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,-0.5333333611488342,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0.5333333611488342,0],"25":0,"26":false,"27":false,"28":["C",0.15294118225574493,0.18039216101169586,0.3490196168422699]},[]],[2,6,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,0,1],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,1,0],"25":0,"26":false,"27":false,"28":["C",0.2039215862751007,0.2039215862751007,0.2039215862751007]},[]],[4,7,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,25,0,25],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.9200000166893005,0,0.06700000166893005,0],"25":0,"26":false,"27":false,"28":["C",0.29411765933036804,0.29411765933036804,0.29411765933036804],"30":0,"31":["r",0,0,0,0],"32":"http://www.roblox.com/asset/?id=6031094678","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Stretch"],"37":["C",0.8549020290374756,0.8549020290374756,0.8549020290374756],"38":["v",0,0],"39":1},[]],[5,8,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,180,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.0272479560226202,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Vexium","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.8705883026123047,0.8705883026123047,0.8705883026123047]},[]],[4,9,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,25,0,25],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.8518801331520081,0,0.06699981540441513,0],"25":0,"26":false,"27":false,"28":["C",0.29411765933036804,0.29411765933036804,0.29411765933036804],"30":0,"31":["r",0,0,0,0],"32":"http://www.roblox.com/asset/?id=6035067836","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Stretch"],"37":["C",0.8549020290374756,0.8549020290374756,0.8549020290374756],"38":["v",0,0],"39":1},[]],[4,10,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,25,0,25],"17":false,"18":["C",0,0,0],"19":false,"20":false,"21":0,"22":0,"23":1,"24":["U",0.8518801331520081,0,0.06699981540441513,0],"25":0,"26":false,"27":false,"28":["C",0.29411765933036804,0.29411765933036804,0.29411765933036804],"30":0,"31":["r",0,0,0,0],"32":"http://www.roblox.com/asset/?id=6031630212","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Stretch"],"37":["C",0.8549020290374756,0.8549020290374756,0.8549020290374756],"38":["v",0,0],"39":1},[]]]],[3,4,{"29":["u",0,8]},[]],[4,11,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":0,"15":["e","AutomaticSize","None"],"16":["U",1,10,1,10],"17":false,"18":["C",0.10588236153125763,0.16470588743686676,0.20784315466880798],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.5,0,0.5,0],"25":1,"26":false,"27":false,"28":["C",0.6392157077789307,0.6352941393852234,0.6470588445663452],"30":0.800000011920929,"31":["r",10,10,118,118],"32":"rbxassetid://1316045217","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Slice"],"37":["C",0,0,0],"38":["v",0,0],"39":1},[]],[4,12,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":0,"15":["e","AutomaticSize","None"],"16":["U",1,10,1,10],"17":false,"18":["C",0.10588236153125763,0.16470588743686676,0.20784315466880798],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.5,0,0.5,0],"25":1,"26":false,"27":false,"28":["C",0.6392157077789307,0.6352941393852234,0.6470588445663452],"30":0.8600000143051147,"31":["r",10,10,118,118],"32":"rbxassetid://1316045217","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Slice"],"37":["C",0,0,0],"38":["v",0,0],"39":1},[]],[4,13,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":0,"15":["e","AutomaticSize","None"],"16":["U",1,10,1,10],"17":false,"18":["C",0.10588236153125763,0.16470588743686676,0.20784315466880798],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.5,0,0.5,0],"25":1,"26":false,"27":false,"28":["C",0.6392157077789307,0.6352941393852234,0.6470588445663452],"30":0.8799999952316284,"31":["r",10,10,118,118],"32":"rbxassetid://1316045217","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Slice"],"37":["C",0,0,0],"38":["v",0,0],"39":1},[]],[6,14,{"1":true,"58":["e","ApplyStrokeMode","Contextual"],"59":["e","LineJoinMode","Round"],"60":["C",0,0,0],"61":0.6299999952316284,"62":1},[]],[2,15,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,98,0,271],"17":false,"18":["C",0.11372549086809158,0.11372549086809158,0.11372549086809158],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0.10264900326728821,0],"25":0,"26":false,"27":false,"28":["C",0.11372549086809158,0.11372549086809158,0.11372549086809158]},[[3,4,{"29":["u",0,8]},[]],[2,16,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,81,0,271],"17":false,"18":["C",0.11372549086809158,0.11372549086809158,0.11372549086809158],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.1734693944454193,0,0,0],"25":0,"26":false,"27":false,"28":["C",0.11372549086809158,0.11372549086809158,0.11372549086809158]},[]],[2,16,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,98,0,45],"17":false,"18":["C",0.11372549086809158,0.11372549086809158,0.11372549086809158],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",0.11372549086809158,0.11372549086809158,0.11372549086809158]},[]],[2,6,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,1,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0.5,"24":["U",1,0,0,1],"25":0,"26":false,"27":false,"28":["C",0.2039215862751007,0.2039215862751007,0.2039215862751007]},[]],[7,17,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,98,0,270],"17":true,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0.0036900369450449944,0],"25":0,"26":true,"27":true,"28":["C",1,1,1],"63":["e","ScrollingDirection","XY"],"64":["U",0,0,2,0],"65":"rbxasset://textures/ui/Scroll/scroll-middle.png","66":["v",0,0],"67":["e","ElasticBehavior","WhenScrollable"],"68":"rbxasset://textures/ui/Scroll/scroll-top.png","69":["e","VerticalScrollBarPosition","Right"],"70":["C",0.47843137383461,0.47843137383461,0.47843137383461],"71":["e","ScrollBarInset","None"],"72":0,"73":0,"74":["e","AutomaticSize","None"],"75":true,"76":"rbxasset://textures/ui/Scroll/scroll-bottom.png","77":["e","ScrollBarInset","None"]},[[8,18,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,0,25],"17":false,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0,0],"25":0,"26":true,"27":false,"28":["C",0.1411764770746231,0.1411764770746231,0.1411764770746231],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Home","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":21,"56":-1,"57":["C",0.8156863451004028,0.8156863451004028,0.8156863451004028],"78":false,"79":true,"80":["e","ButtonStyle","Custom"]},[[3,4,{"29":["u",0,4]},[]]]],[9,19,{"81":["e","VerticalAlignment","Top"],"82":["e","FillDirection","Vertical"],"83":["e","HorizontalAlignment","Left"],"84":false,"85":["u",0,1],"86":["e","ItemLineAlignment","Automatic"],"87":["e","SortOrder","LayoutOrder"]},[]],[8,18,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,0,25],"17":false,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0,0],"25":0,"26":true,"27":false,"28":["C",0.1411764770746231,0.1411764770746231,0.1411764770746231],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Home","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":21,"56":-1,"57":["C",0.8156863451004028,0.8156863451004028,0.8156863451004028],"78":false,"79":true,"80":["e","ButtonStyle","Custom"]},[[3,4,{"29":["u",0,4]},[]]]]]]]],[2,20,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,267,0,269],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.2697547674179077,0,0.10596026480197906,0],"25":0,"26":false,"27":false,"28":["C",1,1,1]},[[7,18,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,1,0],"17":true,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":true,"27":true,"28":["C",1,1,1],"63":["e","ScrollingDirection","XY"],"64":["U",0,0,2,0],"65":"rbxasset://textures/ui/Scroll/scroll-middle.png","66":["v",0,0],"67":["e","ElasticBehavior","WhenScrollable"],"68":"rbxasset://textures/ui/Scroll/scroll-top.png","69":["e","VerticalScrollBarPosition","Right"],"70":["C",0.47843137383461,0.47843137383461,0.47843137383461],"71":["e","ScrollBarInset","None"],"72":2,"73":0.6000000238418579,"74":["e","AutomaticSize","None"],"75":true,"76":"rbxasset://textures/ui/Scroll/scroll-bottom.png","77":["e","ScrollBarInset","None"]},[[9,19,{"81":["e","VerticalAlignment","Top"],"82":["e","FillDirection","Vertical"],"83":["e","HorizontalAlignment","Center"],"84":false,"85":["u",0,2],"86":["e","ItemLineAlignment","Automatic"],"87":["e","SortOrder","LayoutOrder"]},[]],[5,21,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,0,20],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Home","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":23,"56":-1,"57":["C",0.7725490927696228,0.7725490927696228,0.7725490927696228]},[]],[2,22,{"9":5,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.050000034272670746,0,0.05223874747753143,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[2,23,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,20,0,20],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.9300000071525574,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",0.1882353127002716,0.1882353127002716,0.1882353127002716]},[[3,4,{"29":["u",0,4]},[]]]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8639183640480042,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Toggle","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]]]],[10,25,{"88":["u",0,2],"89":["u",0,0],"90":["u",0,2],"91":["u",0,2]},[]],[2,26,{"9":1,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8999999761581421,0,0,1],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0.5,"24":["U",0.5,0,1,0],"25":0,"26":false,"27":false,"28":["C",0.2039215862751007,0.2039215862751007,0.2039215862751007]},[]],[2,27,{"9":2,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8999999761581421,0,0,1],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.5,0,1,0],"25":0,"26":false,"27":false,"28":["C",0.2039215862751007,0.2039215862751007,0.2039215862751007]},[]],[2,28,{"9":4,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.050000034272670746,0,0.05223874747753143,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8639183640480042,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Button","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[4,29,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,20,0,20],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.9300000071525574,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",0.1882352977991104,0.1882352977991104,0.1882352977991104],"30":0,"31":["r",0,0,0,0],"32":"http://www.roblox.com/asset/?id=6034989547","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Stretch"],"37":["C",0.29411765933036804,0.29411765933036804,0.29411765933036804],"38":["v",0,0],"39":1},[[3,4,{"29":["u",0,4]},[]]]]]],[2,30,{"9":3,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,-0.00749063678085804,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0.5,"24":["U",0.024999989196658134,0,0.1716417372226715,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8639183640480042,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Label","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]]]],[2,31,{"9":6,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,-0.033707864582538605,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.024999989196658134,0,0.1641511470079422,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[2,32,{"9":6,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8999999761581421,0,0,1],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0.5,"24":["U",0.5,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",0.2039215862751007,0.2039215862751007,0.2039215862751007]},[]]]],[2,33,{"9":5,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.050000034272670746,0,0.05223874747753143,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8639183640480042,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Input","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[11,34,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,80,0,18],"17":false,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":0,"24":["U",0.800000011920929,0,0.5,0],"25":0,"26":true,"27":false,"28":["C",0.24705883860588074,0.24705883860588074,0.24705883860588074],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"TextBox","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543],"92":true,"93":false,"94":true,"95":["C",0.43529415130615234,0.43529415130615234,0.43529415130615234],"96":""},[[3,4,{"29":["u",0,20]},[]],[6,14,{"1":true,"58":["e","ApplyStrokeMode","Border"],"59":["e","LineJoinMode","Round"],"60":["C",0.3333333432674408,0.3333333432674408,0.3333333432674408],"61":0.2800000011920929,"62":1},[]]]]]],[2,35,{"9":5,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.050000034272670746,0,0.05223874747753143,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8639183640480042,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Slider","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[2,36,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,150,0,4],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.5,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",0.1882353127002716,0.1882353127002716,0.1882353127002716]},[[2,37,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,6,0,10],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",0.7450980544090271,0.7450980544090271,0.7450980544090271]},[[3,4,{"29":["u",0,8]},[]]]],[3,4,{"29":["u",0,8]},[]]]],[5,38,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,44,0,26],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.9044194221496582,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"00","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.4941176772117615,0.4941176772117615,0.4941176772117615]},[]]]],[2,39,{"9":5,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.050000034272670746,0,0.05223874747753143,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,207,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Dropdown","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[4,40,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,25,0,25],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.9300000071525574,0,0.5,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"30":0,"31":["r",0,0,0,0],"32":"http://www.roblox.com/asset/?id=6034818365","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Stretch"],"37":["C",0.5137255191802979,0.5137255191802979,0.5137255191802979],"38":["v",0,0],"39":1},[]],[5,41,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,89,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.49197420477867126,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Right"],"50":0,"51":"Dropdown","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":16,"56":-1,"57":["C",0.4901961088180542,0.4901961088180542,0.4901961088180542]},[]]]],[2,42,{"9":5,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0.1910112351179123,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.024999989196658134,0,0.40295711159706116,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,207,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Dropdown","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[4,40,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,25,0,25],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":90,"22":0,"23":1,"24":["U",0.9300000071525574,0,0.10719741135835648,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"30":0,"31":["r",0,0,0,0],"32":"http://www.roblox.com/asset/?id=6034818365","33":["U",1,0,1,0],"34":["v",0,0],"35":["e","ResamplerMode","Default"],"36":["e","ScaleType","Stretch"],"37":["C",0.5137255191802979,0.5137255191802979,0.5137255191802979],"38":["v",0,0],"39":1},[]],[5,41,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,89,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0.49197420477867126,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Right"],"50":0,"51":"Dropdown","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":16,"56":-1,"57":["C",0.4901961088180542,0.4901961088180542,0.4901961088180542]},[]],[7,43,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1.0416927337646484,0,0.8034855127334595,0],"17":true,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":1,"24":["U",-0.04169272258877754,0,0.21162228286266327,0],"25":0,"26":true,"27":true,"28":["C",1,1,1],"63":["e","ScrollingDirection","XY"],"64":["U",0,0,2,0],"65":"rbxasset://textures/ui/Scroll/scroll-middle.png","66":["v",0,0],"67":["e","ElasticBehavior","WhenScrollable"],"68":"rbxasset://textures/ui/Scroll/scroll-top.png","69":["e","VerticalScrollBarPosition","Right"],"70":["C",0,0,0],"71":["e","ScrollBarInset","None"],"72":0,"73":0,"74":["e","AutomaticSize","None"],"75":true,"76":"rbxasset://textures/ui/Scroll/scroll-bottom.png","77":["e","ScrollBarInset","None"]},[[2,44,{"9":4,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9999999403953552,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",6.107179473247015e-8,0,0.05223871394991875,0],"25":0,"26":false,"27":false,"28":["C",0.11372549831867218,0.11372549831867218,0.11372549831867218]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Option A","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]]]],[9,19,{"81":["e","VerticalAlignment","Top"],"82":["e","FillDirection","Vertical"],"83":["e","HorizontalAlignment","Left"],"84":false,"85":["u",0,1],"86":["e","ItemLineAlignment","Automatic"],"87":["e","SortOrder","LayoutOrder"]},[]],[2,45,{"9":4,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9999999403953552,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",6.107179473247015e-8,0,0.05223871394991875,0],"25":0,"26":false,"27":false,"28":["C",0.11372549831867218,0.11372549831867218,0.11372549831867218]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Option B","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]]]]]]]],[2,46,{"9":5,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.9500000476837158,0,0,30],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.050000034272670746,0,0.05223874747753143,0],"25":0,"26":false,"27":false,"28":["C",0.12941177189350128,0.12941177189350128,0.12941177189350128]},[[3,4,{"29":["u",0,4]},[]],[5,24,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0.8639183640480042,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":false,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":false,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Left"],"50":0,"51":"Keybind","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":18,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[10,25,{"88":["u",0,0],"89":["u",0,0],"90":["u",0,10],"91":["u",0,0]},[]],[11,34,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0.5,0.5],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,47,0,18],"17":false,"18":["C",0,0,0],"19":true,"20":true,"21":0,"22":0,"23":0,"24":["U",0.8687930703163147,0,0.5,0],"25":0,"26":true,"27":false,"28":["C",0.24705883860588074,0.24705883860588074,0.24705883860588074],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Key","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543],"92":true,"93":false,"94":true,"95":["C",0.43529415130615234,0.43529415130615234,0.43529415130615234],"96":""},[[3,4,{"29":["u",0,20]},[]],[6,14,{"1":true,"58":["e","ApplyStrokeMode","Border"],"59":["e","LineJoinMode","Round"],"60":["C",0.3333333432674408,0.3333333432674408,0.3333333432674408],"61":0.2800000011920929,"62":1},[]]]]]]]]]]]],[2,47,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,253,0,85],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.7867187261581421,0,0.7990506291389465,0],"25":0,"26":false,"27":false,"28":["C",0.10196079313755035,0.10196079313755035,0.10196079313755035]},[[3,4,{"29":["u",0,8]},[]],[5,48,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,253,0,26],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Title","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.8705883026123047,0.8705883026123047,0.8705883026123047]},[]],[5,49,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,253,0,49],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,0.30588236451148987,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Label","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[6,14,{"1":true,"58":["e","ApplyStrokeMode","Contextual"],"59":["e","LineJoinMode","Round"],"60":["C",0.38431376218795776,0.38431376218795776,0.38431376218795776],"61":0,"62":1},[]]]],[2,50,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",0,130,0,39],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":0,"24":["U",0.44921875,0,0.06716977059841156,0],"25":0,"26":false,"27":false,"28":["C",0.10196079313755035,0.10196079313755035,0.10196079313755035]},[[3,4,{"29":["u",0,8]},[]],[5,49,{"9":0,"10":["e","BorderMode","Outline"],"11":true,"12":["v",0,0],"13":["e","SizeConstraint","RelativeXY"],"14":1,"15":["e","AutomaticSize","None"],"16":["U",1,0,1,0],"17":false,"18":["C",0,0,0],"19":false,"20":true,"21":0,"22":0,"23":1,"24":["U",0,0,-0.0018099271692335606,0],"25":0,"26":false,"27":false,"28":["C",1,1,1],"40":true,"41":["e","TextDirection","Auto"],"42":1,"43":["e","TextTruncate","None"],"44":false,"45":["e","TextYAlignment","Center"],"46":true,"47":["f","rbxassetid://12187607287","Regular","Normal"],"48":"","49":["e","TextXAlignment","Center"],"50":0,"51":"Label","52":1,"53":["C",0,0,0],"54":["e","Font","Unknown"],"55":14,"56":-1,"57":["C",0.7058823704719543,0.7058823704719543,0.7058823704719543]},[]],[6,14,{"1":true,"58":["e","ApplyStrokeMode","Contextual"],"59":["e","LineJoinMode","Round"],"60":["C",0.38431376218795776,0.38431376218795776,0.38431376218795776],"61":0,"62":1},[]]]]]]}
]================]

local function make(className, parent, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
		instance[property] = value
	end
	instance.Parent = parent
	return instance
end

local function animate(instance, duration, properties, style, direction, delay)
	if not instance or not instance.Parent then
		return nil
	end

	local tween = TweenService:Create(
		instance,
		TweenInfo.new(
			duration,
			style or Enum.EasingStyle.Quad,
			direction or Enum.EasingDirection.Out,
			0,
			false,
			delay or 0
		),
		properties
	)
	tween:Play()
	return tween
end

local function newConnectionBag(window)
	local bag = { connections = {} }

	function bag:Connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(self.connections, connection)
		return connection
	end

	function bag:DisconnectAll()
		for _, connection in ipairs(self.connections) do
			if connection.Connected then
				connection:Disconnect()
			end
		end
		table.clear(self.connections)
	end

	table.insert(window._bags, bag)
	return bag
end

local function invoke(callback, ...)
	if type(callback) ~= "function" then
		return
	end

	local arguments = table.pack(...)
	task.spawn(function()
		local ok, err = xpcall(function()
			callback(table.unpack(arguments, 1, arguments.n))
		end, debug.traceback)
		if not ok then
			warn("[Vexium UI] Callback error:\n" .. tostring(err))
		end
	end)
end

local function normalizeKeyCode(value)
	if typeof(value) == "EnumItem" and value.EnumType == Enum.KeyCode then
		return value
	end
	if type(value) == "string" then
		local keyName = string.gsub(value, "%s+", "")
		local ok, keyCode = pcall(function()
			return Enum.KeyCode[keyName]
		end)
		if ok and keyCode then
			return keyCode
		end
	end
	return nil
end

local function formatNumber(value)
	if math.abs(value - math.round(value)) < 0.000001 then
		return tostring(math.round(value))
	end
	return string.format("%.2f", value)
end

local function addMethod(owner, implementation)
	return function(...)
		if select(1, ...) == owner then
			return implementation(select(2, ...))
		end
		return implementation(...)
	end
end

local function flashRow(row)
	if not row or not row.Parent then
		return
	end

	local originalColor = row.BackgroundColor3
	animate(row, 0.08, {
		BackgroundColor3 = originalColor:Lerp(Color3.new(1, 1, 1), 0.055),
	}, Enum.EasingStyle.Quad)
	task.delay(0.09, function()
		animate(row, 0.16, { BackgroundColor3 = originalColor }, Enum.EasingStyle.Quad)
	end)
end

local function bounce(instance, name)
	if not instance or not instance.Parent then
		return
	end

	local scale = instance:FindFirstChild(name or "_VexiumScale")
	if not scale then
		scale = make("UIScale", instance, {
			Name = name or "_VexiumScale",
			Scale = 1,
		})
	end

	scale.Scale = 0.94
	animate(scale, 0.1, { Scale = 1.06 }, Enum.EasingStyle.Back)
	task.delay(0.1, function()
		animate(scale, 0.12, { Scale = 1 }, Enum.EasingStyle.Quad)
	end)
end

local function attachHandleMethods(control, setter, getter)
	if setter then
		control.set = addMethod(control, setter)
		control.Set = control.set
	end
	if getter then
		control.get = addMethod(control, getter)
		control.Get = control.get
	end
	return control
end

local function decodeEmbeddedValue(value)
	if type(value) ~= "table" then
		return value
	end

	local kind = value[1]
	if kind == "C" then
		return Color3.new(value[2], value[3], value[4])
	elseif kind == "v" then
		return Vector2.new(value[2], value[3])
	elseif kind == "V" then
		return Vector3.new(value[2], value[3], value[4])
	elseif kind == "u" then
		return UDim.new(value[2], value[3])
	elseif kind == "U" then
		return UDim2.new(value[2], value[3], value[4], value[5])
	elseif kind == "e" then
		return Enum[value[2]][value[3]]
	elseif kind == "f" then
		return Font.new(value[2], Enum.FontWeight[value[3]], Enum.FontStyle[value[4]])
	elseif kind == "r" then
		return Rect.new(value[2], value[3], value[4], value[5])
	end

	return value
end

local function instantiateEmbeddedNode(node, parent, classNames, names, propertyNames)
	local instance = Instance.new(classNames[node[1]])
	instance.Name = names[node[2]]
	local customFontFace

	for propertyIndex, encodedValue in pairs(node[3]) do
		local propertyName = propertyNames[tonumber(propertyIndex)]
		if propertyName then
			local decodedValue = decodeEmbeddedValue(encodedValue)
			if propertyName == "FontFace" then
				customFontFace = decodedValue
			else
				local ok, err = pcall(function()
					instance[propertyName] = decodedValue
				end)
				if not ok then
					warn("[Vexium UI] Could not apply embedded property " .. propertyName .. ": " .. tostring(err))
				end
			end
		end
	end

	if customFontFace then
		local ok, err = pcall(function()
			instance.FontFace = customFontFace
		end)
		if not ok then
			warn("[Vexium UI] Could not apply embedded property FontFace: " .. tostring(err))
		end
	end

	for _, child in ipairs(node[4]) do
		instantiateEmbeddedNode(child, instance, classNames, names, propertyNames)
	end

	instance.Parent = parent
	return instance
end

local embeddedTemplateData
local function buildEmbeddedTemplate(playerGui)
	if not embeddedTemplateData then
		embeddedTemplateData = HttpService:JSONDecode(EMBEDDED_TEMPLATE_JSON)
	end

	local screenGui = instantiateEmbeddedNode(
		embeddedTemplateData.r,
		nil,
		embeddedTemplateData.c,
		embeddedTemplateData.n,
		embeddedTemplateData.p
	)
	screenGui.Name = "VexiumUI"
	screenGui:SetAttribute("VexiumLibraryWindow", true)
	screenGui.ResetOnSpawn = false
	screenGui.Enabled = true
	screenGui.Parent = playerGui
	return screenGui
end

local function findTemplateGui(playerGui)
	local staticMockup = playerGui:FindFirstChild("cryptic")
	local staticMockupWasEnabled
	if staticMockup and staticMockup:IsA("ScreenGui") then
		staticMockupWasEnabled = staticMockup.Enabled
		staticMockup.Enabled = false
	end

	return buildEmbeddedTemplate(playerGui), staticMockup, staticMockupWasEnabled
end

local function createActivationButton(parent, name, position, size, anchorPoint, zIndex)
	return make("TextButton", parent, {
		Name = name,
		Active = true,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = position,
		AnchorPoint = anchorPoint or Vector2.zero,
		Selectable = true,
		Size = size,
		Text = "",
		TextTransparency = 1,
		ZIndex = zIndex or 10,
	})
end

local function makeWindow(title, topBarColor, toggleKey)
	local player = Players.LocalPlayer
	assert(player, "Vexium UI must be created from a client LocalScript.")

	local playerGui = player:WaitForChild("PlayerGui")
	local screenGui, staticMockup, staticMockupWasEnabled = findTemplateGui(playerGui)
	local main = screenGui:FindFirstChild("main")
	assert(main and main:IsA("Frame"), "Embedded Vexium UI is missing its main Frame.")

	local topBar = main:FindFirstChild("TopBar")
	local tabButtonContainer = main:FindFirstChild("TabButtonContainer")
	local tabHolder = main:FindFirstChild("TabHolder")
	assert(topBar and tabButtonContainer and tabHolder, "Embedded Vexium UI is missing TopBar, TabButtonContainer, or TabHolder.")

	local tabButtons = tabButtonContainer:FindFirstChild("Holder")
	local firstPage = tabHolder:FindFirstChild("Home")
	assert(tabButtons and firstPage, "Embedded Vexium UI is missing its tab button holder or home page.")

	local templateNames = {
		"Button",
		"Toggle",
		"Label",
		"Divider",
		"Input",
		"Slider",
		"Dropdown_Closed",
		"Dropdown_Opened",
		"Keybind",
	}
	local templates = {}
	for _, templateName in ipairs(templateNames) do
		local template = firstPage:FindFirstChild(templateName)
		assert(template, "Embedded Vexium UI is missing the " .. templateName .. " widget.")
		templates[templateName] = template:Clone()
	end

	local navButtonTemplate = tabButtons:FindFirstChildWhichIsA("TextButton")
	assert(navButtonTemplate, "Embedded Vexium UI is missing its tab button widget.")
	navButtonTemplate = navButtonTemplate:Clone()

	local openedDropdownOptions = templates.Dropdown_Opened:FindFirstChild("Options")
	local optionTemplate
	if openedDropdownOptions then
		for _, child in ipairs(openedDropdownOptions:GetChildren()) do
			if child:IsA("Frame") then
				optionTemplate = child:Clone()
				break
			end
		end
	end
	assert(optionTemplate, "Embedded Vexium UI is missing its dropdown option widget.")

	local notificationSource = screenGui:FindFirstChild("notification")
	local toastSource = screenGui:FindFirstChild("toast")
	assert(notificationSource and toastSource, "Embedded Vexium UI is missing its notification or toast widget.")
	local notificationTemplate = notificationSource:Clone()
	local toastTemplate = toastSource:Clone()
	notificationSource.Visible = false
	toastSource.Visible = false

	local function clearPageSamples(page)
		local keep = {
			UIListLayout = true,
			UIPadding = true,
			_Title = true,
			_Border = true,
			_Space = true,
		}
		for _, child in ipairs(page:GetChildren()) do
			if not keep[child.Name] then
				child:Destroy()
			end
		end
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.ScrollingDirection = Enum.ScrollingDirection.Y
		page.CanvasPosition = Vector2.zero
	end

	clearPageSamples(firstPage)
	local pageTemplate = firstPage:Clone()
	pageTemplate.Name = "PageTemplate"
	pageTemplate.Visible = false
	pageTemplate.Parent = nil

	for _, child in ipairs(tabButtons:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	tabButtons.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabButtons.ScrollingDirection = Enum.ScrollingDirection.Y

	local titleLabel = topBar:FindFirstChild("Title")
	if titleLabel and titleLabel:IsA("TextLabel") then
		titleLabel.Text = tostring(title or "Vexium")
	end
	local accent = typeof(topBarColor) == "Color3" and topBarColor or DEFAULT_TOP_BAR_COLOR
	topBar.BackgroundColor3 = accent
	local extension = topBar:FindFirstChild("TopBar_Extension")
	if extension and extension:IsA("GuiObject") then
		extension.BackgroundColor3 = accent
	end

	local originalMainSize = main.Size
	local baseWidth = math.max(1, main.AbsoluteSize.X)
	local baseHeight = math.max(1, main.AbsoluteSize.Y)
	local uiScale = main:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale = make("UIScale", main, { Scale = 1 })
	end

	local layoutWidth = originalMainSize.X.Offset > 0 and originalMainSize.X.Offset or baseWidth
	local layoutHeight = originalMainSize.Y.Offset > 0 and originalMainSize.Y.Offset or baseHeight
	for _, panel in ipairs({ tabButtonContainer, tabHolder }) do
		local panelPosition = panel.Position
		panel.Position = UDim2.new(
			0,
			math.round(panelPosition.X.Scale * layoutWidth) + panelPosition.X.Offset,
			0,
			math.round(panelPosition.Y.Scale * layoutHeight) + panelPosition.Y.Offset
		)
	end

	local contentGroup = make("CanvasGroup", nil, {
		Name = "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		GroupTransparency = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 1,
	})
	tabButtonContainer.Parent = contentGroup
	tabHolder.Parent = contentGroup
	contentGroup.Parent = main
	topBar.ZIndex = math.max(topBar.ZIndex, 3)

	local fadeTargets = {}
	for _, fadeName in ipairs({ "TopBar_Extension", "Border" }) do
		local fadeObject = topBar:FindFirstChild(fadeName)
		if fadeObject and fadeObject:IsA("GuiObject") then
			table.insert(fadeTargets, {
				instance = fadeObject,
				transparency = fadeObject.BackgroundTransparency,
			})
		end
	end

	local window = {
		_gui = screenGui,
		_main = main,
		_bags = {},
		_keybinds = {},
		_destroyed = false,
		_minimized = false,
		_visible = true,
		_activeKeybind = nil,
	}

	local minimizeIcon = topBar:FindFirstChild("Minimize")
	local maximizeIcon = topBar:FindFirstChild("Maximize")
	local unloadIcon = topBar:FindFirstChild("Exit_Unload")
	assert(minimizeIcon and maximizeIcon and unloadIcon, "The cryptic TopBar must have Minimize, Maximize, and Exit_Unload icons.")

	local minimizeButton = createActivationButton(topBar, "MinimizeAction", minimizeIcon.Position, minimizeIcon.Size, minimizeIcon.AnchorPoint, math.max(10, minimizeIcon.ZIndex + 5))
	local maximizeButton = createActivationButton(topBar, "MaximizeAction", maximizeIcon.Position, maximizeIcon.Size, maximizeIcon.AnchorPoint, math.max(10, maximizeIcon.ZIndex + 5))
	local unloadButton = createActivationButton(topBar, "UnloadAction", unloadIcon.Position, unloadIcon.Size, unloadIcon.AnchorPoint, math.max(10, unloadIcon.ZIndex + 5))
	maximizeButton.Visible = false

	local dragHandle = createActivationButton(
		topBar,
		"DragHandle",
		UDim2.new(0, 0, 0, 0),
		UDim2.new(0.82, 0, 1, 0),
		Vector2.zero,
		math.max(8, topBar.ZIndex + 5)
	)

	local windowBag = newConnectionBag(window)
	local currentCameraConnection
	local currentSizeTween
	local currentDragTween
	local function clampWindowPosition()
		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local absSize = main.AbsoluteSize
		local currentPosition = main.AbsolutePosition
		local left = math.clamp(currentPosition.X, 8, math.max(8, viewport.X - absSize.X - 8))
		local top = math.clamp(currentPosition.Y, 8, math.max(8, viewport.Y - absSize.Y - 8))
		local xOffset = left - (main.Position.X.Scale * viewport.X - main.AnchorPoint.X * absSize.X)
		local yOffset = top - (main.Position.Y.Scale * viewport.Y - main.AnchorPoint.Y * absSize.Y)
		main.Position = UDim2.new(main.Position.X.Scale, xOffset, main.Position.Y.Scale, yOffset)
	end

	local function resizeForViewport()
		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local widthScale = (viewport.X - 24) / baseWidth
		local heightScale = (viewport.Y - 48) / baseHeight
		uiScale.Scale = math.max(0.4, math.min(1, widthScale, heightScale))
		task.defer(clampWindowPosition)
	end

	local function bindCamera()
		if currentCameraConnection and currentCameraConnection.Connected then
			currentCameraConnection:Disconnect()
		end
		local camera = Workspace.CurrentCamera
		if camera then
			currentCameraConnection = windowBag:Connect(camera:GetPropertyChangedSignal("ViewportSize"), resizeForViewport)
		end
		resizeForViewport()
	end
	windowBag:Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
	bindCamera()

	local dragging = false
	local dragInput
	local dragStart
	local dragStartPosition
	windowBag:Connect(dragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragInput = input
			dragStart = input.Position
			dragStartPosition = main.Position
		end
	end)
	windowBag:Connect(dragHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragInput then
				dragInput = input
			end
		end
	end)
	windowBag:Connect(UserInputService.InputChanged, function(input)
		if not dragging or not dragStart or not dragStartPosition then
			return
		end
		local mouseDrag = dragInput and dragInput.UserInputType == Enum.UserInputType.MouseMovement and input.UserInputType == Enum.UserInputType.MouseMovement
		local touchDrag = dragInput and dragInput.UserInputType == Enum.UserInputType.Touch and dragInput == input
		if not mouseDrag and not touchDrag then
			return
		end

		local camera = Workspace.CurrentCamera
		local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
		local delta = input.Position - dragStart
		local absSize = main.AbsoluteSize
		local startLeft = dragStartPosition.X.Scale * viewport.X + dragStartPosition.X.Offset - main.AnchorPoint.X * absSize.X
		local startTop = dragStartPosition.Y.Scale * viewport.Y + dragStartPosition.Y.Offset - main.AnchorPoint.Y * absSize.Y
		local targetLeft = math.clamp(startLeft + delta.X, 8, math.max(8, viewport.X - absSize.X - 8))
		local targetTop = math.clamp(startTop + delta.Y, 8, math.max(8, viewport.Y - absSize.Y - 8))
		local targetPosition = UDim2.new(
			dragStartPosition.X.Scale,
			targetLeft + main.AnchorPoint.X * absSize.X - dragStartPosition.X.Scale * viewport.X,
			dragStartPosition.Y.Scale,
			targetTop + main.AnchorPoint.Y * absSize.Y - dragStartPosition.Y.Scale * viewport.Y
		)
		if currentDragTween then
			currentDragTween:Cancel()
		end
		currentDragTween = TweenService:Create(main, TweenInfo.new(0.06, Enum.EasingStyle.Linear), { Position = targetPosition })
		currentDragTween:Play()
	end)
	windowBag:Connect(UserInputService.InputEnded, function(input)
		if dragInput and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
			dragging = false
			dragInput = nil
		end
	end)

	local chromeTweens = {}
	local transitionRevision = 0
	local minimizedSize = UDim2.new(originalMainSize.X.Scale, originalMainSize.X.Offset, originalMainSize.Y.Scale, topBar.Size.Y.Offset)

	local function trackTween(tween)
		if tween then
			table.insert(chromeTweens, tween)
		end
		return tween
	end

	local function setMinimized(minimized)
		if window._destroyed or window._minimized == minimized then
			return
		end
		window._minimized = minimized
		minimizeIcon.Visible = not minimized
		minimizeButton.Visible = not minimized
		maximizeIcon.Visible = minimized
		maximizeButton.Visible = minimized

		transitionRevision += 1
		local revision = transitionRevision
		if currentSizeTween then
			currentSizeTween:Cancel()
		end
		for _, tween in ipairs(chromeTweens) do
			tween:Cancel()
		end
		table.clear(chromeTweens)

		local currentSize = main.Size
		local currentPosition = main.Position
		local targetSize = minimized and minimizedSize or originalMainSize
		local heightDelta = (targetSize.Y.Offset - currentSize.Y.Offset) * uiScale.Scale
		local targetPosition = UDim2.new(
			currentPosition.X.Scale,
			currentPosition.X.Offset,
			currentPosition.Y.Scale,
			currentPosition.Y.Offset + main.AnchorPoint.Y * heightDelta
		)

		currentSizeTween = TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = targetPosition,
			Size = targetSize,
		})
		currentSizeTween:Play()

		for _, target in ipairs(fadeTargets) do
			trackTween(animate(target.instance, 0.22, {
				BackgroundTransparency = minimized and 1 or target.transparency,
			}, Enum.EasingStyle.Quad))
		end

		if minimized then
			trackTween(animate(contentGroup, 0.12, { GroupTransparency = 1 }, Enum.EasingStyle.Quad))
		else
			contentGroup.Visible = true
			trackTween(animate(contentGroup, 0.18, { GroupTransparency = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.08))
		end

		task.delay(0.26, function()
			if window._destroyed or revision ~= transitionRevision then
				return
			end
			if minimized then
				contentGroup.Visible = false
			else
				clampWindowPosition()
			end
		end)
	end

	window.minimize = function()
		setMinimized(true)
	end
	window.maximize = function()
		setMinimized(false)
	end
	window.toggle = function()
		if not window._destroyed then
			window._visible = not window._visible
			screenGui.Enabled = window._visible
		end
	end
	window.setVisible = function(visible)
		window._visible = not not visible
		screenGui.Enabled = window._visible
	end
	window.toggleKey = normalizeKeyCode(toggleKey) or Enum.KeyCode.RightShift
	window.setToggleKey = function(value)
		local keyCode = normalizeKeyCode(value)
		if keyCode then
			window.toggleKey = keyCode
		end
	end

	local tabs = {}
	local activeTab
	local activeNotifications = {}
	local activeToasts = {}
	local cardVisuals = {}

	local stackSettings = {
		notification = {
			anchor = Vector2.new(1, 1),
			position = UDim2.new(1, -18, 1, -18),
			direction = -1,
			spacing = 94,
			entryOffset = Vector2.new(24, 0),
		},
		toast = {
			anchor = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 18),
			direction = 1,
			spacing = 50,
			entryOffset = Vector2.new(0, -14),
		},
	}

	local function stackPosition(settings, index)
		return UDim2.new(
			settings.position.X.Scale,
			settings.position.X.Offset,
			settings.position.Y.Scale,
			settings.position.Y.Offset + settings.direction * (index - 1) * settings.spacing
		)
	end

	local function collectCardVisuals(card)
		local visuals = {}
		local function add(instance, property)
			table.insert(visuals, {
				instance = instance,
				property = property,
				value = instance[property],
			})
		end

		add(card, "BackgroundTransparency")
		for _, descendant in ipairs(card:GetDescendants()) do
			if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
				add(descendant, "TextTransparency")
			elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
				add(descendant, "ImageTransparency")
			elseif descendant:IsA("Frame") then
				add(descendant, "BackgroundTransparency")
			elseif descendant:IsA("UIStroke") then
				add(descendant, "Transparency")
			end
		end
		return visuals
	end

	local function setCardAlpha(visuals, alpha)
		for _, visual in ipairs(visuals) do
			if visual.instance.Parent then
				visual.instance[visual.property] = alpha
			end
		end
	end

	local function tweenCardAlpha(visuals, duration, alpha)
		for _, visual in ipairs(visuals) do
			if visual.instance.Parent then
				animate(visual.instance, duration, {
					[visual.property] = alpha == nil and visual.value or alpha,
				}, Enum.EasingStyle.Quad)
			end
		end
	end

	local function styleMessageCard(card, isToast)
		card.AnchorPoint = stackSettings[isToast and "toast" or "notification"].anchor
		card.BackgroundColor3 = Color3.fromRGB(27, 27, 31)
		card.ClipsDescendants = true

		if isToast then
			card.Size = UDim2.fromOffset(230, 42)
		else
			card.Size = UDim2.fromOffset(270, 86)
		end

		local stroke = card:FindFirstChildWhichIsA("UIStroke")
		if stroke then
			stroke.Color = accent:Lerp(Color3.new(1, 1, 1), 0.18)
			stroke.Transparency = 0.35
			stroke.Thickness = 1
		end

		local accentBar = card:FindFirstChild("Accent")
		if not accentBar then
			accentBar = make("Frame", card, {
				Name = "Accent",
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = accent,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, 3, 1, -18),
				ZIndex = card.ZIndex + 1,
			})
			make("UICorner", accentBar, { CornerRadius = UDim.new(1, 0) })
		end

		local titleObject = card:FindFirstChild("title")
		local textObject = card:FindFirstChild("text")
		if titleObject and titleObject:IsA("TextLabel") then
			titleObject.TextScaled = false
			titleObject.TextSize = 15
			titleObject.TextTruncate = Enum.TextTruncate.AtEnd
			titleObject.TextXAlignment = Enum.TextXAlignment.Left
			titleObject.Position = UDim2.fromOffset(16, 8)
			titleObject.Size = UDim2.new(1, -28, 0, 19)
			titleObject.ZIndex = card.ZIndex + 2
		end
		if textObject and textObject:IsA("TextLabel") then
			textObject.TextScaled = false
			textObject.TextSize = isToast and 14 or 13
			textObject.TextWrapped = not isToast
			textObject.TextTruncate = isToast and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None
			textObject.TextXAlignment = Enum.TextXAlignment.Left
			textObject.TextYAlignment = isToast and Enum.TextYAlignment.Center or Enum.TextYAlignment.Top
			textObject.Position = isToast and UDim2.fromOffset(16, 0) or UDim2.fromOffset(16, 30)
			textObject.Size = isToast and UDim2.new(1, -28, 1, 0) or UDim2.new(1, -28, 0, 48)
			textObject.ZIndex = card.ZIndex + 2
		end

		return titleObject, textObject
	end

	local function renumberStack(items, settings)
		for index, card in ipairs(items) do
			if card.Parent then
				animate(card, 0.18, { Position = stackPosition(settings, index) }, Enum.EasingStyle.Quart)
			end
		end
	end

	local function removeFromStack(items, card, settings)
		for index, existing in ipairs(items) do
			if existing == card then
				table.remove(items, index)
				break
			end
		end
		renumberStack(items, settings)
	end

	local function fadeAndDestroy(card, items, settings)
		if not card.Parent or card:GetAttribute("VexiumDismissing") then
			return
		end
		card:SetAttribute("VexiumDismissing", true)
		tweenCardAlpha(cardVisuals[card] or {}, 0.15, 1)
		local exitPosition = card.Position + UDim2.fromOffset(settings.entryOffset.X, settings.entryOffset.Y)
		animate(card, 0.15, { Position = exitPosition }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.17, function()
			removeFromStack(items, card, settings)
			cardVisuals[card] = nil
			if card.Parent then
				card:Destroy()
			end
		end)
	end

	local function makeNotification(notificationTitle, message, duration, isToast)
		if window._destroyed then
			return nil
		end
		local template = isToast and toastTemplate or notificationTemplate
		local card = template:Clone()
		local settings = stackSettings[isToast and "toast" or "notification"]
		card.Visible = true
		card.Parent = screenGui
		local titleObject, textObject = styleMessageCard(card, isToast)
		local items = isToast and activeToasts or activeNotifications
		if isToast then
			if textObject then
				textObject.Text = tostring(message or "")
			end
		else
			if titleObject then
				titleObject.Text = tostring(notificationTitle or "Notification")
			end
			if textObject then
				textObject.Text = tostring(message or "")
			end
		end

		card.Position = stackPosition(settings, #items + 1) + UDim2.fromOffset(settings.entryOffset.X, settings.entryOffset.Y)
		cardVisuals[card] = collectCardVisuals(card)
		setCardAlpha(cardVisuals[card], 1)
		table.insert(items, card)
		renumberStack(items, settings)
		tweenCardAlpha(cardVisuals[card], 0.2)
		local dismiss = createActivationButton(card, "Dismiss", UDim2.new(), UDim2.fromScale(1, 1), Vector2.zero, card.ZIndex + 8)
		local dismissBag = newConnectionBag(window)
		dismissBag:Connect(dismiss.Activated, function()
			fadeAndDestroy(card, items, settings)
		end)
		local lifetime = math.max(0, tonumber(duration) or 3)
		task.delay(lifetime, function()
			fadeAndDestroy(card, items, settings)
		end)
		return card
	end

	window.sendNotification = addMethod(window, function(notificationTitle, message, duration)
		return makeNotification(notificationTitle, message, duration, false)
	end)
	window.sendToast = addMethod(window, function(message, duration)
		return makeNotification(nil, message, duration, true)
	end)

	local function bindKeybind(control, keyCode)
		control.keyCode = keyCode
		control.inputBox.Text = control._listening and "Press key..." or (keyCode and keyCode.Name or "Key")
	end

	local function stopListening(control)
		if window._activeKeybind == control then
			window._activeKeybind = nil
		end
		control._listening = false
		control.inputBox.Text = control.keyCode and control.keyCode.Name or "Key"
	end

	local function startListening(control)
		if window._activeKeybind and window._activeKeybind ~= control then
			stopListening(window._activeKeybind)
		end
		window._activeKeybind = control
		control._listening = true
		control.inputBox.Text = "Press key..."
	end

	windowBag:Connect(UserInputService.InputBegan, function(input, gameProcessed)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local keyCode = input.KeyCode
		if window._activeKeybind then
			local control = window._activeKeybind
			if keyCode == Enum.KeyCode.Escape then
				control.inputBox:ReleaseFocus()
				stopListening(control)
			elseif keyCode ~= Enum.KeyCode.Unknown then
				bindKeybind(control, keyCode)
				control.inputBox:ReleaseFocus()
				stopListening(control)
			end
			return
		end
		if gameProcessed or UserInputService:GetFocusedTextBox() then
			return
		end
		if keyCode == window.toggleKey then
			window.toggle()
			return
		end
		for _, keybind in ipairs(window._keybinds) do
			if keybind.keyCode == keyCode then
				invoke(keybind.callback, keyCode)
			end
		end
	end)

	windowBag:Connect(minimizeButton.Activated, function()
		setMinimized(true)
	end)
	windowBag:Connect(maximizeButton.Activated, function()
		setMinimized(false)
	end)
	windowBag:Connect(unloadButton.Activated, function()
		window.destroy()
	end)

	window.createTab = addMethod(window, function(tabName)
		local name = tostring(tabName or ("Tab " .. tostring(#tabs + 1)))
		local page
		if #tabs == 0 then
			page = firstPage
			page.Name = "Tab_1"
		else
			page = pageTemplate:Clone()
			page.Name = "Tab_" .. tostring(#tabs + 1)
			page.Visible = false
			page.Parent = tabHolder
		end

		local pageTitle = page:FindFirstChild("_Title")
		if pageTitle and pageTitle:IsA("TextLabel") then
			pageTitle.Text = name
		end
		page.Visible = false
		local navButton = navButtonTemplate:Clone()
		navButton.Name = "TabButton_" .. tostring(#tabs + 1)
		navButton.Text = name
		navButton.LayoutOrder = #tabs + 1
		navButton.Visible = true
		navButton.Parent = tabButtons

		local tab = {
			name = name,
			_page = page,
			_button = navButton,
			_defaultButtonBackground = navButton.BackgroundColor3,
			_defaultButtonText = navButton.TextColor3,
			_selectedButtonBackground = navButton.BackgroundColor3:Lerp(Color3.new(1, 1, 1), 0.14),
			_hoverButtonBackground = navButton.BackgroundColor3:Lerp(Color3.new(1, 1, 1), 0.06),
			_controls = {},
			_nextLayoutOrder = 3,
		}
		navButton.AutoButtonColor = false

		local function selectTab()
			if activeTab == tab then
				return
			end
			for _, existingTab in ipairs(tabs) do
				existingTab._page.Visible = false
				animate(existingTab._button, 0.14, {
					BackgroundColor3 = existingTab._defaultButtonBackground,
					TextColor3 = existingTab._defaultButtonText,
				}, Enum.EasingStyle.Quad)
			end
			page.Visible = true
			local pageScale = page:FindFirstChild("_VexiumTabScale")
			if not pageScale then
				pageScale = make("UIScale", page, {
					Name = "_VexiumTabScale",
					Scale = 1,
				})
			end
			pageScale.Scale = 0.975
			animate(pageScale, 0.16, { Scale = 1 }, Enum.EasingStyle.Quart)
			animate(navButton, 0.14, {
				BackgroundColor3 = tab._selectedButtonBackground,
				TextColor3 = Color3.fromRGB(245, 245, 248),
			}, Enum.EasingStyle.Quad)
			activeTab = tab
			window._activeTab = tab
		end

		local tabBag = newConnectionBag(window)
		tabBag:Connect(navButton.Activated, selectTab)
		tabBag:Connect(navButton.MouseEnter, function()
			if activeTab ~= tab then
				animate(navButton, 0.12, { BackgroundColor3 = tab._hoverButtonBackground }, Enum.EasingStyle.Quad)
			end
		end)
		tabBag:Connect(navButton.MouseLeave, function()
			if activeTab ~= tab then
				animate(navButton, 0.12, { BackgroundColor3 = tab._defaultButtonBackground }, Enum.EasingStyle.Quad)
			end
		end)
		if not activeTab then
			selectTab()
		end
		table.insert(tabs, tab)

		local function cloneControl(templateName, order)
			local control = templates[templateName]:Clone()
			control.LayoutOrder = order or tab._nextLayoutOrder
			control.Visible = true
			tab._nextLayoutOrder = math.max(tab._nextLayoutOrder, control.LayoutOrder + 1)
			control.Parent = page
			return control
		end

		local function register(control)
			table.insert(tab._controls, control)
			return control
		end

		local function cloneHitbox(parent, name, position, size, anchorPoint, zIndex)
			return createActivationButton(parent, name, position, size, anchorPoint, zIndex)
		end

		tab.createButton = addMethod(tab, function(controlName, callback)
			local row = cloneControl("Button")
			row.Name = "Button"
			local nameLabel = row:FindFirstChild("Name")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Button")
			end
			local hitbox = cloneHitbox(row, "Action", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, row.ZIndex + 5)
			local bag = newConnectionBag(window)
			bag:Connect(hitbox.Activated, function()
				flashRow(row)
				invoke(callback)
			end)
			return register({ instance = row, button = hitbox })
		end)

		tab.createToggle = addMethod(tab, function(controlName, callback, initialValue)
			local row = cloneControl("Toggle")
			row.Name = "Toggle"
			local nameLabel = row:FindFirstChild("Name")
			local toggleBack = row:FindFirstChild("ToggleBtnBack")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Toggle")
			end
			assert(toggleBack and toggleBack:IsA("GuiObject"), "Toggle template is missing ToggleBtnBack.")
			local value = not not initialValue
			local originalColor = toggleBack.BackgroundColor3
			local toggleTween
			local function set(nextValue, notify)
				value = not not nextValue
				if toggleTween then
					toggleTween:Cancel()
				end
				toggleTween = animate(toggleBack, 0.14, {
					BackgroundColor3 = value and TOGGLE_ENABLED_COLOR or originalColor,
				}, Enum.EasingStyle.Quad)
				bounce(toggleBack, "_VexiumToggleScale")
				if notify then
					invoke(callback, value)
				end
			end
			local hitbox = cloneHitbox(row, "ToggleAction", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, row.ZIndex + 5)
			local bag = newConnectionBag(window)
			bag:Connect(hitbox.Activated, function()
				set(not value, true)
			end)
			set(value, false)
			return attachHandleMethods(register({ instance = row, button = hitbox }), set, function()
				return value
			end)
		end)

		tab.createLabel = addMethod(tab, function(text)
			local row = cloneControl("Label")
			row.Name = "Label"
			local nameLabel = row:FindFirstChild("Name")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(text or "")
			end
			local function set(value)
				if nameLabel then
					nameLabel.Text = tostring(value or "")
				end
			end
			return attachHandleMethods(register({ instance = row, label = nameLabel }), set)
		end)

		tab.createDivider = addMethod(tab, function()
			local row = cloneControl("Divider")
			row.Name = "Divider"
			return register({ instance = row })
		end)

		tab.createInput = addMethod(tab, function(controlName, callback, placeholder)
			local row = cloneControl("Input")
			row.Name = "Input"
			local nameLabel = row:FindFirstChild("Name")
			local textBox = row:FindFirstChild("InputBox")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Input")
			end
			assert(textBox and textBox:IsA("TextBox"), "Input template is missing InputBox.")
			textBox.Text = ""
			textBox.PlaceholderText = tostring(placeholder or "")
			local inputStroke = textBox:FindFirstChildWhichIsA("UIStroke")
			local inputBackground = textBox.BackgroundColor3
			local inputStrokeColor = inputStroke and inputStroke.Color
			local inputStrokeTransparency = inputStroke and inputStroke.Transparency
			local bag = newConnectionBag(window)
			bag:Connect(textBox.Focused, function()
				animate(textBox, 0.12, {
					BackgroundColor3 = inputBackground:Lerp(accent, 0.22),
				}, Enum.EasingStyle.Quad)
				if inputStroke then
					animate(inputStroke, 0.12, {
						Color = accent,
						Transparency = 0,
					}, Enum.EasingStyle.Quad)
				end
			end)
			bag:Connect(textBox.FocusLost, function()
				animate(textBox, 0.14, { BackgroundColor3 = inputBackground }, Enum.EasingStyle.Quad)
				if inputStroke then
					animate(inputStroke, 0.14, {
						Color = inputStrokeColor,
						Transparency = inputStrokeTransparency,
					}, Enum.EasingStyle.Quad)
				end
				invoke(callback, textBox.Text)
			end)
			local function set(value)
				textBox.Text = tostring(value or "")
			end
			local control = register({ instance = row, textBox = textBox })
			return attachHandleMethods(control, set, function()
				return textBox.Text
			end)
		end)

		tab.createKeybind = addMethod(tab, function(controlName, callback, initialKey)
			local row = cloneControl("Keybind")
			row.Name = "Keybind"
			local nameLabel = row:FindFirstChild("Name")
			local textBox = row:FindFirstChild("InputBox")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Keybind")
			end
			assert(textBox and textBox:IsA("TextBox"), "Keybind template is missing InputBox.")
			local keyCode = normalizeKeyCode(initialKey)
			local keyStroke = textBox:FindFirstChildWhichIsA("UIStroke")
			local keyBackground = textBox.BackgroundColor3
			local keyStrokeColor = keyStroke and keyStroke.Color
			local keyStrokeTransparency = keyStroke and keyStroke.Transparency
			local control = {
				instance = row,
				inputBox = textBox,
				keyCode = keyCode,
				callback = callback,
				_listening = false,
			}
			textBox.ClearTextOnFocus = false
			textBox.Text = keyCode and keyCode.Name or "Key"

			local function set(value)
				keyCode = normalizeKeyCode(value)
				control.keyCode = keyCode
				if not control._listening then
					textBox.Text = keyCode and keyCode.Name or "Key"
				end
			end
			local bag = newConnectionBag(window)
			bag:Connect(textBox.Focused, function()
				animate(textBox, 0.12, {
					BackgroundColor3 = keyBackground:Lerp(accent, 0.22),
				}, Enum.EasingStyle.Quad)
				if keyStroke then
					animate(keyStroke, 0.12, { Color = accent, Transparency = 0 }, Enum.EasingStyle.Quad)
				end
				startListening(control)
			end)
			bag:Connect(textBox.FocusLost, function()
				animate(textBox, 0.14, { BackgroundColor3 = keyBackground }, Enum.EasingStyle.Quad)
				if keyStroke then
					animate(keyStroke, 0.14, {
						Color = keyStrokeColor,
						Transparency = keyStrokeTransparency,
					}, Enum.EasingStyle.Quad)
				end
				if window._activeKeybind == control then
					window._activeKeybind = nil
				end
				control._listening = false
				textBox.Text = keyCode and keyCode.Name or "Key"
			end)
			table.insert(window._keybinds, control)
			return attachHandleMethods(register(control), set, function()
				return keyCode
			end)
		end)

		tab.createSlider = addMethod(tab, function(controlName, minimum, maximum, callback, step)
			local minValue = tonumber(minimum) or 0
			local maxValue = tonumber(maximum) or 100
			assert(maxValue >= minValue, "Slider maximum must be greater than or equal to its minimum.")
			local increment = tonumber(step) or 1
			if increment <= 0 then
				increment = 1
			end
			local row = cloneControl("Slider")
			row.Name = "Slider"
			local nameLabel = row:FindFirstChild("Name")
			local track = row:FindFirstChild("slider_bg")
			local dot = track and track:FindFirstChild("slider_dot")
			local valueLabel = row:FindFirstChild("Value_Label")
			if nameLabel and nameLabel:IsA("TextLabel") then
				nameLabel.Text = tostring(controlName or "Slider")
				nameLabel.Size = UDim2.new(1, -68, 0, 20)
				nameLabel.Position = UDim2.fromOffset(0, 1)
				nameLabel.TextSize = 16
				nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
			end
			assert(track and dot and valueLabel, "Slider template is missing its track, dot, or value label.")
			row.Size = UDim2.new(row.Size.X.Scale, row.Size.X.Offset, 0, 44)
			track.Active = true
			track.Size = UDim2.fromOffset(205, 4)
			track.Position = UDim2.new(0.5, 0, 0.78, 0)
			dot.ZIndex = track.ZIndex + 2
			valueLabel.Size = UDim2.fromOffset(44, 20)
			valueLabel.Position = UDim2.new(1, -26, 0, 11)
			valueLabel.TextScaled = false
			valueLabel.TextSize = 16
			valueLabel.TextTruncate = Enum.TextTruncate.AtEnd

			local fill = make("Frame", track, {
				Name = "Fill",
				Active = false,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(177, 177, 177),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(0, 0, 1, 0),
				ZIndex = track.ZIndex + 1,
			})
			make("UICorner", fill, { CornerRadius = UDim.new(1, 0) })
			local dragSurface = cloneHitbox(
				track,
				"DragSurface",
				UDim2.new(0, -8, 0.5, 0),
				UDim2.new(1, 16, 0, 24),
				Vector2.new(0, 0.5),
				track.ZIndex + 4
			)

			local value = minValue
			local dotTween
			local fillTween
			local function updateVisuals()
				local alpha = maxValue == minValue and 0 or (value - minValue) / (maxValue - minValue)
				if dotTween then
					dotTween:Cancel()
				end
				if fillTween then
					fillTween:Cancel()
				end
				dotTween = animate(dot, 0.1, { Position = UDim2.new(alpha, 0, 0.5, 0) }, Enum.EasingStyle.Quad)
				fillTween = animate(fill, 0.1, { Size = UDim2.new(alpha, 0, 1, 0) }, Enum.EasingStyle.Quad)
				valueLabel.Text = formatNumber(value)
			end
			local function set(nextValue, notify)
				local number = math.clamp(tonumber(nextValue) or minValue, minValue, maxValue)
				if maxValue > minValue and number > minValue and number < maxValue then
					number = minValue + math.round((number - minValue) / increment) * increment
					number = math.clamp(number, minValue, maxValue)
				end
				local changed = number ~= value
				value = number
				updateVisuals()
				if notify and changed then
					invoke(callback, value)
				end
			end
			local function updateFromInput(input)
				local width = track.AbsoluteSize.X
				if width <= 0 then
					return
				end
				local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / width, 0, 1)
				set(minValue + (maxValue - minValue) * alpha, true)
			end
			updateVisuals()

			local activeInput
			local bag = newConnectionBag(window)
			local function startDrag(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					activeInput = input
					bounce(dot, "_VexiumDotScale")
					updateFromInput(input)
				end
			end
			bag:Connect(dragSurface.InputBegan, startDrag)
			bag:Connect(UserInputService.InputChanged, function(input)
				local mouseDrag = activeInput and activeInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
				local touchDrag = activeInput and activeInput.UserInputType == Enum.UserInputType.Touch and input == activeInput
				if mouseDrag or touchDrag then
					updateFromInput(input)
				end
			end)
			bag:Connect(UserInputService.InputEnded, function(input)
				if activeInput and (input == activeInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
					activeInput = nil
				end
			end)

			return attachHandleMethods(register({ instance = row }), set, function()
				return value
			end)
		end)
		tab.CreateSlider = tab.createSlider

		tab.createDropdown = addMethod(tab, function(controlName, options, callback, initialValue)
			local optionList = type(options) == "table" and options or {}
			local order = tab._nextLayoutOrder
			local closed = cloneControl("Dropdown_Closed", order)
			local opened = cloneControl("Dropdown_Opened", order)
			closed.Name = "Dropdown_Closed"
			opened.Name = "Dropdown_Opened"
			opened.Visible = false
			local closedName = closed:FindFirstChild("Name")
			local closedPick = closed:FindFirstChild("Pick")
			local openName = opened:FindFirstChild("Name")
			local openPick = opened:FindFirstChild("Pick")
			local optionScroll = opened:FindFirstChild("Options")
			if closedName then closedName.Text = tostring(controlName or "Dropdown") end
			if openName then openName.Text = tostring(controlName or "Dropdown") end
			assert(closedPick and openPick and optionScroll, "Dropdown template is missing Name, Pick, or Options.")
			optionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
			optionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

			local selected = initialValue
			if selected == nil then
				selected = "Dropdown"
			end
			closedPick.Text = tostring(selected)
			openPick.Text = tostring(selected)

			for _, child in ipairs(optionScroll:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end
			local extraHeight = math.max(0, #optionList - 2) * 30
			if extraHeight > 0 then
				opened.Size = UDim2.new(opened.Size.X.Scale, opened.Size.X.Offset, opened.Size.Y.Scale, opened.Size.Y.Offset + extraHeight)
				optionScroll.Size = UDim2.new(optionScroll.Size.X.Scale, optionScroll.Size.X.Offset, optionScroll.Size.Y.Scale, optionScroll.Size.Y.Offset + extraHeight)
			end

			local value = selected
			local dropdownOpen = false
			local openRevision = 0
			local dropdownScale = make("UIScale", opened, {
				Name = "_VexiumDropdownScale",
				Scale = 1,
			})
			local function setOpen(shouldOpen)
				if shouldOpen == dropdownOpen then
					return
				end
				dropdownOpen = shouldOpen
				openRevision += 1
				local revision = openRevision
				if shouldOpen then
					closed.Visible = false
					opened.Visible = true
					dropdownScale.Scale = 0.94
					animate(dropdownScale, 0.14, { Scale = 1 }, Enum.EasingStyle.Quart)
				else
					animate(dropdownScale, 0.1, { Scale = 0.96 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					task.delay(0.11, function()
						if revision == openRevision and not dropdownOpen and opened.Parent then
							opened.Visible = false
							closed.Visible = true
							dropdownScale.Scale = 1
						end
					end)
				end
			end
			local function set(nextValue, notify)
				value = nextValue
				closedPick.Text = tostring(nextValue)
				openPick.Text = tostring(nextValue)
				setOpen(false)
				if notify then
					invoke(callback, nextValue)
				end
			end

			for index, option in ipairs(optionList) do
				local optionValue = option
				local optionFrame = optionTemplate:Clone()
				optionFrame.Name = "Option_" .. tostring(index)
				optionFrame.LayoutOrder = index
				optionFrame.Visible = true
				optionFrame.Parent = optionScroll
				local optionLabel = optionFrame:FindFirstChild("Name")
				if optionLabel and optionLabel:IsA("TextLabel") then
					optionLabel.Text = tostring(optionValue)
				end
				local optionHitbox = cloneHitbox(optionFrame, "SelectOption", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, optionFrame.ZIndex + 5)
				local optionBag = newConnectionBag(window)
				optionBag:Connect(optionHitbox.Activated, function()
					set(optionValue, true)
				end)
			end

			local closedHitbox = cloneHitbox(closed, "OpenDropdown", UDim2.new(0, 0, 0, 0), UDim2.fromScale(1, 1), Vector2.zero, closed.ZIndex + 5)
			local openedHitbox = cloneHitbox(opened, "CloseDropdown", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), Vector2.zero, opened.ZIndex + 4)
			local bag = newConnectionBag(window)
			bag:Connect(closedHitbox.Activated, function()
				setOpen(true)
			end)
			bag:Connect(openedHitbox.Activated, function()
				setOpen(false)
			end)

			local control = register({ instance = closed, openedInstance = opened })
			return attachHandleMethods(control, set, function()
				return value
			end)
		end)

		return tab
	end)

	window.destroy = function()
		if window._destroyed then
			return
		end
		window._destroyed = true
		for _, bag in ipairs(window._bags) do
			bag:DisconnectAll()
		end
		if currentSizeTween then
			currentSizeTween:Cancel()
		end
		if currentDragTween then
			currentDragTween:Cancel()
		end
		for _, tween in ipairs(chromeTweens) do
			tween:Cancel()
		end
		if screenGui.Parent then
			screenGui:Destroy()
		end
		if staticMockup and staticMockup.Parent and staticMockupWasEnabled then
			local otherWindowExists = false
			for _, child in ipairs(playerGui:GetChildren()) do
				if child ~= screenGui and child:IsA("ScreenGui") and child:GetAttribute("VexiumLibraryWindow") then
					otherWindowExists = true
					break
				end
			end
			if not otherWindowExists then
				staticMockup.Enabled = true
			end
		end
	end
	window.unload = window.destroy
	window.Destroy = window.destroy
	window.Unload = window.destroy

	windowBag:Connect(screenGui.Destroying, function()
		if window._destroyed then
			return
		end
		window._destroyed = true
		for _, bag in ipairs(window._bags) do
			bag:DisconnectAll()
		end
	end)

	return window
end

library.window = addMethod(library, makeWindow)
library.Window = library.window

return library
