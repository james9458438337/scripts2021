#!/bin/bash

#install python3 

pip install jdcloud_cli

# auto completion
echo 'eval "$(register-python-argcomplete jdc)"' >> .bashrc
echo 'export COLUMNS=100' >> .bashrc
source ~/.bashrc


jdc configure add --profile default --access-key JDC_96B973862E845E11898197936A66 --secret-key DE60FBBEF613739C44F77B5235BF7DA0