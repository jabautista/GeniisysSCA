CREATE OR REPLACE PACKAGE BODY CPI.giclr050a_pkg
AS
/*
   ** Created by : Ariel P. Ignas Jr
   ** Date Created : 07.29.2013
   ** Reference By : GICLR050A
   ** Description : List of PLA for Printing
   */
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

   FUNCTION cf_stat_descformula (p_clm_stat_cd VARCHAR2)
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

   FUNCTION cf_peril_snameformula (p_line_cd VARCHAR2, p_peril_cd NUMBER)
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
   END;

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

   FUNCTION cf_shr_loss_res_amtformula (
      p_claim_id     NUMBER,
      p_la_yy        NUMBER,
      p_pla_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_loss_shr_amt   gicl_advs_pla.loss_shr_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT NVL (SUM (a.loss_shr_amt * NVL (d.convert_rate, 1)),
                            0
                           ) loss_shr_amt
                  FROM gicl_advs_pla a,
                       gicl_reserve_rids b,
                       gicl_reserve_ds c,
                       gicl_clm_res_hist d
                 WHERE a.claim_id = b.claim_id
                   AND a.res_pla_id = b.res_pla_id
                   AND a.pla_id = b.pla_id
                   AND b.claim_id = c.claim_id
                   AND b.clm_res_hist_id = c.clm_res_hist_id
                   AND b.clm_dist_no = c.clm_dist_no
                   AND b.share_type = c.share_type
                   AND c.claim_id = d.claim_id
                   AND c.clm_res_hist_id = d.clm_res_hist_id
                   AND a.claim_id = p_claim_id
                   AND a.la_yy = p_la_yy
                   AND a.pla_seq_no = p_pla_seq_no
                   AND NVL (a.print_sw, 'N') = 'N'
                   AND NVL (a.cancel_tag, 'N') = 'N'
                   AND d.dist_sw = 'Y'
                   AND NVL (c.negate_tag, 'N') = 'N')
      LOOP
         v_loss_shr_amt := v_loss_shr_amt + i.loss_shr_amt;
      END LOOP;

      RETURN (v_loss_shr_amt);
   END;

   FUNCTION cf_exp_shr_amtformula (
      p_claim_id     NUMBER,
      p_la_yy        NUMBER,
      p_pla_seq_no   NUMBER
   )
      RETURN NUMBER
   IS
      v_exp_shr_amt   gicl_advs_pla.exp_shr_amt%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT NVL (SUM (a.exp_shr_amt * NVL (d.convert_rate, 1)),
                            0
                           ) exp_shr_amt
                  FROM gicl_advs_pla a,
                       gicl_reserve_rids b,
                       gicl_reserve_ds c,
                       gicl_clm_res_hist d
                 WHERE a.claim_id = b.claim_id
                   AND a.res_pla_id = b.res_pla_id
                   AND a.pla_id = b.pla_id
                   AND b.claim_id = c.claim_id
                   AND b.clm_res_hist_id = c.clm_res_hist_id
                   AND b.clm_dist_no = c.clm_dist_no
                   AND b.share_type = c.share_type
                   AND c.claim_id = d.claim_id
                   AND c.clm_res_hist_id = d.clm_res_hist_id
                   AND a.claim_id = p_claim_id
                   AND a.la_yy = p_la_yy
                   AND a.pla_seq_no = p_pla_seq_no
                   AND NVL (a.print_sw, 'N') = 'N'
                   AND NVL (a.cancel_tag, 'N') = 'N'
                   AND d.dist_sw = 'Y'
                   AND NVL (c.negate_tag, 'N') = 'N')
      LOOP
         v_exp_shr_amt := v_exp_shr_amt + i.exp_shr_amt;
      END LOOP;

      RETURN (v_exp_shr_amt);
   END;

   FUNCTION get_giclr050a_record (
        p_line_cd VARCHAR2, 
        p_user_id VARCHAR2,
        p_all_users VARCHAR2
   )
      RETURN giclr050a_record_tab PIPELINED
   IS
      v_list   giclr050a_record_type;
      v_test   BOOLEAN               := TRUE;
      
      v_all_user_id VARCHAR2(10) := NULL;
      
   BEGIN
      v_list.company_addformula := company_addformula;
      v_list.company_nameformula := company_nameformula;
      
      IF p_all_users = 'N' THEN
        v_all_user_id := p_user_id;
      END IF;

      FOR i IN
         (SELECT a.pla_seq_no, a.line_cd || ' - ' || d.line_name line,
                    a.line_cd
                 || '-'
                 || LTRIM (TO_CHAR (a.la_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (a.pla_seq_no, '0000009')) pla_no,
                 b.clm_stat_cd, b.in_hou_adj,
                    b.line_cd
                 || '-'
                 || b.subline_cd
                 || '-'
                 || b.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (b.clm_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim_number,
                    b.line_cd
                 || '-'
                 || b.subline_cd
                 || '-'
                 || b.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (b.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                 || '-'
                 || LTRIM (TO_CHAR (b.renew_no, '09')) policy_number,
                 b.assured_name, b.claim_id, a.ri_cd, a.line_cd,
                 a.share_type, a.la_yy, c.item_no, c.peril_cd, g.trty_name,
                    LTRIM (TO_CHAR (e.item_no, '00009'))
                 || '-'
                 || e.item_title item
            FROM gicl_advs_pla a,
                 gicl_claims b,
                 gicl_clm_res_hist c,
                 giis_line d,
                 gicl_clm_item e,
                 giis_dist_share g,
                 gicl_reserve_rids f,
                 gicl_item_peril x
           WHERE a.claim_id = b.claim_id
             AND a.claim_id = f.claim_id
             AND a.pla_id = f.pla_id
             AND f.claim_id = c.claim_id
             AND f.clm_res_hist_id = c.clm_res_hist_id
             AND x.claim_id = f.claim_id
             AND x.item_no = f.item_no
             AND x.peril_cd = f.peril_cd
             AND f.line_cd = g.line_cd
             AND f.grp_seq_no = g.share_cd
             AND f.line_cd = d.line_cd
             AND x.claim_id = e.claim_id
             AND x.item_no = e.item_no
             AND c.dist_sw = 'Y'
             AND NVL (a.print_sw, 'N') = 'N'
             AND NVL (a.cancel_tag, 'N') = 'N'
             AND x.close_flag IN ('AP', 'CC', 'CP')
             AND b.in_hou_adj = NVL (v_all_user_id, b.in_hou_adj)
             AND a.line_cd = p_line_cd
             AND b.iss_cd IN
                    (DECODE (check_user_per_iss_cd2 (NULL, b.iss_cd,
                                                    'GICLS050', p_user_id), --NVL(p_user_id, USER)
                             1, b.iss_cd,
                             0, ''
                            )
                    ))
      LOOP
         v_test := FALSE;
         v_list.pla_seq_no := i.pla_seq_no;
         v_list.line := i.line;
         v_list.pla_no := i.pla_no;
         v_list.clm_stat_cd := i.clm_stat_cd;
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.claim_number := i.claim_number;
         v_list.policy_number := i.policy_number;
         v_list.assured_name := i.assured_name;
         v_list.claim_id := i.claim_id;
         v_list.ri_cd := i.ri_cd;
         v_list.line_cd := i.line_cd;
         v_list.share_type := i.share_type;
         v_list.la_yy := i.la_yy;
         v_list.item_no := i.item_no;
         v_list.peril_cd := i.peril_cd;
         v_list.trty_name := i.trty_name;
         v_list.item := i.item;
         v_list.p_line_cd := p_line_cd;
         v_list.p_user_id := p_user_id;
         v_list.cf_stat_descformula := cf_stat_descformula (i.clm_stat_cd);
         v_list.cf_peril_snameformula :=
                                cf_peril_snameformula (i.line_cd, i.peril_cd);
         v_list.cf_reinsurerformula := cf_reinsurerformula (i.ri_cd);
         v_list.cf_shr_loss_res_amtformula :=
               cf_shr_loss_res_amtformula (i.claim_id, i.la_yy, i.pla_seq_no);
         v_list.cf_exp_shr_amtformula :=
                    cf_exp_shr_amtformula (i.claim_id, i.la_yy, i.pla_seq_no);
                    
         PIPE ROW (v_list);
         
      END LOOP;

      IF v_test = TRUE
      THEN
         v_list.v_test := '1';
         PIPE ROW (v_list);
      END IF;
   END get_giclr050a_record;
END;
/


