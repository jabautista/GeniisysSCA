DROP PROCEDURE CPI.PROCESS_EXPIRING_PACK_POLICIES;

CREATE OR REPLACE PROCEDURE CPI.process_expiring_pack_policies (
   p_intm_no                     gipi_comm_invoice.intrmdry_intm_no%TYPE,
   p_fr_date                     DATE,
   p_to_date                     DATE,
   inc_special_sw                VARCHAR2 DEFAULT 'N' ,
   p_line_cd                     gipi_polbasic.line_cd%TYPE,
   p_subline_cd                  gipi_polbasic.subline_cd%TYPE,
   p_iss_cd                      gipi_polbasic.iss_cd%TYPE,
   p_issue_yy                    gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no                  gipi_polbasic.pol_seq_no%TYPE,
   p_renew_no                    gipi_polbasic.renew_no%TYPE,
   p_def_is_pol_summ_sw          giis_parameters.param_value_v%TYPE,
   p_def_same_polno_sw           giis_parameters.param_value_v%TYPE,
   p_plate_no                    gipi_vehicle.plate_no%TYPE,
   t_policy_id            IN OUT DBMS_SQL.number_table,
   t_line_cd              IN OUT DBMS_SQL.varchar2_table,
   t_subline_cd           IN OUT DBMS_SQL.varchar2_table,
   t_iss_cd               IN OUT DBMS_SQL.varchar2_table,
   t_issue_yy             IN OUT DBMS_SQL.number_table,
   t_pol_seq_no           IN OUT DBMS_SQL.number_table,
   t_renew_no             IN OUT DBMS_SQL.number_table,
   t_expiry_date          IN OUT DBMS_SQL.date_table,
   t_incept_date          IN OUT DBMS_SQL.date_table,
   t_assd_no              IN OUT DBMS_SQL.number_table,
   t_auto_sw              IN OUT DBMS_SQL.varchar2_table,
   t_intm_no              IN OUT DBMS_SQL.number_table
)
IS
   /*Modified by Grace 04.24.2003
   **Remove the claim status 'CD' when checking for existing claims.*/
   /*Modified by Iris Borde 04.21.2003.
   **To check for policies already renewed using manual renew.*/
   v_a8_ren_prem_amt          gipi_polbasic.ann_prem_amt%TYPE;
   v_currency_prem_amt        giex_expiry.currency_prem_amt%TYPE;
   v_currency_tax_amt         giex_expiry.currency_prem_amt%TYPE;
   o_currency_prem_amt2       giex_expiry.currency_prem_amt%TYPE;
   v_total_currency_prm       giex_expiry.currency_prem_amt%TYPE;
   v_currency_prm_ogrp        giex_expiry.currency_prem_amt%TYPE;
   pck_currency_prm_ogrp      giex_expiry.currency_prem_amt%TYPE;
   o_pck_currency_prem_amt2   giex_expiry.currency_prem_amt%TYPE;
   pck_total_currency_prm     giex_expiry.currency_prem_amt%TYPE;
   cnt_ext                    NUMBER := 0;
   counter                    NUMBER := 1;
   cntr                       NUMBER := 1;
   cnt                        NUMBER := 1;
   v_count                    NUMBER := 0;
   v_peril_cnt                NUMBER := 0;
   v_skip                     VARCHAR2 (1);
   v_policy_no                VARCHAR2 (100); --variable to keep the record being processed
   v_policy_ids               VARCHAR2 (32000); --variable to keep the policy_ids
   v_expiry_sw                VARCHAR2 (1) := 'N'; --to identify if the policy already exists in giex_expiry.
   v_clm                      VARCHAR2 (1);
   v_bal                      VARCHAR2 (1);
   v_sw                       VARCHAR2 (1) := 'N';
   v_intm_sw                  VARCHAR2 (1) := 'N';
   various                    VARCHAR2 (100);
   TO_DATE                    DATE;
   fr_date                    DATE;
   t_peril_cds                DBMS_SQL.number_table;
   t_item_nos                 DBMS_SQL.number_table;
   v_line_cd                  gipi_polbasic.line_cd%TYPE;
   v_subline_cd               gipi_polbasic.subline_cd%TYPE;
   v_iss_cd                   gipi_polbasic.iss_cd%TYPE;
   v_issue_yy                 gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no               gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no                 gipi_polbasic.renew_no%TYPE;
   v_back_stat                gipi_polbasic.back_stat%TYPE; --new, to identify backward endorsement
   v_endt_seq_no              gipi_polbasic.endt_seq_no%TYPE;
   pv_endt_seq_no             gipi_polbasic.endt_seq_no%TYPE;
   pv_pck_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
   pv_pck_policy_id           gipi_polbasic.pack_policy_id%TYPE;
   v_expiry_date              gipi_polbasic.expiry_date%TYPE;
   v_incept_date              gipi_polbasic.incept_date%TYPE;
   v_eff_date                 gipi_polbasic.eff_date%TYPE;
   v_assd_no                  gipi_polbasic.assd_no%TYPE;
   v_ext_date                 gipi_polbasic.expiry_date%TYPE := SYSDATE;
   v_tsi                      gipi_polbasic.tsi_amt%TYPE;
   v_prem                     gipi_polbasic.prem_amt%TYPE;
   v_pol_id                   gipi_polbasic.policy_id%TYPE;
   v_exp_date                 gipi_polbasic.expiry_date%TYPE;
   v_inc_date                 gipi_polbasic.incept_date%TYPE;
   v_spld_flag                gipi_polbasic.spld_flag%TYPE;
   v_expiry_tag               gipi_polbasic.expiry_tag%TYPE;
   v_policy_id                gipi_polbasic.policy_id%TYPE;
   v_intm_no                  gipi_comm_invoice.intrmdry_intm_no%TYPE;
   v_auto_sw                  giex_expiry.auto_sw%TYPE := 'Y';
   v_ren_flag                 giex_expiry.renew_flag%TYPE;
   v_summ_sw                  giex_expiry.summary_sw%TYPE;
   v_same_sw                  giex_expiry.same_polno_sw%TYPE;
   v_reg_pol_sw               giex_expiry.reg_policy_sw%TYPE; -- jenny vi lim 02092005
   v_renewal_id               giex_expiry.renewal_id%TYPE; -- jenny vi lim 02102005
   v_tax                      giex_expiry.tax_amt%TYPE;
   v_pol_tax                  giex_expiry.tax_amt%TYPE;
   v_car_company              giex_expiry.car_company%TYPE;
   v_rate                     gipi_item.currency_rt%TYPE;
   v_item_title               gipi_item.item_title%TYPE;
   v_color                    gipi_vehicle.color%TYPE;
   v_motor_no                 gipi_vehicle.motor_no%TYPE;
   v_model_year               gipi_vehicle.model_year%TYPE;
   v_make                     gipi_vehicle.make%TYPE;
   v_serial_no                gipi_vehicle.serial_no%TYPE;
   v_plate_no                 gipi_vehicle.plate_no%TYPE;
   v_item_no                  gipi_vehicle.item_no%TYPE;
   v_line_mc                  giis_line.line_cd%TYPE;
   v_line_fi                  giis_line.line_cd%TYPE;
   v_loc_risk1                gipi_fireitem.loc_risk1%TYPE;
   v_loc_risk2                gipi_fireitem.loc_risk2%TYPE;
   v_loc_risk3                gipi_fireitem.loc_risk3%TYPE;
   o_line_cd                  giex_expiry.line_cd%TYPE;
   o_peril_cd                 giex_old_group_peril.peril_cd%TYPE;
   o_prem_amt2                giex_old_group_peril.prem_amt%TYPE;
   o_tsi_amt2                 giex_old_group_peril.tsi_amt%TYPE;
   o_ren_prem_amt2            giex_old_group_peril.prem_amt%TYPE;
   o_ren_tsi_amt2             giex_old_group_peril.tsi_amt%TYPE;
   v_orig_tsi_exp             giex_expiry.tsi_amt%TYPE;
   v_orig_tsi_item            giex_expiry.tsi_amt%TYPE;
   v_orig_tsi_ngrp            giex_expiry.tsi_amt%TYPE;
   v_orig_tsi_ogrp            giex_expiry.tsi_amt%TYPE;
   v_orig_prm_ogrp            giex_expiry.prem_amt%TYPE;
   v_ren_tsi_ogrp             giex_expiry.ren_tsi_amt%TYPE;
   v_ren_prm_ogrp             giex_expiry.ren_prem_amt%TYPE;
   v_auto_dep giis_parameters.param_value_v%TYPE
         := NVL (Giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N') ; --VARCHAR2(2);/*commented by cherrie, to consolidate changes on process_expiring_policy version 022812;*/
   v_dep_pct giis_parameters.param_value_v%TYPE
         := NVL (Giisp.n ('MC_DEP_PCT'), 0) ; --NUMBER;/*commented by cherrie, to consolidate changes on process_expiring_policy version 022812;*/
   v_total_dep_tsi            giex_expiry.tsi_amt%TYPE := 0;
   v_total_dep_prm            giex_expiry.prem_amt%TYPE := 0;
   v_total_ren_tsi            giex_expiry.ren_tsi_amt%TYPE := 0;
   v_total_ren_prm            giex_expiry.ren_prem_amt%TYPE := 0;
   v_dep_tax_amt              gipi_inv_tax.tax_amt%TYPE := 0;
   v_extraction               VARCHAR2 (1);
   v_ctr                      NUMBER;
   /*
   ** by: gmi fajarito
   ** added (risk_no, risk_item_no) of gipi_item in extraction to giex_expiry
   ** added (motor_coverage) of gipi_vehicle in extraction to giex_expiry
   ** dated: 060707
   */
   v_risk_no                  giex_expiry.risk_no%TYPE;
   v_risk_item_no             giex_expiry.risk_item_no%TYPE;
   v_motor_coverage           giex_expiry.motor_coverage%TYPE;
   /* gmi package variables */
   pck_counter                NUMBER := 1;
   pck_cnt                    NUMBER := 1;
   pck_count                  NUMBER := 0;
   pck_policy_no              VARCHAR2 (100); --variable to keep the record being processed
   pck_policy_ids             VARCHAR2 (32000); --variable to keep the policy_ids
   pck_expiry_sw              VARCHAR2 (1) := 'N'; --to identify if the policy already exists in giex_expiry.
   pck_clm                    VARCHAR2 (1);
   pck_bal                    VARCHAR2 (1);
   pck_sw                     VARCHAR2 (1) := 'N';
   pck_intm_sw                VARCHAR2 (1) := 'N';
   pck_line_cd                gipi_polbasic.line_cd%TYPE;
   pck_subline_cd             gipi_polbasic.subline_cd%TYPE;
   pck_iss_cd                 gipi_polbasic.iss_cd%TYPE;
   pck_issue_yy               gipi_polbasic.issue_yy%TYPE;
   pck_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE;
   pck_renew_no               gipi_polbasic.renew_no%TYPE;
   pck_back_stat              gipi_polbasic.back_stat%TYPE; --new, to identify backward endorsement
   pck_endt_seq_no            gipi_polbasic.endt_seq_no%TYPE; --to check if original policy is already in giex_expiry
   pck_expiry_date            gipi_polbasic.expiry_date%TYPE;
   pck_incept_date            gipi_polbasic.incept_date%TYPE;
   pck_eff_date               gipi_polbasic.eff_date%TYPE;
   pck_assd_no                gipi_polbasic.assd_no%TYPE;
   pck_ext_date               gipi_polbasic.expiry_date%TYPE := SYSDATE;
   pck_tsi                    gipi_polbasic.tsi_amt%TYPE;
   pck_prem                   gipi_polbasic.prem_amt%TYPE;
   pck_pol_id                 gipi_polbasic.policy_id%TYPE;
   pck_exp_date               gipi_polbasic.expiry_date%TYPE;
   pck_inc_date               gipi_polbasic.incept_date%TYPE;
   pck_spld_flag              gipi_polbasic.spld_flag%TYPE;
   pck_expiry_tag             gipi_polbasic.expiry_tag%TYPE;
   pck_policy_id              gipi_polbasic.policy_id%TYPE;
   pck_intm_no                gipi_comm_invoice.intrmdry_intm_no%TYPE;
   pck_auto_sw                giex_expiry.auto_sw%TYPE := 'Y';
   pck_ren_flag               giex_expiry.renew_flag%TYPE;
   pck_summ_sw                giex_expiry.summary_sw%TYPE;
   pck_same_sw                giex_expiry.same_polno_sw%TYPE;
   pck_reg_pol_sw             giex_expiry.reg_policy_sw%TYPE; -- jenny vi lim 02092005
   pck_renewal_id             giex_expiry.renewal_id%TYPE; -- jenny vi lim 02102005
   pck_tax                    giex_expiry.tax_amt%TYPE;
   pck_pol_tax                giex_expiry.tax_amt%TYPE;
   pck_car_company            giex_expiry.car_company%TYPE;
   pck_rate                   gipi_item.currency_rt%TYPE;
   pck_item_title             gipi_item.item_title%TYPE;
   pck_color                  gipi_vehicle.color%TYPE;
   pck_motor_no               gipi_vehicle.motor_no%TYPE;
   pck_model_year             gipi_vehicle.model_year%TYPE;
   pck_make                   gipi_vehicle.make%TYPE;
   pck_serial_no              gipi_vehicle.serial_no%TYPE;
   pck_plate_no               gipi_vehicle.plate_no%TYPE;
   pck_item_no                gipi_vehicle.item_no%TYPE;
   pck_line_mc                giis_line.line_cd%TYPE;
   pck_line_fi                giis_line.line_cd%TYPE;
   pck_loc_risk1              gipi_fireitem.loc_risk1%TYPE;
   pck_loc_risk2              gipi_fireitem.loc_risk2%TYPE;
   pck_loc_risk3              gipi_fireitem.loc_risk3%TYPE;
   o_pck_line_cd              giex_expiry.line_cd%TYPE;
   o_pck_peril_cd             giex_old_group_peril.peril_cd%TYPE;
   o_pck_prem_amt2            giex_old_group_peril.prem_amt%TYPE;
   o_pck_tsi_amt2             giex_old_group_peril.tsi_amt%TYPE;
   o_pck_ren_prem_amt2        giex_old_group_peril.prem_amt%TYPE;
   o_pck_ren_tsi_amt2         giex_old_group_peril.tsi_amt%TYPE;
   pck_orig_tsi_exp           giex_expiry.tsi_amt%TYPE;
   pck_orig_tsi_item          giex_expiry.tsi_amt%TYPE;
   pck_orig_tsi_ngrp          giex_expiry.tsi_amt%TYPE;
   pck_orig_tsi_ogrp          giex_expiry.tsi_amt%TYPE;
   pck_orig_prm_ogrp          giex_expiry.prem_amt%TYPE;
   pck_ren_tsi_ogrp           giex_expiry.ren_tsi_amt%TYPE;
   pck_ren_prm_ogrp           giex_expiry.ren_prem_amt%TYPE;
   pck_auto_dep               VARCHAR2 (2);
   pck_dep_pct                NUMBER;
   pck_total_dep_tsi          giex_expiry.tsi_amt%TYPE := 0;
   pck_total_dep_prm          giex_expiry.prem_amt%TYPE := 0;
   pck_total_ren_tsi          giex_expiry.ren_tsi_amt%TYPE := 0;
   pck_total_ren_prm          giex_expiry.ren_prem_amt%TYPE := 0;
   pck_dep_tax_amt            gipi_inv_tax.tax_amt%TYPE := 0;
   pck_extraction             VARCHAR2 (1);
   pck_ctr                    NUMBER;
   /*
   ** by: gmi fajarito
   ** added (risk_no, risk_item_no) of gipi_item in extraction to giex_expiry
   ** added (motor_coverage) of gipi_vehicle in extraction to giex_expiry
   ** dated: 060707
   */
   pck_risk_no                giex_expiry.risk_no%TYPE;
   pck_risk_item_no           giex_expiry.risk_item_no%TYPE;
   pck_motor_coverage         giex_expiry.motor_coverage%TYPE;
   -- var for details of package and non-package --
   t2_policy_id               DBMS_SQL.number_table;
   t2_line_cd                 DBMS_SQL.varchar2_table;
   t2_subline_cd              DBMS_SQL.varchar2_table;
   t2_iss_cd                  DBMS_SQL.varchar2_table;
   t2_issue_yy                DBMS_SQL.number_table;
   t2_pol_seq_no              DBMS_SQL.number_table;
   t2_renew_no                DBMS_SQL.number_table;
   t2_expiry_date             DBMS_SQL.date_table;
   t2_incept_date             DBMS_SQL.date_table;
   t2_assd_no                 DBMS_SQL.number_table;
   t2_auto_sw                 DBMS_SQL.varchar2_table;
   t2_intm_no                 DBMS_SQL.number_table;
   /* gmi package variables (end)*/
   v_doc_stamps giac_parameters.param_value_n%TYPE
         := giacp.n ('DOC_STAMPS') ;
   v_param_doc giis_parameters.param_value_v%TYPE
         := giisp.v ('COMPUTE_OLD_DOC_STAMPS') ;
   v_acct_iss_cd              giis_issource.acct_iss_cd%TYPE := NULL;
   v_ref_no                   NUMBER;
   v_mod_no                   NUMBER;
   v_ref                      giex_expiry.bank_ref_no%TYPE := NULL;
   v_param_pa_doc giis_parameters.param_value_v%TYPE
         := giisp.v ('COMPUTE_PA_DOC_STAMPS') ;           --Cherrie | 09082012
BEGIN
   -- rollie 31mar2006
   -- to verify how extraction will be done ( policy/date )
   IF    p_line_cd IS NULL
      OR p_subline_cd IS NULL
      OR p_iss_cd IS NULL
      OR p_issue_yy IS NULL
      OR p_pol_seq_no IS NULL
      OR p_renew_no IS NULL
   THEN
      pck_extraction := 'D';
   ELSE
      pck_extraction := 'P';
   END IF;

   -- rollie 20OCT2004
   -- for variables of depreciation
   --v_auto_dep := Giisp.v('AUTO_COMPUTE_MC_DEP');/*commented by cherrie, to consolidate changes on process_expiring_policy version 022812;*/
   --v_dep_pct  := Giisp.n('MC_DEP_PCT');/*commented by cherrie, to consolidate changes on process_expiring_policy version 022812;*/
   /* gmi 051707
   ** for package extraction
   */
   pck_auto_dep := giisp.v ('AUTO_COMPUTE_MC_DEP');
   pck_dep_pct := giisp.n ('MC_DEP_PCT');

   FOR a1
   IN (SELECT   a.line_cd,
                a.subline_cd,
                a.iss_cd,
                a.issue_yy,
                a.pol_seq_no,
                a.renew_no,
                a.endt_seq_no,
                   a.line_cd
                || a.subline_cd
                || a.iss_cd
                || a.issue_yy
                || a.pol_seq_no
                || a.renew_no
                   pack_policy_no,
                a.pack_policy_id,
                a.eff_date eff_date,
                TRUNC (a.expiry_date) expiry_date,
                a.assd_no,
                a.incept_date,
                NVL (a.spld_flag, '1') spld_flag,
                a.expiry_tag,
                a.back_stat,
                a.reg_policy_sw
         FROM   gipi_pack_polbasic a, giis_subline b, giis_line c
        WHERE   1 = 1
                AND EXISTS
                      (SELECT   1
                         FROM   gipi_vehicle gpv, gipi_polbasic j
                        WHERE       1 = 1
                                AND j.pack_policy_id = a.pack_policy_id
                                AND j.policy_id = gpv.policy_id
                                AND gpv.plate_no LIKE '%' || p_plate_no
                       UNION ALL
                       SELECT   1
                         FROM   DUAL
                        WHERE   1 = DECODE (p_plate_no, NULL, 1, 2))
                AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
                AND a.line_cd = c.line_cd         --added by vercel 08.04.2008
                AND b.op_flag = 'N'
                AND (NVL (b.non_renewal_tag, 'N') <> 'Y'
                     AND NVL (c.non_renewal_tag, 'N') <> 'Y') --added by vercel 08.04.2008
                AND a.pol_flag IN ('1', '2', '3')
                AND a.iss_cd NOT IN ('RI', 'BB')
                AND NVL (a.reg_policy_sw, 'Y') =
                      DECODE (NVL (inc_special_sw, 'N'),
                              'N', 'Y',
                              NVL (a.reg_policy_sw, 'Y'))
                AND a.line_cd LIKE p_line_cd || '%'
                AND a.subline_cd LIKE p_subline_cd || '%'
                AND a.iss_cd LIKE p_iss_cd || '%'
                AND a.issue_yy =
                      DECODE (pck_extraction, 'P', p_issue_yy, a.issue_yy)
                AND a.pol_seq_no =
                      DECODE (pck_extraction,
                              'P', p_pol_seq_no,
                              a.pol_seq_no)
                AND a.renew_no =
                      DECODE (pck_extraction, 'P', p_renew_no, a.renew_no)
                /*To check for policies already renewed(using manual renew).*/
                AND NOT EXISTS
                      (SELECT   '1'
                         FROM   gipi_pack_polbasic x, gipi_pack_polnrep y
                        WHERE       1 = 1
                                AND x.pack_policy_id = y.old_pack_policy_id
                                AND x.line_cd = a.line_cd
                                AND x.subline_cd = a.subline_cd
                                AND x.iss_cd = a.iss_cd
                                AND x.issue_yy = a.issue_yy
                                AND x.pol_seq_no = a.pol_seq_no
                                AND x.renew_no = a.renew_no)
                AND NOT EXISTS
                      (SELECT   '1'
                         FROM   gipi_pack_polbasic x, gipi_pack_wpolnrep y
                        WHERE       1 = 1
                                AND x.pack_policy_id = y.old_pack_policy_id
                                AND x.line_cd = a.line_cd
                                AND x.subline_cd = a.subline_cd
                                AND x.iss_cd = a.iss_cd
                                AND x.issue_yy = a.issue_yy
                                AND x.pol_seq_no = a.pol_seq_no
                                AND x.renew_no = a.renew_no)
                AND NOT EXISTS (SELECT   '1'
                                  FROM   giex_pack_expiry c
                                 WHERE   a.pack_policy_id = c.pack_policy_id)
                AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GIEXS001') =
                      1
                AND (a.endt_seq_no = 0
                     OR (a.endt_seq_no > 0
                         AND TRUNC (a.endt_expiry_date) >=
                               TRUNC (a.expiry_date)))
       UNION
       SELECT   'XX',
                'XX',
                'XX',
                0,
                0,
                0,
                0,
                'XX',
                0,
                SYSDATE,
                SYSDATE,
                0,
                SYSDATE,
                '1',
                'N',
                0,
                'Y'
         FROM   DUAL                                    -- FOR THE LAST RECORD
       ORDER BY   1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  10 DESC,
                  7 DESC,
                  11,
                  12,
                  9)
   LOOP
      -- records to be fetched will be accumulated then processed when a new policy is encountered
      IF pck_policy_no IS NULL OR pck_policy_no = a1.pack_policy_no
      THEN
         IF a1.endt_seq_no = 0
         THEN
            pck_endt_seq_no := a1.endt_seq_no;
            pck_policy_id := a1.pack_policy_id;
         END IF;

         IF pck_policy_no IS NULL
         THEN
            pck_policy_ids := a1.pack_policy_id;
         ELSE
            pck_policy_ids := pck_policy_ids || ',' || a1.pack_policy_id;
         END IF;

         pck_line_cd := a1.line_cd;
         pck_subline_cd := a1.subline_cd;
         pck_iss_cd := a1.iss_cd;
         pck_issue_yy := a1.issue_yy;
         pck_pol_seq_no := a1.pol_seq_no;
         pck_renew_no := a1.renew_no;
         pck_back_stat := a1.back_stat;
         pck_reg_pol_sw := a1.reg_policy_sw;

         --this will assure that you will get the latest change
         IF pck_eff_date IS NULL
            OR pck_eff_date > a1.eff_date AND a1.endt_seq_no <> 0
         THEN
            pck_eff_date := a1.eff_date;
         END IF;

         IF pck_expiry_date IS NULL
            OR pck_expiry_date <> a1.expiry_date AND a1.endt_seq_no <> 0
         THEN
            pck_expiry_date := a1.expiry_date;
         END IF;

         IF pck_incept_date IS NULL
            OR pck_incept_date <> a1.incept_date AND a1.endt_seq_no <> 0
         THEN
            pck_incept_date := a1.incept_date;
         END IF;

         IF pck_assd_no IS NULL
         THEN
            pck_assd_no := a1.assd_no;
         END IF;

         IF NVL (pck_auto_sw, 'Y') = 'Y'
         THEN
            IF a1.endt_seq_no <> 0
            THEN
               pck_auto_sw := 'N';
            END IF;
         END IF;

         pck_policy_no := a1.pack_policy_no;
         pck_spld_flag := NVL (a1.spld_flag, '1');
         pck_expiry_tag := NVL (a1.expiry_tag, 'N');
      --processing new package policy already
      ELSIF pck_policy_no != a1.pack_policy_no
      THEN
         -- original package policy was already expired
         IF NVL (pck_endt_seq_no, 1) != 0 AND pck_back_stat <> 2
         THEN
            NULL;
         ELSE
            IF (TRUNC (pck_expiry_date) >= TRUNC (p_fr_date)
                AND TRUNC (pck_expiry_date) <= TRUNC (p_to_date))
               OR pck_extraction = 'P'
            THEN
               pck_intm_sw := 'N';

               IF p_intm_no IS NOT NULL
               THEN
                  pck_intm_sw := 'Y';

                  DECLARE
                     TYPE cv_type IS REF CURSOR;

                     CV       cv_type;
                     retval   NUMBER := 0;
                  BEGIN
                     OPEN CV FOR
                        'SELECT 1 FROM GIPI_COMM_INVOICE A, GIPI_POLBASIC B WHERE B.PACK_POLICY_ID IN ('
                        || pck_policy_ids
                        || ') AND INTRMDRY_INTM_NO = :INTM AND A.POLICY_ID = B.POLICY_ID AND ROWNUM = 1 '
                        USING p_intm_no;

                     LOOP
                        FETCH CV INTO   retval;

                        EXIT WHEN CV%FOUND;
                        EXIT WHEN CV%NOTFOUND;
                     END LOOP;

                     CLOSE CV;

                     IF retval = 1
                     THEN
                        pck_intm_sw := 'N';
                     END IF;
                  END;
               END IF;

               IF     pck_intm_sw = 'N'
                  AND pck_endt_seq_no = 0
                  AND pck_policy_id IS NOT NULL
                  AND pck_policy_no != 'XX'
                  AND pck_spld_flag <> '2'
                  AND pck_expiry_tag = 'N'
                  AND pck_expiry_sw = 'N'
               THEN
                  pck_counter := pck_counter + 1;

                  FOR z1
                  IN (  SELECT   endt_seq_no, expiry_date, incept_date
                          FROM   gipi_pack_polbasic b2501
                         WHERE       b2501.line_cd = pck_line_cd
                                 AND b2501.subline_cd = pck_subline_cd
                                 AND b2501.iss_cd = pck_iss_cd
                                 AND b2501.issue_yy = pck_issue_yy
                                 AND b2501.pol_seq_no = pck_pol_seq_no
                                 AND b2501.renew_no = pck_renew_no
                                 AND b2501.pol_flag IN ('1', '2', '3')
                                 AND NVL (b2501.back_stat, 5) = 2
                                 AND (b2501.endt_seq_no = 0
                                      OR (b2501.endt_seq_no > 0
                                          AND TRUNC (b2501.endt_expiry_date) >=
                                                TRUNC (b2501.expiry_date)))
                      ORDER BY   endt_seq_no DESC)
                  LOOP
                     -- get the last endorsement sequence of the policy
                     FOR z1a
                     IN (  SELECT   endt_seq_no,
                                    eff_date,
                                    expiry_date,
                                    incept_date
                             FROM   gipi_pack_polbasic b2501
                            WHERE       b2501.line_cd = pck_line_cd
                                    AND b2501.subline_cd = pck_subline_cd
                                    AND b2501.iss_cd = pck_iss_cd
                                    AND b2501.issue_yy = pck_issue_yy
                                    AND b2501.pol_seq_no = pck_pol_seq_no
                                    AND b2501.renew_no = pck_renew_no
                                    AND b2501.pol_flag IN ('1', '2', '3')
                                    AND (b2501.endt_seq_no = 0
                                         OR (b2501.endt_seq_no > 0
                                             AND TRUNC (b2501.endt_expiry_date) >=
                                                   TRUNC (b2501.expiry_date)))
                         ORDER BY   endt_seq_no DESC)
                     LOOP
                        IF z1.endt_seq_no = z1a.endt_seq_no
                        THEN
                           pck_expiry_date := z1.expiry_date;
                           pck_incept_date := z1.incept_date;
                        ELSE
                           IF z1a.eff_date > v_eff_date
                           THEN
                              pck_expiry_date := z1a.expiry_date;
                              pck_incept_date := z1a.incept_date;
                           ELSE
                              pck_expiry_date := z1.expiry_date;
                              pck_incept_date := z1.incept_date;
                           END IF;
                        END IF;

                        EXIT;
                     END LOOP;

                     EXIT;
                  END LOOP;

                  -- get the last endorsement sequence of the latest backward endt
                  FOR z3
                  IN (  SELECT   endt_seq_no, assd_no
                          FROM   gipi_pack_polbasic b2501
                         WHERE       b2501.line_cd = pck_line_cd
                                 AND b2501.subline_cd = pck_subline_cd
                                 AND b2501.iss_cd = pck_iss_cd
                                 AND b2501.issue_yy = pck_issue_yy
                                 AND b2501.pol_seq_no = pck_pol_seq_no
                                 AND b2501.renew_no = pck_renew_no
                                 AND b2501.pol_flag IN ('1', '2', '3')
                                 AND assd_no IS NOT NULL
                                 AND NVL (b2501.back_stat, 5) = 2
                                 AND (b2501.endt_seq_no = 0
                                      OR (b2501.endt_seq_no > 0
                                          AND TRUNC (b2501.endt_expiry_date) >=
                                                TRUNC (b2501.expiry_date)))
                      ORDER BY   endt_seq_no DESC)
                  LOOP
                     FOR z3a
                     IN (  SELECT   endt_seq_no, eff_date, assd_no
                             FROM   gipi_pack_polbasic b2501
                            WHERE       b2501.line_cd = pck_line_cd
                                    AND b2501.subline_cd = pck_subline_cd
                                    AND b2501.iss_cd = pck_iss_cd
                                    AND b2501.issue_yy = pck_issue_yy
                                    AND b2501.pol_seq_no = pck_pol_seq_no
                                    AND b2501.renew_no = pck_renew_no
                                    AND b2501.pol_flag IN ('1', '2', '3')
                                    AND assd_no IS NOT NULL
                                    AND (b2501.endt_seq_no = 0
                                         OR (b2501.endt_seq_no > 0
                                             AND TRUNC (b2501.endt_expiry_date) >=
                                                   TRUNC (b2501.expiry_date)))
                         ORDER BY   endt_seq_no DESC)
                     LOOP
                        IF z3.endt_seq_no = z3a.endt_seq_no
                        THEN
                           pck_assd_no := z3.assd_no;
                        ELSE
                           IF z3a.eff_date > v_eff_date
                           THEN
                              pck_assd_no := z3a.assd_no;
                           ELSE
                              pck_assd_no := z3.assd_no;
                           END IF;
                        END IF;

                        EXIT;
                     END LOOP;

                     EXIT;
                  END LOOP;

                  pck_count := pck_count + 1;
                  t_policy_id (pck_count) := pck_policy_id;
                  t_line_cd (pck_count) := pck_line_cd;
                  t_subline_cd (pck_count) := pck_subline_cd;
                  t_iss_cd (pck_count) := pck_iss_cd;
                  t_issue_yy (pck_count) := pck_issue_yy;
                  t_pol_seq_no (pck_count) := pck_pol_seq_no;
                  t_renew_no (pck_count) := pck_renew_no;
                  t_expiry_date (pck_count) := pck_expiry_date;
                  t_incept_date (pck_count) := pck_incept_date;
                  t_assd_no (pck_count) := pck_assd_no;
                  t_intm_no (pck_count) := pck_intm_no;
                  t_auto_sw (pck_count) := pck_auto_sw;

                  /* added by gmi 052407 gets detail records of package
      ** gets policy records based on pack_policy records
      ** gmicode:(012303)
      */
                  FOR dtl
                  IN (SELECT   policy_id,
                               line_cd,
                               subline_cd,
                               iss_cd,
                               issue_yy,
                               pol_seq_no,
                               renew_no,
                               expiry_date,
                               incept_date,
                               assd_no
                        FROM   gipi_polbasic a
                       WHERE   pack_policy_id = pck_policy_id
                               /*AND (
                                     (
                                a.line_cd != decode(p_plate_no, null, '&&', giisp.v('LINE_CD_MC'))
                               )
                                    OR
                                     (
                                a.line_cd = decode(p_plate_no, null, a.line_cd, giisp.v('LINE_CD_MC'))
                                AND EXISTS (SELECT 1
                                           FROM GIPI_VEHICLE gpv
                                    WHERE 1 = 1
                                   AND A.policy_id = gpv.policy_id
                                   AND gpv.plate_no LIKE '%'||p_plate_no
                                   )
                               )
                                )*/
                               AND NOT EXISTS
                                     (SELECT   '1'
                                        FROM   giex_expiry c
                                       WHERE   a.policy_id = c.policy_id))
                  LOOP
                     v_count := v_count + 1;
                     t2_policy_id (v_count) := dtl.policy_id;
                     t2_line_cd (v_count) := dtl.line_cd;
                     t2_subline_cd (v_count) := dtl.subline_cd;
                     t2_iss_cd (v_count) := dtl.iss_cd;
                     t2_issue_yy (v_count) := dtl.issue_yy;
                     t2_pol_seq_no (v_count) := dtl.pol_seq_no;
                     t2_renew_no (v_count) := dtl.renew_no;
                     t2_expiry_date (v_count) := dtl.expiry_date;
                     t2_incept_date (v_count) := dtl.incept_date;
                     t2_assd_no (v_count) := dtl.assd_no;
                     t2_intm_no (v_count) := NULL;              --dtl.intm_no;
                     t2_auto_sw (v_count) := 'Y';
                  END LOOP;
               -- end of gmicode:(012303) --
               END IF;
            END IF;
         END IF;

         pck_line_cd := NULL;
         pck_subline_cd := NULL;
         pck_iss_cd := NULL;
         pck_issue_yy := NULL;
         pck_pol_seq_no := NULL;
         pck_renew_no := NULL;
         pck_expiry_date := NULL;
         pck_incept_date := NULL;
         pck_assd_no := NULL;
         pck_policy_ids := NULL;
         pck_policy_id := NULL;
         pck_endt_seq_no := NULL;
         pck_spld_flag := NULL;
         pck_expiry_tag := NULL;
         pck_reg_pol_sw := NULL;
         pck_auto_sw := 'Y';
         pck_expiry_sw := 'N';
         pck_eff_date := NULL;

         IF a1.endt_seq_no = 0
         THEN
            pck_endt_seq_no := 0;
            pck_policy_id := a1.pack_policy_id;
         END IF;

         IF a1.endt_seq_no <> 0
         THEN
            pck_auto_sw := 'N';
         END IF;

         pck_policy_ids := a1.pack_policy_id;
         pck_line_cd := a1.line_cd;
         pck_subline_cd := a1.subline_cd;
         pck_iss_cd := a1.iss_cd;
         pck_issue_yy := a1.issue_yy;
         pck_pol_seq_no := a1.pol_seq_no;
         pck_renew_no := a1.renew_no;
         pck_expiry_date := a1.expiry_date;
         pck_incept_date := a1.incept_date;
         pck_assd_no := a1.assd_no;
         pck_spld_flag := NVL (a1.spld_flag, '1');
         pck_expiry_tag := NVL (a1.expiry_tag, 'N');
         pck_policy_no := a1.pack_policy_no;
         pck_reg_pol_sw := a1.reg_policy_sw;
      END IF;
   END LOOP;                                             --(end of first loop)

   /*end of package extraction*/

   /* gmi package insertion to giex_pack_expiry gmicode:(88693) */
   IF t_policy_id.EXISTS (1)
   THEN
      pck_line_mc := giisp.v ('LINE_CODE_MC');
      pck_line_fi := giisp.v ('LINE_CODE_FI');

      FOR a1 IN t_policy_id.FIRST .. t_policy_id.LAST
      LOOP
         pck_loc_risk1 := NULL;
         pck_loc_risk2 := NULL;
         pck_loc_risk3 := NULL;
         pck_item_title := NULL;
         pck_color := NULL;
         pck_motor_no := NULL;
         pck_model_year := NULL;
         pck_car_company := NULL;
         pck_make := NULL;
         pck_serial_no := NULL;
         pck_plate_no := NULL;
         pck_item_no := NULL;
         pck_clm := NULL;
         pck_bal := NULL;
         pck_reg_pol_sw := NULL;
         pck_ren_flag := '2';
         pck_pol_id := t_policy_id (a1);
         pck_exp_date := t_expiry_date (a1);
         pck_assd_no := t_assd_no (a1);
         pck_intm_no := t_intm_no (a1);
         pck_inc_date := t_incept_date (a1);
         pck_auto_sw := t_auto_sw (a1);

         FOR a2 IN (SELECT   line_cd,
                             subline_cd,
                             iss_cd,
                             issue_yy,
                             pol_seq_no,
                             renew_no,
                             auto_renew_flag,
                             pack_policy_id,
                             reg_policy_sw,
                             ref_pol_no
                      FROM   gipi_pack_polbasic
                     WHERE   pack_policy_id = pck_pol_id)
         LOOP
            pck_reg_pol_sw := a2.reg_policy_sw;

            FOR a3
            IN (SELECT   '1'
                  FROM   gicl_claims
                 WHERE       line_cd = a2.line_cd
                         AND subline_cd = a2.subline_cd
                         AND pol_iss_cd = a2.iss_cd
                         AND issue_yy = a2.issue_yy
                         AND pol_seq_no = a2.pol_seq_no
                         AND renew_no = a2.renew_no
                         AND clm_stat_cd NOT IN ('CC', 'WD', 'DN'))
            LOOP
               v_clm := 'Y';
               EXIT;
            END LOOP;

            pck_tsi := 0;
            pck_orig_tsi_exp := 0;
            pck_prem := 0;

            FOR a4
            IN (SELECT   NVL (prem_amt, 0) prem, NVL (tsi_amt, 0) tsi
                  FROM   gipi_pack_polbasic
                 WHERE       line_cd = a2.line_cd
                         AND subline_cd = a2.subline_cd
                         AND iss_cd = a2.iss_cd
                         AND issue_yy = a2.issue_yy
                         AND pol_seq_no = a2.pol_seq_no
                         AND renew_no = a2.renew_no
                         AND pol_flag IN ('1', '2', '3')
                         AND (endt_seq_no = 0
                              OR (endt_seq_no > 0
                                  AND TRUNC (endt_expiry_date) >=
                                        TRUNC (expiry_date))))
            LOOP
               pck_orig_tsi_exp := NVL (pck_orig_tsi_exp, 0) + a4.tsi;
               pck_prem := NVL (pck_prem, 0) + a4.prem;
            END LOOP;

            FOR a5
            IN (SELECT   SUM (c.balance_amt_due) due
                  FROM   gipi_polbasic a,
                         gipi_invoice b,
                         giac_aging_soa_details c,
                         gipi_pack_polbasic x
                 WHERE       a.pack_policy_id = x.pack_policy_id
                         AND x.line_cd = a2.line_cd
                         AND x.subline_cd = a2.subline_cd
                         AND x.iss_cd = a2.iss_cd
                         AND x.issue_yy = a2.issue_yy
                         AND x.pol_seq_no = a2.pol_seq_no
                         AND x.renew_no = a2.renew_no
                         AND x.pol_flag IN ('1', '2', '3')
                         AND a.policy_id = b.policy_id
                         AND b.iss_cd = c.iss_cd
                         AND b.prem_seq_no = c.prem_seq_no
                         AND (x.endt_seq_no = 0
                              OR (x.endt_seq_no > 0
                                  AND TRUNC (x.endt_expiry_date) >=
                                        TRUNC (x.expiry_date))))
            LOOP
               IF a5.due <> 0
               THEN
                  pck_bal := 'Y';
               END IF;
            END LOOP;

            pck_tax := 0;
            pck_pol_tax := 0;

            FOR a6
            IN (  SELECT   SUM (NVL (tax_amt, 0)) tax,
                           item_grp,
                           x.pack_policy_id
                    FROM   gipi_polbasic a,
                           gipi_invoice b,
                           gipi_pack_polbasic x
                   WHERE       a.policy_id = b.policy_id
                           AND x.line_cd = a2.line_cd
                           AND x.subline_cd = a2.subline_cd
                           AND x.iss_cd = a2.iss_cd
                           AND x.issue_yy = a2.issue_yy
                           AND x.pol_seq_no = a2.pol_seq_no
                           AND x.renew_no = a2.renew_no
                           AND x.pol_flag IN ('1', '2', '3')
                           AND x.pack_policy_id = a.pack_policy_id
                           AND (x.endt_seq_no = 0
                                OR (x.endt_seq_no > 0
                                    AND TRUNC (x.endt_expiry_date) >=
                                          TRUNC (x.expiry_date)))
                GROUP BY   item_grp, x.pack_policy_id)
            LOOP
               pck_rate := 0;

               FOR a7
               IN (SELECT   currency_rt
                     FROM   gipi_item a, gipi_polbasic b
                    WHERE       item_grp = a6.item_grp
                            AND a.policy_id = b.policy_id
                            AND b.pack_policy_id = a6.pack_policy_id)
               LOOP
                  pck_rate := a7.currency_rt;
                  EXIT;
               END LOOP;

               pck_tax := pck_tax + (a6.tax * pck_rate);

               IF a2.pack_policy_id = a6.pack_policy_id
               THEN
                  pck_pol_tax := pck_pol_tax + (a6.tax * pck_rate);
               END IF;
            END LOOP;

            IF pck_auto_sw = 'Y' AND NVL (a2.auto_renew_flag, 'N') = 'Y'
            THEN
               pck_ren_flag := '3';
            END IF;

            --beth 10262000 derived the latest item title for policy
            --     with more than one item, item title would be various
            pck_item_no := NULL;

            FOR i
            IN (  SELECT   c.item_no, SUBSTR (c.item_title, 1, 50) item_title
                    FROM   gipi_polbasic a, gipi_item c, gipi_pack_polbasic x
                   WHERE       x.line_cd = a2.line_cd
                           AND x.subline_cd = a2.subline_cd
                           AND x.iss_cd = a2.iss_cd
                           AND x.issue_yy = a2.issue_yy
                           AND x.pol_seq_no = a2.pol_seq_no
                           AND x.renew_no = a2.renew_no
                           AND a.policy_id = c.policy_id
                           AND x.pol_flag IN ('1', '2', '3')
                           AND a.pack_policy_id = x.pack_policy_id
                           AND (x.endt_seq_no = 0
                                OR (x.endt_seq_no > 0
                                    AND TRUNC (x.endt_expiry_date) >=
                                          TRUNC (x.expiry_date)))
                ORDER BY   x.eff_date ASC)
            LOOP
               IF NVL (pck_item_no, i.item_no) = i.item_no
               THEN
                  pck_item_no := i.item_no;
                  pck_item_title := i.item_title;
               ELSE
                  pck_item_title := 'VARIOUS';
                  EXIT;
               END IF;
            END LOOP;

            --beth 10262000 for fire derived location of risk
            --     if location of risk is not the same for more than one item
            --     the value of location of risk would be various
            IF a2.line_cd = pck_line_fi
            THEN
               pck_item_no := NULL;

               FOR fi
               IN (  SELECT   SUBSTR (b.loc_risk1, 1, 50) loc_risk1,
                              SUBSTR (b.loc_risk2, 1, 50) loc_risk2,
                              SUBSTR (b.loc_risk3, 1, 50) loc_risk3,
                              c.risk_no,               -- added by gmi  060707
                              c.risk_item_no,          -- added by gmi  060707
                              b.item_no
                       FROM   gipi_polbasic a,
                              gipi_fireitem b,
                              gipi_item c,
                              gipi_pack_polbasic x
                      WHERE       x.line_cd = a2.line_cd
                              AND x.subline_cd = a2.subline_cd
                              AND x.iss_cd = a2.iss_cd
                              AND x.issue_yy = a2.issue_yy
                              AND x.pol_seq_no = a2.pol_seq_no
                              AND x.renew_no = a2.renew_no
                              AND a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.item_no = c.item_no
                              AND x.pol_flag IN ('1', '2', '3')
                              AND a.pack_policy_id = x.pack_policy_id
                              AND (x.endt_seq_no = 0
                                   OR (x.endt_seq_no > 0
                                       AND TRUNC (x.endt_expiry_date) >=
                                             TRUNC (x.expiry_date)))
                   ORDER BY   b.item_no, x.eff_date ASC)
               LOOP
                  IF NVL (pck_item_no, fi.item_no) = fi.item_no
                  THEN
                     pck_item_no := fi.item_no;

                     IF    fi.loc_risk1 IS NOT NULL
                        OR fi.loc_risk2 IS NOT NULL
                        OR fi.loc_risk3 IS NOT NULL
                     THEN
                        pck_loc_risk1 := fi.loc_risk1;
                        pck_loc_risk2 := fi.loc_risk2;
                        pck_loc_risk3 := fi.loc_risk3;
                        pck_risk_no := fi.risk_no;     -- added by gmi  060707
                        pck_risk_item_no := fi.risk_item_no; -- added by gmi  060707
                     END IF;
                  ELSIF NVL (pck_item_no, fi.item_no) <> fi.item_no
                  THEN
                     IF     pck_loc_risk1 IS NULL
                        AND pck_loc_risk2 IS NULL
                        AND pck_loc_risk3 IS NULL
                     THEN
                        pck_item_no := fi.item_no;

                        IF    fi.loc_risk1 IS NOT NULL
                           OR fi.loc_risk2 IS NOT NULL
                           OR fi.loc_risk3 IS NOT NULL
                        THEN
                           pck_loc_risk1 := fi.loc_risk1;
                           pck_loc_risk2 := fi.loc_risk2;
                           pck_loc_risk3 := fi.loc_risk3;
                           pck_risk_no := fi.risk_no;  -- added by gmi  060707
                           pck_risk_item_no := fi.risk_item_no; -- added by gmi  060707
                        END IF;
                     ELSIF NVL (pck_loc_risk1, '%^&') <> NVL (fi.loc_risk1, '%^&') OR NVL (pck_loc_risk2, '%^&') <> NVL (fi.loc_risk2, '%^&') OR NVL (pck_loc_risk3, '%^&') <> NVL (fi.loc_risk3, '%^&')
                     THEN
                        pck_loc_risk1 := 'VARIOUS';
                        pck_loc_risk2 := NULL;
                        pck_loc_risk3 := NULL;
                        pck_risk_no := fi.risk_no;     -- added by gmi  060707
                        pck_risk_item_no := fi.risk_item_no; -- added by gmi  060707
                        EXIT;
                     END IF;
                  END IF;
               END LOOP;
            END IF;

            IF a2.line_cd = pck_line_mc
            THEN
               pck_item_no := NULL;

               FOR a9
               IN (  SELECT   b.color,
                              b.motor_no,
                              b.model_year,
                              d.car_company,
                              b.make,
                              b.serial_no,
                              b.plate_no,
                              b.item_no,
                              b.motor_coverage           --added by gmi 060707
                       FROM   gipi_polbasic a,
                              gipi_vehicle b,
                              gipi_item c,
                              giis_mc_car_company d,
                              gipi_pack_polbasic x
                      WHERE       x.line_cd = a2.line_cd
                              AND x.subline_cd = a2.subline_cd
                              AND x.iss_cd = a2.iss_cd
                              AND x.issue_yy = a2.issue_yy
                              AND x.pol_seq_no = a2.pol_seq_no
                              AND x.renew_no = a2.renew_no
                              AND a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.item_no = c.item_no
                              AND b.car_company_cd = d.car_company_cd(+)
                              AND a.pol_flag IN ('1', '2', '3')
                              AND a.pack_policy_id = x.pack_policy_id
                              AND (x.endt_seq_no = 0
                                   OR (x.endt_seq_no > 0
                                       AND TRUNC (x.endt_expiry_date) >=
                                             TRUNC (x.expiry_date)))
                   ORDER BY   x.eff_date ASC)
               LOOP
                  IF NVL (pck_item_no, a9.item_no) = a9.item_no
                  THEN
                     pck_item_no := a9.item_no;
                     pck_color := NVL (a9.color, pck_color);
                     pck_motor_no := NVL (a9.motor_no, pck_motor_no);
                     pck_model_year := NVL (a9.model_year, pck_model_year);
                     pck_make := NVL (a9.make, pck_make);
                     pck_serial_no := NVL (a9.serial_no, pck_serial_no);
                     pck_plate_no := NVL (a9.plate_no, pck_plate_no);
                     pck_car_company := NVL (a9.car_company, pck_car_company);
                     pck_motor_coverage :=
                        NVL (a9.motor_coverage, v_motor_coverage); --added by gmi 060707
                  ELSE
                     pck_color := 'VARIOUS';
                     pck_motor_no := 'VARIOUS';
                     pck_model_year := 'VAR.';
                     pck_make := 'VARIOUS';
                     pck_serial_no := 'VARIOUS';
                     pck_plate_no := 'VARIOUS';
                     pck_car_company := NULL;
                     pck_motor_coverage := NULL;         --added by gmi 060707
                     EXIT;
                  END IF;
               END LOOP;
            END IF;

            IF NVL (p_def_is_pol_summ_sw, 'N') != 'Y'
            THEN
               pck_summ_sw := 'N';
            ELSE
               pck_summ_sw := 'Y';
            END IF;

            IF NVL (p_def_same_polno_sw, 'N') != 'Y'
            THEN
               pck_same_sw := 'N';
            ELSE
               pck_same_sw := 'Y';
            END IF;

            pck_renewal_id :=
               TRANSLATE (a2.pack_policy_id, '0123456789', 'ABCDGJMPTW');

            /* added by VJ*/
            /* edited by petermkaw 06242010
            ** changed mod_no to bank_ref_no and v_mod_no to v_ref
            ** to acquire bank_ref_no form gipi_ref_no_hist and commented out the
            ** population of v_ref below */
            BEGIN
               SELECT   acct_iss_cd
                 INTO   v_acct_iss_cd
                 FROM   giis_issource
                WHERE   iss_cd = a2.iss_cd;
            END;

            generate_ref_no (v_acct_iss_cd,
                             0000,
                             v_ref_no,
                             'GIEXS001');

            BEGIN
               SELECT   bank_ref_no                                 /*mod_no*/
                 INTO   v_ref                                     /*v_mod_no*/
                 FROM   gipi_ref_no_hist
                WHERE       acct_iss_cd = v_acct_iss_cd
                        AND branch_cd = 0000
                        AND ref_no = v_ref_no;
            EXCEPTION
               WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
               THEN
                  NULL;
            END;

            /*v_ref:=v_acct_iss_cd||'-'||0000||'-'||v_ref_no||'-'||v_mod_no;*/
            /*--*/
            INSERT INTO giex_pack_expiry (pack_policy_id,
                                          expiry_date,
                                          line_cd,
                                          subline_cd,
                                          iss_cd,
                                          issue_yy,
                                          pol_seq_no,
                                          renew_no,
                                          claim_flag,
                                          extract_user,
                                          extract_date,
                                          user_id,
                                          last_update,
                                          renew_flag,
                                          auto_renew_flag,
                                          balance_flag,
                                          incept_date,
                                          assd_no,
                                          same_polno_sw,
                                          update_flag,
                                          summary_sw,
                                          auto_sw,
                                          tax_amt,
                                          policy_tax_amt,
                                          color,
                                          motor_no,
                                          model_year,
                                          make,
                                          serialno,
                                          plate_no,
                                          item_title,
                                          loc_risk1,
                                          loc_risk2,
                                          loc_risk3,
                                          intm_no,
                                          car_company,
                                          orig_tsi_amt,
                                          reg_policy_sw,
                                          renewal_id,
                                          risk_no,
                                          risk_item_no,
                                          motor_coverage, --added by gmi 060707
                                          bank_ref_no,
                                          ref_pol_no)
              VALUES   (a2.pack_policy_id,
                        pck_exp_date,
                        a2.line_cd,
                        a2.subline_cd,
                        a2.iss_cd,
                        a2.issue_yy,
                        a2.pol_seq_no,
                        a2.renew_no,
                        v_clm,
                        USER,
                        pck_ext_date,
                        USER,
                        SYSDATE,
                        pck_ren_flag,
                        a2.auto_renew_flag,
                        pck_bal,
                        pck_inc_date,
                        pck_assd_no,
                        pck_same_sw,
                        'N',
                        pck_summ_sw,
                        pck_auto_sw,
                        pck_tax,
                        pck_pol_tax,
                        pck_color,
                        pck_motor_no,
                        pck_model_year,
                        pck_make,
                        pck_serial_no,
                        pck_plate_no,
                        pck_item_title,
                        pck_loc_risk1,
                        pck_loc_risk2,
                        pck_loc_risk3,
                        pck_intm_no,
                        pck_car_company,
                        pck_orig_tsi_exp,
                        pck_reg_pol_sw,
                        pck_renewal_id,
                        pck_risk_no,
                        pck_risk_item_no,
                        pck_motor_coverage,              --added by gmi 060707
                        v_ref,
                        a2.ref_pol_no);

            pck_total_dep_tsi := 0;
            pck_total_dep_prm := 0;
            pck_total_ren_tsi := 0;
            pck_total_ren_prm := 0;
            pck_total_currency_prm := 0;
            pv_pck_endt_seq_no := NULL;
            v_peril_cnt := 0;

            IF t_peril_cds.EXISTS (1)
            THEN
               t_peril_cds.DELETE;
               t_item_nos.DELETE;
            END IF;
         /*FOR a8 IN (
                 SELECT (A.ann_prem_amt) currency_prem_amt,
                  (A.ann_prem_amt * C.currency_rt) ren_prem_amt,
                        (A.ann_tsi_amt * C.currency_rt) ren_tsi_amt,
                        A.line_cd, A.peril_cd,d.peril_type peril_type,
                        x.endt_seq_no, b.policy_id, C.item_no
                   FROM GIPI_ITMPERIL A,
                        GIPI_POLBASIC b,
                        GIPI_ITEM     C,
                        GIIS_PERIL    d,
                        GIPI_PACK_POLBASIC X
                  WHERE X.line_cd         = a2.line_cd
                    AND X.subline_cd      = a2.subline_cd
                    AND X.iss_cd          = a2.iss_cd
                    AND X.issue_yy        = a2.issue_yy
                    AND X.pol_seq_no      = a2.pol_seq_no
                    AND X.renew_no        = a2.renew_no
           AND d.peril_cd  = A.peril_cd
           AND d.line_cd   = A.line_cd
                    AND A.policy_id       = b.policy_id
                    AND b.policy_id       = C.policy_id
                    AND A.policy_id       = b.policy_id
                    AND A.item_no         = C.item_no
                    AND X.pol_flag        IN('1','2','3')
                    AND b.pack_policy_id  = X.pack_policy_id
                    AND NVL(X.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(X.reg_policy_sw,'Y'))
              AND (
                   X.endt_seq_no = 0 OR
                  (X.endt_seq_no > 0 AND
                   TRUNC(X.endt_expiry_date) >= TRUNC(X.expiry_date))
                  )
            ORDER BY b.policy_id, x.EFF_DATE DESC, x.ENDT_SEQ_NO DESC)
           LOOP
            IF pv_pck_policy_id <> a8.policy_id THEN
          pv_pck_endt_seq_no := NULL;
         v_peril_cnt     := 0;
         IF t_peril_cds.EXISTS(1) THEN
          t_peril_cds.DELETE;
          t_item_nos.DELETE;
         END IF;
         END IF;
         pv_pck_policy_id := a8.policy_id;
         v_skip := NULL;
            IF NVL(pv_pck_endt_seq_no,a8.endt_seq_no) <> a8.endt_seq_no THEN
              v_skip := 'N';
              FOR x1 IN t_peril_cds.FIRST.. t_peril_cds.LAST
           LOOP
            IF t_peril_cds(x1) = a8.peril_cd AND
               t_item_nos(x1)  = a8.item_no THEN
             v_skip := 'Y';
            END IF;
           END LOOP;
            END IF;
            IF v_skip IS NULL THEN
             pv_pck_endt_seq_no           := a8.endt_seq_no;
            END IF;
            IF NVL(v_skip,'N') = 'N' THEN
             v_peril_cnt              := v_peril_cnt + 1;
             t_peril_cds(v_peril_cnt) := a8.peril_cd;
             t_item_nos(v_peril_cnt)  := a8.item_no;
                o_pck_line_cd     := a8.line_cd;
                o_pck_peril_cd    := a8.peril_cd;
                pck_orig_tsi_ogrp := a8.ren_tsi_amt;
              pck_orig_prm_ogrp := a8.ren_prem_amt;
                pck_ren_tsi_ogrp  := a8.ren_tsi_amt;
             pck_ren_prm_ogrp  := a8.ren_prem_amt;
          pck_currency_prm_ogrp := a8.currency_prem_amt;
             BEGIN
              SELECT 'Y'
                INTO pck_auto_dep
                FROM GIEX_DEP_PERL
               WHERE line_cd  = a8.line_cd
                 AND peril_cd = a8.peril_cd;
             EXCEPTION
              WHEN NO_DATA_FOUND THEN
               pck_auto_dep := 'N';
              WHEN TOO_MANY_ROWS THEN
               pck_auto_dep := 'Y';
             END;
             IF pck_auto_dep = 'Y' THEN
                o_pck_ren_tsi_amt2       := pck_ren_tsi_ogrp - (pck_ren_tsi_ogrp * (pck_dep_pct/100));
                o_pck_ren_prem_amt2      := pck_ren_prm_ogrp - (pck_ren_prm_ogrp * (pck_dep_pct/100));
          o_pck_currency_prem_amt2 := pck_currency_prm_ogrp - (pck_currency_prm_ogrp * (pck_dep_pct/100));
             ELSE
                o_pck_ren_tsi_amt2       := pck_ren_tsi_ogrp;
                o_pck_ren_prem_amt2      := pck_ren_prm_ogrp;
          o_pck_currency_prem_amt2 := pck_currency_prm_ogrp;
             END IF;
             IF a8.peril_type = 'B' THEN
                pck_total_ren_tsi := NVL(pck_total_ren_tsi,0) + o_pck_ren_tsi_amt2;
             END IF;
             pck_total_ren_prm := NVL(pck_total_ren_prm,0) + o_pck_ren_prem_amt2;
             pck_total_currency_prm := NVL(pck_total_currency_prm,0) + o_pck_currency_prem_amt2;
         END IF; --v_skip IF --
          END LOOP;
          FOR a8 IN (
           SELECT SUM(A.prem_amt * C.currency_rt) prem_amt2,
                  SUM(A.tsi_amt * C.currency_rt) tsi_amt2,
                        A.line_cd, A.peril_cd,d.peril_type peril_type
                   FROM GIPI_ITMPERIL      A,
                        GIPI_POLBASIC      b,
                        GIPI_ITEM          C,
               GIIS_PERIL         d,
               GIPI_PACK_POLBASIC X
                  WHERE X.line_cd         = a2.line_cd
                    AND X.subline_cd      = a2.subline_cd
                    AND X.iss_cd          = a2.iss_cd
                    AND X.issue_yy        = a2.issue_yy
                    AND X.pol_seq_no      = a2.pol_seq_no
                    AND X.renew_no        = a2.renew_no
           AND d.peril_cd        = A.peril_cd
           AND d.line_cd         = A.line_cd
                    AND A.policy_id       = b.policy_id
                    AND b.policy_id       = C.policy_id
                    AND A.policy_id       = b.policy_id
                    AND A.item_no         = C.item_no
                    AND X.pol_flag        IN('1','2','3')
                    AND b.pack_policy_id  = X.pack_policy_id
                    AND NVL(X.reg_policy_sw,'Y') = DECODE(NVL(inc_special_sw,'N'),'N','Y',NVL(X.reg_policy_sw,'Y'))
              AND (
                  X.endt_seq_no = 0 OR
                  (X.endt_seq_no > 0 AND
                    TRUNC(X.endt_expiry_date) >= TRUNC(X.expiry_date))
                  )
                  GROUP BY A.peril_cd, A.line_cd, d.peril_type)
               LOOP
                 o_pck_line_cd     := a8.line_cd;
                 o_pck_peril_cd    := a8.peril_cd;
                 o_pck_prem_amt2   := a8.prem_amt2;
                 o_pck_tsi_amt2    := a8.tsi_amt2;
           IF a8.peril_type = 'B' THEN
             pck_total_dep_tsi := NVL(pck_total_dep_tsi,0) + o_pck_tsi_amt2;
           END IF;
           pck_total_dep_prm := NVL(pck_total_dep_prm,0) + o_pck_prem_amt2;
           END LOOP;

         UPDATE GIEX_PACK_EXPIRY
            SET tsi_amt           = pck_total_dep_tsi,
          prem_amt          = pck_total_dep_prm,
          ren_tsi_amt       = pck_total_ren_tsi,
          ren_prem_amt      = pck_total_ren_prm,
          currency_prem_amt = pck_total_currency_prm
          WHERE pack_policy_id = a2.pack_policy_id;*/
         END LOOP;
      --gmicode:(00069) comment out? +
      /*FOR m IN ( SELECT intrmdry_intm_no
                   FROM GIPI_COMM_INVOICE
                  WHERE policy_id = v_pol_id ) LOOP
          UPDATE GIEX_EXPIRY
             SET intm_no = m.intrmdry_intm_no
           WHERE policy_id = v_pol_id;
          EXIT;
      END LOOP;*/
      END LOOP;
   END IF;

   /* end of gmicode:(88693)*/

   /* gmicode:(9336953) details of package records and non-package details*/
   -- rollie 20OCT2004
   -- for variables of depreciation
   -- rollie 31mar2006
   -- to verify how extraction will be done ( policy/date )
   IF    p_line_cd IS NULL
      OR p_subline_cd IS NULL
      OR p_iss_cd IS NULL
      OR p_issue_yy IS NULL
      OR p_pol_seq_no IS NULL
      OR p_renew_no IS NULL
   THEN
      v_extraction := 'D';
   ELSE
      v_extraction := 'P';
   END IF;

   v_auto_dep := giisp.v ('AUTO_COMPUTE_MC_DEP');
   v_dep_pct := giisp.n ('MC_DEP_PCT');

   FOR a1
   IN (SELECT   a.line_cd,
                a.subline_cd,
                a.iss_cd,
                a.issue_yy,
                a.pol_seq_no,
                a.renew_no,
                a.endt_seq_no,
                   a.line_cd
                || a.subline_cd
                || a.iss_cd
                || a.issue_yy
                || a.pol_seq_no
                || a.renew_no
                   policy_no,
                a.policy_id,
                a.eff_date eff_date,
                TRUNC (a.expiry_date) expiry_date,
                a.assd_no,
                a.incept_date,
                NVL (a.spld_flag, '1') spld_flag,
                a.expiry_tag,
                a.back_stat,
                a.reg_policy_sw
         FROM   gipi_polbasic a, giis_subline b, giis_line c
        WHERE   1 = 1
                -- jimmy cute super
                -- etong pamalit sa pag-hahanap using plate number ok oko ko kok
                AND EXISTS
                      (SELECT   1
                         FROM   gipi_vehicle gpv
                        WHERE       1 = 1
                                AND a.policy_id = gpv.policy_id
                                AND gpv.plate_no LIKE '%' || p_plate_no
                       UNION ALL
                       SELECT   1
                         FROM   DUAL
                        WHERE   1 = DECODE (p_plate_no, NULL, 1, 2))
                AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
                AND a.line_cd = c.line_cd         --added by vercel 08.04.2008
                AND (NVL (b.non_renewal_tag, 'N') <> 'Y'
                     AND NVL (c.non_renewal_tag, 'N') <> 'Y') --added by vercel 08.04.2008
                AND b.op_flag = 'N'
                AND a.pol_flag IN ('1', '2', '3')
                AND a.iss_cd NOT IN ('RI', 'BB')
                AND NVL (a.reg_policy_sw, 'Y') =
                      DECODE (NVL (inc_special_sw, 'N'),
                              'N', 'Y',
                              NVL (a.reg_policy_sw, 'Y'))
                /* by: julie
                ** date: april 30, 2002
                ** for optimization purposes

                and a.line_cd = nvl(p_line_cd, a.line_cd)
                and a.subline_cd = nvl(p_subline_cd, a.subline_cd)
                and a.iss_cd = nvl(p_iss_cd, a.iss_cd

                the script above was modified. the script below replaces the script above
                */
                AND a.line_cd LIKE p_line_cd || '%'
                AND a.subline_cd LIKE p_subline_cd || '%'
                AND a.iss_cd LIKE p_iss_cd || '%'
                AND a.issue_yy =
                      DECODE (v_extraction, 'P', p_issue_yy, a.issue_yy)
                AND a.pol_seq_no =
                      DECODE (v_extraction, 'P', p_pol_seq_no, a.pol_seq_no)
                AND a.renew_no =
                      DECODE (v_extraction, 'P', p_renew_no, a.renew_no)
                /*added by Iris Bordey 04.21.2003
             **To check for policies already renewed(using manual renew).*/
                AND NOT EXISTS
                      (SELECT   '1'
                         FROM   gipi_polbasic x, gipi_polnrep y
                        WHERE       1 = 1
                                AND x.policy_id = y.old_policy_id
                                AND x.line_cd = a.line_cd
                                AND x.subline_cd = a.subline_cd
                                AND x.iss_cd = a.iss_cd
                                AND x.issue_yy = a.issue_yy
                                AND x.pol_seq_no = a.pol_seq_no
                                AND x.renew_no = a.renew_no)
                AND NOT EXISTS
                      (SELECT   '1'
                         FROM   gipi_polbasic x, gipi_wpolnrep y
                        WHERE       1 = 1
                                AND x.policy_id = y.old_policy_id
                                AND x.line_cd = a.line_cd
                                AND x.subline_cd = a.subline_cd
                                AND x.iss_cd = a.iss_cd
                                AND x.issue_yy = a.issue_yy
                                AND x.pol_seq_no = a.pol_seq_no
                                AND x.renew_no = a.renew_no)
                /* by: julie
                ** date: april 30, 2002
                ** added this select statement here in order to check whether a policy already exists
                   in giex_expiry. a script similar to this was found at the latter part of this procedure
                   but removed for optimizaiton purposes.
                */
                AND NOT EXISTS (SELECT   '1'
                                  FROM   giex_expiry c
                                 WHERE   a.policy_id = c.policy_id)
                AND check_user_per_iss_cd (a.line_cd, a.iss_cd, 'GIEXS001') =
                      1
                AND a.pack_policy_id IS NULL               --A.R.C. 05.07.2007
                AND (a.endt_seq_no = 0
                     OR (a.endt_seq_no > 0
                         AND TRUNC (a.endt_expiry_date) >=
                               TRUNC (a.expiry_date)))
       UNION                                       --bdarusin, untagged 080102
       SELECT   'XX',
                'XX',
                'XX',
                0,
                0,
                0,
                0,
                'XX',
                0,
                SYSDATE,
                SYSDATE,
                0,
                SYSDATE,
                '1',
                'N',
                0,
                'Y'
         FROM   DUAL                                    -- FOR THE LAST RECORD
       ORDER BY   1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  10 DESC,
                  7 DESC,
                  11,
                  12,
                  9)
   -- if inc_special_sw = 'y' then a.reg_policy_sw = a.reg_policy_sw else a.reg_policy_sw = 'y'
   LOOP
      -- records to be fetched will be accumulated then processed when a new policy is encountered
      -- still processing the same policy or first record
      /*message('selecting record...'||counter,no_acknowledge);
                   synchronize;
                   cntr:=cntr + 1;*/
      DBMS_OUTPUT.put_line ('ROLLIE ENDT ' || v_endt_seq_no);

      IF v_policy_no IS NULL OR v_policy_no = a1.policy_no
      THEN
         DBMS_OUTPUT.put_line ('ROLLIE1');

         IF a1.endt_seq_no = 0
         THEN
            v_endt_seq_no := a1.endt_seq_no;
            v_policy_id := a1.policy_id;
         -- removed to consider backward endorsement
         --      else
         --       v_endt_seq_no := null;
         --        v_policy_id   := null;
         END IF;

         IF v_policy_no IS NULL
         THEN
            v_policy_ids := a1.policy_id;
         ELSE
            v_policy_ids := v_policy_ids || ',' || a1.policy_id;
         END IF;

         v_line_cd := a1.line_cd;
         v_subline_cd := a1.subline_cd;
         v_iss_cd := a1.iss_cd;
         v_issue_yy := a1.issue_yy;
         v_pol_seq_no := a1.pol_seq_no;
         v_renew_no := a1.renew_no;
         v_back_stat := a1.back_stat;
         v_reg_pol_sw := a1.reg_policy_sw;             --jenny vi lim 02092005

         --this will assure that you will get the latest change
         --IF v_eff_date IS NULL THEN
         IF v_eff_date IS NULL
            OR v_eff_date > a1.eff_date --bdarusin 080102 for policies w/ changed
                                       AND a1.endt_seq_no <> 0
         THEN                        --eff date (eg pol - feb 1, endt - jan 1)
            v_eff_date := a1.eff_date;
         END IF;

         --IF v_expiry_date IS NULL THEN
         IF v_expiry_date IS NULL
            OR v_expiry_date <> a1.expiry_date                      --bdarusin
                                              AND a1.endt_seq_no <> 0
         THEN
            v_expiry_date := a1.expiry_date;
         END IF;

         --IF v_incept_date IS NULL THEN
         IF v_incept_date IS NULL
            OR v_incept_date <> a1.incept_date                      --bdarusin
                                              AND a1.endt_seq_no <> 0
         THEN
            v_incept_date := a1.incept_date;
         END IF;

         IF v_assd_no IS NULL
         THEN
            v_assd_no := a1.assd_no;
         END IF;

         IF NVL (v_auto_sw, 'Y') = 'Y'
         THEN
            IF a1.endt_seq_no <> 0
            THEN
               v_auto_sw := 'N';
            END IF;
         END IF;

         -- check if policy already exists in giex_expiry.
         /* by: julie
         ** date: april 30, 2002
         ** the script below was removed
              /*if v_expiry_sw = 'n' then
            for a2 in (select '1'
                        from giex_expiry
                      where policy_id  = a1.policy_id)
            loop
             v_expiry_sw := 'y';


             exit;
           end loop;
         end if;

         and replaced by the script below in the first select statement above for
         optimization purposes.

          and not exists (select '1'
                        from giex_expiry c
                    where a.policy_id = c.policy_id)
        */
         v_policy_no := a1.policy_no;
         -- transferred here by IOB 10.14.02
         v_spld_flag := NVL (a1.spld_flag, '1');
         v_expiry_tag := NVL (a1.expiry_tag, 'N');
      --processing new policy already
      ELSIF v_policy_no != a1.policy_no
      THEN
         -- first process the previous policy
         -- original policy was already expired
         IF NVL (v_endt_seq_no, 1) != 0 AND v_back_stat <> 2
         THEN
            NULL;
         ELSE
            IF (TRUNC (v_expiry_date) >= TRUNC (p_fr_date)
                AND TRUNC (v_expiry_date) <= TRUNC (p_to_date))
               OR v_extraction = 'P'
            THEN
               DBMS_OUTPUT.put_line (v_extraction);
               v_intm_sw := 'N';

               /*bdarusin, jan152003,returned the ff statements to include
              renewal of policies without endts*/
               --v_spld_flag := NVL(a1.spld_flag,'1'); --bdarusin, 072203
               --v_expiry_tag:= NVL(a1.expiry_tag,'N');--bdarusin, 072203
               /*bdarusin, end of added statements*/
               -- expiry was done with a specific intm_no
               --:fblock.intm_no is not null then
               IF p_intm_no IS NOT NULL
               THEN
                  v_intm_sw := 'Y';

                  DECLARE
                     TYPE cv_type IS REF CURSOR;

                     CV       cv_type;
                     retval   NUMBER := 0;
                  /* the ff cursor declaration was commented out
                  ** bdarusin 080102 -> from here
                  */
                  /* added by: julie
                  ** date: april 23, 2002
                  */
                  -- CURSOR cv IS
                  --  SELECT 1 FROM gipi_comm_invoice WHERE policy_id = v_policy_ids
                  --     AND intrmdry_intm_no = p_intm_no AND ROWNUM = 1 ;
                  -- to here <-  bdarusin**
                  BEGIN
                     --the ff statement was untagged, to resolve ora-01722 encountered --bdarusin 080102
                     OPEN CV FOR
                        'SELECT 1 FROM GIPI_COMM_INVOICE WHERE POLICY_ID IN ('
                        || v_policy_ids
                        || ') AND INTRMDRY_INTM_NO = :INTM AND ROWNUM = 1 '
                        USING p_intm_no;

                     LOOP
                        FETCH CV INTO   retval;

                        EXIT WHEN CV%FOUND;
                        EXIT WHEN CV%NOTFOUND; --added by gmi: to handle infinite loop when no records found
                     END LOOP;

                     CLOSE CV;

                     IF retval = 1
                     THEN
                        v_intm_sw := 'N';
                     END IF;
                  END;
               END IF;

               --
               DBMS_OUTPUT.put_line ('V_INTM_SW ' || v_intm_sw);
               DBMS_OUTPUT.put_line ('V_ENDT_SEQ_NO ' || v_endt_seq_no);
               DBMS_OUTPUT.put_line ('V_POLICY_ID ' || v_policy_id);
               DBMS_OUTPUT.put_line ('V_POLICY_NO ' || v_policy_no);
               DBMS_OUTPUT.put_line ('V_SPLD_FLAG ' || v_spld_flag);
               DBMS_OUTPUT.put_line ('EXPIRY_TAG ' || v_expiry_tag);
               DBMS_OUTPUT.put_line ('EXPIRY_TAG ' || v_expiry_tag);

               IF     v_intm_sw = 'N'
                  AND v_endt_seq_no = 0
                  AND v_policy_id IS NOT NULL
                  AND v_policy_no != 'XX'
                  AND v_spld_flag <> '2'
                  AND v_expiry_tag = 'N'
                  AND v_expiry_sw = 'N'
               THEN                        --include policy in expiry checking
                  -- added by rbd to get the correct expiry date and inception date if policy has backward endt
                  -- from here
                  -- get the last endorsement sequence of the latest backward endt
                  /* added by: julie
                  ** date: april 23, 2002
                  ** description: to inform the user of the number of policies that are
                                  being processed.
                  */
                  DBMS_OUTPUT.put_line (
                     'PROCESSING RECORD : ' || TO_CHAR (counter)
                  );
                  ---synchronize;
                  counter := counter + 1;

                  /*
                   message(v_line_cd||v_subline_cd||v_iss_cd||v_issue_yy||v_pol_seq_no||v_renew_no);
                   message(v_line_cd||v_subline_cd||v_iss_cd||v_issue_yy||v_pol_seq_no||v_renew_no);
                   */
                  /*message(v_policy_no);
                message(v_policy_no);*/
                  FOR z1
                  IN (  SELECT   endt_seq_no, expiry_date, incept_date
                          FROM   gipi_polbasic b2501
                         WHERE       b2501.line_cd = v_line_cd
                                 AND b2501.subline_cd = v_subline_cd
                                 AND b2501.iss_cd = v_iss_cd
                                 AND b2501.issue_yy = v_issue_yy
                                 AND b2501.pol_seq_no = v_pol_seq_no
                                 AND b2501.renew_no = v_renew_no
                                 AND b2501.pol_flag IN ('1', '2', '3')
                                 AND NVL (b2501.back_stat, 5) = 2
                                 AND b2501.pack_policy_id IS NULL --A.R.C. 05.07.2007
                                 AND (b2501.endt_seq_no = 0
                                      OR (b2501.endt_seq_no > 0
                                          AND TRUNC (b2501.endt_expiry_date) >=
                                                TRUNC (b2501.expiry_date)))
                      ORDER BY   endt_seq_no DESC)
                  LOOP
                     -- get the last endorsement sequence of the policy
                     FOR z1a
                     IN (  SELECT   endt_seq_no,
                                    eff_date,
                                    expiry_date,
                                    incept_date
                             FROM   gipi_polbasic b2501
                            WHERE       b2501.line_cd = v_line_cd
                                    AND b2501.subline_cd = v_subline_cd
                                    AND b2501.iss_cd = v_iss_cd
                                    AND b2501.issue_yy = v_issue_yy
                                    AND b2501.pol_seq_no = v_pol_seq_no
                                    AND b2501.renew_no = v_renew_no
                                    AND b2501.pol_flag IN ('1', '2', '3')
                                    AND b2501.pack_policy_id IS NULL --A.R.C. 05.07.2007
                                    AND (b2501.endt_seq_no = 0
                                         OR (b2501.endt_seq_no > 0
                                             AND TRUNC (b2501.endt_expiry_date) >=
                                                   TRUNC (b2501.expiry_date)))
                         ORDER BY   endt_seq_no DESC)
                     LOOP
                        IF z1.endt_seq_no = z1a.endt_seq_no
                        THEN
                           v_expiry_date := z1.expiry_date;
                           v_incept_date := z1.incept_date;
                        ELSE
                           IF z1a.eff_date > v_eff_date
                           THEN
                              v_expiry_date := z1a.expiry_date;
                              v_incept_date := z1a.incept_date;
                           ELSE
                              v_expiry_date := z1.expiry_date;
                              v_incept_date := z1.incept_date;
                           END IF;
                        END IF;

                        EXIT;
                     END LOOP;

                     EXIT;
                  END LOOP;

                  -- to here
                  -- added by rbd to get the correct assured if policy has backward endt
                  -- from here
                  -- get the last endorsement sequence of the latest backward endt
                  FOR z3
                  IN (  SELECT   endt_seq_no, assd_no
                          FROM   gipi_polbasic b2501
                         WHERE       b2501.line_cd = v_line_cd
                                 AND b2501.subline_cd = v_subline_cd
                                 AND b2501.iss_cd = v_iss_cd
                                 AND b2501.issue_yy = v_issue_yy
                                 AND b2501.pol_seq_no = v_pol_seq_no
                                 AND b2501.renew_no = v_renew_no
                                 AND b2501.pol_flag IN ('1', '2', '3')
                                 AND assd_no IS NOT NULL
                                 AND NVL (b2501.back_stat, 5) = 2
                                 AND b2501.pack_policy_id IS NULL --A.R.C. 05.07.2007
                                 AND (b2501.endt_seq_no = 0
                                      OR (b2501.endt_seq_no > 0
                                          AND TRUNC (b2501.endt_expiry_date) >=
                                                TRUNC (b2501.expiry_date)))
                      ORDER BY   endt_seq_no DESC)
                  LOOP
                     -- get the last endorsement sequence of the policy
                     FOR z3a
                     IN (  SELECT   endt_seq_no, eff_date, assd_no
                             FROM   gipi_polbasic b2501
                            WHERE       b2501.line_cd = v_line_cd
                                    AND b2501.subline_cd = v_subline_cd
                                    AND b2501.iss_cd = v_iss_cd
                                    AND b2501.issue_yy = v_issue_yy
                                    AND b2501.pol_seq_no = v_pol_seq_no
                                    AND b2501.renew_no = v_renew_no
                                    AND b2501.pol_flag IN ('1', '2', '3')
                                    AND assd_no IS NOT NULL
                                    AND b2501.pack_policy_id IS NULL --A.R.C. 05.07.2007
                                    AND (b2501.endt_seq_no = 0
                                         OR (b2501.endt_seq_no > 0
                                             AND TRUNC (b2501.endt_expiry_date) >=
                                                   TRUNC (b2501.expiry_date)))
                         ORDER BY   endt_seq_no DESC)
                     LOOP
                        IF z3.endt_seq_no = z3a.endt_seq_no
                        THEN
                           v_assd_no := z3.assd_no;
                        ELSE
                           IF z3a.eff_date > v_eff_date
                           THEN
                              v_assd_no := z3a.assd_no;
                           ELSE
                              v_assd_no := z3.assd_no;
                           END IF;
                        END IF;

                        EXIT;
                     END LOOP;

                     EXIT;
                  END LOOP;

                  -- to here
                  v_count := v_count + 1;
                  pck_count := pck_count + 1;
                  --    t2_pack_policy_id(v_count)  := NULL;
                  t2_policy_id (v_count) := v_policy_id;
                  t2_line_cd (v_count) := v_line_cd;
                  t2_subline_cd (v_count) := v_subline_cd;
                  t2_iss_cd (v_count) := v_iss_cd;
                  t2_issue_yy (v_count) := v_issue_yy;
                  t2_pol_seq_no (v_count) := v_pol_seq_no;
                  t2_renew_no (v_count) := v_renew_no;
                  t2_expiry_date (v_count) := v_expiry_date;
                  t2_incept_date (v_count) := v_incept_date;
                  t2_assd_no (v_count) := v_assd_no;
                  t2_intm_no (v_count) := v_intm_no;
                  t2_auto_sw (v_count) := v_auto_sw;
                  /* added by gmi: for counting purposes found @ GIEXS001 */
                  t_policy_id (pck_count) := v_policy_id;
                  t_line_cd (pck_count) := v_line_cd;
                  t_subline_cd (pck_count) := v_subline_cd;
                  t_iss_cd (pck_count) := v_iss_cd;
                  t_issue_yy (pck_count) := v_issue_yy;
                  t_pol_seq_no (pck_count) := v_pol_seq_no;
                  t_renew_no (pck_count) := v_renew_no;
                  t_expiry_date (pck_count) := v_expiry_date;
                  t_incept_date (pck_count) := v_incept_date;
                  t_assd_no (pck_count) := v_assd_no;
                  t_intm_no (pck_count) := v_intm_no;
                  t_auto_sw (pck_count) := v_auto_sw;
               END IF;
            END IF;                                     --trunc(v_expiry_date)
         END IF;

         --second initialize the variables to be used
         v_line_cd := NULL;
         v_subline_cd := NULL;
         v_iss_cd := NULL;
         v_issue_yy := NULL;
         v_pol_seq_no := NULL;
         v_renew_no := NULL;
         v_expiry_date := NULL;
         v_incept_date := NULL;
         v_assd_no := NULL;
         v_policy_ids := NULL;
         v_policy_id := NULL;
         v_endt_seq_no := NULL;
         v_spld_flag := NULL;
         v_expiry_tag := NULL;
         v_reg_pol_sw := NULL;
         v_auto_sw := 'Y';
         v_expiry_sw := 'N';
         v_eff_date := NULL;

         --third insert data to the variables
         IF a1.endt_seq_no = 0
         THEN
            v_endt_seq_no := 0;
            v_policy_id := a1.policy_id;
         -- removed to consider backward endorsement
         --      else
         --         v_endt_seq_no  := null;
         --         v_policy_id  := null;
         END IF;

         IF a1.endt_seq_no <> 0
         THEN
            v_auto_sw := 'N';
         END IF;

         v_policy_ids := a1.policy_id;
         v_line_cd := a1.line_cd;
         v_subline_cd := a1.subline_cd;
         v_iss_cd := a1.iss_cd;
         v_issue_yy := a1.issue_yy;
         v_pol_seq_no := a1.pol_seq_no;
         v_renew_no := a1.renew_no;
         --no need to check if null kc initialize na before hand
         v_expiry_date := a1.expiry_date;
         v_incept_date := a1.incept_date;
         v_assd_no := a1.assd_no;
         v_spld_flag := NVL (a1.spld_flag, '1');            --bdarusin, 072203
         v_expiry_tag := NVL (a1.expiry_tag, 'N');          --bdarusin, 072203
         /* by: julie
         ** date: april 30, 2002
         ** the script below was removed
              if v_expiry_sw = 'n' then
            for a2 in (select '1'
                        from giex_expiry
                      where policy_id  = a1.policy_id)
            loop
             v_expiry_sw := 'y';


             exit;
           end loop;
         end if;

         and replaced by the script below in the first select statement above for
         optimization purposes.

          and not exists (select '1'
                        from giex_expiry c
                    where a.policy_id = c.policy_id)
        */
         --fourth transfer policy_no to v_policy_no
         v_policy_no := a1.policy_no;
         v_reg_pol_sw := a1.reg_policy_sw;             --jenny vi lim 02092005
      END IF;
   END LOOP;                                             --(end of first loop)

   v_line_mc := giisp.v ('LINE_CODE_MC');
   v_line_fi := giisp.v ('LINE_CODE_FI');

   IF t2_policy_id.EXISTS (1)
   THEN
      FOR a1 IN t2_policy_id.FIRST .. t2_policy_id.LAST
      LOOP
         DBMS_OUTPUT.put_line (a1 || '(:)' || t2_policy_id (a1));
         v_loc_risk1 := NULL;
         v_loc_risk2 := NULL;
         v_loc_risk3 := NULL;
         v_item_title := NULL;
         v_color := NULL;
         v_motor_no := NULL;
         v_model_year := NULL;
         v_car_company := NULL;
         v_make := NULL;
         v_serial_no := NULL;
         v_plate_no := NULL;
         v_item_no := NULL;
         v_clm := NULL;
         v_bal := NULL;
         v_reg_pol_sw := NULL;
         v_ren_flag := '2';
         v_pol_id := t2_policy_id (a1);
         v_exp_date := t2_expiry_date (a1);
         v_assd_no := t2_assd_no (a1);
         v_intm_no := t2_intm_no (a1);
         v_inc_date := t2_incept_date (a1);
         v_auto_sw := t2_auto_sw (a1);

         FOR a2 IN (  SELECT   line_cd,
                               subline_cd,
                               iss_cd,
                               issue_yy,
                               pol_seq_no,
                               renew_no,
                               auto_renew_flag,
                               policy_id,
                               reg_policy_sw,
                               pack_policy_id,
                               ref_pol_no
                        FROM   gipi_polbasic
                       WHERE   policy_id = v_pol_id
                    ORDER BY   pack_policy_id)
         LOOP
            v_reg_pol_sw := a2.reg_policy_sw;

            FOR a3
            IN (SELECT   '1'
                  FROM   gicl_claims
                 WHERE       line_cd = a2.line_cd
                         AND subline_cd = a2.subline_cd
                         AND pol_iss_cd = a2.iss_cd
                         AND issue_yy = a2.issue_yy
                         AND pol_seq_no = a2.pol_seq_no
                         AND renew_no = a2.renew_no
                         AND clm_stat_cd NOT IN ('CC', 'WD', 'DN'))
            LOOP
               v_clm := 'Y';
               EXIT;
            END LOOP;

            v_tsi := 0;
            v_orig_tsi_exp := 0;
            v_prem := 0;

            FOR a4
            IN (SELECT   NVL (prem_amt, 0) prem, NVL (tsi_amt, 0) tsi
                  FROM   gipi_polbasic
                 WHERE       line_cd = a2.line_cd
                         AND subline_cd = a2.subline_cd
                         AND iss_cd = a2.iss_cd
                         AND issue_yy = a2.issue_yy
                         AND pol_seq_no = a2.pol_seq_no
                         AND renew_no = a2.renew_no
                         AND pol_flag IN ('1', '2', '3')
                         AND (endt_seq_no = 0
                              OR (endt_seq_no > 0
                                  AND TRUNC (endt_expiry_date) >=
                                        TRUNC (expiry_date))))
            LOOP
               v_orig_tsi_exp := NVL (v_orig_tsi_exp, 0) + a4.tsi;
               v_prem := NVL (v_prem, 0) + a4.prem;
            END LOOP;

            FOR a5
            IN (SELECT   SUM (c.balance_amt_due) due
                  FROM   gipi_polbasic a,
                         gipi_invoice b,
                         giac_aging_soa_details c
                 WHERE       a.line_cd = a2.line_cd
                         AND a.subline_cd = a2.subline_cd
                         AND a.iss_cd = a2.iss_cd
                         AND a.issue_yy = a2.issue_yy
                         AND a.pol_seq_no = a2.pol_seq_no
                         AND a.renew_no = a2.renew_no
                         AND a.pol_flag IN ('1', '2', '3')
                         AND a.policy_id = b.policy_id
                         AND b.iss_cd = c.iss_cd
                         AND b.prem_seq_no = c.prem_seq_no
                         AND (a.endt_seq_no = 0
                              OR (a.endt_seq_no > 0
                                  AND TRUNC (a.endt_expiry_date) >=
                                        TRUNC (a.expiry_date))))
            LOOP
               IF a5.due <> 0
               THEN
                  v_bal := 'Y';
               END IF;
            END LOOP;

            v_tax := 0;
            v_pol_tax := 0;

            FOR a6
            IN (  SELECT   SUM (NVL (tax_amt, 0)) tax, item_grp, a.policy_id
                    FROM   gipi_polbasic a, gipi_invoice b
                   WHERE       a.policy_id = b.policy_id
                           AND a.line_cd = a2.line_cd
                           AND a.subline_cd = a2.subline_cd
                           AND a.iss_cd = a2.iss_cd
                           AND a.issue_yy = a2.issue_yy
                           AND a.pol_seq_no = a2.pol_seq_no
                           AND a.renew_no = a2.renew_no
                           AND a.pol_flag IN ('1', '2', '3')
                           AND (a.endt_seq_no = 0
                                OR (a.endt_seq_no > 0
                                    AND TRUNC (a.endt_expiry_date) >=
                                          TRUNC (a.expiry_date)))
                GROUP BY   item_grp, a.policy_id)
            LOOP
               v_rate := 0;

               FOR a7
               IN (SELECT   currency_rt
                     FROM   gipi_item
                    WHERE   item_grp = a6.item_grp
                            AND policy_id = a6.policy_id)
               LOOP
                  v_rate := a7.currency_rt;
                  EXIT;
               END LOOP;

               v_tax := v_tax + (a6.tax * v_rate);

               IF a2.policy_id = a6.policy_id
               THEN
                  v_pol_tax := v_pol_tax + (a6.tax * v_rate);
               END IF;
            END LOOP;

            IF v_auto_sw = 'Y' AND NVL (a2.auto_renew_flag, 'N') = 'Y'
            THEN
               v_ren_flag := '3';
            END IF;

            --beth 10262000 derived the latest item title for policy
            --     with more than one item, item title would be various
            v_item_no := NULL;

            FOR i
            IN (  SELECT   c.item_no, SUBSTR (c.item_title, 1, 50) item_title
                    FROM   gipi_polbasic a, gipi_item c
                   WHERE       a.line_cd = a2.line_cd
                           AND a.subline_cd = a2.subline_cd
                           AND a.iss_cd = a2.iss_cd
                           AND a.issue_yy = a2.issue_yy
                           AND a.pol_seq_no = a2.pol_seq_no
                           AND a.renew_no = a2.renew_no
                           AND a.policy_id = c.policy_id
                           AND a.pol_flag IN ('1', '2', '3')
                           AND (a.endt_seq_no = 0
                                OR (a.endt_seq_no > 0
                                    AND TRUNC (a.endt_expiry_date) >=
                                          TRUNC (a.expiry_date)))
                ORDER BY   eff_date ASC)
            LOOP
               IF NVL (v_item_no, i.item_no) = i.item_no
               THEN
                  v_item_no := i.item_no;
                  v_item_title := i.item_title;
               ELSE
                  v_item_title := 'VARIOUS';
                  EXIT;
               END IF;
            END LOOP;

            --beth 10262000 for fire derived location of risk
            --     if location of risk is not the same for more than one item
            --     the value of location of risk would be various
            IF a2.line_cd = v_line_fi
            THEN
               v_item_no := NULL;

               FOR fi
               IN (  SELECT   SUBSTR (b.loc_risk1, 1, 50) loc_risk1,
                              SUBSTR (b.loc_risk2, 1, 50) loc_risk2,
                              SUBSTR (b.loc_risk3, 1, 50) loc_risk3,
                              c.risk_no,               -- added by gmi  060707
                              c.risk_item_no,          -- added by gmi  060707
                              b.item_no
                       FROM   gipi_polbasic a, gipi_fireitem b, gipi_item c
                      WHERE       a.line_cd = a2.line_cd
                              AND a.subline_cd = a2.subline_cd
                              AND a.iss_cd = a2.iss_cd
                              AND a.issue_yy = a2.issue_yy
                              AND a.pol_seq_no = a2.pol_seq_no
                              AND a.renew_no = a2.renew_no
                              AND a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.item_no = c.item_no
                              AND a.pol_flag IN ('1', '2', '3')
                              --                          AND A.pack_policy_id IS NULL --A.R.C. 05.07.2007
                              AND (a.endt_seq_no = 0
                                   OR (a.endt_seq_no > 0
                                       AND TRUNC (a.endt_expiry_date) >=
                                             TRUNC (a.expiry_date)))
                   ORDER BY   b.item_no, eff_date ASC)
               LOOP
                  IF NVL (v_item_no, fi.item_no) = fi.item_no
                  THEN
                     v_item_no := fi.item_no;

                     IF    fi.loc_risk1 IS NOT NULL
                        OR fi.loc_risk2 IS NOT NULL
                        OR fi.loc_risk3 IS NOT NULL
                     THEN
                        v_loc_risk1 := fi.loc_risk1;
                        v_loc_risk2 := fi.loc_risk2;
                        v_loc_risk3 := fi.loc_risk3;
                        v_risk_no := fi.risk_no;       -- added by gmi  060707
                        v_risk_item_no := fi.risk_item_no; -- added by gmi  060707
                     END IF;
                  ELSIF NVL (v_item_no, fi.item_no) <> fi.item_no
                  THEN
                     IF     v_loc_risk1 IS NULL
                        AND v_loc_risk2 IS NULL
                        AND v_loc_risk3 IS NULL
                     THEN
                        v_item_no := fi.item_no;

                        IF    fi.loc_risk1 IS NOT NULL
                           OR fi.loc_risk2 IS NOT NULL
                           OR fi.loc_risk3 IS NOT NULL
                        THEN
                           v_loc_risk1 := fi.loc_risk1;
                           v_loc_risk2 := fi.loc_risk2;
                           v_loc_risk3 := fi.loc_risk3;
                           v_risk_no := fi.risk_no;    -- added by gmi  060707
                           v_risk_item_no := fi.risk_item_no; -- added by gmi  060707
                        END IF;
                     ELSIF NVL (v_loc_risk1, '%^&') <> NVL (fi.loc_risk1, '%^&') OR NVL (v_loc_risk2, '%^&') <> NVL (fi.loc_risk2, '%^&') OR NVL (v_loc_risk3, '%^&') <> NVL (fi.loc_risk3, '%^&')
                     THEN
                        v_loc_risk1 := 'VARIOUS';
                        v_loc_risk2 := NULL;
                        v_loc_risk3 := NULL;
                        v_risk_no := fi.risk_no;       -- added by gmi  060707
                        v_risk_item_no := fi.risk_item_no; -- added by gmi  060707
                        EXIT;
                     END IF;
                  END IF;
               END LOOP;
            END IF;

            IF a2.line_cd = v_line_mc
            THEN
               v_item_no := NULL;

               FOR a9
               IN (  SELECT   b.color,
                              b.motor_no,
                              b.model_year,
                              d.car_company,
                              b.make,
                              b.serial_no,
                              b.plate_no,
                              b.item_no,
                              b.motor_coverage           --added by gmi 060707
                       FROM   gipi_polbasic a,
                              gipi_vehicle b,
                              gipi_item c,
                              giis_mc_car_company d
                      WHERE       a.line_cd = a2.line_cd
                              AND a.subline_cd = a2.subline_cd
                              AND a.iss_cd = a2.iss_cd
                              AND a.issue_yy = a2.issue_yy
                              AND a.pol_seq_no = a2.pol_seq_no
                              AND a.renew_no = a2.renew_no
                              AND a.policy_id = b.policy_id
                              AND b.policy_id = c.policy_id
                              AND b.item_no = c.item_no
                              AND b.car_company_cd = d.car_company_cd(+)
                              AND a.pol_flag IN ('1', '2', '3')
                              --                        AND A.pack_policy_id IS NULL --A.R.C. 05.07.2007
                              AND (a.endt_seq_no = 0
                                   OR (a.endt_seq_no > 0
                                       AND TRUNC (a.endt_expiry_date) >=
                                             TRUNC (a.expiry_date)))
                   ORDER BY   eff_date ASC)
               LOOP
                  IF NVL (v_item_no, a9.item_no) = a9.item_no
                  THEN
                     v_item_no := a9.item_no;
                     v_color := NVL (a9.color, v_color);
                     v_motor_no := NVL (a9.motor_no, v_motor_no);
                     v_model_year := NVL (a9.model_year, v_model_year);
                     v_make := NVL (a9.make, v_make);
                     v_serial_no := NVL (a9.serial_no, v_serial_no);
                     v_plate_no := NVL (a9.plate_no, v_plate_no);
                     v_car_company := NVL (a9.car_company, v_car_company);
                     v_motor_coverage :=
                        NVL (a9.motor_coverage, v_motor_coverage); --added by gmi 060707
                  ELSE
                     v_color := 'VARIOUS';
                     v_motor_no := 'VARIOUS';
                     v_model_year := 'VAR.';
                     v_make := 'VARIOUS';
                     v_serial_no := 'VARIOUS';
                     v_plate_no := 'VARIOUS';
                     v_car_company := NULL;
                     v_motor_coverage := NULL;           --added by gmi 060707
                     EXIT;
                  END IF;
               END LOOP;
            END IF;

            IF NVL (p_def_is_pol_summ_sw, 'N') != 'Y'
            THEN
               v_summ_sw := 'N';
            ELSE
               v_summ_sw := 'Y';
            END IF;

            IF NVL (p_def_same_polno_sw, 'N') != 'Y'
            THEN
               v_same_sw := 'N';
            ELSE
               v_same_sw := 'Y';
            END IF;

            v_renewal_id :=
               TRANSLATE (a2.policy_id, '0123456789', 'ABCDGJMPTW'); -- jenny vi lim 02102005

            /* added by petermkaw 06242010
            ** added if condition and generation of bank_ref_no for non-package
            ** policies and acquisition of bank_ref_no from giex_pack_expiry
            ** for package policies.
            **--start--*/
            IF a2.pack_policy_id IS NULL OR a2.pack_policy_id < 1
            THEN
               BEGIN
                  SELECT   acct_iss_cd
                    INTO   v_acct_iss_cd
                    FROM   giis_issource
                   WHERE   iss_cd = a2.iss_cd;
               END;

               generate_ref_no (v_acct_iss_cd,
                                0000,
                                v_ref_no,
                                'GIEXS001');

               BEGIN
                  SELECT   bank_ref_no                              /*mod_no*/
                    INTO   v_ref                                  /*v_mod_no*/
                    FROM   gipi_ref_no_hist
                   WHERE       acct_iss_cd = v_acct_iss_cd
                           AND branch_cd = 0000
                           AND ref_no = v_ref_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
                  THEN
                     NULL;
               END;
            /*v_ref:=v_acct_iss_cd||'-'||0000||'-'||v_ref_no||'-'||v_mod_no;*/
            ELSIF a2.pack_policy_id >= 1
            THEN
               BEGIN
                  SELECT   bank_ref_no
                    INTO   v_ref
                    FROM   giex_pack_expiry
                   WHERE   pack_policy_id = a2.pack_policy_id;
               EXCEPTION
                  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
                  THEN
                     NULL;
               END;
            END IF;

            /*--end--*/

            INSERT INTO giex_expiry (policy_id,
                                     expiry_date,
                                     line_cd,
                                     subline_cd,
                                     iss_cd,
                                     issue_yy,
                                     pol_seq_no,
                                     renew_no,
                                     claim_flag,
                                     extract_user,
                                     extract_date,
                                     user_id,
                                     last_update,
                                     renew_flag,
                                     auto_renew_flag,
                                     --tsi_amt,              prem_amt,  --commented by A.R.C. 03.07.2005
                                     balance_flag,
                                     incept_date,
                                     assd_no,
                                     same_polno_sw,
                                     update_flag,
                                     summary_sw,
                                     auto_sw,
                                     tax_amt,
                                     policy_tax_amt,
                                     color,
                                     motor_no,
                                     model_year,
                                     make,
                                     serialno,
                                     plate_no,
                                     item_title,
                                     loc_risk1,
                                     loc_risk2,
                                     loc_risk3,
                                     intm_no,
                                     car_company,
                                     orig_tsi_amt,
                                     reg_policy_sw,
                                     renewal_id,
                                     pack_policy_id,
                                     bank_ref_no,
                                     ref_pol_no)
              VALUES   (a2.policy_id,
                        v_exp_date,
                        a2.line_cd,
                        a2.subline_cd,
                        a2.iss_cd,
                        a2.issue_yy,
                        a2.pol_seq_no,
                        a2.renew_no,
                        v_clm,
                        USER,
                        v_ext_date,
                        USER,
                        SYSDATE,
                        v_ren_flag,
                        a2.auto_renew_flag,
                        --v_total_dep_tsi,           v_total_dep_prm,  --commented by A.R.C. 03.07.2005
                        v_bal,
                        v_inc_date,
                        v_assd_no,
                        v_same_sw,
                        'N',
                        v_summ_sw,
                        v_auto_sw,
                        v_tax,
                        v_pol_tax,
                        v_color,
                        v_motor_no,
                        v_model_year,
                        v_make,
                        v_serial_no,
                        v_plate_no,
                        v_item_title,
                        v_loc_risk1,
                        v_loc_risk2,
                        v_loc_risk3,
                        v_intm_no,
                        v_car_company,
                        v_orig_tsi_exp,
                        v_reg_pol_sw,
                        v_renewal_id,
                        a2.pack_policy_id,
                        v_ref,
                        a2.ref_pol_no);

            /*Added by A.R.C. 03.07.2005
            **To resolve ora-02291 (parent key not found).
            */
            v_total_dep_tsi := 0;
            v_total_dep_prm := 0;
            v_total_ren_tsi := 0;
            v_total_ren_prm := 0;
            v_total_currency_prm := 0;
            pv_endt_seq_no := NULL;
            v_peril_cnt := 0;

            IF t_peril_cds.EXISTS (1)
            THEN
               FOR x1 IN t_peril_cds.FIRST .. t_peril_cds.LAST
               LOOP
                  t_peril_cds (x1) := NULL;
                  t_item_nos (x1) := NULL;
               END LOOP;
            END IF;

            v_a8_ren_prem_amt := 0;
            v_currency_prem_amt := 0;

            FOR a8
            IN (  SELECT /*SUM(A.prem_amt * C.currency_rt) prem_amt2,
                             SUM(A.tsi_amt * C.currency_rt) tsi_amt2,*/
                         ( a.ann_prem_amt) currency_prem_amt,
                           (a.ann_prem_amt * c.currency_rt) ren_prem_amt,
                           (a.ann_tsi_amt * c.currency_rt) ren_tsi_amt,
                           a.line_cd,
                           a.peril_cd,
                           d.peril_type peril_type,
                           endt_seq_no,
                           c.item_no
                    FROM   gipi_itmperil a,
                           gipi_polbasic b,
                           gipi_item c,
                           giis_peril d
                   WHERE       b.line_cd = a2.line_cd
                           AND b.subline_cd = a2.subline_cd
                           AND b.iss_cd = a2.iss_cd
                           AND b.issue_yy = a2.issue_yy
                           AND b.pol_seq_no = a2.pol_seq_no
                           AND b.renew_no = a2.renew_no
                           AND d.peril_cd = a.peril_cd
                           AND d.line_cd = a.line_cd
                           AND a.policy_id = b.policy_id
                           AND b.policy_id = c.policy_id
                           AND a.policy_id = b.policy_id
                           AND a.item_no = c.item_no
                           AND b.pol_flag IN ('1', '2', '3')
                           AND NVL (b.reg_policy_sw, 'Y') =
                                 DECODE (NVL (inc_special_sw, 'N'),
                                         'N', 'Y',
                                         NVL (b.reg_policy_sw, 'Y'))
                           AND (b.endt_seq_no = 0
                                OR (b.endt_seq_no > 0
                                    AND TRUNC (b.endt_expiry_date) >=
                                          TRUNC (b.expiry_date)))
                ORDER BY   eff_date DESC, endt_seq_no DESC)
            --GROUP BY A.peril_cd, A.line_cd, d.peril_type)
            LOOP
               v_skip := NULL;

               IF NVL (pv_endt_seq_no, a8.endt_seq_no) <> a8.endt_seq_no
               THEN
                  v_skip := 'N';

                  FOR x1 IN t_peril_cds.FIRST .. t_peril_cds.LAST
                  LOOP
                     IF t_peril_cds (x1) = a8.peril_cd
                        AND t_item_nos (x1) = a8.item_no
                     THEN
                        v_skip := 'Y';
                     --EXIT;
                     END IF;
                  END LOOP;
               --      EXIT;
               END IF;

               IF v_skip IS NULL
               THEN
                  pv_endt_seq_no := a8.endt_seq_no;
               END IF;

               IF NVL (v_skip, 'N') = 'N'
               THEN
                  v_peril_cnt := v_peril_cnt + 1;
                  t_peril_cds (v_peril_cnt) := a8.peril_cd;
                  t_item_nos (v_peril_cnt) := a8.item_no;
                  o_line_cd := a8.line_cd;
                  o_peril_cd := a8.peril_cd;
                  v_orig_tsi_ogrp := a8.ren_tsi_amt;
                  v_orig_prm_ogrp := a8.ren_prem_amt;
                  v_ren_tsi_ogrp := a8.ren_tsi_amt;
                  v_ren_prm_ogrp := a8.ren_prem_amt;
                  v_currency_prm_ogrp := a8.currency_prem_amt;

                  --   v_a8_ren_prem_amt   := v_a8_ren_prem_amt + a8.ren_prem_amt;
                  --   v_currency_prem_amt := v_currency_prem_amt + a8.currency_prem_amt;
                  /*commented by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012;*/
                  /* rollie 25-OCT-2004
                  ** FOR AUTO COMPUTE OF tsi depreciation
                  ** look up ON TABLE giex_dep_perl */
                  /*      BEGIN
                         SELECT 'Y'
                        INTO v_auto_dep
                        FROM GIEX_DEP_PERL
                       WHERE line_cd  = a8.line_cd
                      AND peril_cd = a8.peril_cd;
                        EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                      v_auto_dep := 'N';
                      WHEN TOO_MANY_ROWS THEN
                       v_auto_dep := 'Y';
                        END;*/
                  /*replaced by codes below*/

                  v_dep_pct := 0;

                  FOR gdp
                  IN (SELECT   rate
                        FROM   giex_dep_perl
                       WHERE   line_cd = a8.line_cd
                               AND peril_cd = a8.peril_cd)
                  LOOP
                     v_dep_pct := gdp.rate;
                  END LOOP;

                  --IF a8.line_cd = v_line_mc AND v_auto_dep = 'Y' THEN
                  IF v_auto_dep = 'Y'
                  THEN
                     o_ren_tsi_amt2 :=
                        v_ren_tsi_ogrp - (v_ren_tsi_ogrp * (v_dep_pct / 100));
                     o_ren_prem_amt2 :=
                        v_ren_prm_ogrp - (v_ren_prm_ogrp * (v_dep_pct / 100));
                     o_currency_prem_amt2 :=
                        v_currency_prm_ogrp
                        - (v_currency_prm_ogrp * (v_dep_pct / 100));
                  ELSE
                     o_ren_tsi_amt2 := v_ren_tsi_ogrp;
                     o_ren_prem_amt2 := v_ren_prm_ogrp;
                     o_currency_prem_amt2 := v_currency_prm_ogrp;
                  END IF;

                  --o_tsi_amt2      := v_orig_tsi_ogrp;
                  --o_prem_amt2     := v_orig_prm_ogrp;
                  IF a8.peril_type = 'B'
                  THEN
                     --v_total_dep_tsi  := NVL(v_total_dep_tsi,0) + o_tsi_amt2;
                     v_total_ren_tsi :=
                        NVL (v_total_ren_tsi, 0) + o_ren_tsi_amt2;
                  END IF;

                  --v_total_dep_prm     := NVL(v_total_dep_prm,0) + o_prem_amt2;
                  v_total_ren_prm :=
                     NVL (v_total_ren_prm, 0) + o_ren_prem_amt2;
                  v_total_currency_prm :=
                     NVL (v_total_currency_prm, 0) + o_currency_prem_amt2;
                  v_a8_ren_prem_amt := v_total_ren_prm;
                  v_currency_prem_amt := v_total_currency_prm;

                  BEGIN
                     SELECT   COUNT ( * )
                       INTO   v_ctr
                       FROM   giex_old_group_peril
                      WHERE   policy_id = a2.policy_id
                              AND peril_cd = a8.peril_cd;
                  END;

                  IF NVL (v_ctr, 0) = 0
                  THEN
                     INSERT INTO giex_old_group_peril (policy_id,
                                                       line_cd,
                                                       peril_cd,
                                                       prem_amt,
                                                       tsi_amt,
                                                       orig_tsi_amt,
                                                       currency_prem_amt)
                       VALUES   (a2.policy_id,
                                 o_line_cd,
                                 o_peril_cd,
                                 o_ren_prem_amt2,
                                 o_ren_tsi_amt2,
                                 v_orig_tsi_ogrp,
                                 o_currency_prem_amt2);
                  ELSE
                     UPDATE   giex_old_group_peril
                        SET   prem_amt = prem_amt + o_ren_prem_amt2,
                              tsi_amt = tsi_amt + o_ren_tsi_amt2,
                              orig_tsi_amt = orig_tsi_amt + v_orig_tsi_ogrp,
                              currency_prem_amt =
                                 currency_prem_amt + o_currency_prem_amt2
                      WHERE   policy_id = a2.policy_id
                              AND peril_cd = a8.peril_cd;
                  END IF;
               END IF;                                            -- v_skip IF
            END LOOP;

            -------------------- modified 101907 --------
            v_ctr := 0;

            FOR a9
            IN (  SELECT   d.line_cd,
                           d.tax_cd,
                           e.tax_id,
                           d.iss_cd,
                           e.tax_desc,
                           e.rate rate,
                           e.peril_sw,
                           f.menu_line_cd,         --added by cherrie 09082012
                           tax_type, -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                           tax_amount -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                    FROM   gipi_polbasic b,
                           gipi_invoice c,
                           gipi_inv_tax d,
                           giis_tax_charges e,
                           giis_line f         --added "f" by cherrie 09082012
                   WHERE       b.line_cd = a2.line_cd
                           AND b.subline_cd = a2.subline_cd
                           AND b.iss_cd = a2.iss_cd
                           AND b.issue_yy = a2.issue_yy
                           AND b.pol_seq_no = a2.pol_seq_no
                           AND b.renew_no = a2.renew_no
                           AND b.policy_id = c.policy_id
                           AND d.prem_seq_no = c.prem_seq_no
                           AND d.iss_cd = b.iss_cd
                           AND d.tax_cd = e.tax_cd
                           --                AND d.tax_id          = e.tax_id
                           AND d.iss_cd = e.iss_cd
                           AND d.line_cd = e.line_cd
                           AND NVL (e.expired_sw, 'N') = 'N'
                           AND ADD_MONTHS (b.incept_date, 12) BETWEEN eff_start_date
                                                                  AND  eff_end_date
                           AND b.pol_flag IN ('1', '2', '3')
                           AND NVL (b.reg_policy_sw, 'Y') =
                                 DECODE (NVL (inc_special_sw, 'N'),
                                         'N', 'Y',
                                         NVL (b.reg_policy_sw, 'Y'))
                           AND (b.endt_seq_no = 0
                                OR (b.endt_seq_no > 0
                                    AND TRUNC (b.endt_expiry_date) >=
                                          TRUNC (b.expiry_date)))
                           AND b.line_cd = f.line_cd --added by cherrie 09082012
                GROUP BY   d.line_cd,
                           d.tax_cd,
                           e.tax_id,
                           d.iss_cd,
                           e.tax_desc,
                           e.rate,                --added by A.R.C. 03.07.2005
                           e.peril_sw,
                           f.menu_line_cd --added f.menu_line_cd by cherrie 09082012
                                         ,
                           tax_type, -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                           tax_amount -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                                     )
            LOOP
               IF a9.peril_sw = 'Y'
               THEN
                  ----------------added 102607 -------------------------
                  o_ren_prem_amt2 := 0;
                  o_currency_prem_amt2 := 0;

                  FOR e
                  IN (  SELECT   SUM (NVL (a.prem_amt, 0)) prem_amt,
                                 SUM (NVL (a.currency_prem_amt, 0))
                                    currency_prem_amt
                          FROM   giex_old_group_peril a
                         WHERE   a.peril_cd IN
                                       (SELECT   peril_cd
                                          FROM   giis_tax_peril
                                         WHERE       line_cd = a9.line_cd
                                                 AND iss_cd = a9.iss_cd
                                                 AND tax_cd = a9.tax_cd)
                                 AND a.policy_id = a2.policy_id
                      GROUP BY   a.peril_cd)
                  LOOP
                     o_ren_prem_amt2 := o_ren_prem_amt2 + e.prem_amt;
                     o_currency_prem_amt2 :=
                        o_currency_prem_amt2 + e.currency_prem_amt;
                  END LOOP;

                  /* cherrie 11222012, start consolidation of changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012 (tax type enhancement)*/
                  IF a9.tax_type = 'A'
                  THEN                                          --FIXED AMOUNT
                     v_dep_tax_amt := a9.tax_amount;
                  ELSIF a9.tax_type = 'N'
                  THEN                                                 --RANGE
                     v_dep_tax_amt := 0;

                     IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC')
                     THEN
                        FOR gtr
                        IN (SELECT   tax_amount
                              FROM   giis_tax_range
                             WHERE       line_cd = a9.line_cd
                                     AND iss_cd = a9.iss_cd
                                     AND tax_cd = a9.tax_cd
                                     AND tax_id = a9.tax_id -- jhing 02.28.2012
                                     AND min_value <= v_total_ren_tsi
                                     AND max_value >= v_total_ren_tsi)
                        LOOP
                           v_dep_tax_amt := gtr.tax_amount;
                        END LOOP;
                     ELSE
                        FOR gtr
                        IN (SELECT   tax_amount
                              FROM   giis_tax_range
                             WHERE       line_cd = a9.line_cd
                                     AND iss_cd = a9.iss_cd
                                     AND tax_cd = a9.tax_cd
                                     AND tax_id = a9.tax_id -- jhing 02.28.2012
                                     AND min_value <= v_total_ren_prm
                                     AND max_value >= v_total_ren_prm)
                        LOOP
                           v_dep_tax_amt := gtr.tax_amount;
                        END LOOP;
                     END IF;
                  ELSE
                      IF     MOD (o_ren_prem_amt2, 4) <> 0
                         AND a9.tax_cd = v_doc_stamps
                         AND v_param_doc = 'Y'
                      THEN
                         --v_dep_tax_amt := CEIL (o_ren_prem_amt2 / 4) * (0.5); commented by cherrie 09082012
                         -- added by cherrie 09082012
                         -- compute tax amount of doc_stamps based on compute_docstamp procedure
                         IF a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC'
                         THEN                       --IF ACCIDENT / LIFE INSURANCE
                            IF v_param_pa_doc = 1
                            THEN -- COMPUTATION is based on Premium amount time tax rate
                               v_dep_tax_amt := (o_ren_prem_amt2 * a9.rate / 100);
                            ELSIF v_param_pa_doc = 2
                            THEN -- COMPUTATION IS 50cents for every 200 pesos of total premium
                               v_dep_tax_amt :=
                                  CEIL (o_ren_prem_amt2 / 200) * (0.5);
                            ELSIF v_param_pa_doc = 3
                            THEN -- COMPUTATION IS  within the range maintain and basis is the totaL sum insured
                               BEGIN
                                  SELECT   tax_amount
                                    INTO   v_dep_tax_amt
                                    FROM   giis_tax_range gtr
                                   WHERE       1 = 1
                                           AND gtr.line_cd = a9.line_cd
                                           AND gtr.iss_cd = a9.iss_cd
                                           AND tax_cd = giacp.n ('DOC_STAMPS')
                                           AND v_total_ren_tsi BETWEEN min_value
                                                                   AND  max_value;
                               EXCEPTION
                                  WHEN NO_DATA_FOUND
                                  THEN
                                     RAISE_APPLICATION_ERROR (
                                        -20002,
                                        'NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).',
                                        TRUE
                                     );
                               END;
                            END IF;
                         ELSE
                            v_dep_tax_amt := CEIL (o_ren_prem_amt2 / 4) * (0.5);
                         END IF;
                      --end cherrie 09082012
                      ELSE
                         v_dep_tax_amt := o_ren_prem_amt2 * (a9.rate / 100);
                      END IF;

                      IF     MOD (o_currency_prem_amt2, 4) <> 0
                         AND a9.tax_cd = v_doc_stamps
                         AND v_param_doc = 'Y'
                      THEN
                         --v_currency_tax_amt := CEIL (o_currency_prem_amt2 / 4) * (0.5); commented by cherrie 09082012
                         --added by cherrie 09082012
                         IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC')
                            AND v_param_pa_doc = '2'
                         THEN /*rose 07152010 to handle currency_tax_amt pnbgen5250*/
                            v_currency_tax_amt :=
                               CEIL (o_currency_prem_amt2 / 200) * (0.5);
                         ELSE
                            v_currency_tax_amt :=
                               CEIL (o_currency_prem_amt2 / 4) * (0.5);
                         END IF;
                      --end cherrie 09082012
                      ELSE
                         v_currency_tax_amt :=
                            o_currency_prem_amt2 * (a9.rate / 100);
                      END IF;
                  END IF;
               ELSE
                  IF a9.tax_type = 'A'
                  THEN                                          --FIXED AMOUNT
                     v_dep_tax_amt := a9.tax_amount;
                  ELSIF a9.tax_type = 'N'
                  THEN                                                 --RANGE
                     v_dep_tax_amt := 0;

                     IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC')
                     THEN
                        FOR gtr
                        IN (SELECT   tax_amount
                              FROM   giis_tax_range
                             WHERE       line_cd = a9.line_cd
                                     AND iss_cd = a9.iss_cd
                                     AND tax_cd = a9.tax_cd
                                     AND tax_id = a9.tax_id -- jhing 02.28.2012
                                     AND min_value <= v_total_ren_tsi
                                     AND max_value >= v_total_ren_tsi)
                        LOOP
                           v_dep_tax_amt := gtr.tax_amount;
                        END LOOP;
                     ELSE
                        FOR gtr
                        IN (SELECT   tax_amount
                              FROM   giis_tax_range
                             WHERE       line_cd = a9.line_cd
                                     AND iss_cd = a9.iss_cd
                                     AND tax_cd = a9.tax_cd
                                     AND tax_id = a9.tax_id -- jhing 02.28.2012
                                     AND min_value <= v_total_ren_prm
                                     AND max_value >= v_total_ren_prm)
                        LOOP
                           v_dep_tax_amt := gtr.tax_amount;
                        END LOOP;
                     END IF;
                  ELSE   
                      IF     MOD (v_a8_ren_prem_amt, 4) <> 0
                         AND a9.tax_cd = v_doc_stamps
                         AND v_param_doc = 'Y'
                      THEN
                         --v_dep_tax_amt := CEIL (v_a8_ren_prem_amt / 4) * (0.5); commented by cherrie 09082012
                         -- added by cherrie 09082012
                         -- compute tax amount of doc_stamps based on compute_docstamp procedure
                         IF a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC'
                         THEN                       --IF ACCIDENT / LIFE INSURANCE
                            IF v_param_pa_doc = 1
                            THEN -- COMPUTATION is based on Premium amount time tax rate
                               v_dep_tax_amt :=
                                  (v_a8_ren_prem_amt * a9.rate / 100);
                            ELSIF v_param_pa_doc = 2
                            THEN -- COMPUTATION IS 50cents for every 200 pesos of total premium
                               v_dep_tax_amt :=
                                  CEIL (v_a8_ren_prem_amt / 200) * (0.5);
                            ELSIF v_param_pa_doc = 3
                            THEN -- COMPUTATION IS  within the range maintain and basis is the totaL sum insured
                               BEGIN
                                  SELECT   tax_amount
                                    INTO   v_dep_tax_amt
                                    FROM   giis_tax_range gtr
                                   WHERE       1 = 1
                                           AND gtr.line_cd = a9.line_cd
                                           AND gtr.iss_cd = a9.iss_cd
                                           AND tax_cd = giacp.n ('DOC_STAMPS')
                                           AND v_total_ren_tsi BETWEEN min_value
                                                                   AND  max_value;
                               EXCEPTION
                                  WHEN NO_DATA_FOUND
                                  THEN
                                     RAISE_APPLICATION_ERROR (
                                        -20002,
                                        'NO RECORDS EXIST FOR DOC STAMPS IN THIS LINE AND ISSUE SOURCE (GIIS_TAX_RANGE).',
                                        TRUE
                                     );
                               END;
                            END IF;
                         ELSE
                            v_dep_tax_amt := CEIL (v_a8_ren_prem_amt / 4) * (0.5);
                         END IF;
                      --end cherrie 09082012
                      ELSE
                         v_dep_tax_amt := v_a8_ren_prem_amt * (a9.rate / 100);
                      END IF;

                      IF     MOD (v_currency_prem_amt, 4) <> 0
                         AND a9.tax_cd = v_doc_stamps
                         AND v_param_doc = 'Y'
                      THEN
                         --added by cherrie 09082012
                         IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC')
                            AND v_param_pa_doc = '2'
                         THEN /*rose 07152010 to handle currency_tax_amt pnbgen5250*/
                            v_currency_tax_amt :=
                               CEIL (o_currency_prem_amt2 / 200) * (0.5);
                         ELSE
                            v_currency_tax_amt :=
                               CEIL (v_currency_prem_amt / 4) * (0.5);
                         END IF;
                      --end cherrie 09082012
                      --v_currency_tax_amt := CEIL (v_currency_prem_amt / 4) * (0.5); commented by cherrie 09082012
                      ELSE
                         v_currency_tax_amt :=
                            v_currency_prem_amt * (a9.rate / 100);
                      END IF;
                  END IF;
               END IF;
               /* cherrie 11222012, end consolidation of changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012 (tax type enhancement)*/
               
               BEGIN
                  SELECT   COUNT ( * )
                    INTO   v_ctr
                    FROM   giex_old_group_tax
                   WHERE       policy_id = a2.policy_id
                           AND line_cd = a9.line_cd
                           AND iss_cd = a9.iss_cd
                           AND tax_cd = a9.tax_cd
                           AND tax_id = a9.tax_id;
               END;

               IF v_ctr = 0
               THEN
                  INSERT INTO giex_old_group_tax (policy_id,
                                                  line_cd,
                                                  iss_cd,
                                                  tax_cd,
                                                  tax_id,
                                                  tax_desc,
                                                  tax_amt,
                                                  currency_tax_amt)
                    VALUES   (a2.policy_id,
                              a9.line_cd,
                              a9.iss_cd,
                              a9.tax_cd,
                              a9.tax_id,
                              a9.tax_desc,
                              v_dep_tax_amt,
                              v_currency_tax_amt);
               ELSE
                  UPDATE   giex_old_group_tax
                     SET   tax_amt =
                              v_dep_tax_amt + giex_old_group_tax.tax_amt,
                           currency_tax_amt =
                              v_currency_tax_amt
                              + giex_old_group_tax.currency_tax_amt
                   WHERE       policy_id = a2.policy_id
                           AND line_cd = a9.line_cd
                           AND iss_cd = a9.iss_cd
                           AND tax_cd = a9.tax_cd
                           AND tax_id = a9.tax_id;
               END IF;

               v_dep_tax_amt := 0;
               v_currency_tax_amt := 0;
            END LOOP;

            FOR a8x
            IN (  SELECT   SUM (a.prem_amt * c.currency_rt) prem_amt2,
                           SUM (a.tsi_amt * c.currency_rt) tsi_amt2,
                           a.line_cd,
                           a.peril_cd,
                           d.peril_type peril_type
                    FROM   gipi_itmperil a,
                           gipi_polbasic b,
                           gipi_item c,
                           giis_peril d
                   WHERE       b.line_cd = a2.line_cd
                           AND b.subline_cd = a2.subline_cd
                           AND b.iss_cd = a2.iss_cd
                           AND b.issue_yy = a2.issue_yy
                           AND b.pol_seq_no = a2.pol_seq_no
                           AND b.renew_no = a2.renew_no
                           AND d.peril_cd = a.peril_cd
                           AND d.line_cd = a.line_cd
                           AND a.policy_id = b.policy_id
                           AND b.policy_id = c.policy_id
                           AND a.policy_id = b.policy_id
                           AND a.item_no = c.item_no
                           AND b.pol_flag IN ('1', '2', '3')
                           --          AND b.pack_policy_id IS NULL
                           AND NVL (b.reg_policy_sw, 'Y') =
                                 DECODE (NVL (inc_special_sw, 'N'),
                                         'N', 'Y',
                                         NVL (b.reg_policy_sw, 'Y'))
                           AND (b.endt_seq_no = 0
                                OR (b.endt_seq_no > 0
                                    AND TRUNC (b.endt_expiry_date) >=
                                          TRUNC (b.expiry_date)))
                GROUP BY   a.peril_cd, a.line_cd, d.peril_type)
            LOOP
               o_prem_amt2 := a8x.prem_amt2;
               o_tsi_amt2 := a8x.tsi_amt2;

               IF a8x.peril_type = 'B'
               THEN
                  v_total_dep_tsi := NVL (v_total_dep_tsi, 0) + o_tsi_amt2;
               END IF;

               v_total_dep_prm := NVL (v_total_dep_prm, 0) + o_prem_amt2;
            END LOOP;

            --added by A.R.C. 03.07.2005
            UPDATE   giex_expiry
               SET   tsi_amt = v_total_dep_tsi,
                     prem_amt = v_total_dep_prm,
                     ren_tsi_amt = v_total_ren_tsi,
                     ren_prem_amt = v_total_ren_prm,
                     currency_prem_amt = v_total_currency_prm
             WHERE   policy_id = a2.policy_id;
             
           /* start cherrie 11222012, consolidation of changes on version with uw-specs-2011-00026*/
           /* added by: udel
           ** date: 06212011
           ** uw-specs-2011-00026
           ** if parameter include_deductible_expiry is set to y, it will check if
           ** the deductible rate and amount are more than zero. if yes, the selected columns
           ** will be inserted into giex_old_group_deductibles table.
           */
            IF NVL (giisp.v ('INCLUDE_DEDUCTIBLE_EXPIRY'), 'N') = 'Y'
            THEN
               FOR ded_cur
               IN (  SELECT   A.item_no,
                              A.peril_cd,
                              A.ded_deductible_cd,
                              b.line_cd,
                              b.subline_cd,
                              SUM (A.deductible_rt) deductible_rt,
                              SUM (A.deductible_amt) deductible_amt
                       FROM   gipi_deductibles A, gipi_polbasic b
                      WHERE       1 = 1
                              AND b.policy_id = A.policy_id
                              AND b.pol_flag IN ('1', '2', '3')
                              --AND b.pack_policy_id IS NULL --cerrie 11222012
                              AND NVL (b.reg_policy_sw, 'N') =
                                    DECODE (NVL (inc_special_sw, 'N'),
                                            'N', 'Y',
                                            NVL (b.reg_policy_sw, 'N'))
                              AND (b.endt_seq_no = 0
                                   OR (b.endt_seq_no > 0
                                       AND TRUNC (b.endt_expiry_date) >=
                                             TRUNC (b.expiry_date)))
                              AND b.line_cd = a2.line_cd
                              AND b.subline_cd = a2.subline_cd
                              AND b.iss_cd = a2.iss_cd
                              AND b.issue_yy = a2.issue_yy
                              AND b.pol_seq_no = a2.pol_seq_no
                              AND b.renew_no = a2.renew_no
                   GROUP BY   A.item_no,
                              A.peril_cd,
                              A.ded_deductible_cd,
                              b.line_cd,
                              b.subline_cd,
                              b.eff_date,
                              b.endt_seq_no
                   ORDER BY   b.eff_date DESC, b.endt_seq_no)
               LOOP
                  IF ded_cur.deductible_rt > 0 AND ded_cur.deductible_amt > 0
                  THEN
                     INSERT INTO giex_old_group_deductibles (
                                                                policy_id,
                                                                item_no,
                                                                peril_cd,
                                                                ded_deductible_cd,
                                                                line_cd,
                                                                subline_cd,
                                                                deductible_rt,
                                                                deductible_amt
                                )
                       VALUES   (v_pol_id,
                                 ded_cur.item_no,
                                 ded_cur.peril_cd,
                                 ded_cur.ded_deductible_cd,
                                 ded_cur.line_cd,
                                 ded_cur.subline_cd,
                                 ded_cur.deductible_rt,
                                 ded_cur.deductible_amt);
                  END IF;
               END LOOP;
            END IF;
            /* end cherrie 11222012, consolidation of changes on version with uw-specs-2011-00026*/

            UPDATE   giex_pack_expiry
               SET
                     (tsi_amt,
                     prem_amt,
                     ren_tsi_amt,
                     ren_prem_amt,
                     currency_prem_amt
                     ) =
                        (SELECT   SUM (tsi_amt),
                                  SUM (prem_amt),
                                  SUM (ren_tsi_amt),
                                  SUM (ren_prem_amt),
                                  SUM (currency_prem_amt)
                           FROM   giex_expiry
                          WHERE   pack_policy_id = a2.pack_policy_id)
             WHERE   pack_policy_id = a2.pack_policy_id;
         END LOOP;

         FOR m
         IN (  SELECT   intrmdry_intm_no,
                        NVL (b.policy_currency, 'N') policy_currency
                 FROM   gipi_comm_invoice a, gipi_invoice b
                WHERE       a.policy_id = v_pol_id
                        AND a.iss_cd = b.iss_cd
                        AND a.prem_seq_no = b.prem_seq_no
             ORDER BY   b.prem_seq_no DESC)
         LOOP
            UPDATE   giex_expiry
               SET   intm_no = m.intrmdry_intm_no,
                     policy_currency = m.policy_currency
             WHERE   policy_id = v_pol_id;

            EXIT;
         END LOOP;
      END LOOP;
   END IF;
/* end of gmicode:(9336953) details of package records and non-package details*/
END;
/


