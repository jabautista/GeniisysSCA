CREATE OR REPLACE PACKAGE CPI.GIARR001A_PKG       
AS
    /*
    Created by: John Carlo M. Brigino
    September 26, 2012
    */
    TYPE GIARR001A_daily_coll_rep_type IS RECORD(
        comp_name               VARCHAR (2000),
        comp_address            VARCHAR (2000),
        branch                  VARCHAR (2000),
        fund_cd                 VARCHAR (2000),
        branch_cd               VARCHAR (2000),
        dcb_year                NUMBER,
        dcb_no                  VARCHAR(10),
        --tran_date               DATE,        -- Start dren 06.15.2015 : SR 0018479
        tran_date               VARCHAR (2000),
        run_date                VARCHAR (2000),
        run_time                VARCHAR (2000),-- End dren 06.15.2015
        particulars1            VARCHAR (2000),
        or_no1                  VARCHAR (2000),
        particulars2            VARCHAR (2000),
        payor1                  VARCHAR (2000),
        
        gross_amt1              NUMBER(12,2),
        comm_amt1               NUMBER(12,2),
        misc_other_amt          NUMBER(12,2),
        
        vat_amt1                NUMBER(12,2),
        cred_whtax_amt          NUMBER(12,2),
        
        pay_mode                VARCHAR (2000),
        fcurrency1              VARCHAR (2000),
        amount_recvd2           NUMBER(12,2),
        fcurrency_amt           NUMBER(12,2),
        check_no1               VARCHAR2 (2000),
        check_date              VARCHAR2 (2000),  
        cs_no                   VARCHAR2  (200),     
        intm_no                 VARCHAR2 (200),              
        
        curr_desc               VARCHAR2 (2000),
        fcurr_tot               VARCHAR2 (2000),
        p_mode1                 VARCHAR2 (2000),
        tot_cash1               VARCHAR2 (2000),
        p_mode2                 VARCHAR2 (2000),
        tot_cash2               NUMBER(12,2),
               
        prep_label              VARCHAR2 (2000),
        signatory               VARCHAR2 (2000),
        cf_designation          VARCHAR2 (2000), 
        designation             VARCHAR2 (2000), 
        user_name               VARCHAR2 (2000),
        acct_no                 VARCHAR2 (2000),
        
        deposit1                VARCHAR2 (2000),
        
        
        --summary
        num_vat                 NUMBER,
        num_non_vat             NUMBER,
        num_misc                NUMBER,
        num_spoiled             NUMBER,
        num_cancelled           NUMBER,
        num_unprinted           NUMBER,
        num_spoiled_cancelled   NUMBER,
        
        vat_total               NUMBER(12,2),
        non_vat_total           NUMBER(12,2),
        misc_or_total           NUMBER(12,2),
        unprinted_amt_total     NUMBER(12,2),       
        vat_misc_total          NUMBER(12,2),
        
        --footer
        or_no_b1                VARCHAR2 (2000),
        particulars_b1          VARCHAR2 (2000),
        or_date_b               VARCHAR2 (2000),
        payor_b1                VARCHAR2 (2000),
        gross_amt_b1            NUMBER(12,2),
        comm_amt_b1             NUMBER(12,2),
        vat_amt_b1              NUMBER(12,2),
        amount_recvd_b1         NUMBER(12,2),
        pay_mode_b1             VARCHAR2 (2000),
        deposit1_total          NUMBER(12,2),
        fcurrency_b1_amt        NUMBER(12,2),
        fcurrency_b1            VARCHAR2 (2000),
        fcurrency_recvd_ab1     NUMBER(12,2),
        check_no_b1             VARCHAR2 (2000),
        intm_no_b1              VARCHAR2 (2000),
        
        vtemp                   NUMBER(12,2),
        cancelled_count         NUMBER(12,2),
        dcb_user_id             giac_dcb_users.dcb_user_id%TYPE,
        exist_cond              VARCHAR2(1),
        
        op_flag               giac_order_of_payts.op_flag%TYPE,
        or_flag               giac_order_of_payts.or_flag%TYPE,
        print_amt             VARCHAR2(1)
    );
    
    TYPE GIARR001A_daily_coll_rep_tab IS TABLE OF GIARR001A_daily_coll_rep_type;
    
    
    FUNCTION get_GIARR001A_details(
        p_fund_cd               GIAC_COLLN_BATCH.FUND_CD%TYPE,
        p_branch_cd             GIAC_COLLN_BATCH.BRANCH_CD%TYPE,
        p_cashier_cd            GIAC_ORDER_OF_PAYTS.CASHIER_CD%TYPE,
        p_dcb_no                GIAC_COLLN_BATCH.DCB_NO%TYPE,
        p_dcb_year              giac_colln_batch.dcb_year%TYPE,
        p_tran_dt               GIAC_COLLN_BATCH.TRAN_DATE%TYPE,
        p_user_id               giis_users.user_id%TYPE
    )
    RETURN GIARR001A_daily_coll_rep_tab PIPELINED;
    
    TYPE GIARR001A_daily_coll_rep_tab2 IS TABLE OF GIARR001A_daily_coll_rep_type;
    
    FUNCTION get_GIARR001A_details2(
        p_fund_cd               GIAC_COLLN_BATCH.FUND_CD%TYPE,
        p_branch_cd             GIAC_COLLN_BATCH.BRANCH_CD%TYPE,
        p_cashier_cd            GIAC_ORDER_OF_PAYTS.CASHIER_CD%TYPE,
        p_dcb_no                GIAC_COLLN_BATCH.DCB_NO%TYPE,
        p_tran_dt               GIAC_COLLN_BATCH.TRAN_DATE%TYPE
    )
    RETURN GIARR001A_daily_coll_rep_tab2 PIPELINED;
    
    /* Added by dren 03.10.2015
   ** For SR 0004141
   ** Added CSV Report for GIARR01A
   */ 
    TYPE GIARR01A_RECORD IS RECORD (
         or_no              VARCHAR (2000),
         particulars        giac_order_of_payts.particulars%TYPE,
         payor              giac_order_of_payts.payor%TYPE,
         gross_amt          giac_collection_dtl.gross_amt%TYPE,
         commission_amt     giac_collection_dtl.commission_amt%TYPE,
         misc_other_amt     giac_collection_dtl.commission_amt%TYPE,
         vat_amt            giac_collection_dtl.vat_amt%TYPE,
         cred_whtax_amt     giac_collection_dtl.gross_amt%TYPE,
         amount_rcvd        giac_collection_dtl.amount%TYPE,
         pay_mode           giac_collection_dtl.pay_mode%TYPE,
         currency_sname     giis_currency.short_name%TYPE,
         amount             giac_collection_dtl.fcurrency_amt%TYPE,
         check_cr_no        VARCHAR (2000),
         check_date         giac_collection_dtl.check_date%TYPE,
         cs_no              VARCHAR (2000),
         intm_no            giac_order_of_payts.intm_no%TYPE
    );
         
    TYPE GIARR01A_TABLE IS TABLE OF GIARR01A_RECORD;    
    FUNCTION CSV_GIARR01A (
      p_fund_cd            VARCHAR2,
      p_branch_cd          VARCHAR2,
      p_cashier_cd         VARCHAR2,
      p_dcb_no             NUMBER,
      p_tran_dt            DATE,
      p_user_id            VARCHAR2
   )
      RETURN GIARR01A_TABLE PIPELINED;       
    --end dren
    
    TYPE account_type IS RECORD(
        acct_no                 VARCHAR2(100),                 
        pay_mode_desc           VARCHAR2(150),
        branch_bank_deposit     VARCHAR2(50)
    );
    TYPE account_tab IS TABLE OF account_type;
    
    --marco - 03.10.2015 - added for GIARR01_ACCOUNTS subreport
    FUNCTION get_accounts(
        p_fund_cd               GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd             GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_dcb_no                GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_tran_dt               GIAC_COLLN_BATCH.tran_date%TYPE
    )
      RETURN account_tab PIPELINED;          
END;
/


