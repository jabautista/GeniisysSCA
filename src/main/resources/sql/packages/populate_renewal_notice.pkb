CREATE OR REPLACE PACKAGE BODY CPI.populate_renewal_notice AS

  FUNCTION populate_renewal_notice_ucpb(
    p_policy_id        VARCHAR2, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
    p_policy_id2        VARCHAR2, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
    p_policy_id3        VARCHAR2, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb    
    p_start_date        DATE,
    p_end_date          DATE,
    p_fr_rn_seq_no      NUMBER,
    p_to_rn_seq_no      NUMBER,
    p_req_renewal_no    VARCHAR2,
    p_user_id           giis_users.user_id%TYPE /*added by cherrie, 11292012*/
  )
    RETURN renewal_tab PIPELINED AS
      v_renewal  renewal_type;
      v_found_flag NUMBER(1) := 0;
      v_autopa_flag NUMBER(1) := 0;
      v_policy_id NUMBER;
      v_temp_no NUMBER;
      v_line_cd VARCHAR2(1000); --Added by Jerome Bautista 07.30.2015 SR 19689
      v_menu_line_cd VARCHAR2(1000); --Added by Jerome Bautista 07.30.2015 SR 19689
      str populate_renewal_notice.policy_id_array; -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      i          NUMBER          := 0; -- Added by Jerome Bautista 07.10.2015 SR 19689
      POSITION   NUMBER          := 0; -- Added by Jerome Bautista 07.10.2015 SR 19689
      p_input    VARCHAR2 (30000) := p_policy_id || p_policy_id2 || p_policy_id3; -- Added by Jerome Bautista 07.10.2015 SR 19689
      output     policy_id_array; -- Added by Jerome Bautista 07.10.2015 SR 19689
            
   BEGIN
       BEGIN -- Added by Jerome Bautista 07.10.2015 SR 19689
          POSITION := INSTR (p_input, ',', 1, 1);

          IF POSITION = 0 THEN
             str (1) := p_input;
          END IF;

          WHILE (POSITION != 0)
          LOOP
             i := i + 1;
             str (i) := SUBSTR (p_input, 1, POSITION - 1);
             p_input := SUBSTR (p_input, POSITION + 1, LENGTH (p_input));
             POSITION := INSTR (p_input, ',', 1, 1);

             IF POSITION = 0 THEN
                str (i + 1) := p_input;
             END IF;
          END LOOP;
       END;
      
      FOR h IN 1 .. str.COUNT -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      LOOP  
        FOR policy IN (SELECT a.policy_id
                         FROM GIEX_EXPIRY a
                        WHERE a.renew_flag = 2
                          AND a.policy_id = NVL(str (h), a.policy_id) --NVL(p_policy_id, a.policy_id) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                          AND TRUNC(a.expiry_date) <= TRUNC(NVL(p_end_date, NVL(p_start_date, a.expiry_date)))
                          AND TRUNC(a.expiry_date) >= DECODE(p_end_date, NULL, TRUNC(a.expiry_date), TRUNC(NVL(p_start_date, a.expiry_date)))
                          AND a.extract_user = NVL(p_user_id, USER)
                          AND a.policy_id = str (h) --p_policy_id -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                          AND EXISTS (SELECT 1
                                        FROM GIEX_RN_NO b,
                                             GIEX_EXPIRY a
                                       WHERE a.policy_id = b.policy_id
                                         AND b.rn_seq_no BETWEEN p_fr_rn_seq_no AND p_to_rn_seq_no
                                         AND 1 = DECODE(NVL(p_req_renewal_no, 'N'), 'N', 2, 1)
                                       UNION
                                      SELECT 1
                                        FROM dual
                                       WHERE 1 = DECODE(NVL(p_req_renewal_no, 'N'), 'N', 1, 2)))  
        LOOP
          v_renewal.policy := policy.policy_id;
          v_policy_id := v_renewal.policy;
          v_renewal.cur_date := TO_CHAR(SYSDATE, 'FMMonth DD, YYYY'); --robert 02.06.2013
          
          FOR rec IN (SELECT SUBSTR(RTRIM(LTRIM(desname)), 1, LENGTH(RTRIM(LTRIM(desname)))-4)||'-'||version||'.DOC' doc,
                             RTRIM(LTRIM(version)) versn
                        FROM GIIS_REPORTS
                       WHERE report_id = 'RENEW')
          LOOP
            v_renewal.doc_name := rec.doc;
            v_renewal.version := rec.versn;
          END LOOP;
          
          FOR a IN (SELECT a.policy_id,
                           get_policy_no(a.policy_id) policy_no,
                           b.assd_no,
                           DECODE(c.assd_name2, NULL, c.assd_name, c.assd_name||' '||c.assd_name2) assd_name,
                           DECODE(a.address3,
                                  NULL,
                                  DECODE(a.address2, NULL, a.address1, a.address1||CHR(10)||a.address2),
                                  DECODE(a.address2, NULL, a.address1, a.address1||CHR(10)||a.address2)||CHR(10)||a.address3) address,
                           TO_CHAR(b.incept_date, 'MM/DD/YYYY')||' - '||TO_CHAR(b.expiry_date, 'MM/DD/YYYY') term, a.line_Cd
                      FROM GIPI_POLBASIC a,
                           GIEX_EXPIRY b,
                           GIIS_ASSURED c
                     WHERE a.policy_id = b.policy_id
                       AND b.assd_no = c.assd_no
                       AND a.policy_id = str (h)) --p_policy_id) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
          LOOP
            v_renewal.assd_name := a.assd_name;
            v_renewal.assd_add := a.address;
            v_renewal.policy_no := a.policy_no;
            v_renewal.policy_id := a.policy_id;
            v_renewal.term := a.term;
            v_renewal.line_cd := a.line_cd;
          END LOOP;
          
          /*BEGIN
              SELECT COUNT(item_title)
              INTO v_temp_no
              FROM gipi_item
             WHERE policy_id = p_policy_id;
             
                
          END;*/
          
          BEGIN
            /*FOR title IN (SELECT DECODE(SIGN(COUNT(item_title)-1), 0, item_title, 'VARIOUS') item_title
                            FROM GIPI_ITEM
                           WHERE policy_id = v_renewal.policy_id
                           GROUP BY item_title)*/
                           
            FOR title IN (SELECT COUNT(item_title) item_title_count
                            FROM gipi_item
                           WHERE policy_id = v_renewal.policy_id)
            LOOP
              v_temp_no := title.item_title_count;
              
              IF v_temp_no > 1 THEN
                  v_renewal.item_title := 'VARIOUS';
                  v_renewal.plate_no := 'VARIOUS';
                  v_renewal.motor_no := 'VARIOUS';
                  v_renewal.serial_no := 'VARIOUS';
              ELSE
                FOR itemtitle IN (SELECT a.item_title , b.plate_no, b.motor_no, b.serial_no --koks
                                    FROM gipi_item a, gipi_vehicle b
                                   WHERE a.policy_id = b.policy_id(+)
                                     and a.policy_id = v_renewal.policy_id)
                LOOP
                  v_renewal.item_title := itemtitle.item_title;
                  v_renewal.plate_no := itemtitle.plate_no;
                  v_renewal.motor_no := itemtitle.motor_no;
                  v_renewal.serial_no := itemtitle.serial_no;
                END LOOP;
              END IF;
            END LOOP;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.item_title := NULL;
              v_renewal.plate_no := NULL;
              v_renewal.motor_no := NULL;
              v_renewal.serial_no := NULL;
          END;
          
          BEGIN
            SELECT a.intm_no
              INTO v_renewal.intm_no
              FROM GIEX_EXPIRY a,
                   GIIS_INTERMEDIARY b
             WHERE a.intm_no = b.intm_no
               AND a.policy_id = v_renewal.policy_id;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.intm_no := NULL;
          END;
          
          BEGIN
            SELECT subline_name
              INTO v_renewal.subline_name
              FROM GIEX_EXPIRY a,
                   GIIS_SUBLINE b
             WHERE a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.policy_id = v_renewal.policy_id;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.subline_name := NULL;
          END;
          
          FOR newperl IN (SELECT a.policy_id,
                                   c.peril_name,
                                   SUM(NVL(b.prem_amt, a.prem_amt)) prem_amt,
                                   LTRIM(TO_CHAR(SUM(NVL(b.tsi_amt, a.tsi_amt)), 'fm9,999,999,999,999.90')) tsi,
                                   LTRIM(TO_CHAR(SUM(NVL(b.prem_amt, a.prem_amt)), 'fm9,999,999,999,999.90')) prem,
                                   c.peril_cd,
                                   c.line_cd
                              FROM GIEX_OLD_GROUP_PERIL a,
                                   GIEX_NEW_GROUP_PERIL b,
                                   GIIS_PERIL c
                             WHERE a.policy_id = str (h) --p_policy_id -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                               AND a.peril_cd = c.peril_cd
                               AND a.line_cd = c.line_cd
                               AND a.policy_id = b.policy_id(+)
                               AND a.peril_cd = b.peril_cd(+)
                             GROUP BY a.policy_id, c.peril_name, sequence, c.line_cd, c.peril_cd
                             ORDER BY sequence, c.peril_name)
                            /* Changed by reymon 02032014
                            SELECT a.policy_id,
                                   c.peril_name,
                                   SUM(a.prem_amt) prem_amt,
                                   LTRIM(TO_CHAR(SUM(a.tsi_amt), 'fm9,999,999,999,999.90')) tsi,
                                   LTRIM(TO_CHAR(SUM(a.prem_amt), 'fm9,999,999,999,999.90')) prem,
                                   c.peril_cd,
                                   c.line_cd
                              FROM GIEX_OLD_GROUP_PERIL a,
                                   GIIS_PERIL c
                             WHERE a.policy_id = p_policy_id
                               AND a.peril_cd = c.peril_cd
                               AND a.line_cd = c.line_cd
                             GROUP BY a.policy_id, c.peril_name, sequence, c.line_cd, c.peril_cd
                             ORDER BY sequence, c.peril_name)*/
          
          LOOP
            v_found_flag := 1;
            
            FOR a IN (SELECT menu_line_cd, line_cd --Added by Jerome Bautista 07.30.2015 SR 19689
                        FROM giis_line
                       WHERE line_cd = newperl.line_cd)
            LOOP
               v_line_cd := a.line_cd;
               v_menu_line_cd := a.menu_line_cd;
            END LOOP;
            
            IF v_renewal.prem_amt IS NULL THEN
              v_renewal.prem_amt := newperl.prem_amt;
            ELSE
              v_renewal.prem_amt := v_renewal.prem_amt + newperl.prem_amt;
            END IF;
        
--            IF v_renewal.peril_name IS NULL THEN  -- Comment out by Jerome Bautista 07.10.2015 SR 19689
--              v_renewal.peril_name := newperl.peril_name;
--            ELSE
--              v_renewal.peril_name := v_renewal.peril_name || CHR(10) ||  newperl.peril_name; 
--            END IF;
            
--            IF v_renewal.dash IS NULL THEN
--              v_renewal.dash := '-';
--            ELSE
--              v_renewal.dash := v_renewal.dash || CHR(10) || '-';
--            END IF;
--            
--            IF v_renewal.sc IS NULL THEN
--              v_renewal.sc := ':';
--            ELSE
--              v_renewal.sc := v_renewal.sc || CHR(10) || ':';
--            END IF;
            
