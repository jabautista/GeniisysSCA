CREATE OR REPLACE PACKAGE BODY CPI.GIXX_GROUPED_ITEMS_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 23, 2010
**  Reference By : 
**  Description  : Function to get casualty grouped item records which are used in policy document report. 
*/ 
   FUNCTION get_pol_doc_ca_grouped_items(p_extract_id IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                                          p_item_no    IN GIXX_GROUPED_ITEMS.item_no%TYPE) 
     RETURN pol_doc_ca_grouped_items_tab PIPELINED IS
     
     v_grouped  pol_doc_ca_grouped_items_type;
     
   BEGIN
     FOR i IN (
        SELECT a.extract_id, a.item_no, a.grouped_item_no,
               a.grouped_item_title, NVL(a.amount_coverage, 0) amount_coverage,
               a.position_cd, a.remarks
          FROM gixx_grouped_items a
         WHERE a.extract_id = p_extract_id
           AND a.item_no    = p_item_no
      ORDER BY a.grouped_item_no)
     LOOP
        v_grouped.extract_id         := i.extract_id;
        v_grouped.item_no            := i.item_no;
        v_grouped.grouped_item_no    := i.grouped_item_no;
        v_grouped.grouped_item_title := i.grouped_item_title;
        v_grouped.amount_coverage    := i.amount_coverage;
        v_grouped.position_cd        := i.position_cd;
        v_grouped.remarks            := i.remarks;
       PIPE ROW(v_grouped);
     END LOOP;
     RETURN;
   END get_pol_doc_ca_grouped_items;


