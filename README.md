# Minecraft Systemd files

### Description
These files can be used to run multiple minecraft servers as services using systemd. Each servers' console is tied to seperate TTYs for sending commands.

The systemd service names are in the format minecraft@instanceName.service; Some examples are minecraft@vanilla.service, minecraft@modded.service, minecraft@paper.service, etc. Each servers' files must be located in seperate subdirectories in `/home/minecraft` with the same instance names as the service names; The respective paths for the previous examples are `/home/minecraft/vanilla`, `/home/minecraft/modded`, and `/home/minecraft/paper`.

The services must be ran as the user "minecraft".  This user's home directory should be /home/minecraft.  All the server files should be kept inside this directory.

### Setting up the user "minecraft"
Since we don't want to run the servers as root, the servers are run under the restricted user "minecraft". We can create the user and group "minecraft" with password "password" and home directory "minecraft" with the command:

`sudo adduser minecraft minecraft -m minecraft -p password`

In order for the user to maintain the servers, we need to give specific sudo permissions by copying the `minecraft` file into `/etc/sudoers.d`

### Setting up the systemd service
Setting up the systemd services requires adding the minecraft@instanceName.service file into `/etc/systemd/system`. There needs to be one service file for each minecraft server. Make sure to rename the service file to match the instance name in `/home/minecraft`. The "TTYPath" option in the service files also needs to be changed to whatever tty you want to run the server in. By default, it is set to run in `/dev/tty2`. Multiple servers cannot share the same tty. Execute `sudo systemctl daemon-reload` to save changes to systemd.

### Basic Usage Example - Vanilla Server
1. Switch to the minecraft user by running `su minecraft`. Create a folder for the server files at `/home/minecraft/vanilla`.
1. Place the server jar, start.sh, and console.sh files into `/home/minecraft/vanilla`. If the server jar file is not named "server.jar", it will fail to start. Either rename it to "server.jar" or see the configuration section on how to use a different jar name.
1. Place the systemd service file into `/etc/systemd/system`. Rename the file accordingly and change the "TTYPath" to an unused TTY.
1. To start the server, run `./start.sh`.
1. To interact with the server console, run `./console.sh`. Ensure that the "conspy" tool is installed before running "console.sh". To exit the tty, press the ESC key 3 times.
1. To stop the server gracefully, enter the "stop" command into the server console. If the server is stopped using `systemctl stop minecraft@instanceName.service`, the server will abruptly stop without saving.

### Configuration

Besides setting the TTYPath, the systemd files do not need to be edited directly. Each servers' settings can be configured by adding the "systemd.conf" file into each servers' respective directory. For the example above, this would be at `/home/minecraft/vanilla/systemd.conf`.

These are the possible options:
- JAVA_PARAMETERS - These are jvm arguments that the server will start with.
- JAR_PATH - This is the path/name of the jar file for the server. This is relative to the server's directory.
