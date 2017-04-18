CREATE OR REPLACE PACKAGE BODY CPI.GIPIS161A_PKG
AS
    FUNCTION get_pack_policy_listing (
        p_user_id               giis_users.user_id%TYPE,
        p_pack_pol_line_cd      gipi_pack_polbasic.line_cd%TYPE,
        p_pack_pol_subline_cd   gipi_pack_polbasic.subline_cd%TYPE,
        p_pack_pol_iss_cd       gipi_pack_polbasic.iss_cd%TYPE,
        p_pack_pol_issue_yy     gipi_pack_polbasic.issue_yy%TYPE,
        p_pack_pol_seq_no       gipi_pack_polbasic.pol_seq_no%TYPE,
        p_pack_pol_renew_no     gipi_pack_polbasic.renew_no%TYPE,
        p_pack_par_line_cd      gipi_pack_parlist.line_cd%TYPE,
        p_pack_par_iss_cd       gipi_pack_parlist.iss_cd%TYPE,
        p_pack_par_yy           gipi_pack_parlist.par_yy%TYPE,
        p_pack_par_seq_no       gipi_pack_parlist.par_seq_no%TYPE,
        p_pack_par_quote_seq_no gipi_pack_parlist.quote_seq_no%TYPE,
        p_pack_endt_iss_cd      gipi_pack_polbasic.endt_iss_cd%TYPE,
        p_pack_endt_yy          gipi_pack_polbasic.endt_yy%TYPE,
        p_pack_endt_seq_no      gipi_pack_polbasic.endt_seq_no%TYPE,
        p_assd_name             giis_assured.assd_name%TYPE
    )
        RETURN pack_policy_tab PIPELINED
    IS
        TYPE cur_type IS REF CURSOR;
        cur     cur_type;
        v_query VARCHAR2(32000);
        v_      pack_policy_type;
    BEGIN
        v_query := 'SELECT a.pack_policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, ' || 
                           'line_cd ' ||
                           '|| ''-'' ' ||
                           '|| subline_cd ' ||
                           '|| ''-'' ' ||
                           '|| iss_cd ' ||
                           '|| ''-'' ' ||
                           '|| LTRIM(TO_CHAR(issue_yy, ''09'')) ' ||
                           '|| ''-'' ' ||
                           '|| LTRIM(TO_CHAR(pol_seq_no, ''0999999'')) ' ||
                           '|| ''-'' ' ||
                           '|| LTRIM(TO_CHAR(renew_no, ''09'')) pack_policy_no, ' ||
                           'a.pack_par_id, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, ' ||
                           'endt_iss_cd ' ||
                           '|| ''-'' ' ||
                           '|| LTRIM(TO_CHAR(endt_yy, ''09'')) ' ||
                           '|| ''-'' ' ||
                           '|| LTRIM(TO_CHAR(endt_seq_no, ''0999999'')) pack_endt_no, ' ||
                           'b.assd_name ' ||
                     'FROM gipi_pack_polbasic a, giis_assured b ' ||
                    'WHERE a.assd_no = b.assd_no ' ||
                      'AND a.line_cd = NVL(''' || p_pack_pol_line_cd || ''', a.line_cd) ' ||
                      'AND a.subline_cd = NVL(''' || p_pack_pol_subline_cd || ''', a.subline_cd) ' ||
                      'AND a.iss_cd = NVL(''' || p_pack_pol_iss_cd || ''', a.iss_cd) ' ||
                      'AND a.issue_yy = NVL(''' || p_pack_pol_issue_yy || ''', a.issue_yy) ' ||
                      'AND a.pol_seq_no = NVL(''' || p_pack_pol_seq_no || ''', a.pol_seq_no) ' ||
                      'AND a.renew_no = NVL(''' || p_pack_pol_renew_no || ''', a.renew_no) ' ||
                      'AND a.endt_iss_cd = NVL(''' || p_pack_endt_iss_cd || ''', a.endt_iss_cd) ' ||
                      'AND a.endt_yy = NVL(''' || p_pack_endt_yy || ''', a.endt_yy) ' ||
                      'AND a.endt_seq_no = NVL(''' || p_pack_endt_seq_no || ''', a.endt_seq_no) ' ||
                      'AND b.assd_name = NVL(''' || p_assd_name || ''', b.assd_name) ' ||
                      'AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GIPIS161A'', ''' || p_user_id || ''') = 1';
                      
        IF p_pack_par_line_cd IS NOT NULL OR p_pack_par_iss_cd IS NOT NULL OR p_pack_par_yy IS NOT NULL OR p_pack_par_seq_no IS NOT NULL OR p_pack_par_quote_seq_no IS NOT NULL THEN
            v_query := v_query ||
                      'AND a.pack_par_id IN(' ||
                                            'SELECT pack_par_id ' ||
                                              'FROM gipi_pack_parlist ' ||
                                             'WHERE line_cd = NVL(''' || p_pack_par_line_cd || ''', line_cd) ' ||
                                               'AND iss_cd = NVL(''' || p_pack_par_iss_cd || ''', iss_cd) ' ||
                                               'AND par_yy = NVL(''' || p_pack_par_yy || ''', par_yy) ' ||
                                               'AND par_seq_no = NVL(''' || p_pack_par_seq_no || ''', par_seq_no) ' ||
                                               'AND quote_seq_no = NVL(''' || p_pack_par_quote_seq_no || ''', quote_seq_no) ' ||
                                           ')';
        END IF;

        OPEN cur FOR v_query;
        LOOP
            FETCH cur
             INTO v_.pack_policy_id, v_.pack_pol_line_cd, v_.pack_pol_subline_cd, v_.pack_pol_iss_cd, v_.pack_pol_issue_yy, v_.pack_pol_seq_no, v_.pack_pol_renew_no,
                  v_.pack_policy_no, v_.pack_par_id, v_.pack_endt_iss_cd, v_.pack_endt_yy, v_.pack_endt_seq_no, v_.pack_endt_no, v_.assd_name;
                  
            SELECT line_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || TRIM(TO_CHAR(par_yy, '09'))
                   || '-'
                   || TRIM(TO_CHAR(par_seq_no, '000009'))
                   || '-'
                   || TRIM(TO_CHAR(quote_seq_no, '09')) par_no, line_cd, iss_cd,
                   TRIM(TO_CHAR(par_yy, '09')) par_yy, TRIM(TO_CHAR(par_seq_no, '000009')) par_seq_no, TRIM(TO_CHAR(quote_seq_no, '09')) quote_seq_no
              INTO v_.pack_par_no, v_.pack_par_line_cd, v_.pack_par_iss_cd, v_.pack_par_yy, v_.pack_par_seq_no, v_.pack_par_quote_seq_no
              FROM gipi_pack_parlist
             WHERE pack_par_id = v_.pack_par_id
               AND ROWNUM = 1;
               
            IF v_.pack_endt_seq_no = 0 THEN
                v_.pack_endt_iss_cd := NULL;
                v_.pack_endt_yy := NULL;
                v_.pack_endt_seq_no := NULL;
                v_.pack_endt_no := NULL;
            END IF;
            
            IF v_.pack_policy_id IS NOT NULL THEN
                BEGIN
                    SELECT line_cd
                           || '-'
                           || subline_cd
                           || '-'
                           || iss_cd
                           || '-'
                           || TRIM(TO_CHAR(issue_yy, '009'))
                           || '-'
                           || TRIM(TO_CHAR(pol_seq_no, '00009')
                           || '-00') pack_policy_no
                      INTO v_.pack_policy_no
                      FROM gipi_pack_polbasic
                     WHERE pack_policy_id = v_.pack_policy_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_.pack_policy_no := NULL;
                END;
            END IF;
            
            EXIT WHEN cur%NOTFOUND;
            PIPE ROW(v_);
        END LOOP;
        CLOSE cur;    
    END get_pack_policy_listing;
    
    FUNCTION get_pack_gen_init_info (
        p_pack_policy_id    gipi_pack_polbasic.pack_policy_id%TYPE
    )
        RETURN pack_gen_init_info_tab PIPELINED
    AS
        v_      pack_gen_init_info_type;
    BEGIN
        SELECT gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, gen_info06,
               gen_info07, gen_info08, gen_info09, gen_info10, gen_info11, gen_info12,
               gen_info13, gen_info14, gen_info15, gen_info16, gen_info17,
               initial_info01, initial_info02, initial_info03, initial_info04, initial_info05,
               initial_info06, initial_info07, initial_info08, initial_info09, initial_info10,
               initial_info11, initial_info12, initial_info13, initial_info14, initial_info15,
               initial_info16, initial_info17, user_id,
               TO_CHAR(last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
          INTO v_.gen_info01, v_.gen_info02, v_.gen_info03, v_.gen_info04, v_.gen_info05, v_.gen_info06,
               v_.gen_info07, v_.gen_info08, v_.gen_info09, v_.gen_info10, v_.gen_info11, v_.gen_info12,
               v_.gen_info13, v_.gen_info14, v_.gen_info15, v_.gen_info16, v_.gen_info17,
               v_.initial_info01, v_.initial_info02, v_.initial_info03, v_.initial_info04, v_.initial_info05,
               v_.initial_info06, v_.initial_info07, v_.initial_info08, v_.initial_info09, v_.initial_info10,
               v_.initial_info11, v_.initial_info12, v_.initial_info13, v_.initial_info14, v_.initial_info15,
               v_.initial_info16, v_.initial_info17, v_.user_id, v_.last_update
          FROM gipi_pack_polgenin
         WHERE pack_policy_id = p_pack_policy_id;
         
         PIPE ROW(v_);
    END get_pack_gen_init_info;
    
    FUNCTION get_pack_endt_info (
        p_pack_policy_id    gipi_pack_polbasic.pack_policy_id%TYPE
    )
        RETURN endt_info_tab PIPELINED
    AS
        v_      endt_info_type;
    BEGIN    
        SELECT endt_text01, endt_text02, endt_text03, endt_text04, endt_text05, endt_text06,
               endt_text07, endt_text08, endt_text09, endt_text10, endt_text11, endt_text12,
               endt_text13, endt_text14, endt_text15, endt_text16, endt_text17,
               user_id, TO_CHAR(last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
          INTO v_.endt_text01, v_.endt_text02, v_.endt_text03, v_.endt_text04, v_.endt_text05, v_.endt_text06,
               v_.endt_text07, v_.endt_text08, v_.endt_text09, v_.endt_text10, v_.endt_text11, v_.endt_text12,
               v_.endt_text13, v_.endt_text14, v_.endt_text15, v_.endt_text16, v_.endt_text17,
               v_.user_id, v_.last_update
          FROM gipi_pack_endttext
         WHERE pack_policy_id = p_pack_policy_id;
         
         PIPE ROW(v_);
    END get_pack_endt_info;
    
    PROCEDURE set_gen_gipi_pack_polgenin(
        p_set   gipi_pack_polgenin%ROWTYPE
    )
    IS
    BEGIN
        MERGE INTO gipi_pack_polgenin
             USING DUAL
                ON (pack_policy_id = p_set.pack_policy_id)
            WHEN NOT MATCHED THEN
                INSERT (pack_policy_id, 
                        gen_info01,gen_info02,gen_info03,gen_info04,gen_info05,gen_info06,
                        gen_info07,gen_info08,gen_info09,gen_info10,gen_info11,gen_info12,
                        gen_info13,gen_info14,gen_info15,gen_info16,gen_info17,
                        user_id, last_update)
                VALUES (p_set.pack_policy_id,
                        p_set.gen_info01,p_set.gen_info02,p_set.gen_info03,p_set.gen_info04,p_set.gen_info05,p_set.gen_info06,
                        p_set.gen_info07,p_set.gen_info08,p_set.gen_info09,p_set.gen_info10,p_set.gen_info11,p_set.gen_info12,
                        p_set.gen_info13,p_set.gen_info14,p_set.gen_info15,p_set.gen_info16,p_set.gen_info17,
                        p_set.user_id, p_set.last_update)
            WHEN MATCHED THEN
                UPDATE
                    SET gen_info01 = p_set.gen_info01,
                        gen_info02 = p_set.gen_info02,
                        gen_info03 = p_set.gen_info03,
                        gen_info04 = p_set.gen_info04,
                        gen_info05 = p_set.gen_info05,
                        gen_info06 = p_set.gen_info06,
                        gen_info07 = p_set.gen_info07,
                        gen_info08 = p_set.gen_info08,
                        gen_info09 = p_set.gen_info09,
                        gen_info10 = p_set.gen_info10,
                        gen_info11 = p_set.gen_info11,
                        gen_info12 = p_set.gen_info12,
                        gen_info13 = p_set.gen_info13,
                        gen_info14 = p_set.gen_info14,
                        gen_info15 = p_set.gen_info15,
                        gen_info16 = p_set.gen_info16,
                        gen_info17 = p_set.gen_info17,
                        user_id    = p_set.user_id,
                        last_update = p_set.last_update;
                        
        -- update sub-policies general info.
        FOR rec IN (SELECT policy_id FROM gipi_polbasic WHERE pack_policy_id = p_set.pack_policy_id)
        LOOP
        	MERGE INTO gipi_polgenin
			 USING dual
				ON (policy_id = rec.policy_id)
			WHEN NOT MATCHED THEN
				INSERT (policy_id, 
					gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, 
					gen_info06, gen_info07, gen_info08, gen_info09, gen_info10, 
					gen_info11, gen_info12, gen_info13, gen_info14, gen_info15, 
					gen_info16, gen_info17, user_id, last_update)
				VALUES (rec.policy_id, 
                    p_set.gen_info01, p_set.gen_info02, p_set.gen_info03, p_set.gen_info04, p_set.gen_info05, 
					p_set.gen_info06, p_set.gen_info07, p_set.gen_info08, p_set.gen_info09, p_set.gen_info10, 
					p_set.gen_info11, p_set.gen_info12, p_set.gen_info13, p_set.gen_info14, p_set.gen_info15, 
					p_set.gen_info16, p_set.gen_info17, p_set.user_id, SYSDATE)
			WHEN MATCHED THEN
				UPDATE
				SET gen_info01 = p_set.gen_info01,
					gen_info02 = p_set.gen_info02,
					gen_info03 = p_set.gen_info03,
					gen_info04 = p_set.gen_info04,
					gen_info05 = p_set.gen_info05,
					gen_info06 = p_set.gen_info06,
					gen_info07 = p_set.gen_info07,
					gen_info08 = p_set.gen_info08,
					gen_info09 = p_set.gen_info09,
					gen_info10 = p_set.gen_info10,
					gen_info11 = p_set.gen_info11,
					gen_info12 = p_set.gen_info12,
					gen_info13 = p_set.gen_info13,
					gen_info14 = p_set.gen_info14,
					gen_info15 = p_set.gen_info15,
					gen_info16 = p_set.gen_info16,
					gen_info17 = p_set.gen_info17,
					user_id    = p_set.user_id,
					last_update = SYSDATE;
        END LOOP;
    END set_gen_gipi_pack_polgenin;
    
    PROCEDURE set_init_gipi_pack_polgenin(
        p_set   gipi_pack_polgenin%ROWTYPE
    )   
    IS
    BEGIN
        MERGE INTO gipi_pack_polgenin
             USING DUAL
                ON (pack_policy_id = p_set.pack_policy_id)
            WHEN NOT MATCHED THEN
                INSERT (pack_policy_id, 
                        initial_info01,initial_info02,initial_info03,initial_info04,initial_info05,initial_info06,
                        initial_info07,initial_info08,initial_info09,initial_info10,initial_info11,initial_info12,
                        initial_info13,initial_info14,initial_info15,initial_info16,initial_info17,
                        user_id, last_update)
                VALUES (p_set.pack_policy_id,
                        p_set.initial_info01,p_set.initial_info02,p_set.initial_info03,p_set.initial_info04,p_set.initial_info05,p_set.initial_info06,
                        p_set.initial_info07,p_set.initial_info08,p_set.initial_info09,p_set.initial_info10,p_set.initial_info11,p_set.initial_info12,
                        p_set.initial_info13,p_set.initial_info14,p_set.initial_info15,p_set.initial_info16,p_set.initial_info17,
                        p_set.user_id, p_set.last_update)
            WHEN MATCHED THEN
                UPDATE
                    SET initial_info01 = p_set.initial_info01,
                        initial_info02 = p_set.initial_info02,
                        initial_info03 = p_set.initial_info03,
                        initial_info04 = p_set.initial_info04,
                        initial_info05 = p_set.initial_info05,
                        initial_info06 = p_set.initial_info06,
                        initial_info07 = p_set.initial_info07,
                        initial_info08 = p_set.initial_info08,
                        initial_info09 = p_set.initial_info09,
                        initial_info10 = p_set.initial_info10,
                        initial_info11 = p_set.initial_info11,
                        initial_info12 = p_set.initial_info12,
                        initial_info13 = p_set.initial_info13,
                        initial_info14 = p_set.initial_info14,
                        initial_info15 = p_set.initial_info15,
                        initial_info16 = p_set.initial_info16,
                        initial_info17 = p_set.initial_info17,
                        user_id    = p_set.user_id,
                        last_update = p_set.last_update;
                        
        -- update sub-policies initial info.
        FOR rec IN (SELECT policy_id FROM gipi_polbasic WHERE pack_policy_id = p_set.pack_policy_id)
        LOOP
            MERGE INTO gipi_polgenin
                 USING DUAL
                    ON (policy_id = rec.policy_id)
                WHEN NOT MATCHED THEN
                    INSERT (policy_id, 
                            initial_info01, initial_info02, initial_info03, initial_info04, initial_info05, 
                            initial_info06, initial_info07, initial_info08, initial_info09, initial_info10, 
                            initial_info11, initial_info12, initial_info13, initial_info14, initial_info15, 
                            initial_info16, initial_info17, user_id, last_update)
                    VALUES (rec.policy_id, 
                            p_set.initial_info01, p_set.initial_info02, p_set.initial_info03, p_set.initial_info04, p_set.initial_info05, 
                            p_set.initial_info06, p_set.initial_info07, p_set.initial_info08, p_set.initial_info09, p_set.initial_info10, 
                            p_set.initial_info11, p_set.initial_info12, p_set.initial_info13, p_set.initial_info14, p_set.initial_info15, 
                            p_set.initial_info16, p_set.initial_info17, p_set.user_id, p_set.last_update)
                WHEN MATCHED THEN
                    UPDATE
                        SET initial_info01 = p_set.initial_info01,
                            initial_info02 = p_set.initial_info02,
                            initial_info03 = p_set.initial_info03,
                            initial_info04 = p_set.initial_info04,
                            initial_info05 = p_set.initial_info05,
                            initial_info06 = p_set.initial_info06,
                            initial_info07 = p_set.initial_info07,
                            initial_info08 = p_set.initial_info08,
                            initial_info09 = p_set.initial_info09,
                            initial_info10 = p_set.initial_info10,
                            initial_info11 = p_set.initial_info11,
                            initial_info12 = p_set.initial_info12,
                            initial_info13 = p_set.initial_info13,
                            initial_info14 = p_set.initial_info14,
                            initial_info15 = p_set.initial_info15,
                            initial_info16 = p_set.initial_info16,
                            initial_info17 = p_set.initial_info17,
                            user_id    = p_set.user_id,
                            last_update = p_set.last_update;
        END LOOP;
    END set_init_gipi_pack_polgenin;
    
    PROCEDURE set_endt_gipi_pack_endttext(
        p_set   gipi_pack_endttext%ROWTYPE
    )
    IS
    BEGIN
        MERGE INTO gipi_pack_endttext
             USING DUAL
                ON (pack_policy_id = p_set.pack_policy_id)
            WHEN NOT MATCHED THEN
                INSERT (pack_policy_id,
                        endt_text01,endt_text02,endt_text03,endt_text04,endt_text05,endt_text06,
                        endt_text07,endt_text08,endt_text09,endt_text10,endt_text11,endt_text12,
                        endt_text13,endt_text14,endt_text15,endt_text16,endt_text17,
                        user_id, last_update)
                VALUES (p_set.pack_policy_id,
                        p_set.endt_text01,p_set.endt_text02,p_set.endt_text03,p_set.endt_text04,p_set.endt_text05,p_set.endt_text06,
                        p_set.endt_text07,p_set.endt_text08,p_set.endt_text09,p_set.endt_text10,p_set.endt_text11,p_set.endt_text12,
                        p_set.endt_text13,p_set.endt_text14,p_set.endt_text15,p_set.endt_text16,p_set.endt_text17,
                        p_set.user_id, p_set.last_update)
            WHEN MATCHED THEN
                UPDATE
                    SET endt_text01 = p_set.endt_text01,
                        endt_text02 = p_set.endt_text02,
                        endt_text03 = p_set.endt_text03,
                        endt_text04 = p_set.endt_text04,
                        endt_text05 = p_set.endt_text05,
                        endt_text06 = p_set.endt_text06,
                        endt_text07 = p_set.endt_text07,
                        endt_text08 = p_set.endt_text08,
                        endt_text09 = p_set.endt_text09,
                        endt_text10 = p_set.endt_text10,
                        endt_text11 = p_set.endt_text11,
                        endt_text12 = p_set.endt_text12,
                        endt_text13 = p_set.endt_text13,
                        endt_text14 = p_set.endt_text14,
                        endt_text15 = p_set.endt_text15,
                        endt_text16 = p_set.endt_text16,
                        endt_text17 = p_set.endt_text17,
                        user_id     = p_set.user_id,
                        last_update = p_set.last_update;
        
        -- update sub-policies endorsement text
        FOR rec IN (SELECT policy_id FROM gipi_polbasic WHERE pack_policy_id = p_set.pack_policy_id)
        LOOP
            MERGE INTO gipi_endttext
                 USING DUAL
                    ON (policy_id = rec.policy_id)
                WHEN NOT MATCHED THEN
                    INSERT (policy_id, 
                            endt_text01, endt_text02, endt_text03, endt_text04, endt_text05, 
                            endt_text06, endt_text07, endt_text08, endt_text09, endt_text10, 
                            endt_text11, endt_text12, endt_text13, endt_text14, endt_text15, 
                            endt_text16, endt_text17, user_id, last_update)
                    VALUES (rec.policy_id, 
                            p_set.endt_text01, p_set.endt_text02, p_set.endt_text03, p_set.endt_text04, p_set.endt_text05, 
                            p_set.endt_text06, p_set.endt_text07, p_set.endt_text08, p_set.endt_text09, p_set.endt_text10, 
                            p_set.endt_text11, p_set.endt_text12, p_set.endt_text13, p_set.endt_text14, p_set.endt_text15, 
                            p_set.endt_text16, p_set.endt_text17, p_set.user_id, p_set.last_update)
                WHEN MATCHED THEN
                    UPDATE
                        SET endt_text01 = p_set.endt_text01,
                            endt_text02 = p_set.endt_text02,
                            endt_text03 = p_set.endt_text03,
                            endt_text04 = p_set.endt_text04,
                            endt_text05 = p_set.endt_text05,
                            endt_text06 = p_set.endt_text06,
                            endt_text07 = p_set.endt_text07,
                            endt_text08 = p_set.endt_text08,
                            endt_text09 = p_set.endt_text09,
                            endt_text10 = p_set.endt_text10,
                            endt_text11 = p_set.endt_text11,
                            endt_text12 = p_set.endt_text12,
                            endt_text13 = p_set.endt_text13,
                            endt_text14 = p_set.endt_text14,
                            endt_text15 = p_set.endt_text15,
                            endt_text16 = p_set.endt_text16,
                            endt_text17 = p_set.endt_text17,
                            user_id     = p_set.user_id,
                            last_update = p_set.last_update;
        END LOOP;
    END set_endt_gipi_pack_endttext;
END GIPIS161A_PKG;
/
