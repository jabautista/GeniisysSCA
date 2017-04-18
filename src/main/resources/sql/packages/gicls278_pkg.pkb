CREATE OR REPLACE PACKAGE BODY CPI.GICLS278_PKG
AS

    FUNCTION validate_entry(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
        p_renew_no      gicl_claims.renew_no%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN VARCHAR2
    IS
        v_result       VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN(SELECT 1
                   FROM gicl_claims a
                  WHERE line_cd = NVL(p_line_cd, line_cd)
                    AND subline_cd = NVL(p_subline_cd, subline_cd)
                    AND pol_iss_cd = NVL(p_pol_iss_cd, pol_iss_cd)
                    AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                    AND issue_yy = NVL(p_issue_yy, issue_yy)
                    AND renew_no = NVL(p_renew_no, renew_no)
                    AND check_user_per_iss_cd2(line_cd, pol_iss_cd, p_module_id, p_user_id) = 1
                    AND EXISTS(SELECT 1
                                 FROM gicl_clm_item
                                WHERE claim_id = a.claim_id
                                  AND NVL(grouped_item_no, 0) <> 0))
        LOOP
            v_result := 'Y';
            EXIT;
        END LOOP;
        RETURN v_result;
    END;

    FUNCTION get_gicls278_policy(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
        p_renew_no      gicl_claims.renew_no%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN gicls278_policy_tab PIPELINED
    IS
        v_row           gicls278_policy_type;
    BEGIN
        FOR i IN(SELECT DISTINCT line_cd, subline_cd, pol_iss_cd, iss_cd, issue_yy, pol_seq_no, renew_no, a.assd_no assd_no, b.assd_name 
                   FROM gicl_claims a,
                        giis_assured b 
                  WHERE line_cd = NVL(p_line_cd, line_cd)
                    AND subline_cd = NVL(p_subline_cd, subline_cd)
                    AND pol_iss_cd = NVL(p_pol_iss_cd, pol_iss_cd)
                    AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                    AND issue_yy = NVL(p_issue_yy, issue_yy)
                    AND renew_no = NVL(p_renew_no, renew_no)
                    AND a.assd_no = b.assd_no
                    AND check_user_per_iss_cd2(line_cd, pol_iss_cd, p_module_id, p_user_id) = 1
                    AND check_user_per_line2(line_cd, pol_iss_cd, p_module_id, p_user_id) = 1
                    AND EXISTS(SELECT 1
                                 FROM gicl_clm_item
                                WHERE claim_id = a.claim_id
                                  AND NVL(grouped_item_no, 0) <> 0))
        LOOP
            v_row.policy_no := i.line_cd || '-' || i.subline_cd || '-' || i.pol_iss_cd || '-' || LTRIM(TO_CHAR(i.issue_yy, '09')) || '-' || LTRIM(TO_CHAR(i.pol_seq_no, '0999999')) || '-' || LTRIM(TO_CHAR(i.renew_no, '09'));
            v_row.line_cd := i.line_cd;
            v_row.subline_cd := i.subline_cd;
            v_row.pol_iss_cd := i.pol_iss_cd;
            v_row.iss_cd := i.iss_cd;
            v_row.issue_yy := i.issue_yy;
            v_row.pol_seq_no := i.pol_seq_no;
            v_row.renew_no := i.renew_no;
            v_row.assd_no := i.assd_no;
            v_row.assd_name := i.assd_name;
            PIPE ROW(v_row);
        END LOOP;
    END;

    FUNCTION get_claims_with_enrollees(
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE,
        p_issue_yy      gicl_claims.issue_yy%TYPE,
        p_pol_seq_no    gicl_claims.pol_seq_no%TYPE,
        p_renew_no      gicl_claims.renew_no%TYPE,
        p_date_type     VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_module_id     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN claims_with_enrollees_tab PIPELINED
    IS
        v_row           claims_with_enrollees_type;
        v_count         NUMBER;
    BEGIN
        v_row.tot_loss_res := 0;
        v_row.tot_loss_pd := 0;
        v_row.tot_exp_res := 0;
        v_row.tot_exp_pd := 0;
    
        FOR i IN(SELECT SUM(NVL(loss_res_amt, 0)) tot_loss_res,
                        SUM(NVL(loss_pd_amt, 0)) tot_loss_pd,
                        SUM(NVL(exp_res_amt, 0)) tot_exp_res,
                        SUM(NVL(exp_pd_amt, 0)) tot_exp_pd
                   FROM gicl_claims
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND pol_iss_cd = p_pol_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND ((p_date_type = '1' AND (TRUNC(clm_file_date) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY'))
		                AND TRUNC(clm_file_date) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY'))
		                OR TRUNC(clm_file_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY'))))
                     OR (p_date_type = '2' AND (TRUNC(loss_date) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY'))
		                AND TRUNC(loss_date) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY'))
		                OR TRUNC(loss_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY')))))
                    AND check_user_per_iss_cd2(line_cd, iss_cd, p_module_id, p_user_id) = 1
                    AND claim_id IN (SELECT claim_id
                                       FROM gicl_clm_item
                                      WHERE NVL(grouped_item_no, 0) <> 0))
        LOOP
            v_row.tot_loss_res := i.tot_loss_res;
            v_row.tot_loss_pd := i.tot_loss_pd;
            v_row.tot_exp_res := i.tot_exp_res;
            v_row.tot_exp_pd := i.tot_exp_pd;
            EXIT;
        END LOOP;
    
        FOR i IN(SELECT *
                   FROM gicl_claims
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND pol_iss_cd = p_pol_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND ((p_date_type = '1' AND (TRUNC(clm_file_date) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY'))
		                AND TRUNC(clm_file_date) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY'))
		                OR TRUNC(clm_file_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY'))))
                     OR (p_date_type = '2' AND (TRUNC(loss_date) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY'))
		                AND TRUNC(loss_date) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY'))
		                OR TRUNC(loss_date) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY')))))
                    AND check_user_per_iss_cd2(line_cd, iss_cd, p_module_id, p_user_id) = 1
                    AND claim_id IN (SELECT claim_id
                                       FROM gicl_clm_item
                                      WHERE NVL(grouped_item_no, 0) <> 0))
        LOOP
            v_row.claim_id := i.claim_id;
            v_row.claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||LTRIM(TO_CHAR(i.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(i.clm_seq_no, '0000009'));
            v_row.line_cd := i.line_cd;
            v_row.subline_cd := i.subline_cd;
            v_row.iss_cd := i.iss_cd;
            v_row.clm_yy := i.clm_yy;
            v_row.clm_seq_no := i.clm_seq_no;
            v_row.loss_res_amt := NVL(i.loss_res_amt, 0);
            v_row.loss_pd_amt := NVL(i.loss_pd_amt, 0); 
            v_row.exp_res_amt := NVL(i.exp_res_amt, 0);
            v_row.exp_pd_amt := NVL(i.exp_pd_amt, 0);
            v_row.clm_stat_cd := i.clm_stat_cd;
            v_row.entry_date := TO_CHAR(i.entry_date, 'MM-DD-YYYY');
            v_row.loss_date := TO_CHAR(i.loss_date, 'MM-DD-YYYY');
            v_row.file_date := TO_CHAR(i.clm_file_date, 'MM-DD-YYYY');
            
            FOR c IN (SELECT clm_stat_desc
                          FROM GIIS_CLM_STAT
                        WHERE clm_stat_cd = i.clm_stat_cd)
            LOOP
                v_row.claim_status := c.clm_stat_desc;
            END LOOP;
            
            FOR x IN (SELECT item_no, grouped_item_no 
                        FROM GICL_CLM_ITEM
                       WHERE claim_id = i.claim_id)
            LOOP           
                v_row.enrollee := UPPER(get_gpa_item_title(i.claim_id, i.line_cd, x.item_no, x.grouped_item_no));
            END LOOP;
            
            BEGIN
                SELECT COUNT(*)
                  INTO v_count
                  FROM gicl_clm_recovery 
                 WHERE claim_id = i.claim_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_count := 0;
            END;
            
            IF v_count <> 0 THEN
                 v_row.clm_recovery := 'Y';
             ELSE
                v_row.clm_recovery := 'N';
             END IF;
            
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION validate_gicls278_line_cd(
        p_line_cd    gicl_claims.line_cd%TYPE
    )
      RETURN VARCHAR2
    IS
        v_check             VARCHAR2(1) := 'N';
    BEGIN
        FOR a IN(SELECT '1'
		           FROM GICL_CLAIMS
		          WHERE line_cd = p_line_cd)
		LOOP
			v_check := 'Y';
            EXIT;
		END LOOP;
        RETURN v_check;
    END;
    
    FUNCTION validate_gicls278_subline_cd(
        p_subline_cd    gicl_claims.subline_cd%TYPE
    )
      RETURN VARCHAR2
    IS
        v_check             VARCHAR2(1) := 'N';
    BEGIN
        FOR a IN(SELECT '1'
		           FROM GICL_CLAIMS
		          WHERE subline_cd = p_subline_cd)
		LOOP
			v_check := 'Y';
            EXIT;
		END LOOP;
        RETURN v_check;
    END;
    
    FUNCTION validate_gicls278_pol_iss_cd(
        p_pol_iss_cd    gicl_claims.pol_iss_cd%TYPE
    )
      RETURN VARCHAR2
    IS
        v_check             VARCHAR2(1) := 'N';
    BEGIN
        FOR a IN(SELECT '1'
		           FROM GICL_CLAIMS
		          WHERE pol_iss_cd = p_pol_iss_cd)
		LOOP
			v_check := 'Y';
            EXIT;
		END LOOP;
        RETURN v_check;
    END;
    
    FUNCTION validate_gicls278_issue_yy(
        p_issue_yy      gicl_claims.issue_yy%TYPE
    )
      RETURN VARCHAR2
    IS
        v_check             VARCHAR2(1) := 'N';
    BEGIN
        FOR a IN(SELECT '1'
		           FROM GICL_CLAIMS
		          WHERE issue_yy = p_issue_yy)
		LOOP
			v_check := 'Y';
            EXIT;
		END LOOP;
        RETURN v_check;
    END;
    
    FUNCTION get_line_lov(
       p_find_text      VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE,
       p_user_id        giis_users.user_id%TYPE
    )
      RETURN line_lov_tab PIPELINED
    IS
        v_row           line_lov_type;
    BEGIN
        FOR i IN(SELECT DISTINCT a.line_cd, b.line_name
                   FROM gicl_claims a,
                        giis_line b 
                  WHERE a.line_cd = b.line_cd
                    AND (UPPER(a.line_cd) LIKE UPPER(NVL(p_find_text, a.line_cd))
                        OR UPPER(b.line_name) LIKE UPPER(NVL(p_find_text, b.line_name)))
                    AND check_user_per_line2(a.line_cd, a.pol_iss_cd, p_module_id, p_user_id) = 1
                    AND a.claim_id IN (SELECT c.claim_id
                                         FROM gicl_clm_item c
                                        WHERE NVL(c.grouped_item_no, 0) <> 0))
        LOOP
            v_row.line_cd := i.line_cd;
            v_row.line_name := i.line_name;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_subline_lov(
       p_line_cd        giis_subline.line_cd%TYPE,
       p_find_text      VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE
    )
      RETURN subline_lov_tab PIPELINED
    IS
        v_row           subline_lov_type;
    BEGIN
        FOR i IN(SELECT DISTINCT a.subline_cd, b.subline_name
                   FROM gicl_claims a,
                        giis_subline b 
                  WHERE a.line_cd = b.line_cd
                    AND a.subline_cd = b.subline_cd
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND (UPPER(a.subline_cd) LIKE UPPER(NVL(p_find_text, a.subline_cd))
                        OR UPPER(b.subline_name) LIKE UPPER(NVL(p_find_text, b.subline_name)))
                  GROUP BY a.subline_cd, b.subline_name)
        LOOP
            v_row.subline_cd := i.subline_cd;
            v_row.subline_name := i.subline_name;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_issource_lov(
       p_line_cd        giis_subline.line_cd%TYPE,
       p_subline_cd     giis_subline.subline_cd%TYPE,
       p_find_text      VARCHAR2,
       p_module_id      giis_modules.module_id%TYPE,
       p_user_id        giis_users.user_id%TYPE
    )
      RETURN issource_lov_tab PIPELINED
    IS
        v_row           issource_lov_type;
    BEGIN
        FOR i IN(SELECT DISTINCT a.iss_cd, b.iss_name 
                   FROM gicl_claims a,
                        giis_issource b 
                  WHERE a.iss_cd = b.iss_cd 
                    AND a.subline_cd = NVL(p_subline_cd, a.subline_cd) 
                    AND a.line_cd = NVL(p_line_cd, a.line_cd)
                    AND (UPPER(a.iss_cd) LIKE UPPER(NVL(p_find_text, a.iss_cd))
                        OR UPPER(b.iss_name) LIKE UPPER(NVL(p_find_text, b.iss_name)))
                    AND check_user_per_iss_cd2(a.line_cd, b.iss_cd, p_module_id, p_user_id) = 1
                  GROUP BY a.iss_cd, b.iss_name)
        LOOP
            v_row.iss_cd := i.iss_cd;
            v_row.iss_name := i.iss_name;
            PIPE ROW(v_row);
        END LOOP;
    END;
    
    FUNCTION get_issue_yy_lov(
       p_line_cd        giis_subline.line_cd%TYPE,
       p_subline_cd     giis_subline.subline_cd%TYPE,
       p_find_text      VARCHAR2
    )
      RETURN issue_yy_lov_tab PIPELINED
    IS
        v_row           issue_yy_lov_type;
    BEGIN
        FOR i IN(SELECT DISTINCT issue_yy
                   FROM gicl_claims
                  WHERE line_cd = NVL(p_line_cd, line_cd)
                    AND subline_cd = NVL(p_subline_cd, subline_cd)
                    AND issue_yy LIKE NVL(p_find_text, issue_yy))
        LOOP
            v_row.issue_yy := i.issue_yy;
            PIPE ROW(v_row);
        END LOOP;
    END;

END GICLS278_PKG;
/


