DROP PROCEDURE CPI.RI_COMM_PERIL;

CREATE OR REPLACE PROCEDURE CPI.ri_comm_peril(b_par_id IN NUMBER) IS
    v_subline_cd   GIPI_WPOLBAS.subline_cd%TYPE;
    v_iss_cd       GIPI_PARLIST.iss_cd%TYPE;
BEGIN
  /* Determine if the issue code is part of the 'RI'
  ** parameter or not by using the GIIS_PARAMETERS table.
  */
  FOR B1 IN (
     SELECT   iss_cd
       FROM   gipi_parlist
      WHERE   par_id  =  b_par_id
        AND   iss_cd IN (SELECT  PARAM_NAME
                           FROM  GIIS_PARAMETERS
                          WHERE  param_value_v = 'RI'
                            AND  LENGTH(param_name) = 2)) LOOP
    /* The Re-Insurance (RI) commission rate
    ** are to be fetched from the peril maintenance table;
    ** These information would be utilized to compute for the
    ** commission amount needed for each peril.
    ** Created by   : Daphne
    */
    FOR A1 IN (
      SELECT    NVL(a.ri_comm_rate,NVL(b.ri_comm_rt,0)) ri_comm_rt,
               (NVL(a.ri_comm_rate,NVL(b.ri_comm_rt,0))/100) * NVL(a.prem_amt,0)
                  ri_comm_amt,
                a.peril_cd    peril_cd,
                a.item_no     item_no
        FROM    gipi_witmperl a,
                giis_peril b,
                gipi_parlist c
       WHERE    a.par_id       =  b_par_id
         AND    a.peril_cd     =  b.peril_cd
         AND    a.par_id       =  c.par_id
         AND    b.line_cd      =  c.line_cd
         AND    c.iss_cd       =  b1.iss_cd) LOOP
       /* Will now update the perils with respect to the
       ** perils fetched from the first statement.
       */
       UPDATE    gipi_witmperl
          SET    ri_comm_amt  =  A1.ri_comm_amt,
                 ri_comm_rate =  A1.ri_comm_rt
        WHERE    par_id       =  b_par_id
          AND    item_no      =  A1.item_no
          AND    peril_cd     =  A1.peril_cd;
   END LOOP;
  END LOOP;
END;
/