--            IF v_renewal.peril_tsi IS NULL THEN
--              v_renewal.peril_tsi := newperl.tsi;
--            ELSE
--              v_renewal.peril_tsi := v_renewal.peril_tsi || CHR(10) || newperl.tsi;
--            END IF;
--            
--            IF v_renewal.peril_prem IS NULL THEN
--              v_renewal.peril_prem := newperl.prem;
--            ELSE
--              v_renewal.peril_prem := v_renewal.peril_prem || CHR(10) || newperl.prem;
--            END IF;
                        
            IF NVL(v_menu_line_cd,v_line_cd) = 'MC' AND newperl.peril_cd = GIISP.n('AUTO_PA') THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
              v_autopa_flag := 1;
            END IF;
          END LOOP;
          v_renewal.prem := TO_CHAR(v_renewal.prem_amt, 'fm9,999,999,999,999.90');
          
          IF v_found_flag = 0 THEN
            FOR peril IN (SELECT a.policy_id,
                                 c.peril_name,
                                 NVL(b.prem_amt, a.prem_amt) prem_amt,
                                 NVL(b.tsi_amt, a.tsi_amt) tsi_amt,
                                 c.line_cd,
                                 c.peril_cd
                            FROM GIEX_OLD_GROUP_PERIL a,
                                 GIEX_NEW_GROUP_PERIL b,
                                 GIIS_PERIL c
                           WHERE a.line_cd = c.line_cd
                             AND a.peril_cd = c.peril_cd
                             AND a.policy_id = b.policy_id(+)
                             AND a.peril_cd = b.peril_cd(+)
                             AND a.policy_id = v_renewal.policy_id
                           GROUP BY a.policy_id,
                                    c.peril_name,
                                    NVL(b.prem_amt, a.prem_amt),
                                    NVL(b.tsi_amt, a.tsi_amt),
                                    c.line_cd,
                                    c.peril_cd)
            LOOP
              v_renewal.peril_name := v_renewal.peril_name||peril.peril_name||CHR(10);
              v_renewal.peril_tsi := v_renewal.peril_tsi||TO_CHAR(peril.tsi_amt, 'fm9,999,999,999,999,990.90')||CHR(10);
              
              IF v_renewal.prem_amt IS NULL THEN
                v_renewal.prem_amt := peril.prem_amt;
              ELSE
                v_renewal.prem_amt := v_renewal.prem_amt + peril.prem_amt;
              END IF;
            
              IF NVL(v_menu_line_cd,v_line_cd) = 'MC' AND peril.peril_cd = GIISP.n('AUTO_PA') THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
                v_autopa_flag := 1;
              END IF;
            END LOOP; 
            v_renewal.peril_name := RTRIM(v_renewal.peril_name, CHR(10));
            v_renewal.peril_tsi := RTRIM(v_renewal.peril_tsi, CHR(10));
          END IF;
          
          IF v_autopa_flag = 1 THEN
            v_renewal.auto_pa := CHR(10)
                                 ||'              Now you are covered with Enhanced AUTO PA! The Enhanced Auto PA is designed to provide '
                                 ||'Accidental Death and Disablement and Accidental Medical Expenses benefits to the passengers '
                                 ||'of the Insured Vehicle including the driver whilst on board the Insured Vehicle. Not only that, '
                                 ||'the Enhanced AUTO PA also extends the same cover to the members of the Insured''s immediate family '
                                 ||'wherever they are.'
                                 ||CHR(10);
          ELSE
            v_renewal.auto_pa := CHR(10);
          END IF;
          /* Commented by cherrie 11212012
          BEGIN
            SELECT DECODE(SIGN(COUNT(deductible_amt)-1),
                          0,
                          short_name||' '||LTRIM(TO_CHAR(DEDUCTIBLE_AMT,'9,999,999,999,999.90')),
                          'VARIOUS') ded_amt
              INTO v_renewal.deductible
              FROM GIPI_DEDUCTIBLES a,
                   GIPI_ITEM b,
                   GIIS_CURRENCY c,
                   GIPI_POLBASIC y
             WHERE a.policy_id = b.policy_id
               AND a.item_no = b.item_no
               AND b.currency_cd = c.main_currency_cd
               AND b.policy_id = y.policy_id
               AND EXISTS (SELECT 1
                             FROM GIPI_POLBASIC x
                            WHERE y.line_cd = x.line_cd
                              AND y.subline_cd = x.subline_cd
                              AND y.iss_cd = x.iss_cd
                              AND y.issue_yy = x.issue_yy
                              AND y.pol_seq_no = x.pol_seq_no
                              AND y.renew_no = x.renew_no
                              AND (x.endt_seq_no = 0 OR (x.endt_seq_no > 0 AND TRUNC(x.endt_expiry_date) >= TRUNC(x.expiry_date)))
                              AND x.policy_id = v_renewal.policy_id)
            GROUP BY short_name, deductible_amt, y.eff_date, y.endt_seq_no
            ORDER BY y.eff_date, y.endt_seq_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.deductible := NULL;
          END;
          --end of comment cherrie, replace by the code below*/
          /*added by cherrie, deductibles enh (uw-specs-2012-0086)*/          
          BEGIN
            v_renewal.deductible := NULL;
            
            FOR deductible IN ( SELECT deductible_text
                                  FROM giex_deductibles_v
                                 WHERE policy_id = v_renewal.policy_id
                                   AND is_package = 'N') 
            LOOP
                IF v_renewal.deductible is NULL THEN
                    v_renewal.deductible := deductible.deductible_text;
                ELSE
                    v_renewal.deductible := v_renewal.deductible || CHR(10) || deductible.deductible_text;    
                END IF;
            END LOOP;
          
          END;
          /*end cherrie*/
          --changed the outerjoin by reymon 02032014
          FOR premtax IN(SELECT SUM(NVL(tax_amt, 0)) tax_amt
                          FROM (SELECT SUM(tax_amt) tax_amt
                                  FROM giex_old_group_tax a
                                 WHERE policy_id = v_renewal.policy_id
                                   AND NOT EXISTS (SELECT 1
                                                     FROM giex_new_group_tax b
                                                    WHERE a.policy_id = b.policy_id)
                                UNION ALL
                                SELECT SUM(tax_amt)
                                  FROM giex_new_group_tax a
                                 WHERE policy_id = v_renewal.policy_id))
                        /*SELECT SUM(NVL(b.tax_amt,a.tax_amt)) tax_amt
                           FROM giex_old_group_tax a, giex_new_group_tax b
                          WHERE a.policy_id(+) = b.policy_id--(+)
                            AND a.line_cd(+) = b.line_cd--(+)
                            AND a.tax_cd(+) = b.tax_cd--(+)
                            AND NVL(b.policy_id, a.policy_id) = v_renewal.policy_id)*/
          LOOP
              v_renewal.tax_amt := NVL(premtax.tax_amt,0);
              --v_renewal.prem_tax := v_renewal.tax_amt + v_renewal.prem_amt; moved by Nica 01.21.2014
          END LOOP;
          
          v_renewal.prem_tax := NVL(v_renewal.prem_amt, 0) + NVL(v_renewal.tax_amt, 0);
        
          END LOOP;
          PIPE ROW(v_renewal);
      END LOOP; -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb :: FOR h IN 1 .. str.COUNT
        
      END;
      
      
  FUNCTION populate_renewal_notice_sub( -- Added by Jerome Bautista 07.10.2015 SR 19689
    p_policy_id         NUMBER, --gipi_polbasic.policy_id%TYPE, -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb        
    p_start_date        DATE,
    p_end_date          DATE,
    p_fr_rn_seq_no      NUMBER,
    p_to_rn_seq_no      NUMBER,
    p_req_renewal_no    VARCHAR2,
    p_user_id           giis_users.user_id%TYPE /*added by cherrie, 11292012*/
  )
    RETURN renewal_tab PIPELINED AS
      v_renewal  renewal_type;
      v_found_flag NUMBER(1) := 0;
      v_autopa_flag NUMBER(1) := 0;
      v_policy_id NUMBER;
      v_temp_no NUMBER;
      v_line_cd VARCHAR2(1000); --Added by Jerome Bautista 07.30.2015 SR 19689
      v_menu_line_cd VARCHAR2(1000); --Added by Jerome Bautista 07.30.2015 SR 19689
   BEGIN 
        FOR policy IN (SELECT a.policy_id
                         FROM GIEX_EXPIRY a
                        WHERE a.renew_flag = 2
                          AND a.policy_id = NVL(p_policy_id, a.policy_id) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                          AND TRUNC(a.expiry_date) <= TRUNC(NVL(p_end_date, NVL(p_start_date, a.expiry_date)))
                          AND TRUNC(a.expiry_date) >= DECODE(p_end_date, NULL, TRUNC(a.expiry_date), TRUNC(NVL(p_start_date, a.expiry_date)))
                          AND a.extract_user = NVL(p_user_id, USER)
                          AND a.policy_id = p_policy_id -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                          AND EXISTS (SELECT 1
                                        FROM GIEX_RN_NO b,
                                             GIEX_EXPIRY a
                                       WHERE a.policy_id = b.policy_id
                                         AND b.rn_seq_no BETWEEN p_fr_rn_seq_no AND p_to_rn_seq_no
                                         AND 1 = DECODE(NVL(p_req_renewal_no, 'N'), 'N', 2, 1)
                                       UNION
                                      SELECT 1
                                        FROM dual
                                       WHERE 1 = DECODE(NVL(p_req_renewal_no, 'N'), 'N', 1, 2)))  
        LOOP
          v_renewal.policy := policy.policy_id;
          v_policy_id := v_renewal.policy;
          v_renewal.cur_date := TO_CHAR(SYSDATE, 'FMMonth DD, YYYY'); --robert 02.06.2013
          
          FOR rec IN (SELECT SUBSTR(RTRIM(LTRIM(desname)), 1, LENGTH(RTRIM(LTRIM(desname)))-4)||'-'||version||'.DOC' doc,
                             RTRIM(LTRIM(version)) versn
                        FROM GIIS_REPORTS
                       WHERE report_id = 'RENEW')
          LOOP
            v_renewal.doc_name := rec.doc;
            v_renewal.version := rec.versn;
          END LOOP;
          
          FOR a IN (SELECT a.policy_id,
                           get_policy_no(a.policy_id) policy_no,
                           b.assd_no,
                           DECODE(c.assd_name2, NULL, c.assd_name, c.assd_name||' '||c.assd_name2) assd_name,
                           DECODE(a.address3,
                                  NULL,
                                  DECODE(a.address2, NULL, a.address1, a.address1||CHR(10)||a.address2),
                                  DECODE(a.address2, NULL, a.address1, a.address1||CHR(10)||a.address2)||CHR(10)||a.address3) address,
                           TO_CHAR(b.incept_date, 'MM/DD/YYYY')||' - '||TO_CHAR(b.expiry_date, 'MM/DD/YYYY') term, a.line_Cd
                      FROM GIPI_POLBASIC a,
                           GIEX_EXPIRY b,
                           GIIS_ASSURED c
                     WHERE a.policy_id = b.policy_id
                       AND b.assd_no = c.assd_no
                       AND a.policy_id = p_policy_id) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
          LOOP
            v_renewal.assd_name := a.assd_name;
            v_renewal.assd_add := a.address;
            v_renewal.policy_no := a.policy_no;
            v_renewal.policy_id := a.policy_id;
            v_renewal.term := a.term;
            v_renewal.line_cd := a.line_cd;
          END LOOP;
          
          /*BEGIN
              SELECT COUNT(item_title)
              INTO v_temp_no
              FROM gipi_item
             WHERE policy_id = p_policy_id;
             
                
          END;*/
                  
          BEGIN
            /*FOR title IN (SELECT DECODE(SIGN(COUNT(item_title)-1), 0, item_title, 'VARIOUS') item_title
                            FROM GIPI_ITEM
                           WHERE policy_id = v_renewal.policy_id
                           GROUP BY item_title)*/
                           
            FOR title IN (SELECT COUNT(item_title) item_title_count
                            FROM gipi_item
                           WHERE policy_id = v_renewal.policy_id)
            LOOP
              v_temp_no := title.item_title_count;
              
              IF v_temp_no > 1 THEN
                  v_renewal.item_title := 'VARIOUS';
                  v_renewal.plate_no := 'VARIOUS';
                  v_renewal.motor_no := 'VARIOUS';
                  v_renewal.serial_no := 'VARIOUS';
              ELSE
                FOR itemtitle IN (SELECT a.item_title , b.plate_no, b.motor_no, b.serial_no --koks
                                    FROM gipi_item a, gipi_vehicle b
                                   WHERE a.policy_id = b.policy_id(+)
                                     and a.policy_id = v_renewal.policy_id)
                LOOP
                  v_renewal.item_title := itemtitle.item_title;
                  v_renewal.plate_no := itemtitle.plate_no;
                  v_renewal.motor_no := itemtitle.motor_no;
                  v_renewal.serial_no := itemtitle.serial_no;
                END LOOP;
              END IF;
            END LOOP;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.item_title := NULL;
              v_renewal.plate_no := NULL;
              v_renewal.motor_no := NULL;
              v_renewal.serial_no := NULL;
          END;
          
          BEGIN
            SELECT a.intm_no
              INTO v_renewal.intm_no
              FROM GIEX_EXPIRY a,
                   GIIS_INTERMEDIARY b
             WHERE a.intm_no = b.intm_no
               AND a.policy_id = v_renewal.policy_id;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.intm_no := NULL;
          END;
          
          BEGIN
            SELECT subline_name
              INTO v_renewal.subline_name
              FROM GIEX_EXPIRY a,
                   GIIS_SUBLINE b
             WHERE a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.policy_id = v_renewal.policy_id;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.subline_name := NULL;
          END;
          
          FOR newperl IN (SELECT a.policy_id,
                                   c.peril_name,
                                   SUM(NVL(b.prem_amt, a.prem_amt)) prem_amt,
                                   LTRIM(TO_CHAR(SUM(NVL(b.tsi_amt, a.tsi_amt)), 'fm9,999,999,999,999.90')) tsi,
                                   LTRIM(TO_CHAR(SUM(NVL(b.prem_amt, a.prem_amt)), 'fm9,999,999,999,999.90')) prem,
                                   c.peril_cd,
                                   c.line_cd
                              FROM GIEX_OLD_GROUP_PERIL a,
                                   GIEX_NEW_GROUP_PERIL b,
                                   GIIS_PERIL c
                             WHERE a.policy_id = p_policy_id -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                               AND a.peril_cd = c.peril_cd
                               AND a.line_cd = c.line_cd
                               AND a.policy_id = b.policy_id(+)
                               AND a.peril_cd = b.peril_cd(+)
                             GROUP BY a.policy_id, c.peril_name, sequence, c.line_cd, c.peril_cd
                             ORDER BY sequence, c.peril_name)
                            /* Changed by reymon 02032014
                            SELECT a.policy_id,
                                   c.peril_name,
                                   SUM(a.prem_amt) prem_amt,
                                   LTRIM(TO_CHAR(SUM(a.tsi_amt), 'fm9,999,999,999,999.90')) tsi,
                                   LTRIM(TO_CHAR(SUM(a.prem_amt), 'fm9,999,999,999,999.90')) prem,
                                   c.peril_cd,
                                   c.line_cd
                              FROM GIEX_OLD_GROUP_PERIL a,
                                   GIIS_PERIL c
                             WHERE a.policy_id = p_policy_id
                               AND a.peril_cd = c.peril_cd
                               AND a.line_cd = c.line_cd
                             GROUP BY a.policy_id, c.peril_name, sequence, c.line_cd, c.peril_cd
                             ORDER BY sequence, c.peril_name)*/
          LOOP
            v_found_flag := 1;
            
            FOR a IN (SELECT menu_line_cd, line_cd --Added by Jerome Bautista 07.30.2015 SR 19689
                        FROM giis_line
                       WHERE line_cd = newperl.line_cd)
            LOOP
                v_line_cd := a.line_cd;
                v_menu_line_cd := a.menu_line_cd;
            END LOOP;
            
            IF v_renewal.prem_amt IS NULL THEN
              v_renewal.prem_amt := newperl.prem_amt;
            ELSE
              v_renewal.prem_amt := v_renewal.prem_amt + newperl.prem_amt;
            END IF;
        
            IF v_renewal.peril_name IS NULL THEN
              v_renewal.peril_name := newperl.peril_name;
            ELSE
              v_renewal.peril_name := v_renewal.peril_name || CHR(10) ||  newperl.peril_name; 
            END IF;
            
            IF v_renewal.dash IS NULL THEN
              v_renewal.dash := '-';
            ELSE
              v_renewal.dash := v_renewal.dash || CHR(10) || '-';
            END IF;
            
            IF v_renewal.sc IS NULL THEN
              v_renewal.sc := ':';
            ELSE
              v_renewal.sc := v_renewal.sc || CHR(10) || ':';
            END IF;
            
            IF v_renewal.peril_tsi IS NULL THEN
              v_renewal.peril_tsi := newperl.tsi;
            ELSE
              v_renewal.peril_tsi := v_renewal.peril_tsi || CHR(10) || newperl.tsi;
            END IF;
            
            IF v_renewal.peril_prem IS NULL THEN
              v_renewal.peril_prem := newperl.prem;
            ELSE
              v_renewal.peril_prem := v_renewal.peril_prem || CHR(10) || newperl.prem;
            END IF;
                        
            IF NVL(v_menu_line_cd, v_line_cd) = 'MC' AND newperl.peril_cd = GIISP.n('AUTO_PA') THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
              v_autopa_flag := 1;
            END IF;
          END LOOP;
          v_renewal.prem := TO_CHAR(v_renewal.prem_amt, 'fm9,999,999,999,999.90');
          
          IF v_found_flag = 0 THEN
            FOR peril IN (SELECT a.policy_id,
                                 c.peril_name,
                                 NVL(b.prem_amt, a.prem_amt) prem_amt,
                                 NVL(b.tsi_amt, a.tsi_amt) tsi_amt,
                                 c.line_cd,
                                 c.peril_cd
                            FROM GIEX_OLD_GROUP_PERIL a,
                                 GIEX_NEW_GROUP_PERIL b,
                                 GIIS_PERIL c
                           WHERE a.line_cd = c.line_cd
                             AND a.peril_cd = c.peril_cd
                             AND a.policy_id = b.policy_id(+)
                             AND a.peril_cd = b.peril_cd(+)
                             AND a.policy_id = v_renewal.policy_id
                           GROUP BY a.policy_id,
                                    c.peril_name,
                                    NVL(b.prem_amt, a.prem_amt),
                                    NVL(b.tsi_amt, a.tsi_amt),
                                    c.line_cd,
                                    c.peril_cd)
            LOOP
              v_renewal.peril_name := v_renewal.peril_name||peril.peril_name||CHR(10);
              v_renewal.peril_tsi := v_renewal.peril_tsi||TO_CHAR(peril.tsi_amt, 'fm9,999,999,999,999,990.90')||CHR(10);
              
              IF v_renewal.prem_amt IS NULL THEN
                v_renewal.prem_amt := peril.prem_amt;
              ELSE
                v_renewal.prem_amt := v_renewal.prem_amt + peril.prem_amt;
              END IF;
            
              IF NVL(v_menu_line_cd,v_line_cd) = 'MC' AND peril.peril_cd = GIISP.n('AUTO_PA') THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
                v_autopa_flag := 1;
              END IF;
            END LOOP; 
            v_renewal.peril_name := RTRIM(v_renewal.peril_name, CHR(10));
            v_renewal.peril_tsi := RTRIM(v_renewal.peril_tsi, CHR(10));
          END IF;
          
          IF v_autopa_flag = 1 THEN
            v_renewal.auto_pa := CHR(10)
                                 ||'              Now you are covered with Enhanced AUTO PA! The Enhanced Auto PA is designed to provide '
                                 ||'Accidental Death and Disablement and Accidental Medical Expenses benefits to the passengers '
                                 ||'of the Insured Vehicle including the driver whilst on board the Insured Vehicle. Not only that, '
                                 ||'the Enhanced AUTO PA also extends the same cover to the members of the Insured''s immediate family '
                                 ||'wherever they are.'
                                 ||CHR(10);
          ELSE
            v_renewal.auto_pa := CHR(10);
          END IF;
          /* Commented by cherrie 11212012
          BEGIN
            SELECT DECODE(SIGN(COUNT(deductible_amt)-1),
                          0,
                          short_name||' '||LTRIM(TO_CHAR(DEDUCTIBLE_AMT,'9,999,999,999,999.90')),
                          'VARIOUS') ded_amt
              INTO v_renewal.deductible
              FROM GIPI_DEDUCTIBLES a,
                   GIPI_ITEM b,
                   GIIS_CURRENCY c,
                   GIPI_POLBASIC y
             WHERE a.policy_id = b.policy_id
               AND a.item_no = b.item_no
               AND b.currency_cd = c.main_currency_cd
               AND b.policy_id = y.policy_id
               AND EXISTS (SELECT 1
                             FROM GIPI_POLBASIC x
                            WHERE y.line_cd = x.line_cd
                              AND y.subline_cd = x.subline_cd
                              AND y.iss_cd = x.iss_cd
                              AND y.issue_yy = x.issue_yy
                              AND y.pol_seq_no = x.pol_seq_no
                              AND y.renew_no = x.renew_no
                              AND (x.endt_seq_no = 0 OR (x.endt_seq_no > 0 AND TRUNC(x.endt_expiry_date) >= TRUNC(x.expiry_date)))
                              AND x.policy_id = v_renewal.policy_id)
            GROUP BY short_name, deductible_amt, y.eff_date, y.endt_seq_no
            ORDER BY y.eff_date, y.endt_seq_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_renewal.deductible := NULL;
          END;
          --end of comment cherrie, replace by the code below*/
          /*added by cherrie, deductibles enh (uw-specs-2012-0086)*/          
          BEGIN
            v_renewal.deductible := NULL;
            
            FOR deductible IN ( SELECT deductible_text
                                  FROM giex_deductibles_v
                                 WHERE policy_id = v_renewal.policy_id
                                   AND is_package = 'N') 
            LOOP
                IF v_renewal.deductible is NULL THEN
                    v_renewal.deductible := deductible.deductible_text;
                ELSE
                    v_renewal.deductible := v_renewal.deductible || CHR(10) || deductible.deductible_text;    
                END IF;
            END LOOP;
          
          END;
          /*end cherrie*/
          --changed the outerjoin by reymon 02032014
          FOR premtax IN(SELECT SUM(NVL(tax_amt, 0)) tax_amt
                          FROM (SELECT SUM(tax_amt) tax_amt
                                  FROM giex_old_group_tax a
                                 WHERE policy_id = v_renewal.policy_id
                                   AND NOT EXISTS (SELECT 1
                                                     FROM giex_new_group_tax b
                                                    WHERE a.policy_id = b.policy_id)
                                UNION ALL
                                SELECT SUM(tax_amt)
                                  FROM giex_new_group_tax a
                                 WHERE policy_id = v_renewal.policy_id))
                        /*SELECT SUM(NVL(b.tax_amt,a.tax_amt)) tax_amt
                           FROM giex_old_group_tax a, giex_new_group_tax b
                          WHERE a.policy_id(+) = b.policy_id--(+)
                            AND a.line_cd(+) = b.line_cd--(+)
                            AND a.tax_cd(+) = b.tax_cd--(+)
                            AND NVL(b.policy_id, a.policy_id) = v_renewal.policy_id)*/
          LOOP
              v_renewal.tax_amt := NVL(premtax.tax_amt,0);
              --v_renewal.prem_tax := v_renewal.tax_amt + v_renewal.prem_amt; moved by Nica 01.21.2014
          END LOOP;
          
          v_renewal.prem_tax := NVL(v_renewal.prem_amt, 0) + NVL(v_renewal.tax_amt, 0);
        
          END LOOP;
        PIPE ROW(v_renewal);
      END;

  FUNCTION populate_renewal_ucpb_wpck (
    p_policy              VARCHAR2, --giex_pack_expiry.pack_policy_id%TYPE -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
    p_policy2             VARCHAR2,
    p_policy3             VARCHAR2   
  )
    RETURN renewal_wpck_tab PIPELINED AS
      v_wpck                renewal_wpck_type;
      v_subpol_peril_flag   NUMBER(1) := 0;
      v_autopa_flag         NUMBER(1) := 0;
      v_vat                 VARCHAR(1);
      v_edited              VARCHAR2(2) := 'N';
      v_tsi_amt             NUMBER;
      str                   populate_renewal_notice.policy_id_array; -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      v_intm_no            VARCHAR2(20000);
      v_pack_policy_id     giex_pack_expiry.pack_policy_id%TYPE := 0;
      i          NUMBER          := 0; -- Added by Jerome Bautista 07.10.2015 SR 19689
      POSITION   NUMBER          := 0; -- Added by Jerome Bautista 07.10.2015 SR 19689
      p_input    VARCHAR2 (30000) := p_policy || p_policy2 || p_policy3; -- Added by Jerome Bautista 07.10.2015 SR 19689
      output     policy_id_array; -- Added by Jerome Bautista 07.10.2015 SR 19689
      BEGIN
      
      BEGIN -- Added by Jerome Bautista 07.10.2015 SR 19689
          POSITION := INSTR (p_input, ',', 1, 1);

          IF POSITION = 0 THEN
             str (1) := p_input;
          END IF;

          WHILE (POSITION != 0)
          LOOP
             i := i + 1;
             str (i) := SUBSTR (p_input, 1, POSITION - 1);
             p_input := SUBSTR (p_input, POSITION + 1, LENGTH (p_input));
             POSITION := INSTR (p_input, ',', 1, 1);

             IF POSITION = 0 THEN
                str (i + 1) := p_input;
             END IF;
          END LOOP;
       END;
       
      FOR h IN 1 .. str.COUNT -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      LOOP  
        FOR ucpb IN (SELECT get_pack_policy_no(a.pack_policy_id) policy_no,
                            b.expiry_date expiry,
                            decode(c.designation,
                                   NULL,
                                   c.assd_name||c.assd_name2,
                                   c.designation||' '||c.assd_name||c.assd_name2) assd_name,
                                   a.address1 address1,
                                   a.address2 address2,
                                   a.address3 address3,
                                   NVL(policy_currency, 'Y') policy_currency,
                                   a.iss_cd iss_cd, 
                                   a.pack_policy_id -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                       FROM gipi_pack_polbasic a,
                            giex_pack_expiry b,
                            giis_assured c,
                            giis_line d,
                            giis_subline e
                      WHERE b.pack_policy_id = a.pack_policy_id
                        AND b.assd_no = c.assd_no
                        AND a.line_cd = d.line_cd
                        AND d.line_cd = e.line_cd
                        AND a.subline_cd = e.subline_cd
                        AND b.pack_policy_id = str (h)) --p_policy)
        LOOP
          v_wpck.policy_no := ucpb.policy_no;
          v_wpck.policy_id := ucpb.pack_policy_id; --p_policy; -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
          v_wpck.expiry := TO_CHAR(ucpb.expiry, 'fmMonth DD, YYYY');
          v_wpck.assd_name := ucpb.assd_name;
          v_wpck.address := ucpb.address1||CHR(10)||ucpb.address2||CHR(10)||ucpb.address3;
          v_wpck.iss_cd := ucpb.iss_cd;
          v_wpck.policy_currency := ucpb.policy_currency;
        END LOOP;
        v_wpck.cur_date := TO_CHAR(SYSDATE, 'FMMonth dd, YYYY');  --robert 02.06.2013
        
        FOR cur IN (SELECT short_name,
                           currency_cd,
                           a.currency_rt
                      FROM giis_currency a,
                           gipi_item b,
                           gipi_polbasic y
                     WHERE a.main_currency_cd = b.currency_cd
                       AND b.policy_id = y.policy_id
                       AND EXISTS (SELECT 1
                                     FROM gipi_polbasic x
                                    WHERE y.line_cd = x.line_cd
                                      AND y.subline_cd = x.subline_cd
                                      AND y.iss_cd = x.iss_cd
                                      AND y.issue_yy = x.issue_yy
                                      AND y.pol_seq_no = x.pol_seq_no
                                      AND y.renew_no = x.renew_no
                                      AND (x.endt_seq_no = 0 OR (x.endt_seq_no > 0 AND TRUNC(x.endt_expiry_date) >= TRUNC(x.expiry_date)))
                                      AND x.pack_policy_id = str (h))) --p_policy)) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        LOOP
          IF v_wpck.currency_cd IS NOT NULL AND v_wpck.currency_cd <> cur.currency_cd THEN
            v_wpck.short_name := 'PHP';
            v_wpck.currency_cd := 1;
            v_wpck.currency_rt := 1;
            EXIT;
          END IF;
          v_wpck.short_name := cur.short_name;
          v_wpck.currency_cd := cur.currency_cd;
          v_wpck.currency_rt := cur.currency_rt;
        END LOOP;
        
        /*FOR sub_pol IN (SELECT get_line_name(line_cd) line_name,
                               policy_id,
                               tsi_amt,
                               line_cd
                          FROM giex_expiry
                         WHERE pack_policy_id = p_policy)
        LOOP
          FOR a IN (SELECT SUM(a.tsi_amt) total
              FROM gipi_itmperil a,
                   giex_expiry b
             WHERE a.policy_id = sub_pol.policy_id
               AND b.line_cd = sub_pol.line_cd
               AND b.pack_policy_id = p_policy)
          LOOP
            IF v_wpck.pol_tsi IS NULL THEN
              v_wpck.pol_tsi := LTRIM(RTRIM(TO_CHAR(a.total, '999,999,999,999.90')));
            ELSE
              v_wpck.pol_tsi := v_wpck.pol_tsi || CHR(10) || LTRIM(RTRIM(TO_CHAR(a.total, '999,999,999,999.90')));
            END IF;
          END LOOP;
        
          IF v_wpck.type IS NULL THEN
            v_wpck.type := sub_pol.line_name;
            v_wpck.cur1 := v_wpck.short_name;
          ELSE
            v_wpck.type := v_wpck.type||CHR(10)||sub_pol.line_name;
            v_wpck.cur1 := v_wpck.cur1||CHR(10)||v_wpck.short_name;
          END IF;
          
          FOR subpol_peril IN (SELECT INITCAP(get_peril_name(sub_pol.line_cd, peril_cd)) peril_name,
                                      tsi_amt,
                                      peril_cd
                                 FROM gipi_itmperil
                                WHERE policy_id = sub_pol.policy_id)
          LOOP
            IF v_subpol_peril_flag = 1 THEN
              v_wpck.peril_tsi := v_wpck.peril_tsi||CHR(10);
              v_wpck.pa_limit := v_wpck.pa_limit||CHR(10);
            END IF;
            v_subpol_peril_flag := 0;
            v_wpck.type := v_wpck.type||CHR(10)||CHR(9)||CHR(9)||CHR(9)||CHR(9)||subpol_peril.peril_name;
            v_wpck.peril_tsi := v_wpck.peril_tsi||CHR(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.tsi_amt, '999,999,999,999.90')));
            IF sub_pol.line_cd = 'PA' THEN
              v_wpck.pa_limit := v_wpck.pa_limit||CHR(10)||'Limit per person';
            ELSE
              v_wpck.pa_limit := v_wpck.pa_limit||CHR(10);
            END IF;
            v_wpck.cur1 := v_wpck.cur1||CHR(10);
            v_wpck.pol_tsi := v_wpck.pol_tsi||CHR(10);
            IF sub_pol.line_cd = 'MC' AND subpol_peril.peril_cd = giisp.n('AUTO_PA') THEN
              v_autopa_flag := 1;
            END IF;
          END LOOP;
          v_wpck.peril_tsi := v_wpck.peril_tsi||CHR(10);
          v_wpck.pa_limit := v_wpck.pa_limit||CHR(10);
        END LOOP;*/ -- replaced by: Nica 01.21.2014
        
