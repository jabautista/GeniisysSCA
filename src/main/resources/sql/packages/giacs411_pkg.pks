CREATE OR REPLACE PACKAGE CPI.GIACS411_PKG
AS
   TYPE tran_year_lov_type IS RECORD (
      tran_year   giac_monthly_totals.tran_year%TYPE
   );

   TYPE tran_year_lov_tab IS TABLE OF tran_year_lov_type;

   TYPE tran_mm_lov_type IS RECORD (
      tran_year   giac_monthly_totals.tran_year%TYPE,
      tran_mm     giac_monthly_totals.tran_mm%TYPE
   );

   TYPE tran_mm_lov_tab IS TABLE OF tran_mm_lov_type;

   TYPE module_id_type IS RECORD (
      module_id   giac_modules.module_id%TYPE,
      gen_type    giac_modules.generation_type%TYPE,
      msg         VARCHAR2 (50)
   );

   TYPE module_id_tab IS TABLE OF module_id_type;

   FUNCTION get_tran_year_lov
      RETURN tran_year_lov_tab PIPELINED;

   FUNCTION get_tran_mm_lov (p_tran_year giac_monthly_totals.tran_year%TYPE)
      RETURN tran_mm_lov_tab PIPELINED;

   FUNCTION get_gl_no
      RETURN VARCHAR2;

   FUNCTION get_finance_end
      RETURN VARCHAR2;

   FUNCTION get_fiscal_end
      RETURN VARCHAR2;

   FUNCTION cye_get_module_id
      RETURN module_id_tab PIPELINED;

   PROCEDURE close_mm_yr (
      p_tran_year     IN     giac_monthly_totals.tran_year%TYPE,
      p_tran_mm       IN     giac_monthly_totals.tran_mm%TYPE,
      p_gl_no         IN     NUMBER,
      p_finance_end   IN     NUMBER,
      p_fiscal_end    IN     NUMBER,
      p_msg           IN OUT VARCHAR2
   );
   
   PROCEDURE confirm_close_mm_yr (
      p_tran_year     IN giac_monthly_totals.tran_year%TYPE,
      p_tran_mm       IN giac_monthly_totals.tran_mm%TYPE,
      p_gl_no         IN NUMBER,
      p_finance_end   IN NUMBER,
      p_fiscal_end    IN NUMBER,
      p_gen_type      IN GIAC_MODULES.generation_type%TYPE,
      p_module_id     IN GIAC_MODULES.module_id%TYPE,
      p_user_id       IN GIIS_USERS.user_id%TYPE,
      p_msg       IN OUT VARCHAR2
   );

   PROCEDURE close_normal_month (
      p_tran_year   IN   NUMBER,
      p_tran_mm     IN   NUMBER,
      p_gl_no            NUMBER
   );

   PROCEDURE cye_close_yearend (
      p_tran_year     IN        NUMBER,
      p_tran_mm       IN        NUMBER,
      p_gl_no         IN        NUMBER,
      p_finance_end   IN        NUMBER,
      p_fiscal_end    IN        NUMBER,
      p_gen_type      IN        GIAC_MODULES.generation_type%TYPE,
      p_module_id     IN        giac_modules.module_id%TYPE,
      p_user_id       IN        GIIS_USERS.user_id%TYPE,
      p_msg           IN OUT    VARCHAR2
   );

   PROCEDURE cye_get_process_no (
      p_tran_year             NUMBER,
      p_tran_mm               NUMBER,
      p_process_no   IN OUT   NUMBER
   );

   PROCEDURE cye_delete_temp_tables (
      p_tran_year   IN       NUMBER,
      p_tran_mm     IN       NUMBER,
      p_msg         IN OUT   VARCHAR2
   );

   PROCEDURE cye_extract_ie_entries (p_tran_year IN NUMBER, p_tran_mm IN NUMBER);

   PROCEDURE cye_create_rev_entries (
      p_tran_year     IN   NUMBER,
      p_tran_mm       IN   NUMBER,
      p_gl_no         IN   NUMBER,
      p_finance_end   IN   NUMBER,
      p_fiscal_end    IN   NUMBER,
      p_gen_type      IN   giac_modules.generation_type%TYPE,
      p_user_id       IN   giis_users.user_id%TYPE
   );

   PROCEDURE cye_update_giac_finance_yr (
      p_tran_year     IN   NUMBER,
      p_tran_mm       IN   NUMBER,
      p_gl_no         IN   NUMBER,
      p_finance_end   IN   NUMBER,
      p_fiscal_end    IN   NUMBER,
      p_gen_type      IN   giac_modules.generation_type%TYPE,
      p_module_id     IN   giac_modules.module_id%TYPE
   );

   PROCEDURE cye_sum_post_rev_entries (
      p_tran_year      IN   NUMBER,
       p_tran_mm       IN   NUMBER,
       p_gl_no         IN   NUMBER,
       p_finance_end   IN   NUMBER,
       p_fiscal_end    IN   NUMBER,
       p_gen_type      IN   giac_modules.generation_type%TYPE,
       p_user_id       IN   giis_users.user_id%TYPE,
       p_module_id     IN   giac_modules.module_id%TYPE
   );

   PROCEDURE cye_insert_acct_entries (
      p_tran_year   IN   NUMBER,
      p_tran_mm     IN   NUMBER
   );
   
   PROCEDURE cye_create_acctrans_record (
       p_tran_year     IN       NUMBER,
       p_tran_mm       IN       NUMBER,
       p_fund_cd       IN       giac_close_acct_entries_ext.gacc_gfun_fund_cd%TYPE,
       p_branch_cd     IN       giac_close_acct_entries_ext.gacc_gibr_branch_cd%TYPE,
       p_particulars   IN       giac_acctrans.particulars%TYPE,
       p_tran_class    IN       giac_acctrans.tran_class%TYPE,
       p_tran_id       OUT      giac_acctrans.tran_id%TYPE,
       p_user_id       IN       GIIS_USERS.user_id%TYPE
    );
    
    PROCEDURE cye_get_eoy_gl_acct_code (
       p_tran_mm            IN       NUMBER,
       p_gl_acct_id         OUT      giac_acct_entries.gl_acct_id%TYPE,
       p_gl_acct_category   OUT      giac_acct_entries.gl_acct_category%TYPE,
       p_gl_control_acct    OUT      giac_acct_entries.gl_control_acct%TYPE,
       p_gl_sub_acct_1      OUT      giac_acct_entries.gl_sub_acct_1%TYPE,
       p_gl_sub_acct_2      OUT      giac_acct_entries.gl_sub_acct_2%TYPE,
       p_gl_sub_acct_3      OUT      giac_acct_entries.gl_sub_acct_3%TYPE,
       p_gl_sub_acct_4      OUT      giac_acct_entries.gl_sub_acct_4%TYPE,
       p_gl_sub_acct_5      OUT      giac_acct_entries.gl_sub_acct_5%TYPE,
       p_gl_sub_acct_6      OUT      giac_acct_entries.gl_sub_acct_6%TYPE,
       p_gl_sub_acct_7      OUT      giac_acct_entries.gl_sub_acct_7%TYPE,
       p_gl_no              IN       NUMBER,
       p_finance_end        IN       NUMBER,
       p_fiscal_end         IN       NUMBER,
       p_gen_type           IN       giac_modules.generation_type%TYPE,
       p_module_id          IN       giac_modules.module_id%TYPE
    );
END;
/


