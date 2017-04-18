CREATE OR REPLACE PACKAGE CPI.GIUW_WPERILDS_PKG
AS
    TYPE giuw_wperilds_type IS RECORD (
        dist_no            giuw_wperilds.dist_no%TYPE,
        dist_seq_no        giuw_wperilds.dist_seq_no%TYPE,
        peril_cd        giuw_wperilds.peril_cd%TYPE,
        peril_name        giis_peril.peril_name%TYPE,
        line_cd            giuw_wperilds.line_cd%TYPE,
        tsi_amt            giuw_wperilds.tsi_amt%TYPE,
        prem_amt        giuw_wperilds.prem_amt%TYPE,
        ann_tsi_amt        giuw_wperilds.ann_tsi_amt%TYPE,
        dist_flag        giuw_wperilds.dist_flag%TYPE,
        arc_ext_data    giuw_wperilds.arc_ext_data%TYPE,
        currency_desc    giis_currency.currency_desc%TYPE,
        
        item_grp                GIUW_WPOLICYDS.item_grp%TYPE,
        currency_cd             GIIS_CURRENCY.main_currency_cd%TYPE,
        currency_rt             GIIS_CURRENCY.currency_rt%TYPE,
        currency_shrtname       GIIS_CURRENCY.short_name%TYPE,
        pack_line_cd            GIPI_ITEM.pack_line_cd%TYPE,
        pack_subline_cd         GIPI_ITEM.pack_subline_cd%TYPE,
        orig_dist_seq_no        GIUW_WPERILDS.dist_seq_no%TYPE,
        orig_peril_cd           GIIS_PERIL.peril_cd%TYPE,
        peril_type              GIIS_PERIL.peril_type%TYPE,
        basc_perl_cd            GIIS_PERIL.basc_perl_cd%TYPE,
		max_dist_seq_no			NUMBER,
        cnt_per_dist_grp        NUMBER  -- jhing 12.11.2014 
        );
    
    TYPE giuw_wperilds_tab IS TABLE OF giuw_wperilds_type;
    
    PROCEDURE del_giuw_wperilds (p_dist_no     GIUW_WPERILDS.dist_no%TYPE);
    
    PROCEDURE del_giuw_wperilds2(p_dist_no     GIUW_WPERILDS.dist_no%TYPE,
                                   p_dist_seq_no GIUW_WPERILDS.dist_seq_no%TYPE,
                                 p_peril_cd       GIUW_WPERILDS.peril_cd%TYPE,
                                 p_line_cd       GIUW_WPERILDS.dist_no%TYPE);
    
    FUNCTION get_giuw_wperilds (p_dist_no IN giuw_wperilds.dist_no%TYPE)
    RETURN giuw_wperilds_tab PIPELINED;
    
    PROCEDURE set_giuw_wperilds(
        p_dist_no                    giuw_wperilds.dist_no%TYPE,
        p_dist_seq_no              giuw_wperilds.dist_seq_no%TYPE,
        p_peril_cd                  giuw_wperilds.peril_cd%TYPE,
        p_line_cd                  giuw_wperilds.line_cd%TYPE,
        p_tsi_amt                  giuw_wperilds.tsi_amt%TYPE,
        p_prem_amt                  giuw_wperilds.prem_amt%TYPE,
        p_ann_tsi_amt              giuw_wperilds.ann_tsi_amt%TYPE,
        p_dist_flag                  giuw_wperilds.dist_flag%TYPE,
        p_arc_ext_data              giuw_wperilds.arc_ext_data%TYPE);
        
    FUNCTION get_giuw_wperilds2 (
        p_dist_no IN giuw_wperilds.dist_no%TYPE,
        p_policy_id  gipi_polbasic.policy_id%TYPE
    )
    RETURN giuw_wperilds_tab PIPELINED;
    
    PROCEDURE del_giuw_wperilds3(
        p_dist_no             GIUW_WPERILDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WPERILDS.dist_seq_no%TYPE
        );
        
    -- added by jhing 12.10.2014 
    PROCEDURE del_giuw_wperilds4(
        p_dist_no             GIUW_WPERILDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WPERILDS.dist_seq_no%TYPE,
        p_peril_cd          GIUW_WPERILDS.peril_cd%TYPE /* jhing 11.28.2014 added peril_cd */ 
        );
                
    FUNCTION get_giuw_wperilds3 (p_dist_no IN giuw_wperilds.dist_no%TYPE)
    RETURN giuw_wperilds_tab PIPELINED;
        
    FUNCTION get_giuw_wperilds_exist (
      p_dist_no   giuw_wperilds.dist_no%TYPE)
    RETURN VARCHAR2;
        
    PROCEDURE get_giuw_wperilds_exist2(
        p_dist_no                   IN  giuw_wperilds.dist_no%TYPE,
        p_pol_flag                  IN  gipi_wpolbas.pol_flag%TYPE,
        p_par_type                  IN  gipi_parlist.par_type%TYPE,
        p_giuw_wperilds_exist       OUT VARCHAR2,
        p_giuw_wperilds_dtl_exist   OUT VARCHAR2
        );
    
    PROCEDURE neg_perilds (
        p_dist_no     IN  giuw_perilds.dist_no%TYPE,
        p_temp_distno IN  giuw_perilds.dist_no%TYPE
    );
    
    FUNCTION get_giuw_wperilds_exist3 (
      p_dist_no   giuw_wperilds.dist_no%TYPE)
    RETURN VARCHAR2;
    
    PROCEDURE NEG_PERILDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_v_ratio          IN OUT NUMBER);
                                  
    PROCEDURE TRANSFER_WPERILDS (p_dist_no     IN   GIUW_POL_DIST.dist_no%TYPE);
            
END GIUW_WPERILDS_PKG;
/


