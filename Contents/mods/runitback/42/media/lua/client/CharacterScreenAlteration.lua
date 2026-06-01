local RIBruntime = require("RIBruntime")

local CharacterCreationMain_setVisible = CharacterCreationMain.setVisible
function CharacterCreationMain:setVisible(visible)
	-- call the original first so vanilla behaviour exist
	CharacterCreationMain_setVisible(self, visible)
	local data = RIBruntime.getData()
	
	if not data then return end
	
	if data.RIBpending and visible then
		-- set player visual
		applyOldCharacterVisual(self)
	end
	
	if not (data.currentAction == "remake") or not MainScreen.instance or not visible then
		return
	end
	
	-- set the player desc we build
	self:initPlayer()
	-- update the DB with first & last name
	if isClient() and getCore():getAccountUsed() then
		getCore():getAccountUsed():setPlayerFirstAndLastName(self.forenameEntry:getText() .. " "
				.. self.surnameEntry:getText())
		updateAccountToAccountList(getCore():getAccountUsed())
		---@diagnostic disable-next-line: param-type-mismatch
		getCore():setAccountUsed(nil) -- ignore warning that's how the indie stone does it
	end
	-- set up the world
	if MainScreen.instance.createWorld then
		createWorld(getWorld():getWorld())
	end
	GameWindow.doRenderEvent(false)
	
	forceChangeState(LoadingQueueState.new())
end

local CharacterCreationProfession_onOptionMouseDown = CharacterCreationProfession.onOptionMouseDown

function CharacterCreationProfession:onOptionMouseDown(button, x, y)
	if button.internal == "BACK" then
		local data = RIBruntime.getData()
		
		if data then
			if not data.RIBpending then return end
			RIBruntime.clearData()
		end
	end
	
	CharacterCreationProfession_onOptionMouseDown(self, button, x, y)
end
