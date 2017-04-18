DROP PROCEDURE CPI.POPULATE_OPEN_POLICY;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_OPEN_POLICY(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_policy.par_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  v_policy_id         gipi_polbasic.policy_id%TYPE;
  --rg_id               RECORDGROUP;
  rg_count            NUMBER;
  rg_name             VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col              VARCHAR2(50) := rg_name || '.policy_id';
  item_exist          VARCHAR2(1) := 'N';
  exist               VARCHAR2(1) := 'N';
  v_line_cd           gipi_wopen_policy.line_cd%TYPE; 
  v_op_subline_cd     gipi_wopen_policy.op_subline_cd%TYPE;
  v_op_iss_cd         gipi_wopen_policy.op_iss_cd%TYPE;
  v_op_pol_seqno      gipi_wopen_policy.op_pol_seqno%TYPE;
  v_op_renew_no       gipi_wopen_policy.op_renew_no%TYPE;
  v_decltn_no         gipi_wopen_policy.decltn_no%TYPE;
  v_eff_date          gipi_wopen_policy.eff_date%TYPE;
  v_op_issue_yy       gipi_wopen_policy.op_issue_yy%TYPE;
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
BEGIN 
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_OPEN_POLICY program unit 
  */
  /*CHECK_POLICY_GROUP(rg_name);   
  rg_id     := FIND_GROUP(rg_name);
  rg_count  := GET_GROUP_ROW_COUNT(rg_id);
  FOR ROW_NO IN 1 .. rg_count  
  LOOP
    v_policy_id  := GET_GROUP_NUMBER_CELL(rg_col,row_no);      
    FOR open_pol IN (
       SELECT line_cd,   op_subline_cd,  
              op_iss_cd, op_pol_seqno,   
              decltn_no, eff_date,       
              op_issue_yy, op_renew_no
         FROM gipi_open_policy
        WHERE policy_id = v_policy_id)
    LOOP
      exist   := 'Y';
      v_line_cd          := NVL(open_pol.line_cd,v_line_cd);          
      v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
      v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
      v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
      v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
      v_eff_date         := NVL(open_pol.eff_date,v_eff_date);                
      v_op_issue_yy      := NVL(open_pol.op_issue_yy,v_op_issue_yy);         
      v_op_renew_no      := NVL(open_pol.op_renew_no,v_op_renew_no); 
    END LOOP;
  END LOOP;    */
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
            FOR open_pol IN (
           SELECT line_cd,   op_subline_cd,  
                  op_iss_cd, op_pol_seqno,   
                  decltn_no, eff_date,       
                  op_issue_yy, op_renew_no
             FROM gipi_open_policy
            WHERE policy_id = v_policy_id)
        LOOP
          exist   := 'Y';
          v_line_cd          := NVL(open_pol.line_cd,v_line_cd);          
          v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
          v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
          v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
          v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
          v_eff_date         := NVL(open_pol.eff_date,v_eff_date);                
          v_op_issue_yy      := NVL(open_pol.op_issue_yy,v_op_issue_yy);         
          v_op_renew_no      := NVL(open_pol.op_renew_no,v_op_renew_no); 
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
         FOR open_pol IN (
           SELECT line_cd,   op_subline_cd,  
                  op_iss_cd, op_pol_seqno,   
                  decltn_no, eff_date,       
                  op_issue_yy, op_renew_no
             FROM gipi_open_policy
            WHERE policy_id = v_policy_id)
        LOOP
          exist   := 'Y';
          v_line_cd          := NVL(open_pol.line_cd,v_line_cd);          
          v_op_subline_cd    := NVL(open_pol.op_subline_cd,v_op_subline_cd);      
          v_op_iss_cd        := NVL(open_pol.op_iss_cd,v_op_iss_cd);        
          v_op_pol_seqno     := NVL(open_pol.op_pol_seqno,v_op_pol_seqno);        
          v_decltn_no        := NVL(open_pol.decltn_no,v_decltn_no);        
          v_eff_date         := NVL(open_pol.eff_date,v_eff_date);                
          v_op_issue_yy      := NVL(open_pol.op_issue_yy,v_op_issue_yy);         
          v_op_renew_no      := NVL(open_pol.op_renew_no,v_op_renew_no); 
        END LOOP;
     END LOOP;
   END IF;
  
  IF NVL(exist, 'N') = 'Y' THEN
     --CLEAR_MESSAGE;
     --MESSAGE('Copying open policy info ...',NO_ACKNOWLEDGE);
     --SYNCHRONIZE;
       INSERT INTO gipi_wopen_policy (
                   par_id,        line_cd,        op_subline_cd,
                   op_iss_cd,     op_pol_seqno,   op_renew_no,
                   decltn_no,     eff_date,       op_issue_yy)
           VALUES (p_new_par_id,  v_line_cd,      v_op_subline_cd,
                   v_op_iss_cd,   v_op_pol_seqno, v_op_renew_no,
                   v_decltn_no,   v_eff_date,     v_op_issue_yy);         
  END IF;     
END;
/


