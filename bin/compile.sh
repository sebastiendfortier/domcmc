#!/bin/bash

#compile script


###Dans l'ordre:
. ssmuse-sh -x comm/eccc/all/opt/intelcomp/intelpsxe-cluster-19.0.3.199
. r.load.dot rpn/code-tools/1.5.0
. r.load.dot rpn/libs/19.6.0

s.compile -src winds.F90 -librmn -shared -o wind_rotation.so

