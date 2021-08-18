#1/bin/bash
CONFIG="$1"
COMMAND="$2"

if [ $# -ne 2 ]
then
    printf "\e[31mERROR: $0 requires two parameters {virtual-host} {restart|reload}\n"
    exit 1
fi

# check if virtual-host file exists
APPEND_PATH=/etc/apache2/sites-available/
if [ -f "$APPEND_PATH$CONFIG" ]
then
    # only allow reload or restart.
    if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
    then
        # Move the current execution state to the proper directory
        cd /etc/apache2/sites-available

        # Disable a vhost configuration
        sudo a2dissite "$CONFIG"
        sudo service apache2 "$COMMAND"

        # Enable a vhost configuration
        sudo a2ensite "$CONFIG"
        sudo service apache2 "$COMMAND"
    else
        printf "\e[31mERROR: $COMMAND is an invalid service command {restart|reload}\n"
        exit 1
    fi
else
    printf "\e[31mERROR: $CONFIG is an invalid virtual-host file, please use one listed below:\e[0m\n"
    # List all of the configuration files in the _/etc/apache2/sites-available/_ directory
    VHOSTS_PATH=/etc/apache2/sites-available/*.conf

    for FILENAME in $VHOSTS_PATH
    do
    echo $FILENAME
    done
    exit 1
fi