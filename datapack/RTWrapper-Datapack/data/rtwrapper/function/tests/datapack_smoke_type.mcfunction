# Smoke test for the {type:"..."} alias path used by handler/proc.
scoreboard objectives add rtw.test dummy
scoreboard players set #smoke_type rtw.test 0
data modify storage rtwrapper:api request set value {type:"scoreboard",params:{category:"players",action:"set",subject:"#smoke_type",objective:"rtw.test",value:"1"}}
function rtwrapper:api/run
execute unless score #smoke_type rtw.test matches 1 run return fail
return 1
