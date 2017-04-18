CREATE OR REPLACE PACKAGE BODY CPI.giacr181_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 06.21.2013
   **  Reference By : GIACR181 Schedule of Premiums Ceded to Facultative RI (Summary)
   **  Description  :
   */
   FUNCTION get_giacr181_records (
      p_ri_cd       giri_binder.ri_cd%TYPE,
      p_line_cd     giri_binder.line_cd%TYPE
   )
      RETURN giacr181_records_tab PIPELINED
   IS
      v_rec         giacr181_records_type;
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

      FOR i IN (SELECT   line_cd, ri_cd, ri_name,
                         SUM (amt_insured) amt_insured,
                         SUM (ri_prem_amt) ri_prem_amt, prem_vat,-- Rosch, 01/16/2006
                         SUM (ri_comm_amt) ri_comm_amt, comm_vat,
                         wholding_vat,                    -- Rosch, 01/16/2006
                         prem_tax,              --cris 07/22/2008
                         SUM (  (  ri_prem_amt+ NVL (prem_vat, 0) - NVL (prem_tax, 0))- (  ri_comm_amt+ NVL (comm_vat, 0)+ NVL (wholding_vat, 0))) net_prem,-- Rosch, 01/16/20060
                         to_date,from_date
                    FROM giac_dueto_ext
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND ri_cd = NVL (p_ri_cd, ri_cd)
                GROUP BY ri_name,
                         ri_cd,
                         line_cd,
                         prem_vat,
                         comm_vat,
                         wholding_vat,                    -- Rosch, 01/16/2006
                         prem_tax,                           --cris 07/22/2008
                         to_date,
                         from_date
                ORDER BY 1, 3)
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
         v_rec.cf_to_date := TO_CHAR (i.to_date, 'FMMonth DD, YYYY');

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


