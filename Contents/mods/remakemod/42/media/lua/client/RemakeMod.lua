function redirectToMenu(ISPostDeathUI)
    ModData.getOrCreate("RetakeMod").RetryPending = {
        world = {
            map = getWorld():getMap() or "Muldraugh, KY",
            preset = getWorld():getPreset()
        },
        characterProfession = {
            traits = getPlayer():getCharacterTraits():getKnownTraits(),
            profession = getPlayer():getDescriptor():getCharacterProfession()
        },
        mainCharacter = {
            isFemale = getPlayer():getDescriptor():isFemale(),
            forename = getPlayer():getDescriptor():getForename(),
            surname = getPlayer():getDescriptor():getSurname(),
            voicePrefix = getPlayer():getDescriptor():getVoicePrefix(),
            voiceStyle = getPlayer():getDescriptor():getVoiceType(),
            voicePitch = getPlayer():getDescriptor():getVoicePitch(),
            torso = getPlayer():getDescriptor():getTorso(),
            hairColor = getPlayer():getDescriptor():getHumanVisual():getNaturalHairColor(),
            hair = getPlayer():getDescriptor():getHumanVisual():getHairModel(),
            beard = getPlayer():getDescriptor():getHumanVisual():getBeardModel(),
            beardColor = getPlayer():getDescriptor():getHumanVisual():getNaturalBeardColor(),
            skinColor = getPlayer():getDescriptor():getHumanVisual():getSkinColor(),
            skinIndex = getPlayer():getDescriptor():getHumanVisual():getSkinTextureIndex()
        }
    }

    if MainScreen.instance and MainScreen.instance:isReallyVisible() then
        return
    end

    setGameSpeed(1)

    ISPostDeathUI:removeFromUIManager()

    getCore():exitToMenu()
end

function createWorldAndSetData(MainScreen, data)
    local sdf = SimpleDateFormat.new("yyyy-MM-dd_HH-mm-ss", Locale.ENGLISH)
    local worldName = tostring(sdf:format(Calendar.getInstance():getTime())) -- ignore warning probably from other's api
    local worldD = data.RetryPending.world

    MainScreen.createWorld = true
    ActiveMods.getById("currentGame"):copyFrom(ActiveMods.getById("default"))

    getWorld():setWorld(worldName)
    getWorld():setPreset(worldD.preset)
    getWorld():setMap(worldD.map)
end

-- there's some strange bug with the traits making some trait taking no point unsure on what's the cause here
function applyTraitsAndProfessionFromData(CharacterProfessionScreen)
    CharacterProfessionScreen:setVisible(true, JoypadData) -- set it to true so charMain can check from it

    local data = ModData.getOrCreate("RetakeMod")
    local prof = data.RetryPending.characterProfession

    local professionDefinition = CharacterProfessionDefinition.getCharacterProfessionDefinition(
        prof.profession
    )
    if professionDefinition then
        CharacterProfessionScreen:onSelectProf(professionDefinition)
    end
    for i = 0, prof.traits:size() - 1 do
        local trait = prof.traits:get(i)
        local traitDefinition = CharacterTraitDefinition.getCharacterTraitDefinition(trait)
        CharacterProfessionScreen:addTrait(traitDefinition)
    end
end

function applyOldCharacterVisual(CharacterMainScreen)
    local data = ModData.getOrCreate("RetakeMod")
    local char = data.RetryPending.mainCharacter

    -- Gender
    print(char.isFemale and 1 or 2 .. " Gender number")
    print(char " Is Null?")

    CharacterMainScreen.genderCombo.selected = char.isFemale and 1 or 2
    CharacterMainScreen:onGenderSelected(CharacterMainScreen.genderCombo)

    -- Name
    CharacterMainScreen.forenameEntry:setText(char.forename)
    CharacterMainScreen.surnameEntry:setText(char.surname)

    -- Skin
    CharacterMainScreen.colorPickerSkin:setInitialColor(ColorInfo.new(
        CharacterMainScreen.skinColors[char.skinIndex + 1].r,
        CharacterMainScreen.skinColors[char.skinIndex + 1].g,
        CharacterMainScreen.skinColors[char.skinIndex + 1].b, 1
    ))
    CharacterMainScreen:onSkinColorPicked(CharacterMainScreen.skinColors[char.skinIndex + 1], true)

    -- Hair
    CharacterMainScreen:onHairColorPicked(char.hairColor, true)
    CharacterMainScreen.hairTypeCombo.selected = 1
    CharacterMainScreen.hairTypeCombo:selectData(char.hair)
    CharacterMainScreen:onHairTypeSelected(CharacterMainScreen.hairTypeCombo)

    -- Beard (male only)
    if not char.isFemale then
        CharacterMainScreen.beardTypeCombo.selected = 1
        CharacterMainScreen.beardTypeCombo:selectData(char.beard)
        CharacterMainScreen:onBeardTypeSelected(CharacterMainScreen.beardTypeCombo)
    end

    -- Voice
    for i in ipairs(CharacterMainScreen.voiceTypeCombo.options) do
        local voiceOption = CharacterMainScreen.voiceTypeCombo:getOptionData(i)
        if voiceOption and voiceOption:getName() == char.voiceStyle then
            CharacterMainScreen.voiceTypeCombo:selectData(voiceOption)
            break
        end
    end
    CharacterMainScreen.voicePitchSlider:setCurrentValue(char.voicePitch, true)
    CharacterMainScreen:onVoiceTypeSelected()

    --does not support stubble visuals rn because yes
end

-- TODO
-- REMOVE THE MENU HUD FROM BELOW
-- ADD A BUTTON FOR SAME SETTINGS START IN 1 CLICK JUST USE CUSTOMIZATION AND CALL THE NEXT BUTTON AUTOMATICALLY
-- FIX BUTTON SHOWING LATER AND LOWER BUTTON COMPLETELY NOT WORKING, I KNOW WHY IT DOES NOT WORK BUT DON'T KNOW HOW TO FIX IT

--[[ IMPORTANTS FIX // NEEDEDE
-----------------------------------------
STACK TRACE
-----------------------------------------
	Lua((MOD:Remake Mod)).applyOldCharacterVisual(RemakeMod.lua:77)
	Lua((MOD:Remake Mod)).instantiate(CharacterScreenAlteration.lua:9)
	Lua(Vanilla).setVisible(CharacterCreationMain.lua:1560)
	Lua(Vanilla).instantiate(MainScreen.lua:257)
	Lua((MOD:Remake Mod)).instantiate(MainScreenAlteration.lua:4)
	Lua(Vanilla).addToUIManager(ISUIElement.lua:1183)
	Lua(Vanilla).LoadMainScreenPanelInt(MainScreen.lua:1773)
	Lua(Vanilla).LoadMainScreenPanel(MainScreen.lua:1668)
LOG  : General      f:0> attempted index of non-table
]]