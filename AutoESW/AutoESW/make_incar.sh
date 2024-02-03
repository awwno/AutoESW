#!/bin/bash

echo "SYSTEM = neu
PREC = Accurate
KPAR = 2
NCORE = 16

ALGO = Normal
ISMEAR = 0
SIGMA = 0.05
ISPIN = 2
NELM = 300
EDIFF = 1e-7
ENCUT = 500

IBRION = 2
NSW = 150
EDIFFG = 1e-3
!NFREE = 2 !vibration
!POTIM = 0.5

LWAVE = T
LCHARG = F

!LORBIT = 11 !density of states
!ICHARG = 11 !density of states
!NEDOS = 1000 !density of states

!LSOL = T !solvation
!EB_K = 20 !solvation
!!EPSILON = 20 !solvation

!NELECT = 40 !electron d/a" > INCAR
