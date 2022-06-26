# DCS-RGC
Random Ground Convoy for DCS (Digital Combat Simulator)

- How to install

In the Mission editor add the script in to the mission as a file at mission start or use the do script to read the script from a file location.

File location with Do script:
assert(loadfile("D:\\my scripts\\DCS-RGC\\dcs-rgc.lua"))()


- How to use

Syntax:
string
rgc.SpawnRGC(number CountryID,number SpawnCoalition ,number CoalitonIDToAttack ,number GroupSize ,string Skill, number Speed ,string SpawnZoneName (Or Nil),
number SpawnAirbaseID (or Nil), number TargetAirbaseId (or Nil),string TriggerZone Name (or no value) )


Examples:

1: rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , nil, 19)

Country: Russia
Coalition list of units: Red
Target Coalition: 2 (Blue)
Group size : 10 (units)
Skill of units: Avarage
Driving Speed of units: 10
SpawnZone not used : nil (must be nil if not used)
Spawn at Airbase ID : 19 (SpawnZone or SpawnAirbaseID must be used)

If no Target base ID or Zone is used, then the script will find a airbase with the other coalition to attack.



2: rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , 'TestSpawnZone')

Spawnzone used, if no more arguments are used, SpawnAirbaseID does not need to be filled out. Has to be Nil if more are used.



3: rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , 'TestSpawnZone', nil, 10)

Used target Airbase 10


4: rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

used TargetZone to attack


5:
_uCount = math.random(1,10)
rgc.SpawnRGC(0, 1, 2, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

Random amount of units between 1 and 10.

6:
rgc.SpawnRGC(2, 2, 1, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')
Country: 2 (USA)
Coalition list of units: Blue
Target Coalition: 1 (Red)

("unitTypeRedTbl" and "unitTypeBlueTbl" in the scrit file reflect the coalition you are spawning)

