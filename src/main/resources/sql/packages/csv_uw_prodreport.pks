CREATE OR REPLACE PACKAGE cpi.csv_uw_prodreport  
AS
   /* ===============================================================================================================
   * Created by:     Apollo Cruz
   * Date Created:   05.27.2015
   * Purpose:        UW-SPECS-2015-056-CSV FOR UW Production Report
   *                 AFPGEN-IMPLEM-SR 4564
   *                 Breakdown of csv_undrwrtng package. Package will hold all underwriting production report CSVs.
   * ============================================================================================================== */
   TYPE dynamic_csv_rec_type IS RECORD (rec VARCHAR2 (32767));

   TYPE dynamic_csv_rec_tab IS TABLE OF dynamic_csv_rec_type;

   TYPE gipir930_type IS RECORD
   (
      iss_name         VARCHAR2 (50),
      line             VARCHAR2 (25),
      subline          VARCHAR2 (40),
      policy_no        VARCHAR2 (100),
      assured          VARCHAR2 (500),
      incept_date      DATE,
      expiry_date      DATE,
      total_si         NUMBER (38, 2),
      tot_premium      NUMBER (38, 2),
      binder_no        VARCHAR2 (14),
      ri_short_name    VARCHAR2 (16),
      sum_reinsured    NUMBER (38, 2),
      share_prem       NUMBER (38, 2),
      share_prem_vat   NUMBER (38, 2),
      ri_comm          NUMBER (38, 2),
      comm_vat         NUMBER (38, 2),
      wholding_vat     NUMBER (38, 2),
      net_due          NUMBER (38, 2)
   );

   TYPE gipir930_tab IS TABLE OF gipir930_type;

   FUNCTION get_gipir930 (p_iss_cd        VARCHAR2,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_scope         VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       VARCHAR2)
      RETURN gipir930_tab
      PIPELINED;

   TYPE gipir930a_type IS RECORD
   (
      iss_name         VARCHAR2 (50),
      line             giis_line.line_name%TYPE,
      subline          giis_subline.subline_name%TYPE,
      bndr_count       NUMBER (38),
      sum_insured      NUMBER (38, 2),
      premium          NUMBER (38, 2),
      sum_reinsured    NUMBER (38, 2),
      share_prem       NUMBER (38, 2),
      share_prem_vat   NUMBER (38, 2),
      ri_comm          NUMBER (38, 2),
      comm_vat         NUMBER (38, 2),
      wholding_vat     NUMBER (38, 2),
      net_due          NUMBER (38, 2)
   );

   TYPE gipir930a_tab IS TABLE OF gipir930a_type;

   FUNCTION get_gipir930a (p_iss_cd        VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_scope         VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       VARCHAR2)
      RETURN gipir930a_tab
      PIPELINED;

   TYPE dyn_sql_query IS RECORD
   (
      query1   VARCHAR2 (4000),
      query2   VARCHAR2 (4000),
      query3   VARCHAR2 (4000),
      query4   VARCHAR2 (4000),
      query5   VARCHAR2 (4000),
      query6   VARCHAR2 (4000),
      query7   VARCHAR2 (4000),
      query8   VARCHAR2 (4000)
   );

   TYPE dyn_sql_query_tab IS TABLE OF dyn_sql_query;

   FUNCTION get_gipir924k (p_tab           VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_scope         VARCHAR2,
                           p_user_id       VARCHAR2,
                           p_param_date    VARCHAR2,
                           p_from_date     VARCHAR2,
                           p_to_date       VARCHAR2,
                           p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED;

   FUNCTION get_date_format (p_date DATE)
      RETURN VARCHAR2;

   /** ====================================================================================================================================
    **            D  I  S  T  R  I  B  U  T  I  O  N   R  E  G  I  S  T E  R   ( T A B  2 ) r e p o r t s
    **
    **    1) GIPIR928A - Distribution Register
    **    2) GIPIR928  - Treaty Distribution Per Peril
    **    3) GIPIR928B - Distribution Register Per Policy
    **    4) GIPIR928C - Distribution Register Per Peril
    **    5) GIPIR928D - Distribution Register Per Line and Subline
    **    6) GIPIR928E - Dist Reg With Breakdown - Summary
    **    7) GIPIR928F - Dist Reg With Breakdown - Detailed
    ** ================================================================================================================================== */
   TYPE gipir928_rec_type IS RECORD
   (
      iss_cd             giis_issource.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      cred_branch        giis_issource.iss_cd%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      policy_no          VARCHAR2 (100),
      peril_sname        VARCHAR2 (10),
      peril_type         giis_peril.peril_type%TYPE,
      trty_name          VARCHAR2 (50), --benjo 02.03.2016 MAC-SR-21220
      tsi_amt            NUMBER (38, 2),
      prem_amt           NUMBER (38, 2)
   );

   TYPE gipir928_type IS TABLE OF gipir928_rec_type;

   TYPE gipir928a_rec_type IS RECORD
   (
      iss_cd                  giis_issource.iss_cd%TYPE,
      iss_source_name         giis_issource.iss_name%TYPE,
      cred_branch             giis_issource.iss_cd%TYPE,
      cred_branch_name        giis_issource.iss_name%TYPE,
      line_cd                 giis_line.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE,
      subline_cd              giis_subline.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE,
      policy_no               VARCHAR2 (100),
      peril_sname             VARCHAR2 (10),
      peril_type              giis_peril.peril_type%TYPE,
      net_retention_risk      NUMBER (38, 2),
      net_retention_premium   NUMBER (38, 2),
      treaty_risk             NUMBER (38, 2),
      treaty_prem             NUMBER (38, 2),
      facultative_risk        NUMBER (38, 2),
      facultative_prem        NUMBER (38, 2)
   );

   TYPE gipir928a_type IS TABLE OF gipir928a_rec_type;

   TYPE gipir928b_rec_type IS RECORD
   (
      iss_cd             giis_issource.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      cred_branch        giis_issource.iss_cd%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      policy_no          VARCHAR2 (100),
      net_ret_tsi        NUMBER (38, 2),
      net_ret_prem       NUMBER (38, 2),
      treaty_tsi         NUMBER (38, 2),
      treaty_prem        NUMBER (38, 2),
      facultative_tsi    NUMBER (38, 2),
      facultative_prem   NUMBER (38, 2),
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2)
   );

   TYPE gipir928b_type IS TABLE OF gipir928b_rec_type;

   TYPE gipir928c_rec_type IS RECORD
   (
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      peril_sname        giis_peril.peril_sname%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      peril_type         giis_peril.peril_type%TYPE,
      net_ret_tsi        NUMBER (38, 2),
      net_ret_prem       NUMBER (38, 2),
      treaty_tsi         NUMBER (38, 2),
      treaty_prem        NUMBER (38, 2),
      facultative_tsi    NUMBER (38, 2),
      facultative_prem   NUMBER (38, 2),
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2)
   );

   TYPE gipir928c_type IS TABLE OF gipir928c_rec_type;

   TYPE gipir928d_rec_type IS RECORD
   (
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      pol_count          NUMBER (38),
      net_ret_tsi        NUMBER (38, 2),
      net_ret_prem       NUMBER (38, 2),
      treaty_tsi         NUMBER (38, 2),
      treaty_prem        NUMBER (38, 2),
      facultative_tsi    NUMBER (38, 2),
      facultative_prem   NUMBER (38, 2),
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2)
   );

   TYPE gipir928d_type IS TABLE OF gipir928d_rec_type;

   TYPE gipir928e_rec_type IS RECORD
   (
      iss_name     VARCHAR2 (50),
      line         giis_line.line_name%TYPE,
      subline      giis_subline.subline_name%TYPE,
      nr_tsi       NUMBER (38, 2),
      tr_tsi       NUMBER (38, 2),
      fa_tsi       NUMBER (38, 2),
      total_tsi    NUMBER (38, 2),
      nr_prem      NUMBER (38, 2),
      tr_prem      NUMBER (38, 2),
      fa_prem      NUMBER (38, 2),
      total_prem   NUMBER (38, 2)
   );

   TYPE gipir928e_type IS TABLE OF gipir928e_rec_type;

   TYPE gipir928f_rec_type IS RECORD
   (
      iss_name      VARCHAR2 (50),
      line          giis_line.line_name%TYPE,
      subline       giis_subline.subline_name%TYPE,
      policy_no     VARCHAR2 (100),
      peril_sname   VARCHAR2 (10),
      nr_tsi        NUMBER (38, 2),
      nr_prem       NUMBER (38, 2),
      tr_tsi        NUMBER (38, 2),
      tr_prem       NUMBER (38, 2),
      fa_tsi        NUMBER (38, 2),
      fa_prem       NUMBER (38, 2),
      total_tsi     NUMBER (38, 2),
      total_prem    NUMBER (38, 2)
   );

   TYPE gipir928f_type IS TABLE OF gipir928f_rec_type;

   FUNCTION get_gipir928 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928_type
      PIPELINED;

   FUNCTION get_gipir928a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928a_type
      PIPELINED;

   FUNCTION get_gipir928b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928b_type
      PIPELINED;

   FUNCTION get_gipir928c (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928c_type
      PIPELINED;

   FUNCTION get_gipir928d (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928d_type
      PIPELINED;

   FUNCTION get_gipir928e (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928e_type
      PIPELINED;

   FUNCTION get_gipir928f (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir928f_type
      PIPELINED;

   /** ====================================================================================================================================
    **            P  E  R   P  E  R  I  L  /  A  G  E  N T ( T A B 4 ) R e p o r t s
    **
    **    1) GIPIR946B - Per Peril - Summary
    **    2) GIPIR946  - Per Peril - Detailed
    **    3) GIPIR946F - Per Agent - Summary
    **    4) GIPIR946D - Per Agent - Detailed
    ** ================================================================================================================================== */
   TYPE gipir946b_rec_type IS RECORD
   (
      iss_name     VARCHAR2 (50),
      line         giis_line.line_name%TYPE,
      subline      giis_subline.subline_name%TYPE,
      peril_name   VARCHAR2 (20),
      peril_type   VARCHAR2 (1),
      tsi_amt      NUMBER (38, 2),
      prem_amt     NUMBER (38, 2),
      comm_amt     NUMBER (38, 2)
   );

   TYPE gipir946b_type IS TABLE OF gipir946b_rec_type;

   TYPE gipir946_rec_type IS RECORD
   (
      iss_name     VARCHAR2 (50),
      line         giis_line.line_name%TYPE,
      subline      giis_subline.subline_name%TYPE,
      peril_name   VARCHAR2 (20),
      peril_type   VARCHAR2 (1),
      intm_name    VARCHAR2 (250),
      tsi_amt      NUMBER (38, 2),
      prem_amt     NUMBER (38, 2),
      comm_amt     NUMBER (38, 2)
   );

   TYPE gipir946_type IS TABLE OF gipir946_rec_type;

   TYPE gipir946f_rec_type IS RECORD
   (
      iss_name   VARCHAR2 (50),
      line       giis_line.line_name%TYPE,
      subline    giis_subline.subline_name%TYPE,
      agent      VARCHAR2 (300),
      tsi_amt    NUMBER (38, 2),
      prem_amt   NUMBER (38, 2)
   );

   TYPE gipir946f_type IS TABLE OF gipir946f_rec_type;

   TYPE gipir946d_rec_type IS RECORD
   (
      iss_name     VARCHAR2 (50),
      line         giis_line.line_name%TYPE,
      subline      giis_subline.subline_name%TYPE,
      agent        VARCHAR2 (300),
      peril_name   VARCHAR2 (20),
      peril_type   VARCHAR2 (1),
      tsi_amt      NUMBER (38, 2),
      prem_amt     NUMBER (38, 2)
   );

   TYPE gipir946d_type IS TABLE OF gipir946d_rec_type;

   FUNCTION get_gipir946b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946b_type
      PIPELINED;

   FUNCTION get_gipir946 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946_type
      PIPELINED;

   FUNCTION get_gipir946f (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946f_type
      PIPELINED;

   FUNCTION get_gipir946d (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir946d_type
      PIPELINED;

   /** ====================================================================================================================================
    **            P  E  R   A  S  S  D  /  I  N  T  M  ( T A B 5 ) R e p o r t s
    **
    **    1) GIPIR924A - Per Assured - Summary
    **    2) GIPIR923A - Per Assured - Detailed
    **    3) GIPIR924B - Per Intermediary - Summary
    **    4) GIPIR923B - Per Intermediary - Detailed
    ** ================================================================================================================================== */
   TYPE gipir924a_v2_rec_type IS RECORD
   (
      extract_basis      VARCHAR2 (100),
      assd_no            giis_assured.assd_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      branch_name        VARCHAR2 (500),
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      pol_count          NUMBER (38),
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2),
      evatprem           NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total_amt_due      NUMBER (38, 2)
   );

   TYPE gipir924a_v2_type IS TABLE OF gipir924a_v2_rec_type;

   TYPE gipir923a_rec_type IS RECORD
   (
      assd_no            giis_assured.assd_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      cred_branch        giis_issource.iss_cd%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      policy_no          VARCHAR2 (1000),
      issue_date         DATE,
      incept_date        DATE,
      expiry_date        DATE,
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2),
      evatprem           NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total_amt_due      NUMBER (38, 2)
   );

   TYPE gipir923a_type IS TABLE OF gipir923a_rec_type;

   TYPE gipir924b_rec_type IS RECORD
   (
      extract_basis      VARCHAR2 (100),
      branch_name        VARCHAR2 (50),
      intm_type          VARCHAR2 (30),
      intm_no            giis_intermediary.intm_no%TYPE,
      intm_name          VARCHAR2 (250),
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      pol_count          NUMBER (38),
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2),
      prem_share_amt     NUMBER (38, 2),
      vatprem            NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total_amt_due      NUMBER (38, 2),
      commission         NUMBER (38, 2)
   );

   TYPE gipir924b_type IS TABLE OF gipir924b_rec_type;

   TYPE gipir923b_rec_type IS RECORD
   (
      iss_cd             giis_issource.iss_cd%TYPE,
      iss_name           VARCHAR2 (50),
      cred_branch        giis_issource.iss_cd%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      intm_type          VARCHAR2 (30),
      intm_no            giis_intermediary.intm_no%TYPE,
      intm_name          giis_intermediary.intm_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_subline.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      policy_no          VARCHAR2 (100),
      assd_no            giis_assured.assd_no%TYPE,
      assured_name       giis_assured.assd_name%TYPE,
      invoice_no         VARCHAR2 (500),
      incept_date        DATE,
      expiry_date        DATE,
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2),
      premium_shr_amt    NUMBER (38, 2),
      evatprem           NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total_amt_due      NUMBER (38, 2),
      commission         NUMBER (38, 2)
   );

   TYPE gipir923b_type IS TABLE OF gipir923b_rec_type;

   FUNCTION get_gipir924a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924a_v2_type
      PIPELINED;

   FUNCTION get_gipir923a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir923a_type
      PIPELINED;

   FUNCTION get_gipir924b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924b_type
      PIPELINED;

   FUNCTION get_gipir923b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir923b_type
      PIPELINED;

   /** ====================================================================================================================================
    **            I  N  W  A  R  D   R  I   ( T A B  8)
    **
    **    1) GIPIR929B - Inward RI - Summary
    **    2) GIPIR929A - Inward RI - Detailed
    ** ================================================================================================================================== */
   TYPE gipir929b_rec_type IS RECORD
   (
      iss_name           VARCHAR2 (50),
      intm_name          VARCHAR2 (250),
      line               giis_line.line_name%TYPE,
      subline            giis_subline.subline_name%TYPE,
      policy_no          VARCHAR2 (300),
      incept_date        DATE,
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2),
      evatprem           NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total              NUMBER (38, 2),
      commission         NUMBER (38, 2),
      ri_comm_vat        NUMBER (38, 2)
   );

   TYPE gipir929b_type IS TABLE OF gipir929b_rec_type;

   TYPE gipir929a_rec_type IS RECORD
   (
      iss_name           VARCHAR2 (50),
      intm_name          VARCHAR2 (250),
      line               giis_line.line_name%TYPE,
      subline            giis_subline.subline_name%TYPE,
      pol_count          NUMBER (38),
      total_tsi          NUMBER (38, 2),
      total_prem         NUMBER (38, 2),
      evatprem           NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total              NUMBER (38, 2),
      commission         NUMBER (38, 2),
      ri_comm_vat        NUMBER (38, 2)
   );

   TYPE gipir929a_type IS TABLE OF gipir929a_rec_type;

   FUNCTION get_gipir929b (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir929b_type
      PIPELINED;

   FUNCTION get_gipir929a (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir929a_type
      PIPELINED;

   /** ====================================================================================================================================
    **            U N D I S T R I B U T E D
    **
    **    1) GIPIR924C - Undistributed - Consolidated All Branches
    **    2) GIPIR924D - Undistributed - Not Consolidated All Branches
    ** ================================================================================================================================== */
   TYPE gipir924c_rec_type IS RECORD
   (
      rv_meaning    VARCHAR2 (100),
      line          giis_line.line_name%TYPE,
      subline       giis_subline.subline_name%TYPE,
      policy_no     VARCHAR2 (45),
      assured       VARCHAR2 (500),
      issue_date    DATE,
      incept_date   DATE,
      tsi_amt       NUMBER (38, 2),
      prem_amt      NUMBER (38, 2)
   );

   TYPE gipir924c_type IS TABLE OF gipir924c_rec_type;

   TYPE gipir924d_rec_type IS RECORD
   (
      iss_name      VARCHAR2 (50),
      rv_meaning    VARCHAR2 (100),
      line          giis_line.line_name%TYPE,
      subline       giis_subline.subline_name%TYPE,
      policy_no     VARCHAR2 (45),
      assured       VARCHAR2 (500),
      issue_date    DATE,
      incept_date   DATE,
      tsi_amt       NUMBER (38, 2),
      prem_amt      NUMBER (38, 2)
   );

   TYPE gipir924d_type IS TABLE OF gipir924d_rec_type;

   FUNCTION get_gipir924c (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924c_type
      PIPELINED;

   FUNCTION get_gipir924d (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924d_type
      PIPELINED;

   /** ====================================================================================================================================
    **            P  O  L  I  C  Y   R  E  G  I  S  T  E  R
    **
    **    1) GIPIR924F - Policy Register - Summary
    **    2) GIPIR924E - Policy Register - Detailed
    ** ================================================================================================================================== */
   TYPE gipir924f_rec_type IS RECORD
   (
      iss_name           VARCHAR2 (50),
      line               gipi_uwreports_ext.line_cd%TYPE,
      subline            giis_subline.subline_name%TYPE,
      pol_count          NUMBER (38),
      tot_sum_insured    NUMBER (38, 2),
      tot_premium        NUMBER (38, 2),
      evat               NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total              NUMBER (38, 2),
      commission         NUMBER (20, 2)
   );

   TYPE gipir924f_type IS TABLE OF gipir924f_rec_type;

   TYPE gipir924e_rec_type IS RECORD
   (
      iss_name           VARCHAR2 (50),
      line               giis_line.line_name%TYPE,
      subline            giis_subline.subline_name%TYPE,
      pol_flag           VARCHAR2 (100),
      policy_no          VARCHAR2 (100),
      assured            VARCHAR2 (500),
      issue_date         DATE,
      incept_date        DATE,
      expiry_date        DATE,
      tot_sum_insured    NUMBER (38, 2),
      tot_premium        NUMBER (38, 2),
      evat               NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total              NUMBER (38, 2),
      commission         NUMBER (20, 2)
   );

   TYPE gipir924e_type IS TABLE OF gipir924e_rec_type;

   FUNCTION get_gipir924f (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924f_type
      PIPELINED;

   FUNCTION get_gipir924e (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_user_id       giis_users.user_id%TYPE)
      RETURN gipir924e_type
      PIPELINED;

   /** ====================================================================================================================================
    **            E D S T
    ** ================================================================================================================================== */
   TYPE edst_rec_type IS RECORD
   (
      line_cd         gipi_polbasic.line_cd%TYPE,
      tin             giis_assured.assd_tin%TYPE,
      branch          gipi_uwreports_ext.iss_cd%TYPE,
      branch_tin_cd   giis_issource.branch_tin_cd%TYPE,
      no_tin          giis_assured.no_tin_reason%TYPE,
      reason          giis_assured.no_tin_reason%TYPE,
      company         giis_assured.assd_name%TYPE,
      first_name      giis_assured.assd_name%TYPE,
      middle_name     giis_assured.assd_name%TYPE,
      last_name       giis_assured.assd_name%TYPE,
      tax_base        edst_ext.total_prem%TYPE,
      tsi_amt         edst_ext.total_tsi%TYPE
   );

   TYPE edst_type IS TABLE OF edst_rec_type;

   FUNCTION get_edst (p_scope           edst_param.scope%TYPE,
                      p_from_date       edst_param.from_date%TYPE,
                      p_to_date         edst_ext.to_date1%TYPE,
                      p_negative_amt    VARCHAR2,
                      p_ctpl_pol        NUMBER,
                      p_inc_spo         VARCHAR2,
                      p_user            edst_param.user_id%TYPE,
                      p_line_cd         VARCHAR2,
                      p_subline_cd      VARCHAR2,
                      p_iss_cd          VARCHAR2,
                      p_iss_param       NUMBER)
      RETURN edst_type
      PIPELINED;

   FUNCTION get_gipir923c (p_tab           VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_scope         VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_user_id       VARCHAR2,
                           p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED;

   /*for handling of special characters*/
   FUNCTION escape_string (p_string VARCHAR2)
      RETURN VARCHAR2;



   FUNCTION get_gipir923 (p_iss_cd        VARCHAR2,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_scope         VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       VARCHAR2,
                          p_tab           VARCHAR2,
                          p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED;

   FUNCTION get_gipir924 (p_iss_cd        VARCHAR2,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_scope         VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id       VARCHAR2,
                          p_tab           VARCHAR2,
                          p_reinstated    VARCHAR2)
      RETURN dynamic_csv_rec_tab
      PIPELINED;
END;

CREATE OR REPLACE PUBLIC SYNONYM csv_uw_prodreport FOR cpi.csv_uw_prodreport;