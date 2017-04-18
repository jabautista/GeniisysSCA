DROP PROCEDURE CPI.AEG_PARAMETERS_GIACS026;

CREATE OR REPLACE PROCEDURE CPI.AEG_PARAMETERS_GIACS026(
   p_gacc_branch_cd         GIAC_ACCTRANS.gibr_branch_cd%TYPE,
   p_gacc_fund_cd           GIAC_ACCTRANS.gfun_fund_cd%TYPE,
   p_gacc_tran_id           GIAC_ACCTRANS.tran_id%TYPE,
   p_dep_flag               GIAC_PREM_DEPOSIT.dep_flag%TYPE,
   p_b140_iss_cd            GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
   p_b140_prem_seq_no       GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE) IS
                                  
  v_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE;
  v_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE;     
  ws_sl_cd            GIAC_ACCT_ENTRIES.sl_cd%TYPE;
  ws_sl_type_cd       GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
  ws_sl_source_cd     GIAC_ACCT_ENTRIES.sl_source_cd%TYPE  := 1 ;                       

  LOC_FLAG            GIAC_ACCTRANS.tran_flag%TYPE;
  LOC_TAG             GIAC_PREM_DEPOSIT.or_print_tag%TYPE;
  
  v_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
  v_assd              GIIS_ASSURED.assd_no%TYPE;
  v_acct_line_cd      GIIS_LINE.acct_line_cd%TYPE;
  v_parent_intm_no    GIIS_INTERMEDIARY.parent_intm_no%TYPE;
  
  v_module_id         GIAC_MODULES.module_id%TYPE;
  v_gen_type          GIAC_MODULES.generation_type%TYPE;
  v_item_no           GIAC_MODULE_ENTRIES.item_no%TYPE := 1;

  CURSOR prem_deposit_cur IS
    SELECT collection_amt, ri_cd, assd_no, 
           transaction_type, intm_no, comm_rec_no
      FROM GIAC_PREM_DEPOSIT
     WHERE gacc_tran_id = p_gacc_tran_id;
    
  --commented out by shan 12142012 as per GEN-2012-948_GIACS026_V01_12112012
   /*CURSOR sl_type_cur IS
    SELECT sl_type_cd 
      FROM GIAC_SL_TYPES
     WHERE sl_type_name = 'ASSURED';*/
  --end shan

BEGIN

  BEGIN
    --commented out by shan 12142012 as per GEN-2012-948_GIACS026_V01_12112012
    /*OPEN sl_type_cur;
    FETCH sl_type_cur INTO ws_sl_type_cd; 
    CLOSE sl_type_cur;*/
    -- end shan
    
    SELECT module_id,
           generation_type
      INTO v_module_id,
           v_gen_type
      FROM GIAC_MODULES
     WHERE module_name  = 'GIACS026';
  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR('-20001','No data found in GIAC MODULES.');
  END;
  
  /*
  ** Call the deletion of accounting entry procedure.
  */
  --
  --
  GIAC_ACCT_ENTRIES_PKG.AEG_Delete_Acct_Entries(p_gacc_tran_id, v_gen_type);
  --
  --
  FOR prem_deposit_rec IN prem_deposit_cur LOOP
      IF prem_deposit_rec.comm_rec_no IS NULL THEN
       IF prem_deposit_rec.ri_cd IS NULL THEN
          v_item_no := 1;
          ws_sl_cd := prem_deposit_rec.assd_no;
          -- replaced with query to retrieve sl_type_cd --shan 12142012 as per GEN-2012-948_GIACS026_V01_12112012
          BEGIN 
          SELECT sl_type_cd 
            INTO ws_sl_type_cd
            FROM giac_sl_types
           WHERE sl_type_name = 'ASSURED';
          EXCEPTION WHEN no_data_found THEN 
              RAISE_APPLICATION_ERROR(-20001, 'No data found in SL Type Maintenance.');
          END;
          --end shan 

       ELSE
          v_item_no := 2;
          --ws_sl_cd := prem_deposit_rec.assd_no;
           ws_sl_cd := prem_deposit_rec.ri_cd; -- replaced as ri_cd shan 12142012 as per GEN-2012-948_GIACS026_V01_12112012
          -- replaced with query to retrieve sl_type_cd --shan 12142012 as per GEN-2012-948_GIACS026_V01_12112012
              
          BEGIN 
          SELECT sl_type_cd 
            INTO ws_sl_type_cd
            FROM giac_sl_types
           WHERE sl_type_name = 'REINSURER';
          EXCEPTION WHEN no_data_found THEN               
              RAISE_APPLICATION_ERROR(-20001, 'No data found in SL Type Maintenance.');
          END;   	 
          --shan 12142012  
          
       END IF;
    ELSE
       IF p_dep_flag = 3 THEN       
          IF prem_deposit_rec.transaction_type = 4 THEN         
                v_item_no := 3;
          ELSIF prem_deposit_rec.transaction_type = 2 THEN
               v_item_no := 4;
          END IF;
          FOR g IN (SELECT sl_type_cd 
                      FROM giac_module_entries
                     WHERE module_id = v_module_id
                       AND item_no = v_item_no)
          LOOP
               v_sl_type_cd := g.sl_type_cd;        
          END LOOP;             
       END IF;   

       FOR p IN (SELECT a.assd_no, 
                        d.acct_line_cd
                   FROM gipi_polbasic a, gipi_invoice b, giis_line d
                  WHERE a.policy_id = b.policy_id
                    AND a.assd_no = prem_deposit_rec.assd_no    
                    AND a.line_cd = d.line_cd       
                    AND b.iss_cd = p_b140_iss_cd
                    AND b.prem_seq_no = p_b140_prem_seq_no)
       LOOP
         v_assd     := p.assd_no;    
         v_acct_line_cd := p.acct_line_cd;              
       END LOOP;  

     /* get SL for overdraft comm entry */
       IF v_sl_type_cd = GIACP.v('LINE_SL_TYPE') THEN    
          ws_sl_cd := v_acct_line_cd;     
       ELSIF v_sl_type_cd = GIACP.v('ASSD_SL_TYPE') THEN
          ws_sl_cd:= v_assd;   
       ELSIF v_sl_type_cd = GIACP.v('INTM_SL_TYPE') THEN  
          BEGIN
             SELECT a.parent_intm_no
              INTO v_parent_intm_no
              FROM giis_intermediary a
             WHERE a.intm_no = prem_deposit_rec.intm_no;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_parent_intm_no := NULL;
          END;       
          IF v_parent_intm_no IS NOT NULL THEN
             ws_sl_cd := v_parent_intm_no;
          ELSE
               ws_sl_cd := prem_deposit_rec.intm_no;
          END IF;
       ELSE
          ws_sl_cd := NULL;   
       END IF;    
       

    END IF;  

    /*
    ** Call the accounting entry generation procedure.
    */
    --
    --  
    AEG_CREATE_ACCT_ENTRIES_026(
                p_gacc_branch_cd, p_gacc_fund_cd,
                p_gacc_tran_id,
                prem_deposit_rec.collection_amt,
                v_gen_type, v_module_id,
                v_item_no,  ws_sl_cd, ws_sl_type_cd, ws_sl_source_cd);
    --
    --

  END LOOP;

  

END;
/


