CREATE OR REPLACE PACKAGE CPI.Csv_Giacs060 AS
 --A. FUNCTION CSV_GIACR060--
  TYPE giacr060_rec_type IS RECORD(gl_account      VARCHAR2(50),
                   gl_account_name  GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                   month_grp    VARCHAR2(100),
                   tran_class    GIAC_ACCTRANS.tran_class%TYPE,
                   debit_amt       GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                   credit_amt      GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                   balance     GIAC_ACCT_ENTRIES.credit_amt%TYPE); -- NUMBER(30) adpascual 08/18/2012
  TYPE giacr060_type IS TABLE OF giacr060_rec_type;
 --END A--
 --B. FUNCTION CSV_GIACR061--
  TYPE giacr061_rec_type IS RECORD(gl_account      VARCHAR2(50),
                   gl_account_name  GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                   month_grp    VARCHAR2(100),
                   tran_class    GIAC_ACCTRANS.tran_class%TYPE,
                   sl_cd      GIAC_SL_LISTS.SL_CD%type, -- VARCHAR2(20), adpascual 08/30/2012
                   sl_name     GIAC_SL_LISTS.SL_NAME%type , -- VARCHAR2(160), adpascual 08/30/2012
                   debit_amt       GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                   credit_amt      GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                   balance     GIAC_ACCT_ENTRIES.credit_amt%TYPE);-- NUMBER(30) adpascual 08/18/2012
  TYPE giacr061_type IS TABLE OF giacr061_rec_type;
 --END B--
   -- START added by Mildred 11.07.2012 consolidate BIR Enh--
  TYPE giacr062_rec_type IS RECORD(gl_account       VARCHAR2(50),
                                   gl_account_name  GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                                   tran_date        VARCHAR2(20),
                                   tran_class       GIAC_ACCTRANS.tran_class%TYPE,
                                   ref_no           VARCHAR2(32767), --VARCHAR2(50), --edited by gab 09.28.2015
                                   tran_id          GIAC_ACCTRANS.tran_id%TYPE,
                                   particulars      VARCHAR2(5000),
                                   debit_amt        GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                                   credit_amt       GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                                   balance          GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                                   jv_ref_no    VARCHAR2(100) -- added gab 09.14.2015
                                   );
                                   
  TYPE giacr062_table_type IS TABLE OF giacr062_rec_type;
  -- END added by Mildred 11.07.2012 consolidate BIR Enh--
 
 
 --C. FUNCTION CSV_GIACR201--
  TYPE giacr201_rec_type IS RECORD(gl_account      VARCHAR2(50),
                   gl_account_name  GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                   month_grp    VARCHAR2(100),
                   tran_class    GIAC_ACCTRANS.tran_class%TYPE,
                   tran_date    VARCHAR2(50),
                   date_posted   VARCHAR2(50),
                   pname      VARCHAR2(1000),
                   tran_flag    GIAC_ACCTRANS.tran_flag%TYPE,
                   particulars   VARCHAR2(5000),
                   tran_id          GIAC_ACCTRANS.tran_id%TYPE, --added by Mildred 11.07.2012 consolidate BIR Enh--
                   ref_no       VARCHAR2(32767), --VARCHAR2(50), --edited by gab 09.28.2015
                   debit_amt       NUMBER(16,2), --GIAC_ACCT_ENTRIES.debit_amt%TYPE,  --modified by albert 11.11.2016 (UCPBGEN SR 23293)
                   credit_amt      NUMBER(16,2), --GIAC_ACCT_ENTRIES.credit_amt%TYPE, --modified by albert 11.11.2016 (UCPBGEN SR 23293)
                   balance     GIAC_ACCT_ENTRIES.credit_amt%TYPE, -- NUMBER(30) adpascual 08/18/2012
                   jv_ref_no    VARCHAR2(100) -- added gab 09.14.2015
                   );
  TYPE giacr201_type IS TABLE OF giacr201_rec_type;
 --END C--
 --D. FUNCTION CSV_GIACR202--
  TYPE giacr202_rec_type IS RECORD(gl_account      VARCHAR2(50),
                   gl_account_name  GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
                   month_grp    VARCHAR2(100),
                   tran_class    GIAC_ACCTRANS.tran_class%TYPE,
                   sl_cd      GIAC_SL_LISTS.SL_CD%type, -- VARCHAR2(20), adpascual 08/30/2012
                   sl_name     GIAC_SL_LISTS.SL_NAME%type , -- VARCHAR2(160), adpascual 08/30/2012
                   tran_date    VARCHAR2(50),
                   date_posted   VARCHAR2(50),
                   pname      VARCHAR2(1000),
                   tran_flag    GIAC_ACCTRANS.tran_flag%TYPE,
                   particulars   VARCHAR2(5000),
                   ref_no      VARCHAR2(32767), --VARCHAR2(50), --edited by gab 09.28.2015
                   debit_amt       GIAC_ACCT_ENTRIES.debit_amt%TYPE,
                   credit_amt      GIAC_ACCT_ENTRIES.credit_amt%TYPE,
                   balance     GIAC_ACCT_ENTRIES.credit_amt%TYPE, -- NUMBER(30) adpascual 08/18/2012
                   jv_ref_no    VARCHAR2(100) -- added gab 09.14.2015
                   );  
  TYPE giacr202_type IS TABLE OF giacr202_rec_type;
 --END D--
  FUNCTION CSV_GIACR060(p_dt_basis     NUMBER,
            p_consolidate    VARCHAR2,
            p_branch_cd     VARCHAR2,
            p_fund_cd      VARCHAR2,
            p_gl_acct_category NUMBER,
            p_gl_control_acct   NUMBER,
            p_gl_acct_1     NUMBER,
            p_gl_acct_2     NUMBER,
            p_gl_acct_3     NUMBER,
            p_gl_acct_4     NUMBER,
            p_gl_acct_5     NUMBER,
            p_gl_acct_6     NUMBER,
            p_gl_acct_7     NUMBER,
            p_tran_class    VARCHAR2,
            p_eotran      VARCHAR2,
            p_fromdate     DATE,
            p_todate      DATE,
            p_user_id     VARCHAR2,
            p_module_id   VARCHAR2 ) RETURN giacr060_type PIPELINED;  -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
  FUNCTION CSV_GIACR061(p_dt_basis     NUMBER,
            p_consolidate    VARCHAR2,
            p_branch_cd     VARCHAR2,
            p_fund_cd      VARCHAR2,
            p_gl_acct_category NUMBER,
            p_gl_control_acct   NUMBER,
            p_gl_acct_1     NUMBER,
            p_gl_acct_2     NUMBER,
            p_gl_acct_3     NUMBER,
            p_gl_acct_4     NUMBER,
            p_gl_acct_5     NUMBER,
            p_gl_acct_6     NUMBER,
            p_gl_acct_7     NUMBER,
            p_tran_class    VARCHAR2,
            p_sl_cd       NUMBER,
            p_sl_type_cd    VARCHAR2,
            p_eotran      VARCHAR2,
            p_fromdate     DATE,
            p_todate      DATE,
            p_user_id     VARCHAR2,
            p_module_id   VARCHAR2 ) RETURN giacr061_type PIPELINED;  -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
  -- START added by Mildred 11.07.2012 consolidate BIR enh            
  FUNCTION CSV_GIACR062(p_branch        VARCHAR2,
                        p_company       VARCHAR2,
                        p_category      VARCHAR2,
                        p_control       VARCHAR2,
                        p_sub_1         VARCHAR2,
                        p_sub_2         VARCHAR2,
                        p_sub_3         VARCHAR2,
                        p_sub_4         VARCHAR2,
                        p_sub_5         VARCHAR2,
                        p_sub_6         VARCHAR2,
                        p_sub_7         VARCHAR2,
                        p_tran_class    VARCHAR2,
                        p_tran_flag     VARCHAR2,
                        p_dt_basis      NUMBER,
                        p_date1         DATE,
                        p_date2         DATE,
                        p_user_id       VARCHAR2,
                        p_module_id     VARCHAR2 ) RETURN giacr062_table_type PIPELINED; -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
  -- END added by Mildred 11.07.2012 consolidate BIR enh
  FUNCTION CSV_GIACR201(p_dt_basis     NUMBER,
            p_consolidate    VARCHAR2,
            p_branch_cd     VARCHAR2,
            p_fund_cd      VARCHAR2,
            p_gl_acct_category NUMBER,
            p_gl_control_acct   NUMBER,
            p_gl_acct_1     NUMBER,
            p_gl_acct_2     NUMBER,
            p_gl_acct_3     NUMBER,
            p_gl_acct_4     NUMBER,
            p_gl_acct_5     NUMBER,
            p_gl_acct_6     NUMBER,
            p_gl_acct_7     NUMBER,
            p_tran_class    VARCHAR2,
            p_eotran      VARCHAR2,
            p_fromdate     DATE,
            p_todate      DATE,
            p_begbal      VARCHAR2, --added by jhing 01.28.2016 from temp solution done by vondanix RSIC 20691 12.09.2015
            p_user_id     VARCHAR2, -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
            p_module_id    VARCHAR2 
            ) RETURN giacr201_type PIPELINED;
  FUNCTION CSV_GIACR202(p_dt_basis     NUMBER,
            p_consolidate    VARCHAR2,
            p_branch_cd     VARCHAR2,
            p_fund_cd      VARCHAR2,
            p_gl_acct_category NUMBER,
            p_gl_control_acct   NUMBER,
            p_gl_acct_1     NUMBER,
            p_gl_acct_2     NUMBER,
            p_gl_acct_3     NUMBER,
            p_gl_acct_4     NUMBER,
            p_gl_acct_5     NUMBER,
            p_gl_acct_6     NUMBER,
            p_gl_acct_7     NUMBER,
            p_tran_class    VARCHAR2,
            p_sl_cd       NUMBER,
            p_sl_type_cd    VARCHAR2,
            p_eotran      VARCHAR2,
            p_fromdate     DATE,
            p_todate      DATE,
            p_user_id     VARCHAR2,
            p_module_id   VARCHAR2) RETURN giacr202_type PIPELINED;  -- jhing 01.28.2016 added p_user_id, p_module_id GENQA 5280,5200
END;
/

