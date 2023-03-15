# Minecraft Systemd files

### Description
These files can be used to run multiple minecraft servers as services using systemd. Each servers' console is tied to seperate TTYs for sending commands.

The systemd service names are in the format minecraft@instanceName.service; Some examples are minecraft@vanilla.service, minecraft@modded.service, minecraft@paper.service, etc. Each servers' files must be located in seperate subdirectories in `/home/minecraft` with the same names as the service names; The respective paths for the previous examples are `/home/minecraft/vanilla`, `/home/minecraft/modded`, and `/home/minecraft/paper`.

The services must be ran as the user "minecraft".  This user's home directory should be /home/minecraft.  All the server files should be kept inside this directory.

### Setting up the user "minecraft"
Since we don't want to run the servers as root, the servers are run under the restricted user "minecraft". We can create the user and group minecraft with password "password" and home directory "minecraft" with the command:

`sudo adduser minecraft minecraft -m minecraft -p password`

In order for the user to maintain the servers, we need to give specific sudo permissions by copying `minecraft.sudoers` into `/etc/sudoers.d`

### Setting up the systemd service
Setting up the systemd services simply involves adding the minecraft@instanceName.service file into /etc/systemd/system. Make sure to rename the service file to match the server's directory name in `/home/minecraft`. The "TTYPath" option in the service files also needs to be changed to whatever tty you want to run the server in. The same tty number should be set in the `console.sh` file. Multiple servers cannot share the same tty. Execute `sudo systemctl daemon-reload` so systemd recognizes the service files.

### Basic Usage Example - Vanilla Server
1. As the user "minecraft", create a folder for the server files at `/home/minecraft/vanilla`.
1. Place the server jar, start.sh, and console.sh files into `/home/minecraft/vanilla`. If the server jar file is not named "server.jar", it will fail to start. Either rename it to "server.jar" or see the configuration section on how to use a different jar name.
1. To start the server, run `./start.sh`.
1. To interact with the server console, run `./console.sh`. Ensure the tty number in `console.sh` is the same as in the service file. To exit the tty, press the ESC key 3 times. Also ensure that the "conspy" tool is installed.
1. To stop the server gracefully, enter the "stop" command into the server console.

### Configuration

Besides setting the TTYPath, the systemd files do not need to be edited directly. Each servers' settings can be configured by adding a file named "systemd.conf" into each servers' respective directory. For the example above, this would be at `/home/minecraft/vanilla/systemd.conf`.

These are the possible options:
- MIN_MEM - This is the minimum server memory. It is the same as the -Xms jvm argument
- MAX_MEM - This is the maximum server memory. It is the same as the -xmx jvm argument
- JAVA_PARAMETERS - These are any other jvm arguments.
- JAR_PATH - This is the path/name of the jar file for the server. This is relative to the server's directory.
