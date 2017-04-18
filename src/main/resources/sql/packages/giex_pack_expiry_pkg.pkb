CREATE OR REPLACE PACKAGE BODY CPI.giex_pack_expiry_pkg AS
    FUNCTION check_pack_policy_id_giexs006 (
        p_pack_policy_id		giex_pack_expiry.pack_policy_id%TYPE
        )
        RETURN VARCHAR2 IS
            v_result VARCHAR2(1) := 'N';
        BEGIN
            FOR i IN(SELECT '1'
                       FROM giex_pack_expiry
                      WHERE pack_policy_id = p_pack_policy_id)
            LOOP
        	    v_result := 'Y';
            END LOOP;
            RETURN v_result;
        END check_pack_policy_id_giexs006;
    FUNCTION get_pack_policy_id (
		p_dsp_policy_id		giex_pack_expiry.pack_policy_id%TYPE,
        p_fr_rn_seq_no      giex_pack_rn_no.rn_seq_no%TYPE,
        p_to_rn_seq_no      giex_pack_rn_no.rn_seq_no%TYPE,
        p_assd_no           giex_pack_expiry.assd_no%TYPE,
        p_intm_no           giex_pack_expiry.intm_no%TYPE,
        p_iss_cd            giex_pack_expiry.iss_cd%TYPE,
        p_subline_cd        giex_pack_expiry.subline_cd%TYPE,
        p_line_cd           giex_pack_expiry.line_cd%TYPE,
        p_start_date        VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
        p_end_date          VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
		p_renew_flag		giex_pack_expiry.renew_flag%TYPE,
        p_user_id           giis_users.user_id%TYPE,
		p_req_renewal_no	VARCHAR2
	)
        RETURN giex_pack_expiry_tab PIPELINED IS
            v_pack_policy_id         giex_pack_expiry_type;
            v_count                  NUMBER := 0; -- bonok :: 9.7.2015 :: SR 20372 for optimization
	BEGIN
		IF p_req_renewal_no = 'Y' THEN
			FOR i IN(SELECT b.pack_policy_id
					   FROM giex_pack_expiry b, giex_pack_rn_no c
			 		  WHERE b.renew_flag = p_renew_flag
				 		AND b.pack_policy_id = c.pack_policy_id
                        AND NVL(b.post_flag,'N') = 'N' --Added by Jerome Bautista 07.29.2015 SR 19628/19781
				 		AND c.rn_seq_no BETWEEN NVL(p_fr_rn_seq_no,c.rn_seq_no) AND NVL(p_to_rn_seq_no,c.rn_seq_no)
				 		AND b.pack_policy_id = NVL(p_dsp_policy_id, b.pack_policy_id)
				 		AND b.assd_no = NVL(p_assd_no, b.assd_no)
				 		--AND NVL(b.intm_no,0) = NVL(p_intm_no,NVL(b.intm_no,0)) --benjo 08.11.2015 UCPBGEN-SR-19846
--                        AND (   DECODE (NVL (p_intm_no, 0), 0, 1, 0) = 1 -- bonok :: 9.7.2015 :: SR 20372 for optimization
--                             OR p_intm_no IN (SELECT x.intm_no
--                                                FROM giex_expiry x
--                                               WHERE x.pack_policy_id = b.pack_policy_id)) --benjo 08.11.2015 UCPBGEN-SR-19846
				 		AND UPPER(b.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(b.iss_cd))
				 		AND UPPER(b.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(b.subline_cd))
				 		AND UPPER(b.line_cd) = NVL(UPPER(p_line_cd),UPPER(b.line_cd))
				 		AND TRUNC(b.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), b.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
				 		AND TRUNC(b.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(b.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), b.expiry_date)))
				 		AND b.extract_user = p_user_id)
			LOOP
				IF p_intm_no IS NOT NULL THEN -- bonok :: 9.7.2015 :: SR 20372 for optimization start
               FOR i1 IN (SELECT DISTINCT(x.pack_policy_id)
                            FROM giex_expiry x
                           WHERE x.pack_policy_id = i.pack_policy_id
                             AND TRUNC(x.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
                             AND TRUNC(x.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(x.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date)))
                             AND x.extract_user = p_user_id
                             AND x.intm_no = p_intm_no)
               LOOP
                  v_count := v_count + 1;
                  v_pack_policy_id.pack_policy_id := i.pack_policy_id;
                  PIPE ROW(v_pack_policy_id); 
                  EXIT;
               END LOOP;
            ELSE
               v_pack_policy_id.pack_policy_id := i.pack_policy_id;
				   PIPE ROW(v_pack_policy_id); 
            END IF;
