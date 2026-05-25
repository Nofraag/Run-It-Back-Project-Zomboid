local RIBruntime = {}

function RIBruntime.setData(action)
    if not getPlayer() then
        return
    end

    local data = ModData.getOrCreate(getWorld():getWorld())
    RIBruntime.RetryPending = {
        world = {
            map = getWorld():getMap() or "Muldraugh, KY",
            preset = getWorld():getPreset()
        },
        characterProfession = {
            traits = data.DefaultTraits,
            profession = getPlayer():getDescriptor():getCharacterProfession()
        },
        mainCharacter = {
            isFemale = getPlayer():getDescriptor():isFemale(),
            forename = getPlayer():getDescriptor():getForename(),
            surname = getPlayer():getDescriptor():getSurname(),
            voicePrefix = getPlayer():getDescriptor():getVoicePrefix(),
            voiceStyle = getPlayer():getDescriptor():getVoiceType(),
            voicePitch = getPlayer():getDescriptor():getVoicePitch(),
            hairColor = getPlayer():getDescriptor():getHumanVisual():getNaturalHairColor(),
            hair = getPlayer():getDescriptor():getHumanVisual():getHairModel(),
            beard = getPlayer():getDescriptor():getHumanVisual():getBeardModel(),
            skinIndex = getPlayer():getDescriptor():getHumanVisual():getSkinTextureIndex(),
            stubbleHair = data.stubbleHair,
            stubbleBeard = data.stubbleBeard,
            chestHair = data.chestHair
        }
    }

    RIBruntime.currentAction = action
end

return RIBruntime
