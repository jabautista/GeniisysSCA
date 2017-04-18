CREATE OR REPLACE PACKAGE BODY CSV_CLM_PER_PLATENO_GICLR268
    /*
    **  Created by        : carlo
    **  Date Created      : 03.31.2016 SR5406
    */
AS
    FUNCTION csv_giclr268(
        p_plate_no          gicl_claims.plate_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_user_id           VARCHAR2 
    ) RETURN giclr268_tab PIPELINED AS
        res                    giclr268_type;
    BEGIN
        FOR i IN (SELECT a.plate_no, b.claim_id, b.item_no,c.first_name,c.last_name,c.middle_initial,
                         a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||SUBSTR(TO_CHAR(a.clm_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.clm_seq_no,'0000009'),2,7) claim_no,
                         a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||SUBSTR(TO_CHAR(a.issue_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.pol_seq_no,'0000009'),2,7)||'-'||SUBSTR(TO_CHAR(a.renew_no,'09'),2,2) policy_no,
                         a.assured_name, c.assd_name, TO_CHAR(b.item_no,'00009')||'-'||item_title item, a.loss_date, a.clm_file_date
                    FROM gicl_claims a, gicl_motor_car_dtl b, giis_assured c
                   WHERE b.claim_id = a.claim_id
                     AND b.plate_no = NVL(UPPER(p_plate_no), b.plate_no)
                     AND c.assd_no  = a.assd_no
                     AND check_user_per_line2(a.line_cd, a.iss_cd, 'GICLS268', p_user_id) = 1
                     AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                          AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                           OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                      OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                          AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                           OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy')))
                  UNION
                  SELECT e.plate_no, b.claim_id, b.item_no,c.first_name,c.last_name,c.middle_initial,
                         a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||SUBSTR(TO_CHAR(a.clm_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.clm_seq_no,'0000009'),2,7) claim_no,
                         a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||SUBSTR(TO_CHAR(a.issue_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.pol_seq_no,'0000009'),2,7)||'-'||SUBSTR(TO_CHAR(a.renew_no,'09'),2,2) policy_no,
                         a.assured_name, c.assd_name, TO_CHAR(b.item_no,'00009')||'-'||f.item_title item, a.loss_date, a.clm_file_date
                    FROM gicl_claims a, gicl_motor_car_dtl b, giis_assured c, gicl_mc_tp_dtl e, gicl_clm_item f
                   WHERE b.claim_id = a.claim_id
                     AND e.claim_id = a.claim_id 
                     AND f.claim_id = a.claim_id  
                     AND b.item_no  = f.item_no    
                     AND e.plate_no = NVL(UPPER(p_plate_no), e.plate_no)
                     AND c.assd_no  = a.assd_no  
                     AND check_user_per_line2(a.line_cd, a.iss_cd, 'GICLS268', p_user_id) = 1 
                     AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                          AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                           OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                      OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                          AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                           OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))))
        LOOP
            res.plate_no  := i.plate_no;
            res.claim_number  := i.claim_no;
            res.policy_number := i.policy_no;
            res.item      := i.item;
            
            IF i.first_name IS NULL
            THEN res.assured_name := i.assd_name;
            ELSE res.assured_name := (i.last_name || ', ' || i.first_name || ' ' || i.middle_initial);
            END IF;
            
            FOR j IN(SELECT DISTINCT NVL(SUM(loss_reserve),0) loss_reserve
                       FROM gicl_clm_reserve
                      WHERE claim_id = i.claim_id)
            LOOP
                res.loss_reserve :=    trim(to_char(j.loss_reserve,'999,999,999,990.00'));--modified amount format by carlo rubenecia 04.28.2016 SR 5406              
            END LOOP;
            
            FOR k IN(SELECT DISTINCT NVL(SUM(losses_paid),0) losses_paid
                       FROM gicl_clm_reserve
                      WHERE claim_id = i.claim_id)
            LOOP
                res.losses_paid := trim(to_char(k.losses_paid, '999,999,999,990.00')); --modified amount format by carlo rubenecia 04.28.2016 SR 5406 
            END LOOP;
            
            FOR l IN(SELECT DISTINCT NVL(SUM(expense_reserve),0) expense_reserve
                       FROM gicl_clm_reserve
                      WHERE claim_id = i.claim_id)
            LOOP
                res.expense_reserve    := trim(to_char(l.expense_reserve, '999,999,999,990.00')); --modified amount format by carlo rubenecia 04.28.2016 SR 5406 
            END LOOP;
            
            FOR m IN (SELECT NVL(SUM(expenses_paid),0) expenses_paid
                           FROM gicl_clm_reserve
                         WHERE claim_id = i.claim_id)
            LOOP
                res.expenses_paid := trim(to_char(m.expenses_paid, '999,999,999,990.00')); --modified amount format by carlo rubenecia 04.28.2016 SR 5406 
            END LOOP;
            
         
                        
            PIPE ROW(res);
        END LOOP;
    
    END;
    
END CSV_CLM_PER_PLATENO_GICLR268;
/
