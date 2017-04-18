CREATE OR REPLACE PACKAGE CPI.GIACR251_CPI_PKG AS 

  TYPE giacr251_record_type IS RECORD (
    company_name        giis_parameters.param_value_v%TYPE,
    intm_name           giis_intermediary.intm_name%TYPE,
    agent_cd            giac_comm_voucher_ext.intm_no%TYPE,
    policy_id           gipi_invoice.policy_id%TYPE,
    policy_no           VARCHAR2(100),
    assd_no             giac_comm_voucher_ext.assd_no%TYPE,
    assd_name           giis_assured.assd_name%TYPE,
    iss_cd              giac_comm_voucher_ext.iss_cd%TYPE,
    prem_seq_no         giac_comm_voucher_ext.prem_seq_no%TYPE,
    prem_amt            NUMBER,
    tot_prem            NUMBER,
    comm_amt            NUMBER,
    wtax                NUMBER,
    advances            NUMBER,
    input_vat           NUMBER,
    actual_comm         NUMBER,
    comm_payable        NUMBER,
    peril_sname         giis_peril.peril_sname%TYPE,
    peril_prem_amt      NUMBER,
    peril_comm_rt       NUMBER,
    peril_wtax_amt      NUMBER,
    parent_comm_rt      NUMBER,
    peril_comm          NUMBER,
    bill_amt_due       NUMBER --added by jeffdojello 01.17.2014
  );

  TYPE giacr251_record_tab IS TABLE OF giacr251_record_type;
  
  FUNCTION populate_giacr251_records (
      p_intm_no           VARCHAR2,
      p_user_id           VARCHAR2
    )
    RETURN giacr251_record_tab PIPELINED;

END GIACR251_CPI_PKG;
/

DROP PACKAGE CPI.GIACR251_CPI_PKG;

