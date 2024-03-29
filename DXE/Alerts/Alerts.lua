-- Based off RDX's alert system

local defaults = {
	profile = {
		-- Top
		TopScale = 0.9,
		TopGrowth = "DOWN",
		TopAlpha = 0.55,
		TopBarWidth = 250,
		-- Center
		CenterScale = 0.9,
		CenterGrowth = "DOWN",
		CenterAlpha = 0.75,
		CenterBarWidth = 275,
		-- Warning Bars
		WarningBars = true,
		WarningAnchor = false,
		WarningMessages = false,
		WarningScale = 0.9,
		WarningGrowth = "DOWN",
		WarningAlpha = 0.75,
		WarningBarWidth = 275,
		RedirectCenter = false,
		RedirectThreshold = 5,
		-- Warning Messages
		BeforeThreshold = 5,
		ClrWarningText = true,
		SinkStorage = {},
		SinkIcon = true,
		AnnounceToRaid = false,
		CdPopupMessage = false,
		CdBeforeMessage = true,
		DurPopupMessage = true,
		DurBeforeMessage = true,
		WarnPopupMessage = true,
		-- Flash
		FlashAlpha = 0.6,
		FlashDuration = 0.8,
		EnableOscillations = true,
		FlashOscillations = 2,
		FlashTexture = "Interface\\Tooltips\\UI-Tooltip-Background",
		ConstantClr = false,
		GlobalColor = {1,0,0},
		-- Text
		CenterTextWidth = 200,
		WarningTextWidth = 200,
		TopTextWidth = 180,
		TextXOffset = 5,
		TextYOffset = 0,
		TextAlpha = 1,
		-- Bar
		BarTextJustification = "CENTER",
		BarFontSize = 10,
		BarFillDirection = "FILL",
		BarFontColor = {1,1,1,1},
		BarHeight = 30,
		BarSpacing = 0,
		-- Timer
		TimerFontColor = {1,1,1,1},
		TimerXOffset = -5,
		TimerYOffset = 0,
		TimerAlpha = 1,
		TimerSecondsFontSize = 20,
		TimerDecimalFontSize = 12,
		ScaleTimerWithBarHeight = true,
		DecimalYOffset = 2,
		-- Icon
		IconXOffset = 0,
		IconYOffset = 0,
		IconSize = 30,
		SetIconToBarHeight = true,
		ShowLeftIcon = true,
		ShowRightIcon = false,
		-- Toggles
		DisableDropdowns = false,
		DisableScreenFlash = false,
		DisableSounds = false,
		ShowBarBorder = true,
		ShowIconBorder = true,
		-- Custom Bars
		CustomLocalClr = "TAN",
		CustomRaidClr = "TAN",
		CustomSound = "ALERT10",
	}
}

local addon = DXE
local L = addon.L
local CN = addon.CN
local NID = addon.NID
local AceTimer = LibStub("AceTimer-3.0")

local Colors = addon.Media.Colors
local GetTime,PlaySoundFile = GetTime,PlaySoundFile
local ipairs,pairs,next,remove = ipairs,pairs,next,table.remove
local util = addon.util
local find = string.find

local ANIMATION_TIME = 0.3
local FADE_TIME = 2
local INSET = 2
local ANNOUNCE_FORMAT = "*** %s ***"

local db,pfl

---------------------------------------
-- INITIALIZATION
---------------------------------------

local module = addon:NewModule("Alerts","LibSink-2.0")
addon.Alerts = module
local Active = {}
local TopAlertStack = {}
local CenterAlertStack = {}
local WarningAlertStack = {}
local BarPool = {}
local prototype = {}

local TopStackAnchor,CenterStackAnchor,WarningStackAnchor

function module:RefreshProfile()
	pfl = db.profile
	self:RefreshBars()
	self:SetSinkStorage(pfl.SinkStorage)
	self:UpdateFlashSettings()
end

