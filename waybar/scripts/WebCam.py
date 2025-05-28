import sys
import subprocess
import json
import time

def main():
    while(True):
        try:
            result = subprocess.run("lsmod | grep -q uvcvideo", capture_output=True, check=False, shell=True)
            status_text = ""
            if result.returncode == 0:
                status_text = "󰄀  On"
            else:
                status_text = "󰗟  Off"

            output = {
                "text": status_text,
                "tooltip": "Webcam Status: " + status_text # Optional: Add a tooltip
                }
        except Exception as e:
            output = {
                "text": "Error...",
                "tooltip": f"Error: {e}"
                }

        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()
        time.sleep(5)

if __name__ == "__main__":
    main()
