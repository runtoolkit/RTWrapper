rm -f -rf datapack/RTWrapper-Datapack/data/runtoolkit/function
rm -f -rf datapack/RTWrapper-Datapack/data/rtwrapper/function/tests
sed -i '/scoreboard objectives add rtw.test dummy/d' datapack/RTWrapper-Datapack/data/rtwrapper/function/core/load.mcfunction