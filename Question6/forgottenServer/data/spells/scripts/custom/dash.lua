--Included in spells.xml
--[[
    <instant group="support" spellid="6" name="Dash" words="dashio" level="14" mana="60" premium="0" aggressive="0" selftarget="1" cooldown="2000" groupcooldown="2000" needlearn="0" script="custom/dash.lua">
        <vocation name="Sorcerer" />
        <vocation name="Master Sorcerer" />
    </instant>
--]]

--tile flags that will disallow dash
local unwanted_tilestates = { TILESTATE_PROTECTIONZONE, TILESTATE_HOUSE, TILESTATE_FLOORCHANGE, TILESTATE_TELEPORT, TILESTATE_BLOCKSOLID, TILESTATE_BLOCKPATH }


function dashStep(creature, variant)
	creature = Creature(creature)
	dir = creature:getDirection()
    --move in sets of 3 tiles, similar to the video
	for i=1,3 do
        nextMovePos = creature:getPosition()
        nextMovePos:getNextPosition(dir)
        tile = Tile(nextMovePos)
        --Ensure the next tile is valid
        for _, tilestate in pairs(unwanted_tilestates) do
        	if tile:hasFlag(tilestate) then
         		creature:sendCancelMessage("You can't dash any further")
         		return false
         	end
        end
        --Then Move
        doMoveCreature(creature, dir)
    end
end

--Send packet to client to turn off/on shader
function sendShaderStoragePacket(creature, variant)
    local player = Player(creature)
    local packet = NetworkMessage()
    packet:addByte(0x32)
    packet:addByte(0x37)
    packet:addString(tostring(player:getStorageValue(99999)))
    packet:sendToPlayer(player)
    packet:delete()
end


function onCastSpell(creature, variant)
    --Turn on shader
    creature:setStorageValue(99999, 1)
    sendShaderStoragePacket(creature:getId(), variant)

    --Repeated as a form of smoothing. 
    for i=0,1 do
    	addEvent(dashStep, i*200, creature.uid, variant)
    end

    --Turn off shader with delay to match timings
    creature:setStorageValue(99999, 0)
    addEvent(sendShaderStoragePacket, 400, creature:getId(), variant)
	return true
end