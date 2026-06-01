local MainScreen_instantiate = MainScreen.instantiate
local RIBruntime = require("RIBruntime")

function MainScreen:instantiate()
	-- call the original first so vanilla behaviour exist
	MainScreen_instantiate(self)
	local data = RIBruntime.getData()
	
	if not data then return end
	
	if not data.RIBpending or self.inGame or not MainScreen.instance then
		return
	end
		
	if data.currentAction == "customization" then
		createWorldAndSetData(self)
		applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationMain:setVisible(true, JoypadData)
		
	elseif data.currentAction == "fresh" then
		RIBruntime.clearData()
		
		ActiveMods.getById("currentGame"):copyFrom(ActiveMods.getById("default"))
		self.soloScreen:setVisible(true, JoypadData)
		self.soloScreen:onItemClick(self.soloScreen.panels[1], 0, 0)
		
	elseif data.currentAction == "trait" then
		createWorldAndSetData(self)
		applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationProfession:setVisible(true, JoypadData)
		
	elseif data.currentAction == "remake" then
		createWorldAndSetData(self)
		applyTraitsAndProfessionFromData(self.charCreationProfession)
		self.charCreationMain:setVisible(true, JoypadData)
	end
end
