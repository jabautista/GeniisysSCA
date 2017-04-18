CREATE OR REPLACE PACKAGE CPI.giacr221b_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      report_title     VARCHAR2 (100),
      iss_name         giis_issource.iss_name%TYPE,
      branch           VARCHAR (2),
      agent_code       VARCHAR2 (15), --changed from 8 vondanix 10.06.2015 SR 5019
      intm_name        giis_intermediary.intm_name%TYPE,
      policy_no        VARCHAR2 (50),
      assd_name        giis_assured.assd_name%TYPE,
      bill_no          VARCHAR2(20), --vondanix 10.06.2015 SR 5019
      commission_amt   gipi_comm_inv_peril.commission_amt%TYPE,
      commission_rt    gipi_comm_inv_peril.commission_rt%TYPE,
      peril_name       giis_peril.peril_name%TYPE,  --changed from sname vondanix 10.06.2015 SR 5019 
      premium_amt      gipi_comm_inv_peril.premium_amt%TYPE,
      wholding_tax     gipi_comm_invoice.wholding_tax%TYPE,  --vondanix 10.06.2015 SR 5019
      input_vat1       gipi_comm_invoice.wholding_tax%TYPE,  --vondanix 10.06.2015 SR 5019
      net_comm         gipi_comm_invoice.commission_amt%TYPE,--vondanix 10.06.2015 SR 5019
      cf_count         NUMBER
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_rep_grp       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_intm_no       VARCHAR2, --vondanix 10.06.2015 SR 5019
      p_module_id     VARCHAR2,
      p_unpaid_prem   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED;
END;
/


