DROP PROCEDURE CPI.CHECK_PREMIUM_PAYT_FOR_SPECIAL;

CREATE OR REPLACE PROCEDURE CPI.check_premium_payt_for_special (
   p_iss_cd               gipi_invoice.iss_cd%TYPE,
   p_prem_seq_no          gipi_invoice.prem_seq_no%TYPE,
   --p_invoice_butt         VARCHAR2, commented in by alfie 12.22.2010, this parameter isnt useful 
   --p_chk_tag         OUT      VARCHAR2,                                because the List of Invoices (GIACS007) in GenWeb dont use checkboxes
   p_msg_alert      OUT   VARCHAR2
)
IS
   v_prem_payt_for_special   giac_parameters.param_value_v%TYPE   := 'Y';
BEGIN
   --p_chk_tag:= 'Y'; alfie 12.22.2010
   --p_msg_alert:= 'none';
   FOR i IN (SELECT 1
               FROM gipi_polbasic a, gipi_invoice b
              WHERE a.policy_id = b.policy_id
                AND a.reg_policy_sw = 'N'
                AND b.iss_cd = p_iss_cd
                AND b.prem_seq_no = p_prem_seq_no)
   LOOP
      BEGIN
         SELECT param_value_v
           INTO v_prem_payt_for_special
           FROM giac_parameters
          WHERE param_name = 'PREM_PAYT_FOR_SPECIAL';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_prem_payt_for_special := 'Y';
      END;

      IF v_prem_payt_for_special = 'Y'
      THEN
         p_msg_alert := 'This is a Special Policy.';
      ELSE
         /*IF p_invoice_butt = 'TRUE' alfie 12.22.2010
         THEN
            p_chk_tag:= 'N';
         END IF;*/
         p_msg_alert := 'Premium payment for Special Policy is not allowed.';
      END IF;
   END LOOP;
END;
/


