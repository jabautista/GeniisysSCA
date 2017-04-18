CREATE OR REPLACE PACKAGE CPI.GIACR296A_PKG AS

TYPE giacr296a_type_old IS RECORD(
    v_not_exist         VARCHAR2(2),
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
    lprem_amt           giac_outfacul_soa_ext.lprem_amt%TYPE,
    lprem_vat           giac_outfacul_soa_ext.lprem_vat%TYPE,
    lcomm_amt           giac_outfacul_soa_ext.lcomm_amt%TYPE,
    lcomm_vat           giac_outfacul_soa_ext.lcomm_vat%TYPE,
    lwholding_vat       giac_outfacul_soa_ext.lwholding_vat%TYPE,
    lnet_due            giac_outfacul_soa_ext.lnet_due%TYPE,
    policy_id           giac_outfacul_soa_ext.policy_id%TYPE,
    fnl_binder_id       giac_outfacul_soa_ext.fnl_binder_id%TYPE,
    ri_cd               giac_outfacul_soa_ext.ri_cd%TYPE,
    line_cd             giac_outfacul_soa_ext.line_cd%TYPE
);      
TYPE giacr296a_tab_old IS TABLE OF giacr296a_type_old;

FUNCTION populate_giacr296a_old(
    p_as_of         VARCHAR2,
    p_cut_off       VARCHAR2,
    p_ri_cd         NUMBER,
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2
)
RETURN giacr296a_tab_old PIPELINED;

TYPE giacr296a_matrix_header_type IS RECORD(
    column_no       giis_report_aging.column_no%TYPE,
    column_title    giis_report_aging.column_title%TYPE
);
TYPE giacr296a_matrix_header_tab IS TABLE OF giacr296a_matrix_header_type;

FUNCTION get_giacr296a_matrix_header (p_user_id VARCHAR2 )  RETURN giacr296a_matrix_header_tab PIPELINED; -- jhing GENQA 4099, 4100, 4102, 4101 added p_user_id

TYPE giacr296a_matrix_type IS RECORD(
    lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE,
    ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
    line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
    policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
    fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
    column_no       giac_outfacul_soa_ext.column_no%TYPE
        
);
TYPE giacr296a_matrix_tab IS TABLE OF giacr296a_matrix_type;

FUNCTION populate_giacr296a_matrix(
    p_as_of         VARCHAR2,
    p_cut_off       VARCHAR2,    
    p_ri_cd         NUMBER,
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2,
    p_policy_id     NUMBER,
    p_fnl_binder_id NUMBER
    
)
RETURN giacr296a_matrix_tab PIPELINED;

   TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
   );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;
      
   TYPE title_type IS RECORD (
      dummy          NUMBER(10),
      col_title      giis_report_aging.column_title%TYPE,
      col_no         giis_report_aging.column_no%TYPE
   );

   TYPE title_tab IS TABLE OF title_type;

   -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
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
   
   TYPE giacr296a_type IS RECORD(
      v_not_exist          VARCHAR2(2),
      print_details        VARCHAR2(1),
      company_name         VARCHAR2(100),
      company_address      VARCHAR2(500),
      as_of_cut_off        VARCHAR2(100),
      ri_name              giac_outfacul_soa_ext.ri_name%TYPE,
      line_name            giis_line.line_name%TYPE,
      eff_date             giac_outfacul_soa_ext.eff_date%TYPE,
      booking_date         giac_outfacul_soa_ext.booking_date%TYPE,
      binder_no            giac_outfacul_soa_ext.binder_no%TYPE,
      ppw                  giac_outfacul_soa_ext.ppw%TYPE,
      policy_no            giac_outfacul_soa_ext.policy_no%TYPE,
      assd_name            giac_outfacul_soa_ext.assd_name%TYPE,
      lprem_amt            giac_outfacul_soa_ext.lprem_amt%TYPE,
      lprem_vat            giac_outfacul_soa_ext.lprem_vat%TYPE,
      lcomm_amt            giac_outfacul_soa_ext.lcomm_amt%TYPE,
      lcomm_vat            giac_outfacul_soa_ext.lcomm_vat%TYPE,
      lwholding_vat        giac_outfacul_soa_ext.lwholding_vat%TYPE,
      lnet_due             giac_outfacul_soa_ext.lnet_due%TYPE,
      policy_id            giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id        giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      ri_cd                giac_outfacul_soa_ext.ri_cd%TYPE,
      line_cd              giac_outfacul_soa_ext.line_cd%TYPE,
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
      lnet_due1            giac_outfacul_soa_ext.lnet_due%TYPE,
      lnet_due2            giac_outfacul_soa_ext.lnet_due%TYPE,
      lnet_due3            giac_outfacul_soa_ext.lnet_due%TYPE,
      lnet_due4            giac_outfacul_soa_ext.lnet_due%TYPE,
      sum_ri_lnet_due1     giac_outfacul_soa_ext.lnet_due%TYPE,
      sum_ri_lnet_due2     giac_outfacul_soa_ext.lnet_due%TYPE,
      sum_ri_lnet_due3     giac_outfacul_soa_ext.lnet_due%TYPE,
      sum_ri_lnet_due4     giac_outfacul_soa_ext.lnet_due%TYPE,
      line_count           NUMBER(5)
   );      

   TYPE giacr296a_tab IS TABLE OF giacr296a_type;
   
   FUNCTION populate_giacr296a(
      p_as_of           VARCHAR2,
      p_cut_off         VARCHAR2,
      p_ri_cd           NUMBER,
      p_line_cd         VARCHAR2,
      p_user            VARCHAR2
   ) RETURN giacr296a_tab PIPELINED;
   -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 end

END GIACR296A_PKG;
/


