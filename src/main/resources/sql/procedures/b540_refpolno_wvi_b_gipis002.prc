DROP PROCEDURE CPI.B540_REFPOLNO_WVI_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Refpolno_Wvi_B_Gipis002
  (B540_ref_pol_no IN VARCHAR2,
   B240_par_id IN NUMBER,
   v_par_no OUT VARCHAR2) IS
BEGIN
  FOR B IN (SELECT b.line_cd||'-'||
                  b.iss_cd||'-'||
                  LTRIM(TO_CHAR(b.par_yy,'09'))||'-'|| 
                  LTRIM(TO_CHAR(b.par_seq_no,'000009'))||'-'||
                  LTRIM(TO_CHAR(b.quote_seq_no,'09')) par_no
              FROM GIPI_WPOLBAS A,
                   GIPI_PARLIST b
             WHERE A.par_id = b.par_id
               AND A.ref_pol_no = B540_ref_pol_no
               AND b.par_id <> B240_par_id)
  LOOP
    v_par_no := v_par_no||', '||B.par_no;                    
  END LOOP;  
END;
/


