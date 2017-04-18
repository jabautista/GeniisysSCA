CREATE OR REPLACE PACKAGE BODY CPI.Extract_Loss_Profile AS
/* BY: PAU 
   DATE: 28NOV06
   REMARKS: COMPILATION OF LOSS EXTRACT PROCEDURES
*/
/* BY:PAU 
   DATE: 08FEB07 
   REMARKS: MODIFIED GET_LOSS_EXT3_PERIL, GET_LOSS_EXT3_FIRE, GET_LOSS_EXT3_MOTOR,
*/   
PROCEDURE Get_Loss_Ext (p_loss_sw  IN VARCHAR2,
		  	p_loss_fr  IN DATE,
			p_loss_to  IN DATE,
			p_line_cd  IN VARCHAR2,
			p_subline  IN VARCHAR2) AS
  TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
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
  DELETE FROM GICL_LOSS_PROFILE_EXT;
  COMMIT;
  SELECT COUNT(c003.claim_id) cnt_clm,
             c003.line_cd,
			 c003.subline_cd,
             c003.pol_iss_cd,
			 c003.issue_yy,
			 c003.pol_seq_no,
			 c003.renew_no
  BULK COLLECT INTO
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
     FORALL i IN vv_line_cd.first..vv_line_cd.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT
	     (cnt_clm, 						line_cd,  	   		 subline_cd,
		  pol_iss_cd,					issue_yy,			 pol_seq_no,
		  renew_no)
	   VALUES
		 (vv_cnt_clm(i),				vv_line_cd(i),		 vv_subline_cd(i),
		  vv_pol_iss_cd(i),				vv_issue_yy(i),		 vv_pol_seq_no(i),
		  vv_renew_no(i));
  COMMIT;
  END IF;
END Get_Loss_Ext;
PROCEDURE Get_Loss_Ext2 (p_pol_sw  IN VARCHAR2,
		         p_date_fr  IN DATE,
			 p_date_to  IN DATE,
			 p_line_cd  IN VARCHAR2,
			 p_subline  IN VARCHAR2) AS
  TYPE tsi_amt_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  vv_tsi_amt           	   tsi_amt_tab;
  vv_line_cd		   line_cd_tab;
  vv_subline_cd		   subline_cd_tab;
  vv_pol_iss_cd		   pol_iss_cd_tab;
  vv_issue_yy		   issue_yy_tab;
  vv_pol_seq_no		   pol_seq_no_tab;
  vv_renew_no		   renew_no_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT2;
  COMMIT;
  SELECT SUM(NVL(b250.tsi_amt,0))  tsi_amt,
         b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no
    BULK COLLECT INTO
	 vv_tsi_amt,
	 vv_line_cd,
	 vv_subline_cd,
	 vv_pol_iss_cd,
	 vv_issue_yy,
	 vv_pol_seq_no,
	 vv_renew_no
    FROM gipi_polbasic b250
   WHERE 1 = 1
     AND b250.line_cd    = p_line_cd
     AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         >= TRUNC(p_date_fr)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         <= TRUNC(p_date_to)
     -- BETH 11182002 consider spoiled accounting entry date
     AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1))
         > TRUNC(p_date_to)
     --end of UPDATE (beth)
     AND POL_FLAG IN ('1','2','3','X')
     AND DIST_FLAG      = '3'
     AND EXISTS (SELECT 1
	          FROM GICL_LOSS_PROFILE_EXT B
	         WHERE B250.LINE_CD = B.LINE_CD
                   AND B250.SUBLINE_CD = B.SUBLINE_cD
                   AND B250.ISS_CD = B.POL_ISS_CD
                   AND B250.ISSUE_YY = B.ISSUE_YY
		   AND B250.POL_SEQ_NO = B.POL_SEQ_NO
		   AND B250.RENEW_NO = B.RENEW_NO)
     -->inserted by mon 090902
     --if policy is not within given date of parameters, its endt will not be included
     AND (b250.endt_seq_no = 0
      OR (b250.endt_seq_no <> 0
           AND EXISTS (SELECT 1
 	                 FROM gipi_polbasic c
                        WHERE b250.line_cd = c.line_cd
                          AND b250.subline_cd = c.subline_cd
 			  AND b250.iss_cd = c.iss_cd
			  AND b250.issue_yy = c.issue_yy
			  AND b250.pol_seq_no = c.pol_seq_no
			  AND b250.renew_no = c.renew_no
			  AND b250.endt_seq_no = 0
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
                                      ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              >= TRUNC(p_date_fr)
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
  			              ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              <= TRUNC(p_date_to))))
     --end of inserted statement
     GROUP BY b250.line_cd,
	      b250.subline_cd,
	      b250.iss_cd,
              b250.issue_yy,
	      b250.pol_seq_no,
	      b250.renew_no;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
       INSERT INTO GICL_LOSS_PROFILE_EXT2
	           (tsi_amt, 						line_cd,  	   		 subline_cd,
	            pol_iss_cd,					issue_yy,			 pol_seq_no,
		    renew_no)
	    VALUES (vv_tsi_amt(i),				vv_line_cd(i),		 vv_subline_cd(i),
		    vv_pol_iss_cd(i),				vv_issue_yy(i),		 vv_pol_seq_no(i),
		    vv_renew_no(i));
  COMMIT;
  END IF;
