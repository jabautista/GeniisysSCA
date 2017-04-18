CREATE OR REPLACE PACKAGE BODY CPI.GIACB003_PKG
AS
 /*
 ** Created by : Steven Ramirez
 ** Date Created : 04.17.2013
 ** Reference By : GIACB003 use in GIACB000 - Batch Accounting Entry
 ** Description : 
 */
 PROCEDURE re_take_up (p_prod_date IN DATE,
 p_msg OUT VARCHAR2)
 IS
 v_tran_flag giac_acctrans.tran_flag%TYPE;
 v_tran_class giac_acctrans.tran_class%TYPE := 'OF';
 v_additional_take_up VARCHAR2 (1) := 'N';
 v_dummy VARCHAR2 (1);
 v_tkup_exs BOOLEAN := FALSE;
 ctr NUMBER := 0;
 BEGIN
 --Check the existence of a posted transaction
 FOR c IN (SELECT tran_id
 FROM giac_acctrans
 WHERE 1 = 1
 AND tran_class = v_tran_class
 AND tran_flag IN ('P', 'C')
 AND TRUNC (tran_date) = TRUNC (p_prod_date))
 LOOP
 --Set the counter
 ctr := ctr + 1;

 IF ctr = 1
 THEN --Show the message
 p_msg := p_msg ||'#Production take up for '
 || TO_CHAR (p_prod_date, 'fmMonth dd,yyyy')
 || ' has already been done. This will be a complete re-take-up! ';
 END IF;

 --UPDATE the records tran_flag to 'D'
 --because this is a re-run, all transactions with tran_flag in ('P','C')
 --must be tagged as DELETED
 UPDATE giac_acctrans
 SET tran_flag = 'D'
 WHERE 1 = 1 AND tran_id = c.tran_id;

 v_tkup_exs := TRUE;
 END LOOP;

 --If there where transactions that where tagged as DELETED
 --we must update the corresponding underwriting tables because it is a complete re-run
 IF v_tkup_exs
 THEN
 --Update giri_binder acc_ent_date
 UPDATE giri_binder
 SET acc_ent_date = NULL
 WHERE TRUNC (acc_ent_date) = TRUNC (p_prod_date);

 --Update giri_binder acc_rev_date
 UPDATE giri_binder
 SET acc_rev_date = NULL
 WHERE TRUNC (acc_rev_date) = TRUNC (p_prod_date);
 END IF;
 END;
 
 PROCEDURE prod_take_up (p_prod_date IN DATE,
 p_cut_off_date IN OUT DATE,
 p_exclude_special IN OUT VARCHAR2,
 p_gen_home IN OUT giac_parameters.param_value_v%TYPE,
 p_sql_path IN OUT VARCHAR2,
 p_var_param_value_n IN OUT GIAC_PARAMETERS.param_value_n%type,
 p_fund_cd IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
 p_ri_iss_cd IN OUT giac_parameters.param_value_v%TYPE,
 p_prem_rec_gross_tag IN OUT giac_parameters.param_value_v%TYPE,
 p_user_id IN giis_users.user_id%TYPE,
 p_msg IN OUT VARCHAR2)
 IS
 var_param_value_n giac_parameters.param_value_n%TYPE;
 v_module_name GIAC_MODULES.module_name%TYPE:= 'GIACB003';
 v_tran_class                 GIAC_ACCTRANS.tran_class%TYPE := 'OF';
 v_tran_flag                 GIAC_ACCTRANS.tran_flag%TYPE := 'C';
 v_gacc_tran_id                 GIAC_ACCTRANS.tran_id%TYPE ;
 var_count_row                     NUMBER := 0;
 v_module_ent_prem_ced giac_module_entries.item_no%TYPE:=1;
 v_module_ent_comm_inc giac_module_entries.item_no%TYPE:=2;
 v_module_ent_due_to_ri giac_module_entries.item_no%TYPE:=3;
 v_module_item_no_Inc_adj GIAC_MODULE_ENTRIES.item_no%TYPE:=4;
 v_module_item_no_Exp_adj     GIAC_MODULE_ENTRIES.item_no%TYPE:=5;
 v_module_ent_def_input_vat giac_module_entries.item_no%TYPE:=6; --issa 01.10.2006 (deferred input vat - vat on prem)
 v_module_ent_def_output_vat giac_module_entries.item_no%TYPE:=7; --issa 01.10.2006 (deferred output vat - vat on comm)
 v_module_ent_def_cred_wh_vatri    giac_module_entries.item_no%TYPE:=8; --issa 01.13.2006 (deferred creditable withholding vat on ri - vat on ri)
 v_module_ent_def_wh_vat_pay giac_module_entries.item_no%TYPE:=9; --issa 01.13.2006 (deferred withholding vat payable - vat payable)
 v_module_ent_prem_tax            giac_module_entries.item_no%TYPE:=10; -- judyann 07072008; for RI premium tax
 v_module_ent_prem_retroced giac_module_entries.item_no%TYPE:=11; -- judyann 03292011; for premiums retroceded 
 v_module_ent_comm_inc_retro giac_module_entries.item_no%TYPE:=12;
 v_module_ent_comm_rec                 giac_module_entries.item_no%TYPE:=13; -- judyann 07012013; for commissions receivable
 v_module_ent_comm_rec_retro                giac_module_entries.item_no%TYPE:=14; -- judyann 07012013; for commissions receivable on retrocession
 v_process VARCHAR2(100);
 v_iss_cd giac_branches.branch_cd%TYPE;
 v_acct_intm_cd                 GIIS_INTM_TYPE.acct_intm_cd%TYPE;
 v_acct_line_cd                 GIIS_LINE.acct_line_cd%TYPE;
 v_reinsurer giac_sl_TYPEs.sl_TYPE_cd%TYPE:='2';
 v_sl_source_cd     GIAC_ACCT_ENTRIES.sl_source_cd%TYPE := 1;
 v_line_subline giac_sl_TYPEs.sl_TYPE_cd%TYPE:='5';
 v_line_subline_peril      giac_sl_TYPEs.sl_TYPE_cd%TYPE:='6';
 var_gl_acct_id     giac_acct_entries.gl_acct_id%TYPE;
 var_sl_TYPE_cd     giac_acct_entries.sl_TYPE_cd%TYPE;
 v_balance NUMBER;
 BEGIN
 p_cut_off_date := p_prod_date;
 giis_users_pkg.app_user := p_user_id; 
 BEGIN
 SELECT param_value_v
 INTO p_fund_cd
 FROM giac_parameters
 WHERE param_name = 'FUND_CD';

 EXCEPTION
 WHEN NO_DATA_FOUND
 THEN
 raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (FUND_CD).');
 END;

 BEGIN
 SELECT param_value_v
 INTO p_ri_iss_cd
 FROM giac_parameters
 WHERE param_name = 'RI_ISS_CD';

 EXCEPTION
 WHEN NO_DATA_FOUND
 THEN
 raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (RI_ISS_CD).');
 END;

 CPI.GIACB003_PKG.create_batch_entries(p_prod_date,
 v_module_name);
 
 GIACB003_PKG.update_giri_binder(p_prod_date,
 p_exclude_special,
 var_count_row,
 p_cut_off_date);
 
 GIACB003_PKG.extract(p_prod_date,
 p_exclude_special,
 v_module_ent_comm_inc,
 v_module_ent_prem_ced,
 v_module_ent_due_to_ri,
 v_module_ent_def_input_vat,
 v_module_ent_def_output_vat,
 v_module_ent_def_cred_wh_vatri,
 v_module_ent_def_wh_vat_pay,
 v_module_ent_prem_tax,
 v_module_ent_comm_rec,
 v_iss_cd,
 v_process,
 v_module_name,
 v_acct_line_cd,
 v_acct_intm_cd,
 var_gl_acct_id,
 var_sl_type_cd,
 v_reinsurer,
 v_line_subline_peril,
 v_line_subline,
 v_sl_source_cd,
 p_msg,
 p_user_id,
 p_fund_cd,
 v_tran_class,
 v_tran_flag,
 p_cut_off_date,
 v_gacc_tran_id,
 var_count_row);

 -- judyann 03292011; separate retrocessions
 
 --raise_application_error(-20001,p_msg||'#Geniisys Exception#p_user_id:'||p_user_id);
 
 IF NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N') = 'Y'
 THEN
 GIACB003_PKG.extract_retrocession(p_prod_date,
 p_exclude_special,
 v_module_ent_comm_inc_retro,
 v_module_ent_prem_retroced,
 v_module_ent_due_to_ri,
 v_module_ent_def_input_vat,
 v_module_ent_def_output_vat,
 v_module_ent_def_cred_wh_vatri,
 v_module_ent_def_wh_vat_pay,
 v_module_ent_prem_tax,
 v_module_ent_comm_rec_retro,
 v_iss_cd,
 v_process,
 v_module_name,
 v_acct_line_cd,
 v_acct_intm_cd,
 var_gl_acct_id,
 var_sl_type_cd,
 v_reinsurer,
 v_line_subline_peril,
 v_line_subline,
 v_sl_source_cd,
 p_msg,
 p_user_id,
 p_fund_cd,
 v_tran_class,
 v_tran_flag,
 p_cut_off_date,
 v_gacc_tran_id,
 var_count_row);
 END IF;
 GIACB003_PKG.check_debit_credit_amounts(p_prod_date,
 v_module_item_no_inc_adj,
 v_module_item_no_exp_adj,
 v_module_name,
 p_fund_cd,
 p_user_id,
 v_balance,
 p_msg);
 END;

 PROCEDURE create_batch_entries (p_prod_date     IN   DATE,
                                    p_module_name   IN   giac_modules.module_name%TYPE)
    IS
       CURSOR accounts
       IS
          SELECT b.item_no, b.module_id, b.gl_acct_category, b.gl_control_acct,
                 b.gl_sub_acct_1, b.gl_sub_acct_2, b.gl_sub_acct_3,
                 b.gl_sub_acct_4, b.gl_sub_acct_5, b.gl_sub_acct_6,
                 b.gl_sub_acct_7, b.sl_type_cd, b.line_dependency_level,
                 b.intm_type_level, b.ca_treaty_type_level
            FROM giac_modules a, giac_module_entries b
           WHERE a.module_id = b.module_id AND a.module_name LIKE p_module_name;

       stmt   VARCHAR2 (2000);
    BEGIN
       DELETE FROM giac_batch_entries;
       
       FOR ja4 IN accounts
       LOOP
          bae_insert_batch_entries (TO_CHAR (p_prod_date, 'yy'),
                                    ja4.module_id,
                                    ja4.item_no,
                                    ja4.gl_acct_category,
                                    ja4.gl_control_acct,
                                    ja4.gl_sub_acct_1,
                                    ja4.gl_sub_acct_2,
                                    ja4.gl_sub_acct_3,
                                    ja4.gl_sub_acct_4,
                                    ja4.gl_sub_acct_5,
                                    ja4.gl_sub_acct_6,
                                    ja4.gl_sub_acct_7,
                                    NVL (ja4.line_dependency_level, 0),
                                    NVL (ja4.intm_type_level, 0),
                                    NVL (ja4.ca_treaty_type_level, 0),
                                    NULL
                                   );
       END LOOP;
    --delete from giac_batch_entries where gl_acct_id is null;
    END;
    
    PROCEDURE update_giri_binder (p_prod_date         IN       DATE,
                                  p_exclude_special   IN       giac_parameters.param_value_v%TYPE,
                                  p_var_count_row     IN OUT   NUMBER,
                                  p_cut_off_date      IN OUT   DATE)
    IS
       v_dummy   NUMBER := 0;
    BEGIN
       /* janet ang  february, 2000 */
       /* specs -- binders to be taken up
       ** 1.  positively take up binders whose policy has been taken up = gipi_polbasic.acct_ent_date <= cut_off_date
       ** 2.  positively take up binders whose distribution has been taken up = giuw_pol_dist.acct_ent_date <= cut_off_date
       ** 3.  negatively take up the binders which were reversed = giri_frps_ri.reverse_sw = 'Y' and acc_rev_date is null
       **     and acc_ent_date is not null
       ** 4.  negatively take up binders whose giuw_pol_dist.dist_flag = '5' = redistributed and giri_binder.acct_ent_date is not null
       ** 5.  negatively take up binders whose policy has been spoiled = gipi_polbasic.spld_acct_ent_date <= cut_off_date
       ** 6.  negatively take up binders whose giri_binder.replaced_flag = 'Y' and giri_binder.acct_ent_date is not null
       **     and giri_frps_ri.reverse_sw != 'Y'
       */
       IF p_exclude_special = 'N'
       THEN
          BEGIN
             /* extract all policies */
             p_var_count_row := 0;

             FOR ja1 IN (SELECT c.fnl_binder_id, c.acc_ent_date, c.acc_rev_date,
                                c.replaced_flag, b.reverse_sw, f.acct_ent_date,
                                f.acct_neg_date, f.dist_flag,
                                g.spld_acct_ent_date,
                                reverse_date         -- added by judyann 02282013
                           FROM giri_frperil a,
                                giri_frps_ri b,
                                giri_binder c,
                                giri_distfrps d,
                                giuw_policyds e,
                                giuw_pol_dist f,
                                gipi_polbasic g,
                                gipi_comm_invoice h
                          WHERE 1 = 1
                            AND a.line_cd = b.line_cd
                            AND a.frps_yy = b.frps_yy
                            AND a.frps_seq_no = b.frps_seq_no
                            AND a.ri_seq_no = b.ri_seq_no
                            AND b.fnl_binder_id = c.fnl_binder_id
                            AND b.line_cd = d.line_cd
                            AND b.frps_yy = d.frps_yy
                            AND b.frps_seq_no = d.frps_seq_no
                            AND d.dist_no = e.dist_no
                            AND d.dist_seq_no = e.dist_seq_no
                            AND e.dist_no = f.dist_no
                            AND f.policy_id = g.policy_id
                            AND g.policy_id = h.policy_id(+)
                            AND f.acct_ent_date IS NOT NULL
                            /* this will fetch taken up distributions */
                            AND f.acct_ent_date <= p_prod_date
                            /* this will fetch taken up distributions */
                            AND g.acct_ent_date IS NOT NULL
                            /* this will fetch taken up policies */
                            AND g.acct_ent_date <= p_prod_date
                            /* this will fetch taken up policies */
                            AND EXISTS (
                                   SELECT 'x'
                                     FROM giuw_pol_dist gpd
                                    WHERE gpd.dist_no = d.dist_no
                                      AND gpd.acct_ent_date IS NOT NULL)
                            AND c.acc_rev_date IS NULL)
             LOOP
                p_var_count_row := p_var_count_row + 1;
                IF     ja1.acc_ent_date IS NULL
                   AND ja1.acc_rev_date IS NULL
                   AND (    NVL (ja1.reverse_sw, 'N') = 'N'
                        AND NVL (ja1.replaced_flag, 'N') = 'N'
                       )                                  --Added by mike 10162002
                   AND ja1.acct_ent_date IS NOT NULL
                THEN
                   UPDATE giri_binder
                      SET acc_ent_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw = 'Y'
                      AND ja1.acct_ent_date IS NOT NULL
                THEN
                   IF TRUNC (ja1.acc_ent_date) < TRUNC (p_prod_date)
                   THEN
                      /* to disallow reversal of binders whose acc_ent_date > reversal date */
                      UPDATE giri_binder
                         SET acc_rev_date = p_cut_off_date
                       WHERE fnl_binder_id = ja1.fnl_binder_id;
                   END IF;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw != 'Y'
                      AND ja1.dist_flag = '5'
                THEN
                   /* to take up binders of part of the redistributed distributions */
                   UPDATE giri_binder
                      SET acc_rev_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw != 'Y'
                      AND ja1.spld_acct_ent_date IS NOT NULL
                THEN
                   /* to take up binders of spoiled policies */
                   IF TRUNC (ja1.spld_acct_ent_date) <= TRUNC (p_prod_date)
                   THEN
                      UPDATE giri_binder
                         SET acc_rev_date = p_cut_off_date
                       WHERE fnl_binder_id = ja1.fnl_binder_id;
                   END IF;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw != 'Y'
                      AND ja1.replaced_flag = 'Y'
                THEN
                   UPDATE giri_binder
                      SET acc_rev_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                /* to take up binders of negated distribution, without binder replacement */   -- judyann 02282013
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_date IS NOT NULL
                      AND (    NVL (ja1.reverse_sw, 'N') = 'N'
                           AND NVL (ja1.replaced_flag, 'N') = 'N'
                          )
                THEN
                   UPDATE giri_binder
                      SET acc_rev_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                END IF;

                --  message('Working. Please wait. Currently reading '|| to_char(variables.var_count_row) ||' records.',no_acknowledge);
             END LOOP;

             p_var_count_row := 0;
          END;
       ELSIF p_exclude_special = 'Y'
       THEN
          BEGIN
             /* exclude special policies */
             p_var_count_row := 0;

             FOR ja1 IN (SELECT c.fnl_binder_id, c.acc_ent_date, c.acc_rev_date,
                                c.replaced_flag, b.reverse_sw, f.acct_ent_date,
                                f.acct_neg_date, f.dist_flag,
                                g.spld_acct_ent_date,
                                reverse_date          -- added by judyann 0282013
                           FROM giri_frperil a,
                                giri_frps_ri b,
                                giri_binder c,
                                giri_distfrps d,
                                giuw_policyds e,
                                giuw_pol_dist f,
                                gipi_polbasic g,
                                gipi_comm_invoice h
                          WHERE 1 = 1
                            AND a.line_cd = b.line_cd
                            AND a.frps_yy = b.frps_yy
                            AND a.frps_seq_no = b.frps_seq_no
                            AND a.ri_seq_no = b.ri_seq_no
                            AND b.fnl_binder_id = c.fnl_binder_id
                            AND b.line_cd = d.line_cd
                            AND b.frps_yy = d.frps_yy
                            AND b.frps_seq_no = d.frps_seq_no
                            AND d.dist_no = e.dist_no
                            AND d.dist_seq_no = e.dist_seq_no
                            AND e.dist_no = f.dist_no
                            AND f.policy_id = g.policy_id
                            AND g.policy_id = h.policy_id(+)
                            AND f.acct_ent_date IS NOT NULL
                            /* this will fetch taken up distributions */
                            AND f.acct_ent_date <= p_prod_date
                            /* this will fetch taken up distributions */
                            AND g.acct_ent_date IS NOT NULL
                            /* this will fetch taken up policies */
                            AND g.acct_ent_date <= p_prod_date
                            /* this will fetch taken up policies */
                            AND EXISTS (
                                   SELECT 'x'
                                     FROM giuw_pol_dist gpd
                                    WHERE gpd.dist_no = d.dist_no
                                      AND gpd.acct_ent_date IS NOT NULL)
                            AND g.reg_policy_sw =
                                            'Y'
                                               /* take up only regular policies */
                            AND c.acc_rev_date IS NULL)
             LOOP
                p_var_count_row := p_var_count_row + 1;

                IF     ja1.acc_ent_date IS NULL
                   AND ja1.acc_rev_date IS NULL
                   AND (    NVL (ja1.reverse_sw, 'N') = 'N'
                        AND NVL (ja1.replaced_flag, 'N') = 'N'
                       )                                  --Added by mike 10162002
                   AND ja1.acct_ent_date IS NOT NULL
                THEN
                   UPDATE giri_binder
                      SET acc_ent_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw = 'Y'
                      AND ja1.acct_ent_date IS NOT NULL
                THEN
                   IF TRUNC (ja1.acc_ent_date) < TRUNC (p_prod_date)
                   THEN
                      /* to disallow reversal of binders whose acc_ent_date > reversal date */
                      UPDATE giri_binder
                         SET acc_rev_date = p_cut_off_date
                       WHERE fnl_binder_id = ja1.fnl_binder_id;
                   END IF;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw != 'Y'
                      AND ja1.dist_flag = '5'
                THEN
                   /* to take up binders of part of the redistributed distributions */
                   UPDATE giri_binder
                      SET acc_rev_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw != 'Y'
                      AND ja1.spld_acct_ent_date IS NOT NULL
                THEN
                   /* to take up binders of spoiled policies */
                   IF TRUNC (ja1.spld_acct_ent_date) <= TRUNC (p_prod_date)
                   THEN
                      UPDATE giri_binder
                         SET acc_rev_date = p_cut_off_date
                       WHERE fnl_binder_id = ja1.fnl_binder_id;
                   END IF;
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_sw != 'Y'
                      AND ja1.replaced_flag = 'Y'
                THEN
                   UPDATE giri_binder
                      SET acc_rev_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                /* to take up binders of negated distribution, without binder replacement */   -- judyann 02282013
                ELSIF     ja1.acc_ent_date IS NOT NULL
                      AND ja1.acc_rev_date IS NULL
                      AND ja1.reverse_date IS NOT NULL
                      AND (    NVL (ja1.reverse_sw, 'N') = 'N'
                           AND NVL (ja1.replaced_flag, 'N') = 'N'
                          )
                THEN
                   UPDATE giri_binder
                      SET acc_rev_date = p_cut_off_date
                    WHERE fnl_binder_id = ja1.fnl_binder_id;
                END IF;

             END LOOP;

             p_var_count_row := 0;
          END;
       END IF;
    END;
    
    PROCEDURE EXTRACT (p_prod_date                       IN DATE,
                       p_exclude_special                 IN giac_parameters.param_value_v%TYPE,
                       p_module_ent_comm_inc             IN giac_module_entries.item_no%TYPE,
                       p_module_ent_prem_ced             IN giac_module_entries.item_no%TYPE,
                       p_module_ent_due_to_ri            IN giac_module_entries.item_no%TYPE,
                       p_module_ent_def_input_vat        IN giac_module_entries.item_no%TYPE,
                       p_module_ent_def_output_vat       IN giac_module_entries.item_no%TYPE,
                       p_module_ent_def_cred_wh_vatri    IN giac_module_entries.item_no%TYPE,
                       p_module_ent_def_wh_vat_pay       IN giac_module_entries.item_no%TYPE,
                       p_module_ent_prem_tax             IN giac_module_entries.item_no%TYPE,
                       p_module_ent_comm_rec             IN giac_module_entries.item_no%TYPE, --marco - 07.03.2014 - AC-SPECS-2014-012_BAE_GIAB003
                       p_iss_cd                          IN OUT giac_branches.branch_cd%TYPE,
                       p_process                         IN OUT VARCHAR2,
                       p_module_name                     IN giac_modules.module_name%TYPE,
                       p_acct_line_cd                    IN OUT giis_line.acct_line_cd%TYPE,
                       p_acct_intm_cd                    IN OUT giis_intm_type.acct_intm_cd%TYPE,
                       p_var_gl_acct_id                  IN OUT giac_acct_entries.gl_acct_id%TYPE,
                       p_var_sl_type_cd                  IN OUT giac_acct_entries.sl_type_cd%TYPE,
                       p_reinsurer                       IN OUT giac_sl_types.sl_type_cd%TYPE,
                       p_line_subline_peril              IN OUT giac_sl_types.sl_type_cd%TYPE,
                       p_line_subline                    IN OUT giac_sl_types.sl_type_cd%TYPE,
                       p_sl_source_cd                    IN OUT giac_acct_entries.sl_source_cd%TYPE,
                       p_msg                             IN OUT VARCHAR2,
                       p_user_id                         IN giis_users.user_id%TYPE,
                       p_fund_cd                         IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                       p_tran_class                      IN OUT giac_acctrans.tran_class%TYPE,
                       p_tran_flag                       IN OUT giac_acctrans.tran_flag%TYPE,
                       p_cut_off_date                    IN OUT DATE,
                       p_gacc_tran_id                    IN OUT giac_acctrans.tran_id%TYPE,
                       p_var_count_row                   IN OUT   NUMBER)
    IS
       var_acct_line_cd              giis_line.acct_line_cd%TYPE;
       var_acct_subline_cd           giis_subline.acct_subline_cd%TYPE;
       var_acct_intm_cd              giis_intm_type.acct_intm_cd%TYPE;
       cvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       cvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       cvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       cvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       cvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       cvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       cvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       cvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       cvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       cvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       cvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       cvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       cvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       pvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       pvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       pvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       pvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       pvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       pvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       pvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       pvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       pvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       pvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       pvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       pvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       pvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       dvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       dvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       dvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       dvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       dvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       dvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       dvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       dvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       dvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       dvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       dvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       dvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       dvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       /* issa 01.11.2006
       ** added for deferred input vat and deferred output vat
       */
       ivar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       ivar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       ivar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       ivar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       ivar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       ivar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       ivar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       ivar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       ivar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       ivar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       ivar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       ivar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       ivar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       ovar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       ovar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       ovar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       ovar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       ovar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       ovar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       ovar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       ovar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       ovar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       ovar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       ovar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       ovar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       ovar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       --i--
       /* issa 01.13.2006
       ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
       */
       rivar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       rivar_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       rivar_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       rivar_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       rivar_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       rivar_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       rivar_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       rivar_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       rivar_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       rivar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       rivar_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       rivar_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       rivar_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       vpvar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       vpvar_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       vpvar_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       vpvar_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       vpvar_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       vpvar_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       vpvar_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       vpvar_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       vpvar_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       vpvar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       vpvar_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       vpvar_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       vpvar_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       --i--
         /* judyann 07072008; for RI premium tax accounting entry */
       ptvar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       ptvar_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       ptvar_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       ptvar_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       ptvar_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       ptvar_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       ptvar_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       ptvar_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       ptvar_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       ptvar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       ptvar_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       ptvar_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       ptvar_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       
       /* judyann 07012013; for commissions receivable */
       crvar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       crvar_gl_control_acct           giac_module_entries.gl_control_acct%TYPE;
       crvar_gl_sub_acct_1             giac_module_entries.gl_sub_acct_1%TYPE;
       crvar_gl_sub_acct_2             giac_module_entries.gl_sub_acct_2%TYPE;
       crvar_gl_sub_acct_3             giac_module_entries.gl_sub_acct_3%TYPE;
       crvar_gl_sub_acct_4             giac_module_entries.gl_sub_acct_4%TYPE;
       crvar_gl_sub_acct_5             giac_module_entries.gl_sub_acct_5%TYPE;
       crvar_gl_sub_acct_6             giac_module_entries.gl_sub_acct_6%TYPE;
       crvar_gl_sub_acct_7             giac_module_entries.gl_sub_acct_7%TYPE;
       crvar_intm_type_level           giac_module_entries.intm_type_level%TYPE;
       crvar_line_dependency_level      giac_module_entries.line_dependency_level%TYPE;
       crvar_old_new_acct_level         giac_module_entries.old_new_acct_level%TYPE;
       crvar_dr_cr_tag                  giac_module_entries.dr_cr_tag%TYPE;
       
       -- marco - 07.03.2014 - AC-SPECS-2014-012_BAE_GIAB003
       v_comm_rec_batch_takeup       giac_parameters.param_value_v%TYPE := GIACP.V('COMM_REC_BATCH_TAKEUP');
       v_ri_comm_rec_gross_tag       giac_parameters.param_value_v%TYPE := GIACP.V('RI_COMM_REC_GROSS_TAG');
       v_due_to_ri                   NUMBER(16, 2);
       v_ri_comm_amt                 NUMBER(16, 2);
    BEGIN

       IF p_exclude_special = 'N'
       THEN
          /* extrct all policies */
          BEGIN                                                    -- extract all
             --Extracting all records...
             --Running the procedure GET_MODULE_PARAMETERS 1...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_inc,
                                    cvar_gl_acct_category,
                                    cvar_gl_control_acct,
                                    cvar_gl_sub_acct_1,
                                    cvar_gl_sub_acct_2,
                                    cvar_gl_sub_acct_3,
                                    cvar_gl_sub_acct_4,
                                    cvar_gl_sub_acct_5,
                                    cvar_gl_sub_acct_6,
                                    cvar_gl_sub_acct_7,
                                    cvar_intm_type_level,
                                    cvar_line_dependency_level,
                                    cvar_old_new_acct_level,
                                    cvar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 2...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_ced,
                                    pvar_gl_acct_category,
                                    pvar_gl_control_acct,
                                    pvar_gl_sub_acct_1,
                                    pvar_gl_sub_acct_2,
                                    pvar_gl_sub_acct_3,
                                    pvar_gl_sub_acct_4,
                                    pvar_gl_sub_acct_5,
                                    pvar_gl_sub_acct_6,
                                    pvar_gl_sub_acct_7,
                                    pvar_intm_type_level,
                                    pvar_line_dependency_level,
                                    pvar_old_new_acct_level,
                                    pvar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 3...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_due_to_ri,
                                    dvar_gl_acct_category,
                                    dvar_gl_control_acct,
                                    dvar_gl_sub_acct_1,
                                    dvar_gl_sub_acct_2,
                                    dvar_gl_sub_acct_3,
                                    dvar_gl_sub_acct_4,
                                    dvar_gl_sub_acct_5,
                                    dvar_gl_sub_acct_6,
                                    dvar_gl_sub_acct_7,
                                    dvar_intm_type_level,
                                    dvar_line_dependency_level,
                                    dvar_old_new_acct_level,
                                    dvar_dr_cr_tag
                                   );
                 /* issa 01.11.2006
             ** added for deferred input vat and deferred output vat
             */
             --Running the procedure GET_MODULE_PARAMETERS 6...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_input_vat,
                                    ivar_gl_acct_category,
                                    ivar_gl_control_acct,
                                    ivar_gl_sub_acct_1,
                                    ivar_gl_sub_acct_2,
                                    ivar_gl_sub_acct_3,
                                    ivar_gl_sub_acct_4,
                                    ivar_gl_sub_acct_5,
                                    ivar_gl_sub_acct_6,
                                    ivar_gl_sub_acct_7,
                                    ivar_intm_type_level,
                                    ivar_line_dependency_level,
                                    ivar_old_new_acct_level,
                                    ivar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 7...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_output_vat,
                                    ovar_gl_acct_category,
                                    ovar_gl_control_acct,
                                    ovar_gl_sub_acct_1,
                                    ovar_gl_sub_acct_2,
                                    ovar_gl_sub_acct_3,
                                    ovar_gl_sub_acct_4,
                                    ovar_gl_sub_acct_5,
                                    ovar_gl_sub_acct_6,
                                    ovar_gl_sub_acct_7,
                                    ovar_intm_type_level,
                                    ovar_line_dependency_level,
                                    ovar_old_new_acct_level,
                                    ovar_dr_cr_tag
                                   );
               --i--
               /* issa 01.13.2006
             ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
             */
             --Running the procedure GET_MODULE_PARAMETERS 8...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_cred_wh_vatri,
                                    rivar_gl_acct_category,
                                    rivar_gl_control_acct,
                                    rivar_gl_sub_acct_1,
                                    rivar_gl_sub_acct_2,
                                    rivar_gl_sub_acct_3,
                                    rivar_gl_sub_acct_4,
                                    rivar_gl_sub_acct_5,
                                    rivar_gl_sub_acct_6,
                                    rivar_gl_sub_acct_7,
                                    rivar_intm_type_level,
                                    rivar_line_dependency_level,
                                    rivar_old_new_acct_level,
                                    rivar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 9...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_wh_vat_pay,
                                    vpvar_gl_acct_category,
                                    vpvar_gl_control_acct,
                                    vpvar_gl_sub_acct_1,
                                    vpvar_gl_sub_acct_2,
                                    vpvar_gl_sub_acct_3,
                                    vpvar_gl_sub_acct_4,
                                    vpvar_gl_sub_acct_5,
                                    vpvar_gl_sub_acct_6,
                                    vpvar_gl_sub_acct_7,
                                    vpvar_intm_type_level,
                                    vpvar_line_dependency_level,
                                    vpvar_old_new_acct_level,
                                    vpvar_dr_cr_tag
                                   );
             --i--
               /* judyann 07072008; for RI premium tax */
             --Running the procedure GET_MODULE_PARAMETERS 10...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_tax,
                                    ptvar_gl_acct_category,
                                    ptvar_gl_control_acct,
                                    ptvar_gl_sub_acct_1,
                                    ptvar_gl_sub_acct_2,
                                    ptvar_gl_sub_acct_3,
                                    ptvar_gl_sub_acct_4,
                                    ptvar_gl_sub_acct_5,
                                    ptvar_gl_sub_acct_6,
                                    ptvar_gl_sub_acct_7,
                                    ptvar_intm_type_level,
                                    ptvar_line_dependency_level,
                                    ptvar_old_new_acct_level,
                                    ptvar_dr_cr_tag
                                   );
                                   
             /* judyann 07012013; for commissions receivable */
              --Running the procedure GET_MODULE_PARAMETERS 13...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_rec, 
                                    crvar_gl_acct_category,
                                    crvar_gl_control_acct,
                                    crvar_gl_sub_acct_1,
                                    crvar_gl_sub_acct_2,
                                    crvar_gl_sub_acct_3,
                                    crvar_gl_sub_acct_4,
                                    crvar_gl_sub_acct_5,
                                    crvar_gl_sub_acct_6,    
                                    crvar_gl_sub_acct_7,
                                    crvar_intm_type_level,
                                    crvar_line_dependency_level,
                                        crvar_old_new_acct_level,
                                    crvar_dr_cr_tag
                                   );

             IF    cvar_gl_acct_category IS NOT NULL
                OR pvar_gl_acct_category IS NOT NULL
                OR dvar_gl_acct_category IS NOT NULL
                OR ivar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR ovar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR rivar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR vpvar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR ptvar_gl_acct_category IS NOT NULL          -- judyann 07072008
                OR crvar_gl_acct_category IS NOT NULL -- judyann 07012013
             THEN
                p_iss_cd := NULL;
    /*
               FOR ja1 IN(
                     SELECT c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd) iss_cd, g.line_cd, i.acct_line_cd,
                            g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd,
                            decode(g.iss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                            SUM(a.ri_comm_amt*d.currency_rt) ri_comm_amt,
                            SUM(a.ri_prem_amt*d.currency_rt) ri_prem_amt,
                            --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
    */                        /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
    /*                        (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt))
                             - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)) due_to_ri_local, --issa 01.13.2006
                            (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt))
                             - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)) due_to_ri_foreign, --issa 01.13.2006
                            SUM(NVL(a.ri_prem_vat,0)*d.currency_rt) ri_prem_vat, --issa 01.11.2006
                            SUM(NVL(a.ri_comm_vat,0)*d.currency_rt) ri_comm_vat,  --issa 01.11.2006
                            SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt) ri_wholding_vat,  --issa 01.13.2006
                            SUM(NVL(a.prem_tax,0)*d.currency_rt) prem_tax,   -- judyann 07072008
                            k.local_foreign_sw --issa 01.13.2006
                       FROM giri_frperil a,
                            giri_frps_ri b,
                            giri_binder c,
                            giri_distfrps d,
                            giuw_policyds e,
                            giuw_pol_dist f,
                            gipi_polbasic g,
                            giac_bae_pol_parent_intm_v h,
                            giis_line  i,
                            giis_subline j,
                            giis_reinsurer k --issa 01.13.2006, to get the local/foreign sw
                      WHERE a.line_cd = b.line_cd            -- frperil 
                        AND a.frps_yy = b.frps_yy              -- frperil 
                        AND a.frps_seq_no = b.frps_seq_no      -- frperil 
                        AND a.ri_seq_no = b.ri_seq_no          -- frperil 
                        AND a.ri_cd = k.ri_cd                                  -- frperil and reinsurer issa 01.13.2006
                        AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                        AND b.line_cd = d.line_cd              -- frpsri 
                        AND b.frps_yy = d.frps_yy              -- frpsri 
                        AND b.frps_seq_no = d.frps_seq_no      -- frpsri 
                        AND d.dist_no = e.dist_no              -- distfrps 
                        AND d.dist_seq_no = e.dist_seq_no      -- distfrps 
                        AND e.dist_no = f.dist_no              -- policyds 
                        AND g.policy_id = h.policy_id(+)       -- polbasic 
                        AND f.policy_id = g.policy_id          -- pol_dist 
                        AND g.acct_ent_date IS NOT NULL
                        AND g.acct_ent_date <= :prod.cut_off_date
                        AND ( trunc(c.acc_ent_date) = :prod.cut_off_date
                              OR (trunc(c.acc_rev_date) = :prod.cut_off_date))
                        AND g.line_cd = i.line_cd              -- polbasic 
                        AND g.line_cd = j.line_cd              -- polibasic 
                        AND g.subline_cd = j.subline_cd        -- polbasic 
                   GROUP BY c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd), g.line_cd, i.acct_line_cd,
                        g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd, decode(g.iss_cd,'RI',5 , h.acct_intm_cd), k.local_foreign_sw /*issa 01.13.2006*/
                                                                                                                                                               /*)
               LOOP
    */
       -- judyann 10052007; separated SELECT statement for reversed binders/negated distribution
                FOR ja1 IN
                   (SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             DECODE (g.iss_cd,
                                     'RI', 5,
                                     h.acct_intm_cd
                                    ) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                               /* (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               ) due_to_ri_local,                --issa 01.13.2006
                               (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                                - SUM (NVL (a.prem_tax, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                               ) due_to_ri_foreign,              --issa 01.13.2006 */
                             -- marco - 07.30.2014 - replaced with lines below
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_ent_date) = p_prod_date
                         --AND TRUNC(f.acct_ent_date) = :prod.cut_off_date            -- judyann 07292011; include new binders created for reversed binders of unnegated distributions
                         AND TRUNC (f.acct_ent_date) <= p_prod_date
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.iss_cd <>
                                DECODE
                                   (NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N'),
                                    'N', '**',
                                    'Y', giisp.v ('ISS_CD_RI')
                                   )  -- exclude inward policies if parameter is Y
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             DECODE (g.iss_cd, 'RI', 5, h.acct_intm_cd),
                             k.local_foreign_sw
                    UNION
                    SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             DECODE (g.iss_cd,
                                     'RI', 5,
                                     h.acct_intm_cd
                                    ) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                               /* (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               ) due_to_ri_local,                --issa 01.13.2006
                               (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                                - SUM (NVL (a.prem_tax, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                               ) due_to_ri_foreign,              --issa 01.13.2006 */
                             -- marco - 07.30.2014 - replaced with lines below
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013 
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_rev_date) = p_prod_date
                         --AND TRUNC(f.acct_neg_date) = :prod.cut_off_date
                         AND (   (    f.dist_flag = '4'
                                  AND TRUNC (f.acct_neg_date) = p_prod_date
                                 )
                              OR (f.dist_flag = '3' AND b.reverse_sw = 'Y')
                              OR (f.dist_flag = '5')) -- added '5' for redistributed policies : SR-4824 shan 08.03.2015
                         -- judyann 07292011; include reversed binders (unnegated distributions)
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.iss_cd <>
                                DECODE
                                   (NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N'),
                                    'N', '**',
                                    'Y', giisp.v ('ISS_CD_RI')
                                   )  -- exclude inward policies if parameter is Y
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             DECODE (g.iss_cd, 'RI', 5, h.acct_intm_cd),
                             k.local_foreign_sw)
                LOOP
                   p_process := 'premium ceded and commission income';

                   IF NVL (p_iss_cd, 'xx') != ja1.iss_cd
                   THEN
                      GIACB003_PKG.insert_giac_acctrans (ja1.iss_cd,
                                    p_prod_date,
                                    p_user_id,
                                    p_iss_cd,
                                    p_fund_cd,
                                    p_tran_class,
                                    p_tran_flag,
                                    p_cut_off_date,
                                    p_gacc_tran_id);
                      p_iss_cd := ja1.iss_cd;
                   END IF;

                   IF cvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries (cvar_gl_acct_category,
                               cvar_gl_control_acct,
                               cvar_gl_sub_acct_1,
                               cvar_gl_sub_acct_2,
                               cvar_gl_sub_acct_3,
                               cvar_gl_sub_acct_4,
                               cvar_gl_sub_acct_5,
                               cvar_gl_sub_acct_6,
                               cvar_gl_sub_acct_7,
                               cvar_intm_type_level,
                               cvar_line_dependency_level,
                               cvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_comm_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id 
                              );
                   END IF;

                   IF pvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries (pvar_gl_acct_category,
                               pvar_gl_control_acct,
                               pvar_gl_sub_acct_1,
                               pvar_gl_sub_acct_2,
                               pvar_gl_sub_acct_3,
                               pvar_gl_sub_acct_4,
                               pvar_gl_sub_acct_5,
                               pvar_gl_sub_acct_6,
                               pvar_gl_sub_acct_7,
                               pvar_intm_type_level,
                               pvar_line_dependency_level,
                               pvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_prem_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;

                   /* issa 01.13.2006
                   ** to consider local/foreign ri
                   */
                   IF     dvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_local; --- ja1.ri_comm_vat; --mikel 09.29.2015; comment out to correct entries for DUE TO; related to FGIC SR 20143
                         ELSE
                            v_due_to_ri := ja1.due_to_ri_local + ja1.ri_comm_vat; --mikel 10.02.2014; added ja1.ri_comm_vat
                         END IF;
                      ELSE
                        --v_due_to_ri := ja1.due_to_ri_local - ja1.ri_comm_vat; --mikel 10.02.2014; replaced by codes below
                        v_due_to_ri := ja1.due_to_ri_local; --mikel 10.02.2014
                      END IF;
                      
                      GIACB003_pkg.entries (dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   ELSE                                                  --foreign
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_foreign; --- ja1.ri_comm_vat; --mikel 09.29.2015; comment out to correct entries for DUE TO; related to FGIC SR 20143
                         ELSE
                            v_due_to_ri := ja1.due_to_ri_foreign  + ja1.ri_comm_vat; --mikel 10.02.2014; added ja1.ri_comm_vat
                         END IF;
                      ELSE
                        v_due_to_ri := ja1.due_to_ri_foreign - ja1.ri_comm_vat; --mikel 10.02.2014; replaced by codes below
                        v_due_to_ri := ja1.due_to_ri_foreign;--mikel 10.02.2014
                      END IF;
                      
                      GIACB003_PKG.entries (dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;

                   /*IF dvar_gl_acct_category IS NOT NULL
                   THEN
                      entries (
                         dvar_gl_acct_category      ,  dvar_gl_control_acct    ,
                                dvar_gl_sub_acct_1         ,  dvar_gl_sub_acct_2      ,
                                  dvar_gl_sub_acct_3         ,  dvar_gl_sub_acct_4      ,
                                  dvar_gl_sub_acct_5         ,  dvar_gl_sub_acct_6      ,
                         dvar_gl_sub_acct_7         ,  dvar_intm_type_level    ,
                                 dvar_line_dependency_level ,  dvar_dr_cr_tag          ,
                         ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                         ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                         ja1.acct_intm_cd           ,  ja1.due_to_ri           ,
                         ja1.iss_cd                 ,  ja1.ri_cd);
                   END IF;*/ --issa 01.13.2006 changed to consider local/foreign ri

                   /* issa 01.11.2006
                              ** added for deferred input vat and deferred output vat
                              */
                   IF     ivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      GIACB003_pkg.entries (ivar_gl_acct_category,
                               ivar_gl_control_acct,
                               ivar_gl_sub_acct_1,
                               ivar_gl_sub_acct_2,
                               ivar_gl_sub_acct_3,
                               ivar_gl_sub_acct_4,
                               ivar_gl_sub_acct_5,
                               ivar_gl_sub_acct_6,
                               ivar_gl_sub_acct_7,
                               ivar_intm_type_level,
                               ivar_line_dependency_level,
                               ivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_prem_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;

                   IF ovar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries (ovar_gl_acct_category,
                               ovar_gl_control_acct,
                               ovar_gl_sub_acct_1,
                               ovar_gl_sub_acct_2,
                               ovar_gl_sub_acct_3,
                               ovar_gl_sub_acct_4,
                               ovar_gl_sub_acct_5,
                               ovar_gl_sub_acct_6,
                               ovar_gl_sub_acct_7,
                               ovar_intm_type_level,
                               ovar_line_dependency_level,
                               ovar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_comm_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;

                   --i--

                   /* issa 01.13.2006
                   ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
                   */
                   IF     rivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries (rivar_gl_acct_category,
                               rivar_gl_control_acct,
                               rivar_gl_sub_acct_1,
                               rivar_gl_sub_acct_2,
                               rivar_gl_sub_acct_3,
                               rivar_gl_sub_acct_4,
                               rivar_gl_sub_acct_5,
                               rivar_gl_sub_acct_6,
                               rivar_gl_sub_acct_7,
                               rivar_intm_type_level,
                               rivar_line_dependency_level,
                               rivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;

                   IF     vpvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries (vpvar_gl_acct_category,
                               vpvar_gl_control_acct,
                               vpvar_gl_sub_acct_1,
                               vpvar_gl_sub_acct_2,
                               vpvar_gl_sub_acct_3,
                               vpvar_gl_sub_acct_4,
                               vpvar_gl_sub_acct_5,
                               vpvar_gl_sub_acct_6,
                               vpvar_gl_sub_acct_7,
                               vpvar_intm_type_level,
                               vpvar_line_dependency_level,
                               vpvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;

                   --i--
                   /* judyann 07072008; for RI premium tax */
                   IF     ptvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries (ptvar_gl_acct_category,
                               ptvar_gl_control_acct,
                               ptvar_gl_sub_acct_1,
                               ptvar_gl_sub_acct_2,
                               ptvar_gl_sub_acct_3,
                               ptvar_gl_sub_acct_4,
                               ptvar_gl_sub_acct_5,
                               ptvar_gl_sub_acct_6,
                               ptvar_gl_sub_acct_7,
                               ptvar_intm_type_level,
                               ptvar_line_dependency_level,
                               ptvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.prem_tax,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id  
                              );
                   END IF;
                   
                   /* judyann 07012013; for commissions receivable */ 
                    IF NVL(v_comm_rec_batch_takeup,'N') = 'Y' THEN
                        IF crvar_gl_acct_category IS NOT NULL 
                        THEN
                           -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                           IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                              v_ri_comm_amt := ja1.ri_comm_amt;
                           ELSE
                              v_ri_comm_amt := ja1.ri_comm_amt + ja1.ri_comm_vat;
                           END IF;
                        
                          GIACB003_PKG.entries (
                             crvar_gl_acct_category      ,  crvar_gl_control_acct    ,
                             crvar_gl_sub_acct_1         ,  crvar_gl_sub_acct_2      ,
                             crvar_gl_sub_acct_3         ,  crvar_gl_sub_acct_4      ,
                             crvar_gl_sub_acct_5         ,  crvar_gl_sub_acct_6      ,
                             crvar_gl_sub_acct_7         ,  crvar_intm_type_level    ,
                             crvar_line_dependency_level ,  crvar_dr_cr_tag          ,
                             ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                             ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                             ja1.acct_intm_cd           ,  v_ri_comm_amt         ,
                             ja1.iss_cd                 ,  ja1.ri_cd,
                             p_prod_date,
                             p_acct_line_cd,
                             p_acct_intm_cd,
                             p_var_gl_acct_id,
                             p_var_sl_type_cd,
                             p_reinsurer,
                             p_line_subline_peril,
                             p_line_subline,
                             p_sl_source_cd,
                             p_process,
                             p_msg,
                             p_gacc_tran_id,
                             p_tran_class,
                             p_fund_cd,
                             p_cut_off_date,
                             p_tran_flag,
                             p_var_count_row,
                             p_user_id);
                        END IF;
                    END IF;
                END LOOP ja1;
             END IF;
          END;                                                      -- extract all
       ELSIF p_exclude_special = 'Y'
       THEN
          BEGIN                                       -- exclude special policies
             --Extracting regular polices...
             --Running the procedure GET_MODULE_PARAMETERS 1...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_inc,
                                    cvar_gl_acct_category,
                                    cvar_gl_control_acct,
                                    cvar_gl_sub_acct_1,
                                    cvar_gl_sub_acct_2,
                                    cvar_gl_sub_acct_3,
                                    cvar_gl_sub_acct_4,
                                    cvar_gl_sub_acct_5,
                                    cvar_gl_sub_acct_6,
                                    cvar_gl_sub_acct_7,
                                    cvar_intm_type_level,
                                    cvar_line_dependency_level,
                                    cvar_old_new_acct_level,
                                    cvar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 2...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_ced,
                                    pvar_gl_acct_category,
                                    pvar_gl_control_acct,
                                    pvar_gl_sub_acct_1,
                                    pvar_gl_sub_acct_2,
                                    pvar_gl_sub_acct_3,
                                    pvar_gl_sub_acct_4,
                                    pvar_gl_sub_acct_5,
                                    pvar_gl_sub_acct_6,
                                    pvar_gl_sub_acct_7,
                                    pvar_intm_type_level,
                                    pvar_line_dependency_level,
                                    pvar_old_new_acct_level,
                                    pvar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 3...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_due_to_ri,
                                    dvar_gl_acct_category,
                                    dvar_gl_control_acct,
                                    dvar_gl_sub_acct_1,
                                    dvar_gl_sub_acct_2,
                                    dvar_gl_sub_acct_3,
                                    dvar_gl_sub_acct_4,
                                    dvar_gl_sub_acct_5,
                                    dvar_gl_sub_acct_6,
                                    dvar_gl_sub_acct_7,
                                    dvar_intm_type_level,
                                    dvar_line_dependency_level,
                                    dvar_old_new_acct_level,
                                    dvar_dr_cr_tag
                                   );
               /* issa 01.11.2006
             ** added for deferred input vat and deferred output vat
             */
             --Running the procedure GET_MODULE_PARAMETERS 6...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_input_vat,
                                    ivar_gl_acct_category,
                                    ivar_gl_control_acct,
                                    ivar_gl_sub_acct_1,
                                    ivar_gl_sub_acct_2,
                                    ivar_gl_sub_acct_3,
                                    ivar_gl_sub_acct_4,
                                    ivar_gl_sub_acct_5,
                                    ivar_gl_sub_acct_6,
                                    ivar_gl_sub_acct_7,
                                    ivar_intm_type_level,
                                    ivar_line_dependency_level,
                                    ivar_old_new_acct_level,
                                    ivar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 7...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_output_vat,
                                    ovar_gl_acct_category,
                                    ovar_gl_control_acct,
                                    ovar_gl_sub_acct_1,
                                    ovar_gl_sub_acct_2,
                                    ovar_gl_sub_acct_3,
                                    ovar_gl_sub_acct_4,
                                    ovar_gl_sub_acct_5,
                                    ovar_gl_sub_acct_6,
                                    ovar_gl_sub_acct_7,
                                    ovar_intm_type_level,
                                    ovar_line_dependency_level,
                                    ovar_old_new_acct_level,
                                    ovar_dr_cr_tag
                                   );
               --i--
                /* issa 01.13.2006
             ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
             */
             --Running the procedure GET_MODULE_PARAMETERS 8...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_cred_wh_vatri,
                                    rivar_gl_acct_category,
                                    rivar_gl_control_acct,
                                    rivar_gl_sub_acct_1,
                                    rivar_gl_sub_acct_2,
                                    rivar_gl_sub_acct_3,
                                    rivar_gl_sub_acct_4,
                                    rivar_gl_sub_acct_5,
                                    rivar_gl_sub_acct_6,
                                    rivar_gl_sub_acct_7,
                                    rivar_intm_type_level,
                                    rivar_line_dependency_level,
                                    rivar_old_new_acct_level,
                                    rivar_dr_cr_tag
                                   );
             --Running the procedure GET_MODULE_PARAMETERS 9...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_wh_vat_pay,
                                    vpvar_gl_acct_category,
                                    vpvar_gl_control_acct,
                                    vpvar_gl_sub_acct_1,
                                    vpvar_gl_sub_acct_2,
                                    vpvar_gl_sub_acct_3,
                                    vpvar_gl_sub_acct_4,
                                    vpvar_gl_sub_acct_5,
                                    vpvar_gl_sub_acct_6,
                                    vpvar_gl_sub_acct_7,
                                    vpvar_intm_type_level,
                                    vpvar_line_dependency_level,
                                    vpvar_old_new_acct_level,
                                    vpvar_dr_cr_tag
                                   );
             --i--
                      /* judyann 07072008; for RI premium tax */
             --Running the procedure GET_MODULE_PARAMETERS 10...
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_tax,
                                    ptvar_gl_acct_category,
                                    ptvar_gl_control_acct,
                                    ptvar_gl_sub_acct_1,
                                    ptvar_gl_sub_acct_2,
                                    ptvar_gl_sub_acct_3,
                                    ptvar_gl_sub_acct_4,
                                    ptvar_gl_sub_acct_5,
                                    ptvar_gl_sub_acct_6,
                                    ptvar_gl_sub_acct_7,
                                    ptvar_intm_type_level,
                                    ptvar_line_dependency_level,
                                    ptvar_old_new_acct_level,
                                    ptvar_dr_cr_tag
                                   );
                                   
               /* judyann 07012013; for commissions receivable */
               --Running the procedure GET_MODULE_PARAMETERS 13...
            IF NVL(v_comm_rec_batch_takeup,'N') = 'Y' THEN --added by robert 03.11.2015
               GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_rec, 
                                    crvar_gl_acct_category,
                                    crvar_gl_control_acct,
                                    crvar_gl_sub_acct_1,
                                    crvar_gl_sub_acct_2,
                                    crvar_gl_sub_acct_3,
                                    crvar_gl_sub_acct_4,
                                    crvar_gl_sub_acct_5,
                                    crvar_gl_sub_acct_6,    
                                    crvar_gl_sub_acct_7,
                                    crvar_intm_type_level,
                                    crvar_line_dependency_level,
                                        crvar_old_new_acct_level,
                                    crvar_dr_cr_tag
                                   );
            END IF;
                                   
             IF    cvar_gl_acct_category IS NOT NULL
                OR pvar_gl_acct_category IS NOT NULL
                OR dvar_gl_acct_category IS NOT NULL
                OR ivar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR ovar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR rivar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR vpvar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR ptvar_gl_acct_category IS NOT NULL          -- judyann 07072008
                OR crvar_gl_acct_category IS NOT NULL -- judyann 07012013
             THEN
                p_iss_cd := NULL;
    /*
               FOR ja1 IN(
                     SELECT c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd) iss_cd, g.line_cd, i.acct_line_cd,
                            g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd,
                            --decode(g.iss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                            SUM(a.ri_comm_amt*d.currency_rt) ri_comm_amt,
                            SUM(a.ri_prem_amt*d.currency_rt) ri_prem_amt,
                            --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
    */                        /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
    /*                      (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)) due_to_ri_local, --issa 01.13.2006
                            (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)) due_to_ri_foreign, --issa 01.13.2006
                            SUM(NVL(a.ri_prem_vat,0)*d.currency_rt) ri_prem_vat, --issa 01.11.2006
                            SUM(NVL(a.ri_comm_vat,0)*d.currency_rt) ri_comm_vat,  --issa 01.11.2006
                            SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt) ri_wholding_vat,  --issa 01.13.2006
                            k.local_foreign_sw --issa 01.13.2006
                       FROM giri_frperil a,
                            giri_frps_ri b,
                            giri_binder c,
                            giri_distfrps d,
                            giuw_policyds e,
                            giuw_pol_dist f,
                            gipi_polbasic g,
                            --giac_bae_pol_parent_intm_v h,
                            giis_line  i,
                            giis_subline j,
                            giis_reinsurer k --issa 01.13.2006, to get the local/foreign sw
                      WHERE a.line_cd = b.line_cd            -- frperil 
                        AND a.frps_yy = b.frps_yy              -- frperil 
                        AND a.frps_seq_no = b.frps_seq_no      -- frperil 
                        AND a.ri_seq_no = b.ri_seq_no          -- frperil 
                        AND a.ri_cd = k.ri_cd                                  -- frperil and reinsurer issa 01.13.2006
                        AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                        AND b.line_cd = d.line_cd              -- frpsri 
                        AND b.frps_yy = d.frps_yy              -- frpsri 
                        AND b.frps_seq_no = d.frps_seq_no      -- frpsri 
                        AND d.dist_no = e.dist_no              -- distfrps 
                        AND d.dist_seq_no = e.dist_seq_no      -- distfrps 
                        AND e.dist_no = f.dist_no              -- policyds 
                        --AND g.policy_id = h.policy_id(+)       -- polbasic 
                        AND f.policy_id = g.policy_id          -- pol_dist 
                        AND g.acct_ent_date IS NOT NULL
                        AND g.acct_ent_date <= :prod.cut_off_date
                        AND ( trunc(c.acc_ent_date) = :prod.cut_off_date
                              OR (trunc(c.acc_rev_date) = :prod.cut_off_date ))
                        AND ( trunc(f.acct_ent_date) = :prod.cut_off_date
                               OR (trunc(f.acct_neg_date) = :prod.cut_off_date ))   -- added 03112005
                        AND g.line_cd = i.line_cd              -- polbasic 
                        AND g.line_cd = j.line_cd              -- polibasic 
                        AND g.subline_cd = j.subline_cd        -- polbasic 
                        AND g.reg_policy_sw = 'Y'             -- exclude special policies
                   GROUP BY c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd), g.line_cd, i.acct_line_cd,
                            g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd, k.local_foreign_sw /*issa 01.13.2006*/
                                                                                                                         /*) --, decode(g.iss_cd,'RI',5 , h.acct_intm_cd) )
               LOOP
    */
       -- judyann 10052007; separated SELECT statement for reversed binders/negated distribution
                FOR ja1 IN
                   (SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             
                             --decode(g.iss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                               /* (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               ) due_to_ri_local,                --issa 01.13.2006
                               (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                                - SUM (NVL (a.prem_tax, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                               ) due_to_ri_foreign,              --issa 01.13.2006 */
                               -- marco - 07.30.2014 - replaced with lines below
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             --giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         --AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_ent_date) = p_prod_date
                         --AND TRUNC(f.acct_ent_date) = :prod.cut_off_date            -- judyann 07292011; include new binders created for reversed binders of unnegated distributions
                         AND TRUNC (f.acct_ent_date) <= p_prod_date
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.reg_policy_sw = 'Y'     -- exclude special policies
                         AND g.iss_cd <>
                                DECODE
                                   (NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N'),
                                    'N', '**',
                                    'Y', giisp.v ('ISS_CD_RI')
                                   )  -- exclude inward policies if parameter is Y
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             k.local_foreign_sw
                    UNION
                    SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             
                             --decode(g.isss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                               /* (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               ) due_to_ri_local,                --issa 01.13.2006
                               (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                                - SUM (NVL (a.prem_tax, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                               ) due_to_ri_foreign,              --issa 01.13.2006 */
                             -- marco - 07.30.2014 - replaced with lines below
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             --giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         --AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_rev_date) = p_prod_date
                         --AND TRUNC(f.acct_neg_date) = :prod.cut_off_date
                         AND (   (    f.dist_flag = '4'
                                  AND TRUNC (f.acct_neg_date) = p_prod_date
                                 )
                              OR (f.dist_flag = '3' AND b.reverse_sw = 'Y')
                              OR (f.dist_flag = '5')) -- added '5' for redistributed policies : SR-4824 shan 08.03.2015
                         -- judyann 07292011; include reversed binders (unnegated distributions)
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.reg_policy_sw = 'Y'     -- exclude special policies
                         AND g.iss_cd <>
                                DECODE
                                   (NVL (giacp.v ('SEPARATE_CESSIONS_GL'), 'N'),
                                    'N', '**',
                                    'Y', giisp.v ('ISS_CD_RI')
                                   )  -- exclude inward policies if parameter is Y
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             k.local_foreign_sw)
                LOOP
                   p_process := 'premium ceded and commission income';

                   IF NVL (p_iss_cd, 'xx') != ja1.iss_cd
                   THEN
                      GIACB003_PKG.insert_giac_acctrans (ja1.iss_cd,
                                            p_prod_date,
                                            p_user_id,
                                            p_iss_cd,
                                            p_fund_cd,
                                            p_tran_class,
                                            p_tran_flag,
                                            p_cut_off_date,
                                            p_gacc_tran_id);
                      p_iss_cd := ja1.iss_cd;
                   END IF;

                   IF cvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries (cvar_gl_acct_category,
                               cvar_gl_control_acct,
                               cvar_gl_sub_acct_1,
                               cvar_gl_sub_acct_2,
                               cvar_gl_sub_acct_3,
                               cvar_gl_sub_acct_4,
                               cvar_gl_sub_acct_5,
                               cvar_gl_sub_acct_6,
                               cvar_gl_sub_acct_7,
                               cvar_intm_type_level,
                               cvar_line_dependency_level,
                               cvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                --ja1.acct_intm_cd           ,
                               ja1.ri_comm_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF pvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries (pvar_gl_acct_category,
                               pvar_gl_control_acct,
                               pvar_gl_sub_acct_1,
                               pvar_gl_sub_acct_2,
                               pvar_gl_sub_acct_3,
                               pvar_gl_sub_acct_4,
                               pvar_gl_sub_acct_5,
                               pvar_gl_sub_acct_6,
                               pvar_gl_sub_acct_7,
                               pvar_intm_type_level,
                               pvar_line_dependency_level,
                               pvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                            --ja1.acct_intm_cd
                               ja1.ri_prem_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   /* issa 01.13.2006
                   ** to consider local/foreign ri
                   */
                   IF     dvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_local; --- ja1.ri_comm_vat; --mikel 09.29.2015; comment out to correct entries for DUE TO; related to FGIC SR 20143
                         ELSE
                            v_due_to_ri := ja1.due_to_ri_local + ja1.ri_comm_vat; --mikel 10.02.2014; added ja1.ri_comm_vat;
                         END IF;
                      ELSE
                        --v_due_to_ri := ja1.due_to_ri_local - ja1.ri_comm_vat; --mikel 10.02.2014; replaced by codes below
                        v_due_to_ri := ja1.due_to_ri_local; --mikel 10.02.2014
                      END IF;
                      
                      GIACB003_PKG.entries (dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                --ja1.acct_intm_cd           ,
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   ELSE                                                  --foreign
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_foreign; --- ja1.ri_comm_vat; --mikel 09.29.2015; comment out to correct entries for DUE TO; related to FGIC SR 20143
                         ELSE
                            v_due_to_ri := ja1.due_to_ri_foreign  + ja1.ri_comm_vat; --mikel 10.02.2014; added ja1.ri_comm_vat;
                         END IF;
                      ELSE
                        --v_due_to_ri := ja1.due_to_ri_foreign - ja1.ri_comm_vat; --mikel 10.02.2014; replaced by codes below
                        v_due_to_ri := ja1.due_to_ri_foreign; --mikel 10.02.2014
                      END IF;
                      
                      GIACB003_PKG.entries (dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                            --ja1.acct_intm_cd
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   /*IF dvar_gl_acct_category IS NOT NULL
                   THEN
                      entries (
                         dvar_gl_acct_category      ,  dvar_gl_control_acct    ,
                            dvar_gl_sub_acct_1         ,  dvar_gl_sub_acct_2      ,
                            dvar_gl_sub_acct_3         ,  dvar_gl_sub_acct_4      ,
                            dvar_gl_sub_acct_5         ,  dvar_gl_sub_acct_6      ,
                         dvar_gl_sub_acct_7         ,  dvar_intm_type_level    ,
                           dvar_line_dependency_level ,  dvar_dr_cr_tag          ,
                         ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                         ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                         NULL, --ja1.acct_intm_cd           ,
                         ja1.due_to_ri           ,
                         ja1.iss_cd                 ,  ja1.ri_cd);
                   END IF;*/ --issa 01.13.2006 changed to consider local/foreign ri

                   /* issa 01.11.2006
                              ** added for deferred input vat and deferred output vat
                              */
                   IF     ivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      GIACB003_PKG.entries (ivar_gl_acct_category,
                               ivar_gl_control_acct,
                               ivar_gl_sub_acct_1,
                               ivar_gl_sub_acct_2,
                               ivar_gl_sub_acct_3,
                               ivar_gl_sub_acct_4,
                               ivar_gl_sub_acct_5,
                               ivar_gl_sub_acct_6,
                               ivar_gl_sub_acct_7,
                               ivar_intm_type_level,
                               ivar_line_dependency_level,
                               ivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_prem_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF ovar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries (ovar_gl_acct_category,
                               ovar_gl_control_acct,
                               ovar_gl_sub_acct_1,
                               ovar_gl_sub_acct_2,
                               ovar_gl_sub_acct_3,
                               ovar_gl_sub_acct_4,
                               ovar_gl_sub_acct_5,
                               ovar_gl_sub_acct_6,
                               ovar_gl_sub_acct_7,
                               ovar_intm_type_level,
                               ovar_line_dependency_level,
                               ovar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_comm_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   --i--

                   /* issa 01.13.2006
                   ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
                   */
                   IF     rivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries (rivar_gl_acct_category,
                               rivar_gl_control_acct,
                               rivar_gl_sub_acct_1,
                               rivar_gl_sub_acct_2,
                               rivar_gl_sub_acct_3,
                               rivar_gl_sub_acct_4,
                               rivar_gl_sub_acct_5,
                               rivar_gl_sub_acct_6,
                               rivar_gl_sub_acct_7,
                               rivar_intm_type_level,
                               rivar_line_dependency_level,
                               rivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF     vpvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries (vpvar_gl_acct_category,
                               vpvar_gl_control_acct,
                               vpvar_gl_sub_acct_1,
                               vpvar_gl_sub_acct_2,
                               vpvar_gl_sub_acct_3,
                               vpvar_gl_sub_acct_4,
                               vpvar_gl_sub_acct_5,
                               vpvar_gl_sub_acct_6,
                               vpvar_gl_sub_acct_7,
                               vpvar_intm_type_level,
                               vpvar_line_dependency_level,
                               vpvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                         --i--
                   /* judyann 07072008; for RI premium tax */
                   IF     ptvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries (ptvar_gl_acct_category,
                               ptvar_gl_control_acct,
                               ptvar_gl_sub_acct_1,
                               ptvar_gl_sub_acct_2,
                               ptvar_gl_sub_acct_3,
                               ptvar_gl_sub_acct_4,
                               ptvar_gl_sub_acct_5,
                               ptvar_gl_sub_acct_6,
                               ptvar_gl_sub_acct_7,
                               ptvar_intm_type_level,
                               ptvar_line_dependency_level,
                               ptvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.prem_tax,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;
                   
                   /* judyann 07012013; for commissions receivable */
                    IF NVL(v_comm_rec_batch_takeup,'N') = 'Y' THEN
                        IF crvar_gl_acct_category IS NOT NULL 
                        THEN                        
                           -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                           IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                              v_ri_comm_amt := ja1.ri_comm_amt;
                           ELSE
                              v_ri_comm_amt := ja1.ri_comm_amt + ja1.ri_comm_vat;
                           END IF;
                           
                           GIACB003_PKG.entries (
                                crvar_gl_acct_category      ,  crvar_gl_control_acct    ,
                                crvar_gl_sub_acct_1         ,  crvar_gl_sub_acct_2      ,
                                crvar_gl_sub_acct_3         ,  crvar_gl_sub_acct_4      ,
                                crvar_gl_sub_acct_5         ,  crvar_gl_sub_acct_6      ,
                                crvar_gl_sub_acct_7         ,  crvar_intm_type_level    ,
                                crvar_line_dependency_level ,  crvar_dr_cr_tag          ,
                                ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                                ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                                NULL                       ,  v_ri_comm_amt         ,
                                ja1.iss_cd                 ,  ja1.ri_cd,
                                p_prod_date,
                                p_acct_line_cd,
                                p_acct_intm_cd,
                                p_var_gl_acct_id,
                                p_var_sl_type_cd,
                                p_reinsurer,
                                p_line_subline_peril,
                                p_line_subline,
                                p_sl_source_cd,
                                p_process,
                                p_msg,
                                p_gacc_tran_id,
                                p_tran_class,
                                p_fund_cd,
                                p_cut_off_date,
                                p_tran_flag,
                                p_var_count_row,
                                p_user_id);
                        END IF;
                     END IF;
                END LOOP ja1;
             END IF;
          END;                                         -- exclude special policies
       END IF;                                        -- variables.exclude_special
    END;
    
    PROCEDURE get_module_parameters (p_module_name               IN GIAC_MODULES.module_name%TYPE,
                                     p_msg                       IN OUT VARCHAR2,
                                     var_module_item_no          IN       giac_module_entries.item_no%TYPE,
                                     var_gl_acct_category        IN OUT   giac_module_entries.gl_acct_category%TYPE,
                                     var_gl_control_acct         IN OUT   giac_module_entries.gl_control_acct%TYPE,
                                     var_gl_sub_acct_1           IN OUT   giac_module_entries.gl_sub_acct_1%TYPE,
                                     var_gl_sub_acct_2           IN OUT   giac_module_entries.gl_sub_acct_2%TYPE,
                                     var_gl_sub_acct_3           IN OUT   giac_module_entries.gl_sub_acct_3%TYPE,
                                     var_gl_sub_acct_4           IN OUT   giac_module_entries.gl_sub_acct_4%TYPE,
                                     var_gl_sub_acct_5           IN OUT   giac_module_entries.gl_sub_acct_5%TYPE,
                                     var_gl_sub_acct_6           IN OUT   giac_module_entries.gl_sub_acct_6%TYPE,
                                     var_gl_sub_acct_7           IN OUT   giac_module_entries.gl_sub_acct_7%TYPE,
                                     var_intm_type_level         IN OUT   giac_module_entries.intm_type_level%TYPE,
                                     var_line_dependency_level   IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                     var_old_new_acct_level      IN OUT   giac_module_entries.old_new_acct_level%TYPE,
                                     var_dr_cr_tag               IN OUT   giac_module_entries.dr_cr_tag%TYPE)
    IS
    BEGIN
       SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
              gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
              gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
              intm_type_level, line_dependency_level,
              old_new_acct_level, dr_cr_tag
         INTO var_gl_acct_category, var_gl_control_acct, var_gl_sub_acct_1,
              var_gl_sub_acct_2, var_gl_sub_acct_3, var_gl_sub_acct_4,
              var_gl_sub_acct_5, var_gl_sub_acct_6, var_gl_sub_acct_7,
              var_intm_type_level, var_line_dependency_level,
              var_old_new_acct_level, var_dr_cr_tag
         FROM giac_module_entries a, giac_modules b
        WHERE a.module_id = b.module_id
          AND module_name = p_module_name
          AND item_no = var_module_item_no;
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#Gl account '
                     || TO_CHAR (var_gl_acct_category)
                     || '-'
                     || TO_CHAR (var_gl_control_acct)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_1)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_2)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_3)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_4)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_5)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_6)
                     || '-'
                     || TO_CHAR (var_gl_sub_acct_7)
                     || '-'
                     || 'not found.');
    END;
    
    PROCEDURE insert_giac_acctrans (iga_iss_cd       IN       giac_branches.branch_cd%TYPE,
                                    p_prod_date      IN       DATE,
                                    p_user_id        IN       giis_users.user_id%TYPE,
                                    p_iss_cd         IN OUT   giac_branches.branch_cd%TYPE,
                                    p_fund_cd        IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                    p_tran_class     IN OUT   giac_acctrans.tran_class%TYPE,
                                    p_tran_flag      IN OUT   giac_acctrans.tran_flag%TYPE,
                                    p_cut_off_date   IN OUT   DATE,
                                    p_gacc_tran_id   IN OUT   giac_acctrans.tran_id%TYPE)
    IS
       var_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
       var_tran_class_no   giac_acctrans.tran_class_no%TYPE; 
       var_year            NUMBER;
       var_month           NUMBER;
       var_tran_id         giac_acctrans.tran_id%TYPE         := 0;
       var_branch_cd       giac_branches.branch_cd%TYPE;
    BEGIN
       var_year := TO_NUMBER (TO_CHAR (p_prod_date, 'YYYY'));
       var_month := TO_NUMBER (TO_CHAR (p_prod_date, 'MM'));

       BEGIN
          var_branch_cd := iga_iss_cd;
          p_iss_cd := iga_iss_cd;

          BEGIN
             SELECT DISTINCT (tran_id)
                        INTO var_tran_id
                        FROM giac_acctrans
                       WHERE gfun_fund_cd = p_fund_cd
                         AND gibr_branch_cd = var_branch_cd
                         AND tran_year = var_year
                         AND tran_month = var_month
                         AND tran_class = p_tran_class
                         AND tran_flag = p_tran_flag
                         AND TO_CHAR (tran_date, 'DD-MON-YY') =
                                             TO_CHAR (p_cut_off_date, 'DD-MON-YY');
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                BEGIN
                   SELECT acctran_tran_id_s.NEXTVAL
                     INTO p_gacc_tran_id
                     FROM DUAL;

                   var_tran_seq_no :=
                      giac_sequence_generation (p_fund_cd,
                                                var_branch_cd,
                                                'TRAN_SEQ_NO',
                                                var_year,
                                                var_month
                                               );
                   var_tran_class_no :=
                      giac_sequence_generation (p_fund_cd,
                                                var_branch_cd,
                                                p_tran_class,
                                                var_year,
                                                0
                                               );

                    -- Note:
                    -- Please don't delete the messages below, it may be useful when troubleshooting
                    -- the module. Michaell 11-25-2002

                   /*
                        MSG_ALERT( 'TRAN_ID : ' ||TO_CHAR(VARIABLES.gacc_tran_id) ,'I', FALSE);
                             MSG_ALERT( 'VARIABLES.fund_cd : '||VARIABLES.fund_cd,'I',FALSE);
                             MSG_ALERT( 'var_branch_cd :  '|| var_branch_cd,'I',FALSE);
                             MSG_ALERT( 'var_year      :  '|| TO_CHAR(VAR_YEAR), 'I',FALSE);
                             MSG_ALERT( 'var_month     :  '|| TO_CHAR(var_month),'I',FALSE);
                             MSG_ALERT( 'var_tran_seq_no : '|| TO_CHAR(var_tran_seq_no),'I',FALSE);
                             MSG_ALERT( 'variables.CUT_OFF_DATE '||TO_CHAR(variables.CUT_OFF_DATE),'I',FALSE);
                             MSG_ALERT( 'VARIABLES.tran_flag : ' ||VARIABLES.tran_flag,'I',FALSE);
                             MSG_ALERT( 'VARIABLES.tran_class : '||VARIABLES.tran_class,'I',FALSE);
                             MSG_ALERT( 'var_tran_class_no    : '||TO_CHAR(var_tran_class_no),'I',FALSE);
                             MSG_ALERT( ':prod.user           : '||:PROD.USER,'I',FALSE);
                   */
                   INSERT INTO giac_acctrans
                               (tran_id, gfun_fund_cd, gibr_branch_cd,
                                tran_year, tran_month, tran_seq_no,
                                tran_date, tran_flag, tran_class,
                                tran_class_no, user_id, last_update,
                                particulars
                               )
                        VALUES (p_gacc_tran_id, p_fund_cd, var_branch_cd,
                                var_year, var_month, var_tran_seq_no,
                                p_cut_off_date, p_tran_flag, p_tran_class,
                                var_tran_class_no, giis_users_pkg.app_user, SYSDATE,
                                   'Production take up of Outward Facul for '
                                || TO_CHAR (p_cut_off_date, 'fmMonth yyyy')
                               );
                               
                               ---raise_application_error(-20001,'Geniisys Exception#p_user_id:'||p_user_id);
                END;
          END;
       END;
    END;
    
    PROCEDURE entries (bpc_gl_acct_category                 giac_chart_of_accts.gl_acct_category%TYPE,
                       bpc_gl_control_acct                  giac_chart_of_accts.gl_control_acct%TYPE,
                       bpc_gl_sub_acct_1                    giac_chart_of_accts.gl_sub_acct_1%TYPE,
                       bpc_gl_sub_acct_2                    giac_chart_of_accts.gl_sub_acct_2%TYPE,
                       bpc_gl_sub_acct_3                    giac_chart_of_accts.gl_sub_acct_3%TYPE,
                       bpc_gl_sub_acct_4                    giac_chart_of_accts.gl_sub_acct_4%TYPE,
                       bpc_gl_sub_acct_5                    giac_chart_of_accts.gl_sub_acct_5%TYPE,
                       bpc_gl_sub_acct_6                    giac_chart_of_accts.gl_sub_acct_6%TYPE,
                       bpc_gl_sub_acct_7                    giac_chart_of_accts.gl_sub_acct_7%TYPE,
                       bpc_intm_type_level                  giac_module_entries.intm_type_level%TYPE,
                       bpc_line_dependency_level            giac_module_entries.line_dependency_level%TYPE,
                       bpc_dr_cr_tag                        giac_module_entries.dr_cr_tag%TYPE,
                       bpc_acc_rev_date                     giri_binder.acc_rev_date%TYPE,
                       bpc_acct_line_cd                     giis_line.acct_line_cd%TYPE,
                       bpc_acct_subline_cd                  giis_subline.acct_subline_cd%TYPE,
                       bpc_peril_cd                         giri_frperil.peril_cd%TYPE,
                       bpc_acct_intm_cd                     giis_intm_type.acct_intm_cd%TYPE,
                       bpc_ri_prem_amt                      giri_frperil.ri_prem_amt%TYPE,
                       bpc_iss_cd                           gipi_polbasic.iss_cd%TYPE,
                       bpc_ri_cd                            giri_frperil.ri_cd%TYPE,
                       p_prod_date                 IN       DATE,
                       p_acct_line_cd              IN OUT   giis_line.acct_line_cd%TYPE,
                       p_acct_intm_cd              IN OUT   giis_intm_type.acct_intm_cd%TYPE,
                       p_var_gl_acct_id            IN OUT   giac_acct_entries.gl_acct_id%TYPE,
                       p_var_sl_type_cd            IN OUT   giac_acct_entries.sl_type_cd%TYPE,
                       p_reinsurer                 IN OUT   giac_sl_types.sl_type_cd%TYPE,
                       p_line_subline_peril        IN OUT   giac_sl_types.sl_type_cd%TYPE,
                       p_line_subline              IN OUT   giac_sl_types.sl_type_cd%TYPE,
                       p_sl_source_cd              IN OUT   giac_acct_entries.sl_source_cd%TYPE,
                       p_process                   IN OUT   VARCHAR2,
                       p_msg                       IN OUT   VARCHAR2,
                       p_gacc_tran_id              IN OUT   giac_acctrans.tran_id%TYPE,
                       p_tran_class                IN OUT   giac_acctrans.tran_class%TYPE,
                       p_fund_cd                   IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                       p_cut_off_date              IN OUT   DATE,
                       p_tran_flag                 IN OUT   giac_acctrans.tran_flag%TYPE,
                       p_var_count_row             IN OUT   NUMBER,
                       p_user_id                      IN       giis_users.user_id%TYPE)
    IS
       var_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE
                                                          := bpc_gl_acct_category;
       var_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE
                                                           := bpc_gl_control_acct;
       var_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE
                                                             := bpc_gl_sub_acct_1;
       var_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE
                                                             := bpc_gl_sub_acct_2;
       var_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE
                                                             := bpc_gl_sub_acct_3;
       var_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE
                                                             := bpc_gl_sub_acct_4;
       var_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE
                                                             := bpc_gl_sub_acct_5;
       var_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE
                                                             := bpc_gl_sub_acct_6;
       var_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
                                                             := bpc_gl_sub_acct_7;
       var_credit_amt         giac_acct_entries.credit_amt%TYPE;
       var_debit_amt          giac_acct_entries.debit_amt%TYPE;
       var_gl_acct_id         giac_acct_entries.gl_acct_id%TYPE;
       var_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE;
       var_sl_cd              giac_acct_entries.sl_cd%TYPE;
    BEGIN
           --Checking entries... inserting the records into GIAC_ACCT_ENTIRES...

       IF NVL (bpc_line_dependency_level, 0) != 0
       THEN
          bae_check_level (bpc_line_dependency_level,
                           bpc_acct_line_cd,
                           var_gl_sub_acct_1,
                           var_gl_sub_acct_2,
                           var_gl_sub_acct_3,
                           var_gl_sub_acct_4,
                           var_gl_sub_acct_5,
                           var_gl_sub_acct_6,
                           var_gl_sub_acct_7
                          );
       END IF;

       IF NVL (bpc_intm_type_level, 0) != 0
       THEN
          bae_check_level (bpc_intm_type_level,
                           bpc_acct_intm_cd,
                           var_gl_sub_acct_1,
                           var_gl_sub_acct_2,
                           var_gl_sub_acct_3,
                           var_gl_sub_acct_4,
                           var_gl_sub_acct_5,
                           var_gl_sub_acct_6,
                           var_gl_sub_acct_7
                          );
       --VARIABLES.intm_sl_type_cd := bpc_acct_intm_cd;
       END IF;

       bae_check_batch_entries (bpc_gl_acct_category,
                                bpc_gl_control_acct,
                                var_gl_sub_acct_1,
                                var_gl_sub_acct_2,
                                var_gl_sub_acct_3,
                                var_gl_sub_acct_4,
                                var_gl_sub_acct_5,
                                var_gl_sub_acct_6,
                                var_gl_sub_acct_7,
                                var_gl_acct_id,
                                var_sl_type_cd
                               );
       p_acct_line_cd := bpc_acct_line_cd;
       p_acct_intm_cd := bpc_acct_intm_cd;
       p_var_gl_acct_id := var_gl_acct_id;
       p_var_sl_type_cd := var_sl_type_cd;

       IF p_var_sl_type_cd IS NOT NULL
       THEN                                                    -- judyann 02032006
          IF p_var_sl_type_cd IN
                             (p_reinsurer, p_line_subline_peril, p_line_subline)
          THEN
             IF bpc_ri_prem_amt != 0
             THEN
                IF p_var_sl_type_cd = p_line_subline_peril
                THEN
                   var_sl_cd :=
                      /*TO_NUMBER (   TO_CHAR (bpc_acct_line_cd, '00')
                                 || LTRIM (TO_CHAR (bpc_acct_subline_cd, '00'))
                                 || LTRIM (TO_CHAR (bpc_peril_cd, '00'))
                                );*/ --comment out and replaced by codes below mikel 03.21.2016 AUII 5467
                                 (bpc_acct_line_cd * 100000) + (bpc_acct_subline_cd * 1000) + bpc_peril_cd; --mikel 03.21.2016 AUII 5467
                ELSIF p_var_sl_type_cd = p_line_subline
                THEN
                   var_sl_cd :=
                      TO_NUMBER (   TO_CHAR (bpc_acct_line_cd, '00')
                                 || LTRIM (TO_CHAR (bpc_acct_subline_cd, '00'))
                                 || '00'
                                );
                ELSIF p_var_sl_type_cd = p_reinsurer
                THEN
                   var_sl_cd := bpc_ri_cd;
                END IF;

                IF bpc_acc_rev_date = p_prod_date
                THEN
                   get_drcr_amt (bpc_dr_cr_tag,
                                 bpc_ri_prem_amt,
                                 var_debit_amt,
                                 var_credit_amt
                                );
                ELSE
                   get_drcr_amt (bpc_dr_cr_tag,
                                 bpc_ri_prem_amt,
                                 var_credit_amt,
                                 var_debit_amt
                                );
                END IF;

                GIACB003_PKG.bae_insert_update_acct_entries (var_gl_acct_category,
                                                var_gl_control_acct,
                                                var_gl_sub_acct_1,
                                                var_gl_sub_acct_2,
                                                var_gl_sub_acct_3,
                                                var_gl_sub_acct_4,
                                                var_gl_sub_acct_5,
                                                var_gl_sub_acct_6,
                                                var_gl_sub_acct_7,
                                                var_sl_cd,
                                                p_var_gl_acct_id,
                                                bpc_iss_cd,
                                                var_credit_amt,
                                                var_debit_amt,
                                                p_var_sl_type_cd,
                                                p_sl_source_cd,
                                                p_gacc_tran_id,
                                                p_tran_class,
                                                p_fund_cd,
                                                p_cut_off_date,
                                                p_tran_flag,
                                                p_var_count_row,
                                                p_process,
                                                p_user_id
                                               );
             END IF;
          ELSE
             p_msg := p_msg ||'#GL account code '
                        || TO_CHAR (var_gl_acct_category)
                        || '-'
                        || TO_CHAR (var_gl_control_acct, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_1, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_2, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_3, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_4, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_5, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_6, '09')
                        || '-'
                        || TO_CHAR (var_gl_sub_acct_7, '09')
                        || ' is not LINE SUBLINE PERIL TYPE / REINSURER .';
          END IF;
       ELSE
          IF bpc_ri_prem_amt != 0
          THEN
             IF bpc_acc_rev_date = p_prod_date
             THEN
                get_drcr_amt (bpc_dr_cr_tag,
                              bpc_ri_prem_amt,
                              var_debit_amt,
                              var_credit_amt
                             );
             ELSE
                get_drcr_amt (bpc_dr_cr_tag,
                              bpc_ri_prem_amt,
                              var_credit_amt,
                              var_debit_amt
                             );
             END IF;

             GIACB003_PKG.bae_insert_update_acct_entries (var_gl_acct_category,
                                             var_gl_control_acct,
                                             var_gl_sub_acct_1,
                                             var_gl_sub_acct_2,
                                             var_gl_sub_acct_3,
                                             var_gl_sub_acct_4,
                                             var_gl_sub_acct_5,
                                             var_gl_sub_acct_6,
                                             var_gl_sub_acct_7,
                                             var_sl_cd,
                                             p_var_gl_acct_id,
                                             bpc_iss_cd,
                                             var_credit_amt,
                                             var_debit_amt,
                                             p_var_sl_type_cd,
                                             p_sl_source_cd,
                                             p_gacc_tran_id,
                                             p_tran_class,
                                             p_fund_cd,
                                             p_cut_off_date,
                                             p_tran_flag,
                                             p_var_count_row,
                                             p_process,
                                             p_user_id
                                            );
          END IF;
       END IF;
    END;
    
    /*****************************************************************************
    *                                                                            *
    * This procedure determines whether the records will be updated or inserted  *
    * in GIAC_ACCT_ENTRIES.                                                      *
    *                                                                            *
    *****************************************************************************/

    PROCEDURE bae_insert_update_acct_entries (iuae_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
                                              iuae_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
                                              iuae_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
                                              iuae_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
                                              iuae_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
                                              iuae_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
                                              iuae_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
                                              iuae_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
                                              iuae_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
                                              iuae_sl_cd                       giac_acct_entries.sl_cd%TYPE,
                                              iuae_gl_acct_id                  giac_chart_of_accts.gl_acct_id%TYPE,
                                              iuae_branch_cd                   giac_branches.branch_cd%TYPE,
                                              iuae_credit_amt                  giac_acct_entries.credit_amt%TYPE,
                                              iuae_debit_amt                   giac_acct_entries.debit_amt%TYPE,
                                              iuae_sl_type_cd                  giac_acct_entries.sl_type_cd%TYPE,
                                              iuae_sl_source_cd                giac_acct_entries.sl_source_cd%TYPE,
                                              p_gacc_tran_id            IN OUT giac_acctrans.tran_id%TYPE,
                                              p_tran_class              IN OUT giac_acctrans.tran_class%TYPE,
                                              p_fund_cd                 IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                              p_cut_off_date            IN OUT DATE,
                                              p_tran_flag               IN OUT giac_acctrans.tran_flag%TYPE,
                                              p_var_count_row           IN OUT NUMBER,
                                              p_process                 IN     VARCHAR2,
                                              p_user_id                 IN     giis_users.user_id%TYPE)
    IS
       iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
       var_branch_cd        giac_acct_entries.gacc_gibr_branch_cd%TYPE;
    BEGIN
       BEGIN
          SELECT tran_id
            INTO p_gacc_tran_id
            FROM giac_acctrans
           WHERE tran_class = p_tran_class
             AND gfun_fund_cd = p_fund_cd
             AND gibr_branch_cd = iuae_branch_cd
             AND TO_CHAR (tran_date, 'DD-MON-YYYY') =
                                   TO_CHAR (p_cut_off_date, 'DD-MON-YYYY')
             AND tran_flag = p_tran_flag;
       END;

       BEGIN
          p_var_count_row := NVL (p_var_count_row, 0) + 1;
          --:prod.row_counter := p_var_count_row;
          iuae_acct_entry_id := p_var_count_row;

        -- Note:
        -- Please don't delete the messages below. It maybe useful in troubleshooting
        -- this module. Michaell 11-25-2002

          /*
        msg_alert( 'VARIABLES.gacc_tran_id : '|| to_char(VARIABLES.gacc_tran_id),'I',false);
        msg_alert( 'VARIABLES.fund_cd      : '|| VARIABLES.fund_cd,'I',false);
        msg_alert( 'var_branch_cd          : '|| var_branch_cd,'I',false);
        msg_alert( 'iuae_acct_entry_id     : '|| to_char(iuae_acct_entry_id),'I',false);
        msg_alert( 'iuae_gl_acct_id        : '|| to_char(iuae_gl_acct_id),'I',false);
        msg_alert( 'iuae_gl_acct_category  : '|| to_char(iuae_gl_acct_category),'I',false);
        msg_alert( 'iuae_gl_control_acct   : '|| to_char(iuae_gl_control_acct),'I',false);
        msg_alert( 'iuae_gl_sub_acct_1     : '|| to_char(iuae_gl_sub_acct_1),'I',false);
        msg_alert( 'iuae_gl_sub_acct_2     : '|| to_char(iuae_gl_sub_acct_2),'I',false);
        msg_alert( 'iuae_gl_sub_acct_3     : '|| to_char(iuae_gl_sub_acct_3),'I',false);
        msg_alert( 'iuae_gl_sub_acct_4     : '|| to_char(iuae_gl_sub_acct_4),'I',false);
        msg_alert( 'iuae_gl_sub_acct_5     : '|| to_char(iuae_gl_sub_acct_5),'I',false);
        msg_alert( 'iuae_gl_sub_acct_6     : '|| to_char(iuae_gl_sub_acct_6),'I',false);
        msg_alert( 'iuae_gl_sub_acct_7     : '|| to_char(iuae_gl_sub_acct_7),'I',false);
        msg_alert( 'iuae_sl_cd             : '|| to_char(iuae_sl_cd),'I',false);
        msg_alert( 'iuae_debit_amt         : '|| to_char(iuae_debit_amt),'I',false);
        msg_alert( 'iuae_credit_amt        : '|| to_char(iuae_credit_amt),'I',false);
        msg_alert( ':PROD.USER             : '|| :PROD.USER,'I',false);
        msg_alert( 'iuae_sl_type_cd        : '|| iuae_sl_type_cd,'I',false);
        msg_alert( 'iuae_sl_source_cd      : '|| iuae_sl_source_cd ,'I',false);
        */
          INSERT INTO giac_acct_entries
                      (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                       acct_entry_id, gl_acct_id,
                       gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4,
                       gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, sl_cd, debit_amt,
                       credit_amt, user_id, last_update,
                       sl_type_cd, sl_source_cd
                      )
               VALUES (p_gacc_tran_id, p_fund_cd, iuae_branch_cd,
                       iuae_acct_entry_id, iuae_gl_acct_id,
                       iuae_gl_acct_category, iuae_gl_control_acct,
                       iuae_gl_sub_acct_1, iuae_gl_sub_acct_2,
                       iuae_gl_sub_acct_3, iuae_gl_sub_acct_4,
                       iuae_gl_sub_acct_5, iuae_gl_sub_acct_6,
                       iuae_gl_sub_acct_7, iuae_sl_cd, NVL (iuae_debit_amt, 0),
                       NVL (iuae_credit_amt, 0), giis_users_pkg.app_user, SYSDATE,
                       iuae_sl_type_cd, iuae_sl_source_cd
                      );
       END;
    END;
    
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.20.2013
   **  Reference By : GIACB003 use in GIACB000 - Batch Accounting Entry
   **  Description  : to handle separate GL entries (Premiums Ceded and Commission Income) for cessions of direct policies and assumed/inward policies 
   */

    PROCEDURE extract_retrocession (p_prod_date                      IN       DATE,
                                    p_exclude_special                IN       giac_parameters.param_value_v%TYPE,
                                    p_module_ent_comm_inc_retro      IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_prem_retroced       IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_due_to_ri           IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_def_input_vat       IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_def_output_vat      IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_def_cred_wh_vatri   IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_def_wh_vat_pay      IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_prem_tax            IN       giac_module_entries.item_no%TYPE,
                                    p_module_ent_comm_rec_retro      IN       giac_module_entries.item_no%TYPE, -- marco - 07.04.2014
                                    p_iss_cd                         IN OUT   giac_branches.branch_cd%TYPE,
                                    p_process                        IN OUT   VARCHAR2,
                                    p_module_name                    IN       giac_modules.module_name%TYPE,
                                    p_acct_line_cd                   IN OUT   giis_line.acct_line_cd%TYPE,
                                    p_acct_intm_cd                   IN OUT   giis_intm_type.acct_intm_cd%TYPE,
                                    p_var_gl_acct_id                 IN OUT   giac_acct_entries.gl_acct_id%TYPE,
                                    p_var_sl_type_cd                 IN OUT   giac_acct_entries.sl_type_cd%TYPE,
                                    p_reinsurer                      IN OUT   giac_sl_types.sl_type_cd%TYPE,
                                    p_line_subline_peril             IN OUT   giac_sl_types.sl_type_cd%TYPE,
                                    p_line_subline                   IN OUT   giac_sl_types.sl_type_cd%TYPE,
                                    p_sl_source_cd                   IN OUT   giac_acct_entries.sl_source_cd%TYPE,
                                    p_msg                            IN OUT   VARCHAR2,
                                    p_user_id                        IN       giis_users.user_id%TYPE,
                                    p_fund_cd                        IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                    p_tran_class                     IN OUT   giac_acctrans.tran_class%TYPE,
                                    p_tran_flag                      IN OUT   giac_acctrans.tran_flag%TYPE,
                                    p_cut_off_date                   IN OUT   DATE,
                                    p_gacc_tran_id                   IN OUT   giac_acctrans.tran_id%TYPE,
                                    p_var_count_row                  IN OUT   NUMBER)
    IS
       var_acct_line_cd              giis_line.acct_line_cd%TYPE;
       var_acct_subline_cd           giis_subline.acct_subline_cd%TYPE;
       var_acct_intm_cd              giis_intm_type.acct_intm_cd%TYPE;
       cvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       cvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       cvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       cvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       cvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       cvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       cvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       cvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       cvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       cvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       cvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       cvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       cvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       pvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       pvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       pvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       pvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       pvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       pvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       pvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       pvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       pvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       pvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       pvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       pvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       pvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       dvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       dvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       dvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       dvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       dvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       dvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       dvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       dvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       dvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       dvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       dvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       dvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       dvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       /* issa 01.11.2006
       ** added for deferred input vat and deferred output vat
       */
       ivar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       ivar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       ivar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       ivar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       ivar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       ivar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       ivar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       ivar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       ivar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       ivar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       ivar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       ivar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       ivar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       ovar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       ovar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       ovar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       ovar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       ovar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       ovar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       ovar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       ovar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       ovar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       ovar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       ovar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       ovar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       ovar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       --i--
       /* issa 01.13.2006
       ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
       */
       rivar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       rivar_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       rivar_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       rivar_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       rivar_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       rivar_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       rivar_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       rivar_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       rivar_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       rivar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       rivar_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       rivar_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       rivar_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       vpvar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       vpvar_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       vpvar_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       vpvar_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       vpvar_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       vpvar_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       vpvar_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       vpvar_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       vpvar_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       vpvar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       vpvar_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       vpvar_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       vpvar_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       --i--
         /* judyann 07072008; for RI premium tax accounting entry */
       ptvar_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       ptvar_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       ptvar_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       ptvar_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       ptvar_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       ptvar_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       ptvar_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       ptvar_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       ptvar_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       ptvar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       ptvar_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       ptvar_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       ptvar_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       
       /* judyann 07012013; for commissions receivable */
       crvar_gl_acct_category          giac_module_entries.gl_acct_category%TYPE;
       crvar_gl_control_acct           giac_module_entries.gl_control_acct%TYPE;
       crvar_gl_sub_acct_1             giac_module_entries.gl_sub_acct_1%TYPE;
       crvar_gl_sub_acct_2             giac_module_entries.gl_sub_acct_2%TYPE;
       crvar_gl_sub_acct_3             giac_module_entries.gl_sub_acct_3%TYPE;
       crvar_gl_sub_acct_4             giac_module_entries.gl_sub_acct_4%TYPE;
       crvar_gl_sub_acct_5             giac_module_entries.gl_sub_acct_5%TYPE;
       crvar_gl_sub_acct_6             giac_module_entries.gl_sub_acct_6%TYPE;
       crvar_gl_sub_acct_7             giac_module_entries.gl_sub_acct_7%TYPE;
       crvar_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       crvar_line_dependency_level      giac_module_entries.line_dependency_level%TYPE;
       crvar_old_new_acct_level         giac_module_entries.old_new_acct_level%TYPE;
       crvar_dr_cr_tag                  giac_module_entries.dr_cr_tag%TYPE;
       
       -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
       v_comm_rec_batch_takeup       giac_parameters.param_value_v%TYPE := GIACP.V('COMM_REC_BATCH_TAKEUP');
       v_ri_comm_rec_gross_tag       giac_parameters.param_value_v%TYPE := GIACP.V('RI_COMM_REC_GROSS_TAG');
       v_due_to_ri                   NUMBER(16, 2);
       v_ri_comm_amt                 NUMBER(16, 2);
    BEGIN
       IF p_exclude_special = 'N'
       THEN
          /* extrct all policies */
          BEGIN                                                    -- extract all
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_inc_retro,
                                    cvar_gl_acct_category,
                                    cvar_gl_control_acct,
                                    cvar_gl_sub_acct_1,
                                    cvar_gl_sub_acct_2,
                                    cvar_gl_sub_acct_3,
                                    cvar_gl_sub_acct_4,
                                    cvar_gl_sub_acct_5,
                                    cvar_gl_sub_acct_6,
                                    cvar_gl_sub_acct_7,
                                    cvar_intm_type_level,
                                    cvar_line_dependency_level,
                                    cvar_old_new_acct_level,
                                    cvar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_retroced,
                                    pvar_gl_acct_category,
                                    pvar_gl_control_acct,
                                    pvar_gl_sub_acct_1,
                                    pvar_gl_sub_acct_2,
                                    pvar_gl_sub_acct_3,
                                    pvar_gl_sub_acct_4,
                                    pvar_gl_sub_acct_5,
                                    pvar_gl_sub_acct_6,
                                    pvar_gl_sub_acct_7,
                                    pvar_intm_type_level,
                                    pvar_line_dependency_level,
                                    pvar_old_new_acct_level,
                                    pvar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_due_to_ri,
                                    dvar_gl_acct_category,
                                    dvar_gl_control_acct,
                                    dvar_gl_sub_acct_1,
                                    dvar_gl_sub_acct_2,
                                    dvar_gl_sub_acct_3,
                                    dvar_gl_sub_acct_4,
                                    dvar_gl_sub_acct_5,
                                    dvar_gl_sub_acct_6,
                                    dvar_gl_sub_acct_7,
                                    dvar_intm_type_level,
                                    dvar_line_dependency_level,
                                    dvar_old_new_acct_level,
                                    dvar_dr_cr_tag
                                   );
                 /* issa 01.11.2006
             ** added for deferred input vat and deferred output vat
             */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_input_vat,
                                    ivar_gl_acct_category,
                                    ivar_gl_control_acct,
                                    ivar_gl_sub_acct_1,
                                    ivar_gl_sub_acct_2,
                                    ivar_gl_sub_acct_3,
                                    ivar_gl_sub_acct_4,
                                    ivar_gl_sub_acct_5,
                                    ivar_gl_sub_acct_6,
                                    ivar_gl_sub_acct_7,
                                    ivar_intm_type_level,
                                    ivar_line_dependency_level,
                                    ivar_old_new_acct_level,
                                    ivar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_output_vat,
                                    ovar_gl_acct_category,
                                    ovar_gl_control_acct,
                                    ovar_gl_sub_acct_1,
                                    ovar_gl_sub_acct_2,
                                    ovar_gl_sub_acct_3,
                                    ovar_gl_sub_acct_4,
                                    ovar_gl_sub_acct_5,
                                    ovar_gl_sub_acct_6,
                                    ovar_gl_sub_acct_7,
                                    ovar_intm_type_level,
                                    ovar_line_dependency_level,
                                    ovar_old_new_acct_level,
                                    ovar_dr_cr_tag
                                   );
               --i--
               /* issa 01.13.2006
             ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
             */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_cred_wh_vatri,
                                    rivar_gl_acct_category,
                                    rivar_gl_control_acct,
                                    rivar_gl_sub_acct_1,
                                    rivar_gl_sub_acct_2,
                                    rivar_gl_sub_acct_3,
                                    rivar_gl_sub_acct_4,
                                    rivar_gl_sub_acct_5,
                                    rivar_gl_sub_acct_6,
                                    rivar_gl_sub_acct_7,
                                    rivar_intm_type_level,
                                    rivar_line_dependency_level,
                                    rivar_old_new_acct_level,
                                    rivar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_wh_vat_pay,
                                    vpvar_gl_acct_category,
                                    vpvar_gl_control_acct,
                                    vpvar_gl_sub_acct_1,
                                    vpvar_gl_sub_acct_2,
                                    vpvar_gl_sub_acct_3,
                                    vpvar_gl_sub_acct_4,
                                    vpvar_gl_sub_acct_5,
                                    vpvar_gl_sub_acct_6,
                                    vpvar_gl_sub_acct_7,
                                    vpvar_intm_type_level,
                                    vpvar_line_dependency_level,
                                    vpvar_old_new_acct_level,
                                    vpvar_dr_cr_tag
                                   );
             --i--
               /* judyann 07072008; for RI premium tax */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_tax,
                                    ptvar_gl_acct_category,
                                    ptvar_gl_control_acct,
                                    ptvar_gl_sub_acct_1,
                                    ptvar_gl_sub_acct_2,
                                    ptvar_gl_sub_acct_3,
                                    ptvar_gl_sub_acct_4,
                                    ptvar_gl_sub_acct_5,
                                    ptvar_gl_sub_acct_6,
                                    ptvar_gl_sub_acct_7,
                                    ptvar_intm_type_level,
                                    ptvar_line_dependency_level,
                                    ptvar_old_new_acct_level,
                                    ptvar_dr_cr_tag
                                   );
               
             /* judyann 07012013; for commissions receivable */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_rec_retro,
                                    crvar_gl_acct_category,
                                    crvar_gl_control_acct,
                                    crvar_gl_sub_acct_1,
                                    crvar_gl_sub_acct_2,
                                    crvar_gl_sub_acct_3,
                                    crvar_gl_sub_acct_4,
                                    crvar_gl_sub_acct_5,
                                    crvar_gl_sub_acct_6,
                                    crvar_gl_sub_acct_7,
                                    crvar_intm_type_level,
                                    crvar_line_dependency_level,
                                    crvar_old_new_acct_level,
                                    crvar_dr_cr_tag
                                   );

             IF    cvar_gl_acct_category IS NOT NULL
                OR pvar_gl_acct_category IS NOT NULL
                OR dvar_gl_acct_category IS NOT NULL
                OR ivar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR ovar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR rivar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR vpvar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR ptvar_gl_acct_category IS NOT NULL          -- judyann 07072008
                OR crvar_gl_acct_category IS NOT NULL -- judyann 07012013
             THEN
                p_iss_cd := NULL;
    /*
               FOR ja1 IN(
                     SELECT c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd) iss_cd, g.line_cd, i.acct_line_cd,
                            g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd,
                            decode(g.iss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                            SUM(a.ri_comm_amt*d.currency_rt) ri_comm_amt,
                            SUM(a.ri_prem_amt*d.currency_rt) ri_prem_amt,
                            --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
    */                        /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
    /*                        (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt))
                             - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)) due_to_ri_local, --issa 01.13.2006
                            (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt))
                             - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)) due_to_ri_foreign, --issa 01.13.2006
                            SUM(NVL(a.ri_prem_vat,0)*d.currency_rt) ri_prem_vat, --issa 01.11.2006
                            SUM(NVL(a.ri_comm_vat,0)*d.currency_rt) ri_comm_vat,  --issa 01.11.2006
                            SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt) ri_wholding_vat,  --issa 01.13.2006
                            SUM(NVL(a.prem_tax,0)*d.currency_rt) prem_tax,   -- judyann 07072008
                            k.local_foreign_sw --issa 01.13.2006
                       FROM giri_frperil a,
                            giri_frps_ri b,
                            giri_binder c,
                            giri_distfrps d,
                            giuw_policyds e,
                            giuw_pol_dist f,
                            gipi_polbasic g,
                            giac_bae_pol_parent_intm_v h,
                            giis_line  i,
                            giis_subline j,
                            giis_reinsurer k --issa 01.13.2006, to get the local/foreign sw
                      WHERE a.line_cd = b.line_cd            -- frperil 
                        AND a.frps_yy = b.frps_yy              -- frperil 
                        AND a.frps_seq_no = b.frps_seq_no      -- frperil 
                        AND a.ri_seq_no = b.ri_seq_no          -- frperil 
                        AND a.ri_cd = k.ri_cd                                  -- frperil and reinsurer issa 01.13.2006
                        AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                        AND b.line_cd = d.line_cd              -- frpsri 
                        AND b.frps_yy = d.frps_yy              -- frpsri 
                        AND b.frps_seq_no = d.frps_seq_no      -- frpsri 
                        AND d.dist_no = e.dist_no              -- distfrps 
                        AND d.dist_seq_no = e.dist_seq_no      -- distfrps 
                        AND e.dist_no = f.dist_no              -- policyds 
                        AND g.policy_id = h.policy_id(+)       -- polbasic 
                        AND f.policy_id = g.policy_id          -- pol_dist 
                        AND g.acct_ent_date IS NOT NULL
                        AND g.acct_ent_date <= :prod.cut_off_date
                        AND ( trunc(c.acc_ent_date) = :prod.cut_off_date
                              OR (trunc(c.acc_rev_date) = :prod.cut_off_date))
                        AND g.line_cd = i.line_cd              -- polbasic 
                        AND g.line_cd = j.line_cd              -- polibasic 
                        AND g.subline_cd = j.subline_cd        -- polbasic 
                   GROUP BY c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd), g.line_cd, i.acct_line_cd,
                        g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd, decode(g.iss_cd,'RI',5 , h.acct_intm_cd), k.local_foreign_sw /*issa 01.13.2006*/
                                                                                                                                                               /*)
               LOOP
    */
       -- judyann 10052007; separated SELECT statement for reversed binders/negated distribution
                FOR ja1 IN
                   (SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             DECODE (g.iss_cd,
                                     'RI', 5,
                                     h.acct_intm_cd
                                    ) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                               /*(  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               ) due_to_ri_local,                --issa 01.13.2006
                               (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                                - SUM (NVL (a.prem_tax, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                               ) due_to_ri_foreign,              --issa 01.13.2006 */
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_ent_date) = p_prod_date
                         --AND TRUNC(f.acct_ent_date) = :prod.cut_off_date            -- judyann 07292011; include new binders created for reversed binders of unnegated distributions
                         AND TRUNC (f.acct_ent_date) <= p_prod_date
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.iss_cd = giisp.v ('ISS_CD_RI')
                    -- inward policies only
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             DECODE (g.iss_cd, 'RI', 5, h.acct_intm_cd),
                             k.local_foreign_sw
                    UNION
                    SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             DECODE (g.iss_cd,
                                     'RI', 5,
                                     h.acct_intm_cd
                                    ) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                               /* (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               ) due_to_ri_local,                --issa 01.13.2006
                               (  SUM (a.ri_prem_amt * d.currency_rt)
                                + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                                - SUM (NVL (a.prem_tax, 0) * d.currency_rt)
                               )
                             - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                                + SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                               ) due_to_ri_foreign,              --issa 01.13.2006 */
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_rev_date) = p_prod_date
                         --AND TRUNC(f.acct_neg_date) = :prod.cut_off_date
                         AND (   (    f.dist_flag = '4'
                                  AND TRUNC (f.acct_neg_date) = p_prod_date
                                 )
                              OR (f.dist_flag = '3' AND b.reverse_sw = 'Y')
                              OR (f.dist_flag = '5')) -- added '5' for redistributed policies : SR-4824 shan 08.03.2015
                         -- judyann 07292011; include reversed binders (unnegated distributions)
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.iss_cd = giisp.v ('ISS_CD_RI')
                    -- inward policies only
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             DECODE (g.iss_cd, 'RI', 5, h.acct_intm_cd),
                             k.local_foreign_sw)
                LOOP
                   p_process := 'premium ceded and commission income';

                   IF NVL (p_iss_cd, 'xx') != ja1.iss_cd
                   THEN
                      GIACB003_PKG.insert_giac_acctrans (ja1.iss_cd,
                                            p_prod_date,
                                            p_user_id,
                                            p_iss_cd,
                                            p_fund_cd,
                                            p_tran_class,
                                            p_tran_flag,
                                            p_cut_off_date,
                                            p_gacc_tran_id);
                      p_iss_cd := ja1.iss_cd;
                   END IF;

                   IF cvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries(cvar_gl_acct_category,
                               cvar_gl_control_acct,
                               cvar_gl_sub_acct_1,
                               cvar_gl_sub_acct_2,
                               cvar_gl_sub_acct_3,
                               cvar_gl_sub_acct_4,
                               cvar_gl_sub_acct_5,
                               cvar_gl_sub_acct_6,
                               cvar_gl_sub_acct_7,
                               cvar_intm_type_level,
                               cvar_line_dependency_level,
                               cvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_comm_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF pvar_gl_acct_category IS NOT NULL
                   THEN
                     GIACB003_PKG.entries(pvar_gl_acct_category,
                               pvar_gl_control_acct,
                               pvar_gl_sub_acct_1,
                               pvar_gl_sub_acct_2,
                               pvar_gl_sub_acct_3,
                               pvar_gl_sub_acct_4,
                               pvar_gl_sub_acct_5,
                               pvar_gl_sub_acct_6,
                               pvar_gl_sub_acct_7,
                               pvar_intm_type_level,
                               pvar_line_dependency_level,
                               pvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_prem_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   /* issa 01.13.2006
                   ** to consider local/foreign ri
                   */
                   IF     dvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_local - ja1.ri_comm_vat;
                         ELSE
                            v_due_to_ri := ja1.due_to_ri_local;
                         END IF;
                      ELSE
                        v_due_to_ri := ja1.due_to_ri_local - ja1.ri_comm_vat;
                      END IF;
                   
                      GIACB003_PKG.entries(dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   ELSE                                                  --foreign
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_foreign - ja1.ri_comm_vat;
                         ELSE
                            v_due_to_ri := ja1.due_to_ri_foreign;
                         END IF;
                      ELSE
                        v_due_to_ri := ja1.due_to_ri_foreign - ja1.ri_comm_vat;
                      END IF;
                      
                      GIACB003_PKG.entries(dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   /*IF dvar_gl_acct_category IS NOT NULL
                   THEN
                      entries (
                         dvar_gl_acct_category      ,  dvar_gl_control_acct    ,
                                dvar_gl_sub_acct_1         ,  dvar_gl_sub_acct_2      ,
                                  dvar_gl_sub_acct_3         ,  dvar_gl_sub_acct_4      ,
                                  dvar_gl_sub_acct_5         ,  dvar_gl_sub_acct_6      ,
                         dvar_gl_sub_acct_7         ,  dvar_intm_type_level    ,
                                 dvar_line_dependency_level ,  dvar_dr_cr_tag          ,
                         ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                         ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                         ja1.acct_intm_cd           ,  ja1.due_to_ri           ,
                         ja1.iss_cd                 ,  ja1.ri_cd);
                   END IF;*/ --issa 01.13.2006 changed to consider local/foreign ri

                   /* issa 01.11.2006
                              ** added for deferred input vat and deferred output vat
                              */
                   IF     ivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      GIACB003_PKG.entries(ivar_gl_acct_category,
                               ivar_gl_control_acct,
                               ivar_gl_sub_acct_1,
                               ivar_gl_sub_acct_2,
                               ivar_gl_sub_acct_3,
                               ivar_gl_sub_acct_4,
                               ivar_gl_sub_acct_5,
                               ivar_gl_sub_acct_6,
                               ivar_gl_sub_acct_7,
                               ivar_intm_type_level,
                               ivar_line_dependency_level,
                               ivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_prem_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF ovar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries(ovar_gl_acct_category,
                               ovar_gl_control_acct,
                               ovar_gl_sub_acct_1,
                               ovar_gl_sub_acct_2,
                               ovar_gl_sub_acct_3,
                               ovar_gl_sub_acct_4,
                               ovar_gl_sub_acct_5,
                               ovar_gl_sub_acct_6,
                               ovar_gl_sub_acct_7,
                               ovar_intm_type_level,
                               ovar_line_dependency_level,
                               ovar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_comm_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   --i--

                   /* issa 01.13.2006
                   ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
                   */
                   IF     rivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries(rivar_gl_acct_category,
                               rivar_gl_control_acct,
                               rivar_gl_sub_acct_1,
                               rivar_gl_sub_acct_2,
                               rivar_gl_sub_acct_3,
                               rivar_gl_sub_acct_4,
                               rivar_gl_sub_acct_5,
                               rivar_gl_sub_acct_6,
                               rivar_gl_sub_acct_7,
                               rivar_intm_type_level,
                               rivar_line_dependency_level,
                               rivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF     vpvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries(vpvar_gl_acct_category,
                               vpvar_gl_control_acct,
                               vpvar_gl_sub_acct_1,
                               vpvar_gl_sub_acct_2,
                               vpvar_gl_sub_acct_3,
                               vpvar_gl_sub_acct_4,
                               vpvar_gl_sub_acct_5,
                               vpvar_gl_sub_acct_6,
                               vpvar_gl_sub_acct_7,
                               vpvar_intm_type_level,
                               vpvar_line_dependency_level,
                               vpvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   --i--
                   /* judyann 07072008; for RI premium tax */
                   IF     ptvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries(ptvar_gl_acct_category,
                               ptvar_gl_control_acct,
                               ptvar_gl_sub_acct_1,
                               ptvar_gl_sub_acct_2,
                               ptvar_gl_sub_acct_3,
                               ptvar_gl_sub_acct_4,
                               ptvar_gl_sub_acct_5,
                               ptvar_gl_sub_acct_6,
                               ptvar_gl_sub_acct_7,
                               ptvar_intm_type_level,
                               ptvar_line_dependency_level,
                               ptvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               ja1.acct_intm_cd,
                               ja1.prem_tax,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;
                   
                   /* judyann 07012013; for commissions receivable */
                    IF NVL(v_comm_rec_batch_takeup,'N') = 'Y' THEN
                        IF crvar_gl_acct_category IS NOT NULL 
                        THEN
                           IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                              v_ri_comm_amt := ja1.ri_comm_amt;
                           ELSE
                              v_ri_comm_amt := ja1.ri_comm_amt + ja1.ri_comm_vat;
                           END IF;
                        
                           GIACB003_PKG.entries (
                             crvar_gl_acct_category      ,  crvar_gl_control_acct    ,
                             crvar_gl_sub_acct_1         ,  crvar_gl_sub_acct_2      ,
                             crvar_gl_sub_acct_3         ,  crvar_gl_sub_acct_4      ,
                             crvar_gl_sub_acct_5         ,  crvar_gl_sub_acct_6      ,
                             crvar_gl_sub_acct_7         ,  crvar_intm_type_level    ,
                             crvar_line_dependency_level ,  crvar_dr_cr_tag          ,
                             ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                             ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                             ja1.acct_intm_cd           ,  v_ri_comm_amt         ,
                             ja1.iss_cd                 ,  ja1.ri_cd,
                             p_prod_date,
                             p_acct_line_cd,
                             p_acct_intm_cd,
                             p_var_gl_acct_id,
                             p_var_sl_type_cd,
                             p_reinsurer,
                             p_line_subline_peril,
                             p_line_subline,
                             p_sl_source_cd,
                             p_process,
                             p_msg,
                             p_gacc_tran_id,
                             p_tran_class,
                             p_fund_cd,
                             p_cut_off_date,
                             p_tran_flag,
                             p_var_count_row,
                             p_user_id);
                        END IF;
                     END IF;
                END LOOP ja1;
             END IF;
          END;                                                      -- extract all
       ELSIF p_exclude_special = 'Y'
       THEN
          BEGIN                                       -- exclude special policies
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_inc_retro,
                                    cvar_gl_acct_category,
                                    cvar_gl_control_acct,
                                    cvar_gl_sub_acct_1,
                                    cvar_gl_sub_acct_2,
                                    cvar_gl_sub_acct_3,
                                    cvar_gl_sub_acct_4,
                                    cvar_gl_sub_acct_5,
                                    cvar_gl_sub_acct_6,
                                    cvar_gl_sub_acct_7,
                                    cvar_intm_type_level,
                                    cvar_line_dependency_level,
                                    cvar_old_new_acct_level,
                                    cvar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_retroced,
                                    pvar_gl_acct_category,
                                    pvar_gl_control_acct,
                                    pvar_gl_sub_acct_1,
                                    pvar_gl_sub_acct_2,
                                    pvar_gl_sub_acct_3,
                                    pvar_gl_sub_acct_4,
                                    pvar_gl_sub_acct_5,
                                    pvar_gl_sub_acct_6,
                                    pvar_gl_sub_acct_7,
                                    pvar_intm_type_level,
                                    pvar_line_dependency_level,
                                    pvar_old_new_acct_level,
                                    pvar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_due_to_ri,
                                    dvar_gl_acct_category,
                                    dvar_gl_control_acct,
                                    dvar_gl_sub_acct_1,
                                    dvar_gl_sub_acct_2,
                                    dvar_gl_sub_acct_3,
                                    dvar_gl_sub_acct_4,
                                    dvar_gl_sub_acct_5,
                                    dvar_gl_sub_acct_6,
                                    dvar_gl_sub_acct_7,
                                    dvar_intm_type_level,
                                    dvar_line_dependency_level,
                                    dvar_old_new_acct_level,
                                    dvar_dr_cr_tag
                                   );
               /* issa 01.11.2006
             ** added for deferred input vat and deferred output vat
             */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_input_vat,
                                    ivar_gl_acct_category,
                                    ivar_gl_control_acct,
                                    ivar_gl_sub_acct_1,
                                    ivar_gl_sub_acct_2,
                                    ivar_gl_sub_acct_3,
                                    ivar_gl_sub_acct_4,
                                    ivar_gl_sub_acct_5,
                                    ivar_gl_sub_acct_6,
                                    ivar_gl_sub_acct_7,
                                    ivar_intm_type_level,
                                    ivar_line_dependency_level,
                                    ivar_old_new_acct_level,
                                    ivar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_output_vat,
                                    ovar_gl_acct_category,
                                    ovar_gl_control_acct,
                                    ovar_gl_sub_acct_1,
                                    ovar_gl_sub_acct_2,
                                    ovar_gl_sub_acct_3,
                                    ovar_gl_sub_acct_4,
                                    ovar_gl_sub_acct_5,
                                    ovar_gl_sub_acct_6,
                                    ovar_gl_sub_acct_7,
                                    ovar_intm_type_level,
                                    ovar_line_dependency_level,
                                    ovar_old_new_acct_level,
                                    ovar_dr_cr_tag
                                   );
               --i--
                /* issa 01.13.2006
             ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
             */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_cred_wh_vatri,
                                    rivar_gl_acct_category,
                                    rivar_gl_control_acct,
                                    rivar_gl_sub_acct_1,
                                    rivar_gl_sub_acct_2,
                                    rivar_gl_sub_acct_3,
                                    rivar_gl_sub_acct_4,
                                    rivar_gl_sub_acct_5,
                                    rivar_gl_sub_acct_6,
                                    rivar_gl_sub_acct_7,
                                    rivar_intm_type_level,
                                    rivar_line_dependency_level,
                                    rivar_old_new_acct_level,
                                    rivar_dr_cr_tag
                                   );
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_def_wh_vat_pay,
                                    vpvar_gl_acct_category,
                                    vpvar_gl_control_acct,
                                    vpvar_gl_sub_acct_1,
                                    vpvar_gl_sub_acct_2,
                                    vpvar_gl_sub_acct_3,
                                    vpvar_gl_sub_acct_4,
                                    vpvar_gl_sub_acct_5,
                                    vpvar_gl_sub_acct_6,
                                    vpvar_gl_sub_acct_7,
                                    vpvar_intm_type_level,
                                    vpvar_line_dependency_level,
                                    vpvar_old_new_acct_level,
                                    vpvar_dr_cr_tag
                                   );
             --i--
                      /* judyann 07072008; for RI premium tax */
             GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_prem_tax,
                                    ptvar_gl_acct_category,
                                    ptvar_gl_control_acct,
                                    ptvar_gl_sub_acct_1,
                                    ptvar_gl_sub_acct_2,
                                    ptvar_gl_sub_acct_3,
                                    ptvar_gl_sub_acct_4,
                                    ptvar_gl_sub_acct_5,
                                    ptvar_gl_sub_acct_6,
                                    ptvar_gl_sub_acct_7,
                                    ptvar_intm_type_level,
                                    ptvar_line_dependency_level,
                                    ptvar_old_new_acct_level,
                                    ptvar_dr_cr_tag
                                   );
                                  
            IF NVL(v_comm_rec_batch_takeup,'N') = 'Y' THEN --added by robert 03.11.2015                     
               GIACB003_PKG.get_module_parameters (p_module_name,
                                    p_msg,
                                    p_module_ent_comm_rec_retro,
                                    crvar_gl_acct_category,
                                    crvar_gl_control_acct,
                                    crvar_gl_sub_acct_1,
                                    crvar_gl_sub_acct_2,
                                    crvar_gl_sub_acct_3,
                                    crvar_gl_sub_acct_4,
                                    crvar_gl_sub_acct_5,
                                    crvar_gl_sub_acct_6,
                                    crvar_gl_sub_acct_7,
                                    crvar_intm_type_level,
                                    crvar_line_dependency_level,
                                    crvar_old_new_acct_level,
                                    crvar_dr_cr_tag
                                   );
            END IF;

             IF    cvar_gl_acct_category IS NOT NULL
                OR pvar_gl_acct_category IS NOT NULL
                OR dvar_gl_acct_category IS NOT NULL
                OR ivar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR ovar_gl_acct_category IS NOT NULL             --issa 01.11.2006
                OR rivar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR vpvar_gl_acct_category IS NOT NULL            --issa 01.13.2006
                OR ptvar_gl_acct_category IS NOT NULL          -- judyann 07072008
                OR crvar_gl_acct_category IS NOT NULL -- judyann 07012013
             THEN
                p_iss_cd := NULL;
    /*
               FOR ja1 IN(
                     SELECT c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd) iss_cd, g.line_cd, i.acct_line_cd,
                            g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd,
                            --decode(g.iss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                            SUM(a.ri_comm_amt*d.currency_rt) ri_comm_amt,
                            SUM(a.ri_prem_amt*d.currency_rt) ri_prem_amt,
                            --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
    */                        /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
    /*                      (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)) due_to_ri_local, --issa 01.13.2006
                            (SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)) due_to_ri_foreign, --issa 01.13.2006
                            SUM(NVL(a.ri_prem_vat,0)*d.currency_rt) ri_prem_vat, --issa 01.11.2006
                            SUM(NVL(a.ri_comm_vat,0)*d.currency_rt) ri_comm_vat,  --issa 01.11.2006
                            SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt) ri_wholding_vat,  --issa 01.13.2006
                            k.local_foreign_sw --issa 01.13.2006
                       FROM giri_frperil a,
                            giri_frps_ri b,
                            giri_binder c,
                            giri_distfrps d,
                            giuw_policyds e,
                            giuw_pol_dist f,
                            gipi_polbasic g,
                            --giac_bae_pol_parent_intm_v h,
                            giis_line  i,
                            giis_subline j,
                            giis_reinsurer k --issa 01.13.2006, to get the local/foreign sw
                      WHERE a.line_cd = b.line_cd            -- frperil 
                        AND a.frps_yy = b.frps_yy              -- frperil 
                        AND a.frps_seq_no = b.frps_seq_no      -- frperil 
                        AND a.ri_seq_no = b.ri_seq_no          -- frperil 
                        AND a.ri_cd = k.ri_cd                                  -- frperil and reinsurer issa 01.13.2006
                        AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                        AND b.line_cd = d.line_cd              -- frpsri 
                        AND b.frps_yy = d.frps_yy              -- frpsri 
                        AND b.frps_seq_no = d.frps_seq_no      -- frpsri 
                        AND d.dist_no = e.dist_no              -- distfrps 
                        AND d.dist_seq_no = e.dist_seq_no      -- distfrps 
                        AND e.dist_no = f.dist_no              -- policyds 
                        --AND g.policy_id = h.policy_id(+)       -- polbasic 
                        AND f.policy_id = g.policy_id          -- pol_dist 
                        AND g.acct_ent_date IS NOT NULL
                        AND g.acct_ent_date <= :prod.cut_off_date
                        AND ( trunc(c.acc_ent_date) = :prod.cut_off_date
                              OR (trunc(c.acc_rev_date) = :prod.cut_off_date ))
                        AND ( trunc(f.acct_ent_date) = :prod.cut_off_date
                               OR (trunc(f.acct_neg_date) = :prod.cut_off_date ))   -- added 03112005
                        AND g.line_cd = i.line_cd              -- polbasic 
                        AND g.line_cd = j.line_cd              -- polibasic 
                        AND g.subline_cd = j.subline_cd        -- polbasic 
                        AND g.reg_policy_sw = 'Y'             -- exclude special policies
                   GROUP BY c.acc_ent_date, c.acc_rev_date, nvl(g.cred_branch,g.iss_cd), g.line_cd, i.acct_line_cd,
                            g.subline_cd, j.acct_subline_cd, a.ri_cd, a.peril_cd, k.local_foreign_sw /*issa 01.13.2006*/
                                                                                                                         /*) --, decode(g.iss_cd,'RI',5 , h.acct_intm_cd) )
               LOOP
    */
       -- judyann 10052007; separated SELECT statement for reversed binders/negated distribution
                FOR ja1 IN
                   (SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             
                             --decode(g.iss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                                  -- marco - 07.30.2014 - replaced with lines below
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             --giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         --AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_ent_date) = p_prod_date
                         --AND TRUNC(f.acct_ent_date) = :prod.cut_off_date            -- judyann 07292011; include new binders created for reversed binders of unnegated distributions
                         AND TRUNC (f.acct_ent_date) <= p_prod_date
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.reg_policy_sw = 'Y'     -- exclude special policies
                         AND g.iss_cd = giisp.v ('ISS_CD_RI')
                    -- inward policies only
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             k.local_foreign_sw
                    UNION
                    SELECT   c.acc_ent_date, c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd) iss_cd, g.line_cd,
                             i.acct_line_cd, g.subline_cd, j.acct_subline_cd,
                             a.ri_cd, a.peril_cd,
                             
                             --decode(g.isss_cd,'RI',5 , h.acct_intm_cd) acct_intm_cd,
                             SUM (a.ri_comm_amt * d.currency_rt) ri_comm_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) ri_prem_amt,
                               
                               --SUM(a.ri_prem_amt*d.currency_rt) - SUM(a.ri_comm_amt*d.currency_rt) due_to_ri,
                               /* issa 01.13.2006 changed computation of prem_due_to_ri to consider local/foreign ri*/
                              DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)) 
                                       - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt))) due_to_ri_local, -- judyann 07012013
                             DECODE(NVL(v_comm_rec_batch_takeup,'N'),'N',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_amt,0)*d.currency_rt)+ SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt)),
                                 'Y',(SUM(a.ri_prem_amt*d.currency_rt)+ SUM(NVL(a.ri_prem_vat,0)*d.currency_rt)- SUM(NVL(a.prem_tax,0)*d.currency_rt)) 
                                     - (SUM(NVL(a.ri_comm_vat,0)*d.currency_rt)+ SUM(NVL(a.ri_wholding_vat,0)*d.currency_rt))) due_to_ri_foreign, -- judyann 07012013
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                                 ) ri_prem_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                                 ) ri_comm_vat,                  --issa 01.11.2006
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                                 ) ri_wholding_vat,              --issa 01.13.2006
                             SUM (NVL (a.prem_tax, 0) * d.currency_rt) prem_tax,
                             
                             -- judyann 07072008
                             k.local_foreign_sw                  --issa 01.13.2006
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             --giac_bae_pol_parent_intm_v h,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       --issa 01.13.2006, to get the local/foreign sw
                    WHERE    a.line_cd = b.line_cd            -- frperil 
                         AND a.frps_yy = b.frps_yy            -- frperil 
                         AND a.frps_seq_no = b.frps_seq_no    -- frperil 
                         AND a.ri_seq_no = b.ri_seq_no        -- frperil 
                         AND a.ri_cd = k.ri_cd
                         -- frperil and reinsurer issa 01.13.2006
                         AND b.fnl_binder_id = c.fnl_binder_id  -- frpsri 
                         AND b.line_cd = d.line_cd            -- frpsri 
                         AND b.frps_yy = d.frps_yy            -- frpsri 
                         AND b.frps_seq_no = d.frps_seq_no    -- frpsri 
                         AND d.dist_no = e.dist_no          -- distfrps 
                         AND d.dist_seq_no = e.dist_seq_no  -- distfrps 
                         AND e.dist_no = f.dist_no          -- policyds 
                         --AND g.policy_id = h.policy_id(+)       -- polbasic 
                         AND f.policy_id = g.policy_id      -- pol_dist 
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= p_prod_date
                         AND TRUNC (c.acc_rev_date) = p_prod_date
                         --AND TRUNC(f.acct_neg_date) = :prod.cut_off_date
                         AND (   (    f.dist_flag = '4'
                                  AND TRUNC (f.acct_neg_date) = p_prod_date
                                 )
                              OR (f.dist_flag = '3' AND b.reverse_sw = 'Y')
                              OR (f.dist_flag = '5')) -- added '5' for redistributed policies : SR-4824 shan 08.03.2015
                         -- judyann 07292011; include reversed binders (unnegated distributions)
                         AND g.line_cd = i.line_cd              -- polbasic 
                         AND g.line_cd = j.line_cd          -- polibasic 
                         AND g.subline_cd = j.subline_cd     -- polbasic 
                         AND g.reg_policy_sw = 'Y'     -- exclude special policies
                         AND g.iss_cd = giisp.v ('ISS_CD_RI')
                    -- inward policies only
                    GROUP BY c.acc_ent_date,
                             c.acc_rev_date,
                             NVL (g.cred_branch, g.iss_cd),
                             g.line_cd,
                             i.acct_line_cd,
                             g.subline_cd,
                             j.acct_subline_cd,
                             a.ri_cd,
                             a.peril_cd,
                             k.local_foreign_sw)
                LOOP
                   p_process := 'premium ceded and commission income';

                   IF NVL (p_iss_cd, 'xx') != ja1.iss_cd
                   THEN
                      GIACB003_PKG.insert_giac_acctrans (ja1.iss_cd,
                                            p_prod_date,
                                            p_user_id,
                                            p_iss_cd,
                                            p_fund_cd,
                                            p_tran_class,
                                            p_tran_flag,
                                            p_cut_off_date,
                                            p_gacc_tran_id);
                      p_iss_cd := ja1.iss_cd;
                   END IF;

                   IF cvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries(cvar_gl_acct_category,
                               cvar_gl_control_acct,
                               cvar_gl_sub_acct_1,
                               cvar_gl_sub_acct_2,
                               cvar_gl_sub_acct_3,
                               cvar_gl_sub_acct_4,
                               cvar_gl_sub_acct_5,
                               cvar_gl_sub_acct_6,
                               cvar_gl_sub_acct_7,
                               cvar_intm_type_level,
                               cvar_line_dependency_level,
                               cvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                --ja1.acct_intm_cd           ,
                               ja1.ri_comm_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF pvar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries(pvar_gl_acct_category,
                               pvar_gl_control_acct,
                               pvar_gl_sub_acct_1,
                               pvar_gl_sub_acct_2,
                               pvar_gl_sub_acct_3,
                               pvar_gl_sub_acct_4,
                               pvar_gl_sub_acct_5,
                               pvar_gl_sub_acct_6,
                               pvar_gl_sub_acct_7,
                               pvar_intm_type_level,
                               pvar_line_dependency_level,
                               pvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                            --ja1.acct_intm_cd
                               ja1.ri_prem_amt,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   /* issa 01.13.2006
                   ** to consider local/foreign ri
                   */
                   IF     dvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_local - ja1.ri_comm_vat;
                         ELSE
                           v_due_to_ri := ja1.due_to_ri_local + ja1.ri_comm_vat; --mikel 03.02.2015; added ja1.ri_comm_vat
                         END IF;
                      ELSE
                        --v_due_to_ri := ja1.due_to_ri_local - ja1.ri_comm_vat; --mikel 03.02.2015; replaced by codes below
                        v_due_to_ri := ja1.due_to_ri_local; --mikel 03.02.2015

                      END IF;
                      
                      GIACB003_PKG.entries(dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                --ja1.acct_intm_cd           ,
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   ELSE                                                  --foreign
                      -- marco - 07.04.2014 - AC-SPECS-2014-012_BAE_GIAB003
                      IF NVL(v_comm_rec_batch_takeup, 'N') = 'Y' THEN
                         IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                            v_due_to_ri := ja1.due_to_ri_foreign - ja1.ri_comm_vat;
                         ELSE
                           v_due_to_ri := ja1.due_to_ri_foreign + ja1.ri_comm_vat;--mikel 03.02.2015; added ja1.ri_comm_vat
                         END IF;
                      ELSE
                        --v_due_to_ri := ja1.due_to_ri_foreign - ja1.ri_comm_vat; --mikel 03.02.2015; replaced by codes below
                        v_due_to_ri := ja1.due_to_ri_foreign; --mikel 03.15.2015

                      END IF;
                      
                      GIACB003_PKG.entries(dvar_gl_acct_category,
                               dvar_gl_control_acct,
                               dvar_gl_sub_acct_1,
                               dvar_gl_sub_acct_2,
                               dvar_gl_sub_acct_3,
                               dvar_gl_sub_acct_4,
                               dvar_gl_sub_acct_5,
                               dvar_gl_sub_acct_6,
                               dvar_gl_sub_acct_7,
                               dvar_intm_type_level,
                               dvar_line_dependency_level,
                               dvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,                            --ja1.acct_intm_cd
                               v_due_to_ri,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   /*IF dvar_gl_acct_category IS NOT NULL
                   THEN
                      entries (
                         dvar_gl_acct_category      ,  dvar_gl_control_acct    ,
                            dvar_gl_sub_acct_1         ,  dvar_gl_sub_acct_2      ,
                            dvar_gl_sub_acct_3         ,  dvar_gl_sub_acct_4      ,
                            dvar_gl_sub_acct_5         ,  dvar_gl_sub_acct_6      ,
                         dvar_gl_sub_acct_7         ,  dvar_intm_type_level    ,
                           dvar_line_dependency_level ,  dvar_dr_cr_tag          ,
                         ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                         ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                         NULL, --ja1.acct_intm_cd           ,
                         ja1.due_to_ri           ,
                         ja1.iss_cd                 ,  ja1.ri_cd);
                   END IF;*/ --issa 01.13.2006 changed to consider local/foreign ri

                   /* issa 01.11.2006
                              ** added for deferred input vat and deferred output vat
                              */
                   IF     ivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw = 'L'                       --local
                   THEN
                      GIACB003_PKG.entries(ivar_gl_acct_category,
                               ivar_gl_control_acct,
                               ivar_gl_sub_acct_1,
                               ivar_gl_sub_acct_2,
                               ivar_gl_sub_acct_3,
                               ivar_gl_sub_acct_4,
                               ivar_gl_sub_acct_5,
                               ivar_gl_sub_acct_6,
                               ivar_gl_sub_acct_7,
                               ivar_intm_type_level,
                               ivar_line_dependency_level,
                               ivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_prem_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF ovar_gl_acct_category IS NOT NULL
                   THEN
                      GIACB003_PKG.entries(ovar_gl_acct_category,
                               ovar_gl_control_acct,
                               ovar_gl_sub_acct_1,
                               ovar_gl_sub_acct_2,
                               ovar_gl_sub_acct_3,
                               ovar_gl_sub_acct_4,
                               ovar_gl_sub_acct_5,
                               ovar_gl_sub_acct_6,
                               ovar_gl_sub_acct_7,
                               ovar_intm_type_level,
                               ovar_line_dependency_level,
                               ovar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_comm_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   --i--

                   /* issa 01.13.2006
                   ** added for deferred creditable withholding vat on ri and deferred withholding vat payable
                   */
                   IF     rivar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries(rivar_gl_acct_category,
                               rivar_gl_control_acct,
                               rivar_gl_sub_acct_1,
                               rivar_gl_sub_acct_2,
                               rivar_gl_sub_acct_3,
                               rivar_gl_sub_acct_4,
                               rivar_gl_sub_acct_5,
                               rivar_gl_sub_acct_6,
                               rivar_gl_sub_acct_7,
                               rivar_intm_type_level,
                               rivar_line_dependency_level,
                               rivar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                   IF     vpvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries(vpvar_gl_acct_category,
                               vpvar_gl_control_acct,
                               vpvar_gl_sub_acct_1,
                               vpvar_gl_sub_acct_2,
                               vpvar_gl_sub_acct_3,
                               vpvar_gl_sub_acct_4,
                               vpvar_gl_sub_acct_5,
                               vpvar_gl_sub_acct_6,
                               vpvar_gl_sub_acct_7,
                               vpvar_intm_type_level,
                               vpvar_line_dependency_level,
                               vpvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.ri_wholding_vat,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;

                         --i--
                   /* judyann 07072008; for RI premium tax */
                   IF     ptvar_gl_acct_category IS NOT NULL
                      AND ja1.local_foreign_sw IN ('A', 'F')             --foreign
                   THEN
                      GIACB003_PKG.entries(ptvar_gl_acct_category,
                               ptvar_gl_control_acct,
                               ptvar_gl_sub_acct_1,
                               ptvar_gl_sub_acct_2,
                               ptvar_gl_sub_acct_3,
                               ptvar_gl_sub_acct_4,
                               ptvar_gl_sub_acct_5,
                               ptvar_gl_sub_acct_6,
                               ptvar_gl_sub_acct_7,
                               ptvar_intm_type_level,
                               ptvar_line_dependency_level,
                               ptvar_dr_cr_tag,
                               ja1.acc_rev_date,
                               ja1.acct_line_cd,
                               ja1.acct_subline_cd,
                               ja1.peril_cd,
                               NULL,
                               ja1.prem_tax,
                               ja1.iss_cd,
                               ja1.ri_cd,
                               p_prod_date,
                               p_acct_line_cd,
                               p_acct_intm_cd,
                               p_var_gl_acct_id,
                               p_var_sl_type_cd,
                               p_reinsurer,
                               p_line_subline_peril,
                               p_line_subline,
                               p_sl_source_cd,
                               p_process,
                               p_msg,
                               p_gacc_tran_id,
                               p_tran_class,
                               p_fund_cd,
                               p_cut_off_date,
                               p_tran_flag,
                               p_var_count_row,
                               p_user_id
                              );
                   END IF;
                   
                   /* judyann 07012013; for commissions receivable */
                    IF NVL(v_comm_rec_batch_takeup,'N') = 'Y' THEN                        
                        IF crvar_gl_acct_category IS NOT NULL 
                        THEN
                           IF(NVL(v_ri_comm_rec_gross_tag, 'N') = 'N') THEN
                              v_ri_comm_amt := ja1.ri_comm_amt;
                           ELSE
                              v_ri_comm_amt := ja1.ri_comm_amt + ja1.ri_comm_vat;
                           END IF;
                           
                           GIACB003_PKG.entries (
                             crvar_gl_acct_category      ,  crvar_gl_control_acct    ,
                             crvar_gl_sub_acct_1         ,  crvar_gl_sub_acct_2      ,
                             crvar_gl_sub_acct_3         ,  crvar_gl_sub_acct_4      ,
                             crvar_gl_sub_acct_5         ,  crvar_gl_sub_acct_6      ,
                             crvar_gl_sub_acct_7         ,  crvar_intm_type_level    ,
                             crvar_line_dependency_level ,  crvar_dr_cr_tag          ,
                             ja1.acc_rev_date           ,  ja1.acct_line_cd        ,
                             ja1.acct_subline_cd        ,  ja1.peril_cd            ,
                             NULL                       ,  v_ri_comm_amt         ,
                             ja1.iss_cd                 ,  ja1.ri_cd,
                             p_prod_date,
                             p_acct_line_cd,
                             p_acct_intm_cd,
                             p_var_gl_acct_id,
                             p_var_sl_type_cd,
                             p_reinsurer,
                             p_line_subline_peril,
                             p_line_subline,
                             p_sl_source_cd,
                             p_process,
                             p_msg,
                             p_gacc_tran_id,
                             p_tran_class,
                             p_fund_cd,
                             p_cut_off_date,
                             p_tran_flag,
                             p_var_count_row,
                             p_user_id);
                        END IF;
                     END IF;
                END LOOP ja1;
             END IF;
          END;                                         -- exclude special policies
       END IF;                                        -- variables.exclude_special
    END;
    
    PROCEDURE check_debit_credit_amounts (p_prod_date                IN       DATE,
                                          p_module_item_no_inc_adj   IN       giac_module_entries.item_no%TYPE,
                                          p_module_item_no_exp_adj   IN       giac_module_entries.item_no%TYPE,
                                          p_module_name              IN       giac_modules.module_name%TYPE,
                                          p_fund_cd                  IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                          p_user_id                  IN       giis_users.user_id%TYPE,
                                          p_balance                  IN OUT   NUMBER,
                                          p_msg                      IN OUT   VARCHAR2)
    IS
       v_debit        giac_acct_entries.debit_amt%TYPE;
       v_credit       giac_acct_entries.credit_amt%TYPE;
       v_tot_debit    giac_acct_entries.debit_amt%TYPE;
       v_tot_credit   giac_acct_entries.credit_amt%TYPE;
       v_balance      giac_acct_entries.credit_amt%TYPE;
       v_tran_id      giac_acct_entries.gacc_tran_id%TYPE;
    BEGIN
       --Loop through the values of the amounts of the OF prod
       FOR c IN (SELECT   a.tran_id, a.gibr_branch_cd, SUM (b.debit_amt) deb_amt,
                          SUM (b.credit_amt) cre_amt
                     FROM giac_acct_entries b, giac_acctrans a
                    WHERE 1 = 1
                      AND a.tran_id = b.gacc_tran_id
                      AND a.tran_flag = 'C'
                      AND a.tran_class = 'OF'
                      AND a.tran_date = p_prod_date
                 GROUP BY a.tran_id, a.gibr_branch_cd)
       LOOP
          v_balance := c.deb_amt - c.cre_amt;

          IF v_balance != 0
          THEN
             IF ABS (v_balance) > 10
             THEN
                   p_msg := p_msg||'#Note: The miscellaenous amount being allocated is greater than 10.';
                   
                   IF v_balance > 0     -- added if-else : SR-4821 shan 08.03.2015
                   THEN
                      p_balance := v_balance;
                      GIACB003_PKG.adjust (c.tran_id,
                                           p_module_item_no_inc_adj,
                                           c.gibr_branch_cd,
                                           p_module_item_no_exp_adj,
                                           p_module_name,
                                           p_fund_cd,
                                           p_module_item_no_inc_adj,
                                           p_user_id,
                                           p_balance
                                           );
                   ELSIF v_balance < 0
                   THEN
                      p_balance := v_balance;
                      GIACB003_PKG.adjust (c.tran_id,
                                           p_module_item_no_exp_adj,
                                           c.gibr_branch_cd,
                                           p_module_item_no_exp_adj,
                                           p_module_name,
                                           p_fund_cd,
                                           p_module_item_no_inc_adj,
                                           p_user_id,
                                           p_balance
                                          );
                   END IF;
             ELSIF ABS (v_balance) <= 10
             THEN
                p_balance := 0;

                IF v_balance != 0
                THEN
                   IF v_balance > 0
                   THEN
                      p_balance := v_balance;
                      GIACB003_PKG.adjust (c.tran_id,
                                           p_module_item_no_inc_adj,
                                           c.gibr_branch_cd,
                                           p_module_item_no_exp_adj,
                                           p_module_name,
                                           p_fund_cd,
                                           p_module_item_no_inc_adj,
                                           p_user_id,
                                           p_balance
                                           );
                   ELSIF v_balance < 0
                   THEN
                      p_balance := v_balance;
                      GIACB003_PKG.adjust (c.tran_id,
                                           p_module_item_no_exp_adj,
                                           c.gibr_branch_cd,
                                           p_module_item_no_exp_adj,
                                           p_module_name,
                                           p_fund_cd,
                                           p_module_item_no_inc_adj,
                                           p_user_id,
                                           p_balance
                                          );
                   END IF;
                END IF;
             END IF;
          END IF;
       END LOOP;
    END;
    
    PROCEDURE adjust (v_tran_id          giac_acctrans.tran_id%TYPE,
                      v_module_item_no   giac_module_entries.item_no%TYPE,
                      v_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
                      p_module_item_no_exp_adj   IN   giac_module_entries.item_no%TYPE,
                      p_module_name              IN   giac_modules.module_name%TYPE,
                      p_fund_cd                  IN   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                      p_module_item_no_inc_adj   IN   giac_module_entries.item_no%TYPE,
                      p_user_id                  IN   giis_users.user_id%TYPE,
                      p_balance                  IN   NUMBER)
    IS
       v_entry_id                  giac_acct_entries.acct_entry_id%TYPE;
       var_gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE;
       var_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE;
       var_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE;
       var_dr_cr_tag               giac_chart_of_accts.dr_cr_tag%TYPE;
       var_credit_amt              giac_acct_entries.credit_amt%TYPE;
       var_debit_amt               giac_acct_entries.debit_amt%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_sl_type_cd              giac_chart_of_accts.gslt_sl_type_cd%TYPE;
    BEGIN
       SELECT MAX (NVL (acct_entry_id, 0))
         INTO v_entry_id
         FROM giac_acct_entries
        WHERE gacc_tran_id = v_tran_id;

       IF v_module_item_no = p_module_item_no_exp_adj
       THEN
          bae_get_module_parameters (p_module_item_no_exp_adj,
                                     p_module_name,
                                     var_gl_acct_category,
                                     var_gl_control_acct,
                                     var_gl_sub_acct_1,
                                     var_gl_sub_acct_2,
                                     var_gl_sub_acct_3,
                                     var_gl_sub_acct_4,
                                     var_gl_sub_acct_5,
                                     var_gl_sub_acct_6,
                                     var_gl_sub_acct_7,
                                     var_intm_type_level,
                                     var_ca_treaty_type_level,
                                     var_line_dependency_level,
                                     var_old_new_acct_level,
                                     var_dr_cr_tag
                                    );
          bae_check_chart_of_accts (var_gl_acct_category,
                                    var_gl_control_acct,
                                    var_gl_sub_acct_1,
                                    var_gl_sub_acct_2,
                                    var_gl_sub_acct_3,
                                    var_gl_sub_acct_4,
                                    var_gl_sub_acct_5,
                                    var_gl_sub_acct_6,
                                    var_gl_sub_acct_7,
                                    var_gl_acct_id,
                                    var_sl_type_cd
                                   );

          /* INSERTS INTO MISCELLANEOUS UNDERWRITING EXPENSE */
          INSERT INTO giac_acct_entries
    --giac_temp_acct_entries     -- judyann 01082009; directly insert into giac_acct_entries
                      (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                       acct_entry_id, gl_acct_id, gl_acct_category,
                       gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                       gl_sub_acct_6, gl_sub_acct_7, user_id, last_update,
                       sl_cd, debit_amt, credit_amt, generation_type,
                       remarks
                      )
               VALUES (v_tran_id, p_fund_cd, v_branch_cd,
                       v_entry_id + 1, var_gl_acct_id, var_gl_acct_category,
                       var_gl_control_acct, var_gl_sub_acct_1, var_gl_sub_acct_2,
                       var_gl_sub_acct_3, var_gl_sub_acct_4, var_gl_sub_acct_5,
                       var_gl_sub_acct_6, var_gl_sub_acct_7, giis_users_pkg.app_user, SYSDATE,
                       NULL, ABS (p_balance), 0, NULL,
                       'to adjust currency conversion/rounding off differences during production take up.'
                      );
       ELSIF v_module_item_no = p_module_item_no_inc_adj
       THEN
          bae_get_module_parameters (p_module_item_no_inc_adj,
                                     p_module_name,
                                     var_gl_acct_category,
                                     var_gl_control_acct,
                                     var_gl_sub_acct_1,
                                     var_gl_sub_acct_2,
                                     var_gl_sub_acct_3,
                                     var_gl_sub_acct_4,
                                     var_gl_sub_acct_5,
                                     var_gl_sub_acct_6,
                                     var_gl_sub_acct_7,
                                     var_intm_type_level,
                                     var_ca_treaty_type_level,
                                     var_line_dependency_level,
                                     var_old_new_acct_level,
                                     var_dr_cr_tag
                                    );
          bae_check_chart_of_accts (var_gl_acct_category,
                                    var_gl_control_acct,
                                    var_gl_sub_acct_1,
                                    var_gl_sub_acct_2,
                                    var_gl_sub_acct_3,
                                    var_gl_sub_acct_4,
                                    var_gl_sub_acct_5,
                                    var_gl_sub_acct_6,
                                    var_gl_sub_acct_7,
                                    var_gl_acct_id,
                                    var_sl_type_cd
                                   );

          /* INSERTS INTO MISCELLANEOUS UNDERWRITING INCOME */
          INSERT INTO giac_acct_entries
    --giac_temp_acct_entries     -- judyann 01082009; directly insert into giac_acct_entries
                      (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                       acct_entry_id, gl_acct_id, gl_acct_category,
                       gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                       gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                       gl_sub_acct_6, gl_sub_acct_7, user_id, last_update,
                       sl_cd, debit_amt, credit_amt, generation_type,
                       remarks
                      )
               VALUES (v_tran_id, p_fund_cd, v_branch_cd,
                       v_entry_id + 1, var_gl_acct_id, var_gl_acct_category,
                       var_gl_control_acct, var_gl_sub_acct_1, var_gl_sub_acct_2,
                       var_gl_sub_acct_3, var_gl_sub_acct_4, var_gl_sub_acct_5,
                       var_gl_sub_acct_6, var_gl_sub_acct_7, giis_users_pkg.app_user, SYSDATE,
                       NULL, 0, ABS (p_balance), NULL,
                       'to adjust currency conversion/rounding off differences during production take up.'
                      );
       END IF;
    END;
END;
/