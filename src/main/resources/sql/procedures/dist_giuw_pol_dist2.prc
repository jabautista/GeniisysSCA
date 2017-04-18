DROP PROCEDURE CPI.DIST_GIUW_POL_DIST2;

CREATE OR REPLACE PROCEDURE CPI.dist_giuw_pol_dist2(
                  p_par_id           IN GIPI_PARLIST.par_id%TYPE,
                  p_policy_id        IN GIPI_POLBASIC.policy_id%TYPE,
                  p_dist_no         OUT giuw_pol_dist.dist_no%TYPE,
                  p_msg_alert       OUT VARCHAR2           
                  )
        IS
  v_endt_type        gipi_polbasic.endt_type%TYPE;
  v_tsi_amt            gipi_polbasic.tsi_amt%TYPE;
  v_prem_amt        gipi_polbasic.prem_amt%TYPE;
  v_ann_tsi_amt        gipi_polbasic.ann_tsi_amt%TYPE;
  v_eff_date        gipi_polbasic.eff_date%TYPE;
  v_expiry_date        gipi_polbasic.expiry_date%TYPE;
  v_user_id            gipi_polbasic.user_id%TYPE;
  v_dist_no            giuw_pol_dist.dist_no%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : dist_giuw_pol_dist program unit
  */
  
  /*IF :gauge.process='Y' THEN
    :gauge.file := 'Copying Distribution Basic information...';
  ELSE
    :gauge.file := 'passing giuw_pol_dist distribution process';
  END IF;
  vbx_counter;*/
  BEGIN
    SELECT pol_dist_dist_no_s.NEXTVAL
      INTO v_dist_no 
      FROM DUAL;
  EXCEPTION
    WHEN NO_DATA_FOUND then
         p_msg_alert := 'Cannot generate new POLICY ID.';
         RETURN;
         --error_rtn;
  END;
  SELECT endt_type,NVL(tsi_amt,0),NVL(prem_amt,0),NVL(ann_tsi_amt,0),eff_date,expiry_date,user_id
    INTO v_endt_type,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_eff_date,v_expiry_date,v_user_id
    FROM gipi_polbasic
   WHERE policy_id = p_policy_id;
  /* modified by bdarusin
  ** modified on jan312003
  ** changed 'user_id' into v_user_id*/
  INSERT INTO giuw_pol_dist
              (dist_no,par_id,policy_id,endt_type,tsi_amt,prem_amt,ann_tsi_amt,dist_flag,
              redist_flag,eff_date,expiry_date,negate_date,dist_type,item_posted_sw,ex_loss_sw,
              acct_ent_date,acct_neg_date,create_date,user_id,last_upd_date,auto_dist)
       VALUES (v_dist_no,p_par_id,p_policy_id,v_endt_type,
              v_tsi_amt,v_prem_amt,v_ann_tsi_amt,'1',1,v_eff_date,v_expiry_date,NULL,'1',
              --'N','N',NULL,NULL,SYSDATE,'user_id',SYSDATE,'N');
              'N','N',NULL,NULL,SYSDATE,v_user_id,SYSDATE,'N');
  
  p_dist_no := v_dist_no ;              
END;
/


