CREATE OR REPLACE PROCEDURE CPI.Extract_Soa_Rep2
  (p_special_pol    VARCHAR2,
   p_branch_cd      VARCHAR2,
   p_intm_no        NUMBER,
   p_intm_type      VARCHAR2,
   p_assd_no        NUMBER,
   p_rep_date       VARCHAR2,
   p_book_tag       VARCHAR2,
   p_book_date_fr   DATE,
   p_book_date_to   DATE,
   p_incep_tag      VARCHAR2,
   p_incep_date_fr  DATE,
   p_incep_date_to  DATE,
   p_issue_tag      VARCHAR2,
   p_issue_date_fr  DATE,
   p_issue_date_to  DATE,
   p_date_as_of     DATE,
   p_cut_off_date   DATE,
   p_inc_pdc        VARCHAR2,
   p_row_counter    OUT NUMBER,
   p_extract_days   NUMBER,          --mod1 start/end
   p_branch_param   VARCHAR2,
   p_user_id        VARCHAR2,
   p_payt_date      VARCHAR2    -- shan 12.09.2014 : based on ENH by RCDatu
  )
AS
   c1_collection_amt        NUMBER;
   c1_prem_amt              NUMBER; 
   c1_tax_amt               NUMBER;
   TYPE t_giac_soa_rec      IS RECORD (iss_cd            GIAC_SOA_PDC_EXT.iss_cd%TYPE,
                                       prem_seq_no       GIAC_SOA_PDC_EXT.prem_seq_no%TYPE,
                                       inst_no           GIAC_SOA_PDC_EXT.inst_no%TYPE ,
                                       check_no          GIAC_SOA_PDC_EXT.check_no%TYPE   ,
                                       Check_Date        GIAC_SOA_PDC_EXT.Check_Date%TYPE ,
                                       pdc_amt           GIAC_SOA_PDC_EXT.pdc_amt%TYPE  ,
                                       user_id           GIAC_SOA_PDC_EXT.user_id%TYPE,
                                       last_update       GIAC_SOA_PDC_EXT.last_update%TYPE  
                                      );
   TYPE t_giac_soa_tab            IS TABLE OF t_giac_soa_rec  ;  
   v_giac_soa_tab                 t_giac_soa_tab:= t_giac_soa_tab() ;             
   TYPE t_giac_rec                IS RECORD (fund_cd             GIAC_SOA_REP_EXT.fund_cd%TYPE,
                                            branch_cd           GIAC_SOA_REP_EXT.branch_cd%TYPE,
                                            intm_no             GIAC_SOA_REP_EXT.intm_no%TYPE,
                                            intm_name           GIAC_SOA_REP_EXT.intm_name%TYPE,
                                            intm_type           GIAC_SOA_REP_EXT.intm_type%TYPE,
                                            assd_no             GIAC_SOA_REP_EXT.assd_no%TYPE,
                                            assd_name           GIAC_SOA_REP_EXT.assd_name%TYPE,
                                            policy_no           GIAC_SOA_REP_EXT.policy_no%TYPE,
                                            iss_cd              GIAC_SOA_REP_EXT.iss_cd%TYPE,
                                            prem_seq_no         GIAC_SOA_REP_EXT.prem_seq_no%TYPE,
                                            inst_no             GIAC_SOA_REP_EXT.inst_no%TYPE,
                                            due_date            GIAC_SOA_REP_EXT.due_date%TYPE,
                                            param_date          GIAC_SOA_REP_EXT.param_date%TYPE,
                                            aging_id            GIAC_SOA_REP_EXT.aging_id%TYPE,
                                            column_no           GIAC_SOA_REP_EXT.column_no%TYPE,
                                            column_title        GIAC_SOA_REP_EXT.column_title%TYPE,
                                            balance_amt_due     GIAC_SOA_REP_EXT.balance_amt_due%TYPE,
                                            prem_bal_due        GIAC_SOA_REP_EXT.prem_bal_due%TYPE,  
                                            tax_bal_due         GIAC_SOA_REP_EXT.tax_bal_due%TYPE,
                                            ref_pol_no          GIAC_SOA_REP_EXT.ref_pol_no%TYPE,
                                            ref_inv_no          GIAC_SOA_REP_EXT.ref_inv_no%TYPE, 
                                            user_id             GIAC_SOA_REP_EXT.user_id%TYPE,
                                            last_update         GIAC_SOA_REP_EXT.last_update%TYPE,
                                            no_of_days          GIAC_SOA_REP_EXT.no_of_days%TYPE,
                                            from_date1          GIAC_SOA_REP_EXT.from_date1%TYPE,
                                            to_date1            GIAC_SOA_REP_EXT.to_date1%TYPE,
                                            from_date2          GIAC_SOA_REP_EXT.from_date2%TYPE,
                                            to_date2            GIAC_SOA_REP_EXT.to_date2%TYPE,
                                            date_tag            GIAC_SOA_REP_EXT.date_tag%TYPE,
                                            due_tag             GIAC_SOA_REP_EXT.due_tag%TYPE,
                                            lic_tag             GIAC_SOA_REP_EXT.lic_tag%TYPE,
                                            parent_intm_no      GIAC_SOA_REP_EXT.parent_intm_no%TYPE,
                                            spld_date           GIAC_SOA_REP_EXT.spld_date%TYPE,
                                            incept_date         GIAC_SOA_REP_EXT.incept_date%TYPE,
                                            expiry_date         GIAC_SOA_REP_EXT.expiry_date%TYPE,
                                            as_of_date          GIAC_SOA_REP_EXT.as_of_date%TYPE,
                                            afterdate_coll      GIAC_SOA_REP_EXT.afterdate_coll%TYPE,
                                            afterdate_prem      GIAC_SOA_REP_EXT.afterdate_prem%TYPE,
                                            afterdate_tax       GIAC_SOA_REP_EXT.afterdate_tax%TYPE                                     
                                           );
  
  TYPE t_giac_tab               IS TABLE OF t_giac_rec ; 
  v_giac_tab                    t_giac_tab:=t_giac_tab();          
  TYPE t_check_user             IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
  v_check_user                  t_check_user;
  v_row_counter                 NUMBER := 0;  
  v_intm_name                   GIAC_SOA_REP_EXT.intm_name%TYPE;
  v_age                         GIAC_AGING_PARAMETERS.max_no_days%TYPE;
  v_inst_no                     GIAC_SOA_REP_EXT.inst_no%TYPE;
  v_iss_cd                      GIAC_SOA_REP_EXT.iss_cd%TYPE;
  v_prem_seq_no                 GIAC_SOA_REP_EXT.prem_seq_no%TYPE;
  v_aging_id                    GIAC_SOA_REP_EXT.aging_id%TYPE;
  v_balance_amt_due             GIAC_SOA_REP_EXT.balance_amt_due%TYPE := 0;
  v_fund_cd                     GIAC_PARAMETERS.param_value_v%TYPE;
  v_intm_type                   GIIS_INTERMEDIARY.intm_type%TYPE;
  v_column_no                   GIAC_SOA_REP_EXT.column_no%TYPE;
  v_column_title                GIAC_SOA_REP_EXT.column_title%TYPE;
  v_prem_bal_due                GIAC_SOA_REP_EXT.prem_bal_due%TYPE := 0;
  v_tax_bal_due                 GIAC_SOA_REP_EXT.tax_bal_due%TYPE := 0;
  v_inv_no                      GIAC_SOA_REP_EXT.ref_inv_no%TYPE;
  /*variables used for date/tag parameters*/
  v_date_tag                    GIAC_SOA_REP_EXT.date_tag%TYPE;
  v_from_date1                  GIAC_SOA_REP_EXT.from_date1%TYPE;
  v_to_date1                    GIAC_SOA_REP_EXT.to_date1%TYPE;
  v_from_date2                  GIAC_SOA_REP_EXT.from_date2%TYPE;
  v_to_date2                    GIAC_SOA_REP_EXT.to_date2%TYPE;
  /*temporary solution*/
  v_temp_col  NUMBER;
  /*for the filtering of due and not due installments*/
  v_due_tag                     GIAC_SOA_REP_EXT.due_tag%TYPE;
  /*for the parent_intm_no and the lic_tag*/
  v_parent_intm_no              GIIS_INTERMEDIARY.parent_intm_no%TYPE;
  v_lic_tag                     GIIS_INTERMEDIARY.lic_tag%TYPE;
  var_parent_intm_no            GIIS_INTERMEDIARY.parent_intm_no%TYPE;
  var_lic_tag                   GIIS_INTERMEDIARY.lic_tag%TYPE;
  var_intm_no                   GIIS_INTERMEDIARY.intm_no%TYPE;
  v_date_as_of                  GIAC_SOA_REP_EXT.as_of_date%TYPE;
  v_afterdate_coll              GIAC_SOA_REP_EXT.afterdate_coll%TYPE := 0;
  v_afterdate_prem              GIAC_SOA_REP_EXT.afterdate_prem%TYPE := 0;
  v_afterdate_tax               GIAC_SOA_REP_EXT.afterdate_tax%TYPE := 0;
  iss_cd_var                    GIPI_INVOICE.iss_cd%TYPE;
  prem_seq_var                  GIPI_INVOICE.prem_seq_no%TYPE;
  v_intm_no                     GIIS_INTERMEDIARY.intm_no%TYPE;                                          
  TYPE policy_id_tab            IS TABLE OF GIPI_POLBASIC.policy_id%TYPE;
  TYPE policy_no_tab            IS TABLE OF VARCHAR2(50);
  TYPE assd_no_tab              IS TABLE OF GIPI_PARLIST.assd_no%TYPE;
  TYPE iss_cd_tab               IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
  TYPE iss_cd_pol_tab           IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;  --koks 9.4.2015 SR 20068
  TYPE line_cd_tab              IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
  TYPE subline_cd_tab           IS TABLE OF GIPI_POLBASIC.subline_cd%TYPE;
  TYPE issue_yy_tab             IS TABLE OF GIPI_POLBASIC.issue_yy%TYPE;
  TYPE renew_no                 IS TABLE OF GIPI_POLBASIC.renew_no%TYPE;
  TYPE pol_seq_no               IS TABLE OF GIPI_POLBASIC.pol_seq_no%TYPE;
  TYPE line_name_tab            IS TABLE OF GIIS_LINE.line_name%TYPE;
  TYPE acct_ent_date_tab        IS TABLE OF GIPI_POLBASIC.acct_ent_date%TYPE;
  TYPE ref_pol_no_tab           IS TABLE OF GIPI_POLBASIC.ref_pol_no%TYPE;
  TYPE incept_date_tab          IS TABLE OF GIPI_POLBASIC.incept_date%TYPE;
  TYPE issue_date_tab           IS TABLE OF GIPI_POLBASIC.issue_date%TYPE;
  TYPE spld_date_tab            IS TABLE OF GIPI_POLBASIC.spld_date%TYPE;
  TYPE pol_flag_tab             IS TABLE OF GIPI_POLBASIC.pol_flag%TYPE;
  TYPE eff_date_tab             IS TABLE OF GIPI_POLBASIC.eff_date%TYPE;
  TYPE expiry_date_tab          IS TABLE OF GIPI_POLBASIC.expiry_date%TYPE;
  TYPE assd_name_tab            IS TABLE OF GIIS_ASSURED.assd_name%TYPE;
  TYPE reg_policy_sw_tab        IS TABLE OF GIPI_POLBASIC.reg_policy_sw%TYPE;
  TYPE endt_type_tab            IS TABLE OF GIPI_POLBASIC.endt_type%TYPE;
  TYPE spld_ent_date_tab IS TABLE OF gipi_polbasic.spld_acct_ent_date%TYPE;
                                                    -- shan 12.09.2014 : based on ENH by RCDatu 07.24.2014 (1.0)
  vv_policy_id                  policy_id_tab;
  vv_policy_no                  policy_no_tab;
  vv_assd_no                    assd_no_tab;
  vv_iss_cd                     iss_cd_tab;  
  vv_iss_cd_pol                 iss_cd_pol_tab; --koks 9.4.2015 SR 20068
  vv_line_cd                    line_cd_tab;
  vv_subline_cd                 subline_cd_tab;
  vv_issue_yy                   issue_yy_tab;
  vv_renew_no                   renew_no;
  vv_pol_seq_no                 pol_seq_no;
  vv_line_name                  line_name_tab;
  vv_acct_ent_date              acct_ent_date_tab;
  vv_ref_pol_no                 ref_pol_no_tab;
  vv_incept_date                incept_date_tab;
  vv_issue_date                 issue_date_tab;
  vv_spld_date                  spld_date_tab;
  vv_pol_flag                   pol_flag_tab;
  vv_eff_date                   eff_date_tab;
  vv_expiry_date                expiry_date_tab;
  vv_policy_id2                 policy_id_tab;
  vv_assd_no2                   assd_no_tab;
  vv_assd_name                  assd_name_tab;
  vv_reg_policy_sw              reg_policy_sw_tab;
  vv_endt_type                  endt_type_tab;
  vv_spld_ent_date              spld_ent_date_tab;          -- shan 12.09.2014 : based on ENH by RCDatu 07.24.2014 (1.0)
  
