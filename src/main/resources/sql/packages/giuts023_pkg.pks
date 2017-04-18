CREATE OR REPLACE PACKAGE CPI.giuts023_pkg
AS
   TYPE policy_info_lov_type IS RECORD (
      par_id           gipi_polbasic.par_id%TYPE,
      assd_no          gipi_polbasic.assd_no%TYPE,
      policy_id        gipi_polbasic.policy_id%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      endt_iss_cd      gipi_polbasic.endt_iss_cd%TYPE,
      n_endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy          gipi_polbasic.endt_yy%TYPE,
      n_endt_yy        gipi_polbasic.endt_yy%TYPE,
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      n_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      policy_no        VARCHAR2 (500),
      endorsement_no   VARCHAR2 (500)
   );

   TYPE policy_info_lov_tab IS TABLE OF policy_info_lov_type;

   FUNCTION get_policy_info_lov (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN policy_info_lov_tab PIPELINED;

   TYPE item_info_type IS RECORD (
      policy_id    gipi_item.policy_id%TYPE,
      item_no      gipi_item.item_no%TYPE,
      item_title   gipi_item.item_title%TYPE,
      item_desc    gipi_item.item_desc%TYPE,
      update_sw    VARCHAR2(1) -- apollo cruz 04.01.2015
   );

   TYPE item_info_tab IS TABLE OF item_info_type;

   FUNCTION get_item_info (p_policy_id VARCHAR2)
      RETURN item_info_tab PIPELINED;

   TYPE grouped_items_info_type IS RECORD (
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      sex                  gipi_grouped_items.sex%TYPE,
      age                  gipi_grouped_items.age%TYPE,
      date_of_birth        gipi_grouped_items.date_of_birth%TYPE,
      civil_status         gipi_grouped_items.civil_status%TYPE,
      amount_coverage      gipi_grouped_items.amount_coverage%TYPE,
      POSITION             giis_position.POSITION%TYPE,
      salary               gipi_grouped_items.salary%TYPE,
      salary_grade         gipi_grouped_items.salary_grade%TYPE,
      subline_cd           gipi_grouped_items.subline_cd%TYPE,
      line_cd              gipi_grouped_items.line_cd%TYPE,
      include_tag          gipi_grouped_items.include_tag%TYPE,
      position_cd          gipi_grouped_items.position_cd%TYPE,
      policy_id            gipi_grouped_items.policy_id%TYPE,
      item_no              gipi_grouped_items.item_no%TYPE
   );

   TYPE grouped_items_info_tab IS TABLE OF grouped_items_info_type;

   FUNCTION get_grouped_items_info (
      p_item_no     gipi_grouped_items.item_no%TYPE,
      p_policy_id   gipi_grouped_items.policy_id%TYPE
   )
      RETURN grouped_items_info_tab PIPELINED;
      
   TYPE grouped_items_type IS RECORD (
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE
   );
   
   TYPE grouped_items_tab IS TABLE OF grouped_items_type;
   
   FUNCTION get_grouped_items (
      p_item_no     gipi_grouped_items.item_no%TYPE,
      p_policy_id   gipi_grouped_items.policy_id%TYPE
   )
      RETURN grouped_items_tab PIPELINED;

   FUNCTION validate_grouped_item_no (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_beneficiary_no (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2,
      p_beneficiary_no    VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE save_grouped_items (
      p_grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      p_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      p_sex                  gipi_grouped_items.sex%TYPE,
      p_age                  gipi_grouped_items.age%TYPE,
      p_date_of_birth        gipi_grouped_items.date_of_birth%TYPE,
      p_civil_status         gipi_grouped_items.civil_status%TYPE,
      p_amount_coverage      gipi_grouped_items.amount_coverage%TYPE,
      p_salary               gipi_grouped_items.salary%TYPE,
      p_salary_grade         gipi_grouped_items.salary_grade%TYPE,
      p_subline_cd           gipi_grouped_items.subline_cd%TYPE,
      p_line_cd              gipi_grouped_items.line_cd%TYPE,
      p_include_tag          gipi_grouped_items.include_tag%TYPE,
      p_position_cd          gipi_grouped_items.position_cd%TYPE,
      p_policy_id            gipi_grouped_items.policy_id%TYPE,
      p_item_no              gipi_grouped_items.item_no%TYPE
   );

   PROCEDURE save_beneficiary (
      p_policy_id          gipi_grp_items_beneficiary.policy_id%TYPE,
      p_item_no            gipi_grp_items_beneficiary.item_no%TYPE,
      p_grouped_item_no    gipi_grp_items_beneficiary.grouped_item_no%TYPE,
      p_beneficiary_no     gipi_grp_items_beneficiary.beneficiary_no%TYPE,
      p_beneficiary_name   gipi_grp_items_beneficiary.beneficiary_name%TYPE,
      p_relation           gipi_grp_items_beneficiary.relation%TYPE,
      p_sex                gipi_grp_items_beneficiary.sex%TYPE,
      p_civil_status       gipi_grp_items_beneficiary.civil_status%TYPE,
      p_date_of_birth      gipi_grp_items_beneficiary.date_of_birth%TYPE,
      p_age                gipi_grp_items_beneficiary.age%TYPE,
      p_beneficiary_addr   gipi_grp_items_beneficiary.beneficiary_addr%TYPE
   );

   PROCEDURE delete_grouped_items (
      p_policy_id         gipi_grouped_items.policy_id%TYPE,
      p_item_no           gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE
   );
   
   PROCEDURE delete_beneficiary (
      p_policy_id         gipi_grouped_items.policy_id%TYPE,
      p_item_no           gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE,
      p_beneficiary_no    gipi_grp_items_beneficiary.beneficiary_no%TYPE
   );
   
   PROCEDURE delete_all_beneficiary (
      p_policy_id         gipi_grouped_items.policy_id%TYPE,
      p_item_no           gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE
   );

   TYPE beneficiary_type IS RECORD (
      beneficiary_no     gipi_grp_items_beneficiary.beneficiary_no%TYPE,
      beneficiary_name   gipi_grp_items_beneficiary.beneficiary_name%TYPE,
      relation           gipi_grp_items_beneficiary.relation%TYPE,
      sex                gipi_grp_items_beneficiary.sex%TYPE,
      civil_status       gipi_grp_items_beneficiary.civil_status%TYPE,
      date_of_birth      gipi_grp_items_beneficiary.date_of_birth%TYPE,
      age                gipi_grp_items_beneficiary.age%TYPE,
      beneficiary_addr   gipi_grp_items_beneficiary.beneficiary_addr%TYPE,
      policy_id          gipi_grp_items_beneficiary.policy_id%TYPE,
      item_no            gipi_grp_items_beneficiary.item_no%TYPE,
      grouped_item_no    gipi_grp_items_beneficiary.grouped_item_no%TYPE
   );

   TYPE beneficiary_tab IS TABLE OF beneficiary_type;

   FUNCTION get_beneficiary (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2
   )
      RETURN beneficiary_tab PIPELINED;
      
   TYPE beneficiary_nos_type IS RECORD (beneficiary_no  gipi_grp_items_beneficiary.beneficiary_no%TYPE);
   
   TYPE beneficiary_nos_tab IS TABLE OF beneficiary_nos_type;
   
   FUNCTION get_beneficiary_nos (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2
   )
      RETURN beneficiary_nos_tab PIPELINED;   
	  
   FUNCTION show_other_cert (
      p_line_cd          	VARCHAR2
   )
      RETURN VARCHAR2;
      
      
END;
/


