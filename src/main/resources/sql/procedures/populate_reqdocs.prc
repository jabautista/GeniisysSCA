DROP PROCEDURE CPI.POPULATE_REQDOCS;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_REQDOCS(
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_wreqdocs.par_id%TYPE,
    p_user             IN  gipi_wreqdocs.user_id%TYPE,
    p_msg             OUT  VARCHAR2
)  
IS
  --rg_id                   RECORDGROUP;
  rg_name                 VARCHAR2(30) := 'GROUP_POLICY';
  rg_count                NUMBER;
  rg_count2               NUMBER;
  rg_col                  VARCHAR2(50) := rg_name || '.policy_id';
  item_exist              VARCHAR2(1); 
  v_row                   NUMBER;
  v_policy_id             gipi_polbasic.policy_id%TYPE;
  v_endt_id               gipi_polbasic.policy_id%TYPE;
  v_doc_cd                gipi_wreqdocs.doc_cd%TYPE;
  v_doc_sw                gipi_wreqdocs.doc_sw%TYPE;
  v_line_cd               gipi_wreqdocs.line_cd%TYPE;
  v_date_submitted        gipi_wreqdocs.date_submitted%TYPE;
  v_remarks               gipi_wreqdocs.remarks%TYPE;
  
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
  **  Description  : POPULATE_REQDOCS program unit 
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
              ( SELECT doc_cd, doc_sw, line_cd, date_submitted, remarks
                  FROM gipi_reqdocs
                 WHERE policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wreqdocs
                      WHERE doc_cd  = data.doc_cd
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_doc_cd         := data.doc_cd;
                 v_doc_sw         := data.doc_sw;
                 v_line_cd        := data.line_cd;
                 v_date_submitted := data.date_submitted;
                 v_remarks        := data.remarks;
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
                    v_endt_id   := b1.policy_id;
                     FOR DATA2 IN
                            ( SELECT doc_sw, line_cd, date_submitted, remarks
                              FROM gipi_reqdocs
                             WHERE doc_cd    = v_doc_cd
                               AND policy_id = v_endt_id
                         ) LOOP
                         v_doc_sw         := NVL(data2.doc_sw, v_doc_sw);
                         v_line_cd        := NVL(data2.line_cd, v_line_cd);
                         v_date_submitted := NVL(data2.date_submitted, v_date_submitted);
                         v_remarks        := NVL(data2.remarks, v_remarks);
                     END LOOP; 
                 END LOOP; 
               --CLEAR_MESSAGE;
               --MESSAGE('Copying policy''s required documents ...',NO_ACKNOWLEDGE);
               --SYNCHRONIZE;      
                INSERT INTO gipi_wreqdocs(
                        par_id,         doc_cd,       doc_sw,       date_submitted,
                        line_cd,        remarks,      user_id,      last_update)
                VALUES(p_new_par_id,   v_doc_cd,     v_doc_sw,     v_date_submitted,
                        v_line_cd,      v_remarks,    p_user,       sysdate); 
                 v_doc_cd         := NULL;
                 v_doc_sw         := NULL;
                 v_line_cd        := NULL;
                 v_date_submitted := NULL;
                 v_remarks        := NULL;
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
              ( SELECT doc_cd, doc_sw, line_cd, date_submitted, remarks
                  FROM gipi_reqdocs
                 WHERE policy_id = v_policy_id               
              ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_wreqdocs
                      WHERE doc_cd  = data.doc_cd
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_doc_cd         := data.doc_cd;
                 v_doc_sw         := data.doc_sw;
                 v_line_cd        := data.line_cd;
                 v_date_submitted := data.date_submitted;
                 v_remarks        := data.remarks;
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
                    v_endt_id   := b1.policy_id;
                     FOR DATA2 IN
                            ( SELECT doc_sw, line_cd, date_submitted, remarks
                              FROM gipi_reqdocs
                             WHERE doc_cd    = v_doc_cd
                               AND policy_id = v_endt_id
                         ) LOOP
                         v_doc_sw         := NVL(data2.doc_sw, v_doc_sw);
                         v_line_cd        := NVL(data2.line_cd, v_line_cd);
                         v_date_submitted := NVL(data2.date_submitted, v_date_submitted);
                         v_remarks        := NVL(data2.remarks, v_remarks);
                     END LOOP; 
                 END LOOP; 
               --CLEAR_MESSAGE;
               --MESSAGE('Copying policy''s required documents ...',NO_ACKNOWLEDGE);
               --SYNCHRONIZE;      
                INSERT INTO gipi_wreqdocs(
                        par_id,         doc_cd,       doc_sw,       date_submitted,
                        line_cd,        remarks,      user_id,      last_update)
                VALUES(p_new_par_id,   v_doc_cd,     v_doc_sw,     v_date_submitted,
                        v_line_cd,      v_remarks,    p_user,       sysdate); 
                 v_doc_cd         := NULL;
                 v_doc_sw         := NULL;
                 v_line_cd        := NULL;
                 v_date_submitted := NULL;
                 v_remarks        := NULL;
              END IF;                        
          END LOOP;
     END LOOP;
   END IF;  
END;
/


