--[[
Included in spells.xml

<instant group="attack" spellid="9999" name="Tavernlight Nova" words="frigo" level="1" mana="100" premium="0" cooldown="1000" groupcooldown="2000" selftarget="1" needlearn="0" script="attack/tavernlight_nova.lua">
		<vocation name="Sorcerer" />
		<vocation name="Master Sorcerer" />
</instant>
--]]

--tornado spawn locations
spawnLocations = {
   	{0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {1, 0, 1, 3, 1, 0, 1},
    {0, 1, 0, 1, 0, 1, 0},
    {0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
}

--Combat will do damage, areaCombat will deal with effects
local combat = Combat()
local areaCombat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
areaCombat:setArea(createCombatArea(spawnLocations))

--Turn on/off tornados at random and do damage
function onTargetTile(cid, pos)
	return math.random(3) == 1 and doCombat(cid, combat, positionToVariant(pos))
end

areaCombat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")


--Used to call execute function through addEvent()
function rollSpell(creature, variant)
	areaCombat:execute(creature, variant)
end

function onCastSpell(creature, variant)
	--Call multiple times with delay. 
	for i=1,6 do
		addEvent(rollSpell, i*400, creature:getId(), variant)
	end
	return areaCombat:execute(creature, variant)
end
