!----------------------------------------------------------------------
!-------Analisys settings ---------------------------------------------
!----------------------------------------------------------------------

ANTYPE,2 ! 2 = modal

Modes = 25

LoadSteps = 1 !Make sure to do only one simulation.

MODOPT,LANB,Modes  
EQSLV,SPAR  
MXPAND,Modes, , ,1 
LUMPM,0 
PSTRES,0

MODOPT,LANB,Modes,0,0, ,OFF


NCNV,1,0,0,18000,0 !Stop simulation after x seconds

/NOPR   
KEYW,PR_SET,1   
KEYW,PR_STRUC,1 
KEYW,PR_THERM,0 
KEYW,PR_FLUID,0 
KEYW,PR_ELMAG,0 
KEYW,MAGNOD,0   
KEYW,MAGEDG,0   
KEYW,MAGHFE,0   
KEYW,MAGELC,0   
KEYW,PR_MULTI,0 
/GO 



TREF,  0.00000000
IRLF,  0
BFUNIF,TEMP,_TINY
ACEL,  0.00000000    ,  0.00000000    ,  0.00000000
OMEGA,  0.00000000    ,  0.00000000    ,  0.00000000
DOMEGA,  0.00000000    ,  0.00000000    ,  0.00000000
CGLOC,  0.00000000    ,  0.00000000    ,  0.00000000
CGOMEGA,  0.00000000    ,  0.00000000    ,  0.00000000
DCGOMG,  0.00000000    ,  0.00000000    ,  0.00000000

DELTIM, 0.500000000    , 0.200000000    , 0.500000000    , !Timesteps
KUSE,     0
ALPHAD,  0.00000000
BETAD,  0.00000000
DMPRAT,  0.00000000
DMPSTR,  0.00000000

CRPLIM, 0.100000000    ,   0
CRPLIM,  0.00000000    ,   1
NCNV,     1,  0.00000000    ,     0,  0.00000000    ,  0.00000000

NEQIT,     0

ERESX,DEFA