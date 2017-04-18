CREATE OR REPLACE PACKAGE BODY CPI.gicls266_pkg
AS
/*Modified by pjsantos 11/10/2016, for optimization GENQA 5835*/
   FUNCTION get_intermediary_lov_list (p_user_id            VARCHAR2,
                                       p_search_string      VARCHAR2,
                                       p_find_text          VARCHAR2,
                                       p_intm_no            VARCHAR2,
                                       p_intm_name          VARCHAR2,
                                       p_order_by           VARCHAR2,      
                                       p_asc_desc_flag      VARCHAR2,      
                                       p_first_row          NUMBER,        
                                       p_last_row           NUMBER)
      RETURN get_intermediary_lov_tab PIPELINED
   IS
      v_list   get_intermediary_lov_type;      
      TYPE cur_type IS REF CURSOR;     
      c        cur_type;                
      v_sql    VARCHAR2(32767);         

   BEGIN
     -- FOR i IN(
     /*Comment out by pjsantos 09/14/2016, replaced by code below for optimization*/
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT   intm_no, intm_name,
                              NULL recovery_details_count
              FROM giis_intermediary a
             WHERE intm_no IN (
                      SELECT intm_no
                        FROM gicl_intm_itmperil
                       WHERE claim_id IN (
                                SELECT claim_id 
                                  FROM gicl_claims z  
                                 WHERE EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''CL'', ''GICLS266'','''||p_user_id||'''))
                                WHERE branch_cd = z.iss_cd))) ';
      IF p_search_string IS NOT NULL
        THEN
          v_sql := v_sql ||' AND (UPPER(INTM_NAME) LIKE '''||REPLACE(UPPER(p_search_string),'''','''''')||'''
                 OR TO_CHAR(INTM_NO) LIKE '''||REPLACE(p_search_string,'''','''''') || ''') ';
      END IF;           
      IF p_find_text IS NOT NULL
        THEN
          v_sql := v_sql ||' AND (UPPER(INTM_NAME) LIKE '''||REPLACE(UPPER(p_find_text),'''','''''')||'''
                 OR TO_CHAR(INTM_NO) LIKE '''||REPLACE(p_find_text,'''','''''') || ''') '; 
      END IF;                               
                                
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'intmNo'
         THEN        
          v_sql := v_sql || ' ORDER BY intm_no ';
        ELSIF  p_order_by = 'intmName'
         THEN
          v_sql := v_sql || ' ORDER BY intm_name ';               
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      ELSE
           v_sql := v_sql || ' ORDER BY 1 ';
      END IF;
    
    v_sql := v_sql || ') innersql ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
   
 
 
    OPEN c FOR v_sql;   
      LOOP
      FETCH c INTO 
       v_list.count_,
       v_list.rownum_,
       v_list.intm_no,
       v_list.intm_name,
       v_list.recovery_details_count;
        /* v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;*/

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_details_count
              FROM gicl_clm_recovery
             WHERE claim_id IN (SELECT claim_id
                                  FROM gicl_claims
                                 WHERE claim_id IN (SELECT claim_id
                                                      FROM gicl_intm_itmperil
                                                     WHERE intm_no = v_list.intm_no));
         END;

         EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_list);
      END LOOP;      
      CLOSE c;       

      RETURN;
   END get_intermediary_lov_list;

   FUNCTION get_clm_list_per_intermediary (
      p_user_id         VARCHAR2,
      p_intm_no         giis_intermediary.intm_no%TYPE,
      p_recovery_sw     VARCHAR2,
      p_claim_no        VARCHAR2,
      p_policy_no       VARCHAR2,
      p_assured_name    VARCHAR2,
      p_clm_file_date   VARCHAR2,
      p_loss_date       VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN clm_list_per_intermediary_tab PIPELINED
   IS
      v_list   clm_list_per_intermediary_type;
   BEGIN
      FOR i IN
         (SELECT a.claim_id, get_clm_no (a.claim_id) claim_no, a.peril_cd,
                 a.item_no, b.line_cd,
                 (   b.line_cd
                  || '-'
                  || b.subline_cd
                  || '-'
                  || b.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (b.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (b.renew_no, '09'))
                 ) policy_no,
                 b.assured_name, b.loss_date, b.clm_file_date, b.entry_date,
                 b.recovery_sw
            FROM gicl_intm_itmperil a, gicl_claims b
           WHERE a.claim_id = b.claim_id
             AND a.intm_no = p_intm_no
             AND a.claim_id IN (
                    SELECT claim_id
                      FROM gicl_claims
                     WHERE check_user_per_line2 (line_cd,
                                                 iss_cd,
                                                 'GICLS266',
                                                 p_user_id
                                                ) = 1)
             AND UPPER (b.recovery_sw) LIKE
                                    UPPER (NVL (p_recovery_sw, b.recovery_sw))
             AND UPPER (get_clm_no (a.claim_id)) LIKE
                             UPPER (NVL (p_claim_no, get_clm_no (a.claim_id)))
             AND UPPER ((   b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09'))
                        )
                       ) LIKE
                    UPPER (NVL (p_policy_no,
                                (   b.line_cd
                                 || '-'
                                 || b.subline_cd
                                 || '-'
                                 || b.pol_iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (b.issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.renew_no, '09'))
                                )
                               )
                          )
             AND UPPER (b.assured_name) LIKE
                                  UPPER (NVL (p_assured_name, b.assured_name))
             AND TRUNC (b.clm_file_date) =
                    NVL (TO_DATE (p_clm_file_date, 'mm-dd-yyyy'),
                         TRUNC (b.clm_file_date)
                        )
             AND TRUNC (b.loss_date) =
                    NVL (TO_DATE (p_loss_date, 'mm-dd-yyyy'),
                         TRUNC (b.loss_date)
                        )
             AND (   (    (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC (b.loss_date),
                                   'fileDate', TRUNC (b.clm_file_date)
                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                          )
                      AND (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC (b.loss_date),
                                   'fileDate', TRUNC (b.clm_file_date)
                                  ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                          )
                     )
                  OR (DECODE (p_search_by_opt,
                              'lossDate', TRUNC (b.loss_date),
                              'fileDate', TRUNC (b.clm_file_date)
                             ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                     )
                 ))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.claim_no := get_clm_no (i.claim_id);
         v_list.peril_cd := i.peril_cd;
         v_list.item_no := i.item_no;
         v_list.line_cd := i.line_cd;
         v_list.policy_no := i.policy_no;
         v_list.assured_name := i.assured_name;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.entry_date := i.entry_date;
         v_list.recovery_sw := i.recovery_sw;

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
             WHERE claim_id = i.claim_id;
         END;

         BEGIN
            SELECT COUNT (loss_reserve)
              INTO v_list.claim_det_count
              FROM gicl_clm_reserve
             WHERE claim_id = i.claim_id;
         END;

         BEGIN
            SELECT a.clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat a, gicl_claims b
             WHERE a.clm_stat_cd = b.clm_stat_cd AND b.claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;

         BEGIN
            SELECT a.loss_cat_des
              INTO v_list.loss_cat_desc
              FROM giis_loss_ctgry a, gicl_claims b
             WHERE a.loss_cat_cd = b.loss_cat_cd
               AND a.line_cd = b.line_cd
               AND b.claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_cat_desc := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_list_per_intermediary;

   FUNCTION get_claim_details (
      p_claim_id   NUMBER,
      p_peril_cd   VARCHAR2,
      p_item_no    NUMBER,
      p_line_cd    VARCHAR2
   )
      RETURN claim_details_tab PIPELINED
   IS
      v_list   claim_details_type;
   BEGIN
      FOR i IN (SELECT item_no, peril_cd, grouped_item_no,
                       NVL (loss_reserve, 0) loss_reserve,
                       NVL (expense_reserve, 0) expense_reserve,
                       NVL (losses_paid, 0) losses_paid,
                       NVL (expenses_paid, 0) expenses_paid
                  FROM gicl_clm_reserve
                 WHERE claim_id = p_claim_id
                                            --AND peril_cd = p_peril_cd
                                            --AND item_no  = item_no
              )
      LOOP
         v_list.item_no := TO_CHAR (i.item_no, '09999');
         v_list.peril_cd := i.peril_cd;
         v_list.item_title :=
            get_gpa_item_title (p_claim_id,
                                p_line_cd,
                                p_item_no,
                                NVL (i.grouped_item_no, 0)
                               );
         v_list.loss_reserve := i.loss_reserve;
         v_list.expense_reserve := i.expense_reserve;
         v_list.losses_paid := i.losses_paid;
         v_list.expenses_paid := i.expenses_paid;

         BEGIN
            SELECT peril_name
              INTO v_list.peril_name
              FROM giis_peril
             WHERE line_cd = p_line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.peril_name := NULL;
         END;

         BEGIN
            SELECT DISTINCT shr_intm_pct
                       INTO v_list.shr_intm_pct
                       FROM gicl_intm_itmperil
                      WHERE claim_id = p_claim_id AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.shr_intm_pct := NULL;
         END;

         IF v_list.tot_loss_reserve IS NULL
         THEN
            BEGIN
               SELECT SUM (NVL (loss_reserve, 0)),
                      SUM (NVL (expense_reserve, 0)),
                      SUM (NVL (losses_paid, 0)),
                      SUM (NVL (expenses_paid, 0))
                 INTO v_list.tot_loss_reserve,
                      v_list.tot_expense_reserve,
                      v_list.tot_losses_paid,
                      v_list.tot_expenses_paid
                 FROM gicl_clm_reserve
                WHERE claim_id = p_claim_id;
            END;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_claim_details;
END;
/


