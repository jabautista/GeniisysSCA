CREATE OR REPLACE PACKAGE CPI.GIACR250_PKG AS

  TYPE giacr250_record_type IS RECORD (
    company_name        giis_parameters.param_value_v%TYPE,
    intm_name           giis_intermediary.intm_name%TYPE,
    agent_cd            giac_comm_slip_ext.intm_no%TYPE,
    gacc_tran_id        giac_comm_slip_ext.gacc_tran_id%TYPE,
    policy_no           VARCHAR2(100),
    comm_amt            NUMBER,
    wtax_amt            NUMBER,
    vat_amt             NUMBER,
    net                 NUMBER,
    prem_seq_no         gipi_comm_inv_peril.prem_seq_no%TYPE,
    comm_paid           NUMBER,
    premium_amt         NUMBER,
    user_id             giac_order_of_payts.user_id%TYPE,
    iss_cd              giac_comm_slip_ext.iss_cd%TYPE,
    assd_name           giis_assured.assd_name%TYPE,
    line_cd             gipi_polbasic.line_cd%TYPE,
    policy_id           gipi_polbasic.policy_id%TYPE,
    peril_sname         giis_peril.peril_sname%TYPE,
    peril_prem_amt      NUMBER,
    peril_comm_amt      NUMBER,
    peril_comm_rt       NUMBER,
    partial_prem        NUMBER,
    comm_rt_b           NUMBER,
    ovr_comm            NUMBER,
    child_rt            NUMBER,
    partial_comm        NUMBER,
    wtax                NUMBER,
    input_vat           NUMBER
  );

  TYPE giacr250_record_tab IS TABLE OF giacr250_record_type;

  FUNCTION populate_giacr250_records (
      p_tran_id           VARCHAR2,
      p_intm_no           VARCHAR2
    )
    RETURN giacr250_record_tab PIPELINED;

END GIACR250_PKG;
/


