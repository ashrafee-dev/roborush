from elegoo_controller import ElegooRobotController
import time


def main():
    raw = sys.stdin.read()
    data = json.loads(raw) 
    location = data.get(location).lower()



print("Connecting to robot...")
with ElegooRobotController() as robot:

    if location == "knox":
        robot.forward(speed=80, duration=1.0)
        time.sleep(2.5)
    elif location == "davis":
        robot.forward(speed=80, duration=3.0)
        time.sleep(2.5)
    elif location == "capen":
        robot.forward(speed=80, duration=5.0)
        time.sleep(2.5)
    elif location == "clemens":
        robot.forward(speed=80, duration=7.0)
        time.sleep(2.5)
    elif location == "park":
        robot.forward(speed=80, duration=9.0)
        time.sleep(2.5)
    elif location == "lockwood":
        robot.forward(speed=80, duration=11.0)
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
