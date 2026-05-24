local CharacterCreationMain_instantiate = CharacterCreationMain.instantiate
function CharacterCreationMain:instantiate()
	-- call the original first so vanilla behaviour exist
	CharacterCreationMain_instantiate(self)
	local data = ModData.getOrCreate("RetakeMod")
	
	if data.RetryPending then
		--set player visual
		applyOldCharacterVisual(self)
	end

	if not data.remake or not MainScreen.instance then
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
	
	ModData.getOrCreate("RetakeMod").remake = false
	ModData.getOrCreate("RetakeMod").RetryPending = nil
end