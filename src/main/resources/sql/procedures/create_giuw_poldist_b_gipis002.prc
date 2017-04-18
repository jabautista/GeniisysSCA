DROP PROCEDURE CPI.CREATE_GIUW_POLDIST_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Create_Giuw_Poldist_B_Gipis002
 (p_dist_no OUT NUMBER,
  p_par_id IN NUMBER,
  p_policy_id IN NUMBER,
  p_endt_type IN VARCHAR2,
  v_tsi_amt IN NUMBER,
  v_prem_amt IN NUMBER,
  v_ann_tsi_amt IN NUMBER,
  p_eff_date IN DATE,
  p_expiry_date IN DATE,
  v_user IN VARCHAR2,
  v_notfound IN OUT VARCHAR2) IS    
  CURSOR B IS
       SELECT  pol_dist_dist_no_s.NEXTVAL
         FROM  sys.dual;              
BEGIN
  OPEN B;
               FETCH B INTO p_dist_no;
               IF B%NOTFOUND THEN
                           v_notfound := 'Y';
                           GOTO fin;
                  --msg_alert('No row in table DUAL.','W',TRUE);
               END IF;
               CLOSE B;
       
       INSERT INTO GIUW_POL_DIST(dist_no, par_id, policy_id, endt_type, tsi_amt,
                                                  prem_amt, ann_tsi_amt, dist_flag, redist_flag,
                                                  eff_date, expiry_date, create_date, user_id,
                                                  last_upd_date, post_flag, auto_dist,
                                                  -- longterm --
                                                item_grp, takeup_seq_no)
                                            VALUES(p_dist_no,p_par_id,p_policy_id,p_endt_type,NVL(v_tsi_amt,0),
                                                  NVL(v_prem_amt,0),NVL(v_ann_tsi_amt,0),1,1,
              p_eff_date,p_expiry_date,SYSDATE,v_user,
              SYSDATE, 'O', 'N',
              -- longterm --
              NULL, /* NULL -- jhing 11.05.2014 replaced with: */ 1 );
  <<fin>>
  NULL;
END;
/


