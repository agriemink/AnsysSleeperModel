/prep7
*set,test
*dim,test,array,4,4
test(1,1)=1,2,3,4
test(1,2)=1,2,3,4
test(1,3)=1,2,3,4
test(1,4)=1,2,3,4

/output,test,txt,,append
*mwrite,test(1,1),,,,ijk,
(4f6.0)
/output