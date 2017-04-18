DROP PROCEDURE CPI.DIST_GIUW_POL_DIST_2;

CREATE OR REPLACE PROCEDURE CPI.dist_giuw_pol_dist_2(
    p_dist_no       OUT     NUMBER,
    p_msg           OUT     VARCHAR2,
    p_new_policy_id  IN     gipi_polbasic.policy_id%TYPE,
    p_new_par_id     IN     gipi_polbasic.par_id%TYPE
) 
IS
  v_endt_type        gipi_polbasic.endt_type%TYPE;
  v_tsi_amt        gipi_polbasic.tsi_amt%TYPE;
  v_prem_amt        gipi_polbasic.prem_amt%TYPE;
  v_ann_tsi_amt        gipi_polbasic.ann_tsi_amt%TYPE;
  v_eff_date        gipi_polbasic.eff_date%TYPE;
  v_expiry_date        gipi_polbasic.expiry_date%TYPE;
  v_user_id        gipi_polbasic.user_id%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-14-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : dist_giuw_pol_dist program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Distribution Basic info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  BEGIN
    SELECT pol_dist_dist_no_s.NEXTVAL
      INTO p_dist_no
      FROM DUAL;
  EXCEPTION
    WHEN NO_DATA_FOUND then
       p_msg := 'Error in generating new distribution no.';
  END;
  SELECT endt_type,NVL(tsi_amt,0),NVL(prem_amt,0),NVL(ann_tsi_amt,0),eff_date,expiry_date,user_id
    INTO v_endt_type,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_eff_date,v_expiry_date,v_user_id
    FROM gipi_polbasic
   WHERE policy_id = p_new_policy_id;
  INSERT INTO giuw_pol_dist
              (dist_no,par_id,policy_id,endt_type,tsi_amt,prem_amt,ann_tsi_amt,dist_flag,
              redist_flag,eff_date,expiry_date,negate_date,dist_type,item_posted_sw,ex_loss_sw,
              acct_ent_date,acct_neg_date,create_date,user_id,last_upd_date)
       VALUES (p_dist_no,p_new_par_id,p_new_policy_id,v_endt_type,
              v_tsi_amt,v_prem_amt,v_ann_tsi_amt,'1',1,v_eff_date,v_expiry_date,NULL,'1',
              'N','N',NULL,NULL,SYSDATE,'user_id',SYSDATE);
END;
/


