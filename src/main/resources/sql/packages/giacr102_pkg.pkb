CREATE OR REPLACE PACKAGE BODY CPI.giacr102_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.08.2013
    **  Reference By : GIACR102 -  DISBURSEMENT/PURCHASE REGISTER
    */
   FUNCTION get_details(
      p_line_cd            VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list               get_details_type;
      v_exists             BOOLEAN := FALSE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      v_list.cf_run_date := 'As of ' || TO_CHAR (SYSDATE, 'fmMONTH DD, YYYY');

      FOR i IN
         (SELECT   b.dist_flag, r.rv_meaning, l.line_name, s.subline_name,
                   DECODE
                         (b.endt_seq_no,
                          0,  b.line_cd
                           || '-'
                           || b.subline_cd
                           || '-'
                           || b.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (b.issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                           || '-'
                           || LTRIM (TO_CHAR (b.renew_no, '09')),
                             b.line_cd
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
                          || '/'
                          || b.endt_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (b.endt_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.endt_seq_no, '099999'))
                         ) policy_endorsement,
                   b.issue_date, b.incept_date, a.assd_name, b.tsi_amt,
                   b.prem_amt
              FROM cg_ref_codes r,
                   giis_line l,
                   gipi_polbasic b,
                   giis_subline s,
                   giis_assured a,
                   gipi_parlist p
             WHERE r.rv_low_value = b.dist_flag
               AND r.rv_low_value IN ('1', '2', '4')
               AND b.dist_flag IN ('1', '2', '4')
               AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'
               AND b.iss_cd != 'RI'
               AND l.line_cd = b.line_cd
               AND s.subline_cd = b.subline_cd
               AND s.line_cd = l.line_cd
               AND a.assd_no = b.assd_no
               AND p.par_id = b.par_id
               AND b.pol_flag <> '5'
               AND NVL (b.endt_type, 0) <> 'N'
               AND b.subline_cd <> 'MOP'
               AND b.acct_ent_date IS NULL
               AND l.line_cd = NVL (p_line_cd, l.line_cd)
               /*AND check_user_per_iss_cd_acctg2(b.line_cd, b.iss_cd, 'GIACS102', p_user_id) = 1 -- marco - 08.13.2013 - added user id parameter
               AND check_user_per_line2(b.line_cd, b.iss_cd, 'GIACS102', p_user_id) = 1*/--modified checking of security by albert 10.22.2015 (GENQA SR 4465)
               AND b.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS102',p_user_id)))
          ORDER BY b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no)
      LOOP
         v_exists := TRUE;
         v_list.dist_flag := i.dist_flag;
         v_list.rv_meaning := i.rv_meaning;
         v_list.line_name := i.line_name;
         v_list.subline_name := i.subline_name;
         v_list.policy_endorsement := i.policy_endorsement;
         v_list.issue_date := i.issue_date;
         v_list.incept_date := i.incept_date;
         v_list.assd_name := i.assd_name;
         v_list.tsi_amt := i.tsi_amt;
         v_list.prem_amt := i.prem_amt;
         PIPE ROW (v_list);
      END LOOP;
  
      IF NOT v_exists THEN  --marco
         PIPE ROW(v_list);
      END IF;

      RETURN;
   END get_details;
END giacr102_pkg;
/
