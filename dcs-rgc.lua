--[[
DCS Random Ground Convoy

Allowes you to spawn random convoys at airbases or trigger zones 



Tigger zones need to be at all airbases in use with the "AirbaseTriggerZoneStartingName" prefix and the actual airbase ID on the map you are playing:
https://wiki.hoggitworld.com/view/Category:Terrain_Information#Syria

-- Will look in to changing this requirement in the future.

Webpage and updates:
https://github.com/AGluttonForPunishment/DCS-RGC

Other Projects for DCS:
https://github.com/AGluttonForPunishment/


ED FORUM:
https://forum.dcs.world/topic/303693-dcs-rgc-a-random-ground-convoy-creator/


My DCS Servers:
https://forum.dcs.world/topic/301046-wargames-server-pvp-and-pve-campaign-servers/



Require MIST:
https://github.com/mrSkortch/MissionScriptingTools/tree/master




Special thank you to : https://wiki.hoggitworld.com/
and MIST
for the massive help it has been to create this script.

And a special thank you to "Grimes" at the ED Forums for helping me with my first coding steps a few years ago :)


See the example mission for how to use the script.

--]]



env.info('-- Random Ground Convoy - Loading  ')

rgc = {} -- Do not remove!!



---------------
-- Settings: --
---------------

showTextWhenSpawn = true -- true or false ( Do not remove )
logDebugWhenSpawn = false -- true or false ( Do not remove )

--_restrictToSingleGroup = false
-- _attackingGroup = nil

-- Max simultanius Convoys on map
_maxAttackingConvoyGroups = 20 -- 1 or max Groups you want ( Do not remove )

-- Every Airbase that you attack with an AirbaseID,needs a trigger zone. Example Krasnodar-Center is AirbaseID 13. Zone name used will be "AF_13" - Can be done better with MOOSE: ZONE_POLYGON
_AirbaseTriggerZoneStartingName = 'AF_' --  (Do not remove)

-- Convoy Group names start with
_groupPrefixName = "SA_Convoy_"

--[[

-- Trype of route the convoy will take up to the target base / Zone. Will go off road to attack targets.
Types :

"Off Road"
"On Road"
"Rank"
"Cone"
"Vee"
"Diamond"
"EchelonL"
"EchelonR"


]]--
_ConvoyRoute = "Off Road" 	-- ( Do not remove )


-- When at target base / zone, find and attack all units.
_UnitAttack = true		-- ( Do not remove ) true or false

-- check area for valid surface in SpawnZone or with AirbaseId.
_abSpwPosMin = 50 	-- ( Do not remove )
_abSpwPosMax = 500		-- ( Do not remove )

-- if you want a sound when a Convoy spawns
_SpawnSound = "Whisper_4.ogg"

-- Tables

attackingConvoyGroupsTbl = {} --( Do not remove )

_targetBase = {}  --( Do not remove )







--[[

Syntax:
string rgc.spawn(number CountryID ,number SpawnCoalition,number CoalitonIDToAttack ,number GroupSize ,string Skill, number Speed ,string SpawnZoneName (Or Nil),number SpawnAirbaseID (or Nil), number TargetAirbaseId (or Nil),string TriggerZone Name (or no value) )

Example:

-- CountryID, SpawnCoalition, AttackCoalition, GroupSize, Skill, Speed, SpawnZone, AirbaseId, TargetAirbaseId, TargetZone

rgc.spawn(0, 1, 2 , 5, 'Average', 30, 'TestSpawnZone')

local cSize = math.random(1,10)
rgc.spawn(0, 1, 2, cSize, 'Average', 30 , nil, 12)

rgc.spawn(0, 1, 2 ,10, 'Average', 20, 'TestSpawnZone')

rgc.spawn(0, 1, 2,10, 'Average', 10 , nil, 12)
rgc.spawn(0, 1, 2,10, 'Average', 10 , nil, 17, 14)


rgc.spawn(0, 1, 2 ,10, 'Average', 20, 'TestSpawnZoneRed', 15)
rgc.spawn(0, 1, 2 ,10, 'Average', 20, 'AF_14', 15)

rgc.spawn(0, 1, 2 ,10, 'Average', 20, 'TestSpawnZone',nil, nil, 'AF_15')

rgc.spawn(0, 1, 2 ,5, 'Average', 30, 'TestSpawnZoneRed')


rgc.spawn(2, 2, 2 ,5, 'Average', 30, 'TestSpawnZoneBlue')


-- USA Country but with Russia units
rgc.spawn(2, 1, 1, 9, 'Average', 30, 'TestSpawnZoneBlue')

-- USA Country but with Russia units attacking Blue forces (Blue on Blue)
rgc.spawn(2, 1, 1, 9, 'Average', 30, 'TestSpawnZoneBlue')



]]--




