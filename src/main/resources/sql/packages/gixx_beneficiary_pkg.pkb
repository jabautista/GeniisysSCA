CREATE OR REPLACE PACKAGE BODY CPI.GIXX_BENEFICIARY_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 29, 2010
**  Reference By : 
**  Description  : Function to get beneficiary records which is used in policy document report. 
*/ 
    FUNCTION get_pol_doc_beneficiary(p_extract_id IN GIXX_BENEFICIARY.extract_id%TYPE,
                                      p_item_no    IN GIXX_BENEFICIARY.item_no%TYPE) 
      RETURN pol_doc_beneficiary_tab PIPELINED IS
     
     v_beneficiary  pol_doc_beneficiary_type;
     
   BEGIN
     FOR i IN (
        SELECT ALL ben.extract_id,       ben.item_no,
                   ben.beneficiary_no,   ben.beneficiary_name,
                   ben.beneficiary_addr, ben.relation
              FROM gixx_beneficiary ben
             WHERE ben.extract_id = p_extract_id
               AND ben.item_no    = p_item_no)
     LOOP
        v_beneficiary.extract_id       := i.extract_id;
        v_beneficiary.item_no          := i.item_no;
        v_beneficiary.beneficiary_no   := i.beneficiary_no;
        v_beneficiary.beneficiary_name := i.beneficiary_name;
        v_beneficiary.beneficiary_addr := i.beneficiary_addr;
        v_beneficiary.relation         := i.relation;
       PIPE ROW(v_beneficiary);
     END LOOP;
     RETURN;
   END get_pol_doc_beneficiary;   
   
   /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 1, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves beneficiaries of an item
    */
    FUNCTION get_beneficiaries (
        p_extract_id    gixx_beneficiary.extract_id%TYPE,
        p_item_no       gixx_beneficiary.item_no%TYPE
    ) RETURN beneficiary_tab PIPELINED
    IS
        v_beneficiary       beneficiary_type;
    BEGIN
        FOR rec IN (SELECT extract_id, policy_id, item_no,
                           beneficiary_name, beneficiary_addr, relation,
                           beneficiary_no, remarks, civil_status, date_of_birth, age,
                           adult_sw, sex, position_cd, delete_sw
                      FROM gixx_beneficiary
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)       
        LOOP
            FOR a IN (SELECT position
                        FROM giis_position
                       WHERE position_cd = rec.position_cd)
            LOOP
                v_beneficiary.position := a.position;
            END LOOP;
            
            FOR b IN (SELECT rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_low_value = rec.civil_status
                         AND rv_domain = '%CIVIL%')
            LOOP
                v_beneficiary.mean_civil_status := b.rv_meaning;
            END LOOP;
            
            BEGIN
        
                SELECT rv_meaning
                  INTO v_beneficiary.mean_sex
                  FROM cg_ref_codes
                 WHERE rv_low_value = rec.sex 
                   AND rv_domain LIKE '%SEX%';
          
            EXCEPTION
             WHEN NO_DATA_FOUND THEN              
                v_beneficiary.mean_sex := '';              
            END;
            
            v_beneficiary.extract_id := rec.extract_id;
            v_beneficiary.policy_id := rec.policy_id;
            v_beneficiary.item_no := rec.item_no;
            v_beneficiary.beneficiary_name := rec.beneficiary_name;
            v_beneficiary.beneficiary_addr := rec.beneficiary_addr;
            v_beneficiary.relation := rec.relation;
            v_beneficiary.beneficiary_no := rec.beneficiary_no;
            v_beneficiary.remarks := rec.remarks;
            v_beneficiary.civil_status := rec.civil_status;
            v_beneficiary.date_of_birth := rec.date_of_birth;
            v_beneficiary.age := rec.age;
            v_beneficiary.adult_sw := rec.adult_sw;
            v_beneficiary.sex := rec.sex;
            v_beneficiary.position_cd := rec.position_cd;
            v_beneficiary.delete_sw := rec.delete_sw;            
            
            PIPE ROW(v_beneficiary);
            
        END LOOP;
    
    END get_beneficiaries;
   
END GIXX_BENEFICIARY_PKG;
/


