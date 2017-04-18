CREATE OR REPLACE PACKAGE CPI.GIXX_GROUPED_ITEMS_PKG AS

    TYPE pol_doc_ca_grouped_items_type IS RECORD(
      extract_id                GIXX_GROUPED_ITEMS.extract_id%TYPE,
      item_no                   GIXX_GROUPED_ITEMS.item_no%TYPE,
      grouped_item_no           GIXX_GROUPED_ITEMS.grouped_item_no%TYPE,
      grouped_item_title        GIXX_GROUPED_ITEMS.grouped_item_title%TYPE,
      amount_coverage           GIXX_GROUPED_ITEMS.amount_coverage%TYPE,
      position_cd               GIXX_GROUPED_ITEMS.position_cd%TYPE,
      position                  GIIS_POSITION.position%TYPE,
      remarks                   GIXX_GROUPED_ITEMS.remarks%TYPE
      );
      
    TYPE pol_doc_ca_grouped_items_tab IS TABLE OF pol_doc_ca_grouped_items_type;
    
    FUNCTION get_pol_doc_ca_grouped_items(p_extract_id IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                                          p_item_no    IN GIXX_GROUPED_ITEMS.item_no%TYPE) 
      RETURN pol_doc_ca_grouped_items_tab PIPELINED;

    TYPE pol_doc_ah_grouped_items_type IS RECORD(
      extract_id          GIXX_GROUPED_ITEMS.extract_id%TYPE,
      item_no             GIXX_GROUPED_ITEMS.item_no%TYPE,
      grouped_item_no     GIXX_GROUPED_ITEMS.grouped_item_no%TYPE,
      grouped_item_title  VARCHAR2(125), --GIXX_GROUPED_ITEMS.grouped_item_title%TYPE, -- marco - 02.25.2013 - modified type to handle concatination of grouped item title and position
      --grouped_item_title  GIXX_GROUPED_ITEMS.grouped_item_title%TYPE, --commented out by abie 08122011
      --grouped_item_title  VARCHAR2(2000), -- abie 008122011   --Commented out by MJ 03/11/2013 to use Marco's change.
      amount_coverage     GIXX_GROUPED_ITEMS.amount_coverage%TYPE,
      position_cd         GIXX_GROUPED_ITEMS.position_cd%TYPE,
      date_of_birth       GIXX_GROUPED_ITEMS.date_of_birth%TYPE,
      age                 GIXX_GROUPED_ITEMS.age%TYPE,
      sex                 GIXX_GROUPED_ITEMS.sex%TYPE,
      to_date             GIXX_GROUPED_ITEMS.to_date%TYPE,
      from_date           GIXX_GROUPED_ITEMS.from_date%TYPE
      );
      
    TYPE pol_doc_ah_grouped_items_tab IS TABLE OF pol_doc_ah_grouped_items_type;
    
    FUNCTION get_pol_doc_ah_grouped_items(p_extract_id IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                                          p_item_no    IN GIXX_GROUPED_ITEMS.item_no%TYPE) 
      RETURN pol_doc_ah_grouped_items_tab PIPELINED;
      
    FUNCTION get_pack_pol_doc_ca_grpd_itms(p_extract_id IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                                           p_item_no    IN GIXX_GROUPED_ITEMS.item_no%TYPE) 
      RETURN pol_doc_ca_grouped_items_tab PIPELINED;
    
    FUNCTION get_grp_amt_cover(p_extract_id   IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                               p_amt_coverage IN GIXX_GROUPED_ITEMS.amount_coverage%TYPE ) 
      RETURN NUMBER;
      
      
    -- added by Kris 02.28.2013 for GIPIS101  
    TYPE accident_grouped_item_type IS RECORD (
        extract_id          gixx_grouped_items.extract_id%TYPE,
        age                 gixx_grouped_items.age%TYPE,
        amount_coverage     gixx_grouped_items.amount_coverage%TYPE,
        sex                 gixx_grouped_items.sex%TYPE,
        salary              gixx_grouped_items.salary%TYPE,
        item_no             gixx_grouped_items.item_no%TYPE,
        remarks             gixx_grouped_items.remarks%TYPE,
        line_cd             gixx_grouped_items.line_cd%TYPE,
        to_date             gixx_grouped_items.to_date%TYPE,
        group_cd            gixx_grouped_items.group_cd%TYPE,
        from_date           gixx_grouped_items.from_date%TYPE,
        policy_id           gixx_grouped_items.policy_id%TYPE,
        payt_terms          gixx_grouped_items.payt_terms%TYPE,
        subline_cd          gixx_grouped_items.subline_cd%TYPE,
        control_cd          gixx_grouped_items.control_cd%TYPE,
        pack_ben_cd         gixx_grouped_items.pack_ben_cd%TYPE,
        position_cd         gixx_grouped_items.position_cd%TYPE,
        include_tag         gixx_grouped_items.include_tag%TYPE,
        delete_sw           gixx_grouped_items.delete_sw%TYPE,
        principal_cd        gixx_grouped_items.principal_cd%TYPE,
        civil_status        gixx_grouped_items.civil_status%TYPE,
        salary_grade        gixx_grouped_items.salary_grade%TYPE,
        date_of_birth       gixx_grouped_items.date_of_birth%TYPE,
        grouped_item_no     gixx_grouped_items.grouped_item_no%TYPE,
        control_type_cd     gixx_grouped_items.control_type_cd%TYPE,        
        grouped_item_title  gixx_grouped_items.grouped_item_title%TYPE,

        control_type_desc   giis_control_type.control_type_desc%TYPE,
        package_cd          giis_package_benefit.package_cd%TYPE,
        payt_terms_desc     giis_payterm.payt_terms_desc%TYPE,
        position            giis_position.position%TYPE,
        group_desc          giis_group.group_desc%TYPE,
        mean_civil_status   VARCHAR2(20),
        mean_sex            VARCHAR2(10)
    );
    
    TYPE accident_grouped_item_tab IS TABLE OF accident_grouped_item_type;
    
    FUNCTION get_accident_grouped_item(
        p_extract_id    gixx_grouped_items.extract_id%TYPE,
        p_item_no       gixx_grouped_items.item_no%TYPE
    ) RETURN accident_grouped_item_tab PIPELINED;
    
    TYPE casualty_grouped_item_type IS RECORD (
        extract_id              gixx_grouped_items.extract_id%TYPE,
        policy_id              gixx_grouped_items.policy_id%TYPE,
        item_no                 gixx_grouped_items.item_no%TYPE,
        grouped_item_no         gixx_grouped_items.grouped_item_no%TYPE,
        grouped_item_title      gixx_grouped_items.grouped_item_title%TYPE,
        sex                     gixx_grouped_items.sex%TYPE,
        date_of_birth           gixx_grouped_items.date_of_birth%TYPE,
        age                     gixx_grouped_items.age%TYPE,
        civil_status            gixx_grouped_items.civil_status%TYPE,
        amount_coverage         gixx_grouped_items.amount_coverage%TYPE,
        position_cd             gixx_grouped_items.position_cd%TYPE,
        salary                  gixx_grouped_items.salary%TYPE,
        salary_grade            gixx_grouped_items.salary_grade%TYPE,
        remarks                 gixx_grouped_items.remarks%TYPE,
        include_tag             gixx_grouped_items.include_tag%TYPE,
        
        mean_civil_status       VARCHAR2(20),
        mean_sex                VARCHAR2(10),
        dsp_amt                 NUMBER(20,2),
        position                giis_position.position%TYPE
    );
    
    TYPE casualty_grouped_item_tab IS TABLE OF casualty_grouped_item_type;
    
    FUNCTION get_casualty_grouped_item (
        p_extract_id    gixx_grouped_items.extract_id%TYPE,
        p_item_no       gixx_grouped_items.item_no%TYPE    
    ) RETURN casualty_grouped_item_tab PIPELINED;
    -- end: for GIPIS101
  
    

END GIXX_GROUPED_ITEMS_PKG;
/


