---@diagnostic disable: call-non-callable, need-check-nil
-- in your mod's client lua file
local UI_BORDER_SPACING = 10

local restartLabel
local restartCombo
local RIBruntime = require("RIBruntime")

local ISPostDeathUI_createChildren = ISPostDeathUI.createChildren
function ISPostDeathUI:createChildren()
	ISPostDeathUI_createChildren(self)
	
	if isMultiplayer() then
		return
	end
	
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
	restartCombo = ISComboBox:new(buttonX, buttonY, buttonWid, buttonHgt, self, self.RIBComboMenu)
	restartCombo:initialise()
	restartCombo:addOption(getText("Restart this world"))
	restartCombo:addOption(getText("Restart this world: Traits"))
	restartCombo:addOption(getText("Restart this world: Customization"))
	restartCombo:addOption(getText("Make a new world"))
	self:addChild(restartCombo)
end

local ISPostDeathUI_prerender = ISPostDeathUI.prerender
function ISPostDeathUI:prerender()
	ISPostDeathUI_prerender(self)
	local allPlayersDead = IsoPlayer.allPlayersDead()
	
	if not restartCombo or not restartLabel then return end
	
	restartLabel:setVisible(self.waitOver and allPlayersDead)
	restartCombo:setVisible(self.waitOver and allPlayersDead)
end
function ISPostDeathUI:RIBComboMenu(combo)
	local actions = {
		[1] = function ()
			RIBruntime.saveData("remake")
		end,
		[2] = function ()
			RIBruntime.saveData("trait")
		end,
		[3] = function ()
			RIBruntime.saveData("customization")
		end,
		[4] = function ()
			RIBruntime.saveData("fresh")
		end
	}
	
	local fn = actions[combo.selected]
	if fn then fn() end
	
	redirectToMenu(self)
end
