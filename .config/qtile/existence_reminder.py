import time, subprocess, pathlib

def tick():
    unixtime = int(time.time())
    localtime_tuple = time.localtime(unixtime)

    if localtime_tuple.tm_sec == 0 and localtime_tuple.tm_min == 0:
        subprocess.Popen("mpv --no-config --volume=75 --no-video {}/ac-bell/10spedup.flac".format(pathlib.Path(__file__).parent.absolute()).split(), stdout=subprocess.DEVNULL)

    return localtime_tuple.tm_sec
