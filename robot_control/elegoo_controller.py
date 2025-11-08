import socket
import json
import time

class ElegooRobotController:
    def __init__(self, ip="192.168.4.1", port=100):
        self.ip = ip
        self.port = port
        self.sock = None
        self.command_id = 0
        
    def connect(self):
        """Connect to robot"""
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(5.0)
        # Set TCP_NODELAY for better responsiveness (like the app)
        self.sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        # Set SO_KEEPALIVE to maintain connection
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
        self.sock.connect((self.ip, self.port))
        return True
        
    def disconnect(self):
        """Disconnect from robot"""
        if self.sock:
            try:
                self.standby_mode()
            except:
                pass
            try:
                self.sock.close()
            except:
                pass
            self.sock = None
    
    def _send_command(self, cmd_dict):
        """Send JSON command to robot via socket"""
        if not self.sock:
            return False
        try:
            self.command_id += 1
            cmd_dict["H"] = str(self.command_id)
            #cmd_str = "{" + json.dumps(cmd_dict)[1:-1] + "}"
            cmd_str = json.dumps(cmd_dict)

            self.sock.sendall(cmd_str.encode('utf-8'))
            return True
        except (BrokenPipeError, OSError):
            return False
    
    def forward(self, speed=150, duration=None):
        """Move forward. Speed: 0-255. Duration in seconds"""
        if duration:
            return self._send_command({"N": 2, "D1": 3, "D2": speed, "T": int(duration * 1000)})
        return self._send_command({"N": 3, "D1": 3, "D2": speed})
    
    def backward(self, speed=150, duration=None):
        """Move backward"""
        if duration:
            return self._send_command({"N": 2, "D1": 4, "D2": speed, "T": int(duration * 1000)})
        return self._send_command({"N": 3, "D1": 4, "D2": speed})
    
    def turn_left(self, speed=150, duration=None):
        """Turn left (rotate)"""
        if duration:
            return self._send_command({"N": 2, "D1": 1, "D2": speed, "T": int(duration * 1000)})
        return self._send_command({"N": 3, "D1": 1, "D2": speed})
    
    def turn_right(self, speed=150, duration=None):
        """Turn right (rotate)"""
        if duration:
            return self._send_command({"N": 2, "D1": 2, "D2": speed, "T": int(duration * 1000)})
        return self._send_command({"N": 3, "D1": 2, "D2": speed})
    
    def stop(self):
        """Stop all movement"""
        return self._send_command({"N": 100})
    
    def turn_90_degrees(self, clockwise=True, speed=150):
        """Turn ~90 degrees. Calibrate timing for your robot."""
        duration = 1.0
        if clockwise:
            self.turn_right(speed, duration)
        else:
            self.turn_left(speed, duration)
        time.sleep(duration + 0.2)
    
    def line_tracking_mode(self, continuous=False, keep_alive_interval=2.0):
        """Follow black line automatically
        
        Args:
            continuous: If True, keeps resending to prevent 3-sec timeout
            keep_alive_interval: How often to resend (seconds, must be < 3)
        """
        if not continuous:
            return self._send_command({"N": 101, "D1": 1})
        else:
            # Keep resending to prevent blind detection timeout
            # Must resend before 3 seconds to prevent robot from stopping
            while True:
                result = self._send_command({"N": 101, "D1": 1})
                if not result:
                    print("⚠️ Connection lost, attempting to reconnect...")
                    try:
                        self.disconnect()
                        time.sleep(0.5)
                        self.connect()
                    except:
                        break
                time.sleep(keep_alive_interval)  # Send every 2 seconds
    
    def obstacle_avoidance_mode(self):
        """Avoid obstacles automatically"""
        return self._send_command({"N": 101, "D1": 2})
    
    def follow_mode(self):
        """Follow objects automatically"""
        return self._send_command({"N": 101, "D1": 3})
    
    def standby_mode(self):
        """Stop and enter standby"""
        return self._send_command({"N": 100})
    
    def __enter__(self):
        self.connect()
        return self
    
    def __exit__(self, *args):
        self.disconnect()
