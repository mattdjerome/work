#!/usr/local/ec/bin/python3


import subprocess

print("Checking Command Line Tools for Xcode")
# Only run if the tools are not installed yet
# To check that try to print the SDK path
result = subprocess.run(['xcode-select', '-p'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if result.returncode != 0:
    print("Command Line Tools for Xcode not found. Installing from softwareupdate…")
    # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
    subprocess.run(['touch', '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'])
    output = subprocess.check_output(['softwareupdate', '-l'])
    prod_lines = [line for line in output.splitlines() if b'Command Line' in line]
    latest_prod = prod_lines[-1].split()[1].decode('utf-8')
    subprocess.run(['softwareupdate', '-i', latest_prod, '--verbose'])
else:
    print("Command Line Tools for Xcode have been installed.")


# Stopping the Falcon service
unload = subprocess.run(["/Applications/Falcon.app/Contents/Resources/falconctl", "unload"], stdout=subprocess.DEVNULL)
unload_code = unload.returncode
print(f"Unload Return Code is {unload_code}.")
#Checks the return code. If it's 0, stopped successfully. Continuing to start the service.
if unload_code != 0:
    print("Sensor Unload Failure")
else:
    print("Sensor Unload Successful")
    
    # Loads the sensor to restart the service.
load = subprocess.run(["/Applications/Falcon.app/Contents/Resources/falconctl", "load"], stdout=subprocess.DEVNULL)
load_code=load.returncode
print(f"Load Return Code is {load_code}.")
if load_code != 0:
    print("Sensor Load Failure")
else:
    print("Sensor Load Successful")
    
    
    #If the return code for unload or load is not zero, the sensor is broken, JAMF will reinstall the sensor to attempt to fix.
if load_code != 0 or unload_code != 0:
    print(f"The unload return code was {unload_code} and the load return was {load_code}. A 0 means the task was successful and a 1 means it failed. Either task returning a 1 will trigger a reinstall of the falcon sensor from Jamf.")
    print("uninstalling the agent")
    subprocess.run(["/Applications/Falcon.app/Contents/Resources/falconctl", "uninstall"], stdout=subprocess.DEVNULL)
    reinstall_falcon = subprocess.run(["jamf","policy","-trigger","reinstall_falcon"])
    reinstall_code = reinstall_falcon.returncode
    
    if reinstall_code != 0:
        print("Jamf reinstall of Falcon failed. Continue with manual falcon install. exiting.")
        exit(1)
    else:
        print("Falcon reinstall successful. Check the console to see if it's reporting.")
else:
    print("The unload and load both returned an exit code of 0, meaning both tasks succeeded. Check the console to see if it's reporting correctly. It could take up to an hour to report in.")
    
    #If it reaches here, everything went through successfully.
print("Process complete. Exiting.")
exit(0)