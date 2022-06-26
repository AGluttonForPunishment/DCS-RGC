# DCS-RGC
Random Ground Convoy for DCS (Digital Combat Simulator)

- How to install

In the Mission editor add the script in to the mission as a file at mission start or use the do script to read the script from a file location.

File location with Do script:<br>
assert(loadfile("D:\\my scripts\\DCS-RGC\\dcs-rgc.lua"))()
<br>
<br>
- How to use

Syntax:
string
rgc.SpawnRGC(number CountryID,number SpawnCoalition ,number CoalitonIDToAttack ,number GroupSize ,string Skill, number Speed ,string SpawnZoneName (Or Nil),
number SpawnAirbaseID (or Nil), number TargetAirbaseId (or Nil),string TriggerZone Name (or no value) )
<br>
<br>

Examples:
<br>
<br>

1:
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , nil, 19)

<br>
<br>

Country: Russia
Coalition list of units: Red
Target Coalition: 2 (Blue)
Group size : 10 (units)
Skill of units: Avarage
Driving Speed of units: 10
SpawnZone not used : nil (must be nil if not used)
Spawn at Airbase ID : 19 (SpawnZone or SpawnAirbaseID must be used)

<br>

If no Target base ID or Zone is used, then the script will find a airbase with the other coalition to attack.

<br>
<br>

2:
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , 'TestSpawnZone')

<br>
Spawnzone used, if no more arguments are used, SpawnAirbaseID does not need to be filled out. Has to be Nil if more are used.

<br>
<br>

3:
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , 'TestSpawnZone', nil, 10)
<br>

Used target Airbase 10

<br>
<br>

4:
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

<br>
used TargetZone to attack

<br>
<br>

5:
_uCount = math.random(1,10)
rgc.SpawnRGC(0, 1, 2, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

<br>
Random amount of units between 1 and 10.

<br>
<br>

6:
rgc.SpawnRGC(2, 2, 1, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')
Country: 2 (USA)
Coalition list of units: Blue
Target Coalition: 1 (Red)

<br>
("unitTypeRedTbl" and "unitTypeBlueTbl" in the scrit file reflect the coalition you are spawning)

