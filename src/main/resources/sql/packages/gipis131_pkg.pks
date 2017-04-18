CREATE OR REPLACE PACKAGE CPI.gipis131_pkg
AS
   SUBTYPE drv_par_status_type IS VARCHAR2 (100);

   v_per_cache_def            NUMBER := 1000;
   v_limit                    NUMBER := 500; 
   v_cache_user_id            gipi_parlist_polbasic_v.user_id%TYPE;
   v_cache_search_by_opt      VARCHAR2 (100);
   v_cache_date_as_of         VARCHAR2 (100);
   v_cache_date_from          VARCHAR2 (100);
   v_cache_date_to            VARCHAR2 (100); 
   v_cache_par_stat           VARCHAR2 (100);
   v_cache_plist_line_cd      VARCHAR2 (100); 
   v_cache_plist_iss_cd       VARCHAR2 (100);
   v_cache_par_yy             NUMBER;
   v_cache_par_seq_no         NUMBER;
   v_cache_quote_seq_no       NUMBER;
   v_cache_assd_name          VARCHAR2 (100);
   v_cache_par_type           VARCHAR2 (100);
   v_cache_underwriter        VARCHAR2 (100);
   v_cache_drv_par_status     VARCHAR2 (100);
   v_cache_parhist            NUMBER;
   v_cache_user_grp_mod       NUMBER;
   v_cache_user_mod           NUMBER;

   TYPE valid_tab IS TABLE OF NUMBER
      INDEX BY VARCHAR2 (100);

   TYPE gipisfetch_rec IS RECORD
   ( 
      par_id           gipi_parlist_polbasic_v.par_id%TYPE,
      plist_line_cd    gipi_parlist_polbasic_v.plist_line_cd%TYPE,
      plist_iss_cd     gipi_parlist_polbasic_v.plist_iss_cd%TYPE,
      par_yy           gipi_parlist_polbasic_v.par_yy%TYPE,
      par_seq_no       gipi_parlist_polbasic_v.par_seq_no%TYPE,
      quote_seq_no     gipi_parlist_polbasic_v.quote_seq_no%TYPE,
      par_type         gipi_parlist_polbasic_v.par_type%TYPE,
      pbasic_line_cd   gipi_parlist_polbasic_v.pbasic_line_cd%TYPE,
      subline_cd       gipi_parlist_polbasic_v.subline_cd%TYPE,
      pbasic_iss_cd    gipi_parlist_polbasic_v.pbasic_iss_cd%TYPE,
      issue_yy         gipi_parlist_polbasic_v.issue_yy%TYPE,
      pol_seq_no       gipi_parlist_polbasic_v.pol_seq_no%TYPE,
      user_id          gipi_parlist_polbasic_v.user_id%TYPE,
      underwriter      gipi_parlist_polbasic_v.underwriter%TYPE,
      renew_no         gipi_parlist_polbasic_v.renew_no%TYPE, 
      incept_date      gipi_parlist_polbasic_v.incept_date%TYPE,
      expiry_date      gipi_parlist_polbasic_v.expiry_date%TYPE,
      eff_date         gipi_parlist_polbasic_v.eff_date%TYPE,
      issue_date       gipi_parlist_polbasic_v.issue_date%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      drv_par_status   drv_par_status_type,
      cred_branch      gipi_parlist_polbasic_v.cred_branch%TYPE,
      endt_iss_cd      gipi_parlist_polbasic_v.endt_iss_cd%TYPE, --Modified by Jerome Bautista SR 20483 10.01.2015
      endt_yy          gipi_parlist_polbasic_v.endt_yy%TYPE,     --Modified by Jerome Bautista SR 20483 10.01.2015
      endt_seq_no      gipi_parlist_polbasic_v.endt_seq_no%TYPE  --Modified by Jerome Bautista SR 20483 10.01.2015
   );

   v_order_col_order          VARCHAR2 (100); --modified by pjsantos 11/09/2016, for optimization GENQA 5803 
   v_order_col_order_format   VARCHAR2 (4);
   v_lastrun                  DATE; 
   v_count                    NUMBER;
   v_gipisfetch_rec           gipisfetch_rec;

   TYPE gipisfetch_tab IS TABLE OF gipisfetch_rec 
      INDEX BY BINARY_INTEGER;

   v_gipisfetch_tab_cache     gipisfetch_tab;
   v_gipisfetch_tab_empty     gipisfetch_tab;

   TYPE gipis131_type IS RECORD
   (
      rownum_          NUMBER,
      count_           NUMBER,
      par_id           gipi_parlist_polbasic_v.par_id%TYPE,
      plist_line_cd    gipi_parlist_polbasic_v.plist_line_cd%TYPE,
      plist_iss_cd     gipi_parlist_polbasic_v.plist_iss_cd%TYPE,
      par_yy           gipi_parlist_polbasic_v.par_yy%TYPE,
      par_seq_no       gipi_parlist_polbasic_v.par_seq_no%TYPE,
      quote_seq_no     gipi_parlist_polbasic_v.quote_seq_no%TYPE,
      par_type         gipi_parlist_polbasic_v.par_type%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      underwriter      gipi_parlist_polbasic_v.underwriter%TYPE,
      drv_par_status   VARCHAR2 (50),
      policy_no        VARCHAR2 (100),
      renew_no         VARCHAR2 (2),
      incept_date      DATE,
      expiry_date      DATE,
      eff_date         DATE,
      issue_date       DATE,
      cred_branch      gipi_polbasic.cred_branch%TYPE,
      endt_no          VARCHAR2 (100) --added by john 8.25.2015; FGICFULLWEB 18645
   );

   TYPE gipis131_tab IS TABLE OF gipis131_type;

   v_gipis131                 gipis131_tab;


   FUNCTION get_par_status (
      p_user_id             VARCHAR2,
      p_search_by_opt       VARCHAR2,
      p_date_as_of          VARCHAR2,
      p_date_from           VARCHAR2,
      p_date_to             VARCHAR2,
      p_par_stat            VARCHAR2,
      p_plist_line_cd       VARCHAR2,
      p_plist_iss_cd        VARCHAR2,
      p_par_yy              NUMBER,
      p_par_seq_no          NUMBER,
      p_quote_seq_no        NUMBER,
      p_assd_name           VARCHAR2,
      p_cred_branch         VARCHAR2,
      p_par_type            VARCHAR2,
      p_underwriter         VARCHAR2,
      p_drv_par_status      VARCHAR2,
      p_from_row            NUMBER DEFAULT 1,
      p_to_row              NUMBER DEFAULT 10,
      p_col_order           VARCHAR2 DEFAULT 'plist_line_cd',
      p_col_order_format    VARCHAR2 DEFAULT 'ASC',
      p_cache               NUMBER DEFAULT 0)
      RETURN gipis131_tab
      PIPELINED;

   TYPE par_history_type IS RECORD
   (
      par_stat       VARCHAR2 (200),
      parstat_date   VARCHAR2 (200),
      user_id        VARCHAR2 (200)
   );

   TYPE par_history_tab IS TABLE OF par_history_type;

   FUNCTION get_par_history (p_par_id gipi_parhist.par_id%TYPE)
      RETURN par_history_tab
      PIPELINED;
END;
/
