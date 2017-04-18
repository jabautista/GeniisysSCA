CREATE OR REPLACE PACKAGE BODY CPI.giacr190a_pkg
AS
/******************************************************************************
   Name:       GIACR190A_PKG
   Purpose:    SOA - COLLECTION LETTER - LIST ALL INTERMEDIARY

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/07/2013  Abegail Pascual  Created this package.
******************************************************************************/
   FUNCTION get_report_details (
      p_intm_no        VARCHAR2,
      p_aging_id       VARCHAR2,
      p_print_btn_no   NUMBER,
      p_user_id        giis_users.user_id%TYPE
   ) RETURN g_giacr190a_tab PIPELINED
   IS
      v_details   g_giacr190a_type;
      v_selected_aging_id VARCHAR2(1000) := p_aging_id;
      v_aging_id          VARCHAR2(8);		-- SR-4050 : shan 06.19.2015
      v_intm_no           VARCHAR2(14);
   BEGIN
      IF p_print_btn_no = 3  -- list of intm only
      THEN
      
        /*FOR g IN (SELECT DISTINCT aging_id
                    FROM giac_soa_rep_ext
                   WHERE user_id = p_user_id)
        LOOP
            v_aging_id := '#' || g.aging_id || '#';
            
            IF INSTR(v_selected_aging_id, v_aging_id) != 0 THEN*/
            
      
                 FOR x IN (SELECT distinct intm_no intm_no --'#' || intm_no || '#' AS intm_no
                             FROM giac_soa_rep_ext  -- giac_aging_intm_v 	                  
                            WHERE balance_amt_due != 0 
                              AND intm_no != 0
                              /*AND aging_id = REPLACE(v_aging_id, '#')*/ )
                 LOOP
                    v_intm_no := '#' || x.intm_no || '#';
                    IF INSTR (p_intm_no, v_intm_no) != 0
                    THEN
                       FOR gi IN
                          (SELECT a.intm_no, c.policy_no,
                                     b.iss_cd
                                  || b.prem_seq_no
                                  || '-'
                                  || b.inst_no AS invoice_num,
                                  b.param_date, b.user_id, a.intm_name,
                                  giisp.v ('COMPANY_NAME') AS company_name,
                                  DECODE (bill_addr1, '.', NULL, bill_addr1) address,
                                  DECODE (bill_addr2,
                                          '.', NULL,
                                          bill_addr2
                                         ) address2,
                                  DECODE (bill_addr3,
                                          '.', NULL,
                                          bill_addr3
                                         ) address3,
                                     TO_CHAR (c.incept_date,
                                              'MM/DD/RRRR'
                                             )
                                  || ' - '
                                  || TO_CHAR (c.expiry_date, 'MM/DD/RRRR')
                                                                      AS policy_term,
                                  prem_bal_due, tax_bal_due, balance_amt_due
                             FROM giis_intermediary a,
                                  giac_soa_rep_ext b,
                                  (SELECT y.iss_cd, y.prem_seq_no,
                                          get_policy_no (x.policy_id) AS policy_no,
                                          x.incept_date, x.expiry_date
                                     FROM gipi_polbasic x, gipi_invoice y
                                    WHERE x.policy_id = y.policy_id) c
                            WHERE a.intm_no = b.intm_no
                              AND b.iss_cd = c.iss_cd
                              AND b.prem_seq_no = c.prem_seq_no
                              AND balance_amt_due != 0
                              AND a.intm_no = REPLACE (x.intm_no, '#')
                              --AND aging_id = REPLACE(v_aging_id, '#')
                              AND b.user_id = p_user_id)
                       LOOP
                          v_details.param_date := gi.param_date;
                          v_details.user_id := gi.user_id;
                          v_details.company_name := gi.company_name;
                          v_details.intm_no := gi.intm_no;
                          v_details.intm_name := gi.intm_name;
                          v_details.address := gi.address;
                          v_details.address2 := gi.address2;
                          v_details.address3 := gi.address3;
                          v_details.policy_no := gi.policy_no;
                          v_details.policy_term := gi.policy_term;
                          v_details.invoice_num := gi.invoice_num;
                          v_details.balance_amt_due := gi.balance_amt_due;
                         -- v_details.aging_id := g.aging_id;
                          PIPE ROW (v_details);
                       END LOOP;
                    END IF;
                 END LOOP;
            /*END IF;
        END LOOP;*/
         
         
      ELSIF p_print_btn_no = 4 -- list of aging 
      THEN
      
        FOR y IN (SELECT DISTINCT gagp_aging_id AS aging_id --'#' ||gagp_aging_id || '#' AS aging_id
                     FROM giac_aging_totals_v
                    WHERE balance_amt_due != 0)
         LOOP
            v_aging_id := '#' || y.aging_id || '#';
         
            IF INSTR (v_selected_aging_id, v_aging_id) != 0
            THEN
            
                    FOR x IN (SELECT distinct intm_no intm_no --'#' || intm_no || '#' AS intm_no
                             FROM giac_soa_rep_ext  -- giac_aging_intm_v 	                  
                            WHERE balance_amt_due != 0 
                              AND intm_no != 0
                              AND aging_id = REPLACE(v_aging_id, '#') )
                 LOOP
                    v_intm_no := '#' || x.intm_no || '#';
                    
                    IF INSTR (p_intm_no, v_intm_no) != 0
                    THEN                
            
            
                       FOR gi IN
                          (SELECT a.intm_no, c.policy_no,
                                     b.iss_cd
                                  || b.prem_seq_no
                                  || '-'
                                  || b.inst_no AS invoice_num,
                                  b.param_date, b.user_id, a.intm_name,
                                  giisp.v ('COMPANY_NAME') AS company_name,
                                  DECODE (bill_addr1, '.', NULL, bill_addr1) address,
                                  DECODE (bill_addr2,
                                          '.', NULL,
                                          bill_addr2
                                         ) address2,
                                  DECODE (bill_addr3,
                                          '.', NULL,
                                          bill_addr3
                                         ) address3,
                                     TO_CHAR (c.incept_date,
                                              'MM/DD/RRRR'
                                             )
                                  || ' - '
                                  || TO_CHAR (c.expiry_date, 'MM/DD/RRRR')
                                                                      AS policy_term,
                                  prem_bal_due, tax_bal_due, balance_amt_due
                             FROM giis_intermediary a,
                                  giac_soa_rep_ext b,
                                  (SELECT y.iss_cd, y.prem_seq_no,
                                          get_policy_no (x.policy_id) AS policy_no,
                                          x.incept_date, x.expiry_date
                                     FROM gipi_polbasic x, gipi_invoice y
                                    WHERE x.policy_id = y.policy_id) c
                            WHERE a.intm_no = b.intm_no
                              AND b.iss_cd = c.iss_cd
                              AND b.prem_seq_no = c.prem_seq_no
                              AND balance_amt_due != 0
                              AND a.intm_no = REPLACE (v_intm_no, '#')
                              AND b.aging_id = REPLACE (v_aging_id, '#')
                              AND b.user_id = p_user_id)
                       LOOP
                          v_details.param_date := gi.param_date;
                          v_details.user_id := gi.user_id;
                          v_details.company_name := gi.company_name;
                          v_details.intm_no := gi.intm_no;
                          v_details.intm_name := gi.intm_name;
                          v_details.address := gi.address;
                          v_details.address2 := gi.address2;
                          v_details.address3 := gi.address3;
                          v_details.policy_no := gi.policy_no;
                          v_details.policy_term := gi.policy_term;
                          v_details.invoice_num := gi.invoice_num;
                          v_details.balance_amt_due := gi.balance_amt_due;
                          PIPE ROW (v_details);
                       END LOOP;
                    END IF;
                 END LOOP;
            END IF;
         END LOOP;
      END IF;
   END;

   FUNCTION get_report_signatory (
        p_report_id giac_documents.report_id%TYPE,
        p_useR_id   giac_soa_rep_ext.user_id%TYPE,
        p_intm_no   giac_soa_rep_ext.intm_no%TYPE
   )
      RETURN g_giacr190a_signatory_tab PIPELINED
   IS
      v_details   g_giacr190a_signatory_type;
   BEGIN
       FOR rec IN (SELECT DISTINCT param_date              
                FROM giac_soa_rep_ext
               WHERE user_id= p_user_id
                 AND intm_no= p_intm_no)
      LOOP
        IF rec.param_date IS NOT NULL THEN              
           v_details.cut_off_Date := rec.param_date;
        ELSE
             v_details.cut_off_Date:=LAST_DAY(SYSDATE);  
        END IF;	
      END LOOP;
   
   
      FOR gi IN
         (SELECT   item_no, b.label,
                   NVL (c.signatory,
                        '_________________________________'
                       ) AS signatory,
                   NVL (c.designation,
                        '_________________________________'
                       ) AS designation,
                   a.remarks
              FROM giac_documents a,
                   giac_rep_signatory b,
                   giis_signatory_names c
             WHERE a.report_no = b.report_no
               AND b.signatory_id = c.signatory_id
               AND a.report_id = 'GIACR190A'
          ORDER BY b.item_no ASC)
      LOOP
         v_details.item_no := gi.item_no;
         v_details.label := gi.label;
         v_details.signatory := gi.signatory;
         v_details.designation := gi.designation;
         v_details.remarks := gi.remarks;
         PIPE ROW (v_details);
      END LOOP;

      IF v_details.item_no IS NULL OR v_details.item_no = ''
      THEN
         v_details.label := '';
         v_details.signatory := '_________________________________';
         v_details.designation := '_________________________________';
         v_details.remarks := '';
         PIPE ROW (v_details);
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_details.label := '';
         v_details.signatory := '_________________________________';
         v_details.designation := '_________________________________';
         v_details.remarks := '';
         PIPE ROW (v_details);
   END;
END;
/


