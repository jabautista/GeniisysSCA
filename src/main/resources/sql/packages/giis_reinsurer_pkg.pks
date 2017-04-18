CREATE OR REPLACE PACKAGE CPI.Giis_Reinsurer_Pkg AS

  TYPE reinsurer_main_list_type IS RECORD(
        ri_cd                   giis_reinsurer.ri_cd%TYPE,
        local_foreign_sw        giis_reinsurer.local_foreign_sw%TYPE,
        ri_status_cd            giis_reinsurer.ri_status_cd%TYPE,
        ri_name                 giis_reinsurer.ri_name%TYPE,
        ri_sname                giis_reinsurer.ri_sname%TYPE, 
        mail_address1           giis_reinsurer.mail_address1%TYPE, 
        mail_address2           giis_reinsurer.mail_address2%TYPE,
        mail_address3           giis_reinsurer.mail_address3%TYPE,
        bill_address1           giis_reinsurer.bill_address1%TYPE,
        bill_address2           giis_reinsurer.bill_address2%TYPE,
        bill_address3           giis_reinsurer.bill_address3%TYPE,
        phone_no                giis_reinsurer.phone_no%TYPE,
        fax_no                  giis_reinsurer.fax_no%TYPE,
        telex_no                giis_reinsurer.telex_no%TYPE,
        thru_ri_cd              giis_reinsurer.thru_ri_cd%TYPE,
        contact_pers            giis_reinsurer.contact_pers%TYPE,
        attention               giis_reinsurer.attention%TYPE,
        int_tax_rt              giis_reinsurer.int_tax_rt%TYPE,
        pres_and_xos            giis_reinsurer.pres_and_xos%TYPE,
        liscence_no             giis_reinsurer.liscence_no%TYPE,
        max_line_net_ret        giis_reinsurer.max_line_net_ret%TYPE,
        max_net_ret             giis_reinsurer.max_net_ret%TYPE,
        tot_asset               giis_reinsurer.tot_asset%TYPE,
        tot_liab                giis_reinsurer.tot_liab%TYPE,
        tot_net_worth           giis_reinsurer.tot_net_worth%TYPE,
        capital_struc           giis_reinsurer.capital_struc%TYPE,
        ri_type                 giis_reinsurer.ri_type%TYPE,
        eff_date                giis_reinsurer.eff_date%TYPE,
        expiry_date             giis_reinsurer.expiry_date%TYPE,
        user_id                 giis_reinsurer.user_id%TYPE,
        last_update             giis_reinsurer.last_update%TYPE,
        remarks                 giis_reinsurer.remarks%TYPE,
        cpi_rec_no              giis_reinsurer.cpi_rec_no%TYPE,
        cpi_branch_cd           giis_reinsurer.cpi_branch_cd%TYPE,
        cp_no                   giis_reinsurer.cp_no%TYPE,
        sun_no                  giis_reinsurer.sun_no%TYPE,
        smart_no                giis_reinsurer.smart_no%TYPE,
        globe_no                giis_reinsurer.globe_no%TYPE,
        input_vat_rate          giis_reinsurer.input_vat_rate%TYPE,
        ri_tin                  giis_reinsurer.ri_tin%TYPE
        --,facilities              giis_reinsurer.facilities%TYPE -- LONG type ayaw ni PIPELINED 
        );

  TYPE reinsurer_list_type IS RECORD
         (ri_cd                giis_reinsurer.ri_cd%TYPE,
        ri_name               giis_reinsurer.ri_name%TYPE, 
        ri_sname           giis_reinsurer.ri_sname%TYPE,
        transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE);
        
  TYPE reinsurer_list_type_2 IS RECORD
         (ri_cd                giis_reinsurer.ri_cd%TYPE,
        ri_name               giis_reinsurer.ri_name%TYPE,
        ri_sname           giis_reinsurer.ri_sname%TYPE);
        
  --pj diaz 01/33/2013 for cedant LOV
  TYPE reinsurer_list_type_3 IS RECORD
        (ri_cd      giis_reinsurer.ri_cd%TYPE,
        ri_name     giis_reinsurer.ri_name%TYPE);
   
  TYPE reinsurer_main_list_tab IS TABLE OF reinsurer_main_list_type;
  TYPE reinsurer_list_tab IS TABLE OF reinsurer_list_type;
  TYPE reinsurer_list_tab_2 IS TABLE OF reinsurer_list_type_2;
  TYPE reinsurer_list_tab_3 IS TABLE OF reinsurer_list_type_3;
  
/********************************** FUNCTION 1 ************************************
  MODULE:  GIACS008 
  RECORD GROUP NAME: LOV_REINSURER 
***********************************************************************************/ 
  FUNCTION get_reinsurer_list RETURN reinsurer_list_tab PIPELINED;
  
/********************************** FUNCTION 2 ************************************
  MODULE:  GIACS008 
  RECORD GROUP NAME: LOV_REINSURER2 
***********************************************************************************/ 
  FUNCTION get_reinsurer_list2 RETURN reinsurer_list_tab PIPELINED;  

  FUNCTION get_reinsurer_list3(p_share_type     gicl_advs_fla.share_type%TYPE)
  RETURN reinsurer_list_tab PIPELINED;
  
  FUNCTION get_reinsurer_list4(p_share_type     giac_loss_ri_collns.share_type%TYPE)
  RETURN reinsurer_list_tab PIPELINED;
  
  FUNCTION get_reinsurer_list5(p_keyword        VARCHAR2)
    RETURN reinsurer_list_tab_2 PIPELINED;
    
  FUNCTION get_reinsurer_list6(p_ri_name VARCHAR2, p_keyword VARCHAR2)
    RETURN reinsurer_list_tab_2 PIPELINED;
    
  FUNCTION get_insurer_sname(p_ri_cd    GIIS_REINSURER.ri_cd%TYPE)
    RETURN VARCHAR2;
  
  FUNCTION get_reinsurer_list7 RETURN reinsurer_main_list_tab PIPELINED;   
  FUNCTION get_input_vat_rt (v_ri_cd	IN	GIIS_REINSURER.ri_cd%TYPE) RETURN NUMBER;
  
  FUNCTION get_reinsurer_list8(
    p_line_cd           gipi_polbasic.line_cd%TYPE,
    p_subline_cd        gipi_polbasic.subline_cd%TYPE,
    p_iss_cd            gipi_polbasic.iss_cd%TYPE,
    p_issue_yy          gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no          gipi_polbasic.renew_no%TYPE,
    p_policy_id         giri_endttext.policy_id%TYPE,
    p_ri_cd             giri_frps_ri.ri_cd%TYPE
  )
  RETURN reinsurer_list_tab_2 PIPELINED;
  
  FUNCTION get_reinsurer_by_ri_cd(p_ri_cd   GIIS_REINSURER.ri_cd%TYPE)
   RETURN reinsurer_list_tab_2 PIPELINED;
   
   FUNCTION get_reinsurer_list9
    RETURN reinsurer_list_tab_2 PIPELINED;
	
   FUNCTION get_reinsurer_list10
	RETURN reinsurer_list_tab_2 PIPELINED;
  
   FUNCTION get_cedant_lov 
    RETURN reinsurer_list_tab_3 PIPELINED;--pjdiaz 1/30/2013
    
   FUNCTION get_reinsurer_lov
        RETURN reinsurer_list_tab_3 PIPELINED;
   
END Giis_Reinsurer_Pkg;
/


