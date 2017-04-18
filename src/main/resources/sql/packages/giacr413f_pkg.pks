CREATE OR REPLACE PACKAGE CPI.giacr413f_pkg
AS
   TYPE giacr413f_record_type IS RECORD (
      intm_type       VARCHAR2 (2),
      intm_no         NUMBER (12),
      line_cd         VARCHAR2 (2),
      iss_cd          VARCHAR2 (2),
      prem_seq_no     VARCHAR2 (240),
      intm_name       VARCHAR2 (240),
      policy_no       VARCHAR2 (500),
      policy_id       NUMBER (12),
      subline_cd      VARCHAR2 (7),
      issue_yy        NUMBER (2),
      pol_seq_no      NUMBER (7),
      renew_no        NUMBER (2),
      endt_seq_no     NUMBER (6),
      comm_amt        NUMBER (12, 2),
      wtax_amt        NUMBER (12, 2),
      wtax            NUMBER (12, 2),
      input_vat_amt   NUMBER (12, 2),
      input_vat       NUMBER (12, 2),
      inst_no         NUMBER (4),
      company_nm      VARCHAR2 (200),
      company_add     VARCHAR2 (200),
      period          VARCHAR2 (50),
      tran_post       VARCHAR2 (50),
      iss_name        VARCHAR2 (50),
      intm            VARCHAR2 (20),
      comm_voucher    VARCHAR2 (240),
      TRANSACTION     VARCHAR2 (200),
      comm            NUMBER (12, 2),
      wtax_formula    NUMBER (12, 2)
   
   
   );

   TYPE giacr413f_record_tab IS TABLE OF giacr413f_record_type;

   FUNCTION get_giacr413f_records (
        p_branch    VARCHAR2, 
        p_from_dt   DATE, 
        p_intm_type VARCHAR2, 
        p_module_id VARCHAR2, 
        p_to_dt     DATE, 
        p_tran_post VARCHAR2, 
        p_user_id   VARCHAR2)
      RETURN giacr413f_record_tab PIPELINED;
END;
/


