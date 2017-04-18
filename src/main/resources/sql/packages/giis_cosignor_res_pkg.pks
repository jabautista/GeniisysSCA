CREATE OR REPLACE PACKAGE CPI.giis_cosignor_res_pkg
AS
   TYPE cosignor_res_type IS RECORD (
      cosign_name   giis_cosignor_res.cosign_name%TYPE,
      designation   giis_cosignor_res.designation%TYPE,
      cosign_id     giis_cosignor_res.cosign_id%TYPE,
      assd_no       giis_cosignor_res.assd_no%TYPE
   );

   TYPE cosignor_res_tab IS TABLE OF cosignor_res_type;

   FUNCTION get_cosignor_list (p_assd_no giis_cosignor_res.assd_no%TYPE)
      RETURN cosignor_res_tab PIPELINED;

   TYPE cosignor_res_type2 IS RECORD (
      cosign_name        giis_cosignor_res.cosign_name%TYPE,
      designation        giis_cosignor_res.designation%TYPE,
      cosign_id          giis_cosignor_res.cosign_id%TYPE,
      cosign_res_no      giis_cosignor_res.cosign_res_no%TYPE,
      cosign_res_place   giis_cosignor_res.cosign_res_place%TYPE,
      cosign_res_date    VARCHAR2 (10),   --giis_prin_signtry.issue_date%TYPE
      user_id            giis_cosignor_res.user_id%TYPE,
      last_update        VARCHAR2 (30),
      remarks            giis_cosignor_res.remarks%TYPE,
      address            giis_cosignor_res.address%TYPE,
      control_type_cd    giis_cosignor_res.control_type_cd%TYPE,
      control_type_desc  giis_control_type.control_type_desc%TYPE
   );

   TYPE cosignor_res_tab2 IS TABLE OF cosignor_res_type2;

   FUNCTION get_cosignor_res (p_assd_no giis_cosignor_res.assd_no%TYPE)
      RETURN cosignor_res_tab2 PIPELINED;

   PROCEDURE set_cosignor (
      p_cosign_name        giis_cosignor_res.cosign_name%TYPE,
      p_designation        giis_cosignor_res.designation%TYPE,
      p_cosign_id          giis_cosignor_res.cosign_id%TYPE,
      p_cosign_res_no      giis_cosignor_res.cosign_res_no%TYPE,
      p_cosign_res_place   giis_cosignor_res.cosign_res_place%TYPE,
      p_cosign_res_date    VARCHAR2,       --giis_prin_signtry.issue_date%TYPE
      p_user_id            giis_cosignor_res.user_id%TYPE,
      p_remarks            giis_cosignor_res.remarks%TYPE,
      p_address            giis_cosignor_res.address%TYPE,
      p_assd_no            giis_prin_signtry.assd_no%TYPE,
      p_control_type_cd    giis_cosignor_res.control_type_cd%TYPE
   );
END giis_cosignor_res_pkg;
/