END Get_Loss_Ext2;
PROCEDURE Get_Loss_Ext3 (p_loss_sw  IN VARCHAR2,
		  	 p_loss_fr  IN DATE,
                 	 p_loss_to  IN DATE,
			 p_line_cd  IN VARCHAR2,
			 p_subline  IN VARCHAR2) AS
  TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
  vv_claim_id		claim_id_tab;
  vv_loss_amt  	        loss_amt_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT3;
  COMMIT;
  SELECT C003.claim_id,(NVL(loss_res_amt,0) + NVL(exp_res_amt,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT
	BULK COLLECT INTO vv_claim_id, vv_loss_amt
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
     FORALL i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT3
	     (claim_id,        loss_amt,       close_sw)
	   VALUES
	     (vv_claim_id(i),  vv_loss_amt(i),'N');
  COMMIT;
  vv_claim_id.DELETE;
  vv_loss_amt.DELETE;
  END IF;
  SELECT C003.claim_id,(NVL(loss_pd_amt,0) + NVL(exp_pd_amt,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT
	BULK COLLECT INTO vv_claim_id, vv_loss_amt
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
     FORALL i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT3
	     (claim_id,        loss_amt,       close_sw)
	   VALUES
	     (vv_claim_id(i),  vv_loss_amt(i),'Y');
  COMMIT;
  END IF;
END Get_Loss_Ext3;
PROCEDURE Get_Loss_Ext_Peril (p_loss_sw  IN VARCHAR2,
		  	      p_loss_fr   IN DATE,
			      p_loss_to   IN DATE,
			      p_line_cd   IN VARCHAR2,
		              p_subline   IN VARCHAR2) AS
  TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE item_no_tab         IS TABLE OF gicl_item_peril.item_no%TYPE; 
  vv_cnt_clm           	   cnt_clm_tab;
  vv_line_cd		   	   line_cd_tab;
  vv_subline_cd		   	   subline_cd_tab;
  vv_pol_iss_cd		       pol_iss_cd_tab;
  vv_issue_yy		   	   issue_yy_tab;
  vv_pol_seq_no		       pol_seq_no_tab;
  vv_renew_no		   	   renew_no_tab;
  vv_peril_cd		   	   peril_cd_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT;
  COMMIT;
  SELECT COUNT(c003.claim_id) cnt_clm,
             c003.line_cd,
			 c003.subline_cd,
             c003.pol_iss_cd,
			 c003.issue_yy,
			 c003.pol_seq_no,
			 c003.renew_no,
			 c002.peril_cd
     BULK COLLECT INTO
             vv_cnt_clm,
			 vv_line_cd,
			 vv_subline_cd,
			 vv_pol_iss_cd,
			 vv_issue_yy,
			 vv_pol_seq_no,
			 vv_renew_no,
			 vv_peril_cd
        FROM gicl_claims c003, gicl_item_peril c002
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
	     AND c003.claim_id = c002.claim_id 
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
             c003.renew_no,
			 c002.peril_cd;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT
	     (cnt_clm, 						line_cd,  	   		 subline_cd,
		  pol_iss_cd,					issue_yy,			 pol_seq_no,
		  renew_no,                     peril_cd)
	   VALUES
		 (vv_cnt_clm(i),				vv_line_cd(i),		 vv_subline_cd(i),
		  vv_pol_iss_cd(i),				vv_issue_yy(i),		 vv_pol_seq_no(i),
		  vv_renew_no(i),               vv_peril_cd(i));	     
  COMMIT;
  END IF;
END Get_Loss_Ext_Peril;
PROCEDURE Get_Loss_Ext2_Peril (p_pol_sw  IN VARCHAR2,
		               p_date_fr  IN DATE,
			       p_date_to  IN DATE,
			       p_line_cd  IN VARCHAR2,
			       p_subline  IN VARCHAR2) AS
  TYPE tsi_amt_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE tarf_cd_tab         IS TABLE OF giis_tariff.tarf_cd%TYPE;
  vv_tsi_amt           	   tsi_amt_tab;
  vv_line_cd		   line_cd_tab;
  vv_subline_cd		   subline_cd_tab;
  vv_pol_iss_cd		   pol_iss_cd_tab;
  vv_issue_yy		   issue_yy_tab;
  vv_pol_seq_no		   pol_seq_no_tab;
  vv_renew_no		   renew_no_tab;
  vv_peril_cd		   	   peril_cd_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT2;
  COMMIT;
  SELECT SUM(NVL(c250.tsi_amt,0) * NVL(d250.currency_rt,1))  tsi_amt,
         b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no,
		 c250.peril_cd
    BULK COLLECT INTO
	 vv_tsi_amt,
	 vv_line_cd,
	 vv_subline_cd,
	 vv_pol_iss_cd,
	 vv_issue_yy,
	 vv_pol_seq_no,
	 vv_renew_no,
	 vv_peril_cd
    FROM gipi_polbasic b250, gipi_itmperil c250, gipi_item d250
   WHERE 1 = 1
     AND b250.policy_id  = d250.policy_id
	 AND d250.policy_id  = c250.policy_id
	 AND d250.item_no  = c250.item_no
     AND b250.line_cd    = p_line_cd
     AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         >= TRUNC(p_date_fr)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         <= TRUNC(p_date_to)
     -- BETH 11182002 consider spoiled accounting entry date
     AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1))
         > TRUNC(p_date_to)
     --end of UPDATE (beth)
     AND POL_FLAG IN ('1','2','3','X')
     AND DIST_FLAG      = '3'
     AND EXISTS (SELECT 1
	          FROM GICL_LOSS_PROFILE_EXT B
	         WHERE B250.LINE_CD = B.LINE_CD
                   AND B250.SUBLINE_CD = B.SUBLINE_cD
                   AND B250.ISS_CD = B.POL_ISS_CD
                   AND B250.ISSUE_YY = B.ISSUE_YY
		   AND B250.POL_SEQ_NO = B.POL_SEQ_NO
		   AND B250.RENEW_NO = B.RENEW_NO
		   AND C250.PERIL_CD = B.PERIL_CD)
     -->inserted by mon 090902
     --if policy is not within given date of parameters, its endt will not be included
     AND (b250.endt_seq_no = 0
      OR (b250.endt_seq_no <> 0
           AND EXISTS (SELECT 1
 	                 FROM gipi_polbasic c
                        WHERE b250.line_cd = c.line_cd
                          AND b250.subline_cd = c.subline_cd
 			  AND b250.iss_cd = c.iss_cd
			  AND b250.issue_yy = c.issue_yy
			  AND b250.pol_seq_no = c.pol_seq_no
			  AND b250.renew_no = c.renew_no
			  AND b250.endt_seq_no = 0
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
                                      ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              >= TRUNC(p_date_fr)
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
  			              ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              <= TRUNC(p_date_to))))
     --end of inserted statement
     GROUP BY b250.line_cd,
	      b250.subline_cd,
	      b250.iss_cd,
              b250.issue_yy,
	      b250.pol_seq_no,
	      b250.renew_no,
		  c250.peril_cd;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
       INSERT INTO GICL_LOSS_PROFILE_EXT2
	           (tsi_amt, 					line_cd,  	   		 subline_cd,
	            pol_iss_cd,					issue_yy,			 pol_seq_no,
		        renew_no,                   peril_cd)
	    VALUES (vv_tsi_amt(i),				vv_line_cd(i),		 vv_subline_cd(i),
  		       vv_pol_iss_cd(i),			vv_issue_yy(i),		 vv_pol_seq_no(i),
		       vv_renew_no(i),              vv_peril_cd(i));
  COMMIT;
  END IF;
END Get_Loss_Ext2_Peril;
PROCEDURE Get_Loss_Ext3_Peril (p_loss_sw  IN VARCHAR2,
	   	     	  		  		   			     p_loss_fr  IN DATE,
                 			               		 p_loss_to  IN DATE,
					   							 p_line_cd  IN VARCHAR2,
												 p_subline  IN VARCHAR2) AS
/* BY: PAU 
   DATE: 08FEB07 
   REMARKS: MODIFIED TO ELIMINATE OUTER JOIN TO TWO DIFFERENT TABLES 
*/
  TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
  TYPE peril_cd_tab         IS TABLE OF gicl_item_peril.peril_cd%TYPE;
  vv_claim_id				claim_id_tab;
  vv_loss_amt  	        	loss_amt_tab;
  vv_peril_cd				peril_cd_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT3;
  COMMIT;
  SELECT C003.claim_id,SUM((NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  NVL(c017b.recovered_amt, 0))) LOSS_AMT,
       	 c003.peril_cd
    BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_peril_cd
  	FROM (SELECT c018.claim_id, c018.peril_cd peril_cd,TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
		  		 SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
          	FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
           WHERE NVL(c017.cancel_tag,'N') = 'N'
           GROUP BY c018.claim_id, c018.peril_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
	     (SELECT A.claim_id, c.loss_reserve,
		 		 c.expense_reserve, b.peril_cd,
				 A.clm_stat_cd, b.close_flag,
				 c.dist_sw, A.clm_file_date,
				 A.loss_date, A.line_cd,
				 A.subline_cd
  	   	    FROM gicl_claims A, gicl_item_peril b, gicl_clm_res_hist c
 		   WHERE A.claim_id = b.claim_id
   		     AND b.claim_id = c.claim_id
   		     AND b.peril_cd = c.peril_cd) c003
   WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
     AND c003.claim_id         = c017B.claim_id(+)
     AND c003.peril_cd         = c017B.peril_cd(+)
     AND NVL(c003.close_flag, 'AP') IN ('AP','CC','CP')
     AND NVL(c003.dist_sw,'N') = 'Y'
     AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
     AND c003.claim_id >= 0
     AND c003.line_cd = p_line_cd
     AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
   GROUP BY C003.claim_id, c003.peril_cd;
  IF SQL%FOUND THEN
    FORALL i IN vv_claim_id.first..vv_claim_id.last
	  INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw, peril_cd)
	  VALUES (vv_claim_id(i),  vv_loss_amt(i),'N', vv_peril_cd(i));
      COMMIT;
      vv_claim_id.DELETE;
      vv_loss_amt.DELETE;
      vv_peril_cd.DELETE;
  END IF;
  SELECT C003.claim_id,SUM (NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT,
         c003.peril_cd
	BULK COLLECT INTO vv_claim_id, vv_loss_amt,vv_peril_cd
    FROM (SELECT c018.claim_id, c018.peril_cd,TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
		         SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
            FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
           WHERE NVL(c017.cancel_tag,'N') = 'N'
           GROUP BY c018.claim_id, c018.peril_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
	     (SELECT A.claim_id, b.losses_paid,
       	 		 b.expenses_paid, b.peril_cd,
	   			 A.clm_stat_cd, b.tran_id,
	   			 b.cancel_tag, A.loss_date lossdate,
	   			 A.clm_file_date, A.loss_date,
	   			 A.line_cd, A.subline_cd
  			FROM gicl_claims A, gicl_clm_res_hist b
 		   WHERE A.claim_id = b.claim_id) c003
   WHERE c003.clm_stat_cd ='CD'
     AND c003.claim_id         = c017B.claim_id(+)
     AND c003.peril_cd         = c017B.peril_cd(+)
     AND c003.tran_id IS NOT NULL
     AND NVL(c003.cancel_tag, 'N') = 'N'
     AND TO_NUMBER(TO_CHAR(c003.lossdate,'YYYY'))= C017B.TRAN_YEAR(+)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.lossdate),SYSDATE) >=TRUNC(p_loss_fr)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.lossdate),SYSDATE) <=TRUNC(p_loss_to)
     AND c003.claim_id >= 0
     AND c003.line_cd = p_line_cd
     AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
   GROUP BY c003.claim_id, c003.peril_cd;
  IF SQL%FOUND THEN
    FORALL i IN vv_claim_id.first..vv_claim_id.last
	  INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw,  peril_cd)
	  VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y',       vv_peril_cd(i));
  	  COMMIT;
  END IF;
