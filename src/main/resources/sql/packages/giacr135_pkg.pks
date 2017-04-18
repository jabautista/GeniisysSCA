CREATE OR REPLACE PACKAGE CPI.giacr135_pkg
AS
   TYPE giacr135_record_type IS RECORD (
      currency_cd           NUMBER(2),
      check_released_by     VARCHAR2(30),
      dv_date               DATE,
      gibr_gfun_fund_cd     VARCHAR2(3),
      gibr_branch_cd        VARCHAR2(2),
      branch_name           VARCHAR2(50),
      bank_cd               VARCHAR2(3),
      bank_name             VARCHAR2(100),
      bank_acct_cd          VARCHAR2(4),
      bank_acct_no          VARCHAR2(30),
      check_date            DATE,
      check_pref_suf        VARCHAR2(5),
      check_no              VARCHAR2(200),     
      dv_no                 VARCHAR2(200),
      ref_no                VARCHAR2(15),
      posting_date          DATE,
      dv_flag               CHARACTER(1),
      dv_amt                NUMBER(12,2),
      check_release_date    DATE,
      tran_id               NUMBER(12),
      batch_tag             CHARACTER(1),
      disb_mode             CHARACTER(1),
      particulars           VARCHAR2(2000),
      gacc_tran_id          NUMBER(12),
      company_name          VARCHAR2 (100),
      company_address       VARCHAR2 (500),
      top_date              VARCHAR2(100),
      disb_mode_type        varchar2(20),
      check_amt             NUMBER,
      unreleased_amt        NUMBER,
      gdv_particulars       VARCHAR2(2000),  
      COUNT_SPOILED         NUMBER,
      count_cancelled       NUMBER,  
      COUNT_VALID_BT        NUMBER,
      COUNT_CANCEL_BT       NUMBER,    
      CS_COUNT_VALID_BT     NUMBER,
      CS_COUNT_CANCEL_BT    NUMBER,
      COUNT_CHECK           NUMBER,
      currency              VARCHAR2(2000),
      F_AMT_VALID           NUMBER,
      AMT_SPOILED           NUMBER,
      AMT_CANCELLED         NUMBER,
      BT_AMT_VALID          NUMBER,
      BT_AMT_CANCEL         NUMBER,
      V_BEGIN_DATE          DATE,
      V_END_DATE            DATE,
      view_check_date       varchar2(1000),
      view_check_no         varchar2(1000),
      view_dv_no            varchar2(1000),
      dsp_check_no          varchar2(1000),
      release_date    DATE,
      released_by     VARCHAR2(30)
   );

   TYPE giacr135_record_tab IS TABLE OF giacr135_record_type;

   FUNCTION get_giacr135_records (
      I_E_PARTICULARS           VARCHAR2,
           ORDERBY              VARCHAR2,
           P_BANK_ACCT_NO       VARCHAR2,
           P_BANK_CD            VARCHAR2,
           P_BRANCH             VARCHAR2,
           P_MODULE_ID          VARCHAR2,
           P_POST_TRAN_TOGGLE   VARCHAR2,
           P_SORT_ITEM          VARCHAR2,
           V_BEGIN_DATE         DATE,
           V_END_DATE           DATE,
           p_user_id            VARCHAR2   
   )
      RETURN giacr135_record_tab PIPELINED;
      
   FUNCTION get_details_in_order(
      i_e_particulars      VARCHAR2,
      orderby              VARCHAR2,
      p_bank_acct_no       VARCHAR2,
      p_bank_cd            VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_post_tran_toggle   VARCHAR2,
      p_sort_item          VARCHAR2,
      v_begin_date         VARCHAR2,
      v_end_date           VARCHAR2,
      p_user_id            VARCHAR2
   ) RETURN giacr135_record_tab PIPELINED;
END;
/


