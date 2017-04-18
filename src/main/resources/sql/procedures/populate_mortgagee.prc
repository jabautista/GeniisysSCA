DROP PROCEDURE CPI.POPULATE_MORTGAGEE;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_MORTGAGEE(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_witem.par_id%TYPE,
    p_user             IN  gipi_wmortgagee.user_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  --rg_id              RECORDGROUP;
  rg_name            VARCHAR2(30) := 'GROUP_POLICY';
  rg_count           NUMBER;
  rg_count2          NUMBER;
  rg_col             VARCHAR2(50) := rg_name || '.policy_id';
  item_exist         VARCHAR2(1); 
  insert_sw          VARCHAR2(1); 
  v_row              NUMBER;
  v_policy_id        gipi_polbasic.policy_id%TYPE;
  v_endt_id          gipi_polbasic.policy_id%TYPE;
  v_iss_cd           gipi_wmortgagee.iss_cd%TYPE;
  v_mortg_cd         gipi_wmortgagee.mortg_cd%TYPE;
  v_item_no          gipi_wmortgagee.item_no%TYPE;  
  v_amount           gipi_wmortgagee.amount%TYPE;
  v_remarks          gipi_wmortgagee.remarks%TYPE;
  
  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;
  
  v_issue_cd         giis_issource.iss_cd%TYPE;
BEGIN 
  
   --added by apollo cruz 02.13.2015
   IF NVL(giisp.v('CRED_BRANCH_RENEWAL'), 'N')='Y' THEN 
      SELECT cred_branch
        INTO v_issue_cd
        FROM gipi_polbasic
       WHERE policy_id = p_old_pol_id; 
   ELSIF NVL(giisp.v('ALLOW_OTHER_BRANCH_RENEWAL'), 'N')='Y' THEN 
      v_issue_cd := get_user_iss_cd(p_user);
   END IF;
  
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-24-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_OPEN_POLICY program unit 
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
              ( SELECT NVL(item_no,0) item_no,  mortg_cd, amount,
                       remarks, iss_cd, delete_sw
                  FROM gipi_mortgagee
                 WHERE (NVL(item_no,0) = 0 
                    OR item_no  in ( SELECT item_no
                                       FROM gipi_witem
                                      WHERE par_id = p_new_par_id))
                   AND policy_id = v_policy_id               
                   AND nvl(delete_sw,'N') <> 'Y'
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wmortgagee
                      WHERE mortg_cd = data.mortg_cd
                        AND item_no  = data.item_no
                        AND par_id   = p_new_par_id
                        AND nvl(delete_sw,'N') != 'Y'
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_mortg_cd         := data.mortg_cd;
                 v_item_no          := data.item_no;
                 v_amount           := nvl(data.amount,0);
                 v_remarks          := data.remarks;             
                 v_iss_cd           := data.iss_cd;
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
                    v_endt_id   := b.policy_id;
                     FOR DATA2 IN
                            ( SELECT remarks, amount, iss_cd
                              FROM gipi_mortgagee
                            WHERE mortg_cd       = v_mortg_cd
                              AND nvl(item_no,0) = nvl(v_item_no,0)                     
                              AND policy_id      = v_endt_id
                              AND nvl(delete_sw,'N') <> 'Y'
                         ) LOOP
                         IF v_policy_id <> v_endt_id THEN    
                            v_amount         := NVL(v_amount,0) + NVL(data2.amount,0);
                            v_remarks        := NVL(data2.remarks, v_remarks);
                            v_iss_cd         := NVL(data2.iss_cd, v_iss_cd);
                         END IF;    
                      END LOOP;
                 END LOOP;         
                   insert_sw := 'Y';
                   IF NVL(v_item_no,0) > 0 THEN
                         insert_sw := 'N';
                         FOR CHK_VALID IN
                             ( SELECT '1'
                                 FROM gipi_witem
                                WHERE item_no = v_item_no
                                  AND par_id  = p_new_par_id
                              ) LOOP  
                              insert_sw := 'Y';
                         END LOOP;          
                   END IF;
                   IF NVL(insert_sw, 'Y') = 'Y' THEN
                    --CLEAR_MESSAGE;
                    --MESSAGE('Copying mortgagee info ...',NO_ACKNOWLEDGE);
                    --SYNCHRONIZE;
                      --modified by apollo cruz 02.13.2015 - to handle fk constraint
                      DECLARE
                         fk_violation EXCEPTION;
                         PRAGMA EXCEPTION_INIT(fk_violation, -02291); 
                      BEGIN            
                      INSERT INTO gipi_wmortgagee (
                                  par_id,            iss_cd,         mortg_cd,
                                  item_no,           amount,         remarks,
                                  last_update,       user_id)
                           VALUES(p_new_par_id,      NVL(v_issue_cd, v_iss_cd),       v_mortg_cd,
                                  v_item_no,         v_amount,       v_remarks,
                                  sysdate,           p_user);
                      EXCEPTION WHEN fk_violation THEN
                         NULL;           
                      END;             
                   END IF;               

                    v_mortg_cd         := NULL;
                    v_iss_cd           := NULL;
                    v_amount           := NULL;
                    v_item_no          := NULL;
                    v_remarks          := NULL;
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
              ( SELECT NVL(item_no,0) item_no,  mortg_cd, amount,
                       remarks, iss_cd, delete_sw
                  FROM gipi_mortgagee
                 WHERE (NVL(item_no,0) = 0 
                    OR item_no  in ( SELECT item_no
                                       FROM gipi_witem
                                      WHERE par_id = p_new_par_id))
                   AND policy_id = v_policy_id               
                   AND nvl(delete_sw,'N') <> 'Y'
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wmortgagee
                      WHERE mortg_cd = data.mortg_cd
                        AND item_no  = data.item_no
                        AND par_id   = p_new_par_id
                        AND nvl(delete_sw,'N') != 'Y'
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_mortg_cd         := data.mortg_cd;
                 v_item_no          := data.item_no;
                 v_amount           := nvl(data.amount,0);
                 v_remarks          := data.remarks;             
                 v_iss_cd           := data.iss_cd;
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
                    v_endt_id   := b.policy_id;
                     FOR DATA2 IN
                            ( SELECT remarks, amount, iss_cd
                              FROM gipi_mortgagee
                            WHERE mortg_cd       = v_mortg_cd
                              AND nvl(item_no,0) = nvl(v_item_no,0)                     
                              AND policy_id      = v_endt_id
                              AND nvl(delete_sw,'N') <> 'Y'
                         ) LOOP
                         IF v_policy_id <> v_endt_id THEN    
                            v_amount         := NVL(v_amount,0) + NVL(data2.amount,0);
                            v_remarks        := NVL(data2.remarks, v_remarks);
                            v_iss_cd         := NVL(data2.iss_cd, v_iss_cd);
                         END IF;    
                      END LOOP;
                 END LOOP;         
                   insert_sw := 'Y';
                   IF NVL(v_item_no,0) > 0 THEN
                         insert_sw := 'N';
                         FOR CHK_VALID IN
                             ( SELECT '1'
                                 FROM gipi_witem
                                WHERE item_no = v_item_no
                                  AND par_id  = p_new_par_id
                              ) LOOP  
                              insert_sw := 'Y';
                         END LOOP;          
                   END IF;
                   IF NVL(insert_sw, 'Y') = 'Y' THEN
                    --CLEAR_MESSAGE;
                    --MESSAGE('Copying mortgagee info ...',NO_ACKNOWLEDGE);
                    --SYNCHRONIZE;
                       --modified by apollo cruz 02.13.2015 - to handle fk constraint                       
                       DECLARE
                          fk_violation EXCEPTION;
                          PRAGMA EXCEPTION_INIT(fk_violation, -02291);
                       BEGIN            
                          INSERT INTO gipi_wmortgagee (
                                   par_id,            iss_cd,         mortg_cd,
                                   item_no,           amount,         remarks,
                                   last_update,       user_id)
                          VALUES(p_new_par_id,      NVL(v_issue_cd, v_iss_cd),       v_mortg_cd,
                                   v_item_no,         v_amount,       v_remarks,
                                   sysdate,           p_user);
                       EXCEPTION WHEN fk_violation THEN
                          NULL;             
                       END;             
                   END IF;               

                    v_mortg_cd         := NULL;
                    v_iss_cd           := NULL;
                    v_amount           := NULL;
                    v_item_no          := NULL;
                    v_remarks          := NULL;
            END IF;         
          END LOOP;
     END LOOP;
   END IF;   
END;
/


