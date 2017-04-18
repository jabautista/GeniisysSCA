CREATE OR REPLACE PACKAGE CPI.GIACB004D_PKG
AS
   TYPE giacb400d_record_type IS RECORD (
      line_cd              VARCHAR2 (2),
      line_name            VARCHAR2 (20),
      premium              NUMBER (12, 2),
      ri_commission        NUMBER (14, 2),
      currency_rt          NUMBER (14, 2),
      currency_cd          NUMBER (2),
      reinsurer            VARCHAR2 (50),
      assured              VARCHAR2 (500),
      policy_number        VARCHAR2 (50),
      top_date             VARCHAR2 (70),
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      v_flag               VARCHAR2 (1),
      ri_comm_vat          NUMBER (14, 2),
      prem_vat             NUMBER (12, 2),
      cf_net               NUMBER (12, 2)
   );

   TYPE giacb400d_record_tab IS TABLE OF giacb400d_record_type;

   FUNCTION get_giacb400d_record (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb400d_record_tab PIPELINED;
END GIACB004D_PKG;
/


