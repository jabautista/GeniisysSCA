CREATE OR REPLACE PACKAGE BODY CPI.GIACR502B_PKG 
AS
   /*
      **  Created by   :  Melvin John O. Ostia
      **  Date Created : 07.024.2013
      **  Reference By : GIACR502B_PKG - TRIAL BALANCE REPORT
      */
   FUNCTION cf_company_addressformula
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT UPPER (param_value_v)
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;

   FUNCTION get_giacr502b_record (p_tran_mm NUMBER, p_tran_yr NUMBER)
      RETURN giacr502b_tab PIPELINED
   AS
      v_rec         giacr502b_type;
      v_not_exist   BOOLEAN        := TRUE;
   BEGIN
      v_rec.comp_add := cf_company_addressformula;

      FOR rec IN (SELECT UPPER (param_value_v) param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_rec.comp_name := rec.param_value_v;
         EXIT;
      END LOOP;

      IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
      THEN
         v_rec.mm := NVL (p_tran_mm, 0);
      ELSE
         v_rec.mm :=
               RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'));
      END IF;

      v_rec.as_of := 'As of ' || v_rec.mm || ' ' || TO_CHAR (p_tran_yr);

      FOR i IN (SELECT   b.gl_acct_name, a.gl_acct_id,
                         get_gl_acct_no (a.gl_acct_id) gl_no,
                         SUM (DECODE (SIGN (trans_balance),
                                      1, trans_balance,
                                      0
                                     )
                             ) debit,
                         SUM (ABS (DECODE (SIGN (trans_balance),
                                           -1, trans_balance,
                                           0
                                          )
                                  )
                             ) credit
                    FROM giac_trial_balance_summary a, giac_chart_of_accts b
                   WHERE a.gl_acct_id = b.gl_acct_id
                GROUP BY b.gl_acct_name,
                         a.gl_acct_id,
                         get_gl_acct_no (a.gl_acct_id)
                ORDER BY 3)
      LOOP
         v_not_exist := FALSE;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.gl_acct_id := i.gl_acct_id;
         v_rec.gl_no := i.gl_no;
         v_rec.debit := i.debit;
         v_rec.credit := i.credit;
         v_rec.balance := i.debit - i.credit;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.gl_acct_name := ' ';
         v_rec.gl_no := ' ';
         PIPE ROW (v_rec);
      END IF;
   END get_giacr502b_record;
END;
/


