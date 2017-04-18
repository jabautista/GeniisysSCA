CREATE OR REPLACE PACKAGE CPI.giex_itmperil_pkg
AS
   TYPE giex_itmperil_type IS RECORD (
     policy_id          giex_itmperil.policy_id%TYPE,
     item_no            giex_itmperil.item_no%TYPE,
     line_cd            giex_itmperil.line_cd%TYPE,
     peril_cd           giex_itmperil.peril_cd%TYPE,
     prem_rt            giex_itmperil.prem_rt%TYPE,
     prem_amt           giex_itmperil.prem_amt%TYPE,
     tsi_amt            giex_itmperil.tsi_amt%TYPE,
     comp_rem           giex_itmperil.comp_rem%TYPE,
     item_title         giex_itmperil.item_title%TYPE,
     ann_tsi_amt        giex_itmperil.ann_tsi_amt%TYPE,
     ann_prem_amt       giex_itmperil.ann_prem_amt%TYPE,
     subline_cd         giex_itmperil.subline_cd%TYPE,
     currency_rt        giex_itmperil.currency_rt%TYPE,
     -------------------------------
     nbt_prem_amt       giex_itmperil.prem_amt%TYPE,
     nbt_tsi_amt        giex_itmperil.tsi_amt%TYPE,
     nbt_item_title     VARCHAR2(50),
     dsp_peril_name     giis_peril.peril_name%TYPE,
     dsp_peril_type     giis_peril.peril_type%TYPE,
     dsp_basc_perl_cd   giis_peril.basc_perl_cd%TYPE
   );

   TYPE giex_itmperil_tab IS TABLE OF giex_itmperil_type;
   
   PROCEDURE update_witem_giexs007(
        p_policy_id       IN    giex_itmperil.policy_id%TYPE,
        p_item_no         IN    giex_itmperil.item_no%TYPE,
        p_recompute_tax   IN    VARCHAR2,
        p_tax_sw          IN    VARCHAR2,
        p_create_peril    IN    VARCHAR2,   --added by joanne 06.03.14
        p_summary_sw      IN    VARCHAR2,   --added by joanne 06.03.14
        p_nbt_prem_amt   OUT    giex_itmperil.prem_amt%TYPE,
        p_ann_prem_amt   OUT    giex_itmperil.ann_prem_amt%TYPE,
        p_nbt_tsi_amt    OUT    giex_itmperil.tsi_amt%TYPE,
        p_ann_tsi_amt    OUT    giex_itmperil.ann_tsi_amt%TYPE
    );
    
    /*
    **  Created by       : Joanne
    **  Date Created     : 05.02.2014
    **  Description      : insert into table giex_new_group_peril
    */
   PROCEDURE insert_group_peril(
        p_policy_id       IN    giex_itmperil.policy_id%TYPE
    );
    
    FUNCTION GET_LATEST_ITEM_TITLE(
        p_line_cd 	 IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd 	 IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy 	 IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no 	 IN gipi_polbasic.renew_no%TYPE,
        p_item_no    IN gipi_item.item_no%TYPE
    )
    RETURN VARCHAR2;
    
    --joanne12.1813
   TYPE giexs007_pack_subpolicy_type IS RECORD (
     policy_id          giex_itmperil.policy_id%TYPE,
     policy_no          VARCHAR2(50),
     line_cd            giis_line.line_cd%TYPE,
     line_name          giis_line.line_name%TYPE,
     subline_cd         giis_subline.subline_cd%TYPE,
     subline_name       giis_subline.SUBLINE_NAME%TYPE,
     iss_cd 	        gipi_polbasic.iss_cd%TYPE,
     issue_yy 	        gipi_polbasic.issue_yy%TYPE,
     pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
     renew_no 	        gipi_polbasic.renew_no%TYPE,
     pack_pol_flag      giis_line.pack_pol_flag%TYPE,
     button_sw          VARCHAR2(1)
   );

   TYPE giexs007_pack_subpolicy_tab IS TABLE OF giexs007_pack_subpolicy_type;
   
    FUNCTION get_pack_policy_list (
        p_pack_policy_id   GIEX_PACK_EXPIRY.pack_policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE --added bu joanne 020314
    )
    RETURN giexs007_pack_subpolicy_tab PIPELINED;
    --end joanne
    FUNCTION get_giexs007_b480_info (
        p_policy_id   GIEX_ITMPERIL.policy_id%TYPE
    )
    RETURN giex_itmperil_tab PIPELINED;
    
    FUNCTION get_giexs007_b490_info (
        p_policy_id   GIEX_ITMPERIL.policy_id%TYPE,
        p_item_no     GIEX_ITMPERIL.item_no%TYPE
    )
    RETURN giex_itmperil_tab PIPELINED;
    
    FUNCTION COMPUTE_DEDUCTIBLE_AMT (
        p_item_no           NUMBER,
        p_peril_cd          NUMBER,
        p_ded_rt            NUMBER,
        p_ded_policy_id     giex_itmperil.policy_id%TYPE,
        p_ded_deductible_cd giis_deductible_desc.deductible_cd%TYPE
    )
    RETURN NUMBER;
    
    PROCEDURE POPULATE_PERIL(
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
    
    PROCEDURE POPULATE_PERIL2(
        p_pack_pol_flag     giis_line.pack_pol_flag%TYPE,
        p_subline_cd        giex_itmperil.subline_cd%TYPE,
        p_policy_id         giex_itmperil.policy_id%TYPE,
        p_for_delete        VARCHAR2
    );
    
    PROCEDURE INITIAL_CREATE_PERIL(
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
    
    PROCEDURE DELETE_EXPIRY_PERILS(
        p_policy_id       IN     giex_expiry.policy_id%TYPE
    );
    
    PROCEDURE CREATE_PERIL(
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
    
    PROCEDURE DELETE_PERIL(
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
    
    PROCEDURE set_b490_dtls (
        p_policy_id         giex_itmperil.policy_id%TYPE,
        p_item_no           giex_itmperil.item_no%TYPE,
        p_peril_cd          giex_itmperil.peril_cd%TYPE,
        p_line_cd           giex_itmperil.line_cd%TYPE,
        p_prem_rt           giex_itmperil.prem_rt%TYPE,
        p_prem_amt          giex_itmperil.prem_amt%TYPE,
        p_tsi_amt           giex_itmperil.tsi_amt%TYPE,
        p_comp_rem          giex_itmperil.comp_rem%TYPE,
        p_item_title        giex_itmperil.item_title%TYPE,
        p_ann_tsi_amt       giex_itmperil.ann_tsi_amt%TYPE,
        p_ann_prem_amt      giex_itmperil.ann_prem_amt%TYPE,
        p_subline_cd        giex_itmperil.subline_cd%TYPE,
        p_currency_rt       giex_itmperil.currency_rt%TYPE
    );
    
    PROCEDURE GIEXS007_POST_FORMS_COMMIT(
        P_POLICY_ID      GIPI_POLBASIC.policy_id%TYPE,
        P_PACK_POLICY_ID GIPI_POLBASIC.pack_policy_id%TYPE
    );
    
    PROCEDURE compute_tax(
        p_policy_id      gipi_polbasic.policy_id%TYPE
    );    
       
END giex_itmperil_pkg;
/


