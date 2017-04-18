DROP PROCEDURE CPI.EXIST_WPOLWC_POLWC;

CREATE OR REPLACE PROCEDURE CPI.EXIST_WPOLWC_POLWC
        (p_line_cd                     GIPI_WPOLBAS.line_cd%TYPE,
         p_subline_cd                  GIPI_WPOLBAS.subline_cd%TYPE,
         p_iss_cd                      GIPI_WPOLBAS.iss_cd%TYPE,
         p_issue_yy                    GIPI_WPOLBAS.issue_yy%TYPE,
         p_pol_seq_no                  GIPI_WPOLBAS.pol_seq_no%TYPE,
         p_wc_cd                       GIPI_WPOLWC.wc_cd%TYPE,
         p_swc_seq_no                  GIPI_WPOLWC.swc_seq_no%TYPE,
         p_rec_flag         OUT        GIPI_WPOLWC.rec_flag%TYPE,
         p_exist            OUT        VARCHAR2           
         )

 IS

/*
**  Created by        : Veronica V. Raymundo 
**  Date Created     : 01.27.2011
**  Reference By     : GIPIS035A - Warranties and Clauses Package Endt
**  Description 	: This procedure checks existing warranties both in endorsement
**                    and policy. Value for rec_flag is also changed. 
*/
   
   exist           VARCHAR2(1) := 'N';
   v_rec_flag      VARCHAR2(1);
   
BEGIN
  p_rec_flag := 'A';
  FOR A1 IN  
      (SELECT  a.policy_id
         FROM  gipi_polbasic a
        WHERE  a.line_cd = p_line_cd
          AND  a.subline_cd = p_subline_cd
          AND  a.iss_cd = p_iss_cd
          AND  a.issue_yy = p_issue_yy
          AND  a.pol_seq_no = p_pol_seq_no
          AND  pol_flag IN ('1','2','3')
     ORDER BY  eff_date desc)
  LOOP
      v_rec_flag := NULL;
      FOR A2 IN  
        (SELECT  rec_flag
           FROM  gipi_polwc
          WHERE  policy_id = A1.policy_id
            AND  wc_cd = p_wc_cd
            AND  swc_seq_no =     NVL(p_swc_seq_no,0))
    LOOP        
      v_rec_flag := A2.rec_flag;
      IF v_rec_flag = 'A' THEN
         p_rec_flag := 'C';
      ELSIF v_rec_flag = 'C' THEN
         p_rec_flag := 'C';               
      ELSIF v_rec_flag = 'D' THEN
         p_rec_flag := 'A';
      ELSIF v_rec_flag IS NULL THEN    
         p_rec_flag := 'D';
      END IF;                  
      exist := 'Y';
      
    END LOOP;
  END LOOP;
  
  p_exist := exist;
  
END;
/


