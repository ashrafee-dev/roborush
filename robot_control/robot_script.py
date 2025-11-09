from elegoo_controller import ElegooRobotController
import time
import sys
import json
raw = sys.stdin.read()
data = json.loads(raw) 
location = data.get("location").lower()


def main():

    print("Connecting to robot...")
    with ElegooRobotController() as robot:

        if location == "davis":
            pass
        elif location == "capen":
            robot.forward(speed=80, duration=1.0)
            time.sleep(2.5)
        elif location == "knox":
            robot.forward(speed=80, duration=3.0)
            time.sleep(2.5)
        elif location == "clemens":
            robot.forward(speed=150, duration=5.0)
            time.sleep(2.5)
        else:
            sys.exit("invalid location")

    #robot.turn_90_degrees(clockwise=True)
    
    try:
        robot.line_tracking_mode(continuous=True, keep_alive_interval=0.05)
    except KeyboardInterrupt:
        print("\n\nStopping robot...")
        robot.stop()

print("Done!")

if __name__ == "__main__":
    main()
