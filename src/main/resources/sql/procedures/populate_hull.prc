DROP PROCEDURE CPI.POPULATE_HULL;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_HULL (
    v_item_no          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_witem_ves.par_id%TYPE,
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
  v_vessel_cd             gipi_witem_ves.vessel_cd%TYPE;
  v_geog_limit            gipi_witem_ves.geog_limit%TYPE;
  v_deduct_text           gipi_witem_ves.deduct_text%TYPE; 
  v_dry_date              gipi_witem_ves.dry_date%TYPE;
  v_dry_place             gipi_witem_ves.dry_place%TYPE;
  
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
  **  Description  : POPULATE_HULL program unit 
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
          ( SELECT vessel_cd,    geog_limit,   deduct_text,    dry_date,   dry_place
              FROM gipi_item_ves
             WHERE item_no = v_item_no
               AND policy_id = v_policy_id               
          ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_witem_ves
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_vessel_cd       := data.vessel_cd;
                 v_geog_limit      := data.geog_limit; 
                 v_deduct_text     := data.deduct_text;
                 v_dry_date        := data.dry_date;
                 v_dry_place       := data.dry_place; 
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
                            ( SELECT vessel_cd,    geog_limit,   deduct_text,    dry_date,   dry_place
                              FROM gipi_item_ves
                            WHERE item_no = v_item_no 
                              AND policy_id = v_endt_id
                         ) LOOP
                         v_vessel_cd       := NVL(data2.vessel_cd, v_vessel_cd);
                         v_geog_limit      := NVL(data2.geog_limit, v_geog_limit); 
                         v_deduct_text     := NVL(data2.deduct_text, v_deduct_text);
                         v_dry_date        := NVL(data2.dry_date, v_dry_date);
                         v_dry_place       := NVL(data2.dry_place, v_dry_place); 
                     END LOOP;
                 END LOOP;
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying vessel info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                 INSERT INTO gipi_witem_ves(
                        par_id,         item_no,    vessel_cd,    geog_limit,
                        deduct_text,    dry_date,   dry_place,    rec_flag)
                VALUES(p_new_par_id,    v_item_no,  v_vessel_cd,  v_geog_limit,
                        v_deduct_text,  v_dry_date, v_dry_place,  'A' ); 
                v_vessel_cd       := NULL;
                v_geog_limit      := NULL; 
                v_deduct_text     := NULL;
                v_dry_date        := NULL;
                v_dry_place       := NULL; 
              ELSE 
                EXIT;
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
          ( SELECT vessel_cd,    geog_limit,   deduct_text,    dry_date,   dry_place
              FROM gipi_item_ves
             WHERE item_no = v_item_no
               AND policy_id = v_policy_id               
          ) LOOP
              item_exist := 'N';
              FOR CHK_ITEM IN
                   ( SELECT '1'
                       FROM gipi_witem_ves
                      WHERE item_no = v_item_no
                        AND par_id  = p_new_par_id
                    ) LOOP
                    item_exist := 'Y';
                    EXIT;
              END LOOP;
              IF item_exist = 'N' THEN                 
                 v_vessel_cd       := data.vessel_cd;
                 v_geog_limit      := data.geog_limit; 
                 v_deduct_text     := data.deduct_text;
                 v_dry_date        := data.dry_date;
                 v_dry_place       := data.dry_place; 
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
                            ( SELECT vessel_cd,    geog_limit,   deduct_text,    dry_date,   dry_place
                              FROM gipi_item_ves
                            WHERE item_no = v_item_no 
                              AND policy_id = v_endt_id
                         ) LOOP
                         v_vessel_cd       := NVL(data2.vessel_cd, v_vessel_cd);
                         v_geog_limit      := NVL(data2.geog_limit, v_geog_limit); 
                         v_deduct_text     := NVL(data2.deduct_text, v_deduct_text);
                         v_dry_date        := NVL(data2.dry_date, v_dry_date);
                         v_dry_place       := NVL(data2.dry_place, v_dry_place); 
                     END LOOP;
                 END LOOP;
                 --CLEAR_MESSAGE;
                 --MESSAGE('Copying vessel info ...',NO_ACKNOWLEDGE);
                 --SYNCHRONIZE; 
                 INSERT INTO gipi_witem_ves(
                        par_id,         item_no,    vessel_cd,    geog_limit,
                        deduct_text,    dry_date,   dry_place,    rec_flag)
                VALUES(p_new_par_id,    v_item_no,  v_vessel_cd,  v_geog_limit,
                        v_deduct_text,  v_dry_date, v_dry_place,  'A' ); 
                v_vessel_cd       := NULL;
                v_geog_limit      := NULL; 
                v_deduct_text     := NULL;
                v_dry_date        := NULL;
                v_dry_place       := NULL; 
              ELSE 
                EXIT;
              END IF;                        
          END LOOP;
     END LOOP;
   END IF; 
END;
/


