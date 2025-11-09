# RoboRush 🤖🍕

A food delivery system that uses an Elegoo robot to autonomously deliver orders across campus.

## Overview

RoboRush combines a Django web interface with an Elegoo robot controller to create an automated food delivery system. Users place orders through the website, and the robot navigates to their location using line-tracking technology.

## Features

- **Robot Control**: Automated delivery using an Elegoo smart robot car
- **Campus Locations**: Delivers to multiple campus buildings (Knox, Davis, Capen, Clemens, Park, Lockwood)
- **Line Tracking**: Robot follows designated paths autonomously

## Project Structure

```
roborush/
├── robot_control/          # Elegoo robot controller and scripts
│   ├── elegoo_controller.py
│   └── robot_script.py
└── website/                # Django web application
    ├── foodRobot/          # Main Django project
    └── main/               # Main app with ordering interface
```

## Setup

### Website
```bash
cd website
python manage.py runserver
```

### Robot Control
Configure the robot IP address (default: 192.168.4.1) in `elegoo_controller.py` and run:
```bash
python robot_script.py
```

## Technologies

- **Backend**: Django (Python)
- **Robot**: Elegoo Smart Robot Car
- **Communication**: Socket connection over TCP/IP
- **Navigation**: Line tracking sensors

---

Built for automated campus food delivery 🚀


