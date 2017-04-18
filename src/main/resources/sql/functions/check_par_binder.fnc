DROP FUNCTION CPI.CHECK_PAR_BINDER;

CREATE OR REPLACE FUNCTION CPI.CHECK_PAR_BINDER (p_par_id IN GIUW_POL_DIST.PAR_ID%TYPE) RETURN VARCHAR2 IS
    v_exists VARCHAR2(1) := 'N';
/*Created by : Gelo
**Date       : 11/23/2012
**Description: Check if the par has posted binder/s.*/
BEGIN
    FOR c1 IN (SELECT A.DIST_NO
             FROM GIUW_POL_DIST A,
                  GIRI_DISTFRPS B,
                  GIRI_FRPS_RI C,
                  GIRI_BINDER D
             WHERE 1=1
             AND A.PAR_ID = p_par_id
             AND A.DIST_NO = B.DIST_NO
             AND B.LINE_CD = C.LINE_CD
             AND B.FRPS_YY = C.FRPS_YY
             AND B.FRPS_SEQ_NO = C.FRPS_SEQ_NO
             AND C.FNL_BINDER_ID = D.FNL_BINDER_ID)
         LOOP
                v_exists := 'Y';
         END LOOP;
RETURN(v_exists);
EXCEPTION
WHEN NO_DATA_FOUND THEN
 v_exists := 'N';             
END CHECK_PAR_BINDER;
/


