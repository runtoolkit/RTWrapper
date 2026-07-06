# Smoke test used by Fabric GameTest and manual validation.
scoreboard objectives add rtw.test dummy
scoreboard players set #smoke rtw.test 0
data modify storage rtwrapper:api request set value {cmd:"scoreboard",params:{category:"players",action:"set",subject:"#smoke",objective:"rtw.test",value:"1"}}
function rtwrapper:api/run
execute unless score #smoke rtw.test matches 1 run return fail
return 1
