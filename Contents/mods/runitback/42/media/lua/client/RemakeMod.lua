local runtimeVar = require("RIBruntime")

function redirectToMenu(ISPostDeathUI)
    if MainScreen.instance and MainScreen.instance:isReallyVisible() then
        return
    end

    setGameSpeed(1)

    ISPostDeathUI:removeFromUIManager()

    getCore():exitToMenu()
end

function savePersistentData(CharacterCreation, CharacterProfessionTab)
    local world = getWorld()
    local data = ModData.getOrCreate(world:getWorld())

    local selectedHairStubble = CharacterCreation.hairStubbleTickBox:isEnabled()

    data.stubbleHair = selectedHairStubble

    local selectedBeardStubble = CharacterCreation.beardStubbleTickBox:isEnabled()

    data.stubbleBeard = selectedBeardStubble

    local selectedchesthair = CharacterCreation.chestHairTickBox:isEnabled()

    data.chestHair = selectedchesthair

    local traits = {}
    local items = CharacterProfessionTab.listboxTraitSelected.items
    for i = 1, #items do
        if items[i] and items[i].item then
            local name = items[i].item:getType():toString()
            traits[#traits + 1] = name
        end
    end
    data.DefaultTraits = traits
end

function createWorldAndSetData(MainScreen)
    if not runtimeVar.RetryPending or isMultiplayer() then return end

    local sdf = SimpleDateFormat.new("yyyy-MM-dd_HH-mm-ss", Locale.ENGLISH)
    local worldName = tostring(sdf:format(Calendar.getInstance():getTime())) -- ignore warning probably from other's api

    local worldD = runtimeVar.RetryPending.world

    MainScreen.createWorld = true
    ActiveMods.getById("currentGame"):copyFrom(ActiveMods.getById("default"))

    getWorld():setWorld(worldName)
    getWorld():setPreset(worldD.preset)
    getWorld():setMap(worldD.map)
end
function applyTraitsAndProfessionFromData(CharacterProfessionScreen)
    if not runtimeVar.RetryPending then return end
    
    local prof = runtimeVar.RetryPending.characterProfession
    if not prof or not prof.traits then return end

    local prof = runtimeVar.RetryPending.characterProfession

    local professionDefinition = CharacterProfessionDefinition.getCharacterProfessionDefinition(prof.profession)
    if professionDefinition then
        CharacterProfessionScreen:onSelectProf(professionDefinition)
    end

    local charTraits = prof.traits
    for _, traitId in pairs(charTraits) do
        local traitDef = CharacterTraitDefinition.getCharacterTraitDefinition(CharacterTrait.get(ResourceLocation.of(traitId)))
        if traitDef then
            CharacterProfessionScreen:addTrait(traitDef)
        end
    end
end

function applyOldCharacterVisual(CharacterMainScreen)
    if not MainScreen.instance or not runtimeVar.RetryPending then return end

    local char = runtimeVar.RetryPending.mainCharacter
    local desc = MainScreen.instance.desc

    -- Gender
    local isFemale = char.isFemale

    CharacterMainScreen.genderCombo.selected = tonumber(isFemale and 1 or 2)
    CharacterMainScreen:onGenderSelected(CharacterMainScreen.genderCombo)
    desc:getWornItems():clear()

    -- Name
    desc:setForename(char.forename)
    CharacterMainScreen.forenameEntry:setText(char.forename)
    desc:setSurname(char.surname)
    CharacterMainScreen.surnameEntry:setText(char.surname)

    -- Skin
    CharacterMainScreen.colorPickerSkin:setInitialColor(
        ColorInfo.new(
            CharacterMainScreen.skinColors[char.skinIndex + 1].r, CharacterMainScreen.skinColors[char.skinIndex + 1].g,
            CharacterMainScreen.skinColors[char.skinIndex + 1].b, 1
        )
    )
    CharacterMainScreen:onSkinColorPicked(CharacterMainScreen.skinColors[char.skinIndex + 1], true)

    -- Hair
    local colorRGB = {}
    colorRGB.r = char.hairColor:getRedFloat()
    colorRGB.g = char.hairColor:getGreenFloat()
    colorRGB.b = char.hairColor:getBlueFloat()
    CharacterMainScreen:onHairColorPicked(colorRGB, true)
    CharacterMainScreen.hairTypeCombo.selected = 1
    CharacterMainScreen.hairTypeCombo:selectData(char.hair)
    CharacterMainScreen:onHairTypeSelected(CharacterMainScreen.hairTypeCombo)

    -- Hair stubble
    CharacterMainScreen.hairStubbleTickBox:setSelected(1, char.stubbleHair)
    CharacterMainScreen:onShavedHairSelected(1, char.stubbleHair)

    -- Beard (male only)
    if not desc:isFemale() then
        CharacterMainScreen.beardTypeCombo.selected = 1
        CharacterMainScreen.beardTypeCombo:selectData(char.beard)
        CharacterMainScreen:onBeardTypeSelected(CharacterMainScreen.beardTypeCombo)

        -- Chest hair
        CharacterMainScreen.chestHairTickBox:setSelected(1, char.chestHair)
        CharacterMainScreen:onChestHairSelected(1, char.chestHair)

        -- Beard stubble
        CharacterMainScreen.beardStubbleTickBox:setSelected(1, char.stubbleBeard)
        CharacterMainScreen:onBeardStubbleSelected(1, char.stubbleBeard)
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

    CharacterMainScreen:randomGenericOutfit() -- fix player being nude
end

Events.OnCreatePlayer.Add(function(playerIndex, player)
    if MainScreen.instance and MainScreen.instance.charCreationProfession then
        savePersistentData(
            MainScreen.instance.charCreationMain,
            MainScreen.instance.charCreationProfession
        )
    end
end)