DROP PROCEDURE CPI.PROCESS_EXPIRING_POLICIES;

CREATE OR REPLACE PROCEDURE CPI.Process_Expiring_Policies (
   p_intm_no                     GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE,
   p_fr_date                     DATE,
   p_to_date                     DATE,
   inc_special_sw                VARCHAR2 DEFAULT 'N' ,
   p_line_cd                     GIPI_POLBASIC.line_cd%TYPE,
   p_subline_cd                  GIPI_POLBASIC.subline_cd%TYPE,
   p_iss_cd                      GIPI_POLBASIC.iss_cd%TYPE,
   p_issue_yy                    GIPI_POLBASIC.issue_yy%TYPE,
   p_pol_seq_no                  GIPI_POLBASIC.pol_seq_no%TYPE,
   p_renew_no                    GIPI_POLBASIC.renew_no%TYPE,
   p_def_is_pol_summ_sw          GIIS_PARAMETERS.param_value_v%TYPE,
   p_def_same_polno_sw           GIIS_PARAMETERS.param_value_v%TYPE,
   p_plate_no                    GIPI_VEHICLE.plate_no%TYPE,
   t_policy_id            IN OUT DBMS_SQL.NUMBER_TABLE,
   t_line_cd              IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_subline_cd           IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_iss_cd               IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_issue_yy             IN OUT DBMS_SQL.NUMBER_TABLE,
   t_pol_seq_no           IN OUT DBMS_SQL.NUMBER_TABLE,
   t_renew_no             IN OUT DBMS_SQL.NUMBER_TABLE,
   t_expiry_date          IN OUT DBMS_SQL.DATE_TABLE,
   t_incept_date          IN OUT DBMS_SQL.DATE_TABLE,
   t_assd_no              IN OUT DBMS_SQL.NUMBER_TABLE,
   t_auto_sw              IN OUT DBMS_SQL.VARCHAR2_TABLE,
   t_intm_no              IN OUT DBMS_SQL.NUMBER_TABLE
)
IS
   v_a8_ren_prem_amt      GIPI_POLBASIC.ann_prem_amt%TYPE;
   v_currency_prem_amt    GIEX_EXPIRY.currency_prem_amt%TYPE;
   v_currency_tax_amt     GIEX_EXPIRY.currency_prem_amt%TYPE;
   o_currency_prem_amt2   GIEX_EXPIRY.currency_prem_amt%TYPE;
   v_total_currency_prm   GIEX_EXPIRY.currency_prem_amt%TYPE;
   v_currency_prm_ogrp    GIEX_EXPIRY.currency_prem_amt%TYPE;

   cnt_ext                NUMBER := 0;
   counter                NUMBER := 1;
   cntr                   NUMBER := 1;
   cnt                    NUMBER := 1;
   v_count                NUMBER := 0;
   v_peril_cnt            NUMBER := 0;
   v_skip                 VARCHAR2 (1) := NULL;
   v_policy_no            VARCHAR2 (100); --variable to keep the record being processed
   v_policy_ids           VARCHAR2 (32000);  --variable to keep the policy_ids
   v_expiry_sw            VARCHAR2 (1) := 'N'; --to identify if the policy already exists in giex_expiry.
   v_clm                  VARCHAR2 (1);
   v_bal                  VARCHAR2 (1);
   v_sw                   VARCHAR2 (1) := 'N';
   v_intm_sw              VARCHAR2 (1) := 'N';
   various                VARCHAR2 (100);
   TO_DATE                DATE;
   fr_date                DATE;
   t_peril_cds            DBMS_SQL.number_table;
   t_item_nos             DBMS_SQL.number_table;
   v_line_cd              gipi_polbasic.line_cd%TYPE;
   v_subline_cd           gipi_polbasic.subline_cd%TYPE;
   v_iss_cd               gipi_polbasic.iss_cd%TYPE;
   v_issue_yy             gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no             gipi_polbasic.renew_no%TYPE;
   v_back_stat            gipi_polbasic.back_stat%TYPE;
   v_endt_seq_no          gipi_polbasic.endt_seq_no%TYPE;
   pv_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
   v_expiry_date          gipi_polbasic.expiry_date%TYPE;
   v_incept_date          gipi_polbasic.incept_date%TYPE;
   v_eff_date             gipi_polbasic.eff_date%TYPE;
   v_assd_no              gipi_polbasic.assd_no%TYPE;
   v_ext_date             gipi_polbasic.expiry_date%TYPE := SYSDATE;
   v_tsi                  gipi_polbasic.tsi_amt%TYPE;
   v_prem                 gipi_polbasic.prem_amt%TYPE;
   v_ann_prem             gipi_polbasic.ann_prem_amt%TYPE;
   v_pol_id               gipi_polbasic.policy_id%TYPE;
   v_exp_date             gipi_polbasic.expiry_date%TYPE;
   v_inc_date             gipi_polbasic.incept_date%TYPE;
   v_spld_flag            gipi_polbasic.spld_flag%TYPE;
   v_expiry_tag           gipi_polbasic.expiry_tag%TYPE;
   v_policy_id            gipi_polbasic.policy_id%TYPE;
   v_intm_no              gipi_comm_invoice.intrmdry_intm_no%TYPE;
   v_auto_sw              giex_expiry.auto_sw%TYPE := 'Y';
   v_ren_flag             giex_expiry.renew_flag%TYPE;
   v_summ_sw              giex_expiry.summary_sw%TYPE;
   v_same_sw              giex_expiry.same_polno_sw%TYPE;
   v_reg_pol_sw           giex_expiry.reg_policy_sw%TYPE;
   v_renewal_id           giex_expiry.renewal_id%TYPE;
   v_tax                  giex_expiry.tax_amt%TYPE;
   v_pol_tax              giex_expiry.tax_amt%TYPE;
   v_car_company          giex_expiry.car_company%TYPE;
   v_rate                 gipi_item.currency_rt%TYPE;
   v_item_title           gipi_item.item_title%TYPE;
   v_color                gipi_vehicle.color%TYPE;
   v_motor_no             gipi_vehicle.motor_no%TYPE;
   v_model_year           gipi_vehicle.model_year%TYPE;
   v_make                 gipi_vehicle.make%TYPE;
   v_serial_no            gipi_vehicle.serial_no%TYPE;
   v_plate_no             gipi_vehicle.plate_no%TYPE;
   v_item_no              gipi_vehicle.item_no%TYPE;
   v_line_mc              giis_line.line_cd%TYPE;
   v_line_fi              giis_line.line_cd%TYPE;
   v_loc_risk1            gipi_fireitem.loc_risk1%TYPE;
   v_loc_risk2            gipi_fireitem.loc_risk2%TYPE;
   v_loc_risk3            gipi_fireitem.loc_risk3%TYPE;
   o_line_cd              giex_expiry.line_cd%TYPE;
   o_peril_cd             giex_old_group_peril.peril_cd%TYPE;
   o_prem_amt2            giex_old_group_peril.prem_amt%TYPE;
   o_ren_prem_amt2        giex_old_group_peril.prem_amt%TYPE;
   o_tsi_amt2             giex_old_group_peril.tsi_amt%TYPE;
   o_ren_tsi_amt2         giex_old_group_peril.tsi_amt%TYPE;
   v_orig_tsi_exp         giex_expiry.tsi_amt%TYPE;
   v_orig_tsi_item        giex_expiry.tsi_amt%TYPE;
   v_orig_tsi_ngrp        giex_expiry.tsi_amt%TYPE;
   v_orig_tsi_ogrp        giex_expiry.tsi_amt%TYPE;
   v_ren_tsi_ogrp         giex_expiry.ren_tsi_amt%TYPE;
   v_orig_prm_ogrp        giex_expiry.prem_amt%TYPE;
   v_ren_prm_ogrp         giex_expiry.ren_prem_amt%TYPE;
   v_auto_dep giis_parameters.param_value_v%TYPE
         := NVL (Giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N') ; --VARCHAR2(2);/*commented by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012;*/
   v_dep_pct giis_parameters.param_value_v%TYPE
         := NVL (Giisp.n ('MC_DEP_PCT'), 0) ; --NUMBER;/*commented by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012;*/
   v_total_dep_tsi        giex_expiry.tsi_amt%TYPE := 0;
   v_total_ren_tsi        giex_expiry.ren_tsi_amt%TYPE := 0;
   v_total_dep_prm        giex_expiry.prem_amt%TYPE := 0;
   v_total_ren_prm        giex_expiry.ren_prem_amt%TYPE := 0;
   v_dep_tax_amt          gipi_inv_tax.tax_amt%TYPE := 0;
   v_extraction           VARCHAR2 (1);
   v_ctr                  NUMBER;
   v_risk_no              giex_expiry.risk_no%TYPE;
   v_risk_item_no         giex_expiry.risk_item_no%TYPE;
   v_motor_coverage       giex_expiry.motor_coverage%TYPE;
   v_doc_stamps giac_parameters.param_value_n%TYPE
         := giacp.n ('DOC_STAMPS') ;
   v_param_doc giis_parameters.param_value_v%TYPE
         := giisp.v ('COMPUTE_OLD_DOC_STAMPS') ;
   v_param_pa_doc giis_parameters.param_value_v%TYPE
         := giisp.v ('COMPUTE_PA_DOC_STAMPS') ;       -- 7/14/2010: 2010-00090
   v_acct_iss_cd          giis_issource.acct_iss_cd%TYPE := NULL;
   v_ref_no               NUMBER;
   v_mod_no               NUMBER;
   v_ref                  giex_expiry.bank_ref_no%TYPE := NULL;         --ppmk
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
      v_extraction := 'D';
   ELSE
      v_extraction := 'P';
   END IF;

   --v_auto_dep := Giisp.v('AUTO_COMPUTE_MC_DEP');/*commented by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012;*/
   --v_dep_pct  := Giisp.n('MC_DEP_PCT');/*commented by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012;*/

   DBMS_OUTPUT.put_line (
      'START PROCEDURE : ' || TO_CHAR (SYSDATE, 'MMDDYYYY HH:MI:SS AM')
   );

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
                /*AND EXISTS (SELECT 1
                           FROM GIPI_VEHICLE gpv
                    WHERE 1 = 1
                   AND A.policy_id = gpv.policy_id
                   AND gpv.plate_no LIKE '%'||p_plate_no
                 UNION ALL
                 SELECT 1
                   FROM dual
                  WHERE 1 = decode(p_plate_no, NULL, 1, 2)
                   )*/
                --commented by gmi (optimize purpose) --
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
                ** check whether a policy already exists
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
      -- still processing the same policy or first record
      IF v_policy_no IS NULL OR v_policy_no = a1.policy_no
      THEN
         IF a1.endt_seq_no = 0
         THEN
            v_endt_seq_no := a1.endt_seq_no;
            v_policy_id := a1.policy_id;
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
         v_reg_pol_sw := a1.reg_policy_sw;

         --this will assure that you will get the latest change
         IF v_eff_date IS NULL
            OR v_eff_date > a1.eff_date AND a1.endt_seq_no <> 0
         THEN
            v_eff_date := a1.eff_date;
         END IF;

         IF v_expiry_date IS NULL
            OR v_expiry_date <> a1.expiry_date AND a1.endt_seq_no <> 0
         THEN
            v_expiry_date := a1.expiry_date;
         END IF;

         IF v_incept_date IS NULL
            OR v_incept_date <> a1.incept_date AND a1.endt_seq_no <> 0
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

         v_policy_no := a1.policy_no;
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
               v_intm_sw := 'N';

               /*include renewal of policies without endts*/
               -- expiry was done with a specific intm_no
               IF p_intm_no IS NOT NULL
               THEN
                  v_intm_sw := 'Y';

                  DECLARE
                     TYPE cv_type IS REF CURSOR;

                     CV       cv_type;
                     retval   NUMBER := 0;
                  BEGIN
                     --the ff statement was untagged, to resolve ora-01722 encountered
                     OPEN CV FOR
                        'SELECT 1
                                    FROM GIPI_COMM_INVOICE
                                   WHERE POLICY_ID IN ('
                        || v_policy_ids
                        || ')
                                     AND INTRMDRY_INTM_NO = :INTM
                                     AND ROWNUM = 1 '
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

               IF     v_intm_sw = 'N'
                  AND v_endt_seq_no = 0
                  AND v_policy_id IS NOT NULL
                  AND v_policy_no != 'XX'
                  AND v_spld_flag <> '2'
                  AND v_expiry_tag = 'N'
                  AND v_expiry_sw = 'N'
               THEN
                  --include policy in expiry checking
                  -- added by rbd to get the correct expiry date and inception date if policy has backward endt
                  counter := counter + 1;

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
                                 AND b2501.pack_policy_id IS NULL
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
                                    AND b2501.pack_policy_id IS NULL
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

                  -- added by rbd to get the correct assured if policy has backward endt
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
                                 AND b2501.pack_policy_id IS NULL
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

                  v_count := v_count + 1;
                  t_policy_id (v_count) := v_policy_id;
                  t_line_cd (v_count) := v_line_cd;
                  t_subline_cd (v_count) := v_subline_cd;
                  t_iss_cd (v_count) := v_iss_cd;
                  t_issue_yy (v_count) := v_issue_yy;
                  t_pol_seq_no (v_count) := v_pol_seq_no;
                  t_renew_no (v_count) := v_renew_no;
                  t_expiry_date (v_count) := v_expiry_date;
                  t_incept_date (v_count) := v_incept_date;
                  t_assd_no (v_count) := v_assd_no;
                  t_intm_no (v_count) := v_intm_no;
                  t_auto_sw (v_count) := v_auto_sw;
               END IF;
            END IF;
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
         v_expiry_date := a1.expiry_date;
         v_incept_date := a1.incept_date;
         v_assd_no := a1.assd_no;
         v_spld_flag := NVL (a1.spld_flag, '1');
         v_expiry_tag := NVL (a1.expiry_tag, 'N');
         v_policy_no := a1.policy_no;
         v_reg_pol_sw := a1.reg_policy_sw;
      END IF;
   END LOOP;                                             --(end of first loop)

   v_line_mc := giisp.v ('LINE_CODE_MC');
   v_line_fi := giisp.v ('LINE_CODE_FI');

   IF t_policy_id.EXISTS (1)
   THEN
      FOR a1 IN t_policy_id.FIRST .. t_policy_id.LAST
      LOOP
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
         v_pol_id := t_policy_id (a1);
         v_exp_date := t_expiry_date (a1);
         v_assd_no := t_assd_no (a1);
         v_intm_no := t_intm_no (a1);
         v_inc_date := t_incept_date (a1);
         v_auto_sw := t_auto_sw (a1);

         /* Udel 08102012 added REF_POL_NO to insert into GIEX_EXPIRY */
         FOR a2 IN (SELECT   line_cd,
                             subline_cd,
                             iss_cd,
                             issue_yy,
                             pol_seq_no,
                             renew_no,
                             auto_renew_flag,
                             policy_id,
                             reg_policy_sw,
                             ref_pol_no
                      FROM   gipi_polbasic
                     WHERE   policy_id = v_pol_id AND pack_policy_id IS NULL)
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
            IN (  SELECT   NVL (prem_amt, 0) prem,
                           NVL (tsi_amt, 0) tsi,
                           NVL (ann_prem_amt, 0) ann_prem
                    FROM   gipi_polbasic
                   WHERE       line_cd = a2.line_cd
                           AND subline_cd = a2.subline_cd
                           AND iss_cd = a2.iss_cd
                           AND issue_yy = a2.issue_yy
                           AND pol_seq_no = a2.pol_seq_no
                           AND renew_no = a2.renew_no
                           AND pol_flag IN ('1', '2', '3')
                           AND pack_policy_id IS NULL
                           AND (endt_seq_no = 0
                                OR (endt_seq_no > 0
                                    AND TRUNC (endt_expiry_date) >=
                                          TRUNC (expiry_date)))
                ORDER BY   endt_seq_no)
            LOOP
               v_orig_tsi_exp := NVL (v_orig_tsi_exp, 0) + a4.tsi;
               v_prem := NVL (v_prem, 0) + a4.prem;
               v_ann_prem := a4.ann_prem;
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
                                        TRUNC (a.expiry_date)))
                         AND a.pack_policy_id IS NULL)
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
                           AND a.pack_policy_id IS NULL    --A.R.C. 05.07.2007
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
                           AND a.pack_policy_id IS NULL    --A.R.C. 05.07.2007
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
                              c.risk_no,
                              c.risk_item_no,
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
                              AND a.pack_policy_id IS NULL
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
                        v_risk_no := fi.risk_no;
                        v_risk_item_no := fi.risk_item_no;
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
                           v_risk_no := fi.risk_no;
                           v_risk_item_no := fi.risk_item_no;
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
                              b.motor_coverage
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
                              AND a.pack_policy_id IS NULL
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
                        NVL (a9.motor_coverage, v_motor_coverage);
                  ELSE
                     v_color := 'VARIOUS';
                     v_motor_no := 'VARIOUS';
                     v_model_year := 'VAR.';
                     v_make := 'VARIOUS';
                     v_serial_no := 'VARIOUS';
                     v_plate_no := 'VARIOUS';
                     v_car_company := NULL;
                     v_motor_coverage := NULL;
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

            /*Modified by Iris Bordey 08.29.2003
            **Transferred end-if after insertion to all table affected by giex_expiry
            **to resolve ora-02291 (parent key not found).
            */
            /*Commented by A.R.C. 03.07.2005
            **Transferred to after insertion to table giex_expiry
            **to resolve ora-02291 (parent key not found).
            */
            v_renewal_id :=
               TRANSLATE (a2.policy_id, '0123456789', 'ABCDGJMPTW');

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

            /* petermkaw 06232010
            ** changed mod_no to bank_ref_no and v_mod_no to v_ref
            ** to acquire bank_ref_no form gipi_ref_no_hist and commented out the
            ** population of v_ref below */
            BEGIN
               SELECT   bank_ref_no                                 /*mod_no*/
                 INTO   v_ref                                     /*v_mod_no*/
                 FROM   gipi_ref_no_hist
                WHERE       acct_iss_cd = v_acct_iss_cd
                        AND branch_cd = 0000
                        AND ref_no = v_ref_no;                        --mod_no
            EXCEPTION
               WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
               THEN
                  NULL;
            END;

            /*v_ref:=v_acct_iss_cd||'-'||0000||'-'||v_ref_no||'-'||v_mod_no;*/
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
                                     motor_coverage,
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
                        v_risk_no,
                        v_risk_item_no,
                        v_motor_coverage,
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
                  t_peril_cds.DELETE;
                  t_item_nos.DELETE;
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
                           AND b.pack_policy_id IS NULL
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
               -- EXIT;
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
                  --o_prem_amt2     := a8.prem_amt2;
                  v_orig_tsi_ogrp := a8.ren_tsi_amt;
                  v_orig_prm_ogrp := a8.ren_prem_amt;
                  v_ren_tsi_ogrp := a8.ren_tsi_amt;
                  v_ren_prm_ogrp := a8.ren_prem_amt;
                  v_currency_prm_ogrp := a8.currency_prem_amt;

                  --   v_a8_ren_prem_amt := v_a8_ren_prem_amt + a8.ren_prem_amt;
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

            v_ctr := 0;

            FOR a9
            IN (  SELECT   d.line_cd,
                           d.tax_cd,
                           e.tax_id,
                           d.iss_cd,
                           f.menu_line_cd, -- 7/14/2010: F.menu_line_cd   2010-00090
                           e.tax_desc,
                           e.rate rate,
                           e.peril_sw,
                           tax_type, -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                           tax_amount -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                    FROM   gipi_polbasic b,
                           gipi_invoice c,
                           gipi_inv_tax d,
                           giis_tax_charges e,
                           giis_line f                -- 7/14/2010: 2010-00090
                   WHERE       b.line_cd = a2.line_cd
                           AND b.subline_cd = a2.subline_cd
                           AND b.iss_cd = a2.iss_cd
                           AND b.issue_yy = a2.issue_yy
                           AND b.pol_seq_no = a2.pol_seq_no
                           AND b.renew_no = a2.renew_no
                           AND b.line_cd = f.line_cd  -- 7/14/2010: 2010-00090
                           AND b.policy_id = c.policy_id
                           AND d.prem_seq_no = c.prem_seq_no
                           AND d.iss_cd = b.iss_cd
                           AND d.tax_cd = e.tax_cd
                           --         AND d.tax_id          = e.tax_id
                           AND d.iss_cd = e.iss_cd
                           AND d.line_cd = e.line_cd
                           AND NVL (e.expired_sw, 'N') = 'N'
                           AND ADD_MONTHS (b.incept_date, 12) BETWEEN eff_start_date
                                                                  AND  eff_end_date
                           AND b.pol_flag IN ('1', '2', '3')
                           AND b.pack_policy_id IS NULL    --A.R.C. 05.07.2007
                           AND NVL (b.reg_policy_sw, 'Y') =
                                 DECODE (NVL (inc_special_sw, 'N'),
                                         'N', 'Y',
                                         NVL (b.reg_policy_sw, 'Y'))
                           AND (b.endt_seq_no = 0
                                OR (b.endt_seq_no > 0
                                    AND TRUNC (b.endt_expiry_date) >=
                                          TRUNC (b.expiry_date)))
                GROUP BY   d.line_cd,
                           d.tax_cd,
                           e.tax_id,
                           d.iss_cd,
                           e.tax_desc,
                           e.rate,
                           e.peril_sw,
                           f.menu_line_cd -- 7/14/2010: F.menu_line_cd    2010-00089
                                         ,
                           tax_type, -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                           tax_amount -- added by cherrie 11212012, to consolidate changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012
                                     )
            LOOP
               /* start consolidation of changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012*/
               /*start of consolidation rose 07152010 added the computation od doc stamps for PA*/
               /*start of consolidation VJPS 022812; added the tax type enhancement*/
               IF a9.peril_sw = 'Y'
               THEN
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
                        /* commented out by cherrie 09082012
                        IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') AND  v_param_pa_doc = '2' THEN                                         -- 7/14/2010: 2010-00089
                           v_dep_tax_amt := CEIL (o_ren_prem_amt2 / 200) * (0.5);                                                                                                 -- 7/14/2010: 2010-00089
                        ELSE                                                                                                                                                       -- 7/14/2010: 2010-00089
                           v_dep_tax_amt := CEIL (o_ren_prem_amt2 / 4) * (0.5);
                        END IF;     */
                        -- added by cherrie 09082012
                        -- compute tax amount of doc_stamps based on compute_docstamp procedure
                        IF a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC'
                        THEN                    --IF ACCIDENT / LIFE INSURANCE
                           IF v_param_pa_doc = 1
                           THEN -- COMPUTATION is based on Premium amount time tax rate
                              v_dep_tax_amt :=
                                 (o_ren_prem_amt2 * a9.rate / 100);
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
                     --end cherrie 09082012                                                                                                                     -- 7/14/2010: 2010-00089
                     ELSE
                        v_dep_tax_amt := o_ren_prem_amt2 * (a9.rate / 100);
                     END IF;

                     IF     MOD (o_currency_prem_amt2, 4) <> 0
                        AND a9.tax_cd = v_doc_stamps
                        AND v_param_doc = 'Y'
                     THEN
                        IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC')
                           AND v_param_pa_doc = '2'
                        THEN /*rose 07152010 to handle currency_tax_amt pnbgen5250*/
                           v_currency_tax_amt :=
                              CEIL (o_currency_prem_amt2 / 200) * (0.5);
                        ELSE
                           v_currency_tax_amt :=
                              CEIL (o_currency_prem_amt2 / 4) * (0.5);
                        END IF;
                     ELSE
                        v_currency_tax_amt :=
                           o_currency_prem_amt2 * (a9.rate / 100);
                     END IF;
                  END IF;
               ELSE                                          --peril_sw <> 'Y'
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
                  ELSE                                                  --RATE
                     IF     MOD (v_a8_ren_prem_amt, 4) <> 0
                        AND a9.tax_cd = v_doc_stamps
                        AND v_param_doc = 'Y'
                     THEN
                        /* commented out by cherrie 09082012
                        IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC') AND v_param_pa_doc = '2' THEN                                         -- 7/14/2010: 2010-00089
                           v_dep_tax_amt := CEIL (v_a8_ren_prem_amt / 200) * (0.5);                                                                                               -- 7/14/2010: 2010-00089
                        ELSE                                                                                                                                                       -- 7/14/2010: 2010-00089
                           v_dep_tax_amt := CEIL (v_a8_ren_prem_amt / 4) * (0.5);
                        END IF;                        */
                        -- 7/14/2010: 2010-00089

                        -- added by cherrie 09082012
                        -- compute tax amount of doc_stamps based on compute_docstamp procedure
                        IF a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC'
                        THEN                    --IF ACCIDENT / LIFE INSURANCE
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
                           v_dep_tax_amt :=
                              CEIL (v_a8_ren_prem_amt / 4) * (0.5);
                        END IF;
                     --end cherrie 09082012

                     ELSE
                        v_dep_tax_amt := v_a8_ren_prem_amt * (a9.rate / 100);
                     END IF;

                     IF     MOD (v_currency_prem_amt, 4) <> 0
                        AND a9.tax_cd = v_doc_stamps
                        AND v_param_doc = 'Y'
                     THEN
                        IF (a9.menu_line_cd = 'AC' OR a9.line_cd = 'AC')
                           AND v_param_pa_doc = '2'
                        THEN /*rose 07152010 to handle currency_tax_amt pnbgen5250*/
                           v_currency_tax_amt :=
                              CEIL (o_currency_prem_amt2 / 200) * (0.5);
                        ELSE
                           v_currency_tax_amt :=
                              CEIL (v_currency_prem_amt / 4) * (0.5);
                        END IF;
                     ELSE
                        v_currency_tax_amt :=
                           v_currency_prem_amt * (a9.rate / 100);
                     END IF;
                  END IF;
               END IF;

               /*end of consolidation VJPS 022812; added the tax type enhancement*/
               /*end of consolidation rose 07152010 added the computation of doc stamps for PA*/
               /* end consolidation of changes on version GEN-2012-025_PROCESS_EXPIRING_POLICIES_A_V01_02282012*/
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
                           AND b.pack_policy_id IS NULL
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
                              AND b.pack_policy_id IS NULL
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
         /* end udel 06212011 */
         /* end cherrie 11222012, consolidation of changes on version with uw-specs-2011-00026*/
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

   DBMS_OUTPUT.put_line (
      'ENDED PROCEDURE : ' || TO_CHAR (SYSDATE, 'MMDDYYYY HH:MI:SS AM')
   );
END;
/


