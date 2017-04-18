CREATE OR REPLACE PACKAGE CPI.GIACR296_PKG AS

TYPE giacr296_type IS RECORD(
    company_name        giis_parameters.param_value_v%TYPE,
    company_address     giis_parameters.param_value_v%TYPE,
    as_of_cut_off       VARCHAR2(100),
    v_not_exist         VARCHAR2(2),
    ri_name             giac_outfacul_soa_ext.ri_name%TYPE,
    line_name           giis_line.line_name%TYPE,
    eff_date            giac_outfacul_soa_ext.eff_date%TYPE,
    booking_date        giac_outfacul_soa_ext.booking_date%TYPE,
    binder_no           giac_outfacul_soa_ext.binder_no%TYPE,
    ppw                 giac_outfacul_soa_ext.ppw%TYPE,
    policy_no           giac_outfacul_soa_ext.policy_no%TYPE,
    assd_name           giac_outfacul_soa_ext.assd_name%TYPE,
    lprem_amt           giac_outfacul_soa_ext.lprem_amt%TYPE,
    lprem_vat           giac_outfacul_soa_ext.lprem_vat%TYPE,
    lcomm_amt           giac_outfacul_soa_ext.lcomm_amt%TYPE,
    lcomm_vat           giac_outfacul_soa_ext.lcomm_vat%TYPE,
    lwholding_vat       giac_outfacul_soa_ext.lwholding_vat%TYPE,
    lnet_due            giac_outfacul_soa_ext.lnet_due%TYPE
);

TYPE giacr296_tab IS TABLE OF giacr296_type;

FUNCTION populate_giacr296(
    p_as_of     VARCHAR2,
    p_cut_off   VARCHAR2,
    p_ri_cd     VARCHAR2,
    p_line_cd   VARCHAR2,
    p_user      VARCHAR2
)
RETURN giacr296_tab PIPELINED;

TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
   );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;


END GIACR296_PKG;
/


