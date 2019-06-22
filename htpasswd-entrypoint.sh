#!/bin/ash

# If htpasswd file path is not set already, set it to something.
if [ -z "$REGISTRY_AUTH_HTPASSWD_PATH" ]; then
    export REGISTRY_AUTH_HTPASSWD_PATH=/etc/docker/registry/htpasswd
fi

# It probably does not exist, create it now.
touch "$REGISTRY_AUTH_HTPASSWD_PATH"

# Function to add a username and password to the htpasswd file.
add_user() {
    if [ -n "$1" ] && [ -n "$2" ] ; then
        # Docker registry needs bcrypt, use -B flag.
        htpasswd -B -b "$REGISTRY_AUTH_HTPASSWD_PATH" "$1" "$2"
    fi
}

# Add some users, if they are defined.
add_user "$HTPASSWD_0_USER" "$HTPASSWD_0_PASS"
add_user "$HTPASSWD_1_USER" "$HTPASSWD_1_PASS"
add_user "$HTPASSWD_2_USER" "$HTPASSWD_2_PASS"
add_user "$HTPASSWD_3_USER" "$HTPASSWD_3_PASS"
add_user "$HTPASSWD_4_USER" "$HTPASSWD_4_PASS"

# Run the usual Docker registry entrypoint.
exec /entrypoint.sh "$@"
