import subprocess
import sys

def dump(url):
    try:
        return subprocess.Popen(['pg_dump', url], stdout=subprocess.PIPE)  #pg_dump parancs futtatása megadott paraméterrel (url) és eredmény továbbítása egy pipe-ra.
    except OSError as err:
        print(f"Error: {err}")
        sys.exit(1)