/*mod4*/
  v_share                       NUMBER;--GIPI_COMM_INVOICE.share_percentage%TYPE;
  ctr                           NUMBER := 0; 
  v_total_bal_due               GIAC_SOA_REP_EXT.balance_amt_due%TYPE;
  v_total_prem_due              GIAC_SOA_REP_EXT.prem_bal_due%TYPE;    
  v_total_tax_due               GIAC_SOA_REP_EXT.tax_bal_due%TYPE;  
  v_iss_cd2                     GIPI_INVOICE.iss_cd%TYPE;
  v_prem_seq_no2                GIPI_INVOICE.prem_seq_no%TYPE;
  ln_count                      NUMBER;
  CURSOR cr_count_intm (p_policy_id     GIPI_INVOICE.policy_id%TYPE,
                        p_iss_cd        GIPI_INVOICE.iss_cd%TYPE,
                        p_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE) IS
    SELECT COUNT (*)
    FROM   GIPI_COMM_INVOICE
    WHERE  policy_id = p_policy_id
    AND    iss_cd    = p_iss_cd
    AND    prem_seq_no = p_prem_seq_no
    AND    share_percentage != 0;
  
  CURSOR cr_sum_installment (p_policy_no    GIAC_SOA_REP_EXT.policy_no%TYPE,
                             p_inst_no      GIAC_SOA_REP_EXT.inst_no%TYPE) IS
    SELECT SUM(balance_amt_due),
           SUM(prem_bal_due),
           SUM(tax_bal_due)
    FROM   GIAC_SOA_REP_EXT
    WHERE  policy_no = p_policy_no
    AND    inst_no   = p_inst_no;      
  
  CURSOR cr_bill_main (p_policy_id        GIPI_INVOICE.policy_id%TYPE) IS
    SELECT iss_cd, prem_seq_no
    FROM   GIPI_INVOICE
    WHERE  policy_id = p_policy_id;
    
