CREATE OR REPLACE PACKAGE BODY CPI.GICLR268_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.05.2013
    **  Reference By      : GICLR268 - CLAIM LISTING PER PLATE NO.
    */
AS
    FUNCTION get_giclr268_details(
        p_plate_no          gicl_claims.plate_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_user_id           VARCHAR2 --Pol Cruz 5.31.2013 (changed check_user_per_line to check_user_per_line2)
    ) RETURN giclr268_tab PIPELINED AS
		res		            giclr268_type;
	BEGIN
        FOR i IN (SELECT a.plate_no, b.claim_id, b.item_no,
                         a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||SUBSTR(TO_CHAR(a.clm_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.clm_seq_no,'0000009'),2,7) claim_no,
                         a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||SUBSTR(TO_CHAR(a.issue_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.pol_seq_no,'0000009'),2,7)||'-'||SUBSTR(TO_CHAR(a.renew_no,'09'),2,2) policy_no,
                         a.assured_name, c.assd_name, TO_CHAR(b.item_no,'00009')||'-'||item_title item, a.loss_date, a.clm_file_date
                    FROM gicl_claims a, gicl_motor_car_dtl b, giis_assured c
                   WHERE b.claim_id = a.claim_id
                     AND b.plate_no = NVL(UPPER(p_plate_no), b.plate_no)
                     AND c.assd_no  = a.assd_no
                     AND check_user_per_line2(a.line_cd, a.iss_cd, 'GICLS268', p_user_id) = 1
--                     AND check_user_per_line(a.line_cd, a.iss_cd, 'GICLS268') = 1
                     AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                          AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                           OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                      OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                          AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                           OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy')))
                  UNION
                  SELECT e.plate_no, b.claim_id, b.item_no,
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
--                     AND check_user_per_line(a.line_cd, a.iss_cd, 'GICLS268') = 1
                     AND ((TRUNC(a.clm_file_date)    >= TO_DATE(p_from_date,'mm/dd/yyyy')
                          AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
                           OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
                      OR (TRUNC(a.loss_date)     >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
                          AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
                           OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy'))))
        LOOP
            res.plate_no  := i.plate_no;
            res.claim_id  := i.claim_id;
            res.item_no   := i.item_no;
            res.claim_no  := i.claim_no;
            res.policy_no := i.policy_no;
            res.assd_name := i.assd_name;
            res.item      := i.item;
            
            FOR j IN(SELECT DISTINCT NVL(SUM(loss_reserve),0) loss_reserve
                       FROM gicl_clm_reserve
                      WHERE claim_id = i.claim_id)
            LOOP
                res.loss_reserve :=	j.loss_reserve;                 
                res.sum_loss_reserve :=	NVL(res.sum_loss_reserve, 0) + NVL(j.loss_reserve, 0);
            END LOOP;
            
            FOR k IN(SELECT DISTINCT NVL(SUM(losses_paid),0) losses_paid
                       FROM gicl_clm_reserve
                      WHERE claim_id = i.claim_id)
            LOOP
                res.losses_paid := k.losses_paid;
                res.sum_losses_paid :=	NVL(res.sum_losses_paid, 0) + NVL(k.losses_paid, 0);
            END LOOP;
            
            FOR l IN(SELECT DISTINCT NVL(SUM(expense_reserve),0) expense_reserve
                       FROM gicl_clm_reserve
                      WHERE claim_id = i.claim_id)
            LOOP
                res.expense_reserve	:= l.expense_reserve;
                res.sum_expense_reserve :=	NVL(res.sum_expense_reserve, 0) + NVL(l.expense_reserve, 0);
            END LOOP;
            
            FOR m IN (SELECT NVL(SUM(expenses_paid),0) expenses_paid
	   					FROM gicl_clm_reserve
	  				   WHERE claim_id = i.claim_id)
            LOOP
                res.expenses_paid := m.expenses_paid;
                res.sum_expenses_paid :=	NVL(res.sum_expenses_paid, 0) + NVL(m.expenses_paid, 0);
            END LOOP;
            
            FOR n IN (SELECT param_value_v 
                        FROM giis_parameters
                       WHERE UPPER(param_name) = 'COMPANY_NAME')
            LOOP
                res.company_name := n.param_value_v;
            END LOOP;
     
            FOR o IN (SELECT param_value_v 
                        FROM giis_parameters
                       WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
            LOOP
                res.company_address := o.param_value_v;
            END LOOP;
            
            IF p_as_of_date IS NOT NULL THEN
  	            res.date_type := ('Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
            ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
                res.date_type := ('Claim File Date From '||TO_CHAR(TO_DATE(p_from_date,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
            ELSIF p_as_of_ldate IS NOT NULL THEN
                res.date_type := ('Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
            ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
                res.date_type := ('Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate,'mm/dd/yyyy'),'fmMonth DD, RRRR'));
            END IF;
                        
            PIPE ROW(res);
        END LOOP;
    
    END;
	
END GICLR268_PKG;
/


