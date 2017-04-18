DROP PROCEDURE CPI.B540_REFPOLNO_WVI_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Refpolno_Wvi_A_Gipis002
  (B540_ref_pol_no IN VARCHAR2,
   v_policy_no OUT VARCHAR2) IS
BEGIN
   FOR A IN (SELECT line_cd||'-'||
                  subline_cd||'-'||
                  iss_cd||'-'||
                  LTRIM(TO_CHAR(issue_yy,'09'))||'-'||
                  LTRIM(TO_CHAR(pol_seq_no,'0000009'))||'-'||
                  LTRIM(TO_CHAR(renew_no,'09')) policy_no
                FROM GIPI_POLBASIC
             WHERE pol_flag IN ('1','2','3','4','X')
               AND ref_pol_no = B540_ref_pol_no)
  LOOP
    v_policy_no := v_policy_no||', '||A.policy_no;          
  END LOOP; 
END;
/


