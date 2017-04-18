CREATE OR REPLACE PACKAGE CPI.CSV_UNDRWRTNG
AS
/* Modified by : Jhing 12.05.2012 added modifications by Bhev Qua for 2010 enh on print to file of 
                 production reports and statistical reports 
                 
                 - modified declaration for line and subline for gipir930_rec_type to prevent blank/incomplete generated to CSV due to ORA-06502: PL/SQL: numeric or value error: 
                 
                 */ 
                 
/* Modified by: Dean
** Date Modified: 03.01.2013
** Description: Added Functions CSV_GIPIR210, CSV_GIPIR211, CSV_GIPIR212 UW-SPECS-2013-00001
*/               
                 
   --1. FUNCTION CSV_GIPIR924--
   TYPE gipir924_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               gipi_uwreports_ext.LINE_CD%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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

   TYPE gipir924_type IS TABLE OF gipir924_rec_type;

   --END 1--
   --2. FUNCTION CSV_GIPIR924J--
   TYPE gipir924j_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               gipi_uwreports_ext.LINE_CD%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         pol_count          NUMBER (38),
         tot_sum_insured    NUMBER (38, 2),
         tot_premium        NUMBER (38, 2),
         evat               NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir924j_type IS TABLE OF gipir924j_rec_type;

   --END 2--
   --3. FUNCTION CSV_GIPIR923--
      /* Udel 09292012 @PNBGEN Changed precision of INVOICE from 30 to 50 */
   TYPE gipir923_rec_type IS RECORD (
      iss_name           VARCHAR2 (50),
      line               giis_line.line_name%TYPE,
      subline            giis_subline.subline_name%TYPE,
      stat               VARCHAR2 (1),
      policy_no          VARCHAR2 (100),
      assured            VARCHAR2 (500),
      invoice            VARCHAR2 (50),
      incept_date        DATE,
      expiry_date        DATE,
      total_si           NUMBER (38, 2),
      tot_premium        NUMBER (38, 2),
      evat               NUMBER (38, 2),
      lgt                NUMBER (38, 2),
      doc_stamps         NUMBER (38, 2),
      fire_service_tax   NUMBER (38, 2),
      other_charges      NUMBER (38, 2),
      total              NUMBER (38, 2),
      commission         NUMBER (38, 2)
   );

   TYPE gipir923_type IS TABLE OF gipir923_rec_type;

      --END 3--
   --4. FUNCTION CSV_GIPIR923E--
   TYPE gipir923e_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         stat               VARCHAR2 (1),
         policy_no          VARCHAR2 (100),
         assured            VARCHAR2 (500),
         issue_date         DATE,
         incept_date        DATE,
         expiry_date        DATE,
         spoiled            DATE,
         total_si           NUMBER (38, 2),
         tot_premium        NUMBER (38, 2),
         evat               NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir923e_type IS TABLE OF gipir923e_rec_type;

   --END 4--
   --5. FUNCTION CSV_GIPIR923E--
   TYPE gipir923c_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         acct_ent_date      VARCHAR2 (15),
         policy_no          VARCHAR2 (100),
         assured            VARCHAR2 (500),
         issue_date         DATE,
         incept_date        DATE,
         expiry_date        DATE,
         total_si           NUMBER (38, 2),
         tot_premium        NUMBER (38, 2),
         evat               NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir923c_type IS TABLE OF gipir923c_rec_type;

   --END 5--
   --6. FUNCTION CSV_GIPIR923F--
   TYPE gipir923f_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         acct_ent_date      VARCHAR2 (15),
         policy_no          VARCHAR2 (100),
         assured            VARCHAR2 (500),
         issue_date         DATE,
         incept_date        DATE,
         expiry_date        DATE,
         spld_date          DATE,
         total_si           NUMBER (38, 2),
         tot_premium        NUMBER (38, 2),
         evat               NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir923f_type IS TABLE OF gipir923f_rec_type;

   --END 6--
   --7. FUNCTION CSV_GIPIR930A--
   TYPE gipir930a_rec_type
   IS
      RECORD (
         iss_name         VARCHAR2 (50),
         line             giis_line.LINE_NAME%TYPE,
         subline          giis_subline.SUBLINE_NAME%TYPE,
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

   TYPE gipir930a_type IS TABLE OF gipir930a_rec_type;

   --END 7--
   --8. FUNCTION CSV_GIPIR930--
   TYPE gipir930_rec_type
   IS
      RECORD (
         iss_name         VARCHAR2 (50),
         line             VARCHAR2(25), /*  line             giis_line.LINE_NAME%TYPE,,  -- jhing commented out and replaced to prevent error  ORA-06502: PL/SQL: numeric or value error: character string buffer too small */ 
         subline          VARCHAR2(40), /*  subline          giis_subline.SUBLINE_NAME%TYPE,-- jhing commented out and replaced to prevent error  ORA-06502: PL/SQL: numeric or value error: character string buffer too small */ 
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

   TYPE gipir930_type IS TABLE OF gipir930_rec_type;

   --END 8--
   --9. FUNCTION CSV_GIPIR946B--
   TYPE gipir946b_rec_type
   IS
      RECORD (
         iss_name     VARCHAR2 (50),
         line         giis_line.LINE_NAME%TYPE,
         subline      giis_subline.SUBLINE_NAME%TYPE,
         peril_name   VARCHAR2 (20),
         peril_type   VARCHAR2 (1),
         tsi_amt      NUMBER (38, 2),
         prem_amt     NUMBER (38, 2),
         comm_amt     NUMBER (38, 2)
      );

   TYPE gipir946b_type IS TABLE OF gipir946b_rec_type;

   --END 9--
   --10. FUNCTION CSV_GIPIR946F--
   TYPE gipir946f_rec_type
   IS
      RECORD (
         iss_name   VARCHAR2 (50),
         line       giis_line.LINE_NAME%TYPE,
         subline    giis_subline.SUBLINE_NAME%TYPE,
         agent      VARCHAR2 (300),
         tsi_amt    NUMBER (38, 2),
         prem_amt   NUMBER (38, 2)
      );

   TYPE gipir946f_type IS TABLE OF gipir946f_rec_type;

   --END 10--
   --11. FUNCTION CSV_GIPIR946B--
   TYPE gipir946_rec_type
   IS
      RECORD (
         iss_name     VARCHAR2 (50),
         line         giis_line.LINE_NAME%TYPE,
         subline      giis_subline.SUBLINE_NAME%TYPE,
         peril_name   VARCHAR2 (20),
         peril_type   VARCHAR2 (1),
         intm_name    VARCHAR2 (250),
         tsi_amt      NUMBER (38, 2),
         prem_amt     NUMBER (38, 2),
         comm_amt     NUMBER (38, 2)
      );

   TYPE gipir946_type IS TABLE OF gipir946_rec_type;

   --END 11--
   --12. FUNCTION CSV_GIPIR946D--
   TYPE gipir946d_rec_type
   IS
      RECORD (
         iss_name     VARCHAR2 (50),
         line         giis_line.LINE_NAME%TYPE,
         subline      giis_subline.SUBLINE_NAME%TYPE,
         agent        VARCHAR2 (300),
         peril_name   VARCHAR2 (20),
         peril_type   VARCHAR2 (1),
         tsi_amt      NUMBER (38, 2),
         prem_amt     NUMBER (38, 2)
      );

   TYPE gipir946d_type IS TABLE OF gipir946d_rec_type;

   --END 12--
   --13. FUNCTION CSV_GIPIR924A--
   TYPE gipir924a_rec_type
   IS
      RECORD (
         assd_name          VARCHAR2 (50),
         iss_name           VARCHAR2 (500),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         pol_count          NUMBER (38),
         total_tsi          NUMBER (38, 2),
         total_prem         NUMBER (38, 2),
         evatprem           NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir924a_type IS TABLE OF gipir924a_rec_type;

   --END 13--
   --14. FUNCTION CSV_GIPIR924B--
   TYPE gipir924b_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         intm_type          VARCHAR2 (30),
         intm_name          VARCHAR2 (250),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         pol_count          NUMBER (38),
         total_tsi          NUMBER (38, 2),
         total_prem         NUMBER (38, 2),
         evatprem           NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2),
         commission         NUMBER (38, 2)
      );

   TYPE gipir924b_type IS TABLE OF gipir924b_rec_type;

   --END 14--
   --15. FUNCTION CSV_GIPIR923A--
   TYPE gipir923a_rec_type
   IS
      RECORD (
         assd_name          VARCHAR2 (50),
         iss_name           VARCHAR2 (500),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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
         total              NUMBER (38, 2)
      );

   TYPE gipir923a_type IS TABLE OF gipir923a_rec_type;

   --END 15--
   --16. FUNCTION CSV_GIPIR924B--
   TYPE gipir923b_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         intm_type          VARCHAR2 (30),
         intm_name          VARCHAR2 (250),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         policy_no          VARCHAR2 (100),
         assured            VARCHAR2 (500),
         invoice            VARCHAR2 (30),
         pol_date           DATE,
         total_tsi          NUMBER (38, 2),
         total_prem         NUMBER (38, 2),
         evatprem           NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2),
         commission         NUMBER (38, 2)
      );

   TYPE gipir923b_type IS TABLE OF gipir923b_rec_type;

   --END 16--
   --17. FUNCTION CSV_GIPIR929B--
   TYPE gipir929b_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         intm_name          VARCHAR2 (250),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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

   --END 17--
   --18. FUNCTION CSV_GIPIR929A--
   TYPE gipir929a_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         intm_name          VARCHAR2 (250),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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

   --END 18--
   --19. FUNCTION CSV_GIPIR924C--
   TYPE gipir924c_rec_type
   IS
      RECORD (
         rv_meaning    VARCHAR2 (100),
         line          giis_line.LINE_NAME%TYPE,
         subline       giis_subline.SUBLINE_NAME%TYPE,
         policy_no     VARCHAR2 (45),
         assured       VARCHAR2 (500),
         issue_date    DATE,
         incept_date   DATE,
         tsi_amt       NUMBER (38, 2),
         prem_amt      NUMBER (38, 2)
      );

   TYPE gipir924c_type IS TABLE OF gipir924c_rec_type;

   --END 19--
   --20. FUNCTION CSV_GIPIR924D--
   TYPE gipir924d_rec_type
   IS
      RECORD (
         iss_name      VARCHAR2 (50),
         rv_meaning    VARCHAR2 (100),
         line          giis_line.LINE_NAME%TYPE,
         subline       giis_subline.SUBLINE_NAME%TYPE,
         policy_no     VARCHAR2 (45),
         assured       VARCHAR2 (500),
         issue_date    DATE,
         incept_date   DATE,
         tsi_amt       NUMBER (38, 2),
         prem_amt      NUMBER (38, 2)
      );

   TYPE gipir924d_type IS TABLE OF gipir924d_rec_type;

   --END 20--
   --21. FUNCTION CSV_GIPIR924F--
   TYPE gipir924f_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               gipi_uwreports_ext.LINE_CD%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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

   --END 21--
   --22. FUNCTION CSV_GIPIR924E--
   TYPE gipir924e_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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

   --END 22--
   --23. FUNCTION CSV_GIPIR928B--
   TYPE gipir928b_rec_type
   IS
      RECORD (
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_CD%TYPE,
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

   --END 23--
   --24. FUNCTION CSV_GIPIR928C--
   TYPE gipir928c_rec_type
   IS
      RECORD (
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_CD%TYPE,
         peril_name         giis_peril.PERIL_NAME%TYPE,
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

   --END 24--
   --25. FUNCTION CSV_GIPIR928D--
   TYPE gipir928d_rec_type
   IS
      RECORD (
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
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

   --END 25--
   --26. FUNCTION CSV_GIPIR923J--
   TYPE gipir923j_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         stat               VARCHAR2 (1),
         policy_no          VARCHAR2 (100),
         assured            VARCHAR2 (500),
         issue_date         DATE,
         incept_date        DATE,
         expiry_date        DATE,
         total_si           NUMBER (38, 2),
         tot_premium        NUMBER (38, 2),
         evat               NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir923j_type IS TABLE OF gipir923j_rec_type;

   --END 26--
   --27. FUNCTION CSV_GIPIR923D--
   TYPE gipir923d_rec_type
   IS
      RECORD (
         iss_name           VARCHAR2 (50),
         line               giis_line.LINE_NAME%TYPE,
         subline            giis_subline.SUBLINE_NAME%TYPE,
         acct_ent_date      VARCHAR2 (15),
         policy_no          VARCHAR2 (100),
         assured            VARCHAR2 (500),
         issue_date         DATE,
         incept_date        DATE,
         expiry_date        DATE,
         total_si           NUMBER (38, 2),
         tot_premium        NUMBER (38, 2),
         evat               NUMBER (38, 2),
         lgt                NUMBER (38, 2),
         doc_stamps         NUMBER (38, 2),
         fire_service_tax   NUMBER (38, 2),
         other_charges      NUMBER (38, 2),
         total              NUMBER (38, 2)
      );

   TYPE gipir923d_type IS TABLE OF gipir923d_rec_type;

   --END 27--
   --28. FUNCTION CSV_GIPIR928A--
   TYPE gipir928a_rec_type
   IS
      RECORD (
         iss_name      VARCHAR2 (50),
         line          giis_line.LINE_NAME%TYPE,
         subline       giis_subline.SUBLINE_NAME%TYPE,
         policy_no     VARCHAR2 (100),
         peril_sname   VARCHAR2 (10),
         nr_risk       NUMBER (38, 2),
         nr_prem       NUMBER (38, 2),
         t_risk        NUMBER (38, 2),
         t_prem        NUMBER (38, 2),
         f_risk        NUMBER (38, 2),
         f_prem        NUMBER (38, 2)
      );

   TYPE gipir928a_type IS TABLE OF gipir928a_rec_type;

   --END 28--
   --29. FUNCTION CSV_GIPIR928--
   TYPE gipir928_rec_type
   IS
      RECORD (
         iss_name      VARCHAR2 (50),
         line          giis_line.LINE_NAME%TYPE,
         subline       giis_subline.SUBLINE_NAME%TYPE,
         policy_no     VARCHAR2 (100),
         peril_sname   VARCHAR2 (10),
         tsi_amt       NUMBER (38, 2),
         prem_amt      NUMBER (38, 2)
      );

   TYPE gipir928_type IS TABLE OF gipir928_rec_type;

   --END 29--
   --30. FUNCTION CSV_GIPIR928E--
   TYPE gipir928e_rec_type
   IS
      RECORD (
         iss_name     VARCHAR2 (50),
         line         giis_line.LINE_NAME%TYPE,
         subline      giis_subline.SUBLINE_NAME%TYPE,
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

   --END 30--
   --31. FUNCTION CSV_GIPIR928F--
   TYPE gipir928f_rec_type
   IS
      RECORD (
         iss_name      VARCHAR2 (50),
         line          giis_line.LINE_NAME%TYPE,
         subline       giis_subline.SUBLINE_NAME%TYPE,
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

   --END 31--
   --32. FUNCTION CSV_GIPIR928G--
   TYPE gipir928g_rec_type
   IS
      RECORD (
         iss_name      VARCHAR2 (50),
         line          giis_line.LINE_NAME%TYPE,
         subline       giis_subline.SUBLINE_NAME%TYPE,
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

   TYPE gipir928g_type IS TABLE OF gipir928g_rec_type;

   --END 32--
   --Alvin Tumlos May 31, 2010--
   --33. FUNCTION CSV_EDST-
   TYPE EDST_rec_type
   IS
      RECORD (
         LINE_CD         gipi_polbasic.line_cd%TYPE,
         TIN             giis_assured.assd_tin%TYPE,
         BRANCH          gipi_uwreports_ext.iss_cd%TYPE,
         BRANCH_TIN_CD   giis_issource.branch_tin_cd%TYPE,
         NO_TIN          giis_assured.no_tin_reason%TYPE,
         REASON          giis_assured.no_tin_reason%TYPE,
         COMPANY         giis_assured.assd_name%TYPE,
         FIRST_NAME      giis_assured.assd_name%TYPE,
         MIDDLE_NAME     giis_assured.assd_name%TYPE,
         LAST_NAME       giis_assured.assd_name%TYPE,
         TAX_BASE        edst_ext.total_prem%TYPE,
         TSI_AMT         edst_ext.total_tsi%TYPE
      );

   TYPE EDST_type IS TABLE OF EDST_rec_type;
   
   /*  ------------------------------------------- START (jhing 12.05.2012 ) ------------------------------
        Modified by jhing : added Ms. Bhev's scripts for print to CSV (2010 enh )  */
        
   -- Bhev:  UW >> Reports Printing >> Generate Statistical Reports--
   --Risk Profile--
   --34. FUNCTION CSV_GIPIR949--
   TYPE gipir949_rec_type IS RECORD (
      period          VARCHAR2 (2000),
      line_name       giis_line.line_name%TYPE,
      subline_name    giis_subline.subline_name%TYPE,
      tariff          giis_tariff.tarf_desc%TYPE,
      tsi_range       VARCHAR2 (1000),
      policy_no       VARCHAR2 (100),
      tsi_amount      gipi_risk_profile_dtl.ann_tsi_amt%TYPE,
      net_retention   gipi_risk_profile_dtl.net_retention%TYPE,
      quota_share     gipi_risk_profile_dtl.quota_share%TYPE,
      treaty          gipi_risk_profile_dtl.treaty_prem%TYPE,
      facultative     gipi_risk_profile_dtl.facultative%TYPE,
      total           NUMBER (16, 2)
   );

   TYPE gipir949_type IS TABLE OF gipir949_rec_type;

      --end 34--
   --35. FUNCTION CSV_GIPIR949B
   TYPE gipir949b_rec_type IS RECORD (
      line_name         giis_line.line_name%TYPE,
      date_range        VARCHAR2 (2000),
      tsi_range         VARCHAR2 (1000),
      policy_no         VARCHAR2 (100),
      item              VARCHAR2 (100),
      sum_insured       gipi_polbasic.tsi_amt%TYPE,
      premium_amt       gipi_polbasic.prem_amt%TYPE,
      net_sum_insured   NUMBER (20, 2),
      net_prem_amt      NUMBER (20, 2),
      treaty_tsi        NUMBER (20, 2),
      treaty_prem_amt   NUMBER (20, 2),
      facul_tsi         NUMBER (20, 2),
      facul_prem_amt    NUMBER (20, 2)
   );

   TYPE gipir949b_type IS TABLE OF gipir949b_rec_type;

      --end 35--
   --36. FUNCTION CSV_GIPIR949C
   TYPE gipir949c_rec_type IS RECORD (
      period        VARCHAR2 (2000),
      ranges        VARCHAR2 (2000),
      block_risk    VARCHAR2 (2000),
      risk_cnt      NUMBER,
      sum_insured   NUMBER (16, 2),
      prem_amt      NUMBER (16, 2)
   );

   TYPE gipir949c_type IS TABLE OF gipir949c_rec_type;

      -- end 36--
   --37. FUNCTION CSV_GIPIR940
   TYPE gipir940_rec_type IS RECORD (
      period          VARCHAR (2000),
      tariff_desc     giis_tariff.tarf_desc%TYPE,
      line_name       VARCHAR2 (30),
      tsi_range       VARCHAR2 (1000),
      policy_count    gipi_risk_profile.policy_count%TYPE,
      net_retention   gipi_risk_profile.net_retention%TYPE,
      quota_share     gipi_risk_profile.quota_share%TYPE,
      treaty          gipi_risk_profile.treaty%TYPE,
      facultative     gipi_risk_profile.facultative%TYPE,
      total           NUMBER (20, 2)
   );

   TYPE gipir940_type IS TABLE OF gipir940_rec_type;

      --end 37--
   --38. FUNCTION CSV_GIPIR934
   TYPE gipir934_rec_type IS RECORD (
      period         VARCHAR2 (2000),
      line_name      VARCHAR2 (30),
      subline_name   VARCHAR2 (40),
      tariff_desc    giis_tariff.tarf_desc%TYPE,
      tsi_range      VARCHAR2 (2000),
      peril_name     giis_peril.peril_name%TYPE,
      policy_count   NUMBER,
      sum_insured    NUMBER (16, 2),
      premium        NUMBER (16, 2)
   );

   TYPE gipir934_type IS TABLE OF gipir934_rec_type;

      --end 38--
   -- 39. FUNCTION CSV_GIPIR941
   TYPE gipir941_rec_type IS RECORD (
      period           VARCHAR2 (2000),
      line_name        VARCHAR2 (30),
      subline_name     VARCHAR2 (40),
      tariff_desc      giis_tariff.tarf_desc%TYPE,
      tsi_range_from   gipi_risk_profile.range_from%TYPE,
      tsi_range_to     gipi_risk_profile.range_to%TYPE,
      policy_count     gipi_risk_profile.policy_count%TYPE,
      net_retention    gipi_risk_profile.net_retention%TYPE,
      quota_share      gipi_risk_profile.quota_share%TYPE,
      treaty           NUMBER (20, 2),
      facultative      gipi_risk_profile.facultative%TYPE
   );

   TYPE gipir941_type IS TABLE OF gipir941_rec_type;

      --end 39--
   -- 40. FUNCTION CSV_GIPIR947B
   TYPE gipir947b_rec_type IS RECORD (
      period             VARCHAR2 (2000),
      tariff_desc        giis_tariff.tarf_desc%TYPE,
      line_name          VARCHAR2 (30),
      tsi_range          VARCHAR2 (2000),
      policy_count       gipi_risk_profile.policy_count%TYPE,
      first_ret_tsi      NUMBER (16, 2),
      first_ret_prem     NUMBER (16, 2),
      sec_ret_tsi        NUMBER (16, 2),
      sec_ret_prem       NUMBER (16, 2),
      quota_share_tsi    NUMBER (16, 2),
      quota_share_prem   NUMBER (16, 2),
      treaty1_tsi        NUMBER (16, 2),
      treaty1_prem       NUMBER (16, 2),
      treaty2_tsi        NUMBER (16, 2),
      treaty2_prem       NUMBER (16, 2),
      treaty3_tsi        NUMBER (16, 2),
      treaty3_prem       NUMBER (16, 2),
      treaty4_tsi        NUMBER (16, 2),
      treaty4_prem       NUMBER (16, 2),
      treaty5_tsi        NUMBER (16, 2),
      treaty5_prem       NUMBER (16, 2),
      treaty6_tsi        NUMBER (16, 2),
      treaty6_prem       NUMBER (16, 2),
      treaty7_tsi        NUMBER (16, 2),
      treaty7_prem       NUMBER (16, 2),
      treaty8_tsi        NUMBER (16, 2),
      treaty8_prem       NUMBER (16, 2),
      treaty9_tsi        NUMBER (16, 2),
      treaty9_prem       NUMBER (16, 2),
      treaty10_tsi       NUMBER (16, 2),
      treaty10_prem      NUMBER (16, 2),
      facultative_tsi    NUMBER (16, 2),
      facultative        NUMBER (16, 2),
      total_tsi          NUMBER (16, 2),
      total_prem         NUMBER (16, 2)
   );

   TYPE gipir947b_type IS TABLE OF gipir947b_rec_type;

      --end 40--
   -- 43. FUNCTION CSV_GIPIR071
   TYPE gipir071_rec_type IS RECORD (
      period         VARCHAR2 (2000),
      subline_name   giis_subline.subline_name%TYPE,
      vessel_name    gixx_mrn_vessel_stat.vessel_name%TYPE,
      policy_no      gixx_mrn_vessel_stat.policy_no%TYPE,
      assd_name      giis_assured.assd_name%TYPE,
      treaty_name    gixx_mrn_vessel_stat.trty_name%TYPE,
      dist_tsi       gixx_mrn_vessel_stat.dist_tsi%TYPE,
      dist_prem      gixx_mrn_vessel_stat.dist_prem%TYPE,
      tax_amt        NUMBER (16, 2)
   );

   TYPE gipir071_type IS TABLE OF gipir071_rec_type;

      --end 43--
   -- 44. FUNCTION CSV_GIPIR072
   TYPE gipir072_rec_type IS RECORD (
      period             VARCHAR2 (2000),
      subline_name       giis_subline.subline_name%TYPE,
      cargo_class_desc   gixx_mrn_cargo_stat.cargo_class_desc%TYPE,
      policy_no          gixx_mrn_cargo_stat.policy_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      treaty_name        gixx_mrn_cargo_stat.trty_name%TYPE,
      dist_tsi           gixx_mrn_cargo_stat.dist_tsi%TYPE,
      dist_prem          gixx_mrn_cargo_stat.dist_prem%TYPE,
      tax_amt            NUMBER (16, 2)
   );

   TYPE gipir072_type IS TABLE OF gipir072_rec_type;

      --end 44--
   -- 45. FUNCTION CSV_GIPIR038A - CSV_GIPIR038C
   TYPE gipir038_rec_type IS RECORD (
      period             VARCHAR2 (2000),
      zone_desc          VARCHAR (2000),
      tariff_int         VARCHAR2 (2000),
      policy_cnt         NUMBER,
      aggr_sum_insured   NUMBER (16, 2),
      aggr_prem_amt      NUMBER (16, 2)
   );

   TYPE gipir038_type IS TABLE OF gipir038_rec_type;

   -- 47. FUNCTION CSV_GIPIR039A
   TYPE gipir039a_rec_type IS RECORD (
      period             VARCHAR2 (2000),
      zone_grp           VARCHAR2 (10),
      zone_no            VARCHAR2 (10),
      policy_no          VARCHAR2 (100),
      bldg_tsi           NUMBER (16, 2),
      bldg_prem_amt      NUMBER (16, 2),
      content_tsi        NUMBER (16, 2),
      content_prem_amt   NUMBER (16, 2),
      loss_tsi           NUMBER (16, 2),
      loss_prem_amt      NUMBER (16, 2),
      total_tsi          NUMBER (16, 2),
      total_prem         NUMBER (16, 2)
   );

   TYPE gipir039a_type IS TABLE OF gipir039a_rec_type;

   -- 48. FUNCTION CSV_GIPIR039B
   TYPE gipir039b_rec_type IS RECORD (
      period             VARCHAR (2000),
      zone_grp           VARCHAR (10),
      zone_no            VARCHAR (10),
      bldg_pol_cnt       NUMBER,
      bldg_tot_tsi       NUMBER (16, 2),
      bldg_tot_prem      NUMBER (16, 2),
      content_pol_cnt    NUMBER,
      content_tot_tsi    NUMBER (16, 2),
      content_tot_prem   NUMBER (16, 2),
      loss_pol_cnt       NUMBER,
      loss_tot_tsi       NUMBER (16, 2),
      loss_tot_prem      NUMBER (16, 2),
      tot_pol_cnt        NUMBER,
      total_tsi          NUMBER (16, 2),
      total_prem         NUMBER (16, 2)
   );

   TYPE gipir039b_type IS TABLE OF gipir039b_rec_type;

   -- 49. FUNCTION CSV_GIPIR039D
   TYPE gipir039d_rec_type IS RECORD (
      period             VARCHAR2 (2000),
      zone_no            VARCHAR2 (10),
      occ_cd             VARCHAR2 (10),
      occupancy          VARCHAR (100),
      risk               NUMBER,
      bldg_exposure      NUMBER (16, 2),
      bldg_prem          NUMBER (16, 2),
      content_exposure   NUMBER (16, 2),
      content_prem       NUMBER (16, 2),
      loss_exposure      NUMBER (16, 2),
      loss_prem          NUMBER (16, 2),
      gross_exposure     NUMBER (16, 2),
      gross_prem         NUMBER (16, 2),
      ret_exposure       NUMBER (16, 2),
      ret_prem           NUMBER (16, 2),
      treaty_exposure    NUMBER (16, 2),
      treaty_prem        NUMBER (16, 2),
      facul_exposure     NUMBER (16, 2),
      facul_prem         NUMBER (16, 2)
   );

   TYPE gipir039d_type IS TABLE OF gipir039d_rec_type;

   -- 50. FUNCTION CSV_GIPIR037
   TYPE gipir037_rec_type IS RECORD (
      period        VARCHAR2 (2000),
      zone_type     VARCHAR (200),
      division      VARCHAR2 (100),
      zone_no       VARCHAR2 (10),
      gross_tsi     NUMBER (18, 2),
      gross_prem    NUMBER (18, 2),
      ret_tsi       NUMBER (18, 2),
      ret_prem      NUMBER (18, 2),
      facul_tsi     NUMBER (18, 2),
      facul_prem    NUMBER (18, 2),
      treaty_tsi    NUMBER (18, 2),
      treaty_prem   NUMBER (18, 2)
   );

   TYPE gipir037_type IS TABLE OF gipir037_rec_type;

   -- 51. FUNCTION CSV_GIRIR115
   TYPE girir115_rec_type IS RECORD (
      period                    VARCHAR2 (2000),
      peril_stat_name           gixx_lto_stat.peril_stat_name%TYPE,
      subline_type              gixx_lto_stat.subline%TYPE,
      mla_vehicle_cnt           gixx_lto_stat.mla_cnt%TYPE,
      mla_total_prem            gixx_lto_stat.mla_prem%TYPE,
      outside_mla_vehicle_cnt   gixx_lto_stat.outside_mla_cnt%TYPE,
      outside_mla_total_prem    gixx_lto_stat.outside_mla_prem%TYPE
   );

   TYPE girir115_type IS TABLE OF girir115_rec_type;

      --end 51--
   -- 52. FUNCTION CSV_GIRIR116
   TYPE girir116_rec_type IS RECORD (
      period           VARCHAR2 (2000),
      coverage         gixx_nlto_stat.coverage%TYPE,
      peril_name       gixx_nlto_stat.peril_name%TYPE,
      pc_vehicle_cnt   gixx_nlto_stat.pc_count%TYPE,
      pc_total_prem    gixx_nlto_stat.pc_prem%TYPE,
      cv_vehicle_cnt   gixx_nlto_stat.cv_count%TYPE,
      cv_total_prem    gixx_nlto_stat.cv_prem%TYPE,
      mc_vehicle_cnt   gixx_nlto_stat.mc_count%TYPE,
      mc_total_prem    gixx_nlto_stat.mc_prem%TYPE
   );

   TYPE girir116_type IS TABLE OF girir116_rec_type;

      --end 52--
   -- 53. FUNCTION CSV_GIRIR117
   TYPE girir117_rec_type IS RECORD (
      period                    VARCHAR (2000),
      peril_name                gixx_lto_claim_stat.peril_stat_name%TYPE,
      subline_type              gixx_lto_claim_stat.subline%TYPE,
      mla_claims_cnt            gixx_lto_claim_stat.mla_clm_cnt%TYPE,
      mla_paid_claims           gixx_lto_claim_stat.mla_pd_claims%TYPE,
      mla_os_losses             gixx_lto_claim_stat.mla_losses%TYPE,
      outside_mla_claims_cnt    gixx_lto_claim_stat.outside_mla_cnt%TYPE,
      outside_mla_paid_claims   gixx_lto_claim_stat.outside_mla_pd_claims%TYPE,
      outside_mla_os_losses     gixx_lto_claim_stat.outside_mla_losses%TYPE
   );

   TYPE girir117_type IS TABLE OF girir117_rec_type;

      --end 53--
   -- 54. FUNCTION CSV_GIRIR118
   TYPE girir118_rec_type IS RECORD (
      period           VARCHAR2 (2000),
      coverage         gixx_nlto_claim_stat.coverage%TYPE,
      peril_name       gixx_nlto_claim_stat.peril_name%TYPE,
      pc_claims_cnt    gixx_nlto_claim_stat.pc_clm_count%TYPE,
      pc_paid_claims   gixx_nlto_claim_stat.pc_pd_claims%TYPE,
      pc_os_losses     gixx_nlto_claim_stat.pc_losses%TYPE,
      cv_claims_cnt    gixx_nlto_claim_stat.cv_clm_count%TYPE,
      cv_paid_claims   gixx_nlto_claim_stat.cv_pd_claims%TYPE,
      cv_os_losses     gixx_nlto_claim_stat.cv_losses%TYPE,
      mc_claims_cnt    gixx_nlto_claim_stat.mc_clm_count%TYPE,
      mc_paid_claims   gixx_nlto_claim_stat.mc_pd_claims%TYPE,
      mc_os_losses     gixx_nlto_claim_stat.mc_losses%TYPE
   );

   TYPE girir118_type IS TABLE OF girir118_rec_type;

      --end 53--
   -- 55. FUNCTION CSV_GIPIR924K
   TYPE gipir924k_rec_type IS RECORD (
      branch_name               VARCHAR2 (500),
      line_name                 VARCHAR2 (25),
      issue_date                VARCHAR2 (20),
      reference_no              VARCHAR2 (50),
      invoice_no                VARCHAR2 (20),
      pol_duration              VARCHAR2 (30),
      assureds_tin              giis_assured.no_tin_reason%TYPE,
      assured_name              giis_assured.assd_name%TYPE,
      description               VARCHAR2 (10),
      prem_amt                  gipi_uwreports_ext.total_prem%TYPE,
      vat                       gipi_uwreports_ext.evatprem%TYPE,
      lgt                       gipi_uwreports_ext.lgt%TYPE,
      docstamps                 gipi_uwreports_ext.doc_stamps%TYPE,
      fst                       gipi_uwreports_ext.fst%TYPE,
      --PT                      GIPI_UWREPORTS_DIST_EXT.PT_AMT%TYPE,
      other_charges             gipi_uwreports_ext.other_charges%TYPE,
      retention_prem_amt        gipi_uwreports_dist_ext.RETENTION%TYPE,
      facultative_prem_amt      gipi_uwreports_dist_ext.facultative%TYPE,
      facultative_ri_comm       gipi_uwreports_dist_ext.ri_comm%TYPE,
      facultative_ri_comm_vat   gipi_uwreports_dist_ext.ri_comm_vat%TYPE,
      treaty_prem_amt           gipi_uwreports_dist_ext.treaty%TYPE,
      treaty_ri_comm            gipi_uwreports_dist_ext.trty_ri_comm%TYPE,
      treaty_ri_comm_vat        gipi_uwreports_dist_ext.trty_ri_comm_vat%TYPE,
      intm_name                 giis_intermediary.intm_name%TYPE,
      intm_comm                 gipi_uwreports_ext.comm_amt%TYPE
   );

   TYPE gipir924k_type IS TABLE OF gipir924k_rec_type;
   --end 55--          
   /*  ------------------------------------------- END  (jhing 12.05.2012 )--------------------------------*/ 
   
   -- 56. FUNCTION CSV_GIPIR210
   /*TYPE gipir210_rec_type IS RECORD (
      policy_number        VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      package_cd           giis_package_benefit.package_cd%TYPE,
      control_cd           gipi_grouped_items.control_cd%TYPE,
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      endt_no              VARCHAR2 (50),
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      eff_date             gipi_polbasic.eff_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      tsi_amt              gipi_grouped_items.tsi_amt%TYPE,
      prem_amt             gipi_grouped_items.prem_amt%TYPE,
      status_flag          VARCHAR2 (10)
   );*/
   
   TYPE gipir210_rec_type IS RECORD (
      policy_number        VARCHAR2 (50),
      endt_no              VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      label_tag            VARCHAR2(100),
      in_acct_leased_to    giis_assured.assd_name%TYPE,
      plan                 VARCHAR2(500),
      item_no              gipi_grouped_items.item_no%TYPE , 
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      enrollee_name        gipi_grouped_items.grouped_item_title%TYPE,      
      control_code         gipi_grouped_items.control_cd%TYPE,  
      eff_date             gipi_polbasic.eff_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      tsi_amt              gipi_grouped_items.tsi_amt%TYPE,
      prem_amt             gipi_grouped_items.prem_amt%TYPE,
      status_flag          VARCHAR2 (10)
   );

   TYPE gipir210_type IS TABLE OF gipir210_rec_type;

   --END 56--

   -- 57. FUNCTION CSV_GIPIR211
   /*TYPE gipir211_rec_type IS RECORD (
      policy_number        VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      control_cd           gipi_grouped_items.control_cd%TYPE,
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      package_cd           giis_package_benefit.package_cd%TYPE,
      endt_no              VARCHAR2 (50),
      item_no              NUMBER (9),
      eff_date             gipi_polbasic.eff_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      peril_sname          giis_peril.peril_sname%TYPE,
      tsi_amt              gipi_grouped_items.tsi_amt%TYPE,
      prem_amt             gipi_grouped_items.prem_amt%TYPE,
      delete_sw            VARCHAR2 (10)
   );*/ -- jhing commented out GENQA 5306 and replaced with: 
  
   TYPE gipir211_rec_type IS RECORD (
      policy_number        VARCHAR2 (50),
      endt_no              VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      label_tag            VARCHAR2(100),
      in_acct_leased_to    giis_assured.assd_name%TYPE,
      plan                 VARCHAR2(500),
      item_no              gipi_grouped_items.item_no%TYPE , 
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      enrollee_name        gipi_grouped_items.grouped_item_title%TYPE,      
      control_code         gipi_grouped_items.control_cd%TYPE,  
      eff_date             gipi_polbasic.eff_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      peril_cd             giis_peril.peril_cd%TYPE,
      peril_sname          giis_peril.peril_sname%TYPE,
      peril_name           giis_peril.peril_name%TYPE,
      peril_type           giis_peril.peril_type%TYPE,
      tsi_amt              gipi_grouped_items.tsi_amt%TYPE,
      prem_amt             gipi_grouped_items.prem_amt%TYPE,
      status_flag          VARCHAR2 (10)
   );
   TYPE gipir211_type IS TABLE OF gipir211_rec_type;   
   --END 57--

   -- 58. FUNCTION CSV_GIPIR212
  /* TYPE gipir212_rec_type IS RECORD (
      policy_number        VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      control_cd           gipi_grouped_items.control_cd%TYPE,
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      package_cd           giis_package_benefit.package_cd%TYPE,
      endt_no              VARCHAR2 (50),
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      eff_date             gipi_polbasic.eff_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      tsi_amt              gipi_grouped_items.tsi_amt%TYPE,
      prem_amt             gipi_grouped_items.prem_amt%TYPE,
      delete_sw            VARCHAR2 (10)
   ); */ -- jhing 04.01.2016 commented out and replace with : 
   TYPE gipir212_rec_type IS RECORD (
      policy_number        VARCHAR2 (50),
      endt_no              VARCHAR2 (50),
      assd_name            giis_assured.assd_name%TYPE,
      label_tag            VARCHAR2(100),
      in_acct_leased_to    giis_assured.assd_name%TYPE,
      plan                 VARCHAR2(500),
      item_no              gipi_grouped_items.item_no%TYPE , 
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      enrollee_name        gipi_grouped_items.grouped_item_title%TYPE,      
      control_code         gipi_grouped_items.control_cd%TYPE,  
      eff_date             gipi_polbasic.eff_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      tsi_amt              gipi_grouped_items.tsi_amt%TYPE,
      prem_amt             gipi_grouped_items.prem_amt%TYPE,
      status_flag          VARCHAR2 (10)
   );   

   TYPE gipir212_type IS TABLE OF gipir212_rec_type;

   --END 58--
   
   FUNCTION CSV_GIPIR924 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924_type
      PIPELINED;

   FUNCTION CSV_GIPIR924J (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924j_type
      PIPELINED;

   FUNCTION CSV_GIPIR923 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923_type
      PIPELINED;

   FUNCTION CSV_GIPIR923E (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923e_type
      PIPELINED;

   FUNCTION CSV_GIPIR923C (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923c_type
      PIPELINED;

   FUNCTION CSV_GIPIR923F (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923f_type
      PIPELINED;

   FUNCTION CSV_GIPIR930A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir930a_type
      PIPELINED;

   FUNCTION CSV_GIPIR930 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir930_type
      PIPELINED;

   FUNCTION CSV_GIPIR946B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946b_type
      PIPELINED;

   FUNCTION CSV_GIPIR946F (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946f_type
      PIPELINED;

   FUNCTION CSV_GIPIR946 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946_type
      PIPELINED;

   FUNCTION CSV_GIPIR946D (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946d_type
      PIPELINED;

   FUNCTION CSV_GIPIR924A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924a_type
      PIPELINED;

   FUNCTION CSV_GIPIR924B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924b_type
      PIPELINED;

   FUNCTION CSV_GIPIR923A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923a_type
      PIPELINED;

   FUNCTION CSV_GIPIR923B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923b_type
      PIPELINED;

   FUNCTION CSV_GIPIR929B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir929b_type
      PIPELINED;

   FUNCTION CSV_GIPIR929A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir929a_type
      PIPELINED;

   FUNCTION CSV_GIPIR924C (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924c_type
      PIPELINED;

   FUNCTION CSV_GIPIR924D (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924d_type
      PIPELINED;

   FUNCTION CSV_GIPIR924F (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924f_type
      PIPELINED;

   FUNCTION CSV_GIPIR924E (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924e_type
      PIPELINED;

   FUNCTION CSV_GIPIR928B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928b_type
      PIPELINED;

   FUNCTION CSV_GIPIR928C (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928c_type
      PIPELINED;

   FUNCTION CSV_GIPIR928D (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928d_type
      PIPELINED;

   FUNCTION CSV_GIPIR923J (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923j_type
      PIPELINED;

   FUNCTION CSV_GIPIR923D (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923d_type
      PIPELINED;

   FUNCTION CSV_GIPIR928A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928a_type
      PIPELINED;

   FUNCTION CSV_GIPIR928 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928_type
      PIPELINED;

   FUNCTION CSV_GIPIR928E (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928e_type
      PIPELINED;

   FUNCTION CSV_GIPIR928F (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928f_type
      PIPELINED;

   FUNCTION CSV_GIPIR928G (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928g_type
      PIPELINED;


   FUNCTION CSV_EDST (p_SCOPE           edst_param.SCOPE%TYPE,
                      p_from_date       edst_param.FROM_DATE%TYPE,
                      p_TO_DATE         edst_EXT.TO_DATE1%TYPE,
                      p_negative_amt    VARCHAR2,
                      p_ctpl_pol        NUMBER,
                      p_inc_spo         VARCHAR2,
                      p_user            edst_param.user_id%TYPE,
                      p_line_cd         VARCHAR2,
                      p_subline_cd      VARCHAR2,
                      p_iss_cd          VARCHAR2,
                      p_iss_param       NUMBER)
      RETURN EDST_type
      PIPELINED;

/* jhing 12.05.2012 added code from Ms. Bhev - 2010 enh on print to screen of risk profile 
  ------------------------------------BEGIN --------------------------------------------------*/
   -- UW >> Reports Printing >> General Statistical Reports
   FUNCTION csv_gipir949 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir949_type PIPELINED;

   FUNCTION csv_gipir949b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir949b_type PIPELINED;

   FUNCTION csv_gipir949c (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user_id GIIS_USERS.user_id%TYPE
   )
      RETURN gipir949c_type PIPELINED;

   FUNCTION csv_gipir940 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir940_type PIPELINED;

   FUNCTION csv_gipir934 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir934_type PIPELINED;

   FUNCTION csv_gipir941 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir941_type PIPELINED;

   FUNCTION csv_gipir947b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_all_line_tag    VARCHAR2,
      p_param_date      VARCHAR2,
      p_by_tarf         VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir947b_type PIPELINED;

   FUNCTION csv_gipir071 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_extract_id      VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_vessel_cd       VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir071_type PIPELINED;

   FUNCTION csv_gipir072 (
      p_starting_date    VARCHAR2,
      p_ending_date      VARCHAR2,
      p_extract_id       VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_cargo_class_cd   VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN gipir072_type PIPELINED;

   FUNCTION csv_gipir038a (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir038_type PIPELINED;

   FUNCTION csv_gipir038b (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir038_type PIPELINED;

   FUNCTION csv_gipir038c (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_zone_typea      VARCHAR2,
      p_zone_typeb      VARCHAR2,
      p_zone_typec      VARCHAR2,
      p_zone_typed      VARCHAR2
   )
      RETURN gipir038_type PIPELINED;

   FUNCTION csv_gipir039a (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id GIIS_USERS.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir039a_type PIPELINED;

   FUNCTION csv_gipir039b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir039b_type PIPELINED;

   FUNCTION csv_gipir039d (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2,
      p_by_count        VARCHAR2
   )
      RETURN gipir039d_type PIPELINED;

   FUNCTION csv_gipir037 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir037_type PIPELINED;

   FUNCTION csv_girir115 (
      p_user            VARCHAR2,
      p_period_param    VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_year            VARCHAR2
   )
      RETURN girir115_type PIPELINED;

   FUNCTION csv_girir116 (
      p_user            VARCHAR2,
      p_period_param    VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_year            VARCHAR2
   )
      RETURN girir116_type PIPELINED;

   FUNCTION csv_girir117 (
      p_user            VARCHAR2,
      p_period_param    VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_year            VARCHAR2
   )
      RETURN girir117_type PIPELINED;
 
   FUNCTION csv_girir118 (
      p_user            VARCHAR2,
      p_period_param    VARCHAR2,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_year            VARCHAR2
   )
      RETURN girir118_type PIPELINED;

   FUNCTION csv_gipir924k_old (
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_param_date   VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_user_id GIIS_USERS.user_id%TYPE
   )
      RETURN gipir924k_type PIPELINED;  
  /* end jhing 12.05.2012 code from risk profile print to file 2010 enh 
  ------------------------------------END ------------------------------------------------------ */ 
  
  --added by mikel 11.18.2013
  FUNCTION csv_gipir924k (
      p_from_date    /*VARCHAR2*/DATE, --edgar 03/03/2015
      p_to_date      /*VARCHAR2*/DATE, --edgar 03/03/2015
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_param_date   VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_user_id GIIS_USERS.user_id%TYPE
   )
      RETURN gipir924k_type PIPELINED;
   --end mikel 11.18.2013
      
  FUNCTION csv_gipir210 (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER,
      p_e_from       VARCHAR2,     -- jhing 04.01.2016 GENQA 5306 changed all date parameter into VARCHAR2
      p_e_to         VARCHAR2,     
      p_a_from       VARCHAR2,
      p_a_to         VARCHAR2,
      p_i_from       VARCHAR2,
      p_i_to         VARCHAR2,
      p_f            VARCHAR2,
      p_t            VARCHAR2,
      p_user_id      VARCHAR2  -- jhing 04.01.2016 GENQA 5306
   )
      RETURN gipir210_type PIPELINED;

   FUNCTION csv_gipir211 (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER,
      p_e_from       VARCHAR2,     -- jhing 04.06.2016 GENQA 5306 changed all date parameter into VARCHAR2
      p_e_to         VARCHAR2,
      p_a_from       VARCHAR2,
      p_a_to         VARCHAR2,
      p_i_from       VARCHAR2,
      p_i_to         VARCHAR2,
      p_f            VARCHAR2,
      p_t            VARCHAR2,
      p_user_id      VARCHAR2  -- jhing 04.06.2016 GENQA 5306
   )
      RETURN gipir211_type PIPELINED;

   FUNCTION csv_gipir212 (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER,
      p_e_from       VARCHAR2,     -- jhing 04.01.2016 GENQA 5306 changed all date parameter into VARCHAR2
      p_e_to         VARCHAR2,
      p_a_from       VARCHAR2,
      p_a_to         VARCHAR2,
      p_i_from       VARCHAR2,
      p_i_to         VARCHAR2,
      p_f            VARCHAR2,
      p_t            VARCHAR2,
      p_user_id      VARCHAR2  -- jhing 04.01.2016 GENQA 5306
   )
      RETURN gipir212_type PIPELINED;
END;
/


