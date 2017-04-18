CREATE OR REPLACE PACKAGE CPI.GICLR204E3_PKG AS

TYPE prem_writn_priod_type IS RECORD(
    assd_no         giis_assured.ASSD_NO%TYPE,
    policy_no       varchar2(40),
    endt_iss_cd     gipi_polbasic.ENDT_ISS_CD%TYPE,
    endt_yy         gipi_polbasic.ENDT_YY%TYPE,
    endt_seq_no     gipi_polbasic.ENDT_SEQ_NO%TYPE,
    incept_date     gipi_polbasic.INCEPT_DATE%TYPE,
    expiry_date     gipi_polbasic.EXPIRY_DATE%TYPE,
    tsi_amt         gipi_polbasic.TSI_AMT%TYPE,
    sum_prem_amt    gipi_polbasic.PREM_AMT%TYPE,
    assd_name       giis_assured.ASSD_NAME%TYPE,
    policy_id       gipi_polbasic.POLICY_ID%TYPE,
    header_date     varchar2(100),
    v_date          varchar2(40),
    transaction_month varchar2(40)
    );

TYPE prem_writn_priod_tab IS TABLE OF prem_writn_priod_type;



TYPE prem_writn_year_type IS RECORD(
    assured         varchar2(200),
    intm_no         giis_intermediary.INTM_NO%TYPE,
    assd_no         giis_assured.ASSD_NO%TYPE,
    policy_no       varchar2(40),
    endt_iss_cd     gipi_polbasic.ENDT_ISS_CD%TYPE,
    endt_yy         gipi_polbasic.ENDT_YY%TYPE,
    endt_seq_no     gipi_polbasic.ENDT_SEQ_NO%TYPE,
    incept_date     gipi_polbasic.INCEPT_DATE%TYPE,
    expiry_date     gipi_polbasic.EXPIRY_DATE%TYPE,
    tsi_amt         gipi_polbasic.TSI_AMT%TYPE,
    sum_prem_amt    gipi_polbasic.PREM_AMT%TYPE,
    intm_name       giis_intermediary.INTM_NAME%TYPE,
    assd_name       giis_assured.ASSD_NAME%TYPE,
    policy_id       gipi_polbasic.POLICY_ID%TYPE,
    header_date     varchar2(100),
    intermediary_   varchar2(100),
    v_date          varchar2(40),
    transaction_month varchar2(40)
    );

TYPE prem_writn_year_tab IS TABLE OF prem_writn_year_type;



TYPE outstndng_loss_as_of_type IS RECORD(
     
    intm_no         giis_intermediary.INTM_NO%TYPE, --
    assd_no         giis_assured.ASSD_NO%TYPE,      --
    claim_no        varchar2(40),
    intm_name       giis_intermediary.INTM_NAME%TYPE,   --
    assd_name       giis_assured.ASSD_NAME%TYPE,    --
    header_date     varchar2(100),
    assured   varchar2(600), --
    claim_id        gicl_lratio_curr_os_ext.CLAIM_ID%Type, --
    os_amt          gicl_lratio_curr_os_ext.OS_AMT%Type, --
    dsp_loss_date   gicl_claims.dsp_loss_date%type,--
    clm_file_date   gicl_claims.clm_file_date%type -- 
    );

TYPE outstndng_loss_as_of_tab IS TABLE OF outstndng_loss_as_of_type;

TYPE losses_pd_curr_year_type IS RECORD(
     
    intm_no         giis_intermediary.INTM_NO%TYPE, 
    assd_no         giis_assured.ASSD_NO%TYPE,      
    claim_no        varchar2(40),
    intm_name       giis_intermediary.INTM_NAME%TYPE,   
    assd_name       giis_assured.ASSD_NAME%TYPE,    
    header_date     varchar2(100),
    claim_id        gicl_lratio_curr_os_ext.CLAIM_ID%Type, 
    sum_loss_paid          gicl_lratio_curr_os_ext.OS_AMT%Type, 
    dsp_loss_date   gicl_claims.dsp_loss_date%type
    );

TYPE losses_pd_curr_year_tab IS TABLE OF losses_pd_curr_year_type;
TYPE loss_recovery_period_type IS RECORD(
    
    assd_no         giis_assured.ASSD_NO%TYPE,
    assd_name       giis_assured.ASSD_NAME%TYPE,
    rec_type_desc   giis_recovery_type.REC_TYPE_DESC%TYPE,
    sum_recovered_amt   gicl_lratio_curr_recovery_ext.RECOVERED_AMT%TYPE, 
    dsp_loss_date   gicl_claims.dsp_loss_date%type,
    recovery_no     varchar2(100),
    header_date     varchar2(100)
    );

TYPE loss_recovery_period_tab IS TABLE OF loss_recovery_period_type;


TYPE loss_recovery_year_type IS RECORD(

    assd_no         giis_assured.ASSD_NO%TYPE,
    intm_no         giis_intermediary.INTM_NO%TYPE,
    intm_name       giis_intermediary.INTM_NAME%TYPE,
    assd_name       giis_assured.ASSD_NAME%TYPE,
    rec_type_desc   giis_recovery_type.REC_TYPE_DESC%TYPE,
    sum_recovered_amt   gicl_lratio_curr_recovery_ext.RECOVERED_AMT%TYPE, 
    dsp_loss_date   gicl_claims.dsp_loss_date%type,
    recovery_no     varchar2(100),
    header_date     varchar2(100)
    );

TYPE loss_recovery_year_tab IS TABLE OF loss_recovery_year_type;


TYPE main_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE
);

TYPE main_tab IS TABLE OF main_type;

FUNCTION populate_prem_writn_priod(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_start_date   varchar2,
    p_curr_end_date     varchar2,
    p_print_date        varchar2
)
RETURN prem_writn_priod_tab PIPELINED;

FUNCTION populate_prem_writn_year(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_prev_year   varchar2,
    p_print_date        varchar2
)
RETURN prem_writn_year_tab PIPELINED;


FUNCTION populate_outstndng_loss_as_of(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_end_date varchar2
    
)
RETURN outstndng_loss_as_of_tab PIPELINED;

FUNCTION populate_outstndng_loss_prev(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_prev_end_date varchar2
)
RETURN outstndng_loss_as_of_tab PIPELINED;

FUNCTION populate_losses_pd_curr_year(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_year      varchar
)
RETURN losses_pd_curr_year_tab PIPELINED;

FUNCTION populate_loss_recovery_period(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_start_dt varchar2,
    p_curr_end_dt varchar2
)
RETURN loss_recovery_period_tab PIPELINED;

FUNCTION populate_loss_recovery_year(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_prev_year number
)
RETURN loss_recovery_year_tab PIPELINED;

FUNCTION populate_main
RETURN main_tab PIPELINED;

FUNCTION get_datevalue(
    p_prnt_date     varchar2,
    p_policy_id       GIPI_POLBASIC.POLICY_ID%TYPE
)
RETURN varchar2;

END GICLR204E3_PKG;
/