--        FOR sub_pol IN (SELECT get_line_name(line_cd) line_name, policy_id, tsi_amt, line_cd      Comment out by Jerome Bautista SR 19689 07.10.2015
--                      FROM giex_expiry 
--                   WHERE pack_policy_id = str (h)) --p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--        LOOP
--            
--            v_edited := 'N'; --moved by reymon 02032014
--            
--            FOR edited IN (SELECT 1
--                             FROM giex_itmperil
--                            WHERE policy_id = sub_pol.policy_id)
--            LOOP
--              v_edited := 'Y';
--              EXIT;
--            END LOOP;
--            
--            v_tsi_amt := NULL;
--            
--            IF v_edited = 'Y' THEN
--                    FOR peril IN(SELECT SUM(a.tsi_amt) tsi
--                                   FROM giex_itmperil a,
--                                        giis_peril b
--                                  WHERE a.line_cd = b.line_cd
--                                    AND a.peril_cd = b.peril_cd
--                                    AND b.peril_type = 'B'
--                                    AND a.policy_id = sub_pol.policy_id
--                                  ORDER BY SEQUENCE)
--                    LOOP
--                      v_tsi_amt := peril.tsi;
--                    END LOOP;
--            ELSIF v_edited = 'N' THEN
--                    FOR peril IN(SELECT SUM(a.tsi_amt) tsi
--                                   FROM giex_old_group_peril a,
--                                        giis_peril b
--                                  WHERE a.line_cd = b.line_cd
--                                    AND a.peril_cd = b.peril_cd
--                                    AND b.peril_type = 'B'
--                                    AND a.policy_id = sub_pol.policy_id
--                                  ORDER BY SEQUENCE)
--                    LOOP
--                      v_tsi_amt := peril.tsi;
--                    END LOOP;
--            END IF;
--            
--            IF v_wpck.type IS NULL THEN
--                v_wpck.type := sub_pol.line_name; 
--                v_wpck.cur1 :=  v_wpck.short_name; --joanne 01.24.14
--                v_wpck.pol_tsi := LTRIM(RTRIM(TO_CHAR(v_tsi_amt, '999,999,999,999.90')));
--            ELSE
--                v_wpck.type := v_wpck.type||chr(10)||sub_pol.line_name;
--                v_wpck.cur1 := v_wpck.cur1||chr(10)||v_wpck.short_name;--joanne 01.24.14
--                v_wpck.pol_tsi := v_wpck.pol_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(v_tsi_amt, '999,999,999,999.90')));
--            END IF;
--            
--            --v_edited := 'N'; moved by reymon 02032014
--            
--            IF v_edited = 'Y' THEN
--                 FOR subpol_peril IN (SELECT INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)) peril_name, SUM (a.tsi_amt) tsi_amt, SUM(NVL(a.tsi_amt,0)*NVL(a.currency_rt,1)) orig_tsi_amt, a.peril_cd
--                                       FROM giex_itmperil a  /*-- pjsantos 11/22/2013 commented out and replaced giex_new_group_peril a with giex_itmperil a, consolidated from ma'am Jhing*/, giis_peril b
--                                      WHERE a.line_cd = b.line_cd
--                                        AND a.peril_cd = b.peril_cd
--                                        AND a.policy_id = sub_pol.policy_id
--                                   GROUP BY INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)), a.peril_cd)
--                LOOP
--                    IF v_subpol_peril_flag = 1 THEN
--                      v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
--                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
--                    END IF;
--                    v_subpol_peril_flag := 0;
--                    v_wpck.type := v_wpck.type||chr(10)||'              '||subpol_peril.peril_name; --joanne 01.24.14
--                    
--                    IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
--                        v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(subpol_peril.orig_tsi_amt, '999,999,999,999.90'));
--                    ELSE
--                        v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.tsi_amt, '999,999,999,999.90')));
--                    END IF;
--                      
--                    IF sub_pol.line_cd = 'PA' THEN
--                        v_wpck.pa_limit := v_wpck.pa_limit||chr(10)||'Limit per person';
--                    ELSE
--                        v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
--                    END IF;
--                  
--                    v_wpck.cur1 := v_wpck.cur1||chr(10);
--                    v_wpck.pol_tsi := v_wpck.pol_tsi||chr(10);
--                    IF sub_pol.line_cd = 'MC' AND subpol_peril.peril_cd = giisp.n('AUTO_PA') THEN
--                      v_autopa_flag := 1;
--                    END IF;
--                END LOOP;
--                
--                v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
--                v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
--                
--            ELSIF v_edited = 'N' THEN
--               FOR subpol_peril IN (SELECT INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)) peril_name, SUM (a.tsi_amt) tsi_amt, SUM (a.orig_tsi_amt) orig_tsi_amt, a.peril_cd
--                                       FROM giex_old_group_peril a, giis_peril b
--                                      WHERE a.line_cd = b.line_cd
--                                        AND a.peril_cd = b.peril_cd
--                                        AND a.policy_id = sub_pol.policy_id
--                                   GROUP BY INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)), a.peril_cd)
--                LOOP
--                  IF v_subpol_peril_flag = 1 THEN
--                      v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
--                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
--                  END IF;
--                  
--                  v_subpol_peril_flag := 0;
--                  v_wpck.type := v_wpck.type||chr(10)||'              '||subpol_peril.peril_name;--joanne 01.24.14
--                  
--                  
--                  IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
--                        v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.orig_tsi_amt, '999,999,999,999.90')));
--                  ELSE
--                    v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.tsi_amt, '999,999,999,999.90')));
--                  END IF;
--                  
--                  IF sub_pol.line_cd = 'PA' THEN
--                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10)||'Limit per person';
--                  ELSE
--                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
--                  END IF;
--                  
--                  v_wpck.cur1 := v_wpck.cur1||chr(10);
--                  v_wpck.pol_tsi := v_wpck.pol_tsi||chr(10);
--                  
--                  IF sub_pol.line_cd = 'MC' AND subpol_peril.peril_cd = giisp.n('AUTO_PA') THEN
--                      v_autopa_flag := 1;
--                  END IF;
--                END LOOP;
--               
--                
--                v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
--                v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
--            
--            END IF;
--        
--        END LOOP;
        
