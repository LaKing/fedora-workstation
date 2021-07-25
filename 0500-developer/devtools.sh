question install_devtools "Software development tools are for programmers and hackers. " no
function install_devtools {

    ## TODO make it more complete

    # The generic Development tools compilation from fedora.
    run 'dnf -y groupinstall "Development Tools"'

    # some more enviroments
    run dnf -y install eclipse
    run dnf -y install geany
    run dnf -y install anjuta

    # Networking development
    run dnf -y install wireshark

    # some tools for ruby programming
    run dnf -y install rubygem-sinatra rubygem-shotgun rubygem-rails rubygem-passenger

    # For local web development. Apache and stuff.
    run dnf -y install httpd 
    run dnf -y install phpMyAdmin 
    run dnf -y install nginx 
    run dnf -y install nodejs
    run dnf -y install npm
    run dnf -y install ShellCheck
    
    # compilers
    run dnf -y install gcc-c++

}