/*end of mod4*/

/*
** List of Application Errors:
**    -20200,'Unhandled value in determining dates in When-Button-Pressed.';
**    -20201,'No data found in giac_soa_title.';
*/
/*
** Created By:   Vincent
** Date Created: 081005
** Description:  This is the extract procedure for SOA. It was based on the when-button-pressed trigger
**   of the extract button in GIACS180. Transferred it to the db and modified it as part of optimization.
**   Also, it uses the view giac_soa_rep_v to optimize the SELECT, specially when using filters for assd_no,
**   intm_no, intm_type.
**  mod1
**   modified by:  a_poncedeleon
**  date:      07-20-06
**   purpose:   inclusion of new parameter p_extract_days for to hold extract days from GIACS180 for AC-SPECS-2006-074
**
**
**  mod2
**  modified by:  a_poncedeleon
**  date:      07-20-06
**  purpose:   added query for bill's/policy's age. (Age should be equal to or more than the specified/passed p_extract_days)
**
**
**  mod3
**  modified by:  a_poncedeleon
**  date:      07-26-06
**  purpose:   added insert to field extract_aging_days to table GIAC_SOA_REP_EXT_PARAM using p_extract_days value
**
**  mod4
**  modified by:       lina
**  date               08-07-2008
**  purpose            to insert all the intermediaries in case the policy has more than one intermediary
*/

/* judyann 12052008; 
** added option for branch, whether issuing source or crediting branch 
*/

BEGIN
  /*This part adds the other parameter dates/tag to the inserted records**
  **so that when incept date or issue date is used, or any other        **
  **extract date for that matter,it will be recorded in the database    **
  **                   (DATE/TAG PARAMETERS)                            */
  BEGIN
    IF p_rep_date = 'F' THEN
      IF (p_book_tag IS NULL OR p_book_tag = 'N') THEN
        SELECT DECODE(p_issue_date_fr, NULL, p_incep_date_fr, p_issue_date_fr)
          INTO v_from_date1
          FROM dual;
        SELECT DECODE(p_issue_date_to, NULL, p_incep_date_to, p_issue_date_to)
          INTO v_to_date1
          FROM dual;
        /*SELECT DECODE(p_issue_tag, NULL, 'IN', 'N', 'IN','IS')
          INTO v_date_tag
          FROM dual;*/
          IF p_issue_tag IS NULL  OR p_issue_tag ='N' 
          THEN
              v_date_tag := 'IN';
          ELSE
              v_date_tag := 'IS' ;
          END IF;
      ELSE
        IF (p_incep_tag IS NULL OR p_incep_tag = 'N') THEN
          v_from_date1 := p_book_date_fr;
          v_to_date1   := p_book_date_to;
          v_from_date2 := p_issue_date_fr;
          v_to_date2   := p_issue_date_to;
          SELECT DECODE(p_issue_tag, 'N', 'BK', NULL,'BK', 'BKIS')
            INTO v_date_tag
            FROM dual;
        ELSIF (p_issue_tag IS NULL OR p_issue_tag = 'N') THEN
          v_from_date1 := p_book_date_fr;
          v_to_date1   := p_book_date_to;
          v_from_date2 := p_incep_date_fr;
          v_to_date2   := p_incep_date_to;
          SELECT DECODE(p_incep_tag, 'N', 'BK', NULL, 'BK','BKIN')
            INTO v_date_tag
            FROM dual;
        ELSE
          RAISE_APPLICATION_ERROR(-20200,'UNHANDLED VALUE IN DETERMINING DATES IN WHEN-BUTTON-PRESSED.');
        END IF;
     END IF;
      v_date_as_of := NULL;
    ELSE
      IF (p_book_tag IS NULL OR p_book_tag = 'N') THEN
        SELECT DECODE(p_issue_tag, NULL, 'IN', 'N', 'IN','IS')
          INTO v_date_tag
          FROM dual;
      ELSE
        IF (p_incep_tag IS NULL OR p_incep_tag = 'N') THEN
          SELECT DECODE(p_issue_tag, 'N', 'BK', NULL,'BK', 'BKIS')
            INTO v_date_tag
            FROM dual;
        ELSIF (p_issue_tag IS NULL OR p_issue_tag = 'N') THEN
          SELECT DECODE(p_incep_tag, 'N', 'BK', NULL, 'BK','BKIN')
            INTO v_date_tag
            FROM dual;
        ELSE
          RAISE_APPLICATION_ERROR(-20200,'UNHANDLED VALUE IN DETERMINING DATES IN WHEN-BUTTON-PRESSED.');
     END IF;
     END IF;
      v_from_date1 := NULL;
      v_to_date1   := NULL;
      v_from_date2 := NULL;
      v_to_date2   := NULL;
      v_date_as_of := p_date_as_of;
 END IF;
  END; --(DATE/TAG PARAMETERS)
  /*Delete record in extract parameter table*/
  DELETE FROM GIAC_SOA_REP_EXT_PARAM
   WHERE user_id = p_user_id; --USER;
  /*Delete records in extract table for the current user*/
  DELETE FROM GIAC_SOA_REP_EXT
   WHERE user_id = p_user_id; --USER;
   --IF p_inc_pdc = 'Y' THEN     -- removed condition, records should be deleted per extraction as per Albert : shan 11.27.2014
    DELETE FROM GIAC_SOA_PDC_EXT
     WHERE user_id = p_user_id; --USER;
  --END IF;
  
  DELETE FROM GIAC_SOA_REP_TAX_EXT  -- added, records should be deleted per extraction as per Albert : shan 11.27.2014
     WHERE user_id = p_user_id;
     COMMIT;
  /*Get fund_cd */
  FOR c IN (SELECT param_value_v
              FROM GIAC_PARAMETERS
             WHERE param_name = 'FUND_CD')
  LOOP
    v_fund_cd := c.param_value_v;
    EXIT;
  END LOOP;
   /*Get the records*/    
  WITH A AS (/*+ materialize */
               SELECT a.policy_id, get_policy_no (a.policy_id) policy_no,
                a.assd_no, a.cred_branch, a.line_cd, a.subline_cd, a.iss_cd,
                a.issue_yy, a.renew_no, a.pol_seq_no, b.line_name,
                a.acct_ent_date, a.ref_pol_no, a.incept_date, a.issue_date,
                a.spld_date, a.pol_flag, a.eff_date, a.expiry_date,
                DECODE ((SELECT 'X' endt_tax_count
                           FROM gipi_endttext
                          WHERE policy_id = a.policy_id AND endt_tax = 'Y'),
                        'X', (SELECT policy_id
                                FROM gipi_polbasic
                               WHERE line_cd = a.line_cd
                                 AND subline_cd = a.subline_cd
                                 AND iss_cd = a.iss_cd
                                 AND issue_yy = a.issue_yy
                                 AND renew_no = a.renew_no
                                 AND pol_seq_no = a.pol_seq_no
                                 AND endt_seq_no = 0),
                        a.policy_id
                       ) policy_id2,
                NULL assd_no2, NULL assd_name2, a.reg_policy_sw, a.endt_type, a.SPLD_ACCT_ENT_DATE
           FROM gipi_polbasic a, giis_line b, gipi_parlist c, giis_subline d
          WHERE a.line_cd = b.line_cd
            AND b.line_cd = d.line_cd
            AND a.line_cd = d.line_cd
            AND a.subline_cd = d.subline_cd
            AND a.par_id = c.par_id
            AND a.policy_id >= 0
            AND c.par_id >= 0
            AND a.iss_cd != 'RI'
            AND d.op_flag != 'Y'
            AND extract_soa_rep2_pkg.validates (p_date_as_of,
                                                p_book_tag,
                                                p_incep_tag,
                                                p_issue_tag,
                                                p_rep_date,
                                                a.acct_ent_date,
                                                p_book_date_fr,
                                                p_book_date_to,
                                                a.incept_date,
                                                p_incep_date_fr,
                                                p_incep_date_to,
                                                p_issue_date_fr,
                                                p_issue_date_to,
                                                p_special_pol,
                                                p_branch_param,
                                                a.issue_date
                                               ) = 1          
  
            )                    
  SELECT policy_id,
         policy_no,
         assd_no,
         iss_cd, --koks 9.4.2015 SR 20068
         DECODE(p_branch_param,'I',iss_cd,cred_branch) branch,
         line_cd,
         subline_cd,
         issue_yy,
         renew_no,
         pol_seq_no,
         line_name,
         acct_ent_date,
         ref_pol_no,
         incept_DATE,
         issue_date,
         spld_date,
         pol_flag,
         eff_date,
         expiry_date,
         policy_id2,
         assd_no2,
         NULL assd_name,
         reg_policy_sw,
         endt_type,
         spld_acct_ent_date                         -- shan 12.09.2014 : based on ENH by RCDatu 07.24.2014 (1.0)
  BULK COLLECT
    INTO vv_policy_id,
         vv_policy_no,
         vv_assd_no,
         vv_iss_cd_pol, --koks 9.4.2015 SR 20068
         vv_iss_cd,
         vv_line_cd,
         vv_subline_cd,
         vv_issue_yy,
         vv_renew_no,
         vv_pol_seq_no,
         vv_line_name,
         vv_acct_ent_date,
         vv_ref_pol_no,
         vv_incept_date,
         vv_issue_date,
         vv_spld_date,
         vv_pol_flag,
         vv_eff_date,
         vv_expiry_date,
         vv_policy_id2,
         vv_assd_no2,
         vv_assd_name,
         vv_reg_policy_sw,
         vv_endt_type,
         vv_spld_ent_date                           -- shan 12.09.2014 : based on ENH by RCDatu 07.24.2014 (1.0)
    FROM   A
      WHERE 1=1
        AND reg_policy_sw = DECODE(p_special_pol, 'Y', reg_policy_sw,'Y')
        AND NVL(endt_type, 'A') = 'A' 
        AND DECODE(p_branch_param,'I',iss_cd,cred_branch) = NVL(p_branch_cd,DECODE(p_branch_param,'I',iss_cd,cred_branch))   -- judyann 12052008
		--AND NVL (assd_no2, 1) = NVL (p_assd_no, NVL (assd_no2, 1)) --replaced by codes below; robert 10.28.15 GENQA 5135 -- shan 12.09.2014 : based on ENH by RCDatu 07.24.2014 (2.0) 
        AND NVL (assd_no, 1) = NVL (p_assd_no, NVL (assd_no, 1)) --added by robert 10.28.15 GENQA 5135
        AND EXISTS (SELECT 'X'
                      FROM GIPI_COMM_INVOICE aa,
                           GIIS_INTERMEDIARY bb
                     WHERE aa.policy_id = policy_id2
                       AND aa.intrmdry_intm_no = bb.intm_no
                       AND intrmdry_intm_no = NVL(p_intm_no, intrmdry_intm_no)
                       AND intm_type = NVL(p_intm_type, intm_type)
                       AND ROWNUM=1);
          