END Get_Loss_Ext3_Peril;
PROCEDURE Get_Loss_Ext_Fire (p_loss_sw  IN VARCHAR2,
           p_loss_fr   IN DATE,
      p_loss_to   IN DATE,
      p_line_cd   IN VARCHAR2,
      p_subline   IN VARCHAR2) AS
--pau 24NOV06
--removed item_no and peril_cd, replaced tarf_cd with risk_cd
  TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  --TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  --TYPE item_no_tab         IS TABLE OF gicl_item_peril.item_no%TYPE;
  TYPE risk_cd_tab         IS TABLE OF GICL_FIRE_DTL.risk_cd%TYPE;
  TYPE block_id_tab        IS TABLE OF GIIS_RISKS.block_id%TYPE; --pau 02/20/07 
  vv_cnt_clm               cnt_clm_tab;
  vv_line_cd         line_cd_tab;
  vv_subline_cd         subline_cd_tab;
  vv_pol_iss_cd         pol_iss_cd_tab;
  vv_issue_yy         issue_yy_tab;
  vv_pol_seq_no         pol_seq_no_tab;
  vv_renew_no         renew_no_tab;
  --vv_peril_cd         peril_cd_tab;
  --vv_item_no         item_no_tab;
  vv_risk_cd         risk_cd_tab;
  vv_block_id		   block_id_tab; --pau 02/20/07 
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT;
  COMMIT;
    SELECT COUNT(c003.claim_id) cnt_clm,
             c003.line_cd,
    c003.subline_cd,
             c003.pol_iss_cd,
    c003.issue_yy,
    c003.pol_seq_no,
    c003.renew_no,
    --c002.peril_cd,
    --c002.item_no,
	c001.block_id,
    c001.risk_cd
     BULK COLLECT INTO
             vv_cnt_clm,
    vv_line_cd,
    vv_subline_cd,
    vv_pol_iss_cd,
    vv_issue_yy,
    vv_pol_seq_no,
    vv_renew_no,
    --vv_peril_cd,
    --vv_item_no,
	vv_block_id,
    vv_risk_cd
        FROM gicl_claims c003, 
		     --gicl_item_peril c002, 
			 GICL_FIRE_DTL c001
       WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
         --AND c003.claim_id = c002.claim_id
         AND c003.claim_id = c001.claim_id
   --AND c002.item_no  = c001.item_no
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
             c003.renew_no,
    --c002.peril_cd,
    --c002.item_no,
	c001.block_id,
    c001.risk_cd;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
    INSERT INTO GICL_LOSS_PROFILE_EXT
      (cnt_clm,       line_cd,         subline_cd,
    pol_iss_cd,     issue_yy,    pol_seq_no,
    renew_no,
    --item_no,
    --peril_cd,
	block_id,
    risk_cd)
    VALUES
   (vv_cnt_clm(i),    vv_line_cd(i),   vv_subline_cd(i),
    vv_pol_iss_cd(i),    vv_issue_yy(i),   vv_pol_seq_no(i),
    vv_renew_no(i),
    --vv_item_no(i),
    --vv_peril_cd(i),
	vv_block_id(i),
    vv_risk_cd(i));
  COMMIT;
  END IF;
