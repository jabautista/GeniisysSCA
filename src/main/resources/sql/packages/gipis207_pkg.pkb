CREATE OR REPLACE PACKAGE BODY CPI.GIPIS207_PKG
AS
     
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 08.23.2013
   **  Reference By : GIPIS207
   **  Remarks      : Batch Posting
   */    
    
    FUNCTION get_iss_cd_batch_posting(
        p_user_id       giis_users.user_id%TYPE   
    )   
        RETURN VARCHAR2
    IS
        ho_cd           VARCHAR2(2);
        v_iss_cd        giis_issource.iss_cd%TYPE;
        nbt_iss_cd      giis_issource.iss_cd%TYPE;
    BEGIN
        FOR iss IN (SELECT param_value_v
                      FROM giis_parameters
                     WHERE param_name = 'ISS_CD_RI')
        LOOP
            v_iss_cd := iss.param_value_v;
        END LOOP;
        
        SELECT param_value_v
          INTO ho_cd
          FROM giis_parameters
         WHERE param_name = 'ISS_CD_HO';
         
        BEGIN
            SELECT b.grp_iss_cd 
              INTO nbt_iss_cd
              FROM giis_user_grp_hdr b,giis_users a 
             WHERE b.user_grp = a.user_grp 
               AND a.user_id = p_user_id
               AND b.grp_iss_cd = ho_cd; 
        EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            BEGIN          
                FOR A IN (SELECT b.grp_iss_cd grp_iss_cd
                               FROM giis_user_grp_hdr b,giis_users a 
                           WHERE b.user_grp = a.user_grp 
                             AND a.user_id = p_user_id)
                LOOP
                      nbt_iss_cd := a.grp_iss_cd;                                
                END LOOP;    
            END;
        END;
        RETURN nbt_iss_cd;
    END get_iss_cd_batch_posting;

    FUNCTION get_par_list_batch_posting(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN par_tab PIPELINED
    IS
        v_par          par_type;
        v_all_user_sw  VARCHAR2(1);
    BEGIN        
        SELECT all_user_sw -- Added by kenneth L. 02.11.2014
          INTO v_all_user_sw
          FROM giis_users
         WHERE user_id = p_user_id;
       
        FOR x IN(SELECT a.line_cd || '-' || a.iss_cd 
                        || '-' || TRIM (TO_CHAR (a.par_yy, '09')) 
                        || '-' || TRIM (TO_CHAR (a.par_seq_no, '000009')) 
                        || '-' || TRIM (TO_CHAR (a.quote_seq_no, '09')) par_no, 
                        a.line_cd, a.subline_cd, a.iss_cd, a.assd_no, 
                        b.assd_name, a.user_id, a.par_type, a.par_id,
                        a.par_yy, a.par_seq_no, a.quote_seq_no, a.bank_ref_no
                   FROM batch_parlist_v2 a, giis_assured b
                  WHERE check_user_per_line2 (line_cd, iss_cd, 'GIPIS207', p_user_id) = 1
                    AND check_user_per_iss_cd2 (line_cd, iss_cd, 'GIPIS207', p_user_id) = 1
                    AND a.user_id = DECODE(v_all_user_sw, 'Y', a.user_id, p_user_id) -- added by: Kenneth L. 02.11.2014                                                                                                -- added by: Kenneth L. 02.11.2014
                    AND a.assd_no = b.assd_no
                    AND line_cd = NVL (p_line_cd, '%')
                 UNION
                 SELECT a.line_cd || '-' || a.iss_cd 
                        || '-' || TRIM (TO_CHAR (a.par_yy, '09')) 
                        || '-' || TRIM (TO_CHAR (a.par_seq_no, '000009')) 
                        || '-' || TRIM (TO_CHAR (a.quote_seq_no, '09')) par_no, 
                        a.line_cd, a.subline_cd, a.iss_cd, a.assd_no, 
                        b.assd_name, a.user_id, a.par_type, a.par_id,
                        a.par_yy, a.par_seq_no, a.quote_seq_no, a.bank_ref_no
                   FROM batch_parlist_v2 a, giis_assured b
                   WHERE check_user_per_line2 (a.line_cd, a.cred_branch, 'GIPIS207', p_user_id) = 1
                     AND check_user_per_iss_cd2 (a.line_cd, a.cred_branch, 'GIPIS207', p_user_id) = 1
                     AND a.user_id = DECODE(v_all_user_sw, 'Y', a.user_id, p_user_id) -- added by: Kenneth L. 02.11.2014                                                                                                -- added by: Kenneth L. 02.11.2014
                     AND a.assd_no = b.assd_no
                     AND line_cd = NVL (p_line_cd, '%'))
        LOOP
            v_par.par_id        := x.par_id;
            v_par.par_no        := x.par_no;
            v_par.line_cd       := x.line_cd;
            v_par.subline_cd    := x.subline_cd;
            v_par.iss_cd        := x.iss_cd;
            v_par.assd_no       := x.assd_no;
            v_par.assd_name     := x.assd_name;
            v_par.user_id       := x.user_id;
            v_par.par_type      := x.par_type; 
            v_par.par_yy        := x.par_yy;
            v_par.par_seq_no    := x.par_seq_no;
            v_par.quote_seq_no  := x.quote_seq_no;
            v_par.bank_ref_no   := x.bank_ref_no;
            PIPE ROW(v_par);
        END LOOP;
    END get_par_list_batch_posting;

    FUNCTION get_error_log(
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN error_log_tab PIPELINED
    IS
        v_err   error_log_type;
    BEGIN
        FOR y IN(SELECT b.line_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || TRIM(TO_CHAR (b.par_yy, '09'))
                        || '-'
                        || TRIM(TO_CHAR (b.par_seq_no, '000009'))
                        || '-'
                        || TRIM(TO_CHAR (b.quote_seq_no, '09')) par_no,
                        a.par_id, a.remarks, a.user_id
                   FROM giis_post_error_log a,  gipi_parlist b
                  WHERE a.par_id = b.par_id 
                    AND a.user_id = p_user_id)
        LOOP
            v_err.par_id  := y.par_id;
            v_err.par_no  := y.par_no;
            v_err.remarks := y.remarks;
            v_err.user_id := y.user_id;
            PIPE ROW(v_err);
        END LOOP;
    END get_error_log;
    
    FUNCTION get_posted_log(
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN posted_log_tab PIPELINED
    IS
        v_posted   posted_log_type;
    BEGIN
        FOR y IN(SELECT b.line_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || TRIM(TO_CHAR (b.par_yy, '09'))
                        || '-'
                        || TRIM(TO_CHAR (b.par_seq_no, '000009'))
                        || '-'
                        || TRIM(TO_CHAR (b.quote_seq_no, '09')) par_no,
                        a.user_id, a.par_id
                   FROM giis_posted_log a,  gipi_parlist b
                  WHERE a.par_id = b.par_id 
                    AND a.user_id = p_user_id)
        LOOP
            BEGIN
                SELECT get_policy_no(b.policy_id) policy_no
                  INTO v_posted.policy_no
                  FROM gipi_polbasic b
                 WHERE b.par_id = y.par_id;
            END;
            v_posted.par_id     := y.par_id;    
            v_posted.par_no     := y.par_no;
            v_posted.user_id    := y.user_id;
            PIPE ROW(v_posted);
        END LOOP;
    END get_posted_log;    

    FUNCTION get_subline_list_batch_posting(
        p_line_cd       giis_line.line_cd%TYPE
    )
        RETURN lov_tab PIPELINED
    IS
        v_lov           lov_type;
    BEGIN
        FOR x IN(SELECT a210.subline_cd, a210.line_cd, a210.subline_name 
                   FROM giis_subline a210
                  WHERE line_cd = p_line_cd)
        LOOP
            v_lov.line_cd       := x.line_cd;
            v_lov.subline_cd    := x.subline_cd;
            v_lov.subline_name  := x.subline_name;
            PIPE ROW(v_lov);
        END LOOP;
    END get_subline_list_batch_posting;
    
    FUNCTION get_iss_list_batch_posting(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN lov_tab PIPELINED
    IS
        v_lov           lov_type;
    BEGIN
        FOR x IN(SELECT iss_cd iss_cd,iss_name iss_name 
                   FROM giis_issource 
                  WHERE check_user_per_iss_cd2(p_line_cd, iss_cd,'GIPIS207', p_user_id) = 1
                    AND iss_cd != 'RI'
                    AND NVL(claim_tag, 'N') != 'Y' 
               ORDER BY iss_cd)
        LOOP
            v_lov.iss_cd    := x.iss_cd;
            v_lov.iss_name  := x.iss_name;
            PIPE ROW(v_lov);
        END LOOP;
    END get_iss_list_batch_posting;        
                     
    FUNCTION get_user_list_batch_posting
        RETURN lov_tab PIPELINED
    IS
        v_lov           lov_type;
    BEGIN
        FOR x IN(SELECT user_id, user_name
                   FROM giis_users
                  WHERE active_flag = 'Y')
        LOOP
            v_lov.user_id   := x.user_id;
            v_lov.user_name := x.user_name;
            PIPE ROW(v_lov);
        END LOOP;
    END get_user_list_batch_posting;        

    PROCEDURE delete_log(p_user_id giis_users.user_id%TYPE)
    IS
    BEGIN
        DELETE FROM giis_post_error_log
         WHERE user_id = p_user_id;
         
        DELETE FROM giis_posted_log
         WHERE user_id = p_user_id;
    END delete_log;  

    FUNCTION check_endt(
        p_par_id        batch_parlist_v2.par_id%TYPE
    )
        RETURN CHAR
    IS
        v_back_endt     VARCHAR2(4) := 'N';
    BEGIN
        FOR pol IN(SELECT '1'
                     FROM gipi_polbasic b250, gipi_wpolbas b540
                    WHERE b250.line_cd = b540.line_cd
                      AND b250.subline_cd = b540.subline_cd
                      AND b250.iss_cd = b540.iss_cd
                      AND b250.issue_yy = b540.issue_yy
                      AND b250.pol_seq_no = b540.pol_seq_no
                      AND b250.renew_no = b540.renew_no
                      AND TRUNC(b250.eff_date) > TRUNC(b540.eff_date)
                      AND b250.pol_flag     in('1','2','3')
                      AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  b540.eff_date
                      AND B540.par_id = p_par_id                
                      AND b540.pol_flag IN ('1','2','3')
                      ORDER BY B250.eff_date desc)
        LOOP
            v_back_endt := 'Y';                            
        EXIT;
        END LOOP;
        --removed conditions below to synchronize with policy issuance posting - check_back_endt Kenneth L. 02.17.2014
--        IF v_back_endt = 'Y' THEN
--        --get value of back_stat from gipi_wpolbas
--            FOR A IN (SELECT nvl(back_stat, 1) back_stat
--                        FROM gipi_wpolbas
--                       WHERE par_id = p_par_id) 
--            LOOP
--                IF a.back_stat = 2 THEN
--                    v_back_endt := 'Y';
--                ELSE
--                    v_back_endt := 'N'; 
--                END IF;      
--                EXIT;
--            END LOOP;
--        END IF;
        RETURN v_back_endt;
    END check_endt;   

    PROCEDURE check_if_back_endt(
        p_par_id    IN   GIPI_PARLIST.par_id%TYPE,
        p_message   OUT  VARCHAR2
    )        
    IS
        v_back_endt     VARCHAR2(4) := 'N';
    BEGIN
        FOR pol IN(SELECT '1'
                     FROM gipi_polbasic b250, gipi_wpolbas b540
                    WHERE b250.line_cd = b540.line_cd
                      AND b250.subline_cd = b540.subline_cd
                      AND b250.iss_cd = b540.iss_cd
                      AND b250.issue_yy = b540.issue_yy
                      AND b250.pol_seq_no = b540.pol_seq_no
                      AND b250.renew_no = b540.renew_no
                      AND TRUNC(b250.eff_date) > TRUNC(b540.eff_date)
                      AND b250.pol_flag     in('1','2','3')
                      AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  b540.eff_date
                      AND B540.par_id = p_par_id                
                      AND b540.pol_flag IN ('1','2','3')
                      ORDER BY B250.eff_date desc)
        LOOP
            gipis207_pkg.pre_post_error2(p_par_id, 'All endts with backward endts will be saved with update. Please post this PAR individually.', 'GIPIS207');
            p_message := 'Y';                            
        EXIT; 
        END LOOP;
    END;
    
    PROCEDURE pre_post_error2(
        p_par_id   IN NUMBER,
        p_remarks  IN VARCHAR2,
        p_module_id IN VARCHAR2
    ) 
    IS
        v_skip_par VARCHAR2(8) := NULL;
    BEGIN
      --ROLLBACK;
      IF p_module_id = 'GIPIS207' THEN
        IF p_remarks IS NOT NULL THEN
            INSERT INTO giis_post_error_log(par_id, remarks)
                 VALUES (p_par_id, p_remarks);
            COMMIT;
        END IF;
      END IF;
    END pre_post_error2;  

    PROCEDURE post_posted_log(
        p_par_id   IN NUMBER,
        p_user_id  IN VARCHAR,
        p_remarks  IN VARCHAR
    )  
    IS
    BEGIN
        INSERT INTO giis_posted_log (par_id, user_id, date_posted, remarks
        )
             VALUES (p_par_id, p_user_id, SYSDATE, p_remarks
             );
        COMMIT;
    END post_posted_log; 

   PROCEDURE check_cancel_par_posting (
        p_par_id gipi_wpolbas.par_id%TYPE,
        p_message   OUT  VARCHAR2
   )
   IS
      v_par_type      gipi_parlist.par_type%TYPE;
      v_line_cd       gipi_polbasic.line_cd%TYPE;
      v_subline_cd    gipi_polbasic.subline_cd%TYPE;
      v_iss_cd        gipi_polbasic.iss_cd%TYPE;
      v_issue_yy      gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no      gipi_polbasic.renew_no%TYPE;
      v_pol_flag      gipi_polbasic.pol_flag%TYPE;
      v_ann_tsi_amt   gipi_polbasic.ann_tsi_amt%TYPE;
      v_endt_type     gipi_polbasic.endt_type%TYPE;
      v_message       VARCHAR2(2000);
   BEGIN
      FOR a IN (SELECT par_type
                  FROM gipi_parlist
                 WHERE par_id = p_par_id)
      LOOP
         v_par_type := a.par_type;
      END LOOP;

      FOR dt IN (SELECT line_cd, subline_cd, iss_cd, pol_seq_no, issue_yy, renew_no, pol_flag, ann_tsi_amt, endt_type
                   FROM gipi_wpolbas
                  WHERE par_id = p_par_id)
      LOOP
         v_line_cd := dt.line_cd;
         v_subline_cd := dt.subline_cd;
         v_iss_cd := dt.iss_cd;
         v_issue_yy := dt.issue_yy;
         v_pol_seq_no := dt.pol_seq_no;
         v_renew_no := dt.renew_no;
         v_pol_flag := dt.pol_flag;
         v_ann_tsi_amt := dt.ann_tsi_amt;
         v_endt_type := dt.endt_type;
         EXIT;
      END LOOP;

      -- for SOA
      BEGIN
         SELECT DISTINCT 'A'
                    INTO v_endt_type
                    FROM gipi_winvoice
                   WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_endt_type := 'N';
      END;

      --end SOA
      IF v_pol_flag <> '4' AND v_ann_tsi_amt = 0 AND v_par_type = 'E' AND v_endt_type <> 'N'
      THEN
         gipis207_pkg.pre_post_error2(p_par_id, 'Effectve TSI for this policy is zero. This will cause to change your policy status as '
                                                ||'cancellation endorsement. Please post this PAR individually.', 'GIPIS207');
         p_message := 'Y';                                                
      END IF;

      IF v_pol_flag = '4' AND v_ann_tsi_amt = 0 AND v_par_type = 'E' AND v_endt_type <> 'N'
      THEN
         FOR a IN (SELECT SUM (c.total_payments) paid_amt
                     FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
                    WHERE a.line_cd = v_line_cd
                      AND a.subline_cd = v_subline_cd
                      AND a.iss_cd = v_iss_cd
                      AND a.issue_yy = v_issue_yy
                      AND a.pol_seq_no = v_pol_seq_no
                      AND a.renew_no = v_renew_no
                      AND a.pol_flag IN ('1', '2', '3')
                      AND a.policy_id = b.policy_id
                      AND b.iss_cd = c.iss_cd
                      AND b.prem_seq_no = c.prem_seq_no)
         LOOP
            IF a.paid_amt <> 0
            THEN
                gipis207_pkg.pre_post_error2(p_par_id, 'Payments have been made to the policy to be cancelled. Please post this PAR individually.', 'GIPIS207');
                p_message := 'Y';
            END IF;
         END LOOP;
      END IF;

      RETURN;
   END;
                                                                      
END GIPIS207_pkg;
/


