DROP PROCEDURE CPI.GET_LOSS_EXT2;

CREATE OR REPLACE PROCEDURE CPI.get_loss_ext2 (p_pol_sw  IN VARCHAR2,
		         p_date_fr  IN DATE,
			 p_date_to  IN DATE,
			 p_line_cd  IN VARCHAR2,
			 p_subline  IN VARCHAR2) IS
  TYPE tsi_amt_tab         IS TABLE OF gicl_loss_profile_ext2.tsi_amt%TYPE;
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
  DELETE FROM gicl_loss_profile_ext2;
  COMMIT;
  SELECT SUM(NVL(b250.tsi_amt,0))  tsi_amt,
         b250.line_cd, b250.subline_cd, b250.iss_cd, b250.issue_yy, b250.pol_seq_no, b250.renew_no
    bulk collect INTO
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
     AND b250.endt_seq_no = 0
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
                              <= TRUNC(p_date_to)))
     --end of inserted statement
     GROUP BY b250.line_cd,
	      b250.subline_cd,
	      b250.iss_cd,
              b250.issue_yy,
	      b250.pol_seq_no,
	      b250.renew_no;
  IF SQL%FOUND THEN
     forall i IN vv_line_cd.first..vv_line_cd.last
       INSERT INTO gicl_loss_profile_ext2
	           (tsi_amt, 						line_cd,  	   		 subline_cd,
	            pol_iss_cd,					issue_yy,			 pol_seq_no,
		    renew_no)
	    VALUES (vv_tsi_amt(i),				vv_line_cd(i),		 vv_subline_cd(i),
		    vv_pol_iss_cd(i),				vv_issue_yy(i),		 vv_pol_seq_no(i),
		    vv_renew_no(i));
  COMMIT;
  END IF;
END;
/


