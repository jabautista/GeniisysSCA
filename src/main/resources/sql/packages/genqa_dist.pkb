CREATE OR REPLACE PACKAGE BODY CPI.genqa_dist
AS
/* ===================================================================================================================================
**  Main Process Procedures
** ==================================================================================================================================*/
   PROCEDURE validate_distribution_rec (
      p_dist_no         IN   giuw_pol_dist.dist_no%TYPE,
      p_module_id       IN   giis_modules.module_id%TYPE,
      p_action          IN   VARCHAR2,
      p_spec_dist_sw    IN   VARCHAR2,
      p_spec_tsi_prem   IN   VARCHAR2,
      p_user            IN   giis_users.user_id%TYPE
   )
   IS
      v_valid              BOOLEAN;
      v_valid2             BOOLEAN;
      v_dist_type          VARCHAR2 (1)    := NULL;
      ----- > P = Peril Dist ; O = One Risk
      v_dist_by_tsi_prem   VARCHAR2 (1)    := NULL;  ----- > Y = Yes ; N = No
      v_distmod_type       VARCHAR2 (1)    := NULL;
      ---- > I = Inner ; O = Outer
      v_findings_exists    VARCHAR2 (1)    := 'N';
      v_test               VARCHAR2 (4000);
      v_proc_name          VARCHAR2 (500);
      v_err_msge           VARCHAR2 (4000);
      v_script_id          NUMBER;
      v_inv_err_msge       VARCHAR2 (4000);
      v_err                BOOLEAN;
   BEGIN
      DBMS_OUTPUT.put_line
         ('Start of Distribution Data Validation ........................... '
         );
      -- validate parameters
      validate_parameters (p_dist_no,
                           p_module_id,
                           p_action,
                           p_spec_dist_sw,
                           p_spec_tsi_prem,
                           p_user,
                           v_err,
                           v_inv_err_msge
                          );

      IF v_err = TRUE
      THEN
         raise_application_error (-20020, v_inv_err_msge, TRUE);
      END IF;

      DELETE FROM genqa_dist_checking_result
            WHERE dist_no = p_dist_no
              AND module_id = p_module_id
              --   AND action = p_action
              AND user_id = p_user;

      -- identify parameters
      identify_disttype (p_module_id,
                         p_spec_dist_sw,
                         p_spec_tsi_prem,
                         v_dist_type,
                         v_distmod_type,
                         v_dist_by_tsi_prem
                        );

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line (   'Debugging parameters : p_action : '
                               || p_action
                               || ' :  ........................... '
                              );
         validate_save_dist (p_dist_no,
                             v_dist_by_tsi_prem,
                             p_action,
                             v_dist_type,
                             v_distmod_type,
                             p_module_id,
                             p_user
                            );
      ELSE
         DBMS_OUTPUT.put_line (   'Debugging parameters : p_action : '
                               || p_action
                               || ' :  ........................... '
                              );
         validate_post_dist (p_dist_no,
                             v_dist_by_tsi_prem,
                             p_action,
                             v_dist_type,
                             v_distmod_type,
                             p_module_id,
                             p_user
                            );
      END IF;

      FOR curfind IN (SELECT 1
                        FROM genqa_dist_checking_result a
                       WHERE a.dist_no = p_dist_no
                         AND a.module_id = p_module_id
                         AND a.user_id = p_user
                         AND a.RESULT = v_result_failed)
      LOOP
         v_findings_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_findings_exists = 'N'
      THEN
         DBMS_OUTPUT.put_line ('There are no discrepancies found.');
      ELSE
         DBMS_OUTPUT.put_line
            ('There are discrepancies found.Please check you checking script log.'
            );
      END IF;
   END validate_distribution_rec;

   PROCEDURE validate_parameters (
      p_dist_no         IN       giuw_pol_dist.dist_no%TYPE,
      p_module_id       IN       giis_modules.module_id%TYPE,
      p_action          IN       VARCHAR2,
      p_spec_dist_sw    IN       VARCHAR2,
      p_spec_tsi_prem   IN       VARCHAR2,
      p_user            IN       giis_users.user_id%TYPE,
      p_err             OUT      BOOLEAN,
      p_err_msge        OUT      VARCHAR2
   )
   IS
   BEGIN
      p_err := FALSE;
      p_err_msge := NULL;
      DBMS_OUTPUT.put_line
         ('Passing procedure validate_parameters [ Validating invalid parameter values ] ................'
         );

      IF NVL (p_action, 'X') NOT IN ('S', 'P') AND p_err = FALSE
      THEN
         p_err := TRUE;
         p_err_msge :=
              'Invalid Action. Choose either S for Saving or P for Posting. ';
      END IF;

      IF NVL (p_spec_dist_sw, 'X') NOT IN ('Y', 'N') AND p_err = FALSE
      THEN
         p_err := TRUE;
         p_err_msge :=
            'Invalid Special Distribution parameter. Either choose N = Special Distribution is not triggered. Y = Special Distribution is Triggered.';
      END IF;

      IF NVL (p_spec_tsi_prem, 'X') NOT IN ('Y', 'N') AND p_err = FALSE
      THEN
         p_err := TRUE;
         p_err_msge :=
               'Invalid Special Distribution By TSI/Prem parameter. '
            || ' Either choose Y = Distribution is created using Dist By TSI/Prem before Special Distribution is triggered.'
            || ' N = Distribution is not Created using Dist By TSI/Prem before Special Distribution is Triggered.';
      END IF;
   END validate_parameters;

   PROCEDURE identify_disttype (
      p_module_id          IN       giis_modules.module_id%TYPE,
      p_spec_dist_sw       IN       VARCHAR2,
      p_spec_tsi_prem      IN       VARCHAR2,
      p_dist_type          OUT      VARCHAR2,
      p_distmod_type       OUT      VARCHAR2,
      p_dist_by_tsi_prem   OUT      VARCHAR2
   )
   IS
   BEGIN
      DBMS_OUTPUT.put_line
         ('Passing procedure identify_disttype [ identifying distribution type ] ................'
         );

      IF p_module_id IN ('GIUWS003', 'GIUWS006')
      THEN
         p_distmod_type := 'I';
         p_dist_type := 'P';
      ELSIF p_module_id IN ('GIUWS004', 'GIUWS005')
      THEN
         p_distmod_type := 'I';
         p_dist_type := 'O';
      ELSIF p_module_id IN ('GIUWS012', 'GIUWS017')
      THEN
         p_distmod_type := 'O';
         p_dist_type := 'P';
      ELSIF p_module_id IN ('GIUWS013', 'GIUWS016')
      THEN
         p_distmod_type := 'O';
         p_dist_type := 'O';
      ELSE
         raise_application_error (-20020, 'Invalid Module IDs ', TRUE);
      END IF;

      IF     NVL (p_spec_dist_sw, 'X') = 'Y'
         AND p_module_id IN ('GIUWS004', 'GIUWS013')
      THEN
         p_dist_type := 'P';
      END IF;

      p_dist_by_tsi_prem := 'N';

      IF p_module_id IN ('GIUWS005', 'GIUWS006', 'GIUWS017', 'GIUWS016')
      THEN
         p_dist_by_tsi_prem := 'Y';
      END IF;

      IF     NVL (p_spec_tsi_prem, 'X') = 'Y'
         AND p_module_id IN ('GIUWS004', 'GIUWS013')
      THEN
         p_dist_by_tsi_prem := 'Y';
      END IF;
   END identify_disttype;

   PROCEDURE validate_save_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
   BEGIN
      DBMS_OUTPUT.put_line
         ('Passing procedure validate_save_dist  [ running saving validation program units  ] ................'
         );
      -- check if there is not null dist_spct1
      p_chk_ntnll_spct1_witemdsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_chk_ntnll_spct1_witmprldsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_ntnll_spct1_wperildsdtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_ntnll_spct1_wpoldsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
-- check for null dist_spct
      p_chk_null_spct1_witemdsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_chk_null_spct1_witmprldsdtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_null_spct1_wperildsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_chk_null_spct1_wpoldsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
