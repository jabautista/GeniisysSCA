CREATE OR REPLACE PACKAGE CPI.giacr287_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      from_to          VARCHAR2 (100),
      branch           VARCHAR2 (25),
      line             VARCHAR2 (25),
      assd_no          giis_assured.assd_no%TYPE,
      assd             VARCHAR2 (543),
      prem_ref_date    DATE,
     -- prem_ref_no      giac_premium_colln_v.ref_no%TYPE,
      prem_ref_no      VARCHAR2(500),
      bill_no          VARCHAR2 (43),
      coll_amt         NUMBER (38,5),
      comm_amt         giac_comm_paid_v.comm_amt%TYPE,
      incept_date      gipi_polbasic.incept_date%TYPE,
      intm_name        giis_intermediary.intm_name%TYPE,
      policy_no        VARCHAR2 (4000),
      prem_amt         NUMBER (38,5),
      comm_ref_date    DATE,
     -- ref_no           giac_premium_colln_v.ref_no%TYPE,
      ref_no           VARCHAR2(500),
      tax_amt          NUMBER (38,5),
      wtax_amt         giac_comm_paid_v.wtax_amt%TYPE
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details_old (      -- GENQA 5298, 5299 
      p_cut_off_param   VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_assd_no         NUMBER,
      p_line_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_details_tab PIPELINED;
      
   FUNCTION get_details (          -- GENQA 5298, 5299 
      p_cut_off_param   VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_assd_no         NUMBER,
      p_line_cd         VARCHAR2,
      p_branch_cd       VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_details_tab PIPELINED;  
   
   FUNCTION get_branch_withaccess (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN VARCHAR2;          
END;
/


