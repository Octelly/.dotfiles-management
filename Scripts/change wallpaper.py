import psutil
import sys

cpu_usage = psutil.cpu_percent(interval=1) # interval is set to 1 second, otherwise the function returns cpu usage since module load which is 0.0

print('CPU: {}'.format(cpu_usage))

if cpu_usage > 50:
    sys.exit()

import subprocess
from os import listdir
from os.path import isfile, join
import random

#CONFIGURAION
wallPath = '/home/ocean/Wallpapers/32-9/'

#CONFIGURATION LOG
print('wallPath is "{}"'.format(wallPath))

result = subprocess.run('gsettings get org.gnome.desktop.background picture-uri'.split(), stdout=subprocess.PIPE)
currentWall = result.stdout.decode('utf-8')[8:-2]

availableWalls = [f for f in listdir(wallPath) if isfile(join(wallPath, f))]

wallSet = False
while wallSet == False: 
	#select a random wallpaper from list of available wallpapers
	randomWall = availableWalls[random.randint(0,len(availableWalls)-1)]
	
	#if the selected wallpaper isn't the current one
	if not currentWall.endswith(randomWall):
		path = '"file://{}"'.format(wallPath + randomWall)
		command = 'gsettings set org.gnome.desktop.background picture-uri'.split() + [path]

		a = subprocess.run(command)
		print('Changed wallpaper to {}'.format(path))
		print('STDOUT:', a.stdout)
		print('STDERR:', a.stderr)
		wallSet = True
