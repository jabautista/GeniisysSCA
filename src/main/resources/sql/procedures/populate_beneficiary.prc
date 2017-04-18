DROP PROCEDURE CPI.POPULATE_BENEFICIARY;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_BENEFICIARY (
    P_ITEM_NO          IN NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wopen_policy.par_id%TYPE,
    p_msg             OUT  VARCHAR2
) 
IS
  v_policy_id         gipi_polbasic.policy_id%TYPE;
  v_endt_id           gipi_polbasic.policy_id%TYPE;
  --rg_id               RECORDGROUP;
  v_row               NUMBER;
  rg_count            NUMBER;
  item_exist          VARCHAR2(1);
  rg_name             VARCHAR2(30) := 'GROUP_POLICY';  
  rg_col              VARCHAR2(50) := rg_name || '.policy_id';

  v_beneficiary_name  gipi_wbeneficiary.beneficiary_name%TYPE;
  v_beneficiary_addr  gipi_wbeneficiary.beneficiary_addr%TYPE;
  v_beneficiary_no    gipi_wbeneficiary.beneficiary_no%TYPE;
  v_relation          gipi_wbeneficiary.relation%TYPE;
  v_remarks           gipi_wbeneficiary.remarks%TYPE;
  
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
  **  Description  : POPULATE_BENEFICIARY program unit 
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
        v_policy_id  := b.policy_id;     
          FOR A IN 
              ( SELECT beneficiary_name,      beneficiary_addr,      relation,                   
                       beneficiary_no, remarks
                  FROM gipi_beneficiary
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wbeneficiary
                      WHERE beneficiary_no = a.beneficiary_no
                        AND item_no = p_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;    
              IF NVL(item_exist,'N') = 'N' THEN
                   v_beneficiary_no       :=  a.beneficiary_no;
                   v_beneficiary_name     :=  a.beneficiary_name;
                   v_beneficiary_addr     :=  a.beneficiary_addr;
                   v_relation             :=  a.relation;               
                   v_remarks              :=  a.remarks;
                 FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
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
                     v_endt_id  := b1.policy_id;
                     FOR DATA2 IN       
                         ( SELECT beneficiary_name,      beneficiary_addr,      relation,
                                  beneficiary_no,        remarks
                             FROM gipi_beneficiary
                            WHERE Beneficiary_no = v_beneficiary_no
                              AND item_no   = p_item_no
                              AND policy_id = v_endt_id
                              AND delete_sw <> 'Y'
                          ) LOOP
                            v_beneficiary_name   :=  NVL(data2.beneficiary_name, v_beneficiary_name);
                            v_beneficiary_addr   :=  NVL(data2.beneficiary_addr, v_beneficiary_addr);
                            v_relation           :=  NVL(data2.relation, v_relation);
                            v_remarks            :=  NVL(data2.remarks, v_remarks);
                        END LOOP; 
                 END LOOP;
     
                  --IF NVL(v_delete_sw, 'N') = 'N' THEN                                               
                  --CLEAR_MESSAGE;
                  -- MESSAGE('Copying beneficiary ...',NO_ACKNOWLEDGE);
                  --SYNCHRONIZE; 
                     INSERT INTO gipi_wbeneficiary (
                                 par_id,             item_no,         beneficiary_name,
                                 beneficiary_addr,   relation,        beneficiary_no,
                                 remarks)
                        VALUES ( p_new_par_id,    p_item_no,  v_beneficiary_name,
                                 v_beneficiary_addr, v_relation,      v_beneficiary_no,
                                 v_remarks);
                  --END IF;
                    v_beneficiary_no       :=  NULL;
                    v_beneficiary_name     :=  NULL;
                    v_beneficiary_addr     :=  NULL;
                    v_relation             :=  NULL;
                    v_remarks              :=  NULL;
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
        v_policy_id  := b.policy_id;     
          FOR A IN 
              ( SELECT beneficiary_name,      beneficiary_addr,      relation,                   
                       beneficiary_no, remarks
                  FROM gipi_beneficiary
                 WHERE policy_id = v_policy_id
                   AND item_no   = p_item_no
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wbeneficiary
                      WHERE beneficiary_no = a.beneficiary_no
                        AND item_no = p_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;    
              IF NVL(item_exist,'N') = 'N' THEN
                   v_beneficiary_no       :=  a.beneficiary_no;
                   v_beneficiary_name     :=  a.beneficiary_name;
                   v_beneficiary_addr     :=  a.beneficiary_addr;
                   v_relation             :=  a.relation;               
                   v_remarks              :=  a.remarks;
                 FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
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
                     v_endt_id  := b1.policy_id;
                     FOR DATA2 IN       
                         ( SELECT beneficiary_name,      beneficiary_addr,      relation,
                                  beneficiary_no,        remarks
                             FROM gipi_beneficiary
                            WHERE Beneficiary_no = v_beneficiary_no
                              AND item_no   = p_item_no
                              AND policy_id = v_endt_id
                              AND delete_sw <> 'Y'
                          ) LOOP
                            v_beneficiary_name   :=  NVL(data2.beneficiary_name, v_beneficiary_name);
                            v_beneficiary_addr   :=  NVL(data2.beneficiary_addr, v_beneficiary_addr);
                            v_relation           :=  NVL(data2.relation, v_relation);
                            v_remarks            :=  NVL(data2.remarks, v_remarks);
                        END LOOP; 
                 END LOOP;
     
                  --IF NVL(v_delete_sw, 'N') = 'N' THEN                                               
                  --CLEAR_MESSAGE;
                  -- MESSAGE('Copying beneficiary ...',NO_ACKNOWLEDGE);
                  --SYNCHRONIZE; 
                     INSERT INTO gipi_wbeneficiary (
                                 par_id,             item_no,         beneficiary_name,
                                 beneficiary_addr,   relation,        beneficiary_no,
                                 remarks)
                        VALUES ( p_new_par_id,    p_item_no,  v_beneficiary_name,
                                 v_beneficiary_addr, v_relation,      v_beneficiary_no,
                                 v_remarks);
                  --END IF;
                    v_beneficiary_no       :=  NULL;
                    v_beneficiary_name     :=  NULL;
                    v_beneficiary_addr     :=  NULL;
                    v_relation             :=  NULL;
                    v_remarks              :=  NULL;
             END IF;       
          END LOOP;
     END LOOP;
   END IF;
END;
/


