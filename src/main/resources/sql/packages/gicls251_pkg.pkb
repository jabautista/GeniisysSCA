CREATE OR REPLACE PACKAGE BODY CPI.gicls251_pkg
AS
   FUNCTION get_assured_lov (p_user_id VARCHAR2,
                             p_module_id VARCHAR2,
                             p_find_text            VARCHAR2,
                             p_order_by             VARCHAR2,
                             p_asc_desc_flag   VARCHAR2,
                             p_from                 NUMBER,
                             p_to                   NUMBER,
                             p_search_string         VARCHAR2
                            ) -- added By MarkS 11.11.2016 SR5836 optimization
                             
      RETURN assured_lov_tab PIPELINED
   IS
      v_list   assured_lov_type;
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   assured_lov_type;
      v_sql   VARCHAR2(32767);

   BEGIN
   -- added By MarkS 11.11.2016 SR5836 optimization
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT DISTINCT a.assd_no, b.assd_name
                                       FROM gicl_claims a, giis_assured b
                                    WHERE
                                        EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''CL'',''' || p_module_id || ''',''' ||p_user_id || '''))
                                                                            WHERE LINE_CD= a.line_cd and BRANCH_CD = a.iss_cd) -- added By MarkS 11.10.2016 SR5836 optimization
                                        AND a.assd_no = b.assd_no ';
                                    
       IF p_find_text IS NOT NULL
       THEN
            v_sql := v_sql || '         AND (   UPPER(b.assd_name) LIKE UPPER(''' || p_find_text || ''')
                                                OR a.assd_no LIKE UPPER(''' ||p_find_text|| ''')
                                            )';
       ELSIF p_search_string IS NOT NULL THEN 
            v_sql := v_sql || '         AND (   UPPER(b.assd_name) LIKE UPPER(''' || p_search_string || ''')
                                                OR a.assd_no LIKE UPPER(''' ||p_search_string|| ''')
                                            )';
       END IF;
       
      IF p_order_by IS NOT NULL
       THEN
        IF p_order_by = 'assdNo'
        THEN        
          v_sql := v_sql || ' ORDER BY a.assd_no ';
        ELSIF p_order_by = 'assdName'
        THEN
          v_sql := v_sql || ' ORDER BY b.assd_name ';                                       
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL 
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
                                    
       v_sql := v_sql || '          ) innersql      
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;     
      OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.assd_no, 
                      v_rec.assd_name;                            
         EXIT WHEN c%NOTFOUND; 
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
      RETURN;       
   ---------------------------
   -- commented By MarkS 11.11.2016 SR5836 optimization
--   FOR i IN (SELECT DISTINCT a.assd_no, b.assd_name
--                           FROM gicl_claims a, giis_assured b
--                          WHERE line_cd = DECODE (check_user_per_line2 (line_cd, iss_cd, 'GICLS251', p_user_id), 1, line_cd, NULL)
--                            AND a.assd_no = b.assd_no
--                       ORDER BY a.assd_no)
--      LOOP
--         v_list.assd_no := i.assd_no;
--         v_list.assd_name := i.assd_name;
--         BEGIN
--            SELECT COUNT (*)
--              INTO v_list.recovery_details_count
--              FROM gicl_clm_recovery
--             WHERE claim_id IN (SELECT claim_id
--                                  FROM gicl_claims
--                                 WHERE assd_no = i.assd_no
--                                   AND line_cd = DECODE (check_user_per_line2 (line_cd, iss_cd, 'GICLS251', p_user_id), 1, line_cd, NULL));
--         END;
--         PIPE ROW (v_list);
--      END LOOP;
--      RETURN;
   ---------------------------
   END;

   FUNCTION get_clm_list_per_assured (
      p_module_id       VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_assd_no         gicl_claims.assd_no%TYPE,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_to         VARCHAR2,
      p_date_from       VARCHAR2,
      p_recovery_sw     VARCHAR2,
      p_claim_number    VARCHAR2,
      p_free_text       VARCHAR2,
      p_loss_res_amt    NUMBER,
      p_exp_res_amt     NUMBER,
      p_loss_pd_amt     NUMBER,
      p_exp_pd_amt      NUMBER
   )
      RETURN clm_list_per_assured_tab PIPELINED
   IS
      v_list   clm_list_per_assured_type;
   BEGIN
      FOR i IN
         (SELECT a.claim_id, a.assured_name free_text, a.line_cd,
                 a.subline_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                 a.pol_iss_cd, a.clm_yy, a.clm_seq_no, a.iss_cd, a.assd_no,
                 a.recovery_sw, a.clm_file_date, a.user_id, a.last_update,
                 a.dsp_loss_date, a.clm_stat_cd, a.loss_pd_amt,
                 a.loss_res_amt, a.exp_pd_amt, a.exp_res_amt, a.assured_name
            FROM gicl_claims a
           WHERE a.assd_no = p_assd_no
             AND check_user_per_line2 (a.line_cd, a.iss_cd, p_module_id, p_user_id) = 1
             AND (   (    (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(dsp_loss_date),
                                   'fileDate', TRUNC(clm_file_date)
                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                          )
                      AND (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(dsp_loss_date),
                                   'fileDate', TRUNC(clm_file_date)
                                  ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                          )
                     )
                  OR (DECODE (p_search_by_opt,
                              'lossDate', TRUNC(dsp_loss_date),
                                   'fileDate', TRUNC(clm_file_date)
                             ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                     )
                 )
             AND UPPER (a.recovery_sw) LIKE UPPER (NVL (p_recovery_sw, a.recovery_sw))
             AND UPPER (get_clm_no (a.claim_id)) LIKE UPPER (NVL (p_claim_number, get_clm_no (a.claim_id)))
             AND UPPER (a.assured_name) LIKE UPPER (NVL (p_free_text, a.assured_name))
             AND NVL (a.loss_res_amt, 0) = NVL (p_loss_res_amt, NVL (a.loss_res_amt, 0))
             AND NVL (a.exp_res_amt, 0) = NVL (p_exp_res_amt, NVL (a.exp_res_amt, 0))
             AND NVL (a.loss_pd_amt, 0) = NVL (p_loss_pd_amt, NVL (a.loss_pd_amt, 0))
             AND NVL (a.exp_pd_amt, 0) = NVL (p_exp_pd_amt, NVL (a.exp_pd_amt, 0))
             )
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.claim_number := get_claim_number (i.claim_id);
         v_list.free_text := i.free_text;
         v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
         v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
         v_list.loss_pd_amt := NVL (i.loss_pd_amt, 0);
         v_list.exp_pd_amt := NVL (i.exp_pd_amt, 0);
         v_list.policy_number :=
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || i.pol_iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '09'));
         v_list.clm_file_date := i.clm_file_date;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.recovery_sw := i.recovery_sw;

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
             WHERE claim_id = i.claim_id;
         END;

         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;

         IF v_list.tot_loss_res_amt IS NULL
         THEN
            FOR b IN
               (SELECT SUM (NVL (loss_res_amt, 0)) tot_loss_res_amt,
                       SUM (NVL (exp_res_amt, 0)) tot_exp_res_amt,
                       SUM (NVL (loss_pd_amt, 0)) tot_loss_pd_amt,
                       SUM (NVL (exp_pd_amt, 0)) tot_exp_pd_amt
                  FROM (SELECT a.claim_id, a.assured_name free_text,
                               a.line_cd, a.subline_cd, a.issue_yy,
                               a.pol_seq_no, a.renew_no, a.pol_iss_cd,
                               a.clm_yy, a.clm_seq_no, a.iss_cd, a.assd_no,
                               a.recovery_sw, a.clm_file_date, a.user_id,
                               a.last_update, a.dsp_loss_date, a.clm_stat_cd,
                               a.loss_pd_amt, a.loss_res_amt, a.exp_pd_amt,
                               a.exp_res_amt, a.assured_name
                          FROM gicl_claims a
                         WHERE a.assd_no = p_assd_no
                           AND check_user_per_line2 (a.line_cd, a.iss_cd, p_module_id, p_user_id) = 1
                           AND (   (    (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(dsp_loss_date),
                                   'fileDate', TRUNC(clm_file_date)
                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                                      )
                                  AND (DECODE (p_search_by_opt,
                                               'lossDate', TRUNC(dsp_loss_date),
                                               'fileDate', TRUNC(clm_file_date)
                                              ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                      )
                                 )
                              OR (DECODE (p_search_by_opt,
                                          'lossDate', TRUNC(dsp_loss_date),
                                               'fileDate', TRUNC(clm_file_date)
                                         ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                                 )
                             )
                           AND UPPER (a.recovery_sw) LIKE UPPER (NVL (p_recovery_sw, a.recovery_sw))
                           AND UPPER (get_clm_no (a.claim_id)) LIKE UPPER (NVL (p_claim_number, get_clm_no (a.claim_id)))
                           AND UPPER (a.assured_name) LIKE UPPER (NVL (p_free_text, a.assured_name))
                           AND NVL (a.loss_res_amt, 0) = NVL (p_loss_res_amt, NVL (a.loss_res_amt, 0))
             AND NVL (a.exp_res_amt, 0) = NVL (p_exp_res_amt, NVL (a.exp_res_amt, 0))
             AND NVL (a.loss_pd_amt, 0) = NVL (p_loss_pd_amt, NVL (a.loss_pd_amt, 0))
             AND NVL (a.exp_pd_amt, 0) = NVL (p_exp_pd_amt, NVL (a.exp_pd_amt, 0))))
            LOOP
               v_list.tot_loss_res_amt := b.tot_loss_res_amt;
               v_list.tot_exp_res_amt := b.tot_exp_res_amt;
               v_list.tot_loss_paid_amt := b.tot_loss_pd_amt;
               v_list.tot_exp_paid_amt := b.tot_exp_pd_amt;
            END LOOP;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_list_per_assured;

   FUNCTION get_per_assured_freetext (
      p_module_id       VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_free_text       VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_to         VARCHAR2,
      p_date_from       VARCHAR2,
      p_recovery_sw     VARCHAR2,
      p_claim_number    VARCHAR2,
      p_loss_res_amt    NUMBER,
      p_exp_res_amt     NUMBER,
      p_loss_pd_amt     NUMBER,
      p_exp_pd_amt      NUMBER
   )
      RETURN clm_list_per_assured_tab PIPELINED
   IS
      v_list   clm_list_per_assured_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM ((SELECT a.claim_id, a.assured_name free_text_search,
                                  'ASSURED - ' || a.assured_name free_text, 0,
                                  'assd' title, a.line_cd, a.subline_cd,
                                  a.issue_yy, a.pol_seq_no, a.renew_no,
                                  a.pol_iss_cd, a.clm_yy, a.clm_seq_no,
                                  a.iss_cd, a.assd_no, a.recovery_sw,
                                  a.clm_file_date, a.user_id, a.last_update,
                                  a.dsp_loss_date, a.clm_stat_cd,
                                  a.loss_pd_amt, a.loss_res_amt, a.exp_pd_amt,
                                  a.exp_res_amt, a.assured_name
                             FROM gicl_claims a
                           UNION
                           SELECT b.claim_id, b.item_title free_text_search,
                                  'ITEM - ' || b.item_title free_text,
                                  b.item_no, 'item' title, a.line_cd,
                                  a.subline_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.pol_iss_cd, a.clm_yy,
                                  a.clm_seq_no, a.iss_cd, a.assd_no,
                                  a.recovery_sw, a.clm_file_date, a.user_id,
                                  a.last_update, a.dsp_loss_date,
                                  a.clm_stat_cd, a.loss_pd_amt,
                                  a.loss_res_amt, a.exp_pd_amt, a.exp_res_amt,
                                  a.assured_name
                             FROM gicl_clm_item b, gicl_claims a
                            WHERE a.claim_id = b.claim_id
                           UNION
                           SELECT c.claim_id, c.grouped_item_title free_text_search,
                                     'GROUPED ITEM - '
                                  || c.grouped_item_title free_text,
                                  c.grouped_item_no, 'grp' title, a.line_cd,
                                  a.subline_cd, a.issue_yy, a.pol_seq_no,
                                  a.renew_no, a.pol_iss_cd, a.clm_yy,
                                  a.clm_seq_no, a.iss_cd, a.assd_no,
                                  a.recovery_sw, a.clm_file_date, a.user_id,
                                  a.last_update, a.dsp_loss_date,
                                  a.clm_stat_cd, a.loss_pd_amt,
                                  a.loss_res_amt, a.exp_pd_amt, a.exp_res_amt,
                                  a.assured_name
                             FROM gicl_claims a,
                                  gicl_clm_item b,
                                  gicl_accident_dtl c
                            WHERE c.claim_id = b.claim_id
                              AND a.claim_id = b.claim_id
                              AND c.item_no = b.item_no
                              AND c.grouped_item_no = b.grouped_item_no))
                   WHERE check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS251', p_user_id) = 1
                     AND UPPER (free_text) LIKE UPPER('%' || p_free_text ||'%') --modified by robert 01.06.2014
                     AND (   (    (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(dsp_loss_date),
                                   'fileDate', TRUNC(clm_file_date)
                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                                      )
                                  AND (DECODE (p_search_by_opt,
                                               'lossDate', TRUNC(dsp_loss_date),
                                               'fileDate', TRUNC(clm_file_date)
                                              ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                      )
                                 )
                              OR (DECODE (p_search_by_opt,
                                          'lossDate', TRUNC(dsp_loss_date),
                                               'fileDate', TRUNC(clm_file_date)
                                         ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                                 )
                             )
                         AND UPPER (recovery_sw) LIKE
                                    UPPER (NVL (p_recovery_sw, recovery_sw))
                           AND UPPER (get_clm_no (claim_id)) LIKE
                                  UPPER (NVL (p_claim_number,
                                              get_clm_no (claim_id)
                                             )
                                        )
                           AND UPPER (free_text_search) LIKE UPPER (NVL (p_free_text, free_text_search))
                           AND NVL (loss_res_amt, 0) = NVL (p_loss_res_amt, NVL (loss_res_amt, 0))
             AND NVL (exp_res_amt, 0) = NVL (p_exp_res_amt, NVL (exp_res_amt, 0))
             AND NVL (loss_pd_amt, 0) = NVL (p_loss_pd_amt, NVL (loss_pd_amt, 0))
             AND NVL (exp_pd_amt, 0) = NVL (p_exp_pd_amt, NVL (exp_pd_amt, 0))
                ORDER BY clm_seq_no
--             AND claim_id IN (
--                            SELECT claim_id
--                              FROM gicl_claims
--                             WHERE UPPER (assured_name) LIKE
--                                                           UPPER (p_free_text))
--             AND (   (    (DECODE (p_search_by_opt,
--                                   'lossDate', dsp_loss_date,
--                                   'fileDate', clm_file_date
--                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
--                          )
--                      AND (DECODE (p_search_by_opt,
--                                   'lossDate', dsp_loss_date,
--                                   'fileDate', clm_file_date
--                                  ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
--                          )
--                     )
--                  OR (DECODE (p_search_by_opt,
--                              'lossDate', dsp_loss_date,
--                              'fileDate', clm_file_date
--                             ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
--                     )
--                 )
              )
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.claim_number := get_clm_no (i.claim_id);
         v_list.assd_no := i.assd_no;
         v_list.free_text := i.free_text;
         v_list.assured_name := i.assured_name;
         v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
         v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
         v_list.loss_pd_amt := NVL (i.loss_pd_amt, 0);
         v_list.exp_pd_amt := NVL (i.exp_pd_amt, 0);
         v_list.recovery_sw := i.recovery_sw;
         v_list.policy_number :=
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || i.pol_iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '09'));
         v_list.clm_file_date := i.clm_file_date;
         v_list.dsp_loss_date := i.dsp_loss_date;

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
             WHERE claim_id = i.claim_id;
         END;

         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.clm_stat_desc := NULL;
         END;

         IF v_list.tot_loss_res_amt IS NULL
         THEN
            FOR b IN (SELECT SUM (NVL (loss_res_amt, 0)) tot_loss_res_amt,
                             SUM (NVL (exp_res_amt, 0)) tot_exp_res_amt,
                             SUM (NVL (loss_pd_amt, 0)) tot_loss_pd_amt,
                             SUM (NVL (exp_pd_amt, 0)) tot_exp_pd_amt
                        FROM ((SELECT a.claim_id, a.assured_name free_text_search,
                                      'ASSURED - '
                                      || a.assured_name free_text,
                                      0, 'assd' title, a.line_cd,
                                      a.subline_cd, a.issue_yy, a.pol_seq_no,
                                      a.renew_no, a.pol_iss_cd, a.clm_yy,
                                      a.clm_seq_no, a.iss_cd, a.assd_no,
                                      a.recovery_sw, a.clm_file_date,
                                      a.user_id, a.last_update,
                                      a.dsp_loss_date, a.clm_stat_cd,
                                      a.loss_pd_amt, a.loss_res_amt,
                                      a.exp_pd_amt, a.exp_res_amt,
                                      a.assured_name
                                 FROM gicl_claims a
                               UNION
                               SELECT b.claim_id, b.item_title free_text_search,
                                      'ITEM - ' || b.item_title free_text,
                                      b.item_no, 'item' title, a.line_cd,
                                      a.subline_cd, a.issue_yy, a.pol_seq_no,
                                      a.renew_no, a.pol_iss_cd, a.clm_yy,
                                      a.clm_seq_no, a.iss_cd, a.assd_no,
                                      a.recovery_sw, a.clm_file_date,
                                      a.user_id, a.last_update,
                                      a.dsp_loss_date, a.clm_stat_cd,
                                      a.loss_pd_amt, a.loss_res_amt,
                                      a.exp_pd_amt, a.exp_res_amt,
                                      a.assured_name
                                 FROM gicl_clm_item b, gicl_claims a
                                WHERE a.claim_id = b.claim_id
                               UNION
                               SELECT c.claim_id, c.grouped_item_title free_text_search,
                                         'GROUPED ITEM - '
                                      || c.grouped_item_title free_text,
                                      c.grouped_item_no, 'grp' title,
                                      a.line_cd, a.subline_cd, a.issue_yy,
                                      a.pol_seq_no, a.renew_no, a.pol_iss_cd,
                                      a.clm_yy, a.clm_seq_no, a.iss_cd,
                                      a.assd_no, a.recovery_sw,
                                      a.clm_file_date, a.user_id,
                                      a.last_update, a.dsp_loss_date,
                                      a.clm_stat_cd, a.loss_pd_amt,
                                      a.loss_res_amt, a.exp_pd_amt,
                                      a.exp_res_amt, a.assured_name
                                 FROM gicl_claims a,
                                      gicl_clm_item b,
                                      gicl_accident_dtl c
                                WHERE c.claim_id = b.claim_id
                                  AND a.claim_id = b.claim_id
                                  AND c.item_no = b.item_no
                                  AND c.grouped_item_no = b.grouped_item_no))
                       WHERE check_user_per_iss_cd2 (line_cd, iss_cd, 'GICLS251', p_user_id) = 1
                         AND UPPER (free_text_search) LIKE UPPER (p_free_text)
                         AND UPPER (free_text) LIKE UPPER ('%' || p_free_text)
                         AND UPPER (free_text) LIKE UPPER ('%' || p_free_text ||'%') --modified by robert 01.06.2014
                         AND (   (    (DECODE (p_search_by_opt,
                                   'lossDate', TRUNC(dsp_loss_date),
                                   'fileDate', TRUNC(clm_file_date)
                                  ) >= TO_DATE (p_date_from, 'MM-DD-YYYY')
                                      )
                                  AND (DECODE (p_search_by_opt,
                                               'lossDate', TRUNC(dsp_loss_date),
                                               'fileDate', TRUNC(clm_file_date)
                                              ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                      )
                                 )
                              OR (DECODE (p_search_by_opt,
                                          'lossDate', TRUNC(dsp_loss_date),
                                               'fileDate', TRUNC(clm_file_date)
                                         ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                                 )
                             )
                             AND UPPER (recovery_sw) LIKE UPPER (NVL (p_recovery_sw, recovery_sw))
                           AND UPPER (get_clm_no (claim_id)) LIKE UPPER (NVL (p_claim_number, get_clm_no (claim_id)))
                           AND UPPER (free_text_search) LIKE UPPER (NVL (p_free_text, free_text_search))
                           AND UPPER (free_text) LIKE UPPER (NVL (p_free_text, '%' || free_text))
                           AND UPPER (free_text) LIKE UPPER (NVL ('%' || p_free_text ||'%', '%' || free_text)) --modified by robert 01.06.2014
                           AND NVL (loss_res_amt, 0) = NVL (p_loss_res_amt, NVL (loss_res_amt, 0))
             AND NVL (exp_res_amt, 0) = NVL (p_exp_res_amt, NVL (exp_res_amt, 0))
             AND NVL (loss_pd_amt, 0) = NVL (p_loss_pd_amt, NVL (loss_pd_amt, 0))
             AND NVL (exp_pd_amt, 0) = NVL (p_exp_pd_amt, NVL (exp_pd_amt, 0)))
            LOOP
               v_list.tot_loss_res_amt := b.tot_loss_res_amt;
               v_list.tot_exp_res_amt := b.tot_exp_res_amt;
               v_list.tot_loss_paid_amt := b.tot_loss_pd_amt;
               v_list.tot_exp_paid_amt := b.tot_exp_pd_amt;
            END LOOP;
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_per_assured_freetext;

   FUNCTION get_recovery_details (p_claim_id gicl_clm_recovery.claim_id%TYPE)
      RETURN recovery_details_tab PIPELINED
   IS
      v_list   recovery_details_type;
   BEGIN
      FOR i IN (SELECT   a.recovery_id, a.claim_id, a.line_cd, a.rec_year,
                         a.rec_seq_no, a.rec_type_cd, a.recoverable_amt,
                         a.recovered_amt, a.tp_item_desc, a.plate_no,
                         a.currency_cd, a.convert_rate, a.lawyer_class_cd,
                         a.lawyer_cd, a.cpi_rec_no, a.cpi_branch_cd,
                         a.user_id, a.last_update, a.cancel_tag, a.iss_cd,
                         a.rec_file_date, a.demand_letter_date,
                         a.demand_letter_date2, a.demand_letter_date3,
                         a.tp_driver_name, a.tp_drvr_add, a.tp_plate_no,
                         a.case_no, a.court
                    FROM gicl_clm_recovery a
                   WHERE a.claim_id = p_claim_id
                ORDER BY line_cd, rec_year, rec_seq_no)
      LOOP
         v_list.recovery_id := i.recovery_id;
         v_list.recovery_no := get_recovery_no (i.recovery_id);
         v_list.recoverable_amt := i.recoverable_amt;
         v_list.recovered_amt := i.recovered_amt;
         v_list.plate_no := i.plate_no;
         v_list.tp_item_desc := i.tp_item_desc;

         BEGIN
            SELECT    payee_first_name
                   || ' '
                   || payee_middle_name
                   || ' '
                   || payee_last_name
              INTO v_list.lawyer
              FROM giis_payees
             WHERE payee_no = i.lawyer_cd
               AND payee_class_cd = i.lawyer_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.lawyer := NULL;
         END;

         BEGIN
            IF i.cancel_tag IS NULL
            THEN
               v_list.status := 'IN PROGRESS';
            ELSIF i.cancel_tag = 'CD'
            THEN
               v_list.status := 'CLOSED';
            ELSIF i.cancel_tag = 'CC'
            THEN
               v_list.status := 'CANCELLED';
            ELSIF i.cancel_tag = 'WO'
            THEN
               v_list.status := 'WRITTEN OFF';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_recovery_details;

   FUNCTION get_payor_details (
      p_claim_id      gicl_recovery_payor.claim_id%TYPE,
      p_recovery_id   gicl_recovery_payor.recovery_id%TYPE
   )
      RETURN payor_details_tab PIPELINED
   IS
      v_list   payor_details_type;
   BEGIN
      FOR i IN (SELECT payor_class_cd, payor_cd, recovered_amt
                  FROM gicl_recovery_payor
                 WHERE claim_id = p_claim_id AND recovery_id = p_recovery_id)
      LOOP
         v_list.recovered_amt := i.recovered_amt;

         BEGIN
            SELECT class_desc
              INTO v_list.class_desc
              FROM giis_payee_class
             WHERE payee_class_cd = i.payor_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.class_desc := NULL;
         END;

         BEGIN
            SELECT    payee_last_name
                   || ' '
                   || payee_first_name
                   || ' '
                   || payee_middle_name payee_name
              INTO v_list.payor
              FROM giis_payees
             WHERE payee_no = i.payor_cd AND payee_class_cd = i.payor_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.payor := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_payor_details;

   FUNCTION get_history (p_recovery_id gicl_rec_hist.recovery_id%TYPE)
      RETURN history_tab PIPELINED
   IS
      v_list   history_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_rec_hist
                 WHERE recovery_id = p_recovery_id)
      LOOP
         v_list.rec_hist_no := i.rec_hist_no;
         v_list.rec_stat_cd := i.rec_stat_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'mm-dd-yyyy HH:MI:ss AM');

         BEGIN
            SELECT rec_stat_desc
              INTO v_list.rec_stat_desc
              FROM giis_recovery_status
             WHERE rec_stat_cd = i.rec_stat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.rec_stat_desc := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;
   END get_history;
END;
/
