from elegoo_controller import ElegooRobotController
import time

print("Connecting to robot...")
with ElegooRobotController() as robot:
    print("Moving forward 2 seconds...")
    robot.forward(speed=80, duration=1.0)
    time.sleep(2.5)
    
  
    #robot.turn_90_degrees(clockwise=True)
    
    
    try:
        robot.line_tracking_mode(continuous=True, keep_alive_interval=0.05)
    except KeyboardInterrupt:
        print("\n\nStopping robot...")
        robot.stop()

print("Done!")
