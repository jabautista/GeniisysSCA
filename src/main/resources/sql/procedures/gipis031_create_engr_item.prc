DROP PROCEDURE CPI.GIPIS031_CREATE_ENGR_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_CREATE_ENGR_ITEM (
	p_par_id IN gipi_witem.par_id%TYPE,
	p_item_no IN gipi_witem.item_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for inserting records to GIPI_WENGG_BASIC table
	*/
	-- modified by robert to add checking if records are already inserted in GIPI_WENGG_BASIC table
	v_eff_date           gipi_polbasic.eff_date%TYPE;
	v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
	v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;
	
	CURSOR A IS
		SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND a.pol_flag                IN ('1','2','3')
           AND EXISTS (SELECT '1'
                         FROM gipi_engg_basic b
                        WHERE b.policy_id = a.policy_id)      
      ORDER BY eff_date DESC;
      
    CURSOR B (p_policy_id  gipi_item.policy_id%TYPE) IS
        SELECT *
          FROM gipi_engg_basic
         WHERE policy_id   =  p_policy_id;
           
    CURSOR D IS
        SELECT a.policy_id policy_id, a.eff_date eff_date
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND a.pol_flag    IN( '1','2','3')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM gipi_engg_basic b
                        WHERE a.policy_id = b.policy_id)      
           AND a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                  FROM gipi_polbasic c
                                 WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
                                       (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                                          FROM gipi_wpolbas
                                         WHERE par_id = p_par_id)
                                   AND pol_flag  IN( '1','2','3')
                                   AND NVL(c.back_stat,5) = 2
                                   AND EXISTS (SELECT '1'
                                                 FROM gipi_engg_basic d
                                                WHERE c.policy_id = d.policy_id))                        
      ORDER BY   eff_date DESC;

    v_new_item   VARCHAR2(1) := 'Y'; 
    v_expired_sw   VARCHAR2(1) := 'N';
BEGIN
    FOR Z IN (
        SELECT MAX(endt_seq_no) endt_seq_no
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND pol_flag  IN( '1','2','3')
           AND EXISTS (SELECT '1'
                         FROM gipi_engg_basic b
                        WHERE a.policy_id = b.policy_id))
    LOOP
        v_max_endt_seq_no := z.endt_seq_no;
        EXIT;
    END LOOP;
    
    FOR X IN (
        SELECT MAX(endt_seq_no) endt_seq_no
          FROM gipi_polbasic a
         WHERE (line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no) =
               (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_wpolbas
                 WHERE par_id = p_par_id)
           AND pol_flag  IN( '1','2','3')
           AND NVL(a.back_stat,5) = 2
           AND EXISTS (SELECT '1'
                         FROM gipi_engg_basic b
                        WHERE a.policy_id = b.policy_id))
    LOOP
        v_max_endt_seq_no1 := X.endt_seq_no;
        EXIT;
    END LOOP;
    
    IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                                 
        FOR D1 IN D LOOP
            FOR B1 IN B(D1.policy_id) LOOP
                IF v_eff_date  IS NULL THEN
                    MERGE INTO gipi_wengg_basic
                      USING DUAL
                      ON (par_id = p_par_id AND engg_basic_infonum = b1.engg_basic_infonum)
                      WHEN NOT MATCHED THEN
                    INSERT(
                    --INSERT INTO gipi_wengg_basic (
                        par_id,                    engg_basic_infonum,        contract_proj_buss_title,    site_location,
                        construct_start_date,    construct_end_date,        maintain_start_date,        maintain_end_date,
                        testing_start_date,        testing_end_date,        weeks_test,                    time_excess,
                        mbi_policy_no)
                    VALUES(
                        p_par_id,                    b1.engg_basic_infonum,        b1.contract_proj_buss_title,    b1.site_location,
                        b1.construct_start_date,    b1.construct_end_date,        b1.maintain_start_date,                b1.maintain_end_date,
                        b1.testing_start_date,        b1.testing_end_date,        b1.weeks_test,                                b1.time_excess,
                        b1.mbi_policy_no);
                END IF;
                IF D1.eff_date > v_eff_date THEN
                    MERGE INTO gipi_wengg_basic
                      USING DUAL
                      ON (par_id = p_par_id AND engg_basic_infonum = b1.engg_basic_infonum)
                      WHEN NOT MATCHED THEN
                    INSERT(
                    --INSERT INTO gipi_wengg_basic (
                        par_id,                    engg_basic_infonum,        contract_proj_buss_title,    site_location,
                        construct_start_date,    construct_end_date,        maintain_start_date,        maintain_end_date,
                        testing_start_date,        testing_end_date,        weeks_test,                    time_excess,
                        mbi_policy_no)
                    VALUES(
                        p_par_id,                    b1.engg_basic_infonum,        b1.contract_proj_buss_title,    b1.site_location,
                        b1.construct_start_date,    b1.construct_end_date,        b1.maintain_start_date,                b1.maintain_end_date,
                        b1.testing_start_date,        b1.testing_end_date,        b1.weeks_test,                                b1.time_excess,
                        b1.mbi_policy_no);
                END IF;
            END LOOP;
            EXIT;
        END LOOP;
    ELSE
        FOR A1 IN A LOOP     
            FOR B1 IN B(A1.policy_id) LOOP
                IF v_eff_date  IS NULL THEN
                    v_eff_date  :=  A1.eff_date;
                    MERGE INTO gipi_wengg_basic
                      USING DUAL
                      ON (par_id = p_par_id AND engg_basic_infonum = b1.engg_basic_infonum)
                      WHEN NOT MATCHED THEN
                    INSERT(
                    --INSERT INTO gipi_wengg_basic (
                        par_id,                    engg_basic_infonum,        contract_proj_buss_title,    site_location,
                        construct_start_date,    construct_end_date,        maintain_start_date,        maintain_end_date,
                        testing_start_date,        testing_end_date,        weeks_test,                    time_excess,
                        mbi_policy_no)
                    VALUES(
                        p_par_id,                    b1.engg_basic_infonum,        b1.contract_proj_buss_title,    b1.site_location,
                        b1.construct_start_date,    b1.construct_end_date,        b1.maintain_start_date,                b1.maintain_end_date,
                        b1.testing_start_date,        b1.testing_end_date,        b1.weeks_test,                                b1.time_excess,
                        b1.mbi_policy_no);
                END IF;
                IF A1.eff_date > v_eff_date THEN
                    v_eff_date  :=  A1.eff_date;
                    MERGE INTO gipi_wengg_basic
                      USING DUAL
                      ON (par_id = p_par_id AND engg_basic_infonum = b1.engg_basic_infonum)
                      WHEN NOT MATCHED THEN
                    INSERT(
                    --INSERT INTO gipi_wengg_basic (
                        par_id,                    engg_basic_infonum,        contract_proj_buss_title,    site_location,
                        construct_start_date,    construct_end_date,        maintain_start_date,        maintain_end_date,
                        testing_start_date,        testing_end_date,        weeks_test,                    time_excess,
                        mbi_policy_no)
                    VALUES(
                        p_par_id,                    b1.engg_basic_infonum,        b1.contract_proj_buss_title,    b1.site_location,
                        b1.construct_start_date,    b1.construct_end_date,        b1.maintain_start_date,                b1.maintain_end_date,
                        b1.testing_start_date,        b1.testing_end_date,        b1.weeks_test,                                b1.time_excess,
                        b1.mbi_policy_no);
                END IF;
            END LOOP;     
            EXIT;
        END LOOP;  
    END IF;
END GIPIS031_CREATE_ENGR_ITEM;
/


