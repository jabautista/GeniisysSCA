CREATE OR REPLACE PACKAGE BODY CPI.giclr051a_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 07.29.2013
** Reference By : giclr051a
** Description  : List of FLA's for printing */
   FUNCTION cf_reinsurerformula (p_ri_cd NUMBER)
      RETURN VARCHAR2
   IS
      v_ri   VARCHAR2 (500);
   BEGIN
      BEGIN
         SELECT LTRIM (TO_CHAR (ri_cd, '00009')) || '-' || ri_name
           INTO v_ri
           FROM giis_reinsurer
          WHERE ri_cd = p_ri_cd;

         RETURN v_ri;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RETURN NULL;
      END;

      RETURN NULL;
   END;

   FUNCTION cf_statusformula (p_clm_stat_cd VARCHAR2)
      RETURN VARCHAR2
   IS
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
   END;

   FUNCTION cf_adv_shr_amtformula (
      p_claim_id     NUMBER,
      p_la_yy        NUMBER,
      p_fla_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_adv_shr_amt   gicl_advs_fla.adv_shr_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT   NVL (a.adv_shr_amt, 0)
                       * NVL (b.convert_rate, 1) adv_shr_amt
                  FROM gicl_advs_fla a, gicl_advice b
                 WHERE a.claim_id = b.claim_id
                   AND a.adv_fla_id = b.adv_fla_id
                   AND a.claim_id = p_claim_id
                   AND NVL (a.print_sw, 'N') = 'N'
                   AND NVL (a.cancel_tag, 'N') = 'N'
                   AND a.la_yy = p_la_yy
                   AND a.fla_seq_no = p_fla_seq_no)
      LOOP
         v_adv_shr_amt := v_adv_shr_amt + i.adv_shr_amt;
      END LOOP;

      RETURN (v_adv_shr_amt);
   END;

   FUNCTION cf_net_shr_amtformula (
      p_claim_id     NUMBER,
      p_la_yy        NUMBER,
      p_fla_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_net_shr_amt   gicl_advs_fla.net_shr_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT   NVL (a.net_shr_amt, 0)
                       * NVL (b.convert_rate, 1) net_shr_amt
                  FROM gicl_advs_fla a, gicl_advice b
                 WHERE a.claim_id = b.claim_id
                   AND a.adv_fla_id = b.adv_fla_id
                   AND a.claim_id = p_claim_id
                   AND NVL (a.print_sw, 'N') = 'N'
                   AND NVL (a.cancel_tag, 'N') = 'N'
                   AND a.la_yy = p_la_yy
                   AND a.fla_seq_no = p_fla_seq_no)
      LOOP
         v_net_shr_amt := v_net_shr_amt + i.net_shr_amt;
      END LOOP;

      RETURN (v_net_shr_amt);
   END;

   FUNCTION cf_paid_shr_amtformula (
      p_claim_id     NUMBER,
      p_la_yy        NUMBER,
      p_fla_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_paid_shr_amt   gicl_advs_fla.paid_shr_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT   NVL (a.paid_shr_amt, 0)
                       * NVL (b.convert_rate, 1) paid_shr_amt
                  FROM gicl_advs_fla a, gicl_advice b
                 WHERE a.claim_id = b.claim_id
                   AND a.adv_fla_id = b.adv_fla_id
                   AND a.claim_id = p_claim_id
                   AND NVL (a.print_sw, 'N') = 'N'
                   AND NVL (a.cancel_tag, 'N') = 'N'
                   AND a.la_yy = p_la_yy
                   AND a.fla_seq_no = p_fla_seq_no)
      LOOP
         v_paid_shr_amt := v_paid_shr_amt + i.paid_shr_amt;
      END LOOP;

      RETURN (v_paid_shr_amt);
   END;

   FUNCTION company_nameformula
      RETURN VARCHAR2
   IS
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
   END;

   FUNCTION company_addformula
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
   END;

   FUNCTION get_giclr051a_record (
        p_line_cd VARCHAR2, 
        p_user_id VARCHAR2,
        p_all_users VARCHAR2
   )
      RETURN giclr051a_record_tab PIPELINED
   IS
      v_list    giclr051a_record_type;
      pjsname   BOOLEAN               := TRUE;
      
      v_all_user_id VARCHAR2(10) := NULL;
   BEGIN
      v_list.company_add := company_addformula;
      v_list.company_name := company_nameformula;
      
      IF p_all_users = 'N' THEN
        v_all_user_id := p_user_id;
      END IF;

      FOR i IN
         (SELECT c.line_cd || ' - ' || e.line_name line, c.claim_id,
                    c.line_cd
                 || '-'
                 || c.subline_cd
                 || '-'
                 || c.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (c.clm_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.clm_seq_no, '0000009')) claim_number,
                    c.line_cd
                 || '-'
                 || c.subline_cd
                 || '-'
                 || c.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (c.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.pol_seq_no, '0000009'))
                 || '-'
                 || LTRIM (TO_CHAR (c.renew_no, '09')) policy_number,
                 c.assured_name,
                    b.line_cd
                 || '-'
                 || b.iss_cd
                 || '-'
                 || b.advice_year
                 || '-'
                 || LTRIM (TO_CHAR (b.advice_seq_no, '0000009')) advice_no,
                 f.trty_name,
                    g.line_cd
                 || '-'
                 || LTRIM (TO_CHAR (g.la_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (g.fla_seq_no, '0000009')) fla_no,
                 g.ri_cd, g.la_yy, g.fla_seq_no, c.in_hou_adj, c.clm_stat_cd
            FROM gicl_claims c,
                 gicl_advice b,
                 gicl_advs_fla g,
                 giis_dist_share f,
                 giis_line e
           WHERE c.claim_id = b.claim_id
             AND g.adv_fla_id = b.adv_fla_id
             AND g.claim_id = c.claim_id
             AND c.line_cd = e.line_cd
             AND g.line_cd = f.line_cd
             AND g.grp_seq_no = f.share_cd
             AND c.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
             AND b.advice_flag != 'N'
             AND g.print_sw = 'N'
             AND NVL (g.cancel_tag, 'N') = 'N'
             AND c.in_hou_adj = NVL (v_all_user_id, c.in_hou_adj)
             AND c.line_cd = p_line_cd
             AND c.iss_cd IN
                    (DECODE (check_user_per_iss_cd2 (NULL, c.iss_cd,
                                                    'GICLS050', p_user_id/*NVL(p_user_id, USER)*/),
                             1, c.iss_cd,
                             0, ''
                            )
                    ))
      LOOP
         pjsname := FALSE;
         v_list.line := i.line;
         v_list.claim_id := i.claim_id;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.advice_no := i.advice_no;
         v_list.trty_name := i.trty_name;
         v_list.fla_no := i.fla_no;
         v_list.ri_cd := i.ri_cd;
         v_list.la_yy := i.la_yy;
         v_list.fla_seq_no := i.fla_seq_no;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.p_line_cd := p_line_cd;
         v_list.p_user_id := p_user_id;
         v_list.cf_paid_shr_amt :=
                   cf_paid_shr_amtformula (i.claim_id, i.la_yy, i.fla_seq_no);
         v_list.cf_net_shr_amt :=
                   cf_paid_shr_amtformula (i.claim_id, i.la_yy, i.fla_seq_no);
         v_list.cf_adv_shr_amt :=
                    cf_adv_shr_amtformula (i.claim_id, i.la_yy, i.fla_seq_no);
         v_list.cf_status := cf_statusformula (i.clm_stat_cd);
         v_list.cf_reinsurer := cf_reinsurerformula (i.ri_cd);
         
         PIPE ROW (v_list);
         
      END LOOP;

      IF pjsname = TRUE
      THEN
         v_list.pjsname := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr051a_record;
END;
/


