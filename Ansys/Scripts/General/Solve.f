!-----Solve -------------------------------------
ALLSEL
!Save all parameters to be able to check them afterwards
PARSAV, ALL, 'CustomParameters', 'f'

/SOLU
ALLSEL

LSSOLVE, 1, LoadSteps, 1 !solve all the loadSteps
ALLSEL


