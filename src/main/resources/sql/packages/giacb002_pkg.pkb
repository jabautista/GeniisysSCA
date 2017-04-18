CREATE OR REPLACE PACKAGE BODY CPI.GIACB002_PKG
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.17.2013
   **  Reference By : GIACB002 use in GIACB000 - Batch Accounting Entry
   **  Description  : added updates of acct_ent_date/spoiled_acct_ent_date on gipi_invoice
   **                 this is due to the long-term policy enhancement
   */
   PROCEDURE re_take_up (p_prod_date       IN       DATE,
                         p_new_prod_date   OUT      DATE,
                         p_msg             OUT      VARCHAR2
   )
   IS
      v_tran_flag    giac_acctrans.tran_flag%TYPE           := 'C';
      v_tran_class   giac_acctrans.tran_class%TYPE          := 'UW';
      addl           VARCHAR2 (1)                           := 'N';
      SWITCH         VARCHAR2 (1)                           := 'N';
      stat           VARCHAR2 (8);
      v_cession_id   giac_treaty_cessions.cession_id%TYPE;
      v_validate     VARCHAR2 (1);
      v_test         VARCHAR2 (1);
      v_add_msg      NUMBER (10)                            := 0;
      v_noadd_msg    NUMBER (10)                            := 0;
   BEGIN
      BEGIN
         FOR rec IN (SELECT DISTINCT 'x'
                                FROM giac_acctrans
                               WHERE tran_class = v_tran_class
                                 AND tran_flag IN ('P') -- variables.tran_flag
                                 AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (p_prod_date, 'mm-dd-yyyy'))
         LOOP
            addl := 'Y';
            v_add_msg := v_add_msg + 1;

            IF v_add_msg = 1
            THEN
               p_msg := p_msg ||'#Production take up for '
                   || TO_CHAR (p_prod_date, 'fmMonth dd,yyyy')
                   || ' has already been done. This will be an additional take up.';
            END IF;

            <<again>>
            p_new_prod_date := TRUNC (p_prod_date) - 1;

            BEGIN
               SELECT DISTINCT 'x'
                          INTO v_test
                          FROM giac_acctrans
                         WHERE tran_class = v_tran_class
                           AND tran_flag = 'P'
                           AND TRUNC (tran_date) = TRUNC (p_new_prod_date);

               IF v_test = 'x'
               THEN
                  GOTO again;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_test
                                FROM giac_acctrans
                               WHERE tran_class = v_tran_class
                                 AND tran_flag = v_tran_flag
                                 AND TRUNC (tran_date) =
                                                       TRUNC (p_new_prod_date);

                     v_add_msg := v_add_msg + 1;

                     IF v_add_msg = 1
                     THEN
                        p_msg := p_msg ||'#Production take up for '
                            || TO_CHAR (p_new_prod_date, 'fmMonth dd,yyyy')
                            || ' has already been done. This will be a complete take up of this transaction date.';
                     END IF;

                     UPDATE giuw_pol_dist
                        SET acct_ent_date = NULL
                      WHERE TRUNC (acct_ent_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

                     UPDATE giuw_pol_dist
                        SET acct_neg_date = NULL
                      WHERE TRUNC (acct_neg_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

                     DELETE FROM giac_treaty_cession_dtl
                           WHERE TRUNC (acct_ent_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

                     DELETE FROM giac_treaty_cessions
                           WHERE TRUNC (acct_ent_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

                     UPDATE giac_acctrans
                        SET tran_flag = 'D'
                      WHERE tran_flag = v_tran_flag
                        AND tran_class = v_tran_class
                        AND TRUNC (tran_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;                      --continue with re-take-up
                  END;
            END;
         END LOOP;
      END;

      IF addl = 'N'
      THEN
         BEGIN
            FOR rec IN (SELECT DISTINCT tran_id
                                   FROM giac_acctrans
                                  WHERE tran_class = v_tran_class
                                    AND tran_flag IN
                                                  ('C') -- variables.tran_flag
                                    AND TRUNC (tran_date) =
                                                           TRUNC (p_prod_date))
            LOOP
               p_new_prod_date := p_prod_date;
               v_noadd_msg := v_noadd_msg + 1;

               IF SWITCH = 'N'
               THEN
                  IF v_noadd_msg = 1
                  THEN
                     p_msg := p_msg ||'#Production take up for '
                         || TO_CHAR (p_prod_date, 'fmMonth dd,yyyy')
                         || ' has already been done. This will be a complete retake-up.';
                  END IF;
               END IF;
            END LOOP;
         END;

         UPDATE giuw_pol_dist
            SET acct_ent_date = NULL
          WHERE TRUNC (acct_ent_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

         UPDATE giuw_pol_dist
            SET acct_neg_date = NULL
          WHERE TRUNC (acct_neg_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

         DELETE FROM giac_treaty_cession_dtl
               WHERE TRUNC (acct_ent_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

         DELETE FROM giac_treaty_cessions
               WHERE TRUNC (acct_ent_date) =
                                    TRUNC (NVL (p_prod_date, p_new_prod_date));

         UPDATE giac_acctrans
            SET tran_flag = 'D'
          WHERE tran_flag = v_tran_flag
            AND tran_class = v_tran_class
            AND TRUNC (tran_date) = TRUNC (NVL (p_prod_date, p_new_prod_date));
      END IF; 
   END;
   
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.18.2013
   **  Reference By : GIACB002 use in GIACB000 - Batch Accounting Entry
   **  Description  : 
   */
    PROCEDURE prod_take_up (p_fund_cd           IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                            p_sql_path          IN OUT VARCHAR2,
                            p_gen_home          IN OUT giac_parameters.param_value_v%TYPE,
                            p_ri_iss_cd         IN OUT giac_parameters.param_value_v%TYPE,
                            p_msg               IN OUT VARCHAR2)
    IS
       v_share_trty_type   giis_dist_share.share_type%TYPE := '2';
       var_param_value_n   giac_parameters.param_value_n%TYPE;
       v_level             giac_module_entries.line_dependency_level%TYPE;

       CURSOR fund_cd
       IS
          SELECT param_value_v
            FROM giac_parameters
           WHERE param_name = 'FUND_CD';

       CURSOR sql_path
       IS
          SELECT param_value_v
            FROM giac_parameters
           WHERE param_name = 'SQL_PATH';

       CURSOR home
       IS
          SELECT param_value_v
            FROM giac_parameters
           WHERE param_name = 'GENIISYS';

       CURSOR ri_iss_cd
       IS
          SELECT param_value_v
            FROM giac_parameters
           WHERE param_name = 'RI_ISS_CD';

       CURSOR treaty
       IS
          SELECT DISTINCT c.trty_yy, a.line_cd, a.share_cd, a.peril_cd,
                          b.peril_name, c.trty_name
                     FROM giuw_itemperilds_dtl a, giis_peril b,
                          giis_dist_share c
                    WHERE 1 = 1
                      AND a.line_cd = b.line_cd
                      AND a.peril_cd = b.peril_cd
                      AND a.line_cd = c.line_cd
                      AND a.share_cd = c.share_cd
                      AND c.share_type = v_share_trty_type
                      -- and c.trty_yy = to_number(to_char(:prod.cut_off_date,'yy'))
                      AND NOT EXISTS (
                             SELECT 'x'
                               FROM giis_trty_peril
                              WHERE line_cd = a.line_cd
                                AND trty_seq_no = a.share_cd
                                AND peril_cd = a.peril_cd);

       v_max_cession       giac_treaty_cessions.cession_id%TYPE;
       error_switch        VARCHAR2 (1)                                     := 'N';
    BEGIN
        p_ri_iss_cd := 'RI';
       FOR ja1 IN fund_cd
       LOOP
          p_fund_cd := ja1.param_value_v;
       END LOOP;

       FOR ja1 IN sql_path
       LOOP
          p_sql_path := ja1.param_value_v;
       END LOOP;

       IF p_fund_cd IS NULL
       THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (FUND_CD).');            
       END IF;

       FOR ja1 IN home
       LOOP
          p_gen_home := ja1.param_value_v;
       END LOOP;

       IF p_fund_cd IS NULL
       THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (FUND_CD).');  
       END IF;

       FOR ja2 IN ri_iss_cd
       LOOP
          p_ri_iss_cd := ja2.param_value_v;
       END LOOP;

       IF p_ri_iss_cd IS NULL
       THEN
            raise_application_error(-20001,p_msg||'#Geniisys Exception#No Data Found in Giac_parameters Table (RI_ISS_CD).');
       END IF;

    END;
    
    PROCEDURE prod_take_up_proc (p_prod_date            IN       DATE,
                                 p_new_prod_date        IN OUT   DATE,
                                 p_exclude_special      IN OUT   VARCHAR2,
                                 p_gen_home             IN OUT   giac_parameters.param_value_v%TYPE,
                                 p_sql_path             IN       VARCHAR2,
                                 p_fund_cd              IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                 p_ri_iss_cd            IN       giac_parameters.param_value_v%TYPE,
                                 p_prem_rec_gross_tag   IN       giac_parameters.param_value_v%TYPE,
                                 p_user_id              IN       giis_users.user_id%TYPE,
                                 p_process              IN OUT   VARCHAR2,
                                 p_msg                  IN OUT   VARCHAR2)
    IS
        v_sql_name                      VARCHAR2 (100);
        v_item_no                       GIAC_MODULE_ENTRIES.item_no%type;
        v_line_dep                      GIAC_MODULE_ENTRIES.line_dependency_level%type;
        v_intm_dep                      GIAC_MODULE_ENTRIES.intm_type_level%type;
        v_ca_dep                        GIAC_MODULE_ENTRIES.ca_treaty_type_level%type;
        v_module_name                   GIAC_MODULES.module_name%type:= 'GIACB002';
        v_tran_flag     		        GIAC_ACCTRANS.tran_flag%type := 'C';
        v_tran_class    		        GIAC_ACCTRANS.tran_class%type := 'UW';
        v_gacc_tran_id  		        GIAC_ACCTRANS.tran_id%type;
        v_module_item_no_PC             GIAC_MODULE_ENTRIES.item_no%type:= 1;
        v_module_item_no_CI             GIAC_MODULE_ENTRIES.item_no%type:= 2;
        v_module_item_no_FH             GIAC_MODULE_ENTRIES.item_no%type:= 3;
        v_module_item_no_DT             GIAC_MODULE_ENTRIES.item_no%type:= 4;
        v_module_item_no_Inc_adj        GIAC_MODULE_ENTRIES.item_no%type:= 5;--Vincent 051205: used by adjust proc
        v_module_item_no_Exp_adj        GIAC_MODULE_ENTRIES.item_no%type:= 6;--Vincent 051205: used by adjust proc
        v_module_item_no_IV				GIAC_MODULE_ENTRIES.item_no%type:= 7;--Lina 011006 : to generate deferred input vat
        v_module_item_no_OV				GIAC_MODULE_ENTRIES.item_no%type:= 8;--Lina 011006 : to generate deferred output vat
        v_module_item_no_DCWV			GIAC_MODULE_ENTRIES.item_no%type:= 9;--Lina 011006 : to generate deferred output vat
        v_module_item_no_DWVP			GIAC_MODULE_ENTRIES.item_no%type:= 10;--Lina 011006 : to generate deferred output vat
        v_module_item_no_PT				GIAC_MODULE_ENTRIES.item_no%type:= 11; -- judyann 07162008; for generation of premium tax entries
        v_module_item_no_PRC						GIAC_MODULE_ENTRIES.item_no%type:= 12; -- judyann 03292011; for separate GL entry for retrocessions
        v_module_item_no_CIR						GIAC_MODULE_ENTRIES.item_no%type:= 13; -- judyann 03292011; for separate GL entry for retrocessions
        
        v_balance                       NUMBER;
       
       v_dummy      NUMBER;
       path         VARCHAR2 (100);
       paramlist    VARCHAR2 (300);
    BEGIN
       giis_users_pkg.app_user := p_user_id;
       IF p_exclude_special = 'N'
       THEN
          --Setting the name of the procedure to run: BAE2_COPY_TO_EXTRACT'
          v_sql_name := ('bae2_copy_to_extract');
       ELSIF p_exclude_special = 'Y'
       THEN
          --Setting the name of the procedure to run: BAE2_COPY_TO_EXTRACT_REG
          v_sql_name := ('bae2_copy_to_extract_reg');
       END IF;
       GIACB002_PKG.run_sql_report (path,
                                    p_prod_date,
                                    p_new_prod_date,
                                    v_sql_name,
                                    v_line_dep,
                                    v_intm_dep,
                                    v_item_no,
                                    v_ca_dep,
                                    p_msg);
        
       GIACB002_PKG.create_batch_entries(p_prod_date,
                                         v_module_name);
       
       GIACB002_PKG.insert_giac_acctrans(p_prod_date,
                            p_new_prod_date,
                            p_fund_cd,
                            v_tran_class,
                            v_tran_flag,
                            p_user_id,
                            v_gacc_tran_id,
                            p_msg);
       
       GIACB002_PKG.update_giac_treaty_batch_ext();
       
       GIACB002_PKG.bae2_copy_to_gtc_gtcd(p_prod_date,
                                          p_new_prod_date,
                                          v_sql_name,
                                          v_line_dep,
                                          v_intm_dep,
                                          v_item_no,
                                          v_ca_dep,
                                          p_msg);

       DELETE FROM giac_temp_acct_entries;

       GIACB002_PKG.bae2_create_prem_ceded(p_prod_date,
                                          p_new_prod_date,
                                          p_process,
                                          p_msg,
                                          v_module_item_no_PC,
                                          v_module_name,
                                          v_sql_name,
                                          v_line_dep,
                                          v_intm_dep,
                                          v_ca_dep,
                                          v_item_no);

       GIACB002_PKG.bae2_create_comm_inc(p_prod_date,
                                        p_new_prod_date,
                                        p_process,
                                        p_msg,
                                        v_module_item_no_CI,
                                        v_module_name,
                                        v_sql_name,
                                        v_line_dep,
                                        v_intm_dep,
                                        v_ca_dep,
                                        v_item_no);
                                        
       /* judyann 03292011; to handle generation of separate GL entries for retrocessions */
       IF NVL(GIACP.v('SEPARATE_CESSIONS_GL'),'N') = 'Y' THEN
         GIACB002_PKG.bae2_create_prem_retroceded(p_prod_date,
                                                  p_new_prod_date,
                                                  p_process,
                                                  p_msg,
                                                  v_module_item_no_PRC,
                                                  v_module_name,
                                                  v_sql_name,
                                                  v_line_dep,
                                                  v_intm_dep,
                                                  v_ca_dep,
                                                  v_item_no);
         
         GIACB002_PKG.bae2_create_comm_inc_retro(p_prod_date,
                                                 p_new_prod_date,
                                                 p_process,
                                                 p_msg,
                                                 v_module_item_no_CIR,
                                                 v_module_name,
                                                 v_sql_name,
                                                 v_line_dep,
                                                 v_intm_dep,
                                                 v_ca_dep,
                                                 v_item_no);
       END IF;
       
       GIACB002_PKG.bae2_create_funds_held(p_prod_date,
                                           p_new_prod_date,
                                           p_process,
                                           p_msg,
                                           v_module_item_no_fh,
                                           v_module_item_no_dt,
                                           v_module_name,
                                           v_sql_name,
                                           v_line_dep,
                                           v_intm_dep,
                                           v_ca_dep,
                                           v_item_no);
       
       GIACB002_PKG.bae2_create_due_to_treaty(p_prod_date,
                                              p_new_prod_date,
                                              p_process,
                                              p_msg,
                                              v_module_item_no_dt,
                                              v_module_name,
                                              v_sql_name,
                                              v_line_dep,
                                              v_intm_dep,
                                              v_ca_dep,
                                              v_item_no);

       --IF NVL(giacp.v('GEN_VAT_ON_RI'),'Y') = 'Y' THEN   -- judyann 04172008; 'Y' - generate entries for VAT (prem and comm)
       IF NVL (giacp.v ('EXCLUDE_TRTY_VAT'), 'N') = 'N'
       THEN    -- judyann 07162008; 'Y' - generate entries for VAT (prem and comm)
          GIACB002_PKG.bae2_create_comm_vat(p_prod_date,
                                            p_new_prod_date,
                                            p_process,
                                            p_msg,
                                            v_module_item_no_ov,
                                            v_module_name,
                                            v_sql_name,
                                            v_line_dep,
                                            v_intm_dep,
                                            v_ca_dep,
                                            v_item_no);
          IF NVL (giacp.v ('GEN_TRTY_PREM_VAT'), 'N') = 'Y'
          THEN      -- judyann 04172008; 'Y' - generate entries for VAT on premium
             GIACB002_PKG.bae2_create_prem_vat(p_prod_date,
                                               p_new_prod_date,
                                               p_process,
                                               p_msg,
                                               v_module_item_no_iv,
                                               v_module_name,
                                               v_sql_name,
                                               v_line_dep,
                                               v_intm_dep,
                                               v_ca_dep,
                                               v_item_no);
             
             GIACB002_PKG.bae2_create_def_credit_wvat(p_prod_date,
                                                      p_new_prod_date,
                                                      p_process,
                                                      p_msg,
                                                      v_module_item_no_dcwv,
                                                      v_module_name,
                                                      v_sql_name,
                                                      v_line_dep,
                                                      v_intm_dep,
                                                      v_ca_dep,
                                                      v_item_no);
             
              GIACB002_PKG.bae2_create_def_wvat_payable(p_prod_date,
                                                        p_new_prod_date,
                                                        p_process,
                                                        p_msg,
                                                        v_module_item_no_dwvp,
                                                        v_module_name,
                                                        v_sql_name,
                                                        v_line_dep,
                                                        v_intm_dep,
                                                        v_ca_dep,
                                                        v_item_no);
          END IF;
       END IF;

       -- judyann 07162008; 'Y' - generate entries for premium tax
       IF NVL (giacp.v ('GEN_TRTY_PREMIUM_TAX'), 'N') = 'Y'
       THEN
          GIACB002_PKG.bae2_create_prem_tax(p_prod_date,
                                            p_new_prod_date,
                                            p_process,
                                            p_msg,
                                            v_module_item_no_pt,
                                            v_module_name,
                                            v_sql_name,
                                            v_line_dep,
                                            v_intm_dep,
                                            v_ca_dep,
                                            v_item_no);
       END IF;
       --trace_log('Running the procedure CHECK_DEBIT_CREDIT_AMOUNTS...');  --mikel 07.26.2011; moved below, to handle rounding off discrepancies when tranferring entries from giac_temp_acct_entries to giac_acct_entries
       --check_debit_credit_amounts; --mikel 07.26.2011; moved below
       GIACB002_PKG.transfer_to_giac_acct_entries;
                                                                
       GIACB002_PKG.check_debit_credit_amounts(p_prod_date,
                                               v_module_item_no_inc_adj,
                                               v_module_item_no_exp_adj,
                                               v_module_name,
                                               p_fund_cd,
                                               p_user_id,
                                               v_balance,
                                               p_msg);                              
       
       GIACB002_PKG.update_giuw_pol_dist(p_prod_date,
                                         p_new_prod_date);
    END;
    
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 04.18.2013
   **  Reference By : GIACB002 use in GIACB000 - Batch Accounting Entry
   **  Description : The RUN_SQL_REPORT procedure was formerly used to run the SQL scripts
   **       of the old batch generation. This was modified to handle the new way of running the
   **       batch generation using the database package BAE. The only variable needed to run the
   **       commands are the names of the procedures that should be called.
   */
    PROCEDURE run_sql_report(path 				IN VARCHAR2,
                             p_prod_date 		IN DATE,
                             p_new_prod_date 	IN OUT DATE,
                             p_sql_name 		IN VARCHAR2,
                             p_line_dep 		IN giac_module_entries.line_dependency_level%type,
                             p_intm_dep 		IN giac_module_entries.intm_type_level%type,
                             p_item_no  		IN giac_module_entries.item_no%type,
                             p_ca_dep           IN GIAC_MODULE_ENTRIES.ca_treaty_type_level%type,
                             p_msg      		IN OUT VARCHAR2)
    IS
        unrecognized_sql_name EXCEPTION;
      --the_username 	VARCHAR2(10); 
      --the_password 	VARCHAR2(10); 
      --the_connect  	VARCHAR2(10); 
      --logon		VARCHAR2(40);
      
      --form_path	VARCHAR2(100) := UPPER (' @C:\JANET\AGING\');

      --paramlist	VARCHAR2(300) ;

      --the_command	VARCHAR2(1000); 

    BEGIN
       IF p_new_prod_date  is null THEN
          p_new_prod_date := p_prod_date; 
       END IF;

       --Start of accounting entry generation
       IF p_sql_name = 'bae2_copy_to_extract' THEN
          --Populating GIAC_TREATY_BATCH_EXT using BAE.BAE2_COPY_TO_EXTRACT...
          BAE.BAE2_COPY_TO_EXTRACT(p_prod_date);        
       ELSIF p_sql_name = 'bae2_copy_to_extract_reg' THEN
          --Populating GIAC_TREATY_CESSIONS using BAE.BAE2_COPY_TO_EXTRACT_REG...
          BAE.BAE2_COPY_TO_EXTRACT_REG(p_prod_date);  
       ELSIF p_sql_name = 'bae2_copy_to_gtc' THEN
          --Populating GIAC_TREATY_CESSIONS using BAE.BAE2_COPY_TO_GTC...
          BAE.BAE2_COPY_TO_GTC(p_prod_date);
       ELSIF p_sql_name = 'bae2_copy_to_gtcd' THEN
          --Populating GIAC_TREATY_CESSION_DTL using BAE.BAE2_COPY_TO_GTCD...
          BAE.BAE2_COPY_TO_GTCD(p_prod_date);
       ELSIF p_sql_name = 'bae2_create_prem_ceded' THEN
          --Creating accounting entries for PREMIUMS CEDED using BAE.BAE2_CREATE_PREM_CEDED_PROC...
          BAE.BAE2_CREATE_PREM_CEDED_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);
       ELSIF p_sql_name = 'bae2_create_prem_retroceded' THEN
          IF NVL(GIACP.v('SEPARATE_CESSIONS_GL'),'N') = 'Y' THEN
            --'Creating accounting entries for PREMIUMS CEDED RETROCESSIONS using BAE.BAE2_CREATE_PREM_RETROCED_PROC...
            BAE.BAE2_CREATE_PREM_RETROCED_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);
          END IF;
       ELSIF p_sql_name = 'bae2_create_comm_inc' THEN
          --Creating accounting entries for COMMISSION INCOME using BAE.BAE2_CREATE_COMM_INC_PROC...
          BAE.BAE2_CREATE_COMM_INC_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);
          
       ELSIF p_sql_name = 'bae2_create_comm_inc_retro' THEN
          IF NVL(GIACP.v('SEPARATE_CESSIONS_GL'),'N') = 'Y' THEN
            --Creating accounting entries for COMMISSION INCOME RETROCESSIONS using BAE.BAE2_CREATE_COMM_RETRO_PROC...
            BAE.BAE2_CREATE_COMM_RETRO_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);  
          END IF;
       ELSIF p_sql_name = 'bae2_create_funds_held' THEN
          --Creating accounting entries for FUNDS HELD using BAE.BAE2_CREATE_FUNDS_HELD_PROC...
          BAE.BAE2_CREATE_FUNDS_HELD_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);  
       ELSIF p_sql_name = 'bae2_create_due_to_treaty' THEN
          --Creating accounting entries for DUE TO TREATY RI using BAE.BAE2_CREATE_DUE_TO_TREATY_PROC...
          BAE.BAE2_CREATE_DUE_TO_TREATY_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);  
       ---Added by lina (to handle vat on RI) 01212006
       ELSIF p_sql_name = 'bae2_create_prem_vat' THEN 
          --Creating accounting entries for DEFERRED_PREM_VAT using BAE.BAE2_CREATE_PREM_VAT_PROC...
          BAE.BAE2_CREATE_PREM_VAT_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);
       ELSIF p_sql_name = 'bae2_create_comm_vat' THEN 
          --Creating accounting entries for DEFERRED_COMM_VAT using BAE.BAE2_CREATE_COMM_VAT_PROC...
          BAE.BAE2_CREATE_COMM_VAT_PROC(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);
       ELSIF p_sql_name = 'bae2_create_def_credit_wvat' THEN
          --Creating accounting entries for DEFERRED_CREDIT_WVAT using BAE.BAE2_CREATE_DEF_CR_WVAT_PROC...
          BAE.bae2_create_def_cr_wvat_proc(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no); 
       ELSIF p_sql_name = 'bae2_create_def_wvat_payable' THEN 
          --Creating accounting entries for DEFERRED_WVAT_PAYABLE using BAE.BAE2_CREATE_DEF_WVAT_PAYABLE_PROC...
          BAE.bae2_create_wvat_pay_proc(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);
       ELSIF p_sql_name = 'bae2_create_prem_tax' THEN   -- judyann 07162008 
          --Creating accounting entries for PREMIUM TAX using BAE.BAE2_CREATE_PREM_TAX_PROC...
          BAE.bae2_create_prem_tax_proc(p_prod_date,p_line_dep,p_intm_dep,p_ca_dep,p_item_no);                    
       ELSE
         RAISE unrecognized_sql_name;
       END IF;

      /* 
      ** Check whether the command succeeded or not 
      */ 
      EXCEPTION
            WHEN unrecognized_sql_name THEN
                raise_application_error(-20001,p_msg||'#Geniisys Exception#Unrecognized variable.sql_name in RUN_SQL_REPORT of GIACB002. Process will be stopped...');
            WHEN OTHERS THEN
                --raise_application_error(-20001,p_msg||'#Geniisys Exception#Error -- process not completed.'); --steven 03.05.2014
				raise_application_error(-20001,p_msg||'#Geniisys Information#No record/s available for batch accounting generation.');
    END;  -- run_sql_report

    PROCEDURE create_batch_entries (p_prod_date IN DATE, 
                                    p_module_name IN VARCHAR2)
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
       
       PRAGMA AUTONOMOUS_TRANSACTION; -- SR-4620 : shan 07.10.2015
      v_exists      BOOLEAN := FALSE;   -- SR-4620 : shan 07.10.2015
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
                                    'GIAC_TREATY_BATCH_EXT'
                                   );
       END LOOP;

       BEGIN
          FOR ja1 IN (SELECT    TO_CHAR (gl_acct_category)
                             || '-'
                             || TO_CHAR (gl_control_acct)
                             || '-'
                             || TO_CHAR (gl_sub_acct_1)
                             || '-'
                             || TO_CHAR (gl_sub_acct_2)
                             || '-'
                             || TO_CHAR (gl_sub_acct_3)
                             || '-'
                             || TO_CHAR (gl_sub_acct_4)
                             || '-'
                             || TO_CHAR (gl_sub_acct_5)
                             || '-'
                             || TO_CHAR (gl_sub_acct_6)
                             || '-'
                             || TO_CHAR (gl_sub_acct_7) gl_acct_id,
                             item_no, ROWID
                        FROM giac_batch_entries
                       WHERE gl_acct_id IS NULL)
          LOOP
             INSERT INTO giac_bae_error_log
                         (module_name, item_no, line_cd, error_log
                         )
                  VALUES (p_module_name, ja1.item_no, NULL, ja1.gl_acct_id
                         );

             DELETE FROM giac_batch_entries
                   WHERE ROWID = ja1.ROWID;
                
                IF ja1.gl_acct_id != '0-0-0-0-0-0-0-0-0' THEN  -- SR-4620 : shan 07.10.2015
                    v_exists := TRUE;
                END IF;
          END LOOP ja1;
          
          COMMIT;   -- SR-4620 : shan 07.10.2015
       END;
            
       -- SR-4620 : shan 07.10.2015  
        IF v_exists = TRUE THEN 
            raise_application_error (-20001, '#Geniisys Information#There are GL account codes that are not existing in Chart of Accounts. Kindly see list of GLs in GIAC_BAE_ERROR_LOG table.');
        END IF;
    END;
    
    PROCEDURE insert_giac_acctrans (p_prod_date       IN       DATE,
                                    p_new_prod_date   IN       DATE,
                                    p_fund_cd         IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                    p_tran_class      IN       giac_acctrans.tran_class%TYPE,
                                    p_tran_flag       IN       giac_acctrans.tran_flag%TYPE,
                                    p_user_id         IN       giis_users.user_id%TYPE,
                                    p_gacc_tran_id    IN OUT   giac_acctrans.tran_id%TYPE,
                                    p_msg             IN OUT   VARCHAR2)
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
          FOR rec IN (SELECT DISTINCT iss_cd
                                 FROM giac_treaty_batch_ext)
          LOOP
             var_branch_cd := rec.iss_cd;

             BEGIN
                SELECT DISTINCT (tran_id)
                           INTO var_tran_id
                           FROM giac_acctrans
                          WHERE gfun_fund_cd = p_fund_cd
                            AND gibr_branch_cd = rec.iss_cd
                            AND tran_year = var_year
                            AND tran_month = var_month
                            AND tran_class = p_tran_class
                            AND tran_flag = p_tran_flag
                            AND TO_CHAR (tran_date, 'DD-MON-YYYY') =
                                   NVL (TO_CHAR (p_new_prod_date, 'DD-MON-YYYY'),
                                        TO_CHAR (p_prod_date, 'DD-MON-YYYY')
                                       );
             EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   BEGIN
                      SELECT acctran_tran_id_s.NEXTVAL
                        INTO p_gacc_tran_id
                        FROM DUAL;

                      var_tran_seq_no :=
                         giac_sequence_generation (p_fund_cd,
                                                   rec.iss_cd,
                                                   'TRAN_SEQ_NO',
                                                   var_year,
                                                   var_month
                                                  );
                      var_tran_class_no :=
                         giac_sequence_generation (p_fund_cd,
                                                   rec.iss_cd,
                                                   p_tran_class,
                                                   var_year,
                                                   0
                                                  );

                      INSERT INTO giac_acctrans
                                  (tran_id, gfun_fund_cd, gibr_branch_cd,
                                   tran_year, tran_month, tran_seq_no,
                                   tran_date,
                                   tran_flag, tran_class, tran_class_no,
                                   user_id, last_update,
                                   particulars
                                  )
                           VALUES (p_gacc_tran_id, p_fund_cd, rec.iss_cd,
                                   var_year, var_month, var_tran_seq_no,
                                   NVL (p_new_prod_date, p_prod_date),
                                   p_tran_flag, p_tran_class, var_tran_class_no,
                                   giis_users_pkg.app_user, SYSDATE,
                                      'Production take up of Treaty RI distribution for '
                                   || TO_CHAR (p_prod_date, 'fmMonth yyyy')
                                  );
                   END;
             END;
          END LOOP;
       END;
    END;
    
    PROCEDURE update_giac_treaty_batch_ext
    IS
       v_max_cession      giac_treaty_cessions.cession_id%TYPE;
       v_policy_id        gipi_polbasic.policy_id%TYPE;
       v_currency_cd      giac_treaty_batch_ext.currency_cd%TYPE;
       v_currency_rt      giac_treaty_batch_ext.currency_rt%TYPE;
       v_tk_up_type       giac_treaty_batch_ext.tk_up_type%TYPE;
       v_item_no          giac_treaty_batch_ext.item_no%TYPE;
       v_share_cd         giac_treaty_batch_ext.share_cd%TYPE;
       v_funds_held       giac_treaty_batch_ext.funds_held%TYPE;
       v_trty_yy          giac_treaty_batch_ext.trty_yy%TYPE;
       v_ri_cd            giac_treaty_batch_ext.ri_cd%TYPE;
       v_acct_intm_cd     giac_treaty_batch_ext.acct_intm_cd%TYPE;
       v_acct_trty_type   giac_treaty_batch_ext.acct_trty_type%TYPE;
       v_dist_no          giac_treaty_batch_ext.dist_no%TYPE;
    BEGIN
       --Updating GIAC_TREATY_BATCH_EXT... getting max(cession_id) from GIAC_TREATY_CESSIONS...
       SELECT MAX (cession_id)
         INTO v_max_cession
         FROM giac_treaty_cessions;

       FOR ja1 IN (SELECT   ROWID, iss_cd, policy_id, currency_cd, currency_rt,
                            tk_up_type, item_no, line_cd, acct_line_cd,
                            acct_subline_cd, share_cd, funds_held, trty_yy, ri_cd,
                            dist_no, acct_intm_cd, acct_trty_type
                       FROM giac_treaty_batch_ext
                   ORDER BY iss_cd,
                            policy_id,
                            currency_cd,
                            currency_rt,
                            tk_up_type,
                            item_no,
                            line_cd,
                            acct_line_cd,
                            acct_subline_cd,
                            share_cd,
                            funds_held,
                            trty_yy,
                            ri_cd,
                            dist_no,
                            acct_intm_cd,
                            acct_trty_type)
       LOOP
          IF     v_policy_id = ja1.policy_id
             AND v_currency_cd = ja1.currency_cd
             AND v_currency_rt = ja1.currency_rt
             AND v_tk_up_type = ja1.tk_up_type
             AND v_item_no = ja1.item_no
             AND v_share_cd = ja1.share_cd
             AND v_funds_held = ja1.funds_held
             AND v_trty_yy = ja1.trty_yy
             AND v_ri_cd = ja1.ri_cd
             AND v_acct_intm_cd = ja1.acct_intm_cd
             AND v_dist_no = ja1.dist_no
             AND v_acct_trty_type = ja1.acct_trty_type
          THEN
             UPDATE giac_treaty_batch_ext
                SET cession_id = v_max_cession
              WHERE ROWID = ja1.ROWID;
          ELSE
             v_max_cession := NVL (v_max_cession, 0) + 1;
             v_policy_id := ja1.policy_id;
             v_currency_cd := ja1.currency_cd;
             v_currency_rt := ja1.currency_rt;
             v_tk_up_type := ja1.tk_up_type;
             v_item_no := ja1.item_no;
             v_share_cd := ja1.share_cd;
             v_funds_held := ja1.funds_held;
             v_trty_yy := ja1.trty_yy;
             v_ri_cd := ja1.ri_cd;
             v_acct_intm_cd := ja1.acct_intm_cd;
             v_acct_trty_type := ja1.acct_trty_type;
             v_dist_no := ja1.dist_no;

             UPDATE giac_treaty_batch_ext
                SET cession_id = v_max_cession
              WHERE ROWID = ja1.ROWID;
          END IF;
       END LOOP ja1;
    END;
    
    PROCEDURE bae2_copy_to_gtc_gtcd(p_prod_date 		IN DATE,
                                    p_new_prod_date 	IN OUT DATE,
                                    p_sql_name 		    IN OUT VARCHAR2,
                                    p_line_dep 		    IN giac_module_entries.line_dependency_level%type,
                                    p_intm_dep 		    IN giac_module_entries.intm_type_level%type,
                                    p_item_no  		    IN giac_module_entries.item_no%type,
                                    p_ca_dep            IN GIAC_MODULE_ENTRIES.ca_treaty_type_level%type,
                                    p_msg      		    IN OUT VARCHAR2)
    IS
       path   VARCHAR2 (100);
    BEGIN
       /* will copy to giac_treaty_cessions */
       p_sql_name := 'bae2_copy_to_gtc';
       GIACB002_PKG.run_sql_report (path,
                                    p_prod_date,
                                    p_new_prod_date,
                                    p_sql_name,
                                    p_line_dep,
                                    p_intm_dep,
                                    p_item_no,
                                    p_ca_dep,
                                    p_msg);
       /* will copy to giac_treaty_cession_dtl */
       p_sql_name := 'bae2_copy_to_gtcd';
       GIACB002_PKG.run_sql_report (path,
                                    p_prod_date,
                                    p_new_prod_date,
                                    p_sql_name,
                                    p_line_dep,
                                    p_intm_dep,
                                    p_item_no,
                                    p_ca_dep,
                                    p_msg);
       p_sql_name := NULL;
    END;
    
    PROCEDURE bae2_create_prem_ceded (p_prod_date           IN       DATE,
                                      p_new_prod_date       IN OUT   DATE,
                                      p_process             IN OUT   VARCHAR2,
                                      p_msg                 IN OUT   VARCHAR2,
                                      p_module_item_no_pc   IN OUT   giac_module_entries.item_no%TYPE,
                                      p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                      p_sql_name            IN OUT   VARCHAR2,
                                      p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                      p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                      p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                      p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_pc,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_prem_ceded';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_pc;
          GIACB002_PKG.run_sql_report(path,
                                      p_prod_date,
                                      p_new_prod_date,
                                      p_sql_name,
                                      p_line_dep,
                                      p_intm_dep,
                                      p_item_no,
                                      p_ca_dep,
                                      p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    --marco - 10.29.2014 - @FGIC - from latest version of GIACB002
    PROCEDURE bae2_create_prem_retroceded(p_prod_date           IN       DATE,
                                          p_new_prod_date       IN OUT   DATE,
                                          p_process             IN OUT   VARCHAR2,
                                          p_msg                 IN OUT   VARCHAR2,
                                          p_module_item_no_prc  IN OUT   giac_module_entries.item_no%TYPE,
                                          p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                          p_sql_name            IN OUT   VARCHAR2,
                                          p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                          p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                          p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                          p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_prc,
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
                                  var_dr_cr_tag);
                                  
       IF var_gl_acct_category IS NOT NULL THEN
          p_sql_name := 'bae2_create_prem_retroceded';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_prc;
    
          GIACB002_PKG.run_sql_report(path,
                                      p_prod_date,
                                      p_new_prod_date,
                                      p_sql_name,
                                      p_line_dep,
                                      p_intm_dep,
                                      p_item_no,
                                      p_ca_dep,
                                      p_msg);
     
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    PROCEDURE bae2_create_comm_inc (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_ci   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_ci,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_comm_inc';
                             --changed from 'bae2_create_prem_ceded' mike04022002
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_ci;
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    --marco - 10.29.2014 - @FGIC - from latest version of GIACB002
    PROCEDURE bae2_create_comm_inc_retro(p_prod_date           IN       DATE,
                                         p_new_prod_date       IN OUT   DATE,
                                         p_process             IN OUT   VARCHAR2,
                                         p_msg                 IN OUT   VARCHAR2,
                                         p_module_item_no_cir  IN OUT   giac_module_entries.item_no%TYPE,
                                         p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                         p_sql_name            IN OUT   VARCHAR2,
                                         p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                         p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                         p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                         p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_cir,
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
                                  var_dr_cr_tag);
       
       IF var_gl_acct_category IS NOT NULL THEN
          p_sql_name := 'bae2_create_comm_inc_retro';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_cir;
    
          GIACB002_PKG.run_sql_report(path,
                                      p_prod_date,
                                      p_new_prod_date,
                                      p_sql_name,
                                      p_line_dep,
                                      p_intm_dep,
                                      p_item_no,
                                      p_ca_dep,
                                      p_msg);
     
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;

    END;
    
    PROCEDURE bae2_create_funds_held (p_prod_date           IN       DATE,
                                       p_new_prod_date       IN OUT   DATE,
                                       p_process             IN OUT   VARCHAR2,
                                       p_msg                 IN OUT   VARCHAR2,
                                       p_module_item_no_fh   IN OUT   giac_module_entries.item_no%TYPE,
                                       p_module_item_no_dt   IN OUT   giac_module_entries.item_no%TYPE,
                                       p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                       p_sql_name            IN OUT   VARCHAR2,
                                       p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                       p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                       p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                       p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_fh,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_funds_held';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_fh;
              
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
              
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       ELSE
          bae_get_module_parameters (p_module_item_no_dt,
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
          p_sql_name := 'bae2_create_funds_held';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_dt;
              
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
              
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    PROCEDURE bae2_create_due_to_treaty (p_prod_date           IN       DATE,
                                         p_new_prod_date       IN OUT   DATE,
                                         p_process             IN OUT   VARCHAR2,
                                         p_msg                 IN OUT   VARCHAR2,
                                         p_module_item_no_dt   IN OUT   giac_module_entries.item_no%TYPE,
                                         p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                         p_sql_name            IN OUT   VARCHAR2,
                                         p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                         p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                         p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                         p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_dt,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_due_to_treaty';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_dt;
          
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    --to handle VAT on commission income--lina01192006
    PROCEDURE bae2_create_comm_vat (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_ov   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_ov,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_comm_vat';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_ov;
          
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    --to handle vat on premiums ceded--lina01192006
    PROCEDURE bae2_create_prem_vat (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_iv   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_iv,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_prem_vat';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_iv;
          
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    --to handle deferred creditable withholding vat on Foreign RI lina 01202006
    PROCEDURE bae2_create_def_credit_wvat (p_prod_date             IN       DATE,
                                           p_new_prod_date         IN OUT   DATE,
                                           p_process               IN OUT   VARCHAR2,
                                           p_msg                   IN OUT   VARCHAR2,
                                           p_module_item_no_dcwv   IN OUT   giac_module_entries.item_no%TYPE,
                                           p_module_name           IN OUT   giac_modules.module_name%TYPE,
                                           p_sql_name              IN OUT   VARCHAR2,
                                           p_line_dep              IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                           p_intm_dep              IN OUT   giac_module_entries.intm_type_level%TYPE,
                                           p_ca_dep                IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                           p_item_no               IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_dcwv,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_def_credit_wvat';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_dcwv;
          
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    --to handle deferred withholding vat payable on Foreign RI --lina01202006
    PROCEDURE bae2_create_def_wvat_payable (p_prod_date             IN       DATE,
                                            p_new_prod_date         IN OUT   DATE,
                                            p_process               IN OUT   VARCHAR2,
                                            p_msg                   IN OUT   VARCHAR2,
                                            p_module_item_no_dwvp   IN OUT   giac_module_entries.item_no%TYPE,
                                            p_module_name           IN OUT   giac_modules.module_name%TYPE,
                                            p_sql_name              IN OUT   VARCHAR2,
                                            p_line_dep              IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                            p_intm_dep              IN OUT   giac_module_entries.intm_type_level%TYPE,
                                            p_ca_dep                IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                            p_item_no               IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_dwvp,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_def_wvat_payable';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_dwvp;
          
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
    END;
    
    /* judyann 07162008; for generation of premium tax accounting entries */
    PROCEDURE bae2_create_prem_tax (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_pt   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE)
    IS
       PATH                        VARCHAR2 (100);
       var_gl_acct_category        giac_module_entries.gl_acct_category%TYPE;
       var_gl_control_acct         giac_module_entries.gl_control_acct%TYPE;
       var_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
       var_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
       var_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
       var_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
       var_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
       var_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
       var_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
       var_intm_type_level         giac_module_entries.intm_type_level%TYPE;
       var_ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE;
       var_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
       var_old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE;
       var_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
    BEGIN
       bae_get_module_parameters (p_module_item_no_pt,
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

       IF var_gl_acct_category IS NOT NULL
       THEN
          p_sql_name := 'bae2_create_prem_tax';
          p_line_dep := NVL (var_line_dependency_level, 0);
          p_intm_dep := NVL (var_intm_type_level, 0);
          p_ca_dep := NVL (var_ca_treaty_type_level, 0);
          p_item_no := p_module_item_no_pt;
          
          GIACB002_PKG.run_sql_report (path,
                          p_prod_date,
                          p_new_prod_date,
                          p_sql_name,
                          p_line_dep,
                          p_intm_dep,
                          p_item_no,
                          p_ca_dep,
                          p_msg);
          
          p_sql_name := NULL;
          p_line_dep := NULL;
          p_intm_dep := NULL;
          p_ca_dep := NULL;
          p_item_no := NULL;
       END IF;
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
    /*  select sum(debit_amt) - sum(credit_amt)
      into v_balance
      from giac_temp_acct_entries;

      if nvl(v_balance,0) != 0 then
        message('Allocating to miscellaenous amount...',no_acknowledge);
        --msg_alert('Debit amounts and credit amounts are not balanced.','i',false);
      end if;*/--Vincent 051205: comment out, added codes below to check and adjust debit and credit.

       /* modified by mikel 07.26.2011 */
    /* directly check discrepancies in giac_acct_entries */
    /* to handle rounding off of amounts when transferring entries from temp table to acct_entries */

       --Loop through the values of the amounts of the UW prod
       FOR c IN (SELECT   a.tran_id, a.gibr_branch_cd, SUM (b.debit_amt) deb_amt,
                          SUM (b.credit_amt) cre_amt
                     --FROM giac_temp_acct_entries b, giac_acctrans a
                 FROM     giac_acct_entries b, giac_acctrans a --mikel 07.26.2011
                    WHERE 1 = 1
                      AND a.tran_id = b.gacc_tran_id
                      AND a.tran_flag = 'C'
                      AND a.tran_class = 'UW'
                      AND a.tran_date = p_prod_date
                 GROUP BY a.tran_id, a.gibr_branch_cd)
       LOOP
          v_balance := c.deb_amt - c.cre_amt;

          IF v_balance != 0
          THEN
             IF ABS (v_balance) > 10
             THEN
                p_msg := p_msg ||'#Note: The miscellaenous amount being allocated is greater than 10.';
                
                IF v_balance > 0     -- added if-else : SR-4821 shan 08.04.2015
                   THEN
                      p_balance := v_balance;
                      adjust (c.tran_id,
                              p_module_item_no_inc_adj,
                              c.gibr_branch_cd,
                              p_module_item_no_Exp_adj, 
                              p_module_name,    
                              p_fund_cd,        
                              p_module_item_no_Inc_adj, 
                              p_user_id,        
                              p_balance);
                   ELSIF v_balance < 0
                   THEN
                      p_balance := v_balance;
                      adjust (c.tran_id,
                              p_module_item_no_exp_adj,
                              c.gibr_branch_cd,
                              p_module_item_no_Exp_adj, 
                              p_module_name,    
                              p_fund_cd,        
                              p_module_item_no_Inc_adj, 
                              p_user_id,        
                              p_balance);
                END IF;
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
                              p_module_item_no_Exp_adj, 
                              p_module_name,    
                              p_fund_cd,        
                              p_module_item_no_Inc_adj, 
                              p_user_id,        
                              p_balance);
                   ELSIF v_balance < 0
                   THEN
                      p_balance := v_balance;
                      adjust (c.tran_id,
                              p_module_item_no_exp_adj,
                              c.gibr_branch_cd,
                              p_module_item_no_Exp_adj, 
                              p_module_name,    
                              p_fund_cd,        
                              p_module_item_no_Inc_adj, 
                              p_user_id,        
                              p_balance);
                   END IF;
                END IF;
             END IF;
          END IF;
       END LOOP;
    END;
    
    --Vincent 051205: added this procedure which was taken from giacb003
--to generate entries to adjust currency conversion/rounding off differences during production take up

/* modified by mikel 07.26.2011 */
/* directly insert into giac_acct_entries */
/* to handle rounding off of amounts when transferring entries from temp table to acct_entries */

    PROCEDURE adjust (v_tran_id                  IN   giac_acctrans.tran_id%TYPE,
                      v_module_item_no           IN   giac_module_entries.item_no%TYPE,
                      v_branch_cd                IN   giac_acctrans.gibr_branch_cd%TYPE,
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
         FROM giac_temp_acct_entries                              --Vincent 051205
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
          --INSERT INTO giac_temp_acct_entries --mikel 07.26.2011; comment out
          INSERT INTO giac_acct_entries                         --mikel 07.26.2011
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
          --INSERT INTO giac_temp_acct_entries --mikel 07.26.2011; comment out
          INSERT INTO giac_acct_entries                         --mikel 07.26.2011
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
    
    PROCEDURE update_giuw_pol_dist (p_prod_date IN DATE, 
                                    p_new_prod_date IN DATE)
    IS
    BEGIN
       FOR ja1 IN (SELECT DISTINCT dist_no, tk_up_type
                              FROM giac_treaty_batch_ext)
       LOOP
          IF ja1.tk_up_type = 'P'
          THEN
             UPDATE giuw_pol_dist
                SET acct_ent_date = NVL (p_new_prod_date, p_prod_date)
              WHERE dist_no = ja1.dist_no
                AND acct_neg_date IS NULL
                AND acct_ent_date IS NULL;
          ELSIF ja1.tk_up_type = 'N'
          THEN
             UPDATE giuw_pol_dist
                SET acct_neg_date = NVL (p_new_prod_date, p_prod_date)
              WHERE dist_no = ja1.dist_no
                AND acct_ent_date IS NOT NULL
                AND acct_neg_date IS NULL;
          END IF;
       END LOOP ja1;

       FOR ja2 IN
          (
          -- modified by judyann 02122010; to handle take-up of long-term policies
           SELECT DISTINCT b.dist_no, b.dist_flag, b.negate_date, b.acct_ent_date,
                           b.acct_neg_date
                      FROM gipi_polbasic a, gipi_invoice c, giuw_pol_dist b
                     WHERE a.policy_id = b.policy_id
                       AND a.policy_id = c.policy_id
                       AND NVL (c.takeup_seq_no, 1) = NVL (b.takeup_seq_no, 1)
                       /*AND ((a.acct_ent_date IS NOT NULL
                           AND TRUNC(a.acct_ent_date) <= TRUNC(:prod.cut_off_date))
                         OR ( a.spld_acct_ent_date IS NOT NULL
                           AND TRUNC(a.spld_acct_ent_date) <= TRUNC(:prod.cut_off_date) )))*/
                       AND (   (    c.acct_ent_date IS NOT NULL
                                AND TRUNC (c.acct_ent_date) <= TRUNC (p_prod_date)
                               )
                            OR (    c.spoiled_acct_ent_date IS NOT NULL
                                AND TRUNC (c.spoiled_acct_ent_date) <=
                                                               TRUNC (p_prod_date)
                               )
                           ))
       LOOP
          IF     ja2.acct_ent_date IS NOT NULL
             AND ja2.acct_neg_date IS NULL
             AND ja2.dist_flag IN
                     ('4', '5') -- judyann 05082006; also considered redistributed
          --and trunc(ja2.negate_date) <= trunc(:prod.cut_off_date)
          THEN
             UPDATE giuw_pol_dist
                SET acct_neg_date = NVL (p_new_prod_date, p_prod_date)
              WHERE dist_no = ja2.dist_no
                AND acct_ent_date IS NOT NULL
                AND dist_flag IN ('4', '5');
                                -- judyann 05082006; also considered redistributed
          ELSIF     ja2.acct_ent_date IS NULL
                AND ja2.acct_neg_date IS NULL
                AND ja2.dist_flag = '3'
          THEN
             UPDATE giuw_pol_dist
                SET acct_ent_date = NVL (p_new_prod_date, p_prod_date)
              WHERE dist_no = ja2.dist_no
                AND acct_ent_date IS NULL
                AND acct_neg_date IS NULL
                AND negate_date IS NULL
                AND dist_flag = '3';
          END IF;
       END LOOP ja2;
    END;
END;
/


