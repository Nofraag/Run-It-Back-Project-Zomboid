local RIBruntime = {}
function RIBruntime.saveData(action)
    local player = getPlayer()

    if not player then
        return
    end

    local data = ModData.getOrCreate(getWorld():getWorld())
    local RuntimeData = ModData.getOrCreate("RIBruntime")
    local desc = player:getDescriptor()
    local visual = desc:getHumanVisual()
    local hairColor = visual:getNaturalHairColor()

    print("READING outfit from: " .. getWorld():getWorld())
    print("DefaultOutfit is: " .. tostring(data.DefaultOutfit))

    RuntimeData.data = {
        RIBpending = {
            world = {
                map = data.spawnPoint or "Muldraugh, KY",
                preset = getWorld():getPreset(),
                sandboxSetting = getSandboxOptions():newCopy()
            },
            characterProfession = {
                traits = data.DefaultTraits or "",
                profession = desc:getCharacterProfession():toString() or ""
            },
            mainCharacter = {
                isFemale = desc:isFemale(),
                forename = desc:getForename(),
                surname = desc:getSurname(),
                voicePrefix = desc:getVoicePrefix(),
                voiceStyle = desc:getVoiceType(),
                voicePitch = desc:getVoicePitch(),
                hairColor = {
                    r = hairColor:getRedFloat(),
                    g = hairColor:getGreenFloat(),
                    b = hairColor:getBlueFloat()
                },
                hair = visual:getHairModel() or "",
                beard = visual:getBeardModel() or "",
                skinIndex = visual:getSkinTextureIndex(),
                stubbleHair = data.stubbleHair,
                stubbleBeard = data.stubbleBeard,
                chestHair = data.chestHair
            }
        },
        currentAction = action,
        fromWorld = getWorld():getWorld()
    }
end

function RIBruntime.clearData()
    local RuntimeData = ModData.getOrCreate("RIBruntime")

    RuntimeData.data = nil
end

function RIBruntime.getData()
    local RuntimeData = ModData.getOrCreate("RIBruntime")

    return RuntimeData.data
end

return RIBruntime
