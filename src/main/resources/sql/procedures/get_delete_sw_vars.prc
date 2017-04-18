DROP PROCEDURE CPI.GET_DELETE_SW_VARS;

CREATE OR REPLACE PROCEDURE CPI.GET_DELETE_SW_VARS(
    p_par_id            IN  GIPI_WGROUPED_ITEMS.par_id%TYPE,
    p_item_no           IN  GIPI_WGROUPED_ITEMS.item_no%TYPE,
    p_grouped_item_no   IN  GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
    p_from_date         IN  VARCHAR2,
    p_exist             OUT VARCHAR,
    p_message           OUT VARCHAR2
)
AS
    v_line_cd           GIPI_WPOLBAS.line_cd%TYPE;
    v_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE;
    v_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE;
    v_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE;
    v_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE;
    v_renew_no          GIPI_WPOLBAS.renew_no%TYPE;
    v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
    v_from_date         GIPI_WITEM.from_date%TYPE;
    v_parlist_line_cd   GIPI_PARLIST.line_cd%TYPE;
    v_parlist_iss_cd    GIPI_PARLIST.iss_cd%TYPE;
    v_exist             VARCHAR2(1) := 'N';
    v_exist2            VARCHAR2(1) := 'N';
BEGIN
    p_exist := 'N';

    BEGIN
        SELECT a.line_cd, a.iss_cd, a.subline_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.eff_date,
               b.line_cd, b.iss_cd
          INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date,
               v_parlist_line_cd, v_parlist_iss_cd
          FROM GIPI_WPOLBAS a,
               GIPI_PARLIST b
         WHERE a.par_id = b.par_id
           AND a.par_id = p_par_id;
    END;
    
    FOR a IN (SELECT c.ann_tsi_amt, c.ann_prem_amt, a.policy_id, b.item_no, c.grouped_item_no   --Gzelle 06112015 SR3810
                FROM GIPI_POLBASIC a,
                     GIPI_ITEM b,
                     GIPI_GROUPED_ITEMS c
               WHERE a.line_cd = v_line_cd
                 AND a.iss_cd = v_iss_cd
                 AND a.subline_cd = v_subline_cd
                 AND a.issue_yy = v_issue_yy
                 AND a.pol_seq_no = v_pol_seq_no
                 AND a.renew_no = v_renew_no
                 AND a.pol_flag IN( '1','2','3','X')
                 AND TRUNC(NVL(NVL(c.from_date, b.from_date), a.eff_date)) <= TRUNC(NVL(NVL(TO_DATE(p_from_date, 'MM-DD-YYYY'), v_from_date), v_eff_date))
                 AND NVL(NVL(c.to_date, b.to_date), NVL(a.endt_expiry_date, a.expiry_date)) >= NVL(NVL(TO_DATE(p_from_date, 'MM-DD-YYYY'), v_from_date), v_eff_date)
                 AND a.policy_id = b.policy_id
                 AND b.policy_id = c.policy_id
                 AND b.item_no = c.item_no
                 AND b.item_no = p_item_no 						
                 AND c.grouped_item_no = p_grouped_item_no
		      ORDER BY a.eff_date desc)
    LOOP
        IF a.ann_tsi_amt = 0 AND a.ann_prem_amt = 0 THEN
        --check enrollee coverage  start Gzelle 06112015 SR3810 
            FOR x IN (SELECT *
                        FROM gipi_itmperil_grouped
                       WHERE policy_id = a.policy_id
                         AND item_no = a.item_no
                         AND grouped_item_no = a.grouped_item_no)
            LOOP
                p_message := 'ZERO';
                RETURN;                
            END LOOP;
        --end
        END IF;
    END LOOP;
    
    FOR pol IN (SELECT policy_id
                  FROM GIPI_POLBASIC
                 WHERE line_cd = v_parlist_line_cd
	               AND iss_cd = v_parlist_iss_cd
                   AND subline_cd = v_subline_cd
                   AND issue_yy = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no  
                   AND renew_no = v_renew_no
                   AND pol_flag IN ('1','2','3','X')
                 ORDER BY eff_date)
    LOOP
        FOR a IN (SELECT grouped_item_no, principal_cd											
                    FROM GIPI_GROUPED_ITEMS
                   WHERE principal_cd = p_grouped_item_no 
                     AND item_no = p_item_no 
                     AND policy_id = pol.policy_id )
        LOOP
            v_exist := 'Y'; 
            p_message := 'PRINCIPAL';    
            RETURN;	 
        END LOOP;
    END LOOP;
    
    IF v_exist = 'N' THEN
        FOR a IN (SELECT grouped_item_no, principal_cd											
                    FROM GIPI_WGROUPED_ITEMS
                   WHERE principal_cd = p_grouped_item_no 
                     AND item_no = p_item_no 
                     AND par_id = p_par_id)
        LOOP 
            p_exist := 'Y'; 
            p_message := 'PRINCIPAL';
            RETURN;
        END LOOP;
    END IF;	
END;
/


