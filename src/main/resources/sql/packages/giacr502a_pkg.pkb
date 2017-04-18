CREATE OR REPLACE PACKAGE BODY CPI.GIACR502A_PKG
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.24.2013
    **  Reference By : GIACR502A- Commissions Paid
    */
   FUNCTION get_details (p_tran_mm NUMBER, p_tran_yr NUMBER)
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_mm     VARCHAR2 (10);
      v_not_exist boolean := true;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      BEGIN
         IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
         THEN
            v_mm := NVL (p_tran_mm, 0);
         ELSE
            v_mm :=
               RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'));
         END IF;

         v_list.as_of := 'As of ' || v_mm || ' ' || TO_CHAR (p_tran_yr);
      END;

      FOR i IN (SELECT   get_gl_acct_no (gfy.gl_acct_id) gl_acct_no,
                         gca.gl_acct_name,
                         SUM (DECODE (SIGN (gfy.trans_balance),
                                      1, gfy.trans_balance,
                                      0
                                     )
                             ) debit,
                         SUM (ABS (DECODE (SIGN (gfy.trans_balance),
                                           -1, gfy.trans_balance,
                                           0
                                          )
                                  )
                             ) credit
                    FROM giac_finance_yr gfy, giac_chart_of_accts gca
                   WHERE gfy.gl_acct_id = gca.gl_acct_id
                     AND gfy.tran_year = p_tran_yr
                     AND gfy.tran_mm = p_tran_mm
                GROUP BY get_gl_acct_no (gfy.gl_acct_id), gca.gl_acct_name
                ORDER BY get_gl_acct_no (gfy.gl_acct_id), gca.gl_acct_name)
      LOOP
         v_not_exist := false;
         v_list.debit := i.debit;
         v_list.credit := i.credit;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.gl_acct_name := i.gl_acct_name;

         BEGIN
            v_list.balance := i.debit - i.credit;
         END;

         PIPE ROW (v_list);
      END LOOP;
        
      IF v_not_exist THEN 
        PIPE ROW (v_list);
      END IF;
        
      RETURN;
   END get_details;
END GIACR502A_PKG;
/


