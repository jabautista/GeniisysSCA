CREATE OR REPLACE PACKAGE CPI.GIEXS008_PKG
AS
   TYPE giexs008_expiry_record_type IS RECORD (
      count_                NUMBER,     --Gzelle 06302015 SR3933
      rownum_               NUMBER,     --Gzelle 06302015 SR3933
      line_cd               giex_expiries_v.line_cd%TYPE,
      subline_cd            giex_expiries_v.subline_cd%TYPE,
      iss_cd                giex_expiries_v.iss_cd%TYPE,
      intm_no               giis_intermediary.intm_no%TYPE,
      issue_yy              giex_expiries_v.issue_yy%TYPE,
      pol_seq_no            giex_expiries_v.pol_seq_no%TYPE,
      renew_no              giex_expiries_v.renew_no%TYPE,
      dsp_assured           VARCHAR2 (500),
      expiry_date           giex_expiries_v.expiry_date%TYPE,
      expiry_date_string    VARCHAR2 (60),
      extract_date_string   VARCHAR2 (60),
      extract_user          giex_expiries_v.extract_user%TYPE,
      tsi_amt               giex_expiries_v.tsi_amt%TYPE,
      policy_id             giex_expiries_v.policy_id%TYPE,
      pack_policy_id        giex_expiries_v.pack_policy_id%TYPE,
      assd_no               giex_expiries_v.assd_no%TYPE,
      is_package            VARCHAR2 (1),   --changed by Gzelle 07212015 SR4744
      policy_no             VARCHAR2 (60),
      post_flag             giex_expiries_v.post_flag%TYPE,
      cred_branch           gipi_polbasic.cred_branch%TYPE,
      nbt_reassignment_sw   VARCHAR2 (1)    --moved here Gzelle 06302015 SR3933
   );

   TYPE giexs008_expiry_record_tab IS TABLE OF giexs008_expiry_record_type;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;   

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   TYPE iss_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE iss_lov_tab IS TABLE OF iss_lov_type;

   TYPE intm_lov_type IS RECORD (
      intm_no     giis_intermediary.intm_no%TYPE,
      intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE intm_lov_tab IS TABLE OF intm_lov_type;

   TYPE user_lov_type IS RECORD (
      user_id     giis_users.user_id%TYPE,
      user_name   giis_users.user_name%TYPE,
      user_grp    giis_users.user_grp%TYPE
   );

   TYPE user_lov_tab IS TABLE OF user_lov_type;

   FUNCTION get_expiry_record (     --modified by Gzelle 06302015 SR3933
     p_user_id        VARCHAR2,
     p_policy_no      VARCHAR2,
     p_assd_name      VARCHAR2,
     p_expiry_date    VARCHAR2,
     p_extract_user   VARCHAR2,
     p_order_by       VARCHAR2,
     p_asc_desc_flag  VARCHAR2,
     p_from           NUMBER,
     p_to             NUMBER,
     p_from_date      VARCHAR2,
     p_to_date        VARCHAR2,
     p_line_cd        giex_expiry.line_cd%TYPE,
     p_subline_cd     giex_expiry.subline_cd%TYPE,
     p_iss_cd         giex_expiry.iss_cd%TYPE,
     p_cred_branch    giex_expiry.iss_cd%TYPE,
     p_intm_no        giis_intermediary.intm_no%TYPE,
     p_by_date        VARCHAR2      
   )								--end Gzelle 06302015 SR3933
      RETURN giexs008_expiry_record_tab PIPELINED;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_iss_cd VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   FUNCTION get_subline_lov (p_line_cd VARCHAR2)
      RETURN subline_lov_tab PIPELINED;

   FUNCTION get_iss_lov (p_user_id VARCHAR2, p_line_cd VARCHAR2)
      RETURN iss_lov_tab PIPELINED;

   FUNCTION get_cred_branch_lov		--added by Gzelle 07102015 SR4744
      RETURN iss_lov_tab PIPELINED;	--end      

   FUNCTION get_intm_lov
      RETURN intm_lov_tab PIPELINED;

   FUNCTION get_user_lov(   --added by Gzelle 06252015 SR3935
     p_policy_id      VARCHAR2,
     p_line_cd        VARCHAR2,
     p_iss_cd         VARCHAR2,
     p_status_tag     VARCHAR2,
     p_user_id        VARCHAR2,
     p_to             VARCHAR2
   )                        --end
      RETURN user_lov_tab PIPELINED;

   PROCEDURE update_extracted_expiries (
      p_extract_user   giex_expiry.extract_user%TYPE,
      p_policy_id      giex_expiry.policy_id%TYPE,
      p_is_package     giex_expiries_v.is_package%TYPE
   );

	/*start - Gzelle 07162015 SR4744*/
    TYPE policy_id_array IS TABLE OF VARCHAR2(5000) INDEX BY BINARY_INTEGER;   
    
    PROCEDURE update_expiries_by_batch(
    	p_extract_user  giex_expiry.extract_user%TYPE, 
    	p_policy_id1   	VARCHAR2,
    	p_policy_id2   	VARCHAR2,
    	p_policy_id3   	VARCHAR2,
    	p_status_tag   	VARCHAR2,
    	p_user_id      	VARCHAR2,   
     	p_from_date    	VARCHAR2,
     	p_to_date      	VARCHAR2,
     	p_line_cd      	giex_expiry.line_cd%TYPE,
     	p_subline_cd   	giex_expiry.subline_cd%TYPE,
     	p_iss_cd       	giex_expiry.iss_cd%TYPE,
     	p_cred_branch  	giex_expiry.iss_cd%TYPE,
     	p_intm_no       giis_intermediary.intm_no%TYPE,
     	p_by_date       VARCHAR2,
     	p_to            VARCHAR2
    ); 	/*end Gzelle 07162015 SR4744*/     

   FUNCTION check_records (
      p_extract_user   VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_user_id        VARCHAR2,
      p_by_date        VARCHAR2,
      p_mis_sw         VARCHAR2,
      p_line_cd        VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_intm_no        giis_intermediary.intm_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION check_subline_list (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2;
      
END GIEXS008_PKG;
/


