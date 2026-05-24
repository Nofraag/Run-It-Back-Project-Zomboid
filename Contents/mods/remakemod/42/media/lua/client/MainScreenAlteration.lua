local MainScreen_instantiate = MainScreen.instantiate
function MainScreen:instantiate()
	-- call the original first so vanilla behaviour exist
	MainScreen_instantiate(self)
	local data = ModData.getOrCreate("RetakeMod")
	if not data.RetryPending or self.inGame then
		return
	end

	if data.customization then
		createWorldAndSetData(self, data)
        applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationMain:setVisible(true, JoypadData)
				
		ModData.getOrCreate("RetakeMod").customization = false
	elseif data.fresh then
        ActiveMods.getById("currentGame"):copyFrom(ActiveMods.getById("default"))
        self.soloScreen:setVisible(true, JoypadData);
        self.soloScreen:onItemClick(self.soloScreen.panels[1], 0, 0);
		
		ModData.getOrCreate("RetakeMod").fresh = false
    elseif data.trait then
		createWorldAndSetData(self, data)
        applyTraitsAndProfessionFromData(self.charCreationProfession)
				
		ModData.getOrCreate("RetakeMod").trait = false
	elseif data.remake then
        createWorldAndSetData(self, data)
        applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationMain:setVisible(true, JoypadData)

	end

    ModData.getOrCreate("RetakeMod").RetryPending = nil
end