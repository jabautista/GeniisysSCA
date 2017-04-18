CREATE OR REPLACE PACKAGE CPI.GIPI_COMM_INVOICE_PKG
AS
  PROCEDURE get_comm_invoice_intm(p_policy_id IN GIPI_POLBASIC.policy_id%TYPE,
                                  p_intm_no   OUT GIIS_INTERMEDIARY.intm_no%TYPE,
                                  p_intm_name OUT GIIS_INTERMEDIARY.intm_name%TYPE);

END GIPI_COMM_INVOICE_PKG;
/