/* added by jason 02/04/2009 end*/
  
  IF SQL% FOUND THEN   
      FOR cur1 IN vv_policy_id.FIRST..vv_policy_id.LAST
      LOOP
          IF v_check_user.EXISTS(vv_iss_cd(cur1)) =FALSE 
          THEN
                v_check_user(vv_iss_cd(cur1)):= check_user_per_iss_cd_acctg2 (NULL, vv_iss_cd(cur1), 'GIACS180', p_user_id) ;
              
          END IF;
                      
          IF v_check_user(vv_iss_cd(cur1)) !=1 
          THEN 
                GOTO NEXT_REC;
          END IF;  
        BEGIN  
                 SELECT z.assd_name, y.assd_no
                   INTO vv_assd_name(cur1), vv_assd_no2(cur1)
                   FROM gipi_polbasic x, gipi_parlist y, giis_assured z
                  WHERE x.par_id = y.par_id
                    AND y.assd_no = z.assd_no
                    AND x.line_cd = vv_line_cd(cur1)
                    AND x.subline_cd = vv_subline_cd(cur1)
                    AND x.iss_cd = vv_iss_cd_pol(cur1) --koks 9.4.2015 SR 20068
                    AND x.issue_yy = vv_issue_yy(cur1)
                    AND x.renew_no = vv_renew_no(cur1)
                    AND x.pol_seq_no = vv_pol_seq_no(cur1)
                    AND x.endt_seq_no =
                           (SELECT MAX (endt_seq_no)
                              FROM gipi_polbasic
                             WHERE line_cd = vv_line_cd(cur1)
                               AND subline_cd = vv_subline_cd(cur1)
                               AND iss_cd = vv_iss_cd_pol(cur1) --koks 9.4.2015 SR 20068
                               AND issue_yy = vv_issue_yy(cur1)
                               AND renew_no = vv_renew_no(cur1)
                               AND pol_seq_no = vv_pol_seq_no(cur1));
        EXCEPTION
        WHEN OTHERS THEN        
              NULL;          
        END;                    
        --------------------------------------------------------------------
        IF ((vv_spld_date(cur1) IS NULL) OR
            (TRUNC(vv_spld_date(cur1)) > p_cut_off_date AND vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '5')
             OR (vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '1')
             -- added by shan 12.09.2014 : based on ENH by RCDatu
             OR (    vv_spld_date (cur1) IS NOT NULL
                 AND vv_pol_flag (cur1) = '5'
                 AND TRUNC (vv_spld_ent_date (cur1)) > p_cut_off_date
                )    --RCDatu 07.24.2014 (1.0)
             ) --to include policies that is only tagged for spoilage has spoiled date but pol flag is still 1*/
        THEN
          FOR cur2a IN (SELECT iss_cd, prem_seq_no, ref_inv_no
                          FROM GIPI_INVOICE
                         WHERE policy_id = vv_policy_id(cur1))
        LOOP
            iss_cd_var := cur2a.iss_cd;
            prem_seq_var := cur2a.prem_seq_no;
            v_inv_no := cur2a.ref_inv_no;           
      
            /*MOD 4 to check whether the policy id is a tax endorsement. If it is a tax endorsement then get the 
            original bill no, this will be use to get the intermediary */
            v_iss_cd2      := NULL;
            v_prem_seq_no2 := NULL;                                                 
            IF vv_policy_id(cur1) <> vv_policy_id2(cur1) THEN
              OPEN  cr_bill_main(vv_policy_id2(cur1));
              FETCH cr_bill_main INTO v_iss_cd2, v_prem_seq_no2;
              CLOSE cr_bill_main;
            
              OPEN  cr_count_intm(vv_policy_id2(cur1), cur2a.iss_cd, cur2a.prem_seq_no);
              FETCH cr_count_intm INTO ln_count;
              CLOSE cr_count_intm;                    
            ELSE
              OPEN  cr_count_intm(vv_policy_id(cur1), cur2a.iss_cd, cur2a.prem_seq_no);
              FETCH cr_count_intm INTO ln_count;
              CLOSE cr_count_intm;            
            END IF; 
            
             FOR c IN (SELECT intm_name, intm_type, A.parent_intm_no, lic_tag, b.intrmdry_intm_no intm_no, b.share_percentage
                          FROM GIIS_INTERMEDIARY A, GIPI_COMM_INVOICE b
                         WHERE A.intm_no     = b.intrmdry_intm_no
                           AND b.policy_id   = vv_policy_id2(cur1)
                           AND b.iss_cd      = NVL(v_iss_cd2,cur2a.iss_cd) /*MOD4--to fetch the intermediary by policy id and bill_no*/ 
                           AND b.prem_seq_no = NVL(v_prem_seq_no2,cur2a.prem_seq_no)
                           AND A.intm_no     = NVL(p_intm_no, A.intm_no)    -- added to extract based on intm_no and intm_type : shan 11.25.2014
                           AND A.intm_type   = NVL(p_intm_type, A.intm_type)
                           AND b.share_percentage <> 0
                           )
              LOOP
                ctr              := ctr + 1;
                v_intm_name      := c.intm_name;
                v_intm_type      := c.intm_type;
                v_lic_tag        := c.lic_tag;
                v_parent_intm_no := c.parent_intm_no;
                v_intm_no        := c.intm_no;
                v_share          := c.share_percentage/100; -- to get the share percentage per intermediary /*MOD4*/
                --This part will get the parent_intm of the intermediary
                IF v_lic_tag  = 'Y' THEN
                  v_parent_intm_no := c.intm_no;
                  v_lic_tag        := 'Y';
                ELSIF v_lic_tag  = 'N' THEN
                  IF v_parent_intm_no IS NULL THEN
                    v_parent_intm_no := c.intm_no;
                    v_lic_tag := 'N';
                  ELSE  --check for the nearest licensed parent intm no
                    var_lic_tag := v_lic_tag;
                    WHILE var_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL LOOP
                      BEGIN
                        SELECT intm_no,
                               parent_intm_no,
                               lic_tag
                          INTO var_intm_no,
                               var_parent_intm_no,
                               var_lic_tag
                          FROM GIIS_INTERMEDIARY
                         WHERE intm_no = v_parent_intm_no;
                        v_parent_intm_no := var_parent_intm_no;
                        IF var_lic_tag = 'Y' THEN
                          v_parent_intm_no := var_intm_no;
                          EXIT;
                        ELSE
                          NULL;
                        END IF;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                          v_parent_intm_no := var_intm_no;
                          EXIT;
                      END;
                    END LOOP;
                  END IF;
                END IF;
                
                FOR cur3 IN (SELECT due_date, inst_no, prem_amt
                               FROM GIPI_INSTALLMENT
                              WHERE iss_cd = iss_cd_var
                                AND prem_seq_no = prem_seq_var
                AND NVL(p_extract_days, 99999) >= ((p_cut_off_date) - TRUNC(due_date))  -- mod2 start/end
                              ORDER BY inst_no)
                LOOP
                  v_age         := ((p_cut_off_date) - TRUNC(cur3.due_date));
                  v_inst_no     := cur3.inst_no;
                  v_iss_cd      := iss_cd_var;
                  v_prem_seq_no := prem_seq_var;
                  v_aging_id    := 0;
                 /* Get the corresponding rep_col_no */
                  IF (p_cut_off_date - cur3.due_date) <= 0 THEN
                  --get aging_id and rep_col_no when not overdue
                    FOR A IN (SELECT aging_id, rep_col_no
                                FROM GIAC_AGING_PARAMETERS
                               WHERE (ABS(v_age) BETWEEN min_no_days AND max_no_days)
                                 AND gibr_branch_cd = v_iss_cd
                                 AND over_due_tag = 'N')
                    LOOP
                      v_aging_id  := A.aging_id;
                      v_column_no := A.rep_col_no;
                      v_due_tag   := 'N';
                      EXIT;
                    END LOOP;
                  ELSIF(p_cut_off_date - cur3.due_date) > 0 THEN -- overdue records
                  --get aging_id and rep_col_no when overdue
                    FOR b IN (SELECT aging_id, rep_col_no
                                FROM GIAC_AGING_PARAMETERS
                               WHERE (v_age BETWEEN min_no_days AND max_no_days)
                                 AND gibr_branch_cd = v_iss_cd
                                 AND over_due_tag = 'Y')
                    LOOP
                      v_aging_id  := b.aging_id;
                      v_column_no := b.rep_col_no;
                      v_due_tag   := 'Y';
                      EXIT;
                    END LOOP;                  
                  END IF;
                  BEGIN
                    SELECT MAX(col_no)
                      INTO v_temp_col
                      FROM GIAC_SOA_TITLE
                     WHERE rep_cd = 1;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      RAISE_APPLICATION_ERROR(-20201,'NO DATA FOUND IN GIAC_SOA_TITLE.');
                  END;
                  IF v_column_no > v_temp_col THEN
                    v_column_no := v_temp_col;
                  END IF;
                  FOR c IN (SELECT col_title
                              FROM GIAC_SOA_TITLE
                             WHERE col_no = v_column_no
                               AND rep_cd = 1)--to identify title bet RI soa and soa
                   LOOP
                    v_column_title := c.col_title;
                    EXIT;
                  END LOOP;
                  
                  IF vv_spld_date(cur1) IS NULL OR (vv_spld_date(cur1) IS NOT NULL AND vv_pol_flag(cur1) = '1') THEN
                       FOR s1 IN (SELECT balance_amt_due, prem_balance_due, tax_balance_due
                                     FROM GIAC_AGING_SOA_DETAILS
                                    WHERE iss_cd = iss_cd_var
                                      AND prem_seq_no = prem_seq_var
                                      AND inst_no = cur3.inst_no)
                        LOOP
                          v_balance_amt_due := s1.balance_amt_due * v_share;
                          v_prem_bal_due    := s1.prem_balance_due * v_share;
                          v_tax_bal_due     := s1.tax_balance_due * v_share;
                        -- /*mod 4*/ for multiple intermediaries.. to resolve the issue on rounding off
                        -- sum the records inserted in giac_soa_rep_ext then get the difference
                        -- between the amount in giac_aging_soa_details and the sum of the records inserted
                          IF ln_count > 1 AND ctr = ln_count THEN
                            OPEN  cr_sum_installment(vv_policy_no(cur1),cur3.inst_no);
                            FETCH cr_sum_installment INTO v_total_bal_due, v_total_prem_due, v_total_tax_due;
                            CLOSE cr_sum_installment;
                            v_balance_amt_due := s1.balance_amt_due - v_total_bal_due;
                            v_prem_bal_due   := s1.prem_balance_due - v_total_prem_due;
                            v_tax_bal_due    := s1.tax_balance_due - v_total_tax_due; 
                          END IF;   /*mod 4*/             
                          EXIT;
                        END LOOP;
                        
                        /* get payments to add back to balance */
                        v_afterdate_coll := 0;
                        v_afterdate_prem := 0;
                        v_afterdate_tax  := 0;
                       FOR c1 IN (SELECT  SUM(A.collection_amt) collection_amt,
                                          SUM(A.premium_amt) prem_amt,
                                          SUM(A.tax_amt) tax_amt
                                     FROM GIAC_DIRECT_PREM_COLLNS A,
                                          GIAC_ACCTRANS b
                                    WHERE A.gacc_tran_id = b.tran_id
                                      AND A.b140_iss_cd = iss_cd_var
                                      AND A.b140_prem_seq_no = prem_seq_var
                                      AND A.inst_no = cur3.inst_no
                                      AND b.tran_flag != 'D'
                                      AND b.tran_id >= 0
                                      AND NOT EXISTS (SELECT 'X'
                                                        FROM GIAC_REVERSALS gr,
                                                             GIAC_ACCTRANS  ga
                                                       WHERE gr.reversing_tran_id = ga.tran_id
                                                         AND ga.tran_flag        !='D'
                                                         AND gr.gacc_tran_id = A.gacc_tran_id
                                                     --added condition by albert 04142015; consider payments that were cancelled before cutoff date
                                                         AND DECODE (p_payt_date, 'T',
                                                                     TRUNC(ga.tran_date),
                                                                     TRUNC(ga.posting_date)
                                                                    ) <= p_cut_off_date
                                                     --end albert 04142015
                                                     )
                                      --AND TRUNC(b.tran_date) > p_cut_off_date -- replaced with codes below 
                                      AND DECODE (p_payt_date,
                                                 'T', TRUNC (b.tran_date),
                                                 TRUNC (NVL (b.posting_date,
                                                             p_cut_off_date + 1
                                                            )
                                                       )
                                                ) > p_cut_off_date
                                        -- shan 12.09.2014 : based on ENH by RCDatu 06.20.2014 (3.0)
                                    GROUP BY A.b140_iss_cd, A.b140_prem_seq_no, A.inst_no)
                        LOOP
                          /*mod 4 multiply to sahre percentage to get the share percentage per intermediary*/
                          v_balance_amt_due := v_balance_amt_due + (c1.collection_amt * v_share);
                          v_prem_bal_due    := v_prem_bal_due + (c1.prem_amt * v_share);
                          v_tax_bal_due     := v_tax_bal_due + (c1.tax_amt * v_share);
                          v_afterdate_coll := c1.collection_amt * v_share;
                          v_afterdate_prem := c1.prem_amt * v_share;
                          v_afterdate_tax   := c1.tax_amt * v_share;
                          EXIT;
                        END LOOP; 
                      
						/*added by albert 06.10.2016; get payments that were made before cut-off date but cancelled
                         after cut-off date and deduct them from the amount due */
                        FOR d1 IN (SELECT SUM(A.collection_amt) collection_amt,
                                          SUM(A.premium_amt) prem_amt,
                                          SUM(A.tax_amt) tax_amt
                                     FROM GIAC_DIRECT_PREM_COLLNS A,
                                          GIAC_ACCTRANS b
                                    WHERE A.gacc_tran_id = b.tran_id
                                      AND A.b140_iss_cd = iss_cd_var
                                      AND A.b140_prem_seq_no = prem_seq_var
                                      AND A.inst_no = cur3.inst_no
                                      AND b.tran_flag != 'D'
                                      AND b.tran_id >= 0
                                      AND EXISTS (SELECT 'X'
                                                        FROM GIAC_REVERSALS gr,
                                                             GIAC_ACCTRANS  ga
                                                       WHERE gr.reversing_tran_id = ga.tran_id
                                                         AND ga.tran_flag        !='D'
                                                         AND gr.gacc_tran_id = A.gacc_tran_id
                                                         AND DECODE (p_payt_date, 'T',
                                                                     TRUNC(ga.tran_date),
                                                                     TRUNC(NVL (ga.posting_date,
                                                             					p_cut_off_date + 1
                                                            			   ))
                                                                     ) > p_cut_off_date
                                                     )
                                    GROUP BY A.b140_iss_cd, A.b140_prem_seq_no, A.inst_no)
                        LOOP
                          /*mod 4 multiply to sahre percentage to get the share percentage per intermediary*/
                          v_balance_amt_due := v_balance_amt_due - (d1.collection_amt * v_share);
                          v_prem_bal_due    := v_prem_bal_due - (d1.prem_amt * v_share);
                          v_tax_bal_due     := v_tax_bal_due - (d1.tax_amt * v_share);
                          EXIT;
                        END LOOP;
                        --end albert 06.10.2016

                  ELSIF ((vv_spld_date (cur1) IS NOT NULL
                                AND vv_pol_flag (cur1) = '5'
                                AND vv_spld_date (cur1) > p_cut_off_date
                               )
                            OR (    vv_spld_date (cur1) IS NOT NULL
                                AND vv_pol_flag (cur1) = '5'
                                AND TRUNC (vv_spld_ent_date (cur1)) >
                                                                p_cut_off_date
                               )                     -- shan 12.09.2014 : based on ENH by RCDatu 07.24.2014 (1.0)
                           )
                  THEN
                    FOR s2 IN (SELECT (NVL(prem_amt,0) + NVL(other_charges,0) + NVL(notarial_fee,0) +
                                       NVL(tax_amt,0)) * NVL(currency_rt,1) balance,
                                      (NVL(prem_amt,0) * NVL(currency_rt,1)) prem_amt,
                                      (NVL(tax_amt,0) * NVL(currency_rt,1)) tax_amt
                                 FROM GIPI_INVOICE
                                WHERE policy_id = vv_policy_id(cur1)
                                  AND iss_cd = iss_cd_var
                                  AND prem_seq_no = prem_seq_var)
                    LOOP
                      v_balance_amt_due := s2.balance * v_share ;
                      v_prem_bal_due    := s2.prem_amt * v_share;
                      v_tax_bal_due     := s2.tax_amt * v_share;

                    -- /*mod 4*/ for multiple intermediaries.. to resolve the issue on rounding off
                    -- sum the records inserted in giac_soa_rep_ext then get the difference
                    -- between the amount in giac_aging_soa_details and the sum of the records inserted
                      IF ln_count > 1 AND ctr = ln_count THEN
                        OPEN  cr_sum_installment(vv_policy_no(cur1),cur3.inst_no);
                        FETCH cr_sum_installment INTO v_total_bal_due, v_total_prem_due, v_total_tax_due;
                        CLOSE cr_sum_installment;
                        v_balance_amt_due := s2.balance - v_total_bal_due;
                        v_prem_bal_due    := s2.prem_amt - v_total_prem_due;
                        v_tax_bal_due     := s2.tax_amt - v_total_tax_due; 
                      END IF;   /*mod 4*/             
                      EXIT;
                    END LOOP;
                    -- get payments made and deduct it to the amount due
                    FOR c2 IN (SELECT SUM(A.collection_amt) collection_amt,
                                      SUM(A.premium_amt) prem_amt,
                                      SUM(A.tax_amt) tax_amt
                                 FROM GIAC_DIRECT_PREM_COLLNS A,
                                      GIAC_ACCTRANS b
                                WHERE A.gacc_tran_id = b.tran_id
                                  AND A.b140_iss_cd = iss_cd_var
                                  AND A.b140_prem_seq_no = prem_seq_var
                                  AND A.inst_no = cur3.inst_no
                                  AND b.tran_flag != 'D'
                                  AND b.tran_id >= 0
                                  AND NOT EXISTS (SELECT 'X'
                                                    FROM GIAC_REVERSALS gr,
                                                         GIAC_ACCTRANS  ga
                                                   WHERE gr.reversing_tran_id = ga.tran_id
                                                     AND ga.tran_flag        !='D'
                                                     AND gr.gacc_tran_id = A.gacc_tran_id
                                                 --added condition by albert 04142015; consider payments that were cancelled before cutoff date
                                                     AND DECODE (p_payt_date, 'T',
                                                                 TRUNC(ga.tran_date),
                                                                 TRUNC(ga.posting_date)
                                                                ) <= p_cut_off_date
                                                 --end albert 04142015    
                                                 )
                                  --AND TRUNC(b.tran_date) <= p_cut_off_date -- replaced with codes below
                                  AND DECODE (p_payt_date,
                                              'T', TRUNC (b.tran_date),
                                              TRUNC (b.posting_date)
                                              ) <= p_cut_off_date
                                  -- shan 12.09.2014 : based on ENH by RCDatu 06.20.2014 (3.0)
                             GROUP BY A.b140_iss_cd, A.b140_prem_seq_no, A.inst_no)
                    LOOP
                      v_balance_amt_due := v_balance_amt_due - (c2.collection_amt * v_share);
                      v_prem_bal_due    := v_prem_bal_due - (c2.prem_amt * v_share);
                      v_tax_bal_due     := v_tax_bal_due - (c2.tax_amt * v_share);
                      EXIT;
                    END LOOP;       
                  END IF;  
                  
                   IF p_inc_pdc = 'Y' THEN
                    FOR d IN (SELECT inst_no, Check_Date, check_no ,
                                     (c.amount * NVL(c.currency_rt,1)) pdc_amt
                                FROM GIAC_PDC_PAYTS A, GIAC_ACCTRANS b, GIAC_PDC_CHECKS c
                               WHERE A.gacc_tran_id = tran_id
                                 AND A.gacc_tran_id = c.gacc_tran_id
                                 AND iss_cd = iss_cd_var
                                 AND prem_seq_no= prem_seq_var
                                 AND A.inst_no = v_inst_no
                                 AND tran_flag <> 'D'
                                 AND NOT EXISTS (SELECT 'X'
                                                   FROM GIAC_REVERSALS gr,
                                                        GIAC_ACCTRANS  ga
                                                  WHERE gr.reversing_tran_id = ga.tran_id
                                                    AND ga.tran_flag        !='D'
                                                    AND gr.gacc_tran_id = A.gacc_tran_id))
                    LOOP
                     /* INSERT INTO GIAC_SOA_PDC_EXT
                        (iss_cd,
                         prem_seq_no,
                         inst_no,
                         check_no,
                         Check_Date,
                         pdc_amt,
                         user_id,
                         last_update)
                      VALUES
                        (iss_cd_var,
                         prem_seq_var,
                         d.inst_no,
                         d.check_no,
                         d.Check_Date,
                         d.pdc_amt,
                         p_user_id, --USER,
                         SYSDATE);*/
                         v_giac_soa_tab.EXTEND;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).iss_cd:=iss_cd_var;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).prem_seq_no:=prem_seq_var;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).inst_no := d.inst_no;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).check_no := d.check_no;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).check_date := d.check_date;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).pdc_amt := d.pdc_amt;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).user_id :=p_user_id;
                         v_giac_soa_tab(v_giac_soa_tab.LAST).last_update :=SYSDATE;                                                                    
                    END LOOP;
                  END IF;
                 -- v_row_counter := v_row_counter + 1; commented out to due to incorrect count. added this to below IF statement rai 02/28/2017 SR 23951
                                    
                  IF NVL(v_balance_amt_due,0) != 0 THEN
                      v_row_counter := v_row_counter + 1; --to correct count displayed in GIACS180 rai 02/28/2017  SR 23951
                      
                      v_giac_tab.extend;
                      v_giac_tab(v_giac_tab.last).fund_cd:= (NVL(v_fund_cd,'NULL'));                       
                      v_giac_tab(v_giac_tab.LAST).branch_cd:=NVL(vv_iss_cd(cur1),'NULL');
                      v_giac_tab(v_giac_tab.LAST).intm_no:=NVL(v_intm_no,0);
                      v_giac_tab(v_giac_tab.LAST).intm_name:=NVL(v_intm_name,'NULL');
                      v_giac_tab(v_giac_tab.LAST).intm_type:=  NVL(v_intm_type,'NULL');
                      v_giac_tab(v_giac_tab.LAST).assd_no:= NVL(vv_assd_no2(cur1),0);
                      v_giac_tab(v_giac_tab.LAST).assd_name:=NVL(vv_assd_name(cur1),'NULL');
                      v_giac_tab(v_giac_tab.LAST).policy_no:= NVL(vv_policy_no(cur1),'NULL');
                      v_giac_tab(v_giac_tab.LAST).iss_cd:= NVL(iss_cd_var,'NULL');
                      v_giac_tab(v_giac_tab.LAST).prem_seq_no:=NVL(prem_seq_var,0);
                      v_giac_tab(v_giac_tab.LAST).inst_no:=NVL(v_inst_no,0);
                      v_giac_tab(v_giac_tab.LAST).due_date:=cur3.due_date;
                      v_giac_tab(v_giac_tab.LAST).param_date:=p_cut_off_date;
                      v_giac_tab(v_giac_tab.LAST).aging_id:= NVL(v_aging_id,0);
                      v_giac_tab(v_giac_tab.LAST).column_no:=NVL(v_column_no,0);
                      v_giac_tab(v_giac_tab.LAST).column_title:=NVL(v_column_title,'NULL TITLE');
                      v_giac_tab(v_giac_tab.LAST).balance_amt_due:=NVL(v_balance_amt_due,0);
                      v_giac_tab(v_giac_tab.LAST).prem_bal_due:= NVL(v_prem_bal_due,0);
                      v_giac_tab(v_giac_tab.LAST).tax_bal_due:= NVL(v_tax_bal_due,0);
                      v_giac_tab(v_giac_tab.LAST).ref_pol_no:=vv_ref_pol_no(cur1);
                      v_giac_tab(v_giac_tab.LAST).ref_inv_no:= v_inv_no;
                      v_giac_tab(v_giac_tab.LAST).user_id:= p_user_id;
                      v_giac_tab(v_giac_tab.LAST).last_update:= SYSDATE;
                      v_giac_tab(v_giac_tab.LAST).no_of_days:=v_age;
                      v_giac_tab(v_giac_tab.LAST).from_date1:=v_from_date1;
                      v_giac_tab(v_giac_tab.LAST).to_date1:=v_to_date1;
                      v_giac_tab(v_giac_tab.LAST).from_date2:=v_from_date2;
                      v_giac_tab(v_giac_tab.LAST).to_date2:=v_to_date2;
                      v_giac_tab(v_giac_tab.LAST).date_tag:=v_date_tag;
                      v_giac_tab(v_giac_tab.LAST).due_tag:=v_due_tag;
                      v_giac_tab(v_giac_tab.LAST).lic_tag:= v_lic_tag;
                      v_giac_tab(v_giac_tab.LAST).parent_intm_no:= v_parent_intm_no;
                      v_giac_tab(v_giac_tab.LAST).spld_date:=vv_spld_date(cur1);
                      v_giac_tab(v_giac_tab.LAST).incept_date:=vv_incept_date(cur1);
                      v_giac_tab(v_giac_tab.LAST).expiry_date:= vv_expiry_date(cur1);
                      v_giac_tab(v_giac_tab.LAST).as_of_date:=v_date_as_of;
                      v_giac_tab(v_giac_tab.LAST).afterdate_coll:= NVL(v_afterdate_coll,0);
                      v_giac_tab(v_giac_tab.LAST).afterdate_prem:=NVL(v_afterdate_prem,0);
                      v_giac_tab(v_giac_tab.LAST).afterdate_tax:= NVL(v_afterdate_tax,0);
                       
                     /* INSERT INTO GIAC_SOA_REP_EXT
                        (fund_cd,
                         branch_cd,
                         intm_no,
                         intm_name,
                         intm_type,
                         assd_no,
                         assd_name,
                         policy_no,
                         iss_cd,
                         prem_seq_no,
                         inst_no,
                         due_date,
                         param_date,
                         aging_id,
                         column_no,
                         column_title,
                         balance_amt_due,
                         prem_bal_due,
                         tax_bal_due,
                         ref_pol_no,
                         ref_inv_no,
                         user_id,
                         last_update,
                         no_of_days,
                         from_date1,
                         to_date1,
                         from_date2,
                         to_date2,
                         date_tag,
                         due_tag,
                         lic_tag,
                         parent_intm_no,
                         spld_date,
                         incept_date,
                         expiry_date,
                         as_of_date,
                         afterdate_coll,
                         afterdate_prem,
                         afterdate_tax)
                      VALUES
                        (NVL(v_fund_cd,'NULL'),
                         NVL(vv_iss_cd(cur1),'NULL'),
                         NVL(v_intm_no,0),
                         NVL(v_intm_name,'NULL'),
                         NVL(v_intm_type,'NULL'),
                         NVL(vv_assd_no2(cur1),0),
                         NVL(vv_assd_name(cur1),'NULL'),
                         NVL(vv_policy_no(cur1),'NULL'),
                         NVL(iss_cd_var,'NULL'),
                         NVL(prem_seq_var,0),
                         NVL(v_inst_no,0),
                         cur3.due_date,
                         p_cut_off_date,
                         NVL(v_aging_id,0),
                         NVL(v_column_no,0),
                         NVL(v_column_title,'NULL TITLE'),
                         NVL(v_balance_amt_due,0),
                         NVL(v_prem_bal_due,0),
                         NVL(v_tax_bal_due,0),
                         vv_ref_pol_no(cur1),
                         v_inv_no,
                         p_user_id, --USER,
                         SYSDATE,
                         v_age,
                         v_from_date1,
                         v_to_date1,
                         v_from_date2,
                         v_to_date2,
                         v_date_tag,
                         v_due_tag,
                         v_lic_tag,
                         v_parent_intm_no,
                         vv_spld_date(cur1),
                         vv_incept_date(cur1),
                         vv_expiry_date(cur1),
                         v_date_as_of,
                         NVL(v_afterdate_coll,0),
                         NVL(v_afterdate_prem,0),
                         NVL(v_afterdate_tax,0));*/
                         
                  END IF;                        
              END LOOP;
             END LOOP;
        END LOOP;    
      END IF;
        <<NEXT_REC>>
        NULL;   
     END LOOP; 
  END IF;    
  p_row_counter := v_row_counter;
  
  FORALL i IN v_giac_soa_tab.FIRST..v_giac_soa_tab.LAST
   INSERT INTO (SELECT   iss_cd,
                         prem_seq_no,
                         inst_no,
                         check_no,
                         Check_Date,
                         pdc_amt,
                         user_id,
                         last_update
                  FROM   GIAC_SOA_PDC_EXT
                )
                VALUES v_giac_soa_tab(i);
  
  
  FORALL i IN v_giac_tab.FIRST..v_giac_tab.LAST
    INSERT INTO (SELECT  fund_cd,
                         branch_cd,
                         intm_no,
                         intm_name,
                         intm_type,
                         assd_no,
                         assd_name,
                         policy_no,
                         iss_cd,
                         prem_seq_no,
                         inst_no,
                         due_date,
                         param_date,
                         aging_id,
                         column_no,
                         column_title,
                         balance_amt_due,
                         prem_bal_due,
                         tax_bal_due,
                         ref_pol_no,
                         ref_inv_no,
                         user_id,
                         last_update,
                         no_of_days,
                         from_date1,
                         to_date1,
                         from_date2,
                         to_date2,
                         date_tag,
                         due_tag,
                         lic_tag,
                         parent_intm_no,
                         spld_date,
                         incept_date,
                         expiry_date,
                         as_of_date,
                         afterdate_coll,
                         afterdate_prem,
                         afterdate_tax FROM GIAC_SOA_REP_EXT) VALUES v_giac_tab(i); 
    
  --insert the parameters in the parameter table
  INSERT INTO GIAC_SOA_REP_EXT_PARAM
    (user_id,
     param_date,
     rep_date,
     as_of_date,
     from_date1,
     to_date1,
     from_date2,
     to_date2,
     date_tag,
     branch_cd,
     intm_no,
     intm_type,
     assd_no,
     inc_special_pol,
     extract_date,
     extract_aging_days,  --mod3 start/end
  branch_param,
     payt_date) -- added as per SA Albert : shan 02.27.2015
  VALUES
    (p_user_id, --USER,
     p_cut_off_date,
     p_rep_date,
     v_date_as_of,
     v_from_date1,
     v_to_date1,
     v_from_date2,
     v_to_date2,
     v_date_tag,
     p_branch_cd,
     p_intm_no,
     p_intm_type,
     p_assd_no,
     p_special_pol,
     SYSDATE,
     p_extract_days,    --mod3 start/end
     p_branch_param,
     p_payt_date); -- added as per SA Albert : shan 02.27.2015
  COMMIT;
  DBMS_OUTPUT.PUT_LINE(vv_policy_no.count);
END Extract_Soa_Rep2;
/
