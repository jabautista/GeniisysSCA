CREATE OR REPLACE PACKAGE CPI.GIACR296C_PKG AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.011.2013
    **  Reference By : GIACR296C_PKG - PREMIUMS DUE TO REINSURER
    */

TYPE giacr296c_type_old IS RECORD(
    company_name        VARCHAR2(100),
    company_address     VARCHAR2(500),  
    as_of_cut_off       VARCHAR2(100),
    ri_name             giac_outfacul_soa_ext.ri_name%TYPE,
    line_name           giis_line.line_name%TYPE,
    eff_date            giac_outfacul_soa_ext.eff_date%TYPE,
    booking_date        giac_outfacul_soa_ext.booking_date%TYPE,
    binder_no           giac_outfacul_soa_ext.binder_no%TYPE,
    ppw                 giac_outfacul_soa_ext.ppw%TYPE,
    policy_no           giac_outfacul_soa_ext.policy_no%TYPE,
    assd_name           giac_outfacul_soa_ext.assd_name%TYPE,
    fprem_amt           giac_outfacul_soa_ext.fprem_amt%TYPE,
    fprem_vat           giac_outfacul_soa_ext.fprem_vat%TYPE,
    fcomm_amt           giac_outfacul_soa_ext.fcomm_amt%TYPE,
    fcomm_vat           giac_outfacul_soa_ext.fcomm_vat%TYPE,
    fwholding_vat       giac_outfacul_soa_ext.fwholding_vat%TYPE,
    fnet_due            giac_outfacul_soa_ext.fnet_due%TYPE,
    policy_id           giac_outfacul_soa_ext.policy_id%TYPE,
    fnl_binder_id       giac_outfacul_soa_ext.fnl_binder_id%TYPE,
    ri_cd               giac_outfacul_soa_ext.ri_cd%TYPE,
    line_cd             giac_outfacul_soa_ext.line_cd%TYPE,
    currency_cd         GIAC_OUTFACUL_SOA_EXT.CURRENCY_CD%TYPE,
    currency_rt         giac_outfacul_soa_ext.currency_rt%TYPE,
    currency_desc       giis_currency.currency_desc%TYPE

);      
TYPE giacr296c_tab_old IS TABLE OF giacr296c_type_old;

TYPE giacr296c_header_type IS RECORD (
    column_no           NUMBER(2),
    column_title        VARCHAR2(100)
    );
TYPE giacr296c_header_tab IS TABLE OF giacr296c_header_type;

TYPE giacr296c_matrix_type IS RECORD (
    d_fnet_due          giac_outfacul_soa_ext.fnet_due%TYPE,
    d_column_no         giis_report_aging.column_no%TYPE,
    d_ri_cd             giac_outfacul_soa_ext.ri_cd%TYPE,
    d_line_cd           giac_outfacul_soa_ext.line_cd%TYPE,
    d_currency_cd      giac_outfacul_soa_ext.currency_cd%TYPE,
    d_currency_rt       giac_outfacul_soa_ext.currency_rt%TYPE,
    d_policy_id         giac_outfacul_soa_ext.policy_id%TYPE,
    d_fnl_binder_id     giac_outfacul_soa_ext.fnl_binder_id%TYPE
     );
TYPE giacr296c_matrix_tab IS TABLE OF giacr296c_matrix_type;

