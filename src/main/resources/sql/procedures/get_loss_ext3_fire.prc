DROP PROCEDURE CPI.GET_LOSS_EXT3_FIRE;

CREATE OR REPLACE PROCEDURE CPI.get_loss_ext3_fire (p_loss_sw  IN VARCHAR2,
						 p_loss_fr  IN DATE,
                 	      p_loss_to  IN DATE,
			      p_line_cd  IN VARCHAR2,
			      p_subline  IN VARCHAR2) AS
/* BY: PAU
   DATE: 07FEB07
   REMARKS: MODIFIED TO ELIMINATE OUTER JOIN TO TWO DIFFERENT TABLES
*/
  TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
  TYPE item_no_tab          IS TABLE OF gicl_item_peril.item_no%TYPE;
  TYPE peril_cd_tab         IS TABLE OF gicl_item_peril.peril_cd%TYPE;
  TYPE risk_cd_tab         IS TABLE OF gicl_fire_dtl.risk_cd%TYPE;
  vv_claim_id				claim_id_tab;
  vv_loss_amt  	        	loss_amt_tab;
  vv_item_no				item_no_tab;
  vv_peril_cd				peril_cd_tab;
  vv_risk_cd				risk_cd_tab;
BEGIN
  DELETE FROM gicl_loss_profile_ext3;
  COMMIT;
  SELECT C003.claim_id,SUM((NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  nvl(c017b.recovered_amt, 0))) LOSS_AMT,
		 c003.risk_cd
	BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_risk_cd
	FROM (SELECT c018.claim_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
	   	 		 SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
  			FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018, gicl_fire_dtl c019
 		   WHERE NVL(c017.cancel_tag,'N') = 'N'
   		   	 AND c018.claim_id = c019.claim_id
 		   GROUP BY c018.claim_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
		 (select a.claim_id, c.loss_reserve, c.expense_reserve,
	   			 d.risk_cd, a.clm_stat_cd,
	   			 b.close_flag, c.dist_sw,
	   			 a.loss_date, a.clm_file_date,
	   			 a.line_cd, a.subline_cd
  			from gicl_claims a, gicl_item_peril b, gicl_clm_res_hist c, gicl_fire_dtl d
 		   where a.claim_id = b.claim_id
   		     and b.claim_id = c.claim_id
   			 and c.claim_id = d.claim_id) c003
   WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
     AND c003.claim_id         = c017B.claim_id(+)
   	 AND NVL(c003.close_flag, 'AP') IN ('AP','CC','CP')
   	 AND NVL(c003.dist_sw,'N') = 'Y'
   	 AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
     	                  'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
     AND c003.claim_id >= 0
     AND c003.line_cd = p_line_cd
     AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
   GROUP BY C003.claim_id, c003.risk_cd;
  IF SQL%FOUND THEN
    FORALL i IN vv_claim_id.first..vv_claim_id.last
	  INSERT INTO gicl_loss_profile_ext3(claim_id,        loss_amt,       close_sw,	  risk_cd)
	  VALUES (vv_claim_id(i),  vv_loss_amt(i), 'N', vv_risk_cd(i));
      COMMIT;
    vv_claim_id.DELETE;
     vv_loss_amt.DELETE;
  END IF;
  SELECT C003.claim_id,SUM((NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  nvl(c017b.recovered_amt, 0))) LOSS_AMT,
		 c003.risk_cd
	BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_risk_cd
	FROM (SELECT c018.claim_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
	   	 		 SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
  			FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018, gicl_fire_dtl c019
 		   WHERE NVL(c017.cancel_tag,'N') = 'N'
   		   	 AND c018.claim_id = c019.claim_id
 		   GROUP BY c018.claim_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
		 (select a.claim_id, c.losses_paid, c.expenses_paid,
	   			 d.risk_cd, a.clm_stat_cd,
				 c.tran_id, c.cancel_tag,
				 a.loss_date, a.clm_file_date,
				 a.line_cd, a.subline_cd
  			from gicl_claims a, gicl_clm_res_hist c, gicl_fire_dtl d
 		   where a.claim_id = c.claim_id
   			 and c.claim_id = d.claim_id) c003
   WHERE c003.clm_stat_cd ='CD'
     AND c003.claim_id         = c017B.claim_id(+)
     AND c003.tran_id IS NOT NULL
     AND NVL(c003.cancel_tag, 'N') = 'N'
     AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
     AND c003.claim_id >= 0
     AND c003.line_cd = p_line_cd
     AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
   GROUP BY c003.claim_id, c003.risk_cd;
  IF SQL%FOUND THEN
     FORALL i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO gicl_loss_profile_ext3 (claim_id,        loss_amt,       close_sw,	  risk_cd)
	   VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y', vv_risk_cd(i));
       COMMIT;
  END IF;
END;
/


