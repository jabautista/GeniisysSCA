CREATE OR REPLACE PACKAGE BODY CPI.p_uwreports_22dec2004
/* author     : terrence to
** desciption : this package will hold all the procedures and functions that will
**              handle the extraction for uwreports (gipis901a) module.
**
*/
AS
  FUNCTION Check_Date_Policy
   /** rollie 19july2004
   *** get the dates of certain policy
   **/
   (p_scope		      NUMBER,
    p_param_date  	  NUMBER,
    p_from_date  	  DATE,
    p_to_date         DATE,
 	p_issue_date  	  DATE,
  	p_eff_date   	  DATE,
  	p_acct_ent_date   DATE,
  	p_spld_acct  	  DATE,
  	p_booking_mth     gipi_polbasic.booking_mth%TYPE,
  	p_booking_year    gipi_polbasic.booking_year%TYPE)
   RETURN NUMBER IS
   	 v_check_date NUMBER(1) := 0;
   BEGIN
     IF p_param_date = 1 THEN ---based on issue_date
        IF TRUNC(p_issue_date) BETWEEN p_from_date AND p_to_date THEN
           v_check_date := 1;
     	END IF;
     ELSIF p_param_date = 2 THEN --based on incept_date
        IF TRUNC(p_eff_date) BETWEEN p_from_date AND p_to_date THEN
           v_check_date := 1;
        END IF;
  	 ELSIF p_param_date = 3 THEN --based on booking mth/yr
        IF LAST_DAY ( TO_DATE ( p_booking_mth || ',' || TO_CHAR(p_booking_year),'FMMONTH,YYYY'))
           BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
           v_check_date := 1;
        END IF;
     ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL THEN --based on acct_ent_date
        IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date THEN
           IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
		      AND p_spld_acct IS NOT NULL AND p_scope=5 THEN
		      v_check_date := 0;
		   ELSE
              v_check_date := 1;
		   END IF;
        END IF;
     END IF;
     RETURN (v_check_date);
   END;
   PROCEDURE pol_taxes
   	 IS
	 v_evat	 		  giac_parameters.param_value_v%TYPE;
	 v_5prem_tax	  giac_parameters.param_value_v%TYPE;
	 v_fst	 		  giac_parameters.param_value_v%TYPE;
	 v_lgt	 		  giac_parameters.param_value_v%TYPE;
	 v_doc_stamps	  giac_parameters.param_value_v%TYPE;	 
   BEGIN
     v_evat			  := Giacp.n('EVAT');																			
	 v_5prem_tax	  := Giacp.n('5PREM_TAX');
	 v_fst	 		  := Giacp.n('FST');
	 v_lgt	 		  := Giacp.n('LGT');
	 v_doc_stamps	  := Giacp.n('DOC_STAMPS');
    -- for evat
     MERGE INTO gipi_uwreports_ext gpp USING
        (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) evat,
                giv.policy_id policy_id
           FROM gipi_inv_tax git, gipi_invoice giv,gipi_uwreports_ext gpp
          WHERE 1 = 1
            AND giv.item_grp    = git.item_grp
            AND giv.iss_cd      = git.iss_cd
            AND giv.prem_seq_no = git.prem_seq_no
            AND git.tax_cd     >= 0
			AND giv.policy_id    = gpp.policy_id
			AND gpp.user_id      = USER
            AND git.tax_cd      IN (v_5prem_tax,v_evat)
		  GROUP BY giv.policy_id) evat
     ON (evat.policy_id = gpp.policy_id)
     WHEN MATCHED THEN UPDATE
       SET gpp.evatprem = evat.evat + NVL(gpp.evatprem,0)
     WHEN NOT MATCHED THEN
       INSERT (evatprem,policy_id)
       VALUES (evat.evat,evat.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'EVAT01');
     -- for 5evat_prem
