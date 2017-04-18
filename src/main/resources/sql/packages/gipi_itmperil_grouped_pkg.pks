CREATE OR REPLACE PACKAGE CPI.GIPI_ITMPERIL_GROUPED_PKG
AS
	TYPE gipi_itmperil_grouped_type IS RECORD (
		policy_id			gipi_itmperil_grouped.policy_id%TYPE,
		item_no				gipi_itmperil_grouped.item_no%TYPE,
		grouped_item_no		gipi_itmperil_grouped.grouped_item_no%TYPE,
		line_cd				gipi_itmperil_grouped.line_cd%TYPE,
		peril_cd			gipi_itmperil_grouped.peril_cd%TYPE,
		rec_flag			gipi_itmperil_grouped.rec_flag%TYPE,
		no_of_days			gipi_itmperil_grouped.no_of_days%TYPE,
        prem_rt				gipi_itmperil_grouped.prem_rt%TYPE,
        tsi_amt				gipi_itmperil_grouped.tsi_amt%TYPE,
        prem_amt            gipi_itmperil_grouped.prem_amt%TYPE,
        ann_tsi_amt			gipi_itmperil_grouped.ann_tsi_amt%TYPE,
        ann_prem_amt        gipi_itmperil_grouped.ann_prem_amt%TYPE,
        aggregate_sw        gipi_itmperil_grouped.aggregate_sw%TYPE,
        base_amt            gipi_itmperil_grouped.base_amt%TYPE,
        ri_comm_rate        gipi_itmperil_grouped.ri_comm_rate%TYPE,
        ri_comm_amt            gipi_itmperil_grouped.ri_comm_amt%TYPE,
        arc_ext_data        gipi_itmperil_grouped.arc_ext_data%TYPE,
        peril_name            giis_peril.peril_name%TYPE,
        grouped_item_title    gipi_grouped_items.grouped_item_title%TYPE,
        peril_type            giis_peril.peril_type%TYPE);
    
    TYPE gipi_itmperil_grouped_tab IS TABLE OF gipi_itmperil_grouped_type;
    
    FUNCTION get_gipi_itmperil_grouped (
        p_policy_id IN gipi_itmperil_grouped.policy_id%TYPE,
        p_item_no IN gipi_itmperil_grouped.item_no%TYPE)
    RETURN gipi_itmperil_grouped_tab PIPELINED;
    
  TYPE itmperil_grouped_type IS RECORD (
  
    item_no                 gipi_itmperil_grouped.item_no%TYPE,
    line_cd                 gipi_itmperil_grouped.line_cd%TYPE,
    prem_rt                 gipi_itmperil_grouped.prem_rt%TYPE,
    tsi_amt                 gipi_itmperil_grouped.tsi_amt%TYPE,
    base_amt                gipi_itmperil_grouped.base_amt%TYPE,
    peril_cd                gipi_itmperil_grouped.peril_cd%TYPE,
    rec_flag                gipi_itmperil_grouped.rec_flag%TYPE,
    prem_amt                gipi_itmperil_grouped.prem_amt%TYPE,
    policy_id               gipi_itmperil_grouped.policy_id%TYPE,
    no_of_days              gipi_itmperil_grouped.no_of_days%TYPE,
    ann_tsi_amt             gipi_itmperil_grouped.ann_tsi_amt%TYPE,
    ri_comm_amt             gipi_itmperil_grouped.ri_comm_amt%TYPE,
    ann_prem_amt            gipi_itmperil_grouped.ann_prem_amt%TYPE,
    aggregate_sw            gipi_itmperil_grouped.aggregate_sw%TYPE,
    ri_comm_rate            gipi_itmperil_grouped.ri_comm_rate%TYPE,
    grouped_item_no         gipi_itmperil_grouped.grouped_item_no%TYPE,

    peril_name              giis_peril.peril_name%TYPE,
    sum_tsi_amt	            gipi_itmperil_grouped.tsi_amt%TYPE,
    sum_prem_amt            gipi_itmperil_grouped.prem_amt%TYPE

  );

  TYPE itmperil_grouped_tab IS TABLE OF itmperil_grouped_type;

    FUNCTION get_itmperil_grouped (
       p_policy_id         gipi_itmperil_grouped.policy_id%TYPE,
       p_item_no           gipi_itmperil_grouped.item_no%TYPE,
       p_grouped_item_no   gipi_itmperil_grouped.grouped_item_no%TYPE
    )
       RETURN itmperil_grouped_tab PIPELINED;
       
    FUNCTION get_itmperil_grouped_exist(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_grouped_item_no       gipi_itmperil_grouped.grouped_item_no%TYPE    
      
    )
        RETURN VARCHAR2;
    
    FUNCTION get_pol_itmperil_grouped (
        p_par_id                gipi_parlist.par_id%TYPE
    ) RETURN gipi_itmperil_grouped_tab PIPELINED;   
END GIPI_ITMPERIL_GROUPED_PKG;
/