--        IF v_autopa_flag = 1 THEN
--          v_wpck.auto_pa := CHR(10)
--                            ||'              Now you are covered with Enhanced AUTO PA! The Enhanced Auto PA is designed to provide '
--                            ||'Accidental Death and Disablement and Accidental Medical Expenses benefits to the passengers '
--                            ||'of the Insured Vehicle including the driver whilst on board the Insured Vehicle. Not only that, '
--                            ||'the Enhanced AUTO PA also extends the same cover to the members of the Insured''s immediate family '
--                            ||'wherever they are.'
--                            ||CHR(10);
--        ELSE
--          v_wpck.auto_pa := CHR(10);
--        END IF;
--        
--        FOR old_tax IN (SELECT LTRIM(TO_CHAR(NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0), '99,999,999,999,990.99')) tax,
--                               NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
--                               tax_cd tax_id
--                          FROM giex_old_group_tax a
--                         WHERE EXISTS (SELECT 1
--                                         FROM giex_expiry x
--                                        WHERE a.policy_id = x.policy_id
--                                          AND x.pack_policy_id = str (h)) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                           AND iss_cd = v_wpck.iss_cd
--                         GROUP BY tax_cd
--                         ORDER BY tax_cd)
--        LOOP
----          IF v_wpck.tax_amt_old IS NULL THEN
----            v_wpck.tax_amt_old := old_tax.tax;
----          ELSE
----            v_wpck.tax_amt_old := v_wpck.tax_amt_old || CHR(10) || old_tax.tax;
----          END IF;
--          IF old_tax.tax_id = v_wpck.tax_param THEN
--            v_vat := 'Y';
--          END IF;
--          v_wpck.tax_amt_old_a := NVL(v_wpck.tax_amt_old_a, 0) + NVL(old_tax.tax_a, 0);
--        END LOOP;
--        v_wpck.tax_checker := NULL;
--        
--        FOR old_tax2 IN (SELECT DISTINCT tax_desc,
--                                          tax_cd
--                            FROM giex_old_group_tax a
--                           WHERE EXISTS (SELECT 1
--                                           FROM giex_expiry x
--                                          WHERE a.policy_id = x.policy_id
--                                            AND x.pack_policy_id = str (h)) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                             AND iss_cd = v_wpck.iss_cd
--                           ORDER BY tax_cd)
--        LOOP
--          IF NVL(v_wpck.tax_checker, 0) <> old_tax2.tax_cd THEN
--            IF v_wpck.tax_desc_old IS NULL THEN
--              v_wpck.tax_desc_old := old_tax2.tax_desc || ' :';
--            ELSE
--              v_wpck.tax_desc_old := v_wpck.tax_desc_old || CHR(10) || old_tax2.tax_desc || ' :';
--            END IF;
--          END IF;
--          v_wpck.tax_checker := old_tax2.tax_cd;
--        END LOOP;
--        
--        FOR new_tax IN (SELECT LTRIM(TO_CHAR(SUM(tax_a), '99,999,999,999,990.99')) tax, SUM(tax_a) tax_a, tax_id 
--                          FROM (SELECT NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
--                                       tax_cd tax_id
--                                  FROM giex_new_group_tax a
--                                 WHERE EXISTS (SELECT 1
--                                                 FROM giex_expiry x
--                                                WHERE a.policy_id = x.policy_id
--                                                  AND x.pack_policy_id = str (h)) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                                   AND iss_cd = v_wpck.iss_cd
--                                 GROUP BY tax_cd
--                                 UNION ALL
--                                SELECT NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
--                                       tax_cd tax_id
--                                  FROM giex_old_group_tax a
--                                 WHERE EXISTS (SELECT 1
--                                                 FROM giex_expiry x
--                                                WHERE a.policy_id = x.policy_id
--                                                  AND x.pack_policy_id = str (h) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                                                  AND NOT EXISTS (SELECT 1
--                                                                    FROM giex_new_group_tax b
--                                                                   WHERE x.policy_id = b.policy_id))
--                                   AND iss_cd = v_wpck.iss_cd
--                                 GROUP BY tax_cd)
--                        GROUP BY tax_id
--                        ORDER BY tax_id)
--                       /* changed by reymon 02032014
--                       SELECT LTRIM(TO_CHAR(NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0), '99,999,999,999,990.99')) tax,
--                               NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
--                               tax_cd tax_id
--                          FROM giex_new_group_tax a
--                         WHERE EXISTS (SELECT 1
--                                         FROM giex_expiry x
--                                        WHERE a.policy_id = x.policy_id
--                                          AND x.pack_policy_id = p_policy)
--                           AND iss_cd = v_wpck.iss_cd
--                         GROUP BY tax_cd
--                         ORDER BY tax_cd)*/
--        LOOP
----          IF v_wpck.tax_amt_new IS NULL THEN
----            v_wpck.tax_amt_new := new_tax.tax;
----          ELSE
----            v_wpck.tax_amt_new := v_wpck.tax_amt_new || CHR(10) || new_tax.tax;
----          END IF;
--          IF new_tax.tax_id = v_wpck.tax_param THEN
--            v_vat := 'Y';
--          END IF;
--          v_wpck.tax_amt_new_a := NVL(v_wpck.tax_amt_new_a, 0) + NVL(new_tax.tax_a, 0);
--        END LOOP;
--        v_wpck.tax_checker := NULL;
--        
--        FOR new_tax2 IN (SELECT DISTINCT tax_desc,
--                                tax_cd
--                           FROM giex_new_group_tax a
--                          WHERE EXISTS (SELECT 1
--                                          FROM giex_expiry b
--                                         WHERE a.policy_id = b.policy_id
--                                           AND b.pack_policy_id = str (h)) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                            AND iss_cd = v_wpck.iss_cd
--                         UNION 
--                         SELECT DISTINCT tax_desc,
--                                tax_cd
--                           FROM giex_old_group_tax a
--                          WHERE EXISTS (SELECT 1
--                                          FROM giex_expiry b
--                                         WHERE a.policy_id = b.policy_id
--                                           AND b.pack_policy_id = str (h) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                                           AND NOT EXISTS (SELECT 1
--                                                             FROM giex_new_group_tax x
--                                                            WHERE b.policy_id = x.policy_id))
--                            AND iss_cd = v_wpck.iss_cd
--                          ORDER BY tax_cd)
--                          /* Changed by reymon 02030214
--                          SELECT DISTINCT tax_desc,
--                                tax_cd
--                           FROM giex_new_group_tax a
--                          WHERE EXISTS (SELECT 1
--                                          FROM giex_expiry b
--                                         WHERE a.policy_id = b.policy_id
--                                           AND b.pack_policy_id = p_policy)
--                            AND iss_cd = v_wpck.iss_cd
--                          ORDER BY tax_cd)*/
--        LOOP
--          IF NVL(v_wpck.tax_checker, 0) <> new_tax2.tax_cd THEN
--            IF v_wpck.tax_desc_new IS NULL THEN
--              v_wpck.tax_desc_new := new_tax2.tax_desc || ' :';
----            ELSE
----              v_wpck.tax_desc_new := v_wpck.tax_desc_new || CHR(10) || new_tax2.tax_desc || ' :';
--            END IF;
--          END IF;
--          v_wpck.tax_checker := new_tax2.tax_cd;
--        END LOOP;
--        IF v_wpck.tax_desc_new IS NULL THEN
--          v_wpck.tax_amts   := v_wpck.tax_amt_old;
--          v_wpck.tax_amts_a := v_wpck.tax_amt_old_a;
--          v_wpck.tax_descs  := v_wpck.tax_desc_old;
--          v_wpck.tax_vat    := v_wpck.tax_vat_old;
--        ELSE
--          v_wpck.tax_amts   := v_wpck.tax_amt_new;
--          v_wpck.tax_amts_a := v_wpck.tax_amt_new_a;
--          v_wpck.tax_descs  := v_wpck.tax_desc_new;
--          v_wpck.tax_vat    := v_wpck.tax_vat_new;
--        END IF;
--        
--        FOR sub_pol IN (SELECT DISTINCT policy_id,
--                               line_cd,
--                               get_line_name(line_cd) line_name,
--                               get_subline_name(subline_cd) subline_name,
--                               LTRIM(TO_CHAR(NVL(tsi_amt, 0), '99,999,999,999,990.99')) tsi_amt
--                          FROM giex_expiry
--                         WHERE pack_policy_id = str (h)) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--        LOOP
--          v_wpck.prem_new := 0;
--          FOR new_prem IN (SELECT NVL(SUM(prem_amt), 0) prem,
--                                  NVL(SUM(currency_prem_amt), 0) currency_prem
--                             FROM /*giex_old_group_peril*/giex_new_group_peril a, giis_peril b--changed to giex_new_group_peril
--                            WHERE a.line_cd = b.line_cd
--                              AND a.peril_cd = b.peril_cd
--                              AND a.policy_id = sub_pol.policy_id)
--          LOOP
--            IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
--              v_wpck.prem_new := new_prem.currency_prem;
--            ELSE
--              v_wpck.prem_new := new_prem.prem;
--            END IF;
--          END LOOP;                    
--        v_wpck.prem_old := 0;
--        
--        FOR old_prem IN (SELECT NVL(SUM(prem_amt), 0) prem,
--                                NVL(SUM(currency_prem_amt), 0) currency_prem
--                           FROM giex_old_group_peril a, giis_peril b
--                          WHERE a.line_cd = b.line_cd
--                            AND a.peril_cd = b.peril_cd
--                            AND a.policy_id = sub_pol.policy_id)
--        LOOP
--          IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
--            v_wpck.prem_old := old_prem.currency_prem;
--          ELSE
--            v_wpck.prem_old := old_prem.prem;
--          END IF;
--        END LOOP;
--        IF v_wpck.prem_new = 0 THEN
--          v_wpck.prem_gross := NVL(v_wpck.prem_gross, 0) + NVL(v_wpck.prem_old, 0);
--        ELSE
--          v_wpck.prem_gross := NVL(v_wpck.prem_gross, 0) + NVL(v_wpck.prem_new, 0);
--        END IF;
--        
--        v_wpck.gross := TO_CHAR(v_wpck.prem_gross, '9,999,999,999.90');
--        v_wpck.vat_wordings := '*VAT - subject to change persuant to R.A. 9337 (EVAT LAW).';
--        v_wpck.net_amt := v_wpck.tax_amts_a + v_wpck.prem_gross;
--        v_wpck.net := TO_CHAR(v_wpck.net_amt, '9,999,999,999.90');
--        
--        FOR cur IN (SELECT short_name
--                      FROM  giis_currency a,
--                            gipi_item b
--                     WHERE a.main_currency_cd = b.currency_cd
--                       AND b.policy_id = sub_pol.policy_id)
--        LOOP
--          v_wpck.short_name := cur.short_name;
--        END LOOP;
--        
--        v_wpck.tsi_amt33 := NULL;
--        FOR peril IN(SELECT LTRIM(TO_CHAR(SUM(a.tsi_amt), '9,999,999,999,999.99')) tsi
--                       FROM gipi_itmperil a,
--                            giis_peril b
--                      WHERE a.line_cd = b.line_cd
--                        AND a.peril_cd = b.peril_cd
--                        AND b.peril_type = 'B'
--                        AND a.policy_id = sub_pol.policy_id
--                      ORDER BY SEQUENCE)
--        LOOP
--          v_wpck.tsi_amt33 := peril.tsi;
--        END LOOP;
--        
--        IF v_wpck.subline_name2 IS NULL THEN
--          v_wpck.subline_name2 := sub_pol.subline_name;
--          v_wpck.tsi_amt       := NVL(v_wpck.tsi_amt33, sub_pol.tsi_amt);
--          v_wpck.short_name2   := v_wpck.short_name;
--        ELSE
--          v_wpck.subline_name2 := v_wpck.subline_name2 || CHR(10) || sub_pol.subline_name;
--          v_wpck.tsi_amt       := v_wpck.tsi_amt || CHR(10) || NVL(v_wpck.tsi_amt33, sub_pol.tsi_amt);
--          v_wpck.short_name2   := v_wpck.short_name2 || CHR(10) || v_wpck.short_name;
--        END IF;
--      END LOOP;
--      
--      v_wpck.cur2 := v_wpck.short_name;
--      
      IF v_pack_policy_id = 0 THEN
         v_pack_policy_id := v_wpck.policy_id;
      ELSIF v_pack_policy_id <> v_wpck.policy_id THEN
         v_pack_policy_id := v_wpck.policy_id;
         v_wpck.intm_no := NULL;
      END IF;

      FOR intm IN (SELECT TO_CHAR(a.intm_no) intm_no
                     FROM giex_expiry a,
                          giis_intermediary b
                    WHERE a.intm_no = b.intm_no
                      AND a.pack_policy_id = str (h)) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      LOOP
        IF v_wpck.intm_no IS NULL THEN
          v_wpck.intm_no := intm.intm_no;
        ELSE
          v_wpck.intm_no := v_wpck.intm_no || '/' || intm.intm_no;
        END IF;
      END LOOP;