function rgc.spawn(CountryID, spawnCoalition, AttackCoalition, GroupSize, Skill, Speed, SpawnZone, AirbaseId, TargetAirbaseId, TargetZone)

	if (logDebugWhenSpawn == true) then
	
		env.info ('-- Spawning groups CountryID: ' .. CountryID)
		env.info ('-- Spawning groups Coalition: ' .. spawnCoalition)
		env.info ('-- Spawning groups AttackCoalition: ' .. AttackCoalition)
		env.info ('-- Spawning groups GroupSize: ' .. GroupSize)
		env.info ('-- Spawning groups Skill: ' .. Skill)
		env.info ('-- Spawning groups Speed: ' .. Speed)
	
		if SpawnZone ~= nil then
			env.info ('Spawning groups SpawnZone: ' .. SpawnZone)
		end
		if AirbaseId ~= nil then
			env.info ('Spawning groups AirbaseId: ' .. AirbaseId)
		end
		if TargetAirbaseId ~= nil then
			env.info ('Spawning groups TargetAirbaseId: ' .. TargetAirbaseId)
		end
		if TargetZone ~= nil then
			env.info ('Spawning groups TargetZone: ' .. TargetZone)
		end
		--_attackingGroup = _attackingGroup or nil -- used to limit attack to 1 group at a time

		if (AirbaseId == nil) then
	
		--env.info('No AirbaseId : ' .. AirbaseId)
	
		end
	end -- if (logDebugWhenSpawn == true) then

	local _CountryID = CountryID or 0 -- Standard RUSSIA Units
	local _attackCoalition = AttackCoalition or 2 -- Standard Attack Blue Coalition
	local _spawnUnitCoalition = spawnCoalition or 1
	local _groupSize = GroupSize or 1
	local _groupSkill = Skill or "Average"
	local _speed = Speed or 40
	local _SpawnAtName = ""
	local _SpawnAtID = 0
	local  ranspawnZonePos = {}
	local _spawnBasePoint = {}
	local _targetBasePointZone = {}
	
	local _TargetZone = TargetZone or nil

	local _triggerTargetZoneName = ""
	local _TriggerTargetZone = nil

	local foundUnits = {}
	local sphere = {}
	local volS = {}
	
	local _abSpwPosMin = _abSpwPosMin or 1000
	local _abSpwPosMax = _abSpwPosMax or 4000
	
	local _convoysCount = 0
	local CheckranspawnZonePos = {}
	
	
	local unitTypeRedTbl = {
		"BRDM-2",
		"BTR-80",
		"BTR_D",
		"MTLB",
		"BMD-1",
		"BMP-1",
		"BMP-2",
		"BMP-3",
		"BTR-82A",
		"PT_76",
		"T-55",
		"T-72B",
		"T-72B3",
		"T-80UD",
		"T-90",
		"HL_DSHK",
		"HL_KORD",
		"tt_DSHK",
		"tt_KORD",
		"Ural-375",
		"SAU Msta",
		"Ural-375 ZU-23",
		"ZSU-23-4 Shilka",
		"Strela-1 9P31",
		"Osa 9A33 ln",
		"Tor 9A331",
		"Smerch",
	}
	
	local unitTypeBlueTbl = {
		"M1043 HMMWV Armament",
		"M1045 HMMWV TOW",
		"M-113",
		"LAV-25",
		"MCV-80",
		"M-109",
		"Marder",
		"M1128 Stryker MGS",
		"M1134 Stryker ATGM",
		"M-2 Bradley",
		"M-60",
		"Leopard1A3",
		"leopard-2A4",
		"M-1 Abrams",
		"Gepard",
		"M1097 Avenger",
		"Roland ADS",
		"M48 Chaparral",
		"M6 Linebacker",
		"MLRS FDDM",
	
	}
	
	local _unitTypesCountRed = 0
	for i = 1, #unitTypeRedTbl do
	
		_unitTypesCountRed = i --_unitTypesCount +1
	
	end
	
	
	
	
	local _unitTypesCountBlue = 0
	for i = 1, #unitTypeBlueTbl do
	
		_unitTypesCountBlue = i --_unitTypesCount +1
	
	end
	
	if (logDebugWhenSpawn == true) then
		env.info ('Found Blue Unit types: ' .. _unitTypesCountRed)
		env.info ('Found Blue Unit types: ' .. _unitTypesCountBlue)
	end
	
	
	

		

   local _tabCounter = 0
   local base = world.getAirbases()
   local myBaseTblBlueTargets = {}
   
   --From https://wiki.hoggitworld.com/
   for i = 1, #base do
       local infoBases = {}
       infoBases.desc = Airbase.getDesc(base[i])
       infoBases.callsign = Airbase.getCallsign(base[i])
       infoBases.id = Airbase.getID(base[i])
       infoBases.cat = Airbase.getCategory(base[i])
       infoBases.point = Airbase.getPoint(base[i])
       if Airbase.getUnit(base[i]) then
           infoBases.unitId = Airbase.getUnit(base[i]):getID()
		   --infoBases.unitName = Airbase.getUnit(base[i]):GetName()
		   --infoBases.unitGroupName = Group.getName(Airbase.getUnit(base[i]))
		   
		   --env.info('Found Blue group at Airbase: ' .. infoBases.callsign .. ' - GroupName: ' .. infoBases.unitGroupName)
		   
       end
       

		
	if (AirbaseId ~= nil) and (SpawnZone == nil)  then
	
		_AirdomeIdStr = string.gsub(AirbaseId, "%s+", "")
		
		--env.info('_AirdomeIdStr str : (' .. _AirdomeIdStr .. ')')
		
		--Fjern mellomrom i id
	   str = string.gsub(infoBases.id, "%s+", "")
	   
	   --env.info('SpawnBase str : (' .. str .. ')') 
	   
	   if _AirdomeIdStr == str then
			_SpawnAtName = infoBases.callsign
			_SpawnAtID = infoBases.id
			_spawnBasePoint = Airbase.getPoint(base[i])
			--trigger.action.outText("Spawn Base Name : " .. _SpawnAtName, 20)
			
			SpawnAiMsg = string.format("SpawinBasePosX : %i", _spawnBasePoint.x)
			--trigger.action.outText(SpawnAiMsg, 20)
			
			if (logDebugWhenSpawn == true) then
				env.info('Spawn base info for manual target: ' .. _SpawnAtName)
				env.info('SpawnAirbaseID match: (' .. str .. ') and (' .. _SpawnAtID .. ')')
			end
			
	   end
		
	end
	
	if (AirbaseId == nil) and (SpawnZone == nil)  then
	
		-- what to do if Airbase ID or SpawnZone is given
	
	end
	
	
	
	if (TargetAirbaseId ~= nil) then
	
		_AirbaseTargetIdStr = string.gsub(TargetAirbaseId, "%s+", "")
		
		--env.info('target string: -' .. _AirbaseTargetIdStr.. '-')
		--Fjern mellomrom i id
	   strTgt = string.gsub(infoBases.id, "%s+", "")
	   
	   --env.info('target string 2: -' .. strTgt .. '-')
	
		if (_AirbaseTargetIdStr == strTgt) then
	
	
			-- _mantargetBase =	#base[i]
			--_targetBase = {}
			myBaseTblBlueTargets[1] = infoBases
			
			if (logDebugWhenSpawn == true) then
				env.info('Target base info for manual target: ' .. myBaseTblBlueTargets[1].callsign)
				env.info('TargetAirbaseID match: (' .. strTgt .. ') and (' .. _AirbaseTargetIdStr .. ')')
			end
			
			
			--myBaseTblBlueTargets[1] = {
			--
			--	["id"] = TargetAirbaseId,
		
			--}
		end
		
	else
	
	
	
	
	
	   	infoBases.coalition = (base[i]):getCoalition()
		
		-- Find all Blue Airbases and add them to a table
		if (infoBases.desc.category == 0 ) and (Airbase.getCategory(base[i]) == 4) then
		
			-- AttackCoalition selected
			if (infoBases.coalition == AttackCoalition)  then
			
				-- Custom for my misson
				--if ((trigger.misc.getUserFlag(infoBases.id) == 0) or (trigger.misc.getUserFlag(infoBases.id) == 2)) and ((trigger.misc.getUserFlag(_SpawnAtID) == 0) or (trigger.misc.getUserFlag(_SpawnAtID) == 1)) then
			
					--If you play on Syra, the island bases you should uncomment this (And add all bases used out there to avoid units trying to cross the sea)
					--if (infoBases.id == 50 or infoBases.id == 47) and (_SpawnAtID == 50 or _SpawnAtID == 47) then
				
						if (logDebugWhenSpawn == true) then
							env.info('-- Island Valid Targets : ' .. infoBases.callsign)
						end
						
						_tabCounter = _tabCounter + 1
						--myBaseTblBlueTargets[infoBases.id] = infoBases
						myBaseTblBlueTargets[_tabCounter] = infoBases
						
				--[[	--If you play on Syra, the island bases you should uncomment this
						elseif ((infoBases.id ~= 50 and _SpawnAtID ~= 47)) or ((_SpawnAtID ~= 50 and infoBases.id ~= 47)) then
					
						if (logDebugWhenSpawn == true) then
							env.info('Valid Targets : ' .. infoBases.callsign)
						end
						_tabCounter = _tabCounter + 1
						--myBaseTblBlueTargets[infoBases.id] = infoBases
						myBaseTblBlueTargets[_tabCounter] = infoBases
					
					end	
					]]--
							
				
				--end
											
			
			end -- if (infoBases.coalition == AttackCoalition)  then
			
		end -- if (infoAF.desc.category == 0 ) and (Airbase.getCategory(base[i]) == 4) then

	end -- if (TargetAirbaseId ~= nil) then

	
		
		
	end
	
	if (TargetAirbaseId ~= nil) then
		_randomBlueBase = 1
	else
		-- Random select of blue airbase
		_randomBlueBase = math.random(1, _tabCounter)
	end
	
	--trigger.action.outText("Airbase 1 : " .. myBaseTblBlueTargets[27].callsign, 20) 
	
	
	if (TargetZone ~= nil) then
	
		-- make shure it's a string
		--triggerTargetZoneName = string.format("%s", TargetZone)
		
		if (logDebugWhenSpawn == true) then
			env.info('Found Zone Name: ' .. TargetZone)
		end
		
				
		--From https://wiki.hoggitworld.com/view/DCS_func_searchObjects
		
		if (trigger.misc.getZone(TargetZone)) then
		
			_targetBaseName = TargetZone
		
			sphere = trigger.misc.getZone(TargetZone)
			volS = {
			id = world.VolumeType.SPHERE,
				params = {
					point = sphere.point,
					radius = sphere.radius
				}
			}
 
			local ifFound = function(foundItem, val)
			
				if (Unit.getCoalition(foundItem) == _attackCoalition) then
			
					foundUnits[#foundUnits + 1] = foundItem:getName()
					
					if (logDebugWhenSpawn == true) then
						env.info('Found Unit : ' .. foundItem:getName() .. ' - Coalition: ' .. _attackCoalition)
					end
					
					return true
			
				end
			
			end
			
			world.searchObjects(Object.Category.UNIT, volS, ifFound)
	
			--_targetBaseName = triggerTargetZoneName
	
			--_targetBasePointZone.x = sphere.point.x + math.random(4000 * -1, 4000)
			--_targetBasePointZone.z = sphere.point.z + math.random(4000 * -1, 4000)
			
			--_TriggerTargetZone = trigger.misc.getZone(TargetZone)
			
			_targetBasePointZone = findLandSurface(TargetZone)
			
			--_targetBasePointZone.x = _TriggerTargetZone.point.x + math.random(_TriggerTargetZone.radius * -1, _TriggerTargetZone.radius)
			--_targetBasePointZone.z = _TriggerTargetZone.point.z + math.random(_TriggerTargetZone.radius * -1, _TriggerTargetZone.radius)
			
			
		end
	
	else
	
		if myBaseTblBlueTargets[_randomBlueBase] ~= nil then
	
		
	
			if myBaseTblBlueTargets[_randomBlueBase].point ~= nil then
		
				_targetBasePoint = myBaseTblBlueTargets[_randomBlueBase].point
				_targetBaseName = myBaseTblBlueTargets[_randomBlueBase].callsign

			
		

				--_targetBasePointZone.x = _targetBasePoint.x + math.random(4000 * -1, 4000)
				--_targetBasePointZone.z = _targetBasePoint.z + math.random(4000 * -1, 4000)
				
			
				
				triggerTargetZoneName = string.format(_AirbaseTriggerZoneStartingName .. "%i", myBaseTblBlueTargets[_randomBlueBase].id)
				_TriggerTargetZone = trigger.misc.getZone(triggerTargetZoneName)
				
				_targetBasePointZone.x = _TriggerTargetZone.point.x + math.random(_TriggerTargetZone.radius * -1, _TriggerTargetZone.radius)
				_targetBasePointZone.z = _TriggerTargetZone.point.z + math.random(_TriggerTargetZone.radius * -1, _TriggerTargetZone.radius)
				
				--env.info('Random Target : - Found Zone Name: (' .. triggerTargetZoneName .. ')' )
				
				--From https://wiki.hoggitworld.com/view/DCS_func_searchObjects
				
				--if (trigger.misc.getZone(triggerTargetZoneName) ~= nil) then
				if (trigger.misc.getZone(triggerTargetZoneName)) then
				
					--env.info('Random Target : Checked AF Zone OK : (' .. triggerTargetZoneName .. ')' )
		

					sphere = trigger.misc.getZone(triggerTargetZoneName)
					volS = {
						id = world.VolumeType.SPHERE,
						params = {
							point = sphere.point,
							radius = sphere.radius
						}
					}
		

		
					local ifFound = function(foundItem, val)
			
						--env.info('Before - Random Target Base - Found Unit : ' .. foundItem:getName() .. ' - Coalition: ' .. _attackCoalition)
			
						if (Unit.getCoalition(foundItem) == _attackCoalition) then
			
							
			
							foundUnits[#foundUnits + 1] = foundItem:getName()
					
							if (logDebugWhenSpawn == true) then
								env.info('Random Target Base - Found Unit : ' .. foundItem:getName() .. ' - Coalition: ' .. _attackCoalition)
							end
					
							return true
			
						end
			
					end
					
					world.searchObjects(Object.Category.UNIT, volS, ifFound)
					
					
				end -- if (trigger.misc.getZone(triggerTargetZoneName)) then



			end -- end of if myBaseTblBlueTargets[_randomBlueBase].point ~= nil then
		
		end -- end of if myBaseTblBlueTargets[_randomBlueBase] ~= nil then

	
	end -- end of if (TargetZone == nil) then
	




	if (SpawnZone ~= nil) then
	
		if (logDebugWhenSpawn == true) then
			env.info('-- KB Random Ground Convoy - SpawnZone used : ' .. SpawnZone)
		end
		

		_SpawnAtName = SpawnZone
	
		ranspawnZonePos = findLandSurface(SpawnZone)
		


	end




	local _groupId = mist.getNextGroupId()
	local _groupName = _groupPrefixName .. _groupId

	local data = {

								["visible"] = false,
                                ["tasks"] = 
                                {
                                }, -- end of ["tasks"]
                                ["uncontrollable"] = false,
                                ["task"] = "Ground Nothing",
                                ["taskSelected"] = true,
                                
								["route"] =
								{
								
								},
								
                                ["groupId"] = _groupId,
                                ["hidden"] = false,
                                ["units"] = 
                                {
                                   								
							
								}, -- end of ["units"]
                            --["y"] = _spawnBasePoint.z,
							--["x"] = _spawnBasePoint.x,
                            ["name"] = _groupName,
                            ["start_time"] = 0,
	} -- end of data

-- Debuging
--[[
if (_targetBasePointZone.z ~= nil) then

	--env.info('Found: _targetBasePointZone.x')

end

if (_targetBasePointZone.z ~= nil) then

	--env.info('Found: _targetBasePointZone.z')

end

if (_spawnBasePoint.x ~= nil) then

	--env.info('Found: _spawnBasePoint.x')

end

if (_spawnBasePoint.z ~= nil) then

	--env.info('Found: _spawnBasePoint.z')

end
]]--

-- Should stop game from crashing if points was not found
if ((_targetBasePointZone.x ~= nil) and (_targetBasePointZone.z ~= nil) and (_spawnBasePoint.x ~= nil) and (_spawnBasePoint.z ~= nil)) or ( (_targetBasePointZone.x ~= nil) and (_targetBasePointZone.z ~= nil) and (SpawnZone ~= nil) )  then


	data.route =
	{

        
        ["points"] = 
        {
            [1] = 
            {
                ["alt"] = 32,
                ["type"] = "Turning Point",
                ["ETA"] = 0,
                ["alt_type"] = "BARO",
                ["formation_template"] = "",
                --["y"] = _spawnBasePoint.z,
                --["x"] = _spawnBasePoint.x +200,
                ["ETA_locked"] = false,
                ["speed"] = _speed,
                ["action"] = _ConvoyRoute,
                ["task"] = 
                {
                    ["id"] = "ComboTask",
                    ["params"] = 
                    {
                        ["tasks"] = 
                        {
                            [1] = 
                            {
                                ["number"] = 1,
                                ["auto"] = false,
                                ["id"] = "WrappedAction",
                                ["enabled"] = true,
                                ["params"] = 
                                {
                                    ["action"] = 
                                    {
                                        ["id"] = "SetInvisible",
                                        ["params"] = 
                                        {
										["value"] = false,
                                        }, -- end of ["params"]
                                    }, -- end of ["action"]
                                }, -- end of ["params"]
                            }, -- end of [1]
                        }, -- end of ["tasks"]
                    }, -- end of ["params"]
                }, -- end of ["task"]
                ["speed_locked"] = true,
            }, -- end of [1]
            [2] = 
            {
                ["alt"] = 32,
                ["type"] = "Turning Point",
                ["ETA"] = 403.52025197396,
                ["alt_type"] = "BARO",
                ["formation_template"] = "",
                ["y"] = _targetBasePointZone.z,
                ["x"] = _targetBasePointZone.x,
                ["ETA_locked"] = false,
                ["speed"] = _speed,
                ["action"] = _ConvoyRoute,
                ["task"] = 
                {
                    ["id"] = "ComboTask",
                    ["params"] = 
                    {
                        ["tasks"] = 
                        {
                        }, -- end of ["tasks"]
                    }, -- end of ["params"]
                }, -- end of ["task"]
                ["speed_locked"] = true,
            }, -- end of [2]
        }, -- end of ["points"]
    }

			local _routeTargets = 2
			if (foundUnits ~= nil) and (_UnitAttack == true) then
					
					for i = 1, #foundUnits do
						
						
						local _tgtUnit = Unit.getByName(foundUnits[i])
						local _tgtUnitPoint = _tgtUnit:getPoint()
						local _tgtGroup = Unit.getGroup(_tgtUnit)
						local _tgtGroupName = Group.getName(_tgtGroup)
						local _tgtGroupID =  Group.getID(_tgtGroup)
						
						--env.info('Found units to attack in Zone: ' .. foundUnits[i] .. ' - Group Name : ' .. _tgtGroupName .. ' - GroupID: ' .. _tgtGroupID)
						
						_routeTargets = _routeTargets+1
						
						data.route.points[_routeTargets] = {
						
							["alt"] = 32,
							["type"] = "Turning Point",
							["ETA"] = 403.52025197396,
							["alt_type"] = "BARO",
							["formation_template"] = "",
							["y"] = _tgtUnitPoint.z,
							["x"] = _tgtUnitPoint.x,
							["ETA_locked"] = false,
							["speed"] = _speed,
							["action"] = "Off Road",
							["task"] = 
							{
                                ["id"] = "ComboTask",
                                ["params"] = 
                                {
									["tasks"] = 
                                    {
                                        [1] = 
                                        {
											["enabled"] = true,
                                            ["auto"] = false,
                                            ["id"] = "AttackGroup",
                                            ["number"] = 1,
                                            ["params"] = 
                                            {
												["altitudeEnabled"] = false,
                                                ["groupId"] = _tgtGroupID,
                                                ["attackQtyLimit"] = false,
                                                ["attackQty"] = 1,
                                                ["expend"] = "Auto",
                                                ["altitude"] = 13,
                                                ["directionEnabled"] = false,
                                                ["groupAttack"] = false,
                                                ["weaponType"] = 1073741822,
                                                ["direction"] = 0,
                                            }, -- end of ["params"]
                                        }, -- end of [1]
                                    }, -- end of ["tasks"]
                                }, -- end of ["params"]
                            }, -- end of ["task"]
							["speed_locked"] = true,
						
						
						}
					end
			end



	if (_groupSize ~= nil) then


		data.units = data.units or {}
		
		local _spawnUnitZ = 0
		local _spawnUnitX = 0
		local _spawnUnit = 0
		local _newpoint = {}
		
			if SpawnZone ~= nil then

				data.route.points[1] = {y = ranspawnZonePos.z}
				data.route.points[1] = {x = ranspawnZonePos.x}
		
				data["x"] = ranspawnZonePos.z
				data["y"] = ranspawnZonePos.x
			
				_spawnUnitZ = ranspawnZonePos.z
				_spawnUnitX = ranspawnZonePos.x
				
				_newpoint = findLandSurfacePoint(ranspawnZonePos)
				
			
				--env.info('-- KB RGCS - Spawn location : SpawnZone used')
			
			elseif	(AirbaseId ~= nil) and (SpawnZone == nil) then
				
				_newpoint = findLandSurfacePoint(_spawnBasePoint)
				
				
				
				data.route.points[1] = {y = _newpoint.z}
				data.route.points[1] = {x = _newpoint.x}
		
				
				data["x"] = _newpoint.x
				data["y"] = _newpoint.z
			
				
				
				_spawnUnitX = _newpoint.x
				_spawnUnitZ = _newpoint.z
				
				--env.info('-- KB RGCS - Spawn location : Airbase used')
			
			end
		
	
	
		for idx = 1, _groupSize do

			local _unitId = mist.getNextUnitId()
			
			local _UnitType = ""
			
			if (_spawnUnitCoalition == 1) then
			
				local _idxUnitType = math.random( 1, _unitTypesCountRed)
				_UnitType = unitTypeRedTbl[_idxUnitType]
			
			else
			
				local _idxUnitType = math.random( 1, _unitTypesCountBlue)
				_UnitType = unitTypeBlueTbl[_idxUnitType]
			
			end
			
			
			_spawnUnit = findLandSurfacePoint(_newpoint)
			
			 
			
					
			data.units[idx] =
			{
		
				["type"] = _UnitType,
				["unitId"] = _unitId,
				["skill"] = _groupSkill,
				["y"] = _spawnUnit.z,
				["x"] = _spawnUnit.x,
				["name"] = _groupPrefixName .. _groupId .. "-" .. _unitId,
				["heading"] = 0,
				["playerCanDrive"] = true,			

		
			}
			


		end

	end --end of if (_groupSize ~= nil) then



	
	if (showTextWhenSpawn ~= nil) then
		showTextWhenSpawn = true
	end
	
	if (logDebugWhenSpawn ~= nil) then
		ogDebugWhenSpawn = true
	end


	if (attackingConvoyGroupsTbl ~= nil) then

		for _ in pairs(attackingConvoyGroupsTbl) do
		

			if (Group.getByName(attackingConvoyGroupsTbl[_]) and Group.getByName(attackingConvoyGroupsTbl[_]):getSize() > 0)  then
		
				_convoysCount = _convoysCount + 1
		
			else
		
				if (logDebugWhenSpawn == true) then
					env.info('-- KB Random Ground Convoy - Removing Dead Convoy: ' .. attackingConvoyGroupsTbl[_])
				end
				
				attackingConvoyGroupsTbl[_] = nil
		
				

			end

		end
	end



	if (_maxAttackingConvoyGroups ~= nil) then
	
		if (_convoysCount < _maxAttackingConvoyGroups) then
		

	

					coalition.addGroup(_CountryID , Group.Category.GROUND, data)
					--_attackingGroup = _groupName
					table.insert(attackingConvoyGroupsTbl, _groupName)
					
					if (showTextWhenSpawn == true) then
						local SpawnMsg = 'A enemy Convoy group Spawned at : ' .. _SpawnAtName .. ' and is attacking : ' .. _targetBaseName
						trigger.action.outText(SpawnMsg, 60)
						
						if (_SpawnSound ~= nil) then
							trigger.action.outSound(_SpawnSound)
						end
					end
					
					if (logDebugWhenSpawn == true) then
						env.info('-- KB Random Ground Convoy - Group : ' .. _groupName .. ' - Spawned at : ' .. _SpawnAtName .. ' and is attacking : ' .. _targetBaseName)
					end
				--end


		else
		
			--if (logDebugWhenSpawn == true) then
				env.info('-- KB Random Ground Convoy - Max Convoy groups spawned for Country ID : ' .. CountryID .. ' - Convoy Groups: ' .. _convoysCount .. ' of ' .. _maxAttackingConvoyGroups)
			--end

		
		end	-- if (_convoysCount < _maxAttackingConvoyGroups) then
		
	

		
	end	--	if (_maxAttackingConvoyGroups ~= nil) then

else

		if (TargetZone ~= nil) then
	
			env.info('-- KB Random Ground Convoy : No target coordinets found. Zone or zone in base not found for TargetZone : ' .. TargetZone )
	
		elseif (_targetBaseName ~= nil) then
	
			env.info('-- KB Random Ground Convoy : No target coordinets found. Zone or zone in base not found for _targetBaseName: ' .. _targetBaseName )
	
		else
	
			env.info('-- KB Random Ground Convoy : Some parameter is not correct! ')
	
		end



end -- if (_targetBasePointZone.x ~= nil) and (_targetBasePointZone.z ~= nil) and (_spawnBasePoint.x ~= nil) and (_spawnBasePoint.z ~= nil)  then


	if (logDebugWhenSpawn == true) then

		if (attackingConvoyGroupsTbl ~= nil) then

			env.info('-- KB Random Ground Convoy - Active Convoys : ')
			for i = 1, #attackingConvoyGroupsTbl do
			
				env.info('-- KB Random Ground Convoy : ' .. attackingConvoyGroupsTbl[i] )
			
			end
			
		end

	end
	
end




function findLandSurface(zone)
		
			local _spawnZonePos = trigger.misc.getZone(zone)
		
			local newranspawnZonePos = {}
			--local CheckSurfaceType = {}
			local CheckranspawnZonePos = {}
			
			for i = 1, 50 do
		
		
				
				CheckranspawnZonePos.x = _spawnZonePos.point.x + math.random(_spawnZonePos.radius * -1, _spawnZonePos.radius)
				CheckranspawnZonePos.y = _spawnZonePos.point.z + math.random(_spawnZonePos.radius * -1, _spawnZonePos.radius)
			
				--CheckSurfaceType = land.getSurfaceType(CheckranspawnZonePos)
			
				--[[
					land.SurfaceType 
					LAND             1
					SHALLOW_WATER    2
					WATER            3 
					ROAD             4
					RUNWAY           5
				]]--
			
				if (land.getSurfaceType(CheckranspawnZonePos) == 1) then
		
					
					--env.info('---- Surface Type is cord ' .. i .. ' = LAND')
					
					
					newranspawnZonePos.x = CheckranspawnZonePos.x
					newranspawnZonePos.z = CheckranspawnZonePos.y
					
					return newranspawnZonePos
				end
		
			end
		
		
			
end -- function findLandSurface (zone)



function findLandSurfacePoint(chkpoint)
		
			--local _spawnZonePos = trigger.misc.getZone(zone)
		
			local newranspawnZonePos = {}
			--local CheckSurfaceType = {}
			local CheckranspawnZonePos = {}
			
			for i = 1, 50 do
		
		
				
				CheckranspawnZonePos.x = chkpoint.x + math.random(_abSpwPosMin * -1, _abSpwPosMax)
				CheckranspawnZonePos.y = chkpoint.z + math.random(_abSpwPosMin * -1, _abSpwPosMax)
			
				--CheckSurfaceType = land.getSurfaceType(CheckranspawnZonePos)
			
				--[[
					land.SurfaceType 
					LAND             1
					SHALLOW_WATER    2
					WATER            3 
					ROAD             4
					RUNWAY           5
				]]--
			
				if (land.getSurfaceType(CheckranspawnZonePos) == 1) then
		
					
					--env.info('---- Surface Type is cord ' .. i .. ' = LAND')
					
					newranspawnZonePos.x = CheckranspawnZonePos.x
					newranspawnZonePos.z = CheckranspawnZonePos.y
					
					return newranspawnZonePos
				end
		
			end
		
		
			
end -- function findLandSurfacePoint (chkpoint)



env.info('-- Random Ground Convoy is loaded!  ')