--            v_pack_policy_id.pack_policy_id := i.pack_policy_id;
--            PIPE ROW(v_pack_policy_id);
            IF v_count > 5 THEN
               RETURN;
            END IF; -- bonok :: 9.7.2015 :: SR 20372 for optimization end
			END LOOP;
		ELSIF p_req_renewal_no = 'N' THEN
			FOR j IN(SELECT b.pack_policy_id
					   FROM giex_pack_expiry b
			          WHERE b.renew_flag = p_renew_flag				 
				  		AND b.pack_policy_id = NVL(p_dsp_policy_id, b.pack_policy_id)
                        AND NVL(b.post_flag,'N') = 'N' --Added by Jerome Bautista 07.29.2015 SR 19628/19781
				 		AND b.assd_no = NVL(p_assd_no, b.assd_no)
				 		--AND NVL(b.intm_no,0) = NVL(p_intm_no,NVL(b.intm_no,0)) --benjo 08.11.2015 UCPBGEN-SR-19846
--                        AND (   DECODE (NVL (p_intm_no, 0), 0, 1, 0) = 1 -- bonok :: 9.7.2015 :: SR 20372 for optimization
--                             OR p_intm_no IN (SELECT x.intm_no
--                                                FROM giex_expiry x
--                                               WHERE x.pack_policy_id = b.pack_policy_id)) --benjo 08.11.2015 UCPBGEN-SR-19846
				 		AND UPPER(b.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(b.iss_cd))
				 		AND UPPER(b.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(b.subline_cd))
				 		AND UPPER(b.line_cd) = NVL(UPPER(p_line_cd),UPPER(b.line_cd))
				 		AND TRUNC(b.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), b.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
				 		AND TRUNC(b.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(b.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), b.expiry_date)))
				 		AND b.extract_user = p_user_id)
			LOOP
				IF p_intm_no IS NOT NULL THEN -- bonok :: 9.7.2015 :: SR 20372 for optimization start
               FOR j1 IN (SELECT DISTINCT(x.pack_policy_id)
                            FROM giex_expiry x
                           WHERE x.pack_policy_id = j.pack_policy_id
                             AND TRUNC(x.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
                             AND TRUNC(x.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(x.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date)))
                             AND x.extract_user = p_user_id
                             AND x.intm_no = p_intm_no)
               LOOP
                  v_count := v_count + 1;
                  v_pack_policy_id.pack_policy_id := j.pack_policy_id;
                  PIPE ROW(v_pack_policy_id); 
                  EXIT;
               END LOOP;
            ELSE
               v_pack_policy_id.pack_policy_id := j.pack_policy_id;
				   PIPE ROW(v_pack_policy_id); 
            END IF;
--            v_pack_policy_id.pack_policy_id := j.pack_policy_id;
--            PIPE ROW(v_pack_policy_id);
            IF v_count > 5 THEN
               RETURN;
            END IF; -- bonok :: 9.7.2015 :: SR 20372 for optimization end
			END LOOP;
		ELSIF p_req_renewal_no = 'M' THEN
			FOR k IN(SELECT b.pack_policy_id 
					   FROM giex_pack_expiry b
					  WHERE b.renew_flag = p_renew_flag	 	                
						AND b.pack_policy_id = NVL(p_dsp_policy_id, b.pack_policy_id)
                        AND NVL(b.post_flag,'N') = 'N' --Added by Jerome Bautista 07.29.2015 SR 19628/19781
						AND b.assd_no = NVL(p_assd_no, b.assd_no)
						--AND NVL(b.intm_no,0) = NVL(p_intm_no,NVL(b.intm_no,0)) --benjo 08.11.2015 UCPBGEN-SR-19846
--                        AND (   DECODE (NVL (p_intm_no, 0), 0, 1, 0) = 1 -- bonok :: 9.7.2015 :: SR 20372 for optimization
--                             OR p_intm_no IN (SELECT x.intm_no
--                                                FROM giex_expiry x
--                                               WHERE x.pack_policy_id = b.pack_policy_id)) --benjo 08.11.2015 UCPBGEN-SR-19846
						AND UPPER(b.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(b.iss_cd))
						AND UPPER(b.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(b.subline_cd))
						AND UPPER(b.line_cd) = NVL(UPPER(p_line_cd),UPPER(b.line_cd))
						AND TRUNC(b.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), b.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
						AND TRUNC(b.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(b.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), b.expiry_date)))
						AND b.extract_user = p_user_id
						AND EXISTS (SELECT 1
									  FROM giex_pack_rn_no c
									 WHERE b.pack_policy_id = c.pack_policy_id
									   AND c.rn_seq_no BETWEEN p_fr_rn_seq_no AND p_to_rn_seq_no
									   AND 1 = DECODE(NVL(p_req_renewal_no,'M'), 'M', 2, 1)
									 UNION   
									SELECT 1
									  FROM dual
									 WHERE 1 = DECODE(NVL(p_req_renewal_no,'M'), 'M', 1, 2)))
			LOOP
				IF p_intm_no IS NOT NULL THEN -- bonok :: 9.7.2015 :: SR 20372 for optimization start
               FOR k1 IN (SELECT DISTINCT(x.pack_policy_id)
                            FROM giex_expiry x
                           WHERE x.pack_policy_id = k.pack_policy_id
                             AND TRUNC(x.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
                             AND TRUNC(x.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(x.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date)))
                             AND x.extract_user = p_user_id
                             AND x.intm_no = p_intm_no)
               LOOP
                  v_count := v_count + 1;
                  v_pack_policy_id.pack_policy_id := k.pack_policy_id;
                  PIPE ROW(v_pack_policy_id); 
                  EXIT;
               END LOOP;
            ELSE
               v_pack_policy_id.pack_policy_id := k.pack_policy_id;
				   PIPE ROW(v_pack_policy_id); 
            END IF;