END Get_Loss_Ext_Fire;
PROCEDURE Get_Loss_Ext2_Fire (p_pol_sw  IN VARCHAR2,
		          							   	p_date_fr  IN DATE,
											 	p_date_to  IN DATE,
											 	p_line_cd  IN VARCHAR2,
											 	p_subline  IN VARCHAR2) 
AS
--modified by pau 24nov06
--added risk_cd in select
  TYPE tsi_amt_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  --TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  --TYPE tarf_cd_tab         IS TABLE OF giis_tariff.tarf_cd%TYPE;
  TYPE risk_cd_tab         IS TABLE OF GICL_FIRE_DTL.risk_cd%TYPE;
  --TYPE item_no_tab         IS TABLE OF gipi_item.item_no%TYPE;
  TYPE block_id_tab        IS TABLE OF GIIS_RISKS.block_id%TYPE; --pau 02/20/07 
  vv_tsi_amt           	   tsi_amt_tab;
  vv_line_cd		   line_cd_tab;
  vv_subline_cd		   subline_cd_tab;
  vv_pol_iss_cd		   pol_iss_cd_tab;
  vv_issue_yy		   issue_yy_tab;
  vv_pol_seq_no		   pol_seq_no_tab;  
  vv_renew_no		   renew_no_tab;
  --vv_peril_cd		   peril_cd_tab;
  --vv_item_no		   item_no_tab;
  vv_risk_cd		   risk_cd_tab;
  vv_block_id		   block_id_tab; --pau 02/20/07 
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT2;
  COMMIT;
  SELECT SUM(NVL(c250.tsi_amt,0) * NVL(d250.currency_rt,1))  tsi_amt,
         b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no,
		 --c250.peril_cd, 
		 --c250.item_no, 
		 e250.block_id,
		 e250.risk_cd
    BULK COLLECT INTO
		 vv_tsi_amt,
		 vv_line_cd,
	 	 vv_subline_cd,
	 	 vv_pol_iss_cd,
	 	 vv_issue_yy,
	 	 vv_pol_seq_no,
	 	 vv_renew_no,
	 	 --vv_peril_cd,
	 	 --vv_item_no,
		 vv_block_id,
		 vv_risk_cd
    FROM gipi_polbasic b250, gipi_itmperil c250, gipi_item d250, GICL_FIRE_DTL e250
   WHERE 1 = 1
     AND b250.policy_id  = d250.policy_id
	 AND d250.policy_id  = c250.policy_id
	 --AND d250.item_no  	 = c250.item_no
     AND b250.line_cd    = p_line_cd
     AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         >= TRUNC(p_date_fr)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         <= TRUNC(p_date_to)
     -- BETH 11182002 consider spoiled accounting entry date
     AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1))
         > TRUNC(p_date_to)
     --end of UPDATE (beth)
     AND POL_FLAG IN ('1','2','3','X')
     AND DIST_FLAG      = '3'
     AND EXISTS (SELECT 1
	          	   FROM GICL_LOSS_PROFILE_EXT B
	              WHERE B250.LINE_CD = B.LINE_CD
                    AND B250.SUBLINE_CD = B.SUBLINE_cD
                    AND B250.ISS_CD = B.POL_ISS_CD
                    AND B250.ISSUE_YY = B.ISSUE_YY
		   			AND B250.POL_SEQ_NO = B.POL_SEQ_NO
		   			AND B250.RENEW_NO = B.RENEW_NO)
	 --pau 24nov06
	 AND e250.claim_id IN (SELECT claim_id
	                         FROM gicl_claims
							WHERE B250.LINE_CD = gicl_claims.LINE_CD
                              AND B250.SUBLINE_CD = gicl_claims.SUBLINE_cD
                              AND B250.ISS_CD = gicl_claims.POL_ISS_CD
                              AND B250.ISSUE_YY = gicl_claims.ISSUE_YY
		   			          AND B250.POL_SEQ_NO = gicl_claims.POL_SEQ_NO
		   			          AND B250.RENEW_NO = gicl_claims.RENEW_NO)
     -->inserted by mon 090902
     --if policy is not within given date of parameters, its endt will not be included
     AND (b250.endt_seq_no = 0
      OR (b250.endt_seq_no <> 0
           AND EXISTS (SELECT 1
 	                     FROM gipi_polbasic c
                        WHERE b250.line_cd = c.line_cd
                          AND b250.subline_cd = c.subline_cd
						  AND b250.iss_cd = c.iss_cd
			  			  AND b250.issue_yy = c.issue_yy
			  			  AND b250.pol_seq_no = c.pol_seq_no
			  			  AND b250.renew_no = c.renew_no
			  			  AND b250.endt_seq_no = 0
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
                                      		  ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              		  		  >= TRUNC(p_date_fr)
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
  			              					  ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              				  <= TRUNC(p_date_to))))
     --end of inserted statement
   GROUP BY b250.line_cd,
	        b250.subline_cd,
	      	b250.iss_cd,
            b250.issue_yy,
	      	b250.pol_seq_no,
	      	b250.renew_no,
		  	--c250.peril_cd,
		  	--c250.item_no,
			e250.block_id,
			e250.risk_cd;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
       INSERT INTO GICL_LOSS_PROFILE_EXT2
	           (tsi_amt, 					line_cd,  	   		 subline_cd,
	            pol_iss_cd,					issue_yy,			 pol_seq_no,
		        renew_no,                   
				--peril_cd,            
				--item_no,
				block_id,
				risk_cd)
	    VALUES (vv_tsi_amt(i),				vv_line_cd(i),		 vv_subline_cd(i),
  		        vv_pol_iss_cd(i),			vv_issue_yy(i),		 vv_pol_seq_no(i),
		        vv_renew_no(i),             
				--vv_peril_cd(i),      
				--vv_item_no(i),
				vv_block_id(i),
				vv_risk_cd(i));
  COMMIT;
  END IF;
