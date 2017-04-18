DROP PROCEDURE CPI.VALIDATE_OPEN_POLICY;

CREATE OR REPLACE PROCEDURE CPI.validate_open_policy (
   p_prem_seq_no   IN       gipi_invoice.prem_seq_no%TYPE,
   p_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
   p_message       OUT      VARCHAR2
)
IS
   v_param_value   giis_parameters.param_value_v%TYPE;
   v_line_cd       giis_line.line_cd%TYPE;
   v_subline_cd    giis_subline.subline_cd%TYPE;
   v_op_flag       giis_subline.op_flag%TYPE;
BEGIN
   /*  SELECT line_cd, subline_cd
       INTO v_line_cd, v_subline_cd
       FROM gipi_polbasic
      WHERE policy_id =
                      (SELECT policy_id
                         FROM gipi_invoice
                        WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no);

     SELECT op_flag
       INTO v_op_flag
       FROM giis_subline
      WHERE line_cd = v_line_cd AND subline_cd = v_subline_cd;*/

	BEGIN
      SELECT b.op_flag
        INTO v_op_flag
        FROM gipi_polbasic a, giis_subline b, gipi_invoice c
       WHERE c.iss_cd = p_iss_cd
         AND c.prem_seq_no = p_prem_seq_no
         AND a.policy_id = c.policy_id
         AND b.line_cd = a.line_cd
         AND b.subline_cd = a.subline_cd;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_op_flag := 'N';
   END;

   IF v_op_flag = 'Y'
   THEN
      v_param_value := NVL(giacp.v ('PREM_PAYT_FOR_OPEN_POLICY'), 'N');

      IF v_param_value = 'Y'
      THEN
         p_message := 'This is an Open Policy.';
      ELSIF v_param_value = 'N'
      THEN
         p_message := 'Premium payment for Open Policy is not allowed.';
      END IF;
   /*ELSE
      p_message := 'Ok';*/
   END IF;
END validate_open_policy;
/