--            v_pack_policy_id.pack_policy_id := k.pack_policy_id;
--            PIPE ROW(v_pack_policy_id);
            IF v_count > 5 THEN
               RETURN;
            END IF; -- bonok :: 9.7.2015 :: SR 20372 for optimization end
			END LOOP;
		END IF;
    END get_pack_policy_id;
    FUNCTION check_pack_record_user (
        p_pack_policy_id	giex_pack_expiry.pack_policy_id%TYPE,
        p_assd_no		    giex_pack_expiry.assd_no%TYPE,
        p_intm_no		    giex_pack_expiry.intm_no%TYPE,
        p_iss_cd		    giex_pack_expiry.iss_cd%TYPE,
        p_subline_cd	    giex_pack_expiry.subline_cd%TYPE,
        p_line_cd		    giex_pack_expiry.line_cd%TYPE,
        p_start_date        VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
        p_end_date          VARCHAR2,--giex_pack_expiry.expiry_date%TYPE, changed to varchar kenneth 11.24.2014
        p_fr_rn_seq_no	    giex_pack_rn_no.rn_seq_no%TYPE,
        p_to_rn_seq_no	    giex_pack_rn_no.rn_seq_no%TYPE,
        p_user_id		    giis_users.user_id%TYPE 
    )
    RETURN VARCHAR2 IS
        v_valid	VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN(SELECT a.pack_policy_id 
  	               FROM giex_pack_expiry a, giex_pack_rn_no b
                  WHERE a.renew_flag = 2
  	                AND a.pack_policy_id = b.pack_policy_id
	 	            AND b.rn_seq_no BETWEEN NVL(p_fr_rn_seq_no,b.rn_seq_no) AND NVL(p_to_rn_seq_no,b.rn_seq_no)
	 	            AND a.pack_policy_id = NVL(p_pack_policy_id, a.pack_policy_id)
		            AND a.assd_no = NVL(p_assd_no, a.assd_no)
		            --AND NVL(a.intm_no,0) = NVL(p_intm_no,NVL(a.intm_no,0)) --benjo 08.11.2015 UCPBGEN-SR-19846
--                    AND (   DECODE (NVL (p_intm_no, 0), 0, 1, 0) = 1 -- bonok :: 9.7.2015 :: SR 20372 for optimization
--                         OR p_intm_no IN (SELECT x.intm_no
--                                            FROM giex_expiry x
--                                           WHERE x.pack_policy_id = a.pack_policy_id)) --benjo 08.11.2015 UCPBGEN-SR-19846
	    	        AND UPPER(a.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
	                AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
	                AND UPPER(a.line_cd) = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
	                AND TRUNC(a.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), a.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
  	                AND TRUNC(a.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(a.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), a.expiry_date))) 
                    AND a.extract_user = p_user_id)
	    LOOP
            IF p_intm_no IS NOT NULL THEN -- bonok :: 9.7.2015 :: SR 20372 for optimization start
               FOR i1 IN (SELECT DISTINCT(x.pack_policy_id)
                            FROM giex_expiry x
                           WHERE x.pack_policy_id = i.pack_policy_id
                             AND TRUNC(x.expiry_date) <= TRUNC(NVL(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date))) --to_date start and end date parameters to varchar kenneth 11.24.2014
                             AND TRUNC(x.expiry_date) >= DECODE(TO_DATE(p_end_date, 'DD-fmMON-YYYY'), NULL, TRUNC(x.expiry_date), TRUNC(NVL(TO_DATE(p_start_date, 'DD-fmMON-YYYY'), x.expiry_date)))
                             AND x.extract_user = p_user_id
                             AND x.intm_no = p_intm_no)
               LOOP
                  v_valid := 'Y';
                  RETURN v_valid;
               END LOOP;
            ELSE
               v_valid := 'Y';
               RETURN v_valid;
            END IF; -- bonok :: 9.7.2015 :: SR 20372 for optimization end
            --v_valid := 'Y';
       END LOOP;
	    RETURN v_valid;
    END check_pack_record_user;
END giex_pack_expiry_pkg;
/


