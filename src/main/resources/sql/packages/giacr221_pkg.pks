CREATE OR REPLACE PACKAGE CPI.giacr221_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      trty_name        giis_dist_share.trty_name%TYPE,
      period1          VARCHAR2 (130),
      ri_name          giis_reinsurer.ri_name%TYPE,
      release_amt      NUMBER (38, 4),
      interest         NUMBER (38, 4),
      peril_name       giis_peril.peril_name%TYPE,
      premium_amt      NUMBER
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_line_cd     VARCHAR2,
      p_trty_yy     VARCHAR2,
      p_share_cd    VARCHAR2,
      p_ri_cd       VARCHAR2,
      p_proc_year   VARCHAR2,
      p_proc_qtr    VARCHAR2
   )  RETURN get_details_tab PIPELINED;
END;
/


