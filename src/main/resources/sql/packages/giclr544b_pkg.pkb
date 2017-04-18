CREATE OR REPLACE PACKAGE BODY CPI.giclr544b_pkg
AS
   FUNCTION get_giclr544b_comp_name
      RETURN VARCHAR2
   IS
      ws_company   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_company := NULL;
      END;

      RETURN (ws_company);
   END get_giclr544b_comp_name;

   FUNCTION get_giclr544b_comp_add
      RETURN VARCHAR2
   IS
      ws_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_address := NULL;
      END;

      RETURN (ws_address);
   END get_giclr544b_comp_add;

   FUNCTION get_giclr544b_title (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('REPORTED CLAIMS PER BRANCH - LOSSES');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('REPORTED CLAIMS PER BRANCH - EXPENSES');
      ELSE
         RETURN ('REPORTED CLAIMS PER BRANCH');
      END IF;
   END get_giclr544b_title;

   FUNCTION get_giclr544b_as_date (p_start_dt DATE, p_end_dt DATE)
      RETURN VARCHAR2
   IS
      v_date   VARCHAR2 (50);
   BEGIN
      RETURN (   'from '
              || TO_CHAR (p_start_dt, 'fmMonth DD, YYYY')
              || ' to '
              || TO_CHAR (p_end_dt, 'fmMonth DD, YYYY')
             );
   END get_giclr544b_as_date;

   FUNCTION get_giclr544b_branch_name (p_iss_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_branch_name   giis_issource.iss_name%TYPE;
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_branch_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_branch_name := ' ';
      END;

      RETURN (v_branch_name);
   END get_giclr544b_branch_name;

   FUNCTION get_giclr544b_clm_func (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('Loss Amount');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('Expense Amount');
      ELSE
         RETURN ('Claim Amount');
      END IF;
   END get_giclr544b_clm_func;

   FUNCTION get_giclr544b_loss_amt (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_loss_amt     gicl_clm_res_hist.loss_reserve%TYPE;
      v_exist        VARCHAR2 (1);
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_loss_amt := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_loss_amt :=
              v_loss_amt
            + gicls540_pkg.get_loss_amt (p_claim_id,
                                         p_peril_cd,
                                         v_loss_exp,
                                         p_clm_stat_cd
                                        );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_loss_amt);
   END get_giclr544b_loss_amt;

   FUNCTION get_giclr544b_retention (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_net_ret      gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist        VARCHAR2 (1);
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_net_ret := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_net_ret :=
              v_net_ret
            + gicls540_pkg.amount_per_share_type (p_claim_id,
                                                  p_peril_cd,
                                                  1,
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_net_ret);
   END get_giclr544b_retention;

   FUNCTION get_giclr544b_treaty (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_trty         gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist        VARCHAR2 (1);
      v_shr_type     NUMBER;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_trty := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_trty :=
              v_trty
            + gicls540_pkg.amount_per_share_type (p_claim_id,
                                                  p_peril_cd,
                                                  giacp.v ('TRTY_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_trty);
   END get_giclr544b_treaty;

   FUNCTION get_giclr544b_facultative (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_facul        gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist        VARCHAR2 (1);
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_facul := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_facul :=
              v_facul
            + gicls540_pkg.amount_per_share_type (p_claim_id,
                                                  p_peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_facul);
   END get_giclr544b_facultative;

   FUNCTION get_giclr544b_xol (
      p_loss_exp      VARCHAR2,
      p_claim_id      NUMBER,
      p_peril_cd      NUMBER,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN NUMBER
   IS
      v_xol          gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_exist        VARCHAR2 (1);
      v_shr_type     NUMBER;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_xol := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_xol :=
              v_xol
            + gicls540_pkg.amount_per_share_type
                                              (p_claim_id,
                                               p_peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clm_stat_cd
                                              );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_xol);
   END get_giclr544b_xol;

   FUNCTION get_giclr544b_records (
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_end_dt      VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line        VARCHAR2,
      p_line_cd     VARCHAR2,
      p_loss_exp    VARCHAR2,
      p_start_dt    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544b_tab PIPELINED
   IS
      v_list        giclr544b_type;
      v_not_exist   BOOLEAN        := TRUE;
      v_start_dt    DATE           := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt      DATE           := TO_DATE (p_end_dt, 'MM/DD/YYYY');
   BEGIN
      v_list.comp_name := get_giclr544b_comp_name;
      v_list.comp_add := get_giclr544b_comp_add;
      v_list.clm_func := get_giclr544b_clm_func (p_loss_exp);
      v_list.title := get_giclr544b_title (p_loss_exp);
      v_list.as_date := get_giclr544b_as_date (v_start_dt, v_end_dt);
      
      FOR i IN (SELECT   a.line_cd, a.iss_cd,
                         (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                         ) "CLAIM_NO",
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '00')) "POLICY_NO",
                         a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                         a.subline_cd, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.assured_name,
                         a.claim_id, a.clm_stat_cd, a.old_stat_cd,
                         close_date
                    FROM gicl_claims a
                   WHERE TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (v_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND a.iss_cd IN NVL (DECODE (p_branch_cd,
                                                  'D', a.iss_cd,
                                                  giacp.v ('RI_ISS_CD'), giacp.v
                                                                  ('RI_ISS_CD'),
                                                  p_branch_cd
                                                 ),
                                          a.iss_cd
                                         )
                     AND a.iss_cd NOT IN DECODE (p_branch_cd, 'D', 'RI', '*')
                     AND iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND line_cd = NVL (p_line_cd, a.line_cd)
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 NVL (p_iss_cd, NULL),
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (NVL (p_line_cd, NULL),
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'))
      LOOP
         v_not_exist := FALSE;
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.pol_eff_date := i.pol_eff_date;
         v_list.subline_cd := i.subline_cd;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.assured_name := i.assured_name;
         v_list.claim_id := i.claim_id;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.old_stat_cd := i.old_stat_cd;
         v_list.close_date := i.close_date;
         v_list.branch_name := get_giclr544b_branch_name (i.iss_cd);
         

         FOR k IN (SELECT DISTINCT c.peril_cd, c.peril_sname peril_sname,
                                   b.claim_id, c.line_cd
                              FROM gicl_item_peril b, giis_peril c
                             WHERE b.peril_cd = c.peril_cd
                               AND c.line_cd = NVL (i.line_cd, c.line_cd)
                               AND b.claim_id = i.claim_id)
         LOOP
            v_list.peril_cd := k.peril_cd;
            v_list.peril_sname := k.peril_sname;
            v_list.claim_id := k.claim_id;
            v_list.line_cd := k.line_cd;
            v_list.loss_amt :=
               get_giclr544b_loss_amt (p_loss_exp,
                                       i.claim_id,
                                       k.peril_cd,
                                       i.clm_stat_cd
                                      );
            v_list.RETENTION :=
               get_giclr544b_retention (p_loss_exp,
                                        i.claim_id,
                                        k.peril_cd,
                                        i.clm_stat_cd
                                       );
            v_list.treaty :=
               get_giclr544b_treaty (p_loss_exp,
                                     i.claim_id,
                                     k.peril_cd,
                                     i.clm_stat_cd
                                    );
            v_list.facultative :=
               get_giclr544b_facultative (p_loss_exp,
                                          i.claim_id,
                                          k.peril_cd,
                                          i.clm_stat_cd
                                         );
            v_list.xol :=
               get_giclr544b_xol (p_loss_exp,
                                  i.claim_id,
                                  k.peril_cd,
                                  i.clm_stat_cd
                                 );
            --  EXIT;
            PIPE ROW (v_list);
         END LOOP;
      END LOOP;

      IF v_not_exist
      THEN
         v_list.flag := 'T';
         PIPE ROW (v_list);
      END IF;
   END get_giclr544b_records;

   FUNCTION get_giclr544b_claim (
      p_claim_id    NUMBER,
      p_branch_cd   VARCHAR2,
      p_line_cd     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_start_dt    VARCHAR2,
      p_end_dt      VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544b_claim_tab PIPELINED
   IS
      v_list       giclr544b_claim_type;
      v_start_dt   DATE                 := TO_DATE (p_start_dt, 'MM/DD/YYYY');
      v_end_dt     DATE                 := TO_DATE (p_end_dt, 'MM/DD/YYYY');
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.iss_cd,
                         (   a.line_cd
                          || '-'
                          || a.subline_cd
                          || '-'
                          || a.iss_cd
                          || '-'
                          || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                          || '-'
                          || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                         ) "CLAIM_NO",
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '00'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '00')) "POLICY_NO",
                         a.dsp_loss_date, a.clm_file_date, a.pol_eff_date,
                         a.subline_cd, a.pol_iss_cd, a.issue_yy,
                         a.pol_seq_no, a.renew_no, a.assured_name,
                         a.claim_id, a.clm_stat_cd, a.old_stat_cd,
                         close_date
                    FROM gicl_claims a
                   WHERE TRUNC (a.clm_file_date) BETWEEN NVL (v_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (v_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND a.iss_cd IN NVL (DECODE (p_branch_cd,
                                                  'D', a.iss_cd,
                                                  giacp.v ('RI_ISS_CD'), giacp.v
                                                                  ('RI_ISS_CD'),
                                                  p_branch_cd
                                                 ),
                                          a.iss_cd
                                         )
                     AND a.iss_cd NOT IN DECODE (p_branch_cd, 'D', 'RI', '*')
                     AND iss_cd = NVL (p_iss_cd, a.iss_cd)
                     AND line_cd = NVL (p_line_cd, a.line_cd)
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 NVL (p_iss_cd, NULL),
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (NVL (p_line_cd, NULL),
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0'))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.iss_cd := i.iss_cd;
         PIPE ROW (v_list);
      END LOOP;
   END get_giclr544b_claim;
END;
/


