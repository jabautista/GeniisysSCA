DROP PROCEDURE CPI.GENERATE_BATCH_GICLB001;

CREATE OR REPLACE PROCEDURE CPI.generate_batch_giclb001(
    p_module_id      IN  giac_modules.module_id%TYPE,
    p_fund_cd        IN  giac_acctrans.gfun_fund_cd%TYPE,
    p_dsp_date       IN  giac_acctrans.tran_date%TYPE,
    p_user_id    	 IN  giac_acctrans.user_id%TYPE,
    p_gen_type       IN  giac_modules.generation_type%TYPE,
    p_tran_id		OUT  giac_acctrans.tran_id%TYPE,
    p_message       OUT  VARCHAR2,
    p_message_type  OUT  VARCHAR2
) 
IS

    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.18.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  GENERATE_BATCH program unit;     
    */
    
  v_gl_acct_ctgry        giac_module_entries.gl_acct_category%type;
  os_net_takeup          varchar2(1);
  take_up_date           varchar2(100);
  
  v_param		         varchar2(1);
  v_ri_recov			 varchar2(1);
  v_ri_share			 varchar2(1);
  v_branch_cd         	 giac_payt_requests.branch_cd%TYPE;
  v_separate_xol_entries VARCHAR2(1) := 'N';
BEGIN
  BEGIN
    SELECT param_value_v
      INTO v_param
      FROM giac_parameters
     WHERE param_name = 'OS_EXP_BOOKING';
  EXCEPTION
    WHEN NO_DATA_FOUND then
      --msg_alert('No OS_EXP_BOOKING parameter found in GIAC_PARAMETERS.','I',TRUE);
      raise_application_error('-20001', 'No OS_EXP_BOOKING parameter found in GIAC_PARAMETERS.');
  END;

  BEGIN
    SELECT gl_acct_category
      INTO v_gl_acct_ctgry
      FROM giac_module_entries
     WHERE module_id = p_module_id
       AND item_no = 2;
  EXCEPTION
    WHEN NO_DATA_FOUND then
      --msg_alert('No expense setup in giac_module_entries.','I',FALSE);
      p_message := 'No expense setup in giac_module_entries.';
      p_message_type := 'I';
      IF v_param = 'Y' THEN
        v_gl_acct_ctgry := 0;
      END IF;
  END;

  BEGIN
    SELECT param_value_v
      INTO os_net_takeup
      FROM giac_parameters
     WHERE param_name = 'OS_NET_TAKEUP';
  EXCEPTION
    WHEN NO_DATA_FOUND then
      --msg_alert('No OS_NET_TAKEUP parameter found in GIAC_PARAMETERS.','I',TRUE);
      raise_application_error('-20001', 'No OS_NET_TAKEUP parameter found in GIAC_PARAMETERS.');
  END;
  
-- added by judyann 03062006
-- parameter for RI RECOVERABLE ENTRY
  BEGIN
    SELECT param_value_v
      INTO v_ri_recov
      FROM giac_parameters
     WHERE param_name = 'SEPARATE_RI_RECOV';
  EXCEPTION
    WHEN NO_DATA_FOUND then
      --msg_alert('No SEPARATE_RI_RECOV parameter found in GIAC_PARAMETERS.','I',TRUE);
      raise_application_error('-20001', 'No SEPARATE_RI_RECOV parameter found in GIAC_PARAMETERS.');
  END;
  
-- added by judyann 04062006
-- parameter for LOSS RECOVERIES ON RI CEDED/RI SHARE ON O/S LOSS
  BEGIN
    SELECT param_value_v
      INTO v_ri_share
      FROM giac_parameters
     WHERE param_name = 'SEPARATE_RI_SHARE';
  EXCEPTION
    WHEN NO_DATA_FOUND then
      --msg_alert('No SEPARATE_RI_SHARE parameter found in GIAC_PARAMETERS.','I',TRUE);
      raise_application_error('-20001', 'No SEPARATE_RI_SHARE parameter found in GIAC_PARAMETERS.');
  END;


/* get the value of SEPARATE_XOL_ENTRIES to determine if xol entries are to be seaprated from the trty.
** Pia, 09.25.06 */
  BEGIN
    SELECT param_value_v
      INTO v_separate_xol_entries
      FROM giac_parameters
     WHERE param_name = 'SEPARATE_XOL_ENTRIES';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      --msg_alert('No SEPARATE_XOL_ENTRIES parameter found in GIAC_PARAMETERS', 'I', TRUE);
      raise_application_error('-20001', 'No SEPARATE_XOL_ENTRIES parameter found in GIAC_PARAMETERS');
  END;
 
  
  FOR A IN (SELECT DISTINCT iss_cd branch
              FROM gicl_take_up_hist
             WHERE acct_tran_id IS NULL)
  LOOP  
    v_branch_cd := a.branch;
    giac_acctrans_pkg.insert_into_acctrans_giclb001(p_fund_cd, v_branch_cd, p_dsp_date, p_user_id, p_tran_id);
    IF os_net_takeup = 'N' THEN
       IF v_param = 'Y' and v_gl_acct_ctgry <> 0 THEN
          setup_one_giclb001(v_branch_cd    ,p_tran_id   ,p_gen_type                ,p_module_id            ,p_fund_cd,
                             p_user_id      ,v_ri_recov  ,v_separate_xol_entries    ,v_ri_share             ,p_message,
                             p_message_type);
       ELSIF v_param = 'Y' and v_gl_acct_ctgry = 0 THEN
          setup_two_giclb001(v_branch_cd    ,p_tran_id   ,p_gen_type                ,p_module_id            ,p_fund_cd,
                             p_user_id      ,v_separate_xol_entries                 ,p_message              ,p_message_type);
       ELSIF v_param = 'N' THEN
          setup_three_giclb001(v_branch_cd  ,p_tran_id   ,p_gen_type                ,p_module_id            ,p_fund_cd,
                               p_user_id    ,v_separate_xol_entries                 ,p_message              ,p_message_type);
       END IF;
    ELSIF os_net_takeup = 'Y' THEN
       IF v_param = 'Y' and v_gl_acct_ctgry <> 0 THEN
          setup_four_giclb001(v_branch_cd    ,p_tran_id   ,p_gen_type                ,p_module_id            ,p_fund_cd,
                              p_user_id      ,v_ri_recov  ,v_separate_xol_entries    ,p_message              ,p_message_type);
       ELSIF v_param = 'Y' and v_gl_acct_ctgry = 0 THEN
          setup_five_giclb001(v_branch_cd  ,p_tran_id   ,p_gen_type                ,p_module_id            ,p_fund_cd,
                              p_user_id    ,v_separate_xol_entries                 ,p_message              ,p_message_type);
       ELSIF v_param = 'N' THEN
          setup_six_giclb001(v_branch_cd  ,p_tran_id   ,p_gen_type                ,p_module_id            ,p_fund_cd,
                             p_user_id    ,v_separate_xol_entries                 ,p_message              ,p_message_type);
       END IF;
    END IF;
    
  --HERBERT 090401
    giac_acct_entries_pkg.offset_loss(p_tran_id, p_module_id, p_user_id);
    UPDATE gicl_take_up_hist
       SET acct_date = p_dsp_date,
           acct_tran_id = p_tran_id
     WHERE acct_date is null
       AND iss_cd = v_branch_cd;
  END LOOP;
END;
/


