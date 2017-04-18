CREATE OR REPLACE PACKAGE BODY CPI.GIACS157_PKG
AS

    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.05.2013
    **  Reference By: GIACS157 - Commission Fund
    **  Description: retrieve list of GIAC_COMM_FUND_EXT
    */
    FUNCTION get_giac_comm_fund_listing(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE
    )
      RETURN giac_comm_fund_ext_tab PIPELINED
    AS
        v_rec                       giac_comm_fund_ext_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIAC_COMM_FUND_EXT
                  WHERE gacc_tran_id = p_gacc_tran_id
                  ORDER BY intm_no, comm_slip_no)
        LOOP
            v_rec.comm_slip_pref := i.comm_slip_pref;
            v_rec.comm_slip_no := i.comm_slip_no;
            v_rec.comm_slip_date := i.comm_slip_date;
            v_rec.intm_no := i.intm_no;
            v_rec.comm_amt := i.comm_amt;
            v_rec.wtax_amt := i.wtax_amt;
            v_rec.input_vat_amt := i.input_vat_amt;
            v_rec.spoiled_tag := i.spoiled_tag;
            v_rec.bill_no := i.iss_cd ||'-'|| TO_CHAR(i.prem_seq_no,'FM099999999999');
            v_rec.net_amt := NVL((i.comm_amt + i.input_vat_amt - i.wtax_amt),0);
            v_rec.dsp_comm_slip_date := TO_CHAR(i.comm_slip_date, 'MM-DD-YYYY');
            v_rec.comm_slip_flag := i.comm_slip_flag;
            v_rec.iss_cd := i.iss_cd;
            v_rec.prem_seq_no := i.prem_seq_no;
            v_rec.rec_id := i.rec_id;
            v_rec.gacc_tran_id := i.gacc_tran_id;
            PIPE ROW(v_rec);
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.05.2013
    **  Reference By: GIACS157 - Commission Fund
    **  Description: populate table GIAC_COMM_FUND_EXT
    */
    PROCEDURE extract_comm_slip(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_user_id                   GIAC_COMM_FUND_EXT.user_id%TYPE
    )
    IS
        v_gacc_tran_id              NUMBER(12);
        v_intm_no                   NUMBER(12);
        v_parent_intm_no            NUMBER(12);
        v_iss_cd                    VARCHAR2(3);
        v_prem_seq_no               NUMBER(12);
        v_comm_amt                  NUMBER(12,2);
        v_wtax_amt                  NUMBER(12,2);
        v_input_vat                 NUMBER(12,2);
        v_or_no                     VARCHAR2(15);
        V_REC_ID                    GIAC_COMM_FUND_EXT.rec_id%TYPE;
        v_policy_id                 GIPI_INVOICE.policy_id%TYPE;
        v_prem_amt                  GIPI_INVOICE.prem_amt%TYPE;
        v_or_date                   DATE;
        v_comm_tag                  GIAC_COMM_FUND_EXT.comm_tag%TYPE;
        v_record_no                 GIAC_COMM_FUND_EXT.record_no%TYPE;
        v_cs_rec_no					giac_comm_fund_ext.cs_rec_no%TYPE;	--shan 10.29.2014, solution copied from PHILFIRE SR 16985
	    v_exist				        NUMBER;							    --shan 10.29.2014
		v_record_seq_no				GIAC_COMM_FUND_EXT.record_seq_no%TYPE;  --robert SR 19752 08.12.15
    BEGIN
        FOR ctr IN (SELECT gacc_tran_id,
                           iss_cd, 
                           prem_seq_no, 
                           intm_no,
                           rec_id,
                           cs_rec_no
                      FROM GIAC_COMM_FUND_EXT
                     WHERE gacc_tran_id = p_gacc_tran_id
                       AND NVL(spoiled_tag, 'N') <> 'Y'
                     MINUS
                    SELECT a.gacc_tran_id, 
                           a.iss_cd, 
                           a.prem_seq_no, 
                           a.intm_no,
                           b.rec_id,
                           cs_rec_no 
                      FROM GIAC_COMM_PAYTS a,
                           GIAC_COMM_FUND_EXT b                                                                         
                     WHERE a.gacc_tran_id = p_gacc_tran_id
                       AND a.gacc_tran_id = b.gacc_tran_id 
                       AND a.intm_no = b.intm_no
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND a.gacc_tran_id > 0                        
                       AND a.comm_amt = b.comm_amt 
                       AND a.wtax_amt = b.wtax_amt
                       AND a.input_vat_amt = b.input_vat_amt
                       AND nvl(b.spoiled_tag, 'N') <> 'Y'
                       AND a.comm_tag = b.comm_tag
                       AND a.record_no = b.record_no)
        LOOP                                    
            DELETE
              FROM GIAC_COMM_FUND_EXT
             WHERE gacc_tran_id = p_gacc_tran_id
               AND iss_cd = ctr.iss_cd 
               AND prem_seq_no = ctr.prem_seq_no
               AND intm_no = ctr.intm_no
               AND rec_id = ctr.rec_id
               AND NVL(spoiled_tag, 'N') <> 'Y'
               AND comm_slip_pref IS NULL
               AND comm_slip_no IS NULL
               AND cs_rec_no = ctr.cs_rec_no;  -- shan 10.29.2014


            UPDATE GIAC_COMM_FUND_EXT
               SET spoiled_tag = 'Y'
             WHERE gacc_tran_id = p_gacc_tran_id
               AND iss_cd = ctr.iss_cd 
               AND prem_seq_no = ctr.prem_seq_no
               AND intm_no = ctr.intm_no
               AND rec_id = ctr.rec_id
               AND NVL(spoiled_tag, 'N') <> 'Y'
               AND comm_slip_flag = 'P'
               AND comm_slip_pref IS NOT NULL
               AND comm_slip_no IS NOT NULL
               AND cs_rec_no = ctr.cs_rec_no;  -- shan 10.29.2014
        END LOOP;
            
        FOR rec IN (SELECT comm_slip_pref, comm_slip_no
                      FROM GIAC_COMM_FUND_EXT
                     WHERE gacc_tran_id = p_gacc_tran_id
                       AND nvl(spoiled_tag, 'N') = 'Y'
                       AND comm_slip_flag = 'P')
        LOOP
            UPDATE GIAC_COMM_FUND_EXT
               SET spoiled_tag = 'Y'
             WHERE gacc_tran_id = p_gacc_tran_id
               AND nvl(comm_slip_pref, 'X') = rec.comm_slip_pref
               AND nvl(comm_slip_no, 0) = rec.comm_slip_no
               AND nvl(spoiled_tag, 'N') <> 'Y'
                AND comm_slip_flag = 'P';
        END LOOP;
    
        SELECT NVL(MAX(NVL(rec_id,0)),0)
          INTO v_rec_id
          FROM GIAC_COMM_FUND_EXT;

        FOR i IN (SELECT gacc_tran_id, 
                         iss_cd, 
                         prem_seq_no, 
                         intm_no, 
                         parent_intm_no,
                         comm_amt, 
                         wtax_amt, 
                         input_vat_amt,
                         comm_tag,
                         record_no,
						 record_seq_no  --robert SR 19752 08.12.15
                    FROM GIAC_COMM_PAYTS                                     
                   WHERE gacc_tran_id = p_gacc_tran_id
                   MINUS
                  SELECT gacc_tran_id, 
                         iss_cd, 
                         prem_seq_no, 
                         intm_no, 
                         parent_intm_no,
                         comm_amt, 
                         wtax_amt, 
                         input_vat_amt,
                         comm_tag,
                         record_no,
						 record_seq_no  --robert SR 19752 08.12.15
                    FROM GIAC_COMM_FUND_EXT
                   WHERE gacc_tran_id = p_gacc_tran_id
                     AND NVL(spoiled_tag, 'N') <> 'Y')                             
        LOOP
            FOR s IN (SELECT c.or_pref_suf||'-'||to_char(max(c.or_no)) or_no, max(or_date) or_date
                        FROM GIAC_DIRECT_PREM_COLLNS a,
                             GIAC_ACCTRANS b,
                             GIAC_ORDER_OF_PAYTS c
                       WHERE a.b140_iss_cd = i.iss_cd
                         AND a.b140_prem_seq_no = i.prem_seq_no
                         AND a.gacc_tran_id + 0 = b.tran_id
                         AND a.gacc_tran_id + 0 = c.gacc_tran_id
                         AND a.gacc_tran_id > 0
                         AND b.tran_flag <> 'D'
                         AND NOT EXISTS (SELECT x.gacc_tran_id
                                           FROM GIAC_REVERSALS x,
                                                GIAC_ACCTRANS y
                                          WHERE x.reversing_tran_id = y.tran_id
                                            AND y.tran_flag <> 'D'
                                            AND x.gacc_tran_id = a.gacc_tran_id)
                       GROUP BY c.or_pref_suf)                                                                 
            LOOP
                v_or_no := s.or_no;            
                v_or_date := s.or_date;
                EXIT;        
            END LOOP;

            SELECT policy_id, prem_amt
              INTO v_policy_id, v_prem_amt
              FROM GIPI_INVOICE
		     WHERE iss_cd = i.iss_cd
			   AND prem_seq_no = i.prem_seq_no;
						
            --shan 10.30.2014 
            BEGIN											
                SELECT 1, MAX (cs_rec_no)
                  INTO v_exist, v_cs_rec_no
                  FROM giac_comm_fund_ext
                 WHERE gacc_tran_id = i.gacc_tran_id
                   AND iss_cd = i.iss_cd
                   AND prem_seq_no = i.prem_seq_no
                   AND intm_no = i.intm_no
                   AND record_no = i.record_no;
            END;
            
            IF v_exist = 1 THEN
                v_cs_rec_no := v_cs_rec_no + 1;
            END IF;
            --end 10.30.2014
            		 	 						
            v_gacc_tran_id := i.gacc_tran_id;
            v_intm_no := i.intm_no;
            v_parent_intm_no := i.parent_intm_no;
            v_iss_cd  := i.iss_cd;
            v_prem_seq_no := i.prem_seq_no;
            v_comm_amt := i.comm_amt;
            v_wtax_amt := i.wtax_amt;
            v_input_vat := i.input_vat_amt;
            v_rec_id := v_rec_id + 1;
            v_comm_tag := i.comm_tag;
            v_record_no := i.record_no;
            v_record_seq_no := i.record_seq_no; --robert SR 19752 08.12.15
            INSERT INTO GIAC_COMM_FUND_EXT 
                (rec_id, gacc_tran_id, iss_cd, prem_seq_no, intm_no, comm_amt,
                wtax_amt, input_vat_amt, user_id, last_update, comm_slip_tag, or_no, parent_intm_no,
                policy_id, prem_amt, or_date,
                comm_tag, record_no, cs_rec_no, record_seq_no) --robert SR 19752 08.12.15
            VALUES 
                (v_rec_id, v_gacc_tran_id, v_iss_cd, v_prem_seq_no, v_intm_no, v_comm_amt,
                v_wtax_amt, v_input_vat, p_user_id, SYSDATE, 'N', v_or_no, v_parent_intm_no,
                v_policy_id, v_prem_amt, v_or_date,
                v_comm_tag, v_record_no, NVL (v_cs_rec_no, 1), v_record_seq_no); --robert SR 19752 08.12.15
        END LOOP;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.05.2013
    **  Reference By: GIACS157 - Commission Fund
    **  Description: update comm_slip_tag of GIAC_COMM_FUND_EXT record
    */
    PROCEDURE update_giac_comm_fund_ext(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_intm_no                   GIAC_COMM_FUND_EXT.intm_no%TYPE,
        p_iss_cd                    GIAC_COMM_FUND_EXT.iss_cd%TYPE,
        p_prem_seq_no               GIAC_COMM_FUND_EXT.prem_seq_no%TYPE,
        p_rec_id                    GIAC_COMM_FUND_EXT.rec_id%TYPE
    )
    IS
    BEGIN
        UPDATE GIAC_COMM_FUND_EXT
           SET comm_slip_tag = 'Y'
         WHERE intm_no = p_intm_no
           AND iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no
           AND (comm_slip_flag !='C' OR comm_slip_flag IS NULL)
           AND gacc_tran_id = p_gacc_tran_id
           AND NVL(spoiled_tag, 'N') <> 'Y'
           AND rec_id = p_rec_id;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.05.2013
    **  Reference By: GIACS157 - Commission Fund
    **  Description: validate before printing comm fund slip
    */
    PROCEDURE check_comm_fund_slip(
        p_gacc_tran_id      IN      GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_in_rec_id         IN      VARCHAR2,                               -- shan 10.30.2014
        p_comm_slip_pref    OUT     GIAC_COMM_FUND_EXT.comm_slip_pref%TYPE,
        p_comm_slip_no      OUT     GIAC_COMM_FUND_EXT.comm_slip_no%TYPE,
        p_comm_slip_date    OUT     VARCHAR2
    )
    IS
        v_flag_count                NUMBER := 0;
        v_slip_count                NUMBER := 0;
        v_intm_count	            NUMBER := 0;
        v_tagged_count              NUMBER;
	    v_actual_count              NUMBER;
        v_flag                      GIAC_COMM_FUND_EXT.comm_slip_flag%TYPE;
        
        v_test number := 0;
    BEGIN
        SELECT COUNT(1)
          INTO v_test
          FROM GIAC_COMM_FUND_EXT
         WHERE comm_slip_tag = 'Y'
           AND gacc_tran_id = p_gacc_tran_id;
        
        FOR i IN(SELECT COUNT(DISTINCT(NVL(comm_slip_flag, 'N'))) flag_count,
                        COUNT(DISTINCT(NVL(comm_slip_pref||TO_CHAR(comm_slip_no),'X'))) slip_count,
                        COUNT(DISTINCT intm_no) intm_count
                   FROM GIAC_COMM_FUND_EXT
                  WHERE comm_slip_tag = 'Y'
                    AND gacc_tran_id = p_gacc_tran_id
                    -- added to check on selected records only : shan 10.30.2014
                    AND (p_in_rec_id IS NOT NULL AND rec_id IN ((SELECT regexp_substr(p_in_rec_id,'[^,]+', 1, level) FROM dual
                                                                 CONNECT BY regexp_substr(p_in_rec_id, '[^,]+', 1, level) IS NOT NULL))))
        LOOP
            v_flag_count := i.flag_count;
            v_slip_count := i.slip_count;
            v_intm_count := i.intm_count;
        END LOOP;
        
        /*
        ** Added update on every if else
        ** by reymon 06182013
        ** based on CS version
        */
        IF v_flag_count > 1 THEN
            UPDATE GIAC_COMM_FUND_EXT
               SET comm_slip_tag = 'N'
             WHERE gacc_tran_id = p_gacc_tran_id;
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Cannot combine unprinted records with printed records.');
        ELSIF v_slip_count > 1 THEN
            UPDATE GIAC_COMM_FUND_EXT
               SET comm_slip_tag = 'N'
             WHERE gacc_tran_id = p_gacc_tran_id;
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Cannot combine records with different comm fund slip numbers.');
        ELSIF v_intm_count > 1 THEN
            UPDATE GIAC_COMM_FUND_EXT
               SET comm_slip_tag = 'N'
             WHERE gacc_tran_id = p_gacc_tran_id;
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Cannot combine records with different intermediaries.');
        ELSE
