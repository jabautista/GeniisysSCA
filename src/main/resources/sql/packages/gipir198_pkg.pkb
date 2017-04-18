CREATE OR REPLACE PACKAGE BODY CPI.gipir198_pkg
AS
   FUNCTION get_gipir198_dtls (
      p_starting_date   DATE,
      p_ending_date     DATE,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN gipir198_dtls_tab PIPELINED
   IS
      gipir198      gipir198_dtls_type;
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      FOR i IN (SELECT line_cd,
                          line_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || TO_CHAR (par_yy, 'fm09')
                       || '-'
                       || TO_CHAR (par_seq_no, 'fm0999999') par_number,
                       get_assd_name (assd_no) assd_name, incept_date,
                       expiry_date, covernote_expiry, tsi_amt, prem_amt
                  FROM gixx_covernote_exp
                 WHERE user_id = p_user_id
                   AND covernote_expiry BETWEEN p_starting_date AND p_ending_date)
      LOOP
         SELECT line_name
           INTO gipir198.line_name
           FROM giis_line
          WHERE line_cd = i.line_cd;

         gipir198.line_cd := i.line_cd;
         gipir198.cf_line_name := i.line_cd || ' - ' || gipir198.line_name;
         gipir198.par_number := i.par_number;
         gipir198.assd_name := i.assd_name;
         gipir198.incept_date := TO_CHAR (i.incept_date, 'MM-DD-RRRR');
         gipir198.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-RRRR');
         gipir198.covernote_expiry :=
                                    TO_CHAR (i.covernote_expiry, 'MM-DD-RRRR');
         gipir198.tsi_amt := i.tsi_amt;
         gipir198.prem_amt := i.prem_amt;
         gipir198.company_name := company_nameformula;
         gipir198.company_address := company_addressformula;
         gipir198.report_desc := 'LIST OF EXPIRING COVERNOTES';
         gipir198.report_date_period :=
               'FOR THE PERIOD '
            || TO_CHAR (p_starting_date, 'fmMONTH DD, YYYY')
            || ' TO '
            || TO_CHAR (p_ending_date, 'fmMONTH DD, YYYY');
         PIPE ROW (gipir198);
      END LOOP;

      RETURN;
   END get_gipir198_dtls;

   FUNCTION company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_company_name
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_company_name := ' ';
      END;

      RETURN (v_company_name);
   END company_nameformula;

   FUNCTION company_addressformula
      RETURN VARCHAR2
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END company_addressformula;
END;
/