FUNCTION populate_giacr296c_old(
    p_as_of         varchar2,
    p_cut_off       varchar2, 
    p_ri_cd         NUMBER, 
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2
)
RETURN giacr296c_tab_old PIPELINED;
FUNCTION populate_giacr296c_header ( p_user_id VARCHAR2 )  -- jhing added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
RETURN giacr296c_header_tab PIPELINED;
FUNCTION populate_giacr296c_matrix(
    p_as_of         varchar2,
    p_cut_off       varchar2, 
    p_ri_cd         NUMBER,
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2,
    p_currency_cd   NUMBER,
    p_currency_rt   NUMBER,
    p_policy_id     NUMBER,
    p_fnl_binder_id NUMBER,
    p_fnet_due      NUMBER
  --  p_column_no     NUMBER
)
RETURN giacr296c_matrix_tab PIPELINED;

   TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
   );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;
      
	-- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
	TYPE title_type IS RECORD (
      dummy          NUMBER(10),
      col_title      giis_report_aging.column_title%TYPE,
      col_no         giis_report_aging.column_no%TYPE
   );

   TYPE title_tab IS TABLE OF title_type;

   TYPE column_header_type IS RECORD (
      dummy          NUMBER(10),
      col_no1        giis_report_aging.column_no%TYPE,
      col_title1     giis_report_aging.column_title%TYPE,
      col_no2        giis_report_aging.column_no%TYPE,
      col_title2     giis_report_aging.column_title%TYPE,
      col_no3        giis_report_aging.column_no%TYPE,
      col_title3     giis_report_aging.column_title%TYPE,
      col_no4        giis_report_aging.column_no%TYPE,
      col_title4     giis_report_aging.column_title%TYPE,
      row1           NUMBER(5),
      row2           NUMBER(5),
      row3           NUMBER(5),
      row4           NUMBER(5)
   );
   
   TYPE column_header_tab IS TABLE OF column_header_type;

   FUNCTION get_column_header(
      p_user_id      giis_users.user_id%TYPE
   ) RETURN column_header_tab PIPELINED;
   
   TYPE giacr296c_type IS RECORD(
      v_not_exist          VARCHAR2(2),
      print_details        VARCHAR2(1),
      company_name         VARCHAR2(100),
      company_address      VARCHAR2(500),
      as_of_cut_off        VARCHAR2(100),
      ri_cd                giac_outfacul_soa_ext.ri_cd%TYPE,
      ri_name              giac_outfacul_soa_ext.ri_name%TYPE,
      line_cd              giac_outfacul_soa_ext.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      eff_date             giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date         giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no            giac_outfacul_soa_ext.binder_no%TYPE,
      policy_no            giac_outfacul_soa_ext.policy_no%TYPE,
      ppw                  giac_outfacul_soa_ext.ppw%TYPE,
      assd_name            giac_outfacul_soa_ext.assd_name%TYPE,
      fprem_amt            giac_outfacul_soa_ext.fprem_amt%TYPE,
      fprem_vat            giac_outfacul_soa_ext.fprem_vat%TYPE,
      fcomm_amt            giac_outfacul_soa_ext.fcomm_amt%TYPE,
      fcomm_vat            giac_outfacul_soa_ext.fcomm_vat%TYPE,
      fwholding_vat        giac_outfacul_soa_ext.fwholding_vat%TYPE,
      fnet_due             giac_outfacul_soa_ext.fnet_due%TYPE,
      currency_cd          giac_outfacul_soa_ext.currency_cd%TYPE,
      currency_rt          giac_outfacul_soa_ext.currency_rt%TYPE,
      currency_desc        giis_currency.currency_desc%TYPE,
      policy_id            giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id        giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      column_no1           giac_outfacul_soa_ext.column_no%TYPE,
      column_no2           giac_outfacul_soa_ext.column_no%TYPE,
      column_no3           giac_outfacul_soa_ext.column_no%TYPE,
      column_no4           giac_outfacul_soa_ext.column_no%TYPE,
      dummy                NUMBER(5),
      ri_cd_dummy          VARCHAR2(10),
      col_no1              giis_report_aging.column_no%TYPE,
      col1                 giis_report_aging.column_title%TYPE,
      col_no2              giis_report_aging.column_no%TYPE,
      col2                 giis_report_aging.column_title%TYPE,
      col_no3              giis_report_aging.column_no%TYPE,
      col3                 giis_report_aging.column_title%TYPE,
      col_no4              giis_report_aging.column_no%TYPE,
      col4                 giis_report_aging.column_title%TYPE,
      fnet_due1            giac_outfacul_soa_ext.fnet_due%TYPE,
      fnet_due2            giac_outfacul_soa_ext.fnet_due%TYPE,
      fnet_due3            giac_outfacul_soa_ext.fnet_due%TYPE,
      fnet_due4            giac_outfacul_soa_ext.fnet_due%TYPE,
      sum_curr_fnet_due1   giac_outfacul_soa_ext.fnet_due%TYPE,
      sum_curr_fnet_due2   giac_outfacul_soa_ext.fnet_due%TYPE,
      sum_curr_fnet_due3   giac_outfacul_soa_ext.fnet_due%TYPE,
      sum_curr_fnet_due4   giac_outfacul_soa_ext.fnet_due%TYPE,
      sum_curr_fprem_amt        giac_outfacul_soa_ext.fprem_amt%TYPE,
      sum_curr_fprem_vat        giac_outfacul_soa_ext.fprem_vat%TYPE,
      sum_curr_fcomm_amt        giac_outfacul_soa_ext.fcomm_amt%TYPE,
      sum_curr_fcomm_vat        giac_outfacul_soa_ext.fcomm_vat%TYPE,
      sum_curr_fwholding_vat    giac_outfacul_soa_ext.fwholding_vat%TYPE,
      sum_curr_fnet_due         giac_outfacul_soa_ext.fnet_due%TYPE,
      curr_rt_count             NUMBER(5),
      curr_rt_max               giac_outfacul_soa_ext.currency_rt%TYPE
   );      

   TYPE giacr296c_tab IS TABLE OF giacr296c_type;
   
   FUNCTION populate_giacr296c(
      p_as_of           VARCHAR2,
      p_cut_off         VARCHAR2,
      p_ri_cd           NUMBER,
      p_line_cd         VARCHAR2,
      p_user            VARCHAR2
   ) RETURN giacr296c_tab PIPELINED;
   
   FUNCTION get_currency_row_total(
      p_cut_off         VARCHAR2,
      p_as_of           VARCHAR2,
      p_ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      p_line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      p_currency_cd     giac_outfacul_soa_ext.currency_cd%TYPE,
      p_column_no       giac_outfacul_soa_ext.column_no%TYPE,
      p_user_branch     giis_report_aging.branch_cd%TYPE,
      p_user_id         giac_outfacul_soa_ext.user_id%TYPE
   ) RETURN NUMBER;
   -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 end

END GIACR296C_PKG;
/


