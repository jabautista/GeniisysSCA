DROP PROCEDURE CPI.GIPIS065_RETRIEVED_GRP_ITEMS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_RETRIEVED_GRP_ITEMS (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_item_no IN gipi_witem.item_no%TYPE,	
	p_message OUT VARCHAR2,
	p_gipi_grouped_items OUT endt_ref_cursor_pkg.rc_gipi_grouped_items,
	p_gipi_itmperil_grouped OUT endt_ref_cursor_pkg.rc_gipi_itmperil_grouped,
	p_gipi_grp_items_beneficiary OUT endt_ref_cursor_pkg.rc_gipi_grp_items_beneficiary)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.02.2011
	**  Reference By 	: (GIPIS065 - Endt Item Information - Accident)
	**  Description 	: Retrieve grouped items used in endorsement
	*/
	v_policy_id gipi_polbasic.policy_id%TYPE;
	v_from_date gipi_grouped_items.from_date%TYPE;
    v_to_date gipi_grouped_items.to_date%TYPE;
BEGIN
    FOR i IN (
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
               eff_date
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        FOR grouped IN (
            SELECT DISTINCT a.policy_id policy_id, a.endt_seq_no,b.from_date from_date, b.to_date to_date
              FROM gipi_polbasic a, gipi_grouped_items b
             WHERE a.line_cd = i.line_cd
               AND a.subline_cd = i.subline_cd
               AND a.iss_cd = i.iss_cd
               AND a.issue_yy = i.issue_yy
               AND a.pol_seq_no = i.pol_seq_no
               AND a.renew_no = i.renew_no 
               AND a.pol_flag IN ('1','2','3','X')            
               AND a.policy_id = b.policy_id
               AND b.item_no = p_item_no                     
               AND i.eff_date BETWEEN TRUNC(NVL(from_date, eff_date)) 
               AND NVL(TO_DATE, NVL(endt_expiry_date, expiry_date))
          ORDER BY endt_seq_no DESC)
        LOOP
            v_policy_id := grouped.policy_id;
            v_from_date := grouped.from_date;
            v_to_date   := grouped.to_date;
            EXIT;
        END LOOP;
        IF NVL(v_policy_id,0) <>  0 AND v_from_date IS NULL AND v_to_date IS NULL THEN
            BEGIN
                FOR items IN (
                    SELECT DISTINCT a.policy_id policy_id
                      FROM gipi_polbasic a, gipi_item b
                     WHERE a.policy_id = v_policy_id
                       AND a.pol_flag IN ('1','2','3','X')            
                       AND a.policy_id  = b.policy_id
                       AND i.eff_date BETWEEN TRUNC(NVL(from_date, eff_date)) 
                       AND NVL(to_date,NVL(endt_expiry_date,expiry_date)))
                LOOP
                    v_policy_id := items.policy_id;
                    EXIT;
                END LOOP;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    p_message := 'No Grouped Items to retrieve. '||
                        'Check Endt effectivity date on Item and Grouped Item level';    /* I, T */
                    RETURN;
            END;
        ELSIF NVL(v_policy_id,0) = 0 THEN
            p_message := 'No Grouped Items to retrieve. '||
                                    'grouped items do not exist in previous endorsements';        /* I, T */
            RETURN;
        END IF;
        OPEN p_gipi_grouped_items FOR
        SELECT *
          FROM gipi_grouped_items
         WHERE policy_id || '-' || grouped_item_no IN (
                    SELECT DISTINCT b.policy_id || '-' || b.grouped_item_no
                      FROM gipi_polbasic a,
                           gipi_grouped_items b
                     WHERE a.line_cd = i.line_cd
                       AND a.subline_cd = i.subline_cd
                       AND a.iss_cd = i.iss_cd
                       AND a.issue_yy = i.issue_yy
                       AND a.pol_seq_no = i.pol_seq_no
                       AND a.renew_no = i.renew_no
                       AND a.pol_flag IN ('1', '2', '3', 'X')
                       AND a.policy_id = b.policy_id
                       AND b.item_no = p_item_no
                       AND i.eff_date BETWEEN TRUNC(NVL(from_date, eff_date)) AND NVL(to_date, NVL(endt_expiry_date, expiry_date))
                       AND endt_seq_no = (
                                SELECT MAX(endt_seq_no)
                                  FROM gipi_polbasic x,
                                       gipi_grouped_items y
                                 WHERE x.line_cd = i.line_cd
                                   AND x.subline_cd = i.subline_cd
                                   AND x.iss_cd = i.iss_cd
                                   AND x.issue_yy = i.issue_yy
                                   AND x.pol_seq_no = i.pol_seq_no
                                   AND x.renew_no = x.renew_no
                                   AND x.pol_flag IN ('1', '2', '3', 'X')
                                   AND x.policy_id = y.policy_id
                                   AND y.grouped_item_no = b.grouped_item_no
                                   AND y.item_no = p_item_no
                                   AND i.eff_date BETWEEN TRUNC(NVL(from_date, eff_date)) AND NVL(to_date, NVL(endt_expiry_date, expiry_date))))
           AND item_no = p_item_no
           AND NOT EXISTS (
                        SELECT 1
                          FROM gipi_wgrouped_items z
                         WHERE z.par_id = p_par_id
                           AND item_no = gipi_grouped_items.item_no
                           AND grouped_item_no = gipi_grouped_items.grouped_item_no)
      ORDER BY grouped_item_no, grouped_item_title;
        
        OPEN p_gipi_itmperil_grouped FOR
        SELECT *
          FROM TABLE(gipi_itmperil_grouped_pkg.get_gipi_itmperil_grouped(v_policy_id, p_item_no));
           
        OPEN p_gipi_grp_items_beneficiary FOR
        SELECT *
          FROM TABLE(gipi_grp_items_beneficiary_pkg.get_gipi_grp_items_beneficiary(v_policy_id, p_item_no));
    END LOOP;
END GIPIS065_RETRIEVED_GRP_ITEMS;
/


