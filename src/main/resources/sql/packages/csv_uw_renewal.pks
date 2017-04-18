CREATE OR REPLACE PACKAGE cpi.csv_uw_renewal
AS
   /*
     * Created by : Carlo de guzman
     * Date Created : 02.04.2016
     * Reference By : GIEXR104
     */
   TYPE get_giexr104_type IS RECORD (
      iss_name       VARCHAR2 (100),
      line_name      VARCHAR2 (100),
      subline_name   VARCHAR2 (100),
      with_bal       giex_expiries_v.balance_flag%TYPE,
      with_ri        VARCHAR2 (100),
      with_clm       giex_expiries_v.claim_flag%TYPE,
      assd_name      giis_assured.assd_name%TYPE,
      policy_no      VARCHAR2 (100),
      ref_pol_no     VARCHAR2 (50),
      AGENT          VARCHAR2 (100),
      expiry_date    giex_expiries_v.expiry_date%TYPE,
      tsi_amt        giex_expiries_v.tsi_amt%TYPE,
      ren_tsi_amt    NUMBER,
      prem_amt       giex_expiries_v.prem_amt%TYPE,
      ren_prem_amt   NUMBER,
      tax_amt        giex_expiries_v.tax_amt%TYPE
   );

   TYPE get_giexr104_tab IS TABLE OF get_giexr104_type;

   TYPE get_giexr105_type IS RECORD (
      issue_code       VARCHAR2 (100),
      line_code        VARCHAR2 (100),
      subline_code     VARCHAR2 (100),
      with_balance     giex_expiries_v.balance_flag%TYPE,
      with_claim       giex_expiries_v.claim_flag%TYPE,
      assured          giis_assured.assd_name%TYPE,
      policy_no        VARCHAR2 (100),
      ref_policy_no    VARCHAR2 (50),
      AGENT            VARCHAR2 (3000),
      expiry_date      giex_expiries_v.expiry_date%TYPE,
      tsi_amount       giex_expiries_v.tsi_amt%TYPE,
      premium_amount   giex_expiries_v.prem_amt%TYPE,
      tax_amount       giex_expiries_v.tax_amt%TYPE,
      total_due        NUMBER (16, 2)
   );

   TYPE get_giexr105_tab IS TABLE OF get_giexr105_type; 
  
   TYPE get_giexr113_type IS RECORD (
      assd_name      VARCHAR2 (100),
      iss_name       VARCHAR2 (100),
      line_name      VARCHAR2 (100),
      subline_name   VARCHAR2 (100),
      balance_flag   giex_expiries_v.balance_flag%TYPE,
      claim_flag     giex_expiries_v.claim_flag%TYPE,
      policy_no      VARCHAR (100),
      ref_pol_no     gipi_polbasic.ref_pol_no%TYPE,
      expiry_date    giex_expiries_v.expiry_date%TYPE,
      tsi_amt        giex_expiries_v.tsi_amt%TYPE,
      prem_amt       giex_expiries_v.prem_amt%TYPE,
      ren_tsi_amt    giex_expiries_v.ren_tsi_amt%TYPE,
      ren_prem_amt   giex_expiries_v.ren_prem_amt%TYPE,
      tax_amt        giex_expiries_v.tax_amt%TYPE,
      total_due      giex_expiries_v.ren_prem_amt%TYPE
   );

   TYPE get_giexr113_tab IS TABLE OF get_giexr113_type;

   FUNCTION get_giexr104 (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_giexr104_tab PIPELINED;

   FUNCTION get_giexr105 (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN get_giexr105_tab PIPELINED;

   /*
   * Created by : Carlo de guzman
   * Date Created : 02.09.2016
   * Reference By : GIEXR113
   */
   FUNCTION get_giexr113 (
      p_line_cd         giex_expiries_v.line_cd%TYPE,
      p_subline_cd      giex_expiries_v.subline_cd%TYPE,
      p_iss_cd          giex_expiries_v.iss_cd%TYPE,
      p_intm_no         giex_expiries_v.intm_no%TYPE,
      p_assd_no         giex_expiries_v.assd_no%TYPE,
      p_policy_id       giex_expiries_v.policy_id%TYPE,
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claim_flag      giex_expiries_v.claim_flag%TYPE,
      p_balance_flag    giex_expiries_v.balance_flag%TYPE
   )
      RETURN get_giexr113_tab PIPELINED;

--  Start: added by kevin 4-6-2016 SR-5491
   TYPE get_giexr108_type IS RECORD (
      issue_source                giis_issource.iss_name%TYPE,
      line_name                   giis_line.line_name%TYPE,
      subline_name                giis_subline.subline_name%TYPE,
      agent_code                  giex_ren_ratio_dtl.intm_no%TYPE,
      agent_name                  giis_intermediary.intm_name%TYPE,
      assured_name                giis_assured.assd_name%TYPE,
      expiry_date                 VARCHAR2 (20),
      policy_number               VARCHAR (100),
      reference_policy_number     gipi_polbasic.ref_pol_no%TYPE,
      premium_amount              VARCHAR2 (20),
      renewal_policy_number       VARCHAR (4000),
      ref_renewal_policy_number   VARCHAR (100),
      premium_renewal_amount      VARCHAR2 (20),
      remarks                     VARCHAR2 (500)
   );

   TYPE get_giexr108_tab IS TABLE OF get_giexr108_type;

   FUNCTION get_giexr108 (
      p_date_from   DATE,
      p_date_to     DATE,
      p_iss_cd      VARCHAR2,
      p_cred_cd     VARCHAR2,
      p_intm_no     NUMBER,
      p_line_cd     VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN get_giexr108_tab PIPELINED;

   FUNCTION intm_name_formula (p_intm_no giex_ren_ratio_dtl.intm_no%TYPE)
      RETURN VARCHAR2;

   FUNCTION renewal_policy_formula (
      p_remarks     VARCHAR2,
      p_policy_id   gipi_polbasic.policy_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION ref_ren_pol (p_cp_1 NUMBER)
      RETURN VARCHAR2;

   FUNCTION expiry_date (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN DATE;
--  End: added by kevin 4-6-2106 SR-5491

    /*
     * Created by : Herbert Tagudin
     * Date Created : 04.07.2016
     * Reference By : GIEXR112
     */
   TYPE get_giexr112_type IS RECORD (
      issue_code                giis_issource.iss_name%TYPE,
      line                      VARCHAR(2000), --changed by carlo rubenecia SR-5499 05.30.2016
      subline                   VARCHAR(2000), --changed by carlo rubenecia SR-5499 05.30.2016
      w_balance                 VARCHAR2(1),
      w_clm                     VARCHAR2(1),
      assured                   GIIS_ASSURED.assd_name%TYPE,
      policy_no                 VARCHAR2(100),
      ref_policy_no             GIPI_POLBASIC.ref_pol_no%TYPE,
      agent                     VARCHAR2(2000),
      agent_name                VARCHAR(5000),
      expiry                    VARCHAR2(15), 
      total_sum_insured         VARCHAR2(25),
      premium_amt               VARCHAR2(20),
      tax_amt                   VARCHAR2(20),
      total_due                 VARCHAR2(25)
   );
   TYPE get_giexr112_tab IS TABLE OF get_giexr112_type;
   
   FUNCTION csv_giexr112  (
        p_line_cd           GIEX_REN_RATIO_DTL.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO_DTL.iss_cd%TYPE,
        p_subline_cd        GIEX_REN_RATIO_DTL.subline_cd%TYPE,
        p_policy_id         GIEX_REN_RATIO_DTL.policy_id%TYPE,
        p_assd_no           GIEX_REN_RATIO_DTL.assd_no%TYPE,
        p_intm_no           GIEX_REN_RATIO_DTL.intm_no%TYPE,
        p_starting_date     DATE,
        p_ending_date       DATE,
        p_user_id           GIEX_REN_RATIO_DTL.user_id%TYPE
    )
      RETURN get_giexr112_tab PIPELINED; 
    
--  Start: added by Kevin 4-6-2016 SR-5322
   TYPE get_giexr106a_type IS RECORD (
      issue_code              VARCHAR2 (100),
      line_code               VARCHAR2 (100),
      subline_code            VARCHAR2 (100),
      with_balance            giex_expiries_v.balance_flag%TYPE,
      with_claim              giex_expiries_v.claim_flag%TYPE,
      assured                 giis_assured.assd_name%TYPE,
      policy_no               VARCHAR2 (100),
      ref_policy_no           VARCHAR2 (50),
      AGENT                   VARCHAR2 (9000),
      expiry                  VARCHAR2 (20),
      plate_no                giex_expiries_v.plate_no%TYPE,
      model_year              giex_expiries_v.model_year%TYPE,
      color_serial_no         VARCHAR2 (100),
      total_sum_insured       VARCHAR2 (20),
      ren_total_sum_insured   VARCHAR2 (20),
      premium_amount          VARCHAR2 (20),
      ren_premium_amount      VARCHAR2 (20)
   );

   TYPE get_giexr106a_tab IS TABLE OF get_giexr106a_type;

   FUNCTION csv_giexr106a (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2
   )
      RETURN get_giexr106a_tab PIPELINED;

   TYPE get_giexr106b_type IS RECORD (
      issue_code              VARCHAR2 (100),
      line                    VARCHAR2 (100),
      subline                 VARCHAR2 (100),
      with_balance            giex_expiries_v.balance_flag%TYPE,
      with_claim              giex_expiries_v.claim_flag%TYPE,
      assured                 VARCHAR2 (600),
      policy_no               VARCHAR2 (100),
      ref_policy_no           VARCHAR2 (50),
      AGENT                   VARCHAR2 (9000),
      expiry                  VARCHAR2 (20),
      total_sum_insured       VARCHAR2 (20),
      ren_total_sum_insured   VARCHAR2 (20),
      premium_amount          VARCHAR2 (20),
      ren_premium_amount      VARCHAR2 (20),
      tax_amount              VARCHAR2 (20),
      total_due               VARCHAR2 (20)
   );

   TYPE get_giexr106b_tab IS TABLE OF get_giexr106b_type;

   FUNCTION csv_giexr106b (
      p_policy_id       NUMBER,
      p_assd_no         NUMBER,
      p_intm_no         NUMBER,
      p_iss_cd          VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_ending_date     VARCHAR2,
      p_starting_date   VARCHAR2,
      p_include_pack    VARCHAR2,
      p_claims_flag     VARCHAR2,
      p_balance_flag    VARCHAR2,
      p_is_package      VARCHAR2
   )
      RETURN get_giexr106b_tab PIPELINED;
--  End: added by Kevin 4-6-2016 SR-5322
END csv_uw_renewal;
/