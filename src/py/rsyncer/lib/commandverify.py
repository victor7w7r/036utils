from subprocess import call, PIPE

def commandverify(cmd: str) -> bool:
    return call("type " + cmd, shell=True, stdout=PIPE, stderr=PIPE) == 0