CREATE OR REPLACE PACKAGE CPI.giacr296d_pkg
AS
   TYPE giacr296d_record_type IS RECORD (
      ri_cd             giac_outfacul_soa_ext.ri_cd%TYPE,
      line_cd           giac_outfacul_soa_ext.line_cd%TYPE,
      policy_id         giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id     giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      policy_id_dummy    VARCHAR2(20),
      fnl_binder_id_dummy VARCHAR2(20),
      col_no1           giis_report_aging.COLUMN_NO%type,
      col1              giis_report_aging.COLUMN_TITLE%type,
      col_no2           giis_report_aging.COLUMN_NO%type,
      col2              giis_report_aging.COLUMN_TITLE%type,
      col_no3           giis_report_aging.COLUMN_NO%type,
      col3              giis_report_aging.COLUMN_TITLE%type,
      col_no4           giis_report_aging.COLUMN_NO%type,
      col4              giis_report_aging.COLUMN_TITLE%type,
      row_num           NUMBER(5),
      lnet_due          giac_outfacul_soa_ext.lnet_due%TYPE,
      column_no         NUMBER (2),
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (500),
      column_title      VARCHAR2 (20),
      as_of_cut_off     VARCHAR2 (100),
      line_name         VARCHAR2 (20),
      eff_date          DATE,
      booking_date      DATE,
      binder_no         VARCHAR2 (15),
      policy_no         VARCHAR2 (50),
      lprem_amt         NUMBER (12, 2),
      lprem_vat         NUMBER (12, 2),
      lcomm_amt         NUMBER (12, 2),
      lcomm_vat         NUMBER (12, 2),
      lwholding_vat     NUMBER (12, 2),
      assd_name         VARCHAR2 (500),
      prem_bal          NUMBER (12, 2),
      loss_tag          VARCHAR2 (1),
      intm_name         VARCHAR2 (240),
      ppw               DATE,
      ri_name           VARCHAR2 (50),
      v_as_of_date      DATE,
      v_cut_off_date    DATE,
      print_details     VARCHAR2 (1)
   );

   TYPE giacr296d_record_tab IS TABLE OF giacr296d_record_type;

   TYPE giacr296d_matrix_header_type IS RECORD (
      column_no      giis_report_aging.column_no%TYPE,
      column_title   giis_report_aging.column_title%TYPE
   );

   TYPE giacr296d_matrix_header_tab IS TABLE OF giacr296d_matrix_header_type;

   TYPE get_giacr296d_matrix_details_t IS RECORD (
      line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      user_id         giac_outfacul_soa_ext.user_id%TYPE,
      policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      lnet_due        giac_outfacul_soa_ext.lnet_due%TYPE,
      column_no       giis_report_aging.column_no%TYPE
   );

   TYPE giacr296d_matrix_details_tab IS TABLE OF get_giacr296d_matrix_details_t;

   FUNCTION get_giacr296d_matrix_details (
      p_as_of_date      VARCHAR2,
      p_cut_off_date    VARCHAR2,
      p_line_cd         VARCHAR2,
      p_paid            VARCHAR2,
      p_partpaid        VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_unpaid          VARCHAR2,
      p_user_id         VARCHAR2,
      p_policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      p_fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE,
      p_row_num         NUMBER
   )
      RETURN giacr296d_matrix_details_tab PIPELINED;

   FUNCTION get_giacr296d_matrix_header
      RETURN giacr296d_matrix_header_tab PIPELINED;

   FUNCTION get_giacr296d_records (p_as_of_date VARCHAR2, p_cut_off_date VARCHAR2, p_line_cd VARCHAR2, p_paid VARCHAR2, p_partpaid VARCHAR2, p_ri_cd VARCHAR2, p_unpaid VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr296d_record_tab PIPELINED;
      
   TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
   );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;      
      
   FUNCTION get_giacr296d_summary_details (
      p_as_of_date      VARCHAR2,
      p_cut_off_date    VARCHAR2,
      p_line_cd         VARCHAR2,
      p_paid            VARCHAR2,
      p_partpaid        VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_unpaid          VARCHAR2,
      p_user_id         VARCHAR2,
      p_policy_id       giac_outfacul_soa_ext.policy_id%TYPE,
      p_fnl_binder_id   giac_outfacul_soa_ext.fnl_binder_id%TYPE
   )
      RETURN giacr296d_matrix_details_tab PIPELINED;
      
    -- SR-3883 : shan 08.10.2015
    TYPE title_type IS RECORD (
        dummy       NUMBER(10),
        col_title   giac_soa_title.col_title%TYPE,
        col_no      giac_soa_title.col_no%TYPE
    );

    TYPE title_tab IS TABLE OF title_type;
    
    TYPE column_header_type IS RECORD (
        dummy       NUMBER(10),
        col_no1      giac_soa_title.col_no%TYPE,
        col_title1   giac_soa_title.col_title%TYPE,
        col_no2      giac_soa_title.col_no%TYPE,
        col_title2   giac_soa_title.col_title%TYPE,
        col_no3      giac_soa_title.col_no%TYPE,
        col_title3   giac_soa_title.col_title%TYPE,
        col_no4      giac_soa_title.col_no%TYPE,
        col_title4   giac_soa_title.col_title%TYPE,
        no_of_dummy  NUMBER(10),
        row1         NUMBER(5), -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898
        row2         NUMBER(5),
        row3         NUMBER(5),
        row4         NUMBER(5)
    );

    TYPE column_header_tab IS TABLE OF column_header_type;

    FUNCTION get_column_header ( p_user_id VARCHAR2 ) --jhing --  added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
        RETURN column_header_tab PIPELINED;
    
    TYPE report_type IS RECORD (        
        company_name      VARCHAR2 (100),
        company_address   VARCHAR2 (500),
        as_of_cut_off     VARCHAR2 (100),
        ri_cd             giac_outfacul_soa_ext.ri_cd%TYPE,
        ri_name           VARCHAR2 (50),
        line_cd           giac_outfacul_soa_ext.line_cd%TYPE,
        line_name         VARCHAR2 (20),
        policy_id         giac_outfacul_soa_ext.policy_id%TYPE,
        fnl_binder_id     giac_outfacul_soa_ext.fnl_binder_id%TYPE,
        policy_no         VARCHAR2 (50),
        binder_no         VARCHAR2 (15),
        eff_date          DATE,
        booking_date      DATE,
        lnet_due          giac_outfacul_soa_ext.lnet_due%TYPE,
        lprem_amt         NUMBER (12, 2),
        lprem_vat         NUMBER (12, 2),
        lcomm_amt         NUMBER (12, 2),
        lcomm_vat         NUMBER (12, 2),
        lwholding_vat     NUMBER (12, 2),
        assd_name         VARCHAR2 (500),
        prem_bal          NUMBER (12, 2),
        loss_tag          VARCHAR2 (1),
        intm_name         VARCHAR2 (240),
        ppw               DATE,
        dummy             NUMBER(5),
        ri_cd_dummy       VARCHAR2(10),
        col_no1           giis_report_aging.COLUMN_NO%type,
        col1              giis_report_aging.COLUMN_TITLE%type,
        lnet_due1         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no2           giis_report_aging.COLUMN_NO%type,
        col2              giis_report_aging.COLUMN_TITLE%type,
        lnet_due2         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no3           giis_report_aging.COLUMN_NO%type,
        col3              giis_report_aging.COLUMN_TITLE%type,
        lnet_due3         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no4           giis_report_aging.COLUMN_NO%type,
        col4              giis_report_aging.COLUMN_TITLE%type,
        lnet_due4         giac_outfacul_soa_ext.lnet_due%TYPE,
        row_num           NUMBER(5),
        no_of_dummy       NUMBER(5),
        print_details     VARCHAR2 (1),
        column_no1        giac_outfacul_soa_ext.column_no%TYPE, -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
        column_no2        giac_outfacul_soa_ext.column_no%TYPE,
        column_no3        giac_outfacul_soa_ext.column_no%TYPE,
        column_no4        giac_outfacul_soa_ext.column_no%TYPE,
        sum_ri_lnet_due1  giac_outfacul_soa_ext.lnet_due%TYPE,
        sum_ri_lnet_due2  giac_outfacul_soa_ext.lnet_due%TYPE,
        sum_ri_lnet_due3  giac_outfacul_soa_ext.lnet_due%TYPE,
        sum_ri_lnet_due4  giac_outfacul_soa_ext.lnet_due%TYPE,
        line_count        NUMBER(5),
        grand_prem_bal    giac_outfacul_soa_ext.prem_bal%TYPE,
        grand_lprem_amt   giac_outfacul_soa_ext.lprem_amt%TYPE,
        grand_lprem_vat   giac_outfacul_soa_ext.lprem_vat%TYPE,
        grand_lcomm_amt   giac_outfacul_soa_ext.lcomm_amt%TYPE,
        grand_lcomm_vat   giac_outfacul_soa_ext.lcomm_vat%TYPE,
        grand_lwholding_vat   giac_outfacul_soa_ext.lwholding_vat%TYPE,
        grand_lnet_due    giac_outfacul_soa_ext.lnet_due%TYPE,
        max_ri_name       giis_reinsurer.ri_name%TYPE,
        max_line_cd       giac_outfacul_soa_ext.line_cd%TYPE -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 end
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_report_details (
        p_as_of_date    VARCHAR2, 
        p_cut_off_date  VARCHAR2,  
        p_ri_cd         VARCHAR2, 
        p_line_cd       VARCHAR2, 
        p_paid          VARCHAR2, 
        p_partpaid      VARCHAR2,
        p_unpaid        VARCHAR2, 
        p_user_id       VARCHAR2
    ) RETURN report_tab PIPELINED;
    
    
    TYPE summary_column_header_type IS RECORD (
        dummy       NUMBER(10),
        col_no1      giac_soa_title.col_no%TYPE,
        col_title1   giac_soa_title.col_title%TYPE,
        col_no2      giac_soa_title.col_no%TYPE,
        col_title2   giac_soa_title.col_title%TYPE,
        col_no3      giac_soa_title.col_no%TYPE,
        col_title3   giac_soa_title.col_title%TYPE,
        col_no4      giac_soa_title.col_no%TYPE,
        col_title4   giac_soa_title.col_title%TYPE,
        col_no5      giac_soa_title.col_no%TYPE,
        col_title5   giac_soa_title.col_title%TYPE,
        col_no6      giac_soa_title.col_no%TYPE,
        col_title6   giac_soa_title.col_title%TYPE,
        col_no7      giac_soa_title.col_no%TYPE,
        col_title7   giac_soa_title.col_title%TYPE,
        no_of_dummy  NUMBER(10)
    );

    TYPE summary_column_header_tab IS TABLE OF summary_column_header_type;

    FUNCTION get_summary_column_header ( p_user_id VARCHAR2 )  -- added by jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
        RETURN summary_column_header_tab PIPELINED;
    
    TYPE summary_report_type IS RECORD (    
        ri_cd             giac_outfacul_soa_ext.ri_cd%TYPE,
        ri_name           VARCHAR2 (50),
        prem_bal          NUMBER (12, 2),
        lprem_amt         NUMBER (12, 2),
        lprem_vat         NUMBER (12, 2),
        lcomm_amt         NUMBER (12, 2),
        lcomm_vat         NUMBER (12, 2),
        lwholding_vat     NUMBER (12, 2),
        lnet_due          giac_outfacul_soa_ext.lnet_due%TYPE,
        dummy             NUMBER(5),
        ri_cd_dummy       VARCHAR2(10),
        col_no1           giis_report_aging.COLUMN_NO%type,
        col1              giis_report_aging.COLUMN_TITLE%type,
        lnet_due1         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no2           giis_report_aging.COLUMN_NO%type,
        col2              giis_report_aging.COLUMN_TITLE%type,
        lnet_due2         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no3           giis_report_aging.COLUMN_NO%type,
        col3              giis_report_aging.COLUMN_TITLE%type,
        lnet_due3         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no4           giis_report_aging.COLUMN_NO%type,
        col4              giis_report_aging.COLUMN_TITLE%type,
        lnet_due4         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no5           giis_report_aging.COLUMN_NO%type,
        col5              giis_report_aging.COLUMN_TITLE%type,
        lnet_due5         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no6           giis_report_aging.COLUMN_NO%type,
        col6              giis_report_aging.COLUMN_TITLE%type,
        lnet_due6         giac_outfacul_soa_ext.lnet_due%TYPE,
        col_no7           giis_report_aging.COLUMN_NO%type,
        col7              giis_report_aging.COLUMN_TITLE%type,
        lnet_due7         giac_outfacul_soa_ext.lnet_due%TYPE,
        no_of_dummy       NUMBER(5),
        print_details     VARCHAR2 (1)
    );
    
    TYPE summary_report_tab IS TABLE OF summary_report_type;
    
    FUNCTION get_report_summary_details (
        p_as_of_date    VARCHAR2, 
        p_cut_off_date  VARCHAR2,  
        p_ri_cd         VARCHAR2, 
        p_line_cd       VARCHAR2, 
        p_paid          VARCHAR2, 
        p_partpaid      VARCHAR2,
        p_unpaid        VARCHAR2, 
        p_user_id       VARCHAR2
    ) RETURN summary_report_tab PIPELINED;
    -- end SR-3883
END;
/