--      
--      /*added by cherrie, deductibles enh (uw-specs-2012-0086)*/
--      BEGIN
--            v_wpck.deductible := NULL;
--            
--            FOR deductible IN ( SELECT deductible_text
--                                  FROM giex_deductibles_v
--                                 WHERE policy_id = str (h) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
--                                   AND is_package = 'Y') 
--            LOOP
--                IF v_wpck.deductible is NULL THEN
--                    v_wpck.deductible := deductible.deductible_text;
--                ELSE
--                    v_wpck.deductible := v_wpck.deductible || CHR(10) || deductible.deductible_text;    
--                END IF;
--            END LOOP;
          
      --END;
      /*end cherrie, deductibles enh (uw-specs-2012-0086)*/
      
      SELECT COUNT(*) -- bonok :: 7.2.2015 :: SR19628 UCPB Fullweb
        INTO v_wpck.ded_count
        FROM giex_deductibles_v
       WHERE policy_id = str (h)--p_policy -- Changed by Jerome Bautista 07.10.2015 SR 19689
         AND is_package = 'Y';
      
      PIPE ROW(v_wpck);
   END LOOP;
    END;

    FUNCTION populate_renewal_ucpb_wpck_sub ( -- Added by Jerome Bautista 07.10.2015 SR 19689
    p_policy              VARCHAR2 --giex_pack_expiry.pack_policy_id%TYPE -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb   
  )
    RETURN renewal_wpck_tab PIPELINED AS
      v_wpck                renewal_wpck_type;
      v_subpol_peril_flag   NUMBER(1) := 0;
      v_autopa_flag         NUMBER(1) := 0;
      v_vat                 VARCHAR(1);
      v_edited              VARCHAR2(2) := 'N';
      v_tsi_amt             NUMBER;
      v_intm_no             VARCHAR2(20000);
      v_pack_policy_id      giex_pack_expiry.pack_policy_id%TYPE := 0;
      v_line_cd             VARCHAR(1000); --Added by Jerome Bautista 07.30.2015 SR 19689
      v_menu_line_cd        VARCHAR(1000); --Added by Jerome Bautista 07.30.2015 SR 19689
      
      BEGIN  
        FOR ucpb IN (SELECT get_pack_policy_no(a.pack_policy_id) policy_no,
                            b.expiry_date expiry,
                            decode(c.designation,
                                   NULL,
                                   c.assd_name||c.assd_name2,
                                   c.designation||' '||c.assd_name||c.assd_name2) assd_name,
                                   a.address1 address1,
                                   a.address2 address2,
                                   a.address3 address3,
                                   NVL(policy_currency, 'Y') policy_currency,
                                   a.iss_cd iss_cd, 
                                   a.pack_policy_id -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                       FROM gipi_pack_polbasic a,
                            giex_pack_expiry b,
                            giis_assured c,
                            giis_line d,
                            giis_subline e
                      WHERE b.pack_policy_id = a.pack_policy_id
                        AND b.assd_no = c.assd_no
                        AND a.line_cd = d.line_cd
                        AND d.line_cd = e.line_cd
                        AND a.subline_cd = e.subline_cd
                        AND b.pack_policy_id =  p_policy)
        LOOP
          v_wpck.policy_no := ucpb.policy_no;
          v_wpck.policy_id := ucpb.pack_policy_id; --p_policy; -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
          v_wpck.expiry := TO_CHAR(ucpb.expiry, 'fmMonth DD, YYYY');
          v_wpck.assd_name := ucpb.assd_name;
          v_wpck.address := ucpb.address1||CHR(10)||ucpb.address2||CHR(10)||ucpb.address3;
          v_wpck.iss_cd := ucpb.iss_cd;
          v_wpck.policy_currency := ucpb.policy_currency;
        END LOOP;
        v_wpck.cur_date := TO_CHAR(SYSDATE, 'FMMonth dd, YYYY');  --robert 02.06.2013
        
        FOR cur IN (SELECT short_name,
                           currency_cd,
                           a.currency_rt
                      FROM giis_currency a,
                           gipi_item b,
                           gipi_polbasic y
                     WHERE a.main_currency_cd = b.currency_cd
                       AND b.policy_id = y.policy_id
                       AND EXISTS (SELECT 1
                                     FROM gipi_polbasic x
                                    WHERE y.line_cd = x.line_cd
                                      AND y.subline_cd = x.subline_cd
                                      AND y.iss_cd = x.iss_cd
                                      AND y.issue_yy = x.issue_yy
                                      AND y.pol_seq_no = x.pol_seq_no
                                      AND y.renew_no = x.renew_no
                                      AND (x.endt_seq_no = 0 OR (x.endt_seq_no > 0 AND TRUNC(x.endt_expiry_date) >= TRUNC(x.expiry_date)))
                                      AND x.pack_policy_id =  p_policy)) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        LOOP
          IF v_wpck.currency_cd IS NOT NULL AND v_wpck.currency_cd <> cur.currency_cd THEN
            v_wpck.short_name := 'PHP';
            v_wpck.currency_cd := 1;
            v_wpck.currency_rt := 1;
            EXIT;
          END IF;
          v_wpck.short_name := cur.short_name;
          v_wpck.currency_cd := cur.currency_cd;
          v_wpck.currency_rt := cur.currency_rt;
        END LOOP;
        
        /*FOR sub_pol IN (SELECT get_line_name(line_cd) line_name,
                               policy_id,
                               tsi_amt,
                               line_cd
                          FROM giex_expiry
                         WHERE pack_policy_id = p_policy)
        LOOP
          FOR a IN (SELECT SUM(a.tsi_amt) total
              FROM gipi_itmperil a,
                   giex_expiry b
             WHERE a.policy_id = sub_pol.policy_id
               AND b.line_cd = sub_pol.line_cd
               AND b.pack_policy_id = p_policy)
          LOOP
            IF v_wpck.pol_tsi IS NULL THEN
              v_wpck.pol_tsi := LTRIM(RTRIM(TO_CHAR(a.total, '999,999,999,999.90')));
            ELSE
              v_wpck.pol_tsi := v_wpck.pol_tsi || CHR(10) || LTRIM(RTRIM(TO_CHAR(a.total, '999,999,999,999.90')));
            END IF;
          END LOOP;
        
          IF v_wpck.type IS NULL THEN
            v_wpck.type := sub_pol.line_name;
            v_wpck.cur1 := v_wpck.short_name;
          ELSE
            v_wpck.type := v_wpck.type||CHR(10)||sub_pol.line_name;
            v_wpck.cur1 := v_wpck.cur1||CHR(10)||v_wpck.short_name;
          END IF;
          
          FOR subpol_peril IN (SELECT INITCAP(get_peril_name(sub_pol.line_cd, peril_cd)) peril_name,
                                      tsi_amt,
                                      peril_cd
                                 FROM gipi_itmperil
                                WHERE policy_id = sub_pol.policy_id)
          LOOP
            IF v_subpol_peril_flag = 1 THEN
              v_wpck.peril_tsi := v_wpck.peril_tsi||CHR(10);
              v_wpck.pa_limit := v_wpck.pa_limit||CHR(10);
            END IF;
            v_subpol_peril_flag := 0;
            v_wpck.type := v_wpck.type||CHR(10)||CHR(9)||CHR(9)||CHR(9)||CHR(9)||subpol_peril.peril_name;
            v_wpck.peril_tsi := v_wpck.peril_tsi||CHR(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.tsi_amt, '999,999,999,999.90')));
            IF sub_pol.line_cd = 'PA' THEN
              v_wpck.pa_limit := v_wpck.pa_limit||CHR(10)||'Limit per person';
            ELSE
              v_wpck.pa_limit := v_wpck.pa_limit||CHR(10);
            END IF;
            v_wpck.cur1 := v_wpck.cur1||CHR(10);
            v_wpck.pol_tsi := v_wpck.pol_tsi||CHR(10);
            IF sub_pol.line_cd = 'MC' AND subpol_peril.peril_cd = giisp.n('AUTO_PA') THEN
              v_autopa_flag := 1;
            END IF;
          END LOOP;
          v_wpck.peril_tsi := v_wpck.peril_tsi||CHR(10);
          v_wpck.pa_limit := v_wpck.pa_limit||CHR(10);
        END LOOP;*/ -- replaced by: Nica 01.21.2014
        FOR sub_pol IN (SELECT get_line_name(line_cd) line_name, policy_id, tsi_amt, line_cd
                      FROM giex_expiry 
                   WHERE pack_policy_id = p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        LOOP
            
            v_edited := 'N'; --moved by reymon 02032014
            
            FOR edited IN (SELECT 1
                             FROM giex_itmperil
                            WHERE policy_id = sub_pol.policy_id)
            LOOP
              v_edited := 'Y';
              EXIT;
            END LOOP;
            
            v_tsi_amt := NULL;
            
            IF v_edited = 'Y' THEN
                    FOR peril IN(SELECT SUM(a.tsi_amt) tsi
                                   FROM giex_itmperil a,
                                        giis_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND b.peril_type = 'B'
                                    AND a.policy_id = sub_pol.policy_id
                                  ORDER BY SEQUENCE)
                    LOOP
                      v_tsi_amt := peril.tsi;
                    END LOOP;
            ELSIF v_edited = 'N' THEN
                    FOR peril IN(SELECT SUM(a.tsi_amt) tsi
                                   FROM giex_old_group_peril a,
                                        giis_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.peril_cd = b.peril_cd
                                    AND b.peril_type = 'B'
                                    AND a.policy_id = sub_pol.policy_id
                                  ORDER BY SEQUENCE)
                    LOOP
                      v_tsi_amt := peril.tsi;
                    END LOOP;
            END IF;
            
            IF v_wpck.type IS NULL THEN
                v_wpck.type := sub_pol.line_name; 
                v_wpck.cur1 :=  v_wpck.short_name; --joanne 01.24.14
                v_wpck.pol_tsi := LTRIM(RTRIM(TO_CHAR(v_tsi_amt, '999,999,999,999.90')));
            ELSE
                v_wpck.type := v_wpck.type||chr(10)||sub_pol.line_name;
                v_wpck.cur1 := v_wpck.cur1||chr(10)||v_wpck.short_name;--joanne 01.24.14
                v_wpck.pol_tsi := v_wpck.pol_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(v_tsi_amt, '999,999,999,999.90')));
            END IF;
            
            --v_edited := 'N'; moved by reymon 02032014
            
            IF v_edited = 'Y' THEN
                 FOR subpol_peril IN (SELECT INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)) peril_name, SUM (a.tsi_amt) tsi_amt, SUM(NVL(a.tsi_amt,0)*NVL(a.currency_rt,1)) orig_tsi_amt, a.peril_cd
                                       FROM giex_itmperil a  /*-- pjsantos 11/22/2013 commented out and replaced giex_new_group_peril a with giex_itmperil a, consolidated from ma'am Jhing*/, giis_peril b
                                      WHERE a.line_cd = b.line_cd
                                        AND a.peril_cd = b.peril_cd
                                        AND a.policy_id = sub_pol.policy_id
                                   GROUP BY INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)), a.peril_cd)
                LOOP
                    FOR a IN (SELECT menu_line_cd, line_cd --Added by Jerome Bautista 07.30.2015 SR 19689
                                FROM giis_line
                               WHERE line_cd = sub_pol.line_cd)
                    LOOP
                        v_line_cd := a.line_cd;
                        v_menu_line_cd := a.menu_line_cd;
                    END LOOP;
                    
                    IF v_subpol_peril_flag = 1 THEN
                      v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
                    END IF;
                    v_subpol_peril_flag := 0;
                    v_wpck.type := v_wpck.type||chr(10)||'              '||subpol_peril.peril_name; --joanne 01.24.14
                    
                    IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
                        v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(subpol_peril.orig_tsi_amt, '999,999,999,999.90'));
                    ELSE
                        v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.tsi_amt, '999,999,999,999.90')));
                    END IF;
                      
                    IF NVL(v_menu_line_cd,v_line_cd) = 'PA' THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
                        v_wpck.pa_limit := v_wpck.pa_limit||chr(10)||'Limit per person';
                    ELSE
                        v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
                    END IF;
                  
                    v_wpck.cur1 := v_wpck.cur1||chr(10);
                    v_wpck.pol_tsi := v_wpck.pol_tsi||chr(10);
                    IF NVL(v_menu_line_cd,v_line_cd) = 'MC' AND subpol_peril.peril_cd = giisp.n('AUTO_PA') THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
                      v_autopa_flag := 1;
                    END IF;
                END LOOP;
                
                v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
                v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
                
            ELSIF v_edited = 'N' THEN
               FOR subpol_peril IN (SELECT INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)) peril_name, SUM (a.tsi_amt) tsi_amt, SUM (a.orig_tsi_amt) orig_tsi_amt, a.peril_cd
                                       FROM giex_old_group_peril a, giis_peril b
                                      WHERE a.line_cd = b.line_cd
                                        AND a.peril_cd = b.peril_cd
                                        AND a.policy_id = sub_pol.policy_id
                                   GROUP BY INITCAP (get_peril_name (sub_pol.line_cd, b.peril_cd)), a.peril_cd)
                LOOP
                  IF v_subpol_peril_flag = 1 THEN
                      v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
                  END IF;
                  
                  v_subpol_peril_flag := 0;
                  v_wpck.type := v_wpck.type||chr(10)||'              '||subpol_peril.peril_name;--joanne 01.24.14
                  
                  
                  IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
                        v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.orig_tsi_amt, '999,999,999,999.90')));
                  ELSE
                    v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10)||LTRIM(RTRIM(TO_CHAR(subpol_peril.tsi_amt, '999,999,999,999.90')));
                  END IF;
                  
                  IF NVL(v_menu_line_cd, v_line_cd) = 'PA' THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10)||'Limit per person';
                  ELSE
                      v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
                  END IF;
                  
                  v_wpck.cur1 := v_wpck.cur1||chr(10);
                  v_wpck.pol_tsi := v_wpck.pol_tsi||chr(10);
                  
                  IF NVL(v_menu_line_cd, v_line_cd) = 'MC' AND subpol_peril.peril_cd = giisp.n('AUTO_PA') THEN --Modified by Jerome Bautista 07.30.2015 SR 19689
                      v_autopa_flag := 1;
                  END IF;
                END LOOP;
               
                
                v_wpck.peril_tsi := v_wpck.peril_tsi||chr(10);
                v_wpck.pa_limit := v_wpck.pa_limit||chr(10);
            
            END IF;
        
        END LOOP;
        
        IF v_autopa_flag = 1 THEN
          v_wpck.auto_pa := CHR(10)
                            ||'              Now you are covered with Enhanced AUTO PA! The Enhanced Auto PA is designed to provide '
                            ||'Accidental Death and Disablement and Accidental Medical Expenses benefits to the passengers '
                            ||'of the Insured Vehicle including the driver whilst on board the Insured Vehicle. Not only that, '
                            ||'the Enhanced AUTO PA also extends the same cover to the members of the Insured''s immediate family '
                            ||'wherever they are.'
                            ||CHR(10);
        ELSE
          v_wpck.auto_pa := CHR(10);
        END IF;
        
        FOR old_tax IN (SELECT LTRIM(TO_CHAR(NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0), '99,999,999,999,990.99')) tax,
                               NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
                               tax_cd tax_id
                          FROM giex_old_group_tax a
                         WHERE EXISTS (SELECT 1
                                         FROM giex_expiry x
                                        WHERE a.policy_id = x.policy_id
                                          AND x.pack_policy_id = p_policy) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                           AND iss_cd = v_wpck.iss_cd
                         GROUP BY tax_cd
                         ORDER BY tax_cd)
        LOOP
          IF v_wpck.tax_amt_old IS NULL THEN
            v_wpck.tax_amt_old := old_tax.tax;
          ELSE
            v_wpck.tax_amt_old := v_wpck.tax_amt_old || CHR(10) || old_tax.tax;
          END IF;
          IF old_tax.tax_id = v_wpck.tax_param THEN
            v_vat := 'Y';
          END IF;
          v_wpck.tax_amt_old_a := NVL(v_wpck.tax_amt_old_a, 0) + NVL(old_tax.tax_a, 0);
        END LOOP;
        v_wpck.tax_checker := NULL;
        
        FOR old_tax2 IN (SELECT DISTINCT tax_desc,
                                          tax_cd
                            FROM giex_old_group_tax a
                           WHERE EXISTS (SELECT 1
                                           FROM giex_expiry x
                                          WHERE a.policy_id = x.policy_id
                                            AND x.pack_policy_id = p_policy) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                             AND iss_cd = v_wpck.iss_cd
                           ORDER BY tax_cd)
        LOOP
          IF NVL(v_wpck.tax_checker, 0) <> old_tax2.tax_cd THEN
            IF v_wpck.tax_desc_old IS NULL THEN
              v_wpck.tax_desc_old := old_tax2.tax_desc || ' :';
            ELSE
              v_wpck.tax_desc_old := v_wpck.tax_desc_old || CHR(10) || old_tax2.tax_desc || ' :';
            END IF;
          END IF;
          v_wpck.tax_checker := old_tax2.tax_cd;
        END LOOP;
        
        FOR new_tax IN (SELECT LTRIM(TO_CHAR(SUM(tax_a), '99,999,999,999,990.99')) tax, SUM(tax_a) tax_a, tax_id 
                          FROM (SELECT NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
                                       tax_cd tax_id
                                  FROM giex_new_group_tax a
                                 WHERE EXISTS (SELECT 1
                                                 FROM giex_expiry x
                                                WHERE a.policy_id = x.policy_id
                                                  AND x.pack_policy_id = p_policy) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                                   AND iss_cd = v_wpck.iss_cd
                                 GROUP BY tax_cd
                                 UNION ALL
                                SELECT NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
                                       tax_cd tax_id
                                  FROM giex_old_group_tax a
                                 WHERE EXISTS (SELECT 1
                                                 FROM giex_expiry x
                                                WHERE a.policy_id = x.policy_id
                                                  AND x.pack_policy_id = p_policy -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                                                  AND NOT EXISTS (SELECT 1
                                                                    FROM giex_new_group_tax b
                                                                   WHERE x.policy_id = b.policy_id))
                                   AND iss_cd = v_wpck.iss_cd
                                 GROUP BY tax_cd)
                        GROUP BY tax_id
                        ORDER BY tax_id)
                       /* changed by reymon 02032014
                       SELECT LTRIM(TO_CHAR(NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0), '99,999,999,999,990.99')) tax,
                               NVL(DECODE(v_wpck.policy_currency, 'N', SUM(tax_amt), DECODE(v_wpck.currency_cd, 1, SUM(tax_amt), SUM(currency_tax_amt))), 0) tax_a,
                               tax_cd tax_id
                          FROM giex_new_group_tax a
                         WHERE EXISTS (SELECT 1
                                         FROM giex_expiry x
                                        WHERE a.policy_id = x.policy_id
                                          AND x.pack_policy_id = p_policy)
                           AND iss_cd = v_wpck.iss_cd
                         GROUP BY tax_cd
                         ORDER BY tax_cd)*/
        LOOP
          IF v_wpck.tax_amt_new IS NULL THEN
            v_wpck.tax_amt_new := new_tax.tax;
          ELSE
            v_wpck.tax_amt_new := v_wpck.tax_amt_new || CHR(10) || new_tax.tax;
          END IF;
          IF new_tax.tax_id = v_wpck.tax_param THEN
            v_vat := 'Y';
          END IF;
          v_wpck.tax_amt_new_a := NVL(v_wpck.tax_amt_new_a, 0) + NVL(new_tax.tax_a, 0);
        END LOOP;
        v_wpck.tax_checker := NULL;
        
        FOR new_tax2 IN (SELECT DISTINCT tax_desc,
                                tax_cd
                           FROM giex_new_group_tax a
                          WHERE EXISTS (SELECT 1
                                          FROM giex_expiry b
                                         WHERE a.policy_id = b.policy_id
                                           AND b.pack_policy_id = p_policy) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                            AND iss_cd = v_wpck.iss_cd
                         UNION 
                         SELECT DISTINCT tax_desc,
                                tax_cd
                           FROM giex_old_group_tax a
                          WHERE EXISTS (SELECT 1
                                          FROM giex_expiry b
                                         WHERE a.policy_id = b.policy_id
                                           AND b.pack_policy_id = p_policy -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                                           AND NOT EXISTS (SELECT 1
                                                             FROM giex_new_group_tax x
                                                            WHERE b.policy_id = x.policy_id))
                            AND iss_cd = v_wpck.iss_cd
                          ORDER BY tax_cd)
                          /* Changed by reymon 02030214
                          SELECT DISTINCT tax_desc,
                                tax_cd
                           FROM giex_new_group_tax a
                          WHERE EXISTS (SELECT 1
                                          FROM giex_expiry b
                                         WHERE a.policy_id = b.policy_id
                                           AND b.pack_policy_id = p_policy)
                            AND iss_cd = v_wpck.iss_cd
                          ORDER BY tax_cd)*/
        LOOP
          IF NVL(v_wpck.tax_checker, 0) <> new_tax2.tax_cd THEN
            IF v_wpck.tax_desc_new IS NULL THEN
              v_wpck.tax_desc_new := new_tax2.tax_desc || ' :';
            ELSE
              v_wpck.tax_desc_new := v_wpck.tax_desc_new || CHR(10) || new_tax2.tax_desc || ' :';
            END IF;
          END IF;
          v_wpck.tax_checker := new_tax2.tax_cd;
        END LOOP;
        IF v_wpck.tax_desc_new IS NULL THEN
          v_wpck.tax_amts   := v_wpck.tax_amt_old;
          v_wpck.tax_amts_a := v_wpck.tax_amt_old_a;
          v_wpck.tax_descs  := v_wpck.tax_desc_old;
          v_wpck.tax_vat    := v_wpck.tax_vat_old;
        ELSE
          v_wpck.tax_amts   := v_wpck.tax_amt_new;
          v_wpck.tax_amts_a := v_wpck.tax_amt_new_a;
          v_wpck.tax_descs  := v_wpck.tax_desc_new;
          v_wpck.tax_vat    := v_wpck.tax_vat_new;
        END IF;
        
        FOR sub_pol IN (SELECT DISTINCT policy_id,
                               line_cd,
                               get_line_name(line_cd) line_name,
                               get_subline_name(subline_cd) subline_name,
                               LTRIM(TO_CHAR(NVL(tsi_amt, 0), '99,999,999,999,990.99')) tsi_amt
                          FROM giex_expiry
                         WHERE pack_policy_id = p_policy) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
        LOOP
          v_wpck.prem_new := 0;
          FOR new_prem IN (SELECT NVL(SUM(prem_amt), 0) prem,
                                  NVL(SUM(currency_prem_amt), 0) currency_prem
                             FROM /*giex_old_group_peril*/giex_new_group_peril a, giis_peril b--changed to giex_new_group_peril
                            WHERE a.line_cd = b.line_cd
                              AND a.peril_cd = b.peril_cd
                              AND a.policy_id = sub_pol.policy_id)
          LOOP
            IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
              v_wpck.prem_new := new_prem.currency_prem;
            ELSE
              v_wpck.prem_new := new_prem.prem;
            END IF;
          END LOOP;                    
        v_wpck.prem_old := 0;
        
        FOR old_prem IN (SELECT NVL(SUM(prem_amt), 0) prem,
                                NVL(SUM(currency_prem_amt), 0) currency_prem
                           FROM giex_old_group_peril a, giis_peril b
                          WHERE a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND a.policy_id = sub_pol.policy_id)
        LOOP
          IF v_wpck.policy_currency = 'Y' AND v_wpck.currency_cd <> 1 THEN
            v_wpck.prem_old := old_prem.currency_prem;
          ELSE
            v_wpck.prem_old := old_prem.prem;
          END IF;
        END LOOP;
        IF v_wpck.prem_new = 0 THEN
          v_wpck.prem_gross := NVL(v_wpck.prem_gross, 0) + NVL(v_wpck.prem_old, 0);
        ELSE
          v_wpck.prem_gross := NVL(v_wpck.prem_gross, 0) + NVL(v_wpck.prem_new, 0);
        END IF;
        
        v_wpck.gross := TO_CHAR(v_wpck.prem_gross, '9,999,999,999.90');
        v_wpck.vat_wordings := '*VAT - subject to change persuant to R.A. 9337 (EVAT LAW).';
        v_wpck.net_amt := v_wpck.tax_amts_a + v_wpck.prem_gross;
        v_wpck.net := TO_CHAR(v_wpck.net_amt, '9,999,999,999.90');
        
        FOR cur IN (SELECT short_name
                      FROM  giis_currency a,
                            gipi_item b
                     WHERE a.main_currency_cd = b.currency_cd
                       AND b.policy_id = sub_pol.policy_id)
        LOOP
          v_wpck.short_name := cur.short_name;
        END LOOP;
        
        v_wpck.tsi_amt33 := NULL;
        FOR peril IN(SELECT LTRIM(TO_CHAR(SUM(a.tsi_amt), '9,999,999,999,999.99')) tsi
                       FROM gipi_itmperil a,
                            giis_peril b
                      WHERE a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.peril_type = 'B'
                        AND a.policy_id = sub_pol.policy_id
                      ORDER BY SEQUENCE)
        LOOP
          v_wpck.tsi_amt33 := peril.tsi;
        END LOOP;
        
        IF v_wpck.subline_name2 IS NULL THEN
          v_wpck.subline_name2 := sub_pol.subline_name;
          v_wpck.tsi_amt       := NVL(v_wpck.tsi_amt33, sub_pol.tsi_amt);
          v_wpck.short_name2   := v_wpck.short_name;
        ELSE
          v_wpck.subline_name2 := v_wpck.subline_name2 || CHR(10) || sub_pol.subline_name;
          v_wpck.tsi_amt       := v_wpck.tsi_amt || CHR(10) || NVL(v_wpck.tsi_amt33, sub_pol.tsi_amt);
          v_wpck.short_name2   := v_wpck.short_name2 || CHR(10) || v_wpck.short_name;
        END IF;
      END LOOP;
      
      v_wpck.cur2 := v_wpck.short_name;
      
      IF v_pack_policy_id = 0 THEN
         v_pack_policy_id := v_wpck.policy_id;
      ELSIF v_pack_policy_id <> v_wpck.policy_id THEN
         v_pack_policy_id := v_wpck.policy_id;
         v_wpck.intm_no := NULL;
      END IF;
      
      FOR intm IN (SELECT TO_CHAR(a.intm_no) intm_no
                     FROM giex_expiry a,
                          giis_intermediary b
                    WHERE a.intm_no = b.intm_no
                      AND a.pack_policy_id = p_policy) -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
      LOOP
        IF v_wpck.intm_no IS NULL THEN
          v_wpck.intm_no := intm.intm_no;
        ELSE
          v_wpck.intm_no := v_wpck.intm_no || '/' || intm.intm_no;
        END IF;
      END LOOP;
      
      /*added by cherrie, deductibles enh (uw-specs-2012-0086)*/
      BEGIN
            v_wpck.deductible := NULL;
            
            FOR deductible IN ( SELECT deductible_text
                                  FROM giex_deductibles_v
                                 WHERE policy_id = p_policy -- p_policy) -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
                                   AND is_package = 'Y') 
            LOOP
                IF v_wpck.deductible is NULL THEN
                    v_wpck.deductible := deductible.deductible_text;
                ELSE
                    v_wpck.deductible := v_wpck.deductible || CHR(10) || deductible.deductible_text;    
                END IF;
            END LOOP;
          
      END;
      /*end cherrie, deductibles enh (uw-specs-2012-0086)*/
      
      SELECT COUNT(*) -- bonok :: 7.2.2015 :: SR19628 UCPB Fullweb
        INTO v_wpck.ded_count
        FROM giex_deductibles_v
       WHERE policy_id = p_policy
         AND is_package = 'Y';
      
      PIPE ROW(v_wpck);
    END;
    
    -- bonok :: 7.6.2015 :: SR19689 :: UCPB Fullweb
    FUNCTION policy_id_to_array (p_policy_id CLOB, p_ref VARCHAR2) -- Added by Jerome Bautista 07.10.2015 SR 19689
      RETURN policy_id_array
   IS
      i          NUMBER          := 0;
      POSITION   NUMBER          := 0;
      p_input    VARCHAR2 (30000) := TO_CHAR(p_policy_id);
      output     policy_id_array;
   BEGIN
      POSITION := INSTR (p_input, p_ref, 1, 1);

      IF POSITION = 0 THEN
         output (1) := p_input;
      END IF;

      WHILE (POSITION != 0)
      LOOP
         i := i + 1;
         output (i) := SUBSTR (p_input, 1, POSITION - 1);
         p_input := SUBSTR (p_input, POSITION + 1, LENGTH (p_input));
         POSITION := INSTR (p_input, p_ref, 1, 1);

         IF POSITION = 0 THEN
            output (i + 1) := p_input;
         END IF;
      END LOOP;

      RETURN output;
   END policy_id_to_array;
END populate_renewal_notice;
/
