CREATE OR REPLACE PACKAGE CPI.giacr181a_pkg
AS
   TYPE giacr181a_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      ri_name              giis_reinsurer.ri_name%TYPE,
      line_name            giis_line.line_name%TYPE,
      ri_cd                giis_reinsurer.ri_cd%TYPE,
      line_cd              giis_line.line_cd%TYPE,
      amt_insured          NUMBER (20, 2),
      ri_prem_amt          NUMBER (20, 2),
      prem_vat             NUMBER (20, 2),
      ri_comm_amt          NUMBER (20, 2),
      comm_vat             NUMBER (20, 2),
      wholding_vat         NUMBER (20, 2),
      prem_tax             NUMBER (20, 2),
      net_prem             NUMBER (20, 2),
      age                  giac_aging_parameters.column_heading%TYPE
   );

   TYPE giacr181a_records_tab IS TABLE OF giacr181a_records_type;

   FUNCTION get_giacr181a_records (
      p_ri_cd     giri_binder.ri_cd%TYPE,
      p_line_cd   giri_binder.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN giacr181a_records_tab PIPELINED;
END;
/


