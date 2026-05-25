-- in your mod's client lua file
local UI_BORDER_SPACING = 10

local RIBTrait
local RIBCustomization
local RIBFreshStart
local RIBWorldDirect

local runtimeVar = require("RIBruntime")

local ISPostDeathUI_createChildren = ISPostDeathUI.createChildren
function ISPostDeathUI:createChildren()
	ISPostDeathUI_createChildren(self)

	if isMultiplayer() then
		return end

	local buttonWid = self.buttonExit:getWidth()
    local buttonHgt = toInt(self.buttonExit:getHeight())  
    local buttonX = self.buttonExit:getX()
    local buttonY = self.buttonQuit:getY() -- quit because it's the last button added in vanilla
	local buttonGapY = UI_BORDER_SPACING
	local newTotalHgt = (buttonHgt * 7) + (buttonGapY * 6)

	self:setHeight(newTotalHgt)
	self:setY(self.screenY + (self.screenHeight - 40 - newTotalHgt))

	-- add from vanilla last button
	buttonY = buttonY + buttonHgt + buttonGapY


	-- modded buttons	
	local moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Restart this world on the traits screen"), self, self.traitRetake
	)
	RIBTrait = moddedButton
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
	buttonY = buttonY + buttonHgt + buttonGapY
	
	moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Restart this world on the customization screen"), self, self.customizationRetake
	)
	RIBCustomization = moddedButton
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
	buttonY = buttonY + buttonHgt + buttonGapY
	
	moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Make a new world"), self, self.freshRetake
	)
	RIBFreshStart = moddedButton
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
	buttonY = buttonY + buttonHgt + buttonGapY
	
	moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Restart this world"), self, self.remakeRetake
	)
	RIBWorldDirect = moddedButton
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
end

local ISPostDeathUI_prerender = ISPostDeathUI.prerender
function ISPostDeathUI:prerender()
    ISPostDeathUI_prerender(self)
	local allPlayersDead = IsoPlayer.allPlayersDead()

	if not (RIBWorldDirect or RIBFreshStart or RIBCustomization or RIBTrait) then return end

	RIBWorldDirect:setVisible(self.waitOver and allPlayersDead)
	RIBFreshStart:setVisible(self.waitOver and allPlayersDead)
	RIBCustomization:setVisible(self.waitOver and allPlayersDead)
	RIBTrait:setVisible(self.waitOver and allPlayersDead)
end
function ISPostDeathUI:remakeRetake()
	runtimeVar.setData("remake")
	redirectToMenu(self)
end
function ISPostDeathUI:traitRetake()
	runtimeVar.setData("trait")
	redirectToMenu(self)
end
function ISPostDeathUI:customizationRetake()
	runtimeVar.setData("customization")
	redirectToMenu(self)
end

function ISPostDeathUI:freshRetake()
	runtimeVar.setData("fresh")
	redirectToMenu(self)
end
