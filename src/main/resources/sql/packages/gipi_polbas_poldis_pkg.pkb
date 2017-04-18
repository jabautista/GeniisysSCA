CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Polbas_Poldis_Pkg AS

  FUNCTION get_gipi_polbas_poldis ( p_line_cd		   GIPI_POLBASIC.line_cd%TYPE,
									p_subline_cd	   GIPI_POLBASIC.subline_cd%TYPE,
									p_iss_cd		   GIPI_POLBASIC.iss_cd%TYPE,
									p_issue_yy		   GIPI_POLBASIC.issue_yy%TYPE,
									p_pol_seq_no	   GIPI_POLBASIC.pol_seq_no%TYPE,
									p_endt_iss_cd	   GIPI_POLBASIC.endt_iss_cd%TYPE,
									p_endt_yy		   GIPI_POLBASIC.endt_yy%TYPE,
									p_endt_seq_no	   GIPI_POLBASIC.endt_seq_no%TYPE,
									p_renew_no		   GIPI_POLBASIC.renew_no%TYPE,
									p_assd_name		   GIIS_ASSURED.assd_name%TYPE,
									p_dist_no		   GIUW_POL_DIST.dist_no%TYPE,
									p_dist_flag		   GIUW_POL_DIST.dist_flag%TYPE,
									p_mean_dist_flag   CG_REF_CODES.rv_meaning%TYPE )
    RETURN gipi_polbas_poldis_tab PIPELINED IS

	v_polbas_poldis		gipi_polbas_poldis_type;

  BEGIN
    FOR i IN (
		SELECT a.policy_id,      a.line_cd,    a.subline_cd,    a.iss_cd,
			   a.issue_yy, 	  	 a.pol_seq_no, a.endt_iss_cd, 	a.endt_yy,
			   a.endt_seq_no,    a.renew_no,   a.par_id, 	 	a.pol_flag,
			   a.acct_ent_date,  a.spld_flag,  a.dist_no, 	 	a.dist_flag,
			   b.rv_meaning mean_dist_flag,    a.eff_date,    	a.expiry_date,
			   a.negate_date,    a.dist_type,  a.acct_neg_date, a.assd_no,
			   c.assd_name,	   	 a.par_type
		  FROM GIPI_POLBASIC_POL_DIST_V a
		  	  ,CG_REF_CODES				b
			  ,GIIS_ASSURED				c
 		 WHERE a.dist_flag    = b.rv_low_value
 		   AND b.rv_domain 	  = 'GIUW_POL_DIST.DIST_FLAG'
 		   AND a.assd_no	  = c.assd_no
 		   AND a.line_cd	  = NVL(p_line_cd, a.line_cd)
		   AND a.subline_cd   = NVL(p_subline_cd, a.subline_cd)
		   AND a.iss_cd	   	  = NVL(p_iss_cd, a.iss_cd)
		   AND a.issue_yy	  = NVL(p_issue_yy, a.issue_yy)
		   AND a.pol_seq_no   = NVL(p_pol_seq_no, a.pol_seq_no)
		   AND a.endt_iss_cd  = NVL(p_endt_iss_cd, a.endt_iss_cd)
		   AND a.endt_yy	  = NVL(p_endt_yy, a.endt_yy)
		   AND a.endt_seq_no  = NVL(p_endt_seq_no, a.endt_seq_no)
		   AND a.renew_no	  = NVL(p_renew_no, a.renew_no)
		   AND a.dist_no	  = NVL(p_dist_no, a.dist_no)
		   AND a.dist_flag	  = NVL(p_dist_flag, a.dist_flag)
		   AND b.rv_meaning   = NVL(p_mean_dist_flag, b.rv_meaning)
		   AND c.assd_name	  = NVL(p_assd_name, c.assd_name)
		 ORDER BY a.line_cd,      a.subline_cd,
		 	   	  a.iss_cd,       a.issue_yy desc,
				  a.pol_seq_no,   a.endt_iss_cd,
				  a.endt_yy desc, a.endt_seq_no,
				  a.dist_no)
	LOOP
	    v_polbas_poldis.policy_id		   := i.policy_id;
		v_polbas_poldis.line_cd			   := i.line_cd;
		v_polbas_poldis.subline_cd		   := i.subline_cd;
		v_polbas_poldis.iss_cd			   := i.iss_cd;
		v_polbas_poldis.issue_yy		   := i.issue_yy;
		v_polbas_poldis.pol_seq_no		   := i.pol_seq_no;
		v_polbas_poldis.endt_iss_cd		   := i.endt_iss_cd;
		v_polbas_poldis.endt_yy			   := i.endt_yy;
		v_polbas_poldis.endt_seq_no		   := i.endt_seq_no;
		v_polbas_poldis.renew_no		   := i.renew_no;
		v_polbas_poldis.par_id			   := i.par_id;
		v_polbas_poldis.pol_flag		   := i.pol_flag;
		v_polbas_poldis.acct_ent_date	   := i.acct_ent_date;
		v_polbas_poldis.spld_flag		   := i.spld_flag;
		v_polbas_poldis.dist_no			   := i.dist_no;
		v_polbas_poldis.dist_flag		   := i.dist_flag;
		v_polbas_poldis.eff_date		   := i.eff_date;
		v_polbas_poldis.expiry_date		   := i.expiry_date;
		v_polbas_poldis.negate_date		   := i.negate_date;
		v_polbas_poldis.dist_type		   := i.dist_type;
		v_polbas_poldis.acct_neg_date	   := i.acct_neg_date;
		v_polbas_poldis.assd_no			   := i.assd_no;
		v_polbas_poldis.par_type		   := i.par_type;
	  PIPE ROW(v_polbas_poldis);
	END LOOP;
	RETURN;
  END get_gipi_polbas_poldis;

END Gipi_Polbas_Poldis_Pkg;
/


