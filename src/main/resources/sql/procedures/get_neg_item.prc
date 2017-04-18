DROP PROCEDURE CPI.GET_NEG_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GET_NEG_ITEM (
    p_par_id IN gipi_witem.par_id%TYPE,
    p_line_cd IN gipi_wpolbas.line_cd%TYPE,
    p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no IN gipi_wpolbas.renew_no%TYPE,
    p_item_no IN gipi_witem.item_no%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.03.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure get the latest info of item with consideration
    **                     : of backward endt. and insert it in table gipi_witem (Original Description)
    */
    v_eff_date           gipi_polbasic.eff_date%TYPE;
    v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
    v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;
    
    CURSOR A IS
        SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM gipi_polbasic a
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd
           AND iss_cd = p_iss_cd
           AND issue_yy = p_issue_yy
           AND pol_seq_no = p_pol_seq_no
           AND renew_no = p_renew_no         
           AND a.pol_flag IN ('1','2','3','X')
           AND EXISTS (SELECT '1'
                         FROM GIPI_ITEM b
                        WHERE b.item_no = p_item_no
                          AND b.policy_id = a.policy_id)      
      ORDER BY eff_date DESC;
      
    CURSOR B (p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
        SELECT a.currency_cd, a.currency_rt, a.item_title, a.item_desc,
               a.item_desc2, a.ann_tsi_amt, a.ann_prem_amt, a.coverage_cd,
               a.group_cd, b.region_cd, a.rec_flag
          FROM gipi_item a, gipi_polbasic b
         WHERE a.policy_id = b.policy_id
              AND a.policy_id =  p_policy_id
           AND a.item_no = p_item_no;

    CURSOR D IS
        SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM gipi_polbasic a
         WHERE a.line_cd = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.iss_cd = p_iss_cd
           AND a.issue_yy = p_issue_yy
           AND a.pol_seq_no = p_pol_seq_no
           AND a.renew_no = p_renew_no
           AND a.pol_flag IN( '1','2','3','X')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM gipi_item b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id)      
           AND a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                  FROM gipi_polbasic c
                                 WHERE c.line_cd = p_line_cd
                                   AND c.subline_cd = p_subline_cd
                                   AND c.iss_cd = p_iss_cd
                                   AND c.issue_yy = p_issue_yy
                                   AND c.pol_seq_no = p_pol_seq_no
                                   AND c.renew_no = p_renew_no
                                   AND pol_flag  IN( '1','2','3','X')
                                   AND NVL(c.back_stat,5) = 2
                                   AND EXISTS (SELECT '1'
                                                 FROM gipi_item d
                                                WHERE d.item_no = p_item_no
                                                  AND c.policy_id = d.policy_id))                        
      ORDER BY   eff_date DESC;
    
    v_new_item   VARCHAR2(1) := 'Y'; 
    v_expired_sw   VARCHAR2(1) := 'N';
BEGIN
    FOR Z IN (
        SELECT MAX(endt_seq_no) endt_seq_no
          FROM gipi_polbasic a
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd
           AND iss_cd = p_iss_cd
           AND issue_yy = p_issue_yy
           AND pol_seq_no = p_pol_seq_no
           AND renew_no = p_renew_no
           AND pol_flag  IN( '1','2','3','X')
           AND EXISTS (SELECT '1'
                         FROM gipi_item b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id))
    LOOP
        v_max_endt_seq_no := z.endt_seq_no;
        EXIT;
    END LOOP;
    
    FOR X IN (
        SELECT MAX(endt_seq_no) endt_seq_no
          FROM gipi_polbasic a
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd
           AND iss_cd = p_iss_cd
           AND issue_yy = p_issue_yy
           AND pol_seq_no = p_pol_seq_no
           AND renew_no = p_renew_no
           AND pol_flag  IN( '1','2','3','X')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM gipi_item b
                        WHERE b.item_no = p_item_no
                          AND a.policy_id = b.policy_id))
    LOOP
        v_max_endt_seq_no1 := X.endt_seq_no;
        EXIT;
    END LOOP;
    
    IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                                 
        FOR D1 IN D LOOP
            FOR B1 IN B(D1.policy_id) LOOP
                IF v_eff_date IS NULL THEN                    
                    INSERT INTO gipi_witem (
                        par_id,     item_no,         item_title,     item_desc,
                        item_desc2,    currency_cd,     currency_rt,     coverage_cd,
                        group_cd,    ann_tsi_amt,    ann_prem_amt,    region_cd,
                        rec_flag)
                    VALUES (
                        p_par_id,        p_item_no,        b1.item_title,    b1.item_desc,
                        b1.item_desc2,    b1.currency_cd,    b1.currency_rt,    b1.coverage_cd,
                        b1.group_cd,    0,                0,                b1.region_cd,
                           b1.rec_flag);
                        
                    GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id, p_item_no, p_line_cd);
                END IF;
                
                IF D1.eff_date > v_eff_date THEN
                    INSERT INTO gipi_witem (
                        par_id,     item_no,         item_title,     item_desc,
                        item_desc2,    currency_cd,     currency_rt,     coverage_cd,
                        group_cd,    ann_tsi_amt,    ann_prem_amt,    region_cd,
                        rec_flag)
                    VALUES (
                        p_par_id,        p_item_no,        b1.item_title,    b1.item_desc,
                        b1.item_desc2,    b1.currency_cd,    b1.currency_rt,    b1.coverage_cd,
                        b1.group_cd,    0,                0,                b1.region_cd,
                           b1.rec_flag);
                        
                    GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id,    p_item_no, p_line_cd);
                END IF;
            END LOOP;
            EXIT;
        END LOOP;
    ELSE
        FOR A1 IN A LOOP     
            FOR B1 IN B(A1.policy_id) LOOP
                IF v_eff_date  IS NULL THEN
                    v_eff_date  :=  A1.eff_date;
                    
                    INSERT INTO gipi_witem (
                        par_id,     item_no,         item_title,     item_desc,
                        item_desc2,    currency_cd,     currency_rt,     coverage_cd,
                        group_cd,    ann_tsi_amt,    ann_prem_amt,    region_cd,
                        rec_flag)
                    VALUES (
                        p_par_id,        p_item_no,        b1.item_title,    b1.item_desc,
                        b1.item_desc2,    b1.currency_cd,    b1.currency_rt,    b1.coverage_cd,
                        b1.group_cd,    0,                0,                b1.region_cd,
                           b1.rec_flag);
                        
                    GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id,    p_item_no, p_line_cd);
                END IF;
                IF A1.eff_date > v_eff_date THEN
                    v_eff_date  :=  A1.eff_date;
                    
                    INSERT INTO gipi_witem (
                        par_id,     item_no,         item_title,     item_desc,
                        item_desc2,    currency_cd,     currency_rt,     coverage_cd,
                        group_cd,    ann_tsi_amt,    ann_prem_amt,    region_cd,
                        rec_flag)
                    VALUES (
                        p_par_id,        p_item_no,        b1.item_title,    b1.item_desc,
                        b1.item_desc2,    b1.currency_cd,    b1.currency_rt,    b1.coverage_cd,
                        b1.group_cd,    0,                0,                b1.region_cd,
                           b1.rec_flag);
                        
                    GIPIS031_CREATE_ITEM_FOR_LINE(p_par_id,    p_item_no, p_line_cd);
                END IF;
            END LOOP;
            EXIT;
        END LOOP;
    END IF;
END GET_NEG_ITEM;
/


