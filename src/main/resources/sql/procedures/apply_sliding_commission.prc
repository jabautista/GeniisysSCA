DROP PROCEDURE CPI.APPLY_SLIDING_COMMISSION;

CREATE OR REPLACE PROCEDURE CPI.APPLY_SLIDING_COMMISSION
/* modified - bmq - 8/12/2011 */ 
    (   v_sliding_comm    IN OUT VARCHAR2,
        v_rate                  IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
        p_line_cd             GIIS_LINE.line_cd%TYPE,
        p_subline_cd        GIIS_SUBLINE.subline_cd%TYPE,
        p_par_id              GIPI_WITMPERL.par_id%TYPE,
        p_peril_cd            GIPI_WITMPERL.peril_cd%TYPE
    )   IS

        v_prem_rt      GIPI_WITMPERL.prem_rt%TYPE;
        v_default_rt   GIIS_PERIL.default_rate%TYPE;
   
BEGIN

    SELECT DISTINCT NVL(A.default_rate,0), NVL(b.prem_rt,0) -- belle 12.03.2012 add distinct 
            INTO v_default_rt, v_prem_rt
        FROM GIIS_PERIL a, GIPI_WITMPERL b
       WHERE A.peril_cd = b.peril_cd
         AND    A.line_cd = b.line_cd       -- bmq - added
         AND    A.line_cd = p_line_cd
         AND    A.peril_cd = p_peril_cd
         AND    b.par_id = p_par_id;

    v_sliding_comm := 'Y';      -- bmq - set default value for v_sliding_comm
/* 
  IF v_default_rt = v_prem_rt THEN
     v_sliding_comm := 'Y';
  ELSE  
     v_sliding_comm := 'N';
     v_rate := NULL;
  -- bmq put into comment */
  IF v_default_rt <> v_prem_rt THEN    -- bmq
     
     FOR COM IN (SELECT  NVL(A.hi_prem_lim,0) prem_rt_high
                            , NVL(A.lo_prem_lim,0) prem_rt_low
                            , NVL(A.slid_comm_rt,0) comm_rate
                                FROM  giis_slid_comm A  
                        WHERE  A.line_cd        = p_line_cd
                               AND  A.subline_cd   = p_subline_cd
                            AND  A.peril_cd       = p_peril_cd
                            AND hi_prem_lim    >= v_prem_rt         -- bmq added filter on rate 
                            AND lo_prem_lim    <= v_prem_rt
                            ) 
    LOOP
        v_rate := com.comm_rate;
        v_sliding_comm  := 'N';
    
        /* bmq
      IF v_prem_rt BETWEEN com.prem_rt_low AND com.prem_high THEN
         v_rate := com.comm_rate;
      END IF;
      */                 
      END LOOP;
   END IF;
END;
/


