-- in your mod's client lua file
local UI_BORDER_SPACING = 10

local ISPostDeathUI_createChildren = ISPostDeathUI.createChildren
function ISPostDeathUI:createChildren()
	ISPostDeathUI_createChildren(self)

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
		buttonX, buttonY, buttonWid, buttonHgt, getText("Remake_RemakeTrait"), self, self.traitRetake
	)
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
	buttonY = buttonY + buttonHgt + buttonGapY
	
	moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Remake_RemakeCustomization"), self, self.customizationRetake
	)
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
	buttonY = buttonY + buttonHgt + buttonGapY
	
	moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Remake_RemakeFreshStart"), self, self.freshRetake
	)
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)
	buttonY = buttonY + buttonHgt + buttonGapY
	
	moddedButton = ISButton:new(
		buttonX, buttonY, buttonWid, buttonHgt, getText("Remake_WorldDirect"), self, self.remakeRetake
	)
	self:configButton(moddedButton)
	moddedButton:initialise()
	moddedButton:instantiate()
	self:addChild(moddedButton)

end
function ISPostDeathUI:remakeRetake()
	ModData.getOrCreate("RetakeMod").remake = true
	
	redirectToMenu(self)
end
function ISPostDeathUI:traitRetake()
	ModData.getOrCreate("RetakeMod").trait = true
	
	redirectToMenu(self)
end
function ISPostDeathUI:customizationRetake()
	ModData.getOrCreate("RetakeMod").customization = true
	
	redirectToMenu(self)
end

function ISPostDeathUI:freshRetake()
	ModData.getOrCreate("RetakeMod").fresh = true
	
	redirectToMenu(self)
end
