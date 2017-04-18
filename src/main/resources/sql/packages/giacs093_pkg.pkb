CREATE OR REPLACE PACKAGE BODY CPI.GIACS093_PKG
AS
    /*  Created By:     Shan Bati
    **  Date Created:   06.17.2013
    **  Referenced By:  GIACS093 - PDC Register
    **/

    FUNCTION get_branch_lov(
        p_user      GIIS_USERS.USER_ID%type
    ) RETURN branch_lov_tab PIPELINED
    AS
        lov     branch_lov_type;
    BEGIN
        FOR i IN  ( SELECT branch_cd, branch_name
                      FROM giac_branches
                     WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,branch_cd,'GIACS093', p_user),1,branch_cd,NULL)
                     /*UNION
                    SELECT NULL , 'ALL BRANCHES'
                      FROM dual*/)
        LOOP
            lov.branch_cd   := i.branch_cd;
            lov.branch_name := i.branch_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_branch_lov;	
    
    FUNCTION validate_branch_cd(
        p_branch_cd     GIAC_BRANCHES.BRANCH_CD%type,
        p_user          GIIS_USERS.USER_ID%type
    ) RETURN VARCHAR2
    AS
        v_branch_name   GIAC_BRANCHES.branch_name%type;
    BEGIN
        SELECT DISTINCT branch_name
          INTO v_branch_name
          FROM giac_branches
         WHERE branch_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,branch_cd,'GIACS093', p_user),1,branch_cd,NULL)
           AND UPPER(branch_cd) = UPPER(p_branch_cd);
           
        RETURN (v_branch_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_branch_name := NULL;
            RETURN (v_branch_name);
    END validate_branch_cd ;
    
    
    PROCEDURE POPULATE_GIAC_PDC(
        p_as_of_date        IN  giac_apdc_payt_dtl.CHECK_DATE%type,
        p_cut_off_date      IN  giac_order_of_payts.OR_DATE%type,
        p_branch_cd         IN  GIAC_BRANCHES.BRANCH_CD%type,
        p_register          IN  VARCHAR2,
        p_outstanding       IN  VARCHAR2,
        p_user              IN  GIAC_PDC_EXT.USER_ID%type,
        p_extract_flag      OUT VARCHAR2,
        p_begin_extract     OUT VARCHAR2,
        p_end_extract       OUT VARCHAR2,
        p_msg               OUT VARCHAR2        
    )
    AS
        v_extraction_counter NUMBER := 0;  --added by Jayson 02.09.2010
        
        --edited by Jayson 02.09.2010--
        CURSOR pdc IS (SELECT a.apdc_id apdcid, a.apdc_pref, a.apdc_no, a.apdc_date, a.branch_cd, 
                                b.pdc_id pdcid_dtl, b.bank_cd, b.check_no, b.check_date, b.check_amt,
                                b.payor, b.gacc_tran_id, b.bank_branch,
                                b.fcurrency_amt, --from d.fcurrency_amt edited by Jayson 12.14.2011
                                b.pdc_id, --added by Jayson 12.14.2011
                                c.or_pref_suf, c.or_no, c.or_date
                                --d.pdc_id pdcid_colln, d.iss_cd, d.prem_seq_no, d.inst_no, d.collection_amt --removed by Jayson 12.14.2011
                           FROM giac_apdc_payt a,
                                giac_apdc_payt_dtl b,
                                giac_order_of_payts c
                                --giac_pdc_prem_colln d --removed by Jayson 12.14.2011
                          WHERE a.apdc_id            = b.apdc_id
                            AND b.gacc_tran_id       = c.gacc_tran_id
                            --AND b.pdc_id             = d.pdc_id --removed by Jayson 12.14.2011
                            AND TRUNC(b.check_date) <= P_AS_OF_DATE                                                
                            AND TRUNC(c.or_date)    <= P_CUT_OFF_DATE                                            
                            --AND a.branch_cd          = NVL(:MISC.BRANCH_CD,a.branch_cd) commented out and changed by reymon 05142012
                            AND ((p_branch_cd IS NOT NULL AND a.branch_cd = p_branch_cd)
                                 OR (p_branch_cd IS NULL AND check_user_per_iss_cd_acctg2(NULL, branch_cd, 'GIACS093', p_user) = 1))
                            -- START added by Jayson 12.14.2011 --
                            AND EXISTS (SELECT 1
                                          FROM giac_pdc_prem_colln z
                                         WHERE z.pdc_id = b.pdc_id
                                           AND EXISTS (SELECT 1
                            -- END added by Jayson 12.14.2011 --
                            --AND d.iss_cd || d.prem_seq_no IN (SELECT e.b140_iss_cd || e.b140_prem_seq_no --removed by Jayson 12.14.2011
                                                         FROM giac_direct_prem_collns e,
                                                              giac_order_of_payts f,
                                                              giac_acctrans g 
                                                        WHERE e.gacc_tran_id     = f.gacc_tran_id
                                                          AND e.gacc_tran_id     = g.tran_id
                                                          AND e.b140_iss_cd      = z.iss_cd -- added by Jayson 12.14.2011
                                                          AND e.b140_prem_Seq_no = z.prem_Seq_no -- added by Jayson 12.14.2011
                                                          AND 1 NOT IN (SELECT '1'
                                                                          FROM giac_reversals x, giac_acctrans y
                                                                         WHERE x.gacc_tran_id       = f.gacc_tran_id
                                                                           AND x.reversing_tran_id  = y.tran_id
                                                                           AND tran_flag           <> 'D')))
                        UNION
                       SELECT a.apdc_id apdcid, a.apdc_pref, a.apdc_no, a.apdc_date, a.branch_cd, 
                              b.pdc_id pdcid_dtl, b.bank_cd, b.check_no, b.check_date, b.check_amt,
                              b.payor, b.gacc_tran_id, b.bank_branch,
                              b.fcurrency_amt, --from d.fcurrency_amt edited by Jayson 12.14.2011
                              b.pdc_id, --added by Jayson 12.14.2011
                              c.or_pref_suf, c.or_no, c.or_date
                              --d.pdc_id pdcid_colln, d.iss_cd, d.prem_seq_no, d.inst_no, d.collection_amt --removed by Jayson 12.14.2011
                         FROM giac_apdc_payt a,
                              giac_apdc_payt_dtl b,
                              giac_order_of_payts c
                              --giac_pdc_prem_colln d --removed by Jayson 12.14.2011
                        WHERE a.apdc_id            =  b.apdc_id
                          AND b.gacc_tran_id       =  c.gacc_tran_id (+)
                          --AND b.pdc_id             =  d.pdc_id --removed by Jayson 12.14.2011
                          AND TRUNC(b.check_date) <= P_AS_OF_DATE
                          --AND a.branch_cd          =  NVL(:MISC.BRANCH_CD,a.branch_cd) commented out and changed by reymon 05142012
                          AND ((p_branch_cd IS NOT NULL AND a.branch_cd = p_branch_cd)
                               OR (p_branch_cd IS NULL AND check_user_per_iss_cd_acctg2(NULL, branch_cd, 'GIACS093', p_user) = 1))
                          AND b.gacc_tran_id      IS NULL
                          AND B.CHECK_FLAG NOT IN ('R','C') --ADDED BY APRIL 12092011
                          -- START added by Jayson 12.14.2011--
                          AND EXISTS (SELECT 1
                                        FROM giac_pdc_prem_colln z
                                       WHERE z.pdc_id = b.pdc_id));
                          -- END added by Jayson 12.14.2011 --
        --end edited by Jayson 02.09.2010--
        
        --added cursor by Jayson 02.09.2010--
	    CURSOR outstanding IS (SELECT a.apdc_id apdcid, a.apdc_pref, a.apdc_no, a.apdc_date, a.branch_cd, 
				                        b.pdc_id pdcid_dtl, b.bank_cd, b.check_no, b.check_date, b.check_amt,
				                        b.payor, b.gacc_tran_id, b.bank_branch,
				                        b.fcurrency_amt, --from d.fcurrency_amt edited by Jayson 12.14.2011
				                        b.pdc_id, --added by Jayson 12.14.2011
				                        c.or_pref_suf, c.or_no, c.or_date
				                        --d.pdc_id pdcid_colln, d.iss_cd, d.prem_seq_no, d.inst_no, d.collection_amt --removed by Jayson 12.14.2011
				                   FROM giac_apdc_payt a,
				                        giac_apdc_payt_dtl b,
				                        giac_order_of_payts c
				                        --giac_pdc_prem_colln d --removed by Jayson 12.14.2011
				                  WHERE a.apdc_id            =  b.apdc_id
				                    AND b.gacc_tran_id       =  c.gacc_tran_id (+)
				                    --AND b.pdc_id             =  d.pdc_id --removed by Jayson 12.14.2011
				                    AND TRUNC(b.check_date) <= P_AS_OF_DATE
				                    --AND a.branch_cd          =  NVL(:MISC.BRANCH_CD,a.branch_cd) commented out and changed by reymon 05142012
				                    AND ((p_branch_cd IS NOT NULL AND a.branch_cd = p_branch_cd)
				                         OR (p_branch_cd IS NULL AND check_user_per_iss_cd_acctg2(NULL, branch_cd, 'GIACS093', p_user) = 1))
				                    AND b.gacc_tran_id      IS NULL
				                    AND B.CHECK_FLAG NOT IN ('R','C') --ADDED BY APRIL 12092011
				                    -- START added by Jayson 12.14.2011--
				                    AND EXISTS (SELECT 1
				                                  FROM giac_pdc_prem_colln z
				                                 WHERE z.pdc_id = b.pdc_id));
				                    -- END added by Jayson 12.14.2011 --
	    --end added cursor by Jayson 02.09.2010--
    BEGIN
        p_begin_extract := to_char(sysdate,'MM/DD/RRRR HH:MI:SS AM');
        
        	--START added by Jayson 12.14.2011 --
	    DELETE FROM cpi.giac_pdc_ext
         WHERE USER_ID = P_USER;
        
        DELETE FROM cpi.giac_pdc_dtl_ext
         WHERE USER_ID = P_USER;
	    --START added by Jayson 12.14.2011 --
        
        IF P_REGISTER = 'R' THEN	--added IF condition Jayson 02.09.2010
            FOR a IN pdc 
            LOOP
                v_extraction_counter := v_extraction_counter + 1;  --added by Jayson 02.09.2010
                INSERT INTO giac_pdc_ext (apdc_id, apdc_pref, apdc_no, apdc_date, branch_cd, pdc_id,
                                          bank_cd, check_no, check_date, check_amt, fcurrency_amt,
                                          payor, gacc_tran_id, or_pref_suf, or_no, or_date, as_of_date,
                                          cut_off_date, user_id, extract_date, bank_branch, param_pdc_type, param_branch_cd)
                     VALUES              (a.apdcid, a.apdc_pref, a.apdc_no, a.apdc_date, a.branch_cd, a.pdcid_dtl,
                                          a.bank_cd, a.check_no, a.check_date, a.check_amt, a.fcurrency_amt,
                                          a.payor, a.gacc_tran_id, a.or_pref_suf, a.or_no, a.or_date, P_AS_OF_DATE,
                                          P_CUT_OFF_DATE, P_USER, SYSDATE, a.bank_branch, 'R', p_branch_cd);
              
                -- START added by Jayson 12.14.2011 --
                FOR rec1 IN (SELECT pdc_id, iss_cd, prem_seq_no, inst_no, collection_amt, fcurrency_amt
                               FROM giac_pdc_prem_colln z
                              WHERE z.pdc_id = a.pdc_id)
                LOOP
                    -- END added by Jayson 12.14.2011 --
                    INSERT INTO giac_pdc_dtl_ext (pdc_id, iss_cd, prem_seq_no, inst_no,
                                                  collection_amt, fcurrency_amt, user_id) --user_id added by Jayson 12.14.2011
                         VALUES                  (rec1.pdc_id, rec1.iss_cd, rec1.prem_seq_no, rec1.inst_no,
                                                  rec1.collection_amt, rec1.fcurrency_amt, P_USER); --user added by Jayson 12.14.2011*/
                END LOOP; --added by Jayson 12.14.2011
            END LOOP;
        --added ELSIF condtion Jayson 02.09.2010--
        ELSIF P_OUTSTANDING = 'O' THEN
            FOR a IN outstanding 
            LOOP
    	        v_extraction_counter := v_extraction_counter + 1;
		        INSERT INTO giac_pdc_ext (apdc_id, apdc_pref, apdc_no, apdc_date, branch_cd, pdc_id,
		                                  bank_cd, check_no, check_date, check_amt, fcurrency_amt,
		                      	          payor, gacc_tran_id, or_pref_suf, or_no, or_date, as_of_date,
			                              cut_off_date, user_id, extract_date, bank_branch, param_pdc_type, param_branch_cd)
			         VALUES              (a.apdcid, a.apdc_pref, a.apdc_no, a.apdc_date, a.branch_cd, a.pdcid_dtl,
		      		                      a.bank_cd, a.check_no, a.check_date, a.check_amt, a.fcurrency_amt,
		              	  	              a.payor, a.gacc_tran_id, a.or_pref_suf, a.or_no, a.or_date, P_AS_OF_DATE,
				                          P_CUT_OFF_DATE, P_USER, SYSDATE, a.bank_branch, 'O', p_branch_cd);
			                        
                -- START added by Jayson 12.14.2011 --
                FOR rec1 IN (SELECT pdc_id, iss_cd, prem_seq_no, inst_no, collection_amt, fcurrency_amt
                               FROM giac_pdc_prem_colln z
                              WHERE z.pdc_id = a.pdc_id)
                LOOP
                    -- END added by Jayson 12.14.2011 --
                    INSERT INTO giac_pdc_dtl_ext (pdc_id, iss_cd, prem_seq_no, inst_no,
                                                  collection_amt, fcurrency_amt, user_id) --user_id added by Jayson 12.14.2011
                         VALUES                  (rec1.pdc_id, rec1.iss_cd, rec1.prem_seq_no, rec1.inst_no,
                                                  rec1.collection_amt, rec1.fcurrency_amt, P_USER); --user added by Jayson 12.14.2011*/
                END LOOP; --added by Jayson 12.14.2011
            END LOOP;
    --end added ELSIF condtion Jayson 02.09.2010--
        END IF;
        
        p_end_extract := to_char(sysdate,'MM/DD/RRRR HH:MI:SS AM');
	    --FORMS_DDL('COMMIT');
	
        --edited by Jayson 02.09.2010--
        IF v_extraction_counter = 0 THEN
            p_msg := 'No records were extracted.';
        ELSE
            p_msg := 'Extraction complete. '||v_extraction_counter||' record(s) were extracted.';
            p_extract_flag := 'TRUE';
        END IF;
        --end edited by Jayson 02.09.2010--
        
    END POPULATE_GIAC_PDC;
    
    PROCEDURE last_extract_params(
        p_user_id           IN  VARCHAR2,
        p_as_of_date        OUT VARCHAR2,
        p_cut_off_date      OUT VARCHAR2,
        p_pdc_type          OUT VARCHAR2,
        p_branch_cd         OUT VARCHAR2,
        p_branch_name       OUT VARCHAR2
    )
    IS
    BEGIN
        SELECT TO_CHAR (as_of_date, 'MM-DD-YYYY'),
               TO_CHAR (cut_off_date, 'MM-DD-YYYY'), param_pdc_type, param_branch_cd
          INTO p_as_of_date,
               p_cut_off_date, p_pdc_type, p_branch_cd
          FROM giac_pdc_ext a
         WHERE a.user_id = p_user_id AND ROWNUM = 1;
         
         FOR i IN(
            SELECT branch_name
              FROM giac_branches
             WHERE branch_cd = p_branch_cd AND ROWNUM = 1
         )
         LOOP
            p_branch_name := i.branch_name;
         END LOOP;
         
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_as_of_date := '';
            p_cut_off_date := '';
            p_pdc_type := '';
            p_branch_cd := '';
            p_branch_name := '';
    END;    
    
END GIACS093_PKG;
/


