CREATE OR REPLACE PACKAGE CPI.giis_subline_pkg
AS
   TYPE subline_list_type IS RECORD (
      subline_cd       giis_subline.subline_cd%TYPE,
      line_cd          giis_subline.line_cd%TYPE,
      subline_name     giis_subline.subline_name%TYPE,
      open_policy_sw   giis_subline.open_policy_sw%TYPE,
      benefit_flag     giis_subline.benefit_flag%TYPE,
      op_flag          giis_subline.op_flag%TYPE
   );

   TYPE subline_list_tab IS TABLE OF subline_list_type;
   
   TYPE subline_details_type IS RECORD (
      line_cd          giis_subline.line_cd%TYPE,
      subline_cd       giis_subline.subline_cd%TYPE,
      subline_name     giis_subline.subline_name%TYPE,
      subline_time     VARCHAR2 (11),
      acct_subline_cd  giis_subline.acct_subline_cd%TYPE,
      min_prem_amt     giis_subline.min_prem_amt%TYPE,
      remarks          giis_subline.remarks%TYPE,
      micro_sw         giis_subline.micro_sw%TYPE, --apollo 05.20.2015 sr#4245
      open_policy_sw   giis_subline.open_policy_sw%TYPE,
      op_flag          giis_subline.op_flag%TYPE,
      allied_prt_tag   giis_subline.allied_prt_tag%TYPE,
      time_sw          giis_subline.time_sw%TYPE,
      no_tax_sw        giis_subline.no_tax_sw%TYPE,
      exclude_tag      giis_subline.exclude_tag%TYPE,
      prof_comm_tag    giis_subline.prof_comm_tag%TYPE,
      non_renewal_tag  giis_subline.non_renewal_tag%TYPE,
      edst_sw          giis_subline.edst_sw%TYPE,
      enrollee_tag     giis_subline.enrollee_tag%TYPE,    -- added by kenneth L. 03.19.2014
      recap_line       cg_ref_codes.rv_meaning%TYPE --added by mikel 03.16.2015 SR 18319
   );

   TYPE subline_details_tab IS TABLE OF subline_details_type;

   FUNCTION get_subline_list (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED;

   FUNCTION get_subline_spf_list (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED;

   FUNCTION get_subline_name (p_subline_cd IN giis_line.line_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_subline_name2 (
      p_line_cd           giis_line.line_cd%TYPE,
      p_subline_cd   IN   giis_line.line_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_subline_code (
      p_subline_name   IN   giis_subline.subline_name%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_subline_code2 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_name   IN   giis_subline.subline_name%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_subline_details (
      p_line_cd           giis_line.line_cd%TYPE,
      p_subline_cd   IN   giis_line.line_cd%TYPE
   )
      RETURN subline_list_tab PIPELINED;

   FUNCTION get_subline_time_sw (
      p_line_cd      IN   giis_subline.line_cd%TYPE,
      p_subline_cd   IN   giis_subline.subline_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_all_subline_list
      RETURN subline_list_tab PIPELINED;

   FUNCTION get_subline_cd_name (p_line_cd giis_subline.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED;

   PROCEDURE validate_subline_cd (
      p_line_cd      IN       giis_line.line_cd%TYPE,
      p_iss_cd       IN       giis_user_grp_line.iss_cd%TYPE,
      p_subline_cd   IN       giis_subline.subline_cd%TYPE,
      p_msg          OUT      VARCHAR2
   );

   FUNCTION get_polbasic_subline_list (p_line_cd giis_subline.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED;
      
   FUNCTION get_subline_lov(
      p_line_cd               GIIS_LINE.line_cd%TYPE
   )
      RETURN subline_list_tab PIPELINED;
      
   PROCEDURE validate_purge_subline_cd(
        p_line_cd       IN      GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN      GIIS_SUBLINE.subline_cd%TYPE,
        p_subline_name  OUT     GIIS_SUBLINE.subline_name%TYPE
    );
    
    --bonok :: 04.10.2012 :: subline LOV for GIEXS006
   FUNCTION get_exp_rep_subline_lov (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN subline_list_tab PIPELINED;
   
   --bonok :: 04.17.2012 :: validate subline for GIEXS006
   FUNCTION validate_subline_cd_giexs006(
      p_line_cd	 giis_line.line_cd%TYPE,
      p_subline_cd giis_subline.subline_cd%TYPE
   )
   RETURN subline_list_tab PIPELINED;
    
    --kenneth L. 04.24.2013
   FUNCTION get_subline_lov_giuts022 (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_search           VARCHAR2
   )
   RETURN subline_list_tab PIPELINED;
      
     --Kenneth L. 05.23.2013 for subline maintenance
   FUNCTION get_giis_subline_lov (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN subline_details_tab PIPELINED;
   
   PROCEDURE set_giis_subline_group (
      p_subline giis_subline%ROWTYPE,
      p_subline_time giis_subline.subline_time%TYPE
   );
   
   PROCEDURE add_giis_subline_group (
      p_subline giis_subline%ROWTYPE,
      p_subline_time giis_subline.subline_time%TYPE
   );
   
   FUNCTION validate_subline_add (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_subline_cd       giis_subline.subline_cd%TYPE
   )
   RETURN VARCHAR2;
   
   PROCEDURE delete_giis_subline_row ( 
      p_line_cd          giis_subline.line_cd%TYPE,
      p_subline_cd       giis_subline.subline_cd%TYPE
   );
    
   FUNCTION validate_subline_del (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_subline_cd       giis_subline.subline_cd%TYPE
   )
   RETURN VARCHAR2;
   
   FUNCTION validate_acct_subline_cd (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_acct_subline_cd  giis_subline.acct_subline_cd%TYPE
   )
   RETURN VARCHAR2;
   
   FUNCTION validate_open_sw (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN VARCHAR2;
   
   FUNCTION validate_op_flag (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN VARCHAR2;
   
   TYPE gicls254_subline_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );
   
   TYPE gicls254_subline_tab IS TABLE OF gicls254_subline_type;
   
   FUNCTION get_gicls254_subline_lov (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gicls254_subline_tab PIPELINED;
   
END giis_subline_pkg;
/


