question limit_bash_history_to_specific_commands 'By default users can use the up and down arrow keys to see their command history. This can be replaced by a set of commands used frequently.' no
function limit_bash_history_to_specific_commands {

    bash_history_path="$USER_HOME/.bash_history"
    bash_profile_path="$USER_HOME/.bash_profile"
    
    add_conf "$bash_profile_path" 'HISTFILE=/dev/null'

    ## The bash history will be limited to these commands
    echo  'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -L 5901:localhost:5901 -N -f -l 
vinagre localhost:1
sudo mc' > "$bash_history_path"

    chmod 644 "$bash_history_path"
}