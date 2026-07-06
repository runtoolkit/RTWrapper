cd datapack/RTWrapper-Datapack/data
sudo rm -rf runtoolkit/function
sudo rm -rf rtwrapper/function/tests
sudo sed -i '/scoreboard objectives add rtw.test dummy/d' rtwrapper/function/core/load.mcfunction
exit 0