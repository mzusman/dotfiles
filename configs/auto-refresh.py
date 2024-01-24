import os
import time
import sys

if __name__ == "__main__":
    while True:
        os.system("zsh -c 'source ~/.zshrc; pod asd; wjobs asd; wpod2 asd'")
        print("Sleeping for " + (sys.argv[1]) + " seconds")
        time.sleep(int(sys.argv[1]))
