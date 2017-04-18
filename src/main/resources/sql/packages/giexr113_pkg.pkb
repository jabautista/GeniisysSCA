CREATE OR REPLACE PACKAGE BODY CPI.GIEXR113_PKG AS
	/*
	** Created By: bonok
	** Date Created: 01.16.2013
	** Reference By: GIEXR113
	** Description: Expiry List of Direct Business (BY ASSURED)
	*/
	FUNCTION get_giexr113_details(
		p_line_cd			giex_expiries_v.line_cd%TYPE,
		p_subline_cd		giex_expiries_v.subline_cd%TYPE,
		p_iss_cd			giex_expiries_v.iss_cd%TYPE,
		p_intm_no			giex_expiries_v.intm_no%TYPE,
		p_assd_no			giex_expiries_v.assd_no%TYPE,
		p_policy_id			giex_expiries_v.policy_id%TYPE,
		p_starting_date		VARCHAR2,
		p_ending_date		VARCHAR2,        
		p_include_pack		VARCHAR2,
		p_claim_flag		giex_expiries_v.claim_flag%TYPE,
		p_balance_flag		giex_expiries_v.balance_flag%TYPE
	)
		RETURN giexr113_details_tab PIPELINED
	IS
		res		giexr113_details_type;
	BEGIN
		FOR i IN
          (SELECT   a.line_cd || '-' ||RTRIM(a.subline_cd) || '-' ||
                     RTRIM(a.iss_cd) || '-' ||
                     LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||
                     LTRIM(TO_CHAR(a.pol_seq_no, '0999999')) || '-' ||
                     LTRIM(TO_CHAR(a.renew_no, '09')) policy_no
                     ,a.line_cd
                     ,a.subline_cd
                     ,a.iss_cd
                     ,a.issue_yy
                     ,a.pol_seq_no
                     ,a.renew_no
                     ,a.iss_cd iss_cd2
                     ,a.line_cd line_cd2
                     ,a.subline_cd subline_cd2
                     ,a.policy_id
                     ,a.tsi_amt
                     ,a.prem_amt
                     ,NVL(a.ren_tsi_amt, 0) ren_tsi_amt
                     ,NVL(a.ren_prem_amt, 0) ren_prem_amt
                     ,a.tax_amt
                     ,a.expiry_date
                     ,DECODE(a.balance_flag, 'Y', '*', NULL) balance_flag
                     ,DECODE(a.claim_flag, 'Y', '*', NULL) claim_flag
                     ,b.line_name
                     ,c.subline_name
                     ,d.iss_name
                     ,a.assd_no
                     ,e.assd_name
               FROM giex_expiry a,
                    giis_line b,
                    giis_subline c,
                    giis_issource d,
                    giis_assured e
              WHERE a.line_cd = b.line_cd
                AND a.line_cd = c.line_cd
                AND a.subline_cd = c.subline_cd
                AND a.iss_cd = d.iss_cd
                AND a.assd_no = e.assd_no
                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                AND NVL (a.intm_no, 0) = NVL (p_intm_no, NVL (a.intm_no, 0))
                AND a.assd_no = NVL (p_assd_no, a.assd_no)
                AND NVL (a.post_flag, 'N') = 'N'
                AND a.policy_id = NVL (p_policy_id, a.policy_id)
                AND TRUNC (a.expiry_date)
                       BETWEEN TRUNC (NVL (TO_DATE (p_starting_date, 'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_ending_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                           AND TRUNC (NVL (TO_DATE (p_ending_date, 'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_starting_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                AND NVL (a.claim_flag, 'N') LIKE
                        NVL (p_claim_flag, DECODE (p_balance_flag, 'Y', 'N', '%'))
                AND NVL (a.balance_flag, 'N') LIKE
                        NVL (p_balance_flag, DECODE (p_claim_flag, 'Y', 'N', '%'))
                AND pack_policy_id IS NULL
           UNION ALL
           SELECT      f.line_cd
                    || '-'
                    || RTRIM (f.subline_cd)
                    || '-'
                    || RTRIM (f.iss_cd)
                    || '-'
                    || LTRIM (TO_CHAR (f.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (f.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (f.renew_no, '09')) policy_no,
                    f.line_cd, 
                    f.subline_cd,
                    f.iss_cd, 
                    f.issue_yy,
                    f.pol_seq_no,
                    f.renew_no,
                    f.iss_cd iss_cd2,
                    f.line_cd line_cd2,
                    f.subline_cd subline_cd2, 
                    f.policy_id,                 
                    a.tsi_amt, 
                    a.prem_amt,
                    NVL (a.ren_tsi_amt, 0) ren_tsi_amt,
                    NVL (a.ren_prem_amt, 0) ren_prem_amt, 
                    a.tax_amt,
                    a.expiry_date,
                    DECODE (a.balance_flag, 'Y', '*', NULL) balance_flag,
                    DECODE (a.claim_flag, 'Y', '*', NULL) claim_flag, 
                    b.line_name,
                    c.subline_name,
                    d.iss_name, 
                    a.assd_no, 
                    e.assd_name
               FROM giex_pack_expiry a,
                    giex_expiry f,
                    giis_line b,
                    giis_subline c,
                    giis_issource d,
                    giis_assured e
              WHERE c.line_cd = b.line_cd
                AND a.pack_policy_id = f.pack_policy_id
                AND b.line_cd = c.line_cd
                AND f.subline_cd = c.subline_cd
                AND f.iss_cd = d.iss_cd
                AND a.assd_no = e.assd_no
                AND a.pack_policy_id = NVL (p_policy_id, a.pack_policy_id)
                AND f.line_cd = NVL (p_line_cd, f.line_cd)
                AND f.subline_cd = NVL (p_subline_cd, f.subline_cd)
                AND f.iss_cd = NVL (p_iss_cd, f.iss_cd)
                AND NVL (f.intm_no, 0) = NVL (p_intm_no, NVL (f.intm_no, 0))
                AND a.assd_no = NVL (p_assd_no, a.assd_no)
                AND NVL (a.post_flag, 'N') = 'N'
                AND TRUNC (a.expiry_date)
                       BETWEEN TRUNC (NVL (TO_DATE (p_starting_date,
                                                    'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_ending_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                           AND TRUNC (NVL (TO_DATE (p_ending_date, 'dd-MM-RRRR'),
                                           NVL (TO_DATE (p_starting_date,
                                                         'dd-MM-RRRR'
                                                        ),
                                                a.expiry_date
                                               )
                                          )
                                     )
                AND DECODE (p_include_pack, 'N', a.pack_policy_id, 0) = 0
                AND NVL (a.claim_flag, 'N') LIKE
                       NVL (p_claim_flag,
                            DECODE (p_balance_flag, 'Y', 'N', '%'))
                AND NVL (a.balance_flag, 'N') LIKE
                       NVL (p_balance_flag,
                            DECODE (p_claim_flag, 'Y', 'N', '%'))
           ORDER BY assd_name, line_cd)        
		LOOP
			res.policy_no	  := i.policy_no;
			res.line_cd		  := i.line_cd;
        	res.subline_cd	  := i.subline_cd;
        	res.iss_cd		  := i.iss_cd;
        	res.issue_yy	  := i.issue_yy;
        	res.pol_seq_no	  := i.pol_seq_no;
        	res.renew_no	  := i.renew_no;
        	res.iss_cd2		  := i.iss_cd2;
        	res.line_cd2	  := i.line_cd2;
        	res.subline_cd2	  := i.subline_cd2;
        	res.policy_id	  := i.policy_id;
        	res.tsi_amt		  := i.tsi_amt;
        	res.prem_amt	  := i.prem_amt;
			res.ren_tsi_amt	  := i.ren_tsi_amt;
        	res.ren_prem_amt  := i.ren_prem_amt;
        	res.tax_amt		  := i.tax_amt;
        	res.expiry_date	  := i.expiry_date;
        	res.balance_flag  := i.balance_flag;
        	res.claim_flag	  := i.claim_flag;
			res.assd_no		  := i.assd_no;
			res.assd_name	  := i.assd_name;
			res.line_name	  := i.line_name;
			res.subline_name  := i.subline_name;
			res.iss_name      := i.iss_name;
			res.total_due     := i.ren_prem_amt + NVL(i.tax_amt, 0);
            res.starting_date := TO_CHAR(TO_DATE(p_starting_date, 'dd-MM-RRRR'), 'Month dd, RRRR');
            res.ending_date   := TO_CHAR(TO_DATE(p_ending_date, 'dd-MM-RRRR'), 'Month dd, RRRR');
            
            SELECT ref_pol_no 
			  INTO res.ref_pol_no
              FROM gipi_polbasic
 	         WHERE policy_id = i.policy_id
 		       AND ROWNUM = 1;
            
			PIPE ROW(res);
		END LOOP;	
	END get_giexr113_details; 
    
    FUNCTION get_giexr113_company_details
        RETURN giexr113_company_details_tab PIPELINED
    IS
        res     giexr113_company_details_type;
    BEGIN
        SELECT param_value_v
          INTO res.company_name
          FROM giis_parameters
         WHERE param_name = 'COMPANY_NAME';
        
        SELECT param_value_v
          INTO res.company_address
          FROM giis_parameters
         WHERE param_name = 'COMPANY_ADDRESS';
         
		PIPE ROW(res);
    END get_giexr113_company_details;
END;
/


