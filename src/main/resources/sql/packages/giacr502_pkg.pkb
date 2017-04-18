CREATE OR REPLACE PACKAGE BODY CPI.GIACR502_PKG
AS
   FUNCTION get_giacr_502_report (
      p_branch_cd   VARCHAR2,
      p_tran_mm     NUMBER,
      p_tran_yr     NUMBER
   )
      RETURN report_tab PIPELINED
   IS
      v_list   report_type;
      v_not_exist   BOOLEAN := TRUE;
   BEGIN
      FOR c IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME')
      LOOP
         v_list.company_name := c.param_value_v;
      END LOOP;
 
      BEGIN
         SELECT param_value_v
           INTO v_list.company_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.company_address := '';
      END;
      
      BEGIN
        IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
        THEN
            v_list.mm := NVL (p_tran_mm, 0);
        ELSE
            v_list.mm :=
                RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'),
                                'Month')
                    );
        END IF;
      END;
            
      v_list.as_of := 'As of ' || v_list.mm || ' ' || TO_CHAR (p_tran_yr);
       
      FOR a IN (SELECT branch_name
                  FROM giac_branches
                 WHERE branch_cd = p_branch_cd)
      LOOP
        v_list.branch_name := a.branch_name;
      END LOOP;
         
      FOR i IN (SELECT   gfy.fund_cd, gfy.branch_cd,
                         get_gl_acct_no (gfy.gl_acct_id) gl_acct_no,
                         gca.gl_acct_name, gfy.trans_balance
                    FROM giac_finance_yr gfy, giac_chart_of_accts gca
                   WHERE gfy.gl_acct_id = gca.gl_acct_id
                     AND gfy.tran_year = p_tran_yr
                     AND gfy.tran_mm = p_tran_mm
                     AND gfy.branch_cd = NVL (p_branch_cd, gfy.branch_cd)
                ORDER BY gfy.fund_cd,
                         gfy.branch_cd,
                         get_gl_acct_no (gfy.gl_acct_id),
                         gca.gl_acct_name)
      LOOP
         v_not_exist := FALSE;
         v_list.v_header := 'T';
         FOR rec IN (SELECT branch_name
                       FROM giac_branches
                      WHERE gfun_fund_cd = i.fund_cd
                        AND branch_cd = i.branch_cd)
         LOOP
            v_list.cf_branch_name := rec.branch_name;
         END LOOP;

         v_list.gl_acct_no := i.gl_acct_no;
         v_list.gl_acct_name := i.gl_acct_name;

         BEGIN
            IF NVL (i.trans_balance, 0) >= 0
            THEN
               v_list.debit := NVL (i.trans_balance, 0);
               v_list.credit := 0;
            ELSE
               v_list.debit := 0;
               v_list.credit := NVL (ABS (i.trans_balance), 0);
            END IF;
         END;

         v_list.balance := v_list.debit - v_list.credit;
         v_list.branch_totals := '(' || i.branch_cd || ') Branch Totals   :';
         v_list.fund_cd := i.fund_cd;
         
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_not_exist THEN
         v_list.v_header := 'F';
         PIPE ROW (v_list);
      END IF;
   END get_giacr_502_report;
END;
/


