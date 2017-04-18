DROP PROCEDURE CPI.CREATE_GIUW_POLDIST_C_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Create_Giuw_Poldist_C_Gipis002
 (v_duration_frm IN OUT DATE,
  v_days_interval IN NUMBER,
  v_duration_to OUT DATE,
  p_dist_no OUT NUMBER,
  takeup_val IN NUMBER,
  v_no_of_payment IN NUMBER,  
  p_par_id IN NUMBER,
  a_item_grp IN NUMBER,
  b240_line_cd IN VARCHAR2,
  p_policy_id IN NUMBER,
  p_endt_type IN VARCHAR2,
  p_eff_date IN DATE,
  v_user IN VARCHAR2,
  v_notfound IN OUT VARCHAR2) IS    
  CURSOR B IS
       SELECT  pol_dist_dist_no_s.NEXTVAL
         FROM  sys.dual;              
BEGIN
  IF v_duration_frm IS NULL THEN
 v_duration_frm := TRUNC(p_eff_date);                  
  ELSE
 v_duration_frm := TRUNC(v_duration_frm + v_days_interval);         
  END IF;
  v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
       
  OPEN B;
  FETCH B INTO p_dist_no;
  IF B%NOTFOUND THEN
    v_notfound := 'Y';
    GOTO fin;
 --msg_alert('No row in table DUAL.','W',TRUE);
  END IF;
  CLOSE B;
  IF takeup_val = v_no_of_payment THEN --------------------------------------------- IF: last loop record (y)
 FOR XYZ IN (SELECT SUM((NVL(DECODE(c.peril_type,'B',X.tsi_amt,0),0)* NVL(currency_rt,1))) tsi_amt, 
           SUM((NVL(X.prem_amt,0)* NVL(currency_rt,1)) - (ROUND(((NVL(X.prem_amt,0)* NVL(currency_rt,1))/v_no_of_payment),2) * (v_no_of_payment - 1))) prem_amt, 
           SUM((NVL(DECODE(c.peril_type,'B',X.ann_tsi_amt,0),0)* NVL(currency_rt,1))) ann_tsi_amt
         FROM GIPI_WITMPERL X, GIPI_WITEM b, GIIS_PERIL c
        WHERE X.par_id = b.par_id
          AND X.item_no = b.item_no
          AND X.par_id = p_par_id
                   AND b.item_grp  = a_item_grp
                   AND X.peril_cd = c.peril_cd
                   AND c.line_cd  = b240_line_cd)--NVL(:c080.item_grp, p_item_grp))*/
    LOOP
      INSERT INTO GIUW_POL_DIST(dist_no, par_id, policy_id, endt_type, 
                                dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                last_upd_date, post_flag, auto_dist,
                                tsi_amt, 
                                prem_amt, 
                                ann_tsi_amt,
                                -- longterm --
                                item_grp, takeup_seq_no)
                         VALUES(p_dist_no,p_par_id,p_policy_id,p_endt_type,                                                            
                                        1,1,v_duration_frm,v_duration_to,SYSDATE,v_user,
                                        SYSDATE, 'O', 'N',
                                        XYZ.tsi_amt,--NVL(a.tsi_amt,0) - (ROUND((NVL(a.tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                       XYZ.prem_amt,--NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                        XYZ.ann_tsi_amt,--NVL(a.ann_tsi_amt,0) - (ROUND((NVL(a.ann_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                       -- longterm --
                                       a_item_grp, takeup_val);
    END LOOP;
                                 
                                 /*INSERT INTO giuw_pol_dist(dist_no, par_id, policy_id, endt_type, 
                                                           dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                                           last_upd_date, post_flag, auto_dist,
                                                           tsi_amt, 
                                                           prem_amt, 
                                                           ann_tsi_amt,
                                                           -- longterm --
                                                          item_grp, takeup_seq_no)
                                                    VALUES(p_dist_no,p_par_id,p_policy_id,p_endt_type,                                                            
                                                           1,1,v_duration_frm,v_duration_to,sysdate,user,
                                                           sysdate, 'O', 'N',
                                                           NVL(a.tsi_amt,0) - (ROUND((NVL(a.tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                                           NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                                           NVL(a.ann_tsi_amt,0) - (ROUND((NVL(a.ann_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                                           -- longterm --
                                                          a.item_grp, takeup_val
                                                          );*/
  ELSE ----------------------------------------------------------------------------- ELSE: other loop records (y)
    FOR XYZ IN (SELECT SUM(ROUND(((NVL(DECODE(c.peril_type,'B',X.tsi_amt,0),0)* NVL(currency_rt,1))),2)) tsi_amt, 
                       SUM(ROUND(((NVL(X.prem_amt,0)* NVL(currency_rt,1))/v_no_of_payment),2)) prem_amt, 
                       SUM(ROUND(((NVL(DECODE(c.peril_type,'B',X.ann_tsi_amt,0),0)* NVL(currency_rt,1))),2)) ann_tsi_amt
                  FROM GIPI_WITMPERL X, GIPI_WITEM b, GIIS_PERIL c
                 WHERE X.par_id = b.par_id
                   AND X.item_no = b.item_no
                   AND X.par_id = p_par_id
                   AND b.item_grp  = a_item_grp
                   AND X.peril_cd = c.peril_cd
                   AND c.line_cd  = b240_line_cd)--NVL(:c080.item_grp, p_item_grp))*/
    LOOP
      INSERT INTO GIUW_POL_DIST(dist_no, par_id, policy_id, endt_type, 
                                dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                last_upd_date, post_flag, auto_dist,
                                tsi_amt, 
                                prem_amt, 
                                ann_tsi_amt,
                                -- longterm --
                                item_grp, takeup_seq_no)
                         VALUES(p_dist_no,p_par_id,p_policy_id,p_endt_type,                                                            
                                1,1,v_duration_frm,v_duration_to,SYSDATE,v_user,
                                SYSDATE, 'O', 'N',
                                XYZ.tsi_amt,--(NVL(a.tsi_amt,0)/ v_no_of_payment),
                                XYZ.prem_amt,--(NVL(a.prem_amt,0)/ v_no_of_payment),
                                XYZ.ann_tsi_amt,--(NVL(a.ann_tsi_amt,0)/ v_no_of_payment),
                                -- longterm --
                                a_item_grp, takeup_val);
    END LOOP;
                             
                             /*    INSERT INTO giuw_pol_dist(dist_no, par_id, policy_id, endt_type, 
                                                           dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                                                           last_upd_date, post_flag, auto_dist,
                                                           tsi_amt, 
                                                           prem_amt, 
                                                           ann_tsi_amt,
                                                           -- longterm --
                                                          item_grp, takeup_seq_no)
                                                     VALUES(p_dist_no,p_par_id,p_policy_id,p_endt_type,                                                            
                                                           1,1,v_duration_frm,v_duration_to,sysdate,user,
                 sysdate, 'O', 'N',
                 (NVL(a.tsi_amt,0)/ v_no_of_payment),
                 (NVL(a.prem_amt,0)/ v_no_of_payment),
                 (NVL(a.ann_tsi_amt,0)/ v_no_of_payment),
                 -- longterm --
                a.item_grp, takeup_val
                );*/
  END IF; -------------------------------------------------------------------------- END IF: loop record (y)
  <<fin>>
  NULL;
END;
/


