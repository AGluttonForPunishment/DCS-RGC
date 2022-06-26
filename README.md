# DCS-RGC
Random Ground Convoy for DCS (Digital Combat Simulator)

- How to install



- How to use

Syntax:
string
rgc.SpawnRGC(number CountryID ,number CoalitonIDToAttack ,number GroupSize ,string Skill, number Speed ,string SpawnZoneName (Or Nil),
number SpawnAirbaseID (or Nil), number TargetAirbaseId (or Nil),string TriggerZone Name (or no value) )


Examples:

1: rgc.SpawnRGC(0, 2,10, 'Average', 10 , nil, 19)

Country: Russia
Target Coalition: 2 (Blue)
Group size : 10 (units)
Skill of units: Avarage
Driving Speed of units: 10
SpawnZone not used : nil (must be nil if not used)
Spawn at Airbase ID : 19 (SpawnZone or SpawnAirbaseID must be used)


2: rgc.SpawnRGC(0, 2,10, 'Average', 10 , 'TestSpawnZone')

Spawnzone used, if no more arguments are used, SpawnAirbaseID does not need to be filled out. Has to be Nil if more are used.


3: rgc.SpawnRGC(0, 2,10, 'Average', 10 , 'TestSpawnZone', nil, 10)

Used target Airbase 10


4: rgc.SpawnRGC(0, 2,10, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

used TargetZone to attack


5:
_uCount = math.random(1,10)
rgc.SpawnRGC(0, 2, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')

Random amount of units between 1 and 10.

6:
rgc.SpawnRGC(2, 1, _uCount, 'Average', 10 , nil , 9, nil 'TargetTriggerZone')
Country: 2 (USA)
Target Coalition: 1 (Red)
(If you use this then you should change out the unit "unitTypeTbl" to reflect the contry you are spawning)

