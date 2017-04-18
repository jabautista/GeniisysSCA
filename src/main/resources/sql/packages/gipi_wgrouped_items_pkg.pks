CREATE OR REPLACE PACKAGE CPI.Gipi_Wgrouped_Items_Pkg
AS
  TYPE gipi_wgrouped_items_type IS RECORD (
        par_id				gipi_wgrouped_items.par_id%TYPE,
        item_no				gipi_wgrouped_items.item_no%TYPE,
        grouped_item_no		gipi_wgrouped_items.grouped_item_no%TYPE,    
        include_tag			gipi_wgrouped_items.include_tag%TYPE,           
        grouped_item_title	gipi_wgrouped_items.grouped_item_title%TYPE,        
        sex					gipi_wgrouped_items.sex%TYPE,                    
        position_cd			gipi_wgrouped_items.position_cd%TYPE,               
        civil_status		gipi_wgrouped_items.civil_status%TYPE,                    
        date_of_birth		gipi_wgrouped_items.date_of_birth%TYPE,                         
        age					gipi_wgrouped_items.age%TYPE,                                         
        salary                gipi_wgrouped_items.salary%TYPE,               
        salary_grade        gipi_wgrouped_items.salary_grade%TYPE, 
        amount_covered        gipi_wgrouped_items.amount_covered%TYPE,
        remarks                gipi_wgrouped_items.remarks%TYPE, -- changed back to remarks by robert 09262013-- mark jm 12.14.2011 change data type to clob
        line_cd                gipi_wgrouped_items.line_cd%TYPE, 
        subline_cd            gipi_wgrouped_items.subline_cd%TYPE,        
        delete_sw            gipi_wgrouped_items.delete_sw%TYPE,           
        group_cd            gipi_wgrouped_items.group_cd%TYPE, 
        from_date            gipi_wgrouped_items.from_date%TYPE,      
        TO_DATE                gipi_wgrouped_items.TO_DATE%TYPE,              
        payt_terms            gipi_wgrouped_items.payt_terms%TYPE,
        pack_ben_cd            gipi_wgrouped_items.pack_ben_cd%TYPE,  
        ann_tsi_amt            gipi_wgrouped_items.ann_tsi_amt%TYPE,          
        ann_prem_amt        gipi_wgrouped_items.ann_prem_amt%TYPE,
        control_cd            gipi_wgrouped_items.control_cd%TYPE, 
        control_type_cd        gipi_wgrouped_items.control_type_cd%TYPE,      
        tsi_amt                gipi_wgrouped_items.tsi_amt%TYPE,
        prem_amt            gipi_wgrouped_items.prem_amt%TYPE,       
        principal_cd        gipi_wgrouped_items.principal_cd%TYPE,         
        group_desc            giis_group.group_desc%TYPE,
        package_cd            giis_package_benefit.package_cd%TYPE,            
        payt_terms_desc        giis_payterm.payt_terms_desc%TYPE);
        
  TYPE gipi_grouped_items_type IS RECORD(
          policy_id                   GIPI_GROUPED_ITEMS.policy_id%TYPE,
          grouped_item_no            GIPI_GROUPED_ITEMS.grouped_item_no%TYPE,
        grouped_item_title        GIPI_GROUPED_ITEMS.grouped_item_title%TYPE,
        item_no                    GIPI_GROUPED_ITEMS.item_no%TYPE,
        control_cd                GIPI_GROUPED_ITEMS.control_cd%TYPE,
        control_type_cd            GIPI_GROUPED_ITEMS.control_type_cd%TYPE
        );
        
    TYPE gipi_wgrouped_items_type2 IS RECORD (
        par_id				gipi_wgrouped_items.par_id%TYPE,
        item_no				gipi_wgrouped_items.item_no%TYPE,
        grouped_item_no		gipi_wgrouped_items.grouped_item_no%TYPE,    
        include_tag			gipi_wgrouped_items.include_tag%TYPE,           
        grouped_item_title	gipi_wgrouped_items.grouped_item_title%TYPE,        
        sex					gipi_wgrouped_items.sex%TYPE,                    
        position_cd			gipi_wgrouped_items.position_cd%TYPE,               
        civil_status		gipi_wgrouped_items.civil_status%TYPE,                    
        date_of_birth		gipi_wgrouped_items.date_of_birth%TYPE,                         
        age					gipi_wgrouped_items.age%TYPE,                                         
        salary              gipi_wgrouped_items.salary%TYPE,               
        salary_grade        gipi_wgrouped_items.salary_grade%TYPE, 
        amount_covered      gipi_wgrouped_items.amount_covered%TYPE,
        remarks             CLOB,
        line_cd             gipi_wgrouped_items.line_cd%TYPE, 
        subline_cd          gipi_wgrouped_items.subline_cd%TYPE,        
        delete_sw           gipi_wgrouped_items.delete_sw%TYPE,           
        group_cd            gipi_wgrouped_items.group_cd%TYPE, 
        from_date           gipi_wgrouped_items.from_date%TYPE,      
        TO_DATE             gipi_wgrouped_items.TO_DATE%TYPE,              
        payt_terms          gipi_wgrouped_items.payt_terms%TYPE,
        pack_ben_cd         gipi_wgrouped_items.pack_ben_cd%TYPE,  
        ann_tsi_amt         gipi_wgrouped_items.ann_tsi_amt%TYPE,          
        ann_prem_amt        gipi_wgrouped_items.ann_prem_amt%TYPE,
        control_cd          gipi_wgrouped_items.control_cd%TYPE, 
        control_type_cd     gipi_wgrouped_items.control_type_cd%TYPE,      
        tsi_amt             gipi_wgrouped_items.tsi_amt%TYPE,
        prem_amt            gipi_wgrouped_items.prem_amt%TYPE,       
        principal_cd        gipi_wgrouped_items.principal_cd%TYPE,         
        group_desc          giis_group.group_desc%TYPE,
        package_cd          giis_package_benefit.package_cd%TYPE,            
        payt_terms_desc     giis_payterm.payt_terms_desc%TYPE,
        control_type_desc   GIIS_CONTROL_TYPE.control_type_desc%TYPE,
        principal_sw        VARCHAR2(1),
        position_desc        GIIS_POSITION.position%TYPE,
        civil_status_desc     CG_REF_CODES.rv_meaning%TYPE
    );
    TYPE gipi_wgrouped_items_tab2 IS TABLE OF gipi_wgrouped_items_type2;
    
    TYPE grouped_items_vars_type IS RECORD(
        par_id              GIPI_WPOLBAS.par_id%TYPE,
        line_cd             GIPI_WPOLBAS.line_cd%TYPE,
        iss_cd              GIPI_WPOLBAS.iss_cd%TYPE,
        subline_cd          GIPI_WPOLBAS.subline_cd%TYPE,
        issue_yy            GIPI_WPOLBAS.issue_yy%TYPE,
        pol_seq_no          GIPI_WPOLBAS.pol_seq_no%TYPE,
        renew_no            GIPI_WPOLBAS.renew_no%TYPE,
        prorate_flag        GIPI_WPOLBAS.prorate_flag%TYPE,
        endt_expiry_date    GIPI_WPOLBAS.endt_expiry_date%TYPE,
        eff_date            GIPI_WPOLBAS.eff_date%TYPE,
        item_no             GIPI_WGROUPED_ITEMS.item_no%TYPE,
        itmperil_exist      VARCHAR2(1),
        no_of_persons       GIPI_WACCIDENT_ITEM.no_of_persons%TYPE,
        pack_pol_flag       GIPI_WPOLBAS.pack_pol_flag%TYPE,
        pol_flag_sw         GIPI_WPOLBAS.pol_flag%TYPE,
        pack_line_cd        GIPI_WITEM.pack_line_cd%TYPE,
        pack_subline_cd     GIPI_WITEM.pack_subline_cd%TYPE,
        changed_tag         GIPI_WITEM.changed_tag%TYPE,
        comp_sw             GIPI_WPOLBAS.comp_sw%TYPE,
        short_rt_percent    GIPI_WITEM.short_rt_percent%TYPE,
        incept_date         GIPI_WPOLBAS.incept_date%TYPE,
        expiry_date         GIPI_WPOLBAS.expiry_date%TYPE,
        prov_prem_pct       GIPI_WPOLBAS.prov_prem_pct%TYPE,
        prov_prem_tag       GIPI_WPOLBAS.prov_prem_tag%TYPE,
        rec_flag            GIPI_ITEM.rec_flag%TYPE,
        endt_tax_sw         GIPI_WENDTTEXT.endt_tax%TYPE,
        par_status          GIPI_PARLIST.par_status%TYPE
    );
    TYPE grouped_items_vars_tab IS TABLE OF grouped_items_vars_type;
        
  TYPE gipi_grouped_items_tab IS TABLE OF gipi_grouped_items_type;
      
  TYPE gipi_wgrouped_items_tab IS TABLE OF gipi_wgrouped_items_type;

  FUNCTION get_gipi_wgrouped_items(p_par_id    GIPI_WGROUPED_ITEMS.par_id%TYPE)
    RETURN gipi_wgrouped_items_tab PIPELINED;
    
  FUNCTION get_gipi_wgrouped_items2(p_par_id    GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                         p_item_no    GIPI_WGROUPED_ITEMS.item_no%TYPE)
    RETURN gipi_wgrouped_items_tab PIPELINED;
  
  Procedure set_gipi_wgrouped_items(
              p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
            p_item_no                GIPI_WGROUPED_ITEMS.item_no%TYPE,
            p_grouped_item_no         GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,    
            p_include_tag             GIPI_WGROUPED_ITEMS.include_tag%TYPE,           
            p_grouped_item_title     GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
            p_group_cd                 GIPI_WGROUPED_ITEMS.group_cd%TYPE,
            p_amount_covered         GIPI_WGROUPED_ITEMS.amount_covered%TYPE,
            p_remarks                 GIPI_WGROUPED_ITEMS.remarks%TYPE,              
            p_line_cd                 GIPI_WGROUPED_ITEMS.line_cd%TYPE, 
            p_subline_cd             GIPI_WGROUPED_ITEMS.subline_cd%TYPE 
              );
            
  Procedure set_gipi_wgrouped_items2(
              p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
            p_item_no                GIPI_WGROUPED_ITEMS.item_no%TYPE,
            p_grouped_item_no         GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,    
            p_include_tag             GIPI_WGROUPED_ITEMS.include_tag%TYPE,           
            p_grouped_item_title     GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
            p_group_cd                 GIPI_WGROUPED_ITEMS.group_cd%TYPE,
            p_amount_covered         GIPI_WGROUPED_ITEMS.amount_covered%TYPE,
            p_remarks                 GIPI_WGROUPED_ITEMS.remarks%TYPE,              
            p_line_cd                 GIPI_WGROUPED_ITEMS.line_cd%TYPE, 
            p_subline_cd             GIPI_WGROUPED_ITEMS.subline_cd%TYPE,
            p_sex                    GIPI_WGROUPED_ITEMS.sex%TYPE,
            p_position_cd            GIPI_WGROUPED_ITEMS.position_cd%TYPE,
            p_civil_status            GIPI_WGROUPED_ITEMS.civil_status%TYPE,
            p_date_of_birth            GIPI_WGROUPED_ITEMS.date_of_birth%TYPE,
            p_age                    GIPI_WGROUPED_ITEMS.age%TYPE,
            p_salary                GIPI_WGROUPED_ITEMS.salary%TYPE,
            p_salary_grade            GIPI_WGROUPED_ITEMS.salary_grade%TYPE,
            p_delete_sw                GIPI_WGROUPED_ITEMS.delete_sw%TYPE,
            p_from_date                GIPI_WGROUPED_ITEMS.from_date%TYPE,
            p_to_date                GIPI_WGROUPED_ITEMS.TO_DATE%TYPE,
            p_payt_terms            GIPI_WGROUPED_ITEMS.payt_terms%TYPE,
            p_pack_ben_cd            GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE,
            p_ann_tsi_amt            GIPI_WGROUPED_ITEMS.ann_tsi_amt%TYPE,
            p_ann_prem_amt            GIPI_WGROUPED_ITEMS.ann_prem_amt%TYPE,
            p_tsi_amt                GIPI_WGROUPED_ITEMS.tsi_amt%TYPE,
            p_prem_amt                GIPI_WGROUPED_ITEMS.prem_amt%TYPE,
            p_control_cd            GIPI_WGROUPED_ITEMS.control_cd%TYPE,
            p_control_type_cd        GIPI_WGROUPED_ITEMS.control_type_cd%TYPE,
            p_principal_cd            GIPI_WGROUPED_ITEMS.principal_cd%TYPE
              );        
            
  Procedure del_gipi_wgrouped_items(p_par_id    GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                      p_item_no   GIPI_WGROUPED_ITEMS.item_no%TYPE);            
    
  Procedure del_gipi_wgrouped_items2(p_par_id          GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                       p_item_no         GIPI_WGROUPED_ITEMS.item_no%TYPE,
                                     p_grouped_item_no GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE);    
      
  Procedure insert_recgrp_witem(p_par_id               GIPI_WACCIDENT_ITEM.par_id%TYPE,
                                  p_item_no              GIPI_WACCIDENT_ITEM.item_no%TYPE,
                                p_line_cd             GIPI_WPOLBAS.line_cd%TYPE,
                                p_grouped_item_no    GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
                                p_no_of_person       NUMBER);    
                                
  Procedure del_grouped_items_per_item(p_par_id    GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                         p_item_no   GIPI_WGROUPED_ITEMS.item_no%TYPE);
    
  Procedure del_gipi_wgrouped_items (p_par_id IN GIPI_WGROUPED_ITEMS.par_id%TYPE);
  
  PROCEDURE populate_benefits(p_par_id               GIPI_WACCIDENT_ITEM.par_id%TYPE,
                                p_item_no              GIPI_WACCIDENT_ITEM.item_no%TYPE,
                              p_grouped_item_no      GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
                              p_pack_ben_cd             GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE,
                              p_line_cd                 GIPI_WGROUPED_ITEMS.line_cd%TYPE);
                              
  PROCEDURE populate_benefits2(p_par_id               GIPI_WACCIDENT_ITEM.par_id%TYPE,
                                 p_item_no              GIPI_WACCIDENT_ITEM.item_no%TYPE);
                                  
  FUNCTION gipi_wgrouped_items_exist (p_par_id      GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                           p_item_no        GIPI_WGROUPED_ITEMS.item_no%TYPE)
    RETURN VARCHAR2;
  
  PROCEDURE RENUMBER_GROUP (p_par_id      GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                 p_item_no        GIPI_WGROUPED_ITEMS.item_no%TYPE);
                            
  PROCEDURE copy_benefits(p_par_id                    GIPI_WGROUPED_ITEMS.par_id%TYPE,
                               p_item_no                      GIPI_WGROUPED_ITEMS.item_no%TYPE,
                          p_line_cd                      GIPI_WPOLBAS.line_cd%TYPE,
                          p_grouped_item_no           GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
                          p_benefits_sw               VARCHAR2,
                          p_orig_grouped_item_no    GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
                          p_pack_ben_cd                  GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE);    
                              
  FUNCTION check_retrieve_grouped_items(p_line_cd                GIPI_POLBASIC.line_cd%TYPE,
                                       p_subline_cd          GIPI_POLBASIC.subline_cd%TYPE,
                                  p_iss_cd              GIPI_POLBASIC.iss_cd%TYPE,
                                  p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
                                  p_pol_seq_no          GIPI_POLBASIC.pol_seq_no%TYPE,
                                  p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
                                  p_item_no              GIPI_GROUPED_ITEMS.item_no%TYPE,
                                  p_eff_date          GIPI_POLBASIC.eff_date%TYPE
                                      )    
    RETURN VARCHAR2;    
    
  FUNCTION retrieve_grouped_items(p_par_id                    GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                 p_line_cd                        GIPI_POLBASIC.LINE_CD%TYPE,
                                 p_subline_cd                 GIPI_POLBASIC.SUBLINE_CD%TYPE,
                            p_iss_cd                     GIPI_POLBASIC.ISS_CD%TYPE,
                            p_issue_yy                     GIPI_POLBASIC.ISSUE_YY%TYPE,
                            p_pol_seq_no                 GIPI_POLBASIC.POL_SEQ_NO%TYPE,
                            p_renew_no                     GIPI_POLBASIC.RENEW_NO%TYPE,
                            p_item_no                     GIPI_GROUPED_ITEMS.item_no%TYPE,
                            p_eff_date                     GIPI_POLBASIC.eff_date%TYPE
                            )
    RETURN gipi_grouped_items_tab PIPELINED;    
    
  PROCEDURE insert_retrieved_grouped_items(p_par_id                    GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                 p_line_cd                        GIPI_POLBASIC.LINE_CD%TYPE,
                                 p_subline_cd                 GIPI_POLBASIC.SUBLINE_CD%TYPE,
                            p_iss_cd                     GIPI_POLBASIC.ISS_CD%TYPE,
                            p_issue_yy                     GIPI_POLBASIC.ISSUE_YY%TYPE,
                            p_pol_seq_no                 GIPI_POLBASIC.POL_SEQ_NO%TYPE,
                            p_renew_no                     GIPI_POLBASIC.RENEW_NO%TYPE,
                            p_item_no                     GIPI_GROUPED_ITEMS.item_no%TYPE,
                            p_eff_date                     GIPI_POLBASIC.eff_date%TYPE,
                            p_grouped_item_no             GIPI_WGROUPED_ITEMS.GROUPED_ITEM_NO%TYPE,
                            p_grouped_item_title         GIPI_WGROUPED_ITEMS.GROUPED_ITEM_TITLE%TYPE,
                            p_control_cd                 GIPI_WGROUPED_ITEMS.CONTROL_CD%TYPE,
                            p_control_type_cd             GIPI_WGROUPED_ITEMS.CONTROL_TYPE_CD%TYPE
                            );    
                            
  FUNCTION retgrpitms_gipi_wgrouped_items(p_par_id                           GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                             p_policy_id                             GIPI_GROUPED_ITEMS.policy_id%TYPE,
                                             p_item_no                       GIPI_GROUPED_ITEMS.item_no%TYPE,
                                          p_grouped_item_no               GIPI_GROUPED_ITEMS.grouped_item_no%TYPE
                                             )
    RETURN gipi_wgrouped_items_tab PIPELINED;                                        
  
  
  PROCEDURE renumber_group2(p_par_id        GIPI_WGROUPED_ITEMS.par_id%TYPE,
                            p_old_item_no   GIPI_WGROUPED_ITEMS.item_no%TYPE,
                            p_new_item_no   GIPI_WGROUPED_ITEMS.item_no%TYPE);

    FUNCTION get_gipi_wgrouped_pack_pol (
        p_par_id IN gipi_wgrouped_items.par_id%TYPE,
        p_item_no IN gipi_wgrouped_items.item_no%TYPE)
    RETURN gipi_wgrouped_items_tab PIPELINED;
    
    FUNCTION get_gipi_wgrouped_items_tg(
        p_par_id IN gipi_wgrouped_items.par_id%TYPE,
          p_item_no IN gipi_wgrouped_items.item_no%TYPE,
        p_item_title IN VARCHAR2,
        p_remarks IN VARCHAR2)
    RETURN gipi_wgrouped_items_tab PIPELINED;
    
    PROCEDURE insert_recgrp_witem1 (
        p_par_id IN gipi_waccident_item.par_id%TYPE,
        p_item_no IN gipi_waccident_item.item_no%TYPE,
        p_grouped_item_no IN gipi_wgrouped_items.grouped_item_no%TYPE,    
        p_line_cd IN gipi_wgrouped_items.line_cd%TYPE);
    
    PROCEDURE populate_benefits_tg (
        p_par_id IN gipi_waccident_item.par_id%TYPE,
        p_item_no IN gipi_waccident_item.item_no%TYPE,
        p_grouped_item_no IN gipi_wgrouped_items.grouped_item_no%TYPE,
        p_orig_grp_item_no IN gipi_wgrouped_items.grouped_item_no%TYPE,
        p_pack_ben_cd IN gipi_wgrouped_items.pack_ben_cd%TYPE,
        p_line_cd IN gipi_wgrouped_items.line_cd%TYPE,
        p_delete_ben_sw IN VARCHAR2,
        p_pop_checker IN VARCHAR2);    
		
	FUNCTION get_wgrouped_items_listing(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_grouped_item_title    GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
        p_principal_cd          GIPI_WGROUPED_ITEMS.principal_cd%TYPE,
        p_package_cd            GIIS_PACKAGE_BENEFIT.package_cd%TYPE,
        p_payt_terms            GIPI_WGROUPED_ITEMS.payt_terms%TYPE,
        p_from_date             VARCHAR2,
        p_to_date               VARCHAR2
    )
      RETURN gipi_wgrouped_items_tab2 PIPELINED;
      
    FUNCTION get_wgrouped_item(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_amount_covered    GIPI_WGROUPED_ITEMS.amount_covered%TYPE,
        p_group_cd          GIPI_WGROUPED_ITEMS.group_cd%TYPE
    )
      RETURN gipi_wgrouped_items_tab2 PIPELINED;
      
    FUNCTION neg_del_item(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION set_grouped_items_vars(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN grouped_items_vars_tab PIPELINED;
      
    FUNCTION validate_retrieve_grp_items(
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date          VARCHAR2,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION pre_negate_delete(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    )
      RETURN VARCHAR2;
      
    FUNCTION check_back_endt(
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date          VARCHAR2,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    )
      RETURN VARCHAR2;
      
    PROCEDURE negate_delete(
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_to_date           VARCHAR2,
        p_from_date         VARCHAR2
    );
    
    FUNCTION retrieve_grouped_items2(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_eff_date              VARCHAR2,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_grouped_item_title    GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE
    )
      RETURN gipi_grouped_items_tab PIPELINED;
      
    PROCEDURE insert_retrieved_grp_items(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd                GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE,
        p_item_no               GIPI_GROUPED_ITEMS.item_no%TYPE,
        p_eff_date              VARCHAR2,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_grouped_item_title    GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
        p_control_cd            GIPI_WGROUPED_ITEMS.control_cd%TYPE,
        p_control_type_cd       GIPI_WGROUPED_ITEMS.control_type_cd%TYPE
    );
    
    FUNCTION get_copy_benefits_listing(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN gipi_grouped_items_tab PIPELINED;
      
    PROCEDURE copy_benefits2(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_pack_ben_cd           GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE,
        p_col1                  GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_line_cd               GIPI_PARLIST.line_cd%TYPE
    );
    
    PROCEDURE insert_rec_grp_witem(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date              VARCHAR2,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_no_of_persons         VARCHAR2
    );
    
    PROCEDURE set_amount_covered(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_tsi_amt               GIPI_WGROUPED_ITEMS.tsi_amt%TYPE,
        p_prem_amt              GIPI_WGROUPED_ITEMS.prem_amt%TYPE,
        p_ann_tsi_amt           GIPI_WGROUPED_ITEMS.ann_tsi_amt%TYPE,
        p_ann_prem_amt          GIPI_WGROUPED_ITEMS.ann_prem_amt%TYPE
    );
    
    FUNCTION check_package(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    )
      RETURN VARCHAR2;
		
	procedure update_prem_amounts ( p_par_id IN gipi_waccident_item.par_id%TYPE);
	
	PROCEDURE INSERT_RECGRP_WITEM2
	 (p_par_id            IN   GIPI_WACCIDENT_ITEM.par_id%TYPE,
	  p_item_no           IN   GIPI_WACCIDENT_ITEM.item_no%TYPE,
	  p_line_cd           IN   GIPI_WGROUPED_ITEMS.line_cd%TYPE);
	
	--Deo [01.26.2017]: add start (SR-23702)   
	TYPE ca_grp_itm_type IS RECORD (
      par_id               gipi_parlist.par_id%TYPE,
      item_no              gipi_grouped_items.item_no%TYPE,
      grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      include_tag          gipi_grouped_items.include_tag%TYPE,
      grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      group_cd             gipi_grouped_items.group_cd%TYPE,
      amount_covered       gipi_grouped_items.amount_coverage%TYPE,
      remarks              gipi_grouped_items.remarks%TYPE,
      line_cd              gipi_grouped_items.line_cd%TYPE,
      subline_cd           gipi_grouped_items.subline_cd%TYPE
   );

   TYPE ca_grp_itm_type_tab IS TABLE OF ca_grp_itm_type;

   FUNCTION get_ca_grouped_items (
      p_par_id       gipi_wgrouped_items.par_id%TYPE,
      p_line_cd      gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     gipi_wpolbas.renew_no%TYPE,
      p_item_no      VARCHAR2,
      p_eff_date     VARCHAR2
   )
      RETURN ca_grp_itm_type_tab PIPELINED;
   --Deo [01.26.2017]: add ends (SR-23702)
END;
/


