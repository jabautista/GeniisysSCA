CREATE OR REPLACE PACKAGE CPI.gicls160_pkg
AS
   TYPE claim_status_type IS RECORD (
      clm_stat_cd     giis_clm_stat.clm_stat_cd%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      clm_stat_type   giis_clm_stat.clm_stat_type%TYPE,
      remarks         giis_clm_stat.remarks%TYPE,
      user_id         giis_clm_stat.user_id%TYPE,
      last_update     VARCHAR2 (200)
   );

   TYPE claim_status_tab IS TABLE OF claim_status_type;

   FUNCTION get_claim_status
      RETURN claim_status_tab PIPELINED;

   PROCEDURE set_claim_status (
      p_clm_stat_cd     giis_clm_stat.clm_stat_cd%TYPE,
      p_clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      p_remarks         giis_clm_stat.remarks%TYPE
   );

   PROCEDURE delete_in_claim_status (
      p_clm_stat_cd   giis_clm_stat.clm_stat_cd%TYPE
   );

   FUNCTION chk_if_valid_input (p_txt_field VARCHAR2, p_search_string VARCHAR2)
      RETURN VARCHAR2;
END;
/


