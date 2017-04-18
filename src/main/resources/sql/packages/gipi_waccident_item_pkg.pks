CREATE OR REPLACE PACKAGE CPI.gipi_waccident_item_pkg
AS
   TYPE gipi_waccident_item_type IS RECORD (
      par_id                        gipi_witem.par_id%TYPE,
      item_no                       gipi_witem.item_no%TYPE,
      item_title                    gipi_witem.item_title%TYPE,
      item_grp                      gipi_witem.item_grp%TYPE,
      item_desc                     gipi_witem.item_desc%TYPE,
      item_desc2                    gipi_witem.item_desc2%TYPE,
      tsi_amt                       gipi_witem.tsi_amt%TYPE,
      prem_amt                      gipi_witem.prem_amt%TYPE,
      ann_prem_amt                  gipi_witem.ann_prem_amt%TYPE,
      ann_tsi_amt                   gipi_witem.ann_tsi_amt%TYPE,
      rec_flag                      gipi_witem.rec_flag%TYPE,
      currency_cd                   gipi_witem.currency_cd%TYPE,
      currency_rt                   gipi_witem.currency_rt%TYPE,
      group_cd                      gipi_witem.group_cd%TYPE,
      from_date                     gipi_witem.from_date%TYPE,
      TO_DATE                       gipi_witem.TO_DATE%TYPE,
      pack_line_cd                  gipi_witem.pack_line_cd%TYPE,
      pack_subline_cd               gipi_witem.pack_subline_cd%TYPE,
      discount_sw                   gipi_witem.discount_sw%TYPE,
      coverage_cd                   gipi_witem.coverage_cd%TYPE,
      other_info                    gipi_witem.other_info%TYPE,
      surcharge_sw                  gipi_witem.surcharge_sw%TYPE,
      region_cd                     gipi_witem.region_cd%TYPE,
      changed_tag                   gipi_witem.changed_tag%TYPE,
      prorate_flag                  gipi_witem.prorate_flag%TYPE,
      comp_sw                       gipi_witem.comp_sw%TYPE,
      short_rt_percent              gipi_witem.short_rt_percent%TYPE,
      pack_ben_cd                   gipi_witem.pack_ben_cd%TYPE,
      payt_terms                    gipi_witem.payt_terms%TYPE,
      risk_no                       gipi_witem.risk_no%TYPE,
      risk_item_no                  gipi_witem.risk_item_no%TYPE,
      date_of_birth                 gipi_waccident_item.date_of_birth%TYPE,
      age                           gipi_waccident_item.age%TYPE,
      civil_status                  gipi_waccident_item.civil_status%TYPE,
      position_cd                   gipi_waccident_item.position_cd%TYPE,
      monthly_salary                gipi_waccident_item.monthly_salary%TYPE,
      salary_grade                  gipi_waccident_item.salary_grade%TYPE,
      no_of_persons                 gipi_waccident_item.no_of_persons%TYPE,
      destination                   gipi_waccident_item.destination%TYPE,
      height                        gipi_waccident_item.height%TYPE,
      weight                        gipi_waccident_item.weight%TYPE,
      sex                           gipi_waccident_item.sex%TYPE,
      group_print_sw                gipi_waccident_item.group_print_sw%TYPE,
      ac_class_cd                   gipi_waccident_item.ac_class_cd%TYPE,
      level_cd                      gipi_waccident_item.level_cd%TYPE,
      parent_level_cd               gipi_waccident_item.parent_level_cd%TYPE,
      currency_desc                 giis_currency.currency_desc%TYPE,
      coverage_desc                 giis_coverage.coverage_desc%TYPE,
      item_witmperl_exist           VARCHAR2 (1),
      item_witmperl_grouped_exist   VARCHAR2 (1),
      item_wgrouped_items_exist     VARCHAR2 (1),
      itmperl_grouped_exists        VARCHAR2 (1),
       restricted_condition            VARCHAR2(1),
       restricted_condition2        VARCHAR2(1)
   );

   TYPE gipi_waccident_item_tab IS TABLE OF gipi_waccident_item_type;
   
   TYPE gipi_waccident_paritem_type IS RECORD (
       par_id                       GIPI_WACCIDENT_ITEM.par_id%TYPE,
       item_no                      GIPI_WACCIDENT_ITEM.item_no%TYPE,
       date_of_birth                GIPI_WACCIDENT_ITEM.date_of_birth%TYPE,
       age                          GIPI_WACCIDENT_ITEM.age%TYPE,
       civil_status                 GIPI_WACCIDENT_ITEM.civil_status%TYPE,
       position_cd                  GIPI_WACCIDENT_ITEM.position_cd%TYPE,
       monthly_salary               GIPI_WACCIDENT_ITEM.monthly_salary%TYPE,
       salary_grade                 GIPI_WACCIDENT_ITEM.salary_grade%TYPE,
       no_of_persons                GIPI_WACCIDENT_ITEM.no_of_persons%TYPE,
       destination                  GIPI_WACCIDENT_ITEM.destination%TYPE,
       height                       GIPI_WACCIDENT_ITEM.height%TYPE,
       weight                       GIPI_WACCIDENT_ITEM.weight%TYPE,
       sex                          GIPI_WACCIDENT_ITEM.sex%TYPE,
       group_print_sw               GIPI_WACCIDENT_ITEM.group_print_sw%TYPE,
       ac_class_cd                  GIPI_WACCIDENT_ITEM.ac_class_cd%TYPE,
       level_cd                     GIPI_WACCIDENT_ITEM.level_cd%TYPE,
       parent_level_cd              GIPI_WACCIDENT_ITEM.parent_level_cd%TYPE
   );
   
   TYPE gipi_waccident_paritem_tab IS TABLE OF gipi_waccident_paritem_type;

   FUNCTION get_gipi_waccident_items (
      p_par_id   gipi_waccident_item.par_id%TYPE
   )
      RETURN gipi_waccident_item_tab PIPELINED;

   PROCEDURE set_gipi_waccident_items (
      p_par_id            gipi_waccident_item.par_id%TYPE,
      p_item_no           gipi_waccident_item.item_no%TYPE,
      p_no_of_persons     gipi_waccident_item.no_of_persons%TYPE,
      p_position_cd       gipi_waccident_item.position_cd%TYPE,
      p_destination       gipi_waccident_item.destination%TYPE,
      p_monthly_salary    gipi_waccident_item.monthly_salary%TYPE,
      p_salary_grade      gipi_waccident_item.salary_grade%TYPE,
      p_date_of_birth     gipi_waccident_item.date_of_birth%TYPE,
      p_age               gipi_waccident_item.age%TYPE,
      p_civil_status      gipi_waccident_item.civil_status%TYPE,
      p_height            gipi_waccident_item.height%TYPE,
      p_weight            gipi_waccident_item.weight%TYPE,
      p_sex               gipi_waccident_item.sex%TYPE,
      p_group_print_sw    gipi_waccident_item.group_print_sw%TYPE,
      p_ac_class_cd       gipi_waccident_item.ac_class_cd%TYPE,
      p_level_cd          gipi_waccident_item.level_cd%TYPE,
      p_parent_level_cd   gipi_waccident_item.parent_level_cd%TYPE
   );

   PROCEDURE del_gipi_waccident_item (
      p_par_id    gipi_waccident_item.par_id%TYPE,
      p_item_no   gipi_waccident_item.item_no%TYPE
   );

   PROCEDURE del_gipi_waccident_item (
      p_par_id   IN   gipi_waccident_item.par_id%TYPE
   );

   PROCEDURE del_bill_gipis012 (
      p_par_id         gipi_waccident_item.par_id%TYPE,
      p_item_no        gipi_waccident_item.item_no%TYPE,
      p_prem_amt       gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE,
      p_tsi_amt        gipi_witem.tsi_amt%TYPE,
      p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE
   );

    FUNCTION get_witem_acci_endt_details (
          p_line_cd       gipi_wpolbas.line_cd%TYPE,
          p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
          p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
          p_item_no       gipi_witem.item_no%TYPE,
          p_expiry_date   gipi_wpolbas.expiry_date%TYPE,
          p_eff_date      gipi_wpolbas.eff_date%TYPE,
          p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
          p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
          p_renew_no      gipi_wpolbas.renew_no%TYPE,
          p_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE,
          p_ann_prem_amt gipi_witem.ann_prem_amt%TYPE) 
    RETURN gipi_waccident_item_tab PIPELINED;

    TYPE pre_insert_endt_accident_type IS RECORD (
        ann_prem_amt                  gipi_witem.ann_prem_amt%TYPE,
        ann_tsi_amt                   gipi_witem.ann_tsi_amt%TYPE,
        currency_cd                   gipi_witem.currency_cd%TYPE,
        currency_rt                   gipi_witem.currency_rt%TYPE,
        error_message                VARCHAR2(1));

    TYPE pre_insert_endt_accident_tab IS TABLE OF pre_insert_endt_accident_type;

    FUNCTION pre_insert_witem_endt_acc(p_line_cd             GIPI_WPOLBAS.line_cd%TYPE,
                                  p_iss_cd             GIPI_WPOLBAS.iss_cd%TYPE,
                                 p_subline_cd         GIPI_WPOLBAS.subline_cd%TYPE,
                                 p_issue_yy             GIPI_WPOLBAS.issue_yy%TYPE,
                                 p_pol_seq_no         GIPI_WPOLBAS.pol_seq_no%TYPE,
                                 p_item_no             GIPI_WITEM.item_no%TYPE,
                                 p_currency_cd         GIPI_WITEM.currency_cd%TYPE,
                                 p_eff_date          GIPI_WPOLBAS.eff_date%TYPE
                                 )
     RETURN gipi_waccident_item_tab PIPELINED;      
     
    PROCEDURE update_wpolbas_accident (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
    );   
   
    FUNCTION check_update_wpolbas_validity (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2) 
    RETURN VARCHAR2;

    PROCEDURE VALIDATE_CHECK_ADDTL_INFO_AH (
        p_par_id        IN  GIPI_PARLIST.par_id%TYPE,
        p_par_status    IN  GIPI_PARLIST.par_status%TYPE,
        p_msg_alert     OUT VARCHAR2);
        
        
    FUNCTION get_gipi_waccident_items1 (
        p_par_id  GIPI_WACCIDENT_ITEM.par_id%TYPE,
        p_item_no   GIPI_WACCIDENT_ITEM.item_no%TYPE
    ) RETURN gipi_waccident_paritem_tab PIPELINED; 
   
    FUNCTION get_gipi_waccident_pack_pol (
        p_par_id IN gipi_waccident_item.par_id%TYPE,
        p_item_no IN gipi_waccident_item.item_no%TYPE)
    RETURN gipi_waccident_paritem_tab PIPELINED; 
    
END;
/


