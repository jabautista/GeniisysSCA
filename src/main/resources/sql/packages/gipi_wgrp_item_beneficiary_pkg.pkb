CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WGRP_ITEM_BENEFICIARY_PKG 
AS

    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.26.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary)   
    **  Description     :Get PAR record listing for GIPI_WGRP_ITEMS_BENEFICIARY per item no      
    */    
  FUNCTION get_gipi_wgrp_item_benificiary(p_par_id    GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                                p_item_no   GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE)
    RETURN gipi_wgrp_items_ben_tab PIPELINED IS
    v_ben    gipi_wgrp_items_ben_type;    
  BEGIN
    FOR i IN (SELECT a.par_id,         a.item_no,                a.grouped_item_no,
                        a.beneficiary_no, a.beneficiary_name,        a.beneficiary_addr,
                     a.relation,       a.date_of_birth,            a.age,
                     a.civil_status,   a.sex
                  FROM GIPI_WGRP_ITEMS_BENEFICIARY a
               WHERE a.par_id = p_par_id
                    AND a.item_no = p_item_no
                 ORDER BY par_id,item_no,grouped_item_no,beneficiary_no)
    LOOP
      v_ben.par_id                      := i.par_id; 
      v_ben.item_no                 := i.item_no;
      v_ben.grouped_item_no         := i.grouped_item_no;
      v_ben.beneficiary_no            := i.beneficiary_no;
      v_ben.beneficiary_name        := i.beneficiary_name;
      v_ben.beneficiary_addr        := i.beneficiary_addr;
      v_ben.relation                := i.relation;
      v_ben.date_of_birth            := i.date_of_birth;
      v_ben.age                        := i.age;
      v_ben.civil_status            := i.civil_status;
      v_ben.sex                        := i.sex;
      
      PIPE ROW(v_ben);
    END LOOP;
    RETURN; 
  END;    
      
     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.27.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary)   
    **  Description     : Insert PAR record listing for GIPI_WGRP_ITEMS_BENEFICIARY per item no      
    */    
  PROCEDURE set_gipi_wgrp_item_benificiary(
              p_par_id                  GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                 p_item_no                   GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
            p_grouped_item_no          GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,                         
            p_beneficiary_no          GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,        
            p_beneficiary_name          GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_name%TYPE,        
            p_beneficiary_addr          GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_addr%TYPE,        
            p_relation                  GIPI_WGRP_ITEMS_BENEFICIARY.relation%TYPE,        
            p_date_of_birth              GIPI_WGRP_ITEMS_BENEFICIARY.date_of_birth%TYPE,        
            p_age                      GIPI_WGRP_ITEMS_BENEFICIARY.age%TYPE,        
            p_civil_status              GIPI_WGRP_ITEMS_BENEFICIARY.civil_status%TYPE,        
            p_sex                      GIPI_WGRP_ITEMS_BENEFICIARY.sex%TYPE
              )
            IS
  BEGIN
       MERGE INTO GIPI_WGRP_ITEMS_BENEFICIARY
        USING dual ON (par_id       = p_par_id
                    AND item_no   = p_item_no
                    AND grouped_item_no = p_grouped_item_no
                    AND beneficiary_no  = p_beneficiary_no)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                       item_no,                grouped_item_no,
                    beneficiary_no,            beneficiary_name,        beneficiary_addr,         
                    relation,                date_of_birth,            age,                     
                    civil_status,            sex    
                   )
            VALUES (p_par_id,                   p_item_no,                p_grouped_item_no,
                       p_beneficiary_no,        p_beneficiary_name,        p_beneficiary_addr,         
                    p_relation,                p_date_of_birth,        p_age,                     
                    p_civil_status,            p_sex                
                    )
        WHEN MATCHED THEN
            UPDATE SET 
                    beneficiary_name        = p_beneficiary_name,    
                    beneficiary_addr        = p_beneficiary_addr,    
                    relation                = p_relation,        
                    date_of_birth            = p_date_of_birth,    
                    age                        = p_age,     
                    civil_status            = p_civil_status,
                    sex                        = p_sex;
  END;    
  
       /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.27.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary)   
    **  Description     : delete PAR record listing for GIPI_WGRP_ITEMS_BENEFICIARY per item no      
    */    
  PROCEDURE del_gipi_wgrp_item_benificiary(p_par_id    GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                             p_item_no   GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE
                                           )
                IS
  BEGIN
    DELETE GIPI_WGRP_ITEMS_BENEFICIARY
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no;
  END;                
    
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.27.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary)   
    **  Description     : delete PAR record listing for GIPI_WGRP_ITEMS_BENEFICIARY per item no      
    */    
  PROCEDURE del_gipi_wgrp_item_ben2(p_par_id             GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                      p_item_no         GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
                                    p_grouped_item_no GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE
                                    )
                IS
  BEGIN
    DELETE GIPI_WGRP_ITEMS_BENEFICIARY
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND GROUPED_ITEM_NO = p_grouped_item_no;
  END;        
                                    
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 05.27.2010  
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Beneficiary)   
    **  Description     : delete PAR record listing for GIPI_WGRP_ITEMS_BENEFICIARY per item no      
    */                                                
  PROCEDURE del_gipi_wgrp_item_ben3(p_par_id          GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                      p_item_no         GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
                                    p_grouped_item_no GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
                                    p_beneficiary_no  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE
                                    )    
                IS
  BEGIN
    DELETE GIPI_WGRP_ITEMS_BENEFICIARY
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND GROUPED_ITEM_NO = p_grouped_item_no
       AND BENEFICIARY_NO = p_beneficiary_no;
  END;        
  
  /*
    **  Created by        : Angelo Pagaduan
    **  Date Created     : 11.25.2010  
    **  Reference By     : (GIPIS065 - Accident Endt Item Information)   
    **  Description     :Get PAR record listing for GIPI_WGRP_ITEMS_BENEFICIARY      
    */    
  FUNCTION get_gipi_wgrp_itm_benificiary2(p_par_id    GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE)
    RETURN gipi_wgrp_items_ben_tab PIPELINED IS
    v_ben    gipi_wgrp_items_ben_type;    
  BEGIN
    FOR i IN (SELECT a.par_id,         a.item_no,                a.grouped_item_no,
                        a.beneficiary_no, a.beneficiary_name,        a.beneficiary_addr,
                     a.relation,       a.date_of_birth,            a.age,
                     a.civil_status,   a.sex
                  FROM GIPI_WGRP_ITEMS_BENEFICIARY a
               WHERE a.par_id = p_par_id
                 ORDER BY par_id,item_no,grouped_item_no,beneficiary_no)
    LOOP
      v_ben.par_id                      := i.par_id; 
      v_ben.item_no                 := i.item_no;
      v_ben.grouped_item_no         := i.grouped_item_no;
      v_ben.beneficiary_no            := i.beneficiary_no;
      v_ben.beneficiary_name        := i.beneficiary_name;
      v_ben.beneficiary_addr        := i.beneficiary_addr;
      v_ben.relation                := i.relation;
      v_ben.date_of_birth            := i.date_of_birth;
      v_ben.age                        := i.age;
      v_ben.civil_status            := i.civil_status;
      v_ben.sex                        := i.sex;
      
      PIPE ROW(v_ben);
    END LOOP;
    RETURN; 
  END;    
  
  /*
  **Created by  : Angelo Pagaduan
  **Date Created   : 12.22.2010 
  **Reference By  : (GIPIS065 - Grouped Items - Retrieve Grp Items)
  **Description      : gets gipi_wgrpitem_beneficiary of retrieved items
  */                
  
  FUNCTION rgitm_gipi_wgrpitem_ben(p_par_id                 GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                             p_policy_id                 GIPI_GROUPED_ITEMS.policy_id%TYPE,
                                        p_item_no                 GIPI_GROUPED_ITEMS.item_no%TYPE,
                                        p_grouped_item_no         GIPI_GROUPED_ITEMS.grouped_item_no%TYPE
                                               )                                      
      RETURN gipi_wgrp_items_ben_tab PIPELINED IS
    v_ben    gipi_wgrp_items_ben_type;            
    
  BEGIN
  
  FOR gipi_wgrp_items_ben IN (SELECT p_par_id PAR_ID,ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO, BENEFICIARY_NAME, 
                                                                                                  BENEFICIARY_ADDR, RELATION, DATE_OF_BIRTH, AGE, CIVIL_STATUS, SEX
                                                                                     FROM gipi_grp_items_beneficiary
                                                                                    WHERE policy_id          = p_policy_id
                                                                                      AND item_no         = p_item_no
                                                                                     AND grouped_item_no = p_grouped_item_no        
                             ) LOOP
      v_ben.par_id := gipi_wgrp_items_ben.par_id; 
      v_ben.item_no := gipi_wgrp_items_ben.item_no;
      v_ben.grouped_item_no := gipi_wgrp_items_ben.grouped_item_no;
      v_ben.beneficiary_no := gipi_wgrp_items_ben.beneficiary_no;
      v_ben.beneficiary_name := gipi_wgrp_items_ben.beneficiary_name;
      v_ben.beneficiary_addr := gipi_wgrp_items_ben.beneficiary_addr;
      v_ben.relation := gipi_wgrp_items_ben.relation;
      v_ben.date_of_birth := gipi_wgrp_items_ben.date_of_birth;
      v_ben.age := gipi_wgrp_items_ben.age;
      v_ben.civil_status := gipi_wgrp_items_ben.civil_status;
      v_ben.sex := gipi_wgrp_items_ben.sex;
      PIPE ROW(v_ben);
      END LOOP;
      RETURN;    
    
  END;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    10.03.2011    mark jm            retrieve records on gipi_wgrp_items_beneficiary based on given parameters (tablegrid varsion)   
    **    10.04.2011    mark jm            modified by adding civil_status_desc
    */
    FUNCTION get_gipi_wgrp_item_ben_tg (
        p_par_id IN gipi_wgrp_items_beneficiary.par_id%TYPE,
        p_item_no IN gipi_wgrp_items_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_wgrp_items_beneficiary.grouped_item_no%TYPE,
        p_beneficiary_name IN gipi_wgrp_items_beneficiary.beneficiary_name%TYPE)
    RETURN gipi_wgrp_items_ben_tab PIPELINED
    IS
        v_ben    gipi_wgrp_items_ben_type;    
    BEGIN
        FOR i IN (
            SELECT a.par_id,             a.item_no,            a.grouped_item_no,
                   a.beneficiary_no,     a.beneficiary_name,    a.beneficiary_addr,
                   a.relation,               a.date_of_birth,    a.age,
                   a.civil_status,       a.sex
              FROM gipi_wgrp_items_beneficiary a
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.grouped_item_no = p_grouped_item_no
               AND UPPER(NVL(a.beneficiary_name, '***')) LIKE UPPER(NVL(p_beneficiary_name, '%%%'))
          ORDER BY par_id,item_no,grouped_item_no,beneficiary_no)
        LOOP
            v_ben.par_id            := i.par_id; 
            v_ben.item_no            := i.item_no;
            v_ben.grouped_item_no    := i.grouped_item_no;
            v_ben.beneficiary_no    := i.beneficiary_no;
            v_ben.beneficiary_name    := i.beneficiary_name;
            v_ben.beneficiary_addr    := i.beneficiary_addr;
            v_ben.relation            := i.relation;
            v_ben.date_of_birth        := i.date_of_birth;
            v_ben.age                := i.age;
            v_ben.civil_status        := i.civil_status;
            v_ben.sex                := i.sex;
            v_ben.civil_status_desc        := cg_ref_codes_pkg.get_rv_meaning1('CIVIL STATUS', i.civil_status); 

            PIPE ROW(v_ben);
        END LOOP;
        RETURN; 
    END get_gipi_wgrp_item_ben_tg;
    
    FUNCTION get_group_beneficiary_listing(
        p_par_id            GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
        p_item_no           GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
        p_beneficiary_no    GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
        p_beneficiary_name  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_name%TYPE,
        p_sex               GIPI_WGRP_ITEMS_BENEFICIARY.sex%TYPE,
        p_relation          GIPI_WGRP_ITEMS_BENEFICIARY.relation%TYPE,
        p_civil_status      GIPI_WGRP_ITEMS_BENEFICIARY.civil_status%TYPE,
        p_date_of_birth     VARCHAR2,
        p_age               GIPI_WGRP_ITEMS_BENEFICIARY.age%TYPE,
        p_beneficiary_addr  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_addr%TYPE
    )
      RETURN gipi_wgrp_items_ben_tab PIPELINED AS
        v_ben               gipi_wgrp_items_ben_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIPI_WGRP_ITEMS_BENEFICIARY
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no
                    AND beneficiary_no = NVL(p_beneficiary_no, beneficiary_no)
                    AND UPPER(beneficiary_name) LIKE UPPER(NVL(p_beneficiary_name, beneficiary_name))
                    AND UPPER(NVL(sex, '%')) LIKE UPPER(NVL(p_sex, DECODE(sex, NULL, '%', sex)))
                    AND UPPER(NVL(relation, '%')) LIKE UPPER(NVL(p_relation, DECODE(relation, NULL, '%', relation)))
                    AND UPPER(NVL(civil_status, '%')) LIKE UPPER(NVL(p_civil_status, DECODE(civil_status, NULL, '%', civil_status)))
                    AND TRUNC(NVL(date_of_birth, SYSDATE)) = TRUNC(NVL(TO_DATE(p_date_of_birth, 'mm-dd-yyyy'), DECODE(date_of_birth, NULL, SYSDATE, date_of_birth)))
                    AND NVL(age, 0) = NVL(p_age, DECODE(age, NULL, 0, age))
                    AND UPPER(NVL(beneficiary_addr, '%')) LIKE UPPER(NVL(p_beneficiary_addr, DECODE(beneficiary_addr, NULL, '%', beneficiary_addr))))
        LOOP
            v_ben.par_id := i.par_id;
            v_ben.item_no := i.item_no;
            v_ben.grouped_item_no := i.grouped_item_no;
            v_ben.beneficiary_no := i.beneficiary_no;
            v_ben.beneficiary_name := i.beneficiary_name;
            v_ben.beneficiary_addr := i.beneficiary_addr;
            v_ben.relation := i.relation;
            v_ben.date_of_birth := i.date_of_birth;
            v_ben.age := i.age;
            v_ben.civil_status := i.civil_status;
            v_ben.sex := i.sex;
            v_ben.civil_status_desc := cg_ref_codes_pkg.get_rv_meaning1('CIVIL STATUS', i.civil_status); 
            PIPE ROW(v_ben);
        END LOOP;
        RETURN;
    END;
    
    PROCEDURE validate_ben_no(
        p_par_id            IN  GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
        p_item_no           IN  GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   IN  GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
        p_ben_no            IN  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
        p_message           OUT VARCHAR2
    )
    IS
    BEGIN
        FOR i IN(SELECT 1
                   FROM GIPI_WGRP_ITEMS_BENEFICIARY
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no
                    AND beneficiary_no = p_ben_no)
        LOOP
            p_message := 'Beneficiary must be unique.';
            RETURN;
        END LOOP;
        p_message := 'SUCCESS';
    END;
    --added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)
    PROCEDURE validate_ben_no2(
        p_par_id            IN  GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
        p_item_no           IN  GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   IN  GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
        p_ben_no            IN  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
        p_message           OUT VARCHAR2
    )
    IS
    BEGIN
        FOR i IN(SELECT 1
                   FROM GIPI_WGRP_ITEMS_BENEFICIARY
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND beneficiary_no = p_ben_no)
        LOOP
            p_message := 'Beneficiary must be unique.';
            RETURN;
        END LOOP;
        p_message := 'SUCCESS';
    END;
    --END SR21720 
        
END;
/


