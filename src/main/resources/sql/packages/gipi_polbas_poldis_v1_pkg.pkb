CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Polbas_Poldis_V1_Pkg AS

  FUNCTION get_gipi_polbas_poldis ( p_line_cd		   GIPI_POLBASIC.line_cd%TYPE,
									p_subline_cd	   GIPI_POLBASIC.subline_cd%TYPE,
									p_iss_cd		   GIPI_POLBASIC.iss_cd%TYPE,
									p_issue_yy		   GIPI_POLBASIC.issue_yy%TYPE,
									p_pol_seq_no	   GIPI_POLBASIC.pol_seq_no%TYPE,
									p_endt_iss_cd	   GIPI_POLBASIC.endt_iss_cd%TYPE,
									p_endt_yy		   GIPI_POLBASIC.endt_yy%TYPE,
									p_endt_seq_no	   GIPI_POLBASIC.endt_seq_no%TYPE,
									p_renew_no		   GIPI_POLBASIC.renew_no%TYPE,
									p_dist_no		   GIUW_POL_DIST.dist_no%TYPE )
    RETURN gipi_polbas_poldis_tab PIPELINED IS

	v_polbas_poldis		gipi_polbas_poldis_type;

  BEGIN
    FOR i IN (
		SELECT policy_id,     line_cd,     subline_cd,  iss_cd,
			   issue_yy, 	  pol_seq_no,  endt_iss_cd, endt_yy,
			   endt_seq_no,   renew_no,    par_id, 		pol_flag,
			   acct_ent_date, spld_flag,   dist_no, 	dist_flag,
			   eff_date, 	  expiry_date, negate_date, dist_type,
			   acct_neg_date, assd_no, 	   par_type
		  FROM GIPI_POLBASIC_POL_DIST_V1
		 WHERE line_cd	   = NVL(p_line_cd, line_cd)
		   AND subline_cd  = NVL(p_subline_cd, subline_cd)
		   AND iss_cd	   = NVL(p_iss_cd, iss_cd)
		   AND issue_yy	   = NVL(p_issue_yy, issue_yy)
		   AND pol_seq_no  = NVL(p_pol_seq_no, pol_seq_no)
		   AND endt_iss_cd = NVL(p_endt_iss_cd, endt_iss_cd)
		   AND endt_yy	   = NVL(p_endt_yy, endt_yy)
		   AND endt_seq_no = NVL(p_endt_seq_no, endt_seq_no)
		   AND renew_no	   = NVL(p_renew_no, renew_no)
		   AND dist_no	   = NVL(p_dist_no, dist_no)
		 ORDER BY line_cd,      subline_cd,
		 	   	  iss_cd,       issue_yy desc,
				  pol_seq_no,   endt_iss_cd,
				  endt_yy desc, endt_seq_no,
				  dist_no)
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

END Gipi_Polbas_Poldis_V1_Pkg;
/