END Get_Loss_Ext2_Fire;
PROCEDURE Get_Loss_Ext3_Fire (p_loss_sw  IN VARCHAR2,
	   	     	  		  		   			    p_loss_fr  IN DATE,
                 			               		p_loss_to  IN DATE,
					   							p_line_cd  IN VARCHAR2,
												p_subline  IN VARCHAR2) AS
/* BY: PAU 
   DATE: 08FEB07 
   REMARKS: MODIFIED TO ELIMINATE OUTER JOIN TO TWO DIFFERENT TABLES 
*/
  TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
  TYPE item_no_tab          IS TABLE OF gicl_item_peril.item_no%TYPE;
  TYPE peril_cd_tab         IS TABLE OF gicl_item_peril.peril_cd%TYPE;
  TYPE block_id_tab        IS TABLE OF GIIS_RISKS.block_id%TYPE; --pau 02/20/07 
  TYPE risk_cd_tab         IS TABLE OF GICL_FIRE_DTL.risk_cd%TYPE;
  vv_claim_id				claim_id_tab;
  vv_loss_amt  	        	loss_amt_tab;
  vv_item_no				item_no_tab;
  vv_peril_cd				peril_cd_tab;
  vv_block_id		   		block_id_tab; --pau 02/20/07 
  vv_risk_cd				risk_cd_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT3;
  COMMIT;
  SELECT C003.claim_id,SUM((NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  NVL(c017b.recovered_amt, 0))) LOSS_AMT,
  		 c003.block_id,
		 c003.risk_cd
	BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_block_id, vv_risk_cd
	FROM (SELECT c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
	   	 		 SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
  			FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018, GICL_FIRE_DTL c019
 		   WHERE NVL(c017.cancel_tag,'N') = 'N'
   		   	 AND c018.claim_id = c019.claim_id
 		   GROUP BY c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
		 (SELECT A.claim_id, c.loss_reserve, c.expense_reserve,
	   			 d.block_id, d.risk_cd, A.clm_stat_cd,
	   			 b.close_flag, c.dist_sw,
	   			 A.loss_date, A.clm_file_date,
	   			 A.line_cd, A.subline_cd
  			FROM gicl_claims A, gicl_item_peril b, gicl_clm_res_hist c, GICL_FIRE_DTL d
 		   WHERE A.claim_id = b.claim_id
   		     AND b.claim_id = c.claim_id
   			 AND c.claim_id = d.claim_id) c003
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
   GROUP BY C003.claim_id, c003.block_id, c003.risk_cd;
  IF SQL%FOUND THEN
    FORALL i IN vv_claim_id.first..vv_claim_id.last
	  INSERT INTO GICL_LOSS_PROFILE_EXT3(claim_id,        loss_amt,       close_sw,	  block_id,	  risk_cd)
	  VALUES (vv_claim_id(i),  vv_loss_amt(i), 'N', vv_block_id(i), vv_risk_cd(i));
      COMMIT;
    vv_claim_id.DELETE;
    vv_loss_amt.DELETE;
	vv_block_id.DELETE;
	vv_risk_cd.DELETE;
  END IF;
  SELECT C003.claim_id,SUM((NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  NVL(c017b.recovered_amt, 0))) LOSS_AMT,
		 c003.block_id,
		 c003.risk_cd
	BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_block_id, vv_risk_cd
	FROM (SELECT c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
	   	 		 SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
  			FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018, GICL_FIRE_DTL c019
 		   WHERE NVL(c017.cancel_tag,'N') = 'N'
   		   	 AND c018.claim_id = c019.claim_id
 		   GROUP BY c018.claim_id, c019.block_id, c019.risk_cd, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
		 (SELECT A.claim_id, c.losses_paid, c.expenses_paid,
	   			 d.block_id, d.risk_cd, A.clm_stat_cd,
				 c.tran_id, c.cancel_tag,
				 A.loss_date, A.clm_file_date,
				 A.line_cd, A.subline_cd
  			FROM gicl_claims A, gicl_clm_res_hist c, GICL_FIRE_DTL d
 		   WHERE A.claim_id = c.claim_id
   			 AND c.claim_id = d.claim_id) c003
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
   GROUP BY c003.claim_id, c003.block_id, c003.risk_cd;
  IF SQL%FOUND THEN
     FORALL i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw,	  block_id,  risk_cd)
	   VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y', vv_block_id(i), vv_risk_cd(i));
       COMMIT;
  END IF;
END Get_Loss_Ext3_Fire;
PROCEDURE Get_Loss_Ext_Motor (p_loss_sw  IN VARCHAR2,
           p_loss_fr   IN DATE,
      p_loss_to   IN DATE,
      p_line_cd   IN VARCHAR2,
      p_subline   IN VARCHAR2) AS
--pau 23nov06
--copied from original get_loss_ext_fire
  TYPE cnt_clm_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT.cnt_clm%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  --TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE item_no_tab         IS TABLE OF gicl_item_peril.item_no%TYPE;
  vv_cnt_clm               cnt_clm_tab;
  vv_line_cd         line_cd_tab;
  vv_subline_cd         subline_cd_tab;
  vv_pol_iss_cd         pol_iss_cd_tab;
  vv_issue_yy         issue_yy_tab;
  vv_pol_seq_no         pol_seq_no_tab;
  vv_renew_no         renew_no_tab;
  --vv_peril_cd         peril_cd_tab;
  vv_item_no         item_no_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT;
  COMMIT;
    SELECT COUNT(c003.claim_id) cnt_clm,
             c003.line_cd,
    c003.subline_cd,
             c003.pol_iss_cd,
    c003.issue_yy,
    c003.pol_seq_no,
    c003.renew_no,
    --c002.peril_cd,
    c002.item_no
     BULK COLLECT INTO
             vv_cnt_clm,
    vv_line_cd,
    vv_subline_cd,
    vv_pol_iss_cd,
    vv_issue_yy,
    vv_pol_seq_no,
    vv_renew_no,
    --vv_peril_cd,
    vv_item_no
      FROM gicl_claims c003, gicl_item_peril c002, gicl_motor_car_dtl c001
     WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC')
       AND c003.claim_id = c002.claim_id
       AND c003.claim_id = c001.claim_id
       AND c002.item_no  = c001.item_no
       AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date), 'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
       AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date), 'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
       AND c003.claim_id >= 0
       AND c003.line_cd = p_line_cd
       AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
     GROUP BY c003.line_cd,
              c003.subline_cd,
              c003.pol_iss_cd,
              c003.issue_yy,
              c003.pol_seq_no,
              c003.renew_no,
              --c002.peril_cd,
              c002.item_no;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
    INSERT INTO GICL_LOSS_PROFILE_EXT
      (cnt_clm,    line_cd,  subline_cd,
       pol_iss_cd, issue_yy, pol_seq_no,
       renew_no,   item_no)
	   --,  peril_cd)
    VALUES
   (vv_cnt_clm(i),    vv_line_cd(i),   vv_subline_cd(i),
    vv_pol_iss_cd(i), vv_issue_yy(i),  vv_pol_seq_no(i),
    vv_renew_no(i),   vv_item_no(i));
	--,   vv_peril_cd(i));
  COMMIT;
  END IF;
