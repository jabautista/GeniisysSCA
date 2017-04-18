DROP PROCEDURE CPI.GET_LOSS_EXT;

CREATE OR REPLACE PROCEDURE CPI.get_loss_ext (p_loss_sw  IN VARCHAR2,
		  			    p_loss_fr  IN DATE,
						p_loss_to  IN DATE,
						p_line_cd  IN VARCHAR2,
						p_subline  IN VARCHAR2) IS

  TYPE cnt_clm_tab         IS TABLE OF gicl_loss_profile_ext.cnt_clm%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  vv_cnt_clm           	   cnt_clm_tab;
  vv_line_cd		   	   line_cd_tab;
  vv_subline_cd		   	   subline_cd_tab;
  vv_pol_iss_cd		       pol_iss_cd_tab;
  vv_issue_yy		   	   issue_yy_tab;
  vv_pol_seq_no		       pol_seq_no_tab;
  vv_renew_no		   	   renew_no_tab;

BEGIN

  DELETE FROM gicl_loss_profile_ext;
  COMMIT;
  SELECT COUNT(c003.claim_id) cnt_clm,
             c003.line_cd,
			 c003.subline_cd,
             c003.pol_iss_cd,
			 c003.issue_yy,
			 c003.pol_seq_no,
			 c003.renew_no
  bulk collect INTO
             vv_cnt_clm,
			 vv_line_cd,
			 vv_subline_cd,
			 vv_pol_iss_cd,
			 vv_issue_yy,
			 vv_pol_seq_no,
			 vv_renew_no
  FROM gicl_claims c003
 WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
   AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                        'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
   AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                        'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
   AND c003.claim_id >= 0
   AND c003.line_cd = p_line_cd
   AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
 GROUP BY c003.line_cd,
	   c003.subline_cd,
	   c003.pol_iss_cd,
       c003.issue_yy,
	   c003.pol_seq_no,
       c003.renew_no;
  IF SQL%FOUND THEN
     forall i IN vv_line_cd.first..vv_line_cd.last
	   INSERT INTO gicl_loss_profile_ext
	     (cnt_clm, 						line_cd,  	   		 subline_cd,
		  pol_iss_cd,					issue_yy,			 pol_seq_no,
		  renew_no)
	   VALUES
		 (vv_cnt_clm(i),				vv_line_cd(i),		 vv_subline_cd(i),
		  vv_pol_iss_cd(i),				vv_issue_yy(i),		 vv_pol_seq_no(i),
		  vv_renew_no(i));
  COMMIT;
  END IF;
END;
/


