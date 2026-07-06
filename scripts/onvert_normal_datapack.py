import subprocess
convertToNormalDatapack = subprocess.run(["bash", "scripts/convert_normal_datapack.sh"], capture_output=True, text=True)
print("Converting...", convertToNormalDatapack.stdout)