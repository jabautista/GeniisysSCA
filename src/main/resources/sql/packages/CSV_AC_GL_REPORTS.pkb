CREATE OR REPLACE PACKAGE BODY CPI.CSV_AC_GL_REPORTS
AS
/*
**  Created by   : Dren Niebres 
**  Date Created : 03.04.2016
**  Reference By : GIACR072 - Credit/Debit Memo Listing
*/
   FUNCTION csv_giacr072 (
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2,
      p_memo_type   VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_date_opt    VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_cutoff_date VARCHAR2
   )
      RETURN giacr072_tab PIPELINED
   IS
      v_list giacr072_type;
   BEGIN
      FOR i IN (SELECT a.branch_cd, a.memo_type || '-' || a.memo_year || '-' || a.memo_seq_no cm_no,
                       b.tran_date, b.posting_date, a.recipient, a.particulars, a.local_amt,
                       DECODE(c.or_no, NULL,NULL,c.or_pref_suf || '-' || c.or_no) or_no, c.or_date,
                       c.particulars particulars2, d.amount, a.memo_seq_no, a.memo_type, a.memo_year
                  FROM giac_cm_dm a, giac_acctrans b, giac_order_of_payts c, giac_collection_dtl d
                 WHERE b.tran_id = a.gacc_tran_id
                   AND d.cm_tran_id(+) = a.gacc_tran_id
                   AND c.gacc_tran_id(+) = d.gacc_tran_id
                   AND a.branch_cd = NVL (UPPER (p_branch_cd), a.branch_cd)
                   AND check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, p_module_id, p_user_id) = 1  
                   AND a.memo_type = NVL (UPPER (p_memo_type), a.memo_type)
                   AND DECODE (UPPER (p_date_opt), 'T', b.tran_date, 'P', b.posting_date)
                       BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy') AND NVL (TRUNC (c.or_date), TO_DATE(p_cutoff_date, 'mm-dd-yyyy')) <= TO_DATE(p_cutoff_date, 'mm-dd-yyyy')                       
                 UNION
                SELECT a.branch_cd, a.memo_type || '-' || a.memo_year || '-' || a.memo_seq_no cm_no,
                       b.tran_date, b.posting_date, a.recipient, a.particulars, a.local_amt,
                       NULL or_no, NULL or_date, NULL particulars2, NULL amount, a.memo_seq_no, a.memo_type, a.memo_year
                  FROM giac_cm_dm a,
                       giac_acctrans b,
                       giac_order_of_payts c,
                       giac_collection_dtl d
                 WHERE b.tran_id = a.gacc_tran_id
                   AND d.cm_tran_id(+) = a.gacc_tran_id
                   AND c.gacc_tran_id(+) = d.gacc_tran_id
                   AND a.branch_cd = NVL (UPPER (p_branch_cd), a.branch_cd)
                   AND check_user_per_iss_cd_acctg2 (NULL, a.branch_cd, p_module_id, p_user_id) = 1 
                   AND a.memo_type = NVL (UPPER (p_memo_type), a.memo_type)
                   AND DECODE (UPPER (p_date_opt), 'T', b.tran_date, 'P', b.posting_date) BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy') AND TO_DATE(p_to_date, 'mm-dd-yyyy')
                   AND TRUNC (c.or_date) > TO_DATE(p_cutoff_date, 'mm-dd-yyyy')
              ORDER BY branch_cd, memo_type, memo_year, memo_seq_no, tran_date, posting_date, recipient, particulars)
      LOOP
         v_list.branch_code := i.branch_cd;
         v_list.cm_no := i.cm_no;
         v_list.transaction_date := i.tran_date;
         v_list.posting_date := i.posting_date;
         v_list.recipient := i.recipient;
         v_list.particulars := i.particulars;
         v_list.amount := i.local_amt;
         v_list.or_no := i.or_no;
         v_list.or_date := i.or_date;
         v_list.or_particulars := i.particulars2;
         v_list.or_amount := i.amount;
         
         BEGIN
            SELECT branch_name
              INTO v_list.branch_name
              FROM giac_branches
             WHERE branch_cd = i.branch_cd; 
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END csv_giacr072;   
END;
/


