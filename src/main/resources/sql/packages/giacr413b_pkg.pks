CREATE OR REPLACE PACKAGE CPI.giacr413b_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      period           VARCHAR2 (50),
      tran_post        VARCHAR2 (50),
      iss_cd           giac_comm_payts.iss_cd%TYPE,
      intm_type        giis_intermediary.intm_type%TYPE,
      intm_no          giac_comm_payts.intm_no%TYPE,
      intm_name        giis_intermediary.intm_name%TYPE,
      comm             NUMBER (38, 5),
      wtax             NUMBER (38, 5),
      input_vat        NUMBER (38, 5),
      net_amt          NUMBER (38, 5),
      iss_name         giis_issource.iss_name%TYPE,
      intm_desc        giis_intm_type.intm_desc%TYPE
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_from_dt     VARCHAR2,
      p_to_dt       VARCHAR2,
      p_tran_post   NUMBER,
      p_branch      VARCHAR2,
      p_module_id   VARCHAR2,
      p_intm_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN get_details_tab PIPELINED;
END;
/