function module:OnInitialize()
	-- Top stack anchor
	TopStackAnchor = addon:CreateLockableFrame("AlertsTopStackAnchor",245,10,format("%s - %s",L["Alerts"],L["Bar Top Anchor"]))
	addon:RegisterMoveSaving(TopStackAnchor,"TOP","UIParent","TOP",0,-16)
	addon:LoadPosition("DXEAlertsTopStackAnchor")

	-- Bottom stack anchor
	CenterStackAnchor = addon:CreateLockableFrame("AlertsCenterStackAnchor",245,10,format("%s - %s",L["Alerts"],L["Bar Center Anchor"]))
	addon:RegisterMoveSaving(CenterStackAnchor,"CENTER","UIParent","CENTER",0,100)
	addon:LoadPosition("DXEAlertsCenterStackAnchor")

	WarningStackAnchor = addon:CreateLockableFrame("AlertsWarningStackAnchor",245,10,format("%s - %s",L["Alerts"],L["Bar Warning Anchor"]))
	addon:RegisterMoveSaving(WarningStackAnchor,"CENTER","UIParent","CENTER",0,210)
	addon:LoadPosition("DXEAlertsWarningStackAnchor")

	self.db = addon.db:RegisterNamespace("Alerts", defaults)
	db = self.db
	pfl = db.profile

	self:SetSinkStorage(pfl.SinkStorage)
	self:UpdateFlashSettings()

	db.RegisterCallback(self, "OnProfileChanged", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshProfile")
	db.RegisterCallback(self, "OnProfileReset", "RefreshProfile")
end

function module:OnDisable()
	self:QuashAll()
end

---------------------------------------
-- AUDIO COUNTDOWN
---------------------------------------
local CDList = {
	"Interface\\Addons\\DXE\\Sounds\\1.mp3",
	"Interface\\Addons\\DXE\\Sounds\\2.mp3",
	"Interface\\Addons\\DXE\\Sounds\\3.mp3",
	"Interface\\Addons\\DXE\\Sounds\\4.mp3",
	"Interface\\Addons\\DXE\\Sounds\\5.mp3",
	"Interface\\Addons\\DXE\\Sounds\\6.mp3",
	"Interface\\Addons\\DXE\\Sounds\\7.mp3",
	"Interface\\Addons\\DXE\\Sounds\\8.mp3",
	"Interface\\Addons\\DXE\\Sounds\\9.mp3",
	"Interface\\Addons\\DXE\\Sounds\\10.mp3",
}

local function Sound(...)
	if pfl.MasterSound then
		PlaySoundFile(...,"Master")
	else
		PlaySoundFile(...)
	end
end

function module:SoundT(...)
	Sound(...)
end



function prototype:PlayAudioCountdown(sound)
	--print("sdasd",sound)
	Sound(sound)
end

function prototype:AudioCountdown(totaltime)
--	print("SDF",totaltime)
	--totaltime = totaltime + 1
	for i,sound in ipairs(CDList) do
--		print("SDF2",totaltime - i)
		if totaltime - i == 0 then break end
		self:ScheduleTimer("PlayAudioCountdown",totaltime - i,sound)
	end
end

function prototype:CancelAudioCountdown()
	self:CancelAllTimers()
end

---------------------------------------
-- UTILITY
---------------------------------------

local SM = LibStub("LibSharedMedia-3.0")
local Sounds = addon.Media.Sounds
local floor = math.floor
local ceil = math.ceil
local gsub = string.gsub

local function GetMedia(sound,c1,c2)
	return Sounds:GetFile(sound),Colors[c1],Colors[c2]
end

local function GetMessageEra(id)
	local popup,before

	if id == nil then return popup,before end

	if find(id,"cd$") then
		popup = pfl.CdPopupMessage
		before = pfl.CdBeforeMessage
	elseif find(id,"dur$") then
		popup = pfl.DurPopupMessage
		before = pfl.DurBeforeMessage
	elseif find(id,"self$") then
		popup = pfl.DurPopupMessage
	elseif find(id,"warn$") then
		popup = pfl.WarnPopupMessage
	end

	return popup,before
end

local function MMSS(time)
	local min = floor(time/60)
	local sec = ceil(time % 60)
	return ("%d:%02d"):format(min,sec)
end

local ColorText

do
	local function colorlist(word,comma)
		return CN[word]..comma
	end

	local function helper(prefix,word)
		-- comma separated
		if find(word,"^[^ ,]+,") then
			return prefix..gsub(word,"([^ ,]+)(,?)",colorlist)
		else
			return prefix..CN[word]
		end
	end

	function ColorText(text)
		return (gsub(text,"^(.+: )([^!.]+)",helper))
	end
end

local function Pour(text,icon,color)
	color = color or Colors.WHITE
	if not pfl.SinkIcon then icon = nil end
	local pour_text = pfl.ClrWarningText and ColorText(text) or text
	module:Pour(pour_text,color.r,color.g,color.b,nil,nil,nil,nil,nil,icon)
	local no_you = not find(text,L.alert["YOU"])
	if no_you and pfl.AnnounceToRaid and addon:IsPromoted() and addon.GroupType == "RAID" then
		-- color coded text disconnects the user!!!
		text = gsub(text,"|c%x%x%x%x%x%x%x%x(.-)|r","%1")
		SendChatMessage(format(ANNOUNCE_FORMAT,text),"RAID_WARNING")
--		print(text)
	end
end

---------------------------------------------
-- SCREEN FLASH
---------------------------------------------

do
	local FLASH_DURATION,PERIOD,AMP,MULT,OSC

	local flash = CreateFrame("Frame","DXEAlertsFlash",UIParent)
	flash:SetFrameStrata("BACKGROUND")
	local t = flash:CreateTexture(nil,"BACKGROUND")
	t:SetAllPoints(true)
	flash:SetAllPoints(true)
	flash:Hide()

	local counter
	local function OnUpdate(self,elapsed)
		counter = counter + elapsed
		if counter > FLASH_DURATION then self:Hide() end
		if OSC then
			local p = counter % PERIOD
			if p > AMP then p = PERIOD - p end
			self:SetAlpha(p * MULT)
		end
	end

	flash:SetScript("OnUpdate",OnUpdate)

	module.FlashTextures = {
		["Interface\\Tooltips\\UI-Tooltip-Background"] = L["Solid"],
		["Interface\\Addons\\DXE\\Textures\\LowHealthGray"] = L["Low Health"],
	}

	function module:UpdateFlashSettings()
		t:SetTexture(pfl.FlashTexture)
	end

	function module:FlashScreen(c)
		if pfl.DisableScreenFlash then return end
		if pfl.ConstantClr then
			local r,g,b = unpack(pfl.GlobalColor)
			t:SetVertexColor(r,g,b,pfl.FlashAlpha)
		else
			c = c or Colors.BLACK
			t:SetVertexColor(c.r,c.g,c.b,pfl.FlashAlpha)
		end
		counter = 0
		OSC = pfl.EnableOscillations
		FLASH_DURATION = pfl.FlashDuration
		PERIOD = FLASH_DURATION / pfl.FlashOscillations
		AMP = PERIOD / 2
		MULT = 1 / AMP
		flash:SetAlpha(OSC and 0 or 1)
		flash:Show()
	end
end

---------------------------------------
-- UPDATING
---------------------------------------

local function OnUpdate(self,elapsed)
	local bar = next(Active)
	if not bar then self:Hide() return end
	local time = GetTime()
	while bar do
		if bar.countFunc then bar:countFunc(time) end
		if bar.animFunc then bar:animFunc(time) end
		bar = next(Active,bar)
	end
end

local UpdateFrame = CreateFrame("Frame",nil,UIParent)
UpdateFrame:SetScript("OnUpdate",OnUpdate)
UpdateFrame:Hide()

---------------------------------------
-- PROTOTYPE
---------------------------------------
local wipe = table.wipe

function prototype:SetColor(c1,c2)
	self.data.c1 = c1
	self.statusbar:SetStatusBarColor(c1.r,c1.g,c1.b)
	self.data.c2 = c2 or c1
end

function prototype:Destroy()
	self:Hide()
	self:ClearAllPoints()
	self:UnregisterAllEvents()
	self:RemoveFromStacks()
	self:CancelAllTimers()
	self.countFunc = nil
	self.animFunc = nil
	self.statusbar:SetValue(0)
	Active[self] = nil
	UIFrameFadeRemoveFrame(self)
	BarPool[self] = true
	wipe(self.data)
	self.timer:Show()
	self.lefticon:Hide()
	self.lefticon.t:SetTexture("")
	self.righticon:Hide()
	self.righticon.t:SetTexture("")
	self.bmsg = nil
	self.orig_text = nil
end

do
	local function SortDesc(a1, a2)
		return (a1.data.timeleft or 10000) > (a2.data.timeleft or 10000)
	end

	function prototype:LayoutAlertStack(stack,anchor,growth)
		sort(stack, SortDesc)
		local point,relpoint,mult
		if growth == "DOWN" then
			point,relpoint,mult = "TOP","BOTTOM",-1
		elseif growth == "UP" then
			point,relpoint,mult = "BOTTOM","TOP",1
		end
		for i,bar in ipairs(stack) do
			bar:ClearAllPoints()
			bar:SetPoint(point,anchor,relpoint,0,mult*(i-1)*(pfl.BarHeight + pfl.BarSpacing))
		end
	end
end

function prototype:AnchorToTop()
	self.data.anchor = "TOP"
	self:SetAlpha(pfl.TopAlpha)
	self:SetScale(pfl.TopScale)
	self:SetWidth(pfl.TopBarWidth)
	self.text:SetWidth(pfl.TopTextWidth)
	self:RemoveFromStacks()
	TopAlertStack[#TopAlertStack+1] = self
	self:LayoutAlertStack(TopAlertStack, TopStackAnchor, pfl.TopGrowth)
end

function prototype:AnchorToCenter()
	if self.data.sound and not pfl.DisableSounds then PlaySoundFile(self.data.sound) end
	self.data.anchor = "CENTER"
	self:SetAlpha(pfl.CenterAlpha)
	self:SetScale(pfl.CenterScale)
	self:SetWidth(pfl.CenterBarWidth)
	self.text:SetWidth(pfl.CenterTextWidth)
	self:RemoveFromStacks()
	CenterAlertStack[#CenterAlertStack+1] = self
	self:LayoutAlertStack(CenterAlertStack, CenterStackAnchor, pfl.CenterGrowth)
end

function prototype:AnchorToWarning()
	if self.data.sound and not pfl.DisableSounds then PlaySoundFile(self.data.sound) end
	self.data.anchor = "WARNING"
	self:SetAlpha(pfl.WarningAlpha)
	self:SetScale(pfl.WarningScale)
	self:SetWidth(pfl.WarningBarWidth)
	self.text:SetWidth(pfl.WarningTextWidth)
	self:RemoveFromStacks()
	WarningAlertStack[#WarningAlertStack+1] = self
	self:LayoutAlertStack(WarningAlertStack, WarningStackAnchor, pfl.WarningGrowth)
end

do
	local UIParent = UIParent
	local function AnimationFunc(self,time)
		local data = self.data
		local perc = (time - data.t0) / ANIMATION_TIME
		if perc < 0 or perc > 1 then
			self.animFunc = nil
			self:AnchorToCenter()
			if self.data.flashscreen then
				module:FlashScreen(self.data.c1)
			end
		else
			local a = pfl.TopAlpha + ((pfl.CenterAlpha - pfl.TopAlpha) * perc)
			self:SetAlpha(a)

			local s = pfl.TopScale + ((pfl.CenterScale - pfl.TopScale) * perc)
			self:SetScale(s)

			local w = pfl.TopBarWidth + ((pfl.CenterBarWidth - pfl.TopBarWidth) * perc)
			self:SetWidth(w)

			local escale = self:GetEffectiveScale()
			local x = (data.fx + ((data.tox - data.fx) * perc)) / escale
			local y = (data.fy + ((data.toy - data.fy) * perc)) / escale
			self:ClearAllPoints()
			self:SetPoint("CENTER",UIParent,"BOTTOMLEFT",x,y)
		end
	end

	function prototype:TranslateToCenter()
		self.data.anchor = nil
		self:RemoveFromStacks()
		local x,y = self:GetCenter()
		self:ClearAllPoints()
		self:SetPoint("CENTER",UIParent,"BOTTOMLEFT",x,y)
		self:LayoutAlertStack(TopAlertStack, TopStackAnchor, pfl.TopGrowth)

		local worldscale,escale = UIParent:GetEffectiveScale(),self:GetEffectiveScale()
		local fx,fy = x*escale, y*escale
		local cx,cy = CenterStackAnchor:GetCenter()
		local mult = pfl.CenterGrowth == "DOWN" and -1 or 1
		cy = cy + mult*5 -- CenterStackAnchor:GetHeight() / 2

		local offset = (pfl.BarHeight * #CenterAlertStack + pfl.BarHeight/2) * (pfl.CenterScale * worldscale)
		local tox,toy = cx*worldscale,cy*worldscale
		toy = toy + mult*(offset)

		local data = self.data
		data.t0 = GetTime()
		data.fx = fx
		data.fy = fy
		data.tox = tox
		data.toy = toy
		self.animFunc = AnimationFunc
	end
end

function prototype:RemoveFromStack(stack)
	for i,bar in ipairs(stack) do
		if bar == self then
			remove(stack,i)
			return
		end
	end
end

function prototype:RemoveFromStacks()
	self:RemoveFromStack(TopAlertStack)
	self:RemoveFromStack(CenterAlertStack)
	self:RemoveFromStack(WarningAlertStack)
end

do
	local function CountdownFunc(self,time)
		local timeleft = self.data.endTime - time
		local data = self.data
		data.timeleft = timeleft
		if timeleft < 0 then
			self.countFunc = nil
			self.timer:SetTime(0)
			return
		end
		self.timer:SetTime(timeleft)
		local value = 1 - (timeleft / data.totalTime)
		self.statusbar:SetValue(pfl.BarFillDirection == "FILL" and value or 1 - value)

		if pfl.WarningMessages and self.bmsg and timeleft <= pfl.BeforeThreshold then
			self.bmsg = nil
			Pour(self.orig_text..L.alert[" in "]..MMSS(timeleft),data.icon,data.c1)
		end
	end

	local cos = math.cos
	local function CountdownFlashFunc(self,time)
		local data = self.data
		local timeleft = data.endTime - time
		self.data.timeleft = timeleft
		if timeleft < 0 then
			self.countFunc = nil
			self.timer:SetTime(0)
			return
		end
		self.timer:SetTime(timeleft)
		local value = 1 - (timeleft / data.totalTime)
		self.statusbar:SetValue(pfl.BarFillDirection == "FILL" and value or 1 - value)
		if timeleft < data.flashTime then
			self.statusbar:SetStatusBarColor(util.blend(data.c1, data.c2, 0.5*(cos(timeleft*12) + 1)))
		end

		if pfl.WarningMessages and self.bmsg and timeleft <= pfl.BeforeThreshold then
			self.bmsg = nil
			Pour(self.orig_text..L.alert[" in "]..MMSS(timeleft),data.icon,data.c1)
		end
	end

	-- for absorb bar
	local function CountdownNoSetFlashFunc(self,time)
		local data = self.data
		local timeleft = data.endTime - time
		self.data.timeleft = timeleft
		if timeleft < 0 then
			self.countFunc = nil
			self.timer:SetTime(0)
			return
		end
		self.timer:SetTime(timeleft)
		if timeleft < data.flashTime then
			self.statusbar:SetStatusBarColor(util.blend(data.c1, data.c2, 0.5*(cos(timeleft*12) + 1)))
		end
	end

	function prototype:Countdown(totalTime, flashTime, noset)
		local endTime = GetTime() + totalTime
		self.data.endTime,self.data.totalTime = endTime, totalTime
		if noset then
			self.data.flashTime = flashTime
			self.countFunc = CountdownNoSetFlashFunc
		elseif flashTime and self.data.c1 ~= self.data.c2 then
			self.data.flashTime = flashTime
			self.countFunc = CountdownFlashFunc
		else
			self.countFunc = CountdownFunc
		end
	end
end

function prototype:Fade()
	local fadeTable = self.fadeTable
	fadeTable.startAlpha = self:GetAlpha()
	fadeTable.fadeTimer = 0
	fadeTable.finishedFunc = self.Destroy
	UIFrameFade(self,fadeTable)
end

function prototype:SetID(id)
	self.data.id = id
end

function prototype:GetID(id)
	return self.data.id
end

function prototype:SetTimeleft(timeleft)
	self.data.timeleft = timeleft
end

function prototype:SetSound(sound)
	self.data.sound = sound
end

function prototype:SetFlashScreen(flashscreen)
	self.data.flashscreen = flashscreen
end

function prototype:SetText(text)
	self.text:SetText(ColorText(text))
	self.orig_text = text
end

function prototype:SetIcon(texture)
	if not texture then
		self.lefticon:Hide()
		self.righticon:Hide()
		return
	end

	self.data.icon = texture

	if pfl.ShowLeftIcon then
		self.lefticon:Show()
		self.lefticon.t:SetTexture(texture)
	end

	if pfl.ShowRightIcon then
		self.righticon:Show()
		self.righticon.t:SetTexture(texture)
	end
end

function prototype:FireBeforeMsg() self.bmsg = true end

local function SkinBar(bar)
	if not pfl.ShowLeftIcon then bar.lefticon:Hide() end
	if not pfl.ShowRightIcon then bar.righticon:Hide() end
	bar:SetIcon(bar.data.icon)

	bar.statusbar:ClearAllPoints()
	bar.lefticon.t:ClearAllPoints()
	bar.righticon.t:ClearAllPoints()
	bar.bg:ClearAllPoints()

	if pfl.ShowBarBorder then
		bar.border:Show()
		bar.bg:SetPoint("TOPLEFT",INSET,-INSET)
		bar.bg:SetPoint("BOTTOMRIGHT",-INSET,INSET)
		bar.statusbar:SetPoint("TOPLEFT",INSET,-INSET)
		bar.statusbar:SetPoint("BOTTOMRIGHT",-INSET,INSET)
	else
		bar.border:Hide()
		bar.statusbar:SetPoint("TOPLEFT")
		bar.statusbar:SetPoint("BOTTOMRIGHT")
		bar.bg:SetPoint("TOPLEFT")
		bar.bg:SetPoint("BOTTOMRIGHT")
	end

	if pfl.ShowIconBorder then
		bar.lefticon.border:Show()
		bar.lefticon.t:SetPoint("TOPLEFT",bar.lefticon,"TOPLEFT",INSET,-INSET)
		bar.lefticon.t:SetPoint("BOTTOMRIGHT",bar.lefticon,"BOTTOMRIGHT",-INSET,INSET)

		bar.righticon.border:Show()
		bar.righticon.t:SetPoint("TOPLEFT",bar.righticon,"TOPLEFT",INSET,-INSET)
		bar.righticon.t:SetPoint("BOTTOMRIGHT",bar.righticon,"BOTTOMRIGHT",-INSET,INSET)
	else
		bar.righticon.border:Hide()
		bar.righticon.t:SetPoint("TOPLEFT",bar.righticon,"TOPLEFT")
		bar.righticon.t:SetPoint("BOTTOMRIGHT",bar.righticon,"BOTTOMRIGHT")

		bar.lefticon.border:Hide()
		bar.lefticon.t:SetPoint("TOPLEFT",bar.lefticon,"TOPLEFT")
		bar.lefticon.t:SetPoint("BOTTOMRIGHT",bar.lefticon,"BOTTOMRIGHT")
	end

	bar:SetHeight(pfl.BarHeight)

	if pfl.ScaleTimerWithBarHeight then
		bar.timer.left:SetFont((bar.timer.left:GetFont()),(0.4375*pfl.BarHeight)+6.875)
		bar.timer.right:SetFont((bar.timer.right:GetFont()),(0.25*pfl.BarHeight)+4.5)
	else
		bar.timer.left:SetFont((bar.timer.left:GetFont()),pfl.TimerSecondsFontSize)
		bar.timer.right:SetFont((bar.timer.right:GetFont()),pfl.TimerDecimalFontSize)
	end

	bar.timer.right:ClearAllPoints()
	bar.timer.right:SetPoint("BOTTOMLEFT",bar.timer.left,"BOTTOMRIGHT",0,pfl.DecimalYOffset)

	bar.timer:ClearAllPoints()
	bar.timer:SetPoint("RIGHT",bar,"RIGHT",pfl.TimerXOffset,pfl.TimerYOffset)
	bar.timer.right:SetVertexColor(unpack(pfl.TimerFontColor))
	bar.timer.left:SetVertexColor(unpack(pfl.TimerFontColor))
	bar.timer:SetAlpha(pfl.TimerAlpha)

	bar.lefticon:ClearAllPoints()
	bar.lefticon:SetPoint("RIGHT",bar,"LEFT",-pfl.IconXOffset,pfl.IconYOffset)

	bar.righticon:ClearAllPoints()
	bar.righticon:SetPoint("LEFT",bar,"RIGHT",pfl.IconXOffset,pfl.IconYOffset)

	if pfl.SetIconToBarHeight then
		bar.lefticon:SetWidth(pfl.BarHeight)
		bar.lefticon:SetHeight(pfl.BarHeight)
		bar.righticon:SetWidth(pfl.BarHeight)
		bar.righticon:SetHeight(pfl.BarHeight)
	else
		bar.lefticon:SetWidth(pfl.IconSize)
		bar.lefticon:SetHeight(pfl.IconSize)
		bar.righticon:SetWidth(pfl.IconSize)
		bar.righticon:SetHeight(pfl.IconSize)
	end

	bar.text:SetFont(bar.text:GetFont(),pfl.BarFontSize)
	bar.text:SetHeight(pfl.BarFontSize * 1.2)
	bar.text:SetVertexColor(unpack(pfl.BarFontColor))
	bar.text:SetJustifyH(pfl.BarTextJustification)
	bar.text:SetPoint("LEFT",bar,"LEFT",pfl.TextXOffset,pfl.TextYOffset)
	bar.text:SetAlpha(pfl.TextAlpha)

	local data = bar.data
	if data.anchor == "TOP" then
		bar:SetScale(pfl.TopScale)
		bar:SetAlpha(pfl.TopAlpha)
		bar:SetWidth(pfl.TopBarWidth)
		bar.text:SetWidth(pfl.TopTextWidth)
	elseif data.anchor == "CENTER" then
		bar:SetScale(pfl.CenterScale)
		bar:SetAlpha(pfl.CenterAlpha)
		bar:SetWidth(pfl.CenterBarWidth)
		bar.text:SetWidth(pfl.CenterTextWidth)
	elseif data.anchor == "WARNING" then
		bar:SetScale(pfl.WarningScale)
		bar:SetAlpha(pfl.WarningAlpha)
		bar:SetWidth(pfl.WarningBarWidth)
		bar.text:SetWidth(pfl.WarningTextWidth)
	end
end

function module:RefreshBars()
	if not next(Active) and not next(BarPool) then return end
	for bar in pairs(Active) do SkinBar(bar) end
	for bar in pairs(BarPool) do SkinBar(bar) end
	prototype:LayoutAlertStack(TopAlertStack, TopStackAnchor, pfl.TopGrowth)
	prototype:LayoutAlertStack(CenterAlertStack, CenterStackAnchor, pfl.CenterGrowth)
	prototype:LayoutAlertStack(WarningAlertStack, WarningStackAnchor, pfl.WarningGrowth)
end

local BarCount = 1
local function CreateBar()
	local self = CreateFrame("Frame","DXEAlertBar"..BarCount,UIParent)
	self:SetHeight(pfl.BarHeight)

	local bg = self:CreateTexture(nil,"BACKGROUND")
	addon:RegisterBackground(bg)
	self.bg = bg

	self.data = {}

	local statusbar = CreateFrame("StatusBar",nil,self)
	statusbar:SetMinMaxValues(0,1)
	statusbar:SetValue(0)
	addon:RegisterStatusBar(statusbar)
	self.statusbar = statusbar

	local border = CreateFrame("Frame",nil,self)
	border:SetAllPoints(true)
	border:SetFrameLevel(statusbar:GetFrameLevel()+1)
	addon:RegisterBorder(border)
	self.border = border

	local timer = addon.Timer:New(self)
	timer:SetFrameLevel(self:GetFrameLevel()+1)
	timer.left:SetShadowOffset(1,-1)
	timer.right:SetShadowOffset(1,-1)
	self.timer = timer

	local text = statusbar:CreateFontString(nil,"ARTWORK")
	text:SetShadowOffset(1,-1)
	text:SetNonSpaceWrap(true)
	addon:RegisterFontString(text,10)
	self.text = text

	local lefticon = CreateFrame("Frame",nil,self)
	self.lefticon = lefticon
	lefticon.t = lefticon:CreateTexture(nil,"BACKGROUND")
	lefticon.t:SetTexCoord(0.07,0.93,0.07,0.93)

	lefticon.border = CreateFrame("Frame",nil,lefticon)
	lefticon.border:SetAllPoints(true)
	addon:RegisterBorder(lefticon.border)

	local righticon = CreateFrame("Frame",nil,self)
	self.righticon = righticon
	righticon.t = righticon:CreateTexture(nil,"BACKGROUND")
	righticon.t:SetTexCoord(0.07,0.93,0.07,0.93)

	righticon.border = CreateFrame("Frame",nil,righticon)
	righticon.border:SetAllPoints(true)
	addon:RegisterBorder(righticon.border)

	AceTimer:Embed(self)
	for k,v in pairs(prototype) do self[k] = v end

	self.fadeTable = {mode = "OUT", timeToFade = FADE_TIME, endAlpha = 0, finishedArg1 = self }

	BarCount = BarCount + 1

	SkinBar(self)

	return self
end

local function GetBar()
	local bar = next(BarPool)
	if bar then BarPool[bar] = nil
	else bar = CreateBar() end
	Active[bar] = true
	UpdateFrame:Show()
	bar:Show()

	return bar
end

---------------------------------------
-- API
---------------------------------------

function module:QuashAll()
	for bar in pairs(Active) do bar:Destroy() end
end

function module:QuashLFGInvite()
	for bar in pairs(Active) do
		if bar:GetID() == DXE_LFG_INVITE then
			bar:Destroy()
		end
	end
end

function module:QuashByPattern(pattern)
	for bar in pairs(Active) do
		if bar:GetID() and find(bar:GetID(),pattern) then
			bar:Destroy()
		end
	end
end

function module:SetTimeleft(id,time)
	for bar in pairs(Active) do
		if bar:GetID() == id then
			bar.data.endTime = GetTime() + time
		end
	end
end

function module:GetTimeleft(id)
	for bar in pairs(Active) do
		if bar:GetID() == id then
			return bar.data.timeleft
		end
	end
	return -1
end

function module:IsActive(id)
	for bar in pairs(Active) do
		if bar:GetID() == id then
			return true
		end
	end
end

function module:Dropdown(id, text, totalTime, flashTime, sound, c1, c2, flashscreen, icon, audiocd, audiotime, raidannounce)
	if pfl.DisableDropdowns then self:CenterPopup(id, text, totalTime, flashTime, sound, c1, c2, flashscreen, icon) return end
	local soundFile,c1Data,c2Data = GetMedia(sound,c1,c2)
	local bar = GetBar()
	bar:SetID(id)
	bar:SetIcon(icon)
	bar:SetTimeleft(totalTime)
	bar:SetText(text)
	bar:SetFlashScreen(flashscreen)
	bar:SetColor(c1Data,c2Data)
	bar:SetSound(soundFile)
	bar:Countdown(totalTime,flashTime)
	bar:AnchorToTop()

	if flashTime then
		local waitTime = totalTime - flashTime
		if waitTime < 0 then bar:TranslateToCenter()
		else bar:ScheduleTimer("TranslateToCenter",waitTime) end
	end
	bar:ScheduleTimer("Fade",totalTime)
	if pfl.WarningMessages and raidannounce then
		local popup,before = GetMessageEra(id)
		if popup then Pour(text..L.alert[" in "]..MMSS(totalTime),icon,c1Data) end
		if before then bar:FireBeforeMsg() end
	end

	if audiocd then
		if not audiotime then audiotime = 5 end
		local waitTimea = totalTime - audiotime - 1
		bar:ScheduleTimer("AudioCountdown",waitTimea,audiotime + 1)
	end
end

function module:CenterPopup(id, text, totalTime, flashTime, sound, c1, c2, flashscreen, icon, audiocd, audiotime, raidannounce)
	local soundFile,c1Data,c2Data = GetMedia(sound,c1,c2)
	local bar = GetBar()
	bar:SetID(id)
	bar:SetIcon(icon)
	bar:SetTimeleft(totalTime)
	bar:SetColor(c1Data,c2Data)
	bar:SetText(text)
	bar:Countdown(totalTime, flashTime)
	bar:SetSound(soundFile)

	if pfl.WarningAnchor and pfl.RedirectCenter and totalTime <= pfl.RedirectThreshold then
		bar:AnchorToWarning()
	else
		bar:AnchorToCenter()
	end
	bar:ScheduleTimer("Fade",totalTime)
	if flashscreen then self:FlashScreen(c1Data) end
	if pfl.WarningMessages and raidannounce then
		local popup,before = GetMessageEra(id)
		if popup then Pour(text..L.alert[" in "]..MMSS(totalTime),icon,c1Data) end
		if before then bar:FireBeforeMsg() end
	end
	if audiocd then
		if not audiotime then audiotime = 5 end
		local waitTimea = totalTime - audiotime - 1
		bar:ScheduleTimer("AudioCountdown",waitTimea,audiotime + 1)
	end
end

function module:Simple(text, totalTime, sound, c1, flashscreen, icon, raidannounce)
	local soundFile,c1Data = GetMedia(sound,c1)
	if soundFile and not pfl.DisableSounds then PlaySoundFile(soundFile) end
	if flashscreen then self:FlashScreen(c1Data) end
	if pfl.WarningBars then
		local bar = GetBar()
		if c1Data then
			bar:SetColor(c1Data)
			bar.statusbar:SetValue(1)
		end
		bar:SetIcon(icon)
		bar:SetText(text)
		bar.timer:Hide()
		bar[pfl.WarningAnchor and "AnchorToWarning" or "AnchorToCenter"](bar)
		bar:ScheduleTimer("Fade",totalTime)
	end

	if pfl.WarningMessages and pfl.WarnPopupMessage and raidannounce then Pour(text,icon,c1Data) end
end

---------------------------------------------
-- ABSORB BARS
---------------------------------------------

local function abbrev(value)
	return value > 1000000 and ("%.2fm"):format(value / 1000000) or ("%dk"):format(value / 1000)
end

local dmg2_types = { SPELL_MISSED = true, SPELL_PERIODIC_MISSED = true, RANGE_MISSED = true }
local function Absorb_OnEvent(self,_,_,eventtype,_,_,_,dstGUID,_,_,misstype,dmg,_,misstype2,dmg2)
	local data = self.data
	if (misstype == "ABSORB" or misstype2 == "ABSORB") and NID[dstGUID] == data.npcid then
		local flag
		if dmg2_types[eventtype] then
			data.value = data.value + dmg2
			flag = true
		elseif eventtype == "SWING_MISSED" then
			data.value = data.value + dmg
			flag = true
		end
		if flag then
			-- reverse
			local perc = data.value / data.total
			if perc <= 0 or perc > 1 then self:Destroy() return end
			self:SetText(data.textformat:format(abbrev(data.total - data.value),data.atotal,(1-perc) * 100))
			self.statusbar:SetValue(1 - perc)
		end
	end
end

function prototype:SetTotal(total) self.data.total,self.data.atotal = total,abbrev(total) end
function prototype:SetNPCID(npcid) self.data.npcid = npcid end
function prototype:SetTextFormat(textformat) self.data.textformat = textformat end
function prototype:UnregisterCLEU() self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") end

function module:Absorb(id, text, textFormat, totalTime, flashTime, sound, c1, c2, flashscreen, icon, total, npcid)
	local soundFile,c1Data,c2Data = GetMedia(sound,c1,c2)
	if soundFile and not pfl.DisableSounds then PlaySoundFile(soundFile) end
	if flashscreen then self:FlashScreen(c1Data) end
	spellid = tonumber(spellid)
	npcid = tonumber(npcid)
	local bar = GetBar()
	bar.data.value = 0
	bar:SetID(id)
	bar:AnchorToCenter()
	bar:SetText(textFormat:format(abbrev(total),abbrev(total),100))
	bar:Countdown(totalTime,flashTime,true)
	bar:SetIcon(icon)
	bar:SetTextFormat(textFormat)
	bar:SetTotal(total)
	bar:SetNPCID(npcid)
	bar:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	bar:SetScript("OnEvent",Absorb_OnEvent)
	bar.statusbar:SetValue(1)
	bar:ScheduleTimer("Fade",totalTime)
	bar:ScheduleTimer("UnregisterCLEU",totalTime)

	if c1Data then bar:SetColor(c1Data,c2Data) end
	print(text)
	if pfl.WarningMessages and pfl.WarnPopupMessage then Pour(text,icon,c1Data) end
end

---------------------------------------------
-- CUSTOM BARS
---------------------------------------------

do
	local L_ICON = "Interface\\Icons\\INV_Misc_PocketWatch_02"
	local R_ICON = "Interface\\Icons\\INV_Misc_PocketWatch_01"
	local YOU_PREFIX = L["YOU"]..": "
	local ID_PREFIX = "custom"
	local MSG_PTN = "^([%d:]+)%s+(.*)"
	local TIME_PTN = "^(%d+):(%d+)$"
	local DROPDOWN_THRES = 15
	local FORMAT_ERROR = L["Invalid input. Usage: |cffffd200%s time text|r"]
	local TIME_ERROR = L["Invalid time. The format must be |cffffd200minutes:seconds|r or |cffffd200seconds|r (e.g. 1:30 or 90)"]
	local OFFICER_ERROR = L["You need to be a raid officer"]
	local COMMTYPE = "AlertsRaidBar"

	local function fire(text,time,color,icon)
		local id = ID_PREFIX..text
		module:QuashByPattern(id)
		if time > DROPDOWN_THRES then
			module:Dropdown(id,text,time,DROPDOWN_THRES,pfl.CustomSound,color,nil,nil,icon)
		else
			module:CenterPopup(id,text,time,nil,pfl.CustomSound,color,nil,nil,icon)
		end
	end

	local helpers = {
		function() return UnitExists("target") and UnitName("target") or "<<"..L["None"]..">>" end,
	}

	local function replace(text)
		text = gsub(text,"%%t",helpers[1]())
		return text
	end

	local function parse(msg,slash)
		if type(msg) ~= "string" then addon:Print(format(FORMAT_ERROR,slash)) return end
		local time,text = msg:match(MSG_PTN)
		if not time then addon:Print(format(FORMAT_ERROR,slash)) return end
		local secs = tonumber(time)
		if not secs then
			local m,s = time:trim():match(TIME_PTN)
			if m then secs = (tonumber(m)*60) + tonumber(s)
			else addon:Print(TIME_ERROR) return end
		end
		return true,secs,replace(text)
	end

	local function LocalBarHandler(msg)
		local success,time,text = parse(msg,"/dxelb")
		if success then fire(YOU_PREFIX..text,time,pfl.CustomLocalClr,L_ICON) end
	end

	local function RaidBarHandler(msg)
		if not UnitIsRaidOfficer("player") then addon:Print(OFFICER_ERROR) return end
		local success,time,text = parse(msg,"/dxerb")
		if success then
			fire(YOU_PREFIX..text,time,pfl.CustomRaidClr,R_ICON)
			addon:SendRaidComm(COMMTYPE,time,CN[addon.PNAME]..": "..text)
		end
	end

	module["OnComm"..COMMTYPE] = function(self,event,commType,sender,time,text)
		if not UnitIsRaidOfficer(sender) then return end
		fire(text,time,pfl.CustomRaidClr,R_ICON)
	end

	addon.RegisterCallback(module,"OnComm"..COMMTYPE)

	SlashCmdList.DXEALERTLOCALBAR = LocalBarHandler
	SlashCmdList.DXEALERTRAIDBAR = RaidBarHandler

	SLASH_DXEALERTLOCALBAR1 = "/dxelb"
	SLASH_DXEALERTRAIDBAR1 = "/dxerb"
	SLASH_DXEALERTRAIDBAR2 = "/dbm"
end

---------------------------------------------
-- ALERT TESTS
---------------------------------------------

function module:BarTest()
	self:CenterPopup("alerttestdur", "Centerpopup Centerpopup Centerpopup Centerpopup Centerpopup Centerpopup Centerpopup Centerpopup ", 10, 5, "DXE ALERT1", "DCYAN", nil, nil, addon.ST[28374], 10, 3)
	self:Dropdown("alerttestcd", "Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown Dropdown ", 20, 5, "DXE ALERT2", "BLUE", "ORANGE", nil, addon.ST[64813], 20, 5)
	self:Simple("Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning Warning ",3,"DXE ALERT3","RED", nil, addon.ST[53351], true)
end

local lookup
function module:FlashTest()
	if not lookup then
		lookup = {}
		for k,v in pairs(Colors) do lookup[#lookup+1] = k end
	end
	local i = math.random(1,#lookup)
	local c = Colors[lookup[i]]
	self:FlashScreen(c)
end
