CREATE OR REPLACE PACKAGE BODY CPI.GIACB006_PKG
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.22.2013
   **  Reference By : GIACB006 use in GIACB000 - Batch Accounting Entry
   **  Description  : 
   */

    PROCEDURE re_take_up(p_prod_date     IN  DATE,
                         p_cut_off_date  OUT DATE,
                         p_msg           OUT VARCHAR2)
    IS
       v_tran_flag   giac_acctrans.tran_flag%TYPE;
       v_dummy       VARCHAR2 (1);
       v_tkup_exs    BOOLEAN                        := FALSE;
       ctr           NUMBER                         := 0;
       v_tran_class  GIAC_ACCTRANS.tran_class%type  := 'PCR';
    BEGIN
       p_cut_off_date := p_prod_date;

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
          THEN                                                 --Show the message
             p_msg := p_msg || '#Production take up for '
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
       --we must update the corresponding tables because it is a complete re-run
       IF v_tkup_exs
       THEN
          --Update giac_prepaid_comm acc_ent_date
          UPDATE giac_prepaid_comm
             SET acct_ent_date = NULL
           WHERE TRUNC (acct_ent_date) = TRUNC (p_prod_date);

       END IF;
    END;
    
    PROCEDURE prod_take_up(p_prod_date            IN       DATE,
                           p_cut_off_date         IN OUT   DATE,
                           p_exclude_special      IN OUT   VARCHAR2,
                           p_fund_cd              IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                           p_ri_iss_cd            IN OUT   giac_parameters.param_value_v%TYPE,
                           p_user_id              IN       giis_users.user_id%TYPE,
                           p_msg                  IN OUT   VARCHAR2)
    IS
        var_param_value_n                   giac_parameters.param_value_n%TYPE;
        v_module_ent_prep_comm              giac_module_entries.item_no%type:=1;
        v_module_ent_comm_payable           giac_module_entries.item_no%type:=2;
        v_module_ent_def_wtax               giac_module_entries.item_no%type:=3;   
        v_module_ent_wtax                   giac_module_entries.item_no%type:=4;   
        v_module_ent_def_invat              giac_module_entries.item_no%type:=5;  
        v_module_ent_invat                  giac_module_entries.item_no%type:=6;  
        v_module_item_no_Inc_adj            GIAC_MODULE_ENTRIES.item_no%type:=7;
        v_module_item_no_Exp_adj            GIAC_MODULE_ENTRIES.item_no%type:=8;
        v_assured                           giac_sl_types.sl_type_cd%type:='1';
        v_sl_source_cd                      GIAC_ACCT_ENTRIES.sl_source_cd%type := 1;
        var_gl_acct_id                      giac_acct_entries.gl_acct_id%type;
        var_sl_type_cd                      giac_acct_entries.sl_type_cd%type;
        v_ri_iss_cd							GIAC_PARAMETERS.param_value_v%type:= 'RI';
        v_tran_class    					GIAC_ACCTRANS.tran_class%type := 'PCR';
        v_module_name                       GIAC_MODULES.module_name%type:= 'GIACB006';
        var_count_row  					    NUMBER := 0;
        v_tran_flag     					GIAC_ACCTRANS.tran_flag%type := 'C';
        v_gacc_tran_id  					GIAC_ACCTRANS.tran_id%type ;    
        v_acct_intm_cd    					GIIS_INTM_TYPE.acct_intm_cd%type;
        v_acct_line_cd  					GIIS_LINE.acct_line_cd%type;
        v_process                           VARCHAR2(100);
        v_iss_cd                            giac_branches.branch_cd%type;
    BEGIN
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

       DELETE FROM giac_temp_acct_entries;

       GIACB006_PKG.create_batch_entries(p_prod_date,
                                         v_module_name);

       GIACB006_PKG.update_giac_prepaid_comm(p_prod_date,
                                             var_count_row);

       GIACB006_PKG.EXTRACT(p_prod_date,
                          p_exclude_special,
                          v_module_ent_prep_comm,
                          v_module_ent_comm_payable,
                          v_module_ent_def_wtax,
                          v_module_ent_wtax,
                          v_module_ent_def_invat,
                          v_module_ent_invat,
                          v_iss_cd,
                          v_process,
                          v_module_name,
                          v_acct_line_cd,
                          v_acct_intm_cd,
                          var_gl_acct_id,
                          var_sl_type_cd,
                          v_sl_source_cd,
                          p_msg,
                          p_fund_cd,
                          v_tran_class,
                          v_tran_flag,
                          p_cut_off_date,
                          v_gacc_tran_id,
                          var_count_row,
                          v_assured);

       GIACB006_PKG.transfer_to_giac_acct_entries();

