CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924D_PKG
AS
	/*
   **  Created by   :  Steven Ramirez
   **  Date Created : 05.14.2012
   **  Reference By : GIPIR924D - Underwriting Production Report(Undistributed)
   **  Description  :
   */
	
	FUNCTION get_header_gipr924D
      RETURN header_tab PIPELINED
   AS
      rep   header_type;
   BEGIN
      rep.cf_company := gipir924D_pkg.cf_companyformula;
      rep.cf_company_address := gipir924D_pkg.cf_company_addressformula;
      rep.cf_heading3 := 'As of '||TO_CHAR(SYSDATE, 'fmMonth DD, YYYY');
      PIPE ROW (rep);
   END;
   
   FUNCTION cf_companyformula
      RETURN CHAR
   IS
      v_company_name   VARCHAR2 (150);
   BEGIN
      SELECT param_value_v
        INTO v_company_name
        FROM giis_parameters
       WHERE UPPER (param_name) = 'COMPANY_NAME';

      RETURN (v_company_name);
   END;
   
    FUNCTION cf_company_addressformula
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;
   
    FUNCTION populate_gipir924D (
      p_iss_param    gipi_polbasic.iss_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
	  p_direct		 NUMBER,
	  p_ri		 	 NUMBER,
	  p_user_id      GIIS_USERS.user_id%TYPE --added by robert 01.02.2014
   )
      RETURN report_tab PIPELINED
   AS
      rep            report_type;
   BEGIN
      FOR i IN
         (SELECT   r.rv_meaning, l.line_name, s.subline_name,
         DECODE (
            b.endt_seq_no,
            0, b.line_cd || '-' || b.subline_cd || '-' || b.iss_cd || '-'
               || LTRIM (TO_CHAR (b.issue_yy, '09')) || '-'
               || LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) || '-'
               || LTRIM (TO_CHAR (b.renew_no, '09')),
            b.line_cd || '-' || b.subline_cd || '-' || b.iss_cd || '-'
            || LTRIM (TO_CHAR (b.issue_yy, '09')) || '-'
            || LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) || '-'
            || LTRIM (TO_CHAR (b.renew_no, '09')) || '/' || b.endt_iss_cd || '-'
            || LTRIM (TO_CHAR (b.endt_yy, '09')) || '-'
            || LTRIM (TO_CHAR (b.endt_seq_no, '099999'))) Policy_Endorsement,
         b.issue_date, b.incept_date, a.assd_name, b.tsi_amt, b.prem_amt, decode(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd 
    FROM cg_ref_codes r,
         giis_line l,
         gipi_polbasic b,
         giuw_pol_dist c,
         giis_subline s,
         giis_assured a,
         gipi_parlist p
   WHERE r.rv_low_value = b.dist_flag
     AND r.rv_low_value IN ('1', '2', '4')
     AND c.dist_flag IN ('1', '2', '4')
     AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'
--and B.ISS_CD != 'RI'
--     AND b.iss_cd = NVL(:p_iss_cd, b.iss_cd)
     AND b.iss_cd IN (SELECT iss_cd
                        FROM giis_issource
                       WHERE (   (    iss_cd = giacp.v ('REINSURER')
                                  AND p_direct <> 1
                                  AND p_ri = 1)
                              OR (    iss_cd <> giacp.v ('REINSURER')
                                  AND p_direct = 1
                                  AND p_ri <> 1)
                              OR (1 = 1 AND p_direct = 1 AND p_ri = 1)))
     AND l.line_cd = b.line_cd
     AND s.subline_cd = b.subline_cd
     AND s.line_cd = l.line_cd
     AND a.assd_no = b.assd_no
     AND p.par_id = b.par_id
     AND b.policy_id = c.policy_id
     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
     AND b.pol_flag <> '5'
     AND NVL (b.endt_type, 0) <> 'N'
     AND b.subline_cd <> 'MOP'
    -- AND b.acct_ent_date IS NULL
     AND b.line_cd = NVL (p_line_cd, b.line_cd)
	 /* added security rights control by robert 01.02.14*/
     AND check_user_per_iss_cd2 (b.line_cd,DECODE (p_iss_param,1, b.cred_branch,b.iss_cd),'GIPIS901A', p_user_id) =1
     AND check_user_per_line2 (b.line_cd,DECODE (p_iss_param,1, b.cred_branch,b.iss_cd),'GIPIS901A', p_user_id) = 1
     /* robert 01.02.14 end of added code */
ORDER BY b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
   )   

         LOOP
		 	--rep.dist_flag := i.dist_flag;
            rep.rv_meaning := i.rv_meaning;
			rep.line_name := i.line_name;
			rep.subline_name:= i.subline_name;
            rep.Policy_Endorsement:= i.Policy_Endorsement;
            rep.issue_date:= i.issue_date;
            rep.incept_date:= i.incept_date;
            rep.assd_name:= i.assd_name;
            rep.tsi_amt:= i.tsi_amt;
            rep.prem_amt:= i.prem_amt;
            rep.iss_cd:= i.iss_cd;
			rep.cf_iss_name := gipir924D_pkg.cf_iss_nameformula(p_iss_param,i.iss_cd);
         PIPE ROW (rep);
      END LOOP;

      RETURN;
   END populate_gipir924D; 
   
   	FUNCTION cf_iss_nameformula( 
	p_iss_param    gipi_polbasic.iss_cd%TYPE,
	i_iss_cd       giis_issource.iss_cd%TYPE
	)
   		RETURN CHAR
	IS
   v_iss_name                    VARCHAR2 (50);
	BEGIN
  		 BEGIN
			  SELECT iss_name
				INTO v_iss_name
				FROM giis_issource
			   WHERE iss_cd = i_iss_cd;
			   EXCEPTION
				  WHEN NO_DATA_FOUND THEN
					 RETURN ('No branch name');
		  END;
	 IF p_iss_param = 1 THEN
      RETURN ('Crediting Branch : '|| v_iss_name);
	 ELSE
	 	  RETURN ('Issuing Source   : '|| v_iss_name);
	 END IF;	 
	END;
   
 END gipir924D_pkg;
/


