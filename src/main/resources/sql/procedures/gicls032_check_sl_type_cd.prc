DROP PROCEDURE CPI.GICLS032_CHECK_SL_TYPE_CD;

CREATE OR REPLACE PROCEDURE CPI.gicls032_check_sl_type_cd(
  p_claim_id        gicl_advice.claim_id%TYPE,
  p_advice_id       gicl_advice.advice_id%TYPE
) IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - check_sl_type_cd
   */ 
   
   v_gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE;
   v_gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE;
   v_gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE;
   v_gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE;
   v_gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE;
   v_gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE;
   v_gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE;
   v_gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE;
   v_gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE;
   v_payee_class_cd     gicl_acct_entries.payee_class_cd%TYPE;
   v_sl_type_cd1        giac_chart_of_accts.gslt_sl_type_cd%TYPE;
   v_sl_type_cd2        giis_payee_class.sl_type_cd%TYPE;
   --alert_id             alert;
   v_alert              NUMBER;
BEGIN
   FOR c IN (SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                    gl_sub_acct_6, gl_sub_acct_7, payee_class_cd
               FROM gicl_acct_entries
              WHERE claim_id = p_claim_id AND advice_id = p_advice_id AND sl_cd IS NULL)
   LOOP
      v_gl_acct_category := c.gl_acct_category;
      v_gl_control_acct := c.gl_control_acct;
      v_gl_sub_acct_1 := c.gl_sub_acct_1;
      v_gl_sub_acct_2 := c.gl_sub_acct_2;
      v_gl_sub_acct_3 := c.gl_sub_acct_3;
      v_gl_sub_acct_4 := c.gl_sub_acct_4;
      v_gl_sub_acct_5 := c.gl_sub_acct_5;
      v_gl_sub_acct_6 := c.gl_sub_acct_6;
      v_gl_sub_acct_7 := c.gl_sub_acct_7;
      v_payee_class_cd := c.payee_class_cd;
      
      FOR j IN (SELECT gslt_sl_type_cd
                  FROM giac_chart_of_accts
                 WHERE gl_acct_category = c.gl_acct_category
                   AND gl_control_acct = c.gl_control_acct
                   AND gl_sub_acct_1 = c.gl_sub_acct_1
                   AND gl_sub_acct_2 = c.gl_sub_acct_2
                   AND gl_sub_acct_3 = c.gl_sub_acct_3
                   AND gl_sub_acct_4 = c.gl_sub_acct_4
                   AND gl_sub_acct_5 = c.gl_sub_acct_5
                   AND gl_sub_acct_6 = c.gl_sub_acct_6
                   AND gl_sub_acct_7 = c.gl_sub_acct_7)
      LOOP
         v_sl_type_cd1 := j.gslt_sl_type_cd;

         IF v_sl_type_cd1 IS NOT NULL
         THEN
            BEGIN
               FOR l IN (SELECT sl_type_cd
                           FROM giis_payee_class
                          WHERE payee_class_cd = v_payee_class_cd)
               LOOP
                  v_sl_type_cd2 := l.sl_type_cd;

                  IF NVL (v_sl_type_cd2, 'XX') = NVL (v_sl_type_cd1, 'XX')
                  THEN
                     raise_application_error (-20001, 'Geniisys Exception#I#GL account code '
                                || TO_CHAR (v_gl_acct_category)
                                || '-'
                                || TO_CHAR (v_gl_control_acct, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_1, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_2, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_3, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_4, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_5, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_6, '09')
                                || '-'
                                || TO_CHAR (v_gl_sub_acct_7, '09')
                                || ' has no SL code.'
                                || '#Geniisys Exception#C#Do you wish to check the generated accounting entries before approving?');                                
                  END IF;
               END LOOP;
            END;
         END IF;
      END LOOP;
   END LOOP;
END;
/


