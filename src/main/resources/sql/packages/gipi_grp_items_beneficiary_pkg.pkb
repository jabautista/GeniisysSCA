CREATE OR REPLACE PACKAGE BODY CPI.GIPI_GRP_ITEMS_BENEFICIARY_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.06.2011
	**  Reference By 	: (GIPIS065 - Endt Item Information - Accident)
	**  Description 	: Returns records with the given policy_id and item_no
	*/
	FUNCTION get_gipi_grp_items_beneficiary (
		p_policy_id IN gipi_grp_items_beneficiary.policy_id%TYPE,
		p_item_no IN gipi_grp_items_beneficiary.item_no%TYPE)
	RETURN gipi_grp_items_ben_tab PIPELINED
	IS
		v_beneficiary gipi_grp_items_ben_type;
	BEGIN
		FOR i IN (
			SELECT a.policy_id,			a.item_no,			a.grouped_item_no,
				   a.beneficiary_no,	a.beneficiary_name,	a.beneficiary_addr,
				   a.relation,			a.date_of_birth,	a.age,
				   a.civil_status,		a.sex,				a.user_id,
				   a.last_update,		a.arc_ext_data
			  FROM GIPI_GRP_ITEMS_BENEFICIARY a
			 WHERE a.policy_id = p_policy_id
               AND a.item_no = p_item_no
          ORDER BY policy_id, item_no,grouped_item_no,beneficiary_no)
        LOOP
            v_beneficiary.policy_id          := i.policy_id;
            v_beneficiary.item_no             := i.item_no;
            v_beneficiary.grouped_item_no     := i.grouped_item_no;
            v_beneficiary.beneficiary_no    := i.beneficiary_no;
            v_beneficiary.beneficiary_name    := i.beneficiary_name;
            v_beneficiary.beneficiary_addr    := i.beneficiary_addr;
            v_beneficiary.relation            := i.relation;
            v_beneficiary.date_of_birth        := i.date_of_birth;
            v_beneficiary.age                := i.age;
            v_beneficiary.civil_status        := i.civil_status;
            v_beneficiary.sex                := i.sex;
            v_beneficiary.user_id            := i.user_id;
            v_beneficiary.last_update        := i.last_update;
            v_beneficiary.arc_ext_data        := i.arc_ext_data;
            PIPE ROW(v_beneficiary);
        END LOOP;
        RETURN;
    END get_gipi_grp_items_beneficiary;


	/*
	**  Created by		: Moses Calma
	**  Date Created 	: 06.27.2011
	**  Reference By 	: (GIPIS100 - Policy Information ItemAddtlInfo/Accident)
	**  Description 	: Returns records with the given policy_id ,item_no grouped_item_no
	*/
    FUNCTION get_grp_items_beneficiaries(
       p_policy_id          gipi_grp_items_beneficiary.policy_id%TYPE,
       p_item_no            gipi_grp_items_beneficiary.item_no%TYPE,
       p_grouped_item_no    gipi_grp_items_beneficiary.grouped_item_no%TYPE
    )
       RETURN grp_items_beneficiary_tab PIPELINED
    IS
        v_items_beneficiary       grp_items_beneficiary_type;

    BEGIN
       FOR i IN (SELECT policy_id, item_no, grouped_item_no,beneficiary_no, beneficiary_name,
                        relation, sex, civil_status,date_of_birth, age, beneficiary_addr
                   FROM gipi_grp_items_beneficiary
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no)
       LOOP

          v_items_beneficiary.policy_id              := i.policy_id;
          v_items_beneficiary.item_no                := i.item_no;
          v_items_beneficiary.grouped_item_no        := i.grouped_item_no;
          v_items_beneficiary.beneficiary_no         := i.beneficiary_no;
          v_items_beneficiary.beneficiary_name       := i.beneficiary_name;
          v_items_beneficiary.relation               := i.relation;
          v_items_beneficiary.sex                    := i.sex;
          v_items_beneficiary.civil_status           := i.civil_status;
          v_items_beneficiary.date_of_birth          := i.date_of_birth;
          v_items_beneficiary.age                    := i.age;
          v_items_beneficiary.beneficiary_addr       := i.beneficiary_addr;


          PIPE ROW (v_items_beneficiary);
       END LOOP;

    END get_grp_items_beneficiaries;

END GIPI_GRP_ITEMS_BENEFICIARY_PKG;
/


