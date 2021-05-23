#!/bin/bash
echo "Welcome to my install script!"
echo "Do you want to continue?"
select i in Yes No; do
case $i in
Yes)
echo "You've chosen YES. Continuing..."
break;;
No)
echo "You've chosen NO"
exit;;
esac
done
echo "Sourcing env..."
source ./env

echo "Preparing for chrooting..."
ls PRE-*.sh | while read line; do { echo "Executing $line..."; bash $line; }; done

echo "Copying chroot scripts to chroot..."
ls INSTALL-*.sh | while read line; do { echo "Copying $line..."; sudo cp $line ${ARCH_DOWNLOADDIR}; }; done

echo "Chrooting and executing scripts..."
cat << "EOF" | sudo -E chroot ${ARCH_DOWNLOADDIR} /bin/bash
ls INSTALL-*.sh | while read line; do { echo "Executing $line..."; bash "./$line"; }; done
/bin/bash
EOF
