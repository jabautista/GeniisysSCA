CREATE OR REPLACE PACKAGE CPI.gicls170_pkg
AS
   TYPE clm_stat_reasons_type IS RECORD (
      reason_cd       gicl_reasons.reason_cd%TYPE,
      reason_desc     gicl_reasons.reason_desc%TYPE,
      clm_stat_cd     gicl_reasons.clm_stat_cd%TYPE,
      remarks         gicl_reasons.remarks%TYPE,
      user_id         gicl_reasons.user_id%TYPE,
      last_update     VARCHAR2 (200),
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE
   );

   TYPE clm_stat_reasons_tab IS TABLE OF clm_stat_reasons_type;

   TYPE clm_stat_reasons_lov_type IS RECORD (
      clm_stat_cd     giis_clm_stat.clm_stat_cd%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      clm_stat_type   giis_clm_stat.clm_stat_type%TYPE
   );

   TYPE clm_stat_reasons_lov_tab IS TABLE OF clm_stat_reasons_lov_type;

   FUNCTION show_clm_stat_reasons
      RETURN clm_stat_reasons_tab PIPELINED;

   FUNCTION get_clm_stat_reasons_lov
      RETURN clm_stat_reasons_lov_tab PIPELINED;

   FUNCTION validate_reasons_input (
      p_txt_field      VARCHAR2,
      p_input_string   VARCHAR2,
      p_reason_cd      VARCHAR2,
      p_clm_stat_cd    VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE set_clm_stat_reasons (
      p_reason_cd     gicl_reasons.reason_cd%TYPE,
      p_reason_desc   gicl_reasons.reason_desc%TYPE,
      p_clm_stat_cd   gicl_reasons.clm_stat_cd%TYPE,
      p_remarks       gicl_reasons.remarks%TYPE
   );

   PROCEDURE delete_in_clm_stat_reasons (
      p_reason_cd   gicl_reasons.reason_cd%TYPE
   );
END;
/


