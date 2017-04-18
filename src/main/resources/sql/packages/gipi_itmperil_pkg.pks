CREATE OR REPLACE PACKAGE CPI.GIPI_ITMPERIL_PKG AS

  TYPE endt_peril_type IS RECORD (
    policy_id        GIPI_ITMPERIL.policy_id%TYPE, 
    item_no          GIPI_ITMPERIL.item_no%TYPE,
    line_cd          GIPI_ITMPERIL.line_cd%TYPE,
    peril_cd         GIPI_ITMPERIL.peril_cd%TYPE,
    peril_name       GIIS_PERIL.peril_name%TYPE,
    prem_rt          GIPI_ITMPERIL.prem_rt%TYPE,
    tsi_amt          GIPI_ITMPERIL.tsi_amt%TYPE,
    prem_amt         GIPI_ITMPERIL.prem_amt%TYPE,
    ann_tsi_amt      GIPI_ITMPERIL.ann_tsi_amt%TYPE,
    ann_prem_amt     GIPI_ITMPERIL.ann_prem_amt%TYPE,
    ri_comm_rate     GIPI_ITMPERIL.ri_comm_rate%TYPE,
    ri_comm_amt      GIPI_ITMPERIL.ri_comm_amt%TYPE,    
    comp_rem         GIPI_ITMPERIL.comp_rem%TYPE,
    rec_flag         GIPI_ITMPERIL.rec_flag%TYPE,
    no_of_days       GIPI_ITMPERIL.no_of_days%TYPE,
    base_amt         GIPI_ITMPERIL.base_amt%TYPE,
    tarf_cd          GIPI_ITMPERIL.tarf_cd%TYPE,
    discount_sw      GIPI_ITMPERIL.discount_sw%TYPE,
    prt_flag         GIPI_ITMPERIL.prt_flag%TYPE,
    as_charge_sw     GIPI_ITMPERIL.as_charge_sw%TYPE,
    surcharge_sw     GIPI_ITMPERIL.surcharge_sw%TYPE,
    aggregate_sw     GIPI_ITMPERIL.aggregate_sw%TYPE,
    basc_perl_cd     GIIS_PERIL.basc_perl_cd%TYPE,
    peril_type       GIIS_PERIL.peril_type%TYPE);
    
  TYPE endt_peril_tab IS TABLE OF endt_peril_type;
  
--  FUNCTION get_gipi_item_peril(p_line_cd        GIPI_POLBASIC.line_cd%TYPE,
--                               p_subline_cd     GIPI_POLBASIC.subline_cd%TYPE,
--                               p_iss_cd         GIPI_POLBASIC.iss_cd%TYPE,
--                               p_issue_yy       GIPI_POLBASIC.issue_yy%TYPE,
--                               p_pol_seq_no     GIPI_POLBASIC.pol_seq_no%TYPE,
--                               p_renew_no       GIPI_POLBASIC.renew_no%TYPE,
--                               p_eff_date       VARCHAR2)
  FUNCTION get_gipi_item_peril(p_par_id        GIPI_POLBASIC.par_id%TYPE)                               
    RETURN endt_peril_tab PIPELINED; 
    
  FUNCTION check_compulsory_death(p_policy_id   GIPI_ITMPERIL.policy_id%TYPE)
    RETURN VARCHAR2; 
    
  FUNCTION get_item_peril_count(p_policy_id   GIPI_ITMPERIL.policy_id%TYPE)
    RETURN NUMBER;  
    
  TYPE gipir915_itmperil_type IS RECORD (
    itmperil_policy_id         gipi_itmperil.policy_id%TYPE,
    itmperil_item_no        gipi_itmperil.item_no%TYPE,
    tsi_amt                    gipi_itmperil.tsi_amt%TYPE,
    prem_amt                gipi_itmperil.prem_amt%TYPE
  );
  
  TYPE gipir915_itmperil_tab IS TABLE OF gipir915_itmperil_type;
  
  FUNCTION get_gipir915_itmperil(
     p_policy_id        gipi_itmperil.policy_id%TYPE,
     p_item_no            gipi_itmperil.item_no%TYPE
  )
     RETURN gipir915_itmperil_tab PIPELINED;
     
  TYPE gipi_itmperil_type IS RECORD (
    
    policy_id       GIPI_ITMPERIL.policy_id%TYPE,
    item_no         GIPI_ITMPERIL.item_no%TYPE,
    peril_cd        GIPI_ITMPERIL.peril_cd%TYPE,
    prem_rt         GIPI_ITMPERIL.prem_rt%TYPE,
    tsi_amt         GIPI_ITMPERIL.tsi_amt%TYPE,
    prem_amt        GIPI_ITMPERIL.prem_amt%TYPE,
    surcharge_sw    GIPI_ITMPERIL.surcharge_sw%TYPE,
    discount_sw     GIPI_ITMPERIL.discount_sw%TYPE,
    aggregate_sw    GIPI_ITMPERIL.aggregate_sw%TYPE,
    comp_rem        GIPI_ITMPERIL.comp_rem%TYPE,
    ri_comm_rate    GIPI_ITMPERIL.ri_comm_rate%TYPE,
    ri_comm_amt     GIPI_ITMPERIL.ri_comm_amt%TYPE,
    peril_name      GIIS_PERIL.peril_name%TYPE

  );
  
  TYPE gipi_itmperil_tab IS TABLE OF gipi_itmperil_type;
  
  FUNCTION get_gipi_itmperil(p_policy_id    GIPI_ITEM.policy_id%TYPE,
                             p_item_no      GIPI_ITEM.item_no%TYPE)
                             
    RETURN gipi_itmperil_tab PIPELINED;
    
  FUNCTION check_ctpl_coc_printing (
    p_item_no       GIPI_ITEM.item_no%TYPE,
    p_policy_id     GIPI_ITMPERIL.policy_id%TYPE
  ) RETURN VARCHAR2;

  PROCEDURE get_endt_ri_comm_rate_amt (
       p_par_id        IN   gipi_parlist.par_id%TYPE,
       p_prem_amt      IN   gipi_witmperl.prem_amt%TYPE,
       p_item_no       IN   gipi_witmperl.item_no%TYPE,
       p_peril_cd      IN   gipi_witmperl.peril_cd%TYPE,        
       p_ri_comm_rate  OUT  gipi_witmperl.ri_comm_rate%TYPE,
       p_ri_comm_amt   OUT  gipi_witmperl.ri_comm_amt%TYPE);

END GIPI_ITMPERIL_PKG;
/


