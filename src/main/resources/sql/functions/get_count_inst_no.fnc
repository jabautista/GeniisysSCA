DROP FUNCTION CPI.GET_COUNT_INST_NO;

CREATE OR REPLACE FUNCTION CPI.GET_COUNT_INST_NO (
p_iss_cd           gipi_installment.iss_cd%TYPE,
p_prem_seq_no      gipi_installment.prem_seq_no%TYPE)
RETURN NUMBER AS
v_inst_no number;

/*Created by: Ladz 04242013 to get number of installments*/
BEGIN
SELECT count(inst_no)
INTO v_inst_no
FROM gipi_installment
WHERE iss_cd = p_iss_cd
AND prem_seq_no = p_prem_seq_no;
RETURN (v_inst_no);
END;
/