/*     MERGE INTO gipi_uwreports_ext gpp USING
        (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) evat,
                giv.policy_id policy_id
           FROM gipi_inv_tax git, gipi_invoice giv,gipi_uwreports_ext gpp
          WHERE 1 = 1
            AND giv.item_grp    = git.item_grp
            AND giv.iss_cd      = git.iss_cd
            AND giv.prem_seq_no = git.prem_seq_no
            AND git.tax_cd     >= 0
			AND giv.policy_id   = gpp.policy_id
			AND gpp.user_id     = USER
            AND git.tax_cd      = Giacp.n ('EVAT')
		  GROUP BY giv.policy_id) evat
     ON (evat.policy_id=gpp.policy_id)
     WHEN MATCHED THEN UPDATE
       SET gpp.evatprem = evat.evat + NVL(gpp.evatprem,0)
     WHEN NOT MATCHED THEN
       INSERT (evatprem,policy_id)
       VALUES (evat.evat,evat.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'EVAT02');
*/
  	 -- for fst
  	 MERGE INTO gipi_uwreports_ext gpp USING
      	(SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) fst,
				giv.policy_id policy_id
	       FROM gipi_inv_tax git, gipi_invoice giv,gipi_uwreports_ext gpp
	 	  WHERE 1 = 1
	        AND giv.item_grp  	 = git.item_grp
	     	AND giv.iss_cd 	  	 = git.iss_cd
	     	AND giv.prem_seq_no  = git.prem_seq_no
		 	AND git.tax_cd   	>= 0
			AND giv.policy_id    = gpp.policy_id
			AND gpp.user_id      = USER
		 	AND git.tax_cd       = v_fst
		  GROUP BY giv.policy_id) fst
  	 ON (fst.policy_id = gpp.policy_id)
  	 WHEN MATCHED THEN UPDATE
       SET gpp.fst = fst.fst + NVL(gpp.fst,0)
  	 WHEN NOT MATCHED THEN
       INSERT (fst,policy_id)
       VALUES (fst.fst,fst.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'FST');
     --for lgt
  	 MERGE INTO gipi_uwreports_ext gpp USING
        (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) lgt,
		  		giv.policy_id policy_id
           FROM gipi_inv_tax git, gipi_invoice giv,gipi_uwreports_ext gpp
	      WHERE 1 = 1
	        AND giv.item_grp     = git.item_grp
	     	AND giv.iss_cd       = git.iss_cd
		 	AND giv.prem_seq_no  = git.prem_seq_no
		 	AND git.tax_cd      >= 0
			AND giv.policy_id    = gpp.policy_id
			AND gpp.user_id      = USER
		 	AND git.tax_cd       = v_lgt
		  GROUP BY giv.policy_id) lgt
     ON (lgt.policy_id = gpp.policy_id)
  	 WHEN MATCHED THEN UPDATE
       SET gpp.lgt = lgt.lgt + NVL(gpp.lgt,0)
  	 WHEN NOT MATCHED THEN
       INSERT (lgt,policy_id)
       VALUES (lgt.lgt,lgt.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'LGT');
     -- other charges
  	 MERGE INTO gipi_uwreports_ext gpp USING
        (SELECT SUM(NVL (giv.other_charges * giv.currency_rt,0)) other_charges,
		 		giv.policy_id policy_id
	       FROM  gipi_invoice giv,gipi_uwreports_ext gpp
		  WHERE 1 = 1
  		    AND giv.policy_id    = gpp.policy_id
			AND gpp.user_id      = USER
			GROUP BY giv.policy_id) goc
     ON (goc.policy_id = gpp.policy_id)
     WHEN MATCHED THEN UPDATE
       SET gpp.other_charges = goc.other_charges + NVL(gpp.other_charges,0)
     WHEN NOT MATCHED THEN
       INSERT (other_charges,policy_id)
       VALUES (goc.other_charges,goc.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'OT');
     -- other taxes
     MERGE INTO gipi_uwreports_ext gpp USING
        (SELECT SUM(NVL(git.tax_amt * giv.currency_rt,0)) other_taxes,
		       giv.policy_id policy_id
	       FROM gipi_inv_tax git, gipi_invoice giv,gipi_uwreports_ext gpp
	      WHERE 1 = 1
		    AND giv.item_grp    = git.item_grp
		 	AND giv.iss_cd      = git.iss_cd
		 	AND giv.prem_seq_no = git.prem_seq_no
		 	AND git.tax_cd     >= 0
			AND giv.policy_id    = gpp.policy_id
			AND gpp.user_id      = USER
		 	AND git.tax_cd NOT IN (v_evat,v_doc_stamps,
						    	   v_fst, v_lgt,v_5prem_tax)
		  GROUP BY giv.policy_id) got
     ON (got.policy_id=gpp.policy_id)
     WHEN MATCHED THEN UPDATE
       SET gpp.other_taxes = got.other_taxes + NVL(gpp.other_taxes,0)
     WHEN NOT MATCHED THEN
       INSERT (other_taxes,policy_id)
       VALUES (got.other_taxes,got.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'OC');
	 -- doc stamps
     MERGE INTO gipi_uwreports_ext gpp USING
        (SELECT SUM(NVL(git.tax_amt,0) * NVL(giv.currency_rt,0)) doc_stamps,
		        giv.policy_id
           FROM gipi_inv_tax git, gipi_invoice giv,gipi_uwreports_ext gpp
          WHERE giv.iss_cd 	 	 = git.iss_cd
            AND giv.prem_seq_no  = git.prem_seq_no
            AND git.tax_cd 		>= 0
            AND giv.item_grp     = git.item_grp
			AND giv.policy_id    = gpp.policy_id
			AND gpp.user_id      = USER
            AND git.tax_cd       = v_doc_stamps
		  GROUP BY giv.policy_id) doc
     ON (doc.policy_id = gpp.policy_id)
     WHEN MATCHED THEN UPDATE
       SET gpp.doc_stamps = doc.doc_stamps + NVL(gpp.doc_stamps,0)
     WHEN NOT MATCHED THEN
       INSERT (doc_stamps,policy_id)
       VALUES (doc.doc_stamps,doc.policy_id);
     COMMIT;
	 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'DOC');
   END;
   PROCEDURE pol_gixx_pol_prod (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;
      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;
      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;
      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;
      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;
      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;
      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;
      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;
      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;
      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;
      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_spld_acct_ent_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_dist_flag_tab IS TABLE OF gipi_polbasic.dist_flag%TYPE;
      TYPE v_spld_date_tab IS TABLE OF VARCHAR2 (20);
	  TYPE v_pol_flag_tab IS TABLE OF gipi_polbasic.pol_flag%TYPE;
	  TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;
      v_assd_no                     v_assd_no_tab;
      v_policy_id                   v_policy_id_tab;
      v_issue_date                  v_issue_date_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_issue_yy                    v_issue_yy_tab;
      v_pol_seq_no                  v_pol_seq_no_tab;
      v_renew_no                    v_renew_no_tab;
      v_endt_iss_cd                 v_endt_iss_cd_tab;
      v_endt_yy                     v_endt_yy_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_incept_date                 v_incept_date_tab;
      v_expiry_date                 v_expiry_date_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_dist_flag                   v_dist_flag_tab;
      v_spld_date                   v_spld_date_tab;
	  v_pol_flag                    v_pol_flag_tab;
	  v_cred_branch					v_cred_branch_tab;
   BEGIN

      SELECT a.assd_no,
	         gp.policy_id gp_policy_id,
             gp.issue_date gp_issue_date,
             gp.line_cd gp_line_cd,
			 gp.subline_cd gp_subline_cd,
             gp.iss_cd gp_iss_cd,
			 gp.issue_yy gp_issue_yy,
             gp.pol_seq_no gp_pol_seq_no,
			 gp.renew_no gp_renew_no,
             gp.endt_iss_cd gp_endt_iss_cd,
			 gp.endt_yy gp_endt_yy,
             gp.endt_seq_no gp_endt_seq_no,
             gp.incept_date gp_incept_date,
             gp.expiry_date gp_expiry_date,
			 gp.tsi_amt gp_tsi_amt,
			 gp.prem_amt gp_prem_amt,
             gp.acct_ent_date gp_acct_ent_date,
             gp.spld_acct_ent_date gp_spld_acct_ent_date,
			 gp.dist_flag dist_flag,
 			 gp.spld_date gp_spld_date,
			 gp.pol_flag gp_pol_flag,
			 gp.cred_branch	gp_cred_branch
        BULK COLLECT INTO v_assd_no,
			 		 	  v_policy_id,
                          v_issue_date,
                          v_line_cd, v_subline_cd,
                          v_iss_cd, v_issue_yy,
                          v_pol_seq_no, v_renew_no,
                          v_endt_iss_cd, v_endt_yy,
                          v_endt_seq_no,
                          v_incept_date,
                          v_expiry_date,
                          v_tsi_amt,
						  v_prem_amt,
                          v_acct_ent_date,
                          v_spld_acct_ent_date,
						  v_dist_flag,
                          v_spld_date,
						  v_pol_flag,
						  v_cred_branch
        FROM gipi_parlist a,
			   gipi_polbasic gp
       WHERE a.par_id = gp.par_id
		 AND Check_Date_Policy(p_scope,
		  	 				   p_param_date,
		 	 				   p_from_date,
							   p_to_date,
							   gp.issue_date,
							   gp.eff_date,
							   gp.acct_ent_date,
							   gp.spld_acct_ent_date,
							   gp.booking_mth,
							   gp.booking_year) = 1
		 AND NVL (gp.endt_type, 'A') = 'A'
		 AND gp.reg_policy_sw = DECODE(p_special_pol,'Y',reg_policy_sw,'Y')
         AND gp.subline_cd    = NVL (p_subline_cd, gp.subline_cd)
         AND gp.line_cd       = NVL (p_line_cd, gp.line_cd)
		 AND DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,gp.cred_branch,gp.iss_cd));
		IF SQL%FOUND THEN
		  FORALL cnt IN v_policy_id.FIRST..v_policy_id.LAST
		     INSERT INTO gipi_uwreports_ext(
			  			 			   assd_no,
			 			 			   policy_id,
									   issue_date,
									   line_cd,
									   subline_cd,
									   iss_cd,
									   issue_yy,
									   pol_seq_no,
									   renew_no,
									   endt_iss_cd,
									   endt_yy,
									   endt_seq_no,
									   incept_date,
									   expiry_date,
									   total_tsi,
									   total_prem,
									   from_date,
									   TO_DATE,
									   SCOPE,
									   user_id,
									   acct_ent_date,
									   spld_acct_ent_date,
									   dist_flag,
									   spld_date,
									   pol_flag,
									   param_date,
									   evatprem,
									   fst,
									   lgt,
									   doc_stamps,
									   other_taxes,
									   other_charges,
									   cred_branch,
									   cred_branch_param,
									   special_pol_param)
								VALUES(v_assd_no(cnt),
									   v_policy_id(cnt),
			                           v_issue_date(cnt),
			                           v_line_cd(cnt),
									   v_subline_cd(cnt),
			                           v_iss_cd(cnt),
									   v_issue_yy(cnt),
			                           v_pol_seq_no(cnt),
									   v_renew_no(cnt),
			                           v_endt_iss_cd(cnt),
									   v_endt_yy(cnt),
			                           v_endt_seq_no(cnt),
			                           v_incept_date(cnt),
			                           v_expiry_date(cnt),
			                           v_tsi_amt(cnt),
									   v_prem_amt(cnt),
									   p_from_date,
									   p_to_date,
									   p_scope,
									   USER,
			                           v_acct_ent_date(cnt),
			                           v_spld_acct_ent_date(cnt),
									   v_dist_flag(cnt),
			                           v_spld_date(cnt),
									   v_pol_flag(cnt),
									   p_param_date,
									   0,0,0,0,0,0,
									   v_cred_branch(cnt),
									   p_parameter,
									   p_special_pol);
	   	 	COMMIT;
	    END IF;
		DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'MAIN');
  END;

  FUNCTION Check_Date
   /** rollie 02/18/04
   *** date parameter of the last endorsement of policy
   *** must be within the date given, else it will
   *** be exluded
   *** note: policy with pol_flag = '4' only
   **/
	(p_scope	 	NUMBER,
	 p_line_cd	    gipi_polbasic.line_cd%TYPE,
	 p_subline_cd	gipi_polbasic.subline_cd%TYPE,
	 p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	 p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	 p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	 p_renew_no	    gipi_polbasic.renew_no%TYPE,
 	 p_param_date	NUMBER,
	 p_from_date	DATE,
	 p_to_date	    DATE
	 )
   RETURN NUMBER
    IS
    v_check_date	NUMBER(1) := 0;
   BEGIN
   FOR a IN (
     SELECT a.issue_date issue_date,
	 	    a.eff_date   eff_date,
		    a.booking_mth booking_month,
		    a.booking_year booking_year,
		    a.acct_ent_date acct_ent_date,
		    a.spld_acct_ent_date spld_acct_ent_date
       FROM gipi_polbasic a
	  WHERE a.line_cd     = p_line_cd
	    AND a.subline_cd  = p_subline_cd
 	    AND a.iss_cd      = p_iss_cd
	    AND a.issue_yy    = p_issue_yy
 	    AND a.pol_seq_no  = p_pol_seq_no
	    AND a.renew_no    = p_renew_no
	    AND endt_seq_no IN (SELECT MAX(endt_seq_no)
	   	   			          FROM gipi_polbasic b
						     WHERE a.line_cd    = b.line_cd
							   AND a.subline_cd = b.subline_cd
      						   AND a.iss_cd = b.iss_cd
      						   AND a.issue_yy = b.issue_yy
      						   AND a.pol_seq_no = b.pol_seq_no
      						   AND a.renew_no  = b.renew_no))
      LOOP
	    IF p_param_date = 1 THEN ---based on issue_date
 		   IF TRUNC(a.issue_date) BETWEEN p_from_date AND p_to_date THEN
	          v_check_date := 1;
	       END IF;
		ELSIF p_param_date = 2 THEN --based on incept_date
		   IF TRUNC(a.eff_date) BETWEEN p_from_date AND p_to_date THEN
	          v_check_date := 1;
	       END IF;
		ELSIF p_param_date = 3 THEN --based on booking mth/yr
		   IF LAST_DAY ( TO_DATE ( a.booking_month || ',' || TO_CHAR (a.booking_year),'FMMONTH,YYYY'))
		      BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
			  v_check_date := 1;
		   END IF;
		ELSIF p_param_date = 4 AND a.acct_ent_date IS NOT NULL THEN --based on acct_ent_date
		   IF (TRUNC (a.acct_ent_date) BETWEEN p_from_date AND p_to_date
                  OR NVL (TRUNC (a.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date AND p_to_date) THEN
			  v_check_date := 1;
		   END IF;
		END IF;
		EXIT;
      END LOOP;
      RETURN (v_check_date);
   END;

   PROCEDURE extract_tab1 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE policy_id_tab  		  IS TABLE OF gipi_polbasic.policy_id%TYPE;
	  TYPE total_tsi_tab 		  IS TABLE OF gipi_polbasic.tsi_amt%TYPE;
	  TYPE total_prem_tab 		  IS TABLE OF gipi_polbasic.prem_amt%TYPE;
	  TYPE acct_ent_date_tab 	  IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
	  TYPE spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;
	  TYPE spld_date_tab 		  IS TABLE OF gipi_polbasic.spld_date%TYPE;
	  vv_policy_id				  policy_id_tab;
	  vv_total_tsi				  total_tsi_tab;
	  vv_total_prem				  total_prem_tab;
	  vv_acct_ent_date			  acct_ent_date_tab;
	  vv_spld_acct_ent_date		  spld_acct_ent_date_tab;
	  vv_spld_date				  spld_date_tab;
	  v_multiplier                  NUMBER := 1;
	  v_count						NUMBER;
   BEGIN
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START');
	  DELETE FROM gipi_uwreports_ext
            WHERE user_id = p_user;
	  COMMIT;
	  pol_gixx_pol_prod(p_scope,
				        p_param_date,
				        p_from_date,
				        p_to_date,
				        p_iss_cd,
				        p_line_cd,
				        p_subline_cd,
				        p_user,
					    p_parameter ,
					    p_special_pol);
	  SELECT COUNT(policy_id)
	    INTO v_count
		FROM gipi_uwreports_ext;
	  IF v_count > 0 THEN
	  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS'));
	     pol_taxes;
	  END IF;
	  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 2');
	  IF v_count <> 0 AND p_param_date = 4 THEN
	     SELECT policy_id,
		 		total_tsi,
				total_prem,
				acct_ent_date,
				spld_acct_ent_date,
				spld_date
  		 BULK COLLECT INTO
		        vv_policy_id,
		   		vv_total_tsi,
				vv_total_prem,
				vv_acct_ent_date,
				vv_spld_acct_ent_date,
				vv_spld_date
		   FROM gipi_uwreports_ext
		  WHERE user_id=USER;
		 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 3');
		 FOR idx IN vv_policy_id.FIRST..vv_policy_id.LAST LOOP
		   IF (vv_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date)
			  AND (vv_spld_acct_ent_date(idx) BETWEEN p_from_date AND p_to_date) THEN
			  vv_total_tsi(idx)  := 0;
			  vv_total_prem(idx) := 0;
		   ELSIF vv_spld_date(idx) BETWEEN p_from_date AND p_to_date THEN
			  vv_total_tsi(idx)  := vv_total_tsi(idx)  * (-1);
			  vv_total_prem(idx) := vv_total_prem(idx) * (-1);
		   END IF;
		   vv_spld_date(idx) := NULL;
		 END LOOP;
		 DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 4');
		 FORALL upd IN vv_policy_id.FIRST..vv_policy_id.LAST
		     UPDATE gipi_uwreports_ext
			    SET total_tsi  = vv_total_tsi(upd),
					total_prem = vv_total_prem(upd),
					spld_date  = vv_spld_date(upd)
			   WHERE policy_id = vv_policy_id(upd);
--		 END LOOP;
	  	 COMMIT;
	  END IF;
	  DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'HH:MI:SS')||'START 5');
   END;

   PROCEDURE extract_tab2 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (150);
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;
      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;
      TYPE v_share_cd_tab IS TABLE OF giuw_perilds_dtl.share_cd%TYPE;
      TYPE v_share_type_tab IS TABLE OF giis_dist_share.share_type%TYPE;
      TYPE v_trty_name_tab IS TABLE OF giis_dist_share.trty_name%TYPE;
      TYPE v_trty_yy_tab IS TABLE OF giis_dist_share.trty_yy%TYPE;
      TYPE v_dist_no_tab IS TABLE OF giuw_perilds_dtl.dist_no%TYPE;
      TYPE v_dist_seq_no_tab IS TABLE OF giuw_perilds_dtl.dist_seq_no%TYPE;
      TYPE v_peril_cd_tab IS TABLE OF giuw_perilds_dtl.peril_cd%TYPE;
      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;
      TYPE v_nr_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;
      TYPE v_nr_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;
      TYPE v_nr_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;
      TYPE v_tr_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;
      TYPE v_tr_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;
      TYPE v_tr_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;
      TYPE v_fa_dist_tsi_tab IS TABLE OF giuw_perilds_dtl.dist_tsi%TYPE;
      TYPE v_fa_dist_prem_tab IS TABLE OF giuw_perilds_dtl.dist_prem%TYPE;
      TYPE v_fa_dist_spct_tab IS TABLE OF giuw_perilds_dtl.dist_spct%TYPE;
      TYPE v_currency_rt_tab IS TABLE OF gipi_invoice.currency_rt%TYPE;
      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;
      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;
      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;
      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;
      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;
      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;
      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;
      TYPE v_acct_ent_date_tab IS TABLE OF giuw_pol_dist.acct_ent_date%TYPE;
      TYPE v_acct_neg_date_tab IS TABLE OF giuw_pol_dist.acct_neg_date%TYPE;
	  TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;
	  v_cred_branch			 		v_cred_branch_tab;
      v_policy_id                   v_policy_id_tab;
      v_policy_no                   v_policy_no_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_share_cd                    v_share_cd_tab;
      v_share_type                  v_share_type_tab;
      v_trty_name                   v_trty_name_tab;
      v_trty_yy                     v_trty_yy_tab;
      v_dist_no                     v_dist_no_tab;
      v_dist_seq_no                 v_dist_seq_no_tab;
      v_peril_cd                    v_peril_cd_tab;
      v_peril_type                  v_peril_type_tab;
      v_nr_dist_tsi                 v_nr_dist_tsi_tab;
      v_nr_dist_prem                v_nr_dist_prem_tab;
      v_nr_dist_spct                v_nr_dist_spct_tab;
      v_tr_dist_tsi                 v_tr_dist_tsi_tab;
      v_tr_dist_prem                v_tr_dist_prem_tab;
      v_tr_dist_spct                v_tr_dist_spct_tab;
      v_fa_dist_tsi                 v_fa_dist_tsi_tab;
      v_fa_dist_prem                v_fa_dist_prem_tab;
      v_fa_dist_spct                v_fa_dist_spct_tab;
      v_currency_rt                 v_currency_rt_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_issue_yy                    v_issue_yy_tab;
      v_pol_seq_no                  v_pol_seq_no_tab;
      v_renew_no                    v_renew_no_tab;
      v_endt_iss_cd                 v_endt_iss_cd_tab;
      v_endt_yy                     v_endt_yy_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_acct_neg_date               v_acct_neg_date_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_dist_peril_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT b.policy_id, /*Get_Policy_No (b.policy_id) */b.line_cd
             || '-'
             || b.subline_cd
             || '-'
             || b.iss_cd
             || '-'
             || LTRIM (TO_CHAR (b.issue_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
             || '-'
             || LTRIM (TO_CHAR (b.renew_no, '09'))
             || DECODE (
                   NVL (b.endt_seq_no, 0),
                   0, '',
                      ' / '
                   || b.endt_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (b.endt_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (b.endt_seq_no, '9999999'))
                ) policy_no, g.line_cd,
             b.subline_cd, g.share_cd, f.share_type, f.trty_name, f.trty_yy,
             g.dist_no, g.dist_seq_no, g.peril_cd, h.peril_type,
             DECODE (f.share_type, '1', NVL (g.dist_tsi, 0)) * e.currency_rt  nr_dist_tsi,
             DECODE (f.share_type, '1', NVL (g.dist_prem, 0)) * e.currency_rt  nr_dist_prem,
             DECODE (f.share_type, '1', g.dist_spct) nr_dist_spct,
             DECODE (f.share_type, '2', NVL (g.dist_tsi, 0)) * e.currency_rt  tr_dist_tsi,
             DECODE (f.share_type, '2', NVL (g.dist_prem, 0)) * e.currency_rt  tr_dist_prem,
             DECODE (f.share_type, '2', g.dist_spct) tr_dist_spct,
             DECODE (f.share_type, '3', NVL (g.dist_tsi, 0)) * e.currency_rt  fa_dist_tsi,
             DECODE (f.share_type, '3', NVL (g.dist_prem, 0)) * e.currency_rt fa_dist_prem,
             DECODE (f.share_type, '3', g.dist_spct) fa_dist_spct,
             e.currency_rt, b.endt_seq_no, b.iss_cd, b.issue_yy,
             b.pol_seq_no, b.renew_no, b.endt_iss_cd, b.endt_yy,
             a.acct_ent_date, a.acct_neg_date,b.cred_branch
        BULK COLLECT INTO v_policy_id, v_policy_no, v_line_cd,
                          v_subline_cd, v_share_cd, v_share_type, v_trty_name, v_trty_yy,
                          v_dist_no, v_dist_seq_no, v_peril_cd, v_peril_type,
                          v_nr_dist_tsi,
                          v_nr_dist_prem,
                          v_nr_dist_spct,
                          v_tr_dist_tsi,
                          v_tr_dist_prem,
                          v_tr_dist_spct,
                          v_fa_dist_tsi,
                          v_fa_dist_prem,
                          v_fa_dist_spct,
                          v_currency_rt, v_endt_seq_no, v_iss_cd, v_issue_yy,
                          v_pol_seq_no, v_renew_no, v_endt_iss_cd, v_endt_yy,
                          v_acct_ent_date, v_acct_neg_date,v_cred_branch
        FROM gipi_polbasic b,
             giuw_pol_dist a,
             giuw_perilds_dtl g,
             gipi_invoice e,
             giis_dist_share f,
             giis_peril h
       WHERE a.policy_id = b.policy_id
         AND g.dist_no = a.dist_no
         AND a.policy_id = e.policy_id
		 AND b.reg_policy_sw = DECODE(p_special_pol,'Y',b.reg_policy_sw,'Y')
         AND NVL (b.line_cd, b.line_cd) = f.line_cd
         AND NVL (b.line_cd, b.line_cd) = f.line_cd
         AND NVL (b.line_cd, b.line_cd) = f.line_cd
         AND b.line_cd >= '%'
         AND b.subline_cd >= '%'
         AND g.share_cd = f.share_cd
         AND g.share_cd = f.share_cd
         AND g.peril_cd = h.peril_cd
         AND g.line_cd = h.line_cd
         AND (   b.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND NVL (b.endt_type, 'A') = 'A'
         AND (   (a.dist_flag = 3 AND b.dist_flag = 3)
              OR p_param_date = 4)
		 AND (   (    p_param_date = 3
                  AND LAST_DAY (
                         Convert_Booking_My (b.booking_mth, b.booking_year)) >=
                                                                  p_from_date)
              OR (p_param_date <> 3))
         AND (   (    p_param_date = 3
                  AND Convert_Booking_My (b.booking_mth, b.booking_year) <=
                                                                    p_to_date)
              OR (p_param_date <> 3))
         AND (   (    TRUNC (
                         DECODE (
                            p_param_date,
                            1, b.issue_date,
                            2, b.eff_date,
                            4, a.acct_ent_date,
                            p_from_date + 1)) >= p_from_date
                  AND TRUNC (
                         DECODE (
                            p_param_date,
                            1, b.issue_date,
                            2, b.eff_date,
                            4, a.acct_ent_date,
                            p_to_date - 1)) <= p_to_date)
              OR (    a.acct_neg_date >= p_from_date
                  AND a.acct_neg_date <= p_to_date
                  AND p_param_date = 4))
	     AND DECODE(b.pol_flag,'4',Check_Date_Dist_Peril(b.line_cd,
		                                                 b.subline_cd,
													     b.iss_cd,
													     b.issue_yy,
													     b.pol_seq_no,
													     b.renew_no,
													     p_param_date,
													     p_from_date,
													     p_to_date)
								  ,1) = 1
         AND b.line_cd = NVL (p_line_cd, b.line_cd)
		 AND b.iss_cd = NVL (p_iss_cd, b.iss_cd)
		 AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
		 AND DECODE(p_parameter,1,b.cred_branch,b.iss_cd)   = NVL(p_iss_cd,DECODE(p_parameter,1,b.cred_branch,b.iss_cd));

      IF v_policy_id.EXISTS (1) THEN

--      if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_acct_neg_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_nr_dist_tsi (idx) := v_nr_dist_tsi (idx) * v_multiplier;
                  v_nr_dist_prem (idx) := v_nr_dist_prem (idx) * v_multiplier;
                  v_tr_dist_tsi (idx) := v_tr_dist_tsi (idx) * v_multiplier;
                  v_tr_dist_prem (idx) := v_tr_dist_prem (idx) * v_multiplier;
                  v_fa_dist_tsi (idx) := v_fa_dist_tsi (idx) * v_multiplier;
                  v_fa_dist_prem (idx) := v_fa_dist_prem (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- for idx in 1 .. v_pol_count
      END IF; --if v_policy_id.exists(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_dist_peril_ext
                        (policy_id,
                         policy_no,
                         line_cd,
                         subline_cd,
                         share_cd,
                         share_type,
                         dist_no,
                         dist_seq_no,
                         trty_name,
                         trty_yy,
                         from_date1,
                         to_date1,
                         peril_cd,
                         peril_type,
                         nr_dist_tsi,
                         nr_dist_prem,
                         nr_dist_spct,
                         tr_dist_tsi,
                         tr_dist_prem,
                         tr_dist_spct,
                         fa_dist_tsi,
                         fa_dist_prem,
                         fa_dist_spct,
                         currency_rt,
                         endt_seq_no,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         user_id,
                         SCOPE,
                         param_date,
						 cred_branch)
                 VALUES (v_policy_id (cnt),
                         v_policy_no (cnt),
                         v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_share_cd (cnt),
                         v_share_type (cnt),
                         v_dist_no (cnt),
                         v_dist_seq_no (cnt),
                         v_trty_name (cnt),
                         v_trty_yy (cnt),
                         p_from_date,
                         p_to_date,
                         v_peril_cd (cnt),
                         v_peril_type (cnt),
                         v_nr_dist_tsi (cnt),
                         v_nr_dist_prem (cnt),
                         v_nr_dist_spct (cnt),
                         v_tr_dist_tsi (cnt),
                         v_tr_dist_prem (cnt),
                         v_tr_dist_spct (cnt),
                         v_fa_dist_tsi (cnt),
                         v_fa_dist_prem (cnt),
                         v_fa_dist_spct (cnt),
                         v_currency_rt (cnt),
                         v_endt_seq_no (cnt),
                         v_iss_cd (cnt),
                         v_issue_yy (cnt),
                         v_pol_seq_no (cnt),
                         v_renew_no (cnt),
                         v_endt_iss_cd (cnt),
                         v_endt_yy (cnt),
                         p_user,
                         p_scope,
                         p_param_date,
						 v_cred_branch(cnt));
      END IF; --end of if sql%found

      COMMIT;
   END; --extract tab 2

   PROCEDURE extract_tab3 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;
      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;
      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;
      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;
      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;
      TYPE v_policy_no_tab IS TABLE OF VARCHAR2 (200);
      TYPE v_binder_no_tab IS TABLE OF VARCHAR2 (200);
      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;
      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_ri_tsi_amt_tab IS TABLE OF giri_binder.ri_tsi_amt%TYPE;
      TYPE v_ri_prem_amt_tab IS TABLE OF giri_binder.ri_prem_amt%TYPE;
      TYPE v_ri_comm_amt_tab IS TABLE OF giri_binder.ri_comm_amt%TYPE;
      TYPE v_ri_sname_tab IS TABLE OF giis_reinsurer.ri_sname%TYPE;
      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;
      TYPE v_ri_cd_tab IS TABLE OF giis_reinsurer.ri_cd%TYPE;
      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;
	  TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;
	  v_cred_branch			 		v_cred_branch_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_line_name                   v_line_name_tab;
      v_subline_name                v_subline_name_tab;
      v_policy_no                   v_policy_no_tab;
      v_binder_no                   v_binder_no_tab;
      v_assd_name                   v_assd_name_tab;
      v_policy_id                   v_policy_id_tab;
      v_incept_date                 v_incept_date_tab;
      v_expiry_date                 v_expiry_date_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_ri_tsi_amt                  v_ri_tsi_amt_tab;
      v_ri_prem_amt                 v_ri_prem_amt_tab;
      v_ri_comm_amt                 v_ri_comm_amt_tab;
      v_ri_sname                    v_ri_sname_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_ri_cd                       v_ri_cd_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_ri_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT b250.line_cd, b250.subline_cd, b250.iss_cd, a120.line_name,
             a130.subline_name, Get_Policy_No (b250.policy_id) policy_no,
             b250.line_cd || '-' || LTRIM (TO_CHAR (d005.binder_yy, '09')) || '-'
             || LTRIM (TO_CHAR (d005.binder_seq_no, '099999')) binder_no,
             a020.assd_name, b250.policy_id,
             TO_CHAR (b250.incept_date, 'MM-DD-YYYY'),
             TO_CHAR (b250.expiry_date, 'MM-DD-YYYY'),
             d060.tsi_amt sum_insured, d060.prem_amt,
             d005.ri_tsi_amt amt_accepted, d005.ri_prem_amt prem_accepted,
             NVL(d005.ri_comm_amt,0) ri_comm_amt, a140.ri_sname ri_short_name,
             b250.acct_ent_date, b250.spld_acct_ent_date, d005.ri_cd,
             b250.endt_seq_no
        BULK COLLECT INTO v_line_cd, v_subline_cd, v_iss_cd, v_line_name,
                          v_subline_name, v_policy_no,
                          v_binder_no,
                          v_assd_name, v_policy_id,
                          v_incept_date,
                          v_expiry_date,
                          v_tsi_amt, v_prem_amt,
                          v_ri_tsi_amt, v_ri_prem_amt,
                          v_ri_comm_amt, v_ri_sname,
                          v_acct_ent_date, v_spld_acct_ent_date, v_ri_cd,
                          v_endt_seq_no
        FROM gipi_polbasic b250,
             giuw_pol_dist c080,
             giri_distfrps d060,
             giri_frps_ri d070,
             gipi_parlist b240,
             giri_binder d005,
             giis_line a120,
             giis_subline a130,
             giis_assured a020,
             giis_reinsurer a140
       WHERE d060.line_cd >= '%'
         AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
		 AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
         AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
         AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
         AND NVL (a120.line_cd, a120.line_cd) =
                                             NVL (b250.line_cd, b250.line_cd)
         AND NVL (b250.line_cd, b250.line_cd) =
                                             NVL (a130.line_cd, a130.line_cd)
         AND NVL (b250.subline_cd, b250.subline_cd) =
                                       NVL (a130.subline_cd, a130.subline_cd)
         AND (   b250.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date
                                                    AND p_to_date
                  OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
         AND d005.reverse_date IS NULL
	     AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
		 	 									  b250.line_cd,
		 	 				  					  b250.subline_cd,
												  b250.iss_cd,
												  b250.issue_yy,
												  b250.pol_seq_no,
												  b250.renew_no,
												  p_param_date,
												  p_from_date,
												  p_to_date),1) = 1
		 AND b240.assd_no 			   = a020.assd_no
         AND d005.ri_cd   			   = a140.ri_cd
         AND c080.dist_no 			   = d060.dist_no
         AND b250.par_id  			   = b240.par_id
         AND c080.policy_id 		   = b250.policy_id
         AND d070.fnl_binder_id 	   = d005.fnl_binder_id
		 AND NVL (b250.endt_type, 'A') = 'A'
--		 and b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
         AND b250.subline_cd 		   = NVL (p_subline_cd, b250.subline_cd)
		 AND b250.line_cd 			   = NVL (p_line_cd, b250.line_cd)
		 AND b250.iss_cd 			   = NVL (p_iss_cd, b250.iss_cd);

      IF v_policy_id.EXISTS (1) THEN

--if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
                  v_ri_tsi_amt (idx) := v_ri_tsi_amt (idx) * v_multiplier;
                  v_ri_prem_amt (idx) := v_ri_prem_amt (idx) * v_multiplier;
                  v_ri_comm_amt (idx) := v_ri_comm_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- for idx in 1 .. v_pol_count
      END IF; --if v_policy_id.exists(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
/*
dbms_output.put_line('assd_name-'||v_assd_name (cnt));
dbms_output.put_line('LINE_CD-'||v_line_cd (cnt));
dbms_output.put_line('SUBLINE_CD-'||v_subline_cd (cnt));
dbms_output.put_line('ISS_CD-'||v_iss_cd (cnt));
dbms_output.put_line('LINE_NAME-'||v_line_name (cnt));
dbms_output.put_line('SUBLINE_NAME-'||v_subline_name (cnt));
dbms_output.put_line('POLICY_NO-'||v_policy_no (cnt));
dbms_output.put_line('BINDER_NO-'||v_binder_no (cnt));
dbms_output.put_line('TOTAL_SI-'||v_tsi_amt (cnt));
dbms_output.put_line('TOTAL_PROM-'||v_prem_amt (cnt));
dbms_output.put_line('SUM_REINSURED-'||v_ri_tsi_amt (cnt));
dbms_output.put_line('SHARE_PREM-'||v_ri_prem_amt (cnt));
dbms_output.put_line('COMM_AMT-'||v_ri_comm_amt (cnt));
dbms_output.put_line('NET_DUE-'||nvl (v_ri_prem_amt (cnt), 0)
                         - nvl (v_ri_comm_amt (cnt), 0));
dbms_output.put_line('SHORT_NAME-'||v_ri_sname (cnt));
dbms_output.put_line('RI_CD-'||v_ri_cd (cnt));
dbms_output.put_line('POLICY_CD-'||v_policy_cd (cnt));
dbms_output.put_line('PARAM_DATE-'||p_param_date);
dbms_output.put_line('FROM_DATE-'||p_from_date);
dbms_output.put_line('TO_DATE-'||p_to_date);
dbms_output.put_line('USER_ID-'||p_user);*/
			INSERT INTO gipi_uwreports_ri_ext
                        (assd_name,
                         line_cd,
                         subline_cd,
                         iss_cd,
                         incept_date,
                         expiry_date,
                         line_name,
                         subline_name,
                         policy_no,
                         binder_no,
                         total_si,
                         total_prem,
                         sum_reinsured,
                         share_premium,
                         ri_comm_amt,
                         net_due,
                         ri_short_name,
                         ri_cd,
                         policy_id,
                         param_date,
                         from_date,
                         TO_DATE,
                         SCOPE,
                         user_id,
                         endt_seq_no)
                 VALUES (v_assd_name (cnt),
                         v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                         v_line_name (cnt),
                         v_subline_name (cnt),
                         v_policy_no (cnt),
                         v_binder_no (cnt),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_ri_tsi_amt (cnt),
                         v_ri_prem_amt (cnt),
                         v_ri_comm_amt (cnt),
                         NVL (v_ri_prem_amt (cnt), 0)
                         - NVL (v_ri_comm_amt (cnt), 0),
                         v_ri_sname (cnt),
                         v_ri_cd (cnt),
                         v_policy_id (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_endt_seq_no (cnt));
         COMMIT;
      END IF; --end of if sql%found
   END; --extract tab 3

   PROCEDURE extract_tab4 (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;
      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;
      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;
      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;
      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_peril_sname_tab IS TABLE OF giis_peril.peril_sname%TYPE;
      TYPE v_peril_name_tab IS TABLE OF giis_peril.peril_name%TYPE;
      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;
      TYPE v_peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;
      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;
      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;
      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;
	  TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;
	  v_cred_branch			 		v_cred_branch_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_line_name                   v_line_name_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_peril_sname                 v_peril_sname_tab;
      v_peril_name                  v_peril_name_tab;
      v_intm_name                   v_intm_name_tab;
      v_peril_cd                    v_peril_cd_tab;
      v_peril_type                  v_peril_type_tab;
      v_intm_no                     v_intm_no_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_policy_id                   v_policy_id_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_peril_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT   b250.line_cd, b250.subline_cd, a100.line_name,
               SUM (
                  NVL (b300.share_percentage, 0) / 100 * NVL (
                                                            b400.tsi_amt,
                                                            0)) tsi_amt,
               SUM (
                  NVL (b300.share_percentage, 0) / 100
                  * NVL (b400.prem_amt, 0)) prem_amt,
               a300.peril_sname, a300.peril_name, a400.intm_name,
               a300.peril_cd, a300.peril_type, a400.intm_no,
               b250.acct_ent_date, b250.spld_acct_ent_date, b250.policy_id,
               b250.iss_cd, b250.endt_seq_no
          BULK COLLECT INTO v_line_cd, v_subline_cd, v_line_name,
                            v_tsi_amt,
                            v_prem_amt,
                            v_peril_sname, v_peril_name, v_intm_name,
                            v_peril_cd, v_peril_type, v_intm_no,
                            v_acct_ent_date, v_spld_acct_ent_date, v_policy_id,
                            v_iss_cd, v_endt_seq_no
          FROM gipi_polbasic b250,
               gipi_comm_invoice b300,
               gipi_invperil b400,
               giis_line a100,
               giis_peril a300,
               giis_intermediary a400
         WHERE NVL (b300.intrmdry_intm_no, b300.intrmdry_intm_no) =
                                             NVL (a400.intm_no, a400.intm_no)
           AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
		   AND NVL (b400.peril_cd, b400.peril_cd) =
                                           NVL (a300.peril_cd, a300.peril_cd)
           AND NVL (a300.line_cd, a300.line_cd) =
                                             NVL (b250.line_cd, b250.line_cd)
           AND (   b250.pol_flag != '5'
                OR DECODE (p_param_date, 4, 1, 0) = 1)
           --and (b250.dist_flag = '3'  or decode(v_param_date,4,1,0) = 1)
           AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 1, 0, 1) = 1)
           AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
                OR DECODE (p_param_date, 2, 0, 1) = 1)
           AND (   LAST_DAY (
                      TO_DATE (
                         b250.booking_mth || ',' || TO_CHAR (
                                                       b250.booking_year),
                         'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                              AND LAST_DAY (p_to_date)
                OR DECODE (p_param_date, 3, 0, 1) = 1)
           AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date
                                                      AND p_to_date
                    OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                          BETWEEN p_from_date
                              AND p_to_date)
                OR DECODE (p_param_date, 4, 0, 1) = 1)
		   AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
		   	   		  								b250.line_cd,
		 	 				  					    b250.subline_cd,
												    b250.iss_cd,
												    b250.issue_yy,
												    b250.pol_seq_no,
												    b250.renew_no,
												    p_param_date,
												    p_from_date,
												    p_to_date),1) = 1
--           and b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
		   AND b250.line_cd = a100.line_cd
           AND b250.line_cd = a100.line_cd
           AND b300.iss_cd = b400.iss_cd
           AND b300.prem_seq_no = b400.prem_seq_no
           AND b250.policy_id = b300.policy_id
		   AND NVL (b250.endt_type, 'A') = 'A'
		   AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
           AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
		   AND b250.iss_cd <> Giacp.v ('RI_ISS_CD')
		   AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd)
      GROUP BY b250.line_cd,
               b250.subline_cd,
               a100.line_name,
               a300.peril_sname,
               a300.peril_name,
               a400.intm_name,
               a300.peril_cd,
               a300.peril_type,
               a400.intm_no,
               b250.acct_ent_date,
               b250.spld_acct_ent_date,
               b250.policy_id,
               b250.iss_cd,
               b250.endt_seq_no;

      IF v_policy_id.EXISTS (1) THEN

--if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- for idx in 1 .. v_pol_count
      END IF; --if v_policy_id.exists(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_peril_ext
                        (line_cd,
                         subline_cd,
                         iss_cd,
                         line_name,
                         tsi_amt,
                         prem_amt,
                         policy_id,
                         peril_cd,
                         peril_sname,
                         peril_name,
                         peril_type,
                         intm_no,
                         intm_name,
                         param_date,
                         from_date,
                         TO_DATE,
                         SCOPE,
                         user_id,
                         endt_seq_no)
                 VALUES (v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         v_line_name (cnt),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_policy_id (cnt),
                         v_peril_cd (cnt),
                         v_peril_sname (cnt),
                         v_peril_name (cnt),
                         v_peril_type (cnt),
                         v_intm_no (cnt),
                         v_intm_name (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_endt_seq_no (cnt));
         COMMIT;
      END IF; --end of if sql%found
   END; --extract tab 4 direct

   PROCEDURE extract_tab4_ri (
      p_scope        IN   NUMBER,
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;
      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;
      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;
      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;
      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_peril_sname_tab IS TABLE OF giis_peril.peril_sname%TYPE;
      TYPE v_peril_name_tab IS TABLE OF giis_peril.peril_name%TYPE;
      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;
      TYPE v_peril_cd_tab IS TABLE OF giis_peril.peril_cd%TYPE;
      TYPE v_peril_type_tab IS TABLE OF giis_peril.peril_type%TYPE;
      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;
      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;
      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;
	  TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;
	  v_cred_branch			 		v_cred_branch_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_line_name                   v_line_name_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_peril_sname                 v_peril_sname_tab;
      v_peril_name                  v_peril_name_tab;
      v_intm_name                   v_intm_name_tab;
      v_peril_cd                    v_peril_cd_tab;
      v_peril_type                  v_peril_type_tab;
      v_intm_no                     v_intm_no_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_policy_id                   v_policy_id_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      SELECT b250.line_cd, b250.subline_cd, a100.line_name, b400.tsi_amt,
             b400.prem_amt, a300.peril_sname, a300.peril_name, NULL,
             a300.peril_cd, a300.peril_type, NULL, b250.acct_ent_date,
             b250.spld_acct_ent_date, b250.policy_id, b250.iss_cd,
             b250.endt_seq_no
        BULK COLLECT INTO v_line_cd, v_subline_cd, v_line_name, v_tsi_amt,
                          v_prem_amt, v_peril_sname, v_peril_name, v_intm_name,
                          v_peril_cd, v_peril_type, v_intm_no, v_acct_ent_date,
                          v_spld_acct_ent_date, v_policy_id, v_iss_cd,
                          v_endt_seq_no
        FROM gipi_polbasic b250,
             gipi_invperil b400,
             giis_line a100,
             giis_peril a300,
             gipi_invoice l300
       WHERE 1 = 1
         AND b250.reg_policy_sw = DECODE(p_special_pol,'Y',b250.reg_policy_sw,'Y')
		 AND (   b250.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND (   TRUNC (b250.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (b250.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       b250.booking_mth || ',' || TO_CHAR (b250.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (b250.acct_ent_date) BETWEEN p_from_date
                                                    AND p_to_date
                  OR NVL (TRUNC (b250.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
	     AND DECODE (b250.pol_flag,'4',Check_Date(p_scope,
		 	 									  b250.line_cd,
		 	 				  					  b250.subline_cd,
												  b250.iss_cd,
												  b250.issue_yy,
												  b250.pol_seq_no,
												  b250.renew_no,
												  p_param_date,
												  p_from_date,
												  p_to_date),1) = 1
         AND b250.policy_id = l300.policy_id
         AND l300.iss_cd = b400.iss_cd
         AND l300.iss_cd = b400.iss_cd
         AND l300.prem_seq_no = b400.prem_seq_no
         AND l300.prem_seq_no = b400.prem_seq_no
         AND b400.peril_cd = a300.peril_cd
         AND a300.line_cd = b250.line_cd
         AND b250.line_cd = a100.line_cd
--         and b250.reg_policy_sw        = decode(p_special_pol,'Y',b250.reg_policy_sw,'Y')
		 AND NVL (b250.endt_type, 'A') = 'A'
         AND b250.subline_cd = NVL (p_subline_cd, b250.subline_cd)
		 AND b250.line_cd = NVL (p_line_cd, b250.line_cd)
         AND b250.iss_cd = Giacp.v ('RI_ISS_CD')
		 AND b250.iss_cd = NVL (p_iss_cd, b250.iss_cd);

      IF v_policy_id.EXISTS (1) THEN

--if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;
         END LOOP; -- for idx in 1 .. v_pol_count
      END IF; --if v_policy_id.exists(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_peril_ext
                        (line_cd,
                         subline_cd,
                         iss_cd,
                         line_name,
                         tsi_amt,
                         prem_amt,
                         policy_id,
                         peril_cd,
                         peril_sname,
                         peril_name,
                         peril_type,
                         intm_no,
                         intm_name,
                         param_date,
                         from_date,
                         TO_DATE,
                         SCOPE,
                         user_id,
                         endt_seq_no)
                 VALUES (v_line_cd (cnt),
                         v_subline_cd (cnt),
                         v_iss_cd (cnt),
                         v_line_name (cnt),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_policy_id (cnt),
                         v_peril_cd (cnt),
                         v_peril_sname (cnt),
                         v_peril_name (cnt),
                         v_peril_type (cnt),
                         v_intm_no (cnt),
                         v_intm_name (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_endt_seq_no (cnt));
         COMMIT;
      END IF; -- end of if sql%found
   END; --extract tab 4 ri

   PROCEDURE extract_tab5 (
      p_param_date   IN   NUMBER,
      p_from_date    IN   DATE,
      p_to_date      IN   DATE,
      p_scope        IN   NUMBER,
      p_iss_cd       IN   VARCHAR2,
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_user         IN   VARCHAR2,
      p_assd         IN   NUMBER,
      p_intm         IN   NUMBER,
	  p_parameter    IN   NUMBER,
	  p_special_pol  IN   VARCHAR2)
   AS
      TYPE v_policy_id_tab IS TABLE OF gipi_polbasic.policy_id%TYPE;
      TYPE v_assd_name_tab IS TABLE OF giis_assured.assd_name%TYPE;
      TYPE v_issue_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_line_cd_tab IS TABLE OF gipi_polbasic.line_cd%TYPE;
      TYPE v_subline_cd_tab IS TABLE OF gipi_polbasic.subline_cd%TYPE;
      TYPE v_iss_cd_tab IS TABLE OF gipi_polbasic.iss_cd%TYPE;
      TYPE v_issue_yy_tab IS TABLE OF gipi_polbasic.issue_yy%TYPE;
      TYPE v_pol_seq_no_tab IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;
      TYPE v_renew_no_tab IS TABLE OF gipi_polbasic.renew_no%TYPE;
      TYPE v_endt_iss_cd_tab IS TABLE OF gipi_polbasic.endt_iss_cd%TYPE;
      TYPE v_endt_yy_tab IS TABLE OF gipi_polbasic.endt_yy%TYPE;
      TYPE v_endt_seq_no_tab IS TABLE OF gipi_polbasic.endt_seq_no%TYPE;
      TYPE v_incept_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_expiry_date_tab IS TABLE OF VARCHAR2 (20);
      TYPE v_line_name_tab IS TABLE OF giis_line.line_name%TYPE;
      TYPE v_subline_name_tab IS TABLE OF giis_subline.subline_name%TYPE;
      TYPE v_tsi_amt_tab IS TABLE OF gipi_polbasic.tsi_amt%TYPE;
      TYPE v_prem_amt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_acct_ent_date_tab IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
      TYPE v_spld_acct_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;
      TYPE v_intm_name_tab IS TABLE OF giis_intermediary.intm_name%TYPE;
      TYPE v_assd_no_tab IS TABLE OF gipi_parlist.assd_no%TYPE;
      TYPE v_intm_no_tab IS TABLE OF giis_intermediary.intm_no%TYPE;
      TYPE v_evatprem_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_fst_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_lgt_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_doc_stamps_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_other_taxes_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
      TYPE v_other_charges_tab IS TABLE OF gipi_polbasic.prem_amt%TYPE;
	  TYPE v_cred_branch_tab IS TABLE OF gipi_polbasic.cred_branch%TYPE;
	  v_cred_branch			 		v_cred_branch_tab;
      v_policy_id                   v_policy_id_tab;
      v_assd_name                   v_assd_name_tab;
      v_issue_date                  v_issue_date_tab;
      v_line_cd                     v_line_cd_tab;
      v_subline_cd                  v_subline_cd_tab;
      v_iss_cd                      v_iss_cd_tab;
      v_issue_yy                    v_issue_yy_tab;
      v_pol_seq_no                  v_pol_seq_no_tab;
      v_renew_no                    v_renew_no_tab;
      v_endt_iss_cd                 v_endt_iss_cd_tab;
      v_endt_yy                     v_endt_yy_tab;
      v_endt_seq_no                 v_endt_seq_no_tab;
      v_incept_date                 v_incept_date_tab;
      v_expiry_date                 v_expiry_date_tab;
      v_line_name                   v_line_name_tab;
      v_subline_name                v_subline_name_tab;
      v_tsi_amt                     v_tsi_amt_tab;
      v_prem_amt                    v_prem_amt_tab;
      v_acct_ent_date               v_acct_ent_date_tab;
      v_spld_acct_ent_date          v_spld_acct_ent_date_tab;
      v_intm_name                   v_intm_name_tab;
      v_assd_no                     v_assd_no_tab;
      v_intm_no                     v_intm_no_tab;
      v_evatprem                    v_evatprem_tab;
      v_fst                         v_fst_tab;
      v_lgt                         v_lgt_tab;
      v_doc_stamps                  v_doc_stamps_tab;
      v_other_taxes                 v_other_taxes_tab;
      v_other_charges               v_other_charges_tab;
      v_multiplier                  NUMBER := 1;
   BEGIN
      DELETE FROM gipi_uwreports_intm_ext
            WHERE user_id = p_user;

      COMMIT;

      SELECT gp.policy_id gp_policy_id, ga.assd_name ga_assd_name,
             TO_CHAR (gp.issue_date, 'MM-DD-YYYY') gp_issue_date,
             gp.line_cd gp_line_cd, gp.subline_cd gp_subline_cd,
             gp.iss_cd gp_iss_cd, gp.issue_yy gp_issue_yy,
             gp.pol_seq_no gp_pol_seq_no, gp.renew_no gp_renew_no,
             gp.endt_iss_cd gp_endt_iss_cd, gp.endt_yy gp_endt_yy,
             gp.endt_seq_no gp_endt_seq_no,
             TO_CHAR (gp.incept_date, 'MM-DD-YYYY') gp_incept_date,
             TO_CHAR (gp.expiry_date, 'MM-DD-YYYY') gp_expiry_date,
             gl.line_name gl_line_name, gs.subline_name gs_subline_name,
             gp.tsi_amt gp_tsi_amt, gp.prem_amt gp_prem_amt,
             gp.acct_ent_date gp_acct_ent_date,
             gp.spld_acct_ent_date gp_spld_acct_ent_date,
             b.intm_name gp_intm_name, a.assd_no,
             gci.intrmdry_intm_no intm_no, NULL, NULL, NULL, NULL,
             NULL, NULL
        BULK COLLECT INTO v_policy_id, v_assd_name,
                          v_issue_date,
                          v_line_cd, v_subline_cd,
                          v_iss_cd, v_issue_yy,
                          v_pol_seq_no, v_renew_no,
                          v_endt_iss_cd, v_endt_yy,
                          v_endt_seq_no,
                          v_incept_date,
                          v_expiry_date,
                          v_line_name, v_subline_name,
                          v_tsi_amt, v_prem_amt,
                          v_acct_ent_date,
                          v_spld_acct_ent_date,
                          v_intm_name, v_assd_no,
                          v_intm_no, v_evatprem, v_fst, v_lgt, v_doc_stamps,
                          v_other_taxes, v_other_charges
        FROM gipi_polbasic gp,
             gipi_parlist a,
             giis_line gl,
             giis_subline gs,
             giis_issource gi,
             giis_assured ga,
             gipi_comm_invoice gci,
             giis_intermediary b
       WHERE 1 = 1
         AND gp.reg_policy_sw = DECODE(p_special_pol,'Y',gp.reg_policy_sw,'Y')
		 AND gci.intrmdry_intm_no = NVL (p_intm, gci.intrmdry_intm_no)
         AND ga.assd_no = NVL (p_assd, ga.assd_no)
         AND (   gp.pol_flag != '5'
              OR DECODE (p_param_date, 4, 1, 0) = 1)
         AND (   TRUNC (gp.issue_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 1, 0, 1) = 1)
         AND (   TRUNC (gp.eff_date) BETWEEN p_from_date AND p_to_date
              OR DECODE (p_param_date, 2, 0, 1) = 1)
         AND (   LAST_DAY (
                    TO_DATE (
                       gp.booking_mth || ',' || TO_CHAR (gp.booking_year),
                       'FMMONTH,YYYY')) BETWEEN LAST_DAY (p_from_date)
                                            AND LAST_DAY (p_to_date)
              OR DECODE (p_param_date, 3, 0, 1) = 1)
         AND (   (   TRUNC (gp.acct_ent_date) BETWEEN p_from_date
                                                  AND p_to_date
                  OR NVL (TRUNC (gp.spld_acct_ent_date), p_to_date + 1)
                        BETWEEN p_from_date
                            AND p_to_date)
              OR DECODE (p_param_date, 4, 0, 1) = 1)
		AND DECODE (gp.pol_flag,'4',Check_Date(p_scope,
				   							   gp.line_cd,
		 	 				  				   gp.subline_cd,
											   gp.iss_cd,
											   gp.issue_yy,
											   gp.pol_seq_no,
											   gp.renew_no,
											   p_param_date,
											   p_from_date,
											   p_to_date),1) = 1
		AND gp.line_cd = gl.line_cd
        AND gci.intrmdry_intm_no >= 0
        AND gp.policy_id = gci.policy_id
        AND b.intm_no = gci.intrmdry_intm_no
        AND a.par_id = gp.par_id
        AND gp.subline_cd = gs.subline_cd
        AND gl.line_cd = gs.line_cd
        AND ga.assd_no = a.assd_no
        AND gp.iss_cd = gi.iss_cd
--		and gp.reg_policy_sw        = decode(p_special_pol,'Y',gp.reg_policy_sw,'Y')
		AND NVL (gp.endt_type, 'A') = 'A'
        AND gp.subline_cd = NVL (p_subline_cd, gp.subline_cd)
		AND gp.line_cd = NVL (p_line_cd, gp.line_cd)
        AND gp.iss_cd <> Giacp.v ('RI_ISS_CD')
        AND gp.iss_cd = NVL (p_iss_cd, gp.iss_cd);

      IF v_policy_id.EXISTS (1) THEN

--if sql%found then
         FOR idx IN v_policy_id.FIRST .. v_policy_id.LAST
         LOOP
            BEGIN
               IF p_param_date = 4 THEN
                  IF      TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                            AND p_to_date
                      AND TRUNC (v_spld_acct_ent_date (idx))
                             BETWEEN p_from_date
                                 AND p_to_date THEN
                     v_multiplier := 0;
                  ELSIF TRUNC (v_acct_ent_date (idx)) BETWEEN p_from_date
                                                          AND p_to_date THEN
                     v_multiplier := 1;
                  ELSIF TRUNC (v_spld_acct_ent_date (idx)) BETWEEN p_from_date
                                                               AND p_to_date THEN
                     v_multiplier := -1;
                  END IF;

                  v_tsi_amt (idx) := v_tsi_amt (idx) * v_multiplier;
                  v_prem_amt (idx) := v_prem_amt (idx) * v_multiplier;
               END IF;
            END;

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_evat
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND (   git.tax_cd = Giacp.n ('EVAT')
                               OR git.tax_cd = Giacp.n ('5PREM_TAX'))
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_evatprem (idx) := NVL (c.gparam_evat, 0) * v_multiplier;
            END LOOP; -- for c in...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_prem_tax
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('FST')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_fst (idx) := NVL (c.gparam_prem_tax, 0) * v_multiplier;
            END LOOP; -- for c in...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_lgt
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('LGT')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_lgt (idx) := NVL (c.gparam_lgt, 0) * v_multiplier;
            END LOOP; -- for c in...

            FOR c IN  (SELECT SUM (
                                 git.tax_amt * giv.currency_rt)
                                    gparam_doc_stamps
                         FROM gipi_inv_tax git, gipi_invoice giv
                        WHERE giv.iss_cd = git.iss_cd
                          AND giv.prem_seq_no = git.prem_seq_no
                          AND git.tax_cd >= 0
                          AND giv.item_grp = git.item_grp
                          AND git.tax_cd = Giacp.n ('DOC_STAMPS')
                          AND giv.policy_id = v_policy_id (idx))
            LOOP
               v_doc_stamps (idx) :=
                                   NVL (c.gparam_doc_stamps, 0) * v_multiplier;
            END LOOP; -- for c in...

            FOR d IN
                (SELECT SUM (
                           NVL (git.tax_amt, 0) * giv.currency_rt) git_otax_amt
                   FROM gipi_inv_tax git, gipi_invoice giv
                  WHERE giv.iss_cd = git.iss_cd
                    AND giv.prem_seq_no = git.prem_seq_no
                    AND giv.policy_id = v_policy_id (idx)
                    AND NOT EXISTS ( SELECT gp.param_value_n
                                       FROM giac_parameters gp
                                      WHERE gp.param_name IN ('EVAT',
                                                              '5PREM_TAX',
                                                              'LGT',
                                                              'DOC_STAMPS',
                                                              'FST')
                                        AND gp.param_value_n = git.tax_cd))
            LOOP
               v_other_taxes (idx) := NVL (d.git_otax_amt, 0) * v_multiplier;
            END LOOP; -- for d in..

            FOR e IN  (SELECT SUM (
                                 NVL (giv.other_charges, 0) * giv.currency_rt)
                                    giv_otax_amt
                         FROM gipi_invoice giv
                        WHERE giv.policy_id = v_policy_id (idx))
            LOOP
               v_other_charges (idx) := NVL (e.giv_otax_amt, 0) * v_multiplier;
            END LOOP; --for e in...
         END LOOP; -- for idx in 1 .. v_pol_count
      END IF; --if v_policy_id.exists(1)

      IF SQL%FOUND THEN
         FORALL cnt IN v_policy_id.FIRST .. v_policy_id.LAST
            INSERT INTO gipi_uwreports_intm_ext
                        (assd_name,
                         line_cd,
                         line_name,
                         subline_cd,
                         subline_name,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_iss_cd,
                         endt_yy,
                         endt_seq_no,
                         incept_date,
                         expiry_date,
                         total_tsi,
                         total_prem,
                         evatprem,
                         fst,
                         lgt,
                         doc_stamps,
                         other_taxes,
                         other_charges,
                         param_date,
                         from_date,
                         TO_DATE,
                         SCOPE,
                         user_id,
                         policy_id,
                         intm_name,
                         assd_no,
                         intm_no,
                         issue_date)
                 VALUES (v_assd_name (cnt),
                         v_line_cd (cnt),
                         v_line_name (cnt),
                         v_subline_cd (cnt),
                         v_subline_name (cnt),
                         v_iss_cd (cnt),
                         v_issue_yy (cnt),
                         v_pol_seq_no (cnt),
                         v_renew_no (cnt),
                         v_endt_iss_cd (cnt),
                         v_endt_yy (cnt),
                         v_endt_seq_no (cnt),
                         TO_DATE (v_incept_date (cnt), 'MM-DD-YYYY'),
                         TO_DATE (v_expiry_date (cnt), 'MM-DD-YYYY'),
                         v_tsi_amt (cnt),
                         v_prem_amt (cnt),
                         v_evatprem (cnt),
                         v_fst (cnt),
                         v_lgt (cnt),
                         v_doc_stamps (cnt),
                         v_other_taxes (cnt),
                         v_other_charges (cnt),
                         p_param_date,
                         p_from_date,
                         p_to_date,
                         p_scope,
                         p_user,
                         v_policy_id (cnt),
                         v_intm_name (cnt),
                         v_assd_no (cnt),
                         v_intm_no (cnt),
                         TO_DATE (v_issue_date (cnt), 'MM-DD-YYYY'));
         COMMIT;
      END IF; --end of if sql%found
   END; --extract tab 5
END P_Uwreports_22dec2004;
/

DROP PACKAGE CPI.P_UWREPORTS_22DEC2004;

