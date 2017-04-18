CREATE OR REPLACE PACKAGE CPI.GIPI_GRP_ITEMS_BENEFICIARY_PKG
AS
	TYPE gipi_grp_items_ben_type IS RECORD (
		policy_id			gipi_grp_items_beneficiary.policy_id%TYPE,
		item_no				gipi_grp_items_beneficiary.item_no%TYPE,
		grouped_item_no		gipi_grp_items_beneficiary.grouped_item_no%TYPE,
		beneficiary_no		gipi_grp_items_beneficiary.beneficiary_no%TYPE,
		beneficiary_name	gipi_grp_items_beneficiary.beneficiary_name%TYPE,
		beneficiary_addr	gipi_grp_items_beneficiary.beneficiary_addr%TYPE,
		relation			gipi_grp_items_beneficiary.relation%TYPE,
		date_of_birth		gipi_grp_items_beneficiary.date_of_birth%TYPE,
		age					gipi_grp_items_beneficiary.age%TYPE,
		civil_status		gipi_grp_items_beneficiary.civil_status%TYPE,
        sex                    gipi_grp_items_beneficiary.sex%TYPE,
        user_id                gipi_grp_items_beneficiary.user_id%TYPE,
        last_update            gipi_grp_items_beneficiary.last_update%TYPE,
        arc_ext_data        gipi_grp_items_beneficiary.arc_ext_data%TYPE);
    TYPE gipi_grp_items_ben_tab IS TABLE OF gipi_grp_items_ben_type;
    FUNCTION get_gipi_grp_items_beneficiary (
        p_policy_id IN gipi_grp_items_beneficiary.policy_id%TYPE,
        p_item_no IN gipi_grp_items_beneficiary.item_no%TYPE)
    RETURN gipi_grp_items_ben_tab PIPELINED;
    
  TYPE grp_items_beneficiary_type IS RECORD (
  
    age                 gipi_grp_items_beneficiary.age%TYPE,
    sex                 gipi_grp_items_beneficiary.sex%TYPE,
    item_no             gipi_grp_items_beneficiary.item_no%TYPE,
    relation            gipi_grp_items_beneficiary.relation%TYPE,
    policy_id           gipi_grp_items_beneficiary.policy_id%TYPE,
    civil_status        gipi_grp_items_beneficiary.civil_status%TYPE,
    date_of_birth       gipi_grp_items_beneficiary.date_of_birth%TYPE,
    beneficiary_no      gipi_grp_items_beneficiary.beneficiary_no%TYPE,
    grouped_item_no     gipi_grp_items_beneficiary.grouped_item_no%TYPE,
    beneficiary_name    gipi_grp_items_beneficiary.beneficiary_name%TYPE,
    beneficiary_addr    gipi_grp_items_beneficiary.beneficiary_addr%TYPE

  );

    TYPE grp_items_beneficiary_tab IS TABLE OF grp_items_beneficiary_type;

    FUNCTION get_grp_items_beneficiaries(
       p_policy_id          gipi_grp_items_beneficiary.policy_id%TYPE,
       p_item_no            gipi_grp_items_beneficiary.item_no%TYPE,
       p_grouped_item_no    gipi_grp_items_beneficiary.grouped_item_no%TYPE
    )
       RETURN grp_items_beneficiary_tab PIPELINED;
  
END GIPI_GRP_ITEMS_BENEFICIARY_PKG;
/


