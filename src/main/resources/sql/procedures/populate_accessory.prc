DROP PROCEDURE CPI.POPULATE_ACCESSORY;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ACCESSORY ( 
    P_ITEM_NO          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wmcacc.par_id%TYPE,
    p_user             IN  gipi_wmcacc.user_id%TYPE,
    p_msg             OUT  VARCHAR2
     
)
IS
  v_accessory_desc   giis_accessory.accessory_desc%TYPE;
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  v_row              NUMBER;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  item_exist         VARCHAR2(1) := 'N';
  exist1             VARCHAR2(1) := 'N';
  
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
  **  Description  : POPULATE_ACCESSORY program unit 
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
        v_policy_id   := b.policy_id;
          FOR DATA IN
              ( SELECT accessory_cd, acc_amt
                  FROM gipi_mcacc
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no      
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wmcacc
                      WHERE par_id   = p_new_par_id
                        AND item_no  = p_item_no
                        AND accessory_cd = data.accessory_cd
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
              --CLEAR_MESSAGE;
              --MESSAGE('Copying accessories...',NO_ACKNOWLEDGE);
              --SYNCHRONIZE;         
              INSERT INTO gipi_wmcacc( 
                          par_id,       item_no,   accessory_cd,  acc_amt,  user_id,  last_update)
                  VALUES(p_new_par_id, p_item_no, data.accessory_cd, data.acc_amt,  p_user,  sysdate);       
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
        v_policy_id   := b.policy_id;
          FOR DATA IN
              ( SELECT accessory_cd, acc_amt
                  FROM gipi_mcacc
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no      
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wmcacc
                      WHERE par_id   = p_new_par_id
                        AND item_no  = p_item_no
                        AND accessory_cd = data.accessory_cd
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
              --CLEAR_MESSAGE;
              --MESSAGE('Copying accessories...',NO_ACKNOWLEDGE);
              --SYNCHRONIZE;         
              INSERT INTO gipi_wmcacc( 
                          par_id,       item_no,   accessory_cd,  acc_amt,  user_id,  last_update)
                  VALUES(p_new_par_id, p_item_no, data.accessory_cd, data.acc_amt,  p_user,  sysdate);       
              END IF;                        
          END LOOP;
     END LOOP;
   END IF;
END;
/


