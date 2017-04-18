CREATE OR REPLACE PACKAGE BODY CPI.giacr180_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.21.2013
   **  Reference By : GIACR180 - SCHEDULE OF PREMIUMS CEDED TO FACULTATIVE RI (Detail)
   **  Description  :
   */
   FUNCTION get_giacr180_records (
      p_ri_cd     giri_binder.ri_cd%TYPE,
      p_line_cd   giri_binder.line_cd%TYPE
   )
      RETURN giacr180_records_tab PIPELINED
   IS
      v_rec         giacr180_records_type;
      v_not_exist   BOOLEAN               := TRUE;
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

      FOR i IN (SELECT   assd_no, assd_name, line_cd, fund_cd, branch_cd,
                         ri_cd, ri_name, binder_date, ri_prem_amt, prem_vat,
                         ri_comm_amt, comm_vat, wholding_vat, amt_insured,
                         policy_no, prem_tax,
                         (   line_cd
                          || '-'
                          || TO_CHAR (binder_yy)
                          || '-'
                          || TO_CHAR (binder_seq_no)
                         ) binder_no,
                         booking_date,
                         (  (ri_prem_amt + NVL (prem_vat, 0)
                             - NVL (prem_tax, 0)
                            )
                          - (  ri_comm_amt
                             + NVL (comm_vat, 0)
                             + NVL (wholding_vat, 0)
                            )
                         ) net_premium,
                         from_date,to_date                   
                    FROM giac_dueto_ext
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND ri_cd = NVL (p_ri_cd, ri_cd)
                ORDER BY 7, 13)
      LOOP
         v_not_exist := FALSE;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         v_rec.line_cd := i.line_cd;
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.fund_cd := i.fund_cd;
         v_rec.branch_cd := i.branch_cd;
         v_rec.binder_date := i.binder_date;
         v_rec.ri_prem_amt := i.ri_prem_amt;
         v_rec.prem_vat := i.prem_vat;
         v_rec.ri_comm_amt := i.ri_comm_amt;
         v_rec.comm_vat := i.comm_vat;
         v_rec.prem_tax := i.prem_tax;
         v_rec.wholding_vat := i.wholding_vat;
         v_rec.amt_insured := i.amt_insured;
         v_rec.policy_no := i.policy_no;
         v_rec.binder_no := i.binder_no;
         v_rec.booking_date := i.booking_date;
         v_rec.net_prem := i.net_premium;
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

         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;
END;
/


