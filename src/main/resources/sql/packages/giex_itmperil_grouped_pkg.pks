CREATE OR REPLACE PACKAGE CPI.giex_itmperil_grouped_pkg
AS
   TYPE giex_itmperil_grouped_type IS RECORD (
     policy_id          giex_itmperil_grouped.policy_id%TYPE,
     item_no            giex_itmperil_grouped.item_no%TYPE,
     grouped_item_no    giex_itmperil_grouped.grouped_item_no%TYPE,
     line_cd            giex_itmperil_grouped.line_cd%TYPE,
     peril_cd           giex_itmperil_grouped.peril_cd%TYPE,
     prem_rt            giex_itmperil_grouped.prem_rt%TYPE,
     prem_amt           giex_itmperil_grouped.prem_amt%TYPE,
     tsi_amt            giex_itmperil_grouped.tsi_amt%TYPE,
     ann_tsi_amt        giex_itmperil_grouped.ann_tsi_amt%TYPE,
     ann_prem_amt       giex_itmperil_grouped.ann_prem_amt%TYPE,
     aggregate_sw       giex_itmperil_grouped.aggregate_sw%TYPE,
     base_amt           giex_itmperil_grouped.base_amt%TYPE,
     ri_comm_rate       giex_itmperil_grouped.ri_comm_rate%TYPE,
     ri_comm_amt        giex_itmperil_grouped.ri_comm_amt%TYPE,
     no_of_days         giex_itmperil_grouped.no_of_days%TYPE,
     -------------------------------
     nbt_prem_amt           giex_itmperil_grouped.prem_amt%TYPE,
     nbt_tsi_amt            giex_itmperil_grouped.tsi_amt%TYPE,
     nbt_item_title         VARCHAR2(50),
     nbt_grouped_item_title VARCHAR2(50),
     dsp_peril_name         giis_peril.peril_name%TYPE,
     dsp_peril_type         giis_peril.peril_type%TYPE,
     dsp_basc_perl_cd       giis_peril.basc_perl_cd%TYPE
   );

   TYPE giex_itmperil_grouped_tab IS TABLE OF giex_itmperil_grouped_type;
   
   PROCEDURE update_witem_grp(
        p_policy_id       IN    giex_itmperil_grouped.policy_id%TYPE,
        p_item_no         IN    giex_itmperil_grouped.item_no%TYPE,
        p_grouped_item_no IN    giex_itmperil_grouped.grouped_item_no%TYPE,
        p_recompute_tax   IN    VARCHAR2,
        p_tax_sw          IN    VARCHAR2,
        p_nbt_prem_amt   OUT    giex_itmperil_grouped.prem_amt%TYPE,
        p_ann_prem_amt   OUT    giex_itmperil_grouped.ann_prem_amt%TYPE,
        p_nbt_tsi_amt    OUT    giex_itmperil_grouped.tsi_amt%TYPE,
        p_ann_tsi_amt    OUT    giex_itmperil_grouped.ann_tsi_amt%TYPE
    );
    
    FUNCTION GET_LATEST_GROUPED_ITEM_TITLE(
        p_line_cd 	 IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd     IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy 	 IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no 	 IN gipi_polbasic.renew_no%TYPE,
        p_grouped_no IN gipi_grouped_items.grouped_item_no%TYPE
    ) 
    RETURN VARCHAR2;
    
    FUNCTION get_giexs007_b480_grp_info (
        p_policy_id   GIEX_ITMPERIL_GROUPED.policy_id%TYPE
    )
    RETURN giex_itmperil_grouped_tab PIPELINED;
    
    FUNCTION get_giexs007_b490_grp_info (
        p_policy_id         GIEX_ITMPERIL_GROUPED.policy_id%TYPE,
        p_item_no           GIEX_ITMPERIL_GROUPED.item_no%TYPE,
        p_grouped_item_no   GIEX_ITMPERIL_GROUPED.grouped_item_no%TYPE
    )
    RETURN giex_itmperil_grouped_tab PIPELINED;
    
    PROCEDURE POPULATE_PERIL_GRP(
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_policy_id       IN     giex_itmperil.policy_id%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_for_delete      IN OUT VARCHAR2 
    );
    
    PROCEDURE POPULATE_PERIL2_GRP(
        p_pack_pol_flag     giis_line.pack_pol_flag%TYPE,
        p_subline_cd        giex_itmperil.subline_cd%TYPE,
        p_policy_id         giex_itmperil.policy_id%TYPE,
        p_for_delete        VARCHAR2
    );
    
    PROCEDURE CREATE_PERIL_GRP(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_pack_policy_id  IN     giex_expiry.pack_policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_item_no         IN     giex_itmperil.item_no%TYPE,
        p_grouped_item_no IN     giex_itmperil_grouped.grouped_item_no%TYPE,
        p_recompute_tax   IN     VARCHAR2,
        p_tax_sw          IN     VARCHAR2,
        p_for_delete      IN OUT VARCHAR2,
        p_nbt_prem_amt       OUT giex_itmperil.prem_amt%TYPE,
        p_ann_prem_amt       OUT giex_itmperil.ann_prem_amt%TYPE,
        p_nbt_tsi_amt        OUT giex_itmperil.tsi_amt%TYPE,
        p_ann_tsi_amt        OUT giex_itmperil.ann_tsi_amt%TYPE
    );
    
    PROCEDURE DELETE_PERIL_GRP(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE
    );
    
    PROCEDURE set_b490_grp_dtls (
        p_policy_id         giex_itmperil_grouped.policy_id%TYPE,
        p_item_no           giex_itmperil_grouped.item_no%TYPE,
        p_grouped_item_no   giex_itmperil_grouped.grouped_item_no%TYPE,
        p_line_cd           giex_itmperil_grouped.line_cd%TYPE,
        p_peril_cd          giex_itmperil_grouped.peril_cd%TYPE,
        p_prem_rt           giex_itmperil_grouped.prem_rt%TYPE,
        p_prem_amt          giex_itmperil_grouped.prem_amt%TYPE,
        p_tsi_amt           giex_itmperil_grouped.tsi_amt%TYPE,
        p_ann_tsi_amt       giex_itmperil_grouped.ann_tsi_amt%TYPE,
        p_ann_prem_amt      giex_itmperil_grouped.ann_prem_amt%TYPE,
        p_aggregate_sw      giex_itmperil_grouped.aggregate_sw%TYPE,
        p_base_amt          giex_itmperil_grouped.base_amt%TYPE,
        p_no_of_days        giex_itmperil_grouped.no_of_days%TYPE
    );
   
END giex_itmperil_grouped_pkg;
/


