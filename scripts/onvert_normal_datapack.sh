sudo rm -rf datapack/RTWrapper-Datapack/data/runtoolkit/function
sudo rm -rf datapack/RTWrapper-Datapack/data/rtwrapper/function/tests
sudo sed -i '/scoreboard objectives add rtw.test dummy/d' datapack/RTWrapper-Datapack/data/rtwrapper/function/core/load.mcfunction