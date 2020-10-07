Config = {}

-- 0 (Explode After Countdown) | 1 (Explode once the veh reaches a set speed) | 2 (Remote Detonate on Key Press) | 3 (Detonate after veh is entered and timer ends) |
-- 4 (Detonate Immediately After the vehicle is entered)
Config.DetonationType = 2

Config.UsingMythicNotifications = false -- false (Default ESX Notifications) | true (Mythic Notifications Enabled)

Config.TimeTakenToArm = 4 -- in seconds 

Config.TimeUntilDetonation = 10 -- in seconds

Config.TriggerKey = 47 -- If using type 2

Config.maxSpeed = 100 -- if using type 1

Config.Speed = 'MPH' -- if using type 2