--        raise_application_error (-20001, p_in_rec_id);
            SELECT DISTINCT(NVL(comm_slip_flag,'N'))
              INTO v_flag
              FROM GIAC_COMM_FUND_EXT
             WHERE comm_slip_tag = 'Y'
               AND gacc_tran_id = p_gacc_tran_id
               -- added to check on selected records only : shan 10.30.2014
               AND rec_id IN (SELECT regexp_substr(p_in_rec_id,'[^,]+', 1, level) FROM dual
                              CONNECT BY regexp_substr(p_in_rec_id, '[^,]+', 1, level) IS NOT NULL);
        
            IF v_flag = 'P' THEN
                FOR b IN(SELECT DISTINCT comm_slip_pref,
                                comm_slip_no,
                                comm_slip_date
                           FROM GIAC_COMM_FUND_EXT
                          WHERE comm_slip_tag = 'Y'
                            AND gacc_tran_id = p_gacc_tran_id
                            -- added to check on selected records only : shan 10.30.2014
                            AND rec_id IN (SELECT regexp_substr(p_in_rec_id,'[^,]+', 1, level) FROM dual
                                           CONNECT BY regexp_substr(p_in_rec_id, '[^,]+', 1, level) IS NOT NULL))
                LOOP
                    p_comm_slip_pref := b.comm_slip_pref;
                    p_comm_slip_no := b.comm_slip_no;
                    p_comm_slip_date := TO_CHAR(b.comm_slip_date, 'MM-dd-yyyy');
                    
                    SELECT COUNT(comm_slip_no)
                      INTO v_tagged_count 
                      FROM GIAC_COMM_FUND_EXT
                     WHERE comm_slip_tag = 'Y'
                       AND gacc_tran_id = p_gacc_tran_id
                       -- added to check on selected records only : shan 10.30.2014
                       AND rec_id IN (SELECT regexp_substr(p_in_rec_id,'[^,]+', 1, level) FROM dual
                                      CONNECT BY regexp_substr(p_in_rec_id, '[^,]+', 1, level) IS NOT NULL);

                    SELECT COUNT(comm_slip_no)
                      INTO v_actual_count 
                      FROM GIAC_COMM_FUND_EXT
                     WHERE comm_slip_pref = b.comm_slip_pref
         	           AND comm_slip_no = b.comm_slip_no
                       AND gacc_tran_id = p_gacc_tran_id
                       -- added to check on selected records only : shan 10.30.2014
                       AND rec_id IN (SELECT regexp_substr(p_in_rec_id,'[^,]+', 1, level) FROM dual
                                      CONNECT BY regexp_substr(p_in_rec_id, '[^,]+', 1, level) IS NOT NULL);
                    
                    IF v_tagged_count <> v_actual_count THEN 
                        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Please select all records having the same comm fund slip number.');
                    END IF;
                END LOOP;
                
                /* Commented out by reymon 06182013
                UPDATE GIAC_COMM_FUND_EXT
                   SET comm_slip_tag = 'N'
                 WHERE gacc_tran_id = p_gacc_tran_id;*/
            ELSE
                /*FOR c IN(SELECT doc_pref_suf slip_pref, doc_seq_no slip_no
  	               	       FROM GIAC_DOC_SEQUENCE								
						  WHERE fund_cd = (SELECT a.fund_cd
                                             FROM GIAC_PAYT_REQUESTS a, 
                                                  GIAC_PAYT_REQUESTS_DTL b 
                                            WHERE a.ref_id = b.gprq_ref_id  
   											  AND b.tran_id = p_gacc_tran_id)
  	                		AND branch_cd = (SELECT a.branch_cd
                                               FROM GIAC_PAYT_REQUESTS a, 
                                                    GIAC_PAYT_REQUESTS_DTL b 
                                              WHERE a.ref_id = b.gprq_ref_id  
                                                AND b.tran_id = p_gacc_tran_id)
	 	        			AND doc_name = 'COMM_FUND')
                LOOP
                    p_comm_slip_pref := c.slip_pref;
                    p_comm_slip_no := c.slip_no;
                    p_comm_slip_date := TO_CHAR(SYSDATE, 'MM-dd-yyyy');
                    GIACS157_PKG.save_slip_no(p_gacc_tran_id, c.slip_pref, c.slip_no);
                END LOOP;*/
                
                BEGIN   -- replacement for commented codes above : shan 10.30.2014
                    SELECT doc_pref_suf slip_pref, doc_seq_no slip_no
                      INTO p_comm_slip_pref, p_comm_slip_no
                      FROM GIAC_DOC_SEQUENCE								
                     WHERE fund_cd = (SELECT a.fund_cd
                                        FROM GIAC_PAYT_REQUESTS a, 
                                             GIAC_PAYT_REQUESTS_DTL b 
                                       WHERE a.ref_id = b.gprq_ref_id  
                                         AND b.tran_id = p_gacc_tran_id)
                       AND branch_cd = (SELECT a.branch_cd
                                          FROM GIAC_PAYT_REQUESTS a, 
                                               GIAC_PAYT_REQUESTS_DTL b 
                                         WHERE a.ref_id = b.gprq_ref_id  
                                           AND b.tran_id = p_gacc_tran_id)
                       AND doc_name = 'COMM_FUND';
                
                    p_comm_slip_date := TO_CHAR(SYSDATE, 'MM-dd-yyyy');
                    GIACS157_PKG.save_slip_no(p_gacc_tran_id, p_comm_slip_pref, p_comm_slip_no);
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        raise_application_error(-20001, 'Geniisys Exception#E#No data found in GIAC_DOC_SEQUENCE.');
                END;
            END IF;
        END IF;
    END;
    
    /*
    **  Created by: Marco Paolo Rebong
    **  Date Created: 06.05.2013
    **  Reference By: GIACS157 - Commission Fund
    **  Description: save generated comm slip number
    */
    PROCEDURE save_slip_no(
        p_gacc_tran_id              GIAC_COMM_FUND_EXT.gacc_tran_id%TYPE,
        p_comm_slip_pref            GIAC_COMM_FUND_EXT.comm_slip_pref%TYPE,
        p_comm_slip_no              GIAC_COMM_FUND_EXT.comm_slip_no%TYPE
    )
    IS
    BEGIN
        UPDATE GIAC_COMM_FUND_EXT
           SET comm_slip_flag = 'P',
	       	   comm_slip_pref = p_comm_slip_pref,
	     	   comm_slip_no = p_comm_slip_no,
               comm_slip_date = SYSDATE
               --comm_slip_tag = 'N' commented out by reymon 06202013
         WHERE comm_slip_tag = 'Y'
   	       AND gacc_tran_id = p_gacc_tran_id;
           
        UPDATE GIAC_DOC_SEQUENCE
	 	   SET doc_seq_no = doc_seq_no + 1	   							 	
	     WHERE fund_cd = (SELECT a.fund_cd
                            FROM GIAC_PAYT_REQUESTS a, 
                                 GIAC_PAYT_REQUESTS_DTL b 
						   WHERE a.ref_id = b.gprq_ref_id  
							 AND b.tran_id = p_gacc_tran_id)
		   AND branch_cd = (SELECT a.branch_cd
					          FROM GIAC_PAYT_REQUESTS a, 
								   GIAC_PAYT_REQUESTS_DTL b 
						     WHERE a.ref_id = b.gprq_ref_id  
							   AND b.tran_id = p_gacc_tran_id)			   							 
	 	   AND doc_name = 'COMM_FUND';
    END;
    
    /*
    **  Created by: Reymon Santos
    **  Date Created: 06.18.2013
    **  Reference By: GIACS157 - Commission Fund
    **  Description: Process after printing comm fund slip
    */
    PROCEDURE proccess_after_printing(
        p_gacc_tran_id              giac_comm_fund_ext.gacc_tran_id%TYPE,
        p_sw                        NUMBER
    )
    AS
    BEGIN
        IF p_sw = 1 THEN
            UPDATE giac_comm_fund_ext
               SET comm_slip_date = SYSDATE
             WHERE comm_slip_tag = 'Y'
               AND gacc_tran_id  = p_gacc_tran_id;
        ELSIF p_sw = 0 THEN    -- added to spoil the CFS if printing is unsuccessful : shan 10.21.2014
            UPDATE giac_comm_fund_ext
               SET spoiled_tag = 'Y'
             WHERE comm_slip_tag = 'Y'
               AND gacc_tran_id  = p_gacc_tran_id;
               
             /*UPDATE GIAC_DOC_SEQUENCE
               SET doc_seq_no = doc_seq_no - 1	   							 	
             WHERE fund_cd = (SELECT a.fund_cd
                                FROM GIAC_PAYT_REQUESTS a, 
                                     GIAC_PAYT_REQUESTS_DTL b 
                               WHERE a.ref_id = b.gprq_ref_id  
                                 AND b.tran_id = p_gacc_tran_id)
               AND branch_cd = (SELECT a.branch_cd
                                  FROM GIAC_PAYT_REQUESTS a, 
                                       GIAC_PAYT_REQUESTS_DTL b 
                                 WHERE a.ref_id = b.gprq_ref_id  
                                   AND b.tran_id = p_gacc_tran_id)			   							 
               AND doc_name = 'COMM_FUND';*/
        ELSIF p_sw = 3 THEN 
           UPDATE giac_comm_fund_ext
              SET comm_slip_tag = 'N'
            WHERE comm_slip_tag = 'Y'
              AND gacc_tran_id  = p_gacc_tran_id;  
        ELSE    -- added to revert if user press Cancel in print overlay without printing new CFS
            UPDATE giac_comm_fund_ext
               SET comm_slip_date = NULL,
                   comm_slip_pref = NULL,
                   comm_slip_no = NULL,
                   comm_slip_flag = NULL,
                   comm_slip_tag = 'N'
             WHERE comm_slip_tag = 'Y'
               AND gacc_tran_id  = p_gacc_tran_id;
        END IF;
        
        UPDATE giac_comm_fund_ext
           SET comm_slip_tag = 'N'
         WHERE comm_slip_tag = 'Y'
           AND gacc_tran_id  = p_gacc_tran_id;
    END proccess_after_printing;

END; 
/

