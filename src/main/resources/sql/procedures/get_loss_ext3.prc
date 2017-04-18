DROP PROCEDURE CPI.GET_LOSS_EXT3;

CREATE OR REPLACE PROCEDURE CPI.get_loss_ext3 (p_loss_sw  IN VARCHAR2,
		  			    p_loss_fr  IN DATE,
                 			    p_loss_to  IN DATE,
					   p_line_cd  IN VARCHAR2,
						p_subline  IN VARCHAR2) IS

  TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
  vv_claim_id		claim_id_tab;
  vv_loss_amt  	        loss_amt_tab;
BEGIN
  DELETE FROM gicl_loss_profile_ext3;
  COMMIT;
  SELECT C003.claim_id,(NVL(loss_res_amt,0) + NVL(exp_res_amt,0) -  nvl(c017b.recovered_amt, 0)) LOSS_AMT
	bulk collect INTO vv_claim_id, vv_loss_amt
   FROM gicl_claims c003,
        (SELECT claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
		        SUM(NVL(c017.recovered_amt,0)) recovered_amt
           FROM gicl_recovery_payt c017
          WHERE NVL(c017.cancel_tag,'N') = 'N'
         GROUP BY claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B
  WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
   AND c003.claim_id         = c017B.claim_id(+)
   AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
   AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                        'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
   AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                        'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
   AND c003.claim_id >= 0
   AND c003.line_cd = p_line_cd
   AND c003.subline_cd = NVL(p_subline,c003.subline_cd);
  IF SQL%FOUND THEN
     forall i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO gicl_loss_profile_ext3
	     (claim_id,        loss_amt,       close_sw)
	   VALUES
	     (vv_claim_id(i),  vv_loss_amt(i),'N');
  COMMIT;
  vv_claim_id.DELETE;
  vv_loss_amt.DELETE;
  END IF;
  SELECT C003.claim_id,(NVL(loss_pd_amt,0) + NVL(exp_pd_amt,0) -  nvl(c017b.recovered_amt, 0)) LOSS_AMT
	bulk collect INTO vv_claim_id, vv_loss_amt
   FROM gicl_claims c003,
        (SELECT claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
		        SUM(NVL(c017.recovered_amt,0)) recovered_amt
           FROM gicl_recovery_payt c017
          WHERE NVL(c017.cancel_tag,'N') = 'N'
         GROUP BY claim_id, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B
  WHERE c003.clm_stat_cd ='CD'
   AND c003.claim_id         = c017B.claim_id(+)
   AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
   AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                        'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
   AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                        'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
   AND c003.claim_id >= 0
   AND c003.line_cd = p_line_cd
   AND c003.subline_cd = NVL(p_subline,c003.subline_cd);
  IF SQL%FOUND THEN
     forall i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO gicl_loss_profile_ext3
	     (claim_id,        loss_amt,       close_sw)
	   VALUES
	     (vv_claim_id(i),  vv_loss_amt(i),'Y');
  COMMIT;
  END IF;
END;
/


