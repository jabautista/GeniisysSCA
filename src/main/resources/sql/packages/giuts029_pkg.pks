CREATE OR REPLACE PACKAGE CPI.giuts029_pkg
AS
   PROCEDURE new_form_instance (
      p_allowed_media_type      OUT   giis_parameters.param_value_v%TYPE,
      p_allowed_size_per_file   OUT   giis_parameters.param_value_n%TYPE,
      p_allowed_size_per_item   OUT   giis_parameters.param_value_n%TYPE
   );

   TYPE pol_type IS RECORD (
      policy_id     gipi_polbasic.policy_id%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      subline_cd    gipi_polbasic.subline_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE,
      issue_yy      gipi_polbasic.issue_yy%TYPE,
      pol_seq_no    VARCHAR2 (10),
      renew_no      VARCHAR2 (5),
      endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy       gipi_polbasic.endt_yy%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      policy_no     VARCHAR2 (50),
      assd_name     giis_assured.assd_name%TYPE
   );

   TYPE pol_tab IS TABLE OF pol_type;

   FUNCTION get_giuts029_pol_lov (
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE
   )
      RETURN pol_tab PIPELINED;

   TYPE item_type IS RECORD (
      item_no      gipi_item.item_no%TYPE,
      item_title   gipi_item.item_title%TYPE,
      item_desc    gipi_item.item_desc%TYPE,
      item_desc2   gipi_item.item_desc2%TYPE
   );

   TYPE item_tab IS TABLE OF item_type;

   FUNCTION get_items (
      p_policy_id    gipi_item.policy_id%TYPE,
      p_item_no      gipi_item.item_no%TYPE,
      p_item_title   gipi_item.item_title%TYPE
   )
      RETURN item_tab PIPELINED;

   TYPE attachment_type IS RECORD (
      item_no      gipi_item.item_no%TYPE,
      policy_id    gipi_item.policy_id%TYPE,
      file_name    gipi_pictures.file_name%TYPE,
      file_name2   gipi_pictures.file_name%TYPE,
      remarks      gipi_pictures.remarks%TYPE
   );

   TYPE attachment_tab IS TABLE OF attachment_type;

   FUNCTION get_attachments (
      p_policy_id   gipi_item.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN attachment_tab PIPELINED;

   TYPE attachment_list_type IS RECORD (
        policy_id       gipi_item.policy_id%TYPE,
        item_no         gipi_item.item_no%TYPE,
        file_name       gipi_pictures.file_name%TYPE
   );
   
   TYPE attachment_list_tab IS TABLE OF attachment_list_type;
   
   FUNCTION get_attachment_list(
       p_policy_id     gipi_item.policy_id%TYPE,
       p_item_no       gipi_item.item_no%TYPE
   )
     RETURN attachment_list_tab PIPELINED;

   PROCEDURE set_attachments (
      p_policy_id   gipi_pictures.policy_id%TYPE,
      p_item_no     gipi_pictures.item_no%TYPE,
      p_file_name   gipi_pictures.file_name%TYPE,
      p_remarks     gipi_pictures.remarks%TYPE
   );

   PROCEDURE del_attachments (
      p_policy_id   gipi_pictures.policy_id%TYPE,
      p_item_no     gipi_pictures.item_no%TYPE,
      p_file_name   gipi_pictures.file_name%TYPE
   );

   PROCEDURE val_add_rec (
      p_policy_id   gipi_pictures.policy_id%TYPE,
      p_item_no     gipi_pictures.item_no%TYPE,
      p_file_name   gipi_pictures.file_name%TYPE
   );
END;
/


