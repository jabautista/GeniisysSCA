CREATE OR REPLACE PACKAGE BODY CPI.GIACB001_PKG
AS
   /*
   **  Created by   : Steven Ramirez 
   **  Date Created : 04.15.2013
   **  Reference By : GIACB001 use in GIACB000 - Batch Accounting Entry
   **  Description  : added updates of acct_ent_date/spoiled_acct_ent_date on gipi_invoice
   **                 this is due to the long-term policy enhancement
   */
    PROCEDURE re_take_up(p_prod_date     IN  DATE,
                         p_new_prod_date OUT DATE,
                         p_msg           OUT VARCHAR2)
    IS
        v_tran_class         GIAC_ACCTRANS.tran_class%type := 'PRD';
        v_tran_flag          GIAC_ACCTRANS.tran_flag%type := 'C';
        v_new_prod_date      DATE;
        v_ri_iss_cd          GIAC_PARAMETERS.param_value_v%type:= 'RI';
        addl                 VARCHAR2(1):= 'N';
        switch               VARCHAR2(1):= 'N';
        stat                 VARCHAR2(8);
        v_validate           VARCHAR2(1);
        v_test               VARCHAR2(1);
        v_taken_up           VARCHAR2(1):= 'N';
        v_test_2             VARCHAR2(1);
        /*
        This will limit the number of the times the messsages
        appear on screen because it is inside a loop
        */
        v_add_msg            NUMBER(10) := 0;
        v_noadd_msg          NUMBER(10) := 0;
    BEGIN
      /* for posted additional take-up starts here */
      BEGIN
        FOR rec IN (
          SELECT DISTINCT 'x'
            FROM giac_acctrans
           WHERE tran_class = v_tran_class
             AND tran_flag  IN ('P')  -- variables.tran_flag    
             AND TO_CHAR(tran_date,'mm-dd-yyyy') = TO_CHAR(p_prod_date,'mm-dd-yyyy') ) 
        LOOP   
          addl := 'Y' ; 

          v_add_msg := v_add_msg + 1;
         
          IF v_add_msg = 1 THEN
             p_msg := p_msg ||'#Production for '||to_char(p_prod_date,'fmMonth dd,yyyy')||
                       ' has already been done.This will be an additional take up.';
          END IF;
          << again >>
          v_new_prod_date := TRUNC(p_prod_date) - 1;
          BEGIN
            SELECT DISTINCT 'x'
              INTO v_test
              FROM giac_acctrans
             WHERE tran_class = v_tran_class
               AND tran_flag = 'P'
               AND trunc(tran_date) = TRUNC(v_new_prod_date);

            IF v_test = 'x' THEN
               GOTO again;
            END IF;
           
            EXCEPTION
              WHEN no_data_found THEN  
                BEGIN
                  SELECT DISTINCT 'x'
                    INTO v_test
                    FROM giac_acctrans
                   WHERE tran_class = v_tran_class
                     AND tran_flag = v_tran_flag
                     AND TRUNC(tran_date) = TRUNC(v_new_prod_date);

                  IF v_add_msg = 1 THEN
                     p_msg := p_msg ||'#Production take up for '||to_char( v_new_prod_date,'fmMonth dd,yyyy')||
                              ' has already been done. This will be a complete take up of this transaction date.';
                  END IF;
                 
                  UPDATE gipi_polbasic
                     SET acct_ent_date = NULL
                   WHERE TRUNC(acct_ent_date) = TRUNC(v_new_prod_date)
                     AND iss_cd != v_ri_iss_cd
                     AND line_cd NOT IN ('BB','SC');
                                 
                  UPDATE gipi_invoice
                     SET acct_ent_date = NULL
                   WHERE TRUNC(acct_ent_date) = TRUNC(v_new_prod_date)
                     AND iss_cd != v_ri_iss_cd; --added by steven 03.06.2014; base from the module changes
                
                  UPDATE gipi_polbasic
                     SET spld_acct_ent_date = NULL
                   WHERE TRUNC(spld_acct_ent_date) = TRUNC(v_new_prod_date)
                     AND iss_cd != v_ri_iss_cd
                     AND line_cd NOT IN ('BB','SC');

                  UPDATE gipi_invoice
                     SET spoiled_acct_ent_date = NULL
                   WHERE TRUNC(spoiled_acct_ent_date) = TRUNC(v_new_prod_date)
                     AND iss_cd != v_ri_iss_cd; --added by steven 03.06.2014; base from the module changes                 
             
                  FOR ja1 IN ( 
                    SELECT tran_id
                      FROM giac_acctrans
                     WHERE tran_flag = v_tran_flag
                       AND tran_class = v_tran_class
                       AND TRUNC(tran_date) = TRUNC(v_new_prod_date)) 
                  LOOP
         
                    UPDATE gipi_comm_invoice 
                       SET gacc_tran_id = null
                     WHERE gacc_tran_id = ja1.tran_id;

                    UPDATE giac_parent_comm_invoice 
                       SET tran_id = null
                     WHERE tran_id = ja1.tran_id;

                    UPDATE giac_acctrans 
                       SET tran_flag = 'D'
                     WHERE tran_id = ja1.tran_id;

                  END LOOP;
                 
                  EXCEPTION
                    WHEN no_data_found THEN
                      NULL;  --continue with re-take-up
                END;
            END;
        END LOOP;
      END;
      
      /* for posted additional take-up ends here */
      IF v_new_prod_date IS NULL THEN
         v_new_prod_date := p_prod_date;
      END IF;
      
      /* for unposted take-up starts here */
      IF addl = 'N' THEN
         BEGIN
           FOR rec IN (
             SELECT DISTINCT tran_id
               FROM giac_acctrans
              WHERE tran_class = v_tran_class
                AND tran_flag  IN ('C')  -- variables.tran_flag    
                AND TO_CHAR(tran_date,'mm-dd-yyyy') = TO_CHAR(p_prod_date,'mm-dd-yyyy') ) 
           LOOP
             v_new_prod_date := p_prod_date;

             UPDATE gipi_comm_invoice
                SET gacc_tran_id = NULL
              WHERE gacc_tran_id = rec.tran_id;
            
             UPDATE giac_parent_comm_invoice
                SET tran_id = NULL
              WHERE tran_id = rec.tran_id;
                 
             UPDATE giac_acctrans
                SET tran_flag = 'D'
              WHERE tran_id = rec.tran_id;
                 
             v_noadd_msg := v_noadd_msg + 1;

             IF switch = 'N' THEN
                IF v_noadd_msg = 1 THEN 
                   p_msg := p_msg ||'#Production take up for '||to_char(p_prod_date,'fmMonth dd,yyyy')||
                             ' has already been done. This will be a complete retake-up.';
                END IF;
             END IF;
           END LOOP;
         END;

         UPDATE gipi_polbasic
            SET acct_ent_date = NULL
          WHERE TRUNC(acct_ent_date) = TRUNC(v_new_prod_date)
            AND line_cd NOT IN ('BB','SC')
            AND iss_cd != v_ri_iss_cd;

         UPDATE gipi_invoice
            SET acct_ent_date = NULL
          WHERE TRUNC(acct_ent_date) = TRUNC(v_new_prod_date)
            AND iss_cd != v_ri_iss_cd;     --added by albert 01.25.2017 GENQA SR 4857 - only direct policies should be set to null upon re-run

         UPDATE gipi_polbasic
            SET spld_acct_ent_date = null
          WHERE TRUNC(spld_acct_ent_date) = TRUNC(v_new_prod_date)
            AND line_cd not in ('BB','SC')
            AND iss_cd != v_ri_iss_cd;
            
         UPDATE gipi_invoice
            SET spoiled_acct_ent_date = null
          WHERE TRUNC(spoiled_acct_ent_date) = TRUNC(v_new_prod_date)
            AND iss_cd != v_ri_iss_cd;     --added by albert 01.25.2017 GENQA SR 4857 - only direct policies should be set to null upon re-run        

      END IF; -- addl = 'N' then
      p_new_prod_date := v_new_prod_date;--TO_CHAR(v_new_prod_date,'mm-dd-yyyy');
      --raise_application_error(-20001,'Geniisys Exception#imgMessage.INFO#steve test - '|| p_new_prod_date);
    END;
    
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.15.2013
   **  Reference By : GIACB001 use in GIACB000 - Batch Accounting Entry
   **  Description  : 
   */
    PROCEDURE prod_take_up(p_msg                 IN OUT VARCHAR2,
                           p_gen_home            IN OUT GIAC_PARAMETERS.param_value_v%type,
                           p_sql_path            IN OUT VARCHAR2,
                           p_var_param_value_n   IN OUT    GIAC_PARAMETERS.param_value_n%type,
                           p_fund_cd             IN OUT    GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                           p_ri_iss_cd           IN OUT GIAC_PARAMETERS.param_value_v%type,
                           p_prem_rec_gross_tag  IN OUT    GIAC_PARAMETERS.param_value_v%type)
    IS
     v_gen_home              GIAC_PARAMETERS.param_value_v%type;
     v_sql_path              VARCHAR2(40);
     v_var_param_value_n     GIAC_PARAMETERS.param_value_n%type;
     v_fund_cd               GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type;
     v_ri_iss_cd             GIAC_PARAMETERS.param_value_v%type:= 'RI';
     v_prem_rec_gross_tag     GIAC_PARAMETERS.param_value_v%type;

     CURSOR home IS
        SELECT param_value_v
        FROM giac_parameters
        WHERE param_name = 'GENIISYS'; 

     CURSOR PATH IS
        SELECT param_value_v
        FROM giac_parameters
        WHERE param_name = 'SQL_PATH'; 

    BEGIN
       FOR ja1 in home LOOP
          v_gen_home := ja1.param_value_v;
       END LOOP;

       FOR ja1 in PATH LOOP
          v_sql_path := ja1.param_value_v;
       END LOOP;

       BEGIN
          SELECT param_value_n
            INTO v_var_param_value_n   
            FROM giac_parameters
           WHERE  param_name = 'BATCH_TAKE_UP';
       EXCEPTION
          WHEN NO_DATA_FOUND  THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (BATCH_TAKE_UP).');
          WHEN TOO_MANY_ROWS THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#TOO MANY ROWS for BATCH_TAKE_UP parameter.');
       END;

       BEGIN
          SELECT PARAM_VALUE_V
            INTO v_fund_cd
            FROM GIAC_PARAMETERS
           WHERE PARAM_NAME = 'FUND_CD';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (FUND_CD).');
       END;

       BEGIN
          SELECT  param_value_v
            INTO v_ri_iss_cd
            FROM giac_parameters
           WHERE param_name = 'RI_ISS_CD';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (RI_ISS_CD).');
       END;

       BEGIN
          SELECT param_value_v
            INTO v_prem_rec_gross_tag
            FROM giac_parameters
           WHERE param_name  = 'PREM_REC_GROSS_TAG';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (PREM_REC_GROSS_TAG).');
       END;
       
       p_gen_home := v_gen_home;              
       p_sql_path := v_sql_path;
       p_var_param_value_n := v_var_param_value_n;
       p_fund_cd := v_fund_cd;
       p_ri_iss_cd := v_ri_iss_cd;
       p_prem_rec_gross_tag := v_prem_rec_gross_tag;
    END;
    
    PROCEDURE prod_take_up_proc(p_prod_date             IN DATE,
                                p_new_prod_date         IN OUT DATE,
                                p_exclude_special       IN OUT VARCHAR2,
                                p_gen_home              IN OUT GIAC_PARAMETERS.param_value_v%type,
                                p_sql_path              IN VARCHAR2,
                                p_var_param_value_n     IN GIAC_PARAMETERS.param_value_n%type,
                                p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                p_ri_iss_cd             IN GIAC_PARAMETERS.param_value_v%type,
                                p_prem_rec_gross_tag    IN GIAC_PARAMETERS.param_value_v%type,
                                p_user_id               IN GIIS_USERS.user_id%type,
                                p_process               IN OUT VARCHAR2,
                                p_msg                   IN OUT VARCHAR2)
    IS
    v_sql_name                  VARCHAR2(100);
    v_folder                    VARCHAR2(100):= 'GIACB001\';
    v_spoiled_flag              GIPI_POLBASIC.pol_flag%type := '5';
    v_dist_flag                 GIUW_POL_DIST.dist_flag%type := '3';
    v_marine_line               GIIS_LINE.line_cd%TYPE:= 'MN';
    v_marine_subline            GIIS_SUBLINE.subline_cd%TYPE := 'MOP';
    v_bb_iss_cd                 GIAC_PARAMETERS.param_value_v%type:= 'BB';
    v_bae_line_cd               GIIS_LINE.line_cd%type;
    var_counter_positive        NUMBER := 0;
    var_counter_negative        NUMBER := 0;
    var_positive                VARCHAR2(1) := 'P';
    var_negative                VARCHAR2(1) := 'N';
    v_policies                  NUMBER;
    v_module_name               GIAC_MODULES.module_name%type:= 'GIACB001';
    v_tran_class                GIAC_ACCTRANS.tran_class%type := 'PRD';
    v_tran_flag                 GIAC_ACCTRANS.tran_flag%type := 'C';
    v_gacc_tran_id              GIAC_ACCTRANS.tran_id%type;
    v_tax_dr_cd_tag             VARCHAR2(1) := 'C'; 
    var_count_row               NUMBER := 0;
    v_row_counter               NUMBER;
    v_line_dep                  giac_module_entries.line_dependency_level%type;
    v_intm_dep                  giac_module_entries.intm_type_level%type;
    v_ca_dep                    giac_module_entries.ca_treaty_type_level%type;
    v_item_no                   giac_module_entries.item_no%type;
    v_module_item_no_CP         GIAC_MODULE_ENTRIES.item_no%type:= 5;
    v_module_item_no_CE         GIAC_MODULE_ENTRIES.item_no%type:= 6;
    v_module_item_no_GP         GIAC_MODULE_ENTRIES.item_no%type:= 1;
    v_module_item_no_PR1        GIAC_MODULE_ENTRIES.item_no%type:= 2;
    v_module_item_no_PR2        GIAC_MODULE_ENTRIES.item_no%type:= 3;
    v_module_item_no_OCI        GIAC_MODULE_ENTRIES.item_no%type:= 7;
    v_module_item_no_Inc        GIAC_MODULE_ENTRIES.item_no%type:= 7;
    v_module_item_no_Exp        GIAC_MODULE_ENTRIES.item_no%type:= 8;
    v_module_item_no_Inc_adj    GIAC_MODULE_ENTRIES.item_no%type:= 9;
    v_module_item_no_Exp_adj    GIAC_MODULE_ENTRIES.item_no%type:= 10;
    v_balance                   NUMBER;
    
    var_policy_id               GIPI_POLBASIC.policy_id%type;
    var_acct_branch_cd          GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%type;
    var_acct_line_cd            GIIS_LINE.acct_line_cd%type;
    var_acct_subline_cd         GIIS_SUBLINE.acct_subline_cd%type;
    var_acct_intm_cd            GIIS_INTM_TYPE.acct_intm_cd%type;
    var_peril_cd                GIIS_PERIL.peril_cd%type;
    var_prem_amt                GIPI_POLBASIC.tsi_amt%type;
    var_currency_rt             GIPI_INVOICE.currency_rt%type;
    var_pos_neg_inclusion       GIAC_PRODUCTION_EXT.pos_neg_inclusion%type;
    var_assd_no                 GIPI_POLBASIC.assd_no%type;
    var_other_charges           GIPI_POLBASIC.tsi_amt%type;
    var_total_amt               GIPI_POLBASIC.tsi_amt%type;
    var_branch_cd               GIAC_BRANCHES.branch_cd%type;
    v_parent_intm_no            GIIS_INTERMEDIARY.parent_intm_no%type; 
    v_intm_type                 GIIS_INTERMEDIARY.intm_type%type;
    v_acct_intm_cd              GIIS_INTM_TYPE.acct_intm_cd%type; 
    v_prem_amt                  GIPI_POLBASIC.prem_amt%type;

    BEGIN
      giis_users_pkg.app_user := p_user_id; 
      p_exclude_special := NVL(p_exclude_special,'Y');
      --raise_application_error(-20001,p_msg||'#Geniisys Exception#steven test only.');
      --Truncate the production table
      DELETE FROM giac_production_ext;
     --delete from giac_production_ext;

      --Truncate production tax table
      DELETE FROM giac_production_tax_ext;
      --delete from giac_production_tax_ext;

      GIACB001_PKG.get_acct_intm_cd3(v_module_name,
                                     p_msg); 

      IF p_var_param_value_n IN (3, 4, 5) 
      THEN
         GIACB001_PKG.bae1_copy_to_extract(p_prod_date,
                                            p_new_prod_date,
                                            p_var_param_value_n,
                                            p_exclude_special,
                                            v_line_dep,
                                            v_intm_dep,
                                            v_item_no,
                                            v_sql_name,
                                            p_msg,
                                            p_process);
      ELSIF p_var_param_value_n = 2 THEN
      
         GIACB001_PKG.extract_all_policies_2(p_prod_date,
                                             p_exclude_special,
                                             v_spoiled_flag,
                                             p_ri_iss_cd,
                                             v_bb_iss_cd,
                                             p_fund_cd,
                                             v_bae_line_cd,
                                             v_marine_line,
                                             v_marine_subline,
                                             v_dist_flag,
                                             var_counter_positive,
                                             var_positive,
                                             var_counter_negative,
                                             var_negative,
                                             v_policies);
         GIACB001_PKG.bae1_copy_to_extract(p_prod_date,
                                            p_new_prod_date,
                                            p_var_param_value_n,
                                            p_exclude_special,
                                            v_line_dep,
                                            v_intm_dep,
                                            v_item_no,
                                            v_sql_name,
                                            p_msg,
                                            p_process);
      ELSIF p_var_param_value_n = 1 then
         GIACB001_PKG.extract_all_policies_1(p_prod_date,
                                             p_exclude_special,
                                             v_spoiled_flag,
                                             p_ri_iss_cd,
                                             v_bb_iss_cd,
                                             p_fund_cd,
                                             v_bae_line_cd,
                                             v_marine_line,
                                             v_marine_subline,
                                             v_dist_flag,
                                             var_counter_positive,
                                             var_positive,
                                             var_counter_negative,
                                             var_negative,
                                             v_policies);
         GIACB001_PKG.bae1_copy_to_extract(p_prod_date,
                                            p_new_prod_date,
                                            p_var_param_value_n,
                                            p_exclude_special,
                                            v_line_dep,
                                            v_intm_dep,
                                            v_item_no,
                                            v_sql_name,
                                            p_msg,
                                            p_process);
      END IF;

      --Creating batch chart of account entries
      GIACB001_PKG.create_batch_entries(p_prod_date,
                                        v_module_name);
      
      --Deleting records in GIAC_TEMP_ACCT_ENTRIES...
      DELETE FROM giac_temp_acct_entries;
      
      --Inserting records in giac_acctrans...
      GIACB001_PKG.insert_giac_acctrans(p_prod_date,
                                        p_new_prod_date,
                                        p_fund_cd,
                                        v_tran_class,
                                        v_tran_flag,
                                        p_user_id,
                                        v_gacc_tran_id,
                                        p_msg);

      --Creating taxes payable accounting entries...
      GIACB001_PKG.bae_taxes_payable(p_prem_rec_gross_tag,
                                     v_tax_dr_cd_tag,
                                     var_positive,
                                     var_negative,
                                     p_fund_cd,
                                     p_prod_date,
                                     p_new_prod_date,
                                     p_user_id,
                                     v_tran_class,
                                     v_tran_flag,
                                     var_count_row, 
                                     v_row_counter,
                                     v_gacc_tran_id,
                                     p_msg);

      --Creating commission expense accounting entries...
      GIACB001_PKG.bae1_create_comm_expense(p_prod_date,
                                            p_new_prod_date,
                                            p_process,
                                            p_msg,
                                            v_module_item_no_CE,
                                            v_module_name,
                                            p_gen_home,
                                            v_folder,
                                            v_sql_name,
                                            v_line_dep,
                                            v_intm_dep,
                                            v_ca_dep,
                                            v_item_no);

      --added by mikel 06.15.2015; SR 4691 Wtax enhancements, BIR demo findings.
      IF NVL(giacp.v('BATCH_GEN_WTAX'), 'N') = 'Y' THEN
        --Creating commission payable accounting entries...
          GIACB001_PKG.bae1_create_netcomm_payable  (p_prod_date,
                                                    p_new_prod_date,
                                                    p_process,
                                                    p_msg,
                                                    v_module_item_no_CP,
                                                    v_module_name,
                                                    p_gen_home,
                                                    v_folder,
                                                    v_sql_name,
                                                    v_line_dep,
                                                    v_intm_dep,
                                                    v_ca_dep,
                                                    v_item_no);
        --Creating withholding tax accounting entries...
          GIACB001_PKG.bae1_create_wtax (p_prod_date,
                                        p_new_prod_date,
                                        p_process,
                                        p_msg,
                                        v_module_name,
                                        p_gen_home,
                                        v_folder,
                                        v_sql_name,
                                        v_line_dep,
                                        v_intm_dep,
                                        v_ca_dep,
                                        v_item_no);                                                                             
      --end mikel 06.15.2015;                                                                                                
      ELSE 
          --Creating commission payable accounting entries...
          GIACB001_PKG.bae1_create_comm_payable(p_prod_date,
                                                p_new_prod_date,
                                                p_process,
                                                p_msg,
                                                v_module_item_no_CP,
                                                v_module_name,
                                                p_gen_home,
                                                v_folder,
                                                v_sql_name,
                                                v_line_dep,
                                                v_intm_dep,
                                                v_ca_dep,
                                                v_item_no);
      END IF;                                          

      --Creating gross premiums accounting entries...
      GIACB001_PKG.bae1_create_gross_prem(p_prod_date,
                                          p_new_prod_date,
                                          p_process,
                                          p_msg,
                                          v_module_item_no_GP,
                                          v_module_name,
                                          p_gen_home,
                                          v_folder,
                                          v_sql_name,
                                          v_line_dep,
                                          v_intm_dep,
                                          v_ca_dep,
                                          v_item_no);
                                          
      --Creating premiums receivable accounting entries...
      GIACB001_PKG.bae1_create_prem_rec(p_prod_date,
                                        p_prem_rec_gross_tag,
                                        p_new_prod_date,
                                        p_process,
                                        p_msg,
                                        v_module_item_no_PR1,
                                        v_module_item_no_PR2,
                                        v_module_item_no_OCI,
                                        v_module_name,
                                        p_gen_home,
                                        v_folder,
                                        v_sql_name,
                                        v_line_dep,
                                        v_intm_dep,
                                        v_ca_dep,
                                        v_item_no);
    --commented by lina transfer this codes below  04102007
      /*trace_log('Checking debit/credit amounts if equal...');
      CHECK_DEBIT_CREDIT_AMOUNTS;
      trace_log('Issuing a commit...');
      FORMS_DDL('COMMIT');
      synchronize;
      message('Please wait. Transferring accounting entries to giac_acct_entries.',no_acknowledge);*/

      --Running procedure GIAC_ACCT_ENTRIES'
      GIACB001_PKG.transfer_to_giac_acct_entries;

      --Checking debit/credit amounts if equal...'
      
      GIACB001_PKG.check_debit_credit_amounts(p_prod_date,
                                              v_module_item_no_Inc_adj,
                                              v_module_item_no_Exp_adj,
                                              v_module_name,
                                              p_fund_Cd,
                                              p_user_id,
                                              v_balance);

      --'Updating GIPI_POLBASIC...'
      GIACB001_PKG.update_polbasic(p_prod_date,
                                   var_count_row);

      --Updating GIAC_PARENT_COMM_INVOICE...'
      GIACB001_PKG.update_giac_parent_comm(v_module_name,
                                           v_module_item_no_CP,
                                           v_module_item_no_CE,
                                           v_tran_class,
                                           v_tran_flag,
                                           p_new_prod_date,
                                           var_count_row,
                                           p_prod_date);
                                           
    END;
    
    PROCEDURE get_acct_intm_cd3(p_module_name IN VARCHAR2,
                                p_msg       IN OUT VARCHAR2)
    IS
       V_SHARE_PERCENTAGE         GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE;
       V_INTM_NO                  GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
       V_PARENT_INTM_NO           GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE;
       V_INTM_TYPE                GIIS_INTM_TYPE.INTM_TYPE%TYPE;
       V_ACCT_INTM_CD             GIIS_INTM_TYPE.ACCT_INTM_CD%TYPE;
       V_LIC_TAG                  GIIS_INTERMEDIARY.LIC_TAG%TYPE;
       VAR_LIC_TAG                GIIS_INTERMEDIARY.LIC_TAG%TYPE:='N';
       VAR_INTM_TYPE              GIIS_INTM_TYPE.INTM_TYPE%TYPE;
       VAR_INTM_NO                GIPI_COMM_INVOICE.INTRMDRY_INTM_NO%TYPE;
       VAR_PARENT_INTM_NO         GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE;
       GICI_PARENT_INTM_NO        GIPI_COMM_INVOICE.PARENT_INTM_NO%TYPE;
       V_DUMMY                    VARCHAR2(1);
    BEGIN
         BEGIN
           SELECT DISTINCT 'x'
             INTO v_dummy
             FROM giac_module_entries a
            WHERE intm_type_level IS NOT NULL
              AND EXISTS (SELECT b.module_id
                            FROM giac_modules b
                           WHERE b.module_id = a.module_id
                             AND b.module_name LIKE p_module_name);

           IF v_dummy IS NOT NULL 
           THEN
           FOR rec IN (
             SELECT POLICY_ID
               FROM GIAC_PRODUCTION_EXT )
               LOOP
                 BEGIN  
                   SELECT DISTINCT parent_intm_no 
                   INTO gici_parent_intm_no
                   FROM gipi_comm_invoice
                   WHERE policy_Id = rec.policy_id;

                   IF gici_parent_intm_no IS NOT NULL 
                   THEN
                     BEGIN
                       SELECT a.intm_type, b.acct_intm_cd
                       INTO v_intm_type, v_acct_intm_cd
                       FROM giis_intermediary a, giis_intm_type b
                       WHERE a.intm_type = b.intm_type
                       AND a.intm_no = gici_parent_intm_no;

                         V_PARENT_INTM_NO := gici_parent_intm_no;
                          
                     EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          p_msg := p_msg||'#Intermediary No. '|| to_char(gici_parent_intm_no)||' does not exist in master file.';
                          DELETE FROM giac_production_ext 
                          WHERE policy_id = rec.policy_id;
                     END;
                   ELSIF gici_parent_intm_no IS NULL THEN
                   <<find_parent>>
                   
                       BEGIN
                         SELECT MAX(SHARE_PERCENTAGE)
                           INTO V_SHARE_PERCENTAGE
                           FROM GIPI_COMM_INVOICE
                          WHERE POLICY_ID = REC.POLICY_ID;

                          IF V_SHARE_PERCENTAGE IS NOT NULL 
                          THEN
                            BEGIN
                             SELECT min(intrmdry_intm_no)
                             INTO v_intm_no
                             FROM gipi_comm_invoice
                             WHERE share_percentage = v_share_percentage
                               AND POLICY_ID = REC.POLICY_ID;
                               IF V_INTM_NO IS NULL THEN NULL;
                                  p_msg := p_msg||'#NO INTERMEDIARY FOUND FOR POLICY '||TO_CHAR(REC.POLICY_ID);
                               END IF;            
                            EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                               p_msg := p_msg||'#NO SHARE PERCENTAGE FOUND FOR POLICY '||TO_CHAR(REC.POLICY_ID);
                            END;
                          ELSE
                            p_msg := p_msg||'#NO SHARE PERCENTAGE FOUND FOR POLICY '||TO_CHAR(REC.POLICY_ID);
                          END IF;
                       EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                            p_msg := p_msg||'#NO SHARE PERCENTAGE FOUND FOR THIS POLICY.';
                       END;

                       BEGIN
                         SELECT PARENT_INTM_NO, INTM_TYPE, NVL(LIC_TAG,'N')
                         INTO V_PARENT_INTM_NO, V_INTM_TYPE, V_LIC_TAG
                         FROM GIIS_INTERMEDIARY
                         WHERE INTM_NO = V_INTM_NO;

                           IF V_LIC_TAG  = 'Y' THEN
                               V_PARENT_INTM_NO := V_INTM_NO;
                           ELSIF V_LIC_TAG  = 'N' THEN
                             IF V_PARENT_INTM_NO IS NULL THEN
                               V_PARENT_INTM_NO := V_INTM_NO;
                             ELSE  -- check for the nearest licensed parent intm no --
                               var_lic_tag := v_lic_tag;
                               WHILE var_lic_tag = 'N' 
                                 AND v_parent_intm_no IS NOT NULL 
                                 LOOP
                                     BEGIN
                                       SELECT intm_no,
                                              parent_intm_no,
                                              intm_type,
                                              lic_tag
                                       INTO   var_intm_no,
                                              var_parent_intm_no,
                                              var_intm_type,
                                              var_lic_tag
                                       FROM giis_intermediary
                                       WHERE intm_no = v_parent_intm_no; 

                                       v_parent_intm_no := var_parent_intm_no;
                                       v_intm_type      := var_intm_type;
                                       v_lic_tag        := var_lic_tag; 


                                       IF VAR_PARENT_INTM_NO IS NULL THEN
                                         v_parent_intm_no := var_intm_no;
                                         EXIT;
                                       ELSE
                                         var_lic_tag := 'N';
                                       END IF;
                                     EXCEPTION
                                       WHEN NO_DATA_FOUND THEN
                                         p_msg := p_msg||'#'||TO_Char(v_parent_intm_no)||' HAS NO_DATA_FOUND IN GIIS INTERMEDIARY.';
                                         v_parent_intm_no := var_intm_no;
                                         EXIT;
                                     END;
                               END LOOP;
                             END IF;  --IF V_PARENT_INTM_NO IS NULL THEN
                           END IF;  --IF V_LIC_TAG  = 'Y' THEN
                           
                           BEGIN
                             SELECT ACCT_INTM_CD
                             INTO V_ACCT_INTM_CD
                             FROM GIIS_INTM_TYPE
                             WHERE INTM_TYPE = V_INTM_TYPE;
                           EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                               p_msg := p_msg||'#'|| V_INTM_TYPE||' HAS NO RECORD IN GIIS_INTM_TYPE.';
                           END;
                       EXCEPTION 
                         WHEN NO_DATA_FOUND THEN
                           p_msg := p_msg||'#'|| TO_CHAR(REC.POLICY_iD)|| ' POLICY HAS NO RECORD IN GIIS_INTERMEDIARY.';
                           delete from giac_production_ext where policy_id = rec.policy_id;
                       END;
                   END IF;        --if gici_parent_intm_no is null then
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     p_msg := p_msg||'#Policy id '|| to_char(rec.policy_id) ||' not in gipi_comm_invoice.';
                     delete from giac_production_ext where policy_id = rec.policy_id;
                 END;
                 UPDATE GIAC_PRODUCTION_EXT
                    SET INTM_NO      =   V_PARENT_INTM_NO,
                        ACCT_INTM_CD =   V_ACCT_INTM_CD
                  WHERE POLICY_ID  =   REC.POLICY_ID;

                 UPDATE gipi_comm_invoice
                    SET parent_intm_no = V_PARENT_INTM_NO
                  WHERE policy_id = rec.policy_id
                    AND parent_intm_no IS NULL;
               END LOOP;
           END IF;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN 
             NULL;
         END;
    END;

    PROCEDURE bae1_copy_to_extract(p_prod_date          IN DATE,
                                   p_new_prod_date      IN OUT DATE,
                                   p_var_param_value_n  IN GIAC_PARAMETERS.param_value_n%type,
                                   p_exclude_special    IN VARCHAR2,
                                   p_line_dep           IN giac_module_entries.line_dependency_level%type,
                                   p_intm_dep           IN giac_module_entries.intm_type_level%type,
                                   p_item_no            IN giac_module_entries.item_no%type,
                                   p_sql_name           IN OUT VARCHAR2,
                                   p_msg                IN OUT VARCHAR2,
                                   p_process            IN OUT VARCHAR2)
    IS
        path  VARCHAR2(100);
    BEGIN
      --Run the production extract
      IF p_var_param_value_n IN (3,4,5) THEN
         IF p_exclude_special = 'Y' THEN
            /* to exclude special policies */     
            IF p_var_param_value_n = 5 THEN
               --Setting the name of the procedure to run: BAE1_COPY_TO_EXTRACT_REG'
               p_sql_name := upper('bae1_copy_to_extract_reg');
            ELSIF p_var_param_value_n = 4 THEN
               --(BATCH_TAKE_UP is 4)Setting the name of the procedure to run: BAE1_COPY_TO_EXTRACT_REG'
               p_sql_name := upper('bae1_copy_to_extract_reg');
            ELSIF p_var_param_value_n = 3 THEN
               --(BATCH_TAKE_UP is 3)Setting the name of the procedure to run: BAE1_COPY_TO_EXTRACT_REG'
               p_sql_name := upper('bae1_copy_to_extract_reg');
            END IF;
         
         ELSIF p_exclude_special = 'N' THEN

            /* take up all policies */ 
            IF p_var_param_value_n = 5 THEN
               --Setting the name of the procedure to run: BAE1_COPY_TO_EXTRACT'
               p_sql_name := upper('bae1_copy_to_extract');
            ELSIF p_var_param_value_n = 4 THEN
               --(BATCH_TAKE_UP is 4)Setting the name of the procedure to run: BAE1_COPY_TO_EXTRACT'
               p_sql_name := upper('bae1_copy_to_extract');
            ELSIF p_var_param_value_n = 3 THEN
               --(BATCH_TAKE_UP is 3)Setting the name of the procedure to run: BAE1_COPY_TO_EXTRACT'
               p_sql_name := upper('bae1_copy_to_extract');
            END IF;
         END IF;
         GIACB001_PKG.run_sql_report(path, 
                                     p_prod_date,
                                     p_new_prod_date,
                                     p_sql_name,
                                     p_line_dep,
                                     p_intm_dep,
                                     p_item_no,
                                     p_process,
                                     p_msg);
      END IF;

      --Run the production tax extract
      --Setting the name of the procedure to run: BAE1_COPY_TAX_TO_EXTRACT'
      p_sql_name := upper('bae1_copy_tax_to_extract');
      GIACB001_PKG.run_sql_report(path,
                                  p_prod_date,
                                  p_new_prod_date,
                                  p_sql_name,
                                  p_line_dep,
                                  p_intm_dep,
                                  p_item_no,
                                  p_process,
                                  p_msg);
    END;
    
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.16.2013
   **  Reference By : GIACB001 use in GIACB000 - Batch Accounting Entry
   **  Description  : The RUN_SQL_REPORT procedure was formerly used to run the SQL scripts
   **       of the old batch generation. This was modified to handle the new way of running the
   **       batch generation using the database package BAE. The only variable needed to run the
   **       commands are the names of the procedures that should be called.
   */
    PROCEDURE run_sql_report(path               IN VARCHAR2,
                             p_prod_date        IN DATE,
                             p_new_prod_date    IN OUT DATE,
                             p_sql_name         IN VARCHAR2,
                             p_line_dep         IN giac_module_entries.line_dependency_level%type,
                             p_intm_dep         IN giac_module_entries.intm_type_level%type,
                             p_item_no          IN giac_module_entries.item_no%type,
                             p_process          IN OUT VARCHAR2,
                             p_msg              IN OUT VARCHAR2)
    IS
   unrecognized_sql_name EXCEPTION;
    BEGIN
      p_process := 'false';
      IF p_new_prod_date  IS NULL 
      THEN
        p_new_prod_date := p_prod_date; 
      END IF;

      --Start calling the corresponding procedure to run
      IF UPPER(p_sql_name) = upper('bae1_copy_to_extract') THEN
         --Populating GIAC_PRODUCTION_EXT using BAE.BAE1_COPY_TO_EXTRACT...'
         BAE.BAE1_COPY_TO_EXTRACT(p_prod_date);
         p_process := 'true';
      ELSIF  upper(p_sql_name) = upper('bae1_copy_to_extract_reg') THEN
         --'Populating GIAC_PRODUCTION_EXT using BAE.BAE1_COPY_TO_EXTRACT_REG...'
         BAE.BAE1_COPY_TO_EXTRACT_REG(p_prod_date);
         p_process := 'true';
      ELSIF  upper(p_sql_name) = upper('bae1_copy_tax_to_extract') THEN
         --'Populating GIAC_PRODUCTION_TAX_EXT using BAE.BAE1_COPY_TAX_TO_EXTRACT...'
         BAE.BAE1_COPY_TAX_TO_EXTRACT(p_prod_date);
         p_process := 'true';
      ELSIF  upper(p_sql_name) = upper('bae1_create_comm') THEN
         --'Creating accounting entries for COMMISSION EXPENSE AND PAYABLE using BAE.BAE1_CREATE_COMM...'
         BAE.BAE1_CREATE_COMM(p_prod_date,p_line_dep,p_intm_dep,p_item_no);
         p_process := 'true';
      ELSIF  upper(p_sql_name) = upper('bae1_create_parent_comm') THEN
        NULL;
        p_process := 'true';
         --'Creating accounting entries for PARENT COMMISSION EXPENSE AND PAYABLE using BAE.BAE1_CREATE_PARENT_COMM...'
         --BAE.BAE1_CREATE_PARENT_COMM(:prod.cut_off_date,variables.p_line_dep,variables.p_intm_dep,variables.p_item_no);
      ELSIF  upper(p_sql_name) = upper('bae1_create_premiums') THEN
        --'Creating accounting entries for GROSS PREMIUMS using BAE.BAE1_CREATE_PREMIUMS...'
         BAE.BAE1_CREATE_PREMIUMS(p_prod_date,p_line_dep,p_intm_dep,p_item_no);
         p_process := 'true';
      ELSIF  upper(p_sql_name) = upper('bae1_create_prem_rec_gross') THEN
         --'Creating accounting entries for PREMIUMS RECEIVABLE using BAE.BAE1_CREATE_PREM_REC_GROSS...'
         BAE.BAE1_CREATE_PREM_REC_GROSS(p_prod_date,p_line_dep,p_intm_dep,p_item_no);
         p_process := 'true';
      ELSIF  upper(p_sql_name) = upper('bae1_create_other_charges') THEN
         --'Creating accounting entries for OTHER CHARGES using BAE.BAE1_CREATE_OTHER_CHARGES...'
         BAE.BAE1_CREATE_OTHER_CHARGES(p_prod_date,p_line_dep,p_intm_dep,p_item_no);
         p_process := 'true';
      --added by mikel 06.15.2015; SR 4691 Wtax enhancements, BIR demo findings.   
      ELSIF  upper(p_sql_name) = upper('bae1_create_netcomm') THEN
         --'Creating accounting entries for COMMISSION PAYABLE net of WITHHOLDING TAXusing BAE.BAE1_CREATE_NETCOMM...'
         BAE.BAE1_CREATE_NETCOMM(p_prod_date,p_line_dep,p_intm_dep,p_item_no);
         p_process := 'true'; 
      ELSIF  upper(p_sql_name) = upper('bae1_create_wtax') THEN
         --'Creating accounting entries for WITHHOLDING TAX sing BAE.BAE1_CREATE_WTAX...'
         BAE.BAE1_CREATE_WTAX(p_prod_date,p_line_dep,p_intm_dep,p_item_no);
         BAE.BAE1_INSERT_TAXES_WHELD(p_prod_date);
         p_process := 'true';
      --end mikel 06.15.2015;         
      ELSE
         p_process := 'false';
         RAISE unrecognized_sql_name;
      END IF;
      /* 
      ** Check whether the command succeeded or not 
      */ 
      EXCEPTION
        WHEN unrecognized_sql_name THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#Unrecognized variable.sql_name in RUN_SQL_REPORT of GIACB001. Process will be stopped...');
        WHEN OTHERS THEN
            --raise_application_error(-20001,p_msg||'#Geniisys Exception#Error -- process not completed.'); --steven 03.05.2014
            raise_application_error(-20001,p_msg||'#Geniisys Information#No record/s available for batch accounting generation.');
    END; 

    /*   greatest(gipi_polbasic.issue_date, gipi_polbasic.incept_date) <= production_date   **
    **   and policies fully distributed or not                                              */
    PROCEDURE extract_all_policies_2(p_prod_date            IN DATE,
                                     p_exclude_special      IN giac_parameters.param_value_v%type,
                                     p_spoiled_flag            IN GIPI_POLBASIC.pol_flag%type,
                                     p_ri_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_bb_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_fund_cd              IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                     p_bae_line_cd          IN giis_line.line_cd%type,
                                     p_marine_line          IN GIIS_LINE.line_cd%TYPE,
                                     p_marine_subline       IN GIIS_SUBLINE.subline_cd%TYPE,
                                     p_dist_flag            IN GIUW_POL_DIST.dist_flag%type,
                                     p_var_counter_positive IN OUT NUMBER,
                                     p_var_positive         IN VARCHAR2,
                                     p_var_counter_negative IN OUT NUMBER,
                                     p_var_negative         IN VARCHAR2,
                                     p_policies             IN OUT NUMBER) 
    IS 
    var_with_invoice_tag gipi_open_liab.with_invoice_tag % TYPE;

    BEGIN

      IF p_exclude_special = 'N'
      THEN
      /* take up all policies */
          FOR rec IN (  
               SELECT DISTINCT A.POLICY_ID,     
                A.ISS_CD,     
                D.ACCT_BRANCH_CD,
                D.BRANCH_NAME,  
                A.LINE_CD,     
                B.ACCT_LINE_CD, 
                    B.LINE_NAME,    
                A.SUBLINE_CD,   
                C.ACCT_SUBLINE_CD, 
                        C.SUBLINE_NAME, 
                A.ACCT_ENT_DATE, 
                A.SPLD_ACCT_ENT_DATE,
                A.PREM_AMT,     
                A.TSI_AMT,      
                A.BOOKING_MTH,  
                        A.BOOKING_YEAR,
                        A.INCEPT_DATE,  
                        A.EXPIRY_DATE,  
                A.ISSUE_DATE,   
                e.ASSD_NO,
                        A.DIST_FLAG,
                        DECODE( A.ENDT_SEQ_NO, 0,
                            SUBSTR(A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) , 1,37),
                            SUBSTR( A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) ||'-'|| A.ENDT_ISS_CD
                              ||'-'|| TO_CHAR( A.ENDT_YY) ||'-'||TO_CHAR( A.ENDT_SEQ_NO)||'-'||  
                              TO_CHAR( A.RENEW_NO), 1,37)) POLICY_NO
            FROM GIPI_POLBASIC A,
                     GIIS_LINE     B,
                     GIIS_SUBLINE  C,
                     GIAC_BRANCHES D,
                 GIPI_PARLIST  E
                WHERE TRUNC( greatest(A.ISSUE_DATE, A.INCEPT_DATE) ) <= TRUNC(p_prod_date)
                  AND ((A.ACCT_ENT_DATE IS NULL  
                     AND A.POL_FLAG <>  p_spoiled_flag
                     AND A.SPLD_DATE IS NULL)
                   OR (A.POL_FLAG = p_spoiled_flag
                     AND A.SPLD_ACCT_ENT_DATE IS NULL
                     AND A.ACCT_ENT_DATE IS NOT NULL
                     AND A.SPLD_DATE <= p_prod_date))
                  AND A.ISS_CD <> p_ri_iss_cd
                  AND A.LINE_CD <> p_bb_iss_cd
                  AND NVL(A.ENDT_TYPE, 'A') = 'A'
                  AND A.LINE_CD = B.LINE_CD
                  AND A.LINE_CD = C.LINE_CD
                  AND A.SUBLINE_CD = C.SUBLINE_CD
                  AND A.ISS_CD = D.BRANCH_CD
              AND D.GFUN_FUND_CD  = p_fund_cd
              AND A.PAR_ID = E.PAR_ID
             --   AND A.DIST_FLAG IN ('3','4') 
                  AND B.SC_TAG IS NULL
                  AND A.LINE_CD = p_bae_line_cd              -- for COV trial run, delete afterwards
                  AND A.POLICY_ID IN (SELECT POLICY_ID FROM GIPI_COMM_INVOICE)
                ORDER BY A.ACCT_ENT_DATE , D.ACCT_BRANCH_CD, 
                 B.ACCT_LINE_CD,  C.ACCT_SUBLINE_CD  )  
              LOOP

                 IF rec.LINE_CD = p_marine_line
                       AND rec.SUBLINE_CD = p_marine_subline 
                 THEN

                    SELECT NVL(WITH_INVOICE_TAG,'N')
                      INTO var_with_invoice_tag
                  FROM GIPI_OPEN_LIAB
                     WHERE POLICY_ID = rec.policy_id;

                    IF var_with_invoice_tag = 'N' 
                    THEN
                       NULL;
                    ELSE
                       /* commented for the time being 10-01-1999  by janet ang */
                       NULL; 
                       /*
                       if rec.ACCT_ENT_DATE is null 
                           then
                          variables.var_counter_positive := nvl(variables.var_counter_positive,0) + 1;
                          INSERT INTO GIAC_PRODUCTION_EXT 
                                (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                             LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                                 ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                             INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                             POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                     ASSD_NO, BOOKING_YEAR)
                           VALUES (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                                 rec.line_cd, rec.ACCT_LINE_CD,  rec.line_name,          rec.SUBLINE_CD,    
                                 rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                                 rec.INCEPT_DATE,rec.ISSUE_DATE,    rec.BOOKING_MTH,        :prod.cut_off_date,
                                         variables.var_positive,  rec.SPLD_ACCT_ENT_DATE, variables.fund_cd, 
                                 rec.policy_no, rec.assd_no, rec.booking_year);
                       else
                          variables.var_counter_negative := nvl(variables.var_counter_negative,0) + 1;
                          INSERT INTO GIAC_PRODUCTION_EXT
                                  (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                               LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                                   ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                               INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                               POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                       ASSD_NO , booking_year)
                          VALUES (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                                  rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                                  rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                                  rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                                  variables.var_negative,  :prod.cut_off_date,     variables.fund_cd,
                                      rec.policy_no, rec.assd_no, rec.booking_year);
                       end if;
                       */
                    END IF; -- var_with_invoice_tag = 'N' 

                 ELSE
                       IF rec.ACCT_ENT_DATE IS  NULL 
                       THEN
                          IF REC.DIST_FLAG = p_dist_flag 
                          THEN 
                            p_var_counter_positive := nvl(p_var_counter_positive,0) + 1;
                            INSERT INTO GIAC_PRODUCTION_EXT
                                 (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                              LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                                  ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                              INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                              POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                      ASSD_NO, booking_year, expiry_date)
                         VALUES 
                                         (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                                  rec.line_cd,    rec.ACCT_LINE_CD,   rec.line_name,      rec.SUBLINE_CD,   
                                  rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                                  rec.INCEPT_DATE,  rec.ISSUE_DATE,   rec.BOOKING_MTH,    p_prod_date,
                                  p_var_positive,   rec.SPLD_ACCT_ENT_DATE, p_fund_cd,
                                          rec.policy_no, rec.assd_no , rec.booking_year, 
                                          TO_DATE('rec.expiry_date','MM-DD-YYYY'));
                         END IF;
                      else
                          p_var_counter_negative := nvl(p_var_counter_negative,0) + 1;
                      INSERT INTO GIAC_PRODUCTION_EXT
                              (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                           LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                               ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                           INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                           POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                   ASSD_NO, booking_year , expiry_date)
                          VALUES 
                                      (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                               rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                               rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                               rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                               p_var_negative,   p_prod_date,     p_fund_cd,
                               rec.policy_no,  rec.assd_no, rec.booking_year,
                                       TO_DATE('rec.expiry_date','MM-DD-YYYY'));
                      end if;
                 END IF;
              END LOOP;

      p_policies  :=  p_var_counter_positive + p_var_counter_negative;
      ELSIF p_exclude_special = 'Y'
      THEN
          /* do not take up special policies */  
          FOR rec IN (  
               SELECT DISTINCT A.POLICY_ID,     
                A.ISS_CD,     
                D.ACCT_BRANCH_CD,
                D.BRANCH_NAME,  
                A.LINE_CD,     
                B.ACCT_LINE_CD, 
                    B.LINE_NAME,    
                A.SUBLINE_CD,   
                C.ACCT_SUBLINE_CD, 
                        C.SUBLINE_NAME, 
                A.ACCT_ENT_DATE, 
                A.SPLD_ACCT_ENT_DATE,
                A.PREM_AMT,     
                A.TSI_AMT,      
                A.BOOKING_MTH,  
                        A.BOOKING_YEAR,
                        A.INCEPT_DATE,  
                        A.EXPIRY_DATE,  
                A.ISSUE_DATE,   
                e.ASSD_NO,
                        A.DIST_FLAG,
                        DECODE( A.ENDT_SEQ_NO, 0,
                            SUBSTR(A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) , 1,37),
                            SUBSTR( A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) ||'-'|| A.ENDT_ISS_CD
                              ||'-'|| TO_CHAR( A.ENDT_YY) ||'-'||TO_CHAR( A.ENDT_SEQ_NO)||'-'||  
                              TO_CHAR( A.RENEW_NO), 1,37)) POLICY_NO
            FROM GIPI_POLBASIC A,
                     GIIS_LINE     B,
                     GIIS_SUBLINE  C,
                     GIAC_BRANCHES D,
                 GIPI_PARLIST  E
                WHERE TRUNC( greatest(A.ISSUE_DATE, A.INCEPT_DATE) ) <= TRUNC(p_prod_date)
                  AND ((A.ACCT_ENT_DATE IS NULL  
                     AND A.POL_FLAG <>  p_spoiled_flag
                     AND A.SPLD_DATE IS NULL)
                   OR (A.POL_FLAG = p_spoiled_flag
                     AND A.SPLD_ACCT_ENT_DATE IS NULL
                     AND A.ACCT_ENT_DATE IS NOT NULL
                     AND A.SPLD_DATE <= p_prod_date))
                  AND A.ISS_CD <> p_ri_iss_cd
                  AND A.LINE_CD <> p_bb_iss_cd
                  AND NVL(A.ENDT_TYPE, 'A') = 'A'
                  AND A.LINE_CD = B.LINE_CD
                  AND A.LINE_CD = C.LINE_CD
                  AND A.SUBLINE_CD = C.SUBLINE_CD
                  AND A.ISS_CD = D.BRANCH_CD
              AND D.GFUN_FUND_CD  = p_fund_cd
              AND A.PAR_ID = E.PAR_ID
             --   AND A.DIST_FLAG IN ('3','4') 
                  AND B.SC_TAG IS NULL
                  AND A.REG_POLICY_SW = 'Y'                        -- for COV do not include special policies 
                  AND A.LINE_CD = p_bae_line_cd              -- for COV trial run, delete afterwards
                  AND A.POLICY_ID IN (SELECT POLICY_ID FROM GIPI_COMM_INVOICE)
                ORDER BY A.ACCT_ENT_DATE , D.ACCT_BRANCH_CD, 
                 B.ACCT_LINE_CD,  C.ACCT_SUBLINE_CD  )  
              LOOP

                 IF rec.LINE_CD = p_marine_line
                       AND rec.SUBLINE_CD = p_marine_subline 
                 THEN

                    SELECT NVL(WITH_INVOICE_TAG,'N')
                      INTO var_with_invoice_tag
                  FROM GIPI_OPEN_LIAB
                     WHERE POLICY_ID = rec.policy_id;

                    IF var_with_invoice_tag = 'N' 
                    then
                       NULL;
                    ELSE
                       /* commented for the time being 10-01-1999  by janet ang */
                       NULL; 
                       /*
                       if rec.ACCT_ENT_DATE is null 
                           then
                          variables.var_counter_positive := nvl(variables.var_counter_positive,0) + 1;
                          INSERT INTO GIAC_PRODUCTION_EXT 
                                (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                             LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                                 ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                             INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                             POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                     ASSD_NO, BOOKING_YEAR)
                           VALUES (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                                 rec.line_cd, rec.ACCT_LINE_CD,  rec.line_name,          rec.SUBLINE_CD,    
                                 rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                                 rec.INCEPT_DATE,rec.ISSUE_DATE,    rec.BOOKING_MTH,        :prod.cut_off_date,
                                         variables.var_positive,  rec.SPLD_ACCT_ENT_DATE, variables.fund_cd, 
                                 rec.policy_no, rec.assd_no, rec.booking_year);
                       else
                          variables.var_counter_negative := nvl(variables.var_counter_negative,0) + 1;
                          INSERT INTO GIAC_PRODUCTION_EXT
                                  (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                               LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                                   ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                               INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                               POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                       ASSD_NO , booking_year)
                          VALUES (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                                  rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                                  rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                                  rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                                  variables.var_negative,  :prod.cut_off_date,     variables.fund_cd,
                                      rec.policy_no, rec.assd_no, rec.booking_year);
                       end if;
                       */
                    END IF; -- var_with_invoice_tag = 'N' 
                 ELSE
                    IF rec.ACCT_ENT_DATE IS  NULL 
                    THEN
                       IF REC.DIST_FLAG = p_dist_flag 
                       THEN 
                          p_var_counter_positive := nvl(p_var_counter_positive,0) + 1;
                          INSERT INTO GIAC_PRODUCTION_EXT
                             (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                          LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                              ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                          INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                          POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                  ASSD_NO, booking_year, expiry_date)
                        VALUES 
                                     (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                              rec.line_cd,    rec.ACCT_LINE_CD,   rec.line_name,      rec.SUBLINE_CD,   
                              rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                              rec.INCEPT_DATE,  rec.ISSUE_DATE,   rec.BOOKING_MTH,    p_prod_date,
                              p_var_positive,   rec.SPLD_ACCT_ENT_DATE, p_fund_cd,
                                      rec.policy_no, rec.assd_no , rec.booking_year,
                                      TO_DATE('rec.expiry_date','MM-DD-YYYY')
                                      );
                       END IF;
                    ELSE
                      p_var_counter_negative := nvl(p_var_counter_negative,0) + 1;
                        INSERT INTO GIAC_PRODUCTION_EXT
                          (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                       LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                           ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                       INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                       POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                               ASSD_NO, booking_year , expiry_date)
                      VALUES 
                                  (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                           rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                           rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                           rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                           p_var_negative,   p_prod_date,     p_fund_cd,
                           rec.policy_no,  rec.assd_no, rec.booking_year,
                                   TO_DATE('rec.expiry_date','MM-DD-YYYY'));
                    END IF;
                 END IF;
              END LOOP;

      p_policies  :=  p_var_counter_positive + p_var_counter_negative;
      END IF;
    END;
    
    /*   gipi_polbasic.issue_date <= production_date   
||   and policies fully distributed or not         
*/
    PROCEDURE extract_all_policies_1(p_prod_date            IN DATE,
                                     p_exclude_special      IN giac_parameters.param_value_v%type,
                                     p_spoiled_flag            IN GIPI_POLBASIC.pol_flag%type,
                                     p_ri_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_bb_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_fund_cd              IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                     p_bae_line_cd          IN giis_line.line_cd%type,
                                     p_marine_line          IN GIIS_LINE.line_cd%TYPE,
                                     p_marine_subline       IN GIIS_SUBLINE.subline_cd%TYPE,
                                     p_dist_flag            IN GIUW_POL_DIST.dist_flag%type,
                                     p_var_counter_positive IN OUT NUMBER,
                                     p_var_positive         IN VARCHAR2,
                                     p_var_counter_negative IN OUT NUMBER,
                                     p_var_negative         IN VARCHAR2,
                                     p_policies             IN OUT NUMBER)
    IS
      var_with_invoice_tag     gipi_open_liab.with_invoice_tag%TYPE;
    BEGIN

           IF p_exclude_special = 'N'
           THEN
             /* take up all policies */   
             FOR rec IN (  
               SELECT DISTINCT A.POLICY_ID,     
                A.ISS_CD,     
                D.ACCT_BRANCH_CD,
                D.BRANCH_NAME,  
                A.LINE_CD,     
                B.ACCT_LINE_CD, 
                    B.LINE_NAME,    
                A.SUBLINE_CD,   
                C.ACCT_SUBLINE_CD, 
                        C.SUBLINE_NAME, 
                A.ACCT_ENT_DATE, 
                A.SPLD_ACCT_ENT_DATE,
                A.PREM_AMT,     
                A.TSI_AMT,      
                A.BOOKING_MTH,  
                        A.BOOKING_YEAR,
                        A.EXPIRY_DATE,
                        A.INCEPT_DATE,  
                A.ISSUE_DATE,   
                e.ASSD_NO,
                        A.DIST_FLAG,
                        DECODE( A.ENDT_SEQ_NO, 0,
                            SUBSTR(A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) , 1,37),
                            SUBSTR( A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) ||'-'|| A.ENDT_ISS_CD
                              ||'-'|| TO_CHAR( A.ENDT_YY) ||'-'||TO_CHAR( A.ENDT_SEQ_NO)||'-'||  
                              TO_CHAR( A.RENEW_NO), 1,37)) POLICY_NO
            FROM GIPI_POLBASIC A,
                     GIIS_LINE     B,
                     GIIS_SUBLINE  C,
                     GIAC_BRANCHES D,
                 GIPI_PARLIST  E
                WHERE TRUNC(A.ISSUE_DATE) <= TRUNC(p_prod_date)
                  AND ((A.ACCT_ENT_DATE IS NULL  
                     AND A.POL_FLAG <>  p_spoiled_flag
                     AND A.SPLD_DATE IS NULL)
                   OR (A.POL_FLAG = p_spoiled_flag
                     AND A.SPLD_ACCT_ENT_DATE IS NULL
                     AND A.ACCT_ENT_DATE IS NOT NULL
                     AND A.SPLD_DATE <= p_prod_date))
                  AND A.ISS_CD <> p_ri_iss_cd
                  AND A.LINE_CD <> p_bb_iss_cd
                  AND NVL(A.ENDT_TYPE, 'A') = 'A'
                  AND A.LINE_CD = B.LINE_CD
                  AND A.LINE_CD = C.LINE_CD
                  AND A.SUBLINE_CD = C.SUBLINE_CD
                  AND A.ISS_CD = D.BRANCH_CD
              AND D.GFUN_FUND_CD  = p_fund_cd
              AND A.PAR_ID = E.PAR_ID
               -- AND A.DIST_FLAG IN ('3','4') 
                  AND A.LINE_CD = p_bae_line_cd
                  AND B.SC_TAG IS NULL
                  AND A.POLICY_ID IN (SELECT POLICY_ID FROM GIPI_COMM_INVOICE)
                ORDER BY A.ACCT_ENT_DATE , D.ACCT_BRANCH_CD, 
                 B.ACCT_LINE_CD,  C.ACCT_SUBLINE_CD  )  
             LOOP


               IF rec.LINE_CD = p_marine_line
                  AND rec.SUBLINE_CD = p_marine_subline 
               THEN

                  SELECT NVL(WITH_INVOICE_TAG,'N')
                    INTO var_with_invoice_tag
                FROM GIPI_OPEN_LIAB
                   WHERE POLICY_ID = rec.policy_id;

                  IF var_with_invoice_tag = 'N' THEN
                     NULL;
                  ELSE
                     /* commented for the time being 10-01-1999  by janet ang */
                     null; 
                     /*
                 if rec.ACCT_ENT_DATE is null 
                     then
                    variables.var_counter_positive := nvl(variables.var_counter_positive,0) + 1;
                    INSERT INTO GIAC_PRODUCTION_EXT 
                       (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                    LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                        ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                    INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                    POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                            ASSD_NO, BOOKING_YEAR)
                    VALUES (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                        rec.line_cd, rec.ACCT_LINE_CD,  rec.line_name,          rec.SUBLINE_CD,    
                        rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                        rec.INCEPT_DATE,rec.ISSUE_DATE,    rec.BOOKING_MTH,        :prod.cut_off_date,
                            variables.var_positive,  rec.SPLD_ACCT_ENT_DATE, variables.fund_cd, 
                        rec.policy_no, rec.assd_no, rec.booking_year);
                 else
                     variables.var_counter_negative := nvl(variables.var_counter_negative,0) + 1;
                     INSERT INTO GIAC_PRODUCTION_EXT
                         (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                      LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                          ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                      INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                      POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                              ASSD_NO , booking_year)
                     VALUES (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                         rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                         rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                         rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                         variables.var_negative,  :prod.cut_off_date,     variables.fund_cd,
                         rec.policy_no, rec.assd_no, rec.booking_year);
                end if;
                    */
                 END IF;
              ELSE
                     IF rec.ACCT_ENT_DATE IS  NULL 
                     THEN
                        IF REC.DIST_FLAG = p_dist_flag 
                        THEN 
                                   p_var_counter_positive := nvl(p_var_counter_positive,0) + 1;
                        INSERT INTO GIAC_PRODUCTION_EXT
                            (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                            LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                            ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                            INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                            POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                            ASSD_NO, booking_year, expiry_date)
                       VALUES (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                                rec.line_cd,    rec.ACCT_LINE_CD,   rec.line_name,      rec.SUBLINE_CD,   
                                rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                                rec.INCEPT_DATE,  rec.ISSUE_DATE,   rec.BOOKING_MTH,    p_prod_date,
                                p_var_positive,   rec.SPLD_ACCT_ENT_DATE, p_fund_cd,
                            rec.policy_no, rec.assd_no , rec.booking_year,
                            TO_DATE('rec.expiry_date','MM-DD-YYYY')
                            );
                         END IF;
                   ELSE
                       p_var_counter_negative := nvl(p_var_counter_negative,0) + 1;
                       INSERT INTO GIAC_PRODUCTION_EXT
                        (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                        LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                        ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                        INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                        POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                            ASSD_NO, booking_year, expiry_date)
                       VALUES (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                                rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                                rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                                rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                                p_var_negative,   p_prod_date,     p_fund_cd,
                                rec.policy_no,  rec.assd_no, rec.booking_year,
                            TO_DATE('rec.expiry_date','MM-DD-YYYY'));
                   END IF;
              END IF;
            END LOOP;
            p_policies  :=  p_var_counter_positive + p_var_counter_negative;

           ELSIF p_exclude_special = 'Y'
           THEN

             /* exclude special policies */
             FOR rec IN (  
               SELECT DISTINCT A.POLICY_ID,     
                A.ISS_CD,     
                D.ACCT_BRANCH_CD,
                D.BRANCH_NAME,  
                A.LINE_CD,     
                B.ACCT_LINE_CD, 
                    B.LINE_NAME,    
                A.SUBLINE_CD,   
                C.ACCT_SUBLINE_CD, 
                        C.SUBLINE_NAME, 
                A.ACCT_ENT_DATE, 
                A.SPLD_ACCT_ENT_DATE,
                A.PREM_AMT,     
                A.TSI_AMT,      
                A.BOOKING_MTH,  
                        A.BOOKING_YEAR,
                        A.EXPIRY_DATE,
                        A.INCEPT_DATE,  
                A.ISSUE_DATE,   
                e.ASSD_NO,
                        A.DIST_FLAG,
                        DECODE( A.ENDT_SEQ_NO, 0,
                            SUBSTR(A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) , 1,37),
                            SUBSTR( A.LINE_CD ||'-'|| A.SUBLINE_CD||'-'|| A.ISS_CD||'-'||
                              TO_CHAR( A.ISSUE_YY)||'-'|| TO_CHAR( A.POL_SEQ_NO) ||'-'|| A.ENDT_ISS_CD
                              ||'-'|| TO_CHAR( A.ENDT_YY) ||'-'||TO_CHAR( A.ENDT_SEQ_NO)||'-'||  
                              TO_CHAR( A.RENEW_NO), 1,37)) POLICY_NO
            FROM GIPI_POLBASIC A,
                     GIIS_LINE     B,
                     GIIS_SUBLINE  C,
                     GIAC_BRANCHES D,
                 GIPI_PARLIST  E
                WHERE TRUNC(A.ISSUE_DATE) <= TRUNC(p_prod_date)
                  AND ((A.ACCT_ENT_DATE IS NULL  
                     AND A.POL_FLAG <>  p_spoiled_flag
                     AND A.SPLD_DATE IS NULL)
                   OR (A.POL_FLAG = p_spoiled_flag
                     AND A.SPLD_ACCT_ENT_DATE IS NULL
                     AND A.ACCT_ENT_DATE IS NOT NULL
                     AND A.SPLD_DATE <= p_prod_date))
                  AND A.ISS_CD <> p_ri_iss_cd
                  AND A.LINE_CD <> p_bb_iss_cd
                  AND NVL(A.ENDT_TYPE, 'A') = 'A'
                  AND A.LINE_CD = B.LINE_CD
                  AND A.LINE_CD = C.LINE_CD
                  AND A.SUBLINE_CD = C.SUBLINE_CD
                  AND A.ISS_CD = D.BRANCH_CD
              AND D.GFUN_FUND_CD  = p_fund_cd
              AND A.PAR_ID = E.PAR_ID
               -- AND A.DIST_FLAG IN ('3','4') 
                  AND B.SC_TAG IS NULL
                  AND A.LINE_CD = p_bae_line_cd
                  AND A.REG_POLICY_SW = 'Y'
                  AND A.POLICY_ID IN (SELECT POLICY_ID FROM GIPI_COMM_INVOICE)
                ORDER BY A.ACCT_ENT_DATE , D.ACCT_BRANCH_CD, 
                 B.ACCT_LINE_CD,  C.ACCT_SUBLINE_CD  )  
             LOOP


               IF rec.LINE_CD = p_marine_line
                  AND rec.SUBLINE_CD = p_marine_subline 
               THEN

                  SELECT NVL(WITH_INVOICE_TAG,'N')
                    INTO var_with_invoice_tag
                FROM GIPI_OPEN_LIAB
                   WHERE POLICY_ID = rec.policy_id;

                  IF var_with_invoice_tag = 'N' then
                     null;
                  ELSE
                     /* commented for the time being 10-01-1999  by janet ang */
                     null; 
                     /*
                 if rec.ACCT_ENT_DATE is null 
                     then
                    variables.var_counter_positive := nvl(variables.var_counter_positive,0) + 1;
                    INSERT INTO GIAC_PRODUCTION_EXT 
                       (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                    LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                        ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                    INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                    POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                            ASSD_NO, BOOKING_YEAR)
                    VALUES (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                        rec.line_cd, rec.ACCT_LINE_CD,  rec.line_name,          rec.SUBLINE_CD,    
                        rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                        rec.INCEPT_DATE,rec.ISSUE_DATE,    rec.BOOKING_MTH,        :prod.cut_off_date,
                            variables.var_positive,  rec.SPLD_ACCT_ENT_DATE, variables.fund_cd, 
                        rec.policy_no, rec.assd_no, rec.booking_year);
                 else
                     variables.var_counter_negative := nvl(variables.var_counter_negative,0) + 1;
                     INSERT INTO GIAC_PRODUCTION_EXT
                         (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                      LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                          ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                      INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                      POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                              ASSD_NO , booking_year)
                     VALUES (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                         rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                         rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                         rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                         variables.var_negative,  :prod.cut_off_date,     variables.fund_cd,
                         rec.policy_no, rec.assd_no, rec.booking_year);
                end if;
                    */
                 END IF;
              ELSE
                   IF rec.ACCT_ENT_DATE IS  NULL 
                     THEN
                        IF REC.DIST_FLAG = p_dist_flag 
                        THEN 
                                   p_var_counter_positive := nvl(p_var_counter_positive,0) + 1;
                        INSERT INTO GIAC_PRODUCTION_EXT
                            (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                             LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                            ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                            INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                            POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                                ASSD_NO, booking_year, expiry_date)
                           VALUES (rec.policy_id,   rec.iss_cd, rec.acct_branch_cd, rec.branch_name,
                            rec.line_cd,    rec.ACCT_LINE_CD,   rec.line_name,      rec.SUBLINE_CD,   
                            rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT, rec.TSI_AMT,
                            rec.INCEPT_DATE,  rec.ISSUE_DATE,   rec.BOOKING_MTH,    p_prod_date,
                            p_var_positive,   rec.SPLD_ACCT_ENT_DATE, p_fund_cd,
                            rec.policy_no, rec.assd_no , rec.booking_year,
                            TO_DATE('rec.expiry_date','MM-DD-YYYY'));
                         END IF;
                   ELSE
                       p_var_counter_negative := nvl(p_var_counter_negative,0) + 1;
                       INSERT INTO GIAC_PRODUCTION_EXT
                        (POLICY_ID,      ISS_CD,     ACCT_BRANCH_CD,     BRANCH_NAME,
                        LINE_CD,        ACCT_LINE_CD,     LINE_NAME,              SUBLINE_CD,     
                        ACCT_SUBLINE_CD,SUBLINE_NAME,     PREM_AMT,               TSI_AMT,    
                        INCEPT_DATE,     ISSUE_DATE,       BOOKING_MTH,             ACCT_ENT_DATE,
                        POS_NEG_INCLUSION, SPLD_ACCT_ENT_DATE,  FUND_CD,        POLICY_NO, 
                            ASSD_NO, booking_year, expiry_date)
                       VALUES (rec.policy_id,   rec.iss_cd,   rec.acct_branch_cd,   rec.branch_name,
                                rec.line_cd,    rec.ACCT_LINE_CD,     rec.line_name,        rec.SUBLINE_CD,   
                                rec.ACCT_SUBLINE_CD,    rec.subline_name, rec.PREM_AMT,     rec.TSI_AMT,
                                rec.INCEPT_DATE,  rec.ISSUE_DATE,         rec.BOOKING_MTH,  rec.ACCT_ENT_DATE,
                                p_var_negative,   p_prod_date,     p_fund_cd,
                                rec.policy_no,  rec.assd_no, rec.booking_year,
                            TO_DATE('rec.expiry_date','MM-DD-YYYY'));
                   END IF;
              END IF;
            END LOOP;
            p_policies :=  p_var_counter_positive + p_var_counter_negative;
       END IF;
    END;
    
    PROCEDURE CREATE_BATCH_ENTRIES(p_prod_date      IN DATE,
                                   p_module_name    IN VARCHAR2)
    IS
      CURSOR accounts IS
        SELECT  b.item_no           
               ,b.module_id
               ,b.gl_acct_category
               ,b.gl_control_acct
               ,b.gl_sub_acct_1
               ,b.gl_sub_acct_2
               ,b.gl_sub_acct_3
               ,b.gl_sub_acct_4
               ,b.gl_sub_acct_5
               ,b.gl_sub_acct_6
               ,b.gl_sub_acct_7
               ,b.sl_type_cd
               ,b.line_dependency_level
               ,b.intm_type_level
               ,b.ca_treaty_type_level
        FROM giac_modules a,
             giac_module_entries b
        WHERE a.module_id = b.module_id
        AND a.module_name LIKE p_module_name;
      stmt               varchar2(2000);
      
      PRAGMA AUTONOMOUS_TRANSACTION; -- SR-4620 : shan 07.10.2015
      v_exists      BOOLEAN := FALSE;   -- SR-4620 : shan 07.10.2015
    BEGIN
       DELETE FROM giac_batch_entries;
       DELETE FROM giac_bae_error_log;

        FOR ja4 IN accounts LOOP
         bae_insert_batch_entries( TO_CHAR(p_prod_date,'yy'), ja4.module_id
           ,ja4.item_no, ja4.gl_acct_category ,ja4.gl_control_acct ,ja4.gl_sub_acct_1 
           ,ja4.gl_sub_acct_2 ,ja4.gl_sub_acct_3 ,ja4.gl_sub_acct_4 ,ja4.gl_sub_acct_5 
           ,ja4.gl_sub_acct_6 ,ja4.gl_sub_acct_7 ,NVL(ja4.line_dependency_level,0) 
           ,NVL(ja4.intm_type_level,0) ,NVL(ja4.ca_treaty_type_level,0), 'GIAC_PRODUCTION_EXT');
        END LOOP;
      
        BEGIN
            FOR ja1 IN (
            SELECT TO_CHAR(gl_acct_category)||'-'||TO_CHAR(gl_control_acct)||'-'||TO_CHAR(gl_sub_acct_1)||'-'||
                   TO_CHAR(gl_sub_acct_2)||'-'||TO_CHAR(gl_sub_acct_3)||'-'||TO_CHAR(gl_sub_acct_4)||'-'||
                   TO_CHAR(gl_sub_acct_5)||'-'||TO_CHAR(gl_sub_acct_6)||'-'||TO_CHAR(gl_sub_acct_7) gl_acct_id,
                   item_no, rowid
              FROM giac_batch_entries WHERE gl_acct_id IS NULL ) 
             LOOP
                INSERT INTO giac_bae_error_log 
                       (module_name,item_no, line_cd, error_log)
                VALUES (p_module_name,  ja1.item_no, NULL, ja1.gl_acct_id);

                DELETE FROM giac_batch_entries WHERE rowid = ja1.rowid;
                
                IF ja1.gl_acct_id != '0-0-0-0-0-0-0-0-0' THEN  -- SR-4620 : shan 07.10.2015
                    v_exists := TRUE;
                END IF;
            END LOOP ja1;
            
            COMMIT; -- SR-4620 : shan 07.10.2015
        END;
        
        -- SR-4620 : shan 07.10.2015   
        IF v_exists = TRUE THEN 
            raise_application_error (-20001, '#Geniisys Information#There are GL account codes that are not existing in Chart of Accounts. Kindly see list of GLs in GIAC_BAE_ERROR_LOG table.');
        END IF;
    END;
    
    PROCEDURE insert_giac_acctrans(p_prod_date      IN DATE,
                                   p_new_prod_date  IN DATE,
                                   p_fund_cd        IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                   p_tran_class     IN GIAC_ACCTRANS.tran_class%type,
                                   p_tran_flag      IN GIAC_ACCTRANS.tran_flag%type,
                                   p_user_id        IN GIIS_USERS.user_id%type,
                                   p_gacc_tran_id   IN OUT GIAC_ACCTRANS.tran_id%type,
                                   p_msg            IN OUT VARCHAR2)  
    IS
      var_tran_seq_no     giac_acctrans.tran_seq_no%type;
      var_tran_class_no   giac_acctrans.tran_class_no%type;
      var_year            NUMBER;
      var_month                NUMBER;
      var_tran_id         giac_acctrans.tran_id%type := 0;
      var_branch_cd       giac_branches.branch_cd%type;
    BEGIN
      var_year   :=  TO_NUMBER(TO_CHAR(p_prod_date, 'YYYY'));
      var_month  :=  TO_NUMBER(TO_CHAR(p_prod_date, 'MM'));
        BEGIN
          FOR rec IN (
            SELECT DISTINCT ISS_CD
              FROM GIAC_PRODUCTION_EXT          ) 
          LOOP
             var_branch_cd  := rec.iss_cd;
             BEGIN
               
                SELECT distinct(tran_id)
              INTO var_tran_id
              FROM giac_acctrans
             WHERE gfun_fund_cd   = p_fund_cd
                   AND gibr_branch_cd = rec.iss_cd
                   AND tran_year      = var_year
               AND tran_month     = var_month
               AND tran_class     = p_tran_class
                   AND TRAN_FLAG      = p_tran_flag
                   AND TO_CHAR(TRAN_DATE,'DD-MON-YY') = TO_CHAR(nvl(p_new_prod_date,p_prod_date),'DD-MON-YY');


             EXCEPTION 
                WHEN NO_DATA_FOUND 
                THEN
               BEGIN

                  SELECT acctran_tran_id_s.nextval
                    INTO p_gacc_tran_id 
                    FROM DUAL;


                  var_tran_seq_no := GIAC_SEQUENCE_GENERATION(p_fund_cd,
                                      rec.iss_cd,
                                      'TRAN_SEQ_NO',
                                      var_year,
                                      var_month);

                  var_tran_class_no := GIAC_SEQUENCE_GENERATION(p_fund_cd,
                                      rec.iss_cd,
                                      p_tran_class,
                                      var_year,
                                      0 );
                  INSERT INTO giac_acctrans(TRAN_ID  , GFUN_FUND_CD, GIBR_BRANCH_CD,  
                              TRAN_YEAR, TRAN_MONTH,   TRAN_SEQ_NO   ,
                              TRAN_DATE, TRAN_FLAG   , TRAN_CLASS    ,
                              TRAN_CLASS_NO  , USER_ID , LAST_UPDATE ,PARTICULARS)
                  VALUES(p_gacc_tran_id  , p_fund_cd, rec.iss_cd,
                         var_year  ,  var_month,  var_tran_seq_no , 
                         NVL(p_new_prod_date,p_prod_date), p_tran_flag    , p_tran_class    ,
                         var_tran_class_no , giis_users_pkg.app_user, SYSDATE, 
                             'Production take up of Direct Business for the month of '|| TO_CHAR(p_prod_date,'fmMonth yyyy'));
                   
               END;
               WHEN TOO_MANY_ROWS THEN
                raise_application_error(-20001,p_msg||'#Geniisys Exception#TOO MANY ROWS.');
            END;
          END LOOP;

          --Updating GIPI_COMM_INVOICE... setting gacc_tran_id
          UPDATE gipi_comm_invoice
             SET gacc_tran_id = NVL(p_gacc_tran_id, var_tran_id)
           WHERE policy_id in (SELECT policy_id From giac_production_ext);

          --Updating GIAC_PARENT_COMM_INVOICE... setting gacc_tran_id 
          UPDATE giac_parent_comm_invoice
             SET tran_id = NVL(p_gacc_tran_id, var_tran_id)
           WHERE iss_Cd ||'-'||TO_CHAR(prem_seq_no) IN (SELECT iss_cd||'-'||TO_CHAR(prem_seq_no)
                                                          FROM giac_production_tax_ext);

          --Updating GIAC_PARENT_COMM_INVPRL... setting gacc_tran_id
          UPDATE giac_parent_comm_invprl
             SET tran_id = NVL(p_gacc_tran_id, var_tran_id)
           WHERE iss_Cd ||'-'||TO_CHAR(prem_seq_no) IN (SELECT iss_cd||'-'||TO_CHAR(prem_seq_no)
                                                          FROM giac_production_tax_ext);
        END;
    END;
    
    PROCEDURE bae_taxes_payable(p_prem_rec_gross_tag      IN GIAC_PARAMETERS.param_value_v%type,
                                p_tax_dr_cd_tag           IN VARCHAR2,
                                p_var_positive            IN VARCHAR2,
                                p_var_negative            IN VARCHAR2,
                                p_fund_cd                 IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                p_prod_date               IN DATE,
                                p_new_prod_date           IN DATE,
                                p_user_id                 IN GIIS_USERS.user_id%type,
                                p_tran_class              IN GIAC_ACCTRANS.tran_class%type,
                                p_tran_flag               IN GIAC_ACCTRANS.tran_flag%type,
                                p_var_count_row           IN OUT NUMBER, 
                                p_row_counter             IN OUT NUMBER,
                                p_gacc_tran_id            IN OUT GIAC_ACCTRANS.tran_id%type,
                                p_msg                     IN OUT VARCHAR2)
    IS
    var_gl_acct_category       giac_acct_entries.gl_acct_category%type;
    var_gl_control_acct     giac_acct_entries.gl_control_acct%type;
    var_gl_acct_id             giac_acct_entries.gl_acct_id%type;
    var_gl_sub_acct_1       giac_acct_entries.gl_sub_acct_1%type;
    var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
    var_gl_sub_acct_3       giac_acct_entries.gl_sub_acct_3%type;
    var_gl_sub_acct_4       giac_acct_entries.gl_sub_acct_4%type;
    var_gl_sub_acct_5       giac_acct_entries.gl_sub_acct_5%type;
    var_gl_sub_acct_6       giac_acct_entries.gl_sub_acct_6%type;
    var_gl_sub_acct_7       giac_acct_entries.gl_sub_acct_7%type;
    var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;

    var_credit_amt            giac_acct_entries.credit_amt%type;
    var_debit_amt            giac_acct_entries.debit_amt%type;
    var_sl_cd               giac_acct_entries.sl_cd%type;
    var_branch_cd              giac_acct_entries.gacc_gibr_branch_cd%type;
    var_tax_amt                gipi_inv_tax.tax_amt%type;
    var_sl_type_cd          giac_acct_entries.sl_type_cd%type;
    var_sl_source_cd        giac_acct_entries.sl_source_cd%type;

    BEGIN
       IF NVL(p_prem_rec_gross_tag,'Y') = 'N' THEN
          /* processing of taxes is not batched for this company */
          NULL;  
       ELSE  
        Var_dr_cr_tag := p_tax_dr_cd_tag;    --'C';

        FOR rec1 IN
           (SELECT acct_branch_cd, 
                   tax_cd, 
                   SUM(tax_amt * currency_rt) tax_amt, 
                   pos_neg_inclusion
              FROM giac_production_tax_ext
             GROUP BY acct_branch_cd, tax_cd, pos_neg_inclusion)
        LOOP    

            var_tax_amt := nvl(REC1.tax_amt,0) ;

            IF rec1.pos_neg_inclusion = p_var_positive 
            THEN
              GET_DRCR_AMT(var_dr_cr_tag, var_tax_amt, var_credit_amt, var_debit_amt);    
            ELSIF rec1.pos_neg_inclusion = p_var_negative 
            THEN
              GET_DRCR_AMT(var_dr_cr_tag, var_tax_amt, var_debit_amt, var_credit_amt);    
            END IF;

           --var_sl_cd := REC1.tax_cd;
           var_branch_cd  := rec1.acct_branch_cd;

            BEGIN
            FOR rec2 IN (
                SELECT  gl_acct_category   ,  gl_control_acct   ,
                gl_sub_acct_1      ,  gl_sub_acct_2     ,
                gl_sub_acct_3      ,  gl_sub_acct_4     ,
                gl_sub_acct_5      ,  gl_sub_acct_6     ,
                gl_sub_acct_7      ,  gl_acct_id
                FROM giac_taxes
                    WHERE fund_cd = p_fund_cd
                       AND tax_cd = REC1.tax_cd) 
                     LOOP
                        var_gl_acct_category  :=  rec2.gl_acct_category;  
                        var_gl_control_acct   :=  rec2.gl_control_acct;
                        var_gl_sub_acct_1     :=  rec2.gl_sub_acct_1;
                        var_gl_sub_acct_2     :=  rec2.gl_sub_acct_2;
                        var_gl_sub_acct_3     :=  rec2.gl_sub_acct_3;
                        var_gl_sub_acct_4     :=  rec2.gl_sub_acct_4;
                        var_gl_sub_acct_5     :=  rec2.gl_sub_acct_5;
                        var_gl_sub_acct_6     :=  rec2.gl_sub_acct_6;
                        var_gl_sub_acct_7     :=  rec2.gl_sub_acct_7;
                        var_gl_acct_id        :=  rec2.gl_acct_id;
                        EXIT;
                     END LOOP;
             END;
             
            IF var_gl_acct_category  IS NULL 
            THEN
                raise_application_error(-20001,p_msg||'#Geniisys Exception#No data in giac module entries for taxes...');
            ELSE
            
                GIACB001_PKG.bae_insert_update_acct_entries(var_gl_acct_category, var_gl_control_acct  ,
                                               var_gl_sub_acct_1   , var_gl_sub_acct_2    ,
                                               var_gl_sub_acct_3   , var_gl_sub_acct_4    ,
                                               var_gl_sub_acct_5   , var_gl_sub_acct_6    ,
                                               var_gl_sub_acct_7   , var_sl_cd            ,
                                               var_gl_acct_id      , var_branch_cd        ,
                                               var_credit_amt      , var_debit_amt        ,
                                               var_sl_type_cd      , var_sl_source_cd,
                                               p_prod_date,          p_new_prod_date,
                                               p_user_id,            p_fund_cd,
                                               p_tran_class,         p_tran_flag,
                                               p_var_count_row,      p_row_counter,
                                               p_gacc_tran_id,       p_msg);         
            END IF;
        END LOOP;
      END IF;
    END;
    
    /*****************************************************************************
    *                                                                            *
    * This procedure determines whether the records will be updated or inserted  *
    * in GIAC_ACCT_ENTRIES.                                                      *
    *                                                                            *
    *****************************************************************************/

    PROCEDURE bae_insert_update_acct_entries(iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                                             iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                                             iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                             iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                             iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                             iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                             iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                             iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                             iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                             iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                                             iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE, 
                                             iuae_acct_branch_cd    GIAC_branches.acct_branch_cd%type,
                                             iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%type,
                                             iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%type,
                                             iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type,
                                             iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%type,  
                                             p_prod_date         IN DATE,
                                             p_new_prod_date     IN DATE,
                                             p_user_id             IN GIIS_USERS.user_id%type,
                                             p_fund_cd             IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                             p_tran_class         IN GIAC_ACCTRANS.tran_class%type,
                                             p_tran_flag         IN GIAC_ACCTRANS.tran_flag%type,
                                             p_var_count_row     IN OUT NUMBER, 
                                             p_row_counter         IN OUT NUMBER,
                                             p_gacc_tran_id         IN OUT GIAC_ACCTRANS.tran_id%type,
                                             p_msg               IN OUT VARCHAR2) 
    IS
          
      iuae_acct_entry_id           GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;
      var_branch_cd             GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%type;

    BEGIN
        BEGIN
            SELECT branch_cd
            INTO var_branch_cd
            FROM giac_branches
            WHERE acct_branch_cd = iuae_acct_branch_cd 
              AND gfun_fund_cd   = p_fund_cd;
        END;
        
        BEGIN
        SELECT TRAN_ID
          INTO p_gacc_tran_id
          FROM giac_acctrans
          WHERE tran_class = p_tran_class
          AND GFUN_FUND_CD  = p_fund_Cd
          AND GIBR_BRANCH_CD = var_branch_cd
          AND TO_CHAR(TRAN_DATE,'DD-MON-YYYY') = TO_CHAR(NVL(p_new_prod_date,p_prod_date),'DD-MON-YYYY')
          AND TRAN_FLAG = p_tran_flag;


        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_msg := p_msg||'#No record found in giac_acctrans for branch '||var_branch_cd||'.';
        END;
        
        BEGIN
          p_var_count_row   := NVL(p_var_count_row,0)   + 1;
          p_row_counter := p_var_count_row;

            iuae_acct_entry_id  := p_var_count_row;
            INSERT INTO GIAC_temp_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                               gacc_gibr_branch_cd, acct_entry_id    ,
                                               gl_acct_id         , gl_acct_category ,
                                               gl_control_acct    , gl_sub_acct_1    ,
                                               gl_sub_acct_2      , gl_sub_acct_3    ,
                                               gl_sub_acct_4      , gl_sub_acct_5    ,
                                               gl_sub_acct_6      , gl_sub_acct_7    ,
                                               sl_cd              , debit_amt        ,
                                               credit_amt         , user_id          ,
                                               last_update        , sl_type_cd       ,
                                               sl_source_cd        )
               VALUES (p_gacc_tran_id                 , p_fund_cd,
                       var_branch_cd                 , iuae_acct_entry_id          ,
                       iuae_gl_acct_id               , iuae_gl_acct_category       ,
                       iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                       iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                       iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                       iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                       iuae_sl_cd                    , NVL(iuae_debit_amt,0)       ,
                       NVL(iuae_credit_amt,0)        , giis_users_pkg.app_user                  ,
                       SYSDATE                       , iuae_sl_type_cd             ,
                       iuae_sl_source_cd);

        END;
    END;
    
    PROCEDURE bae1_create_comm_expense(p_prod_date          IN DATE,
                                       p_new_prod_date      IN OUT DATE,
                                       p_process            IN OUT VARCHAR2,
                                       p_msg                IN OUT VARCHAR2,
                                       p_module_item_no_CE  IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                       p_module_name        IN OUT GIAC_MODULES.module_name%type,
                                       p_gen_home           IN OUT GIAC_PARAMETERS.param_value_v%type,
                                       p_folder             IN OUT VARCHAR2,
                                       p_sql_name           IN OUT VARCHAR2,
                                       p_line_dep           IN OUT giac_module_entries.line_dependency_level%type,
                                       p_intm_dep           IN OUT giac_module_entries.intm_type_level%type,
                                       p_ca_dep             IN OUT giac_module_entries.ca_treaty_type_level%type,
                                       p_item_no            IN OUT giac_module_entries.item_no%type)
    IS

      path                          VARCHAR2(100);
      var_gl_acct_category       giac_module_entries.gl_acct_category%type;
      var_gl_control_acct         giac_module_entries.gl_control_acct%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_intm_type_level         giac_module_entries.intm_type_level%type;
      var_line_dependency_level      giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level     giac_module_entries.old_new_acct_level%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
      var_ca_treaty_type_level      giac_module_entries.ca_treaty_type_level%type;


      var_acct_line_cd            giis_line.acct_line_cd%type;
      var_gslt_sl_type_cd        giac_chart_of_accts.gslt_sl_type_cd%type;
      var_gl_acct_id          giac_chart_of_accts.gl_acct_id%type;

    BEGIN
      BAE_GET_MODULE_PARAMETERS
           (p_module_item_no_CE,p_module_name     ,
            var_gl_acct_category      ,var_gl_control_acct       ,
            var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
            var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
            var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
            var_gl_sub_acct_7         ,var_intm_type_level       ,
            var_ca_treaty_type_level  ,var_line_dependency_level ,
            var_old_new_acct_level    ,var_dr_cr_tag             );

      IF var_gl_acct_category IS NOT NULL THEN
        path    := '  @'||p_gen_home||p_folder||'bae1_create_comm.sql';
        p_sql_name := UPPER('bae1_create_comm');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_CE;

        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);

        path    := '  @'||p_gen_home||p_folder||'bae1_create_parent_comm.sql';
        p_sql_name := UPPER('bae1_create_parent_comm');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_CE;

        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);

        p_sql_name := NULL;
        p_line_dep := NULL;
        p_intm_dep := NULL;
        p_ca_dep   := NULL;
        p_item_no  := NULL;

      END IF;
    END;

    PROCEDURE bae1_create_comm_payable(p_prod_date          IN DATE,
                                       p_new_prod_date      IN OUT DATE,
                                       p_process            IN OUT VARCHAR2,
                                       p_msg                IN OUT VARCHAR2,
                                       p_module_item_no_CP  IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                       p_module_name        IN OUT GIAC_MODULES.module_name%type,
                                       p_gen_home           IN OUT GIAC_PARAMETERS.param_value_v%type,
                                       p_folder             IN OUT VARCHAR2,
                                       p_sql_name           IN OUT VARCHAR2,
                                       p_line_dep           IN OUT giac_module_entries.line_dependency_level%type,
                                       p_intm_dep           IN OUT giac_module_entries.intm_type_level%type,
                                       p_ca_dep             IN OUT giac_module_entries.ca_treaty_type_level%type,
                                       p_item_no            IN OUT giac_module_entries.item_no%type)
    IS

      path                          VARCHAR2(100);
      var_gl_acct_category       giac_module_entries.gl_acct_category%type;
      var_gl_control_acct         giac_module_entries.gl_control_acct%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_intm_type_level         giac_module_entries.intm_type_level%type;
      var_line_dependency_level      giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level     giac_module_entries.old_new_acct_level%type;
      var_ca_treaty_type_level     giac_module_entries.ca_treaty_type_level%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
      
      v_param_val   GIAC_PARAMETERS.param_value_v%TYPE := Giacp.v('ENTER_PREPAID_COMM'); --jason 10/9/2008
        

    BEGIN
      BAE_GET_MODULE_PARAMETERS
           (p_module_item_no_CP,p_module_name     ,
            var_gl_acct_category      ,var_gl_control_acct       ,
            var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
            var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
            var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
            var_gl_sub_acct_7         ,var_intm_type_level       ,
            var_ca_treaty_type_level  ,var_line_dependency_level ,
            var_old_new_acct_level    ,var_dr_cr_tag             );

      if var_gl_acct_category is not null then
        path    := '  @'||p_gen_home||p_folder||'bae1_create_comm.sql';
        p_sql_name := UPPER('bae1_create_comm');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_CP;

        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);
        
        
        --jason 10/9/2008: for generation of prepaid commissions
        IF v_param_val = 'Y' THEN
          FOR j IN (SELECT a.item_no, nvl(a.line_dependency_level,0) line_dep, NVL(a.intm_type_level,0) intm_dep
                        FROM GIAC_MODULE_ENTRIES a, GIAC_MODULES b
                         WHERE a.module_id = b.module_id
                           AND b.module_name = 'GIACB001'
                               AND a.item_no IN (11,12))
            LOOP
            p_line_dep := j.line_dep;
            p_intm_dep := j.intm_dep;
            p_item_no  := j.item_no;
          
            RUN_SQL_REPORT(path,
                           p_prod_date,
                           p_new_prod_date,
                           p_sql_name,
                           p_line_dep,
                           p_intm_dep,
                           p_item_no,
                           p_process,
                           p_msg);
            END LOOP;
        END IF;    
        --jason: end of modification


        path    := '  @'||p_gen_home||p_folder||'bae1_create_parent_comm.sql';
        p_sql_name := UPPER('bae1_create_parent_comm');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_CP;


        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);
        p_sql_name := NULL;
        p_line_dep := NULL;
        p_intm_dep := NULL;
        p_ca_dep   := NULL;
        p_item_no  := NULL;
      END IF;
    END;
    
    PROCEDURE bae1_create_gross_prem(p_prod_date            IN DATE,
                                     p_new_prod_date        IN OUT DATE,
                                     p_process                IN OUT VARCHAR2,
                                     p_msg                    IN OUT VARCHAR2,
                                     p_module_item_no_GP    IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                     p_module_name            IN OUT GIAC_MODULES.module_name%type,
                                     p_gen_home                IN OUT GIAC_PARAMETERS.param_value_v%type,
                                     p_folder                IN OUT VARCHAR2,
                                     p_sql_name                IN OUT VARCHAR2,
                                     p_line_dep                IN OUT giac_module_entries.line_dependency_level%type,
                                     p_intm_dep                IN OUT giac_module_entries.intm_type_level%type,
                                     p_ca_dep                IN OUT giac_module_entries.ca_treaty_type_level%type,
                                     p_item_no                IN OUT giac_module_entries.item_no%type)
    IS

      path                          VARCHAR2(100);
      var_gl_acct_category       giac_module_entries.gl_acct_category%type;
      var_gl_control_acct         giac_module_entries.gl_control_acct%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_intm_type_level         giac_module_entries.intm_type_level%type;
      var_line_dependency_level      giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level     giac_module_entries.old_new_acct_level%type;
      var_ca_treaty_type_level     giac_module_entries.ca_treaty_type_level%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
    BEGIN
      BAE_GET_MODULE_PARAMETERS
           (p_module_item_no_GP, p_module_name     ,
            var_gl_acct_category      ,var_gl_control_acct       ,
            var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
            var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
            var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
            var_gl_sub_acct_7         ,var_intm_type_level       ,
            var_ca_treaty_type_level  ,var_line_dependency_level ,
            var_old_new_acct_level    ,var_dr_cr_tag             );

      IF var_gl_acct_category IS NOT NULL THEN
        path    := '  @'||p_gen_home||p_folder||'bae1_create_premiums.sql';
        p_sql_name := UPPER('bae1_create_premiums');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_GP;

        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);
        p_sql_name := NULL;
        p_line_dep := NULL;
        p_intm_dep := NULL;
        p_ca_dep   := NULL;
        p_item_no  := NULL;
      END IF;
    END;

    PROCEDURE bae1_create_prem_rec(p_prod_date            IN DATE,
                                   p_prem_rec_gross_tag IN GIAC_PARAMETERS.param_value_v%type,
                                   p_new_prod_date        IN OUT DATE,
                                   p_process            IN OUT VARCHAR2,
                                   p_msg                IN OUT VARCHAR2,
                                   p_module_item_no_PR1    IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                   p_module_item_no_PR2 IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                   p_module_item_no_OCI IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                   p_module_name        IN OUT GIAC_MODULES.module_name%type,
                                   p_gen_home            IN OUT GIAC_PARAMETERS.param_value_v%type,
                                   p_folder                IN OUT VARCHAR2,
                                   p_sql_name            IN OUT VARCHAR2,
                                   p_line_dep            IN OUT giac_module_entries.line_dependency_level%type,
                                   p_intm_dep            IN OUT giac_module_entries.intm_type_level%type,
                                   p_ca_dep                IN OUT giac_module_entries.ca_treaty_type_level%type,
                                   p_item_no            IN OUT giac_module_entries.item_no%type)
    IS

      path                          VARCHAR2(100);
      var_gl_acct_category       giac_module_entries.gl_acct_category%type;
      var_gl_control_acct         giac_module_entries.gl_control_acct%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_intm_type_level         giac_module_entries.intm_type_level%type;
      var_line_dependency_level      giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level     giac_module_entries.old_new_acct_level%type;
      var_ca_treaty_type_level     giac_module_entries.ca_treaty_type_level%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
    BEGIN
       IF p_prem_rec_gross_tag = 'Y' THEN
          /* take up of premiums receivable is premium_amt + tax_amt + other_charges + notarial_fee */
          BAE_GET_MODULE_PARAMETERS
             (p_module_item_no_pr1, p_module_name  ,
              var_gl_acct_category      ,var_gl_control_acct       ,
              var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
              var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
              var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
              var_gl_sub_acct_7         ,var_intm_type_level       ,
              var_ca_treaty_type_level  ,var_line_dependency_level ,
              var_old_new_acct_level    ,var_dr_cr_tag             );

          p_item_no  := p_module_item_no_PR1;
          path    := '  @'||p_gen_home||p_folder||'bae1_create_prem_rec_gross.sql';

          IF var_gl_acct_category is not null THEN
             p_sql_name := upper('bae1_create_prem_rec_gross');
             p_line_dep := nvl(var_line_dependency_level,0);
             p_intm_dep := nvl(var_intm_type_level,0);
             p_ca_dep   := nvl(var_ca_treaty_type_level,0);
      
             RUN_SQL_REPORT(path,
                            p_prod_date,
                            p_new_prod_date,
                            p_sql_name,
                            p_line_dep,
                            p_intm_dep,
                            p_item_no,
                            p_process,
                            p_msg);
             p_sql_name := null;
             p_line_dep := null;
             p_intm_dep := null;
             p_ca_dep   := null;
             p_item_no  := null;

             /* this is for other charges and notarial fee*/
             BAE_GET_MODULE_PARAMETERS
                (p_module_item_no_OCI, p_module_name  ,
             var_gl_acct_category      ,var_gl_control_acct       ,
             var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
             var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
             var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
             var_gl_sub_acct_7         ,var_intm_type_level       ,
                 var_ca_treaty_type_level  ,var_line_dependency_level ,
             var_old_new_acct_level    ,var_dr_cr_tag             );

             IF var_gl_acct_category is not null THEN
                path    := '  @'||p_gen_home||p_folder||'bae1_create_other_charges.sql';
                p_sql_name := upper('bae1_create_other_charges');
                p_line_dep := nvl(var_line_dependency_level,0);
                p_intm_dep := nvl(var_intm_type_level,0);
                p_ca_dep   := nvl(var_ca_treaty_type_level,0);
                p_item_no  := p_module_item_no_OCI;
      
                RUN_SQL_REPORT(path,
                               p_prod_date,
                               p_new_prod_date,
                               p_sql_name,
                               p_line_dep,
                               p_intm_dep,
                               p_item_no,
                               p_process,
                               p_msg);
                p_sql_name := null;
                p_line_dep := null;
                p_intm_dep := null;
                p_ca_dep   := null;
                p_item_no  := null;
             END IF;
          END IF;

       ELSIF p_prem_rec_gross_tag = 'N' THEN
          /* take up of premiums receivable is premium_amt only */
          BAE_GET_MODULE_PARAMETERS
             (p_module_item_no_pr2, p_module_name  ,
              var_gl_acct_category      ,var_gl_control_acct       ,
              var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
              var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
              var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
              var_gl_sub_acct_7         ,var_intm_type_level       ,
              var_ca_treaty_type_level  ,var_line_dependency_level ,
              var_old_new_acct_level    ,var_dr_cr_tag             );

           p_item_no  := p_module_item_no_PR2;
           path    := '  @'||p_gen_home||p_folder||'bae1_create_premiums.sql';

           IF var_gl_acct_category IS NOT NULL THEN
              p_sql_name := 'bae1_create_premiums';
              p_line_dep := nvl(var_line_dependency_level,0);
              p_intm_dep := nvl(var_intm_type_level,0);
              p_ca_dep   := nvl(var_ca_treaty_type_level,0);
      
              RUN_SQL_REPORT(path,
                             p_prod_date,
                             p_new_prod_date,
                             p_sql_name,
                             p_line_dep,
                             p_intm_dep,
                             p_item_no,
                             p_process,
                             p_msg);
              p_sql_name := NULL;
              p_line_dep := NULL;
              p_intm_dep := NULL;
              p_ca_dep   := NULL;
              p_item_no  := NULL;
           END IF;
       END IF;

    END;

    --added by mikel 06.15.2015; SR 4691 Wtax enhancements, BIR demo findings.    
    PROCEDURE bae1_create_netcomm_payable (p_prod_date          IN DATE,
                                           p_new_prod_date      IN OUT DATE,
                                           p_process            IN OUT VARCHAR2,
                                           p_msg                IN OUT VARCHAR2,
                                           p_module_item_no_CP  IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                           p_module_name        IN OUT GIAC_MODULES.module_name%type,
                                           p_gen_home           IN OUT GIAC_PARAMETERS.param_value_v%type,
                                           p_folder             IN OUT VARCHAR2,
                                           p_sql_name           IN OUT VARCHAR2,
                                           p_line_dep           IN OUT giac_module_entries.line_dependency_level%type,
                                           p_intm_dep           IN OUT giac_module_entries.intm_type_level%type,
                                           p_ca_dep             IN OUT giac_module_entries.ca_treaty_type_level%type,
                                           p_item_no            IN OUT giac_module_entries.item_no%type)
    IS

      path                          VARCHAR2(100);
      var_gl_acct_category       giac_module_entries.gl_acct_category%type;
      var_gl_control_acct         giac_module_entries.gl_control_acct%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_intm_type_level         giac_module_entries.intm_type_level%type;
      var_line_dependency_level      giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level     giac_module_entries.old_new_acct_level%type;
      var_ca_treaty_type_level     giac_module_entries.ca_treaty_type_level%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
      
      v_param_val   GIAC_PARAMETERS.param_value_v%TYPE := Giacp.v('ENTER_PREPAID_COMM');
        

    BEGIN
      BAE_GET_MODULE_PARAMETERS
           (p_module_item_no_CP,p_module_name     ,
            var_gl_acct_category      ,var_gl_control_acct       ,
            var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
            var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
            var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
            var_gl_sub_acct_7         ,var_intm_type_level       ,
            var_ca_treaty_type_level  ,var_line_dependency_level ,
            var_old_new_acct_level    ,var_dr_cr_tag             );

      if var_gl_acct_category is not null then
        path    := '  @'||p_gen_home||p_folder||'bae1_create_netcomm.sql';
        p_sql_name := UPPER('bae1_create_netcomm');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_CP;

        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);
        
        
        --for generation of prepaid commissions
        IF v_param_val = 'Y' THEN
          FOR j IN (SELECT a.item_no, nvl(a.line_dependency_level,0) line_dep, NVL(a.intm_type_level,0) intm_dep
                        FROM GIAC_MODULE_ENTRIES a, GIAC_MODULES b
                         WHERE a.module_id = b.module_id
                           AND b.module_name = 'GIACB001'
                               AND a.item_no IN (11,12))
            LOOP
            p_line_dep := j.line_dep;
            p_intm_dep := j.intm_dep;
            p_item_no  := j.item_no;
          
            RUN_SQL_REPORT(path,
                           p_prod_date,
                           p_new_prod_date,
                           p_sql_name,
                           p_line_dep,
                           p_intm_dep,
                           p_item_no,
                           p_process,
                           p_msg);
            END LOOP;
        END IF;    

        path    := '  @'||p_gen_home||p_folder||'bae1_create_parent_comm.sql';
        p_sql_name := UPPER('bae1_create_parent_comm');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := p_module_item_no_CP;


        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);
        p_sql_name := NULL;
        p_line_dep := NULL;
        p_intm_dep := NULL;
        p_ca_dep   := NULL;
        p_item_no  := NULL;
      END IF;
    END;
    
    PROCEDURE bae1_create_wtax (p_prod_date             IN DATE,
                                p_new_prod_date         IN OUT DATE,
                                p_process               IN OUT VARCHAR2,
                                p_msg                   IN OUT VARCHAR2,
                                p_module_name           IN OUT GIAC_MODULES.module_name%type,
                                p_gen_home              IN OUT GIAC_PARAMETERS.param_value_v%type,
                                p_folder                IN OUT VARCHAR2,
                                p_sql_name              IN OUT VARCHAR2,
                                p_line_dep              IN OUT giac_module_entries.line_dependency_level%type,
                                p_intm_dep              IN OUT giac_module_entries.intm_type_level%type,
                                p_ca_dep                IN OUT giac_module_entries.ca_treaty_type_level%type,
                                p_item_no               IN OUT giac_module_entries.item_no%type)
    IS

      path                          VARCHAR2(100);
      var_gl_acct_category       giac_module_entries.gl_acct_category%type;
      var_gl_control_acct         giac_module_entries.gl_control_acct%type;
      var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%type;
      var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%type;
      var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%type;
      var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%type;
      var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%type;
      var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%type;
      var_intm_type_level         giac_module_entries.intm_type_level%type;
      var_line_dependency_level      giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level     giac_module_entries.old_new_acct_level%type;
      var_ca_treaty_type_level     giac_module_entries.ca_treaty_type_level%type;
      var_dr_cr_tag              giac_module_entries.dr_cr_tag%type;
      
      v_param_val   GIAC_PARAMETERS.param_value_v%TYPE := Giacp.v('ENTER_PREPAID_COMM');
        
    BEGIN

        path    := '  @'||p_gen_home||p_folder||'bae1_create_wtax.sql';
        p_sql_name := UPPER('bae1_create_wtax');
        p_line_dep := NVL(var_line_dependency_level,0);
        p_intm_dep := NVL(var_intm_type_level,0);
        p_ca_dep   := NVL(var_ca_treaty_type_level,0);
        p_item_no  := NULL;

        RUN_SQL_REPORT(path,
                       p_prod_date,
                       p_new_prod_date,
                       p_sql_name,
                       p_line_dep,
                       p_intm_dep,
                       p_item_no,
                       p_process,
                       p_msg);              
        
        p_sql_name := NULL;
        p_line_dep := NULL;
        p_intm_dep := NULL;
        p_ca_dep   := NULL;
        p_item_no  := NULL;
    END;
    --end mikel 06.15.2015
    
    PROCEDURE transfer_to_giac_acct_entries 
    IS
    var_counter                NUMBER;
    BEGIN
        --Transferring from GIAC_TEMP_ACCT_ENTRIES to GIAC_ACCT_ENTRIES
      FOR rec IN
       (SELECT gacc_tran_id,      gacc_gfun_fund_cd,      gacc_gibr_branch_cd,
               gl_acct_id,        gl_acct_category,       gl_control_acct,
               gl_sub_acct_1,     gl_sub_acct_2,          gl_sub_acct_3,
               gl_sub_acct_4,     gl_sub_acct_5,          gl_sub_acct_6,
               gl_sub_acct_7,     user_id,                TRUNC(last_update) last_update,
               sl_cd,             SUM(debit_amt) debit_amt,    SUM(credit_amt) credit_amt, 
               generation_type,   remarks,                sl_type_cd,
               sl_source_cd
        FROM giac_temp_acct_entries                      
        GROUP BY gacc_tran_id,    gacc_gfun_fund_cd,      gacc_gibr_branch_cd,
               gl_acct_id,        gl_acct_category,       gl_control_acct,
               gl_sub_acct_1,     gl_sub_acct_2,          gl_sub_acct_3,
               gl_sub_acct_4,     gl_sub_acct_5,          gl_sub_acct_6,
               gl_sub_acct_7,     user_id,                TRUNC(last_update),
               sl_cd,             generation_type,        remarks,        
               sl_type_cd,        sl_source_cd        ) 
       LOOP

       var_counter := NVL(var_counter,0) + 1;
       INSERT INTO giac_acct_entries
        (GACC_TRAN_ID           ,         GACC_GFUN_FUND_CD      ,         
        GACC_GIBR_BRANCH_CD    ,         ACCT_ENTRY_ID          ,         
        GL_ACCT_ID             ,         GL_ACCT_CATEGORY       ,         
        GL_CONTROL_ACCT        ,         GL_SUB_ACCT_1          ,         
        GL_SUB_ACCT_2          ,         GL_SUB_ACCT_3          ,         
        GL_SUB_ACCT_4          ,         GL_SUB_ACCT_5          ,         
        GL_SUB_ACCT_6          ,         GL_SUB_ACCT_7          ,         
        USER_ID                ,         LAST_UPDATE            ,         
        SL_CD                  ,         DEBIT_AMT              ,               
        CREDIT_AMT             ,         GENERATION_TYPE        ,                
        REMARKS                ,         SL_TYPE_CD             ,                
        SL_SOURCE_CD           )               
       VALUES
        (rec.GACC_TRAN_ID          ,         rec.GACC_GFUN_FUND_CD      ,         
        rec.GACC_GIBR_BRANCH_CD    ,         var_counter                ,
        rec.GL_ACCT_ID             ,         rec.GL_ACCT_CATEGORY       ,         
        rec.GL_CONTROL_ACCT        ,         rec.GL_SUB_ACCT_1          ,         
        rec.GL_SUB_ACCT_2          ,         rec.GL_SUB_ACCT_3          ,         
        rec.GL_SUB_ACCT_4          ,         rec.GL_SUB_ACCT_5          ,         
        rec.GL_SUB_ACCT_6          ,         rec.GL_SUB_ACCT_7          ,         
        rec.USER_ID                ,         rec.LAST_UPDATE            ,         
        rec.SL_CD                  ,         rec.DEBIT_AMT              ,               
        rec.CREDIT_AMT             ,         rec.GENERATION_TYPE        ,                
        rec.REMARKS                ,         rec.SL_TYPE_CD             ,                
        rec.SL_SOURCE_CD           );

      END LOOP;
    END;
    
    PROCEDURE check_debit_credit_amounts(p_prod_date                IN DATE,
                                         p_module_item_no_Inc_adj   IN GIAC_MODULE_ENTRIES.item_no%type,
                                         p_module_item_no_Exp_adj   IN GIAC_MODULE_ENTRIES.item_no%type,
                                         p_module_name                IN GIAC_MODULES.module_name%type,
                                         p_fund_Cd                    IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                         p_user_id                    IN GIIS_USERS.user_id%type,
                                         p_balance                    IN OUT NUMBER)
    IS
        v_debit      giac_acct_entries.debit_amt%type;
        v_credit    giac_acct_entries.credit_amt%type;
        v_tot_debit     giac_acct_entries.debit_amt%type;
        v_tot_credit    giac_acct_entries.credit_amt%type;
        v_balance       giac_acct_entries.credit_amt%type;
        v_tran_id       giac_acct_entries.gacc_tran_id%type;
    BEGIN
      select sum(debit_amt) - sum(credit_amt)
        into v_balance
        --from giac_acct_entries ;
        from giac_acct_entries a, giac_acctrans b--giac_temp_acct_entries lina 04102007
       where a.gacc_tran_id = b.tran_id
         and b.tran_class = 'PRD'
         and tran_flag = 'C'
         and tran_date = p_prod_date;
      --if abs(v_balance) > 1 
      /*IF abs(v_balance) != 0 --lina 11/22/2006    
      THEN
        message('Allocating to miscellaenous amount...',no_acknowledge);
      END IF;*/
      
      IF ABS(v_balance) <= 1 
      THEN
         FOR ja1 IN (
              SELECT gacc_tran_id, 
                     gacc_gibr_branch_cd,
                     SUM(debit_amt) debit,
                     SUM(credit_amt) credit, 
                     SUM(debit_amt) - SUM(credit_amt) balance
                FROM giac_acct_entries a, giac_acctrans b--giac_temp_acct_entries lina 04102007
               WHERE a.gacc_tran_id = b.tran_id
                 AND b.tran_class = 'PRD'
                 AND tran_flag = 'C'
                 AND tran_date = p_prod_date
               GROUP BY gacc_tran_id, gacc_gibr_branch_cd) 
         LOOP
            p_balance := 0;
            
            IF ja1.balance != 0  
            THEN
               IF ja1.balance > 0 
               THEN 
                  --:prod.balance := v_balance;
                  p_balance := ja1.balance; --lina 11/22/06 
                  adjust( ja1.gacc_tran_id, p_module_item_no_Inc_adj ,ja1.gacc_gibr_branch_cd, --mikel 10.02.2014; change p_module_item_no_Exp_adj to p_module_item_no_Inc_adj
                         p_module_item_no_Exp_adj, p_module_name,    p_fund_Cd,        
                         p_module_item_no_Inc_adj, giis_users_pkg.app_user,        p_balance);
                 
               ELSIF ja1.balance < 0 
               THEN 
                  --:prod.balance := v_balance;
                  p_balance := ja1.balance; --mikel 10.02.2014 
                  adjust(ja1.gacc_tran_id, p_module_item_no_Exp_adj ,ja1.gacc_gibr_branch_cd,
                         p_module_item_no_Exp_adj, p_module_name,    p_fund_Cd,        
                         p_module_item_no_Inc_adj, giis_users_pkg.app_user,        p_balance);
               END IF;
            END IF;
         END LOOP ja1;
      END IF;
    END;
    
    PROCEDURE ADJUST(v_tran_id                IN giac_acctrans.tran_id%type        ,
                     v_module_item_no         IN giac_module_entries.item_no%type  ,
                     v_branch_cd              IN giac_acctrans.gibr_branch_cd%type,
                     p_module_item_no_Exp_adj IN GIAC_MODULE_ENTRIES.item_no%type,        
                     p_module_name              IN GIAC_MODULES.module_name%type,
                     p_fund_Cd                  IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                     p_module_item_no_Inc_adj IN GIAC_MODULE_ENTRIES.item_no%type,
                     p_user_id                  IN GIIS_USERS.user_id%type,
                     p_balance                  IN NUMBER) 
      IS


      v_entry_id               giac_acct_entries.acct_entry_id%type;
      v_entry_id2              NUMBER(4);
      var_gl_acct_id           giac_chart_of_accts.gl_acct_id%type;
      var_gl_acct_category     giac_chart_of_accts.gl_acct_category%type;
      var_gl_control_acct      giac_chart_of_accts.gl_control_acct%type;
      var_gl_sub_acct_1        giac_chart_of_accts.gl_sub_acct_1%type;
      var_gl_sub_acct_2        giac_chart_of_accts.gl_sub_acct_2%type;
      var_gl_sub_acct_3        giac_chart_of_accts.gl_sub_acct_3%type;
      var_gl_sub_acct_4        giac_chart_of_accts.gl_sub_acct_4%type;
      var_gl_sub_acct_5        giac_chart_of_accts.gl_sub_acct_5%type;
      var_gl_sub_acct_6        giac_chart_of_accts.gl_sub_acct_6%type;
      var_gl_sub_acct_7        giac_chart_of_accts.gl_sub_acct_7%type;
      var_dr_cr_tag            giac_chart_of_accts.dr_cr_tag%type;
      var_credit_amt           giac_acct_entries.credit_amt%type; 
      var_debit_amt            giac_acct_entries.debit_amt%type; 
      var_intm_type_level      giac_module_entries.intm_type_level%type;
      var_ca_treaty_type_level giac_module_entries.ca_treaty_type_level%type;
      var_line_dependency_level giac_module_entries.line_dependency_level%type;
      var_old_new_acct_level   giac_module_entries.old_new_acct_level%type;
      var_sl_type_cd           giac_chart_of_accts.gslt_sl_type_cd%type;

    BEGIN
      SELECT MAX( NVL(acct_entry_id,0)) 
        INTO v_entry_id
        FROM giac_acct_entries--giac_temp_acct_entries lina 04102007
       WHERE gacc_tran_id = v_tran_id;
      
      IF v_module_item_no = p_module_item_no_Exp_adj 
      THEN  
        
         BAE_GET_MODULE_PARAMETERS
            (p_module_item_no_Exp_adj , p_module_name     ,
             var_gl_acct_category      ,var_gl_control_acct       ,
             var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
             var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
             var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
             var_gl_sub_acct_7         ,var_intm_type_level       ,
             var_ca_treaty_type_level  ,var_line_dependency_level ,
             var_old_new_acct_level    ,var_dr_cr_tag             );
         BAE_Check_Chart_Of_Accts( var_gl_acct_category, var_gl_control_acct, 
                                   var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                                   var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                   var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                                   var_gl_sub_acct_7   , var_gl_acct_id     ,
                                   var_sl_type_cd       );
         INSERT INTO giac_acct_entries--giac_temp_acct_entries lina 04102007
              (    gacc_tran_id,            gacc_gfun_fund_cd,    gacc_gibr_branch_cd,
                acct_entry_id,            gl_acct_id,        gl_acct_category,
                gl_control_acct,        gl_sub_acct_1,        gl_sub_acct_2,
                gl_sub_acct_3,            gl_sub_acct_4,        gl_sub_acct_5,
                gl_sub_acct_6,            gl_sub_acct_7,        user_id,
                last_update,            sl_cd,            debit_amt,
                credit_amt,            generation_type,    remarks )        
         VALUES
              ( v_tran_id,              p_fund_Cd,    v_branch_cd,
                v_entry_id + 1,      var_gl_acct_id,    var_gl_acct_category,    
                var_gl_control_acct,  var_gl_sub_acct_1,    var_gl_sub_acct_2,
                var_gl_sub_acct_3,      var_gl_sub_acct_4,    var_gl_sub_acct_5,
                var_gl_sub_acct_6,      var_gl_sub_acct_7,    giis_users_pkg.app_user,
                SYSDATE,              NULL,            ABS(p_balance) ,
                0,                  NULL,    
                'to adjust currency conversion differences during production take up.');

      ELSIF v_module_item_no = p_module_item_no_Inc_adj 
      THEN   

         BAE_GET_MODULE_PARAMETERS
            (p_module_item_no_Inc_adj , p_module_name     ,
             var_gl_acct_category      ,var_gl_control_acct       ,
             var_gl_sub_acct_1         ,var_gl_sub_acct_2         ,
             var_gl_sub_acct_3         ,var_gl_sub_acct_4         ,
             var_gl_sub_acct_5         ,var_gl_sub_acct_6         ,
             var_gl_sub_acct_7         ,var_intm_type_level       ,
             var_ca_treaty_type_level  ,var_line_dependency_level ,
             var_old_new_acct_level    ,var_dr_cr_tag             );

         BAE_Check_Chart_Of_Accts( var_gl_acct_category, var_gl_control_acct, 
                                    var_gl_sub_acct_1   , var_gl_sub_acct_2  ,
                                    var_gl_sub_acct_3   , var_gl_sub_acct_4  ,
                                    var_gl_sub_acct_5   , var_gl_sub_acct_6  ,
                                    var_gl_sub_acct_7   , var_gl_acct_id     ,
                                    var_sl_type_cd       );

          /* INSERTS INTO MISCELLANEOUS UNDERWRITING INCOME */
          INSERT INTO giac_acct_entries--giac_temp_acct_entries lina 04102007
           ( GACC_TRAN_ID ,          GACC_GFUN_FUND_CD,      GACC_GIBR_BRANCH_CD ,  
             ACCT_ENTRY_ID,          GL_ACCT_ID,             GL_ACCT_CATEGORY  , 
             GL_CONTROL_ACCT,        GL_SUB_ACCT_1,          GL_SUB_ACCT_2, 
             GL_SUB_ACCT_3,          GL_SUB_ACCT_4,          GL_SUB_ACCT_5,
             GL_SUB_ACCT_6,          GL_SUB_ACCT_7     ,     USER_ID             ,  
             LAST_UPDATE  ,          SL_CD        ,          DEBIT_AMT         , 
             CREDIT_AMT          ,   GENERATION_TYPE,        REMARKS      )
          VALUES 
           ( v_tran_id,            p_fund_Cd,    v_branch_cd,
             v_entry_id + 1,    var_gl_acct_id,        var_gl_acct_category,    
             var_gl_control_acct,    var_gl_sub_acct_1,    var_gl_sub_acct_2,
             var_gl_sub_acct_3,    var_gl_sub_acct_4,    var_gl_sub_acct_5,
             var_gl_sub_acct_6,    var_gl_sub_acct_7,    giis_users_pkg.app_user,
             SYSDATE,            NULL,            0,
             ABS(p_balance),    NULL,    
             'to adjust currency conversion differences during production take up.');
      END IF;
    END;
    
    /* modified by judyann 04032008
    ** added updates of acct_ent_date/spoiled_acct_ent_date on gipi_invoice
    ** take-up of policy will be by bill number; this is due to the long-term policy enhancement
    */

    PROCEDURE update_polbasic(p_prod_date         IN DATE,
                              p_var_count_row    IN OUT NUMBER)
    IS
      v_tran_id                  giac_acctrans.tran_id%type;
      v_branch_cd                giac_acctrans.gibr_branch_cd%type;

    BEGIN
      p_var_count_row   :=  1;

      DELETE FROM GIAC_POLICY_ID;

      FOR rec IN (
          SELECT policy_id, pos_neg_inclusion, iss_cd, 
                 bill_iss_cd, prem_seq_no
            FROM giac_production_ext      
            --order by iss_cd
            ) 
      LOOP
         p_var_count_row   := nvl(p_var_count_row,0)   + 1;

         INSERT INTO GIAC_POLICY_ID (POLICY_ID, POS_NEG_INCLUSION, ISS_CD, PREM_SEQ_NO)
                             VALUES (rec.policy_id, rec.pos_neg_inclusion, rec.bill_iss_cd, rec.prem_seq_no);
                             
         IF rec.pos_neg_inclusion = 'P' THEN
            UPDATE gipi_polbasic
               SET acct_ent_date = p_prod_date
             WHERE policy_id = rec.policy_id;
               
            UPDATE gipi_invoice
               SET acct_ent_date = p_prod_date
             WHERE iss_cd = rec.bill_iss_cd
               AND prem_seq_no = rec.prem_seq_no; 

         ELSIF rec.pos_neg_inclusion = 'N' THEN
            UPDATE gipi_polbasic
               SET spld_acct_ent_date = p_prod_date
             WHERE policy_id = rec.policy_id;

            UPDATE gipi_invoice
               SET spoiled_acct_ent_date = p_prod_date
             WHERE iss_cd = rec.bill_iss_cd
               AND prem_seq_no = rec.prem_seq_no;           
         END IF;

      END LOOP;
    END;
    
    PROCEDURE update_giac_parent_comm(p_module_name            IN GIAC_MODULES.module_name%type,
                                      p_module_item_no_CP    IN GIAC_MODULE_ENTRIES.item_no%type,
                                      p_module_item_no_CE    IN GIAC_MODULE_ENTRIES.item_no%type,
                                      p_tran_class            IN GIAC_ACCTRANS.tran_class%type,
                                      p_tran_flag            IN GIAC_ACCTRANS.tran_flag%type,
                                      p_new_prod_date        IN DATE,
                                      p_var_count_row        IN OUT NUMBER,
                                      p_prod_date            IN DATE)
    IS
      v_dummy                    VARCHAR2(1);
    BEGIN
       SELECT distinct 'x'
         INTO v_dummy
         FROM giac_module_entries a
        WHERE EXISTS (SELECT 'x'
                        FROM giac_modules b
                       WHERE b.module_id = a.module_id
                         AND b.module_name like p_module_name)
                         AND item_no in (  p_module_item_no_CP      , p_module_item_no_CE );

       IF v_dummy IS NOT NULL THEN
          FOR rec in (SELECT DISTINCT b.tran_id, a.iss_cd, a.prem_Seq_no
                        FROM giac_production_tax_ext a,
                            giac_acctrans       b
                       WHERE 1 = 1
                         AND a.iss_cd    = b.gibr_branch_cd
                         AND b.tran_class = p_tran_class
                         AND b.tran_flag  = p_tran_flag
                         AND TRUNC(b.tran_date)  =  TRUNC(NVL(p_new_prod_date,p_prod_date)) ) 
          LOOP

            p_var_count_row   := nvl(p_var_count_row,0)   + 1;

            BEGIN
               UPDATE giac_parent_comm_invoice
                  SET tran_id = rec.tran_id
                WHERE iss_cd = rec.iss_cd
                  AND prem_Seq_no = rec.prem_seq_no;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  null;
            END;
            
            BEGIN
               UPDATE gipi_comm_invoice
                  SET gacc_tran_id = rec.tran_id
                WHERE iss_cd = rec.iss_cd
                  AND prem_Seq_no = rec.prem_seq_no;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN 
                  null;
            END;

            BEGIN
               UPDATE giac_parent_comm_invprl
                  SET tran_id = rec.tran_id
                WHERE iss_cd = rec.iss_cd
                  AND prem_Seq_no = rec.prem_seq_no; 
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  null;
            END;
         END LOOP;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        /*  processing of commissions is not included in the batch production */
        null;
    END;
    
END; 
/

