DROP PROCEDURE CPI.PRE_POST_GIUWS013;

CREATE OR REPLACE PROCEDURE CPI.pre_post_giuws013 (
   p_policy_id            giuw_pol_dist.policy_id%TYPE,
   p_dist_no              giuw_pol_dist.dist_no%TYPE,
   p_facul_sw       OUT   VARCHAR2,
   p_facul_share    OUT   giuw_wpolicyds_dtl_pkg.giuw_facul_share_dtl_cur,
   p_facul_share2   OUT   giuw_wpolicyds_dtl_pkg.giuw_facul_share_dtl_cur,
   p_message        OUT   VARCHAR2,
   p_count          OUT   NUMBER,
   p_exist          OUT   VARCHAR2,
   p_old_dist_no    OUT   NUMBER
)
IS
   v_old_dist_no   giuw_pol_dist.dist_no%TYPE;
   v_old_line_cd   giuw_policyds_dtl.line_cd%TYPE;
   v_cnt           NUMBER;
BEGIN
   p_message := 'SUCCESS';
   p_exist := 'N';
   p_facul_sw := 'N';
   p_count := 0;

   FOR a IN (SELECT COUNT (dist_no) COUNT
               FROM giuw_pol_dist
              WHERE policy_id = p_policy_id
                AND negate_date IS NULL
                AND dist_flag IN ('1', '2', '3'))
   LOOP
      v_cnt := a.COUNT;
   END LOOP;

   IF v_cnt > 1
   THEN
      validate_existing_dist_rec2 (p_policy_id, p_dist_no, p_message);
   ELSE
      validate_existing_dist_rec (p_policy_id, p_dist_no, p_message);
   END IF;

   FOR i IN
      (SELECT *
         FROM TABLE
                  (giuw_wpolicyds_dtl_pkg.get_list_with_facul_share (p_dist_no)
                  ))
   LOOP
      p_count := p_count + 1;
   END LOOP;

   OPEN p_facul_share FOR
      SELECT *
        FROM TABLE
                  (giuw_wpolicyds_dtl_pkg.get_list_with_facul_share (p_dist_no)
                  );

   IF p_count > 0
   THEN
      p_facul_sw := 'Y';
   END IF;

   /* Delete previously inserted records
   ** that are no longer relevant to the
   ** current distribution record as such
   ** records no longer have a facultative
   ** share in it. */
   DELETE      giri_wdistfrps a
         WHERE NOT EXISTS (
                  SELECT 'A'
                    FROM giuw_wpolicyds_dtl
                   WHERE share_cd = 999
                     AND dist_seq_no = a.dist_seq_no
                     AND dist_no = a.dist_no)
           AND dist_no = p_dist_no;

   FOR c1 IN (SELECT dist_no_old
                FROM giuw_distrel
               WHERE policy_id = p_policy_id AND dist_no_new = p_dist_no)
   LOOP
      p_exist := 'Y';
      v_old_dist_no := c1.dist_no_old;
      EXIT;
   END LOOP;

   OPEN p_facul_share2 FOR
      SELECT *
        FROM TABLE
                (giuw_wpolicyds_dtl_pkg.get_list_with_facul_share2
                                                                 (p_policy_id,
                                                                  p_dist_no
                                                                 )
                );
END;
/


