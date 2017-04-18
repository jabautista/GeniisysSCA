CREATE OR REPLACE PACKAGE CPI.giacr259_pkg
AS
   TYPE giacr259_record_type IS RECORD (
      branch              VARCHAR2 (50),
      pdate               DATE,
      line_name           VARCHAR (50),
      intm_type           VARCHAR (50),
      intermediary_name   VARCHAR (100),
      policy_number       VARCHAR (50),
      bill_number         VARCHAR (20),
      iss_cd              gipi_comm_inv_peril.iss_cd%TYPE,
      prem_seq_no         gipi_comm_inv_peril.prem_seq_no%TYPE,
      peril_name          giis_peril.peril_name%TYPE,
      comm_rate           giis_intmdry_type_rt.comm_rate%TYPE,
      premium_amt         gipi_comm_inv_peril.premium_amt%TYPE,
      policy_id           gipi_polbasic.policy_id%TYPE,
      company_name        VARCHAR2 (200),
      company_address     VARCHAR2 (200),
      mjm                 VARCHAR2 (1),
      cf_date             VARCHAR2 (100),
      cf_branch           VARCHAR2 (50),
      commission_rate     NUMBER,
      commission_amt      NUMBER
   );

   TYPE giacr259_record_tab IS TABLE OF giacr259_record_type;

   FUNCTION get_giacr259_record (
      p_branch_param      VARCHAR2,
      p_date_param        VARCHAR2,
      p_line_cd           VARCHAR2,
      p_branch_cd         VARCHAR2,
      p_from              DATE,
      p_to                DATE,
      p_intm_cd           VARCHAR2,
      p_intermediary_cd   VARCHAR2,
      p_module_id         VARCHAR2,
      p_user_id           VARCHAR2
   )
      RETURN giacr259_record_tab PIPELINED;
END;
/


