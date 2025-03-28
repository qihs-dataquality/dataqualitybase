if [ "$1" = "next" -o "$1" = "devel" ] ; then
    echo "Applying C23 workaround"

    apt update && apt install software-properties-common -yy 
    add-apt-repository ppa:ubuntu-toolchain-r/test -y
    apt update
    apt install gcc-13 -yy 
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 20 
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 10 
    update-alternatives --set gcc /usr/bin/gcc-13 

    mkdir /root/.R
    echo "CC=gcc -std=c2x" > /root/.R/Makevars 
else
    echo "Skipping C23 workaround"
fi


