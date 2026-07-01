# Condition object forms:
# {type:"predicate",id:"my_pack:my_predicate"}
# {type:"score",name:"#foo",objective:"myScore",value:"1"}
# {type:"score",name:"#foo",score:"myScore",value:"1"}
execute unless data storage rtwrapper:runtime condition.current.type run scoreboard players set #conditions rtw.temp 0
execute if data storage rtwrapper:runtime condition.current{type:"predicate"} unless data storage rtwrapper:runtime condition.current.id run scoreboard players set #conditions rtw.temp 0
execute if data storage rtwrapper:runtime condition.current{type:"predicate"} if data storage rtwrapper:runtime condition.current.id run function rtwrapper:condition/predicate with storage rtwrapper:runtime condition.current
execute if data storage rtwrapper:runtime condition.current{type:"score"} unless data storage rtwrapper:runtime condition.current.name run scoreboard players set #conditions rtw.temp 0
execute if data storage rtwrapper:runtime condition.current{type:"score"} unless data storage rtwrapper:runtime condition.current.value run scoreboard players set #conditions rtw.temp 0
execute if data storage rtwrapper:runtime condition.current{type:"score"} if data storage rtwrapper:runtime condition.current.objective run function rtwrapper:condition/score_objective with storage rtwrapper:runtime condition.current
execute if data storage rtwrapper:runtime condition.current{type:"score"} unless data storage rtwrapper:runtime condition.current.objective if data storage rtwrapper:runtime condition.current.score run function rtwrapper:condition/score_alias with storage rtwrapper:runtime condition.current
execute unless data storage rtwrapper:runtime condition.current{type:"predicate"} unless data storage rtwrapper:runtime condition.current{type:"score"} run scoreboard players set #conditions rtw.temp 0
data remove storage rtwrapper:runtime condition.current
