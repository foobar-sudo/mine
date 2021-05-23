#!/bin/bash
link="https://raw.githubusercontent.com/foobar-sudo/mine/main"
files=(".bash_profile" ".bashrc")

for i in ${files[@]}; do
{
sudo -u ${ARCH_USERNAME} curl "${link}/${i}" --output /home/${ARCH_USERNAME}/${i}
}; done
