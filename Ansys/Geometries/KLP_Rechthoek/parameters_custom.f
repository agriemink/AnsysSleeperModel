
epsilon_ = 1/100000 !Must be much less than 1 mm [1/1000]

!Wapening
*IF, W_Diameter, LT, epsilon_, THEN
	W_Diameter = 25 / 1000 !25 mm
*ENDIF
W_Straal = W_Diameter / 2 !W_Diameter is always set


*IF, W_Dekking_y, LT, epsilon_, THEN
	W_Dekking_y = 14.5 / 1000 !Default from Lankhorst drawing.
*ENDIF

*IF, W_Dekking_x, LT, epsilon_, THEN
	W_Dekking_x = 13 / 1000 !Default from Lankhorst drawing.
*ENDIF

*IF, W_Halve_Lengte, LT, epsilon_, THEN
	W_Halve_Lengte = S_Lengte/2 - (75 / 1000) !wapening stopt iets voor het einde van de ligger.
*ENDIF


*DEL, epsilon_