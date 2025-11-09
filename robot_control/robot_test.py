from elegoo_controller import ElegooRobotController
import time
import sys
import json
#raw = sys.stdin.read()
#data = json.loads(raw) 
#ocation = data.get("location").lower()


def main():

    print("Connecting to robot...")
    with ElegooRobotController() as robot:
        robot.forward(speed=150, duration=3.0)
        time.sleep(2.5)

print("Done!")

if __name__ == "__main__":
    main()