/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 27, 2010
**  Reference By : 
**  Description  : Function to get accident grouped item records which are used in policy document report. 
*/   
   FUNCTION get_pol_doc_ah_grouped_items(p_extract_id IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                                         p_item_no    IN GIXX_GROUPED_ITEMS.item_no%TYPE) 
     RETURN pol_doc_ah_grouped_items_tab PIPELINED IS
     
     v_grouped  pol_doc_ah_grouped_items_type;
     
   BEGIN
     FOR i IN (
          SELECT extract_id, item_no,
                 grouped_item_no, grouped_item_title,
                 NVL(amount_coverage, 0) amount_coverage, position_cd,
                 date_of_birth, age, sex,
                 to_date, from_date
            FROM gixx_grouped_items
           WHERE extract_id = p_extract_id
             AND item_no    = p_item_no
        ORDER BY grouped_item_no)
     LOOP
        v_grouped.extract_id         := i.extract_id;
        v_grouped.item_no            := i.item_no;
        v_grouped.grouped_item_no    := i.grouped_item_no;
        v_grouped.grouped_item_title := i.grouped_item_title;
        v_grouped.amount_coverage    := i.amount_coverage;
        v_grouped.position_cd        := i.position_cd;
        v_grouped.date_of_birth      := i.date_of_birth;
        v_grouped.age                := i.age;
        v_grouped.sex                := i.sex;
        v_grouped.to_date            := i.to_date;
        v_grouped.from_date          := i.from_date;
        
        FOR x IN (
            SELECT position
              FROM giis_position
             WHERE position_cd = i.position_cd)
        LOOP
            v_grouped.grouped_item_title := i.grouped_item_title || ' (' || x.position || ')';
        END LOOP;
        
        IF v_grouped.grouped_item_title IS NULL THEN
            v_grouped.grouped_item_title := i.grouped_item_title;
        END IF;
        
       PIPE ROW(v_grouped);
     END LOOP;
     RETURN;
   END get_pol_doc_ah_grouped_items;
   
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 07, 2011
**  Reference By :  Package Policy Documents
**  Description  : Function to get casualty grouped item records which are used in package policy document report. 
*/ 
   FUNCTION get_pack_pol_doc_ca_grpd_itms(p_extract_id IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                                          p_item_no    IN GIXX_GROUPED_ITEMS.item_no%TYPE) 
     RETURN pol_doc_ca_grouped_items_tab PIPELINED IS
     
     v_grouped      pol_doc_ca_grouped_items_type;
     
   BEGIN
     FOR i IN (
        SELECT a.extract_id, a.item_no, a.grouped_item_no,
               a.grouped_item_title, NVL(a.amount_coverage, 0) amount_coverage,
               a.position_cd, a.remarks, b.position
          FROM gixx_grouped_items a,
               giis_position b
         WHERE a.extract_id = p_extract_id
           AND a.item_no    = p_item_no
           AND a.position_cd = b.position_cd(+)
      ORDER BY a.grouped_item_no)
     LOOP
        
        v_grouped.extract_id         := i.extract_id;
        v_grouped.item_no            := i.item_no;
        v_grouped.grouped_item_no    := i.grouped_item_no;
        v_grouped.grouped_item_title := i.grouped_item_title;
        v_grouped.amount_coverage    := GIXX_GROUPED_ITEMS_PKG.get_grp_amt_cover(p_extract_id, i.amount_coverage);
        v_grouped.position_cd        := i.position_cd;
        v_grouped.position           := i.position;
        v_grouped.remarks            := i.remarks;
       PIPE ROW(v_grouped);
       
     END LOOP;
     RETURN;
   END get_pack_pol_doc_ca_grpd_itms;
   
   FUNCTION get_grp_amt_cover(p_extract_id   IN GIXX_GROUPED_ITEMS.extract_id%TYPE,
                              p_amt_coverage IN GIXX_GROUPED_ITEMS.amount_coverage%TYPE ) 
   RETURN NUMBER IS

    v_currency_rt          GIXX_ITEM.currency_rt%TYPE;
    v_policy_currency     GIXX_PACK_INVOICE.policy_currency%TYPE;
    v_amt_coverage        NUMBER;
    
    BEGIN
        FOR A IN (
                SELECT a.currency_rt, NVL(policy_currency,'N') policy_currency
                    FROM GIXX_ITEM a, GIXX_PACK_INVOICE b
                   WHERE a.extract_id = p_extract_id
                     AND a.extract_id = b.extract_id)
          LOOP
            v_currency_rt     := a.currency_rt;
            v_policy_currency := a.policy_currency;
            EXIT;
          END LOOP;
          
          IF nvl(v_policy_currency, 'N') = 'Y' THEN
            v_amt_coverage := p_amt_coverage;
          ELSE
            v_amt_coverage := p_amt_coverage * NVL(v_currency_rt,1);
          END IF;
      
      RETURN(v_amt_coverage);
    END;
    
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  February 28, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves grouped items of an accident item
    */
    FUNCTION get_accident_grouped_item(
        p_extract_id    gixx_grouped_items.extract_id%TYPE,
        p_item_no       gixx_grouped_items.item_no%TYPE
    ) RETURN accident_grouped_item_tab PIPELINED
    IS 
        v_accident_item      accident_grouped_item_type;
    BEGIN
        
        FOR rec IN (SELECT extract_id, item_no, policy_id,
                           age, amount_coverage, sex, salary, remarks,
                           line_cd, subline_cd, group_cd, grouped_item_no, grouped_item_title,
                           to_date, from_date, payt_terms,
                           control_cd, control_type_cd, pack_ben_cd, position_cd,
                           include_tag, delete_sw, principal_cd, 
                           civil_status, salary_grade,date_of_birth
                      FROM gixx_grouped_items
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no
                     ORDER BY item_no, grouped_item_no)
        LOOP
            FOR a IN (SELECT group_desc
                        FROM giis_group
                       WHERE group_cd = rec.group_cd)
            LOOP
                v_accident_item.group_desc := a.group_desc;
            END LOOP;
            
            IF rec.sex = 'F' THEN
                v_accident_item.mean_sex := 'Female';
            ELSIF rec.sex = 'M' THEN
                v_accident_item.mean_sex := 'Male';                
            END IF;
            
            IF rec.civil_status = 'D' THEN
                v_accident_item.mean_civil_status := 'Divorced';
            ELSIF rec.civil_status = 'L' THEN
                v_accident_item.mean_civil_status := 'Legally Separated';
            ELSIF rec.civil_status = 'M' THEN
                v_accident_item.mean_civil_status := 'Married';
            ELSIF rec.civil_status = 'S' THEN
                v_accident_item.mean_civil_status := 'Single';
            ELSIF rec.civil_status = 'W' THEN
                v_accident_item.mean_civil_status := 'Widow(er)';
            END IF;
            
            FOR b IN (SELECT position
                        FROM giis_position
                       WHERE position_cd = rec.position_cd)
            LOOP
                v_accident_item.position := b.position;
            END LOOP;
            
            BEGIN            
                SELECT payt_terms_desc
                  INTO v_accident_item.payt_terms_desc
                  FROM giis_payterm
                 WHERE payt_terms = rec.payt_terms;            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN            
                    v_accident_item.payt_terms_desc := '';                
            END;
            
            v_accident_item.extract_id := rec.extract_id;
            v_accident_item.item_no := rec.item_no;
            v_accident_item.age := rec.age;
            v_accident_item.sex := rec.sex;
            v_accident_item.amount_coverage := rec.amount_coverage;
            v_accident_item.salary := rec.salary;
            v_accident_item.remarks := rec.remarks;
            v_accident_item.line_cd := rec.line_cd;
            v_accident_item.subline_cd := rec.subline_cd;
            v_accident_item.group_cd := rec.group_cd;
            v_accident_item.grouped_item_no := rec.grouped_item_no;
            v_accident_item.grouped_item_title := rec.grouped_item_title;
            v_accident_item.to_date := rec.to_date;
            v_accident_item.from_date := rec.from_date;
            v_accident_item.payt_terms := rec.payt_terms;
            v_accident_item.control_cd := rec.control_cd;
            v_accident_item.control_type_cd := rec.control_type_cd;
            v_accident_item.pack_ben_cd := rec.pack_ben_cd;
            v_accident_item.position_cd := rec.position_cd;
            v_accident_item.include_tag := rec.include_tag;
            v_accident_item.delete_sw := NVL(rec.delete_sw, 'N');
            v_accident_item.principal_cd := rec.principal_cd;
            v_accident_item.civil_status := rec.civil_status;
            v_accident_item.salary_grade := rec.salary_grade;
            v_accident_item.date_of_birth := TRUNC(rec.date_of_birth);
            
            PIPE ROW(v_accident_item);
        END LOOP;
    
    END get_accident_grouped_item;
    
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 5, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves grouped items of a casualty item
    */
    FUNCTION get_casualty_grouped_item (
        p_extract_id    gixx_grouped_items.extract_id%TYPE,
        p_item_no       gixx_grouped_items.item_no%TYPE    
    ) RETURN casualty_grouped_item_tab PIPELINED
    IS
        v_casualty_item     casualty_grouped_item_type;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, policy_id,
                           grouped_item_no, grouped_item_title,
                           sex, date_of_birth, age, civil_status,
                           amount_coverage, include_tag,
                           position_cd, salary, salary_grade, remarks
                      FROM gixx_grouped_items
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            FOR a IN (SELECT sum(amount_coverage) amt
                        FROM gixx_grouped_items
                       WHERE extract_id = rec.extract_id
                         AND item_no = rec.item_no)
            LOOP
                v_casualty_item.dsp_amt := a.amt;
            END LOOP;
            
            BEGIN
                SELECT rv_meaning
                  INTO v_casualty_item.mean_sex
                  FROM cg_ref_codes
                 WHERE rv_domain LIKE '%SEX%'  
                   AND rv_low_value = rec.sex;          
            EXCEPTION
                WHEN no_data_found THEN
                    v_casualty_item.mean_sex := '';            
            END;
            
            BEGIN
                SELECT rv_meaning
                  INTO v_casualty_item.mean_civil_status
                  FROM cg_ref_codes
                 WHERE rv_low_value = rec.civil_status 
                   AND rv_domain LIKE '%CIVIL%';            
            EXCEPTION
                WHEN no_data_found THEN
                    v_casualty_item.mean_civil_status := '';            
            END;
            
            BEGIN
                SELECT position
                  INTO v_casualty_item.position
                  FROM giis_position
                 WHERE position_cd = rec.position_cd;
            EXCEPTION
                WHEN no_data_found THEN
                    v_casualty_item.position := '';
            END;
            
            v_casualty_item.extract_id := rec.extract_id;
            v_casualty_item.policy_id := rec.policy_id;
            v_casualty_item.item_no := rec.item_no;
            v_casualty_item.grouped_item_no := rec.grouped_item_no;
            v_casualty_item.grouped_item_title := rec.grouped_item_title;
            v_casualty_item.sex := rec.sex;
            v_casualty_item.date_of_birth := TRUNC(rec.date_of_birth);
            v_casualty_item.age := rec.age;
            v_casualty_item.civil_status := rec.civil_status;
            v_casualty_item.amount_coverage := rec.amount_coverage;
            v_casualty_item.include_tag := rec.include_tag;
            v_casualty_item.position_cd := rec.position_cd;
            v_casualty_item.salary := rec.salary;
            v_casualty_item.salary_grade := rec.salary_grade;
            v_casualty_item.remarks := rec.remarks;
        
            PIPE ROW(v_casualty_item);
        END LOOP;
    
    END get_casualty_grouped_item;
   
END GIXX_GROUPED_ITEMS_PKG;
/


