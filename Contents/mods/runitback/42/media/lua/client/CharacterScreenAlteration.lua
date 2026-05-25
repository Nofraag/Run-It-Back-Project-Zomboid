local runtimeVar = require("RIBruntime")

local CharacterCreationMain_setVisible = CharacterCreationMain.setVisible
function CharacterCreationMain:setVisible(visible)
	-- call the original first so vanilla behaviour exist
	CharacterCreationMain_setVisible(self, visible)

	if runtimeVar.RetryPending and visible then
		--set player visual
		applyOldCharacterVisual(self)
	end
	
	if not (runtimeVar.currentAction == "remake") or not MainScreen.instance or not visible then		
		return
	end

	-- set the player desc we build
	self:initPlayer()
	-- update the DB with first & last name
	if isClient() and getCore():getAccountUsed() then
		getCore():getAccountUsed():setPlayerFirstAndLastName(self.forenameEntry:getText() .. " "
				.. self.surnameEntry:getText())
		updateAccountToAccountList(getCore():getAccountUsed())
		getCore():setAccountUsed(nil) -- ignore warning that's how the indie stone does it
	end
	-- set up the world
	if MainScreen.instance.createWorld then
		createWorld(getWorld():getWorld())
	end
	GameWindow.doRenderEvent(false)
	
	forceChangeState(LoadingQueueState.new())
	
	runtimeVar.currentAction = ""
	runtimeVar.RetryPending = nil
end

local CharacterCreationProfession_onOptionMouseDown = CharacterCreationProfession.onOptionMouseDown

function CharacterCreationProfession:onOptionMouseDown(button, x, y)
	 if button.internal == "BACK" then

		if runtimeVar.RetryPending and MainScreen.instance then
			runtimeVar.RetryPending = nil

			MainScreen.instance.bottomPanel:setVisible(true);
		end
	 end

	CharacterCreationProfession_onOptionMouseDown(self, button, x, y)
end

local CharacterCreationMain_onOptionMouseDown = CharacterCreationMain.onOptionMouseDown

function CharacterCreationMain:onOptionMouseDown(button, x, y)
	 if button.internal == "NEXT" then
		if not MainScreen.instance then
			return 
		end

		if runtimeVar.RetryPending then
			runtimeVar.RetryPending = nil
		end
	 end

	CharacterCreationMain_onOptionMouseDown(self, button, x, y)
end