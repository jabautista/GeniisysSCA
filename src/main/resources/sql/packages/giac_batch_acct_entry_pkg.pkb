CREATE OR REPLACE PACKAGE BODY CPI.GIAC_BATCH_ACCT_ENTRY_PKG
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.19.2013
   **  Reference By : GIACB000 - Batch Accounting Entry
   **  Description  : 
   */
	FUNCTION  validate_prod_date(p_prod_date  DATE) 
    RETURN validate_prod_date_tab PIPELINED
     IS
       v_cnt    NUMBER:=0;
       v_rec    validate_prod_date_type;
     BEGIN
        v_rec.batch_date := to_char(p_prod_date,'mm/dd/yyyy');

        v_cnt := 0;
        BEGIN
            SELECT count(*)
            INTO v_cnt
            FROM GIAC_ACCTRANS
            WHERE tran_class IN ('INF', 'OF', 'PRD', 'UW', 'SPR','PPR','INT') --benjo 10.13.2016 SR-5512
            AND trunc(tran_date) = to_date(v_rec.batch_date, 'mm/dd/yyyy');
            EXCEPTION 
            WHEN NO_DATA_FOUND THEN
             v_rec.giacb001    := 1;
             v_rec.giacb002    := 2;
             v_rec.giacb003    := 3;
             v_rec.giacb004    := 4;
             v_rec.giacb001_sc := 5;
             v_rec.giacb005    := 6;
             v_rec.giacb006    := 7;   --jason 08132009  
             v_rec.giacb007    := 8; --benjo 10.13.2016 SR-5512
            
            v_rec.enter_advanced_payt := giacp.v('ENTER_ADVANCED_PAYT');
            v_rec.enter_prepaid_comm := giacp.v('ENTER_PREPAID_COMM');
            
        END;

        IF v_cnt > 0 THEN
            v_rec.giacb001    := 1;
            v_rec.giacb002    := 2;
            v_rec.giacb003    := 3;
            v_rec.giacb004    := 4;
            v_rec.giacb001_sc := 5;
            v_rec.giacb005    := 6;    
            v_rec.giacb006    := 7;   --jason 08132009  
            v_rec.giacb007    := 8; --benjo 10.13.2016 SR-5512
             
            FOR rec IN (select distinct tran_class
                         from giac_acctrans
                        where tran_class in ('PRD','SPR','INF','OF','UW','PPR', 'PCR','INT')  --jason 08132009: added PCR tran_class  --benjo 10.13.2016 SR-5512
                          and trunc(tran_date) = to_date(v_rec.batch_date,'mm/dd/yyyy')
                          and tran_flag in ('C','P') )
                    LOOP
                    /*ENABLES ONLY THE BATCH WHICH HAVEN'T BEEN RUN YET*/
                      IF rec.tran_class = 'PRD' THEN
                          v_rec.giacb001    := 0;
                      ELSIF rec.tran_class = 'SPR' THEN
                          v_rec.giacb001_sc := 0;
                      ELSIF rec.tran_class = 'INF' THEN
                          v_rec.giacb004    := 0;
                      ELSIF rec.tran_class = 'OF' THEN
                          v_rec.giacb003    := 0;
                      ELSIF rec.tran_class = 'UW' THEN
                          v_rec.giacb002    := 0;
                      ELSIF rec.tran_class = 'PPR' THEN
                          v_rec.giacb005    := 0; 
                      ELSIF rec.tran_class = 'PCR' THEN  --jason 08132009
                          v_rec.giacb006    := 0;             
                      ELSIF rec.tran_class = 'INT' THEN --benjo 10.13.2016 SR-5512
                          v_rec.giacb007    := 0;
                      END IF;
                    END LOOP;
             v_rec.enter_advanced_payt := giacp.v('ENTER_ADVANCED_PAYT');
             v_rec.enter_prepaid_comm := giacp.v('ENTER_PREPAID_COMM');
        ELSE
            v_rec.giacb001    := 1;
            v_rec.giacb002    := 2;
            v_rec.giacb003    := 3;
            v_rec.giacb004    := 4;
            v_rec.giacb001_sc := 5;
            v_rec.giacb005    := 6;
            v_rec.giacb006    := 7;   --jason 08132009  
            v_rec.giacb007    := 8; --benjo 10.13.2016 SR-5512
            v_rec.enter_advanced_payt := giacp.v('ENTER_ADVANCED_PAYT');
            v_rec.enter_prepaid_comm := giacp.v('ENTER_PREPAID_COMM');       
        END IF;  -- v_count
        
        v_rec.cnt := v_cnt;
        PIPE ROW(v_rec);
     END;
     
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 03.19.2013
   **  Reference By : GIACB000 - Batch Accounting Entry
   **  Description  : This procedure was added so that the data of the policies to be taken-up
   **          by the batch accounting entry generation will be checked for data errors
   **          and inconsistencies which may lead to erroneous production results.
   */
    PROCEDURE data_check (p_prod_date    IN  DATE,
                          p_report       OUT VARCHAR2,
                          p_log          OUT VARCHAR2,
                          p_error_msg    OUT VARCHAR2) 
    IS
       v_report VARCHAR(2000) := 'REPORT SUMMARY'||CHR(10)||
                                 ' '||CHR(10);
       v_part0  NUMBER  := 0;   -- SR-4619 : shan 07.06.2015
       v_part1  NUMBER  := 0;
       v_part2  NUMBER  := 0;
       v_part3  NUMBER  := 0;
       v_part4  NUMBER  := 0;
       v_part5  NUMBER  := 0;
       v_part6  NUMBER  := 0;
       v_part7  NUMBER  := 0;
       v_part8  NUMBER  := 0;
       v_part9  NUMBER  := 0;
       v_part10 NUMBER  := 0;
       v_part11 NUMBER  := 0;
       v_part12 NUMBER  := 0;
       v_error  BOOLEAN := FALSE;
       v_date   VARCHAR2(20) := to_char(p_prod_date,'MONTH YYYY');
    BEGIN
       p_error_msg := '';
       /* ZERO: CHECK GIPI_POLBASIC FOR NULL BOOKING_MTH ::: SR-4619 : shan 07.06.2015 */
       p_log := 'Checking null booking month. Please wait...';
       p_log := p_log ||CHR(10)||'Checking null booking month using baecheck.check_null_booking_mth... ';
       v_part0 := baecheck.check_null_booking_mth;
       IF v_part0 = 0 THEN
          v_report := v_report||'     CHECK NULL BOOKING MONTH:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS HAVE BOOKING MONTH'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;
           v_report := v_report||'     CHECK NULL BOOKING MONTH:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part0)||' RECORDS IN GIPI_POLBASIC '||CHR(10)||
                      '                  WITH NULL BOOKING MONTH'||CHR(10)||
                      '          ACTION: THESE POLICIES MUST BE CORRECTED'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
           GOTO with_error;
       END IF;
       p_log := p_log ||CHR(10)||'Finished.';
       /* end SR-4619 : shan 07.06.2015*/
       
       
       /*ONE: CHECK GIPI_COMM_INVOICE FOR NULL PARENT_INTM_NO, THEN POPULATE IT*/
       p_log := 'Checking parent intermediary. Please wait...';
       p_log := p_log ||CHR(10)||'Checking parent intermediary using baecheck.check_parent_intm... ';
       v_part1 := baecheck.check_parent_intm;
       IF v_part1 = 0 THEN
          v_report := v_report||'     CHECK PARENT INTERMDIARY:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS HAVE PARENT INTERMEDIARY'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_report := v_report||'     CHECK PARENT INTERMDIARY:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part1)||' RECORDS IN GIPI_COMM_INVOICE '||CHR(10)||
                      '                  WITH NULL PARENT INTERMEDIARY'||CHR(10)||
                      '          ACTION: RECORDS HAVE BEEN UPDATED'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;
       p_log := p_log ||CHR(10)||'Finished.';
       /*THREE: CHECK  IF THERE ARE RECORDS IN GIIS_TRTY_PANEL 
         WHERE THE PANEL's total IS NOT 100%*/
       p_log := p_log ||CHR(10)||'Checking panels. Please wait...';
       p_log := p_log ||CHR(10)||'Checking panels using baecheck.check_trty_100... ';
       v_part3 := baecheck.check_trty_100;
       IF v_part3 = 0 THEN
          v_report := v_report||'     CHECK IF TREATY IS 100%:'||CHR(10)||
                      '        FINDINGS: ALL PANELS ARE 100%'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'     CHECK IF TREATY IS 100%:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part3)||' PANELS WITH TOTALS NOT 100%'||CHR(10)||
                      '          ACTION: THESE PANELS MUST HAVE A TOTAL OF 100%'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;
       p_log := p_log ||CHR(10)||'Finished.';
       /*FOUR: CHECK IF THERE ARE RECORDS IN GIIS_DIST_SHARE 
         THAT DOES NOT HAVE AN ACCT_TREATY_TYPE*/
       p_log := p_log ||CHR(10)||'Checking for acct_entry_type. Please wait...';
       p_log := p_log ||CHR(10)||'Checking for acct_entry_type using baecheck.check_trty_type... ';
       v_part4 := baecheck.check_trty_type(p_prod_date);
       IF v_part4 = 0 THEN
          v_report := v_report||'     CHECK IF TREATY HAS ACCT_TRTY_TYPE:'||CHR(10)||
                      '        FINDINGS: ALL TREATIES HAVE ACCT_TRTY_TYPE'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'     CHECK IF TREATY HAS ACCT_TRTY_TYPE::'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part4)||' TREATIES WITH NO ACCT_TRTY_TYPE'||CHR(10)||
                      '          ACTION: THESE TREATIES MUST HAVE ACCT_TRTY_TYPE'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF; 
       p_log := p_log ||CHR(10)||'Finished.';
       /*FIVE: CHECK IF THERE ARE RECORDS IN GIRI_BINDER
         WHICH SHOULD HAVE A REPLACED_FLAG = 'y'*/
       p_log := p_log ||CHR(10)||'Checking binders. Please wait...';
       p_log := p_log ||CHR(10)||'Checking binders using baecheck.check_binder_flag... ';
       v_part5 := baecheck.check_binder_flag(v_date);
       IF v_part5 = 0 THEN
          v_report := v_report||'     CHECK BINDERS REPLACED FLAG:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS ARE CORRECT'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'      CHECK BINDERS REPLACED FLAG:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part5)||' BINDERS THAT MUST HAVE REPLACED FLAG=Y'||CHR(10)||
                      '          ACTION: THESE BINDERS MUST BE CORRECTED'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;    
       p_log := p_log ||CHR(10)||'Finished.';
       /*SIX: CHECK IF THE TOTAL PREMIUM IN GIPI_COMM_INVOICE IS
         EQUAL TO THE PREMUIM IN GIPI_INVOICE
         ALSO CHECKS THE GIPI_COMM_INVOICE AND GIPI_COMM_INV_PERIL*/
       /*  -- omit checking; judyann 10062006
       message('Checking premium details. Please wait...',no_acknowledge);
       synchronize;
       trace_log('Checking premium details using baecheck.check_comm_prem... ');
       v_part6 := baecheck.check_comm_prem(v_date);
       IF v_part6 = 0 THEN
          v_report := v_report||'     CHECK COMM PREMIUMS:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS ARE CORRECT'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_report := v_report||'    CHECK COMM PREMIUMS:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part6)||' INVOICES HAS WRONG PREMIUMS IN GIPI_COMM_INVOICE'||CHR(10)||
                      '          ACTION: THESE INVOICES HAVE BEEN CORRECTED.'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;
       SYNCHRONIZE;
       */
       
       /*SEVEN: CHECK IF THE TOTAL TAX IN GIPI_INV_TAX IS
         EQUAL TO THE TAX_AMT IN GIPI_INVOICE*/
       p_log := p_log ||CHR(10)||'Checking tax details. Please wait...';
       p_log := p_log ||CHR(10)||'Checking tax details using baecheck.check_inv_tax... ';
       v_part7 := baecheck.check_inv_tax(v_date);
       IF v_part7 = 0 THEN
          v_report := v_report||'     CHECK INV TAX:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS ARE CORRECT'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_report := v_report||'    CHECK INV TAX:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(/*v_part6*/ v_part7)||' INVOICES HAS WRONG TAXES IN GIPI_INV_TAX'||CHR(10)||    -- changed v_part6 to v_part7 : SR-4567 shan 06.16.2015
                      '          ACTION: THESE INVOICES HAVE BEEN CORRECTED'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;
       p_log := p_log ||CHR(10)||'Finished.';
       /*EIGHT: CHECK IF THE TOTAL PREMIUM IN GIPI_COMM_INV_PERIL IS
         EQUAL TO THE TAX_AMT IN GIPI_COMM_INVOICE*/
       /*message('Checking premium invoice peril details. Please wait...',no_acknowledge);
       synchronize;
       trace_log('Checking premium invoice peril details using baecheck.check_prem_invprl... ');
       v_part8 := baecheck.check_prem_invprl(v_date);
       IF v_part8 = 0 THEN
          v_report := v_report||'     CHECK PREM INV PERIL:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS ARE CORRECT'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'    CHECK PREM INV PERIL:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part8)||' INVOICES HAS WRONG PREMIUMS IN GIPI_COMM_INVOICE'||CHR(10)||
                      '          ACTION: THESE INVOICES MUST BE CORRECTED'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;*/
       /*NINE: CHECK IF TREATY BEING USED EXISTS*/
       p_log := p_log ||CHR(10)||'Checking treaty for existence. Please wait...';
       p_log := p_log ||CHR(10)||'Checking treaty for existence using baecheck.check_treaty_exists... ';
       v_part9 := baecheck.check_trty_exists(p_prod_date); -- mildred 07202011 for baecheck modified;
       IF v_part9 = 0 THEN
          v_report := v_report||'     CHECK TREATY EXISTS:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS ARE CORRECT'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'    CHECK TREATY EXISTS:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part9)||' TREATIES USED BUT IS NOT IN MAINTENANCE TABLE'||CHR(10)||
                      '          ACTION: THESE TREATIES MUST BE SETUP'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;
       p_log := p_log ||CHR(10)||'Finished.';
       /*TEN: CHECK IF THERE ARE POLICIES THAT ARE NOT TAX ENDORSEMENTS BUT DOES NOT EXISTS
              IN GIPI_COMM_INVOICE AND/OR GIPI_COMM_INV_PERIL
       */
       p_log := p_log ||CHR(10)||'Checking not tax endorsement policies not in gipi_comm_invoice. Please wait...';
       p_log := p_log ||CHR(10)||'Checking not tax endorsement policies not in gipi_comm_invoice using baecheck.check_notendttax... ';
       v_part10 := baecheck.check_invcomm_exs(v_date); --baecheck.check_notendttax(v_date); -- changed for SR-4568 : shan 06.16.2015
       IF v_part10 = 0 THEN
          v_report := v_report||'     CHECK NOT ENDT TAX NOT IN GIPI_COMM_INVOICE:'||CHR(10)||
                      '        FINDINGS: ALL RECORDS ARE CORRECT'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'    CHECK NOT ENDT TAX NOT IN GIPI_COMM_INVOICE:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part10)||' NOT TAX ENDT POLICIES BUT NOT IN GIPI_COMM_INVOICE'||CHR(10)||
                      '          ACTION: DATA MUST BE INSERTED INTO GIPI_COMM_INVOICE'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;
       p_log := p_log ||CHR(10)||'Finished.';
    --added by lina
       p_log := p_log ||CHR(10)||'Checking if replacement distribution is fully distributed.  Please wait....';
       p_log := p_log ||CHR(10)||'Checking if replacement distribution is fully distributed using baecheck.check_negated_dist... ';
       v_part11 := baecheck.check_negated_dist(p_prod_date);
       IF v_part11 = 0 THEN
          v_report := v_report||'     CHECK IF REPLACEMENT DISTRIBUTION IS FULLY-DISTRIBUTED:'||CHR(10)||
                      '        FINDINGS: ALL REPLACEMENT DISTRIBUTIONS ARE FULLY-DISTRIBUTED'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'    CHECK IF REPLACEMENT DISTRIBUTION IS FULLY-DISTRIBUTED:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part11)||' REPLACEMENT DISTRIBUTIONS ARE NOT FULLY-DISTRIBUTED'||CHR(10)||
                      '          ACTION:THESE DISTRIBUTION RECORDS MUST BE DISTRIBUTED'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;   
       p_log := p_log ||CHR(10)||'Finished.';
       /*
       message('Checking if policy is taken-up before endorsement.  Please wait....',no_acknowledge);
       trace_log('Checking if policy is taken-up before endorsement... ');
       v_part12 := baecheck.list_of_endorsements(:nbt.prod_date);
       IF v_part12 = 0 THEN
          v_report := v_report||'     CHECK IF POLICY IS TAKEN-UP BEFORE ENDT:'||CHR(10)||
                      '        FINDINGS: NO ENDORSEMENT WILL BE TAKEN-UP AHEAD OF THE POLICY'||CHR(10)||
                      '          ACTION: NONE'||CHR(10)||
                      '          STATUS: OK'||CHR(10)||
                      ' '||CHR(10);
       ELSE
           v_error := TRUE;   
           v_report := v_report||'    CHECK IF POLICY IS TAKEN-UP BEFORE ENDT:'||CHR(10)||
                      '        FINDINGS: '||TO_CHAR(v_part12)||' POLICY/IES WILL BE TAKEN-UP AHEAD OF ENDORSEMENTS'||CHR(10)||
                      '          ACTION:BOOKING MONTH OF POLICY AND ENDORSEMENTS MUST BE CHECKED'||CHR(10)||
                      '          STATUS: NOT OK'||CHR(10)||
                      ' '||CHR(10);
       END IF;      
       SYNCHRONIZE;   
    --end of modification
     */ --jeremy 02092010
     
     <<with_error>> -- SR-4619 :: shan 07.06.2015
       IF v_error = TRUE THEN
          p_error_msg := 'There are errors that has to be resolved to ensure correct batch processing. Please see the DATA CHECK REPORT for more details.';
       END IF;
       
       p_report := v_report;
    END;
    
    PROCEDURE  update_allow_spoilage
    IS
    BEGIN
        UPDATE giis_parameters
           SET PARAM_VALUE_V = 'N'
            WHERE upper(PARAM_NAME) LIKE 'ALLOW_SPOILAGE';
    END;
    
    PROCEDURE validate_when_exit
    IS
     v_allow_spoilage   giac_parameters.param_value_v%type;
    BEGIN
         SELECT param_value_v 
           INTO v_allow_spoilage
           FROM giac_parameters
          WHERE param_name = 'ALLOW_SPOILAGE';
         IF v_allow_spoilage = 'N'
         THEN
            UPDATE giis_parameters
               SET param_value_v = 'Y'
             WHERE UPPER(param_name) LIKE 'ALLOW_SPOILAGE';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND 
         THEN
            NULL;
    END;
    
    PROCEDURE prod_sum_rep_and_peril_ext(p_prod_date   IN  DATE,
                                         p_log         OUT VARCHAR2)
    IS
    v_add_proc_exs  BOOLEAN := FALSE;
    v_add_proc      VARCHAR2(1);
    BEGIN
    /*Additional run of procedures for AUII
    database procedure:
    1. GIAC_PROD_SUM_REP(param_date)
    2. INSERT_GIAC_PROD_PERIL_EXT(param_date);
    */
    --Check if the additional procedures will be ran
      FOR c IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'BATCH_ADDITIONAL_PROCS')
      LOOP
         v_add_proc := c.param_value_v;
         v_add_proc_exs := TRUE;
         EXIT;
      END LOOP;
      
      IF v_add_proc_exs = TRUE THEN  
         IF v_add_proc = 'Y' THEN
            p_log := '*Running additional procedures...';
            p_log := p_log||CHR(10)||' Running GIAC_PROD_SUM_REP... '||to_char(p_prod_date,'mm-dd-yyyy');
            GIAC_PROD_SUM_REP(p_prod_date);
            p_log := p_log||CHR(10)||' Running INSERT_GIAC_PROD_PERIL_EXT... '||to_char(p_prod_date,'mm-dd-yyyy');
            INSERT_GIAC_PROD_PERIL_EXT(p_prod_date);
            p_log := p_log||CHR(10)||'Additional procedures finished.';
         ELSE
            p_log := '*Will not be running additional procedures...';
            p_log := p_log||CHR(10)||' Reason: Parameter BATCH_ADDITIONAL_PROCS is set to N';
            p_log := p_log||CHR(10)||'Additional procedures skipped.';
         END IF;
      ELSE
         p_log := '*Will not be running additional procedures...';
         p_log := p_log||CHR(10)||' Reason: Parameter BATCH_ADDITIONAL_PROCS does not exist in GIAC_PARAMETERS';
         p_log := p_log||CHR(10)||'Additional procedures skipped.';
      END IF;
      --Set the allow_spoilage parameter to 'Y'
      p_log := p_log||CHR(10)||'Updating parameter allow_spoilage to Y...';
      UPDATE GIIS_PARAMETERS
         SET PARAM_VALUE_V = 'Y'
       WHERE upper(PARAM_NAME) LIKE 'ALLOW_SPOILAGE';
       
      p_log := p_log||CHR(10)||'Generation finished.';
    END;
END;
/


