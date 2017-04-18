DROP FUNCTION CPI.GET_BOND_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.GET_BOND_SEQ_NO
/** VJP 09262011
***  TPISC SPECIFIC ENHANCEMENT
**/
    (p_line_cd        gipi_polbasic.line_cd%TYPE,
     p_subline_cd    gipi_polbasic.subline_Cd%TYPE,
     p_par_id       gipi_parlist.par_id%TYPE)
   RETURN NUMBER
IS
  v_bond_seq gipi_wpolbas.bond_seq_no%TYPE :=0;
BEGIN
    BEGIN
                SELECT MIN(SEQ_NO)
                  INTO v_bond_seq
                  FROM GIPI_BOND_SEQ_HIST
                 WHERE LINE_CD = p_line_cd
                   AND SUBLINE_CD = p_subline_cd
                   AND (PAR_ID IS NULL
                        OR PAR_ID = p_par_id
                        OR PAR_ID IN (SELECT PAR_ID
                                     FROM GIPI_PARLIST
                                    WHERE PAR_STATUS IN ('98','99'))
                       )   
         ORDER BY 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_bond_seq    := 0;
    END;     
   RETURN (v_bond_seq);
END;
/


