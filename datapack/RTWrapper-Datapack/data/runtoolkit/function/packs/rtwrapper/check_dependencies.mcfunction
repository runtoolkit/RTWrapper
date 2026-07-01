# RTWrapper dependency check.
# Hard dependency for selector-string helpers: StringLib by CMDred.
data modify storage runtoolkit:runtime missing_dependencies set value []
scoreboard players set #dependency_errors rtk.status 0
scoreboard players set rtwrapper rtk.loaded 0

scoreboard players set stringlib rtk.registered 1
scoreboard players set stringlib rtk.enabled 0
data modify storage stringlib:input find set value {String:"@p",Find:"@",n:1}
execute store success score stringlib rtk.enabled run function stringlib:util/find
execute if score stringlib rtk.enabled matches 1.. run data modify storage runtoolkit:registry packs.stringlib set value {id:"stringlib",name:"StringLib",namespace:"stringlib",kind:"dependency",source:"https://github.com/CMDred/StringLib",provided_by:"CMDred",status:"detected"}
execute unless score stringlib rtk.enabled matches 1.. run scoreboard players add #dependency_errors rtk.status 1
execute unless score stringlib rtk.enabled matches 1.. run data modify storage runtoolkit:runtime missing_dependencies append value "stringlib"
