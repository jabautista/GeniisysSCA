CREATE OR REPLACE PACKAGE CPI.populate_renewal_notice AS
/******************************************************************************
   NAME:       populate_renewal_notice
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/21/2011  Marco            Created this package.
******************************************************************************/

    TYPE renewal_type IS RECORD (
        policy                  gipi_polbasic.policy_id%TYPE,
        doc_name                giis_reports.desname%TYPE,
        version                 giis_reports.version%TYPE,
        item_title              VARCHAR2(1500),
        plate_no                VARCHAR2(200),
        motor_no                VARCHAR2(200),
        serial_no               VARCHAR2(200),
        line_cd                 VARCHAR2(2),
        assd_name               VARCHAR2(15000),
        assd_add                VARCHAR2(1500),
        policy_no               VARCHAR2(50),
        policy_id               gipi_polbasic.policy_id%TYPE,
        subline_name            giis_subline.subline_name%TYPE,
        term                    VARCHAR2(1000),
        deductible              VARCHAR2(20000),
        prem_amt                giex_new_group_peril.prem_amt%TYPE,--NUMBER(10) changed by reymon 02032014,
        dash                    VARCHAR2(4000),
        sc                      VARCHAR2(4000),
        peril_name              VARCHAR2(30000),
        peril_tsi               VARCHAR2(8000),
        peril_prem              VARCHAR2(8000),
        intm_no                 giis_intermediary.intm_no%TYPE,
        auto_pa                 VARCHAR2(1000),
        cur_date                VARCHAR2(100),
        prem                    VARCHAR2(4000),
        tax_amt                    giex_old_group_tax.tax_amt%TYPE,
        prem_tax                giex_old_group_tax.tax_amt%TYPE
    );
    
    TYPE renewal_tab IS TABLE OF renewal_type;
    
    FUNCTION populate_renewal_notice_ucpb(
        p_policy_id        VARCHAR2, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        p_policy_id2        VARCHAR2, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        p_policy_id3        VARCHAR2, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        p_start_date        DATE,
        p_end_date          DATE,
        p_fr_rn_seq_no      NUMBER,
        p_to_rn_seq_no      NUMBER,
        p_req_renewal_no    VARCHAR2,
        p_user_id           giis_users.user_id%TYPE /*added by cherrie, 11292012*/
    )
      RETURN renewal_tab PIPELINED;
      
   FUNCTION populate_renewal_notice_sub(
        p_policy_id         NUMBER, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        p_start_date        DATE,
        p_end_date          DATE,
        p_fr_rn_seq_no      NUMBER,
        p_to_rn_seq_no      NUMBER,
        p_req_renewal_no    VARCHAR2,
        p_user_id           giis_users.user_id%TYPE /*added by cherrie, 11292012*/
    )
      RETURN renewal_tab PIPELINED;      
      
    TYPE renewal_wpck_type IS RECORD (
        tsi_amt             VARCHAR(32767),
        iss_cd              gipi_polbasic.iss_cd%TYPE,
        policy_id           giex_pack_expiry.pack_policy_id%TYPE,
        policy              giex_pack_expiry.pack_policy_id%TYPE,
        assd_name           VARCHAR2(600),
        policy_no           VARCHAR2(50),
        expiry              VARCHAR2(30),
        address             VARCHAR(200),
        line_name           VARCHAR(200),
        acct_no             gipi_polbasic.assd_no%TYPE,
        net_amt             NUMBER(16,2),          
        prem_old            NUMBER(16,2),
        prem_new            NUMBER(16,2),
        prem_gross          NUMBER(16,2),
        tax_amt_old         VARCHAR2(1000),
        tax_amt_new         VARCHAR2(1000),
        tax_amts            VARCHAR2(1000),
        tax_amt_old_a       NUMBER(16,2),
        tax_amt_new_a       NUMBER(16,2),
        tax_amts_a          NUMBER(16,2),
        tax_desc_old        VARCHAR2(32000),
        tax_desc_new        VARCHAR2(30000),
        tax_descs           VARCHAR2(30000),
        tax_vat_old         VARCHAR2(100),
        tax_vat_new         VARCHAR2(100),
        tax_vat             VARCHAR2(100),
        ded_amt             VARCHAR2(50),
        short_name          giis_currency.short_name%TYPE,
        short_name2         VARCHAR2(32700),
        tax_param           giis_parameters.param_value_n%TYPE,
        vat_wordings        VARCHAR2(1000),
        subline_name        giis_subline.subline_name%TYPE,
        subline_name2       VARCHAR2(3000),
        tax_checker         giex_old_group_tax.tax_cd%TYPE,
        currency_cd         gipi_item.currency_cd%TYPE,
        currency_rt         giis_currency.currency_rt%TYPE,
        policy_currency     giex_expiry.policy_currency%TYPE,
        tsi_amt33           VARCHAR2(500),
        type                VARCHAR2(32000),
        peril_tsi           VARCHAR2(32000),
        cur1                VARCHAR2(500),
        cur2                VARCHAR2(500),
        pol_tsi             VARCHAR2(1000),
        pa_limit            VARCHAR2(500),
        auto_pa             VARCHAR2(400),
        intm_no             VARCHAR2(32000),
        cur_date            VARCHAR2(100),
        gross               VARCHAR2(100),
        net                 VARCHAR2(100),
        deductible          VARCHAR2(20000), /*added by cherrie, 11222012*/
        ded_count           NUMBER
    );
    
    TYPE renewal_wpck_tab IS TABLE OF renewal_wpck_type;
    
    FUNCTION populate_renewal_ucpb_wpck(
      p_policy   VARCHAR2, --giex_pack_expiry.pack_policy_id%TYPE -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      p_policy2  VARCHAR2,
      p_policy3  VARCHAR2   
    )
        RETURN renewal_wpck_tab PIPELINED;
        
   -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb     
   TYPE policy_id_array IS TABLE OF VARCHAR2(30000) INDEX BY BINARY_INTEGER;
   
   FUNCTION populate_renewal_ucpb_wpck_sub( -- Added by Jerome Bautista 07.10.2015 SR 19689
      p_policy   VARCHAR2 --giex_pack_expiry.pack_policy_id%TYPE -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb 
    )
        RETURN renewal_wpck_tab PIPELINED;
        
   -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb     
   --TYPE policy_id_array IS TABLE OF VARCHAR2(30000) INDEX BY BINARY_INTEGER;
   
   FUNCTION policy_id_to_array ( -- Added by Jerome Bautista 07.10.2015 SR 19689
      p_policy_id CLOB, 
      p_ref VARCHAR2
   ) 
      RETURN policy_id_array;
        
END populate_renewal_notice;
/


