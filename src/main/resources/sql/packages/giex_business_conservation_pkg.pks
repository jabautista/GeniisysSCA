CREATE OR REPLACE PACKAGE CPI.GIEX_BUSINESS_CONSERVATION_PKG AS
/******************************************************************************
   NAME:       GIEX_BUSINESS_CONSERVATION_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        1/12/2012   Marco            Created this package.
******************************************************************************/

    TYPE bus_con_details_type IS RECORD (
        policy_id           GIEX_REN_RATIO_DTL_V.policy_id%TYPE,
        pack_policy_id      GIEX_REN_RATIO_DTL_V.pack_policy_id%TYPE,
        line_cd             GIEX_REN_RATIO_DTL_V.line_cd%TYPE,
        iss_cd              GIEX_REN_RATIO_DTL_V.iss_cd%TYPE,
        iss_name            GIEX_REN_RATIO_DTL_V.iss_name%TYPE,
        line_name           GIEX_REN_RATIO_DTL_V.line_name%TYPE,
        subline_name        GIEX_REN_RATIO_DTL_V.subline_name%TYPE,
        intm_number         GIEX_REN_RATIO_DTL_V.intm_number%TYPE,
        assured_no          GIEX_REN_RATIO_DTL_V.assured_no%TYPE,
        assured_name        GIEX_REN_RATIO_DTL_V.assured_name%TYPE,
        expiry_date         GIEX_REN_RATIO_DTL_V.expiry_date%TYPE,
        policy_no           GIEX_REN_RATIO_DTL_V.policy_no%TYPE,
        premium_amt         GIEX_REN_RATIO_DTL_V.premium_amt%TYPE,
        premium_renew_amt   GIEX_REN_RATIO_DTL_V.premium_renew_amt%TYPE,
        remarks             GIEX_REN_RATIO_DTL_V.remarks%TYPE,
        renewal_policy      GIEX_REN_RATIO_DTL_V.renewal_policy%TYPE,
        ref_pol_no          GIEX_REN_RATIO_DTL_V.ref_pol_no%TYPE,
        exp_date            VARCHAR2(5000),
        prem_amt            VARCHAR2(10000),
        prem_renew_amt      VARCHAR2(10000),
        prem_total          VARCHAR2(10000),
        prem_renew_total    VARCHAR2(10000),
        renewal_count       NUMBER
    );
    TYPE bus_con_details_tab IS TABLE OF bus_con_details_type;
    
    TYPE bus_con_lov_type IS RECORD (
        line_cd             VARCHAR2(100),
        line_name           GIIS_LINE.line_name%TYPE,
        subline_cd          GIIS_SUBLINE.subline_cd%TYPE,
        subline_name        GIIS_SUBLINE.subline_name%TYPE,
        iss_cd              VARCHAR2(100),
        iss_name            GIIS_ISSOURCE.iss_name%TYPE,
        intm_type           VARCHAR2(100),
        intm_desc           GIIS_INTM_TYPE.intm_desc%TYPE,
        intm_no             VARCHAR2(100),
        intm_name           GIIS_INTERMEDIARY.intm_name%TYPE,
        pack_pol_flag       VARCHAR2(3)
    );
    TYPE bus_con_lov_tab IS TABLE OF bus_con_lov_type;
    
    TYPE giexr111_main_type IS RECORD (
        pol_premium             GIEX_REN_RATIO.prem_amt%TYPE,
        no_of_policy            GIEX_REN_RATIO.nop%TYPE,
        line_cd                 GIEX_REN_RATIO.line_cd%TYPE,
        subline_cd              GIEX_REN_RATIO.subline_cd%TYPE,
        iss_cd                  GIEX_REN_RATIO.iss_cd%TYPE,
        year                    GIEX_REN_RATIO.year%TYPE,
        renew_prem              GIEX_REN_RATIO.prem_renew_amt%TYPE,
        new_prem                GIEX_REN_RATIO.prem_new_amt%TYPE,
        line_name               GIIS_LINE.line_name%TYPE,
        sum_nop                 GIEX_REN_RATIO.nop%TYPE,
        sum_nnp                 GIEX_REN_RATIO.nnp%TYPE,
        sum_nrp                 GIEX_REN_RATIO.nrp%TYPE,
        unrenewed               GIEX_REN_RATIO.nop%TYPE,
        subline_name            GIIS_SUBLINE.subline_name%TYPE,
        iss_name                GIIS_ISSOURCE.iss_name%TYPE,
        pct_differ              NUMBER,
        pct_differ_unrenewed    NUMBER,
        unrenewed_prem          GIEX_REN_RATIO.prem_amt%TYPE,
        pct_inc_dec             NUMBER,
        line_pct_inc_dec        NUMBER,
        iss_pct_inc_dec         NUMBER,
        grand_pct_inc_dec       NUMBER
    );
    TYPE giexr111_main_tab IS TABLE OF giexr111_main_type;
    
    TYPE giexr111_recap_type IS RECORD (
        max_year                NUMBER,
        iss_name                GIIS_ISSOURCE.iss_name%TYPE,
        grand_nop               GIEX_REN_RATIO.nop%TYPE,
        grand_pol_premium       GIEX_REN_RATIO.prem_amt%TYPE,
        grand_unrenewed         GIEX_REN_RATIO.nrp%TYPE,
        grand_unrenewed_prem    GIEX_REN_RATIO.prem_amt%TYPE,
        grand_pct_differ        NUMBER,
        grand_pct_inc_dec       NUMBER,
        total_pct_differ        NUMBER,
        total_pct_inc_dec       NUMBER
    );
    TYPE giexr111_recap_tab IS TABLE OF giexr111_recap_type;
    
    TYPE giexr112_header_type IS RECORD (
        company_name        VARCHAR2(1000),
        company_address     VARCHAR2(2000)
    );
    TYPE giexr112_header_tab IS TABLE OF giexr112_header_type;
    
    TYPE giexr112_main_type IS RECORD (
        policy_id           GIEX_REN_RATIO_DTL.policy_id%TYPE,
        pack_policy_id      GIEX_REN_RATIO_DTL.pack_policy_id%TYPE,
        iss_cd              GIEX_REN_RATIO_DTL.iss_cd%TYPE,
        line_cd             GIEX_REN_RATIO_DTL.line_cd%TYPE,
        subline_cd          GIEX_REN_RATIO_DTL.subline_cd%TYPE,
        iss_cd2             GIEX_REN_RATIO_DTL.iss_cd%TYPE,
        line_cd2            GIEX_REN_RATIO_DTL.line_cd%TYPE,
        subline_cd1         GIEX_REN_RATIO_DTL.subline_cd%TYPE,
        issue_yy            GIPI_POLBASIC.issue_yy%TYPE,
        pol_seq_no          GIPI_POLBASIC.pol_seq_no%TYPE,
        renew_no            GIPI_POLBASIC.renew_no%TYPE,
        policy_no           VARCHAR2(100),
        tsi_amt             GIPI_POLBASIC.tsi_amt%TYPE,
        prem_amt            GIPI_POLBASIC.prem_amt%TYPE,
        tax_amt             GIPI_INVOICE.tax_amt%TYPE,
        expiry_date         GIPI_POLBASIC.expiry_date%TYPE,
        line_name           GIIS_LINE.line_name%TYPE,
        subline_name        GIIS_SUBLINE.subline_name%TYPE,
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        iss_name            GIIS_ISSOURCE.iss_name%TYPE,
        w_balance           VARCHAR2(1),
        w_clm               VARCHAR2(1),
        ref_pol_no          GIPI_POLBASIC.ref_pol_no%TYPE,
        intm_no             VARCHAR2(2000),
        total_due           GIPI_POLBASIC.prem_amt%TYPE,
        intm_name           VARCHAR(5000) --Added by Jerome Bautista 09.08.2015 SR 17460
    );
    TYPE giexr112_main_tab IS TABLE OF giexr112_main_type;
    
    --GIEXR109 BEGIN
    TYPE giexr109_main_type IS RECORD (
       line_name         giis_line.line_name%TYPE,
       line_cd           giis_line.line_cd%TYPE,
       iss_cd            giis_issource.iss_cd%TYPE,
       subline_cd        giis_subline.subline_cd%TYPE,
       subline_name      giis_subline.subline_name%TYPE,
       year              giex_ren_ratio.year%TYPE,
       iss_name          giis_issource.iss_name%TYPE,
       no_of_policy      number,
       no_of_renewed     number,
       no_of_new         number,
       pct_renew         number,
       pct_diff          number,
       pct_renew_diff    number,
       sum_nop           number,
       sum_nrp           number,
       sum_nnp           number,
       g_sum_nop         number,
       g_sum_nrp         number,
       g_sum_nnp         number,
       pct_renew_avg     number,
       lcd_pct_diff      number,
       min_lcd_pd        number,
       max_lcd_pd        number,
       icd_pct_diff      number,
       min_isd_pd        number,
       max_isd_pd        number,
       isd_pct_diff      number,
       scd_pct_diff      number
    );
    
    TYPE giexr109_main_tab IS TABLE OF giexr109_main_type;
    
    TYPE giexr109_header_type IS RECORD (
       company_name      varchar2(32767),
       company_address   varchar2(32767)
    );
    
    TYPE giexr109_header_tab IS TABLE OF giexr109_header_type;
    
    TYPE giexr109_recap_type IS RECORD (
        iss_name            giis_issource.iss_name%TYPE,
        iss_cd              giis_issource.iss_cd%TYPE,
        year                giex_ren_ratio.year%TYPE,
        sum_nop             number,
        sum_nrp             number,
        sum_nnp             number,
        min_year_pct        number,
        max_year_pct        number,
        sum_pct_renew       number,
        g_min_year_pct      number,
        g_max_year_pct      number,
        g_sum_pct_renew     number
    );
    
    TYPE giexr109_recap_tab IS TABLE OF giexr109_recap_type;
    
    TYPE giexr109_grand_total_type IS RECORD (
        year                giex_ren_ratio.year%TYPE,
        sum_nop             number,
        sum_nrp             number,
        sum_nnp             number,
        grand_pct_renew     number,
        grand_pct_diff      number,
        grand_pct_diff_temp number,
        min_year_pct        number,
        max_year_pct        number
    );
    
    TYPE giexr109_grand_total_tab IS TABLE OF giexr109_grand_total_type;
    --GIEXR109 END
    --GIEXR110 BEGIN
    TYPE giexr110_main_type IS RECORD (
      iss_cd            giis_issource.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      subline_cd        giis_subline.subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      year              giex_ren_ratio.year%TYPE,
      renew_prem        number,        
      new_prem          number,
      sum_nop           number,
      sum_nnp           number,
      sum_nrp           number,
      pct_differ        number,
      no_of_policy      number,
      pol_premium       number,
      lcd_pct_diff      number,
      lcd_pol_premium   number,
      icd_pct_differ    number,
      scd_pct_differ    number,
      min_lcd_pd        number,
      max_lcd_pd        number,
      line_pct_diff     number,
      iss_pct_diff      number,
      min_icd_pd        number,
      max_icd_pd        number,
      min_scd_pd        number,
      max_scd_pd        number
   );
   
   TYPE giexr110_main_tab IS TABLE OF giexr110_main_type;
   
   TYPE giexr110_header_type IS RECORD (
       company_name      varchar2(32767),
       company_address   varchar2(32767)
    );
    
   TYPE giexr110_header_tab IS TABLE OF giexr110_header_type;
   
   TYPE giexr110_recap_type IS RECORD (
       year                giex_ren_ratio.year%TYPE,
       iss_name            giis_issource.iss_name%TYPE,
       iss_cd              giis_issource.iss_cd%TYPE,
       sum_nop             number,
       sum_nrp             number,
       sum_nnp             number,
       pol_premium         number,
       renew_prem          number,
       pct_differ          number,
       min_year_pct        number,
       max_year_pct        number,
       iss_pct_diff        number,
       min_grand_pd        number,
       max_grand_pd        number,
       grand_pct_diff      number
   );
    
   TYPE giexr110_recap_tab IS TABLE OF giexr110_recap_type;
    
   TYPE giexr110_grand_total_type IS RECORD (
       year                giex_ren_ratio.year%TYPE,
       sum_nop             number,
       sum_nrp             number,
       sum_nnp             number,
       grand_pol_premium   number,
       grand_renew_prem    number,
       grand_pct_differ    number,
       min_grand_pd        number,
       max_grand_pd        number,
       grand_pct_diff      number
   );
    
   TYPE giexr110_grand_total_tab IS TABLE OF giexr110_grand_total_type;
   --GIEXR110 END
   
    PROCEDURE extract_policies(
        p_line_cd           GIIS_LINE.line_cd%TYPE,
        p_subline_cd        GIIS_SUBLINE.subline_cd%TYPE,
        p_iss_cd            GIIS_ISSOURCE.iss_cd%TYPE,
        p_intm_no           NUMBER,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_del_table         VARCHAR2,
        p_inc_pack          VARCHAR2,
        p_cred_cd           GIIS_ISSOURCE.iss_cd%TYPE,
        p_intm_type         GIIS_INTM_TYPE.intm_type%TYPE,
        p_from_month        VARCHAR2,
        p_user_id           GIIS_USERS.user_id%TYPE,
        p_msg				OUT VARCHAR2 -- added by Daniel Marasigan 07.11.2016 SR 22330
    );
    
    FUNCTION get_bus_con_details(
        p_line_cd           GIIS_LINE.line_cd%TYPE,
        p_iss_cd            GIIS_ISSOURCE.iss_cd%TYPE,
        p_mode              NUMBER,
        p_assd_name         VARCHAR2,
        p_policy_no         VARCHAR2,
        p_renewal_no        VARCHAR2,
        p_prem_amt          VARCHAR2,
        p_renewal_amt       VARCHAR2,
        p_user_id           VARCHAR2
    )
      RETURN bus_con_details_tab PIPELINED;
      
    FUNCTION get_bus_con_pack_details(
        p_pack_pol_id       GIEX_REN_RATIO_PACK_V.pack_policy_id%TYPE,
        p_assd_name         VARCHAR2,
        p_policy_no         VARCHAR2,
        p_renewal_no        VARCHAR2,
        p_prem_amt          VARCHAR2,
        p_renewal_amt       VARCHAR2,
        p_user_id           VARCHAR2
    )
      RETURN bus_con_details_tab PIPELINED;
      
    FUNCTION get_bus_con_line_lov
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION get_bus_con_subline_lov(
        p_line_cd           GIIS_LINE.line_cd%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION get_bus_con_issue_lov
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION get_bus_con_credit_lov
      RETURN bus_con_lov_tab PIPELINED;
    
    FUNCTION get_bus_con_intm_type_lov
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION get_bus_con_intm_lov(
        p_intm_type         GIIS_INTM_TYPE.intm_type%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION get_bus_con_details_line_lov(
      p_user_id            GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION get_bus_con_details_iss_lov(
      p_user_id            GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED;
      
    FUNCTION populate_giexr111_main (
        p_line_cd           GIEX_REN_RATIO.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO.iss_cd%TYPE,
        p_user_id           GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN giexr111_main_tab PIPELINED;
      
    FUNCTION populate_giexr111_recap (
        p_line_cd           GIEX_REN_RATIO.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO.iss_cd%TYPE,
        p_user_id           GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN giexr111_recap_tab PIPELINED;
      
    FUNCTION populate_giexr112_header
      RETURN giexr112_header_tab PIPELINED;
    
    FUNCTION populate_giexr112_main (
        p_line_cd           GIEX_REN_RATIO_DTL.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO_DTL.iss_cd%TYPE,
        p_subline_cd        GIEX_REN_RATIO_DTL.subline_cd%TYPE,
        p_policy_id         GIEX_REN_RATIO_DTL.policy_id%TYPE,
        p_assd_no           GIEX_REN_RATIO_DTL.assd_no%TYPE,
        p_intm_no           GIEX_REN_RATIO_DTL.intm_no%TYPE,
        p_starting_date     DATE,
        p_ending_date       DATE,
        p_user_id           GIEX_REN_RATIO_DTL.user_id%TYPE
    )
      RETURN giexr112_main_tab PIPELINED;
    
    --GIEXR109 BEGIN
     FUNCTION populate_giexr109_main(
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
       RETURN giexr109_main_tab PIPELINED;
       
    FUNCTION populate_giexr109_header
    
       RETURN giexr109_header_tab PIPELINED;
       
    FUNCTION populate_giexr109_recap(
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
       RETURN giexr109_recap_tab PIPELINED;
       
    FUNCTION populate_giexr109_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
       RETURN giexr109_grand_total_tab PIPELINED;
    --GIEXR109 END
    --GIEXR110 BEGIN
    FUNCTION populate_giexr110_main(
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_user_id         giex_ren_ratio.user_Id%TYPE
    )
       RETURN giexr110_main_tab PIPELINED;
       
    FUNCTION populate_giexr110_header
    
       RETURN giexr110_header_tab PIPELINED;
    
    FUNCTION populate_giexr110_recap (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
       RETURN giexr110_recap_tab PIPELINED;
       
    FUNCTION populate_giexr110_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
       RETURN giexr110_grand_total_tab PIPELINED;
    --GIEXR110 BEGIN
    
END GIEX_BUSINESS_CONSERVATION_PKG;
/


