#!/usr/bin/env python3

import os
import signal
import subprocess
import time

import RPi.GPIO as GPIO

displayison = False
maxidle = int(os.environ.get("IDLE_SECONDS", "60"))
poll_seconds = float(os.environ.get("POLL_SECONDS", "5"))
pir_pin = int(os.environ.get("PIR_GPIO", "17"))
display = os.environ.get("DISPLAY", ":0")
lastsignaled = 0

running = True


def shutdown(signum, frame):
    global running
    running = False


def set_display(power_on):
    state = "on" if power_on else "off"
    env = {**os.environ, "DISPLAY": display}
    subprocess.run(
        ["xset", "dpms", "force", state],
        env=env,
        check=False,
    )


signal.signal(signal.SIGTERM, shutdown)
signal.signal(signal.SIGINT, shutdown)

GPIO.setmode(GPIO.BCM)
GPIO.setup(pir_pin, GPIO.IN)

try:
    while running:
        now = time.time()
        if GPIO.input(pir_pin):
            if not displayison:
                set_display(True)
                displayison = True
            lastsignaled = now
        elif now - lastsignaled > maxidle:
            if displayison:
                set_display(False)
                displayison = False
        time.sleep(poll_seconds)
finally:
    GPIO.cleanup()
