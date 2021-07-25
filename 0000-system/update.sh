question run_update 'Run a DNF update to update all packages?' yes
function run_update {
    run dnf -y update
}