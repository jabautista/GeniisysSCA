CREATE OR REPLACE PACKAGE BODY CPI.GIACS044_PKG
AS


    FUNCTION check_iss(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN VARCHAR2
    IS
        v_ret   VARCHAR2(1) := '0';
    BEGIN
        FOR i IN(SELECT iss_cd
                   FROM giis_user_iss_cd
                  WHERE userid = p_user_id
                    AND tran_cd = (SELECT tran_cd
                                     FROM giis_modules_tran
                                    WHERE module_id = 'GIACS044')
                 UNION               
                 SELECT iss_cd    
                   FROM giis_user_grp_dtl
                  WHERE user_grp = (SELECT user_grp
                                      FROM giis_users
                                     WHERE user_id = p_user_id)
                    AND tran_cd = (SELECT tran_cd
                                     FROM giis_modules_tran
                                    WHERE module_id = 'GIACS044'))
        LOOP
            IF i.iss_cd IS NOT NULL 
            THEN
                v_ret := '1';
            END IF;
        END LOOP;
        RETURN v_ret;
    END check_iss;
        
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.08.2013
   **  Reference By : GIACS044
   **  Remarks      : method list - procedure description; RG_PRCC_DESC
   */
   
    FUNCTION get_method_list
        RETURN method_list_tab PIPELINED
    IS
        v_list  method_list_type;
    BEGIN
        FOR q IN(SELECT  procedure_id, procedure_desc
                    FROM giac_deferred_procedures
                   WHERE fund_cd IN (SELECT param_value_v
                                       FROM giac_parameters
                                      WHERE param_name LIKE 'FUND_CD')
                ORDER BY procedure_id)
        LOOP
            v_list.procedure_id     := q.procedure_id;
            v_list.procedure_desc   := q.procedure_desc;
            PIPE ROW(v_list);
        END LOOP;
    END get_method_list;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.09.2013
   **  Reference By : GIACS044
   **  Remarks      : check if data already exist on given extract paramaters
   */
    FUNCTION check_data_extracted(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
        RETURN VARCHAR2
    AS
        v_exists     VARCHAR2(1);
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
        v_proceed_check BOOLEAN := FALSE;
        v_msg        VARCHAR2(200);
    BEGIN
    	FOR i IN (SELECT 'Y' 
                    FROM gipi_invoice 
                   WHERE TO_DATE(TO_CHAR(acct_ent_date,'MM-YYYY'),'MM-YYYY') = TO_DATE(p_mm||'-'||p_year,'MM-YYYY')
                 )
        LOOP
            v_proceed_check := TRUE;
            EXIT;
        END LOOP;
        IF v_proceed_check
        THEN
		    BEGIN
		        SELECT 'Y'
		          INTO v_exists
		          FROM giac_deferred_extract
		         WHERE year = p_year
		           AND mm   = p_mm
		           AND procedure_id = p_procedure_id
		           AND comp_sw = v_24th_comp; --mikel 02.26.2016 GENQA 5288
		    RETURN v_exists; 
		    EXCEPTION
		        WHEN NO_DATA_FOUND THEN
		            v_exists := 'N';
		    RETURN v_exists;
		    END check_data_extracted;    
		ELSE
            v_msg := 'Production entries for '||TO_CHAR(TO_DATE(p_mm||'-'||p_year,'MM-YYYY'),'Month- YYYY')||
                         ' are not yet processed. Please perform Batch Accounting Entry before extracting 24th Method.';
            RETURN v_msg;
        END IF;
    END;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.09.2013
   **  Reference By : GIACS044
   **  Remarks      : check if accounting entries are already posted
   */
    FUNCTION check_gen_tag(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
        RETURN VARCHAR2
    AS
        v_gentag        giac_deferred_extract.gen_tag%TYPE;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        SELECT gen_tag
          INTO v_gentag
          FROM giac_deferred_extract
         WHERE year = p_year
           AND mm   = p_mm
           AND procedure_id = p_procedure_id
           AND comp_sw = v_24th_comp; --mikel 02.26.2016 GENQA 5288
    RETURN v_gentag;
    END check_gen_tag;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.09.2013
   **  Reference By : GIACS044
   **  Remarks      : check status of 24th method transactions
   */
    FUNCTION check_status(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE
    )
        RETURN VARCHAR2
    AS
        v_tran_flag        giac_acctrans.tran_flag%TYPE;
    BEGIN
        SELECT DISTINCT tran_flag
                    INTO v_tran_flag
                   FROM giac_acctrans a  
                  WHERE NVL(jv_tran_yy, tran_year)  = p_year
                       AND NVL(jv_tran_mm, tran_month) = p_mm
                    AND tran_class IN ('DGP','DPC','DCI','DCE')
                    AND tran_flag <> 'D'
         AND NOT EXISTS (SELECT '1'
                            FROM GIAC_REVERSALS x, GIAC_ACCTRANS y
                           WHERE x.gacc_tran_id = a.tran_id
                             AND x.reversing_tran_id = y.tran_id
                             AND y.tran_flag <> 'D');
    RETURN v_tran_flag;                            
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_tran_flag := 'D';        
    RETURN v_tran_flag;
    END check_status; 
          
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.09.2013
   **  Reference By : GIACS044
   **  Remarks      : set tran_flag to D for current entries in giac_acctrans
   */   
    PROCEDURE set_tran_flag(
        p_year  giac_deferred_extract.year%TYPE,
        p_mm    giac_deferred_extract.mm%TYPE
    )
    IS
    BEGIN
        UPDATE giac_acctrans 
           SET tran_flag = 'D'
         WHERE ((NVL(jv_tran_yy, tran_year) = p_year
                 AND NVL(jv_tran_mm, tran_month) = p_mm
                 AND tran_class IN ('DGP','DPC','DCI','DCE'))
               OR 
                (NVL(jv_tran_yy, tran_year) = DECODE(p_mm, 12, p_year + 1, p_year)
                 AND NVL(jv_tran_mm, tran_month) = p_mm
                 AND tran_class IN ('RGP','RPC','RCI','RCE')))
                 AND tran_flag = 'C';                   
    END set_tran_flag; 

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.09.2013
   **  Reference By : GIACS044
   **  Remarks      : call deferred procedures depending upon the value of the parameter '24th Method Proc'
   */    
    PROCEDURE call_deferred_procedures(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_msg       OUT VARCHAR
    )
    IS
        v_method_proc    NUMBER;
        v_new_method    giac_parameters.param_value_v%TYPE; 
        v_switch        VARCHAR2(1) := 'N';
        v_count         NUMBER;
    BEGIN
        v_method_proc := giacp.n('24TH_METHOD_PROC');
        v_new_method  := NVL(giacp.v('UNEARNED_COMP_METHOD'), 'XXX'); 
        
        IF v_new_method = '1/365' AND p_procedure_id = 3 THEN
             v_switch := 'Y';
        END IF;
                
        IF v_method_proc = 1 THEN
            deferred_extract(p_year, p_mm, p_procedure_id);
        ELSIF v_method_proc IN (2,3) and v_switch = 'N' THEN
            --deferred_extract2(p_year, p_mm, p_procedure_id); --mikel 02.03.2016 genqa 5288
            deferred_extract3(p_year, p_mm, p_procedure_id); --mikel 02.03.2016; factors to get unearned amount is based on the no. of months of the policy term
        ELSIF v_method_proc IN (2,3) and v_switch = 'Y' THEN 
            deferred_extract365(p_year, p_mm, p_procedure_id); 
        END IF;    
        
        SELECT COUNT(*)
          INTO v_count
          FROM giac_deferred_gross_prem a
         WHERE year = p_year
           AND mm   = p_mm
           AND procedure_id = p_procedure_id;
     
        IF v_count = 0 --1 main
        THEN 
            SELECT COUNT(*)
              INTO v_count
              FROM giac_deferred_ri_prem_ceded a
             WHERE year = p_year
               AND mm   = p_mm
               AND procedure_id = p_procedure_id;
            IF v_count = 0 THEN --2 main
             SELECT COUNT(*)
               INTO v_count
               FROM giac_deferred_comm_income a
              WHERE year = p_year
                AND mm   = p_mm
                AND procedure_id = p_procedure_id;
                
                IF v_count = 0 THEN --3 main
                 SELECT COUNT(*)
                   INTO v_count
                   FROM giac_deferred_comm_expense a
                  WHERE year = p_year
                    AND mm   = p_mm
                    AND procedure_id = p_procedure_id;
                    
                    IF v_method_proc IN (2,3) and v_switch = 'Y' THEN
                        IF v_count = 0 THEN --1 dtl
                         SELECT COUNT(*)
                           INTO v_count
                           FROM giac_deferred_gross_prem_pol
                          WHERE extract_year = p_year
                            AND extract_mm   = p_mm
                            AND procedure_id = p_procedure_id;
                        
                            IF v_count = 0 THEN --2 dtl
                             SELECT COUNT(*)
                               INTO v_count
                               FROM giac_deferred_ri_prem_cede_pol
                              WHERE extract_year = p_year
                                AND extract_mm   = p_mm
                                AND procedure_id = p_procedure_id;
                            
                                IF v_count = 0 THEN --3 dtl
                                 SELECT COUNT(*)
                                   INTO v_count
                                   FROM giac_deferred_comm_income_pol
                                  WHERE extract_year = p_year
                                    AND extract_mm   = p_mm
                                    AND procedure_id = p_procedure_id;
                                
                                    IF v_count = 0 THEN --4 dtl
                                     SELECT COUNT(*)
                                       INTO v_count
                                       FROM giac_deferred_comm_expense_pol
                                      WHERE extract_year = p_year
                                        AND extract_mm   = p_mm
                                        AND procedure_id = p_procedure_id;
                                        
                                        p_msg := 'Extraction finished. No records extracted.';
                                        
                                    ELSE
                                        p_msg := 'Extraction finished.';                                    
                                    END IF;    ---4 dtl     
                                ELSE
                                    p_msg := 'Extraction finished.';                                    
                                END IF;    ---3 dtl    
                            ELSE
                                p_msg := 'Extraction finished.';                                    
                            END IF;    ---2 dtl
                        ELSE
                            p_msg := 'Extraction finished.';                                    
                        END IF;    ---1 dtl
                    ELSIF v_method_proc IN (2,3) and v_switch = 'N' THEN
                        IF v_count = 0 THEN --1 dtl
                         SELECT COUNT(*)
                           INTO v_count
                           FROM giac_deferred_gross_prem_dtl
                          WHERE extract_year = p_year
                            AND extract_mm   = p_mm
                            AND procedure_id = p_procedure_id;
                        
                            IF v_count = 0 THEN --2 dtl
                             SELECT COUNT(*)
                               INTO v_count
                               FROM giac_deferred_ri_prem_cede_dtl
                              WHERE extract_year = p_year
                                AND extract_mm   = p_mm
                                AND procedure_id = p_procedure_id;
                                                    
                                IF v_count = 0 THEN --3 dtl
                                 SELECT COUNT(*)
                                   INTO v_count
                                   FROM giac_deferred_comm_income_dtl
                                  WHERE extract_year = p_year
                                    AND extract_mm   = p_mm
                                    AND procedure_id = p_procedure_id;  
                                                        
                                    IF v_count = 0 THEN --4 dtl
                                     SELECT COUNT(*)
                                       INTO v_count
                                       FROM giac_deferred_comm_expense_dtl
                                      WHERE extract_year = p_year
                                        AND extract_mm   = p_mm
                                        AND procedure_id = p_procedure_id;  
                                        
                                        p_msg := 'Extraction finished. No records extracted.';
                                        
                                    ELSE
                                        p_msg := 'Extraction finished.';                                    
                                    END IF;    ---4 dtl                        
                                ELSE
                                    p_msg := 'Extraction finished.';                                    
                                END IF;    ---3 dtl                          
                            ELSE
                                p_msg := 'Extraction finished.';                                    
                            END IF;    ---2 dtl                          
                        ELSE
                            p_msg := 'Extraction finished.';                                    
                        END IF;    ---1 dtl   
                    END IF;
                ELSE
                    p_msg := 'Extraction finished.';                                    
                END IF;    ---3
            ELSE
                p_msg := 'Extraction finished.';                                    
            END IF;    --2
        ELSE
            p_msg := 'Extraction finished.';                                    
        END IF; --1
            
                                          
    END call_deferred_procedures;
    
    FUNCTION get_share_type_name(
        p_share_type   giac_deferred_ri_prem_ceded.share_type%TYPE
    )
        RETURN VARCHAR2
    IS
        v_share_type_name VARCHAR2(50);
    BEGIN
        IF p_share_type = '2' THEN
            v_share_type_name := 'Treaty';
        ELSIF p_share_type = '3' THEN
            v_share_type_name := 'Facul';
        ELSE
            v_share_type_name := NULL;
        END IF;
        RETURN v_share_type_name;
    END get_share_type_name;  

    FUNCTION get_procedure_desc(
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_fund_cd       giac_deferred_procedures.fund_cd%TYPE             
    )
        RETURN VARCHAR2
    IS
        v_procedure_desc    giac_deferred_procedures.procedure_desc%TYPE;     
    BEGIN
        SELECT procedure_desc
          INTO v_procedure_desc
          FROM giac_deferred_procedures
         WHERE procedure_id = p_procedure_id
           AND fund_cd = NVL(p_fund_cd, fund_cd);
        RETURN v_procedure_desc;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END get_procedure_desc;    
         
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.11.2013
   **  Reference By : GIACS044
   **  Remarks      : query for gross premiums table
   */ 
    FUNCTION get_gd_gross(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_gross_tab PIPELINED
    IS
        v_gd_gross        gd_gross_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN (SELECT year, mm, procedure_id, numerator_factor, denominator_factor, iss_cd, line_cd,
                         prem_amt, def_prem_amt, prev_def_prem_amt, def_prem_amt_diff, user_id, TO_CHAR(last_update,'MM-DD-YYYY')  last_update
                         ,comp_sw --mikel 02.26.2016 GENQA 5288
                    FROM giac_deferred_gross_prem
                   WHERE year = p_year
                     AND mm = p_mm
                     AND procedure_id = p_procedure_id
                     --AND check_user_per_iss_cd_acctg2 (line_cd, iss_cd, 'GIACS044', p_user_id) = 1
                     AND comp_sw = v_24th_comp --mikel 02.26.2016 GENQA 5288
                     )
        LOOP
            v_gd_gross.year               := q.year;
            v_gd_gross.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
            v_gd_gross.numerator_factor   := q.numerator_factor;
            v_gd_gross.denominator_factor := q.denominator_factor;
            v_gd_gross.iss_cd             := q.iss_cd;
            v_gd_gross.line_cd            := q.line_cd;
            v_gd_gross.prem_amt           := q.prem_amt;
            v_gd_gross.def_prem_amt       := q.def_prem_amt;  
            v_gd_gross.prev_def_prem_amt  := q.prev_def_prem_amt;
            v_gd_gross.def_prem_amt_diff  := q.def_prem_amt_diff;
            v_gd_gross.user_id            := q.user_id;
            v_gd_gross.last_update        := q.last_update;
            v_gd_gross.procedure_desc     := get_procedure_desc(q.procedure_id, null);
            v_gd_gross.comp_sw            := q.comp_sw; --mikel 02.26.2016 GENQA 5288
            
            PIPE ROW(v_gd_gross);
        END LOOP;
    END get_gd_gross;   
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.20.2013
   **  Reference By : GIACS044
   **  Remarks      : query for premium ceded
   */           
    FUNCTION get_gd_ri_ceded(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED
    IS
        v_gd_ricede        gd_ri_ceded_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN(SELECT year, mm, procedure_id, numerator_factor, denominator_factor,
                        iss_cd, line_cd, share_type, sum(dist_prem) dist_prem,
                        sum(def_dist_prem) def_dist_prem, sum(prev_def_dist_prem) prev_def_dist_prem,
                        sum(def_dist_prem_diff) def_dist_prem_diff, user_id,last_update
                        ,comp_sw --mikel 02.26.2016 GENQA 5288
                  FROM giac_deferred_ri_prem_ceded
                 WHERE year = p_year
                   AND mm = p_mm
                   AND procedure_id = p_procedure_id
                  -- AND check_user_per_iss_cd_acctg2 (line_cd, iss_cd, 'GIACS044', p_user_id) = 1
                   AND iss_cd NOT IN(SELECT param_value_v  
                                       FROM giis_parameters
                                      WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                   AND comp_sw = v_24th_comp --mikel 02.26.2016 GENQA 5288
                 GROUP BY year, mm, iss_cd, line_cd, procedure_id, share_type, 
                          gacc_tran_id, numerator_factor, denominator_factor, user_id,
                          last_update, cpi_rec_no, cpi_branch_cd
                          ,comp_sw) --mikel 02.26.2016 GENQA 5288
        LOOP
            v_gd_ricede.year               := q.year;
            v_gd_ricede.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
            v_gd_ricede.numerator_factor   := q.numerator_factor;
            v_gd_ricede.denominator_factor := q.denominator_factor;
            v_gd_ricede.shr_type           := q.share_type;
            v_gd_ricede.iss_cd             := q.iss_cd;
            v_gd_ricede.line_cd            := q.line_cd;
            v_gd_ricede.dist_prem          := q.dist_prem;
            v_gd_ricede.def_dist_prem      := q.def_dist_prem;
            v_gd_ricede.prev_def_dist_prem := q.prev_def_dist_prem;
            v_gd_ricede.def_dist_prem_diff := q.def_dist_prem_diff;
            v_gd_ricede.user_id            := q.user_id;
            v_gd_ricede.last_update        := q.last_update;
            v_gd_ricede.share_type         := get_share_type_name(q.share_type);
            v_gd_ricede.procedure_desc     := get_procedure_desc(q.procedure_id, null);
            v_gd_ricede.comp_sw            := q.comp_sw; --mikel 02.26.2016 GENQA 5288

            PIPE ROW(v_gd_ricede);
        END LOOP;   
    END get_gd_ri_ceded;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.11.2013
   **  Reference By : GIACS044
   **  Remarks      : query for commission income
   */           
    FUNCTION get_gd_inc(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_inc_tab PIPELINED
    IS
       v_gd_inc        gd_inc_type;
       v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN(SELECT year, mm, procedure_id, numerator_factor, denominator_factor, 
                        iss_cd, line_cd, share_type, SUM (comm_income) comm_income, SUM (def_comm_income) def_comm_income,
                         SUM (prev_def_comm_income) prev_def_comm_income, SUM (def_comm_income_diff) def_comm_income_diff, 
                         user_id, last_update,comp_sw --mikel 02.26.2016 GENQA 5288
                    FROM giac_deferred_comm_income
                   WHERE year = p_year
                     AND mm = p_mm
                     AND procedure_id = p_procedure_id
                     --AND check_user_per_iss_cd_acctg2 (line_cd, iss_cd, 'GIACS044', p_user_id) = 1
                     AND comp_sw = v_24th_comp --mikel 02.26.2016 GENQA 5288
                GROUP BY YEAR, mm, iss_cd, line_cd, procedure_id, share_type, gacc_tran_id, 
                numerator_factor, denominator_factor, user_id, last_update, cpi_rec_no, cpi_branch_cd
                ,comp_sw) --mikel 02.26.2016 GENQA 5288
        LOOP
            v_gd_inc.year                 := q.year;
            v_gd_inc.mm                   := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
            v_gd_inc.numerator_factor     := q.numerator_factor;
            v_gd_inc.denominator_factor   := q.denominator_factor;
            v_gd_inc.shr_type             := q.share_type;
            v_gd_inc.iss_cd               := q.iss_cd;
            v_gd_inc.line_cd              := q.line_cd;
            v_gd_inc.comm_income          := q.comm_income;
            v_gd_inc.def_comm_income      := q.def_comm_income;
            v_gd_inc.prev_def_comm_income := q.prev_def_comm_income;
            v_gd_inc.def_comm_income_diff := q.def_comm_income_diff;
            v_gd_inc.user_id              := q.user_id;
            v_gd_inc.last_update          := q.last_update;
            v_gd_inc.share_type           := get_share_type_name(q.share_type);
            v_gd_inc.procedure_desc       := get_procedure_desc(q.procedure_id, null);
            v_gd_inc.comp_sw              := q.comp_sw; --mikel 02.26.2016 GENQA 5288

            PIPE ROW(v_gd_inc);
        END LOOP;   
    END get_gd_inc; 

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.11.2013
   **  Reference By : GIACS044
   **  Remarks      : query for commission expense
   */      
    FUNCTION get_gd_exp(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_exp_tab PIPELINED 
    IS
        v_gd_exp        gd_exp_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN(SELECT year, mm, procedure_id, numerator_factor, denominator_factor, 
                        iss_cd, line_cd, SUM(comm_expense) comm_expense, SUM(def_comm_expense) def_comm_expense, 
                        SUM(prev_def_comm_expense) prev_def_comm_expense, SUM(def_comm_expense_diff) def_comm_expense_diff, user_id, TRUNC(last_update) last_update
                        ,comp_sw --mikel 02.26.2016 GENQA 5288
                    FROM giac_deferred_comm_expense
                   WHERE year = p_year
                     AND mm = p_mm
                     AND procedure_id = p_procedure_id
                     --AND check_user_per_iss_cd_acctg2 (line_cd, iss_cd, 'GIACS044', p_user_id) = 1
                     AND comp_sw = v_24th_comp --mikel 02.26.2016 GENQA 5288
                GROUP BY YEAR, mm, iss_cd, line_cd, procedure_id, gacc_tran_id, 
                        numerator_factor, denominator_factor, user_id, TRUNC(last_update), cpi_rec_no, cpi_branch_cd
                        ,comp_sw) --mikel 02.26.2016 GENQA 5288; added group by
        LOOP
            v_gd_exp.year                  := q.year;
            v_gd_exp.mm                    := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
            v_gd_exp.numerator_factor      := q.numerator_factor;
            v_gd_exp.denominator_factor    := q.denominator_factor;
            v_gd_exp.iss_cd                := q.iss_cd;
            v_gd_exp.line_cd               := q.line_cd;
            v_gd_exp.comm_expense          := q.comm_expense;
            v_gd_exp.def_comm_expense      := q.def_comm_expense;
            v_gd_exp.prev_def_comm_expense := q.prev_def_comm_expense;
            v_gd_exp.def_comm_expense_diff := q.def_comm_expense_diff;
            v_gd_exp.user_id               := q.user_id;
            v_gd_exp.last_update           := q.last_update;
            v_gd_exp.procedure_desc        := get_procedure_desc(q.procedure_id, null);
            v_gd_exp.comp_sw               := q.comp_sw; --mikel 02.26.2016 GENQA 5288
            
            PIPE ROW(v_gd_exp);
        END LOOP;
    END get_gd_exp;          

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.14.2013
   **  Reference By : GIACS044
   **  Remarks      : query for net premiums
   */ 
    FUNCTION get_gd_net_prem(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_net_prem_tab PIPELINED
    IS
        v_gd_net_prem      gd_net_prem_type;
    BEGIN
        FOR q IN(SELECT year, mm, procedure_id, iss_cd, line_cd,
                        gross_prem, total_ri_ceded, net_prem, user_id, TO_CHAR(last_update, 'MM-DD-YYYY') last_update
                   FROM giac_deferred_net_prem_v 
                  WHERE year = p_year
                    AND mm = p_mm
                    AND procedure_id = p_procedure_id
                    --AND check_user_per_iss_cd_acctg2 (line_cd, iss_cd, 'GIACS044', p_user_id) = 1
                    )
        LOOP
            v_gd_net_prem.year             := q.year;
            v_gd_net_prem.mm               := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
            v_gd_net_prem.iss_cd           := q.iss_cd;
            v_gd_net_prem.line_cd          := q.line_cd;
            v_gd_net_prem.gross_prem       := q.gross_prem;
            v_gd_net_prem.total_ri_ceded   := q.total_ri_ceded;
            v_gd_net_prem.net_prem         := q.net_prem;
            v_gd_net_prem.user_id          := q.user_id;
            v_gd_net_prem.last_update      := q.last_update;
            v_gd_net_prem.procedure_desc   := get_procedure_desc(q.procedure_id, null);           
            
            BEGIN
               SELECT distinct numerator_factor, denominator_factor
                 INTO v_gd_net_prem.numerator_factor, v_gd_net_prem.denominator_factor
                 FROM giac_deferred_gross_prem
                WHERE year = p_year
                  AND mm   = p_mm
                  AND procedure_id = p_procedure_id;
               EXCEPTION 
                  WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                null;
            END;            
            
            PIPE ROW(v_gd_net_prem);
        END LOOP;
    END get_gd_net_prem;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.14.2013
   **  Reference By : GIACS044
   **  Remarks      : query for retroceded premiums
   */           
    FUNCTION get_gd_retrocede(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED
    IS
        v_gd_retrocede        gd_ri_ceded_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN(SELECT year, mm, procedure_id, numerator_factor, denominator_factor,
                        iss_cd, line_cd, share_type, sum(dist_prem) dist_prem,
                        sum(def_dist_prem) def_dist_prem, sum(prev_def_dist_prem) prev_def_dist_prem,
                        sum(def_dist_prem_diff) def_dist_prem_diff, user_id, TRUNC(last_update) last_update
                        ,comp_sw --mikel 02.26.2016 GENQA 5288
                  FROM giac_deferred_ri_prem_ceded
                 WHERE year = p_year
                   AND mm = p_mm
                   AND procedure_id = p_procedure_id
                   --AND check_user_per_iss_cd_acctg2 (line_cd, iss_cd, 'GIACS044', p_user_id) = 1
                   AND iss_cd IN(SELECT param_value_v  
                                       FROM giis_parameters
                                      WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV'))
                   AND comp_sw = v_24th_comp --mikel 02.26.2016 GENQA 5288                   
                 GROUP BY year, mm, iss_cd, line_cd, procedure_id, share_type, 
                          gacc_tran_id, numerator_factor, denominator_factor, user_id,
                          TRUNC(last_update), cpi_rec_no, cpi_branch_cd
                          ,comp_sw) --mikel 02.26.2016 GENQA 5288
        LOOP
            v_gd_retrocede.year               := q.year;
            v_gd_retrocede.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
            v_gd_retrocede.numerator_factor   := q.numerator_factor;
            v_gd_retrocede.denominator_factor := q.denominator_factor;
            v_gd_retrocede.shr_type           := q.share_type;
            v_gd_retrocede.iss_cd             := q.iss_cd;
            v_gd_retrocede.line_cd            := q.line_cd;
            v_gd_retrocede.dist_prem          := q.dist_prem;
            v_gd_retrocede.def_dist_prem      := q.def_dist_prem;
            v_gd_retrocede.prev_def_dist_prem := q.prev_def_dist_prem;
            v_gd_retrocede.def_dist_prem_diff := q.def_dist_prem_diff;
            v_gd_retrocede.user_id            := q.user_id;
            v_gd_retrocede.last_update        := q.last_update;
            v_gd_retrocede.share_type         := get_share_type_name(q.share_type);
            v_gd_retrocede.procedure_desc     := get_procedure_desc(q.procedure_id, null);
            v_gd_retrocede.comp_sw            := q.comp_sw; --mikel 02.26.2016 GENQA 5288 

            PIPE ROW(v_gd_retrocede);
        END LOOP;   
    END get_gd_retrocede;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.14.2013
   **  Reference By : GIACS044
   **  Remarks      : query for extract history
   */     
    FUNCTION get_extract_hist(
        p_fund_cd          giac_deferred_procedures.fund_cd%TYPE
    )
        RETURN extract_hist_tab PIPELINED
    IS
        v_hist          extract_hist_type;
        v_fund_cd       giac_deferred_procedures.fund_cd%TYPE; 
    BEGIN
        FOR q IN(SELECT year, mm, user_id, TO_CHAR(last_extract,'MM-DD-YYYY') last_extract, last_extract last_extract_date,
                        procedure_id, gen_user, TO_CHAR(gen_date, 'MM-DD-YYYY') gen_date, gen_tag
                   FROM giac_deferred_extract
               ORDER BY last_extract_date)
        LOOP
            v_hist.year           := q.year;
            v_hist.mm             := q.mm;
            v_hist.user_id        := q.user_id;
            v_hist.last_extract   := q.last_extract;
            v_hist.gen_user       := q.gen_user;
            v_hist.gen_date       := q.gen_date;
            v_hist.gen_tag        := q.gen_tag;
            v_hist.procedure_desc := get_procedure_desc(q.procedure_id, p_fund_cd);
            
            BEGIN
                SELECT param_value_v
                  INTO v_fund_cd
                  FROM giac_parameters
                 WHERE param_name LIKE 'FUND_CD';
            END;
        
        PIPE ROW(v_hist);
        END LOOP;
    END get_extract_hist;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.15.2013
   **  Reference By : GIACS044
   **  Remarks      : query for gross premiums detail
   */  
    FUNCTION get_gd_gross_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
    )
        RETURN gd_gross_tab PIPELINED
     IS 
        v_dtl           gd_gross_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
     BEGIN
        IF p_procedure_id IN (1, 2) AND v_24th_comp = 'N' THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, mm, year, numerator_factor, denominator_factor, prem_amt, def_prem_amt
                       FROM giac_deferred_gross_prem_dtl
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd) 
            LOOP
                v_dtl.year               := q.year;
                --v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth'); --mikel 06.01.2015
                IF q.mm = 99 THEN --mikel 06.01.2015; to handle ORA-01843: not a valid month
                    v_dtl.mm := 'BEYOND '||TO_CHAR(to_date(p_mm,'MM'),'fmMONTH');
                ELSE
                    v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
                END IF;        
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.prem_amt           := q.prem_amt;
                v_dtl.def_prem_amt       := q.def_prem_amt;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;
                                            
            PIPE ROW(v_dtl);
            END LOOP;
        ELSIF (p_procedure_id = 1 AND v_24th_comp = 'Y') OR p_procedure_id = 3 THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, policy_no, TO_CHAR(eff_date, 'MM-DD-YYYY') eff_date, TO_CHAR(expiry_date, 'MM-DD-YYYY') expiry_date, 
                            numerator_factor, denominator_factor, prem_amt, def_prem_amt
                       FROM giac_deferred_gross_prem_pol
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND comp_sw = v_24th_comp) --mikel 02.26.2016 GENQA 5288 
            LOOP
                v_dtl.policy_no          := q.policy_no;
                v_dtl.eff_date           := q.eff_date;
                v_dtl.expiry_date        := q.expiry_date;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.prem_amt           := q.prem_amt;
                v_dtl.def_prem_amt       := q.def_prem_amt;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;
                                            
            PIPE ROW(v_dtl);
            END LOOP;        
        END IF;        
     END get_gd_gross_dtl;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.20.2013
   **  Reference By : GIACS044
   **  Remarks      : query for gross premiums detail
   */ 
    FUNCTION get_gd_ri_ceded_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giac_deferred_ri_prem_cede_dtl.share_type%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED
    IS
        v_dtl   gd_ri_ceded_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        IF p_procedure_id IN (1, 2) AND v_24th_comp = 'N' THEN --mikel 02.26.2016 GENQA 5288 
            FOR q IN(SELECT iss_cd, line_cd, mm, year,share_type, numerator_factor, 
                            denominator_factor, sum(dist_prem) dist_prem, sum(def_dist_prem) def_dist_prem 
                       FROM giac_deferred_ri_prem_cede_dtl 
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND iss_cd NOT IN(SELECT param_value_v 
                                            FROM giis_parameters 
                                           WHERE param_name IN('ISS_CD_RI','ISS_CD_RV'))
                        AND share_type = p_share_type
                   GROUP BY extract_year, extract_mm, procedure_id, 
                            iss_cd, line_cd, mm, year, share_type, 
                            numerator_factor, denominator_factor)
            LOOP
                v_dtl.year               := q.year;
                --v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth'); --mikel 06.01.2015
                IF q.mm = 99 THEN --mikel 06.01.2015; to handle ORA-01843: not a valid month
                    v_dtl.mm := 'BEYOND '||TO_CHAR(to_date(p_mm,'MM'),'fmMONTH');
                ELSE
                    v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
                END IF;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.dist_prem          := q.dist_prem;
                v_dtl.def_dist_prem      := q.def_dist_prem;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                v_dtl.share_type         := get_share_type_name(q.share_type);
                                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;         
                                            
            PIPE ROW(v_dtl);        
            END LOOP;
        ELSIF (p_procedure_id = 1 AND v_24th_comp = 'Y') OR p_procedure_id = 3 THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, policy_no, TO_CHAR(eff_date, 'MM-DD-YYYY') eff_date, 
                            TO_CHAR(expiry_date, 'MM-DD-YYYY') expiry_date, share_type, 
                            numerator_factor, denominator_factor, dist_prem, def_dist_prem 
                       FROM giac_deferred_ri_prem_cede_pol
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND iss_cd NOT IN(SELECT param_value_v 
                                            FROM giis_parameters 
                                           WHERE param_name IN('ISS_CD_RI','ISS_CD_RV'))
                        AND share_type = p_share_type
                        AND comp_sw = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                v_dtl.policy_no          := q.policy_no;
                v_dtl.eff_date           := q.eff_date;
                v_dtl.expiry_date        := q.expiry_date;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.dist_prem          := q.dist_prem;
                v_dtl.def_dist_prem      := q.def_dist_prem;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                v_dtl.share_type         := get_share_type_name(q.share_type);
                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;          
                                            
            PIPE ROW(v_dtl);        
            END LOOP;            
        END IF;            
    END get_gd_ri_ceded_dtl;     

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.20.2013
   **  Reference By : GIACS044
   **  Remarks      : query for commission income detail
   */ 
    FUNCTION get_gd_inc_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giac_deferred_comm_income_dtl.share_type%TYPE
    )
        RETURN gd_inc_tab PIPELINED
    IS
        v_dtl   gd_inc_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        IF p_procedure_id IN (1, 2) AND v_24th_comp = 'N' THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, mm, year, share_type, numerator_factor, denominator_factor, 
                            sum(comm_income) comm_income, sum(def_comm_income) def_comm_income 
                       FROM giac_deferred_comm_income_dtl
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND share_type = p_share_type                   
                   GROUP BY extract_year, extract_mm, procedure_id, 
                            iss_cd, line_cd, mm, year, share_type, 
                            numerator_factor, denominator_factor)
            LOOP
                v_dtl.year               := q.year;
                --v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth'); --mikel 06.01.2015
                IF q.mm = 99 THEN --mikel 06.01.2015; to handle ORA-01843: not a valid month
                    v_dtl.mm := 'BEYOND '||TO_CHAR(to_date(p_mm,'MM'),'fmMONTH');
                ELSE
                    v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
                END IF;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.comm_income        := q.comm_income;
                v_dtl.def_comm_income    := q.def_comm_income;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                v_dtl.share_type         := get_share_type_name(q.share_type);
                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;         
                                            
            PIPE ROW(v_dtl);        
            END LOOP;
        ELSIF (p_procedure_id = 1 AND v_24th_comp = 'Y') OR p_procedure_id = 3 THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, policy_no, TO_CHAR(eff_date, 'MM-DD-YYYY') eff_date, 
                            TO_CHAR(expiry_date, 'MM-DD-YYYY') expiry_date, share_type, 
                            numerator_factor, denominator_factor, comm_income, def_comm_income
                       FROM giac_deferred_comm_income_pol
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND iss_cd NOT IN(SELECT param_value_v 
                                            FROM giis_parameters 
                                           WHERE param_name IN('ISS_CD_RI','ISS_CD_RV'))
                        AND share_type = p_share_type
                        AND comp_sw = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                v_dtl.policy_no          := q.policy_no;
                v_dtl.eff_date           := q.eff_date;
                v_dtl.expiry_date        := q.expiry_date;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.comm_income        := q.comm_income;
                v_dtl.def_comm_income    := q.def_comm_income;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                v_dtl.share_type         := get_share_type_name(q.share_type); 
                   
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;         
                                            
            PIPE ROW(v_dtl);        
            END LOOP;         
        END IF;
    END get_gd_inc_dtl; 

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.20.2013
   **  Reference By : GIACS044
   **  Remarks      : query for commission expense detail
   */  
    FUNCTION get_gd_exp_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
    )
        RETURN gd_exp_tab PIPELINED
     IS 
        v_dtl           gd_exp_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
     BEGIN
        IF p_procedure_id IN (1, 2) AND v_24th_comp = 'N' THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, mm, year, numerator_factor, denominator_factor, comm_expense, def_comm_expense
                       FROM giac_deferred_comm_expense_dtl
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd) 
            LOOP
                v_dtl.year               := q.year;
                --v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth'); --mikel 06.01.2015
                IF q.mm = 99 THEN --mikel 06.01.2015; to handle ORA-01843: not a valid month
                    v_dtl.mm := 'BEYOND '||TO_CHAR(to_date(p_mm,'MM'),'fmMONTH');
                ELSE
                    v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
                END IF;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.comm_expense       := q.comm_expense;
                v_dtl.def_comm_expense   := q.def_comm_expense;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;
                                            
            PIPE ROW(v_dtl);
            END LOOP;
        ELSIF (p_procedure_id = 1 AND v_24th_comp = 'Y') OR p_procedure_id = 3 THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, policy_no, TO_CHAR(eff_date, 'MM-DD-YYYY') eff_date, 
                            TO_CHAR(expiry_date, 'MM-DD-YYYY') expiry_date, 
                            numerator_factor, denominator_factor, comm_expense, def_comm_expense
                       FROM giac_deferred_comm_expense_pol
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND comp_sw = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                v_dtl.policy_no          := q.policy_no;
                v_dtl.eff_date           := q.eff_date;
                v_dtl.expiry_date        := q.expiry_date;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.comm_expense       := q.comm_expense;
                v_dtl.def_comm_expense   := q.def_comm_expense;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;
                                                      
            PIPE ROW(v_dtl);        
            END LOOP;         
        END IF;
     END get_gd_exp_dtl;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.20.2013
   **  Reference By : GIACS044
   **  Remarks      : query for retroceded premiums
   */ 
    FUNCTION get_gd_retrocede_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giac_deferred_ri_prem_cede_dtl.share_type%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED
    IS
        v_dtl   gd_ri_ceded_type;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        IF p_procedure_id IN (1, 2) AND v_24th_comp = 'N' THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, mm, year,share_type, numerator_factor, 
                            denominator_factor, sum(dist_prem) dist_prem, sum(def_dist_prem) def_dist_prem 
                       FROM giac_deferred_ri_prem_cede_dtl 
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND iss_cd IN (SELECT param_value_v  --mikel 02.04.2016; changed NOT IN to IN
                                            FROM giis_parameters 
                                           WHERE param_name IN('ISS_CD_RI','ISS_CD_RV'))
                        AND share_type = p_share_type
                   GROUP BY extract_year, extract_mm, procedure_id, 
                            iss_cd, line_cd, mm, year, share_type, 
                            numerator_factor, denominator_factor)
            LOOP
                v_dtl.year               := q.year;
                --v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth'); --mikel 06.01.2015
                IF q.mm = 99 THEN --mikel 06.01.2015; to handle ORA-01843: not a valid month
                    v_dtl.mm := 'BEYOND '||TO_CHAR(to_date(p_mm,'MM'),'fmMONTH');
                ELSE
                    v_dtl.mm                 := TO_CHAR(TO_DATE(q.mm,'mm'),'fmMonth');
                END IF;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.dist_prem          := q.dist_prem;
                v_dtl.def_dist_prem      := q.def_dist_prem;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                v_dtl.share_type         := get_share_type_name(q.share_type);
                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;          
                                            
            PIPE ROW(v_dtl);        
            END LOOP;
        ELSIF (p_procedure_id = 1 AND v_24th_comp = 'Y') OR p_procedure_id = 3 THEN --mikel 02.26.2016 GENQA 5288
            FOR q IN(SELECT iss_cd, line_cd, policy_no, TO_CHAR(eff_date, 'MM-DD-YYYY') eff_date, 
                            TO_CHAR(expiry_date, 'MM-DD-YYYY') expiry_date, share_type, 
                            numerator_factor, denominator_factor, dist_prem, def_dist_prem
                       FROM giac_deferred_ri_prem_cede_pol
                      WHERE extract_year = p_year
                        AND extract_mm = p_mm
                        AND procedure_id = p_procedure_id
                        AND iss_cd = p_iss_cd
                        AND line_cd = p_line_cd
                        AND iss_cd IN(SELECT param_value_v --mikel 02.04.2016; changed NOT IN to IN
                                            FROM giis_parameters 
                                           WHERE param_name IN('ISS_CD_RI','ISS_CD_RV'))
                        AND share_type = p_share_type
                        AND comp_sw = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                v_dtl.policy_no          := q.policy_no;
                v_dtl.eff_date           := q.eff_date;
                v_dtl.expiry_date        := q.expiry_date;
                v_dtl.numerator_factor   := q.numerator_factor;
                v_dtl.denominator_factor := q.denominator_factor;
                v_dtl.dist_prem          := q.dist_prem;
                v_dtl.def_dist_prem      := q.def_dist_prem;
                v_dtl.line_cd            := q.line_cd;
                v_dtl.line_name          := get_line_name(q.line_cd);
                v_dtl.iss_cd             := q.iss_cd;
                v_dtl.iss_name           := get_iss_name(q.iss_cd);
                v_dtl.share_type         := get_share_type_name(q.share_type);
                    
                IF v_dtl.line_name IS NULL THEN
                    v_dtl.line_cd := NULL;
                END IF;
                
                IF v_dtl.iss_name IS NULL THEN
                    v_dtl.iss_cd := NULL;
                END IF;
                        
            PIPE ROW(v_dtl);        
            END LOOP;          
        END IF;
    END get_gd_retrocede_dtl; 

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.24.2013
   **  Reference By : GIACS044
   **  Remarks      : check last compute
   */
    FUNCTION check_last_compute(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
        RETURN VARCHAR2
    IS
        v_last_compute  DATE;
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        SELECT last_compute 
        INTO v_last_compute
        FROM giac_deferred_extract
       WHERE year = p_year
         AND mm   = p_mm
         AND procedure_id = p_procedure_id
         AND comp_sw = v_24th_comp; --mikel 02.26.2016 GENQA 5288
        
        IF v_last_compute IS NOT NULL THEN
            RETURN 'Y';
        ELSE
            RETURN NULL; 
        END IF;
        
    END check_last_compute;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.24.2013
   **  Reference By : GIACS044
   **  Remarks      : for straight method reference: deferred_compute (database procedure)
   */ 
    PROCEDURE deferred_compute_straight (
        p_year   NUMBER, 
        p_mm     NUMBER, 
        p_method NUMBER
    )
    IS
       v_exists  NUMBER;

    BEGIN
       v_exists := 0;
       /* Check for previous extract */
       FOR chk IN (SELECT gen_tag
                     FROM giac_deferred_extract
                    WHERE year = p_year
                      AND mm   = p_mm
                      AND procedure_id = p_method)
       LOOP
--          IF chk.gen_tag = 'Y' THEN
--              msg_alert('Previous extract for this Year and MM has already been posted.','I',true);
--          ELSE
             v_exists := 1;
             UPDATE giac_deferred_extract
                SET user_id      = USER,
                    last_compute = SYSDATE
              WHERE year = p_year
                AND mm   = p_mm
                AND procedure_id = p_method;
--          END IF;   
          EXIT;
       END LOOP;
       IF v_exists = 0 THEN null;
--           msg_alert ('You have not yet extracted data for computation.','I',true); 
       END IF;
       /* Compute for the Deferred Gross Premium */
       --for deferred premium
       FOR gross IN (SELECT gdgp.iss_cd, gdgp.line_cd, gb.prnt_branch_cd, NVL(gdgp.prem_amt,0) prem_amt,
                            NVL(gdgp.def_prem_amt,0) def_prem_amt, NVL(gdgp.prev_def_prem_amt,0) prev_def_prem_amt,
                            NVL(gdgp.def_prem_amt_diff,0) def_prem_amt_diff
                       FROM giac_deferred_gross_prem gdgp,
                            giac_branches gb
                      WHERE gdgp.year         = p_year
                        AND gdgp.mm           = p_mm
                        AND gdgp.procedure_id = p_method
                        AND gdgp.iss_cd       = gb.branch_cd)
       LOOP
            gross.def_prem_amt := gross.prem_amt * .40; --(40% for straight method)
        --for prev. deferred premium
          BEGIN
             SELECT NVL(def_prem_amt,0)
               INTO gross.prev_def_prem_amt
               FROM giac_deferred_gross_prem
              WHERE year         = (p_year - 1)
                AND mm           = p_mm
                AND procedure_id = p_method
                AND iss_cd       = gross.iss_cd
                AND line_cd      = gross.line_cd;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  gross.prev_def_prem_amt := 0;
          END;
        --for deferred difference
        gross.def_prem_amt_diff := gross.def_prem_amt - gross.prev_def_prem_amt;
         
          UPDATE giac_deferred_gross_prem
             SET prnt_branch_cd     = gross.prnt_branch_cd,
                 def_prem_amt       = gross.def_prem_amt,
                 prev_def_prem_amt  = gross.prev_def_prem_amt,
                 def_prem_amt_diff  = gross.def_prem_amt_diff,
                 user_id            = USER,              
                 last_update        = SYSDATE
           WHERE year = p_year
             AND mm   = p_mm
             AND procedure_id = p_method
             AND iss_cd = gross.iss_cd
             AND line_cd = gross.line_cd;
       END LOOP;
       /* RI PREMIUMS CEDED */
       FOR ri_prem IN (SELECT iss_cd, line_cd, NVL(dist_prem,0) dist_prem, NVL(def_dist_prem,0) def_dist_prem,
                              NVL(prev_def_dist_prem,0) prev_def_dist_prem, NVL(def_dist_prem_diff,0) def_dist_prem_diff,
                               share_type, acct_trty_type 
                       FROM giac_deferred_ri_prem_ceded
                      WHERE year = p_year
                        AND mm   = p_mm
                        AND procedure_id = p_method)
       LOOP      
         ri_prem.def_dist_prem := ri_prem.dist_prem * .40; 
          BEGIN
             SELECT NVL(def_dist_prem,0)
               INTO ri_prem.prev_def_dist_prem
               FROM giac_deferred_ri_prem_ceded
              WHERE year    = (p_year - 1)
                AND mm      = p_mm
                AND iss_cd  = ri_prem.iss_cd
                AND line_cd = ri_prem.line_cd
                AND procedure_id = p_method
                AND share_type = ri_prem.share_type
                AND acct_trty_type = ri_prem.acct_trty_type;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   ri_prem.prev_def_dist_prem := 0;
          END;
            
            ri_prem.def_dist_prem_diff := ri_prem.def_dist_prem - ri_prem.prev_def_dist_prem;  
          
          UPDATE giac_deferred_ri_prem_ceded
             SET def_dist_prem       = ri_prem.def_dist_prem,
                 prev_def_dist_prem  = ri_prem.prev_def_dist_prem,
                 def_dist_prem_diff  = ri_prem.def_dist_prem_diff,
                 user_id             = USER,              
                 last_update         = SYSDATE
           WHERE year = p_year
             AND mm   = p_mm
             AND iss_cd = ri_prem.iss_cd
             AND line_cd = ri_prem.line_cd
             AND procedure_id = p_method
             AND share_type = ri_prem.share_type
             AND acct_trty_type = ri_prem.acct_trty_type;    
       END LOOP;
       /*For Commission Income*/
       FOR comm IN (SELECT iss_cd, line_cd, NVL(comm_income,0) comm_income, NVL(def_comm_income,0) def_comm_income,
                           NVL(prev_def_comm_income,0) prev_def_comm_income, NVL(def_comm_income_diff,0) def_comm_income_diff,
                           share_type, acct_trty_type
                      FROM giac_deferred_comm_income
                     WHERE year = p_year
                       AND mm   = p_mm
                       AND procedure_id = p_method)
       LOOP
         comm.def_comm_income := comm.comm_income * .40; 
          BEGIN
             SELECT NVL(def_comm_income,0)
               INTO comm.prev_def_comm_income
               FROM giac_deferred_comm_income
              WHERE year    = (p_year - 1)
                AND mm      = p_mm
                AND iss_cd  = comm.iss_cd
                AND line_cd = comm.line_cd
                AND procedure_id = p_method
                AND share_type = comm.share_type
                AND acct_trty_type = comm.acct_trty_type;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   comm.prev_def_comm_income := 0;
          END;
         
          comm.def_comm_income_diff := comm.def_comm_income - comm.prev_def_comm_income;
          
          UPDATE giac_deferred_comm_income
             SET def_comm_income      = comm.def_comm_income,
                 prev_def_comm_income = comm.prev_def_comm_income,
                 def_comm_income_diff = comm.def_comm_income_diff,
                 user_id              = USER,              
                 last_update          = SYSDATE
           WHERE year = p_year
             AND mm   = p_mm
             AND iss_cd = comm.iss_cd
             AND line_cd = comm.line_cd
             AND procedure_id = p_method
             AND share_type = comm.share_type
             AND acct_trty_type = comm.acct_trty_type;
       END LOOP;
       /*For Commission Expense*/
       FOR expen IN (SELECT iss_cd, line_cd, NVL(comm_expense,0) comm_expense, NVL(def_comm_expense,0) def_comm_expense,
                            NVL(prev_def_comm_expense,0) prev_def_comm_expense, NVL(def_comm_expense_diff,0) def_comm_expense_diff
                      FROM giac_deferred_comm_expense
                     WHERE year = p_year
                       AND mm   = p_mm
                       AND procedure_id = p_method)
       LOOP
         expen.def_comm_expense := expen.comm_expense * .40; 
       
          BEGIN
             SELECT NVL(def_comm_expense,0)
               INTO expen.prev_def_comm_expense
               FROM giac_deferred_comm_expense
              WHERE year    = (p_year - 1)
                AND mm      = p_mm
                AND iss_cd  = expen.iss_cd
                AND line_cd = expen.line_cd
                AND procedure_id = p_method;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   expen.prev_def_comm_expense := 0;
          END;
       
          expen.def_comm_expense_diff := expen.def_comm_expense - expen.prev_def_comm_expense;
       
          UPDATE giac_deferred_comm_expense
             SET def_comm_expense      = expen.def_comm_expense,
                 prev_def_comm_expense = expen.prev_def_comm_expense,
                 def_comm_expense_diff  = expen.def_comm_expense_diff,
                 user_id               = USER,              
                 last_update          = SYSDATE
           WHERE year = p_year
             AND mm   = p_mm
             AND iss_cd = expen.iss_cd
             AND line_cd = expen.line_cd
             AND procedure_id = p_method;
       END LOOP;
    --   COMMIT; --issa (para di muna ma-save sa table agad)
    END; 
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.24.2013
   **  Reference By : GIACS044
   **  Remarks      : calls deferred_compute procedures
   */ 
    PROCEDURE call_deferred_compute(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
    IS
        v_method_proc    NUMBER;
        v_new_method    giac_parameters.param_value_v%TYPE; 
        v_switch        VARCHAR2(1) := 'N';
    BEGIN
        v_new_method  := NVL(giacp.v('UNEARNED_COMP_METHOD'), 'XXX');
        v_method_proc := giacp.n('24TH_METHOD_PROC');
        
        IF v_new_method = '1/365' THEN
            v_switch := 'Y';
        END IF;
        
        IF v_method_proc = 1 THEN
            deferred_compute(p_year, p_mm, p_procedure_id);
        ELSIF v_method_proc IN (2,3) and v_switch = 'N' THEN     
            --deferred_compute2(p_year, p_mm, p_procedure_id);
            deferred_compute3_dtl(p_year, p_mm, p_procedure_id); --mikel 02.04.2016
        ELSIF v_method_proc IN (2,3) and v_switch = 'Y' THEN 
            deferred_compute365_dtl(p_year, p_mm, p_procedure_id); 
        END IF;   
             
    END call_deferred_compute;  

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.24.2013
   **  Reference By : GIACS044
   **  Remarks      : procedure called on click of 
   */    
    PROCEDURE compute_amounts(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
    IS
        v_new_method    giac_parameters.param_value_v%TYPE; 
        v_switch        VARCHAR2(1) := 'N';
        v_last_compute  DATE;
        v_procedure_id  VARCHAR2(1);
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        v_new_method  := NVL(giacp.v('UNEARNED_COMP_METHOD'), 'XXX');

        IF v_new_method = '1/365' THEN
            v_switch := 'Y';
        END IF;
        
        SELECT last_compute,
               procedure_id 
        INTO v_last_compute,
             v_procedure_id 
        FROM giac_deferred_extract
       WHERE year = p_year
         AND mm   = p_mm
         AND procedure_id = p_procedure_id
         AND comp_sw = v_24th_comp; --mikel 02.26.2016 GENQA 5288
            
        IF v_last_compute IS NULL AND v_procedure_id = 1 THEN
            giacs044_pkg.call_deferred_compute(p_year, p_mm, p_procedure_id);
        ELSIF v_last_compute IS NULL AND v_procedure_id = 2 THEN
            giacs044_pkg.deferred_compute_straight(p_year, p_mm, p_procedure_id);
        ELSIF v_last_compute IS NULL AND v_procedure_id = 3 THEN
            IF v_switch = 'Y' THEN 
                 deferred_compute365_dtl(p_year, p_mm, p_procedure_id);
            END IF;
        END IF;
        
    END compute_amounts;   

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.28.2013
   **  Reference By : GIACS044
   **  Remarks      : called when user wants to regenerate, generated accounting entries 
   */    
    PROCEDURE cancel_acct_entries(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_msg       OUT VARCHAR2
    )
    IS
        v_24th_comp  VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        /* set tran_flag='D' for current entries in Giac_Acctrans. */
        BEGIN
            UPDATE giac_acctrans 
                 SET tran_flag = 'D'
            WHERE NVL(jv_tran_yy, tran_year)  =  p_year 
              AND NVL(jv_tran_mm, tran_month) =  p_mm 
              AND tran_class IN ('DGP','DPC','DCI','DCE','RGP','RPC','RCI','RCE')
              AND tran_flag NOT IN ('P', 'D'); 
            IF SQL%NOTFOUND THEN
                p_msg := 'No records updated in Giac_Acctrans.';
            END IF;    
        END;
        /* set gacc_tran_id=NULL in Deferred Tables */
        IF p_msg IS NULL THEN
            BEGIN
                UPDATE giac_deferred_gross_prem
                   SET gacc_tran_id = NULL
                 WHERE year         = p_year
                   AND mm           = p_mm
                   AND procedure_id = p_procedure_id
                   AND comp_sw      = v_24th_comp; --mikel 02.26.2016 GENQA 5288
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_msg := NULL; 
            END;
            
            BEGIN
                UPDATE giac_deferred_ri_prem_ceded
                   SET gacc_tran_id = NULL
                 WHERE year         = p_year
                   AND mm           = p_mm
                   AND procedure_id = p_procedure_id
                   AND comp_sw      = v_24th_comp; --mikel 02.26.2016 GENQA 5288
            EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                p_msg := NULL; 
            END;
            
            BEGIN
                UPDATE giac_deferred_comm_income
                   SET gacc_tran_id = NULL
                 WHERE year         = p_year
                   AND mm           = p_mm
                   AND procedure_id = p_procedure_id
                   AND comp_sw      = v_24th_comp; --mikel 02.26.2016 GENQA 5288
            EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                p_msg := NULL; 
            END;
            
            BEGIN
                UPDATE giac_deferred_comm_expense
                   SET gacc_tran_id = NULL
                 WHERE year         = p_year
                   AND mm           = p_mm
                   AND procedure_id = p_procedure_id
                   AND comp_sw      = v_24th_comp; --mikel 02.26.2016 GENQA 5288
            EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                p_msg := NULL; 
            END;
            /* set gen_tag = 'N' in Giac_Deferred_Extract */
            BEGIN
                UPDATE giac_deferred_extract
                   SET gen_tag  = 'N',
                       gen_date = NULL
                 WHERE year         = p_year
                   AND mm           = p_mm
                   AND procedure_id = p_procedure_id
                   AND comp_sw      = v_24th_comp; --mikel 02.26.2016 GENQA 5288
            EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                ROLLBACK;
                p_msg := 'No record found in Giac_Deferred_Extract.';
            END;    
        END IF;        
    END cancel_acct_entries;  
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.29.2013
   **  Reference By : GIACS044
   **  Remarks      : aeg_check_chart_of_accts program unit 
   */  
    PROCEDURE aeg_chk_chrt_of_accts_giacs044(
        cca_gl_acct_category    giac_acct_entries.gl_acct_category%TYPE,
        cca_gl_control_acct     giac_acct_entries.gl_control_acct%TYPE,
        cca_gl_sub_acct_1       giac_acct_entries.gl_sub_acct_1%TYPE,
        cca_gl_sub_acct_2       giac_acct_entries.gl_sub_acct_2%TYPE,
        cca_gl_sub_acct_3       giac_acct_entries.gl_sub_acct_3%TYPE,
        cca_gl_sub_acct_4       giac_acct_entries.gl_sub_acct_4%TYPE,
        cca_gl_sub_acct_5       giac_acct_entries.gl_sub_acct_5%TYPE,
        cca_gl_sub_acct_6       giac_acct_entries.gl_sub_acct_6%TYPE,
        cca_gl_sub_acct_7       giac_acct_entries.gl_sub_acct_7%TYPE,
        cca_gl_acct_id   IN OUT giac_chart_of_accts.gl_acct_id%TYPE,    
        p_msg               OUT VARCHAR2
    )
    IS
    BEGIN
       SELECT DISTINCT(gl_acct_id)
         INTO cca_gl_acct_id
         FROM giac_chart_of_accts
        WHERE gl_acct_category  = cca_gl_acct_category
          AND gl_control_acct   = cca_gl_control_acct
          AND gl_sub_acct_1     = cca_gl_sub_acct_1
          AND gl_sub_acct_2     = cca_gl_sub_acct_2
          AND gl_sub_acct_3     = cca_gl_sub_acct_3
          AND gl_sub_acct_4     = cca_gl_sub_acct_4
          AND gl_sub_acct_5     = cca_gl_sub_acct_5
          AND gl_sub_acct_6     = cca_gl_sub_acct_6
          AND gl_sub_acct_7     = cca_gl_sub_acct_7;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg := ('GL account code '||to_char(cca_gl_acct_category)
                        ||'-'||to_char(cca_gl_control_acct,'09') 
                        ||'-'||to_char(cca_gl_sub_acct_1,'09')
                        ||'-'||to_char(cca_gl_sub_acct_2,'09')
                        ||'-'||to_char(cca_gl_sub_acct_3,'09')
                        ||'-'||to_char(cca_gl_sub_acct_4,'09')
                        ||'-'||to_char(cca_gl_sub_acct_5,'09')
                        ||'-'||to_char(cca_gl_sub_acct_6,'09')
                        ||'-'||to_char(cca_gl_sub_acct_7,'09')
                        ||' does not exist in Chart of Accounts (Giac_Acctrans).');   
            raise_application_error (-20001,
                                    'Geniisys Exception#E#GL account code '||to_char(cca_gl_acct_category)
                                                            ||'-'||to_char(cca_gl_control_acct,'09') 
                                                            ||'-'||to_char(cca_gl_sub_acct_1,'09')
                                                            ||'-'||to_char(cca_gl_sub_acct_2,'09')
                                                            ||'-'||to_char(cca_gl_sub_acct_3,'09')
                                                            ||'-'||to_char(cca_gl_sub_acct_4,'09')
                                                            ||'-'||to_char(cca_gl_sub_acct_5,'09')
                                                            ||'-'||to_char(cca_gl_sub_acct_6,'09')
                                                            ||'-'||to_char(cca_gl_sub_acct_7,'09')
                                                            ||' does not exist in Chart of Accounts (Giac_Acctrans).'
                                    );                          
    END aeg_chk_chrt_of_accts_giacs044;     

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.29.2013
   **  Reference By : GIACS044
   **  Remarks      : aeg_check_level program unit
   */ 
    PROCEDURE aeg_check_level_giacs044(
        cl_level         IN NUMBER,
        cl_value         IN NUMBER,
        cl_sub_acct1 IN OUT NUMBER,
        cl_sub_acct2 IN OUT NUMBER,
        cl_sub_acct3 IN OUT NUMBER,
        cl_sub_acct4 IN OUT NUMBER,
        cl_sub_acct5 IN OUT NUMBER,
        cl_sub_acct6 IN OUT NUMBER,
        cl_sub_acct7 IN OUT NUMBER    
    )
    IS
    BEGIN
        IF cl_level = 1 THEN
            cl_sub_acct1 := cl_value;
        ELSIF cl_level = 2 THEN
            cl_sub_acct2 := cl_value;
        ELSIF cl_level = 3 THEN
            cl_sub_acct3 := cl_value;
        ELSIF cl_level = 4 THEN
            cl_sub_acct4 := cl_value;
        ELSIF cl_level = 5 THEN
            cl_sub_acct5 := cl_value;
        ELSIF cl_level = 6 THEN
            cl_sub_acct6 := cl_value;
        ELSIF cl_level = 7 THEN
            cl_sub_acct7 := cl_value;
        END IF;    
    END aeg_check_level_giacs044;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.29.2013
   **  Reference By : GIACS044
   **  Remarks      : aeg_gen_acctran_entry program unit
   */ 
    PROCEDURE aeg_gen_acctran_entry_giacs044(
        p_tran_id         OUT NUMBER,
        p_tran_class      IN  VARCHAR2,
        p_gfun_fund_cd    IN  VARCHAR2,
        p_gibr_branch_cd  IN  VARCHAR2,
        p_tran_date       IN  VARCHAR2,
        p_year            IN  giac_deferred_extract.year%TYPE,
        p_mm              IN  giac_deferred_extract.mm%TYPE,
        p_user_id         IN  giac_users.user_id%TYPE,
        p_msg             OUT VARCHAR2
    )
    IS
        v_tran_date        giac_acctrans.tran_date%TYPE;
        v_tran_flag        giac_acctrans.tran_flag%TYPE;
        v_tran_year        giac_acctrans.tran_year%TYPE;
        v_tran_month    giac_acctrans.tran_month%TYPE;
        v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
        v_tran_class    giac_acctrans.tran_class%TYPE;
        v_tran_class_no giac_acctrans.tran_class_no%TYPE;
        v_month         VARCHAR2(20);
        v_class         VARCHAR2(100);
        v_particulars   giac_acctrans.particulars%TYPE;
        v_tran_date2     DATE := TO_DATE(p_tran_date,'MM-DD-YYYY'); 
    BEGIN
        /* Generate Tran_Id */
        BEGIN
            SELECT acctran_tran_id_s.NEXTVAL 
              INTO p_tran_id
              FROM dual;
        EXCEPTION
        WHEN OTHERS THEN
            p_msg := 'No Sequence for Tran_Id was found.';
            raise_application_error (-20001,
                                    'Geniisys Exception#E#No Sequence for Tran_Id was found.'
                                    );             
        END;

        IF p_tran_class IN ('DGP','DPC','DCI','DCE') THEN
            v_tran_date    := v_tran_date2;
        ELSE        
            v_tran_date    := last_day(v_tran_date2) + 1;
        END IF;
        
        v_tran_flag        := 'C';
        v_tran_year        := p_year; 
        v_tran_month    := p_mm;   
        v_tran_seq_no   := giac_sequence_generation(p_gfun_fund_cd, p_gibr_branch_cd, 'TRAN_SEQ_NO', v_tran_year, v_tran_month);
        v_tran_class    := p_tran_class;
        v_tran_class_no := giac_sequence_generation(p_gfun_fund_cd, p_gibr_branch_cd, p_tran_class, v_tran_year, v_tran_month);
       
        BEGIN
            SELECT decode(v_tran_month   ,
                            1,'January'  , 2 ,'February', 3 ,'March'   , 4 ,'April',
                            5,'May'      , 6 ,'June'    , 7 ,'July'    , 8 ,'August',
                            9,'September', 10,'October' , 11,'November', 12,'December')
              INTO v_month
              FROM dual;                                      
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_month := NULL;
        END;         

        BEGIN
            SELECT rv_meaning
              INTO v_class
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_ACCTRANS.TRAN_CLASS'
               AND rv_low_value = v_tran_class;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg := 'No meaning found in CG_REF_CODES.';
            raise_application_error (-20001,
                                    'Geniisys Exception#E#No meaning found in CG_REF_CODES.'
                                    );             
            v_class := NULL;
        END;          

        IF (v_month IS NOT NULL AND v_class IS NOT NULL) THEN
            v_particulars := 'Entries for '||v_class||' for the month of '||v_month||' '||v_tran_year;
        ELSE
            v_particulars := NULL;
        END IF;      
        /* Insert Record in Giac_Acctrans */
        INSERT INTO giac_acctrans
                    (tran_id                    , gfun_fund_cd             , gibr_branch_cd  , tran_date   , tran_flag, 
                     tran_year                  , tran_month               , tran_seq_no     , tran_class  , tran_class_no,
                     particulars                , user_id                  , last_update     , jv_tran_yy  , jv_tran_mm)
             VALUES (p_tran_id                  , p_gfun_fund_cd           , p_gibr_branch_cd, v_tran_date , v_tran_flag,
                     TO_CHAR(v_tran_date,'YYYY'), TO_CHAR(v_tran_date,'MM'), v_tran_seq_no   , p_tran_class, v_tran_class_no,
                     v_particulars              , p_user_id                , SYSDATE         , v_tran_year , v_tran_month);   
                         
    END aeg_gen_acctran_entry_giacs044;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.29.2013
   **  Reference By : GIACS044
   **  Remarks      : aeg_gen_acct_entries program unit
   */ 
    PROCEDURE aeg_gen_acct_entries_giacs044(
        p_tran_id        IN  NUMBER,
        p_fund_cd        IN  VARCHAR2,
        p_branch_cd      IN  VARCHAR2,
        p_line_cd        IN  VARCHAR2,
        p_sl_cd          IN  NUMBER,           
        p_amount         IN  NUMBER,
        p_item_no        IN  NUMBER,
        p_tran_flag      IN  VARCHAR2,
        p_dr_cr_flag     IN  VARCHAR2,
        p_acct_trty_type IN  NUMBER,
        p_module_id      IN  VARCHAR2,
        p_user_id        IN  giac_users.user_id%TYPE,
        p_msg            OUT VARCHAR2
    )
    IS
        ws_gl_acct_category              giac_acct_entries.gl_acct_category%TYPE;
        ws_gl_control_acct               giac_acct_entries.gl_control_acct%TYPE;
        ws_gl_sub_acct_1                 giac_acct_entries.gl_sub_acct_1%TYPE;
        ws_gl_sub_acct_2                 giac_acct_entries.gl_sub_acct_2%TYPE;
        ws_gl_sub_acct_3                 giac_acct_entries.gl_sub_acct_3%TYPE;
        ws_gl_sub_acct_4                 giac_acct_entries.gl_sub_acct_4%TYPE;
        ws_gl_sub_acct_5                 giac_acct_entries.gl_sub_acct_5%TYPE;
        ws_gl_sub_acct_6                 giac_acct_entries.gl_sub_acct_6%TYPE;
        ws_gl_sub_acct_7                 giac_acct_entries.gl_sub_acct_7%TYPE;
        ws_pol_type_tag                  giac_module_entries.pol_type_tag%TYPE;
        ws_intm_type_level               giac_module_entries.intm_type_level%TYPE;
        ws_old_new_acct_level            giac_module_entries.old_new_acct_level%TYPE;
        ws_line_dep_level                giac_module_entries.line_dependency_level%TYPE;
        ws_dr_cr_tag                     giac_module_entries.dr_cr_tag%TYPE;
        ws_acct_intm_cd                  giis_intm_type.acct_intm_cd%TYPE;
        ws_line_cd                       giis_line.line_cd%TYPE;
        ws_old_acct_cd                   giac_acct_entries.gl_sub_acct_2%TYPE;
        ws_new_acct_cd                   giac_acct_entries.gl_sub_acct_2%TYPE;
        ws_generation_type               giac_modules.generation_type%TYPE;
        ws_debit_amount                  giac_acct_entries.debit_amt%TYPE;
        ws_credit_amount                 giac_acct_entries.credit_amt%TYPE;
        ws_gl_acct_id                    giac_acct_entries.gl_acct_id%TYPE;
        ws_trty_type_level               giac_module_entries.ca_treaty_type_level%TYPE;
        ws_sl_type_cd                     giac_module_entries.sl_type_cd%TYPE;
        v_module_id                      giis_modules.module_id%TYPE;
        v_module_name                    giac_modules.module_name%TYPE;
    BEGIN
        /* Get Module_Id */
        BEGIN
            SELECT module_id, module_name
              INTO v_module_id,
                   v_module_name
              FROM giac_modules
             WHERE module_name LIKE p_module_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg := 'No Module_Id found in Giac_Modules.';
            raise_application_error (-20001,
                                    'Geniisys Exception#E#No Module_Id found in Giac_Modules.'
                                    );            
        END;    
        /* Get the corresponding GL in module entries for a given p_module_id and p_item_no */
        BEGIN
            SELECT gl_acct_category           , gl_control_acct,
                   gl_sub_acct_1              , gl_sub_acct_2  ,
                   gl_sub_acct_3              , gl_sub_acct_4  ,
                   gl_sub_acct_5              , gl_sub_acct_6  ,
                   gl_sub_acct_7              , pol_type_tag   ,
                   nvl(intm_type_level,0)     , nvl(old_new_acct_level,0),
                   dr_cr_tag                  , nvl(line_dependency_level,0),
                   nvl(ca_treaty_type_level,0), sl_type_cd  
             INTO ws_gl_acct_category         , ws_gl_control_acct,
                  ws_gl_sub_acct_1            , ws_gl_sub_acct_2  ,
                  ws_gl_sub_acct_3            , ws_gl_sub_acct_4  ,
                  ws_gl_sub_acct_5            , ws_gl_sub_acct_6  ,
                  ws_gl_sub_acct_7            , ws_pol_type_tag   ,
                  ws_intm_type_level          , ws_old_new_acct_level,
                  ws_dr_cr_tag                , ws_line_dep_level,
                  ws_trty_type_level          , ws_sl_type_cd
             FROM giac_module_entries
            WHERE module_id = v_module_id
              AND item_no   = p_item_no;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg := 'No data found in giac_module_entries.';
            raise_application_error (-20001,
                                    'Geniisys Exception#E#No data found in giac_module_entries.'
                                    );             
        END;
        /* Get Generation_Type in Giac_Modules */   
        BEGIN
            SELECT generation_type
              INTO ws_generation_type
              FROM giac_modules
             WHERE module_name = v_module_name;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_msg := 'No data found in Giac_Modules.';
            raise_application_error (-20001,
                                    'Geniisys Exception#E#No data found in Giac_Modules.'
                                    );            
        END;
      /**************************************************************************
      *                                                                         *
      * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the line number.                         *
      *                                                                         *
      **************************************************************************/
        IF ws_line_dep_level != 0 THEN      
        BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = p_line_cd;
        EXCEPTION
        WHEN no_data_found THEN
            p_msg := 'No data found in giis_line.';  
            raise_application_error (-20001,
                                    'Geniisys Exception#E#No data found in giis_line.'
                                    );                   
        END;
            giacs044_pkg.aeg_check_level_giacs044(ws_line_dep_level, ws_line_cd      , ws_gl_sub_acct_1,
                                                  ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                                  ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
        END IF;
      /**************************************************************************
      *                                                                         *
      * Validate the CA_TREATY_TYPE_LEVEL value which indicates the segment of  *
      * the GL account code that holds the treaty type code.                    *
      *                                                                         *
      **************************************************************************/
        IF ws_trty_type_level != 0 THEN
            --mikel 10.22.2015 AFPGEN 20768; replaced ws_line_dep_level to ws_trty_type_level
            --robert 01.27.2016 SR 5262 ; replaced ws_line_cd to p_acct_trty_type
            giacs044_pkg.aeg_check_level_giacs044(/*ws_line_dep_level*/ ws_trty_type_level, /*ws_line_cd*/ p_acct_trty_type      , ws_gl_sub_acct_1,
                                                    ws_gl_sub_acct_2 , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                                                    ws_gl_sub_acct_5 , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
        END IF;  

        giacs044_pkg.aeg_chk_chrt_of_accts_giacs044(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1, ws_gl_sub_acct_2, 
                                                    ws_gl_sub_acct_3   , ws_gl_sub_acct_4  , ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                                                    ws_gl_sub_acct_7   , ws_gl_acct_id     , p_msg);
      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
        IF p_dr_cr_flag = 'Y' THEN
            IF ws_dr_cr_tag = 'D' THEN
                IF p_amount > 0 THEN
                    ws_debit_amount  := ABS(p_amount);
                    ws_credit_amount := 0;
                ELSE
                    ws_debit_amount  := 0;
                    ws_credit_amount := ABS(p_amount);
                END IF;
            ELSE
                IF p_amount > 0 THEN
                    ws_debit_amount  := 0;
                    ws_credit_amount := ABS(p_amount);
                ELSE
                    ws_debit_amount  := ABS(p_amount);
                    ws_credit_amount := 0;
                END IF;
            END IF;
        ELSE
            IF p_amount > 0 THEN
                ws_debit_amount  := ABS(p_amount);
                ws_credit_amount := 0;
            ELSE
                ws_debit_amount  := 0;
                ws_credit_amount := ABS(p_amount);
            END IF;
        END IF;
   
        INSERT INTO giac_acct_entries 
                    (gacc_tran_id      , gacc_gfun_fund_cd, gacc_gibr_branch_cd, gl_acct_id      , gl_acct_category,
                     gl_control_acct   , gl_sub_acct_1    , gl_sub_acct_2      , gl_sub_acct_3   , gl_sub_acct_4   ,
                     gl_sub_acct_5     , gl_sub_acct_6    , gl_sub_acct_7      , sl_type_cd      , sl_cd           ,        
                     debit_amt         , credit_amt       , generation_type    , user_id         , last_update)
              VALUES(p_tran_id         , p_fund_cd        , p_branch_cd        , ws_gl_acct_id   , ws_gl_acct_category, 
                     ws_gl_control_acct, ws_gl_sub_acct_1 , ws_gl_sub_acct_2   , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                     ws_gl_sub_acct_5  , ws_gl_sub_acct_6 , ws_gl_sub_acct_7   , ws_sl_type_cd   , p_sl_cd,
                     ws_debit_amount   , ws_credit_amount , ws_generation_type , p_user_id       , SYSDATE);
    END aeg_gen_acct_entries_giacs044;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.30.2013
   **  Reference By : GIACS044
   **  Remarks      : for the reversal of posted 24th method transactions
   */     
    PROCEDURE reverse_posted_trans(
        p_year           giac_deferred_extract.year%TYPE,
        p_mm             giac_deferred_extract.mm%TYPE,
        p_tran_date  IN  VARCHAR2,
        p_user_id    IN  giac_users.user_id%TYPE,       
        p_msg        OUT VARCHAR2
    )
    IS
        v_rev_tran_id   giac_acctrans.tran_id%TYPE;
        v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
        v_tran_class_no giac_acctrans.tran_class_no%TYPE;
        v_tran_date     DATE := TO_DATE(p_tran_date,'MM-DD-YYYY');
    BEGIN
        p_msg := 'Please wait initializing process...';
        FOR t1 IN(SELECT 'D' tran, tran_id, tran_date, gfun_fund_cd, gibr_branch_cd
                    FROM giac_acctrans
                   WHERE tran_year = p_year
                     AND tran_month = p_mm
                     AND tran_class IN ('DGP','DPC','DCI','DCE')   -- deferred take-ups
                     AND tran_flag  = 'P'
                 UNION     
                  SELECT 'R' tran, tran_id, tran_date, gfun_fund_cd, gibr_branch_cd
                    FROM giac_acctrans
                   WHERE tran_year = DECODE(p_mm, 12, p_year + 1, p_year)
                     AND tran_month = DECODE(p_mm, 12, 1, p_mm + 1)
                     AND tran_class IN ('RGP','RPC','RCI','RCE')    -- reversal of deferred take-ups
                     AND tran_flag  = 'P')
        LOOP
            BEGIN
                SELECT acctran_tran_id_s.nextval
                  INTO v_rev_tran_id
                  FROM dual;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_msg := 'ACCTRAN_TRAN_ID sequence not found.';
            END;
            
            v_tran_seq_no := Giac_Sequence_Generation(t1.gfun_fund_cd, t1.gibr_branch_cd, 'ACCTRAN_TRAN_SEQ_NO',
                                                      TO_CHAR(v_tran_date,'YYYY'), TO_CHAR(v_tran_date,'MM'));
            IF t1.tran = 'D' THEN
                v_tran_class_no := Giac_Sequence_Generation(t1.gfun_fund_cd, t1.gibr_branch_cd, 'RPD', 0, 0);
            
                INSERT INTO giac_acctrans (tran_id                    , gfun_fund_cd             , gibr_branch_cd, 
                                           tran_year                  , tran_month               , tran_seq_no,
                                           tran_date                  , tran_flag                , tran_class,     
                                           tran_class_no              , 
                                           particulars                ,  
                                           user_id                    , last_update)
                                   VALUES (v_rev_tran_id              , t1.gfun_fund_cd          , t1.gibr_branch_cd, 
                                           TO_CHAR(v_tran_date,'YYYY'), TO_CHAR(v_tran_date,'MM'), v_tran_seq_no,
                                           v_tran_date                , 'C'                      , 'RPD', 
                                           v_tran_class_no,                  
                                           'Reversing entry for '||TO_CHAR(t1.tran_date,'fmMonth YYYY')||'  '||Get_Ref_No(t1.tran_id), 
                                           p_user_id                  , SYSDATE);
                                            
            ELSIF t1.tran = 'R' THEN
                v_tran_class_no := Giac_Sequence_Generation(t1.gfun_fund_cd, t1.gibr_branch_cd, 'RPR', 0, 0);
            
                INSERT INTO giac_acctrans (tran_id                    , gfun_fund_cd            , gibr_branch_cd, 
                                           tran_year                  , tran_month              , tran_seq_no,
                                           tran_date                  , tran_flag               , tran_class,     
                                           tran_class_no              , 
                                           particulars                ,  
                                           user_id                    , last_update)
                                   VALUES (v_rev_tran_id              , t1.gfun_fund_cd          , t1.gibr_branch_cd, 
                                           TO_CHAR(v_tran_date,'YYYY'), TO_CHAR(v_tran_date,'MM'), v_tran_seq_no,
                                           v_tran_date                , 'C'                      , 'RPR', 
                                           v_tran_class_no            ,                  
                                           'Reversing entry for '||TO_CHAR(t1.tran_date,'fmMonth YYYY')||'  '||Get_Ref_No(t1.tran_id), 
                                           p_user_id                  , SYSDATE);       

            END IF;                                      
            
            INSERT INTO giac_reversals (gacc_tran_id, reversing_tran_id, rev_corr_tag)
                                VALUES (t1.tran_id  , v_rev_tran_id    , 'R');
            /* accounting entries of old tran_id */
            FOR a1 IN (SELECT gacc_gfun_fund_cd, gacc_gibr_branch_cd, acct_entry_id,
                              gl_acct_id       , gl_acct_category   , gl_control_acct, 
                              gl_sub_acct_1    , gl_sub_acct_2      , gl_sub_acct_3,
                              gl_sub_acct_4    , gl_sub_acct_5      , gl_sub_acct_6, 
                              gl_sub_acct_7    , debit_amt          , credit_amt,
                              generation_type  , sl_type_cd         , sl_cd, 
                              sl_source_cd   
                         FROM giac_acct_entries
                        WHERE gacc_tran_id = t1.tran_id)
            LOOP
            INSERT INTO giac_acct_entries (gacc_tran_id      , gacc_gfun_fund_cd   , gacc_gibr_branch_cd,
                                           acct_entry_id     , gl_acct_id          , gl_acct_category,
                                           gl_control_acct   , gl_sub_acct_1       , gl_sub_acct_2,
                                           gl_sub_acct_3     , gl_sub_acct_4       , gl_sub_acct_5,
                                           gl_sub_acct_6     , gl_sub_acct_7       ,                
                                           debit_amt         , credit_amt          , generation_type,
                                           sl_type_cd        , sl_cd               , sl_source_cd,                 
                                           user_id           , last_update)
                                   VALUES (v_rev_tran_id     , a1.gacc_gfun_fund_cd, a1.gacc_gibr_branch_cd,
                                           a1.acct_entry_id  , a1.gl_acct_id       , a1.gl_acct_category,
                                           a1.gl_control_acct, a1.gl_sub_acct_1    , a1.gl_sub_acct_2,
                                           a1.gl_sub_acct_3  , a1.gl_sub_acct_4    , a1.gl_sub_acct_5,
                                           a1.gl_sub_acct_6  , a1.gl_sub_acct_7    ,     
                                           a1.credit_amt     , a1.debit_amt        , a1.generation_type,
                                           a1.sl_type_cd     , a1.sl_cd            , a1.sl_source_cd,      
                                           p_user_id         , SYSDATE);

            END LOOP;
        END LOOP;
    END reverse_posted_trans;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.30.2013
   **  Reference By : GIACS044
   **  Remarks      : This procedure is used if the parameter 24TH_METHOD_PROC in giac_parameters has a value of:
   **                  1 - annual computation;   2 - monthly computation, additional take-up;    3 - monthly computation, reversal the following month
   */     
    PROCEDURE gen_acct_entries_gross(
        p_year         IN  giac_deferred_extract.year%TYPE,
        p_mm           IN  giac_deferred_extract.mm%TYPE,
        p_tran_date    IN  VARCHAR2,        
        p_user_id      IN  giac_users.user_id%TYPE,         
        p_procedure_id IN  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id    IN  VARCHAR2,
        p_msg          OUT VARCHAR2                
    )
    IS
        v_cnt           NUMBER;
        v_tran_id       giac_acctrans.tran_id%TYPE;
        v_rev_tran_id     giac_acctrans.tran_id%TYPE;
        v_item_no1      NUMBER;
        v_item_no2      NUMBER;
        v_item_no3      NUMBER;
        v_item_no4        NUMBER;
        v_item_no5        NUMBER;
        v_item_no6        NUMBER;  
        v_gfun_fund_cd  giac_acctrans.gfun_fund_cd%TYPE;
        v_ri_iss_cd1    giac_parameters.param_value_v%TYPE;
        v_ri_iss_cd2    giac_parameters.param_value_v%TYPE;
        v_module_id     giac_modules.module_id%TYPE;    
        v_method_proc    NUMBER;
        v_tran_date     DATE := TO_DATE(p_tran_date,'MM-DD-YYYY');
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        v_method_proc := giacp.n('24TH_METHOD_PROC');
    
    /* Set tran_flag='D' for previously created accounting entries */
            FOR chk IN (SELECT gen_tag
                          FROM giac_deferred_extract
                         WHERE year = p_year
                           AND mm   = p_mm
                           AND procedure_id = p_procedure_id
                           AND gen_tag = 'Y'
                           AND comp_sw = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                BEGIN 
                    UPDATE giac_acctrans
                       SET tran_flag = 'D'
                     WHERE NVL(jv_tran_mm, tran_month) = p_mm   
                       AND NVL(jv_tran_yy, tran_year)  = p_year 
                       AND tran_flag NOT IN ('P', 'D') 
                       AND tran_class IN ('DGP','DPC','DCI','DCE');
                EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    p_msg := 'No accounting entries were found in previous generation.';
                END;
            EXIT;
            END LOOP;
            /* Get Module_Id */
            BEGIN
                SELECT module_id
                  INTO v_module_id
                  FROM giac_modules
                 WHERE module_name LIKE p_module_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_msg := 'No Module_Id found in Giac_Modules.';
            END;
            /* Get Fund_Cd */
            BEGIN
                v_gfun_fund_cd := giacp.v('FUND_CD');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving Fund_Cd.';
            END;

            BEGIN
                v_ri_iss_cd1 := NVL(giisp.v('ISS_CD_RI'),'--');
                v_ri_iss_cd2 := NVL(giisp.v('ISS_CD_RV'),'--');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving ISS_CD_RI/ISS_CD_RV.';
            END;        
        IF v_method_proc IN (1,2) THEN 
        /*for annual computation and for monthly computation, additional take up
        **NOTE: same statements were used for annual and monthly,additional take-up 
        **As per fmb: 01.29.2013
        */
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Gross Premiums "DGP" */
            FOR gross IN (SELECT NVL(prnt_branch_cd, iss_cd) prnt_branch_cd,
                                 SUM(NVL(def_prem_amt_diff,0)) def_prem_amt_diff
                            FROM giac_deferred_gross_prem
                           WHERE year         = p_year
                             AND mm           = p_mm
                             AND procedure_id = p_procedure_id
                             AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                        GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF gross.def_prem_amt_diff <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF gross.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                        v_item_no1 := 4; 
                        v_item_no2 := 5; 
                        v_item_no3 := 6; 
                    ELSE
                        v_item_no1 := 1;
                        v_item_no2 := 2;
                        v_item_no3 := 3;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DGP', v_gfun_fund_cd, gross.prnt_branch_cd,
                                                                v_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry1 IN (SELECT line_cd, def_prem_amt_diff
                                     FROM giac_deferred_gross_prem
                                    WHERE year         = p_year
                                      AND mm           = p_mm
                                      AND procedure_id = p_procedure_id
                                      AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                      AND NVL(prnt_branch_cd, iss_cd) = gross.prnt_branch_cd)
                    LOOP
                        IF entry1.def_prem_amt_diff <> 0 THEN
                            IF entry1.def_prem_amt_diff > 0 THEN    
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           gross.prnt_branch_cd,
                                                                           entry1.line_cd,
                                                                           NULL,
                                                                           entry1.def_prem_amt_diff,
                                                                           v_item_no1,
                                                                           'DGP',
                                                                           'N', -- used to disable the use of the default DC_CR_TAG 
                                                                           0,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                            ELSE
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           gross.prnt_branch_cd,
                                                                           entry1.line_cd,
                                                                           NULL,
                                                                           entry1.def_prem_amt_diff,
                                                                           v_item_no3,
                                                                           'DGP',
                                                                           'N',
                                                                           0,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                            END IF;
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       gross.prnt_branch_cd,
                                                                       entry1.line_cd,
                                                                       NULL,
                                                                       entry1.def_prem_amt_diff,
                                                                       v_item_no2,
                                                                       'DGP',
                                                                       'Y',
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                        END IF;
                    END LOOP; 
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_gross_prem
                       SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = gross.prnt_branch_cd;                  
                END IF;
            END LOOP;  -- end of annual computation and monthly computation, additional take-up for gross  
        ELSIF v_method_proc = 3 THEN    
        /*for monthly computation, reversal the following month*/
            /* Set tran_flag='D' for previously created accounting entries */
            FOR chk IN (SELECT gen_tag
                          FROM giac_deferred_extract
                         WHERE year        = p_year
                          AND mm           = p_mm
                          AND procedure_id = p_procedure_id
                          AND gen_tag      = 'Y' 
                          AND comp_sw      = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                BEGIN 
                    UPDATE giac_acctrans
                       SET tran_flag = 'D'
                     WHERE NVL(jv_tran_mm, tran_month) = p_mm   
                       AND NVL(jv_tran_yy, tran_year)  = p_year  
                       AND tran_flag NOT IN ('P', 'D') 
                       AND tran_class IN ('DGP','DPC','DCI','DCE',
                                           'RGP','RPC','RCI','RCE');

                    IF SQL%NOTFOUND THEN
                        p_msg := 'No accounting entries were found in previous generation.';
                    END IF;    
                END;
            EXIT;
            END LOOP;
            /* Get Module_Id */
            BEGIN
                SELECT module_id
                  INTO v_module_id
                  FROM giac_modules
                 WHERE module_name LIKE p_module_id;
            EXCEPTION
              WHEN no_data_found THEN
                p_msg := 'No Module_Id found in Giac_Modules.'; 
            END;
            /* Get Fund_Cd */
            BEGIN
                v_gfun_fund_cd := giacp.v('FUND_CD');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving Fund_Cd.';
            END;

            BEGIN
                v_ri_iss_cd1 := nvl(giisp.v('ISS_CD_RI'),'--');
                v_ri_iss_cd2 := nvl(giisp.v('ISS_CD_RV'),'--');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving ISS_CD_RI/ISS_CD_RV.';
            END;
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Gross Premiums "DGP" */
            FOR gross IN (SELECT nvl(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(nvl(def_prem_amt,0)) def_prem_amt
                            FROM giac_deferred_gross_prem
                            WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                         GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP        
                v_cnt := v_cnt + 1;
                IF gross.def_prem_amt <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF gross.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                        v_item_no1 := 4;
                        v_item_no2 := 5;
                        v_item_no3 := 6;
                    ELSE
                        v_item_no1 := 1;
                        v_item_no2 := 2;
                        v_item_no3 := 3;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DGP', v_gfun_fund_cd, gross.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate reversing record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_rev_tran_id, 'RGP', v_gfun_fund_cd, gross.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry1 IN (SELECT line_cd, def_prem_amt
                                 FROM giac_deferred_gross_prem
                                   WHERE year                          = p_year
                                     AND mm                          = p_mm
                                     AND procedure_id                = p_procedure_id
                                     AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                     AND nvl(prnt_branch_cd, iss_cd) = gross.prnt_branch_cd)
                    LOOP
                        IF entry1.def_prem_amt <> 0 THEN
                            IF entry1.def_prem_amt > 0 THEN    
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id, 
                                                                           v_gfun_fund_cd,
                                                                           gross.prnt_branch_cd,
                                                                           entry1.line_cd,
                                                                           NULL,
                                                                           entry1.def_prem_amt,
                                                                           v_item_no1,
                                                                           'DGP',
                                                                           'N', -- used to disable the use of the default DC_CR_TAG
                                                                           0,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                                --reversal
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           gross.prnt_branch_cd,
                                                                           entry1.line_cd,
                                                                           NULL,
                                                                           (-1) * entry1.def_prem_amt,
                                                                           v_item_no1,
                                                                           'RGP',
                                                                           'N', -- used to disable the use of the default DC_CR_TAG
                                                                           0,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);                                
                            ELSE
                                  giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           gross.prnt_branch_cd,
                                                                           entry1.line_cd,
                                                                           NULL,
                                                                           entry1.def_prem_amt,
                                                                           v_item_no3,
                                                                           'DGP',
                                                                           'N',
                                                                           0,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                                --reversal
                                  giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           gross.prnt_branch_cd,
                                                                           entry1.line_cd,
                                                                           NULL,
                                                                           (-1) * entry1.def_prem_amt,
                                                                           v_item_no3,
                                                                           'RGP',
                                                                           'N',
                                                                           0,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);                                
                            END IF;
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                         v_gfun_fund_cd,
                                                                       gross.prnt_branch_cd,
                                                                       entry1.line_cd,
                                                                       NULL,
                                                                       entry1.def_prem_amt,
                                                                       v_item_no2,
                                                                       'DGP',
                                                                       'Y',
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                            --reversal
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       gross.prnt_branch_cd,
                                                                       entry1.line_cd,
                                                                       NULL,
                                                                       (-1) * entry1.def_prem_amt,
                                                                       v_item_no2,
                                                                       'RGP',
                                                                       'Y',
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);                            
                          END IF;
                    END LOOP;
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_gross_prem
                       SET gacc_tran_id = v_tran_id
                     WHERE year         = p_year
                       AND mm           = p_mm
                       AND procedure_id = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND nvl(prnt_branch_cd, iss_cd) = gross.prnt_branch_cd;
                END IF;
            END LOOP;  -- end of monthly computation, reversal the following month for gross
            p_msg := 'Processing Gross Premiums...record(s): '||TO_CHAR(v_cnt);
        END IF;     
    END gen_acct_entries_gross;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.30.2013
   **  Reference By : GIACS044
   **  Remarks      : This procedure is used if the parameter 24TH_METHOD_PROC in giac_parameters has a value of:
   **                  1 - annual computation;   2 - monthly computation, additional take-up;    3 - monthly computation, reversal the following month
   **                  For Deferred RI Premium Ceded
   */ 
    PROCEDURE gen_acct_entries_ri_prem(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_tran_date     VARCHAR2,        
        p_user_id       giac_users.user_id%TYPE,         
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id     VARCHAR2,
        p_msg       OUT VARCHAR2        
    )
    IS
        v_cnt           NUMBER;
        v_tran_id       giac_acctrans.tran_id%TYPE;
        v_rev_tran_id     giac_acctrans.tran_id%TYPE;
        v_item_no1      NUMBER;
        v_item_no2      NUMBER;
        v_item_no3      NUMBER;
        v_item_no4        NUMBER;
        v_item_no5        NUMBER;
        v_item_no6        NUMBER;  
        v_gfun_fund_cd  giac_acctrans.gfun_fund_cd%TYPE;
        v_ri_iss_cd1    giac_parameters.param_value_v%TYPE;
        v_ri_iss_cd2    giac_parameters.param_value_v%TYPE;
        v_module_id     giac_modules.module_id%TYPE;    
        v_method_proc    NUMBER;
        v_tran_date     DATE := TO_DATE(p_tran_date,'MM-DD-YYYY');
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        v_method_proc := giacp.n('24TH_METHOD_PROC');
    /* Set tran_flag='D' for previously created accounting entries */
            FOR chk IN (SELECT gen_tag
                          FROM giac_deferred_extract
                         WHERE year = p_year
                           AND mm   = p_mm
                           AND procedure_id = p_procedure_id
                           AND gen_tag = 'Y'
                           AND comp_sw      = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                BEGIN 
                    UPDATE giac_acctrans
                       SET tran_flag = 'D'
                     WHERE NVL(jv_tran_mm, tran_month) = p_mm   
                       AND NVL(jv_tran_yy, tran_year)  = p_year 
                       AND tran_flag NOT IN ('P', 'D') 
                       AND tran_class IN ('DGP','DPC','DCI','DCE');
                EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    p_msg := 'No accounting entries were found in previous generation.';
                END;
            EXIT;
            END LOOP;
            /* Get Module_Id */
            BEGIN
                SELECT module_id
                  INTO v_module_id
                  FROM giac_modules
                 WHERE module_name LIKE p_module_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_msg := 'No Module_Id found in Giac_Modules.';
            END;
            /* Get Fund_Cd */
            BEGIN
                v_gfun_fund_cd := giacp.v('FUND_CD');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving Fund_Cd.';
            END;

            BEGIN
                v_ri_iss_cd1 := NVL(giisp.v('ISS_CD_RI'),'--');
                v_ri_iss_cd2 := NVL(giisp.v('ISS_CD_RV'),'--');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving ISS_CD_RI/ISS_CD_RV.';
            END;        
        IF v_method_proc IN (1,2) THEN
        /*for annual computation and for monthly computation, additional take up
        **NOTE: same statements were used for annual and monthly,additional take-up 
        **As per fmb: 01.29.2013
        */
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred RI Premium Ceded "DPC" */
            FOR ri_prem IN(SELECT NVL(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(NVL(def_dist_prem_diff,0)) def_dist_prem_diff            
                             FROM giac_deferred_ri_prem_ceded 
                            WHERE year         = p_year
                              AND mm           = p_mm
                              AND procedure_id = p_procedure_id
                              AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                         GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF ri_prem.def_dist_prem_diff <> 0 THEN -- do not generate entry for 0 amounts
                
                /* The following IF statement is to determine what item_no to use
                ** Assumed Business or Direct Business respectively
                */             
                    IF ri_prem.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                        v_item_no1 := 13;
                        v_item_no2 := 15;
                        v_item_no3 := 17;
                        v_item_no4 := 14; 
                        v_item_no5 := 16;
                        v_item_no6 := 18;
                    ELSE
                        v_item_no1 := 26;
                        v_item_no2 := 28;
                        v_item_no3 := 30;
                        v_item_no4 := 27;
                        v_item_no5 := 29;
                        v_item_no6 := 31;      
                    END IF;        
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DPC', v_gfun_fund_cd, ri_prem.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm,  p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry2 IN ( SELECT line_cd, def_dist_prem_diff, acct_trty_type, share_type
                                      FROM giac_deferred_ri_prem_ceded
                                     WHERE year         = p_year
                                       AND mm           = p_mm
                                       AND procedure_id = p_procedure_id
                                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                       AND NVL(prnt_branch_cd, iss_cd) = ri_prem.prnt_branch_cd)
                    LOOP
                        IF entry2.def_dist_prem_diff <> 0 THEN
                            IF entry2.share_type = 2 THEN    
                                IF entry2.def_dist_prem_diff > 0 THEN
                                    --increase
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem_diff,
                                                                               v_item_no1,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                ELSE
                                    --decrease                        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem_diff,
                                                                               v_item_no3,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                END IF;
                                --deferred
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           ri_prem.prnt_branch_cd,
                                                                           entry2.line_cd,
                                                                           NULL,
                                                                           entry2.def_dist_prem_diff,
                                                                           v_item_no2,
                                                                           'DPC',
                                                                           'Y',
                                                                           entry2.acct_trty_type,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                            ELSIF entry2.share_type = 3 THEN
                                IF entry2.def_dist_prem_diff > 0 THEN
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem_diff,
                                                                               v_item_no4,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                ELSE                        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem_diff,
                                                                               v_item_no6,
                                                                               'DPC',
                                                                               'Y', --'N', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                END IF;
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           ri_prem.prnt_branch_cd,
                                                                           entry2.line_cd,
                                                                           NULL,
                                                                           entry2.def_dist_prem_diff,
                                                                           v_item_no5,
                                                                           'DPC',
                                                                           'Y',
                                                                           entry2.acct_trty_type,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);        
                            END IF;
                        END IF;                        
                    END LOOP; 
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_ri_prem_ceded
                       SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = ri_prem.prnt_branch_cd; 
                END IF;
            END LOOP;  --end of annual computation and monthly computation, additional take-up for gross
        ELSIF v_method_proc = 3 THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred RI Premium Ceded "DPC" */
            FOR ri_prem IN (SELECT nvl(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(nvl(def_dist_prem,0)) def_dist_prem
                              FROM giac_deferred_ri_prem_ceded
                             WHERE year         = p_year
                               AND mm           = p_mm
                               AND procedure_id = p_procedure_id
                               AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                          GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF ri_prem.def_dist_prem <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */             
                    IF ri_prem.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                        v_item_no1 := 13; 
                        v_item_no2 := 15; 
                        v_item_no3 := 17; 
                        v_item_no4 := 14; 
                        v_item_no5 := 16;
                        v_item_no6 := 18;
                    ELSE
                        v_item_no1 := 26;
                        v_item_no2 := 28;
                        v_item_no3 := 30;
                        v_item_no4 := 27;
                        v_item_no5 := 29;
                        v_item_no6 := 31;      
                    END IF;        
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DPC', v_gfun_fund_cd, ri_prem.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate reversing record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_rev_tran_id, 'RPC', v_gfun_fund_cd, ri_prem.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry2 IN (SELECT line_cd, def_dist_prem, acct_trty_type, share_type
                                     FROM giac_deferred_ri_prem_ceded
                                    WHERE year         = p_year
                                      AND mm           = p_mm
                                      AND procedure_id = p_procedure_id
                                      AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                      AND nvl(prnt_branch_cd, iss_cd) = ri_prem.prnt_branch_cd)
                    LOOP
                        IF entry2.def_dist_prem <> 0 THEN
                            IF entry2.share_type = 2 THEN
                                IF entry2.def_dist_prem > 0 THEN
                                    --increase
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem,
                                                                               v_item_no1,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               (-1) * entry2.def_dist_prem,
                                                                               v_item_no1,
                                                                               'RPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                  
                                ELSE
                                    --decrease                        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem,
                                                                               v_item_no3,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               (-1) * entry2.def_dist_prem,
                                                                               v_item_no3,
                                                                               'RPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                END IF;
                                --deferred
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           ri_prem.prnt_branch_cd,
                                                                           entry2.line_cd,
                                                                           NULL,
                                                                           entry2.def_dist_prem,
                                                                           v_item_no2,
                                                                           'DPC',
                                                                           'Y',
                                                                           entry2.acct_trty_type,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                                --reversal
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           ri_prem.prnt_branch_cd,
                                                                           entry2.line_cd,
                                                                           NULL,
                                                                           (-1) * entry2.def_dist_prem,
                                                                           v_item_no2,
                                                                           'RPC',
                                                                           'Y',
                                                                           entry2.acct_trty_type,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                            ELSIF entry2.share_type = 3 THEN                                  
                                IF entry2.def_dist_prem > 0 THEN
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem,
                                                                               v_item_no4,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,  
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               (-1) * entry2.def_dist_prem,
                                                                               v_item_no4,
                                                                               'RPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                   
                                ELSE                        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               entry2.def_dist_prem,
                                                                               v_item_no6,
                                                                               'DPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               ri_prem.prnt_branch_cd,
                                                                               entry2.line_cd,
                                                                               NULL,
                                                                               (-1) * entry2.def_dist_prem,
                                                                               v_item_no6,
                                                                               'RPC',
                                                                               'Y', 
                                                                               entry2.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                END IF;
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           ri_prem.prnt_branch_cd,
                                                                           entry2.line_cd,
                                                                           NULL,
                                                                           entry2.def_dist_prem,
                                                                           v_item_no5,
                                                                           'DPC',
                                                                           'Y',
                                                                           entry2.acct_trty_type,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                                --reversal
                                giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                           v_gfun_fund_cd,
                                                                           ri_prem.prnt_branch_cd,
                                                                           entry2.line_cd,
                                                                           NULL,
                                                                           (-1) * entry2.def_dist_prem,
                                                                           v_item_no5,
                                                                           'RPC',
                                                                           'Y',
                                                                           entry2.acct_trty_type,
                                                                           p_module_id,
                                                                           p_user_id,
                                                                           p_msg);
                            END IF;
                        END IF;                
                    END LOOP; 
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_ri_prem_ceded
                       SET gacc_tran_id = v_tran_id
                     WHERE year         = p_year
                       AND mm           = p_mm
                       AND procedure_id = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND nvl(prnt_branch_cd, iss_cd) = ri_prem.prnt_branch_cd;
                END IF;
            END LOOP;  --end of monthly computation, reversal the following month for ri prem
        p_msg := 'Processing RI Ceded Premiums... record(s): '||TO_CHAR(v_cnt);            
        END IF;    
    END gen_acct_entries_ri_prem;      
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.31.2013
   **  Reference By : GIACS044
   **  Remarks      : This procedure is used if the parameter 24TH_METHOD_PROC in giac_parameters has a value of:
   **                  1 - annual computation;   2 - monthly computation, additional take-up;    3 - monthly computation, reversal the following month
   **                  For Deferred RI Premium Ceded
   */ 
    PROCEDURE gen_acct_entries_comm_inc(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_tran_date     VARCHAR2,        
        p_user_id       giac_users.user_id%TYPE,         
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id     VARCHAR2,
        p_msg       OUT VARCHAR2          
    )
    IS
        v_cnt           NUMBER;
        v_tran_id       giac_acctrans.tran_id%TYPE;
        v_rev_tran_id     giac_acctrans.tran_id%TYPE;
        v_item_no1      NUMBER;
        v_item_no2      NUMBER;
        v_item_no3      NUMBER;
        v_item_no4        NUMBER;
        v_item_no5        NUMBER;
        v_item_no6        NUMBER;  
        v_gfun_fund_cd  giac_acctrans.gfun_fund_cd%TYPE;
        v_ri_iss_cd1    giac_parameters.param_value_v%TYPE;
        v_ri_iss_cd2    giac_parameters.param_value_v%TYPE;
        v_module_id     giac_modules.module_id%TYPE;    
        v_method_proc    NUMBER;
        v_tran_date     DATE := TO_DATE(p_tran_date,'MM-DD-YYYY');
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        v_method_proc := giacp.n('24TH_METHOD_PROC');
    /* Set tran_flag='D' for previously created accounting entries */
            FOR chk IN (SELECT gen_tag
                          FROM giac_deferred_extract
                         WHERE year = p_year
                           AND mm   = p_mm
                           AND procedure_id = p_procedure_id
                           AND gen_tag = 'Y'
                           AND comp_sw      = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                BEGIN 
                    UPDATE giac_acctrans
                       SET tran_flag = 'D'
                     WHERE NVL(jv_tran_mm, tran_month) = p_mm   
                       AND NVL(jv_tran_yy, tran_year)  = p_year 
                       AND tran_flag NOT IN ('P', 'D') 
                       AND tran_class IN ('DGP','DPC','DCI','DCE');
                EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    p_msg := 'No accounting entries were found in previous generation.';
                END;
            EXIT;
            END LOOP;
            /* Get Module_Id */
            BEGIN
                SELECT module_id
                  INTO v_module_id
                  FROM giac_modules
                 WHERE module_name LIKE p_module_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_msg := 'No Module_Id found in Giac_Modules.';
            END;
            /* Get Fund_Cd */
            BEGIN
                v_gfun_fund_cd := giacp.v('FUND_CD');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving Fund_Cd.';
            END;

            BEGIN
                v_ri_iss_cd1 := NVL(giisp.v('ISS_CD_RI'),'--');
                v_ri_iss_cd2 := NVL(giisp.v('ISS_CD_RV'),'--');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving ISS_CD_RI/ISS_CD_RV.';
            END;        
        IF v_method_proc = 1  THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Commission Income "DCI" */
            FOR comm_inc IN (SELECT NVL(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(NVL(def_comm_income_diff,0)) def_comm_income_diff
                               FROM giac_deferred_comm_income
                              WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                           GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF comm_inc.def_comm_income_diff <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF comm_inc.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                       v_item_no1 := 19;
                       v_item_no2 := 20;
                       v_item_no3 := 21;
                       v_item_no4 := 32;
                    ELSE
                       v_item_no1 := 7;
                       v_item_no2 := 8;
                       v_item_no3 := 9;
                       v_item_no4 := 25;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DCI', v_gfun_fund_cd, comm_inc.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry3 IN ( SELECT line_cd, def_comm_income_diff, acct_trty_type, share_type, ri_cd    
                                      FROM giac_deferred_comm_income
                                     WHERE year         = p_year
                                       AND mm           = p_mm
                                       AND procedure_id = p_procedure_id
                                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                       AND NVL(prnt_branch_cd, iss_cd) = comm_inc.prnt_branch_cd)
                    LOOP
                        IF entry3.def_comm_income_diff <> 0 THEN
                            IF entry3.share_type = 2 THEN        
                                IF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN
                                    --income   
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no2,
                                                                               'DCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --deferred
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no1,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                                                               
                                ELSIF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN
                                    --deferred   
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no2,
                                                                               'DCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                                                               
                                    --income
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no1,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                END IF;                    
                            ELSE  --share_type = 3 
                                IF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN 
                                    --income        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no3,
                                                                               'DCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --deferred                      
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no4,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                                                                                                                       
                                ELSIF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN
                               
                                    --deferred        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no3,
                                                                               'DCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --income                      
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income_diff,
                                                                               v_item_no4,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);    
                                END IF;                                                                      
                            END IF;
                        END IF;
                    END LOOP;
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_comm_income
                       SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = comm_inc.prnt_branch_cd;
                END IF;
            END LOOP;  -- end of annual computation for comm_inc        
        
        ELSIF v_method_proc = 2 THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Commission Income "DCI" */
            FOR comm_inc IN (SELECT NVL(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(NVL(def_comm_income,0)) def_comm_income
                               FROM giac_deferred_comm_income
                              WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                           GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF comm_inc.def_comm_income <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF comm_inc.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                       v_item_no1 := 19;
                       v_item_no2 := 20;
                       v_item_no3 := 21;
                       v_item_no4 := 32;
                    ELSE
                       v_item_no1 := 7;
                       v_item_no2 := 8;
                       v_item_no3 := 9;
                       v_item_no4 := 25;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DCI',v_gfun_fund_cd, comm_inc.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm,p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry3 IN ( SELECT line_cd, def_comm_income, acct_trty_type, share_type, ri_cd    
                                      FROM giac_deferred_comm_income
                                     WHERE year         = p_year
                                       AND mm           = p_mm
                                       AND procedure_id = p_procedure_id
                                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                       AND NVL(prnt_branch_cd, iss_cd) = comm_inc.prnt_branch_cd)
                    LOOP
                        IF entry3.def_comm_income <> 0 THEN
                            IF entry3.share_type = 2 THEN
                                IF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN
                                
                                    --income  
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no2,
                                                                               'DCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --deferred 
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no1,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);    
                                ELSIF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN
                                    --deferred   
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no2,
                                                                               'DCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --income
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no1,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);    
                                END IF;                    
                            ELSE  --share_type = 3
                                IF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN
                                    --income        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no3,
                                                                               'DCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);    
                                    --deferred                       
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no4,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                                            
                                ELSIF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN
                                    --deferred        
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no3,
                                                                               'DCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);    
                                    --income                   
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no4,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);    
                                END IF;                                                                      
                            END IF;
                        END IF;
                    END LOOP;
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_comm_income
                       SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = comm_inc.prnt_branch_cd;
                END IF;
            END LOOP;  -- end monthly computation, additional takeup for commission income        
        ELSIF v_method_proc = 3 THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Commission Income "DCI" */
            FOR comm_inc IN (SELECT nvl(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(nvl(def_comm_income,0)) def_comm_income
                               FROM giac_deferred_comm_income
                              WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                           GROUP BY nvl(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF comm_inc.def_comm_income <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF comm_inc.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                        v_item_no1 := 19;
                        v_item_no2 := 20;
                        v_item_no3 := 21;
                        v_item_no4 := 32;
                    ELSE
                        v_item_no1 := 7;
                        v_item_no2 := 8;
                        v_item_no3 := 9;
                        v_item_no4 := 25;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DCI', v_gfun_fund_cd, comm_inc.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate reversing record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_rev_tran_id, 'RCI', v_gfun_fund_cd, comm_inc.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry3 IN (SELECT line_cd, def_comm_income, acct_trty_type, share_type, ri_cd
                                     FROM giac_deferred_comm_income
                                    WHERE year         = p_year
                                      AND mm           = p_mm
                                      AND procedure_id = p_procedure_id
                                      AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                      AND nvl(prnt_branch_cd, iss_cd) = comm_inc.prnt_branch_cd)
                    LOOP
                        IF entry3.def_comm_income <> 0 THEN
                            IF entry3.share_type = 2 THEN       
                                 IF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN
                                    --income
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                                 v_gfun_fund_cd,
                                                                                 comm_inc.prnt_branch_cd,
                                                                                 entry3.line_cd,
                                                                                 entry3.ri_cd,
                                                                                 entry3.def_comm_income,
                                                                                 v_item_no2,
                                                                                 'DCI',
                                                                                 'N', 
                                                                                 entry3.acct_trty_type,
                                                                                 p_module_id,
                                                                                 p_user_id,
                                                                                 p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no2,
                                                                               'RCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                                             
                                    --deferred
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no1,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no1,
                                                                               'RCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                
                                 ELSIF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN
                                    --deferred
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no2,
                                                                               'DCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal 
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no2,
                                                                               'RCI',
                                                                               'N', 
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                                             
                                    --income
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no1,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no1,
                                                                               'RCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);                                
                                 
                                 END IF;
                            ELSE  --share_type = 3
                                IF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'N' THEN
                                    --income
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no3,
                                                                               'DCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no3,
                                                                               'RCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --deferred                    
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no4,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no4,
                                                                               'RCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                ELSIF NVL(giacp.v('DEF_COMM_PROD_ENTRY'),'N') = 'Y' THEN                                 
                                    --deferred
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               entry3.def_comm_income,
                                                                               v_item_no3,
                                                                               'DCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               NULL,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no3,
                                                                               'RCI',
                                                                               'N',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --income                    
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               entry3.def_comm_income,
                                                                               v_item_no4,
                                                                               'DCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                    --reversal
                                    giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                               v_gfun_fund_cd,
                                                                               comm_inc.prnt_branch_cd,
                                                                               entry3.line_cd,
                                                                               entry3.ri_cd,
                                                                               (-1) * entry3.def_comm_income,
                                                                               v_item_no4,
                                                                               'RCI',
                                                                               'Y',
                                                                               entry3.acct_trty_type,
                                                                               p_module_id,
                                                                               p_user_id,
                                                                               p_msg);
                                END IF;                    
                            END IF;
                        END IF;
                    END LOOP;
                  /* Populate the new gacc_tran_id for the corresponding generated record */
                  UPDATE giac_deferred_comm_income
                     SET gacc_tran_id = v_tran_id
                   WHERE year         = p_year
                     AND mm           = p_mm
                     AND procedure_id = p_procedure_id
                     AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                     AND nvl(prnt_branch_cd, iss_cd) = comm_inc.prnt_branch_cd;
                END IF;
            END LOOP;  -- end of monthly computation, reversal the following month for comm income
            p_msg := 'Processing Commission Income...record(s): '||TO_CHAR(v_cnt);
        END IF;
    END gen_acct_entries_comm_inc;         

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.31.2013
   **  Reference By : GIACS044
   **  Remarks      : This procedure is used if the parameter 24TH_METHOD_PROC in giac_parameters has a value of:
   **                  1 - annual computation;   2 - monthly computation, additional take-up;    3 - monthly computation, reversal the following month
   **                  For Deferred RI Premium Ceded
   */ 
    PROCEDURE gen_acct_entries_comm_exp(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_tran_date     VARCHAR2,        
        p_user_id       giac_users.user_id%TYPE,         
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id     VARCHAR2,
        p_msg       OUT VARCHAR2        
    )
    IS
        v_cnt           NUMBER;
        v_tran_id       giac_acctrans.tran_id%TYPE;
        v_rev_tran_id     giac_acctrans.tran_id%TYPE;
        v_item_no1      NUMBER;
        v_item_no2      NUMBER;
        v_item_no3      NUMBER;
        v_item_no4        NUMBER;
        v_item_no5        NUMBER;
        v_item_no6        NUMBER;  
        v_gfun_fund_cd  giac_acctrans.gfun_fund_cd%TYPE;
        v_ri_iss_cd1    giac_parameters.param_value_v%TYPE;
        v_ri_iss_cd2    giac_parameters.param_value_v%TYPE;
        v_module_id     giac_modules.module_id%TYPE;    
        v_method_proc    NUMBER;
        v_tran_date     DATE := TO_DATE(p_tran_date,'MM-DD-YYYY');
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        v_method_proc := giacp.n('24TH_METHOD_PROC');
    /* Set tran_flag='D' for previously created accounting entries */
            FOR chk IN (SELECT gen_tag
                          FROM giac_deferred_extract
                         WHERE year = p_year
                           AND mm   = p_mm
                           AND procedure_id = p_procedure_id
                           AND gen_tag = 'Y'
                           AND comp_sw      = v_24th_comp) --mikel 02.26.2016 GENQA 5288
            LOOP
                BEGIN 
                    UPDATE giac_acctrans
                       SET tran_flag = 'D'
                     WHERE NVL(jv_tran_mm, tran_month) = p_mm   
                       AND NVL(jv_tran_yy, tran_year)  = p_year 
                       AND tran_flag NOT IN ('P', 'D') 
                       AND tran_class IN ('DGP','DPC','DCI','DCE');
                EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                    p_msg := 'No accounting entries were found in previous generation.';
                END;
            EXIT;
            END LOOP;
            /* Get Module_Id */
            BEGIN
                SELECT module_id
                  INTO v_module_id
                  FROM giac_modules
                 WHERE module_name LIKE p_module_id;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_msg := 'No Module_Id found in Giac_Modules.';
            END;
            /* Get Fund_Cd */
            BEGIN
                v_gfun_fund_cd := giacp.v('FUND_CD');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving Fund_Cd.';
            END;

            BEGIN
                v_ri_iss_cd1 := NVL(giisp.v('ISS_CD_RI'),'--');
                v_ri_iss_cd2 := NVL(giisp.v('ISS_CD_RV'),'--');
            EXCEPTION
            WHEN OTHERS THEN
                p_msg := 'Error retrieving ISS_CD_RI/ISS_CD_RV.';
            END;        
        IF v_method_proc = 1  THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Commission Expense "DCE" */
            FOR comm_exp IN (SELECT NVL(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(NVL(def_comm_expense_diff,0)) def_comm_expense_diff
                               FROM giac_deferred_comm_expense
                              WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                           GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
            v_cnt := v_cnt + 1;
                IF comm_exp.def_comm_expense_diff <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF comm_exp.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                       v_item_no1 := 22;
                       v_item_no2 := 23;
                    ELSE
                       v_item_no1 := 10;
                       v_item_no2 := 11;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DCE', v_gfun_fund_cd, comm_exp.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry4 IN (SELECT line_cd, intm_ri, def_comm_expense_diff
                                     FROM giac_deferred_comm_expense
                                    WHERE year         = p_year
                                      AND mm           = p_mm
                                      AND procedure_id = p_procedure_id
                                      AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                      AND NVL(prnt_branch_cd, iss_cd) = comm_exp.prnt_branch_cd)
                    LOOP
                        IF entry4.def_comm_expense_diff <> 0 THEN
                            --for comm expense
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       entry4.intm_ri,
                                                                       entry4.def_comm_expense_diff,
                                                                       v_item_no2,
                                                                       'DCE',
                                                                       'N',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                            --for deferred                                
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       NULL,
                                                                       entry4.def_comm_expense_diff,
                                                                       v_item_no1,
                                                                       'DCE',
                                                                       'Y',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                        END IF;
                    END LOOP;
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_comm_expense
                       SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = comm_exp.prnt_branch_cd;
                END IF;
            END LOOP;  -- end of annual computation for comm expense        
        ELSIF v_method_proc = 2 THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Commission Expense "DCE" */
            FOR comm_exp IN (SELECT NVL(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(NVL(def_comm_expense,0)) def_comm_expense
                               FROM giac_deferred_comm_expense
                              WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                           GROUP BY NVL(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF comm_exp.def_comm_expense <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF comm_exp.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                       v_item_no1 := 22;
                       v_item_no2 := 23;
                    ELSE
                       v_item_no1 := 10;
                       v_item_no2 := 11;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DCE', v_gfun_fund_cd, comm_exp.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry4 IN (SELECT line_cd, intm_ri, def_comm_expense
                                     FROM giac_deferred_comm_expense
                                    WHERE year         = p_year
                                      AND mm           = p_mm
                                      AND procedure_id = p_procedure_id
                                      AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                      AND NVL(prnt_branch_cd, iss_cd) = comm_exp.prnt_branch_cd)
                    LOOP
                        IF entry4.def_comm_expense <> 0 THEN
                            --for comm expense
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       entry4.intm_ri,
                                                                       entry4.def_comm_expense,
                                                                       v_item_no2,
                                                                       'DCE',
                                                                       'N',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                            --for deferred                                
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       NULL,
                                                                       entry4.def_comm_expense,
                                                                       v_item_no1,
                                                                       'DCE',
                                                                       'Y',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                        END IF;
                    END LOOP;
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_comm_expense
                       SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = comm_exp.prnt_branch_cd;
                END IF;
            END LOOP;  -- end of monthly computation, additional take up for comm expense                
        ELSIF v_method_proc = 3 THEN
            v_cnt := 0;
            /* Generate Accounting Entries for Deferred Commission Expense "DCE" */
            FOR comm_exp IN (SELECT nvl(prnt_branch_cd, iss_cd) prnt_branch_cd, SUM(nvl(def_comm_expense,0)) def_comm_expense
                               FROM giac_deferred_comm_expense
                              WHERE year         = p_year
                                AND mm           = p_mm
                                AND procedure_id = p_procedure_id
                                AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                           GROUP BY nvl(prnt_branch_cd,iss_cd))
            LOOP
                v_cnt := v_cnt + 1;
                IF comm_exp.def_comm_expense <> 0 THEN -- do not generate entry for 0 amounts
                    /* The following IF statement is to determine what item_no to use
                    ** Assumed Business or Direct Business respectively
                    */ 
                    IF comm_exp.prnt_branch_cd IN (v_ri_iss_cd1, v_ri_iss_cd2) THEN
                        v_item_no1 := 22;
                        v_item_no2 := 23;
                    ELSE
                        v_item_no1 := 10;
                        v_item_no2 := 11;
                    END IF;
                    /* Generate record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_tran_id, 'DCE', v_gfun_fund_cd, comm_exp.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate reversing record in Giac_Acctrans */
                    giacs044_pkg.aeg_gen_acctran_entry_giacs044(v_rev_tran_id, 'RCE', v_gfun_fund_cd, comm_exp.prnt_branch_cd,
                                                                p_tran_date, p_year, p_mm, p_user_id, p_msg);
                    /* Generate the entry for Giac_Acct_Entries */
                    FOR entry4 IN (SELECT line_cd, intm_ri, def_comm_expense
                                     FROM giac_deferred_comm_expense
                                    WHERE year         = p_year
                                      AND mm           = p_mm
                                      AND procedure_id = p_procedure_id
                                      AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                      AND nvl(prnt_branch_cd, iss_cd) = comm_exp.prnt_branch_cd)
                    LOOP
                        IF entry4.def_comm_expense <> 0 THEN
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       entry4.intm_ri,
                                                                       entry4.def_comm_expense,
                                                                       v_item_no2,
                                                                       'DCE',
                                                                       'Y',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                            --reversal
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       entry4.intm_ri,
                                                                       (-1) * entry4.def_comm_expense,
                                                                       v_item_no2,
                                                                       'RCE',
                                                                       'Y',
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                            --for deferred                                
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       NULL,
                                                                       entry4.def_comm_expense,
                                                                       v_item_no1,
                                                                       'DCE',
                                                                       'N',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                            --reversal
                            giacs044_pkg.aeg_gen_acct_entries_giacs044(v_rev_tran_id,
                                                                       v_gfun_fund_cd,
                                                                       comm_exp.prnt_branch_cd,
                                                                       entry4.line_cd,
                                                                       NULL,
                                                                       (-1) * entry4.def_comm_expense,
                                                                       v_item_no1,
                                                                       'RCE',
                                                                       'N',                                      
                                                                       0,
                                                                       p_module_id,
                                                                       p_user_id,
                                                                       p_msg);
                        END IF;
                    END LOOP;
                    /* Populate the new gacc_tran_id for the corresponding generated record */
                    UPDATE giac_deferred_comm_expense
                   SET gacc_tran_id = v_tran_id
                     WHERE year           = p_year
                       AND mm             = p_mm
                       AND procedure_id   = p_procedure_id
                       AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                       AND NVL(prnt_branch_cd, iss_cd) = comm_exp.prnt_branch_cd;
                END IF;
            END LOOP;  -- end of monthly computation, reversal the next month       
            p_msg := 'Processing Commission Expenses...record(s): '; 
        END IF;
    END gen_acct_entries_comm_exp;  
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 05.31.2013
   **  Reference By : GIACS044
   **  Remarks      : last table to update for generate accounting entries
   */     
    PROCEDURE set_gen_tag(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_user_id       giac_users.user_id%TYPE,
        p_msg       OUT VARCHAR2
    )
    IS
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        UPDATE giac_deferred_extract
          SET gen_tag = 'Y',
              gen_user = p_user_id,
              gen_date = SYSDATE
        WHERE year = p_year
          AND mm   = p_mm
          AND procedure_id = p_procedure_id
          AND comp_sw      = v_24th_comp; --mikel 02.26.2016 GENQA 5288
    p_msg := 'Generation Complete!';
    END set_gen_tag;  
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.04.2013
   **  Reference By : GIACS044
   **  Remarks      : retrieves generated accounting records
   */      
    FUNCTION get_acct_entries(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_table         VARCHAR2       
    )
    /* modified by Mikel
    ** 02.09.2016
    ** replaced some codes to optimize query used when retrieving accounting entries
    */
        RETURN acct_entries_tab PIPELINED
    IS
        v_acct          acct_entries_type;
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN(SELECT /*TO_CHAR(a.gl_acct_category)|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_control_acct,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_1,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_2,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_3,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_4,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_5,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_6,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(a.gl_sub_acct_7,'09'))gl_acct_code,*/ a.gacc_tran_id,
                        LTRIM(TO_CHAR(a.sl_cd, '099999999999')) sl_cd, a.sl_type_cd,
                        a.debit_amt, a.credit_amt, a.gl_acct_id, a.gacc_gibr_branch_cd,
                        a.remarks, a.user_id, a.last_update, a.gacc_gfun_fund_cd
                        --added by mikel 02.09.2016;used aggregate functions and geniisys built-in functions
                        ,get_gl_acct_no (a.gl_acct_id) gl_acct_code, get_gl_acct_name(a.gl_acct_id) gl_acct_name 
                        ,get_sl_name(a.sl_cd, a.sl_type_cd, a.sl_source_cd) sl_name
                        ,sum(debit_amt) over() debit_amt_total, sum(credit_amt) over () credit_amt_total
                        --end mikel 02.09.2016
                   FROM giac_acct_entries a
                          WHERE gacc_tran_id IN (SELECT DISTINCT gacc_tran_id --mikel 02.05.2016; added DISTINCT 
                                                   FROM giac_deferred_gross_prem 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdGross') 
                                                 UNION ALL
                                                 SELECT DISTINCT gacc_tran_id --mikel 02.05.2016; added DISTINCT 
                                                   FROM giac_deferred_ri_prem_ceded 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdRiCeded') 
                                                    AND iss_cd NOT IN (SELECT param_value_v 
                                                                        FROM giis_parameters 
                                                                       WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV')) 
                                                 UNION ALL 
                                                 SELECT DISTINCT gacc_tran_id --mikel 02.05.2016; added DISTINCT 
                                                   FROM giac_deferred_ri_prem_ceded 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdRetrocede')  
                                                    AND iss_cd IN (SELECT param_value_v 
                                                                     FROM giis_parameters 
                                                                    WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV')) 
                                                 UNION ALL 
                                                 SELECT DISTINCT gacc_tran_id --mikel 02.05.2016; added DISTINCT 
                                                   FROM giac_deferred_comm_income 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdInc')  
                                                 UNION ALL 
                                                 SELECT DISTINCT gacc_tran_id --mikel 02.05.2016; added DISTINCT 
                                                   FROM giac_deferred_comm_expense 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdExp'))
                )
        LOOP
            v_acct.gl_acct_code := q.gl_acct_code;
            v_acct.sl_cd        := q.sl_cd;
            v_acct.debit_amt    := q.debit_amt;
            v_acct.credit_amt   := q.credit_amt;
            v_acct.remarks      := q.remarks;
            v_acct.user_id      := q.user_id;
            v_acct.last_update  := TO_CHAR(q.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            v_acct.year_gen     := p_year;
            v_acct.mm_gen       := TO_CHAR(TO_DATE(p_mm, 'MM'), 'fmMonth');
            v_acct.branch_cd    := q.gacc_gibr_branch_cd;
            v_acct.fund_cd      := q.gacc_gfun_fund_cd;
            v_acct.gacc_tran_id := q.gacc_tran_id;
            
            --mikel 02.09.2016; for optimization
            v_acct.gl_acct_name := q.gl_acct_name;
            v_acct.sl_name := q.sl_name;
            v_acct.debit_amt_total := q.debit_amt_total;
            v_acct.credit_amt_total := q.credit_amt_total;
            
            /*FOR w IN (SELECT gl_acct_name
                          FROM giac_chart_of_accts
                         WHERE gl_acct_id = q.gl_acct_id)
            LOOP
                v_acct.gl_acct_name := w.gl_acct_name;
                EXIT; 
            END LOOP;
            
            FOR e IN (SELECT sl_name
                         FROM giac_sl_lists
                        WHERE sl_type_cd = q.sl_type_cd
                          AND sl_cd = q.sl_cd)
            LOOP
                  v_acct.sl_name := e.sl_name;
                  EXIT;   
            END LOOP;
            
            FOR r IN (SELECT SUM(NVL(debit_amt,0)) debit_amt_total, SUM(NVL(credit_amt,0)) credit_amt_total
                        FROM giac_acct_entries
                        WHERE gacc_tran_id IN (SELECT DISTINCT gacc_tran_id 
                                                   FROM giac_deferred_gross_prem 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND UPPER(p_table) = UPPER('gdGross') 
                                                 UNION ALL
                                                 SELECT DISTINCT gacc_tran_id 
                                                   FROM giac_deferred_ri_prem_ceded 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND UPPER(p_table) = UPPER('gdRiCeded') 
                                                    AND iss_cd NOT IN (SELECT param_value_v 
                                                                        FROM giis_parameters 
                                                                       WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV')) 
                                                 UNION ALL 
                                                 SELECT DISTINCT gacc_tran_id 
                                                   FROM giac_deferred_ri_prem_ceded 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND UPPER(p_table) = UPPER('gdRetrocede')  
                                                    AND iss_cd IN (SELECT param_value_v 
                                                                     FROM giis_parameters 
                                                                    WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV')) 
                                                 UNION ALL 
                                                 SELECT DISTINCT gacc_tran_id 
                                                   FROM giac_deferred_comm_income 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND UPPER(p_table) = UPPER('gdInc')  
                                                 UNION ALL 
                                                 SELECT DISTINCT gacc_tran_id 
                                                   FROM giac_deferred_comm_expense 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND UPPER(p_table) = UPPER('gdExp')))
            LOOP
                  v_acct.debit_amt_total := r.debit_amt_total;
                v_acct.credit_amt_total := r.credit_amt_total;
                  EXIT;   
            END LOOP;*/  --comment out by mikel 02.09.2016; for optimization                         
            
            FOR t IN (SELECT gen_date
                        FROM giac_deferred_extract
                       WHERE year = p_year
                         AND mm   = p_mm
                         AND procedure_id = p_procedure_id
                         AND comp_sw      = v_24th_comp) --mikel 02.26.2016 GENQA 5288                            
            LOOP
                v_acct.tran_date := t.gen_date;
                EXIT;
            END LOOP;     
                   
            PIPE ROW(v_acct);
        END LOOP;
    END get_acct_entries;       

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.05.2013
   **  Reference By : GIACS044
   **  Remarks      : retrieves generated accounting records
   */ 
    FUNCTION get_gl_summary(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_table         VARCHAR2        
    )
        RETURN acct_entries_tab PIPELINED
    IS
        v_gl            acct_entries_type;
        v_24th_comp     VARCHAR2(1) := NVL(giacp.v('24TH_METHOD_DEF_COMP'), 'N'); --mikel 02.26.2016 GENQA 5288
    BEGIN
        FOR q IN(SELECT TO_CHAR(c.gl_acct_category)|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_control_acct,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_1,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_2,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_3,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_4,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_5,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_6,'09'))|| ' - ' ||
                        LTRIM(TO_CHAR(c.gl_sub_acct_7,'09')) gl_acct_code,
                        LTRIM(TO_CHAR(c.sl_cd, '099999999999')) sl_cd,
                        sum(c.debit_amt) debit_amt, sum(c.credit_amt) credit_amt, 
                        c.gl_acct_id, c.gl_acct_name 
                   FROM (SELECT a.gl_acct_category, a.gl_control_acct, a.gl_sub_acct_1, 
                                a.gl_sub_acct_2, a.gl_sub_acct_3, a.gl_sub_acct_4, 
                                a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7, 
                                a.sl_cd, a.debit_amt, a.credit_amt, a.gl_acct_id, b.gl_acct_name 
                              FROM giac_acct_entries a, giac_chart_of_accts b  
                          WHERE gacc_tran_id IN (SELECT gacc_tran_id 
                                                   FROM giac_deferred_gross_prem 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdGross') 
                                                 UNION ALL
                                                 SELECT gacc_tran_id 
                                                   FROM giac_deferred_ri_prem_ceded 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdRiCeded') 
                                                    AND iss_cd NOT IN (SELECT param_value_v 
                                                                        FROM giis_parameters 
                                                                       WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV')) 
                                                 UNION ALL 
                                                 SELECT gacc_tran_id 
                                                   FROM giac_deferred_ri_prem_ceded 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdRetrocede')  
                                                    AND iss_cd IN (SELECT param_value_v 
                                                                     FROM giis_parameters 
                                                                    WHERE param_name IN ('ISS_CD_RI','ISS_CD_RV')) 
                                                 UNION ALL 
                                                 SELECT gacc_tran_id 
                                                   FROM giac_deferred_comm_income 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdInc')  
                                                 UNION ALL 
                                                 SELECT gacc_tran_id 
                                                   FROM giac_deferred_comm_expense 
                                                  WHERE year = p_year
                                                    AND mm = p_mm
                                                    AND procedure_id = p_procedure_id
                                                    AND comp_sw      = v_24th_comp --mikel 02.26.2016 GENQA 5288
                                                    AND UPPER(p_table) = UPPER('gdExp'))
                            AND a.gl_acct_id = b.gl_acct_id) c
               GROUP BY gl_acct_category, gl_control_acct, gl_sub_acct_1, 
                        gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, 
                        gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, 
                        sl_cd, gl_acct_id, gl_acct_name)
        LOOP
            v_gl.gl_acct_code := q.gl_acct_code;
            v_gl.sl_cd        := q.sl_cd;
            v_gl.debit_amt    := q.debit_amt;
            v_gl.credit_amt   := q.credit_amt;
            v_gl.gl_acct_name := q.gl_acct_name;
        PIPE ROW(v_gl);
        END LOOP;
    END get_gl_summary;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 06.07.2013
   **  Reference By : GIACS044
   **  Remarks      : retrieves branch lists for print dialog box
   */ 
    FUNCTION get_branch_list(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN branch_list_tab PIPELINED
    IS
        v_branch        branch_list_type;
    BEGIN
        FOR q IN(SELECT DISTINCT gibr_branch_cd, branch_name
                   FROM giac_acctrans a, giac_branches b
                  WHERE a.tran_class IN ('DGP', 'DPC', 'DCI', 'DCE',
                                'RGP', 'RPC', 'RCI', 'RCE')
                     AND TO_NUMBER(TO_CHAR(a.tran_date, 'MM')) = p_mm
                     AND TO_NUMBER(TO_CHAR(a.tran_date, 'YYYY')) = p_year             
                    AND a.tran_flag IN ('C', 'P')
                    AND a.tran_id > 0
                    AND a.gfun_fund_cd = b.gfun_fund_cd
                    AND a.gibr_branch_cd = b.branch_cd
                    AND check_user_per_iss_cd_acctg2 (NULL, a.gibr_branch_cd, 'GIACS044', p_user_id) = 1)
    
        LOOP
            v_branch.branch_cd   := q.gibr_branch_cd;
            v_branch.branch_name := q.branch_name;
        PIPE ROW(v_branch);
        END LOOP;
    END get_branch_list;                        
    
END GIACS044_PKG;
/