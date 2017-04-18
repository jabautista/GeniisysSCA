CREATE OR REPLACE PACKAGE CPI.POPULATE_TEXT_FOR_BOND_DOC AS
/******************************************************************************
   NAME:       POPULATE_TEXT_FOR_BOND_DOC
   PURPOSE:    For populating bond documents

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/9/2011            Grace    Created this package.
******************************************************************************/
  TYPE g16bond_type IS RECORD (
     prem_amt                   GIPI_POLBASIC.prem_amt%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     policy_no                  VARCHAR2(50),    
     expiry_date                VARCHAR2(50),
     subline_cd                 GIPI_POLBASIC.subline_cd%TYPE,
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE, 
     tsi_word                   VARCHAR2(200), 
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     designation                GIIS_PRIN_SIGNTRY.designation%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE,
     incept_date                VARCHAR2(50), --* Added by Windell ON May 12, 2011
     subline_name               VARCHAR2(50)  --* Added by Windell ON May 12, 2011
     ,clause_type               giis_bond_class_clause.clause_type%TYPE
   );
    
  TYPE g16bond_tab IS TABLE OF g16bond_type;
  

  FUNCTION Populate_text_for_G16bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g16bond_tab PIPELINED;
  
  
  TYPE taxes_type IS RECORD (
     policy_id                   GIPI_INVOICE.policy_id%TYPE,
     prem_amt                    GIPI_INVOICE.prem_amt%TYPE,
     ds_tax                      GIPI_INV_TAX.tax_amt%TYPE,
     lgt_tax                     GIPI_INV_TAX.tax_amt%TYPE,
     not_fee                     GIPI_INV_TAX.tax_amt%TYPE,
     evat_tax                    GIIS_TAX_CHARGES.tax_desc%TYPE,
     oth_tax                     GIPI_INV_TAX.tax_amt%TYPE,
     total_tax                   NUMBER(16,2)
   );
   
    TYPE taxes_tab IS TABLE OF taxes_type;   
  
  FUNCTION Populate_text_for_Taxes (p_policy_id    GIPI_INVOICE.policy_id%TYPE) 
    RETURN taxes_tab PIPELINED;
    
    
  -- start
  -- added taxes_tab2 and taxes_type2 for another function for taxes
  -- function would only return taxes declared in the policy 
   
    TYPE taxes_type2 IS RECORD (
     policy_id                   GIPI_INVOICE.policy_id%TYPE,
     tax_desc                    GIIS_TAX_CHARGES.TAX_DESC%TYPE,
     tax_amt                     GIPI_INVOICE.TAX_AMT%TYPE
   );
    
  TYPE taxes_tab2 IS TABLE OF taxes_type2;    
    
  FUNCTION Populate_text_for_Taxes2 (p_policy_id    GIPI_INVOICE.policy_id%TYPE) 
    RETURN taxes_tab2 PIPELINED;
  -- abie 06092011
  -- end    
    
    
  TYPE g13bond_type IS RECORD (
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     policy_no                  VARCHAR2(50),
     incept_date                VARCHAR2(50), --* Added by Windell ON May 12, 2011    
     expiry_date                VARCHAR2(50), --* Revised by Windell ON May 12, 2011; Changed from GIPI_POLBASIC.expiry_date%TYPE,
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE,  
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     tsi_word_dh                VARCHAR(500), -- Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
     tsi_chr                    VARCHAR(200),  -- Added by Windell ON April 06, 2011; Converts currency to a formatted character/string      
     prin_designation           GIIS_PRIN_SIGNTRY.designation%TYPE, --* WSV; 05/12/11; Renamed to prin_designation
     contract_date              GIPI_BOND_BASIC.contract_date%TYPE,
     contract_day               VARCHAR2(50), 
     contract_mon_year             VARCHAR2(50),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,
     issue_day                  VARCHAR2(50), 
     issue_mon_year             VARCHAR2(50),
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     prem_amt                   GIPI_POLBASIC.prem_amt%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     np_no                        GIIS_NOTARY_PUBLIC.np_no%TYPE,
     np_name                    GIIS_NOTARY_PUBLIC.np_name%TYPE,
     np_expiry_date                GIIS_NOTARY_PUBLIC.expiry_date%TYPE,
     ptr_no                        GIIS_NOTARY_PUBLIC.ptr_no%TYPE,
     place_issue                GIIS_NOTARY_PUBLIC.place_issue%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     s_issue_date                GIIS_PRIN_SIGNTRY.issue_date%TYPE,
     endt_seq_no                GIPI_POLBASIC.endt_seq_no%TYPE,
     clause_desc                GIIS_BOND_CLASS_CLAUSE.clause_desc%TYPE,
     iss_cd                     VARCHAR2(2),
     s_address                  GIIS_PRIN_SIGNTRY.address%TYPE,
     cents                      VARCHAR2(10),
     hundreds                   VARCHAR2(6),
     thousands                  VARCHAR2(6),
     millions                   VARCHAR2(6),
     tsiamt_word                VARCHAR2(1000),
     pol_iss_dt                 GIPI_POLBASIC.issue_date%TYPE, 
     subline_cd                 GIPI_POLBASIC.subline_cd%TYPE, --* Added by Windell ON May 12, 2011  
     subline_name               VARCHAR2(50)                   --* Added by Windell ON May 12, 2011  
     
   );
    
  TYPE g13bond_tab IS TABLE OF g13bond_type;
    
  FUNCTION Populate_text_for_G13bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g13bond_tab PIPELINED;
  
  TYPE signatory_type IS RECORD (
    signatory                  GIIS_SIGNATORY_NAMES.signatory%TYPE,
    designation                   GIIS_SIGNATORY_NAMES.designation%TYPE,
    res_cert_no                     GIIS_SIGNATORY_NAMES.res_cert_no%TYPE,
    res_cert_place               GIIS_SIGNATORY_NAMES.res_cert_place%TYPE,
    res_cert_date               VARCHAR2(200)
    ,comp_name                   GIIS_PARAMETERS.PARAM_VALUE_V%type,
    comp_sname                  GIIS_PARAMETERS.PARAM_VALUE_V%type,
    comp_address                   GIIS_PARAMETERS.PARAM_VALUE_V%type,
    comp_tin                    GIIS_PARAMETERS.PARAM_VALUE_V%type,
    sign_remarks                giis_signatory.remarks%TYPE
  
  );  
   TYPE signatory_tab IS TABLE OF signatory_type;
   
  FUNCTION Populate_text_for_Signatory (p_iss_cd    GIIS_SIGNATORY.iss_cd%TYPE )    
    RETURN signatory_tab PIPELINED; 
  
  FUNCTION get_spelled_number (p_number    VARCHAR2)
    RETURN VARCHAR2;
  
  TYPE g02bond_type IS RECORD (
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     policy_no                  VARCHAR2(50),    
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE,  
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     p_designation              GIIS_PRIN_SIGNTRY.designation%TYPE,
     contract_date              VARCHAR2(50),
     contract_time              VARCHAR2(25), 
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     issue_day                  VARCHAR2(50),
     issue_year                 VARCHAR2(50), --Added by Windell ON April 04, 2011 FOR UCPB G2 Bond   
     issue_month_year           VARCHAR2(50),
     issue_date                 VARCHAR2(50),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE, 
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     prem_amt                   GIPI_POLBASIC.prem_amt%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     np_name                    GIIS_NOTARY_PUBLIC.np_name%TYPE,
     ptr_no                        GIIS_NOTARY_PUBLIC.ptr_no%TYPE,
     np_expiry_date                VARCHAR2(50),  --* Revised by Windell ON May 12, 2011; Changed from GIIS_NOTARY_PUBLIC.expiry_date%TYPE, Renamed to np_expiry_date
     expiry_date                VARCHAR2(50), --* Added by Windell ON May 12, 2011
     incept_date                VARCHAR2(50), --* Added by Windell ON May 12, 2011
     place_issue                GIIS_NOTARY_PUBLIC.place_issue%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     s_issue_date               VARCHAR2(50),
     np_issue_date              VARCHAR2(50),
     iss_cd                     VARCHAR2(2),
     tsiamt_word                VARCHAR2(1000),
     clause_desc                GIIS_BOND_CLASS_CLAUSE.CLAUSE_DESC%TYPE, --Added by Windell ON April 01, 2011 FOR UCPB G2 Bond 
     remarks                    GIIS_NOTARY_PUBLIC.remarks%TYPE,         --Added by Windell ON April 04, 2011 FOR UCPB G2 Bond
     tsi_word_dh                VARCHAR(500), -- Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
     tsi_chr                    VARCHAR(200), -- Added by Windell ON April 06, 2011; Converts currency to a formatted character/string 
     subline_cd                 VARCHAR2(5), --* Added by Windell ON May 12, 2011  
     subline_name               VARCHAR2(50), --* Added by Windell ON May 12, 2011  
     period                        VARCHAR2(100)
   );
    
  TYPE g02bond_tab IS TABLE OF g02bond_type;
  
  FUNCTION Populate_text_for_G02bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g02bond_tab PIPELINED;


  TYPE g07bond_type IS RECORD (
    assd_name           GIIS_ASSURED.assd_name%TYPE,
    policy_no           VARCHAR2(35),
    policy_id           GIPI_POLBASIC.policy_id%TYPE,
    address             VARCHAR2(150),
    eff_day             VARCHAR2(10),
    eff_month_year      VARCHAR2(20),
    expiry_day          VARCHAR2(10),
    expiry_month_year   VARCHAR2(50),
    tsi_amt             NUMBER(16,2),
    prin_signor         VARCHAR2(50),
    p_designation       GIIS_SIGNATORY_NAMES.designation%TYPE,              
    issue_date          VARCHAR2(30),
    issue_day           VARCHAR2(10),
    issue_month_year    VARCHAR2(20),
    v_ref_pol_no        GIPI_POLBASIC.ref_pol_no%TYPE,
    iss_cd              VARCHAR2(2),
    tsiamt_word         VARCHAR2(1000)
     
   );
    
  TYPE g07bond_tab IS TABLE OF g07bond_type;
  
  FUNCTION Populate_text_for_G07bond (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN g07bond_tab PIPELINED;
  
  TYPE c07bond_type IS RECORD (
    assd_name           giis_assured.assd_name%TYPE,
    policy_no           VARCHAR2(35),
    expiry_date         VARCHAR2(20),
    tsi_amt             NUMBER(16,2),
    prin_signor         VARCHAR2(50),
    prin_desig          giis_signatory_names.designation%TYPE,
    issue_day           VARCHAR2(10),
    issue_month_year    VARCHAR2(20),
    assd_name_add       VARCHAR(210),
    obligee_name        giis_obligee.obligee_name%TYPE,
    tsiamt_word         VARCHAR(150),
    eff_year            VARCHAR(4),
    issue_date          VARCHAR2(25),
    iss_cd              VARCHAR2(2)
  );
  
  TYPE c07bond_tab IS TABLE OF c07bond_type;
  
  FUNCTION Populate_text_for_C07bond (p_policy_id   GIPI_POLBASIC.policy_id%TYPE)
    RETURN c07bond_tab PIPELINED;
    
  
  TYPE comm_computed_prem_type IS RECORD (
     partial_prem                giac_direct_prem_collns.premium_amt%TYPE,
     prem_amt                    NUMBER(16,2),
     partial_comm                giac_comm_slip_ext.comm_amt%TYPE,
     total_comm                  NUMBER(16,2)
   );
    
  TYPE comm_computed_prem_tab IS TABLE OF comm_computed_prem_type;
  
  
    FUNCTION get_comm_computed_prem (p_iss_cd    GIIS_SIGNATORY.iss_cd%TYPE,
                                     p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE
                                    )   
        RETURN comm_computed_prem_tab PIPELINED;

    TYPE g18bond_type IS RECORD (
    assd_name           GIIS_ASSURED.assd_name%TYPE,
    policy_no           VARCHAR2(35),
    policy_id           GIPI_POLBASIC.policy_id%TYPE,
    address             VARCHAR2(150),
    eff_day             VARCHAR2(10),
    eff_month_year      VARCHAR2(20),
    expiry_day          VARCHAR2(10),
    expiry_month_year   VARCHAR2(50),
    tsi_amt             NUMBER(16,2),
    tsi_amt_char        VARCHAR2(50),
    prin_signor         VARCHAR2(50),
    p_designation       GIIS_SIGNATORY_NAMES.designation%TYPE,              
    issue_date          VARCHAR2(30),
    issue_day           VARCHAR2(10),
    issue_month_year    VARCHAR2(20),
    v_ref_pol_no        GIPI_POLBASIC.ref_pol_no%TYPE,
    iss_cd              VARCHAR2(2),
    obligee_name        GIIS_OBLIGEE.obligee_name%TYPE,
    bond_dtl            GIPI_BOND_BASIC.bond_dtl%TYPE,
    expiry_date         VARCHAR2(50),
    incept_date         VARCHAR2(50), --* Added by Windell ON May 12, 2011
    tsiamt_word         VARCHAR2(1000),
    subline_cd          VARCHAR2(5),  --* Added by Windell ON May 12, 2011
    subline_name        VARCHAR2(50)  --* Added by Windell ON May 12, 2011
    ,clause_desc         giis_bond_class_clause.clause_desc%TYPE         
   );
    
  TYPE g18bond_tab IS TABLE OF g18bond_type;
  
  FUNCTION Populate_text_for_G18bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g18bond_tab PIPELINED;
    
/*****************ADDED*BY*WINDELL***********04*05*2011**************C12***********/    
/*   Added by    : Windell Valle
**   Date Created: April 05, 2011
**   last Revised: April 06, 2011
**   Description : Populate C12 Bond Documents
**   Client(s)   : UCPB,...
*/
TYPE c12bond_type IS RECORD (
     policy_no                  VARCHAR2(50), 
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE,
     tsi_word_dh                VARCHAR2(500), -- Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
     tsi_word                   VARCHAR2(200), 
     tsi_chr                    VARCHAR2(100), -- Added by Windell ON April 06, 2011; Converts currency to a formatted character/string
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     prin_designation           GIIS_PRIN_SIGNTRY.designation%TYPE, --* WSV; 05/11/11
     incept_date                VARCHAR2(50),
     expiry_date                VARCHAR2(50),
     subline_cd                 GIPI_POLBASIC.subline_cd%TYPE,
     subline_name               VARCHAR2(50),
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE,
     clause_type                GIPI_BOND_BASIC.clause_type%TYPE
   );
    
  TYPE c12bond_tab IS TABLE OF c12bond_type;
  

  FUNCTION Populate_text_for_c12bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN c12bond_tab PIPELINED;    
/*****************ADDED*BY*WINDELL***********04*05*2011**************C12***********/

 
  TYPE jcl5bond_type IS RECORD (
     prem_amt                   GIPI_POLBASIC.prem_amt%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     policy_no                  VARCHAR2(50),
     incept_date                VARCHAR2(50), --* Added by Windell ON May 12, 2011      
     expiry_date                VARCHAR2(50),
     subline_cd                 GIPI_POLBASIC.subline_cd%TYPE,
     subline_name               VARCHAR2(50), --* Added by Windell ON May 12, 2011
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE, 
     tsi_word                   VARCHAR2(200), 
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     designation                GIIS_PRIN_SIGNTRY.designation%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE
     , clause_type              GIPI_BOND_BASIC.clause_type%TYPE
   );
    
  TYPE jcl5bond_tab IS TABLE OF jcl5bond_type;
  

  FUNCTION Populate_text_for_jcl5bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN jcl5bond_tab PIPELINED;

  TYPE g05bond_type IS RECORD (
     prem_amt                   GIPI_POLBASIC.prem_amt%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     policy_no                  VARCHAR2(50),    
     expiry_date                VARCHAR2(50),
     subline_cd                 GIPI_POLBASIC.subline_cd%TYPE,
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE, 
     tsi_word                   VARCHAR2(200), 
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     designation                GIIS_PRIN_SIGNTRY.designation%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE,
     eff_date                   VARCHAR2(50),
     subline_name               GIIS_SUBLINE.subline_name%TYPE,
     incept_date                   VARCHAR2(50)
   );
    
  TYPE g05bond_tab IS TABLE OF g05bond_type;
  

  FUNCTION Populate_text_for_G05bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g05bond_tab PIPELINED;
        -----added_by_gino-----

TYPE ucpb_g17bond_type IS RECORD (---------------------------------------gino 5.6.11
  ASSD_NAME            VARCHAR2(500 BYTE)       ,
  ADDRESS              VARCHAR2(150 BYTE),
  POLICY_NO            VARCHAR2(4000 BYTE),
  SUBLINE_CD           VARCHAR2(7 BYTE)         ,
  SUBLINE_NAME         VARCHAR2(30 BYTE)        ,
  INCEPT_DATE          VARCHAR2(18 BYTE),
  EXPIRY_DATE          VARCHAR2(18 BYTE),
  TSI_AMT              NUMBER(16,2),
  TSI_CHR              VARCHAR2(19 BYTE),
  TSI_WORD_DH          VARCHAR2(4000 BYTE),
  PRIN_SIGNOR          VARCHAR2(50 BYTE)        ,
  DESIGNATION          VARCHAR2(30 BYTE)        ,
  TSI_WORD             VARCHAR2(4000 BYTE),
  CONTRACT_DAY         VARCHAR2(6 BYTE),
  CONTRACT_MONTH_YEAR  VARCHAR2(20 BYTE),
  CONTRACT_DTL         VARCHAR2(75 BYTE),
  BOND_DTL             VARCHAR2(2000 BYTE),
  ISSUE_DATE           DATE,
  ISSUE_DAY            VARCHAR2(6 BYTE),
  ISSUE_MONTH          VARCHAR2(21 BYTE),
  ISSUE_MONTH_YEAR     VARCHAR2(21 BYTE),
  OBLIGEE_NAME         giis_obligee.obligee_name%TYPE,--VARCHAR2(50 BYTE)        , modified by Gzelle 01212015
  O_ADDRESS            VARCHAR2(150 BYTE),
  ISSUE_PLACE          VARCHAR2(15 BYTE),
  POLICY_ID            NUMBER(12)               ,
  REF_POL_NO           VARCHAR2(30 BYTE),
  RES_CERT             VARCHAR2(15 BYTE),
  ISS_CD               VARCHAR2(2 BYTE)         ,
  INDEMNITY_TEXT       VARCHAR2(2000 BYTE),
  val_period           VARCHAR2(50 BYTE)
   );    
  TYPE ucpb_g17bond_tab IS TABLE OF ucpb_g17bond_type;
  

  FUNCTION Populate_text_for_ucpb_g17bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN ucpb_g17bond_tab PIPELINED;------------------------------------------end gino    5.6.11

/*****************ADDED*BY*WINDELL***********05*05*2011**************JCL15***********/    
/*   Added by    : Windell Valle
**   Date Created: May 05, 2011
**   Last Revised: May 05, 2011
**   Description : Populate JCL15 Bond Documents
**   Client(s)   : UCPB,...
*/
TYPE JCL15bond_type IS RECORD (
     policy_no                  VARCHAR2(50), 
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE,
     tsi_word_dh                VARCHAR2(500), 
     tsi_word                   VARCHAR2(200), 
     tsi_chr                    VARCHAR2(100), 
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     prin_designation           GIIS_PRIN_SIGNTRY.designation%TYPE,
     incept_date                VARCHAR2(50),
     expiry_date                VARCHAR2(50),
     subline_cd                 GIIS_SUBLINE.subline_cd%TYPE,
     subline_name               GIIS_SUBLINE.subline_name%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE,
     indemnity_text             GIXX_BOND_BASIC.indemnity_text%TYPE
   );    
  TYPE JCL15bond_tab IS TABLE OF JCL15bond_type;
  

  FUNCTION Populate_text_for_JCL15bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN JCL15bond_tab PIPELINED;    
/*****************ADDED*BY*WINDELL***********05*05*2011**************JCL15***********/


/*****************ADDED*BY*WINDELL***********05*06*2011**************JCL13***********/    
/*   Added by    : Windell Valle
**   Date Created: May 06, 2011
**   Last Revised: May 06, 2011
**   Description : Populate JCL13 Bond Documents
**   Client(s)   : UCPB,...
*/
TYPE JCL13bond_type IS RECORD (
     policy_no                  VARCHAR2(50), 
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE,
     tsi_word_dh                VARCHAR2(500), 
     tsi_word                   VARCHAR2(200), 
     tsi_chr                    VARCHAR2(100), 
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     prin_designation           GIIS_PRIN_SIGNTRY.designation%TYPE,
     incept_date                VARCHAR2(50),
     expiry_date                VARCHAR2(50),
     subline_cd                 GIIS_SUBLINE.subline_cd%TYPE,
     subline_name               GIIS_SUBLINE.subline_name%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE,
     indemnity_text             GIXX_BOND_BASIC.indemnity_text%TYPE,
     clause_type                gipi_bond_basic.clause_type%TYPE
   );    
  TYPE JCL13bond_tab IS TABLE OF JCL13bond_type;
  

  FUNCTION Populate_text_for_JCL13bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN JCL13bond_tab PIPELINED;    
/*****************ADDED*BY*WINDELL***********05*06*2011**************JCL13***********/


/*****************ADDED*BY*WINDELL***********05*06*2011**************JCL4***********/    
/*   Added by    : Windell Valle
**   Date Created: May 06, 2011
**   Last Revised: May 06, 2011
**   Description : Populate JCL4 Bond Documents
**   Client(s)   : UCPB,...
*/
TYPE JCL4bond_type IS RECORD (
     policy_no                  VARCHAR2(50), 
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     address                    VARCHAR2(200),
     tsi_amt                    GIPI_POLBASIC.tsi_amt%TYPE,
     tsi_word_dh                VARCHAR2(500), 
     tsi_word                   VARCHAR2(200), 
     tsi_chr                    VARCHAR2(100), 
     bond_dtl                   GIPI_BOND_BASIC.bond_dtl%TYPE,
     contract_day               VARCHAR2(50),
     contract_month_year        VARCHAR2(100),
     contract_dtl               GIPI_BOND_BASIC.contract_dtl%TYPE,
     prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
     prin_designation           GIIS_PRIN_SIGNTRY.designation%TYPE,
     incept_date                VARCHAR2(50),
     expiry_date                VARCHAR2(50),
     subline_cd                 GIIS_SUBLINE.subline_cd%TYPE,
     subline_name               GIIS_SUBLINE.subline_name%TYPE,
     issue_date                 GIPI_POLBASIC.issue_date%TYPE,  
     issue_day                   VARCHAR2(70),
     issue_month_year            VARCHAR2(70),                    
     obligee_name               GIIS_OBLIGEE.obligee_name%TYPE,
     o_address                  VARCHAR2(200),
     issue_place                GIIS_PRIN_SIGNTRY.issue_place%TYPE,
     policy_id                  GIPI_POLBASIC.policy_id%TYPE,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     iss_cd                     GIPI_POLBASIC.iss_cd%TYPE,
     indemnity_text             GIXX_BOND_BASIC.indemnity_text%TYPE
   );    
  TYPE JCL4bond_tab IS TABLE OF JCL4bond_type;
  

  FUNCTION Populate_text_for_JCL4bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN JCL4bond_tab PIPELINED;    
/*****************ADDED*BY*WINDELL***********05*06*2011**************JCL4***********/


/*****************ADDED*BY*WINDELL***********05*09*2011**************NOTARYPUBLICDETAILS***********/    
/*   Added by    : Windell Valle
**   Date Created: May 09, 2011
**   Last Revised: May 09, 2011
**   Description : Notary Public Details
**   Client(s)   : UCPB,...
*/
TYPE notary_public_type IS RECORD (
     np_name                    GIIS_NOTARY_PUBLIC.np_name%TYPE, 
     np_issue_date                GIIS_NOTARY_PUBLIC.issue_date%TYPE,
     np_issue_year               VARCHAR2(50),
     np_expiry_date                VARCHAR2(50),
     np_ptr_no                    GIIS_NOTARY_PUBLIC.ptr_no%TYPE,
     np_place_issue                GIIS_NOTARY_PUBLIC.place_issue%TYPE,
     np_remarks                 GIIS_NOTARY_PUBLIC.remarks%TYPE,
     ref_pol_no                 GIPI_POLBASIC.ref_pol_no%TYPE,
     policy_id                  gipi_polbasic.policy_id%type,
     iss_cd                     gipi_polbasic.iss_cd%type,
     pol_issue_date             gipi_polbasic.issue_date%type,
     subline_cd                 gipi_polbasic.subline_cd%type,
     tsi_amt                    gipi_polbasic.tsi_amt%type,
     res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
     issue_date                 VARCHAR2(50),
     s_issue_date               VARCHAR2(50),
     clause_desc                GIIS_BOND_CLASS_CLAUSE.CLAUSE_DESC%TYPE
   );
    
  TYPE notary_public_tab IS TABLE OF notary_public_type;
  
  FUNCTION Populate_Notary_Public_Details (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN notary_public_tab PIPELINED;
/*****************ADDED*BY*WINDELL***********05*09*2011**************NOTARYPUBLICDETAILS***********/     


/*****************ADDED*BY*WINDELL***********05*11*2011**************bond_policy***********/    
/*   Added by    : Windell Valle
**   Date Created: May 12, 2011
**   Last Revised: May 12, 2011
**   Description : For BOND POLICY DOC
**   Client(s)   : UCPB,...
*/

   TYPE bond_policy_type IS RECORD (
     policy_no                         VARCHAR2(50),
     tsi_chr                           VARCHAR2(50),
     intrmdry_intm_no                  NUMBER,
     policy_id                         NUMBER,
     collateral                        NUMBER,
     assd_name                         GIIS_ASSURED.assd_name%TYPE,
     address                           VARCHAR2(200),
     obligee_name                      GIIS_OBLIGEE.obligee_name%TYPE,
     subline_name                      GIIS_SUBLINE.subline_name%TYPE,
     contract_period                   VARCHAR2(50),
     bond_no                           VARCHAR2(50),
     tsi_word                          VARCHAR2(200),
     indemnity_text                    gipi_bond_basic.indemnity_text%TYPE,
     issue_day                         VARCHAR2(50),
     issue_month_year                  VARCHAR2(50),
     subline_cd                        gipi_polbasic.subline_cd%TYPE,
     expiry_date                       gipi_polbasic.expiry_date%TYPE,
     iss_cd                            gipi_polbasic.iss_cd%TYPE,
     issue_date                        GIPI_POLBASIC.ISSUE_DATE%TYPE,  --abie 06092011      
     prem_amt                          GIPI_INVOICE.PREM_AMT%TYPE, --abie 06092011
     currency                          GIIS_CURRENCY.SHORT_NAME%TYPE, -- abie 06092011
     total_amt                         GIPI_INVOICE.PREM_AMT%TYPE  --abie 06092011          
   );
    
  TYPE bond_policy_tab IS TABLE OF bond_policy_type;

  FUNCTION get_bond_policy (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN bond_policy_tab PIPELINED;

/*****************ADDED*BY*WINDELL***********05*18*2011**************bond_policy***********/   


/*****************ADDED*BY*WINDELL***********05*18*2011**************indemnity***********/    
/*   Added by    : Windell Valle
**   Date Created: May 18, 2011
**   Last Revised: May 18, 2011
**   Description : For BOND POLICY DOC; Indemnity
**   Client(s)   : UCPB,...
*/

   TYPE indemnity_type IS RECORD (
     assd_name            GIIS_ASSURED.assd_name%TYPE,
     tsi_amt              GIPI_POLBASIC.tsi_amt%TYPE,
     tsi_word_dh          VARCHAR2(500),  
     tsi_chr              VARCHAR2(100), 
     prem_amt             GIPI_POLBASIC.prem_amt%TYPE,
     prem_word_dh         VARCHAR2(500),  
     prem_chr             VARCHAR2(100), 
     issue_date           VARCHAR2(50),  
     issue_day            VARCHAR2(70),
     issue_month_year     VARCHAR2(70),
     np_issue_year        VARCHAR2(20),
     indemnity_text       VARCHAR2(4000),
     assd_addr            VARCHAR2(200),
     prin_signor          VARCHAR2(50),
     cosignatory          VARCHAR2(2000),
     prin_designation     giis_prin_signtry.designation%TYPE,
     obligee              giis_obligee.obligee_name%TYPE
   );
    
  TYPE indemnity_tab IS TABLE OF indemnity_type;

  FUNCTION populate_indemnity (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN indemnity_tab PIPELINED;

/*****************ADDED*BY*WINDELL***********05*18*2011**************indemnity***********/ 


/*****************ADDED*BY*WINDELL***********05*19*2011**************bond_acknowledgment***********/    
/*   Added by    : Windell Valle
**   Date Created: May 19, 2011
**   Last Revised: May 19, 2011
**   Description : For BOND POLICY DOC; Bond Acknowledgment
**   Client(s)   : UCPB,...
*/

   TYPE bond_acknowledgment_type IS RECORD (
    policy_id                   gipi_polbasic.policy_id%TYPE,
    prin_signor                GIIS_PRIN_SIGNTRY.prin_signor%TYPE,
    res_cert                   GIIS_PRIN_SIGNTRY.res_cert%TYPE,
    issue_place                VARCHAR2(300),
    issue_date                 VARCHAR2(50) ,
    remarks                    VARCHAR2(1000)        
   );
    
  TYPE bond_acknowledgment_tab IS TABLE OF bond_acknowledgment_type;

  FUNCTION populate_bond_acknowledgment (p_policy_id    GIPI_POLBASIC.policy_id%TYPE)
    RETURN bond_acknowledgment_tab PIPELINED;

/*****************ADDED*BY*WINDELL***********05*19*2011**************bond_acknowledgment***********/ 
  type bond_cosign_type is record (
    policy_id                   gipi_polbasic.policy_id%type,
    assd_no                     gipi_polbasic.assd_no%type,
    cosign                      VARCHAR2(500),
    co_iss_dt                   VARCHAR2(20),
    co_iss_pl                   VARCHAR2(15), 
    remarks                     VARCHAR2(2000),
    id_no                       VARCHAR2(50),
    report_id                   VARCHAR2(50),
    bonds_flag                  VARCHAR2(1),
    indem_flag                  VARCHAR2(1)
    );
    
  type bond_ack_names_tab   is table of bond_cosign_type;

  function populate_ack_names (p_policy_id  gipi_polbasic.policy_id%type)
    return bond_ack_names_tab pipelined;
    
  function get_cosigner (p_policy_id  gipi_polbasic.policy_id%type)
    return VARCHAR2;    

  function get_pol_issue_place (p_iss_cd gipi_polbasic.iss_cd%type)
    return varchar2;
    
  function get_pol_rep (p_policy_id gipi_polbasic.policy_id%type)
    return varchar2;
  
/* 
 *  Added by:       Christian Santos
 *  Module:         GIPIS091
 *  Date Created:   March 19, 2012
 *  Description:    Fidelity Bond for FGIC
*/  
  TYPE fido2b_type IS RECORD(
       assd_name                giis_assured.assd_name%type,
       policy_no                VARCHAR2(35),
       tsi_amt                  VARCHAR2(30), 
       sp_tsi_amt               VARCHAR2(200),
       prem_amt                 VARCHAR2(30),
       sp_prem_amt              VARCHAR2(200),  
       obligee_name             giis_obligee.obligee_name%TYPE,--VARCHAR2(50),	modified by Gzelle 01212015
       contract_day             VARCHAR2(70),
       contract_month_year      VARCHAR2(70),
       expiry_date              VARCHAR2(30),
       eff_date                 VARCHAR2(20),
       prin_signor              VARCHAR2(50),
       designation              giis_signatory_names.designation%type,
       ref_pol_no               VARCHAR2(30),
       bond_dtl                 VARCHAR2(2000),
       issue_day                VARCHAR2(70),
       issue_month_year         VARCHAR2(70));
  
  TYPE fido2b_tab IS TABLE OF fido2b_type;
    
  FUNCTION populate_text_for_fido2b (p_policy_id gipi_polbasic.policy_id%type)
    RETURN fido2b_tab PIPELINED;
END;
/


