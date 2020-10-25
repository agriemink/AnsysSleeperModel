!-----Solve -------------------------------------

!Delete some parameters that do not have to be in the parameter-file.
*DEL, AREA_0
PARSAV, ALL, 'CustomParameters', 'f'

/SOLU
ALLSEL

LSSOLVE, 1, LoadSteps, 1 !solve all the loadSteps
ALLSEL


