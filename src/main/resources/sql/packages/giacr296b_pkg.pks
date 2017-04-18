CREATE OR REPLACE PACKAGE CPI.giacr296b_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      as_of_cut_off     VARCHAR2 (100),
      ri_name           giac_outfacul_soa_ext.ri_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      currency_desc     giis_currency.currency_desc%TYPE,
      eff_date          giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date      giac_outfacul_soa_ext.booking_date%TYPE,
      currency_rt       giac_outfacul_soa_ext.currency_rt%TYPE,
      binder_no         giac_outfacul_soa_ext.binder_no%TYPE,
      ppw               giac_outfacul_soa_ext.ppw%TYPE,
      policy_no         giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name         giac_outfacul_soa_ext.assd_name%TYPE,
      prem_amt          giac_outfacul_soa_ext.fprem_amt%TYPE,
      prem_vat          giac_outfacul_soa_ext.fprem_vat%TYPE,
      comm_amt          giac_outfacul_soa_ext.fcomm_amt%TYPE,
      comm_vat          giac_outfacul_soa_ext.fcomm_vat%TYPE,
      wholding_vat      giac_outfacul_soa_ext.fwholding_vat%TYPE,
      net_due           giac_outfacul_soa_ext.fnet_due%TYPE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_296_b_report (
      p_as_of_date     VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_ri_cd          VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
   TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
   );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;      
      
END;
/


