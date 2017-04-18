CREATE OR REPLACE PACKAGE BODY CPI.giclr050b_pkg
AS
   FUNCTION get_giclr050b_company_name
      RETURN VARCHAR2
   IS
      --V_NAME VARCHAR2(200);
      v_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
         RETURN (v_name);
      WHEN TOO_MANY_ROWS
      THEN
         v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
         RETURN (v_name);
   END get_giclr050b_company_name;

   FUNCTION get_giclr050b_company_add
      RETURN VARCHAR2
   IS
      v_add   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
      WHEN TOO_MANY_ROWS
      THEN
         v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
   END get_giclr050b_company_add;

   FUNCTION get_giclr050b_stat_desc (p_clm_stat_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      --v_desc   varchar2(50);
      v_desc   giis_clm_stat.clm_stat_desc%TYPE;
   BEGIN
      BEGIN
         SELECT clm_stat_desc
           INTO v_desc
           FROM giis_clm_stat
          WHERE clm_stat_cd = p_clm_stat_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN v_desc;
   END get_giclr050b_stat_desc;

   FUNCTION get_giclr050b_peril_sname (p_line_cd VARCHAR2, p_peril_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_peril_name   giis_peril.peril_name%TYPE;
   BEGIN
      BEGIN
         SELECT peril_name
           INTO v_peril_name
           FROM giis_peril
          WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN v_peril_name;
   END get_giclr050b_peril_sname;

   FUNCTION get_giclr050b_shr_loss_res_amt (
      p_claim_id     NUMBER,
      p_item_no      NUMBER,
      p_peril_cd     NUMBER,
      p_grp_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_loss_shr_amt   gicl_reserve_ds.shr_loss_res_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT NVL (SUM (shr_loss_res_amt * NVL (b.convert_rate, 1)),
                            0
                           ) shr_loss_res_amt
                  FROM gicl_reserve_ds a, gicl_clm_res_hist b
                 WHERE a.claim_id = b.claim_id
                   AND a.clm_res_hist_id = b.clm_res_hist_id
                   AND a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = p_peril_cd
                   AND a.grp_seq_no = p_grp_seq_no
                   AND (a.negate_tag = 'N' OR a.negate_tag IS NULL))
--               AND a.hist_seq_no = :hist_seq_no)
      LOOP
         v_loss_shr_amt := i.shr_loss_res_amt + v_loss_shr_amt;
      END LOOP;

      RETURN (v_loss_shr_amt);
   END get_giclr050b_shr_loss_res_amt;

   FUNCTION get_giclr050b_exp_shr_amt (
      p_claim_id     NUMBER,
      p_item_no      NUMBER,
      p_peril_cd     NUMBER,
      p_grp_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_exp_shr_amt   gicl_reserve_ds.shr_exp_res_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT NVL (SUM (shr_exp_res_amt * NVL (b.convert_rate, 1)),
                            0
                           ) shr_exp_res_amt
                  FROM gicl_reserve_ds a, gicl_clm_res_hist b
                 WHERE a.claim_id = b.claim_id
                   AND a.clm_res_hist_id = b.clm_res_hist_id
                   AND a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = p_peril_cd
                   AND a.grp_seq_no = p_grp_seq_no
                   AND (a.negate_tag = 'N' OR a.negate_tag IS NULL))
--               AND a.hist_seq_no = :hist_seq_no)
      LOOP
         v_exp_shr_amt := i.shr_exp_res_amt + v_exp_shr_amt;
      END LOOP;

      RETURN (v_exp_shr_amt);
   END get_giclr050b_exp_shr_amt;

   FUNCTION get_giclr050b_records (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giclr050b_record_tab PIPELINED
   IS
      v_list        giclr050b_record_type;
      v_not_exist   BOOLEAN               := TRUE;
   BEGIN
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_add := giisp.v ('COMPANY_ADDRESS');

      FOR i IN
         (SELECT DISTINCT a.line_cd || ' - ' || d.line_name line,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                claim_number,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.pol_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                               policy_number,
                          a.clm_stat_cd, a.in_hou_adj,
                          a.assured_name /*,  c.grp_seq_no*/, a.claim_id,
                          a.line_cd, b.item_no, b.peril_cd, b.hist_seq_no,
                          
                             -- g.trty_name,
                             LTRIM (TO_CHAR (e.item_no, '00009'))
                          || '-'
                          || e.item_title item
                     FROM gicl_claims a,
                          gicl_clm_res_hist b,
                          gicl_reserve_ds c,
                          giis_dist_share g,
                          giis_line d,
                          gicl_clm_item e,
                          gicl_item_peril f
                    WHERE a.claim_id = b.claim_id
                      AND b.claim_id = c.claim_id
                      AND b.clm_res_hist_id = c.clm_res_hist_id
                      AND b.claim_id = f.claim_id
                      AND b.item_no = f.item_no
                      AND b.peril_cd = f.peril_cd
                      AND a.line_cd = d.line_cd
                      AND c.line_cd = g.line_cd
                      AND c.grp_seq_no = g.share_cd
                      AND e.claim_id = f.claim_id
                      AND e.item_no = f.item_no
                      AND NVL (f.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      AND NVL (c.negate_tag, 'N') = 'N'
                      AND c.share_type IN ('2', '3')
                      AND EXISTS (
                             SELECT '1'
                               FROM gicl_reserve_rids h
                              WHERE h.claim_id = c.claim_id
                                AND h.clm_res_hist_id = c.clm_res_hist_id
                                AND h.clm_dist_no = c.clm_dist_no
                                AND h.hist_seq_no = c.hist_seq_no
                                AND h.pla_id IS NULL)
                      AND a.line_cd = p_line_cd
                      AND a.in_hou_adj = NVL (p_user_id, a.in_hou_adj)
                      --AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS051' ) = 1)
                      AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS051', nvl(p_user_id, USER) ) = 1)

      LOOP
         v_not_exist := FALSE;
         --raise_application_error(-20001, 'test');
         v_list.line := i.line;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.assured_name := i.assured_name;
         v_list.claim_id := i.claim_id;
         v_list.line_cd := i.line_cd;
         v_list.item_no := i.item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.hist_seq_no := i.hist_seq_no;
         v_list.item := i.item;
         v_list.company_name := get_giclr050b_company_name;
         v_list.company_add := get_giclr050b_company_add;
         v_list.stat_desc := get_giclr050b_stat_desc (i.clm_stat_cd);
         v_list.peril_sname :=
                            get_giclr050b_peril_sname (i.line_cd, i.peril_cd);
         PIPE ROW (v_list);
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr050b_records;

   FUNCTION get_giclr050b_subreport (
      p_line_cd         VARCHAR2,
      p_user_id         VARCHAR2,
      p_claim_id        NUMBER,
      p_policy_number   VARCHAR2
   )
      RETURN giclr050b_subreport_tab PIPELINED
   IS
      v_list   giclr050b_subreport_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT 
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.clm_seq_no, '0000009'))
                                                                claim_number,
                                                                
                                                                a.line_cd || ' - ' || d.line_name line,
                             a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.pol_iss_cd
                          || '-'
                          || LTRIM (TO_CHAR (a.issue_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                          || '-'
                          || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                               policy_number,
                          a.clm_stat_cd, a.in_hou_adj, a.assured_name,
                          c.grp_seq_no, a.claim_id, a.line_cd, b.item_no,
                          b.peril_cd, b.hist_seq_no, g.trty_name,
                             LTRIM (TO_CHAR (e.item_no, '00009'))
                          || '-'
                          || e.item_title item
                     FROM gicl_claims a,
                          gicl_clm_res_hist b,
                          gicl_reserve_ds c,
                          giis_dist_share g,
                          giis_line d,
                          gicl_clm_item e,
                          gicl_item_peril f
                    WHERE a.claim_id = b.claim_id
                      AND b.claim_id = c.claim_id
                      AND b.clm_res_hist_id = c.clm_res_hist_id
                      AND b.claim_id = f.claim_id
                      AND b.item_no = f.item_no
                      AND b.peril_cd = f.peril_cd
                      AND a.line_cd = d.line_cd
                      AND c.line_cd = g.line_cd
                      AND c.grp_seq_no = g.share_cd
                      AND e.claim_id = f.claim_id
                      AND e.item_no = f.item_no
                      AND NVL (f.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      AND NVL (c.negate_tag, 'N') = 'N'
                      AND c.share_type IN ('2', '3')
                      AND a.claim_id = p_claim_id
                      AND EXISTS (
                             SELECT '1'
                               FROM gicl_reserve_rids h
                              WHERE h.claim_id = c.claim_id
                                AND h.clm_res_hist_id = c.clm_res_hist_id
                                AND h.clm_dist_no = c.clm_dist_no
                                AND h.hist_seq_no = c.hist_seq_no
                                AND h.pla_id IS NULL)
                      AND a.line_cd = p_line_cd
                      AND a.in_hou_adj = NVL (p_user_id, a.in_hou_adj)
                      --AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GICLS051' ) = 1)
                      AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GICLS051', nvl(p_user_id, USER) ) = 1)

      LOOP
         v_list.line := i.line;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.assured_name := i.assured_name;
         v_list.grp_seq_no := i.grp_seq_no;
         v_list.claim_id := i.claim_id;
         v_list.line_cd := i.line_cd;
         v_list.item_no := i.item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.hist_seq_no := i.hist_seq_no;
         v_list.trty_name := i.trty_name;
         v_list.item := i.item;
         v_list.company_name := get_giclr050b_company_name;
         v_list.company_add := get_giclr050b_company_add;
         v_list.stat_desc := get_giclr050b_stat_desc (i.clm_stat_cd);
         v_list.peril_sname :=
                            get_giclr050b_peril_sname (i.line_cd, i.peril_cd);
         v_list.shr_loss_res_amt :=
            get_giclr050b_shr_loss_res_amt (i.claim_id,
                                            i.item_no,
                                            i.peril_cd,
                                            i.grp_seq_no
                                           );
         v_list.exp_shr_amt :=
            get_giclr050b_exp_shr_amt (i.claim_id,
                                       i.item_no,
                                       i.peril_cd,
                                       i.grp_seq_no
                                      );
         PIPE ROW (v_list);
      END LOOP;
   END get_giclr050b_subreport;
END;
/


