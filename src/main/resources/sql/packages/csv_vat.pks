CREATE OR REPLACE PACKAGE CPI.CSV_VAT AS 
/* Created by: Ramon 08/13/2010, Generate CSV in GIACS108 - EVAT */
/* Modified by: Ramon 08/19/2010, Added functions for input_vat reports */
/*Modified by: Jongs 05/27/2013, Consolidated Udel's Modifications in ENHSEICI's csv_vat to the latest version of csv_vat
               Added Parameter P_MODULE_ID on wtax reports*/
                 
  --A. FUNCTION CSV_EVAT--
  TYPE evat_rec_type IS RECORD(dir_inw       VARCHAR2(6),
                               line_name     GIIS_LINE.line_name%TYPE,
                               policy_no     VARCHAR2(50),
                               ref_pol_no    GIPI_POLBASIC.ref_pol_no%TYPE,
                               incept_date   GIPI_POLBASIC.incept_date%TYPE,
                               expiry_date   GIPI_POLBASIC.expiry_date%TYPE,
                               acct_ent_date GIPI_POLBASIC.acct_ent_date%TYPE,
                               assd_name     GIIS_ASSURED.assd_name%TYPE,
                               addr          VARCHAR2(500),
                               tin           GIIS_ASSURED.assd_tin%TYPE,
                               bill_no       VARCHAR2(20),
                               premium       GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE,
                               evat          NUMBER(12,2),
                               pyt_date      GIAC_ACCTRANS.tran_date%TYPE,
                               pyt_ref       VARCHAR2(60), --mikel 02.11.2014; changed from 20 to 60
                               pyt_amt       GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE,
                               os_bal        GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE);
  TYPE evat_type IS TABLE OF evat_rec_type;
  --END A--
  
  --B. FUNCTION CSV_INPUT_VAT1--
  --GIACR104--
  TYPE input_vat1_rec_type IS RECORD(branch         VARCHAR2(60),
                                     name           GIAC_ORDER_OF_PAYTS.payor%TYPE,
                                     address        VARCHAR2(500),
                                     tin            GIAC_ORDER_OF_PAYTS.tin%TYPE,
                                     particulars    VARCHAR2(2000),--GIAC_ORDER_OF_PAYTS.particulars%TYPE,-- mildred 07112012 
                                     tran_date      GIAC_ACCTRANS.tran_date%TYPE,
                                     ref_no         VARCHAR2(40),
                                     amt_subjto_vat NUMBER(10,2),
                                     input_vat      NUMBER(16,2));
  TYPE input_vat1_type IS TABLE OF input_vat1_rec_type;
  --END B--
  
  --C. FUNCTION CSV_INPUT_VAT2--
  --GIACR214--
  TYPE input_vat2_rec_type IS RECORD(branch         VARCHAR2(60),
                                     sl_name        GIAC_ORDER_OF_PAYTS.payor%TYPE,
                                     address        VARCHAR2(500),
                                     tin            GIAC_ORDER_OF_PAYTS.tin%TYPE,
                                     particulars    VARCHAR2(2000),--GIAC_ORDER_OF_PAYTS.particulars%TYPE, -- mildred 07112012 
                                     tran_date      GIAC_ACCTRANS.tran_date%TYPE,
                                     ref_no         VARCHAR2(40),
                                     amt_subjto_vat NUMBER(10,2),
                                     input_vat      NUMBER(16,2));
  TYPE input_vat2_type IS TABLE OF input_vat2_rec_type;
  --END C--
  
  --D. FUNCTION CSV_INPUT_VAT3--
  --GIACR214B--
  TYPE input_vat3_rec_type IS RECORD(branch         VARCHAR2(60),
                                     sl_name        GIAC_ORDER_OF_PAYTS.payor%TYPE,
                                     tin            GIAC_ORDER_OF_PAYTS.tin%TYPE,
                                     address        VARCHAR2(500),
                                     amt_subjto_vat NUMBER(16,2),
                                     input_vat      NUMBER(16,2));
  TYPE input_vat3_type IS TABLE OF input_vat3_rec_type;
  --END D--
  
  -- START added by Jayson 11.28.2011 --
  TYPE wtax_giacr107_rec_type IS RECORD(payee_class   GIIS_PAYEE_CLASS.class_desc%TYPE,
                                        payee_no      GIAC_TAXES_WHELD.payee_cd%TYPE,
                                        name          VARCHAR2(500),
                                        income_amount GIAC_TAXES_WHELD.income_amt%TYPE, 
                                        tax_withheld  GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr107_table IS TABLE OF wtax_giacr107_rec_type;
  
  TYPE wtax_giacr110_rec_type IS RECORD(payee_class  GIIS_PAYEE_CLASS.class_desc%TYPE,
                                        payee_no     GIAC_TAXES_WHELD.payee_cd%TYPE,
                                        name         VARCHAR2(500),
                                        tax_cd       GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
                                        tax_name     GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
                                        TIN          GIIS_PAYEES.tin%TYPE,
                                        income_amt   GIAC_TAXES_WHELD.income_amt%TYPE, 
                                        tax_rate     GIAC_WHOLDING_TAXES.percent_rate%TYPE, 
                                        tax_wheld    GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr110_table IS TABLE OF wtax_giacr110_rec_type;
  
  TYPE wtax_giacr111_rec_type IS RECORD(seq_no     NUMBER,
                                        TIN        GIIS_PAYEES.tin%TYPE,
                                        name       VARCHAR2(500),
                                        atc_code   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
                                        income_amt GIAC_TAXES_WHELD.income_amt%TYPE,
                                        tax_rate   GIAC_WHOLDING_TAXES.percent_rate%TYPE,
                                        tax_wheld  GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr111_table IS TABLE OF wtax_giacr111_rec_type;
  
  TYPE wtax_giacr253_rec_type IS RECORD(withholding_tax_cd GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
                                        withholding_tax    GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
                                        payee_class        GIIS_PAYEE_CLASS.class_desc%TYPE,
                                        payee              VARCHAR2(500),
                                        TIN                GIIS_PAYEES.tin%TYPE,
                                        income_amount      GIAC_TAXES_WHELD.income_amt%TYPE, 
                                        tax_withheld       GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr253_table IS TABLE OF wtax_giacr253_rec_type;
  
  TYPE wtax_giacr254_rec_type IS RECORD(bir_tax_cd   GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
                                        bir_tax_name GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
                                        payee_class  GIIS_PAYEE_CLASS.class_desc%TYPE,
                                        payee        VARCHAR2(500),
                                        address      VARCHAR2(500),
                                        TIN          GIIS_PAYEES.tin%TYPE,
                                        tran_date    GIAC_ACCTRANS.tran_date%TYPE,
                                        posting_date GIAC_ACCTRANS.posting_date%TYPE,
                                        tran_class   GIAC_ACCTRANS.tran_class%TYPE,
                                        ref_no       VARCHAR2(50),
                                        income_amt   GIAC_TAXES_WHELD.income_amt%TYPE, 
                                        tax_wheld    GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr254_table IS TABLE OF wtax_giacr254_rec_type;
  
  TYPE wtax_giacr255_rec_type IS RECORD(payee_class  GIIS_PAYEE_CLASS.class_desc%TYPE,
                                        payee        VARCHAR2(500),
                                        tran_date    GIAC_ACCTRANS.tran_date%TYPE,
                                        posting_date GIAC_ACCTRANS.posting_date%TYPE,
                                        ref_no       VARCHAR2(50),
                                        income_amt   GIAC_TAXES_WHELD.income_amt%TYPE, 
                                        tax_wheld    GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr255_table IS TABLE OF wtax_giacr255_rec_type;
  
  TYPE wtax_giacr256_rec_type IS RECORD(payee_class  GIIS_PAYEE_CLASS.class_desc%TYPE,
                                        payee        VARCHAR2(500),
                                        address      VARCHAR2(500),
                                        TIN          GIIS_PAYEES.tin%TYPE,
                                        tax_cd       GIAC_WHOLDING_TAXES.bir_tax_cd%TYPE,
                                        tax_name     GIAC_WHOLDING_TAXES.whtax_desc%TYPE,
                                        tax_rate     GIAC_WHOLDING_TAXES.percent_rate%TYPE,
                                        tran_date    GIAC_ACCTRANS.tran_date%TYPE,
                                        posting_date GIAC_ACCTRANS.posting_date%TYPE,
                                        ref_no       VARCHAR2(50),
                                        income_amt   GIAC_TAXES_WHELD.income_amt%TYPE, 
                                        tax_wheld    GIAC_TAXES_WHELD.wholding_tax_amt%TYPE);
                                        
  TYPE wtax_giacr256_table IS TABLE OF wtax_giacr256_rec_type;
  -- END added by Jayson 11.28.2011 --
  
  FUNCTION CSV_EVAT(p_line_cd    VARCHAR2,
                    p_branch_cd  VARCHAR2,
                    p_post_tran  VARCHAR2,
                    p_tran_date1 DATE,
                    p_tran_date2 DATE) RETURN evat_type PIPELINED;

  FUNCTION CSV_INPUT_VAT1(p_branch_cd VARCHAR2,
                          p_include   VARCHAR2,
                          p_from_date VARCHAR2,
                          p_to_date   VARCHAR2,
                          p_tran_post VARCHAR2) RETURN input_vat1_type PIPELINED;

  FUNCTION CSV_INPUT_VAT2(p_branch_cd VARCHAR2,
                          p_include   VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
                          p_from_date VARCHAR2,
                          p_to_date   VARCHAR2,
                          p_tran_post VARCHAR2) RETURN input_vat2_type PIPELINED;

  FUNCTION CSV_INPUT_VAT3(p_branch_cd VARCHAR2,
                          p_include   VARCHAR2, --vondanix 12.16.15 RSIC GENQA 5223
                          p_from_date VARCHAR2,
                          p_to_date   VARCHAR2,
                          p_tran_post VARCHAR2) RETURN input_vat3_type PIPELINED;
                          
  -- START added by Jayson 11.28.2011 --
  --modified by jongs 05.27.2013
  FUNCTION csv_wtax_giacr107(p_post_tran   VARCHAR2,
                             p_date1       DATE,
                             p_date2       DATE,
                             p_payee       VARCHAR2,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2) RETURN wtax_giacr107_table PIPELINED;
  
  FUNCTION csv_wtax_giacr110(p_post_tran   VARCHAR2,
                             p_date1       DATE,
                             p_date2       DATE,
                             p_payee       VARCHAR2,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2,
                             p_tax_cd      VARCHAR2) -- Added by Jerome 10.20.2016 SR 5671
                             RETURN wtax_giacr110_table PIPELINED;
  
  FUNCTION csv_wtax_giacr111(p_post_tran   VARCHAR2,
                             p_date        DATE,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2) RETURN wtax_giacr111_table PIPELINED;
                             
  FUNCTION csv_wtax_giacr253(p_post_tran   VARCHAR2,
                             p_date1       DATE,
                             p_date2       DATE,
                             p_payee       VARCHAR2,
                             p_tax_id      VARCHAR2,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2) RETURN wtax_giacr253_table PIPELINED;
  
  FUNCTION csv_wtax_giacr254(p_post_tran   VARCHAR2,
                             p_date1       DATE,
                             p_date2       DATE,
                             p_payee       VARCHAR2,
                             p_tax_id      VARCHAR2,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2) RETURN wtax_giacr254_table PIPELINED;
  
  FUNCTION csv_wtax_giacr255(p_post_tran   VARCHAR2,
                             p_date1       DATE,
                             p_date2       DATE,
                             p_payee       VARCHAR2,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2) RETURN wtax_giacr255_table PIPELINED;                           
  
  FUNCTION csv_wtax_giacr256(p_post_tran   VARCHAR2,
                             p_date1       DATE,
                             p_date2       DATE,
                             p_payee       VARCHAR2,
                             p_exclude_tag VARCHAR2,
                             p_module_id   VARCHAR2,
                             p_tax_cd      VARCHAR2) --Added by Jerome 10.20.2016 SR 5671
                             RETURN wtax_giacr256_table PIPELINED;
  --end jongs 05.27.2013                             
  -- END added by Jayson 11.28.2011 --
                             
END;
/