END Get_Loss_Ext_Motor;
PROCEDURE Get_Loss_Ext2_Motor (p_pol_sw  IN VARCHAR2,
		         p_date_fr  IN DATE,
			 p_date_to  IN DATE,
			 p_line_cd  IN VARCHAR2,
			 p_subline  IN VARCHAR2) AS
--pau 23nov06
--copied from orig get_loss_ext2_fire
  TYPE tsi_amt_tab         IS TABLE OF GICL_LOSS_PROFILE_EXT2.tsi_amt%TYPE;
  TYPE line_cd_tab         IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gicl_claims.subline_cd%TYPE;
  TYPE pol_iss_cd_tab      IS TABLE OF gicl_claims.pol_iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gicl_claims.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gicl_claims.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gicl_claims.renew_no%TYPE;
  --TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  --TYPE tarf_cd_tab         IS TABLE OF giis_tariff.tarf_cd%TYPE;
  TYPE item_no_tab         IS TABLE OF gipi_item.item_no%TYPE;
  vv_tsi_amt           	   tsi_amt_tab;
  vv_line_cd		   line_cd_tab;
  vv_subline_cd		   subline_cd_tab;
  vv_pol_iss_cd		   pol_iss_cd_tab;
  vv_issue_yy		   issue_yy_tab;
  vv_pol_seq_no		   pol_seq_no_tab;  
  vv_renew_no		   renew_no_tab;
  --vv_peril_cd		   peril_cd_tab;
  vv_item_no		   item_no_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT2;
  COMMIT;
  SELECT SUM(NVL(c250.tsi_amt,0) * NVL(d250.currency_rt,1))  tsi_amt,
         b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no,
		 --c250.peril_cd, 
		 c250.item_no
    BULK COLLECT INTO
	 vv_tsi_amt,
	 vv_line_cd,
	 vv_subline_cd,
	 vv_pol_iss_cd,
	 vv_issue_yy,
	 vv_pol_seq_no,
	 vv_renew_no,
	 --vv_peril_cd,
	 vv_item_no
    FROM gipi_polbasic b250, gipi_itmperil c250, gipi_item d250
   WHERE 1 = 1
     AND b250.policy_id  = d250.policy_id
	 AND d250.policy_id  = c250.policy_id
	 AND d250.item_no  = c250.item_no
     AND b250.line_cd    = p_line_cd
     AND b250.subline_cd = NVL(p_subline,b250.subline_cd)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         >= TRUNC(p_date_fr)
     AND DECODE(p_pol_sw,'ID',TRUNC(b250.issue_date),
                         'ED',TRUNC(b250.eff_date),
                         'AD',TRUNC(b250.acct_ent_date),
                         'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(b250.booking_mth)||' 1,'||TO_CHAR(b250.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
         <= TRUNC(p_date_to)
     -- BETH 11182002 consider spoiled accounting entry date
     AND DECODE(p_pol_sw,'AD',TRUNC(NVL(b250.spld_acct_ent_date,TRUNC(p_date_to + 1))),TRUNC(p_date_to + 1))
         > TRUNC(p_date_to)
     --end of UPDATE (beth)
     AND POL_FLAG IN ('1','2','3','X')
     AND DIST_FLAG      = '3'
     AND EXISTS (SELECT 1
	          FROM GICL_LOSS_PROFILE_EXT B
	         WHERE B250.LINE_CD = B.LINE_CD
                   AND B250.SUBLINE_CD = B.SUBLINE_cD
                   AND B250.ISS_CD = B.POL_ISS_CD
                   AND B250.ISSUE_YY = B.ISSUE_YY
		   AND B250.POL_SEQ_NO = B.POL_SEQ_NO
		   AND B250.RENEW_NO = B.RENEW_NO)
     -->inserted by mon 090902
     --if policy is not within given date of parameters, its endt will not be included
     AND (b250.endt_seq_no = 0
      OR (b250.endt_seq_no <> 0
           AND EXISTS (SELECT 1
 	                 FROM gipi_polbasic c
                        WHERE b250.line_cd = c.line_cd
                          AND b250.subline_cd = c.subline_cd
 			  AND b250.iss_cd = c.iss_cd
			  AND b250.issue_yy = c.issue_yy
			  AND b250.pol_seq_no = c.pol_seq_no
			  AND b250.renew_no = c.renew_no
			  AND b250.endt_seq_no = 0
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
                                      ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              >= TRUNC(p_date_fr)
                          AND DECODE(p_pol_sw,'ID',TRUNC(c.issue_date),
                                              'ED',TRUNC(c.eff_date),
                                              'AD',TRUNC(c.acct_ent_date),
                                              'BD',TRUNC(LAST_DAY(TO_DATE(UPPER(c.booking_mth)
  			              ||'1,'||TO_CHAR(c.booking_year),'FMMONTH DD,YYYY'))),SYSDATE)
                              <= TRUNC(p_date_to))))
     --end of inserted statement
     GROUP BY b250.line_cd,
	      b250.subline_cd,
	      b250.iss_cd,
              b250.issue_yy,
	      b250.pol_seq_no,
	      b250.renew_no,
		  --c250.peril_cd,
		  c250.item_no;
  IF SQL%FOUND THEN
     FORALL i IN vv_line_cd.first..vv_line_cd.last
       INSERT INTO GICL_LOSS_PROFILE_EXT2
	           (tsi_amt, 					line_cd,  	   		 subline_cd,
	            pol_iss_cd,					issue_yy,			 pol_seq_no,
		        renew_no,                   
				--peril_cd,            
				item_no)
	    VALUES (vv_tsi_amt(i),				vv_line_cd(i),		 vv_subline_cd(i),
  		       vv_pol_iss_cd(i),			vv_issue_yy(i),		 vv_pol_seq_no(i),
		       vv_renew_no(i),              
			   --vv_peril_cd(i),      
			   vv_item_no(i));
  COMMIT;
  END IF;
END Get_Loss_Ext2_Motor;
PROCEDURE Get_Loss_Ext3_Motor (p_loss_sw  IN VARCHAR2,
	   	     	  		  		   			    p_loss_fr  IN DATE,
                 			               		p_loss_to  IN DATE,
					   							p_line_cd  IN VARCHAR2,
												p_subline  IN VARCHAR2) AS
/* BY: PAU 
   DATE: 08FEB07 
   REMARKS: MODIFIED TO ELIMINATE OUTER JOIN TO TWO DIFFERENT TABLES 
*/
  TYPE claim_id_tab         IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE loss_amt_tab         IS TABLE OF gicl_claims.loss_pd_amt%TYPE;
  TYPE item_no_tab          IS TABLE OF gicl_item_peril.item_no%TYPE;
  vv_claim_id				claim_id_tab;
  vv_loss_amt  	        	loss_amt_tab;
  vv_item_no				item_no_tab;
BEGIN
  DELETE FROM GICL_LOSS_PROFILE_EXT3;
  COMMIT;
  SELECT C003.claim_id,SUM(NVL(c003.loss_reserve,0) + NVL(c003.expense_reserve,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT,
         c003.item_no
	BULK COLLECT INTO vv_claim_id, vv_loss_amt, vv_item_no
	FROM (SELECT c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
		         SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
            FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
           WHERE NVL(c017.cancel_tag,'N') = 'N'
           GROUP BY c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
		 (SELECT A.claim_id, c.loss_reserve, c.expense_reserve,
	   	 		 b.item_no, A.clm_stat_cd,
	   			 b.close_flag, c.dist_sw,
	  			 A.loss_date, A.clm_file_date,
	   			 A.line_cd, A.subline_cd
  			FROM gicl_claims A, gicl_item_peril b, gicl_clm_res_hist c
 		   WHERE A.claim_id = b.claim_id
   		     AND b.claim_id = c.claim_id
   			 AND b.item_no = c.item_no) c003
   WHERE c003.clm_stat_cd NOT IN ('WD','DN','CC','CD')
     AND c003.claim_id         = c017B.claim_id(+)
     AND c003.item_no         = c017B.item_no(+)
   	 AND NVL(c003.close_flag, 'AP') IN ('AP','CC','CP')
   	 AND NVL(c003.dist_sw,'N') = 'Y'
   	 AND TO_NUMBER(TO_CHAR(c003.loss_date,'YYYY'))= C017B.TRAN_YEAR(+)
   	 AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
     	                  'LD', TRUNC(c003.loss_date),SYSDATE) >=TRUNC(p_loss_fr)
     AND DECODE(p_loss_sw,'FD', TRUNC(c003.clm_file_date),
                          'LD', TRUNC(c003.loss_date),SYSDATE) <=TRUNC(p_loss_to)
     AND c003.claim_id >= 0
     AND c003.line_cd = p_line_cd
     AND c003.subline_cd = NVL(p_subline,c003.subline_cd)
  GROUP BY C003.claim_id, c003.item_no;
  IF SQL%FOUND THEN
     FORALL i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id, loss_amt, close_sw, item_no)         
	   VALUES (vv_claim_id(i),  vv_loss_amt(i), 'N', vv_item_no(i)); 
     COMMIT;
     vv_claim_id.DELETE;
     vv_loss_amt.DELETE;
     vv_item_no.DELETE; 
  END IF;
  SELECT C003.claim_id, SUM(NVL(c003.losses_paid,0) + NVL(c003.expenses_paid,0) -  NVL(c017b.recovered_amt, 0)) LOSS_AMT,
         c003.item_no
	BULK COLLECT INTO vv_claim_id, vv_loss_amt,vv_item_no
    FROM (SELECT c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY')) tran_year,
		         SUM(NVL(c017.recovered_amt,0) * (NVL(c018.recoverable_amt,0) / Get_Rec_Amt(c018.recovery_id))) recovered_amt
            FROM gicl_recovery_payt c017, gicl_clm_recovery_dtl c018
           WHERE NVL(c017.cancel_tag,'N') = 'N'
           GROUP BY c018.claim_id, c018.item_no, TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))) C017B,
		 (SELECT A.claim_id, b.losses_paid, b.expenses_paid,
	   	 		 b.item_no, A.clm_stat_cd,
	   			 b.tran_id, b.cancel_tag,
	   			 A.loss_date, A.clm_file_date,
	   			 A.line_cd, A.subline_cd
  			FROM gicl_claims A, gicl_clm_res_hist b
 		   WHERE A.claim_id = b.claim_id) c003
   WHERE c003.clm_stat_cd ='CD'
     AND c003.claim_id         = c017B.claim_id(+)
     AND c003.item_no          = c017B.item_no(+)
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
   GROUP BY c003.claim_id, c003.item_no;
  IF SQL%FOUND THEN
     FORALL i IN vv_claim_id.first..vv_claim_id.last
	   INSERT INTO GICL_LOSS_PROFILE_EXT3 (claim_id,        loss_amt,       close_sw, item_no)         
	   VALUES (vv_claim_id(i),  vv_loss_amt(i), 'Y', vv_item_no(i));   
       COMMIT;
  END IF;
END Get_Loss_Ext3_Motor;
END;
/