--       GIACB006_PKG.check_debit_credit_amounts;
    END;
    
    PROCEDURE create_batch_entries(p_prod_date     IN   DATE,
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
           WHERE a.module_id = b.module_id
             AND a.module_name LIKE p_module_name;

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
    END;
    
    PROCEDURE update_giac_prepaid_comm(p_prod_date         IN       DATE,
                                       p_var_count_row     IN OUT   NUMBER)
    IS
       v_dummy   NUMBER := 0;
    BEGIN
       p_var_count_row := 0;

       FOR ja1 IN (SELECT a.gacc_tran_id, a.policy_id, a.iss_cd, a.prem_seq_no,
                          d.acct_ent_date
                     FROM giac_prepaid_comm a,
                          gipi_polbasic b,
                          gipi_invoice d,
                          giac_acctrans c
                    WHERE a.policy_id = b.policy_id
                      AND a.gacc_tran_id = c.tran_id
                      AND b.policy_id = d.policy_id
                      AND a.iss_cd = d.iss_cd
                      AND a.prem_seq_no = d.prem_seq_no
                      AND c.tran_flag <> 'D'
                      AND NOT EXISTS (
                             SELECT '1'
                               FROM giac_reversals x, giac_acctrans y
                              WHERE x.reversing_tran_id = y.tran_id
                                AND x.gacc_tran_id = a.gacc_tran_id
                                AND y.tran_flag <> 'D')
                      AND a.cancel_date IS NULL
                      AND d.acct_ent_date <= p_prod_date
                      AND a.acct_ent_date IS NULL)
       LOOP
          UPDATE giac_prepaid_comm
             SET acct_ent_date = p_prod_date
           WHERE gacc_tran_id = ja1.gacc_tran_id
             AND iss_cd = ja1.iss_cd
             AND prem_seq_no = ja1.prem_seq_no;
       END LOOP;
    END;
    
    PROCEDURE EXTRACT(p_prod_date                       IN DATE,
                      p_exclude_special                 IN giac_parameters.param_value_v%TYPE,
                      p_module_ent_prep_comm            IN giac_module_entries.item_no%TYPE,
                      p_module_ent_comm_payable         IN giac_module_entries.item_no%TYPE,
                      p_module_ent_def_wtax             IN giac_module_entries.item_no%TYPE,
                      p_module_ent_wtax                 IN giac_module_entries.item_no%TYPE,
                      p_module_ent_def_invat            IN giac_module_entries.item_no%TYPE,
                      p_module_ent_invat                IN giac_module_entries.item_no%TYPE,
                      p_iss_cd                          IN OUT giac_branches.branch_cd%TYPE,
                      p_process                         IN OUT VARCHAR2,
                      p_module_name                     IN giac_modules.module_name%TYPE,
                      p_acct_line_cd                    IN OUT giis_line.acct_line_cd%TYPE,
                      p_acct_intm_cd                    IN OUT giis_intm_type.acct_intm_cd%TYPE,
                      p_var_gl_acct_id                  IN OUT giac_acct_entries.gl_acct_id%TYPE,
                      p_var_sl_type_cd                  IN OUT giac_acct_entries.sl_type_cd%TYPE,
                      p_sl_source_cd                    IN OUT giac_acct_entries.sl_source_cd%TYPE,
                      p_msg                             IN OUT VARCHAR2,
                      p_fund_cd                         IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                      p_tran_class                      IN OUT giac_acctrans.tran_class%TYPE,
                      p_tran_flag                       IN OUT giac_acctrans.tran_flag%TYPE,
                      p_cut_off_date                    IN OUT DATE,
                      p_gacc_tran_id                    IN OUT giac_acctrans.tran_id%TYPE,
                      p_var_count_row                   IN OUT NUMBER,
                      p_assured                         IN OUT giac_sl_types.sl_type_cd%type)
    IS
       var_acct_line_cd              giis_line.acct_line_cd%TYPE;
       var_acct_subline_cd           giis_subline.acct_subline_cd%TYPE;
       var_acct_intm_cd              giis_intm_type.acct_intm_cd%TYPE;
       --prepaid comm gl account
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
       --comm payable gl account
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
       --deferred input vat gl account
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
       --input vat gl account
       dvar2_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       dvar2_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       dvar2_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       dvar2_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       dvar2_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       dvar2_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       dvar2_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       dvar2_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       dvar2_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       dvar2_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       dvar2_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       dvar2_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       dvar2_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       --deferred withholding tax gl account
       vvar_gl_acct_category         giac_module_entries.gl_acct_category%TYPE;
       vvar_gl_control_acct          giac_module_entries.gl_control_acct%TYPE;
       vvar_gl_sub_acct_1            giac_module_entries.gl_sub_acct_1%TYPE;
       vvar_gl_sub_acct_2            giac_module_entries.gl_sub_acct_2%TYPE;
       vvar_gl_sub_acct_3            giac_module_entries.gl_sub_acct_3%TYPE;
       vvar_gl_sub_acct_4            giac_module_entries.gl_sub_acct_4%TYPE;
       vvar_gl_sub_acct_5            giac_module_entries.gl_sub_acct_5%TYPE;
       vvar_gl_sub_acct_6            giac_module_entries.gl_sub_acct_6%TYPE;
       vvar_gl_sub_acct_7            giac_module_entries.gl_sub_acct_7%TYPE;
       vvar_intm_type_level          giac_module_entries.intm_type_level%TYPE;
       vvar_line_dependency_level    giac_module_entries.line_dependency_level%TYPE;
       vvar_old_new_acct_level       giac_module_entries.old_new_acct_level%TYPE;
       vvar_dr_cr_tag                giac_module_entries.dr_cr_tag%TYPE;
       --withholding tax gl account
       vvar2_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       vvar2_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       vvar2_gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE;
       vvar2_gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE;
       vvar2_gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE;
       vvar2_gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE;
       vvar2_gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE;
       vvar2_gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE;
       vvar2_gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE;
       vvar2_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       vvar2_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       vvar2_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       vvar2_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
       v_tax_ent_param               giac_parameters.param_value_v%TYPE
                                            := giacp.v ('TAX_ENTRY_ON_COMM_PAYT');
    BEGIN
       BEGIN
          GIACB006_PKG.get_module_parameters (p_module_ent_prep_comm,
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
                                             cvar_dr_cr_tag,
                                             p_module_name,
                                             p_msg
                                            );
          GIACB006_PKG.get_module_parameters (p_module_ent_comm_payable,
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
                                             pvar_dr_cr_tag,
                                             p_module_name,
                                             p_msg
                                            );
          GIACB006_PKG.get_module_parameters (p_module_ent_def_wtax,
                                             vvar_gl_acct_category,
                                             vvar_gl_control_acct,
                                             vvar_gl_sub_acct_1,
                                             vvar_gl_sub_acct_2,
                                             vvar_gl_sub_acct_3,
                                             vvar_gl_sub_acct_4,
                                             vvar_gl_sub_acct_5,
                                             vvar_gl_sub_acct_6,
                                             vvar_gl_sub_acct_7,
                                             vvar_intm_type_level,
                                             vvar_line_dependency_level,
                                             vvar_old_new_acct_level,
                                             vvar_dr_cr_tag,
                                             p_module_name,
                                             p_msg
                                            );
          GIACB006_PKG.get_module_parameters (p_module_ent_wtax,
                                             vvar2_gl_acct_category,
                                             vvar2_gl_control_acct,
                                             vvar2_gl_sub_acct_1,
                                             vvar2_gl_sub_acct_2,
                                             vvar2_gl_sub_acct_3,
                                             vvar2_gl_sub_acct_4,
                                             vvar2_gl_sub_acct_5,
                                             vvar2_gl_sub_acct_6,
                                             vvar2_gl_sub_acct_7,
                                             vvar2_intm_type_level,
                                             vvar2_line_dependency_level,
                                             vvar2_old_new_acct_level,
                                             vvar2_dr_cr_tag,
                                             p_module_name,
                                             p_msg
                                            );
          GIACB006_PKG.get_module_parameters (p_module_ent_def_invat,
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
                                             dvar_dr_cr_tag,
                                             p_module_name,
                                             p_msg
                                            );
          GIACB006_PKG.get_module_parameters (p_module_ent_invat,
                                             dvar2_gl_acct_category,
                                             dvar2_gl_control_acct,
                                             dvar2_gl_sub_acct_1,
                                             dvar2_gl_sub_acct_2,
                                             dvar2_gl_sub_acct_3,
                                             dvar2_gl_sub_acct_4,
                                             dvar2_gl_sub_acct_5,
                                             dvar2_gl_sub_acct_6,
                                             dvar2_gl_sub_acct_7,
                                             dvar2_intm_type_level,
                                             dvar2_line_dependency_level,
                                             dvar2_old_new_acct_level,
                                             dvar2_dr_cr_tag,
                                             p_module_name,
                                             p_msg
                                            );

          IF cvar_gl_acct_category IS NOT NULL
             OR pvar_gl_acct_category IS NOT NULL
          THEN
             p_iss_cd := NULL;
             FOR ja1 IN (SELECT   a.gacc_tran_id, b.assd_no, a.policy_id,
                                  a.iss_cd, a.prem_seq_no,
                                  SUM (NVL (a.comm_amt, 0)) comm_amt,
                                  SUM (NVL (a.wtax_amt, 0)) wtax_amt,
                                  SUM (NVL (a.input_vat_amt, 0)) invat_amt,
                                  e.acct_line_cd, h.acct_intm_cd,
                                  c.gibr_branch_cd
                             FROM giac_prepaid_comm a,
                                  gipi_polbasic b,
                                  gipi_invoice i,
                                  giac_acctrans c,
                                  giis_line e,
                                  giac_bae_pol_parent_intm_v h
                            WHERE a.policy_id = b.policy_id
                              AND a.policy_id = i.policy_id
                              AND a.gacc_tran_id = c.tran_id
                              AND b.line_cd = e.line_cd
                              AND b.policy_id = h.policy_id(+)
                              AND a.iss_cd = i.iss_cd
                              AND a.prem_seq_no = i.prem_seq_no
                              AND a.intm_no = h.parent_intm_no
                              AND NVL (i.takeup_seq_no, 1) = h.takeup_seq_no
                              AND c.tran_flag <> 'D'
                              AND NOT EXISTS (
                                     SELECT '1'
                                       FROM giac_reversals x, giac_acctrans y
                                      WHERE x.reversing_tran_id = y.tran_id
                                        AND x.gacc_tran_id = a.gacc_tran_id
                                        AND y.tran_flag <> 'D')
                              AND a.cancel_date IS NULL
                              AND a.acct_ent_date = p_prod_date
                         GROUP BY c.gibr_branch_cd,
                                  a.gacc_tran_id,
                                  b.assd_no,
                                  a.policy_id,
                                  a.iss_cd,
                                  a.prem_seq_no,
                                  e.acct_line_cd,
                                  h.acct_intm_cd)
             LOOP
                p_process :=
                                    'prepaid commissions and commissions payable';

                IF NVL (p_iss_cd, 'xx') != ja1.gibr_branch_cd
                THEN
                   insert_giac_acctrans (ja1.gibr_branch_cd,
                                         p_prod_date,
                                         p_cut_off_date,  
                                         p_iss_cd,
                                         p_fund_cd,
                                         p_tran_class,
                                         p_tran_flag,
                                         p_gacc_tran_id);
                   p_iss_cd := ja1.gibr_branch_cd;
                END IF;

                IF cvar_gl_acct_category IS NOT NULL
                THEN
                   GIACB006_PKG.entries (cvar_gl_acct_category,
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
                                        ja1.assd_no,
                                        ja1.acct_line_cd,
                                        ja1.acct_intm_cd,
                                        ja1.comm_amt,
                                        ja1.gibr_branch_cd,
                                        p_prod_date,
                                        p_acct_line_cd,
                                        p_acct_intm_cd,
                                        p_var_gl_acct_id,
                                        p_var_sl_type_cd,
                                        p_sl_source_cd,
                                        p_process,
                                        p_msg,
                                        p_gacc_tran_id,
                                        p_tran_class,
                                        p_fund_cd,
                                        p_cut_off_date,
                                        p_tran_flag,
                                        p_var_count_row,
                                        p_assured
                                        );
                END IF;

                IF pvar_gl_acct_category IS NOT NULL
                THEN
                   GIACB006_PKG.entries (pvar_gl_acct_category,
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
                                        ja1.assd_no,
                                        ja1.acct_line_cd,
                                        ja1.acct_intm_cd,
                                        ja1.comm_amt,
                                        ja1.gibr_branch_cd,
                                        p_prod_date,
                                        p_acct_line_cd,
                                        p_acct_intm_cd,
                                        p_var_gl_acct_id,
                                        p_var_sl_type_cd,
                                        p_sl_source_cd,
                                        p_process,
                                        p_msg,
                                        p_gacc_tran_id,
                                        p_tran_class,
                                        p_fund_cd,
                                        p_cut_off_date,
                                        p_tran_flag,
                                        p_var_count_row,
                                        p_assured
                                        );
                END IF;

                IF NVL (v_tax_ent_param, 'A') = 'A'
                THEN
                   --entries for deferred input vat
                   GIACB006_PKG.entries (dvar_gl_acct_category,
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
                                        NULL,
                                        ja1.acct_line_cd,
                                        ja1.acct_intm_cd,
                                        ja1.invat_amt,
                                        ja1.gibr_branch_cd,
                                        p_prod_date,
                                        p_acct_line_cd,
                                        p_acct_intm_cd,
                                        p_var_gl_acct_id,
                                        p_var_sl_type_cd,
                                        p_sl_source_cd,
                                        p_process,
                                        p_msg,
                                        p_gacc_tran_id,
                                        p_tran_class,
                                        p_fund_cd,
                                        p_cut_off_date,
                                        p_tran_flag,
                                        p_var_count_row,
                                        p_assured
                                        );
                   --entries for input vat
                   GIACB006_PKG.entries (dvar2_gl_acct_category,
                                        dvar2_gl_control_acct,
                                        dvar2_gl_sub_acct_1,
                                        dvar2_gl_sub_acct_2,
                                        dvar2_gl_sub_acct_3,
                                        dvar2_gl_sub_acct_4,
                                        dvar2_gl_sub_acct_5,
                                        dvar2_gl_sub_acct_6,
                                        dvar2_gl_sub_acct_7,
                                        dvar2_intm_type_level,
                                        dvar2_line_dependency_level,
                                        dvar2_dr_cr_tag,
                                        NULL,
                                        ja1.acct_line_cd,
                                        ja1.acct_intm_cd,
                                        ja1.invat_amt,
                                        ja1.gibr_branch_cd,
                                        p_prod_date,
                                        p_acct_line_cd,
                                        p_acct_intm_cd,
                                        p_var_gl_acct_id,
                                        p_var_sl_type_cd,
                                        p_sl_source_cd,
                                        p_process,
                                        p_msg,
                                        p_gacc_tran_id,
                                        p_tran_class,
                                        p_fund_cd,
                                        p_cut_off_date,
                                        p_tran_flag,
                                        p_var_count_row,
                                        p_assured
                                        );
                   --entries for deferred withholding tax
                   GIACB006_PKG.entries (vvar_gl_acct_category,
                                        vvar_gl_control_acct,
                                        vvar_gl_sub_acct_1,
                                        vvar_gl_sub_acct_2,
                                        vvar_gl_sub_acct_3,
                                        vvar_gl_sub_acct_4,
                                        vvar_gl_sub_acct_5,
                                        vvar_gl_sub_acct_6,
                                        vvar_gl_sub_acct_7,
                                        vvar_intm_type_level,
                                        vvar_line_dependency_level,
                                        vvar_dr_cr_tag,
                                        NULL,
                                        ja1.acct_line_cd,
                                        ja1.acct_intm_cd,
                                        ja1.wtax_amt,
                                        ja1.gibr_branch_cd,
                                        p_prod_date,
                                        p_acct_line_cd,
                                        p_acct_intm_cd,
                                        p_var_gl_acct_id,
                                        p_var_sl_type_cd,
                                        p_sl_source_cd,
                                        p_process,
                                        p_msg,
                                        p_gacc_tran_id,
                                        p_tran_class,
                                        p_fund_cd,
                                        p_cut_off_date,
                                        p_tran_flag,
                                        p_var_count_row,
                                        p_assured
                                        );
                   --entries for withholding tax
                   GIACB006_PKG.entries (vvar2_gl_acct_category,
                                        vvar2_gl_control_acct,
                                        vvar2_gl_sub_acct_1,
                                        vvar2_gl_sub_acct_2,
                                        vvar2_gl_sub_acct_3,
                                        vvar2_gl_sub_acct_4,
                                        vvar2_gl_sub_acct_5,
                                        vvar2_gl_sub_acct_6,
                                        vvar2_gl_sub_acct_7,
                                        vvar2_intm_type_level,
                                        vvar2_line_dependency_level,
                                        vvar2_dr_cr_tag,
                                        NULL,
                                        ja1.acct_line_cd,
                                        ja1.acct_intm_cd,
                                        ja1.wtax_amt,
                                        ja1.gibr_branch_cd,
                                        p_prod_date,
                                        p_acct_line_cd,
                                        p_acct_intm_cd,
                                        p_var_gl_acct_id,
                                        p_var_sl_type_cd,
                                        p_sl_source_cd,
                                        p_process,
                                        p_msg,
                                        p_gacc_tran_id,
                                        p_tran_class,
                                        p_fund_cd,
                                        p_cut_off_date,
                                        p_tran_flag,
                                        p_var_count_row,
                                        p_assured
                                        );
                END IF;
             END LOOP ja1;
          END IF;
       END;
    END;
    
    PROCEDURE get_module_parameters (var_module_item_no          IN       giac_module_entries.item_no%TYPE,
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
                                    var_dr_cr_tag               IN OUT   giac_module_entries.dr_cr_tag%TYPE,
                                    p_module_name			    IN       GIAC_MODULES.module_name%type,
                                    p_msg					    IN OUT   VARCHAR2)
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
          raise_application_error(-20001,p_msg||'#Geniisys Exception#GL account '
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
    
    PROCEDURE insert_giac_acctrans (iga_iss_cd 			IN giac_branches.branch_cd%TYPE,
                                    p_prod_date			IN DATE,
                                    p_cut_off_date		IN DATE,  
                                    p_iss_cd			IN OUT giac_branches.branch_cd%type,
                                    p_fund_cd			IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                    p_tran_class		IN OUT GIAC_ACCTRANS.tran_class%type,
                                    p_tran_flag			IN OUT GIAC_ACCTRANS.tran_flag%type,
                                    p_gacc_tran_id		IN OUT GIAC_ACCTRANS.tran_id%type)
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

                   UPDATE giac_prepaid_comm a
                      SET a.batch_gacc_tran_id = p_gacc_tran_id
                    WHERE a.acct_ent_date = p_prod_date
                      AND var_branch_cd = (SELECT b.gibr_branch_cd
                                             FROM giac_acctrans b
                                            WHERE b.tran_id = a.gacc_tran_id);

                   INSERT INTO giac_acctrans
                               (tran_id, gfun_fund_cd,
                                gibr_branch_cd, tran_year, tran_month,
                                tran_seq_no, tran_date,
                                tran_flag, tran_class,
                                tran_class_no, user_id, last_update,
                                particulars
                               )
                        VALUES (p_gacc_tran_id, p_fund_cd,
                                var_branch_cd, var_year, var_month,
                                var_tran_seq_no, p_cut_off_date,
                                p_tran_flag, p_tran_class,
                                var_tran_class_no, giis_users_pkg.app_user, SYSDATE,
                                   'Reversing entries for prepaid commissions for '
                                || TO_CHAR (p_cut_off_date,
                                            'fmMonth yyyy')
                               );
                END;
          END;
       END;
    END;
    
    PROCEDURE entries ( bpc_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
                        bpc_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
                        bpc_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,
                        bpc_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
                        bpc_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
                        bpc_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
                        bpc_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
                        bpc_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
                        bpc_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
                        bpc_intm_type_level         giac_module_entries.intm_type_level%TYPE,
                        bpc_line_dependency_level   giac_module_entries.line_dependency_level%TYPE,
                        bpc_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE,
                        bpc_assd_no                 gipi_parlist.assd_no%TYPE,
                        bpc_acct_line_cd            giis_line.acct_line_cd%TYPE,
                        bpc_acct_intm_cd            giis_intm_type.acct_intm_cd%TYPE,
                        bpc_coll_amt                NUMBER,
                        bpc_iss_cd                  gipi_polbasic.iss_cd%TYPE,
                        p_prod_date                 IN       DATE,
                        p_acct_line_cd              IN OUT   giis_line.acct_line_cd%TYPE,
                        p_acct_intm_cd              IN OUT   giis_intm_type.acct_intm_cd%TYPE,
                        p_var_gl_acct_id            IN OUT   giac_acct_entries.gl_acct_id%TYPE,
                        p_var_sl_type_cd            IN OUT   giac_acct_entries.sl_type_cd%TYPE,
                        p_sl_source_cd              IN OUT   giac_acct_entries.sl_source_cd%TYPE,
                        p_process                   IN OUT   VARCHAR2,
                        p_msg                       IN OUT   VARCHAR2,
                        p_gacc_tran_id              IN OUT   giac_acctrans.tran_id%TYPE,
                        p_tran_class                IN OUT   giac_acctrans.tran_class%TYPE,
                        p_fund_cd                   IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                        p_cut_off_date              IN OUT   DATE,
                        p_tran_flag                 IN OUT   giac_acctrans.tran_flag%TYPE,
                        p_var_count_row             IN OUT   NUMBER,
                        p_assured                   IN OUT   giac_sl_types.sl_type_cd%type)
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

       CURSOR sl_type_cur
       IS
          SELECT sl_type_cd
            FROM giac_sl_types
           WHERE sl_type_name = 'ASSURED';
    BEGIN
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

       OPEN sl_type_cur;

       FETCH sl_type_cur
        INTO var_sl_type_cd;

       CLOSE sl_type_cur;

       p_acct_line_cd := bpc_acct_line_cd;
       p_acct_intm_cd := bpc_acct_intm_cd;
       p_var_gl_acct_id := var_gl_acct_id;
       p_var_sl_type_cd := var_sl_type_cd;

       IF bpc_coll_amt != 0
       THEN
          IF p_var_sl_type_cd = p_assured
          THEN
             var_sl_cd := bpc_assd_no;
          END IF;

          get_drcr_amt (bpc_dr_cr_tag, bpc_coll_amt, var_credit_amt,
                        var_debit_amt);
          GIACB006_PKG.bae_insert_update_acct_entries (var_gl_acct_category,
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
                                                      p_process
                                                     );
       END IF;
    END;
    
    /*****************************************************************************
    *                                                                            *
    * This procedure determines whether the records will be updated or inserted  *
    * in GIAC_ACCT_ENTRIES.                                                      *
    *                                                                            *
    *****************************************************************************/
    PROCEDURE bae_insert_update_acct_entries(iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
                                             iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
                                             iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
                                             iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
                                             iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
                                             iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
                                             iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
                                             iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
                                             iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
                                             iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
                                             iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
                                             iuae_branch_cd          giac_branches.branch_cd%TYPE,
                                             iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
                                             iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
                                             iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
                                             iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
                                             p_gacc_tran_id            IN OUT giac_acctrans.tran_id%TYPE,
                                             p_tran_class              IN OUT giac_acctrans.tran_class%TYPE,
                                             p_fund_cd                 IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                             p_cut_off_date            IN OUT DATE,
                                             p_tran_flag               IN OUT giac_acctrans.tran_flag%TYPE,
                                             p_var_count_row           IN OUT NUMBER,
                                             p_process                 IN     VARCHAR2)
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
          iuae_acct_entry_id := p_var_count_row;

          INSERT INTO giac_temp_acct_entries
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
    
    PROCEDURE transfer_to_giac_acct_entries
    IS
       var_counter   NUMBER;
    BEGIN
       FOR rec IN (SELECT   gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                            gl_acct_id, gl_acct_category, gl_control_acct,
                            gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                            gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                            gl_sub_acct_7, user_id,
                            TRUNC (last_update) last_update, sl_cd,
                            SUM (debit_amt) debit_amt,
                            SUM (credit_amt) credit_amt, generation_type,
                            remarks, sl_type_cd, sl_source_cd
                       FROM giac_temp_acct_entries
                   GROUP BY gacc_tran_id,
                            gacc_gfun_fund_cd,
                            gacc_gibr_branch_cd,
                            gl_acct_id,
                            gl_acct_category,
                            gl_control_acct,
                            gl_sub_acct_1,
                            gl_sub_acct_2,
                            gl_sub_acct_3,
                            gl_sub_acct_4,
                            gl_sub_acct_5,
                            gl_sub_acct_6,
                            gl_sub_acct_7,
                            user_id,
                            TRUNC (last_update),
                            sl_cd,
                            generation_type,
                            remarks,
                            sl_type_cd,
                            sl_source_cd)
       LOOP
          var_counter := NVL (var_counter, 0) + 1;

          INSERT INTO giac_acct_entries
                      (gacc_tran_id, gacc_gfun_fund_cd,
                       gacc_gibr_branch_cd, acct_entry_id, gl_acct_id,
                       gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, user_id, last_update,
                       sl_cd, debit_amt, credit_amt,
                       generation_type, remarks, sl_type_cd,
                       sl_source_cd
                      )
               VALUES (rec.gacc_tran_id, rec.gacc_gfun_fund_cd,
                       rec.gacc_gibr_branch_cd, var_counter, rec.gl_acct_id,
                       rec.gl_acct_category, rec.gl_control_acct,
                       rec.gl_sub_acct_1, rec.gl_sub_acct_2, rec.gl_sub_acct_3,
                       rec.gl_sub_acct_4, rec.gl_sub_acct_5, rec.gl_sub_acct_6,
                       rec.gl_sub_acct_7, rec.user_id, rec.last_update,
                       rec.sl_cd, rec.debit_amt, rec.credit_amt,
                       rec.generation_type, rec.remarks, rec.sl_type_cd,
                       rec.sl_source_cd
                      );
       END LOOP;
    END;
    
    PROCEDURE check_debit_credit_amounts(p_prod_date                IN       DATE,
                                         p_module_item_no_inc_adj   IN       giac_module_entries.item_no%TYPE,
                                         p_module_item_no_exp_adj   IN       giac_module_entries.item_no%TYPE,
                                         p_module_name              IN       giac_modules.module_name%TYPE,
                                         p_fund_cd                  IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
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
       --Loop through the values of the amounts of the PCR transaction
       FOR c IN (SELECT   a.tran_id, a.gibr_branch_cd, SUM (b.debit_amt) deb_amt,
                          SUM (b.credit_amt) cre_amt
                     FROM giac_acct_entries b, giac_acctrans a
                    WHERE 1 = 1
                      AND a.tran_id = b.gacc_tran_id
                      AND a.tran_flag = 'C'
                      AND a.tran_class = 'PCR'
                      AND a.tran_date = p_prod_date
                 GROUP BY a.tran_id, a.gibr_branch_cd)
       LOOP
          v_balance := c.deb_amt - c.cre_amt;

          IF v_balance != 0
          THEN
             IF ABS (v_balance) > 10
             THEN
                p_msg := p_msg||'#Note: The miscellaenous amount being allocated is greater than 10.';
             ELSIF ABS (v_balance) <= 10
             THEN
                p_balance := 0;

                IF v_balance != 0
                THEN
                   IF v_balance > 0
                   THEN
                      p_balance := v_balance;
                      adjust (c.tran_id,
                              p_module_item_no_inc_adj,
                              c.gibr_branch_cd,
                              p_module_item_no_exp_adj,
                              p_module_name,
                              p_fund_cd,
                              p_module_item_no_inc_adj,
                              p_balance
                             );
                   ELSIF v_balance < 0
                   THEN
                      p_balance := v_balance;
                      adjust (c.tran_id,
                              p_module_item_no_exp_adj,
                              c.gibr_branch_cd,
                              p_module_item_no_exp_adj,
                              p_module_name,
                              p_fund_cd,
                              p_module_item_no_inc_adj,
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

          /* INSERTS INTO MISCELLANEOUS UNDERWRITING EXPENSE / OTHER OPERATING EXPENSE */
          INSERT INTO giac_acct_entries
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

          /* INSERTS INTO MISCELLANEOUS INCOME / OTHER INCOME*/
          INSERT INTO giac_acct_entries
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


