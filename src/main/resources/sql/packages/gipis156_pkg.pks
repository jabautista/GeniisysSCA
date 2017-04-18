CREATE OR REPLACE PACKAGE CPI.GIPIS156_PKG AS
   
   TYPE gipis156_booking_hist_type IS RECORD (
       policy_id        gipi_booking_hist.policy_id%TYPE, 
       takeup_seq_no    gipi_booking_hist.takeup_seq_no%TYPE, 
       iss_cd           gipi_booking_hist.iss_cd%TYPE,
       prem_seq_no      gipi_booking_hist.prem_seq_no%TYPE, 
       old_reg_pol_sw   gipi_booking_hist.old_reg_pol_sw%TYPE, 
       new_reg_pol_sw   gipi_booking_hist.new_reg_pol_sw%TYPE,
       old_cred_branch  gipi_booking_hist.old_cred_branch%TYPE, 
       new_cred_branch  gipi_booking_hist.new_cred_branch%TYPE, 
       old_booking_mm   gipi_booking_hist.old_booking_mm%TYPE,
       new_booking_mm   gipi_booking_hist.new_booking_mm%TYPE,
       old_booking_mm_yy    VARCHAR2(50), 
       old_booking_yy   gipi_booking_hist.old_booking_yy%TYPE, 
       new_booking_yy   gipi_booking_hist.new_booking_yy%TYPE,
       new_booking_mm_yy    VARCHAR2(50), 
       user_id          gipi_booking_hist.user_id%TYPE,
       last_update      gipi_booking_hist.last_update%TYPE, 
       hist_no          gipi_booking_hist.hist_no%TYPE,
       dsp_old_booking_mth_yy   VARCHAR2(50),
       old_r_pol_switch         VARCHAR2(1),
       dsp_new_booking_mth_yy   VARCHAR2(50),
       new_r_pol_switch         VARCHAR2(1),
       dsp_user_id      gipi_booking_hist.user_id%TYPE,        
       dsp_last_update  VARCHAR2(100),
       dsp_old_cred_branch  giis_issource.iss_name%TYPE,
       dsp_new_cred_branch  giis_issource.iss_name%TYPE
   );
   
   TYPE gipis156_booking_hist_tab IS TABLE OF gipis156_booking_hist_type;
   
   FUNCTION get_gipis156_booking_hist(
      p_policy_id       VARCHAR2,
      p_takeup_seq_no   VARCHAR2,
      p_prem_seq_no     VARCHAR2
   )
      RETURN gipis156_booking_hist_tab PIPELINED;
      
   TYPE gipis156_banca_hist_type IS RECORD (
      old_area              gipi_bancassurance_hist.old_area%TYPE,
      new_area              gipi_bancassurance_hist.new_area%TYPE,
      old_branch            gipi_bancassurance_hist.old_branch%TYPE,
      new_branch            gipi_bancassurance_hist.new_branch%TYPE,
      old_manager           gipi_bancassurance_hist.old_manager%TYPE,
      new_manager           gipi_bancassurance_hist.new_manager%TYPE,
      hist_no               gipi_bancassurance_hist.hist_no%TYPE,
      dsp_area_desc_old       giis_banc_area.area_desc%TYPE,
      dsp_area_desc_new       giis_banc_area.area_desc%TYPE,
      dsp_branch_desc_old     giis_banc_branch.branch_desc%TYPE,
      dsp_branch_desc_new     giis_banc_branch.branch_desc%TYPE,
      dsp_mgr_name_old        VARCHAR2(1000),
      dsp_mgr_name_new        VARCHAR2(1000),
      user_id               gipi_bancassurance_hist.user_id%TYPE,
      last_update           gipi_bancassurance_hist.last_update%TYPE
   );
   
   TYPE gipis156_banca_hist_tab IS TABLE OF gipis156_banca_hist_type;
   
   FUNCTION get_gipis156_banc_hist (
      p_policy_id   VARCHAR2
   )
      RETURN gipis156_banca_hist_tab PIPELINED;
      
   TYPE gipis156_banc_area_type IS RECORD (
      area_cd       giis_banc_area.area_cd%TYPE,
      area_desc     giis_banc_area.area_desc%TYPE
   );
   
   TYPE gipis156_banc_area_tab IS TABLE OF gipis156_banc_area_type;
   
   FUNCTION get_banc_area_lov
      RETURN gipis156_banc_area_tab PIPELINED;
      
   TYPE gipis156_banc_branch_type IS RECORD (
      branch_cd       giis_banc_branch.branch_cd%TYPE,
      branch_desc     giis_banc_branch.branch_desc%TYPE,
      manager_cd      giis_banc_branch.manager_cd%TYPE,
      manager_name    VARCHAR2(1000)
   );
   
   TYPE gipis156_banc_branch_tab IS TABLE OF gipis156_banc_branch_type;
   
   FUNCTION get_banc_branch_lov(
      p_area_cd VARCHAR2
   )
      RETURN gipis156_banc_branch_tab PIPELINED; 
      
   TYPE iss_type IS RECORD (
      iss_cd    giis_issource.iss_cd%TYPE,
      iss_name  giis_issource.iss_name%TYPE
   );
   
   TYPE iss_tab IS TABLE OF iss_type;
   
   FUNCTION get_iss_lov (
      p_line_cd VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN iss_tab PIPELINED;
      
   PROCEDURE update_gipis156 (
      p_policy_id       VARCHAR2,
      p_cred_branch     VARCHAR2,
      p_booking_mth     VARCHAR2,
      p_booking_year    VARCHAR2,   
      p_reg_policy_sw   VARCHAR2,
      p_takeup_seq_no   VARCHAR2,
      p_area_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_manager_cd      VARCHAR2,
      p_no_of_takeup    OUT VARCHAR2
   );
   
   FUNCTION val_area_cd (
      p_area_cd   VARCHAR2
   )
      RETURN VARCHAR2;
      
   FUNCTION val_banc_branch_cd (
      p_area_cd   VARCHAR2,
      p_branch_cd VARCHAR2
   )
      RETURN gipis156_banc_branch_tab PIPELINED;
      
   PROCEDURE update_gipis156_invoice(
      p_policy_id          VARCHAR2,
      p_iss_cd             VARCHAR2,
      p_prem_seq_no        VARCHAR2,
      p_multi_booking_yy   VARCHAR2,
      p_multi_booking_mm   VARCHAR2   
    );
    
   -- Added by apollo cruz 08.06.2015
   PROCEDURE update_polbasic_booking_date (p_policy_id VARCHAR2);
   
END;
/


