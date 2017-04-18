DROP PROCEDURE CPI.POPULATE_PRINCIPAL;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_PRINCIPAL(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wprincipal.par_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  exist_sw      VARCHAR2(1);  
  v_policy_id   gipi_polbasic.policy_id%TYPE;                            
  --rg_id         RECORDGROUP;
  rg_count      NUMBER;
  rg_name       VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col        VARCHAR2(50) := rg_name || '.policy_id';
  item_exist    VARCHAR2(1) := 'N';
  exist1        VARCHAR2(1) := 'N';
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_PRINCIPAL program unit 
  */

   GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);
   IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
                AND NVL(endt_seq_no,0) = 0
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id     := b.policy_id;
          FOR A IN 
              ( SELECT principal_cd, engg_basic_infonum, subcon_sw
                  FROM gipi_principal
                 WHERE policy_id = v_policy_id
              ) LOOP
              exist_sw := 'N';    
              FOR B IN 
                  ( SELECT '1'
                      FROM gipi_wprincipal
                     WHERE principal_cd = a.principal_cd
                       AND par_id       = p_new_par_id
                  ) LOOP
                  exist_sw   := 'Y';
              END LOOP;         
              IF exist_sw = 'N' THEN
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying principal info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                    INSERT INTO gipi_wprincipal
                                ( par_id,        principal_cd,   engg_basic_infonum,   subcon_sw)
                         VALUES ( p_new_par_id,  a.principal_cd, a.engg_basic_infonum, a.subcon_sw);
              END IF;               
          END LOOP;
     END LOOP;
   ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
    FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
               FROM gipi_polbasic
              WHERE line_cd     =  x_line_cd
                AND subline_cd  =  x_subline_cd
                AND iss_cd      =  x_iss_cd
                AND issue_yy    =  to_char(x_issue_yy)
                AND pol_seq_no  =  to_char(x_pol_seq_no)
                AND renew_no    =  to_char(x_renew_no)
                AND (endt_seq_no = 0 OR 
                    (endt_seq_no > 0 AND 
                    TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                AND pol_flag In ('1','2','3')
              ORDER BY eff_date, endt_seq_no)
     LOOP      
        v_policy_id     := b.policy_id;
          FOR A IN 
              ( SELECT principal_cd, engg_basic_infonum, subcon_sw
                  FROM gipi_principal
                 WHERE policy_id = v_policy_id
              ) LOOP
              exist_sw := 'N';    
              FOR B IN 
                  ( SELECT '1'
                      FROM gipi_wprincipal
                     WHERE principal_cd = a.principal_cd
                       AND par_id       = p_new_par_id
                  ) LOOP
                  exist_sw   := 'Y';
              END LOOP;         
              IF exist_sw = 'N' THEN
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying principal info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                    INSERT INTO gipi_wprincipal
                                ( par_id,        principal_cd,   engg_basic_infonum,   subcon_sw)
                         VALUES ( p_new_par_id,  a.principal_cd, a.engg_basic_infonum, a.subcon_sw);
              END IF;               
          END LOOP;
     END LOOP;
   END IF;
END;
/


