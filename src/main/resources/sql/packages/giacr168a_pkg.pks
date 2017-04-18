/*
Created by: Gzelle
Date      : 12012015
Remarks   : referenced by GIACR167 and GIACR169
            get_giacr168a_all_rec functions is also used in csv_acctg.officialreceiptsregister_ap_a
            apply changes accordingly.
*/
CREATE OR REPLACE PACKAGE CPI.GIACR168A_PKG
AS
    TYPE parent_rec_type IS RECORD (
        branch                  VARCHAR2(50) := '',
        or_pref_suf             giac_order_of_payts.or_pref_suf%TYPE,
        or_no                   giac_order_of_payts.or_no%TYPE,
        or_flag                 giac_order_of_payts.or_flag%TYPE,
        particulars             giac_order_of_payts.particulars%TYPE,
        last_update             giac_order_of_payts.last_update%TYPE,
        or_number               VARCHAR2(50) := '',
        or_date                 giac_order_of_payts.or_date%TYPE,
        cancel_date             giac_order_of_payts.cancel_date%TYPE,
        dcb_number              VARCHAR2(50) := '',
        cancel_dcb_number       VARCHAR2(50) := '',
        tran_date               giac_acctrans.tran_date%TYPE,
        posting_date            giac_acctrans.posting_date%TYPE,        
        payor                   giac_order_of_payts.payor%TYPE,        
        amt_received            giac_collection_dtl.amount%TYPE,        
        currency                giis_currency.short_name%TYPE,        
        foreign_curr_amt        giac_collection_dtl.fcurrency_amt%TYPE,
        or_type                 VARCHAR2(2)  := '',                 
        tran_id                 giac_acctrans.tran_id%TYPE,
        or_tag                  giac_order_of_payts.or_tag%TYPE,
        prem_amt                giac_direct_prem_collns.premium_amt%TYPE,
        vat_tax_amt             giac_tax_collns.tax_amt%TYPE,
        lgt_tax_amt             giac_tax_collns.tax_amt%TYPE,
        dst_tax_amt             giac_tax_collns.tax_amt%TYPE,
        fst_tax_amt             giac_tax_collns.tax_amt%TYPE,
        other_tax_amt           giac_tax_collns.tax_amt%TYPE,
        company_name            giis_parameters.param_value_v%TYPE,
        company_address         giac_parameters.param_value_v%TYPE,
        posted                  VARCHAR2(70) := '',
        top_date                VARCHAR2(70) := '',
        v_print_all             VARCHAR2(8)     
    );
    TYPE parent_rec_tab IS TABLE OF parent_rec_type;  

    FUNCTION get_giacr168a_parent_rec(
        p_date          DATE,
        p_date2         DATE,
        p_branch_cd     VARCHAR2,
        p_user_id       VARCHAR2,
        p_posted        VARCHAR2
    )
        RETURN parent_rec_tab PIPELINED; 

    FUNCTION get_giacr168a_all_rec(
        p_date          VARCHAR2,
        p_date2         VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_user_id       VARCHAR2,
        p_posted        VARCHAR2,
        p_or_tag        VARCHAR2
    )
        RETURN parent_rec_tab PIPELINED;        
END;
/


