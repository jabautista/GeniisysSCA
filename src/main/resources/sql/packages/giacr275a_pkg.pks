CREATE OR REPLACE PACKAGE CPI.giacr275a_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      from_to           VARCHAR2 (100),
      cut_off           VARCHAR2 (100),
      branch            VARCHAR2 (200),
      line              VARCHAR2 (200),
      intm              VARCHAR2 (300),
      policy_no         giac_intm_prod_colln_ext.policy_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      incept_date       giac_intm_prod_colln_ext.incept_date%TYPE,
      bill_no           VARCHAR2 (100),
      premium_amt       giac_intm_prod_colln_ext.premium_amt%TYPE,
      tax_amt           giac_intm_prod_colln_ext.tax_amt%TYPE,
      amount_due        NUMBER (16, 2),
      ref_date          DATE,
      ref_no            VARCHAR2 (200),
      collection_amt    NUMBER (16, 2),
      balance_due       NUMBER (16, 2),
      policy_id         giac_intm_prod_colln_ext.policy_id%TYPE,
      cs_balance        NUMBER (16, 2),
      share_percentage  giac_intm_prod_colln_ext.share_percentage%TYPE,
      prem_seq_no       giac_intm_prod_colln_ext.prem_seq_no%TYPE,
      iss_cd            giac_intm_prod_colln_ext.iss_cd%TYPE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_275a_report (
      p_cut_off_date    VARCHAR2,
      p_cut_off_param   VARCHAR2,
      p_date_param      VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_iss_param       VARCHAR2,
      p_line_cd         VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
   TYPE colls_type IS RECORD (
      tran_id           giac_premium_colln_v.tran_id%TYPE,
      tran_class        giac_premium_colln_v.tran_class%TYPE,
      ref_date          DATE,
      ref_no            giac_premium_colln_v.ref_no%TYPE,
      collection_amt    giac_premium_colln_v.collection_amt%TYPE,
      balance_due       NUMBER
   );
   
   TYPE colls_tab IS TABLE OF colls_type;
   
   FUNCTION get_colls (
      p_cut_off_date        VARCHAR2,
      p_cut_off_param       VARCHAR2,
      p_share_percentage    NUMBER,
      p_iss_cd              VARCHAR2,
      p_prem_seq_no         NUMBER,
      p_amount_due          NUMBER
   )
      RETURN colls_tab PIPELINED;
      
END;
/