-- computed peril from giuw_witemperilds_dtl
      p_val_compt_wperildtl (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_val_compt_wpoldtl (p_dist_no,
                           p_dist_by_tsi_prem_sw,
                           p_action,
                           p_dist_type,
                           p_distmod_type,
                           p_module_id,
                           p_user
                          );
      p_val_compt_wtemdtl (p_dist_no,
                           p_dist_by_tsi_prem_sw,
                           p_action,
                           p_dist_type,
                           p_distmod_type,
                           p_module_id,
                           p_user
                          );
--check round off of value
      p_val_dtl_rndoff9_witemdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_dtl_rndoff9_witmprldtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_dtl_rndoff9_wperildtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_val_dtl_rndoff9_wpoldtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
-- comparison of dist tables
      p_val_witemds_witemdsdtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_val_witemdsdtl_f_itemdsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_witmprlds_witmprldsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_witmpldsdtl_f_itmpldsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_val_witmprldtl_witemdsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_val_witmprldtl_wperildsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_wperilds_wperildsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_wperildsdtl_f_perildsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_val_wpolds_wpoldsdtl (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_val_wpoldsdtl_f_poldsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_wpoldsdtl_witemdsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_wpoldsdtl_witmprldsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_wpoldsdtl_wperildsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
-- check if there are non-zero premium with zero prem
      p_valcnt_nzroprem_witmprldtl02 (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_valcnt_nzrotsi_witmprldtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_valcnt_orsk_witmprldtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_valcnt_orsk_wpoldtl (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_valcnt_pdist_witmprldtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_valcnt_pdist_wperildtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_valcnt_sign_witmprldtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
-- check if there are shares wchich exists on other distribution tables
      p_valconst_shr_witemdtl (p_dist_no,
                               p_dist_by_tsi_prem_sw,
                               p_action,
                               p_dist_type,
                               p_distmod_type,
                               p_module_id,
                               p_user
                              );
      p_valconst_shr_witmprldtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_valconst_shr_wperildtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_vcomp_shr_witmdtl01 (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_vcomp_shr_witmdtl02 (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_vcomp_shr_wpoldtl01 (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_vcomp_shr_wpoldtl02 (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
-- check if there are dist tables which exists on other dist tables
      p_vcorsk_wpoldtl_witemdtl01 (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_vcorsk_wpoldtl_witemdtl02 (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_vcorsk_wpoldtl_witmprldtl01 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vcorsk_wpoldtl_witmprldtl02 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vcorsk_wpoldtl_wperildtl01 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_vcorsk_wpoldtl_wperildtl02 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
-- check if there are dist tables hich exists on other dist tables
      p_vpdist_wperildtl_witemdtl01 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vpdist_wperildtl_witemdtl02 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vpdist_wperildtl_witmpldtl01 (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_vpdist_wperildtl_witmpldtl02 (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_vpdist_wperildtl_wpoldtl01 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_vpdist_wperildtl_wpoldtl02 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
-- ==================================================================================
      p_chk_exists_f_itemds (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_chk_exists_f_itemds_dtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_chk_exists_f_itemperilds (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_chk_exists_f_itemperilds_dtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_exists_f_perilds (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_chk_exists_f_perilds_dtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_chk_exists_f_policyds (p_dist_no,
                               p_dist_by_tsi_prem_sw,
                               p_action,
                               p_dist_type,
                               p_distmod_type,
                               p_module_id,
                               p_user
                              );
      p_chk_exists_f_policyds_dtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_chk_exists_witemds (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_chk_exists_witemds_dtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_chk_exists_witemperilds (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_chk_exists_witemperilds_dtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_exists_wperilds (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_chk_exists_wperilds_dtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_chk_exists_wpolicyds (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_chk_exists_wpolicyds_dtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      -- validate existence of working binder records
      p_wrkngbndr_wfrps_ri (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_wrkngbndr_wfrperil (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_wrkngbndr_wbinderperil (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_wrkngbndr_wbinder (p_dist_no,
                           p_dist_by_tsi_prem_sw,
                           p_action,
                           p_dist_type,
                           p_distmod_type,
                           p_module_id,
                           p_user
                          );
      p_wrkngbndr_wfrps_peril_grp (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      -- validate giuw_pol_dist
      p_val_pol_dist (p_dist_no,
                      p_dist_by_tsi_prem_sw,
                      p_action,
                      p_dist_type,
                      p_distmod_type,
                      p_module_id,
                      p_user
                     );
   END validate_save_dist;

   PROCEDURE validate_post_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
   BEGIN
      DBMS_OUTPUT.put_line
         ('Passing procedure validate_post_dist [ running posting validation program unit ]  ................'
         );
      -- check if there are records with zero dist_spct / dist_spct1
      p_chk_btsp_zerospct_f_itemdtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_btsp_zerospct_f_itmpldtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_btsp_zerospct_f_perildtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_btsp_zerospct_f_poldtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      -- check if there are records with not null dist_spct1
      p_chk_ntnll_spct1_f_itemdsdtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_ntnll_spct1_f_itmpldsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_ntnll_spct1_f_perildsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_ntnll_spct1_f_poldsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      -- check if there are records with null dist_spct1
      p_chk_null_spct1_f_itemdsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_chk_null_spct1_f_itmprldsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_null_spct1_f_perildsdtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_null_spct1_f_poldsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
-- validate if TSI/Prem stored in backend equals data queried from giuw_witemperilds_dtl
      p_val_compt_f_itemdtl (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_val_compt_f_perildtl (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_val_compt_f_poldtl (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
-- validate if share% in dist tables are rounded to 9 decimal places
      p_val_dtl_rndoff9_f_itemdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_val_dtl_rndoff9_f_itmprldtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_val_dtl_rndoff9_f_perildtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_dtl_rndoff9_f_poldtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
-- compare distribution tables
      p_val_f_itemds_itemdsdtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_val_f_itmprlds_itmprldsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_f_itmprldtl_itemdsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_val_f_itmprldtl_perildsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_f_perilds_perildsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_f_perildsdtl_wdstfrps (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_val_f_polds_poldsdtl (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_val_f_poldsdtl_wdistfrps (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_f_poldsdtl_itemdsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_val_f_poldsdtl_itmprldsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_f_poldsdtl_perildsdtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
-- validate if there are non-zero amounts in dist tables but dist_spct = 0
      p_valcnt_nzroprem_f_itmpldtl01 (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_valcnt_nzrotsi_f_itmprldtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
-- validate the data stored in the dist tables
      p_valcnt_orsk_f_itmprldtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_valcnt_orsk_f_poldtl (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_valcnt_pdist_f_itmprldtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_valcnt_pdist_f_perildtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
-- validate sign of itmperil
      p_valcnt_sign_f_itmprldtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
-- validate consistency of shares
      p_valconst_shr_f_itemdtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_valconst_shr_f_itmprldtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_valconst_shr_f_perildtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
-- validate if computed share % matches data stored
      p_vcomp_shr_f_itmdtl01 (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_vcomp_shr_f_itmdtl02 (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_vcomp_shr_f_poldtl01 (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_vcomp_shr_f_poldtl02 (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
-- validate existence of shares in each group
      p_vcorsk_poldtl_f_itemdtl01 (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_vcorsk_poldtl_f_itemdtl02 (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_vcorsk_poldtl_f_itmprldtl01 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vcorsk_poldtl_f_itmprldtl02 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vcorsk_poldtl_f_perildtl01 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_vcorsk_poldtl_f_perildtl02 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_vpdist_perildtl_f_itemdtl01 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vpdist_perildtl_f_itemdtl02 (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_vpdist_perildtl_f_itmpldtl01 (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_vpdist_perildtl_f_itmpldtl02 (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_vpdist_perildtl_f_poldtl01 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_vpdist_perildtl_f_poldtl02 (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      -- compare working and final distribution tables
      p_val_witemdsdtl_f_itemdsdtl (p_dist_no,
                                    p_dist_by_tsi_prem_sw,
                                    p_action,
                                    p_dist_type,
                                    p_distmod_type,
                                    p_module_id,
                                    p_user
                                   );
      p_val_witmpldsdtl_f_itmpldsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_val_wperildsdtl_f_perildsdtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_val_wpoldsdtl_f_poldsdtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
-- ==================================================================================
      p_chk_exists_f_itemds (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_chk_exists_f_itemds_dtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_chk_exists_f_itemperilds (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_chk_exists_f_itemperilds_dtl (p_dist_no,
                                      p_dist_by_tsi_prem_sw,
                                      p_action,
                                      p_dist_type,
                                      p_distmod_type,
                                      p_module_id,
                                      p_user
                                     );
      p_chk_exists_f_perilds (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_chk_exists_f_perilds_dtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      p_chk_exists_f_policyds (p_dist_no,
                               p_dist_by_tsi_prem_sw,
                               p_action,
                               p_dist_type,
                               p_distmod_type,
                               p_module_id,
                               p_user
                              );
      p_chk_exists_f_policyds_dtl (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      p_chk_exists_wfrps01 (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_chk_exists_wfrps02 (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_chk_exists_witemds (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_chk_exists_witemds_dtl (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_chk_exists_witemperilds (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_chk_exists_witemperilds_dtl (p_dist_no,
                                     p_dist_by_tsi_prem_sw,
                                     p_action,
                                     p_dist_type,
                                     p_distmod_type,
                                     p_module_id,
                                     p_user
                                    );
      p_chk_exists_wperilds (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user
                            );
      p_chk_exists_wperilds_dtl (p_dist_no,
                                 p_dist_by_tsi_prem_sw,
                                 p_action,
                                 p_dist_type,
                                 p_distmod_type,
                                 p_module_id,
                                 p_user
                                );
      p_chk_exists_wpolicyds (p_dist_no,
                              p_dist_by_tsi_prem_sw,
                              p_action,
                              p_dist_type,
                              p_distmod_type,
                              p_module_id,
                              p_user
                             );
      p_chk_exists_wpolicyds_dtl (p_dist_no,
                                  p_dist_by_tsi_prem_sw,
                                  p_action,
                                  p_dist_type,
                                  p_distmod_type,
                                  p_module_id,
                                  p_user
                                 );
      -- validate existence of working binder records
      p_wrkngbndr_wfrps_ri (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_wrkngbndr_wfrperil (p_dist_no,
                            p_dist_by_tsi_prem_sw,
                            p_action,
                            p_dist_type,
                            p_distmod_type,
                            p_module_id,
                            p_user
                           );
      p_wrkngbndr_wbinderperil (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user
                               );
      p_wrkngbndr_wbinder (p_dist_no,
                           p_dist_by_tsi_prem_sw,
                           p_action,
                           p_dist_type,
                           p_distmod_type,
                           p_module_id,
                           p_user
                          );
      p_wrkngbndr_wfrps_peril_grp (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user
                                  );
      -- validate giuw_pol_dist
      p_val_pol_dist (p_dist_no,
                      p_dist_by_tsi_prem_sw,
                      p_action,
                      p_dist_type,
                      p_distmod_type,
                      p_module_id,
                      p_user
                     );
   END validate_post_dist;

   PROCEDURE p_log_result (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2,
      p_findings              IN   VARCHAR2,
      p_query_fnc             IN   VARCHAR2,
      p_program_unit          IN   VARCHAR2,
      p_result                IN   VARCHAR2
   )
   IS
      /* Purpose : Log and display results
       */
      log_findings   genqa_dist_checking_result.findings%TYPE;
   BEGIN
      IF p_result = v_result_failed
      THEN
         log_findings := p_findings;
         DBMS_OUTPUT.put_line
                           (   '*********** Result: FAILED : Program Unit : '
                            || UPPER (p_program_unit)
                            || ' : Findings :  '
                            || p_findings
                           );
      ELSE
         log_findings :=
             'No error found during execution of  ' || p_program_unit || ' .';
         DBMS_OUTPUT.put_line
                          (   '=========== Result: PASSED : Program Unit :  '
                           || UPPER (p_program_unit)
                          );
      END IF;

      INSERT INTO genqa_dist_checking_result
                  (dist_no, module_id, action, findings, user_id,
                   last_update, query_fnc, val_proc,
                   dist_by_tsi_prem_sw, dist_type, distmod_type,
                   RESULT
                  )
           VALUES (p_dist_no, p_module_id, p_action, log_findings, p_user,
                   SYSDATE, p_query_fnc, p_program_unit,
                   p_dist_by_tsi_prem_sw, p_dist_type, p_distmod_type,
                   p_result
                  );
   END p_log_result;

/* ===================================================================================================================================
**  Dist Validation  - Zero Share Percentage - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_btsp_zerospct_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records with zero DIST_SPCT and DIST_SPCT1 ( Dist By TSI/Prem)  in GIUW_ITEMDS_DTL
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_chk_btsp_zerospct_f_itemdtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_chk_btsp_zerospct_f_itemdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'There are records with zero share % in  GIUW_ITEMDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_btsp_zerospct_f_itemdtl  [ checking existence of shares with zero share % in GIUW_ITEMDS_DTL................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_itemds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_itemds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_spct = 0
                            AND dist_spct1 = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_btsp_zerospct_f_itemdtl;

   PROCEDURE p_chk_btsp_zerospct_f_itmpldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records with zero DIST_SPCT and DIST_SPCT1 ( Dist By TSI/Prem)  in GIUW_ITEMPERILDS_DTL
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_btsp_zerospct_f_itmpldtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_btsp_zerospct_f_itmpldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      DBMS_OUTPUT.put_line
         ('Passing procedure p_chk_btsp_zerospct_f_itmpldtl  [ checking existence of shares with zero share % in GIUW_ITEMPERILDS_DTL ................'
         );
      v_findings :=
                'There are records with zero share % in  GIUW_ITEMPERILDS_DTL';

      IF p_action = 'P'
      THEN
         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_spct = 0
                            AND dist_spct1 = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_btsp_zerospct_f_itmpldtl;

   PROCEDURE p_chk_btsp_zerospct_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records with zero DIST_SPCT and DIST_SPCT1 ( Dist By TSI/Prem)  in GIUW_PERILDS_DTL
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_btsp_zerospct_f_perildtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_btsp_zerospct_f_perildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
                   'There are records with zero share % in  GIUW_PERILDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_btsp_zerospct_f_perildtl  [ checking existence of shares with zero share % in GIUW_PERILDS_DTL................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_perilds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_perilds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_spct = 0
                            AND dist_spct1 = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_btsp_zerospct_f_perildtl;

   PROCEDURE p_chk_btsp_zerospct_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records with zero DIST_SPCT and DIST_SPCT1 ( Dist By TSI/Prem)  in GIUW_POLICYDS_DTL
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_chk_btsp_zerospct_f_poldtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_chk_btsp_zerospct_f_poldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
                  'There are records with zero share % in  GIUW_POLICYDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_btsp_zerospct_f_poldtl  [ checking existence of shares with zero share % in GIUW_POLICYDS_DTL ................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_policyds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_policyds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_spct = 0
                            AND dist_spct1 = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_btsp_zerospct_f_poldtl;

/* ===================================================================================================================================
**  Dist Validation - Check Existence of Records in Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_exists_witemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WITEMDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)        := UPPER ('f_chk_exists_witemds');
      v_calling_proc   VARCHAR2 (30)        := UPPER ('p_chk_exists_witemds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WITEMDS.';
      v_findings2 := 'There are no records in GIUW_WITEMDS.';

      FOR cur IN (SELECT 1
                    FROM giuw_witemds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_exists_witemds [ checking the existence of records in GIUW_WITEMDS ]  ................'
            );

         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_exists_witemds [ checking the existence of records in GIUW_WITEMDS ]  ................'
            );

         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_witemds;

   PROCEDURE p_chk_exists_witemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WITEMDS_DTL
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_chk_exists_witemds_dtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_chk_exists_witemds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WITEMDS_DTL.';
      v_findings2 := 'There are no records in GIUW_WITEMDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_witemds_dtl [ checking the existence of records in GIUW_WITEMDS_DTL ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_witemds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_witemds_dtl;

   PROCEDURE p_chk_exists_witemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WITEMPERILDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_chk_exists_witemperilds');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_chk_exists_witemperilds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WITEMPERILDS.';
      v_findings2 := 'There are no records in GIUW_WITEMPERILDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_witemperilds [checking the existence of records in GIUW_WITEMPERILDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_witemperilds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_witemperilds;

   PROCEDURE p_chk_exists_witemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WITEMPERILDS_DTL
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_chk_exists_witemperilds_dtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_chk_exists_witemperilds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WITEMPERILDS_DTL.';
      v_findings2 := 'There are no records in GIUW_WITEMPERILDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_witemperilds_dtl  [ checking the existence of records in GIUW_WITEMPERILDS_DTL ] ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_witemperilds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_witemperilds_dtl;

   PROCEDURE p_chk_exists_wperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WITEMDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_chk_exists_wperilds');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_chk_exists_wperilds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WPERILDS.';
      v_findings2 := 'There are no records in GIUW_WPERILDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_wperilds [checking the existence of records in GIUW_WPERILDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_wperilds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         /*  IF v_exists_rec = 'Y' AND v_dist_flag <> '2'
           THEN
              v_output := v_result_failed;
           END IF;  -- REPLACED CONDITION */
         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_wperilds;

   PROCEDURE p_chk_exists_wperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WITEMDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_chk_exists_wperilds_dtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_chk_exists_wperilds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WPERILDS_DTL.';
      v_findings2 := 'There are no records in GIUW_WPERILDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_wperilds_dtl [ checking the existence of records in GIUW_WPERILDS_DTL ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_wperilds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         /*IF v_exists_rec = 'Y' AND v_dist_flag <> '2'
         THEN
            v_output := v_result_failed;
         END IF;  -- 07.03.2014 jhing replaced condition */
         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_wperilds_dtl;

   PROCEDURE p_chk_exists_wpolicyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WPOLICYDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_chk_exists_wpolicyds');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_chk_exists_wpolicyds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WPOLICYDS.';
      v_findings2 := 'There are no records in GIUW_WPOLICYDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_wpolicyds [ checking the existence of records in GIUW_WPOLICYDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_wpolicyds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         /*  IF v_exists_rec = 'Y' AND v_dist_flag <> '2'
           THEN
              v_output := v_result_failed;
           END IF;  -- jhing 07.03.2014 replaced condition */
         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_wpolicyds;

   PROCEDURE p_chk_exists_wpolicyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_WPOLICYDS_DTL
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_chk_exists_wpolicyds_dtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_chk_exists_wpolicyds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_WPOLICYDS_DTL.';
      v_findings2 := 'There are no records in GIUW_WPOLICYDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_wpolicyds_dtl [ checking the existence of records in GIUW_WPOLICYDS_DTL ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_wpolicyds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         /*  IF v_exists_rec = 'Y' AND v_dist_flag <> '2'
           THEN
              v_output := v_result_failed;
           END IF;   -- jhing 07.03.2014 replaced condition */
         IF v_dist_flag = '3' AND v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_wpolicyds_dtl;

/* ===================================================================================================================================
**  Dist Validation - Check Existence of Records in Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_exists_f_itemds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_ITEMDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_chk_exists_f_itemds');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_chk_exists_f_itemds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_ITEMDS.';
      v_findings2 := 'There are no records in GIUW_ITEMDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_itemds [ checking the existence of records in GIUW_ITEMDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_itemds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_itemds;

   PROCEDURE p_chk_exists_f_itemds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_ITEMDS_DTL
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_chk_exists_f_itemds_dtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_chk_exists_f_itemds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_ITEMDS_DTL.';
      v_findings2 := 'There are no records in GIUW_ITEMDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_itemds_dtl [ checking the existence of records in GIUW_ITEMDS_DTL ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_itemds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_itemds_dtl;

   PROCEDURE p_chk_exists_f_itemperilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_ITEMPERILDS
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_chk_exists_f_itemperilds');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_chk_exists_f_itemperilds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_ITEMPERILDS.';
      v_findings2 := 'There are no records in GIUW_ITEMPERILDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_itemperilds [ checking the existence of records in GIUW_ITEMPERILDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_itemperilds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_itemperilds;

   PROCEDURE p_chk_exists_f_itemperilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_ITEMPERILDS_DTL
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_exists_f_itemperilds_dtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_exists_f_itemperilds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_ITEMPERILDS_DTL.';
      v_findings2 := 'There are no records in GIUW_ITEMPERILDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_itemperilds_dtl [ checking the existence of records in GIUW_ITEMPERILDS_DTL]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_itemperilds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_itemperilds_dtl;

   PROCEDURE p_chk_exists_f_perilds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_PERILDS
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_chk_exists_f_perilds');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_chk_exists_f_perilds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_PERILDS.';
      v_findings2 := 'There are no records in GIUW_PERILDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_perilds [ checking the existence of records in GIUW_PERILDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_perilds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_perilds;

   PROCEDURE p_chk_exists_f_perilds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_PERILDS_DTL
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_chk_exists_f_perilds_dtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_chk_exists_f_perilds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_PERILDS_DTL.';
      v_findings2 := 'There are no records in GIUW_PERILDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_perilds_dtl [ checking the existence of records in GIUW_PERILDS_DTL ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_perilds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_perilds_dtl;

   PROCEDURE p_chk_exists_f_policyds (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_POLICYDS
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)     := UPPER ('f_chk_exists_f_policyds');
      v_calling_proc   VARCHAR2 (30)     := UPPER ('p_chk_exists_f_policyds');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_POLICYDS.';
      v_findings2 := 'There are no records in GIUW_POLICYDS.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_policyds [ checking the existence of records in GIUW_POLICYDS ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_policyds
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_policyds;

   PROCEDURE p_chk_exists_f_policyds_dtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if record exists in GIUW_ITEMDS
            Modules affected : All distribution modules.
         */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_chk_exists_f_policyds_dtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_chk_exists_f_policyds_dtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Records exists in GIUW_POLICYDS_DTL.';
      v_findings2 := 'There are no records in GIUW_POLICYDS_DTL.';
      DBMS_OUTPUT.put_line
         ('Executing procedure p_chk_exists_f_policyds_dtl [ checking the existence of records in GIUW_POLICYDS_DTL ]  ................'
         );

      FOR cur IN (SELECT 1
                    FROM giuw_policyds_dtl
                   WHERE dist_no = p_dist_no)
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF p_action = 'S'
      THEN
         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         IF v_exists_rec = 'N'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings2,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_f_policyds_dtl;

   PROCEDURE p_chk_exists_wfrps01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : check if there exists records in giri_wdistfprs with no corresponding record in giuw_policyds_dtl
            Modules affected : All distribution modules.
         */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)        := UPPER ('f_chk_exists_wfrps01');
      v_calling_proc   VARCHAR2 (30)        := UPPER ('p_chk_exists_wfrps01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'Records exists in GIRI_WDISTFRPS with no corresponding record in GIUW_POLICYDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_exists_wfrps01 [ checking the existence of records in GIRI_WDISTFRPS with no corresponding GIUW_POLICYDS_DTL ]  ................'
            );

         FOR chk IN (SELECT *
                       FROM giri_wdistfrps x
                      WHERE NOT EXISTS (
                               SELECT 1
                                 FROM giuw_policyds_dtl y
                                WHERE y.dist_no = x.dist_no
                                  AND y.dist_seq_no = x.dist_seq_no
                                  AND y.share_cd = 999)
                        AND x.dist_no = p_dist_no)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_wfrps01;

   PROCEDURE p_chk_exists_wfrps02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : check if there exists records in giri_wdistfprs with no corresponding record in giuw_policyds_dtl
            Modules affected : All distribution modules.
         */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)        := UPPER ('f_chk_exists_wfrps02');
      v_calling_proc   VARCHAR2 (30)        := UPPER ('p_chk_exists_wfrps02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'Records exists in GIUW_POLICYDS_DTL (Facul Share) with no corresponding record in GIRI_WDISTFRPS.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_exists_wfrps02 [ checking the existence of records in GIUW_POLICYDS_DTL (Facul) with no corresponding GIRI_WDISTFRPS  ]  ................'
            );

         FOR chk IN (SELECT *
                       FROM giuw_policyds_dtl x
                      WHERE NOT EXISTS (
                               SELECT 1
                                 FROM giri_wdistfrps y
                                WHERE y.dist_no = x.dist_no
                                  AND y.dist_seq_no = x.dist_seq_no)
                        AND x.dist_no = p_dist_no
                        AND x.share_cd = 999)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_exists_wfrps02;

/* ===================================================================================================================================
**  Dist Validation - Checking of the existence of Not Null and Null DIST_SPCT1 in Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_ntnll_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   /* Purpose : Check if there are records in GIUW_WITEMDS_DTL with NOT NULL DIST_SPCT1
      Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
      Exception: Special Distribution in GIUWS004, GIUWS013
   */
   IS
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_chk_ntnll_spct1_witemdsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_chk_ntnll_spct1_witemdsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
                'Record exists with not null DIST_SPCT1 in GIUW_WITEMDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_witemdsdtl [ checking the existence of NOT NULL DIST_SPCT1 in GIUW_WITEMDS_DTL ]  ................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_witemds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_ntnll_spct1_witemdsdtl;

   PROCEDURE p_chk_ntnll_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WITEMPERILDS_DTL with NOT NULL DIST_SPCT1
         Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
         Exception: Special Distribution in GIUWS004, GIUWS013
      */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_ntnll_spct1_witmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_ntnll_spct1_witmprldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
           'Record exists with not null DIST_SPCT1 in GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_witmprldsdtl  [ checking the existence of NOT NULL DIST_SPCT1 in GIUW_WITEMPERILDS_DTL ]  ................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_witemperilds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_ntnll_spct1_witmprldsdtl;

   PROCEDURE p_chk_ntnll_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPERILDS_DTL with NOT NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
           Exception: Special Distribution in GIUWS004, GIUWS013
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_chk_ntnll_spct1_wperildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_chk_ntnll_spct1_wperildsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
               'Record exists with not null DIST_SPCT1 in GIUW_WPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_wperildsdtl [ checking NOT NULL DIST_SPCT1 in GIUW_WPERILDS_DTL ]  ................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_wperilds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_ntnll_spct1_wperildsdtl;

   PROCEDURE p_chk_ntnll_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPOLICYDS_DTL with NOT NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
           Exception: Special Distribution in GIUWS004, GIUWS013
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_chk_ntnll_spct1_wpoldsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_chk_ntnll_spct1_wpoldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
              'Record exists with not null DIST_SPCT1 in GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_wpoldsdtl [ checking existence of NOT NULL DIST_SPCT1 in GIUW_WPOLICYDS_DTL ] ...........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_wpolicyds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_ntnll_spct1_wpoldsdtl;

   PROCEDURE p_chk_null_spct1_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : CCheck if there are records in GIUW_WITEMDS_DTL with NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NOT NULL : GIUWS005 , GIUWS006 , GIUWS016 , GIUWS017
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_chk_null_spct1_witemdsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_chk_null_spct1_witemdsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Record exists with null DIST_SPCT1 in GIUW_WITEMDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_witemdsdtl [ checking the existence of NULL DIST_SPCT1 in GIUW_WITEMDS_DTL ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_witemds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_witemdsdtl;

   PROCEDURE p_chk_null_spct1_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : CCheck if there are records in GIUW_WITEMPERILDS_DTL with NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NOT NULL : GIUWS005 , GIUWS006 , GIUWS016 , GIUWS017
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_chk_null_spct1_witmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_chk_null_spct1_witmprldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
               'Record exists with null DIST_SPCT1 in GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_witmprldsdtl  [ checking the existence of NULL DIST_SPCT1 in GIUW_WITEMPERILDS_DTL ]......'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_witemperilds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_witmprldsdtl;

   PROCEDURE p_chk_null_spct1_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : CCheck if there are records in GIUW_WPERILS_DTL with NULL DIST_SPCT1
          Modules whose DIST_SPCT1 should always be NOT NULL : GIUWS005 , GIUWS006 , GIUWS016 , GIUWS017
       */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_chk_null_spct1_wperildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_chk_null_spct1_wperildsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
                  'Record exists with  null DIST_SPCT1 in GIUW_WPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_wperildsdtl [ checking the existence of NULL DIST_SPCT1 in GIUW_WPERILDS_DTL ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_wperilds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_wperildsdtl;

   PROCEDURE p_chk_null_spct1_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPOLICYDS_DTL with NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NOT NULL : GIUWS005 , GIUWS006 , GIUWS016 , GIUWS017
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_chk_null_spct1_wpoldsdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_chk_null_spct1_wpoldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
              'Record exists with not null DIST_SPCT1 in GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_wpolicydsdtl [ checking the existence of NULL DIST_SPCT1 in GIUW_WPOLICYDS_DTL ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_wpolicyds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_wpoldsdtl;

/* ===================================================================================================================================
**  Dist Validation - Checking of the existence of Not Null and Null DIST_SPCT1 in Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_chk_ntnll_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_ITEMDS_DTL with NOT NULL DIST_SPCT1
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_chk_ntnll_spct1_f_itemdsdtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_chk_ntnll_spct1_f_itemdsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
              'There are records with NOT NULL DIST_SPCT1 in GIUW_ITEMDS_DTL';

      IF p_action = 'P' AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_f_itemdsdtl  [ checking the existence of NOT NULL DIST_SPCT1 in GIUW_ITEMDS_DTL ]  ................'
            );

         FOR dist IN (SELECT 1
                        FROM giuw_itemds_dtl
                       WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_ntnll_spct1_f_itemdsdtl;

   PROCEDURE p_chk_ntnll_spct1_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_ITEMPERILDS_DTL with NOT NULL DIST_SPCT1
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_ntnll_spct1_f_itmpldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_ntnll_spct1_f_itmpldsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with NOT NULL DIST_SPCT1 in GIUW_ITEMPERILDS_DTL';

      IF p_action = 'P' AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_f_itmpldsdtl  [ checking the existence of NOT NULL DIST_SPCT1 in GIUW_ITEMPERILDS_DTL ]  ................'
            );

         FOR dist IN (SELECT 1
                        FROM giuw_itemperilds_dtl
                       WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_ntnll_spct1_f_itmpldsdtl;

   PROCEDURE p_chk_ntnll_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_PERILDS_DTL with NOT NULL DIST_SPCT1
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_ntnll_spct1_f_perildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_ntnll_spct1_f_perildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
             'There are records with NOT NULL DIST_SPCT1 in GIUW_PERILDS_DTL';

      IF p_action = 'P' AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_f_perildsdtl  [ checking the existence of NOT NULL DIST_SPCT1 in GIUW_PERILDS_DTL ]  ................'
            );

         FOR dist IN (SELECT 1
                        FROM giuw_perilds_dtl
                       WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_ntnll_spct1_f_perildsdtl;

   PROCEDURE p_chk_ntnll_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_POLICYDS_DTL with NOT NULL DIST_SPCT1
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_chk_ntnll_spct1_f_poldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_chk_ntnll_spct1_f_poldsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
            'There are records with NOT NULL DIST_SPCT1 in GIUW_POLICYDS_DTL';

      IF p_action = 'P' AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_ntnll_spct1_f_poldsdtl  [ checking the existence of NOT NULL DIST_SPCT1 in GIUW_POLICYDS_DTL ]  ................'
            );

         FOR dist IN (SELECT 1
                        FROM giuw_policyds_dtl
                       WHERE dist_no = p_dist_no AND dist_spct1 IS NOT NULL)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_chk_ntnll_spct1_f_poldsdtl;

   PROCEDURE p_chk_null_spct1_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPOLICYDS_DTL with NOT NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
           Exception: Special Distribution in GIUWS004, GIUWS013
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_chk_null_spct1_f_itemdsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_chk_null_spct1_f_itemdsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Record exists with NULL DIST_SPCT1 in GIUW_ITEMDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_f_itemdsdtl [ checking existence of  NULL DIST_SPCT1 in GIUW_ITEMDS_DTL ] ...........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_itemds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_f_itemdsdtl;

   PROCEDURE p_chk_null_spct1_f_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPOLICYDS_DTL with NOT NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
           Exception: Special Distribution in GIUWS004, GIUWS013
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_chk_null_spct1_f_itmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_chk_null_spct1_f_itmprldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
                'Record exists with NULL DIST_SPCT1 in GIUW_ITEMPERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_f_itmprldsdtl [ checking existence of  NULL DIST_SPCT1 in GIUW_ITEMPERILDS_DTL ] ...........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_itemperilds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_f_itmprldsdtl;

   PROCEDURE p_chk_null_spct1_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPOLICYDS_DTL with NOT NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
           Exception: Special Distribution in GIUWS004, GIUWS013
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_chk_null_spct1_f_perildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_chk_null_spct1_f_perildsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings := 'Record exists with NULL DIST_SPCT1 in GIUW_PERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_f_perildsdtl [ checking existence of  NULL DIST_SPCT1 in GIUW_PERILDS_DTL ] ...........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_perilds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_f_perildsdtl;

   PROCEDURE p_chk_null_spct1_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there are records in GIUW_WPOLICYDS_DTL with NOT NULL DIST_SPCT1
           Modules whose DIST_SPCT1 should always be NULL : GIUWS003 , GIUWS004 , GIUWS012 , GIUWS013
           Exception: Special Distribution in GIUWS004, GIUWS013
        */
      v_exists         VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_chk_null_spct1_f_poldsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_chk_null_spct1_f_poldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
                   'Record exists with NULL DIST_SPCT1 in GIUW_POLICYDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_chk_null_spct1_f_poldsdtl [ checking existence of  NULL DIST_SPCT1 in GIUW_POLICYDS_DTL ] ...........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
         THEN
            FOR cur IN (SELECT 1
                          FROM giuw_policyds_dtl
                         WHERE dist_no = p_dist_no AND dist_spct1 IS NULL)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;

            IF v_exists = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_chk_null_spct1_f_poldsdtl;

/* ===================================================================================================================================
**  Dist Validation - Comparing TSI/Premium from ITMPERIL - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_compt_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the computed TSI and premium of GIUW_PERILDS_DTL based from GIUW_WITEMPERILDS_DTL matches data stored in GIUW_ITEMPERILDS_DTL
        */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_val_compt_wperildtl');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_val_compt_wperildtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy of TSI and PREMIUM between GIUW_WITEMPERILDS_DTL and GIUW_WPERILDS_DTL. ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_compt_wperildtl [ checking discrepancy of TSI and premium between GIUW_WITEMPERILDS_DTL and GIUW_WPERILDS_DTL  ]..........'
            );

         FOR dist IN (SELECT x.dist_no, x.dist_seq_no, x.peril_cd, x.share_cd,
                             w.trty_name, x.computed_tsi itmperil_dist_tsi,
                             x.computed_prem itmperil_dist_prem,
                             y.dist_tsi item_dist_tsi,
                             y.dist_prem item_dist_prem,
                               NVL (x.computed_tsi, 0)
                             - NVL (y.dist_tsi, 0) diff_tsi,
                               NVL (x.computed_prem, 0)
                             - NVL (y.dist_prem, 0) diff_prem
                        FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                       a.peril_cd, a.share_cd,
                                       SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                       SUM (NVL (a.dist_prem, 0)
                                           ) computed_prem
                                  FROM giuw_witemperilds_dtl a, giis_peril b
                                 WHERE a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND a.dist_no = p_dist_no
                              GROUP BY a.line_cd,
                                       a.dist_no,
                                       a.dist_seq_no,
                                       a.peril_cd,
                                       a.share_cd) x,
                             giuw_wperilds_dtl y,
                             giis_dist_share w
                       WHERE 1 = 1
                         AND x.dist_no = p_dist_no
                         AND x.line_cd = w.line_cd
                         AND x.share_cd = w.share_cd
                         AND x.dist_no = y.dist_no(+)
                         AND x.dist_seq_no = y.dist_seq_no(+)
                         AND x.peril_cd = y.peril_cd(+)
                         AND x.share_cd = y.share_cd(+)
                         AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                              OR   NVL (x.computed_prem, 0)
                                 - NVL (y.dist_prem, 0) <> 0
                             )
                      UNION
                      SELECT y.dist_no, y.dist_seq_no, y.peril_cd, y.share_cd,
                             w.trty_name, x.computed_tsi itmperil_dist_tsi,
                             x.computed_prem itmperil_dist_prem,
                             y.dist_tsi item_dist_tsi,
                             y.dist_prem item_dist_prem,
                               NVL (x.computed_tsi, 0)
                             - NVL (y.dist_tsi, 0) diff_tsi,
                               NVL (x.computed_prem, 0)
                             - NVL (y.dist_prem, 0) diff_prem
                        FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                       a.peril_cd, a.share_cd,
                                       SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                       SUM (NVL (a.dist_prem, 0)
                                           ) computed_prem
                                  FROM giuw_witemperilds_dtl a, giis_peril b
                                 WHERE a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND a.dist_no = p_dist_no
                              GROUP BY a.line_cd,
                                       a.dist_no,
                                       a.dist_seq_no,
                                       a.peril_cd,
                                       a.share_cd) x,
                             giuw_wperilds_dtl y,
                             giis_dist_share w
                       WHERE 1 = 1
                         AND y.dist_no = p_dist_no
                         AND y.line_cd = w.line_cd
                         AND y.share_cd = w.share_cd
                         AND y.dist_no = x.dist_no(+)
                         AND y.dist_seq_no = x.dist_seq_no(+)
                         AND y.peril_cd = x.peril_cd(+)
                         AND y.share_cd = x.share_cd(+)
                         AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                              OR   NVL (x.computed_prem, 0)
                                 - NVL (y.dist_prem, 0) <> 0
                             ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_compt_wperildtl;

   PROCEDURE p_val_compt_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the computed TSI and premium of GIUW_POLICYDS_DTL based from GIUW_WITEMPERILDS_DTL matches data stored in GIUW_ITEMPERILDS_DTL
       */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)         := UPPER ('f_val_compt_wpoldtl');
      v_calling_proc   VARCHAR2 (30)         := UPPER ('p_val_compt_wpoldtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy of TSI and PREMIUM between GIUW_WITEMPERILDS_DTL and GIUW_WPOLICYDS_DTL. ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_compt_wpoldtl [ checking discrepancy of TSI and premium between GIUW_WITEMPERILDS_DTL and GIUW_WPOLICYDS_DTL  ]..........'
            );

         FOR dist IN
            (SELECT b.dist_no, b.dist_seq_no, b.share_cd, c.trty_name,
                    a.dist_tsi pol_dist_tsi, a.dist_prem pol_dist_prem,
                    b.dist_tsi itmperl_dist_tsi,
                    b.dist_prem itmperl_dist_prem,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_wpolicyds_dtl a,
                    (SELECT   x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd,
                              SUM (DECODE (y.peril_type,
                                           'B', NVL (x.dist_tsi, 0),
                                           0
                                          )
                                  ) dist_tsi,
                              SUM (NVL (x.dist_prem, 0)) dist_prem
                         FROM giuw_witemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                          AND x.peril_cd = y.peril_cd
                          AND x.dist_no = p_dist_no
                     GROUP BY x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd) b,
                    giis_dist_share c
              WHERE b.dist_no = p_dist_no
                AND b.dist_no = a.dist_no(+)
                AND b.dist_seq_no = a.dist_seq_no(+)
                AND b.share_cd = a.share_cd(+)
                AND b.line_cd = c.line_cd(+)
                AND b.share_cd = c.share_cd(+)
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                    )
             UNION
             SELECT a.dist_no, a.dist_seq_no, a.share_cd, c.trty_name,
                    a.dist_tsi pol_dist_tsi, a.dist_prem pol_dist_prem,
                    b.dist_tsi itmperl_dist_tsi,
                    b.dist_prem itmperl_dist_prem,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_wpolicyds_dtl a,
                    (SELECT   x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd,
                              SUM (DECODE (y.peril_type,
                                           'B', NVL (x.dist_tsi, 0),
                                           0
                                          )
                                  ) dist_tsi,
                              SUM (NVL (x.dist_prem, 0)) dist_prem
                         FROM giuw_witemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                          AND x.peril_cd = y.peril_cd
                          AND x.dist_no = p_dist_no
                     GROUP BY x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd) b,
                    giis_dist_share c
              WHERE a.dist_no = p_dist_no
                AND a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.share_cd = b.share_cd(+)
                AND a.line_cd = c.line_cd(+)
                AND a.share_cd = c.share_cd(+)
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_compt_wpoldtl;

   PROCEDURE p_val_compt_wtemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the computed TSI and premium of GIUW_ITEMDS_DTL based from GIUW_WITEMPERILDS_DTL matches data stored in GIUW_ITEMPERILDS_DTL

      */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)         := UPPER ('f_val_compt_wtemdtl');
      v_calling_proc   VARCHAR2 (30)         := UPPER ('p_val_compt_wtemdtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy of TSI and PREMIUM between GIUW_WITEMPERILDS_DTL and GIUW_WITEMDS_DTL. ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_compt_wtemdtl [ checking discrepancy of TSI and premium between GIUW_WITEMPERILDS_DTL and GIUW_WITEMDS_DTL  ]..........'
            );

         FOR dist IN
            (SELECT x.dist_no, x.dist_seq_no, x.item_no, x.share_cd,
                    w.trty_name, x.computed_tsi itmperil_dist_tsi,
                    x.computed_prem itmperil_dist_prem,
                    y.dist_tsi item_dist_tsi, y.dist_prem item_dist_prem,
                    NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                    NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
               FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                              a.share_cd,
                              SUM (DECODE (b.peril_type,
                                           'B', NVL (a.dist_tsi, 0),
                                           0
                                          )
                                  ) computed_tsi,
                              SUM (NVL (a.dist_prem, 0)) computed_prem
                         FROM giuw_witemperilds_dtl a, giis_peril b
                        WHERE a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.dist_no = p_dist_no
                     GROUP BY a.line_cd,
                              a.dist_no,
                              a.dist_seq_no,
                              a.item_no,
                              a.share_cd) x,
                    giuw_witemds_dtl y,
                    giis_dist_share w
              WHERE 1 = 1
                AND x.line_cd = w.line_cd
                AND x.share_cd = w.share_cd
                AND x.dist_no = p_dist_no
                AND x.dist_no = y.dist_no(+)
                AND x.dist_seq_no = y.dist_seq_no(+)
                AND x.item_no = y.item_no(+)
                AND x.share_cd = y.share_cd(+)
                AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                     OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                    )
             UNION
             SELECT y.dist_no, y.dist_seq_no, y.item_no, y.share_cd,
                    w.trty_name, x.computed_tsi, x.computed_prem, y.dist_tsi,
                    y.dist_prem,
                    NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                    NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
               FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                              a.share_cd,
                              SUM (DECODE (b.peril_type,
                                           'B', NVL (a.dist_tsi, 0),
                                           0
                                          )
                                  ) computed_tsi,
                              SUM (NVL (a.dist_prem, 0)) computed_prem
                         FROM giuw_witemperilds_dtl a, giis_peril b
                        WHERE a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.dist_no = p_dist_no
                     GROUP BY a.line_cd,
                              a.dist_no,
                              a.dist_seq_no,
                              a.item_no,
                              a.share_cd) x,
                    giuw_witemds_dtl y,
                    giis_dist_share w
              WHERE 1 = 1
                AND y.dist_no = p_dist_no
                AND y.line_cd = w.line_cd
                AND y.share_cd = w.share_cd
                AND y.dist_no = x.dist_no(+)
                AND y.dist_seq_no = x.dist_seq_no(+)
                AND y.item_no = x.item_no(+)
                AND y.share_cd = x.share_cd(+)
                AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                     OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_compt_wtemdtl;

/* ===================================================================================================================================
**  Dist Validation - Comparing TSI/Premium from ITMPERIL - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_compt_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the computed TSI and premium of GIUW_ITEMDS_DTL based from GIUW_WITEMPERILDS_DTL matches data stored in GIUW_ITEMPERILDS_DTL

      */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_val_compt_f_itemdtl');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_val_compt_f_itemdtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy of TSI and PREMIUM between GIUW_ITEMPERILDS_DTL and GIUW_ITEMDS_DTL. ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_compt_f_itemdtl [ checking discrepancy of TSI and premium between GIUW_ITEMPERILDS_DTL and GIUW_ITEMDS_DTL  ]..........'
            );

         FOR dist IN
            (SELECT x.dist_no, x.dist_seq_no, x.item_no, x.share_cd,
                    w.trty_name, x.computed_tsi itmperil_dist_tsi,
                    x.computed_prem itmperil_dist_prem,
                    y.dist_tsi item_dist_tsi, y.dist_prem item_dist_prem,
                    NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                    NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
               FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                              a.share_cd,
                              SUM (DECODE (b.peril_type,
                                           'B', NVL (a.dist_tsi, 0),
                                           0
                                          )
                                  ) computed_tsi,
                              SUM (NVL (a.dist_prem, 0)) computed_prem
                         FROM giuw_itemperilds_dtl a, giis_peril b
                        WHERE a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.dist_no = p_dist_no
                     GROUP BY a.line_cd,
                              a.dist_no,
                              a.dist_seq_no,
                              a.item_no,
                              a.share_cd) x,
                    giuw_itemds_dtl y,
                    giis_dist_share w
              WHERE 1 = 1
                AND x.line_cd = w.line_cd
                AND x.share_cd = w.share_cd
                AND x.dist_no = p_dist_no
                AND x.dist_no = y.dist_no(+)
                AND x.dist_seq_no = y.dist_seq_no(+)
                AND x.item_no = y.item_no(+)
                AND x.share_cd = y.share_cd(+)
                AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                     OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                    )
             UNION
             SELECT y.dist_no, y.dist_seq_no, y.item_no, y.share_cd,
                    w.trty_name, x.computed_tsi, x.computed_prem, y.dist_tsi,
                    y.dist_prem,
                    NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) diff_tsi,
                    NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) diff_prem
               FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no, a.item_no,
                              a.share_cd,
                              SUM (DECODE (b.peril_type,
                                           'B', NVL (a.dist_tsi, 0),
                                           0
                                          )
                                  ) computed_tsi,
                              SUM (NVL (a.dist_prem, 0)) computed_prem
                         FROM giuw_itemperilds_dtl a, giis_peril b
                        WHERE a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND a.dist_no = p_dist_no
                     GROUP BY a.line_cd,
                              a.dist_no,
                              a.dist_seq_no,
                              a.item_no,
                              a.share_cd) x,
                    giuw_itemds_dtl y,
                    giis_dist_share w
              WHERE 1 = 1
                AND y.dist_no = p_dist_no
                AND y.line_cd = w.line_cd
                AND y.share_cd = w.share_cd
                AND y.dist_no = x.dist_no(+)
                AND y.dist_seq_no = x.dist_seq_no(+)
                AND y.item_no = x.item_no(+)
                AND y.share_cd = x.share_cd(+)
                AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <> 0
                     OR NVL (x.computed_prem, 0) - NVL (y.dist_prem, 0) <> 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_compt_f_itemdtl;

   PROCEDURE p_val_compt_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the computed TSI and premium of GIUW_PERILDS_DTL based from GIUW_WITEMPERILDS_DTL matches data stored in GIUW_ITEMPERILDS_DTL
        */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_val_compt_f_perildtl');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_val_compt_f_perildtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy of TSI and PREMIUM between GIUW_ITEMPERILDS_DTL and GIUW_PERILDS_DTL. ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_compt_f_perildtl [ checking discrepancy of TSI and premium between GIUW_ITEMPERILDS_DTL and GIUW_PERILDS_DTL  ]..........'
            );

         FOR dist IN (SELECT x.dist_no, x.dist_seq_no, x.peril_cd, x.share_cd,
                             w.trty_name, x.computed_tsi itmperil_dist_tsi,
                             x.computed_prem itmperil_dist_prem,
                             y.dist_tsi item_dist_tsi,
                             y.dist_prem item_dist_prem,
                               NVL (x.computed_tsi, 0)
                             - NVL (y.dist_tsi, 0) diff_tsi,
                               NVL (x.computed_prem, 0)
                             - NVL (y.dist_prem, 0) diff_prem
                        FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                       a.peril_cd, a.share_cd,
                                       SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                       SUM (NVL (a.dist_prem, 0)
                                           ) computed_prem
                                  FROM giuw_itemperilds_dtl a, giis_peril b
                                 WHERE a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND a.dist_no = p_dist_no
                              GROUP BY a.line_cd,
                                       a.dist_no,
                                       a.dist_seq_no,
                                       a.peril_cd,
                                       a.share_cd) x,
                             giuw_perilds_dtl y,
                             giis_dist_share w
                       WHERE 1 = 1
                         AND x.dist_no = p_dist_no
                         AND x.line_cd = w.line_cd
                         AND x.share_cd = w.share_cd
                         AND x.dist_no = y.dist_no(+)
                         AND x.dist_seq_no = y.dist_seq_no(+)
                         AND x.peril_cd = y.peril_cd(+)
                         AND x.share_cd = y.share_cd(+)
                         AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                              OR   NVL (x.computed_prem, 0)
                                 - NVL (y.dist_prem, 0) <> 0
                             )
                      UNION
                      SELECT y.dist_no, y.dist_seq_no, y.peril_cd, y.share_cd,
                             w.trty_name, x.computed_tsi itmperil_dist_tsi,
                             x.computed_prem itmperil_dist_prem,
                             y.dist_tsi item_dist_tsi,
                             y.dist_prem item_dist_prem,
                               NVL (x.computed_tsi, 0)
                             - NVL (y.dist_tsi, 0) diff_tsi,
                               NVL (x.computed_prem, 0)
                             - NVL (y.dist_prem, 0) diff_prem
                        FROM (SELECT   a.line_cd, a.dist_no, a.dist_seq_no,
                                       a.peril_cd, a.share_cd,
                                       SUM (NVL (a.dist_tsi, 0)) computed_tsi,
                                       SUM (NVL (a.dist_prem, 0)
                                           ) computed_prem
                                  FROM giuw_itemperilds_dtl a, giis_peril b
                                 WHERE a.line_cd = b.line_cd
                                   AND a.peril_cd = b.peril_cd
                                   AND a.dist_no = p_dist_no
                              GROUP BY a.line_cd,
                                       a.dist_no,
                                       a.dist_seq_no,
                                       a.peril_cd,
                                       a.share_cd) x,
                             giuw_perilds_dtl y,
                             giis_dist_share w
                       WHERE 1 = 1
                         AND y.dist_no = p_dist_no
                         AND y.line_cd = w.line_cd
                         AND y.share_cd = w.share_cd
                         AND y.dist_no = x.dist_no(+)
                         AND y.dist_seq_no = x.dist_seq_no(+)
                         AND y.peril_cd = x.peril_cd(+)
                         AND y.share_cd = x.share_cd(+)
                         AND (   NVL (x.computed_tsi, 0) - NVL (y.dist_tsi, 0) <>
                                                                             0
                              OR   NVL (x.computed_prem, 0)
                                 - NVL (y.dist_prem, 0) <> 0
                             ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_compt_f_perildtl;

   PROCEDURE p_val_compt_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the computed TSI and premium of GIUW_POLICYDS_DTL based from GIUW_WITEMPERILDS_DTL matches data stored in GIUW_ITEMPERILDS_DTL
       */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)        := UPPER ('f_val_compt_f_poldtl');
      v_calling_proc   VARCHAR2 (30)        := UPPER ('p_val_compt_f_poldtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy of TSI and PREMIUM between GIUW_ITEMPERILDS_DTL and GIUW_POLICYDS_DTL. ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_compt_f_poldtl [ checking discrepancy of TSI and premium between GIUW_ITEMPERILDS_DTL and GIUW_POLICYDS_DTL  ]..........'
            );

         FOR dist IN
            (SELECT b.dist_no, b.dist_seq_no, b.share_cd, c.trty_name,
                    a.dist_tsi pol_dist_tsi, a.dist_prem pol_dist_prem,
                    b.dist_tsi itmperl_dist_tsi,
                    b.dist_prem itmperl_dist_prem,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl a,
                    (SELECT   x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd,
                              SUM (DECODE (y.peril_type,
                                           'B', NVL (x.dist_tsi, 0),
                                           0
                                          )
                                  ) dist_tsi,
                              SUM (NVL (x.dist_prem, 0)) dist_prem
                         FROM giuw_itemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                          AND x.peril_cd = y.peril_cd
                          AND x.dist_no = p_dist_no
                     GROUP BY x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd) b,
                    giis_dist_share c
              WHERE b.dist_no = p_dist_no
                AND b.dist_no = a.dist_no(+)
                AND b.dist_seq_no = a.dist_seq_no(+)
                AND b.share_cd = a.share_cd(+)
                AND b.line_cd = c.line_cd(+)
                AND b.share_cd = c.share_cd(+)
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                    )
             UNION
             SELECT a.dist_no, a.dist_seq_no, a.share_cd, c.trty_name,
                    a.dist_tsi pol_dist_tsi, a.dist_prem pol_dist_prem,
                    b.dist_tsi itmperl_dist_tsi,
                    b.dist_prem itmperl_dist_prem,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl a,
                    (SELECT   x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd,
                              SUM (DECODE (y.peril_type,
                                           'B', NVL (x.dist_tsi, 0),
                                           0
                                          )
                                  ) dist_tsi,
                              SUM (NVL (x.dist_prem, 0)) dist_prem
                         FROM giuw_itemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                          AND x.peril_cd = y.peril_cd
                          AND x.dist_no = p_dist_no
                     GROUP BY x.line_cd, x.dist_no, x.dist_seq_no, x.share_cd) b,
                    giis_dist_share c
              WHERE a.dist_no = p_dist_no
                AND a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.share_cd = b.share_cd(+)
                AND a.line_cd = c.line_cd(+)
                AND a.share_cd = c.share_cd(+)
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <> 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) <> 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_compt_f_poldtl;

/* ===================================================================================================================================
**  Dist Validation - Checking if there are share % whose decimal places is greater than nine (9) - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_dtl_rndoff9_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_ITEMDS_DTL
      */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_dtl_rndoff9_witemdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_dtl_rndoff9_witemdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share % of GIUW_WITEMDS_DTL.  ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_witemdtl [ checking if there exists dist shares  in GIUW_WITEMDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_witemds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_witemds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_witemdtl;

   PROCEDURE p_val_dtl_rndoff9_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_ITEMPERILDS_DTL
       */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_dtl_rndoff9_witmprldtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_dtl_rndoff9_witmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share %. of GIUW_WITEMPERILDS_DTL.  ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_witmprldtl [ checking if there exists dist shares  in GIUW_WITEMPERILDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_witemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_witemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_witmprldtl;

   PROCEDURE p_val_dtl_rndoff9_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_PERILDS_DTL
      */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_dtl_rndoff9_wperildtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_dtl_rndoff9_wperildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share %. of GIUW_WPERILDS_DTL ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_wperildtl [ checking if there exists dist shares  in GIUW_WPERILDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_wperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_wperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_wperildtl;

   PROCEDURE p_val_dtl_rndoff9_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_POLICYDS_DTL
         */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_val_dtl_rndoff9_wpoldtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_val_dtl_rndoff9_wpoldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share %. of GIUW_WPOLICYDS_DTL  ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_wpoldtl [ checking if there exists dist shares  in GIUW_WPOLICYDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_wpolicyds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_wpolicyds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_wpoldtl;

/* ===================================================================================================================================
**  Dist Validation - Checking if there are share % whose decimal places is greater than nine (9) - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_dtl_rndoff9_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_ITEMDS_DTL
      */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_dtl_rndoff9_f_itemdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_dtl_rndoff9_f_itemdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share % of GIUW_ITEMDS_DTL.  ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_f_itemdtl [ checking if there exists dist shares  in GIUW_ITEMDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_itemds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_itemds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_f_itemdtl;

   PROCEDURE p_val_dtl_rndoff9_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_ITEMPERILDS_DTL
       */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_val_dtl_rndoff9_f_itmprldtl');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_val_dtl_rndoff9_f_itmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share %. of GIUW_ITEMPERILDS_DTL.  ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_f_itmprldtl [ checking if there exists dist shares  in GIUW_ITEMPERILDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_f_itmprldtl;

   PROCEDURE p_val_dtl_rndoff9_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_PERILDS_DTL
      */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_dtl_rndoff9_f_perildtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_dtl_rndoff9_f_perildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share %. of GIUW_PERILDS_DTL ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_f_perildtl [ checking if there exists dist shares  in GIUW_PERILDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_perilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_perilds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_f_perildtl;

   PROCEDURE p_val_dtl_rndoff9_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there is any share which has more than 9 decimal places in GIUW_POLICYDS_DTL
         */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_dtl_rndoff9_f_poldtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_dtl_rndoff9_f_poldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are shares with more than nine decimal places in the share %. of GIUW_POLICYDS_DTL ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_dtl_rndoff9_f_poldtl [ checking if there exists dist shares  in GIUW_POLICYDS_DTL with more than 9 decimal places  ]..........'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR dist IN (SELECT 1
                           FROM giuw_policyds_dtl
                          WHERE dist_no = p_dist_no
                            AND (ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR dist IN (SELECT 1
                           FROM giuw_policyds_dtl
                          WHERE dist_no = p_dist_no
                            AND (   ROUND (NVL (dist_spct, 0), 9) <>
                                                            NVL (dist_spct, 0)
                                 OR ROUND (NVL (dist_spct1, 0), 9) <>
                                                           NVL (dist_spct1, 0)
                                ))
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_dtl_rndoff9_f_poldtl;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Amounts between Distribution Tables - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_witemds_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMDS against GIUW_WITEMDS_DTL ( TSI/PREM)
            Modules affected : All distribution modules.
         */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_val_witemds_witemdsdtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_val_witemds_witemdsdtl');
      v_exists_item    VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
          'There is a discrepancy between GIUW_WITEMDS and GIUW_WITEMDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_witemds_witemdsdtl [ comparing GIUW_WITEMDS against GIUW_WITEMDS_DTL ................'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_witemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_witemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.item_no = c.item_no(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_witemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_witemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.item_no = a.item_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_witemds_witemdsdtl;

   PROCEDURE p_val_witmprlds_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMPERILDS against GIUW_WITEMPERILDS_DTL ( TSI/PREM)
            Modules affected : All distribution modules.
         */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_witmprlds_witmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_witmprlds_witmprldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_witmprlds_witmprldsdtl [ comparing GIUW_WITEMPERILDS and GIUW_WITEMPERILDS_DTL ]...........'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.peril_cd, a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_witemperilds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_witemperilds_dtl b
                                 GROUP BY b.dist_no,
                                          b.dist_seq_no,
                                          b.item_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND a.dist_no = p_dist_no
                            AND a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.item_no = c.item_no(+)
                            AND a.peril_cd = c.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.item_no,
                                c.peril_cd, a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_witemperilds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_witemperilds_dtl b
                                 GROUP BY b.dist_no,
                                          b.dist_seq_no,
                                          b.item_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.item_no = a.item_no(+)
                            AND c.peril_cd = a.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_witmprlds_witmprldsdtl;

   PROCEDURE p_val_witmprldtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMPERILDS_DTL against GIUW_WITEMDS_DTL ( TSI/PREM)
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_witmprldtl_witemdsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_witmprldtl_witemdsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WITEMPERILDS_DTL and GIUW_WITEMDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_witmprldtl_witemdsdtl [ comparing GIUW_WITEMPERILDS_DTL against GIUW_WITEMDS_DTL  ................'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_item,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_item,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, item_no,
                                          share_cd,
                                          SUM (DECODE (y.peril_type,
                                                       'B', dist_tsi,
                                                       0
                                                      )
                                              ) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_witemperilds_dtl x,
                                          giis_peril y
                                    WHERE x.line_cd = y.line_cd
                                      AND x.peril_cd = y.peril_cd
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          item_no,
                                          share_cd) a,
                                giuw_witemds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.item_no = b.item_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                )
                         UNION
                         SELECT b.dist_no, b.dist_seq_no, b.item_no,
                                b.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_item,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_item,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, item_no,
                                          share_cd,
                                          SUM (DECODE (y.peril_type,
                                                       'B', dist_tsi,
                                                       0
                                                      )
                                              ) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_witemperilds_dtl x,
                                          giis_peril y
                                    WHERE x.line_cd = y.line_cd
                                      AND x.peril_cd = y.peril_cd
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          item_no,
                                          share_cd) a,
                                giuw_witemds_dtl b
                          WHERE a.dist_no(+) = b.dist_no
                            AND a.dist_seq_no(+) = b.dist_seq_no
                            AND a.item_no(+) = b.item_no
                            AND a.share_cd(+) = b.share_cd
                            AND b.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_witmprldtl_witemdsdtl;

   PROCEDURE p_val_witmprldtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMPERILDS_DTL against GIUW_WPERILDS_DTL ( TSI/PREM)
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_witmprldtl_wperildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_witmprldtl_wperildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WITEMPERILDS_DTL and GIUW_WPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_witmprldtl_wperildsdtl [ comparing GIUW_WITEMPERILDS_DTL against GIUW_WPERILDS_DTL ]...........'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                                a.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_peril,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_peril,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                          share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_witemperilds_dtl
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          peril_cd,
                                          share_cd) a,
                                giuw_wperilds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.peril_cd = b.peril_cd(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                )
                         UNION
                         SELECT b.dist_no, b.dist_seq_no, b.peril_cd,
                                b.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_peril,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_peril,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                          share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_witemperilds_dtl
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          peril_cd,
                                          share_cd) a,
                                giuw_wperilds_dtl b
                          WHERE a.dist_no(+) = b.dist_no
                            AND a.dist_seq_no(+) = b.dist_seq_no
                            AND a.peril_cd(+) = b.peril_cd
                            AND a.share_cd(+) = b.share_cd
                            AND b.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_witmprldtl_wperildsdtl;

   PROCEDURE p_val_wperilds_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPERILDS against GIUW_WPERILS_DTL ( TSI/PREM)
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_wperilds_wperildsdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_wperilds_wperildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WPERILDS and GIUW_WPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_wperilds_wperildsdtl [ comparing GIUW_WPERILDS and GIUW_WPERILDS_DTL ] ...............'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                                a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_wperilds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_wperilds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND a.dist_no = p_dist_no
                            AND a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.peril_cd = c.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.peril_cd,
                                a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_wperilds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_wperilds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.peril_cd = a.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_wperilds_wperildsdtl;

   PROCEDURE p_val_wpolds_wpoldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPOLICYDS against GIUW_WPOLICYDS_DTL ( TSI/PREM)
            Modules affected : All distribution modules.
         */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_val_wpolds_wpoldsdtl');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_val_wpolds_wpoldsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_wpolds_wpoldsdtl [ comparing GIUW_WPOLICYDS and GIUW_WPOLICYDS_DTL ]  ................'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.tsi_amt,
                                c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_wpolicyds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_wpolicyds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no) c
                          WHERE 1 = 1
                            AND a.dist_no = p_dist_no
                            AND a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, a.tsi_amt,
                                c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_wpolicyds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_wpolicyds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_wpolds_wpoldsdtl;

   PROCEDURE p_val_wpoldsdtl_witemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPOLICYDS_DTL against GIUW_WITEMDS_DTL
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_wpoldsdtl_witemdsdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_wpoldsdtl_witemdsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WPOLICYDS_DTL and GIUW_WITEMDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_wpoldsdtl_witemdsdtl   [ comparing GIUW_WPOLICYDS_DTL against GIUW_WITEMDS_DTL ] ...........'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                                a.dist_tsi policy_dtl_tsi,
                                b.dist_tsi itemdtl_tsi,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                a.dist_prem policy_dtl_prem,
                                b.dist_prem itemdtl_prem,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM giuw_wpolicyds_dtl a,
                                (SELECT   dist_no, dist_seq_no, share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_witemds_dtl x
                                 GROUP BY dist_no, dist_seq_no, share_cd) b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) != 0
                                )
                         UNION
                         SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                                a.dist_tsi policy_dtl_tsi,
                                b.dist_tsi itemdtl_tsi,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                a.dist_prem policy_dtl_prem,
                                b.dist_prem itemdtl_prem,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM giuw_wpolicyds_dtl a,
                                (SELECT   dist_no, dist_seq_no, share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_witemds_dtl x
                                 GROUP BY dist_no, dist_seq_no, share_cd) b
                          WHERE a.dist_no(+) = b.dist_no
                            AND a.dist_seq_no(+) = b.dist_seq_no
                            AND a.share_cd(+) = b.share_cd
                            AND b.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) != 0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_wpoldsdtl_witemdsdtl;

   PROCEDURE p_val_wpoldsdtl_witmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPOLICYDS_DTL against GIUW_WITEMPERILDS_DTL ( TSI/PREM)
         Modules affected : All distribution modules.
      */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_wpoldsdtl_witmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_wpoldsdtl_witmprldsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WPOLICYDS_DTL against GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_wpoldsdtl_witmprldsdtl   [comparing GIUW_WPOLICYDS_DTL against GIUW_WITMPERILDS_DTL ].......'
            );

         FOR discrep IN
            (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_wpolicyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', x.dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_witemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY dist_no, dist_seq_no, share_cd) b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.share_cd = b.share_cd(+)
                AND a.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    )
             UNION
             SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_wpolicyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', x.dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_witemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY dist_no, dist_seq_no, share_cd) b
              WHERE a.dist_no(+) = b.dist_no
                AND a.dist_seq_no(+) = b.dist_seq_no
                AND a.share_cd(+) = b.share_cd
                AND b.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_wpoldsdtl_witmprldsdtl;

   PROCEDURE p_val_wpoldsdtl_wperildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPOLICYDS_DTL against GIUW_WPERILDS_DTL ( TSI/PREM)
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_wpoldsdtl_wperildsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_wpoldsdtl_wperildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WPOLICYDS_DTL and GIUW_WPERILDS_DTL.';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_wpoldsdtl_wperildsdtl  [ comparing GIUW_WPOLICYDS_DTL against GIUW_WPERILDS_DTL ]..........'
            );

         FOR discrep IN
            (SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_wpolicyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_wperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
              WHERE a.dist_no(+) = b.dist_no
                AND a.dist_seq_no(+) = b.dist_seq_no
                AND a.share_cd(+) = b.share_cd
                AND b.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    )
             UNION
             SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_wpolicyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_wperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.share_cd = b.share_cd(+)
                AND a.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_wpoldsdtl_wperildsdtl;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Amounts between Distribution Tables - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_val_f_itemds_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_ITEMDS against GIUW_ITEMDS_DTL ( TSI/PREM)
            Modules affected : All distribution modules.
         */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_val_f_itemds_itemdsdtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_val_f_itemds_itemdsdtl');
      v_exists_item    VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
            'There is a discrepancy between GIUW_ITEMDS and GIUW_ITEMDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_itemds_itemdsdtl [ comparing GIUW_ITEMDS against GIUW_ITEMDS_DTL ................'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_itemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_itemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.item_no = c.item_no(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.item_no,
                                a.tsi_amt itemds_tsi,
                                c.dist_tsi itemds_dtl_tsi,
                                a.prem_amt itemds_prem,
                                c.dist_prem itemds_dtl_prem,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_itemds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_itemds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no, b.item_no) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.item_no = a.item_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_itemds_itemdsdtl;

   PROCEDURE p_val_f_itmprlds_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_ITEMPERILDS against GIUW_ITEMPERILDS_DTL ( TSI/PREM)
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_f_itmprlds_itmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_f_itmprlds_itmprldsdtl');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_itmprlds_itmprldsdtl [ comparing GIUW_ITEMPERILDS and GIUW_ITEMPERILDS_DTL ]...........'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.peril_cd, a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_itemperilds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_itemperilds_dtl b
                                 GROUP BY b.dist_no,
                                          b.dist_seq_no,
                                          b.item_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND a.dist_no = p_dist_no
                            AND a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.item_no = c.item_no(+)
                            AND a.peril_cd = c.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.item_no,
                                c.peril_cd, a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_itemperilds a,
                                (SELECT   b.dist_no, b.dist_seq_no, b.item_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_itemperilds_dtl b
                                 GROUP BY b.dist_no,
                                          b.dist_seq_no,
                                          b.item_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.item_no = a.item_no(+)
                            AND c.peril_cd = a.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_itmprlds_itmprldsdtl;

   PROCEDURE p_val_f_itmprldtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_ITEMPERILDS_DTL against GIUW_ITEMDS_DTL ( TSI/PREM)
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_f_itmprldtl_itemdsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_f_itmprldtl_itemdsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_ITEMPERILDS_DTL and GIUW_ITEMDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_itmprldtl_itemdsdtl [ comparing GIUW_ITEMPERILDS_DTL against GIUW_ITEMDS_DTL  ................'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_item,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_item,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, item_no,
                                          share_cd,
                                          SUM (DECODE (y.peril_type,
                                                       'B', dist_tsi,
                                                       0
                                                      )
                                              ) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_itemperilds_dtl x,
                                          giis_peril y
                                    WHERE x.line_cd = y.line_cd
                                      AND x.peril_cd = y.peril_cd
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          item_no,
                                          share_cd) a,
                                giuw_itemds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.item_no = b.item_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                )
                         UNION
                         SELECT b.dist_no, b.dist_seq_no, b.item_no,
                                b.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_item,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_item,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, item_no,
                                          share_cd,
                                          SUM (DECODE (y.peril_type,
                                                       'B', dist_tsi,
                                                       0
                                                      )
                                              ) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_itemperilds_dtl x,
                                          giis_peril y
                                    WHERE x.line_cd = y.line_cd
                                      AND x.peril_cd = y.peril_cd
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          item_no,
                                          share_cd) a,
                                giuw_itemds_dtl b
                          WHERE a.dist_no(+) = b.dist_no
                            AND a.dist_seq_no(+) = b.dist_seq_no
                            AND a.item_no(+) = b.item_no
                            AND a.share_cd(+) = b.share_cd
                            AND b.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_itmprldtl_itemdsdtl;

   PROCEDURE p_val_f_itmprldtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMPERILDS_DTL against GIUW_WPERILDS_DTL ( TSI/PREM)
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_f_itmprldtl_perildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_f_itmprldtl_perildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_ITEMPERILDS_DTL and GIUW_PERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_itmprldtl_perildsdtl [ comparing GIUW_ITEMPERILDS_DTL against GIUW_PERILDS_DTL ]...........'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                                a.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_peril,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_peril,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                          share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_itemperilds_dtl
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          peril_cd,
                                          share_cd) a,
                                giuw_perilds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.peril_cd = b.peril_cd(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                )
                         UNION
                         SELECT b.dist_no, b.dist_seq_no, b.peril_cd,
                                b.share_cd, a.dist_tsi tsi_itmperil,
                                b.dist_tsi tsi_peril,
                                a.dist_prem prem_itmperil,
                                b.dist_prem prem_peril,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM (SELECT   dist_no, dist_seq_no, peril_cd,
                                          share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_itemperilds_dtl
                                 GROUP BY dist_no,
                                          dist_seq_no,
                                          peril_cd,
                                          share_cd) a,
                                giuw_perilds_dtl b
                          WHERE a.dist_no(+) = b.dist_no
                            AND a.dist_seq_no(+) = b.dist_seq_no
                            AND a.peril_cd(+) = b.peril_cd
                            AND a.share_cd(+) = b.share_cd
                            AND b.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) <> 0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_itmprldtl_perildsdtl;

   PROCEDURE p_val_f_perilds_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_PERILDS against GIUW_PERILS_DTL ( TSI/PREM)
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_f_perilds_perildsdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_f_perilds_perildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
          'There is a discrepancy between GIUW_PERILDS and GIUW_PERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_perilds_perildsdtl [ comparing GIUW_PERILDS and GIUW_PERILDS_DTL ] ...............'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                                a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_perilds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_perilds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND a.dist_no = p_dist_no
                            AND a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND a.peril_cd = c.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, c.peril_cd,
                                a.tsi_amt, c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_perilds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          b.peril_cd,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_perilds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no,
                                          b.peril_cd) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND c.peril_cd = a.peril_cd(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_perilds_perildsdtl;

   PROCEDURE p_val_f_perildsdtl_wdstfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_PERILDS_DTL against GIRI_WDISTFRPS
                     Modules affected : All peril distribution modules
                */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_f_perildsdtl_wdstfrps');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_f_perildsdtl_wdstfrps');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_PERILDS_DTL and GIRI_WDISTFRPS.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_perildsdtl_wdstfrps [ comparing GIUW_PERILDS_DTL and GIRI_WDISTFRPS   ]  ........'
            );

         FOR dist IN
            (SELECT x.dist_no, x.dist_seq_no, y.line_cd, y.frps_yy,
                    y.frps_seq_no, x.dist_tsi perilds_facul_tsi,
                    x.dist_prem perilds_facul_prem, y.tot_fac_tsi,
                    y.tot_fac_prem,
                    NVL (x.dist_tsi, 0) - NVL (y.tot_fac_tsi, 0) diff_tsi,
                    NVL (x.dist_prem, 0) - NVL (y.tot_fac_prem, 0) diff_prem
               FROM (SELECT   a.dist_no, a.dist_seq_no,
                              SUM (NVL (DECODE (c.peril_type,
                                                'B', NVL (a.dist_tsi, 0),
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (a.dist_prem, 0)) dist_prem
                         FROM giuw_perilds_dtl a, giis_peril c
                        WHERE 1 = 1
                          AND a.dist_no = p_dist_no
                          AND a.share_cd = 999
                          AND a.line_cd = c.line_cd
                          AND a.peril_cd = c.peril_cd
                     GROUP BY a.dist_no, a.dist_seq_no) x,
                    giri_wdistfrps y
              WHERE x.dist_no = p_dist_no
                AND x.dist_no = y.dist_no(+)
                AND x.dist_seq_no = y.dist_seq_no(+)
                AND (   (NVL (x.dist_tsi, 0) - NVL (y.tot_fac_tsi, 0) <> 0)
                     OR (NVL (x.dist_prem, 0) - NVL (y.tot_fac_prem, 0) <> 0)
                    )
             UNION
             SELECT y.dist_no, y.dist_seq_no, y.line_cd, y.frps_yy,
                    y.frps_seq_no, NULL perilds_facul_tsi,
                    NULL perilds_facul_prem, y.tot_fac_tsi, y.tot_fac_prem,
                    0 - NVL (y.tot_fac_tsi, 0) diff_tsi,
                    0 - NVL (y.tot_fac_prem, 0) diff_prem
               FROM giri_wdistfrps y
              WHERE y.dist_no = p_dist_no
                AND NOT EXISTS (
                       SELECT 1
                         FROM giuw_perilds_dtl p
                        WHERE p.dist_no = y.dist_no
                          AND p.dist_seq_no = y.dist_seq_no
                          AND p.share_cd = 999))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_perildsdtl_wdstfrps;

   PROCEDURE p_val_f_polds_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_POLICYDS against GIUW_POLICYDS_DTL ( TSI/PREM)
            Modules affected : All distribution modules.
         */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_val_f_polds_poldsdtl');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_val_f_polds_poldsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS and GIUW_POLICYDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_polds_poldsdtl [ comparing GIUW_POLICYDS and GIUW_POLICYDS_DTL ]  ................'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.tsi_amt,
                                c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_policyds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_policyds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no) c
                          WHERE 1 = 1
                            AND a.dist_no = p_dist_no
                            AND a.dist_no = c.dist_no(+)
                            AND a.dist_seq_no = c.dist_seq_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                )
                         UNION
                         SELECT c.dist_no, c.dist_seq_no, a.tsi_amt,
                                c.dist_tsi,
                                  NVL (a.tsi_amt, 0)
                                - NVL (c.dist_tsi, 0) diff_tsi,
                                a.prem_amt, c.dist_prem,
                                  NVL (a.prem_amt, 0)
                                - NVL (c.dist_prem, 0) diff_prem
                           FROM giuw_policyds a,
                                (SELECT   b.dist_no, b.dist_seq_no,
                                          SUM (NVL (b.dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (b.dist_prem, 0))
                                                                    dist_prem
                                     FROM giuw_policyds_dtl b
                                 GROUP BY b.dist_no, b.dist_seq_no) c
                          WHERE 1 = 1
                            AND c.dist_no = p_dist_no
                            AND c.dist_no = a.dist_no(+)
                            AND c.dist_seq_no = a.dist_seq_no(+)
                            AND (   NVL (a.tsi_amt, 0) - NVL (c.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.prem_amt, 0) - NVL (c.dist_prem, 0) !=
                                                                             0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_polds_poldsdtl;

   PROCEDURE p_val_f_poldsdtl_wdistfrps (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_POLICYDS_DTL against GIRI_WDISTFRPS
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_f_poldsdtl_wdistfrps');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_f_poldsdtl_wdistfrps');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS_DTL and GIRI_WDISTFRPS.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_poldsdtl_wdistfrps [ comparing GIUW_POLICYDS_DTL and GIRI_WDISTFRPS   ]  ........'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.tot_fac_tsi,
                             b.dist_tsi, a.tot_fac_prem, b.dist_prem,
                             a.tot_fac_spct, b.dist_spct, a.tot_fac_spct2,
                             b.dist_spct1,
                               NVL (a.tot_fac_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.tot_fac_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem,
                               NVL (b.dist_spct, 0)
                             - NVL (a.tot_fac_spct, 0) diff_tot_fac_spct,
                               NVL (b.dist_spct1, 0)
                             - NVL (a.tot_fac_spct2, 0) diff_tot_fac_spct2
                        FROM giri_wdistfrps a, giuw_policyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no(+)
                         AND b.dist_seq_no = a.dist_seq_no(+)
                         AND b.share_cd(+) = 999
                         AND (   (NVL (a.tot_fac_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 )
                              OR (  NVL (a.tot_fac_prem, 0)
                                  - NVL (b.dist_prem, 0) <> 0
                                 )
                              OR (  NVL (b.dist_spct, 0)
                                  - NVL (a.tot_fac_spct, 0) <> 0
                                 )
                              OR (  NVL (b.dist_spct1, 0)
                                  - NVL (a.tot_fac_spct2, 0) <> 0
                                 )
                             )
                      UNION
                      SELECT a.dist_no, a.dist_seq_no, a.tot_fac_tsi,
                             b.dist_tsi, a.tot_fac_prem, b.dist_prem,
                             a.tot_fac_spct, b.dist_spct, a.tot_fac_spct2,
                             b.dist_spct1,
                               NVL (a.tot_fac_tsi, 0)
                             - NVL (b.dist_tsi, 0) diff_tsi,
                               NVL (a.tot_fac_prem, 0)
                             - NVL (b.dist_prem, 0) diff_prem,
                               NVL (b.dist_spct, 0)
                             - NVL (a.tot_fac_spct, 0) diff_tot_fac_spct,
                               NVL (b.dist_spct1, 0)
                             - NVL (a.tot_fac_spct2, 0) diff_tot_fac_spct2
                        FROM giri_wdistfrps a, giuw_policyds_dtl b
                       WHERE 1 = 1
                         AND a.dist_no = p_dist_no
                         AND a.dist_no = b.dist_no(+)
                         AND a.dist_seq_no = b.dist_seq_no(+)
                         AND b.share_cd(+) = 999
                         AND (   (NVL (a.tot_fac_tsi, 0) - NVL (b.dist_tsi, 0) <>
                                                                             0
                                 )
                              OR (  NVL (a.tot_fac_prem, 0)
                                  - NVL (b.dist_prem, 0) <> 0
                                 )
                              OR (  NVL (b.dist_spct, 0)
                                  - NVL (a.tot_fac_spct, 0) <> 0
                                 )
                              OR (  NVL (b.dist_spct1, 0)
                                  - NVL (a.tot_fac_spct2, 0) <> 0
                                 )
                             ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_poldsdtl_wdistfrps;

   PROCEDURE p_val_f_poldsdtl_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPOLICYDS_DTL against GIUW_WITEMDS_DTL
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_f_poldsdtl_itemdsdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_f_poldsdtl_itemdsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS_DTL and GIUW_ITEMDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_poldsdtl_itemdsdtl   [ comparing GIUW_POLICYDS_DTL against GIUW_ITEMDS_DTL ] ...........'
            );

         FOR discrep IN (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                                a.dist_tsi policy_dtl_tsi,
                                b.dist_tsi itemdtl_tsi,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                a.dist_prem policy_dtl_prem,
                                b.dist_prem itemdtl_prem,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM giuw_policyds_dtl a,
                                (SELECT   dist_no, dist_seq_no, share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_itemds_dtl x
                                 GROUP BY dist_no, dist_seq_no, share_cd) b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) != 0
                                )
                         UNION
                         SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                                a.dist_tsi policy_dtl_tsi,
                                b.dist_tsi itemdtl_tsi,
                                  NVL (a.dist_tsi, 0)
                                - NVL (b.dist_tsi, 0) diff_tsi,
                                a.dist_prem policy_dtl_prem,
                                b.dist_prem itemdtl_prem,
                                  NVL (a.dist_prem, 0)
                                - NVL (b.dist_prem, 0) diff_prem
                           FROM giuw_policyds_dtl a,
                                (SELECT   dist_no, dist_seq_no, share_cd,
                                          SUM (NVL (dist_tsi, 0)) dist_tsi,
                                          SUM (NVL (dist_prem, 0)) dist_prem
                                     FROM giuw_itemds_dtl x
                                 GROUP BY dist_no, dist_seq_no, share_cd) b
                          WHERE a.dist_no(+) = b.dist_no
                            AND a.dist_seq_no(+) = b.dist_seq_no
                            AND a.share_cd(+) = b.share_cd
                            AND b.dist_no = p_dist_no
                            AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) !=
                                                                             0
                                 OR NVL (a.dist_prem, 0)
                                    - NVL (b.dist_prem, 0) != 0
                                ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_poldsdtl_itemdsdtl;

   PROCEDURE p_val_f_poldsdtl_itmprldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_POLICYDS_DTL against GIUW_ITEMPERILDS_DTL ( TSI/PREM)
         Modules affected : All distribution modules.
      */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_f_poldsdtl_itmprldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_f_poldsdtl_itmprldsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS_DTL against GIUW_ITEMPERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_poldsdtl_itmprldsdtl  [comparing GIUW_POLICYDS_DTL against GIUW_ITMPERILDS_DTL ].......'
            );

         FOR discrep IN
            (SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', x.dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_itemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY dist_no, dist_seq_no, share_cd) b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.share_cd = b.share_cd(+)
                AND a.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    )
             UNION
             SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi itemperildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem itemperildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', x.dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_itemperilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY dist_no, dist_seq_no, share_cd) b
              WHERE a.dist_no(+) = b.dist_no
                AND a.dist_seq_no(+) = b.dist_seq_no
                AND a.share_cd(+) = b.share_cd
                AND b.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_poldsdtl_itmprldsdtl;

   PROCEDURE p_val_f_poldsdtl_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_POLICYDS_DTL against GIUW_PERILDS_DTL ( TSI/PREM)
                 Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_val_f_poldsdtl_perildsdtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_val_f_poldsdtl_perildsdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS_DTL and GIUW_PERILDS_DTL.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_f_poldsdtl_perildsdtl  [ comparing GIUW_POLICYDS_DTL against GIUW_PERILDS_DTL ]..........'
            );

         FOR discrep IN
            (SELECT b.dist_no, b.dist_seq_no, b.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_perilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
              WHERE a.dist_no(+) = b.dist_no
                AND a.dist_seq_no(+) = b.dist_seq_no
                AND a.share_cd(+) = b.share_cd
                AND b.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    )
             UNION
             SELECT a.dist_no, a.dist_seq_no, a.share_cd,
                    a.dist_tsi policydtl_tsi, b.dist_tsi perildtl_tsi,
                    NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    a.dist_prem policydtl_prem, b.dist_prem perildtl_prem,
                    NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl a,
                    (SELECT   dist_no, dist_seq_no, share_cd,
                              SUM (NVL (DECODE (y.peril_type,
                                                'B', dist_tsi,
                                                0
                                               ),
                                        0
                                       )
                                  ) dist_tsi,
                              SUM (NVL (dist_prem, 0)) dist_prem
                         FROM giuw_perilds_dtl x, giis_peril y
                        WHERE x.line_cd = y.line_cd
                              AND x.peril_cd = y.peril_cd
                     GROUP BY x.dist_no, x.dist_seq_no, x.share_cd) b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.share_cd = b.share_cd(+)
                AND a.dist_no = p_dist_no
                AND (   NVL (a.dist_tsi, 0) - NVL (b.dist_tsi, 0) != 0
                     OR NVL (a.dist_prem, 0) - NVL (b.dist_prem, 0) != 0
                    ))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_val_f_poldsdtl_perildsdtl;

/* ===================================================================================================================================
**  Dist Validation - Validating GIUW_POL_DIST
** ==================================================================================================================================*/
   PROCEDURE p_val_pol_dist (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the value of auto_dist, post_flag and dist_flag in GIUW_POL_DIST.
             Modules affected : All distribution modules.
          */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)              := UPPER ('f_val_pol_dist');
      v_calling_proc   VARCHAR2 (30)              := UPPER ('p_val_pol_dist');
      v_exists_item    VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_auto_dist      giuw_pol_dist.auto_dist%TYPE;
      v_post_flag      giuw_pol_dist.post_flag%TYPE;
      v_with_facul     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
      v_special_dist   giuw_pol_dist.special_dist_sw%TYPE;
   BEGIN
      FOR poldist IN (SELECT dist_flag, auto_dist, post_flag
                        FROM giuw_pol_dist
                       WHERE dist_no = p_dist_no)
      LOOP
         v_dist_flag := poldist.dist_flag;
         v_auto_dist := poldist.auto_dist;
         v_post_flag := poldist.post_flag;
         EXIT;
      END LOOP;

      IF p_dist_type = 'P' AND v_post_flag <> 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_val_pol_dist [validating data in GIUW_POL_DIST ]............'
            );
         v_findings :=
            'Incorrect value of POST_FLAG in GIUW_POL_DIST. Post_flag should be tagged as P for Peril Distribution.';
         v_output := v_result_failed;
         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSIF p_dist_type = 'O' AND v_post_flag <> 'O'
      THEN
         v_findings :=
            'Incorrect value of POST_FLAG in GIUW_POL_DIST. Post_flag should be tagged as O for One Risk Distribution.';
         v_output := v_result_failed;
         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      ELSE
         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;

      v_output := v_result_passed;

      IF p_action = 'S'
      THEN
         IF v_dist_flag <> '1'
         THEN
            v_findings :=
               'Incorrect value of DIST_FLAG in GIUW_POL_DIST. Record should be undistributed (1 ).';
            v_output := v_result_failed;
            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         ELSE
            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;

         v_output := v_result_passed;

         IF v_auto_dist <> 'N'
         THEN
            v_findings :=
               'Incorrect value of auto_dist in GIUW_POL_DIST. Record should have auto_dist equal to N .';
            v_output := v_result_failed;
            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         ELSE
            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      ELSIF p_action = 'P'
      THEN
         v_output := v_result_passed;
         v_with_facul := 'N';

         FOR facul IN (SELECT 1
                         FROM giuw_policyds_dtl
                        WHERE dist_no = p_dist_no AND share_cd = 999)
         LOOP
            v_with_facul := 'Y';
            EXIT;
         END LOOP;


         IF v_with_facul = 'Y' AND v_dist_flag <> '2'
         THEN
            v_findings :=
               'Incorrect value of DIST_FLAG in GIUW_POL_DIST. Record should be undistributed with facultative (2).';
            v_output := v_result_failed;
            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         ELSIF v_with_facul = 'N'
         THEN
       /*AND v_dist_flag <> '3'  -- jhing 07.03.2014 commented out condition*/
            -- jhing 07.03.2014
            IF v_dist_flag <> '3' AND p_distmod_type = 'O'
            THEN
               v_findings :=
                  'Incorrect value of DIST_FLAG in GIUW_POL_DIST. Record should be distributed (3).';
               v_output := v_result_failed;
            ELSIF v_dist_flag <> '1' AND p_distmod_type = 'I'
            THEN
               v_findings :=
                  'Incorrect value of DIST_FLAG in GIUW_POL_DIST. Record should be undistributed (1 ).';
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         /* ELSE
             p_log_result (p_dist_no,
                           p_dist_by_tsi_prem_sw,
                           p_action,
                           p_dist_type,
                           p_distmod_type,
                           p_module_id,
                           p_user,
                           v_findings,
                           v_query_fnc,
                           v_calling_proc,
                           v_output
                          );  -- jhing 07.03.2014 commented out */
         END IF;
      ELSE
         raise_application_error
            (-20020,
             'Invalid parameter value for P_ACTION. Can only accept S = Saving and P = Posting.',
             TRUE
            );
      END IF;
   END p_val_pol_dist;

/* ===================================================================================================================================
**  Dist Validation - Comparing Final and Working Distribution Tables if EQUAL
** ==================================================================================================================================*/
   PROCEDURE p_val_witemdsdtl_f_itemdsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMDSDTL against GIUW_ITEMDS_DTL. This should be used in validating posted distribution in the inner distribution module;
                   posting distribution with facultative share in the outer dist module
        */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_val_witemdsdtl_f_itemdsdtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_val_witemdsdtl_f_itemdsdtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'Records in GIUW_ITEMDS_DTL does not match records in GIUW_WITEMDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing p_val_witemdsdtl_f_itemdsdtl  [ comparing records in GIUW_WITEMDS_DTL against GIUW_ITEMDS_DTL  ] ................'
            );

         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF p_distmod_type = 'I' OR v_dist_flag = '2'
         THEN
            FOR dist IN (SELECT *
                           FROM (SELECT dist_no, dist_seq_no, item_no,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_itemds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, item_no,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_witemds_dtl
                                  WHERE dist_no = p_dist_no) x
                         UNION
                         SELECT *
                           FROM (SELECT dist_no, dist_seq_no, item_no,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_witemds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, item_no,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_itemds_dtl
                                  WHERE dist_no = p_dist_no))
            LOOP
               v_discrep := 'Y';
               EXIT;
            END LOOP;

            IF v_discrep = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_val_witemdsdtl_f_itemdsdtl;

   PROCEDURE p_val_witmpldsdtl_f_itmpldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WITEMPERILDS_DTL against GIUW_ITEMPERILDS_DTL. This should be used in validating posted distribution in the inner distribution module;
                    posting distribution with facultative share in the outer dist module
         */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_val_witmpldsdtl_f_itmpldsdtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_val_witmpldsdtl_f_itmpldsdtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'Records in GIUW_ITEMPERILDS_DTL does not match records in GIUW_WITEMPERILDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing p_val_witmpldsdtl_f_itmpldsdtl [ comparing records in GIUW_WITEMPERILDS_DTL against GIUW_ITEMPERILDS_DTL  ] ................'
            );

         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF p_distmod_type = 'I' OR v_dist_flag = '2'
         THEN
            FOR dist IN (SELECT *
                           FROM (SELECT dist_no, dist_seq_no, item_no,
                                        peril_cd, line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_itemperilds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, item_no,
                                        peril_cd, line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_witemperilds_dtl
                                  WHERE dist_no = p_dist_no)
                         UNION
                         SELECT *
                           FROM (SELECT dist_no, dist_seq_no, item_no,
                                        peril_cd, line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_witemperilds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, item_no,
                                        peril_cd, line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_itemperilds_dtl
                                  WHERE dist_no = p_dist_no))
            LOOP
               v_discrep := 'Y';
               EXIT;
            END LOOP;

            IF v_discrep = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_val_witmpldsdtl_f_itmpldsdtl;

   PROCEDURE p_val_wpoldsdtl_f_poldsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPOLICYDS_DTL against GIUW_POLICYDS_DTL. This should be used in validating posted distribution in the inner distribution module;
                      posting distribution with facultative share in the outer dist module
           */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_val_wpoldsdtl_f_poldsdtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_val_wpoldsdtl_f_poldsdtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'Records in GIUW_POLICYDS_DTL does not match records in GIUW_WPOLICYDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing  p_val_wpoldsdtl_f_poldsdtl [ comparing records in GIUW_WPOLICYDS_DTL against GIUW_POLICYDS_DTL  ] ................'
            );

         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF p_distmod_type = 'I' OR v_dist_flag = '2'
         THEN
            FOR dist IN (SELECT *
                           FROM (SELECT dist_no, dist_seq_no, line_cd,
                                        share_cd, dist_tsi, dist_prem,
                                        dist_spct, dist_spct1, ann_dist_spct,
                                        ann_dist_tsi, dist_grp
                                   FROM giuw_policyds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, line_cd,
                                        share_cd, dist_tsi, dist_prem,
                                        dist_spct, dist_spct1, ann_dist_spct,
                                        ann_dist_tsi, dist_grp
                                   FROM giuw_wpolicyds_dtl
                                  WHERE dist_no = p_dist_no) x
                         UNION
                         SELECT *
                           FROM (SELECT dist_no, dist_seq_no, line_cd,
                                        share_cd, dist_tsi, dist_prem,
                                        dist_spct, dist_spct1, ann_dist_spct,
                                        ann_dist_tsi, dist_grp
                                   FROM giuw_wpolicyds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, line_cd,
                                        share_cd, dist_tsi, dist_prem,
                                        dist_spct, dist_spct1, ann_dist_spct,
                                        ann_dist_tsi, dist_grp
                                   FROM giuw_policyds_dtl
                                  WHERE dist_no = p_dist_no))
            LOOP
               v_discrep := 'Y';
               EXIT;
            END LOOP;

            IF v_discrep = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_val_wpoldsdtl_f_poldsdtl;

   PROCEDURE p_val_wperildsdtl_f_perildsdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare GIUW_WPERILDS_DTL against GIUW_PERILDS_DTL. This should be used in validating posted distribution in the inner distribution module;
                      posting distribution with facultative share in the outer dist module
           */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_val_wperildsdtl_f_perildsdtl');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_val_wperildsdtl_f_perildsdtl');
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'Records in GIUW_PERILDS_DTL does not match records in GIUW_WPERILDS_DTL';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing p_val_wperildsdtl_f_perildsdtl [ comparing records in GIUW_WPERILDS_DTL against GIUW_PERILDS_DTL  ] ................'
            );

         FOR poldist IN (SELECT dist_flag
                           FROM giuw_pol_dist
                          WHERE dist_no = p_dist_no)
         LOOP
            v_dist_flag := poldist.dist_flag;
            EXIT;
         END LOOP;

         IF p_distmod_type = 'I' OR v_dist_flag = '2'
         THEN
            FOR dist IN (SELECT *
                           FROM (SELECT dist_no, dist_seq_no, peril_cd,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_perilds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, peril_cd,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_wperilds_dtl
                                  WHERE dist_no = p_dist_no)
                         UNION
                         SELECT *
                           FROM (SELECT dist_no, dist_seq_no, peril_cd,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_wperilds_dtl
                                  WHERE dist_no = p_dist_no
                                 MINUS
                                 SELECT dist_no, dist_seq_no, peril_cd,
                                        line_cd, share_cd, dist_tsi,
                                        dist_prem, dist_spct, dist_spct1,
                                        ann_dist_spct, ann_dist_tsi, dist_grp
                                   FROM giuw_perilds_dtl
                                  WHERE dist_no = p_dist_no))
            LOOP
               v_discrep := 'Y';
               EXIT;
            END LOOP;

            IF v_discrep = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_val_wperildsdtl_f_perildsdtl;

      /* ===================================================================================================================================
   **  Dist Validation - Checking existence of non-zero TSI/Prem with zero share % - Working Distribution Tables
   ** ==================================================================================================================================*/
   PROCEDURE p_valcnt_nzroprem_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists records whose premium is non-zero but share % is zero in GIUW_WITEMPERILDS_DTL
                  Modules affected : All distribution modules.
               */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_valcnt_nzroprem_witmprldtl02');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_valcnt_nzroprem_witmprldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with non-zero premium but share % is zero  in GIUW_WITEMPERILDS_DTL .  ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_nzroprem_witmprldtl02  [ checking of existence of records with non-zero premium but share% is zero in GIUW_WITEMPERILDS_DTL.  ]................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR curdist IN (SELECT 1
                              FROM giuw_witemperilds_dtl
                             WHERE dist_no = p_dist_no
                               AND dist_prem <> 0
                               AND dist_spct = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR curdist IN (SELECT 1
                              FROM giuw_witemperilds_dtl
                             WHERE dist_no = p_dist_no
                               AND dist_prem <> 0
                               AND NVL (dist_spct1, 0) = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_nzroprem_witmprldtl02;

   PROCEDURE p_valcnt_nzrotsi_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists records whose TSI is non-zero but DIST_SPCT is zero in GIUW_WITEMPERILDS_DTL
                    Modules affected : All distribution modules.
                  */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('p_valcnt_nzrotsi_witmprldtl');
      v_calling_proc   VARCHAR2 (30) := UPPER ('f_valcnt_nzrotsi_witmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with non-zero TSI but share % is zero in GIUW_WITEMPERILDS_DTL . ';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_nzroprem_f_itmpldtl01  [ checking of existence of records with non-zero TSI but share% is zero in GIUW_WITEMPERILDS_DTL ]................'
            );

         FOR curdist IN (SELECT 1
                           FROM giuw_witemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_tsi <> 0
                            AND dist_spct = 0)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_nzrotsi_witmprldtl;

      /* ===================================================================================================================================
   **  Dist Validation - Checking existence of non-zero TSI/Prem with zero share % - Final Distribution Tables
   ** ==================================================================================================================================*/
   PROCEDURE p_valcnt_nzroprem_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists records whose premium is non-zero but share % is zero in GIUW_ITEMPERILDS_DTL
                  Modules affected : All distribution modules.
               */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_valcnt_nzroprem_f_itmpldtl01');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_valcnt_nzroprem_f_itmpldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with non-zero premium but share % is zero in GIUW_ITEMPERILDS_DTL. ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_nzroprem_f_itmpldtl01  [ checking of existence of records with non-zero premium but share% is zero in GIUW_ITEMPERILDS_DTL ]................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         THEN
            FOR curdist IN (SELECT 1
                              FROM giuw_itemperilds_dtl
                             WHERE dist_no = p_dist_no
                               AND dist_prem <> 0
                               AND dist_spct = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         ELSE
            FOR curdist IN (SELECT 1
                              FROM giuw_itemperilds_dtl
                             WHERE dist_no = p_dist_no
                               AND dist_prem <> 0
                               AND NVL (dist_spct1, 0) = 0)
            LOOP
               v_exists_rec := 'Y';
               EXIT;
            END LOOP;
         END IF;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_nzroprem_f_itmpldtl01;

   PROCEDURE p_valcnt_nzrotsi_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists records whose TSI is non-zero but DIST_SPCT is zero in GIUW_ITEMPERILDS_DTL
                   Modules affected : All distribution modules.
                 */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_valcnt_nzrotsi_f_itmprldtl');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_valcnt_nzrotsi_f_itmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with non-zero TSI but share % is zero in GIUW_ITEMPERILDS_DTL . ';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_nzroprem_f_itmpldtl01  [ checking of existence of records with non-zero TSI but share% is zero in GIUW_ITEMPERILDS_DTL ]................'
            );

         FOR curdist IN (SELECT 1
                           FROM giuw_itemperilds_dtl
                          WHERE dist_no = p_dist_no
                            AND dist_tsi <> 0
                            AND dist_spct = 0)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_nzrotsi_f_itmprldtl;

/* ===================================================================================================================================
**  Dist Validation - Verification of amounts based on manual computation - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valcnt_orsk_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_ITEMPERILDS_DTL ( One Risk Distribution)
                  Modules affected : All peril distribution modules
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_valcnt_orsk_witmprldtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_valcnt_orsk_witmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 0.05;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WITEMPERILDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit. ( One Risk Dist )';

      IF p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_orsk_f_itmprldtl [ Validating the amounts of GIUW_WITEMPERILDS_DTL - One Risk Distribution  ]  ................'
            );

         IF p_dist_type = 'O'
         THEN
            FOR cur IN
               (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                       a.share_cd, a.dist_spct pol_distspct,
                       a.dist_spct1 pol_distspct1, a.computed_tsi,
                       a.computed_prem, b.dist_spct itmperl_distspct,
                       b.dist_spct1 itmperil_distspct1,
                       b.dist_tsi itmperil_disttsi,
                       b.dist_prem itmperil_distprem,
                         NVL (a.dist_spct, 0)
                       - NVL (b.dist_spct, 0) diff_dist_spct,
                         NVL (a.dist_spct1, 0)
                       - NVL (b.dist_spct1, 0) diff_dist_spct1,
                       NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)
                                                                    diff_tsi,
                         NVL (a.computed_prem, 0)
                       - NVL (b.dist_prem, 0) diff_prem
                  FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no,
                               y.peril_cd, x.share_cd, x.dist_spct,
                               x.dist_spct1,
                               ROUND
                                    (  NVL (y.tsi_amt, 0)
                                     * ROUND (NVL (x.dist_spct, 0), 9)
                                     / 100,
                                     2
                                    ) computed_tsi,
                               (ROUND
                                    (  NVL (y.prem_amt, 0)
                                     * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                       'Y', NVL (x.dist_spct1,
                                                                 0
                                                                ),
                                                       NVL (x.dist_spct, 0)
                                                      )
                                              ),
                                              9
                                             )
                                     / 100,
                                     2
                                    )
                               ) computed_prem
                          FROM giuw_wpolicyds_dtl x, giuw_witemperilds y
                         WHERE x.dist_no = p_dist_no
                           AND x.dist_no = y.dist_no
                           AND x.dist_seq_no = y.dist_seq_no) a,
                       giuw_witemperilds_dtl b
                 WHERE a.dist_no = b.dist_no(+)
                   AND a.dist_seq_no = b.dist_seq_no(+)
                   AND a.item_no = b.item_no(+)
                   AND a.peril_cd = b.peril_cd(+)
                   AND a.share_cd = b.share_cd(+)
                   AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <> 0)
                        OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <> 0
                           )
                        OR (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                           )
                        OR (ABS (  NVL (a.computed_prem, 0)
                                 - NVL (b.dist_prem, 0)
                                ) > v_tol_discrep
                           )
                       )
                UNION
                SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd,
                       y.share_cd, 0 pol_distspct, 0 pol_distspct1,
                       0 computed_tsi, 0 computed_prem,
                       y.dist_spct itmperil_distspct,
                       y.dist_spct1 itmperil_distspct1,
                       y.dist_tsi itmperil_disttsi,
                       y.dist_prem itmperil_distprem,
                       0 - NVL (y.dist_spct, 0) diff_dist_spct,
                       0 - NVL (y.dist_spct1, 0) diff_dist_spct1,
                       0 - NVL (y.dist_tsi, 0) diff_tsi,
                       0 - NVL (y.dist_prem, 0) diff_prem
                  FROM giuw_wpolicyds_dtl x, giuw_witemperilds_dtl y
                 WHERE y.dist_no = p_dist_no
                   AND x.dist_no(+) = y.dist_no
                   AND x.dist_seq_no(+) = y.dist_seq_no
                   AND x.share_cd(+) = y.share_cd
                   AND NOT EXISTS (
                          SELECT 1
                            FROM giuw_wpolicyds_dtl p
                           WHERE p.dist_no = y.dist_no
                             AND p.dist_seq_no = y.dist_seq_no
                             AND p.share_cd = y.share_cd))
            LOOP
               v_discrep := 'Y';
               EXIT;
            END LOOP;

            IF v_discrep = 'Y'
            THEN
               v_output := v_result_failed;
            END IF;

            p_log_result (p_dist_no,
                          p_dist_by_tsi_prem_sw,
                          p_action,
                          p_dist_type,
                          p_distmod_type,
                          p_module_id,
                          p_user,
                          v_findings,
                          v_query_fnc,
                          v_calling_proc,
                          v_output
                         );
         END IF;
      END IF;
   END p_valcnt_orsk_witmprldtl;

   PROCEDURE p_valcnt_orsk_wpoldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_WPOLICYDS_DTL ( One Risk Distribution)
                      Modules affected : All peril distribution modules
                 */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_valcnt_orsk_wpoldtl');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_valcnt_orsk_wpoldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 1;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit. ( One Risk Dist )';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_orsk_wpoldtl [ Validating the amounts of GIUW_POLICYDS_DTL - One Risk Distribution  ]  ................'
            );

         FOR dist IN
            (SELECT a.dist_no, a.dist_seq_no, c.trty_name, c.share_cd,
                    b.dist_spct, b.dist_tsi, b.dist_prem,
                    ROUND (  NVL (a.tsi_amt, 0)
                           * ROUND (NVL (b.dist_spct, 0), 9)
                           / 100,
                           2
                          ) computed_tsi,
                    ROUND
                       (  NVL (a.prem_amt, 0)
                        * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                          'Y', NVL (b.dist_spct1, 0),
                                          NVL (b.dist_spct, 0)
                                         )
                                 ),
                                 9
                                )
                        / 100,
                        2
                       ) computed_prem,
                      NVL (b.dist_tsi, 0)
                    - ROUND (  NVL (a.tsi_amt, 0)
                             * ROUND (NVL (b.dist_spct, 0), 9)
                             / 100,
                             2
                            ) diff_tsi,
                      NVL (b.dist_prem, 0)
                    - ROUND (  NVL (a.prem_amt, 0)
                             * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                               'Y', NVL (b.dist_spct1, 0),
                                               NVL (b.dist_spct, 0)
                                              )
                                      ),
                                      9
                                     )
                             / 100,
                             2
                            ) diff_prem,
                      NVL (b.dist_spct, 0)
                    - ROUND (NVL (b.dist_spct, 0), 9) diff_spct,
                      NVL (b.dist_spct1, 0)
                    - ROUND (NVL (b.dist_spct1, 0), 9) diff_spct1
               FROM giuw_wpolicyds a, giuw_wpolicyds_dtl b, giis_dist_share c
              WHERE a.dist_no = b.dist_no
                AND a.dist_seq_no = b.dist_seq_no
                AND b.line_cd = c.line_cd
                AND b.share_cd = c.share_cd
                AND a.dist_no = p_dist_no
                AND (   (NVL (b.dist_spct, 0)
                         - ROUND (NVL (b.dist_spct, 0), 9) <> 0
                        )
                     OR (  NVL (b.dist_spct1, 0)
                         - ROUND (NVL (b.dist_spct1, 0), 9) <> 0
                        )
                     OR (ABS (  NVL (b.dist_tsi, 0)
                              - ROUND (  NVL (a.tsi_amt, 0)
                                       * ROUND (NVL (b.dist_spct, 0), 9)
                                       / 100,
                                       2
                                      )
                             ) > v_tol_discrep
                        )
                     OR (ABS (  NVL (b.dist_prem, 0)
                              - ROUND
                                    (  NVL (a.prem_amt, 0)
                                     * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                       'Y', NVL (b.dist_spct1,
                                                                 0
                                                                ),
                                                       NVL (b.dist_spct, 0)
                                                      )
                                              ),
                                              9
                                             )
                                     / 100,
                                     2
                                    )
                             ) > v_tol_discrep
                        )
                    ))
         LOOP
            v_discrep := 'Y';
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_orsk_wpoldtl;

   PROCEDURE p_valcnt_pdist_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Compare computed amounts of GIUW_WITEMPERILDS_DTL based on data on GIUW_WPERILDS_DTL ( DIST_SPCT/ DIST_SPCT1)
               Modules affected : All peril distribution modules
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_valcnt_pdist_witmprldtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_valcnt_pdist_witmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 0.05;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WITEMPERILDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit.';

      IF p_dist_type = 'P' AND p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_pdist_witmprldtl [ validating the amounts in GIUW_WITEMPERILDS_DTL (Peril Dist) ] ...........'
            );

         FOR cur IN
            (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                    a.share_cd, a.dist_spct pol_distspct,
                    a.dist_spct1 pol_distspct1, a.computed_tsi,
                    a.computed_prem, b.dist_spct itmperl_distspct,
                    b.dist_spct1 itmperil_distspct1,
                    b.dist_tsi itmperil_disttsi,
                    b.dist_prem itmperil_distprem,
                    NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                            x.share_cd, x.dist_spct, x.dist_spct1,
                            ROUND (  NVL (y.tsi_amt, 0)
                                   * ROUND (NVL (x.dist_spct, 0), 9)
                                   / 100,
                                   2
                                  ) computed_tsi,
                            (ROUND (  NVL (y.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (x.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (x.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                            ) computed_prem
                       FROM giuw_wperilds_dtl x, giuw_witemperilds y
                      WHERE x.dist_no = p_dist_no
                        AND x.dist_no = y.dist_no
                        AND x.dist_seq_no = y.dist_seq_no
                        AND x.peril_cd = y.peril_cd) a,
                    giuw_witemperilds_dtl b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.item_no = b.item_no(+)
                AND a.peril_cd = b.peril_cd(+)
                AND a.share_cd = b.share_cd(+)
                AND (   (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                        )
                     OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                        )
                    )
             UNION
             SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd,
                    y.share_cd, 0 pol_distspct, 0 pol_distspct1,
                    0 computed_tsi, 0 computed_prem,
                    y.dist_spct itmperil_distspct,
                    y.dist_spct1 itmperil_distspct1,
                    y.dist_tsi itmperil_disttsi,
                    y.dist_prem itmperil_distprem,
                    0 - NVL (y.dist_tsi, 0) diff_tsi,
                    0 - NVL (y.dist_prem, 0) diff_prem
               FROM giuw_wperilds_dtl x, giuw_witemperilds_dtl y
              WHERE y.dist_no = p_dist_no
                AND x.dist_no(+) = y.dist_no
                AND x.dist_seq_no(+) = y.dist_seq_no
                AND x.share_cd(+) = y.share_cd
                AND x.peril_cd(+) = y.peril_cd
                AND NOT EXISTS (
                       SELECT 1
                         FROM giuw_wperilds_dtl p
                        WHERE p.dist_no = y.dist_no
                          AND p.dist_seq_no = y.dist_seq_no
                          AND p.share_cd = y.share_cd
                          AND p.peril_cd = y.peril_cd))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_pdist_witmprldtl;

   PROCEDURE p_valcnt_pdist_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_PERILDS_DTL ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_valcnt_pdist_wperildtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_valcnt_pdist_wperildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 1;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_WPERILDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit. ( Peril Distribution )';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_pdist_wperildtl [ Validating the amounts of GIUW_WPERILDS_DTL (Peril Distribution) against expected amounts  ]  ................'
            );

         FOR dist IN
            (SELECT a.dist_no, a.dist_seq_no, a.peril_cd, c.trty_name,
                    c.share_cd, b.dist_spct, b.dist_tsi, b.dist_prem,
                    ROUND (  NVL (a.tsi_amt, 0)
                           * ROUND (NVL (b.dist_spct, 0), 9)
                           / 100,
                           2
                          ) computed_tsi,
                    ROUND
                       (  NVL (a.prem_amt, 0)
                        * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                          'Y', NVL (b.dist_spct1, 0),
                                          NVL (b.dist_spct, 0)
                                         )
                                 ),
                                 9
                                )
                        / 100,
                        2
                       ) computed_prem,
                      NVL (b.dist_tsi, 0)
                    - ROUND (  NVL (a.tsi_amt, 0)
                             * ROUND (NVL (b.dist_spct, 0), 9)
                             / 100,
                             2
                            ) diff_tsi,
                      NVL (b.dist_prem, 0)
                    - ROUND (  NVL (a.prem_amt, 0)
                             * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                               'Y', NVL (b.dist_spct1, 0),
                                               NVL (b.dist_spct, 0)
                                              )
                                      ),
                                      9
                                     )
                             / 100,
                             2
                            ) diff_prem
               FROM giuw_wperilds a, giuw_wperilds_dtl b, giis_dist_share c
              WHERE 1 = 1
                AND a.dist_no = p_dist_no
                AND a.dist_no = b.dist_no
                AND a.dist_seq_no = b.dist_seq_no
                AND a.peril_cd = b.peril_cd
                AND b.line_cd = c.line_cd
                AND b.share_cd = c.share_cd
                AND (   (ABS (  NVL (b.dist_tsi, 0)
                              - ROUND (  NVL (a.tsi_amt, 0)
                                       * ROUND (NVL (b.dist_spct, 0), 9)
                                       / 100,
                                       2
                                      )
                             ) > v_tol_discrep
                        )
                     OR (ABS (  NVL (b.dist_prem, 0)
                              - ROUND
                                    (  NVL (a.prem_amt, 0)
                                     * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                       'Y', NVL (b.dist_spct1,
                                                                 0
                                                                ),
                                                       NVL (b.dist_spct, 0)
                                                      )
                                              ),
                                              9
                                             )
                                     / 100,
                                     2
                                    )
                             ) > v_tol_discrep
                        )
                    ))
         LOOP
            v_discrep := 'Y';
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_pdist_wperildtl;

/* ===================================================================================================================================
**  Dist Validation - Verification of amounts based on manual computation - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valcnt_orsk_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_ITEMPERILDS_DTL ( One Risk Distribution)
                  Modules affected : All peril distribution modules
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_valcnt_orsk_f_itmprldtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_valcnt_orsk_f_itmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 0.05;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_ITEMPERILDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit. ( One Risk Dist )';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_orsk_f_itmprldtl [ Validating the amounts of GIUW_ITEMPERILDS_DTL - One Risk Distribution  ]  ................'
            );

         FOR cur IN
            (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                    a.share_cd, a.dist_spct pol_distspct,
                    a.dist_spct1 pol_distspct1, a.computed_tsi,
                    a.computed_prem, b.dist_spct itmperl_distspct,
                    b.dist_spct1 itmperil_distspct1,
                    b.dist_tsi itmperil_disttsi,
                    b.dist_prem itmperil_distprem,
                    NVL (a.dist_spct, 0)
                    - NVL (b.dist_spct, 0) diff_dist_spct,
                      NVL (a.dist_spct1, 0)
                    - NVL (b.dist_spct1, 0) diff_dist_spct1,
                    NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                            x.share_cd, x.dist_spct, x.dist_spct1,
                            ROUND (  NVL (y.tsi_amt, 0)
                                   * ROUND (NVL (x.dist_spct, 0), 9)
                                   / 100,
                                   2
                                  ) computed_tsi,
                            (ROUND (  NVL (y.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (x.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (x.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                            ) computed_prem
                       FROM giuw_policyds_dtl x, giuw_itemperilds y
                      WHERE x.dist_no = p_dist_no
                        AND x.dist_no = y.dist_no
                        AND x.dist_seq_no = y.dist_seq_no) a,
                    giuw_itemperilds_dtl b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.item_no = b.item_no(+)
                AND a.peril_cd = b.peril_cd(+)
                AND a.share_cd = b.share_cd(+)
                AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <> 0)
                     OR (NVL (a.dist_spct1, 0) - NVL (b.dist_spct1, 0) <> 0)
                     OR (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                        )
                     OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                        )
                    )
             UNION
             SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd,
                    y.share_cd, 0 pol_distspct, 0 pol_distspct1,
                    0 computed_tsi, 0 computed_prem,
                    y.dist_spct itmperil_distspct,
                    y.dist_spct1 itmperil_distspct1,
                    y.dist_tsi itmperil_disttsi,
                    y.dist_prem itmperil_distprem,
                    0 - NVL (y.dist_spct, 0) diff_dist_spct,
                    0 - NVL (y.dist_spct1, 0) diff_dist_spct1,
                    0 - NVL (y.dist_tsi, 0) diff_tsi,
                    0 - NVL (y.dist_prem, 0) diff_prem
               FROM giuw_policyds_dtl x, giuw_itemperilds_dtl y
              WHERE y.dist_no = p_dist_no
                AND x.dist_no(+) = y.dist_no
                AND x.dist_seq_no(+) = y.dist_seq_no
                AND x.share_cd(+) = y.share_cd
                AND NOT EXISTS (
                       SELECT 1
                         FROM giuw_policyds_dtl p
                        WHERE p.dist_no = y.dist_no
                          AND p.dist_seq_no = y.dist_seq_no
                          AND p.share_cd = y.share_cd))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_orsk_f_itmprldtl;

   PROCEDURE p_valcnt_orsk_f_poldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_POLICYDS_DTL ( One Risk Distribution)
                    Modules affected : All peril distribution modules
               */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_valcnt_orsk_f_poldtl');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_valcnt_orsk_f_poldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 1;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_POLICYDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit. ( One Risk Dist )';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_orsk_f_poldtl [ Validating the amounts of GIUW_POLICYDS_DTL - One Risk Distribution  ]  ................'
            );

         FOR dist IN
            (SELECT a.dist_no, a.dist_seq_no, c.trty_name, c.share_cd,
                    b.dist_spct, b.dist_tsi, b.dist_prem,
                    ROUND (  NVL (a.tsi_amt, 0)
                           * ROUND (NVL (b.dist_spct, 0), 9)
                           / 100,
                           2
                          ) computed_tsi,
                    ROUND
                       (  NVL (a.prem_amt, 0)
                        * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                          'Y', NVL (b.dist_spct1, 0),
                                          NVL (b.dist_spct, 0)
                                         )
                                 ),
                                 9
                                )
                        / 100,
                        2
                       ) computed_prem,
                      NVL (b.dist_tsi, 0)
                    - ROUND (  NVL (a.tsi_amt, 0)
                             * ROUND (NVL (b.dist_spct, 0), 9)
                             / 100,
                             2
                            ) diff_tsi,
                      NVL (b.dist_prem, 0)
                    - ROUND (  NVL (a.prem_amt, 0)
                             * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                               'Y', NVL (b.dist_spct1, 0),
                                               NVL (b.dist_spct, 0)
                                              )
                                      ),
                                      9
                                     )
                             / 100,
                             2
                            ) diff_prem,
                      NVL (b.dist_spct, 0)
                    - ROUND (NVL (b.dist_spct, 0), 9) diff_spct,
                      NVL (b.dist_spct1, 0)
                    - ROUND (NVL (b.dist_spct1, 0), 9) diff_spct1
               FROM giuw_policyds a, giuw_policyds_dtl b, giis_dist_share c
              WHERE a.dist_no = b.dist_no
                AND a.dist_seq_no = b.dist_seq_no
                AND b.line_cd = c.line_cd
                AND b.share_cd = c.share_cd
                AND a.dist_no = p_dist_no
                AND (   (NVL (b.dist_spct, 0)
                         - ROUND (NVL (b.dist_spct, 0), 9) <> 0
                        )
                     OR (  NVL (b.dist_spct1, 0)
                         - ROUND (NVL (b.dist_spct1, 0), 9) <> 0
                        )
                     OR (ABS (  NVL (b.dist_tsi, 0)
                              - ROUND (  NVL (a.tsi_amt, 0)
                                       * ROUND (NVL (b.dist_spct, 0), 9)
                                       / 100,
                                       2
                                      )
                             ) > v_tol_discrep
                        )
                     OR (ABS (  NVL (b.dist_prem, 0)
                              - ROUND
                                    (  NVL (a.prem_amt, 0)
                                     * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                       'Y', NVL (b.dist_spct1,
                                                                 0
                                                                ),
                                                       NVL (b.dist_spct, 0)
                                                      )
                                              ),
                                              9
                                             )
                                     / 100,
                                     2
                                    )
                             ) > v_tol_discrep
                        )
                    ))
         LOOP
            v_discrep := 'Y';
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_orsk_f_poldtl;

   PROCEDURE p_valcnt_pdist_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_ITEMPERILDS_DTL ( Peril Distribution)
                Modules affected : All peril distribution modules
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_valcnt_pdist_f_itmprldtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_valcnt_pdist_f_itmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 0.05;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_ITEMPERILDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit.';

      IF p_dist_type = 'P' AND p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_pdist_f_itmprldtl [ validating the amounts in GIUW_ITEMPERILDS_DTL (Peril Dist) ] ...........'
            );

         FOR cur IN
            (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                    a.share_cd, a.dist_spct pol_distspct,
                    a.dist_spct1 pol_distspct1, a.computed_tsi,
                    a.computed_prem, b.dist_spct itmperl_distspct,
                    b.dist_spct1 itmperil_distspct1,
                    b.dist_tsi itmperil_disttsi,
                    b.dist_prem itmperil_distprem,
                    NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0) diff_tsi,
                    NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0) diff_prem
               FROM (SELECT x.dist_no, x.dist_seq_no, y.item_no, y.peril_cd,
                            x.share_cd, x.dist_spct, x.dist_spct1,
                            ROUND (  NVL (y.tsi_amt, 0)
                                   * ROUND (NVL (x.dist_spct, 0), 9)
                                   / 100,
                                   2
                                  ) computed_tsi,
                            (ROUND (  NVL (y.prem_amt, 0)
                                    * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                      'Y', NVL (x.dist_spct1,
                                                                0
                                                               ),
                                                      NVL (x.dist_spct, 0)
                                                     )
                                             ),
                                             9
                                            )
                                    / 100,
                                    2
                                   )
                            ) computed_prem
                       FROM giuw_perilds_dtl x, giuw_itemperilds y
                      WHERE x.dist_no = p_dist_no
                        AND x.dist_no = y.dist_no
                        AND x.dist_seq_no = y.dist_seq_no
                        AND x.peril_cd = y.peril_cd) a,
                    giuw_itemperilds_dtl b
              WHERE a.dist_no = b.dist_no(+)
                AND a.dist_seq_no = b.dist_seq_no(+)
                AND a.item_no = b.item_no(+)
                AND a.peril_cd = b.peril_cd(+)
                AND a.share_cd = b.share_cd(+)
                AND (   (ABS (NVL (a.computed_tsi, 0) - NVL (b.dist_tsi, 0)) >
                                                                 v_tol_discrep
                        )
                     OR (ABS (NVL (a.computed_prem, 0) - NVL (b.dist_prem, 0)) >
                                                                 v_tol_discrep
                        )
                    )
             UNION
             SELECT y.dist_no, y.dist_seq_no, y.item_no, y.peril_cd,
                    y.share_cd, 0 pol_distspct, 0 pol_distspct1,
                    0 computed_tsi, 0 computed_prem,
                    y.dist_spct itmperil_distspct,
                    y.dist_spct1 itmperil_distspct1,
                    y.dist_tsi itmperil_disttsi,
                    y.dist_prem itmperil_distprem,
                    0 - NVL (y.dist_tsi, 0) diff_tsi,
                    0 - NVL (y.dist_prem, 0) diff_prem
               FROM giuw_perilds_dtl x, giuw_itemperilds_dtl y
              WHERE y.dist_no = p_dist_no
                AND x.dist_no(+) = y.dist_no
                AND x.dist_seq_no(+) = y.dist_seq_no
                AND x.share_cd(+) = y.share_cd
                AND x.peril_cd(+) = y.peril_cd
                AND NOT EXISTS (
                       SELECT 1
                         FROM giuw_perilds_dtl p
                        WHERE p.dist_no = y.dist_no
                          AND p.dist_seq_no = y.dist_seq_no
                          AND p.share_cd = y.share_cd
                          AND p.peril_cd = y.peril_cd))
         LOOP
            v_discrep := 'Y';
            EXIT;
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_pdist_f_itmprldtl;

   PROCEDURE p_valcnt_pdist_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate the data stored in GIUW_PERILDS_DTL ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_valcnt_pdist_f_perildtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_valcnt_pdist_f_perildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_tol_discrep    giuw_pol_dist.tsi_amt%TYPE               := 1;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There is a discrepancy between GIUW_PERILDS_DTL amounts against expected amounts. Discrepancy is beyond tolerable limit. ( Peril Distribution )';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_pdist_f_perildtl [ Validating the amounts of GIUW_PERILDS_DTL (Peril Distribution) against expected amounts  ]  ................'
            );

         FOR dist IN
            (SELECT a.dist_no, a.dist_seq_no, a.peril_cd, c.trty_name,
                    c.share_cd, b.dist_spct, b.dist_tsi, b.dist_prem,
                    ROUND (  NVL (a.tsi_amt, 0)
                           * ROUND (NVL (b.dist_spct, 0), 9)
                           / 100,
                           2
                          ) computed_tsi,
                    ROUND
                       (  NVL (a.prem_amt, 0)
                        * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                          'Y', NVL (b.dist_spct1, 0),
                                          NVL (b.dist_spct, 0)
                                         )
                                 ),
                                 9
                                )
                        / 100,
                        2
                       ) computed_prem,
                      NVL (b.dist_tsi, 0)
                    - ROUND (  NVL (a.tsi_amt, 0)
                             * ROUND (NVL (b.dist_spct, 0), 9)
                             / 100,
                             2
                            ) diff_tsi,
                      NVL (b.dist_prem, 0)
                    - ROUND (  NVL (a.prem_amt, 0)
                             * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                               'Y', NVL (b.dist_spct1, 0),
                                               NVL (b.dist_spct, 0)
                                              )
                                      ),
                                      9
                                     )
                             / 100,
                             2
                            ) diff_prem
               FROM giuw_perilds a, giuw_perilds_dtl b, giis_dist_share c
              WHERE 1 = 1
                AND a.dist_no = p_dist_no
                AND a.dist_no = b.dist_no
                AND a.dist_seq_no = b.dist_seq_no
                AND a.peril_cd = b.peril_cd
                AND b.line_cd = c.line_cd
                AND b.share_cd = c.share_cd
                AND (   (ABS (  NVL (b.dist_tsi, 0)
                              - ROUND (  NVL (a.tsi_amt, 0)
                                       * ROUND (NVL (b.dist_spct, 0), 9)
                                       / 100,
                                       2
                                      )
                             ) > v_tol_discrep
                        )
                     OR (ABS (  NVL (b.dist_prem, 0)
                              - ROUND
                                    (  NVL (a.prem_amt, 0)
                                     * ROUND ((DECODE (p_dist_by_tsi_prem_sw,
                                                       'Y', NVL (b.dist_spct1,
                                                                 0
                                                                ),
                                                       NVL (b.dist_spct, 0)
                                                      )
                                              ),
                                              9
                                             )
                                     / 100,
                                     2
                                    )
                             ) > v_tol_discrep
                        )
                    ))
         LOOP
            v_discrep := 'Y';
         END LOOP;

         IF v_discrep = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_pdist_f_perildtl;

    /* ===================================================================================================================================
   **  Dist Validation - Comparison of Sign against Amount Stored in Tables - Working Distribution Tables
   ** ==================================================================================================================================*/
   PROCEDURE p_valcnt_sign_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists amounts in GIUW_ITEMPERILDS_DTL with different sign than parent DS record
                      Modules affected : All peril distribution modules
                 */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_valcnt_sign_witmprldtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_valcnt_sign_witmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with different sign in GIUW_WITEMPERILDS_DTL than amount in GIUW_WITEMPERILDS.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_sign_witmprldtl [ Checking the existence of records in GIUW_WITEMPERILDS_DTL with different sign than DS  ]  ................'
            );

         FOR dist IN (SELECT 1
                        FROM giuw_witemperilds_dtl a, giuw_witemperilds b
                       WHERE a.dist_no = p_dist_no
                         AND a.dist_no = b.dist_no
                         AND a.dist_seq_no = b.dist_seq_no
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND (   ( SIGN (a.dist_tsi) <> SIGN (b.tsi_amt) and a.dist_tsi <> 0 )   -- jhing 07.03.2014 added exclusion of zero amt
                              OR ( SIGN (a.dist_prem) <> SIGN (b.prem_amt) and a.dist_prem <> 0 ) 
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_sign_witmprldtl;

/* ===================================================================================================================================
**  Dist Validation - Comparison of Sign against Amount Stored in Tables - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valcnt_sign_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists amounts in GIUW_ITEMPERILDS_DTL with different sign than parent DS record
                      Modules affected : All peril distribution modules
                 */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_valcnt_sign_f_itmprldtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_valcnt_sign_f_itmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with different sign in GIUW_ITEMPERILDS_DTL than amount in GIUW_ITEMPERILDS.';

      IF p_action = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valcnt_sign_f_itmprldtl [ Checking the existence of records in GIUW_ITEMPERILDS_DTL with different sign than DS  ]  ................'
            );

         FOR dist IN (SELECT 1
                        FROM giuw_itemperilds_dtl a, giuw_itemperilds b
                       WHERE a.dist_no = p_dist_no
                         AND a.dist_no = b.dist_no
                         AND a.dist_seq_no = b.dist_seq_no
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND (  (  SIGN (a.dist_tsi) <> SIGN (b.tsi_amt)  and a.dist_tsi <> 0  )  -- jhing 07.03.2014 added restriction on zero amount
                              OR (  SIGN (a.dist_prem) <> SIGN (b.prem_amt) and a.dist_prem <> 0 )   -- jhing 07.03.2014 added restriction on zero amount
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valcnt_sign_f_itmprldtl;

/* ===================================================================================================================================
**  Dist Validation - Consistency of Share % in Distribution - Working Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valconst_shr_witemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if share in GIUW_WITEMDS_DTL matches GIUW_WPOLICYDS_DTL ( if there are records in GIUW_WITEMDS_DTL which
                      different share %.

                       Modules affected : All peril distribution modules
                  */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)     := UPPER ('f_valconst_shr_witemdtl');
      v_calling_proc   VARCHAR2 (30)     := UPPER ('p_valconst_shr_witemdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with inconsistent share% between GIUW_WPOLICYDS_DTL and GIUW_WITEMDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valconst_shr_witemdtl [ Checking of discrepancy of share % between GIUW_WPOLICYDS_DTL and GIUW_WITEMDS_DTL  ]  ................'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                             b.dist_spct, b.dist_spct1,
                               NVL (a.dist_spct, 0)
                             - NVL (b.dist_spct, 0) diff_spct,
                               NVL (a.dist_spct1, 0)
                             - NVL (b.dist_spct1, 0) diff_spct1
                        FROM giuw_witemds_dtl a, giuw_wpolicyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no
                         AND b.dist_seq_no = a.dist_seq_no
                         AND b.share_cd = a.share_cd
                         AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                                 )
                              OR (NVL (a.dist_spct1, 0)
                                  - NVL (b.dist_spct1, 0) <> 0
                                 )
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valconst_shr_witemdtl;

   PROCEDURE p_valconst_shr_witmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if share in GIUW_WITEMPERILDS_DTL matches GIUW_WPOLICYDS_DTL ( if there are records in GIUW_WITEMPERILDS_DTL which
                      different share %. )

                       Modules affected : All peril distribution modules
                  */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_valconst_shr_witmprldtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_valconst_shr_witmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with inconsistent share% bet. GIUW_WPOLICYDS_DTL and GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valconst_shr_witmprldtl [Checking of discrepancy of share % between GIUW_WPOLICYDS_DTL and GIUW_WITEMPERILDS_DTL] .........'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                             b.dist_spct, b.dist_spct1,
                               NVL (a.dist_spct, 0)
                             - NVL (b.dist_spct, 0) diff_spct,
                               NVL (a.dist_spct1, 0)
                             - NVL (b.dist_spct1, 0) diff_spct1
                        FROM giuw_witemperilds_dtl a, giuw_wpolicyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no
                         AND b.dist_seq_no = a.dist_seq_no
                         AND b.share_cd = a.share_cd
                         AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                                 )
                              OR (NVL (a.dist_spct1, 0)
                                  - NVL (b.dist_spct1, 0) <> 0
                                 )
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valconst_shr_witmprldtl;

   PROCEDURE p_valconst_shr_wperildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if share in GIUW_PERILDS_DTL matches GIUW_POLICYDS_DTL( if there are records in GIUW_ITEMPERILDS_DTL which
                      different share %. )
                       Modules affected : All peril distribution modules
                  */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_valconst_shr_wperildtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_valconst_shr_wperildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with inconsistent share% bet. GIUW_WPERILDS_DTL and GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valconst_shr_wperildtl [ Checking of discrepancy of share % between GIUW_WPERILDS_DTL and GIUW_WPOLICYDS_DTL  ]  ..........'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.peril_cd, b.share_cd,
                             b.dist_spct, b.dist_spct1,
                               NVL (a.dist_spct, 0)
                             - NVL (b.dist_spct, 0) diff_spct,
                               NVL (a.dist_spct1, 0)
                             - NVL (b.dist_spct1, 0) diff_spct1
                        FROM giuw_wperilds_dtl a, giuw_wpolicyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no
                         AND b.dist_seq_no = a.dist_seq_no
                         AND b.share_cd = a.share_cd
                         AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                                 )
                              OR (NVL (a.dist_spct1, 0)
                                  - NVL (b.dist_spct1, 0) <> 0
                                 )
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valconst_shr_wperildtl;

   PROCEDURE p_vcomp_shr_witmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_WITEMDS_DTL matches computed share % - DIST_SPCT ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_vcomp_shr_witmdtl01');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_vcomp_shr_witmdtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT) in GIUW_WITEMDS_DTL (Peril Distribution).';

      IF p_dist_type = 'P' AND p_action = 'S'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing  procedure p_vcomp_shr_witmdtl01 [ Checking of computation of share % for GIUW_WITEMDS_DTL (Peril Dist)  ]  ................'
            );

         FOR curdist IN
            (SELECT   p.dist_no, p.dist_seq_no, p.item_no, COUNT (*) cnt
                 FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                              c.trty_name,
                              DECODE
                                 (a.tsi_amt,
                                  0, (DECODE (a.prem_amt,
                                              0, 0,
                                              ROUND ((  NVL (b.dist_prem, 0)
                                                      / a.prem_amt
                                                      * 100
                                                     ),
                                                     9
                                                    )
                                             )
                                   ),
                                  ROUND ((NVL (b.dist_tsi, 0) / a.tsi_amt
                                          * 100
                                         ),
                                         9
                                        )
                                 ) computed_dist_spct,
                              b.dist_spct item_spct,
                              TO_CHAR
                                 (  (DECODE
                                        (a.tsi_amt,
                                         0, (DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  )
                                          ),
                                         ROUND ((  NVL (b.dist_tsi, 0)
                                                 / a.tsi_amt
                                                 * 100
                                                ),
                                                9
                                               )
                                        )
                                    )
                                  - NVL (b.dist_spct, 0)
                                 ) diff_spct
                         FROM giuw_witemds a,
                              giuw_witemds_dtl b,
                              giis_dist_share c
                        WHERE a.dist_no = p_dist_no
                          AND a.dist_no = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND a.item_no = b.item_no
                          AND b.line_cd = c.line_cd
                          AND b.share_cd = c.share_cd) p
                WHERE p.diff_spct <> '0'
             GROUP BY p.dist_no, p.dist_seq_no, p.item_no)
         LOOP
            IF curdist.cnt > 1
            THEN
               v_cnt_distinct := curdist.cnt;
               EXIT;
            END IF;
         END LOOP;

         IF v_cnt_distinct > 1
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcomp_shr_witmdtl01;

   PROCEDURE p_vcomp_shr_witmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_WITEMDS_DTL matches computed share % - DIST_SPCT ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_vcomp_shr_witmdtl02');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_vcomp_shr_witmdtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT1) in GIUW_WITEMDS_DTL (Peril Distribution).';

      IF     p_dist_type = 'P'
         AND p_action = 'S'
         AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_witmdtl02 [ Checking of computation of share % for GIUW_WITEMDS_DTL02 (Peril Dist)  ]  ................'
            );

         FOR curdist IN
            (SELECT   p.dist_no, p.dist_seq_no, p.item_no, COUNT (*) cnt
                 FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                              c.trty_name,
                              DECODE
                                 (a.prem_amt,
                                  0, (DECODE (a.tsi_amt,
                                              0, 0,
                                              ROUND ((  NVL (b.dist_tsi, 0)
                                                      / a.tsi_amt
                                                      * 100
                                                     ),
                                                     9
                                                    )
                                             )
                                   ),
                                  ROUND ((  NVL (b.dist_prem, 0)
                                          / a.prem_amt
                                          * 100
                                         ),
                                         9
                                        )
                                 ) computed_dist_spct1,
                              b.dist_spct1 item_spct1,
                              TO_CHAR
                                 (  (DECODE
                                         (a.prem_amt,
                                          0, (DECODE
                                                   (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                           ),
                                          ROUND ((  NVL (b.dist_prem, 0)
                                                  / a.prem_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         )
                                    )
                                  - NVL (b.dist_spct1, 0)
                                 ) diff_spct1
                         FROM giuw_witemds a,
                              giuw_witemds_dtl b,
                              giis_dist_share c
                        WHERE a.dist_no = p_dist_no
                          AND a.dist_no = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND a.item_no = b.item_no
                          AND b.line_cd = c.line_cd
                          AND b.share_cd = c.share_cd) p
                WHERE p.diff_spct1 <> '0'
             GROUP BY p.dist_no, p.dist_seq_no, p.item_no)
         LOOP
            IF curdist.cnt > 1
            THEN
               v_cnt_distinct := curdist.cnt;
               EXIT;
            END IF;
         END LOOP;

         IF v_cnt_distinct > 1
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcomp_shr_witmdtl02;

   PROCEDURE p_vcomp_shr_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_POLICYDS_DTL matches computed share % - DIST_SPCT ( Peril Distribution)
                   Modules affected : All peril distribution modules
              */
      v_findings       VARCHAR2 (4000);
      v_findings1      VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_vcomp_shr_wpoldtl01');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_vcomp_shr_wpoldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_zero_share     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE             := NULL;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT) in GIUW_POLICYDS_DTL (Peril Distribution).';

      IF     p_dist_type = 'P'
         AND p_action = 'S'            -- begin tc1 - p_dist_type and p_action
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_wpoldtl01 [ Checking of computation of share % for GIUW_WPOLICYDS_DTL (Peril Dist)  ]  ................'
            );

         FOR curdist IN
            (SELECT   p.dist_no, p.dist_seq_no, COUNT (*) cnt
                 FROM (SELECT   a.dist_no, a.dist_seq_no, b.share_cd,
                                c.trty_name,
                                DECODE
                                   (a.tsi_amt,
                                    0, DECODE (a.prem_amt,
                                               0, 0,
                                               ROUND ((  NVL (b.dist_prem, 0)
                                                       / a.prem_amt
                                                       * 100
                                                      ),
                                                      9
                                                     )
                                              ),
                                    ROUND ((  NVL (b.dist_tsi, 0)
                                            / a.tsi_amt
                                            * 100
                                           ),
                                           9
                                          )
                                   ) computed_share,
                                b.dist_spct pol_spct,
                                TO_CHAR
                                   (  (DECODE
                                          (a.tsi_amt,
                                           0, DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  ),
                                           ROUND ((  NVL (b.dist_tsi, 0)
                                                   / a.tsi_amt
                                                   * 100
                                                  ),
                                                  9
                                                 )
                                          )
                                      )
                                    - b.dist_spct
                                   ) diff_spct
                           FROM giuw_wpolicyds a,
                                giuw_wpolicyds_dtl b,
                                giis_dist_share c
                          WHERE a.dist_no = p_dist_no
                            AND a.dist_no = b.dist_no
                            AND a.dist_seq_no = b.dist_seq_no
                            AND b.line_cd = c.line_cd
                            AND b.share_cd = c.share_cd
                       ORDER BY a.dist_no, a.dist_seq_no, b.share_cd) p
                WHERE p.diff_spct <> '0'
             GROUP BY p.dist_no, p.dist_seq_no)
         LOOP
            IF curdist.cnt > 1
            THEN
               v_cnt_distinct := curdist.cnt;
               EXIT;
            END IF;
         END LOOP;

         IF v_cnt_distinct > 1                   -- begin tc3 - v_cnt_distinct
         THEN
            v_output := v_result_failed;
         END IF;                                  -- end  tc3 - v_cnt_distinct

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;                            -- end tc1 - p_dist_type and p_action
   END p_vcomp_shr_wpoldtl01;

   PROCEDURE p_vcomp_shr_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_POLICYDS_DTL matches computed share % - DIST_SPCT1( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)       := UPPER ('f_vcomp_shr_wpoldtl02');
      v_calling_proc   VARCHAR2 (30)       := UPPER ('p_vcomp_shr_wpoldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT1) in GIUW_WPOLICYDS_DTL (Peril Distribution).';

      IF     p_dist_type = 'P'
         AND p_action = 'S'
         AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_wpoldtl02 [ Checking of computation of share % for GIUW_WPOLICYDS - DSIT_SPCT1 (Peril Dist)  ]  ................'
            );

         FOR curdist IN
            (SELECT   p.dist_no, p.dist_seq_no, COUNT (*) cnt
                 FROM (SELECT a.dist_no, a.dist_seq_no, b.share_cd,
                              c.trty_name,
                              DECODE
                                 (a.prem_amt,
                                  0, (DECODE (a.tsi_amt,
                                              0, 0,
                                              ROUND ((  NVL (b.dist_tsi, 0)
                                                      / a.tsi_amt
                                                      * 100
                                                     ),
                                                     9
                                                    )
                                             )
                                   ),
                                  ROUND ((  NVL (b.dist_prem, 0)
                                          / a.prem_amt
                                          * 100
                                         ),
                                         9
                                        )
                                 ) computed_dist_spct1,
                              b.dist_spct1 item_spct1,
                              TO_CHAR
                                 (  (DECODE
                                         (a.prem_amt,
                                          0, (DECODE
                                                   (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                           ),
                                          ROUND ((  NVL (b.dist_prem, 0)
                                                  / a.prem_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         )
                                    )
                                  - NVL (b.dist_spct1, 0)
                                 ) diff_spct1
                         FROM giuw_wpolicyds a,
                              giuw_wpolicyds_dtl b,
                              giis_dist_share c
                        WHERE a.dist_no = p_dist_no
                          AND a.dist_no = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND b.line_cd = c.line_cd
                          AND b.share_cd = c.share_cd) p
                WHERE p.diff_spct1 <> '0'
             GROUP BY p.dist_no, p.dist_seq_no)
         LOOP
            IF curdist.cnt > 1
            THEN
               v_cnt_distinct := curdist.cnt;
               EXIT;
            END IF;
         END LOOP;

         IF v_cnt_distinct > 1
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcomp_shr_wpoldtl02;

/* ===================================================================================================================================
**  Dist Validation - Consistency of Share % in Distribution - Final Distribution Tables
** ==================================================================================================================================*/
   PROCEDURE p_valconst_shr_f_itemdtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if share in GIUW_ITEMDS_DTL matches GIUW_POLICYDS_DTL ( if there are records in GIUW_ITEMDS_DTL which
                    different share %.

                     Modules affected : All peril distribution modules
                */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_valconst_shr_f_itemdtl');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_valconst_shr_f_itemdtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with inconsistent share% between GIUW_POLICYDS_DTL and GIUW_ITEMDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valconst_shr_f_itemdtl [ Checking of discrepancy of share % between GIUW_POLICYDS_DTL and GIUW_ITEMDS_DTL  ]  ................'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                             b.dist_spct, b.dist_spct1,
                               NVL (a.dist_spct, 0)
                             - NVL (b.dist_spct, 0) diff_spct,
                               NVL (a.dist_spct1, 0)
                             - NVL (b.dist_spct1, 0) diff_spct1
                        FROM giuw_itemds_dtl a, giuw_policyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no
                         AND b.dist_seq_no = a.dist_seq_no
                         AND b.share_cd = a.share_cd
                         AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                                 )
                              OR (NVL (a.dist_spct1, 0)
                                  - NVL (b.dist_spct1, 0) <> 0
                                 )
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valconst_shr_f_itemdtl;

   PROCEDURE p_valconst_shr_f_itmprldtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if share in GIUW_ITEMPERILDS_DTL matches GIUW_POLICYDS_DTL ( if there are records in GIUW_ITEMPERILDS_DTL which
                    different share %.

                     Modules affected : All peril distribution modules
                */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)  := UPPER ('f_valconst_shr_f_itmprldtl');
      v_calling_proc   VARCHAR2 (30)  := UPPER ('p_valconst_shr_f_itmprldtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with inconsistent share% between GIUW_POLICYDS_DTL and GIUW_ITEMPERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valconst_shr_f_itemdtl [ Checking of discrepancy of share % between GIUW_POLICYDS_DTL and GIUW_ITEMPERILDS_DTL  ]  ................'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.item_no, b.share_cd,
                             b.dist_spct, b.dist_spct1,
                               NVL (a.dist_spct, 0)
                             - NVL (b.dist_spct, 0) diff_spct,
                               NVL (a.dist_spct1, 0)
                             - NVL (b.dist_spct1, 0) diff_spct1
                        FROM giuw_itemperilds_dtl a, giuw_policyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no
                         AND b.dist_seq_no = a.dist_seq_no
                         AND b.share_cd = a.share_cd
                         AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                                 )
                              OR (NVL (a.dist_spct1, 0)
                                  - NVL (b.dist_spct1, 0) <> 0
                                 )
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valconst_shr_f_itmprldtl;

   PROCEDURE p_valconst_shr_f_perildtl (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if share in GIUW_PERILDS_DTL matches GIUW_POLICYDS_DTL( if there are records in GIUW_ITEMPERILDS_DTL which
                    different share %. )
                     Modules affected : All one risk distribution modules
                */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)   := UPPER ('f_valconst_shr_f_perildtl');
      v_calling_proc   VARCHAR2 (30)   := UPPER ('p_valconst_shr_f_perildtl');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with inconsistent share% between GIUW_PERILDS_DTL and GIUW_POLICYDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_valconst_shr_f_perildtl [ Checking of discrepancy of share % between GIUW_PERILDS_DTL and GIUW_POLICYDS_DTL  ]  ................'
            );

         FOR dist IN (SELECT b.dist_no, b.dist_seq_no, a.peril_cd, b.share_cd,
                             b.dist_spct, b.dist_spct1,
                               NVL (a.dist_spct, 0)
                             - NVL (b.dist_spct, 0) diff_spct,
                               NVL (a.dist_spct1, 0)
                             - NVL (b.dist_spct1, 0) diff_spct1
                        FROM giuw_perilds_dtl a, giuw_policyds_dtl b
                       WHERE 1 = 1
                         AND b.dist_no = p_dist_no
                         AND b.dist_no = a.dist_no
                         AND b.dist_seq_no = a.dist_seq_no
                         AND b.share_cd = a.share_cd
                         AND (   (NVL (a.dist_spct, 0) - NVL (b.dist_spct, 0) <>
                                                                             0
                                 )
                              OR (NVL (a.dist_spct1, 0)
                                  - NVL (b.dist_spct1, 0) <> 0
                                 )
                             ))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_valconst_shr_f_perildtl;

   PROCEDURE p_vcomp_shr_f_itmdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_ITEMDS_DTL matches computed share % - DIST_SPCT ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_findings1      VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_vcomp_shr_f_itmdtl01');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_vcomp_shr_f_itmdtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_zero_share     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE             := NULL;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT) in GIUW_ITEMDS_DTL (Peril Distribution).';
      v_findings1 :=
         'There are distribution records in GIUW_WITEMDS_DTL with zero share %. Distribution should not exists in GIUW_ITEMDS_DTL.';
      v_findings2 :=
         'There are distribution records in GIUW_WITEMDS_DTL with zero share %. Distribution should not be posted and GIUW_POL_DIST.DIST_FLAG should still be undistributed.';

      IF     p_dist_type = 'P'
         AND p_action = 'P'            -- begin tc1 - p_dist_type and p_action
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_f_itmdtl01 [ Checking of computation of share % for GIUW_ITEMDS_DTL (Peril Dist)  ]  ................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         -- begin tc1_01 - p_dist_by_tsi_prem
         THEN
            FOR chck IN (SELECT 1
                           FROM giuw_witemds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_zero_share := 'Y';
               EXIT;
            END LOOP;

            IF v_zero_share = 'Y'                 -- begin tc1_02 - zero share
            THEN
               FOR chck2 IN (SELECT 1
                               FROM giuw_itemds_dtl
                              WHERE dist_no = p_dist_no)
               LOOP
                  v_exists_rec := 'Y';
                  EXIT;
               END LOOP;

               IF v_exists_rec = 'Y'
               -- begin tc1_03 - record exists in final table
               THEN
                  v_output := v_result_failed;                   -- findings1
               ELSE
                  FOR poldist IN (SELECT dist_flag
                                    FROM giuw_pol_dist
                                   WHERE dist_no = p_dist_no)
                  LOOP
                     v_dist_flag := poldist.dist_flag;
                     EXIT;
                  END LOOP;

                  IF v_dist_flag IN ('2', '3') --  -- begin tc1_04 - dist_flag
                  THEN
                     v_output := v_result_failed;                -- findings2
                  END IF;                           -- end  tc1_04 - dist_flag
               END IF;           -- end  tc1_03 - record exists in final table
            END IF;                                -- end  tc1_02 - zero share
         END IF;                           -- end  tc1_01 - p_dist_by_tsi_prem

         IF v_zero_share = 'N'                    -- begin tc2 -- v_zero_share
         THEN
            FOR curdist IN
               (SELECT   p.dist_no, p.dist_seq_no, p.item_no, COUNT (*) cnt
                    FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                 b.share_cd, c.trty_name,
                                 DECODE
                                    (a.tsi_amt,
                                     0, (DECODE (a.prem_amt,
                                                 0, 0,
                                                 ROUND ((  NVL (b.dist_prem,
                                                                0)
                                                         / a.prem_amt
                                                         * 100
                                                        ),
                                                        9
                                                       )
                                                )
                                      ),
                                     ROUND ((  NVL (b.dist_tsi, 0)
                                             / a.tsi_amt
                                             * 100
                                            ),
                                            9
                                           )
                                    ) computed_dist_spct,
                                 b.dist_spct item_spct,
                                 TO_CHAR
                                    (  (DECODE
                                           (a.tsi_amt,
                                            0, (DECODE
                                                   (a.prem_amt,
                                                    0, 0,
                                                    ROUND
                                                         ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                   )
                                             ),
                                            ROUND ((  NVL (b.dist_tsi, 0)
                                                    / a.tsi_amt
                                                    * 100
                                                   ),
                                                   9
                                                  )
                                           )
                                       )
                                     - NVL (b.dist_spct, 0)
                                    ) diff_spct
                            FROM giuw_itemds a,
                                 giuw_itemds_dtl b,
                                 giis_dist_share c
                           WHERE a.dist_no = p_dist_no
                             AND a.dist_no = b.dist_no
                             AND a.dist_seq_no = b.dist_seq_no
                             AND a.item_no = b.item_no
                             AND b.line_cd = c.line_cd
                             AND b.share_cd = c.share_cd) p
                   WHERE p.diff_spct <> '0'
                GROUP BY p.dist_no, p.dist_seq_no, p.item_no)
            LOOP
               IF curdist.cnt > 1
               THEN
                  v_cnt_distinct := curdist.cnt;
                  EXIT;
               END IF;
            END LOOP;

            IF v_cnt_distinct > 1                -- begin tc3 - v_cnt_distinct
            THEN
               v_output := v_result_failed;
            END IF;                               -- end  tc3 - v_cnt_distinct
         END IF;                                   -- end  tc2 -- v_zero_share

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;                            -- end tc1 - p_dist_type and p_action
   END p_vcomp_shr_f_itmdtl01;

   PROCEDURE p_vcomp_shr_f_itmdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_WITEMDS_DTL matches computed share % - DIST_SPCT ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_vcomp_shr_f_itmdtl02');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_vcomp_shr_f_itmdtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT1) in GIUW_ITEMDS_DTL (Peril Distribution).';

      IF     p_dist_type = 'P'
         AND p_action = 'P'
         AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_f_itmdtl02 [ Checking of computation of share % for GIUW_ITEMDS_DTL02 (Peril Dist)  ]  ................'
            );

         FOR curdist IN
            (SELECT   p.dist_no, p.dist_seq_no, p.item_no, COUNT (*) cnt
                 FROM (SELECT a.dist_no, a.dist_seq_no, a.item_no, b.share_cd,
                              c.trty_name,
                              DECODE
                                 (a.prem_amt,
                                  0, (DECODE (a.tsi_amt,
                                              0, 0,
                                              ROUND ((  NVL (b.dist_tsi, 0)
                                                      / a.tsi_amt
                                                      * 100
                                                     ),
                                                     9
                                                    )
                                             )
                                   ),
                                  ROUND ((  NVL (b.dist_prem, 0)
                                          / a.prem_amt
                                          * 100
                                         ),
                                         9
                                        )
                                 ) computed_dist_spct1,
                              b.dist_spct1 item_spct1,
                              TO_CHAR
                                 (  (DECODE
                                         (a.prem_amt,
                                          0, (DECODE
                                                   (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                           ),
                                          ROUND ((  NVL (b.dist_prem, 0)
                                                  / a.prem_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         )
                                    )
                                  - NVL (b.dist_spct1, 0)
                                 ) diff_spct1
                         FROM giuw_witemds a,
                              giuw_witemds_dtl b,
                              giis_dist_share c
                        WHERE a.dist_no = p_dist_no
                          AND a.dist_no = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND a.item_no = b.item_no
                          AND b.line_cd = c.line_cd
                          AND b.share_cd = c.share_cd) p
                WHERE p.diff_spct1 <> '0'
             GROUP BY p.dist_no, p.dist_seq_no, p.item_no)
         LOOP
            IF curdist.cnt > 1
            THEN
               v_cnt_distinct := curdist.cnt;
               EXIT;
            END IF;
         END LOOP;

         IF v_cnt_distinct > 1
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcomp_shr_f_itmdtl02;

   PROCEDURE p_vcomp_shr_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_POLICYDS_DTL matches computed share % - DIST_SPCT ( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_findings1      VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_vcomp_shr_f_poldtl01');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_vcomp_shr_f_poldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_zero_share     VARCHAR2 (1)                             := 'N';
      v_dist_flag      giuw_pol_dist.dist_flag%TYPE             := NULL;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT) in GIUW_POLICYDS_DTL (Peril Distribution).';
      v_findings1 :=
         'There are distribution records in GIUW_WPOLICYDS_DTL with zero share %. Distribution should not exists in GIUW_POLICYDS_DTL.';
      v_findings2 :=
         'There are distribution records in GIUW_WPOLICYDS_DTL with zero share %. Distribution should not be posted and GIUW_POL_DIST.DIST_FLAG should still be undistributed.';

      IF     p_dist_type = 'P'
         AND p_action = 'P'            -- begin tc1 - p_dist_type and p_action
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_f_poldtl01 [ Checking of computation of share % for GIUW_POLICYDS_DTL (Peril Dist)  ]  ................'
            );

         IF NVL (p_dist_by_tsi_prem_sw, 'N') = 'N'
         -- begin tc1_01 - p_dist_by_tsi_prem
         THEN
            FOR chck IN (SELECT 1
                           FROM giuw_wpolicyds_dtl
                          WHERE dist_no = p_dist_no AND dist_spct = 0)
            LOOP
               v_zero_share := 'Y';
               EXIT;
            END LOOP;

            IF v_zero_share = 'Y'                 -- begin tc1_02 - zero share
            THEN
               FOR chck2 IN (SELECT 1
                               FROM giuw_policyds_dtl
                              WHERE dist_no = p_dist_no)
               LOOP
                  v_exists_rec := 'Y';
                  EXIT;
               END LOOP;

               IF v_exists_rec = 'Y'
               -- begin tc1_03 - record exists in final table
               THEN
                  p_log_result (p_dist_no,
                                p_dist_by_tsi_prem_sw,
                                p_action,
                                p_dist_type,
                                p_distmod_type,
                                p_module_id,
                                p_user,
                                v_findings1,
                                v_query_fnc,
                                v_calling_proc,
                                v_output
                               );
               ELSE
                  FOR poldist IN (SELECT dist_flag
                                    FROM giuw_pol_dist
                                   WHERE dist_no = p_dist_no)
                  LOOP
                     v_dist_flag := poldist.dist_flag;
                     EXIT;
                  END LOOP;

                  IF v_dist_flag IN ('2', '3') --  -- begin tc1_04 - dist_flag
                  THEN
                     p_log_result (p_dist_no,
                                   p_dist_by_tsi_prem_sw,
                                   p_action,
                                   p_dist_type,
                                   p_distmod_type,
                                   p_module_id,
                                   p_user,
                                   v_findings2,
                                   v_query_fnc,
                                   v_calling_proc,
                                   v_output
                                  );
                  END IF;                           -- end  tc1_04 - dist_flag
               END IF;           -- end  tc1_03 - record exists in final table
            END IF;                                -- end  tc1_02 - zero share
         END IF;                           -- end  tc1_01 - p_dist_by_tsi_prem

         IF v_zero_share = 'N'                    -- begin tc2 -- v_zero_share
         THEN
            FOR curdist IN
               (SELECT   p.dist_no, p.dist_seq_no, COUNT (*) cnt
                    FROM (SELECT   a.dist_no, a.dist_seq_no, b.share_cd,
                                   c.trty_name,
                                   DECODE
                                      (a.tsi_amt,
                                       0, DECODE (a.prem_amt,
                                                  0, 0,
                                                  ROUND ((  NVL (b.dist_prem,
                                                                 0
                                                                )
                                                          / a.prem_amt
                                                          * 100
                                                         ),
                                                         9
                                                        )
                                                 ),
                                       ROUND ((  NVL (b.dist_tsi, 0)
                                               / a.tsi_amt
                                               * 100
                                              ),
                                              9
                                             )
                                      ) computed_share,
                                   b.dist_spct pol_spct,
                                   TO_CHAR
                                      (  (DECODE
                                             (a.tsi_amt,
                                              0, DECODE
                                                  (a.prem_amt,
                                                   0, 0,
                                                   ROUND ((  NVL (b.dist_prem,
                                                                  0
                                                                 )
                                                           / a.prem_amt
                                                           * 100
                                                          ),
                                                          9
                                                         )
                                                  ),
                                              ROUND ((  NVL (b.dist_tsi, 0)
                                                      / a.tsi_amt
                                                      * 100
                                                     ),
                                                     9
                                                    )
                                             )
                                         )
                                       - b.dist_spct
                                      ) diff_spct
                              FROM giuw_policyds a,
                                   giuw_policyds_dtl b,
                                   giis_dist_share c
                             WHERE a.dist_no = p_dist_no
                               AND a.dist_no = b.dist_no
                               AND a.dist_seq_no = b.dist_seq_no
                               AND b.line_cd = c.line_cd
                               AND b.share_cd = c.share_cd
                          ORDER BY a.dist_no, a.dist_seq_no, b.share_cd) p
                   WHERE p.diff_spct <> '0'
                GROUP BY p.dist_no, p.dist_seq_no)
            LOOP
               IF curdist.cnt > 1
               THEN
                  v_cnt_distinct := curdist.cnt;
                  EXIT;
               END IF;
            END LOOP;

            IF v_cnt_distinct > 1                -- begin tc3 - v_cnt_distinct
            THEN
               p_log_result (p_dist_no,
                             p_dist_by_tsi_prem_sw,
                             p_action,
                             p_dist_type,
                             p_distmod_type,
                             p_module_id,
                             p_user,
                             v_findings,
                             v_query_fnc,
                             v_calling_proc,
                             v_output
                            );
            END IF;                               -- end  tc3 - v_cnt_distinct
         END IF;                                   -- end  tc2 -- v_zero_share
      END IF;                            -- end tc1 - p_dist_type and p_action
   END p_vcomp_shr_f_poldtl01;

   PROCEDURE p_vcomp_shr_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if the share % stored in GIUW_POLICYDS_DTL matches computed share % - DIST_SPCT1( Peril Distribution)
                    Modules affected : All peril distribution modules
               */
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)      := UPPER ('f_vcomp_shr_f_poldtl02');
      v_calling_proc   VARCHAR2 (30)      := UPPER ('p_vcomp_shr_f_poldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_cnt_distinct   NUMBER                                   := 0;
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records with incorrect share % (DIST_SPCT1) in GIUW_POLICYDS_DTL (Peril Distribution).';

      IF     p_dist_type = 'P'
         AND p_action = 'P'
         AND NVL (p_dist_by_tsi_prem_sw, 'N') = 'Y'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcomp_shr_f_poldtl02 [ Checking of computation of share % for GIUW_POLICYDS - DSIT_SPCT1 (Peril Dist)  ]  ................'
            );

         FOR curdist IN
            (SELECT   p.dist_no, p.dist_seq_no, COUNT (*) cnt
                 FROM (SELECT a.dist_no, a.dist_seq_no, b.share_cd,
                              c.trty_name,
                              DECODE
                                 (a.prem_amt,
                                  0, (DECODE (a.tsi_amt,
                                              0, 0,
                                              ROUND ((  NVL (b.dist_tsi, 0)
                                                      / a.tsi_amt
                                                      * 100
                                                     ),
                                                     9
                                                    )
                                             )
                                   ),
                                  ROUND ((  NVL (b.dist_prem, 0)
                                          / a.prem_amt
                                          * 100
                                         ),
                                         9
                                        )
                                 ) computed_dist_spct1,
                              b.dist_spct1 item_spct1,
                              TO_CHAR
                                 (  (DECODE
                                         (a.prem_amt,
                                          0, (DECODE
                                                   (a.tsi_amt,
                                                    0, 0,
                                                    ROUND ((  NVL (b.dist_tsi,
                                                                   0
                                                                  )
                                                            / a.tsi_amt
                                                            * 100
                                                           ),
                                                           9
                                                          )
                                                   )
                                           ),
                                          ROUND ((  NVL (b.dist_prem, 0)
                                                  / a.prem_amt
                                                  * 100
                                                 ),
                                                 9
                                                )
                                         )
                                    )
                                  - NVL (b.dist_spct1, 0)
                                 ) diff_spct1
                         FROM giuw_policyds a,
                              giuw_policyds_dtl b,
                              giis_dist_share c
                        WHERE a.dist_no = p_dist_no
                          AND a.dist_no = b.dist_no
                          AND a.dist_seq_no = b.dist_seq_no
                          AND b.line_cd = c.line_cd
                          AND b.share_cd = c.share_cd) p
                WHERE p.diff_spct1 <> '0'
             GROUP BY p.dist_no, p.dist_seq_no)
         LOOP
            IF curdist.cnt > 1
            THEN
               v_cnt_distinct := curdist.cnt;
               EXIT;
            END IF;
         END LOOP;

         IF v_cnt_distinct > 1
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcomp_shr_f_poldtl02;

     /* ===================================================================================================================================
   **  Dist Validation - Validation of existence of Share % based on dist type - Peril/One Risk - Working Distribution Table
   ** ==================================================================================================================================*/
   PROCEDURE p_vcorsk_wpoldtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WITEMDS_DTL  ( One Risk Distribution )
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_vcorsk_wpoldtl_witemdtl01');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_vcorsk_wpoldtl_witemdtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPOLICYDS_DTL but does not exists in GIUW_WITEMDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing  procedure p_vcorsk_wpoldtl_witemdtl01 [ checking if there exists shares in GIUW_WPOLICYDS_DTL not existing in GIUW_WITEMDS_DTL  ]  ....'
            );

         FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no,
                                x.share_cd, x.dist_spct, x.dist_spct1
                           FROM giuw_wpolicyds_dtl x, giuw_witemds w
                          WHERE x.dist_no = p_dist_no
                            AND x.dist_no = w.dist_no
                            AND x.dist_seq_no = w.dist_seq_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_witemds_dtl y
                                    WHERE y.dist_no = x.dist_no
                                      AND y.dist_seq_no = x.dist_seq_no
                                      AND y.line_cd = x.line_cd
                                      AND y.share_cd = x.share_cd
                                      AND y.item_no = w.item_no))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_wpoldtl_witemdtl01;

   PROCEDURE p_vcorsk_wpoldtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WITEMDS_DTL which does not exists in GIUW_WPOLICYDS_DTL  ( One Risk Distribution )
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_vcorsk_wpoldtl_witemdtl02');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_vcorsk_wpoldtl_witemdtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WITEMDS_DTL but does not exists in GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_wpoldtl_witemdtl02 [ checking if there exists shares in GIUW_WITEMDS_DTL not existing in GIUW_WPOLICYDS_DTL  ]  ....'
            );

         FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.share_cd, a.dist_spct, a.dist_spct1
                           FROM giuw_witemds_dtl a, giuw_wpolicyds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_wpolicyds_dtl x
                                    WHERE x.dist_no = a.dist_no
                                      AND x.dist_seq_no = a.dist_seq_no
                                      AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_wpoldtl_witemdtl02;

   PROCEDURE p_vcorsk_wpoldtl_witmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WITEMPERILDS_DTL ( One Risk Distribution )
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vcorsk_wpoldtl_witmprldtl01');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vcorsk_wpoldtl_witmprldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPOLICYDS_DTL but does not exists in GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_wpoldtl_witmprldtl01 [ checking if there exists shares in GIUW_WPOLICYDS_DTL not existing in GIUW_WITEMPERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no,
                                w.peril_cd, x.share_cd, x.dist_spct,
                                x.dist_spct1
                           FROM giuw_wpolicyds_dtl x, giuw_witemperilds w
                          WHERE x.dist_no = p_dist_no
                            AND x.dist_no = w.dist_no
                            AND x.dist_seq_no = w.dist_seq_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_witemperilds_dtl y
                                    WHERE y.dist_no = x.dist_no
                                      AND y.dist_seq_no = x.dist_seq_no
                                      AND y.line_cd = x.line_cd
                                      AND y.share_cd = x.share_cd
                                      AND y.item_no = w.item_no
                                      AND y.peril_cd = w.peril_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_wpoldtl_witmprldtl01;

   PROCEDURE p_vcorsk_wpoldtl_witmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there exists shares in GIUW_WITEMPERILDS_DTL which does not exists in GIUW_WPOLICYDS_DTL  ( One Risk Distribution )
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vcorsk_wpoldtl_witmprldtl02');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vcorsk_wpoldtl_witmprldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WITEMPERILDS_DTL but does not exists in GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_wpoldtl_witmprldtl02 [ checking if there exists shares in GIUW_WITEMPERILDS_DTL not existing in GIUW_WPOLICYDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.peril_cd, a.share_cd, a.dist_spct,
                                a.dist_spct1
                           FROM giuw_witemperilds_dtl a, giuw_wpolicyds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_wpolicyds_dtl x
                                    WHERE x.dist_no = a.dist_no
                                      AND x.dist_seq_no = a.dist_seq_no
                                      AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_wpoldtl_witmprldtl02;

   PROCEDURE p_vcorsk_wpoldtl_wperildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WPERILDS_DTL  ( One Risk Distribution )
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vcorsk_wpoldtl_wperildtl01');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vcorsk_wpoldtl_wperildtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPOLICYDS_DTL but does not exists in GIUW_WPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_wpoldtl_wperildtl01 [ checking if there exists shares in WPOLICYDS_DTL not in WPERILDS_DTL  ]  ....'
            );

         FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.peril_cd,
                                x.share_cd, x.dist_spct, x.dist_spct1
                           FROM giuw_wpolicyds_dtl x, giuw_wperilds w
                          WHERE x.dist_no = p_dist_no
                            AND x.dist_no = w.dist_no
                            AND x.dist_seq_no = w.dist_seq_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_wperilds_dtl y
                                    WHERE y.dist_no = x.dist_no
                                      AND y.dist_seq_no = x.dist_seq_no
                                      AND y.share_cd = x.share_cd
                                      AND y.line_cd = w.line_cd
                                      AND y.peril_cd = w.peril_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_wpoldtl_wperildtl01;

   PROCEDURE p_vcorsk_wpoldtl_wperildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPERILDS_DTL which does not exists in GIUW_WPOLICYDS_DTL  ( One Risk Distribution )
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vcorsk_wpoldtl_wperildtl02');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vcorsk_wpoldtl_wperildtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPERILDS_DTL but does not exists in GIUW_WPOLICYDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_wpoldtl_wperildtl02 [ checking if there exists shares in GIUW_WPERILDS_DTL not existing in GIUW_WPOLICYDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                                a.share_cd, a.dist_spct, a.dist_spct1
                           FROM giuw_wperilds_dtl a, giuw_wpolicyds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_wpolicyds_dtl x
                                    WHERE x.dist_no = a.dist_no
                                      AND x.dist_seq_no = a.dist_seq_no
                                      AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_wpoldtl_wperildtl02;

   PROCEDURE p_vpdist_wperildtl_witemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPERILDS_DTL which does not exists in GIUW_WITEMDS_DTL (Peril Distribution )
                Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vpdist_wperildtl_witemdtl01');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vpdist_wperildtl_witemdtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPERILDS_DTL but does not exists in GIUW_WITEMDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_wperildtl_witemdtl01 [ checking if there exists shares in GIUW_WPERILDS_DTL not existing in GIUW_WITEMDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.item_no,
                                  bb.share_cd
                             FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   b.item_no, a.share_cd,
                                                   c.trty_name
                                              FROM giuw_wperilds_dtl a,
                                                   giuw_witemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd) bb,
                                  giuw_witemds cc
                            WHERE bb.dist_no = p_dist_no
                              AND bb.dist_no = cc.dist_no(+)
                              AND bb.dist_seq_no = cc.dist_seq_no(+)
                              AND bb.item_no = cc.item_no(+)
                              AND NOT EXISTS (
                                     SELECT 1
                                       FROM giuw_witemds_dtl pp
                                      WHERE pp.dist_no = bb.dist_no
                                        AND pp.dist_seq_no = bb.dist_seq_no
                                        AND pp.item_no = bb.item_no
                                        AND pp.share_cd = bb.share_cd)
                         ORDER BY bb.item_no, bb.share_cd)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_wperildtl_witemdtl01;

   PROCEDURE p_vpdist_wperildtl_witemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WITEMDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                  Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vpdist_wperildtl_witemdtl02');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vpdist_wperildtl_witemdtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WITEMDS_DTL but does not exists in GIUW_WPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_wperildtl_witemdtl01 [ checking if there exists shares in GIUW_WITEMDS_DTL not existing in GIUW_WPERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.item_no,
                                xx.share_cd
                           FROM giuw_witemds_dtl xx,
                                (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                 b.item_no, a.share_cd,
                                                 c.trty_name
                                            FROM giuw_wperilds_dtl a,
                                                 giuw_witemperilds b,
                                                 giis_dist_share c
                                           WHERE a.dist_no = p_dist_no
                                             AND a.line_cd = c.line_cd
                                             AND a.share_cd = c.share_cd
                                             AND a.dist_no = b.dist_no
                                             AND a.dist_seq_no = b.dist_seq_no
                                             AND a.peril_cd = b.peril_cd) yy
                          WHERE xx.dist_no = p_dist_no
                            AND xx.dist_no = yy.dist_no(+)
                            AND xx.dist_seq_no = yy.dist_seq_no(+)
                            AND xx.item_no = yy.item_no(+)
                            AND xx.share_cd = yy.share_cd(+)
                            AND NOT EXISTS (
                                   SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   b.item_no, a.share_cd,
                                                   c.trty_name
                                              FROM giuw_wperilds_dtl a,
                                                   giuw_witemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd
                                               AND b.dist_no = xx.dist_no
                                               AND b.dist_seq_no =
                                                                xx.dist_seq_no
                                               AND b.item_no = xx.item_no
                                               AND b.peril_cd = a.peril_cd
                                               AND a.share_cd = xx.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_wperildtl_witemdtl02;

   PROCEDURE p_vpdist_wperildtl_witmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPERILDS_DTL which does not exists in GIUW_WITEMPERILDS_DTL (Peril Distribution )
                   Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_vpdist_wperildtl_witmpldtl01');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_vpdist_wperildtl_witmpldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPERILDS_DTL but does not exists in GIUW_WITEMPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_wperildtl_witmpldtl01 [ checking if there exists shares in GIUW_WPERILDS_DTL not existing in GIUW_WITEMPERILDS_DTL ]  ....'
            );

         FOR cur IN (SELECT a.dist_no, a.dist_seq_no, b.item_no, a.peril_cd,
                            a.share_cd, c.trty_name
                       FROM giuw_wperilds_dtl a,
                            giuw_witemperilds b,
                            giis_dist_share c
                      WHERE a.dist_no = p_dist_no
                        AND a.line_cd = c.line_cd
                        AND a.share_cd = c.share_cd
                        AND a.dist_no = b.dist_no(+)
                        AND a.dist_seq_no = b.dist_seq_no(+)
                        AND a.peril_cd = b.peril_cd(+)
                        AND NOT EXISTS (
                               SELECT 1
                                 FROM giuw_witemperilds_dtl x
                                WHERE x.dist_no = a.dist_no
                                  AND x.dist_seq_no = a.dist_seq_no
                                  AND x.item_no = b.item_no
                                  AND x.peril_cd = b.peril_cd
                                  AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_wperildtl_witmpldtl01;

   PROCEDURE p_vpdist_wperildtl_witmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WITEMPERILDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                   Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_vpdist_wperildtl_witmpldtl02');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_vpdist_wperildtl_witmpldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WITEMPERILDS_DTL but does not exists in GIUW_WPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_wperildtl_witmpldtl02 [ checking if there exists shares in GIUW_WITEMPERILDS_DTL not existing in GIUW_WPERILDS_DTL ]  ....'
            );

         FOR cur IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                            a.share_cd, a.dist_spct, a.dist_spct1
                       FROM giuw_witemperilds_dtl a, giuw_wperilds_dtl b
                      WHERE a.dist_no = b.dist_no(+)
                        AND a.dist_seq_no = b.dist_seq_no(+)
                        AND a.share_cd = b.share_cd(+)
                        AND a.peril_cd = b.peril_cd(+)
                        AND a.dist_no = p_dist_no
                        AND NOT EXISTS (
                               SELECT 1
                                 FROM giuw_wperilds_dtl x
                                WHERE x.dist_no = a.dist_no
                                  AND x.dist_seq_no = a.dist_seq_no
                                  AND x.peril_cd = a.peril_cd
                                  AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_wperildtl_witmpldtl02;

   PROCEDURE p_vpdist_wperildtl_wpoldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                   Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vpdist_wperildtl_wpoldtl01');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vpdist_wperildtl_wpoldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPOLICYDS_DTL but does not exists in GIUW_WPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_wperildtl_wpoldtl01 [ checking if there exists shares in GIUW_WPOLICYDS_DTL not existing in GIUW_WPERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.share_cd
                             FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   a.share_cd, c.trty_name
                                              FROM giuw_wperilds_dtl a,
                                                   giuw_witemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd) bb,
                                  giuw_wpolicyds cc
                            WHERE bb.dist_no = p_dist_no
                              AND bb.dist_no = cc.dist_no(+)
                              AND bb.dist_seq_no = cc.dist_seq_no(+)
                              AND NOT EXISTS (
                                     SELECT 1
                                       FROM giuw_wpolicyds_dtl pp
                                      WHERE pp.dist_no = bb.dist_no
                                        AND pp.dist_seq_no = bb.dist_seq_no
                                        AND pp.share_cd = bb.share_cd)
                         ORDER BY bb.dist_seq_no, bb.share_cd)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_wperildtl_wpoldtl01;

   PROCEDURE p_vpdist_wperildtl_wpoldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                 Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vpdist_wperildtl_wpoldtl02');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vpdist_wperildtl_wpoldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_WPOLICYDS_DTL but does not exists in GIUW_WPERILDS_DTL.';

      IF p_action = 'S' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_wperildtl_wpoldtl02 [ checking if there exists shares in GIUW_WPOLICYDS_DTL not existing in GIUW_WPERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.share_cd
                           FROM giuw_wpolicyds_dtl xx,
                                (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                 a.share_cd, c.trty_name
                                            FROM giuw_wperilds_dtl a,
                                                 giuw_witemperilds b,
                                                 giis_dist_share c
                                           WHERE a.dist_no = p_dist_no
                                             AND a.line_cd = c.line_cd
                                             AND a.share_cd = c.share_cd
                                             AND a.dist_no = b.dist_no
                                             AND a.dist_seq_no = b.dist_seq_no
                                             AND a.peril_cd = b.peril_cd) yy
                          WHERE xx.dist_no = p_dist_no
                            AND xx.dist_no = yy.dist_no(+)
                            AND xx.dist_seq_no = yy.dist_seq_no(+)
                            AND xx.share_cd = yy.share_cd(+)
                            AND NOT EXISTS (
                                   SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   b.item_no, a.share_cd,
                                                   c.trty_name
                                              FROM giuw_wperilds_dtl a,
                                                   giuw_witemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd
                                               AND b.dist_no = xx.dist_no
                                               AND b.dist_seq_no =
                                                                xx.dist_seq_no
                                               AND b.peril_cd = a.peril_cd
                                               AND a.share_cd = xx.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_wperildtl_wpoldtl02;

/* ===================================================================================================================================
**  Dist Validation - Validation of existence of Share % based on dist type - Peril/One Risk - Final Distribution Table
** ==================================================================================================================================*/
   PROCEDURE p_vcorsk_poldtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_POLICYDS_DTL which does not exists in GIUW_ITEMDS_DTL  ( One Risk Distribution )
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_vcorsk_poldtl_f_itemdtl01');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_vcorsk_poldtl_f_itemdtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_POLICYDS_DTL but does not exists in GIUW_ITEMDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Passing procedure p_vcorsk_poldtl_f_itemdtl01 [ checking if there exists shares in GIUW_WPOLICYDS_DTL not existing in GIUW_ITEMDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no,
                                x.share_cd, x.dist_spct, x.dist_spct1
                           FROM giuw_policyds_dtl x, giuw_itemds w
                          WHERE x.dist_no = p_dist_no
                            AND x.dist_no = w.dist_no
                            AND x.dist_seq_no = w.dist_seq_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_itemds_dtl y
                                    WHERE y.dist_no = x.dist_no
                                      AND y.dist_seq_no = x.dist_seq_no
                                      AND y.line_cd = x.line_cd
                                      AND y.share_cd = x.share_cd
                                      AND y.item_no = w.item_no))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_poldtl_f_itemdtl01;

   PROCEDURE p_vcorsk_poldtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WITEMDS_DTL which does not exists in GIUW_WPOLICYDS_DTL  ( One Risk Distribution )
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_vcorsk_poldtl_f_itemdtl02');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_vcorsk_poldtl_f_itemdtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_ITEMDS_DTL but does not exists in GIUW_POLICYDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Passing procedure p_vcorsk_poldtl_f_itemdtl02 [ checking if there exists shares in GIUW_ITEMDS_DTL which does not exists in GIUW_POLICYDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.share_cd, a.dist_spct, a.dist_spct1
                           FROM giuw_itemds_dtl a, giuw_policyds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_policyds_dtl x
                                    WHERE x.dist_no = a.dist_no
                                      AND x.dist_seq_no = a.dist_seq_no
                                      AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_poldtl_f_itemdtl02;

   PROCEDURE p_vcorsk_poldtl_f_itmprldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there exists shares in GIUW_POLICYDS_DTL which does not exists in GIUW_ITEMPERILDS_DTL ( One Risk Distribution )
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vcorsk_poldtl_f_itmprldtl01');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vcorsk_poldtl_f_itmprldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_POLICYDS_DTL but does not exists in GIUW_ITEMPERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_poldtl_f_itmprldtl01 [checking if there exists shares in GIUW_POLICYDS_DTL which does not exists in GIUW_ITEMPERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.item_no,
                                x.share_cd, x.dist_spct, x.dist_spct1
                           FROM giuw_policyds_dtl x, giuw_itemperilds w
                          WHERE x.dist_no = p_dist_no
                            AND x.dist_no = w.dist_no
                            AND x.dist_seq_no = w.dist_seq_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_itemperilds_dtl y
                                    WHERE y.dist_no = x.dist_no
                                      AND y.dist_seq_no = x.dist_seq_no
                                      AND y.line_cd = x.line_cd
                                      AND y.share_cd = x.share_cd
                                      AND y.item_no = w.item_no
                                      AND y.peril_cd = w.peril_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_poldtl_f_itmprldtl01;

   PROCEDURE p_vcorsk_poldtl_f_itmprldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Check if there exists shares in GIUW_ITEMPERILDS_DTL which does not exists in GIUW_POLICYDS_DTL  ( One Risk Distribution )
                Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vcorsk_poldtl_f_itmprldtl02');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vcorsk_poldtl_f_itmprldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_ITEMPERILDS_DTL but does not exists in GIUW_POLICYDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing  procedure p_vcorsk_poldtl_f_itmprldtl02 [checking if there exists shares in GIUW_ITEMPERILDS_DTL which does not exists in GIUW_POLICYDS_DTL  ]  ....'
            );

         FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.item_no,
                                a.peril_cd, a.share_cd, a.dist_spct,
                                a.dist_spct1
                           FROM giuw_itemperilds_dtl a, giuw_policyds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_policyds_dtl x
                                    WHERE x.dist_no = a.dist_no
                                      AND x.dist_seq_no = a.dist_seq_no
                                      AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_poldtl_f_itmprldtl02;

   PROCEDURE p_vcorsk_poldtl_f_perildtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_POLICYDS_DTL which does not exists in GIUW_PERILDS_DTL  ( One Risk Distribution )
              Modules affected : All distribution modules.
           */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vcorsk_poldtl_f_perildtl01');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vcorsk_poldtl_f_perildtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_POLICYDS_DTL but does not exists in GIUW_PERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing  procedure p_vcorsk_poldtl_f_perildtl01 [ checking if there exists shares in POLICYDS_DTL not in PERILDS_DTL  ]  ....'
            );

         FOR curdist IN (SELECT x.dist_no, x.dist_seq_no, w.peril_cd,
                                x.share_cd, x.dist_spct, x.dist_spct1
                           FROM giuw_policyds_dtl x, giuw_perilds w
                          WHERE x.dist_no = p_dist_no
                            AND x.dist_no = w.dist_no
                            AND x.dist_seq_no = w.dist_seq_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_perilds_dtl y
                                    WHERE y.dist_no = x.dist_no
                                      AND y.dist_seq_no = x.dist_seq_no
                                      AND y.share_cd = x.share_cd
                                      AND y.line_cd = w.line_cd
                                      AND y.peril_cd = w.peril_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_poldtl_f_perildtl01;

   PROCEDURE p_vcorsk_poldtl_f_perildtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_PERILDS_DTL which does not exists in GIUW_POLICYDS_DTL  ( One Risk Distribution )
               Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vcorsk_poldtl_f_perildtl02');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vcorsk_poldtl_f_perildtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_PERILDS_DTL but does not exists in GIUW_POLICYDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'O'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vcorsk_poldtl_f_perildtl02 [ checking if there exists shares in GIUW_PERILDS_DTL not existing in GIUW_POLICYDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT a.dist_no, a.dist_seq_no, a.peril_cd,
                                a.share_cd, a.dist_spct, a.dist_spct1
                           FROM giuw_perilds_dtl a, giuw_policyds_dtl b
                          WHERE a.dist_no = b.dist_no(+)
                            AND a.dist_seq_no = b.dist_seq_no(+)
                            AND a.share_cd = b.share_cd(+)
                            AND a.dist_no = p_dist_no
                            AND NOT EXISTS (
                                   SELECT 1
                                     FROM giuw_policyds_dtl x
                                    WHERE x.dist_no = a.dist_no
                                      AND x.dist_seq_no = a.dist_seq_no
                                      AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vcorsk_poldtl_f_perildtl02;

   PROCEDURE p_vpdist_perildtl_f_itemdtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_PERILDS_DTL which does not exists in GIUW_ITEMDS_DTL (Peril Distribution )
                 Modules affected : All distribution modules.
            */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vpdist_perildtl_f_itemdtl01');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vpdist_perildtl_f_itemdtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_PERILDS_DTL but does not exists in GIUW_ITEMDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_perildtl_f_itemdtl01 [ checking if there exists shares in GIUW_PERILDS_DTL not existing in GIUW_ITEMDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.item_no,
                                  bb.share_cd
                             FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   b.item_no, a.share_cd,
                                                   c.trty_name
                                              FROM giuw_perilds_dtl a,
                                                   giuw_itemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd) bb,
                                  giuw_itemds cc
                            WHERE bb.dist_no = p_dist_no
                              AND bb.dist_no = cc.dist_no(+)
                              AND bb.dist_seq_no = cc.dist_seq_no(+)
                              AND bb.item_no = cc.item_no(+)
                              AND NOT EXISTS (
                                     SELECT 1
                                       FROM giuw_itemds_dtl pp
                                      WHERE pp.dist_no = bb.dist_no
                                        AND pp.dist_seq_no = bb.dist_seq_no
                                        AND pp.item_no = bb.item_no
                                        AND pp.share_cd = bb.share_cd)
                         ORDER BY bb.item_no, bb.share_cd)
         LOOP
            v_exists_rec := 'Y';
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_perildtl_f_itemdtl01;

   PROCEDURE p_vpdist_perildtl_f_itemdtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_ITEMDS_DTL which does not exists in GIUW_PERILDS_DTL (Peril Distribution )
                  Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                   := UPPER ('f_vpdist_perildtl_f_itemdtl02');
      v_calling_proc   VARCHAR2 (30)
                                   := UPPER ('p_vpdist_perildtl_f_itemdtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_ITEMDS_DTL but does not exists in GIUW_PERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_perildtl_f_itemdtl02 [ checking if there exists shares in GIUW_ITEMDS_DTL not existing in GIUW_PERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.item_no,
                                xx.share_cd
                           FROM giuw_itemds_dtl xx,
                                (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                 b.item_no, a.share_cd,
                                                 c.trty_name
                                            FROM giuw_perilds_dtl a,
                                                 giuw_itemperilds b,
                                                 giis_dist_share c
                                           WHERE a.dist_no = p_dist_no
                                             AND a.line_cd = c.line_cd
                                             AND a.share_cd = c.share_cd
                                             AND a.dist_no = b.dist_no
                                             AND a.dist_seq_no = b.dist_seq_no
                                             AND a.peril_cd = b.peril_cd) yy
                          WHERE xx.dist_no = p_dist_no
                            AND xx.dist_no = yy.dist_no(+)
                            AND xx.dist_seq_no = yy.dist_seq_no(+)
                            AND xx.item_no = yy.item_no(+)
                            AND xx.share_cd = yy.share_cd(+)
                            AND NOT EXISTS (
                                   SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   b.item_no, a.share_cd,
                                                   c.trty_name
                                              FROM giuw_perilds_dtl a,
                                                   giuw_itemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd
                                               AND b.dist_no = xx.dist_no
                                               AND b.dist_seq_no =
                                                                xx.dist_seq_no
                                               AND b.item_no = xx.item_no
                                               AND b.peril_cd = a.peril_cd
                                               AND a.share_cd = xx.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_perildtl_f_itemdtl02;

   PROCEDURE p_vpdist_perildtl_f_itmpldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_PERILDS_DTL which does not exists in GIUW_ITEMPERILDS_DTL (Peril Distribution )
                   Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_vpdist_perildtl_f_itmpldtl01');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_vpdist_perildtl_f_itmpldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_PERILDS_DTL but does not exists in GIUW_ITEMPERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_perildtl_f_itmpldtl01 [ checking if there exists shares in GIUW_PERILDS_DTL not existing in GIUW_ITEMPERILDS_DTL ]  ....'
            );

         FOR cur IN (SELECT a.dist_no, a.dist_seq_no, b.item_no, a.peril_cd,
                            a.share_cd, c.trty_name
                       FROM giuw_perilds_dtl a,
                            giuw_itemperilds b,
                            giis_dist_share c
                      WHERE a.dist_no = p_dist_no
                        AND a.line_cd = c.line_cd
                        AND a.share_cd = c.share_cd
                        AND a.dist_no = b.dist_no(+)
                        AND a.dist_seq_no = b.dist_seq_no(+)
                        AND a.peril_cd = b.peril_cd(+)
                        AND NOT EXISTS (
                               SELECT 1
                                 FROM giuw_itemperilds_dtl x
                                WHERE x.dist_no = a.dist_no
                                  AND x.dist_seq_no = a.dist_seq_no
                                  AND x.item_no = b.item_no
                                  AND x.peril_cd = b.peril_cd
                                  AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_perildtl_f_itmpldtl01;

   PROCEDURE p_vpdist_perildtl_f_itmpldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WITEMPERILDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                   Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                  := UPPER ('f_vpdist_perildtl_f_itmpldtl02');
      v_calling_proc   VARCHAR2 (30)
                                  := UPPER ('p_vpdist_perildtl_f_itmpldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_ITEMPERILDS_DTL but does not exists in GIUW_PERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_perildtl_f_itmpldtl02 [ checking if there exists shares in GIUW_ITEMPERILDS_DTL not existing in GIUW_PERILDS_DTL ]  ....'
            );

         FOR cur IN (SELECT a.dist_no, a.dist_seq_no, a.item_no, a.peril_cd,
                            a.share_cd, a.dist_spct, a.dist_spct1
                       FROM giuw_itemperilds_dtl a, giuw_perilds_dtl b
                      WHERE a.dist_no = b.dist_no(+)
                        AND a.dist_seq_no = b.dist_seq_no(+)
                        AND a.share_cd = b.share_cd(+)
                        AND a.peril_cd = b.peril_cd(+)
                        AND a.dist_no = p_dist_no
                        AND NOT EXISTS (
                               SELECT 1
                                 FROM giuw_perilds_dtl x
                                WHERE x.dist_no = a.dist_no
                                  AND x.dist_seq_no = a.dist_seq_no
                                  AND x.peril_cd = a.peril_cd
                                  AND x.share_cd = a.share_cd))
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_perildtl_f_itmpldtl02;

   PROCEDURE p_vpdist_perildtl_f_poldtl01 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                   Modules affected : All distribution modules.
              */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vpdist_perildtl_f_poldtl01');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vpdist_perildtl_f_poldtl01');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_POLICYDS_DTL but does not exists in GIUW_PERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_perildtl_f_poldtl01 [ checking if there exists shares in GIUW_POLICYDS_DTL not existing in GIUW_PERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT   bb.dist_no, bb.dist_seq_no, bb.share_cd
                             FROM (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   a.share_cd, c.trty_name
                                              FROM giuw_perilds_dtl a,
                                                   giuw_itemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd) bb,
                                  giuw_policyds cc
                            WHERE bb.dist_no = p_dist_no
                              AND bb.dist_no = cc.dist_no(+)
                              AND bb.dist_seq_no = cc.dist_seq_no(+)
                              AND NOT EXISTS (
                                     SELECT 1
                                       FROM giuw_policyds_dtl pp
                                      WHERE pp.dist_no = bb.dist_no
                                        AND pp.dist_seq_no = bb.dist_seq_no
                                        AND pp.share_cd = bb.share_cd)
                         ORDER BY bb.dist_seq_no, bb.share_cd)
         LOOP
            v_exists_rec := 'Y';
            EXIT;
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_perildtl_f_poldtl01;

   PROCEDURE p_vpdist_perildtl_f_poldtl02 (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : Validate if there exists shares in GIUW_WPOLICYDS_DTL which does not exists in GIUW_WPERILDS_DTL (Peril Distribution )
                 Modules affected : All distribution modules.
             */
      v_discrep        VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_findings2      VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)
                                    := UPPER ('f_vpdist_perildtl_f_poldtl02');
      v_calling_proc   VARCHAR2 (30)
                                    := UPPER ('p_vpdist_perildtl_f_poldtl02');
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are share/s which exists in GIUW_POLICYDS_DTL but does not exists in GIUW_PERILDS_DTL.';

      IF p_action = 'P' AND p_dist_type = 'P'
      THEN
         DBMS_OUTPUT.put_line
            ('Executing procedure p_vpdist_perildtl_f_poldtl02 [ checking if there exists shares in GIUW_POLICYDS_DTL not existing in GIUW_PERILDS_DTL ]  ....'
            );

         FOR curdist IN (SELECT xx.dist_no, xx.dist_seq_no, xx.share_cd
                           FROM giuw_policyds_dtl xx,
                                (SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                 a.share_cd, c.trty_name
                                            FROM giuw_perilds_dtl a,
                                                 giuw_itemperilds b,
                                                 giis_dist_share c
                                           WHERE a.dist_no = p_dist_no
                                             AND a.line_cd = c.line_cd
                                             AND a.share_cd = c.share_cd
                                             AND a.dist_no = b.dist_no
                                             AND a.dist_seq_no = b.dist_seq_no
                                             AND a.peril_cd = b.peril_cd) yy
                          WHERE xx.dist_no = p_dist_no
                            AND xx.dist_no = yy.dist_no(+)
                            AND xx.dist_seq_no = yy.dist_seq_no(+)
                            AND xx.share_cd = yy.share_cd(+)
                            AND NOT EXISTS (
                                   SELECT DISTINCT a.dist_no, a.dist_seq_no,
                                                   b.item_no, a.share_cd,
                                                   c.trty_name
                                              FROM giuw_perilds_dtl a,
                                                   giuw_itemperilds b,
                                                   giis_dist_share c
                                             WHERE a.dist_no = p_dist_no
                                               AND a.line_cd = c.line_cd
                                               AND a.share_cd = c.share_cd
                                               AND a.dist_no = b.dist_no
                                               AND a.dist_seq_no =
                                                                 b.dist_seq_no
                                               AND a.peril_cd = b.peril_cd
                                               AND b.dist_no = xx.dist_no
                                               AND b.dist_seq_no =
                                                                xx.dist_seq_no
                                               AND b.peril_cd = a.peril_cd
                                               AND a.share_cd = xx.share_cd))
         LOOP
            v_exists_rec := 'Y';
         END LOOP;

         IF v_exists_rec = 'Y'
         THEN
            v_output := v_result_failed;
         END IF;

         p_log_result (p_dist_no,
                       p_dist_by_tsi_prem_sw,
                       p_action,
                       p_dist_type,
                       p_distmod_type,
                       p_module_id,
                       p_user,
                       v_findings,
                       v_query_fnc,
                       v_calling_proc,
                       v_output
                      );
      END IF;
   END p_vpdist_perildtl_f_poldtl02;

/* ===================================================================================================================================
**  Dist Validation - Validating if there exists working binder tables
** ==================================================================================================================================*/
   PROCEDURE p_wrkngbndr_wfrps_ri (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : To check if there are working binder records when saving / posting distribution. Assumption is there should be no working binder tables.
      */
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)        := UPPER ('f_wrkngbndr_wfrps_ri');
      v_calling_proc   VARCHAR2 (30)        := UPPER ('p_wrkngbndr_wfrps_ri');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records existing in GIRI_WFRPS_RI for the distribution record.';

      FOR bndr IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                          pre_binder_id
                     FROM giri_wfrps_ri
                    WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no))
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_rec = 'Y'
      THEN
         v_output := v_result_failed;
      END IF;

      p_log_result (p_dist_no,
                    p_dist_by_tsi_prem_sw,
                    p_action,
                    p_dist_type,
                    p_distmod_type,
                    p_module_id,
                    p_user,
                    v_findings,
                    v_query_fnc,
                    v_calling_proc,
                    v_output
                   );
   END p_wrkngbndr_wfrps_ri;

   PROCEDURE p_wrkngbndr_wfrperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : To check if there are working binder records when saving / posting distribution. Assumption is there should be no working binder tables.
      */
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)        := UPPER ('f_wrkngbndr_wfrperil');
      v_calling_proc   VARCHAR2 (30)        := UPPER ('p_wrkngbndr_wfrperil');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records existing in GIRI_WFRPERIL for the distribution record.';

      FOR bndr IN (SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, ri_cd,
                          peril_cd
                     FROM giri_wfrperil
                    WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no))
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_rec = 'Y'
      THEN
         v_output := v_result_failed;
      END IF;

      p_log_result (p_dist_no,
                    p_dist_by_tsi_prem_sw,
                    p_action,
                    p_dist_type,
                    p_distmod_type,
                    p_module_id,
                    p_user,
                    v_findings,
                    v_query_fnc,
                    v_calling_proc,
                    v_output
                   );
   END p_wrkngbndr_wfrperil;

   PROCEDURE p_wrkngbndr_wbinderperil (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : To check if there are working binder records when saving / posting distribution. Assumption is there should be no working binder tables.
      */
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)    := UPPER ('f_wrkngbndr_wbinderperil');
      v_calling_proc   VARCHAR2 (30)    := UPPER ('p_wrkngbndr_wbinderperil');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records existing in GIRI_WBINDER_PERIL for the distribution record.';

      FOR bndr IN
         (SELECT pre_binder_id, peril_seq_no
            FROM giri_wbinder_peril
           WHERE pre_binder_id IN (
                    SELECT pre_binder_id
                      FROM giri_wfrps_ri
                     WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no)))
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_rec = 'Y'
      THEN
         v_output := v_result_failed;
      END IF;

      p_log_result (p_dist_no,
                    p_dist_by_tsi_prem_sw,
                    p_action,
                    p_dist_type,
                    p_distmod_type,
                    p_module_id,
                    p_user,
                    v_findings,
                    v_query_fnc,
                    v_calling_proc,
                    v_output
                   );
   END p_wrkngbndr_wbinderperil;

   PROCEDURE p_wrkngbndr_wbinder (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : To check if there are working binder records when saving / posting distribution. Assumption is there should be no working binder tables.
      */
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30)         := UPPER ('f_wrkngbndr_wbinder');
      v_calling_proc   VARCHAR2 (30)         := UPPER ('p_wrkngbndr_wbinder');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records existing in GIRI_WBINDER for the distribution record.';

      FOR bndr IN
         (SELECT pre_binder_id, line_cd, binder_yy, binder_seq_no, ri_cd
            FROM giri_wbinder
           WHERE pre_binder_id IN (
                    SELECT pre_binder_id
                      FROM giri_wfrps_ri
                     WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no)))
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_rec = 'Y'
      THEN
         v_output := v_result_failed;
      END IF;

      p_log_result (p_dist_no,
                    p_dist_by_tsi_prem_sw,
                    p_action,
                    p_dist_type,
                    p_distmod_type,
                    p_module_id,
                    p_user,
                    v_findings,
                    v_query_fnc,
                    v_calling_proc,
                    v_output
                   );
   END p_wrkngbndr_wbinder;

   PROCEDURE p_wrkngbndr_wfrps_peril_grp (
      p_dist_no               IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_by_tsi_prem_sw   IN   VARCHAR2,
      p_action                IN   VARCHAR2,
      p_dist_type             IN   VARCHAR2,
      p_distmod_type          IN   VARCHAR2,
      p_module_id             IN   VARCHAR2,
      p_user                  IN   VARCHAR2
   )
   IS
      /* Purpose : To check if there are working binder records when saving / posting distribution. Assumption is there should be no working binder tables.
      */
      v_exists_rec     VARCHAR2 (1)                             := 'N';
      v_findings       VARCHAR2 (4000);
      v_query_fnc      VARCHAR2 (30) := UPPER ('f_wrkngbndr_wfrps_peril_grp');
      v_calling_proc   VARCHAR2 (30) := UPPER ('p_wrkngbndr_wfrps_peril_grp');
      v_output         genqa_dist_checking_result.RESULT%TYPE
                                                           := v_result_passed;
   BEGIN
      v_findings :=
         'There are records existing in GIRI_WBINDER for the distribution record.';

      FOR bndr IN (SELECT line_cd, frps_yy, frps_seq_no, peril_seq_no,
                          peril_cd
                     FROM giri_wfrps_peril_grp
                    WHERE (line_cd, frps_yy, frps_seq_no) IN (
                                         SELECT line_cd, frps_yy,
                                                frps_seq_no
                                           FROM giri_wdistfrps
                                          WHERE dist_no = p_dist_no))
      LOOP
         v_exists_rec := 'Y';
         EXIT;
      END LOOP;

      IF v_exists_rec = 'Y'
      THEN
         v_output := v_result_failed;
      END IF;

      p_log_result (p_dist_no,
                    p_dist_by_tsi_prem_sw,
                    p_action,
                    p_dist_type,
                    p_distmod_type,
                    p_module_id,
                    p_user,
                    v_findings,
                    v_query_fnc,
                    v_calling_proc,
                    v_output
                   );
   END p_wrkngbndr_wfrps_peril_grp;
/* ==========================================================================================================================================*/
END;
/

DROP PACKAGE BODY CPI.GENQA_DIST;
