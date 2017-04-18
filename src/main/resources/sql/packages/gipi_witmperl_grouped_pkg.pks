CREATE OR REPLACE PACKAGE CPI.GIPI_WITMPERL_GROUPED_PKG
AS

  TYPE gipi_witmperl_grouped_type IS RECORD
    (par_id		  		  GIPI_WITMPERL_GROUPED.par_id%TYPE,
	 item_no			  GIPI_WITMPERL_GROUPED.item_no%TYPE,
	 grouped_item_no 	  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
	 line_cd		 	  GIPI_WITMPERL_GROUPED.line_cd%TYPE,
	 peril_cd			  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
	 rec_flag			  GIPI_WITMPERL_GROUPED.rec_flag%TYPE,
	 no_of_days			  GIPI_WITMPERL_GROUPED.no_of_days%TYPE,
	 prem_rt			  GIPI_WITMPERL_GROUPED.prem_rt%TYPE,
	 tsi_amt			  GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
     prem_amt              GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
     ann_tsi_amt          GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,
     ann_prem_amt          GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
     aggregate_sw          GIPI_WITMPERL_GROUPED.aggregate_sw%TYPE,
     base_amt               GIPI_WITMPERL_GROUPED.base_amt%TYPE,
     ri_comm_rate          GIPI_WITMPERL_GROUPED.ri_comm_rate%TYPE,
     ri_comm_amt          GIPI_WITMPERL_GROUPED.ri_comm_amt%TYPE,
     peril_name              GIIS_PERIL.peril_name%TYPE,
     grouped_item_title      GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
     peril_type              GIIS_PERIL.peril_type%TYPE,
	 basc_perl_cd           GIIS_PERIL.basc_perl_cd%TYPE
     );

  TYPE gipi_witmperl_grouped_tab IS TABLE OF gipi_witmperl_grouped_type;
  
  TYPE gipi_witmperl_grouped_type2 IS RECORD(
     par_id		  		  GIPI_WITMPERL_GROUPED.par_id%TYPE,
	 item_no			  GIPI_WITMPERL_GROUPED.item_no%TYPE,
	 grouped_item_no 	  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
	 line_cd		 	  GIPI_WITMPERL_GROUPED.line_cd%TYPE,
	 peril_cd			  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
	 rec_flag			  GIPI_WITMPERL_GROUPED.rec_flag%TYPE,
	 no_of_days			  GIPI_WITMPERL_GROUPED.no_of_days%TYPE,
	 prem_rt			  GIPI_WITMPERL_GROUPED.prem_rt%TYPE,
	 tsi_amt			  GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
     prem_amt              GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
     ann_tsi_amt          GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,
     ann_prem_amt          GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
     orig_ann_prem_amt     GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE, --benjo 12.16.2015 UCPBGEN-SR-20835
     aggregate_sw          GIPI_WITMPERL_GROUPED.aggregate_sw%TYPE,
     base_amt               GIPI_WITMPERL_GROUPED.base_amt%TYPE,
     ri_comm_rate          GIPI_WITMPERL_GROUPED.ri_comm_rate%TYPE,
     ri_comm_amt          GIPI_WITMPERL_GROUPED.ri_comm_amt%TYPE,
     peril_name              GIIS_PERIL.peril_name%TYPE,
     grouped_item_title      GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
     peril_type              GIIS_PERIL.peril_type%TYPE,
     basc_perl_cd           GIIS_PERIL.basc_perl_cd%TYPE
     );

  TYPE gipi_witmperl_grouped_tab2 IS TABLE OF gipi_witmperl_grouped_type2;
  
  TYPE coverage_vars_type IS RECORD(
    prem_amt                GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
    tsi_amt                 GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
    ann_prem_amt            GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
    ann_tsi_amt             GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE
  );
  TYPE coverage_vars_tab IS TABLE OF coverage_vars_type;
  
  TYPE peril_rg_type IS RECORD(
    peril_cd                GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
    tsi_amt                 GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
    peril_type              GIIS_PERIL.peril_type%TYPE,
    basc_perl_cd            GIIS_PERIL.basc_perl_cd%TYPE,
    tsi_amt1                GIPI_WITMPERL_GROUPED.tsi_amt%TYPE
  );
  TYPE peril_rg_tab IS TABLE OF peril_rg_type;

  FUNCTION get_gipi_witmperl_grouped(p_par_id    GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                          p_item_no     GIPI_WITMPERL_GROUPED.item_no%TYPE)
    RETURN gipi_witmperl_grouped_tab PIPELINED;

  PROCEDURE set_gipi_witmperl_grouped(
              p_par_id                  GIPI_WITMPERL_GROUPED.par_id%TYPE,
                 p_item_no                   GIPI_WITMPERL_GROUPED.item_no%TYPE,
            p_grouped_item_no          GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
            p_line_cd                  GIPI_WITMPERL_GROUPED.line_cd%TYPE,
            p_peril_cd                  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
            p_rec_flag                  GIPI_WITMPERL_GROUPED.rec_flag%TYPE,
            p_no_of_days              GIPI_WITMPERL_GROUPED.no_of_days%TYPE,
            p_prem_rt                  GIPI_WITMPERL_GROUPED.prem_rt%TYPE,
            p_tsi_amt                  GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
            p_prem_amt                  GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
            p_ann_tsi_amt              GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,
            p_ann_prem_amt              GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
            p_aggregate_sw              GIPI_WITMPERL_GROUPED.aggregate_sw%TYPE,
            p_base_amt                  GIPI_WITMPERL_GROUPED.base_amt%TYPE,
            p_ri_comm_rate              GIPI_WITMPERL_GROUPED.ri_comm_rate%TYPE,
            p_ri_comm_amt              GIPI_WITMPERL_GROUPED.ri_comm_amt%TYPE
              );

  PROCEDURE del_gipi_witmperl_grouped(p_par_id    GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                           p_item_no      GIPI_WITMPERL_GROUPED.item_no%TYPE);

  PROCEDURE del_gipi_witmperl_grouped2(p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                            p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
                                       p_grouped_item_no  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE);

  PROCEDURE del_gipi_witmperl_grouped3(p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                            p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
                                       p_grouped_item_no  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
                                       p_peril_cd          GIPI_WITMPERL_GROUPED.peril_cd%TYPE);
                                       
  PROCEDURE del_gipi_witmperl_grouped4(
    p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
    p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
    p_grouped_item_no  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE
  );

  FUNCTION gipi_witmperl_grouped_exist (p_par_id          GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                             p_item_no        GIPI_WITMPERL_GROUPED.item_no%TYPE)
    RETURN VARCHAR2;

  PROCEDURE pre_commit_gipis012(p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                  p_line_cd           GIPI_WITMPERL_GROUPED.line_cd%TYPE,
                                p_peril_cd            GIPI_WITMPERL_GROUPED.peril_cd%TYPE);

  FUNCTION rgitm_gipi_witmperl_grouped(p_par_id                 GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                             p_policy_id                 GIPI_GROUPED_ITEMS.policy_id%TYPE,
                                        p_item_no                 GIPI_GROUPED_ITEMS.item_no%TYPE,
                                        p_grouped_item_no         GIPI_GROUPED_ITEMS.grouped_item_no%TYPE
                                               )

    RETURN gipi_witmperl_grouped_tab PIPELINED;

  FUNCTION get_gipi_witmperl_grouped2(p_par_id    GIPI_WITMPERL_GROUPED.par_id%TYPE)
    RETURN gipi_witmperl_grouped_tab PIPELINED;
    
    FUNCTION get_gipi_witmperl_grouped3(
        p_par_id IN gipi_witmperl_grouped.par_id%TYPE,
        p_item_no IN gipi_witmperl_grouped.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_grouped.grouped_item_no%TYPE)
    RETURN gipi_witmperl_grouped_tab PIPELINED;
    
    FUNCTION get_gipi_witmperl_grouped_tg(
        p_par_id IN gipi_witmperl_grouped.par_id%TYPE,
        p_item_no IN gipi_witmperl_grouped.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_grouped.grouped_item_no%TYPE,
        p_grouped_item_title IN VARCHAR2,
        p_peril_name IN VARCHAR2)
    RETURN gipi_witmperl_grouped_tab PIPELINED;
    
    PROCEDURE populate_benefits(
        p_line_cd           IN  GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            IN  GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        IN  GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          IN  GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN  GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_WPOLBAS.renew_no%TYPE,
        p_par_id            IN  GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no           IN  GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no   IN  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_pack_ben_cd       IN  GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE
    );
    
    FUNCTION get_enrollee_coverage_listing(
        p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_prem_rt               GIPI_WITMPERL_GROUPED.prem_rt%TYPE,
        p_tsi_amt               GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
        p_ann_tsi_amt           GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,
        p_prem_amt              GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
        p_ann_prem_amt          GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
        p_peril_name            GIIS_PERIL.peril_name%TYPE
    )
      RETURN gipi_witmperl_grouped_tab2 PIPELINED;
    
    FUNCTION get_enrollee_coverage_vars(
        p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE
    )
      RETURN coverage_vars_tab PIPELINED;
      
    PROCEDURE delete_itmperl(
        p_peril_cd              GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
        p_peril_type            GIIS_PERIL.peril_type%TYPE,
        p_line_cd           GIPI_WITMPERL_GROUPED.line_cd%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_basic1          GIIS_PERIL.basc_perl_cd%TYPE,
        
        p_rec_flag      GIPI_WITMPERL_GROUPED.rec_flag%TYPE,
        p_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        
        p_eff_date          VARCHAR2,
        p_expiry_date       VARCHAR2,
        
        p_peril_list        VARCHAR2,
        p_peril_count       NUMBER,
        
        p_message       OUT        VARCHAR2
    );
    
    FUNCTION check_open_allied_peril(
        p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_eff_date              VARCHAR2,
        p_peril_cd              GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
        p_count1                NUMBER,
        p_count0                NUMBER
    )
      RETURN VARCHAR2;
      
    PROCEDURE validate_allied(
        p_line_cd                   GIPI_QUOTE.line_cd%TYPE,
        p_peril_cd                  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
        p_peril_type                GIIS_PERIL.peril_type%TYPE,
        p_basc_perl_cd              GIIS_PERIL.basc_perl_cd%TYPE,
        p_tsi_amt                   GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
        p_prem_amt                  GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
        
        p_par_id        GIPI_WPOLBAS.par_id%TYPE,
        p_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy      GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no      GIPI_WPOLBAS.renew_no%TYPE,
        
        p_post_sw                   VARCHAR2, -- y pag galing compute tsi
        p_tsi_limit_sw              VARCHAR2, -- N pag galing peril name, Y pag may changes sa tsi = tsi_amt, base_amt, no_of_days
        
        p_ann_tsi_amt               GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,               
        p_old_tsi_amt               GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
        p_item_no                   GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no           GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        
        p_eff_date      VARCHAR2,
        p_expiry_date   VARCHAR2,
        
        p_peril_list                VARCHAR,
        p_peril_count               NUMBER,
        
        p_back_endt     VARCHAR2,
        
        p_message       OUT VARCHAR2
    );
    
    PROCEDURE compute_premium(
        px_prem_amt     IN NUMBER,     -- cv001.prem_amt
         p_tsi_amt       IN NUMBER,     -- cv001.tsi_amt
         p_ann_prem_amt  IN  OUT NUMBER,     -- cv001.ann_prem_amt
         i_prem_amt      IN OUT NUMBER,     -- dsp_prem_amt
         i_ann_prem_amt  IN OUT NUMBER,     -- dsp_ann_prem_amt
         p_prov_prem_pct IN NUMBER,
         p_prov_prem_tag IN VARCHAR2,
         
         p_ann_tsi_amt IN NUMBER, -- cv1 tsi
         
         p_old_prem_amt     GIPI_ITMPERIL_GROUPED.prem_amt%TYPE,
         p_prem_rt      IN OUT GIPI_ITMPERIL_GROUPED.prem_rt%TYPE,
         p_changed_tag      GIPI_WITEM.changed_tag%TYPE,
         p_prorate_flag     GIPI_WITEM.prorate_flag%TYPE,
         p_from_date        VARCHAR2,
         p_to_date          VARCHAR2,
         p_eff_date          IN     VARCHAR2,
        p_endt_expiry_date  IN     VARCHAR2,
        p_incept_date       IN     VARCHAR2,
        p_expiry_date       IN     VARCHAR2,
         p_comp_sw           IN     GIPI_WPOLBAS.comp_sw%TYPE,
         p_short_rt_percent  GIPI_WITEM.short_rt_percent%TYPE,
         p_par_id            GIPI_WITMPERL_GROUPED.par_id%TYPE,
         p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
         
         p_line_cd      GIPI_WPOLBAS.line_cd%TYPE,
         p_subline_cd   GIPI_WPOLBAS.subline_cd%TYPE,
         p_iss_cd       GIPI_WPOLBAS.iss_cd%TYPE,
         p_issue_yy     GIPI_WPOLBAS.issue_yy%TYPE,
         p_pol_seq_no       GIPI_WPOLBAS.pol_seq_no%TYPE,
         p_renew_no     GIPI_WPOLBAS.renew_no%TYPE,
         p_peril_cd     GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
         
         p_message      OUT    VARCHAR2
    );
    
    PROCEDURE   compute_tsi2(p_tsi_amt      IN NUMBER,     -- cv001.tsi_amt
                        p_prem_rt      IN NUMBER,     -- cv001.prem_rt
                        p_ann_tsi_amt  IN OUT NUMBER,     -- cv001.ann_tsi_amt
                        p_ann_prem_amt IN OUT NUMBER,     -- cv001.ann_prem_amt
                        i_tsi_amt      IN OUT NUMBER,     -- :gipi_wgr_i.tsi_amt
                        i_prem_amt     IN OUT NUMBER,     -- :gipi_wgr_i.prem_amt
                        i_ann_tsi_amt  IN OUT NUMBER,     -- :gipi_wgr_i.ann_tsi_amt
                        i_ann_prem_amt IN OUT NUMBER,     -- :gipi_wgr_i.ann_prem_amt
                        p_prov_prem_pct IN NUMBER,
                        p_prov_prem_tag IN VARCHAR2,
                        
                        p_prem_amt      IN OUT NUMBER,
                        p_old_tsi       IN NUMBER,
                        p_old_prem_amt  IN NUMBER,
                        p_old_prem_rt   IN NUMBER,
                        
                        p_changed_tag   IN   GIPI_WITEM.changed_tag%TYPE,
                        p_peril_type    IN VARCHAR,
                        p_prorate_flag  IN NUMBER,
                        p_comp_sw       IN GIPI_WPOLBAS.comp_sw%TYPE,
                        p_short_rt_percent  GIPI_WITEM.short_rt_percent%TYPE,
                        
                       p_par_id            GIPI_WITMPERL_GROUPED.par_id%TYPE,
                        p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
                        p_peril_cd          GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
                        
                        p_to_date       IN VARCHAR2,
                        p_from_date     IN VARCHAR2,
                        p_eff_date          IN     VARCHAR2,
                        p_endt_expiry_date  IN     VARCHAR2,
                        p_incept_date       IN     VARCHAR2,
                        p_expiry_date       IN     VARCHAR2,
                        
                        p_line_cd           IN     GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd        IN     GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            IN     GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy          IN     GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN     GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          IN     GIPI_WPOLBAS.renew_no%TYPE,
                        
                        p_message       OUT VARCHAR2
                        );
                        
    PROCEDURE insert_recgrp_witem(
        p_line_cd           IN     GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd        IN     GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            IN     GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy          IN     GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN     GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          IN     GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date          IN      VARCHAR2,
        p_par_id            IN      GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no           IN      GIPI_WITMPERL_GROUPED.item_no%TYPE
    );
    
    FUNCTION prepare_peril_rg(
        p_peril_list                VARCHAR2,
        p_peril_count               NUMBER
    )
      RETURN peril_rg_tab PIPELINED;
      
    function check_duration(p_date1 date, p_date2 date) return number;
END;
/


