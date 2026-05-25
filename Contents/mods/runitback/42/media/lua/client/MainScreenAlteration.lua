local runtimeVar = require("RIBruntime")


local MainScreen_instantiate = MainScreen.instantiate

function MainScreen:instantiate()
	-- call the original first so vanilla behaviour exist
	MainScreen_instantiate(self)
	if not runtimeVar.RetryPending or self.inGame or not MainScreen.instance then
		return
	end

	MainScreen.instance.bottomPanel:setVisible(false);

	
	if runtimeVar.currentAction == "customization" then
		createWorldAndSetData(self)
        applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationMain:setVisible(true, JoypadData)
				
		runtimeVar.currentAction = ""
	elseif runtimeVar.currentAction == "fresh" then
		runtimeVar.RetryPending = nil

        ActiveMods.getById("currentGame"):copyFrom(ActiveMods.getById("default"))
        self.soloScreen:setVisible(true, JoypadData);
        self.soloScreen:onItemClick(self.soloScreen.panels[1], 0, 0);
		
		runtimeVar.currentAction = ""
    elseif runtimeVar.currentAction == "trait" then
		createWorldAndSetData(self)
        applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationProfession:setVisible(true, JoypadData)

		runtimeVar.currentAction = ""
	elseif runtimeVar.currentAction == "remake" then
        createWorldAndSetData(self)
        applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationMain:setVisible(true, JoypadData)
	end
end