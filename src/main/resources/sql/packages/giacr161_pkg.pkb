CREATE OR REPLACE PACKAGE BODY CPI.GIACR161_PKG
AS
   /*
   **  Created by   :  Melvin John O. Ostia
   **  Date Created : 06.20.2013
   **  Description : GIACR161_PKG - Premium Deposit
   */
   FUNCTION cf_companyformula
      RETURN VARCHAR2
   IS
      v_company   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v
        INTO v_company
        FROM giac_parameters
       WHERE param_name = 'COMPANY_NAME';
      RETURN (v_company);
   END;

   FUNCTION cf_addressformula
      RETURN VARCHAR2
   IS
      v_add   VARCHAR2 (300);
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM giac_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
   END;

   FUNCTION cf_branch_nameformula (p_branch_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_branch   VARCHAR2 (250);
   BEGIN
      SELECT branch_name
        INTO v_branch
        FROM giac_branches
       WHERE branch_cd = p_branch_cd;

      RETURN (v_branch);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_branch := 'NO BRANCH NAME IN GIAC_BRANCHES';
         RETURN (v_branch);
      WHEN TOO_MANY_ROWS
      THEN
         v_branch := 'TOO MANY BRANCH NAME IN GIAC_BRANCHES';
         RETURN (v_branch);
   END;

   FUNCTION cf_cutoffformula(
      p_user_id         GIIS_USERS.user_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_cutoff   DATE;
   BEGIN
      SELECT DISTINCT cutoff_date
                 INTO v_cutoff
                 FROM giac_premdeposit_ext
                WHERE user_id = p_user_id;

      RETURN (TO_CHAR (v_cutoff, 'fmMonth DD, RRRR'));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_cutoff := SYSDATE;
         RETURN (TO_CHAR (v_cutoff, 'fmMonth DD, RRRR'));
   END;

   FUNCTION cf_fromformula(
      p_user_id         GIIS_USERS.user_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_from   DATE;
   BEGIN
      SELECT DISTINCT from_date
                 INTO v_from
                 FROM giac_premdeposit_ext
                WHERE user_id = p_user_id;

      RETURN (TO_CHAR (v_from, 'fmMonth DD, RRRR'));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_from := SYSDATE;
         RETURN (TO_CHAR (v_from, 'fmMonth DD, RRRR'));
   END;

   FUNCTION cf_toformula(
      p_user_id         GIIS_USERS.user_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_to   DATE;
   BEGIN
      SELECT DISTINCT TO_DATE
                 INTO v_to
                 FROM giac_premdeposit_ext
                WHERE user_id = p_user_id;

      RETURN (TO_CHAR (v_to, 'fmMonth DD, RRRR'));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_to := SYSDATE;
         RETURN (TO_CHAR (v_to, 'fmMonth DD, RRRR'));
   END;

   FUNCTION cf_date_flagformula(
      p_user_id         GIIS_USERS.user_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_date_flag   VARCHAR2 (1);
   BEGIN
      FOR c IN (SELECT date_flag
                  FROM giac_premdeposit_ext
                 WHERE user_id = p_user_id)
      LOOP
         v_date_flag := c.date_flag;
         EXIT;
      END LOOP;

      IF v_date_flag = 'T'
      THEN
         RETURN ('By Transaction Date');
      ELSE
         RETURN ('By Posting Date');
      END IF;
   END;

   FUNCTION get_giacr161_records (
      p_assd_no     VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_date_from   DATE,
      p_date_to     DATE,
      p_dep_flag    VARCHAR2,
      p_switch      VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr161_record_tab PIPELINED
   IS
      v_list      giacr161_record_type;
      v_company   VARCHAR2 (200);
      v_add       VARCHAR2 (300);
      v_branch    VARCHAR2 (250);
      v_total_colln NUMBER;
      v_exists    VARCHAR2(1) := 'N';
   BEGIN
      v_list.d_flag := cf_date_flagformula(p_user_id);
      v_list.d_to := cf_toformula(p_user_id);
      v_list.d_from := cf_fromformula(p_user_id);
      v_list.cutoff := cf_cutoffformula(p_user_id);
      v_list.company_name := cf_companyformula;
      v_list.address := cf_addressformula;
   
      FOR i IN
         (SELECT   b.upload_tag, b.or_tag, a.tran_date, a.tran_id,
                   /*DECODE (a.tran_class,
                           'COL', a.tran_class
                            || ' '
                            || SUBSTR (ref_no, 1, 5)
                            || DECODE (LPAD (SUBSTR (ref_no, 6), 10, '0'),
                                       NULL, NULL,
                                       LPAD (SUBSTR (ref_no, 6), 10, '0')
                                      ),
                              a.tran_class
                           || ' '
                           || SUBSTR (a.ref_no, 1, 2)
                           || '-'
                           || LPAD (SUBSTR (a.ref_no, 3), 6, '0')
                          ) ref_class*/  
                          get_ref_no(a.tran_id) ref_class, --replaced by john 11.25.2014
                   
/*dean 08052011 to add leading zeros on ref_no*/
/*modified by joms to correct leading zeros on ref no. from substring 7 to 6, and removed excess '-'*/
                   a.item_no, a.collection_amt, a.assd_no, a.assured_name,
                   a.remarks, a.rev_tran_date,
                   DECODE
                      (a.rev_tran_class,
                       'JV', a.rev_tran_class
                        || ' '
                        || a.rev_tran_class
                        || '-'
                        || LPAD (SUBSTR (a.rev_ref_no,
                                         LENGTH (a.rev_tran_class) + 1
                                        ),
                                 6,
                                 '0'
                                ),
                       'DV', DECODE (SUBSTR (a.rev_ref_no, 1, 5),
                                     'OTHER', a.rev_tran_class || ' '
                                      || a.rev_ref_no,
                                        a.rev_tran_class
                                     || ' '
                                     || a.rev_tran_class
                                     || '-'
                                     || LPAD
                                           (SUBSTR (a.rev_ref_no,
                                                      LENGTH (a.rev_tran_class)
                                                    + 2
                                                   ),
                                            6,
                                            '0'
                                           )
                                    ),
                       'COL', a.rev_tran_class
                        || ' '
                        || SUBSTR (a.rev_ref_no, 1, 5)
                        || '-'
                        || LPAD (SUBSTR (a.rev_ref_no, 6), 10, '0')
                      ) rev_ref_class,
                   
                   /*dean 08052011 to add leading zeros to reversing ref no*/
                   /*modified by joms to correct leading zeros on ref no. from substring 7 to 6*/
                   a.rev_coll_amt, a.rev_tran_id,
                   NVL (a.balance, a.collection_amt) balance, a.from_date,
                   a.TO_DATE, a.branch_cd, a.cutoff_date, a.date_flag,
                      TO_CHAR (a.tran_year, 'fm0000')
                   || '-'
                   || TO_CHAR (a.tran_month, 'fm00')
                   || '-'
                   || TO_CHAR (NVL (a.tran_seq_no, 0), 'fm000000') tran,
                   DECODE (a.rev_tran_year,
                           NULL, NULL,
                           (   TO_CHAR (a.rev_tran_year, 'fm0000')
                            || '-'
                            || TO_CHAR (a.rev_tran_month, 'fm00')
                            || '-'
                            || TO_CHAR (NVL (a.rev_tran_seq_no, 0),
                                        'fm000000')
                           )
                          ) rev_tran,
                   a.dep_flag
              FROM giac_premdeposit_ext a, giac_prem_deposit b
             WHERE (   (    p_assd_no = '000'
                        AND a.assured_name LIKE ('No Assured Specified')
                       )
                    OR (    p_assd_no IS NOT NULL
                        AND a.assd_no = (TO_CHAR (p_assd_no))
                       )
                    OR (    p_assd_no IS NULL
                        AND NVL (a.assd_no, 10001) = NVL (a.assd_no, 10001)
                       )
                   )
               AND a.branch_cd = NVL (p_branch_cd, a.branch_cd)
               AND a.dep_flag = NVL (p_dep_flag, a.dep_flag)
               AND a.user_id = NVL (p_user_id, a.user_id)
               AND b.gacc_tran_id = a.tran_id
               AND a.item_no = b.item_no                   -- judyann 11292007
          ORDER BY 1, 2, 4)
      LOOP
         v_exists := 'Y';
--         v_list.d_flag := cf_date_flagformula;
--         v_list.d_to := cf_toformula;
--         v_list.d_from := cf_fromformula;
--         v_list.cutoff := cf_cutoffformula;
--         v_list.company_name := cf_companyformula;
--         v_list.address := cf_addressformula;
         v_list.branch_name := cf_branch_nameformula (i.branch_cd);
         v_list.upload_tag := i.upload_tag;
         v_list.or_tag := i.or_tag;
         v_list.tran_date := i.tran_date;
         v_list.tran_id := i.tran_id;
         v_list.ref_class := i.ref_class;
         v_list.item_no := i.item_no;
         v_list.collection_amt := i.collection_amt;
         v_list.assd_no := i.assd_no;
         v_list.assured_name := i.assured_name;
         v_list.remarks := i.remarks;
         v_list.rev_tran_date := i.rev_tran_date;
         v_list.rev_ref_class := i.rev_ref_class;
         v_list.rev_coll_amt := i.rev_coll_amt;
         v_list.rev_tran_id := i.rev_tran_id;
         
         
            BEGIN
               SELECT   SUM (rev_coll_amt)
                   INTO v_total_colln
                   FROM giac_premdeposit_ext
                  WHERE tran_id = i.tran_id AND item_no = i.item_no AND user_id = p_user_id
               GROUP BY tran_id;


               IF v_total_colln IS NOT NULL
               THEN
                  v_list.balance := i.collection_amt + v_total_colln;
               ELSE
                   v_list.balance := i.collection_amt;
               END IF;
            END;
      
         --v_list.balance := i.balance;
         v_list.from_date := i.from_date;
         v_list.TO_DATE := i.TO_DATE;
         v_list.branch_cd := i.branch_cd;
         v_list.cutoff_date := i.cutoff_date;
         v_list.date_flag := i.date_flag;
         v_list.tran := i.tran;
         v_list.rev_tran := i.rev_tran;
         v_list.dep_flag := i.dep_flag;
        
         
         IF p_switch = 'A'
         THEN
            v_list.v_for_zero_bal := 1; 
         ELSE
            IF p_switch = 'B'
            THEN
                IF i.balance = 0
                THEN
                    v_list.v_for_zero_bal := 0; 
                ELSE
                    v_list.v_for_zero_bal := 1; 
                END IF;
            END IF;
         END IF;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_exists = 'N' THEN
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giacr161_records;
END;
/


