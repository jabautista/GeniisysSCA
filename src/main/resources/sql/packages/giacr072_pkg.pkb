CREATE OR REPLACE PACKAGE BODY CPI.GIACR072_PKG
AS
   FUNCTION generate_giacr072 (
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
      FOR i IN (SELECT a.branch_cd, a.memo_type, a.memo_year, a.memo_seq_no,
                       b.tran_date, b.posting_date, a.recipient, a.particulars, a.local_amt,
                       DECODE(c.or_no, NULL,NULL,c.or_pref_suf || '-' || c.or_no) or_no, c.or_date,
                       c.particulars particulars2, d.amount
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
                SELECT a.branch_cd, a.memo_type, a.memo_year, a.memo_seq_no,
                       b.tran_date, b.posting_date, a.recipient, a.particulars, a.local_amt,
                       NULL or_no, NULL or_date, NULL particulars2, NULL amount
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
                   AND TRUNC (c.or_date) > TO_DATE(p_cutoff_date, 'mm-dd-yyyy'))
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.memo_type := i.memo_type;
         v_list.memo_year := i.memo_year;
         v_list.memo_seq_no := i.memo_seq_no;
         v_list.tran_date := i.tran_date;
         v_list.posting_date := i.posting_date;
         v_list.recipient := i.recipient;
         v_list.particulars := i.particulars;
         v_list.local_amt := i.local_amt;
         v_list.or_no := i.or_no;
         v_list.or_date := i.or_date;
         v_list.particulars2 := i.particulars2;
         v_list.amount := i.amount;
	     v_list.cm_no := i.memo_type || '-' || i.memo_year|| '-' || LTRIM (TO_CHAR (i.memo_seq_no, '099999')); -- added by robert SR 5199 02.22.16
         v_list.memo_type_desc := GET_RV_MEANING('GIAC_CM_DM.MEMO_TYPE',i.memo_type); -- added by robert SR 5199 02.22.16
         BEGIN
            SELECT branch_name
              INTO v_list.branch_name
              FROM giac_branches
             WHERE branch_cd = i.branch_cd; 
         END;
         
         IF v_list.company_name IS NULL THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;
         
         IF v_list.cutoff_date IS NULL THEN
            v_list.cutoff_date := TRIM(TO_CHAR(TO_DATE (p_cutoff_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_cutoff_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         IF v_list.from_date IS NULL THEN
            v_list.from_date := TRIM(TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_from_date, 'MM-DD-YYYY'), ' DD, YYYY');
            v_list.to_date := TRIM(TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), 'Month')) ||  TO_CHAR(TO_DATE (p_to_date, 'MM-DD-YYYY'), ' DD, YYYY');
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END generate_giacr072;
   
END;
/


