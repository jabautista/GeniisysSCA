CREATE OR REPLACE PACKAGE CPI.giacr355_pkg
AS
   TYPE main_report_type IS RECORD (
      cf_company   giis_parameters.param_value_v%TYPE,
      cf_address   giis_parameters.param_value_v%TYPE,
      count_q1     NUMBER (30),
      count_q2     NUMBER (30),
      count_q3     NUMBER (30),
      count_q4     NUMBER (30),
      count_q5     NUMBER (30),
      count_q6     NUMBER (30)
   );

   TYPE main_report_tab IS TABLE OF main_report_type;

   TYPE q_report_type IS RECORD (
      policy_id   giac_batch_check_undist.policy_id%TYPE,
      policy_no   giac_batch_check_undist.policy_no%TYPE,
      panel       VARCHAR2 (100),
      trty        VARCHAR2 (100),
      binder_id   giac_batch_bad_binders.binder_id%TYPE,
      bill_no     VARCHAR2 (100)
   );

   TYPE q_report_tab IS TABLE OF q_report_type;

   FUNCTION get_main_report
      RETURN main_report_tab PIPELINED;

   FUNCTION get_q1_report
      RETURN q_report_tab PIPELINED;

   FUNCTION get_q2_report
      RETURN q_report_tab PIPELINED;

   FUNCTION get_q3_report
      RETURN q_report_tab PIPELINED;

   FUNCTION get_q4_report
      RETURN q_report_tab PIPELINED;

   FUNCTION get_q5_report
      RETURN q_report_tab PIPELINED;

   FUNCTION get_q6_report
      RETURN q_report_tab PIPELINED;
      
    -- SR-4798 : shan 07.21.2015
    TYPE report_type IS RECORD (
        cf_company          giis_parameters.param_value_v%TYPE,
        cf_address          giis_parameters.param_value_v%TYPE,
        subcode             NUMBER(2),
        subtitle            VARCHAR2(500),
        policy_id           giac_batch_check_undist.policy_id%TYPE,
        policy_no           giac_batch_check_undist.policy_no%TYPE,
        bill_no             VARCHAR2(20),
        par_id              GIPI_POLBASIC.PAR_ID%TYPE,
        old_dist_no         GIAC_BATCH_NEGATE_CHECK.DIST_NO_OLD%TYPE,
        old_dist_flag       GIAC_BATCH_NEGATE_CHECK.DIST_FLAG_OLD%TYPE,
        new_dist_no         GIAC_BATCH_NEGATE_CHECK.DIST_NO_NEW%TYPE,
        new_dist_flag       GIAC_BATCH_NEGATE_CHECK.DIST_FLAG_NEW%TYPE,
        negate_date         VARCHAR2(30),
        acct_neg_date       VARCHAR2(30),
        binder_id           GIAC_BATCH_BAD_BINDERS.BINDER_ID%TYPE,
        binder_no           VARCHAR2(20),
        old_rep_flag        GIAC_BATCH_BAD_BINDERS.OLD_REP_FLAG%TYPE,
        new_rep_flag        GIAC_BATCH_BAD_BINDERS.NEW_REP_FLAG%TYPE,
        trty_no             VARCHAR2(50),
        trty_name           VARCHAR2(50),
        peril_cd            GIPI_COMM_INV_PERIL.PERIL_CD%TYPE,
        peril_name          GIIS_PERIL.PERIL_NAME%TYPE
    );

    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_report_details
        RETURN report_tab PIPELINED;

    -- end SR-4798
END giacr355_pkg;
/


