# DCS-RGC
Random Ground Convoy for DCS (Digital Combat Simulator)

- How to install

In the Mission editor add the script in to the mission as a file with condition "time more" after MIST is loaded or use the do script to read the script from a file location after MIST is loaded.

Example File location with Do script:<br>
assert(loadfile("D:\\my scripts\\DCS-RGC\\dcs-rgc.lua"))()
<br>
<br>
- How to use

Syntax:<br>
string
rgc.SpawnRGC(number CountryID,number SpawnCoalition ,number CoalitonIDToAttack ,number GroupSize ,string Skill, number Speed ,string SpawnZoneName (Or Nil),
number SpawnAirbaseID (or Nil), number TargetAirbaseId (or Nil),string TriggerZone Name (or no value) )
<br>
<br>

Examples:
<br>
<br>

1:<br>
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , nil, 19)

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

2:<br>
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , 'TestSpawnZone')
<br>
<br>
Spawnzone used, if no more arguments are used, SpawnAirbaseID does not need to be filled out. Has to be Nil if more are used.

<br>
<br>

3:<br>
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , 'TestSpawnZone', nil, 10)
<br>
<br>
Used target Airbase 10

<br>
<br>

4:<br>
rgc.SpawnRGC(0, 1, 2, 10, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')
<br>
<br>
used TargetZone to attack

<br>
<br>

5:<br>
_uCount = math.random(1,10)
<br>
rgc.SpawnRGC(0, 1, 2, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

<br>
<br>
Random amount of units between 1 and 10.

<br>
<br>

6:<br>
rgc.SpawnRGC(2, 2, 1, _uCount, 'Average', 10 , nil , 9, nil, 'TargetTriggerZone')
<br>
Country: 2 (USA)<br>
Coalition list of units: Blue<br>
Target Coalition: 1 (Red)<br>

<br>
("unitTypeRedTbl" and "unitTypeBlueTbl" in the scrit file reflect the coalition you are spawning)

