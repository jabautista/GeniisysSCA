CREATE OR REPLACE PACKAGE BODY CPI.GIXX_GRP_ITEMS_BENEFICIARY_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 27, 2010
**  Reference By : 
**  Description  : Function to get accident grouped item beneficiary records which are used in policy document report. 
*/ 
   FUNCTION get_pol_doc_ah_grp_items_ben(p_extract_id      IN GIXX_GRP_ITEMS_BENEFICIARY.extract_id%TYPE,
                                         p_item_no         IN GIXX_GRP_ITEMS_BENEFICIARY.item_no%TYPE,
                                         p_grouped_item_no IN GIXX_GRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE) 
     RETURN pol_doc_ah_grp_items_ben_tab PIPELINED IS
     
     v_grp_beneficiary  pol_doc_ah_grp_items_ben_type;
     
   BEGIN
     FOR i IN (
        SELECT extract_id, item_no, grouped_item_no,
               beneficiary_no, beneficiary_name,
               beneficiary_addr, NVL(relation,REPLACE('X', 'X', ' ')) relation, --NVL added by jeffdojello 06102013
               date_of_birth, age, sex
          FROM gixx_grp_items_beneficiary
         WHERE extract_id      = p_extract_id
           AND item_no         = p_item_no
           AND grouped_item_no = p_grouped_item_no
      ORDER BY item_no, grouped_item_no, beneficiary_no)
     LOOP
        v_grp_beneficiary.extract_id         := i.extract_id;
        v_grp_beneficiary.item_no            := i.item_no;
        v_grp_beneficiary.grouped_item_no    := i.grouped_item_no;
        v_grp_beneficiary.beneficiary_addr   := i.beneficiary_addr;
        v_grp_beneficiary.beneficiary_name   := i.beneficiary_name;
        v_grp_beneficiary.beneficiary_no     := i.beneficiary_no;
        v_grp_beneficiary.date_of_birth      := i.date_of_birth;
        v_grp_beneficiary.age                := i.age;
        v_grp_beneficiary.sex                := i.sex;
        v_grp_beneficiary.relation           := i.relation;
       PIPE ROW(v_grp_beneficiary);
     END LOOP;
     RETURN;
   END get_pol_doc_ah_grp_items_ben;
   
   
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  February 28, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves grouped items beneficiaries of an accident item
    */
    FUNCTION get_grp_items_beneficiaries(
       p_extract_id          gixx_grp_items_beneficiary.extract_id%TYPE,
       p_item_no            gixx_grp_items_beneficiary.item_no%TYPE,
       p_grouped_item_no    gixx_grp_items_beneficiary.grouped_item_no%TYPE
    ) RETURN grp_items_beneficiary_tab PIPELINED
    IS
        v_items_beneficiary       grp_items_beneficiary_type;
    BEGIN
        FOR i IN (SELECT policy_id, item_no, grouped_item_no,beneficiary_no, beneficiary_name,
                        relation, sex, civil_status,date_of_birth, age, beneficiary_addr
                   FROM gixx_grp_items_beneficiary
                  WHERE extract_id = p_extract_id
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
   
END GIXX_GRP_ITEMS_BENEFICIARY_PKG;
/


