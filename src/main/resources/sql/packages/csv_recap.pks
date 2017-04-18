CREATE OR REPLACE PACKAGE CPI.csv_recap
AS
/* Created by: Ramon 04/15/2010, Generate CSV in GIACS290 - Recapitulation */
  --A. FUNCTION CSV_RECAP1--
  --RECAP I--
   TYPE recap1_rec_type IS RECORD (
      rowtitle       giac_recap_summ_ext.rowtitle%TYPE,
      subline_name   giis_subline.subline_name%TYPE,  --Dean 05.09.2012
      peril_name     giis_peril.peril_name%TYPE,      --Dean 05.09.2012
      no_of_pol      giac_recap_count.total%TYPE,
      coc            NUMBER (20, 2),
      direct_prem    giac_recap_summ_ext.direct_prem%TYPE,
      ceded_auth     giac_recap_summ_ext.ceded_prem_auth%TYPE,
      ceded_asean    giac_recap_summ_ext.ceded_prem_asean%TYPE,
      ceded_oth      giac_recap_summ_ext.ceded_prem_oth%TYPE,
      direct_net     NUMBER (20, 2),
      inw_auth       giac_recap_summ_ext.inw_prem_auth%TYPE,
      inw_asean      giac_recap_summ_ext.inw_prem_asean%TYPE,
      inw_oth        giac_recap_summ_ext.inw_prem_oth%TYPE,
      ret_auth       giac_recap_summ_ext.retceded_prem_auth%TYPE,
      ret_asean      giac_recap_summ_ext.retceded_prem_asean%TYPE,
      ret_oth        giac_recap_summ_ext.retceded_prem_oth%TYPE,
      net_written    NUMBER (20, 2)
   );

   TYPE recap1_type IS TABLE OF recap1_rec_type;

   --END A--

   --B. FUNCTION CSV_RECAP2--
   --RECAP II, V--
   TYPE recap2_rec_type IS RECORD (
      rowtitle      giac_recap_summ_ext.rowtitle%TYPE,
      subline_name  giis_subline.subline_name%TYPE,  --Dean 05.09.2012
      peril_name    giis_peril.peril_name%TYPE,      --Dean 05.09.2012
      no_of_pol     giac_recap_count.total%TYPE,
      direct_prem   giac_recap_summ_ext.direct_prem%TYPE,
      ceded_auth    giac_recap_summ_ext.ceded_prem_auth%TYPE,
      ceded_asean   giac_recap_summ_ext.ceded_prem_asean%TYPE,
      ceded_oth     giac_recap_summ_ext.ceded_prem_oth%TYPE,
      direct_net    NUMBER (20, 2),
      inw_auth      giac_recap_summ_ext.inw_prem_auth%TYPE,
      inw_asean     giac_recap_summ_ext.inw_prem_asean%TYPE,
      inw_oth       giac_recap_summ_ext.inw_prem_oth%TYPE,
      ret_auth      giac_recap_summ_ext.retceded_prem_auth%TYPE,
      ret_asean     giac_recap_summ_ext.retceded_prem_asean%TYPE,
      ret_oth       giac_recap_summ_ext.retceded_prem_oth%TYPE,
      net_written   NUMBER (20, 2)
   );

   TYPE recap2_type IS TABLE OF recap2_rec_type;

   --END B--

   --C. FUNCTION CSV_RECAP3--
   --RECAP III, IV--
   TYPE recap3_rec_type IS RECORD (
      rowtitle      giac_recap_summ_ext.rowtitle%TYPE,
      subline_name  giis_subline.subline_name%TYPE,  --Dean 05.09.2012
      peril_name    giis_peril.peril_name%TYPE,      --Dean 05.09.2012
      direct_prem   giac_recap_summ_ext.direct_prem%TYPE,
      ceded_auth    giac_recap_summ_ext.ceded_prem_auth%TYPE,
      ceded_asean   giac_recap_summ_ext.ceded_prem_asean%TYPE,
      ceded_oth     giac_recap_summ_ext.ceded_prem_oth%TYPE,
      direct_net    NUMBER (20, 2),
      inw_auth      giac_recap_summ_ext.inw_prem_auth%TYPE,
      inw_asean     giac_recap_summ_ext.inw_prem_asean%TYPE,
      inw_oth       giac_recap_summ_ext.inw_prem_oth%TYPE,
      ret_auth      giac_recap_summ_ext.retceded_prem_auth%TYPE,
      ret_asean     giac_recap_summ_ext.retceded_prem_asean%TYPE,
      ret_oth       giac_recap_summ_ext.retceded_prem_oth%TYPE,
      net_written   NUMBER (20, 2)
   );

   TYPE recap3_type IS TABLE OF recap3_rec_type;

   --END C--

   --D. FUNCTION CSV_RECAP_DTL--
   TYPE recap_dtl_rec_type IS RECORD (
      polclm_no     VARCHAR2 (50),
      direct_prem   giac_recap_summ_ext.direct_prem%TYPE,
      ceded_auth    giac_recap_summ_ext.ceded_prem_auth%TYPE,
      ceded_asean   giac_recap_summ_ext.ceded_prem_asean%TYPE,
      ceded_oth     giac_recap_summ_ext.ceded_prem_oth%TYPE,
      direct_net    NUMBER (20),
      inw_auth      giac_recap_summ_ext.inw_prem_auth%TYPE,
      inw_asean     giac_recap_summ_ext.inw_prem_asean%TYPE,
      inw_oth       giac_recap_summ_ext.inw_prem_oth%TYPE,
      ret_auth      giac_recap_summ_ext.retceded_prem_auth%TYPE,
      ret_asean     giac_recap_summ_ext.retceded_prem_asean%TYPE,
      ret_oth       giac_recap_summ_ext.retceded_prem_oth%TYPE,
      net_written   NUMBER (20, 2)
   );

   TYPE recap_dtl_type IS TABLE OF recap_dtl_rec_type;

   --END D--
   FUNCTION csv_recap1 (p_report_name VARCHAR2)
      RETURN recap1_type PIPELINED;

   FUNCTION csv_recap2 (p_report_name VARCHAR2)
      RETURN recap2_type PIPELINED;

   FUNCTION csv_recap3 (p_report_name VARCHAR2)
      RETURN recap3_type PIPELINED;

   FUNCTION csv_recap_dtl (p_report_name VARCHAR2, p_rowtitle VARCHAR2)
      RETURN recap_dtl_type PIPELINED;
      
   -- printgipir203csv added by carlo de guzman 3.14.2016  --
   TYPE recap4_dtl_type IS RECORD (
        regions                 VARCHAR2(100),
        industry_group          giis_industry_group.ind_grp_nm%TYPE,
        policy_holders          gixx_recapitulation.no_of_policy%TYPE,
        premiums_earned         gixx_recapitulation.gross_prem%TYPE,
        social_premiums_earned  gixx_recapitulation.social_gross_prem%TYPE,
        losses_incured          gixx_recapitulation.gross_losses%TYPE
    );
    
    TYPE recap4_dtl_tab IS TABLE OF recap4_dtl_type;
    FUNCTION csv_gipir203 
        RETURN recap4_dtl_tab PIPELINED;        
   -- printgipir203csv END --
        
   -- printgipir203Bcsv added by carlo de guzman 3.14.2016  --    
    TYPE gipir203b_type IS RECORD(
        line                    VARCHAR2(30),
        region_cd               GIXX_RECAPITULATION_LOSSES_DTL.region_cd%TYPE,
        region_desc             VARCHAR2(50),
        industry_cd             GIXX_RECAPITULATION_LOSSES_DTL.ind_grp_cd%TYPE,
        industry_name           giis_industry_group.ind_grp_nm%TYPE,       
        policy_number           VARCHAR2(100), 
        claim_number            VARCHAR2(100),
        assured_name            giis_assured.assd_name%TYPE,
        loss_amount             GIXX_RECAPITULATION_LOSSES_DTL.loss_amt%TYPE
    );
    
    TYPE gipir203b_tab IS TABLE OF gipir203b_type;    
    FUNCTION csv_gipir203B
        RETURN gipir203b_tab PIPELINED;        
    -- printgipir203Bcsv END --      
END;
/