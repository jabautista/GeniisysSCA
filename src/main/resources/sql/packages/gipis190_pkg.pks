CREATE OR REPLACE PACKAGE CPI.GIPIS190_PKG
AS
   TYPE disc_surc_list_type IS RECORD(
      policy_id               gipi_polbasic.policy_id%TYPE,
      policy_no               VARCHAR2(50),
      endt_no                 VARCHAR2(25),
      cred_branch             gipi_polbasic.cred_branch%TYPE,
      disc_amt                gipi_peril_discount.disc_amt%TYPE,         
      surc_amt                gipi_peril_discount.surcharge_amt%TYPE,
      prem_amt                gipi_polbasic.prem_amt%TYPE,
      tsi_amt                 gipi_polbasic.tsi_amt%TYPE,
      assd_name               giis_assured.assd_name%TYPE,
      disc_sw                 VARCHAR2(1),
      surc_sw                 VARCHAR2(1)
   );
       
   TYPE disc_surc_list_tab IS TABLE OF disc_surc_list_type;
   
   FUNCTION get_disc_surc_list(
      p_line_cd               gipi_polbasic.line_cd%TYPE,
      p_disc_sw               VARCHAR2,
      p_surc_sw               VARCHAR2,
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE
   ) RETURN disc_surc_list_tab PIPELINED;
   
   TYPE disc_surc_detail_type IS RECORD(
      sequence                VARCHAR2(10),
      item_no                 VARCHAR2(10),
      peril_name              giis_peril.peril_name%TYPE,                     
      disc_amt                gipi_peril_discount.disc_amt%TYPE,
      disc_rt                 gipi_peril_discount.disc_rt%TYPE,
      surc_amt                gipi_peril_discount.surcharge_amt%TYPE,
      surc_rt                 gipi_peril_discount.surcharge_rt%TYPE,
      net_prem_amt            gipi_peril_discount.net_prem_amt%TYPE,
      net_gross_tag           gipi_peril_discount.net_gross_tag%TYPE,
      remarks                 gipi_peril_discount.remarks%TYPE
   );
       
   TYPE disc_surc_detail_tab IS TABLE OF disc_surc_detail_type;
   
   FUNCTION get_disc_surc_details(
      p_policy_id             gipi_polbasic.policy_id%TYPE,
      p_type                  VARCHAR2
   )RETURN disc_surc_detail_tab PIPELINED;
   
   TYPE line_listing_type IS RECORD (
      line_cd                 giis_line.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;
   
   FUNCTION get_gipis190_line_lov(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   ) RETURN line_listing_tab PIPELINED;    
   
   PROCEDURE get_disc_surc_sw(
      p_policy_id             IN gipi_polbasic_discount.policy_id%TYPE,
      p_disc_sw               OUT VARCHAR2,
      p_surc_sw               OUT VARCHAR2
   );
END;
/


