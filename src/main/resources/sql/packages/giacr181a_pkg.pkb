CREATE OR REPLACE PACKAGE BODY CPI.giacr181a_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.21.2013
   **  Reference By : GIACR181A Schedule of Premiums Ceded to Facultative RI (Summary)
   **  Description  :
   */
   FUNCTION get_giacr181a_records (
      p_ri_cd     giri_binder.ri_cd%TYPE,
      p_line_cd   giri_binder.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN giacr181a_records_tab PIPELINED
   IS
      v_rec         giacr181a_records_type;
      v_not_exist   BOOLEAN               := TRUE;
      v_fund_cd  giac_parameters.param_value_v%TYPE;
      v_iss_cd   giis_user_grp_hdr.grp_iss_cd%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company
           FROM giis_parameters
          WHERE UPPER (param_name) = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      FOR i IN (SELECT   line_cd, ri_cd, ri_name, booking_date,
                         SUM (amt_insured) amt_insured,
                         SUM (ri_prem_amt) ri_prem_amt, prem_vat,-- Rosch, 01/16/2006
                         prem_tax,--cris 07/22/2008
                         SUM (ri_comm_amt) ri_comm_amt, comm_vat,
                         wholding_vat,
                         SUM ((ri_prem_amt+ NVL (prem_vat, 0)- NVL (prem_tax, 0))- (ri_comm_amt+ NVL (comm_vat, 0)+ NVL (wholding_vat, 0))) net_prem, -- Rosch, 01/16/2006
                         to_date,from_date
                    FROM giac_dueto_ext
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND ri_cd = NVL (p_ri_cd, ri_cd)
                GROUP BY ri_name,
                         ri_cd,
                         line_cd,
                         booking_date,
                         prem_vat,
                         comm_vat,
                         wholding_vat,
                         -- Rosch, 01/16/2006
                         prem_tax, --cris 07/22/2008
                         to_date,
                         from_date
                ORDER BY 1, 3, 4)
      LOOP
         v_not_exist := FALSE;
         v_rec.ri_name := i.ri_name;
         v_rec.ri_cd := i.ri_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.amt_insured := i.amt_insured;
         v_rec.ri_prem_amt := i.ri_prem_amt;
         v_rec.prem_vat := i.prem_vat;
         v_rec.ri_comm_amt := i.ri_comm_amt;
         v_rec.comm_vat := i.comm_vat;
         v_rec.wholding_vat := i.wholding_vat;
         v_rec.prem_tax := i.prem_tax;
         v_rec.net_prem := i.net_prem;
         v_rec.cf_from_date := TO_CHAR (i.from_date, 'FMMonth DD, YYYY');
         v_rec.cf_to_date := TO_CHAR (i.TO_DATE, 'FMMonth DD, YYYY');

         BEGIN
            SELECT line_name
              INTO v_rec.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.line_name := NULL;
         END;
         
         BEGIN
            SELECT param_value_v
             INTO v_fund_cd
              FROM giac_parameters
             WHERE param_name = 'FUND_CD';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_fund_cd := NULL;
         END;

         BEGIN
            SELECT grp_iss_cd
             INTO v_iss_cd
              FROM giis_user_grp_hdr b, giis_users a
             WHERE b.user_grp = a.user_grp AND a.user_id = p_user_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_iss_cd := NULL;
         END;
         FOR c1 IN (SELECT column_heading
                    FROM giac_aging_parameters
                   WHERE gibr_gfun_fund_cd = v_fund_cd
                     AND gibr_branch_cd = v_iss_cd
                     AND over_due_tag = 'Y'
                     AND (SYSDATE-i.booking_date)BETWEEN min_no_days AND max_no_days)
         LOOP
           v_rec.age := c1.column_heading;
         END LOOP;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;
END;
/


