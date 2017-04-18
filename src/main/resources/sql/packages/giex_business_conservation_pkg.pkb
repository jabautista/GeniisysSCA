CREATE OR REPLACE PACKAGE BODY CPI.GIEX_BUSINESS_CONSERVATION_PKG AS
    PROCEDURE extract_policies(
        p_line_cd           GIIS_LINE.line_cd%TYPE,
        p_subline_cd        GIIS_SUBLINE.subline_cd%TYPE,
        p_iss_cd            GIIS_ISSOURCE.iss_cd%TYPE,
        p_intm_no           NUMBER,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_del_table         VARCHAR2,
        p_inc_pack          VARCHAR2,
        p_cred_cd           GIIS_ISSOURCE.iss_cd%TYPE,
        p_intm_type         GIIS_INTM_TYPE.intm_type%TYPE,
        p_from_month        VARCHAR2,
        p_user_id           GIIS_USERS.user_id%TYPE,
        p_msg				OUT VARCHAR2 -- added by Daniel Marasigan SR 22330 07.11.2016
    )
    IS
        v_include_package   VARCHAR2(10) := NULL;
        v_pack_line         BOOLEAN := FALSE;
        v_from_date         DATE;
        v_to_date           DATE;
        v_line_cd           VARCHAR2(1000);
        v_subline_cd        VARCHAR2(1000);
        v_iss_cd            VARCHAR2(1000);
        v_intm_no           NUMBER;
        v_cred_cd           VARCHAR2(1000);
        v_intm_type         VARCHAR2(1000);
        v_extract_count     NUMBER := 0; -- added by Daniel Marasigan SR 22330 07.11.2016
    BEGIN
        IF p_from_month = 'Y' THEN
            v_from_date := TO_DATE(p_from_date, 'DD-MON-YYYY');
            v_to_date := LAST_DAY(TO_DATE(p_to_date, 'DD-MON-YYYY'));
        ELSE
            v_from_date := TO_DATE(p_from_date, 'MM-DD-YYYY');
            v_to_date := TO_DATE(p_to_date, 'MM-DD-YYYY');
        END IF;
    
        IF p_line_cd = 'ALL' THEN
            v_line_cd := NULL;
        ELSE
            v_line_cd := p_line_cd;
        END IF;
        
        IF p_subline_cd = 'ALL' THEN
            v_subline_cd := NULL;
        ELSE
            v_subline_cd := p_subline_cd;
        END IF;
        
        IF p_iss_cd = 'ALL' THEN
            v_iss_cd := NULL;
        ELSE
            v_iss_cd := p_iss_cd;
        END IF;
        
        IF p_intm_no = '' THEN
            v_intm_no := NULL;
        ELSE
            v_intm_no := p_intm_no;
        END IF;
        
        IF p_cred_cd = 'ALL' THEN
            v_cred_cd := NULL;
        ELSE
            v_cred_cd := p_cred_cd;
        END IF;
        
        IF p_intm_type = 'ALL' THEN
            v_intm_type := NULL;
        ELSE
            v_intm_type := p_intm_type;
        END IF;
    
        FOR a IN (SELECT line_cd
                    FROM GIIS_LINE
                   WHERE pack_pol_flag = 'Y')
        LOOP
            IF p_line_cd = a.line_cd THEN
                v_pack_line := TRUE;
                EXIT;
            END IF;
        END LOOP;
        
        IF p_line_cd <> 'ALL' THEN
            v_include_package := NVL(p_inc_pack, 'Y');
            IF NOT v_pack_line AND v_include_package = 'Y' THEN
                v_include_package := 'X';
            END IF;
        ELSE
            v_include_package := 'Y';
        END IF;
        
        p_bus_conservation_dtl_web.get_data(v_line_cd,
                                        v_subline_cd,
                                        v_iss_cd,
                                        v_intm_no,
                                        v_from_date,
                                        v_to_date,
                                        'Y',
                                        v_include_package,
                                        v_cred_cd,
                                        v_intm_type,
                                        p_user_id);
                                        
        p_bus_conservation_dtl_web.get_data(v_line_cd,
                                        v_subline_cd,
                                        v_iss_cd,
                                        v_intm_no,
                                        ADD_MONTHS(v_from_date, -12),
                                        ADD_MONTHS(v_to_date, -12),
                                        'N',
                                        v_include_package,
                                        v_cred_cd,
                                        v_intm_type,
                                        p_user_id);
                                        
        p_bus_conservation_web.get_data(v_line_cd,
                                    v_subline_cd,
                                    v_iss_cd,
                                    v_intm_no,
                                    v_from_date,
                                    v_to_date,
                                    'Y',
                                    --v_include_package,
                                    v_cred_cd,
                                    v_intm_type,
                                    p_user_id);
                                    
        --added by Daniel Marasigan SR 22330 07.11.2016
        SELECT COUNT(*)
        INTO v_extract_count
        FROM giex_ren_ratio_dtl
        WHERE line_cd = NVL(v_line_cd, line_cd)
          AND subline_cd = NVL(v_subline_cd, subline_cd)
          AND iss_cd = NVL(v_iss_cd, iss_cd)
          AND NVL(intm_no, 1) = NVL(v_intm_no, NVL(intm_no, 1))
          AND user_id = p_user_id;
        
        IF v_extract_count = 0 OR SQL%NOTFOUND THEN
            p_msg := 'No records extracted';
        ELSE
            p_msg := v_extract_count || ' record(s) extracted.';
        END IF;
    END;
    
    FUNCTION get_bus_con_details(
        p_line_cd           GIIS_LINE.line_cd%TYPE,
        p_iss_cd            GIIS_ISSOURCE.iss_cd%TYPE,
        p_mode              NUMBER,
        p_assd_name         VARCHAR2,
        p_policy_no         VARCHAR2,
        p_renewal_no        VARCHAR2,
        p_prem_amt          VARCHAR2,
        p_renewal_amt       VARCHAR2,
        p_user_id           VARCHAR2
    )
      RETURN bus_con_details_tab PIPELINED AS
        v_details           bus_con_details_type;
        v_prem_total        NUMBER := 0;
        v_prem_renew_total  NUMBER := 0;
        v_renewal_count     NUMBER := 0;
    BEGIN        
        FOR a IN (SELECT DISTINCT line_cd,
                         iss_cd
                    FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                  a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                  f.line_name line_name, g.subline_name subline_name,
                                  TO_CHAR (a.intm_no, '09999999') intm_number,
                                  a.assd_no assured_no, b.assd_name assured_name,
                                  c.expiry_date expiry_date,
                                     c.line_cd
                                  || '-'
                                  || c.subline_cd
                                  || '-'
                                  || c.iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                  a.prem_amt premium_amt,
                                  DECODE (a.renewal_tag,
                                          'Y', a.prem_renew_amt,
                                          0
                                         ) premium_renew_amt,
                                  DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                  DECODE (a.renewal_tag,
                                          'Y', c.line_cd
                                           || '-'
                                           || c.iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.renew_no, '09'))
                                         ) renewal_policy,
                                  c.ref_pol_no
                             FROM giex_ren_ratio_dtl a,
                                  gipi_polbasic c,
                                  giis_assured b,
                                  giis_line f,
                                  giis_subline g,
                                  giis_issource h
                            WHERE 1 = 1
                              AND h.iss_cd = a.iss_cd
                              AND f.line_cd = a.line_cd
                              AND g.subline_cd = a.subline_cd
                              AND g.line_cd = a.line_cd
                              AND b.assd_no = a.assd_no
                              AND c.policy_id = a.policy_id
                              AND a.YEAR IN (SELECT MAX (YEAR)
                                               FROM giex_ren_ratio_dtl
                                              WHERE user_id = p_user_id)
                              AND a.user_id = p_user_id
                              AND a.pack_policy_id = 0
                  UNION ALL
                  SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                  a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                  f.line_name line_name, g.subline_name subline_name,
                                  TO_CHAR (a.intm_no, '09999999') intm_number,
                                  a.assd_no assured_no, b.assd_name assured_name,
                                  c.expiry_date expiry_date,
                                     c.line_cd
                                  || '-'
                                  || c.subline_cd
                                  || '-'
                                  || c.iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                  a.prem_amt premium_amt,
                                  DECODE (a.renewal_tag,
                                          'Y', a.prem_renew_amt,
                                          0
                                         ) premium_renew_amt,
                                  DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                  DECODE (a.renewal_tag,
                                          'Y', c.line_cd
                                           || '-'
                                           || c.iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.renew_no, '09'))
                                         ) renewal_policy,
                                  c.ref_pol_no
                             FROM giex_ren_ratio_dtl a,
                                  gipi_pack_polbasic c,
                                  giis_assured b,
                                  giis_line f,
                                  giis_subline g,
                                  giis_issource h
                            WHERE 1 = 1
                              AND h.iss_cd = a.iss_cd
                              AND f.line_cd = a.line_cd
                              AND g.subline_cd = a.subline_cd
                              AND g.line_cd = a.line_cd
                              AND b.assd_no = a.assd_no
                              AND c.pack_policy_id = a.policy_id
                              AND a.YEAR IN (SELECT MAX (YEAR)
                                               FROM giex_ren_ratio_dtl
                                              WHERE user_id = p_user_id)
                              AND a.user_id = p_user_id
                              AND a.pack_policy_id > 0))
        LOOP
            FOR d IN (SELECT *
                        FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                     a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                     f.line_name line_name, g.subline_name subline_name,
                                     TO_CHAR (a.intm_no, '09999999') intm_number,
                                     a.assd_no assured_no, b.assd_name assured_name,
                                     c.expiry_date expiry_date,
                                        c.line_cd
                                     || '-'
                                     || c.subline_cd
                                     || '-'
                                     || c.iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                     a.prem_amt premium_amt,
                                     DECODE (a.renewal_tag,
                                             'Y', a.prem_renew_amt,
                                             0
                                            ) premium_renew_amt,
                                     DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                     DECODE (a.renewal_tag,
                                             'Y', c.line_cd
                                              || '-'
                                              || c.iss_cd
                                              || '-'
                                              || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.renew_no, '09'))
                                            ) renewal_policy,
                                     c.ref_pol_no
                                FROM giex_ren_ratio_dtl a,
                                     gipi_polbasic c,
                                     giis_assured b,
                                     giis_line f,
                                     giis_subline g,
                                     giis_issource h
                               WHERE 1 = 1
                                 AND h.iss_cd = a.iss_cd
                                 AND f.line_cd = a.line_cd
                                 AND g.subline_cd = a.subline_cd
                                 AND g.line_cd = a.line_cd
                                 AND b.assd_no = a.assd_no
                                 AND c.policy_id = a.policy_id
                                 AND a.YEAR IN (SELECT MAX (YEAR)
                                                  FROM giex_ren_ratio_dtl
                                                 WHERE user_id = p_user_id)
                                 AND a.user_id = p_user_id
                                 AND a.pack_policy_id = 0
                     UNION ALL
                     SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                     a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                     f.line_name line_name, g.subline_name subline_name,
                                     TO_CHAR (a.intm_no, '09999999') intm_number,
                                     a.assd_no assured_no, b.assd_name assured_name,
                                     c.expiry_date expiry_date,
                                        c.line_cd
                                     || '-'
                                     || c.subline_cd
                                     || '-'
                                     || c.iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                     a.prem_amt premium_amt,
                                     DECODE (a.renewal_tag,
                                             'Y', a.prem_renew_amt,
                                             0
                                            ) premium_renew_amt,
                                     DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                     DECODE (a.renewal_tag,
                                             'Y', c.line_cd
                                              || '-'
                                              || c.iss_cd
                                              || '-'
                                              || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.renew_no, '09'))
                                            ) renewal_policy,
                                     c.ref_pol_no
                                FROM giex_ren_ratio_dtl a,
                                     gipi_pack_polbasic c,
                                     giis_assured b,
                                     giis_line f,
                                     giis_subline g,
                                     giis_issource h
                               WHERE 1 = 1
                                 AND h.iss_cd = a.iss_cd
                                 AND f.line_cd = a.line_cd
                                 AND g.subline_cd = a.subline_cd
                                 AND g.line_cd = a.line_cd
                                 AND b.assd_no = a.assd_no
                                 AND c.pack_policy_id = a.policy_id
                                 AND a.YEAR IN (SELECT MAX (YEAR)
                                                  FROM giex_ren_ratio_dtl
                                                 WHERE user_id = p_user_id)
                                 AND a.user_id = p_user_id
                                 AND a.pack_policy_id > 0) v
                       WHERE line_cd = NVL(p_line_cd, line_cd)
                         AND line_cd = a.line_cd
                         AND iss_cd = NVL(p_iss_cd, iss_cd)
                         AND iss_cd = a.iss_cd
                         AND UPPER(assured_name) LIKE UPPER(NVL(p_assd_name, assured_name))
                         AND UPPER(policy_no) LIKE UPPER(NVL(p_policy_no, policy_no))
                         AND premium_amt = NVL(LTRIM(TO_NUMBER(REPLACE(p_prem_amt, ',', ''))), premium_amt)
                         AND UPPER(NVL(renewal_policy, 'x')) LIKE UPPER(NVL(p_renewal_no, DECODE(renewal_policy, NULL, 'x', renewal_policy)))
                         AND NVL(premium_renew_amt, 0) = NVL(LTRIM(TO_NUMBER(REPLACE(p_renewal_amt, ',', ''))), DECODE(premium_renew_amt, NULL, 0, premium_renew_amt)))
            LOOP
                v_details.exp_date := TO_CHAR(d.expiry_date, 'MM-DD-YYYY');
                v_details.prem_amt := LTRIM(TO_CHAR(NVL(d.premium_amt, 0), '9,999,999,990.00'));
                v_details.prem_renew_amt := LTRIM(TO_CHAR(NVL(d.premium_renew_amt, 0), '9,999,999,990.00'));
                v_details.policy_id := d.policy_id;
                v_details.pack_policy_id := d.pack_policy_id;
                v_details.line_cd := d.line_cd;
                v_details.iss_cd := d.iss_cd;
                v_details.iss_name := d.iss_name;
                v_details.line_name := d.line_name;
                v_details.subline_name := d.subline_name;
                v_details.intm_number := d.intm_number;
                v_details.assured_no := d.assured_no;
                v_details.assured_name := d.assured_name;
                v_details.expiry_date := d.expiry_date;
                v_details.policy_no := d.policy_no;
                v_details.premium_amt := NVL(d.premium_amt, 0);
                v_details.premium_renew_amt := NVL(d.premium_renew_amt, 0);
                v_details.remarks := d.remarks;
                v_details.renewal_policy := d.renewal_policy;
                v_details.ref_pol_no := d.ref_pol_no;
                
                FOR m IN (SELECT *
                            FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                        a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                        f.line_name line_name, g.subline_name subline_name,
                                        TO_CHAR (a.intm_no, '09999999') intm_number,
                                        a.assd_no assured_no, b.assd_name assured_name,
                                        c.expiry_date expiry_date,
                                           c.line_cd
                                        || '-'
                                        || c.subline_cd
                                        || '-'
                                        || c.iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                        a.prem_amt premium_amt,
                                        DECODE (a.renewal_tag,
                                                'Y', a.prem_renew_amt,
                                                0
                                               ) premium_renew_amt,
                                        DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                        DECODE (a.renewal_tag,
                                                'Y', c.line_cd
                                                 || '-'
                                                 || c.iss_cd
                                                 || '-'
                                                 || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                                 || '-'
                                                 || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                                 || '-'
                                                 || LTRIM (TO_CHAR (c.renew_no, '09'))
                                               ) renewal_policy,
                                        c.ref_pol_no
                                   FROM giex_ren_ratio_dtl a,
                                        gipi_polbasic c,
                                        giis_assured b,
                                        giis_line f,
                                        giis_subline g,
                                        giis_issource h
                                  WHERE 1 = 1
                                    AND h.iss_cd = a.iss_cd
                                    AND f.line_cd = a.line_cd
                                    AND g.subline_cd = a.subline_cd
                                    AND g.line_cd = a.line_cd
                                    AND b.assd_no = a.assd_no
                                    AND c.policy_id = a.policy_id
                                    AND a.YEAR IN (SELECT MAX (YEAR)
                                                     FROM giex_ren_ratio_dtl
                                                    WHERE user_id = p_user_id)
                                    AND a.user_id = p_user_id
                                    AND a.pack_policy_id = 0
                        UNION ALL
                        SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                        a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                        f.line_name line_name, g.subline_name subline_name,
                                        TO_CHAR (a.intm_no, '09999999') intm_number,
                                        a.assd_no assured_no, b.assd_name assured_name,
                                        c.expiry_date expiry_date,
                                           c.line_cd
                                        || '-'
                                        || c.subline_cd
                                        || '-'
                                        || c.iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                        a.prem_amt premium_amt,
                                        DECODE (a.renewal_tag,
                                                'Y', a.prem_renew_amt,
                                                0
                                               ) premium_renew_amt,
                                        DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                        DECODE (a.renewal_tag,
                                                'Y', c.line_cd
                                                 || '-'
                                                 || c.iss_cd
                                                 || '-'
                                                 || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                                 || '-'
                                                 || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                                 || '-'
                                                 || LTRIM (TO_CHAR (c.renew_no, '09'))
                                               ) renewal_policy,
                                        c.ref_pol_no
                                   FROM giex_ren_ratio_dtl a,
                                        gipi_pack_polbasic c,
                                        giis_assured b,
                                        giis_line f,
                                        giis_subline g,
                                        giis_issource h
                                  WHERE 1 = 1
                                    AND h.iss_cd = a.iss_cd
                                    AND f.line_cd = a.line_cd
                                    AND g.subline_cd = a.subline_cd
                                    AND g.line_cd = a.line_cd
                                    AND b.assd_no = a.assd_no
                                    AND c.pack_policy_id = a.policy_id
                                    AND a.YEAR IN (SELECT MAX (YEAR)
                                                     FROM giex_ren_ratio_dtl
                                                    WHERE user_id = p_user_id)
                                    AND a.user_id = p_user_id
                                    AND a.pack_policy_id > 0)
                           WHERE line_cd = NVL(p_line_cd, line_cd)
                             AND line_cd = a.line_cd
                             AND iss_cd = NVL(p_iss_cd, iss_cd)
                             AND iss_cd = a.iss_cd
                             AND UPPER(assured_name) LIKE UPPER(NVL(p_assd_name, assured_name))
                             AND UPPER(policy_no) LIKE UPPER(NVL(p_policy_no, policy_no))
                             AND premium_amt = NVL(LTRIM(TO_NUMBER(REPLACE(p_prem_amt, ',', ''))), premium_amt)
                             AND UPPER(NVL(renewal_policy, '*')) LIKE UPPER(NVL(p_renewal_no, DECODE(renewal_policy, NULL, '*', renewal_policy)))
                             AND NVL(premium_renew_amt, 0) = NVL(LTRIM(TO_NUMBER(REPLACE(p_renewal_amt, ',', ''))), DECODE(premium_renew_amt, NULL, 0, premium_renew_amt)))
                LOOP
                    v_prem_total := v_prem_total + NVL(m.premium_amt, 0);
                    v_prem_renew_total := v_prem_renew_total + NVL(m.premium_renew_amt, 0);
                    IF m.renewal_policy IS NOT NULL THEN
                        v_renewal_count := v_renewal_count + 1;
                    END IF;
                END LOOP;
                v_details.prem_total := LTRIM(TO_CHAR(v_prem_total, '9,999,999,990.00'));
                v_details.prem_renew_total := LTRIM(TO_CHAR(v_prem_renew_total, '9,999,999,990.00'));
                v_details.renewal_count := v_renewal_count;
                v_prem_total := 0;
                v_prem_renew_total := 0;
                v_renewal_count := 0;
                
                PIPE ROW(v_details);
            END LOOP;
            IF p_mode = 1 OR p_mode IS NULL THEN
                EXIT;
            END IF;
        END LOOP;
    END;
    
    FUNCTION get_bus_con_pack_details(
        p_pack_pol_id       GIEX_REN_RATIO_PACK_V.pack_policy_id%TYPE,
        p_assd_name         VARCHAR2,
        p_policy_no         VARCHAR2,
        p_renewal_no        VARCHAR2,
        p_prem_amt          VARCHAR2,
        p_renewal_amt       VARCHAR2,
        p_user_id           VARCHAR2
    )
      RETURN bus_con_details_tab PIPELINED AS
        v_pack_details      bus_con_details_type;
        v_prem_total        NUMBER;
        v_prem_renew_total  NUMBER;
        v_renewal_count     NUMBER;
    BEGIN
        v_prem_total := 0;
        v_prem_renew_total := 0;
        v_renewal_count := 0;
        
        FOR p IN (SELECT *
                    FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                  a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                  f.line_name line_name, g.subline_name subline_name,
                                  TO_CHAR (a.intm_no, '09999999') intm_number,
                                  a.assd_no assured_no, b.assd_name assured_name,
                                  c.expiry_date expiry_date,
                                     c.line_cd
                                  || '-'
                                  || c.subline_cd
                                  || '-'
                                  || c.iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                  a.prem_amt premium_amt,
                                  DECODE (a.renewal_tag,
                                          'Y', a.prem_renew_amt,
                                          0
                                         ) premium_renew_amt,
                                  DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                  DECODE (a.renewal_tag,
                                          'Y', c.line_cd
                                           || '-'
                                           || c.iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.renew_no, '09'))
                                         ) renewal_policy,
                                  c.ref_pol_no
                             FROM giex_ren_ratio_dtl a,
                                  gipi_polbasic c,
                                  giis_assured b,
                                  giis_line f,
                                  giis_subline g,
                                  giis_issource h
                            WHERE 1 = 1
                              AND h.iss_cd = a.iss_cd
                              AND f.line_cd = a.line_cd
                              AND g.subline_cd = a.subline_cd
                              AND g.line_cd = a.line_cd
                              AND b.assd_no = a.assd_no
                              AND c.policy_id = a.policy_id
                              AND a.YEAR IN (SELECT MAX (YEAR)
                                               FROM giex_ren_ratio_dtl
                                              WHERE user_id = p_user_id)
                              AND a.user_id = p_user_id
                              AND a.pack_policy_id = 0
                  UNION ALL
                  SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                  a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                  f.line_name line_name, g.subline_name subline_name,
                                  TO_CHAR (a.intm_no, '09999999') intm_number,
                                  a.assd_no assured_no, b.assd_name assured_name,
                                  c.expiry_date expiry_date,
                                     c.line_cd
                                  || '-'
                                  || c.subline_cd
                                  || '-'
                                  || c.iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                  || '-'
                                  || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                  a.prem_amt premium_amt,
                                  DECODE (a.renewal_tag,
                                          'Y', a.prem_renew_amt,
                                          0
                                         ) premium_renew_amt,
                                  DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                  DECODE (a.renewal_tag,
                                          'Y', c.line_cd
                                           || '-'
                                           || c.iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.renew_no, '09'))
                                         ) renewal_policy,
                                  c.ref_pol_no
                             FROM giex_ren_ratio_dtl a,
                                  gipi_pack_polbasic c,
                                  giis_assured b,
                                  giis_line f,
                                  giis_subline g,
                                  giis_issource h
                            WHERE 1 = 1
                              AND h.iss_cd = a.iss_cd
                              AND f.line_cd = a.line_cd
                              AND g.subline_cd = a.subline_cd
                              AND g.line_cd = a.line_cd
                              AND b.assd_no = a.assd_no
                              AND c.pack_policy_id = a.policy_id
                              AND a.YEAR IN (SELECT MAX (YEAR)
                                               FROM giex_ren_ratio_dtl
                                              WHERE user_id = p_user_id)
                              AND a.user_id = p_user_id
                              AND a.pack_policy_id > 0)
                   WHERE pack_policy_id > 0
                     AND pack_policy_id <> policy_id
                     AND pack_policy_id = p_pack_pol_id
                     AND UPPER(assured_name) LIKE UPPER(NVL(p_assd_name, assured_name))
                     AND UPPER(policy_no) LIKE UPPER(NVL(p_policy_no, policy_no))
                     AND premium_amt = NVL(LTRIM(TO_NUMBER(REPLACE(p_prem_amt, ',', ''))), premium_amt)
                     AND UPPER(NVL(renewal_policy, 'x')) LIKE UPPER(NVL(p_renewal_no, DECODE(renewal_policy, NULL, 'x', renewal_policy)))
                     AND NVL(premium_renew_amt, 0) = NVL(LTRIM(TO_NUMBER(REPLACE(p_renewal_amt, ',', ''))), DECODE(premium_renew_amt, NULL, 0, premium_renew_amt))
                   ORDER BY intm_number,
                            policy_no)
        LOOP
            v_pack_details.exp_date := TO_CHAR(p.expiry_date, 'MM-DD-YYYY');
            v_pack_details.prem_amt := LTRIM(TO_CHAR(NVL(p.premium_amt, 0), '9,999,999,990.00'));
            v_pack_details.prem_renew_amt := LTRIM(TO_CHAR(NVL(p.premium_renew_amt, 0), '9,999,999,990.00'));
            v_pack_details.policy_id := p.policy_id;
            v_pack_details.pack_policy_id := p.pack_policy_id;
            v_pack_details.line_cd := p.line_cd;
            v_pack_details.iss_cd := p.iss_cd;
            v_pack_details.iss_name := p.iss_name;
            v_pack_details.line_name := p.line_name;
            v_pack_details.subline_name := p.subline_name;
            v_pack_details.intm_number := p.intm_number;
            v_pack_details.assured_no := p.assured_no;
            v_pack_details.assured_name := p.assured_name;
            v_pack_details.expiry_date := p.expiry_date;
            v_pack_details.policy_no := p.policy_no;
            v_pack_details.premium_amt := NVL(p.premium_amt, 0);
            v_pack_details.premium_renew_amt := NVL(p.premium_renew_amt, 0);
            v_pack_details.remarks := p.remarks;
            v_pack_details.renewal_policy := p.renewal_policy;
            v_pack_details.ref_pol_no := p.ref_pol_no;
            
            FOR m IN (SELECT *
                        FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                     a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                     f.line_name line_name, g.subline_name subline_name,
                                     TO_CHAR (a.intm_no, '09999999') intm_number,
                                     a.assd_no assured_no, b.assd_name assured_name,
                                     c.expiry_date expiry_date,
                                        c.line_cd
                                     || '-'
                                     || c.subline_cd
                                     || '-'
                                     || c.iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                     a.prem_amt premium_amt,
                                     DECODE (a.renewal_tag,
                                             'Y', a.prem_renew_amt,
                                             0
                                            ) premium_renew_amt,
                                     DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                     DECODE (a.renewal_tag,
                                             'Y', c.line_cd
                                              || '-'
                                              || c.iss_cd
                                              || '-'
                                              || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.renew_no, '09'))
                                            ) renewal_policy,
                                     c.ref_pol_no
                                FROM giex_ren_ratio_dtl a,
                                     gipi_polbasic c,
                                     giis_assured b,
                                     giis_line f,
                                     giis_subline g,
                                     giis_issource h
                               WHERE 1 = 1
                                 AND h.iss_cd = a.iss_cd
                                 AND f.line_cd = a.line_cd
                                 AND g.subline_cd = a.subline_cd
                                 AND g.line_cd = a.line_cd
                                 AND b.assd_no = a.assd_no
                                 AND c.policy_id = a.policy_id
                                 AND a.YEAR IN (SELECT MAX (YEAR)
                                                  FROM giex_ren_ratio_dtl
                                                 WHERE user_id = p_user_id)
                                 AND a.user_id = p_user_id
                                 AND a.pack_policy_id = 0
                     UNION ALL
                     SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                                     a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                                     f.line_name line_name, g.subline_name subline_name,
                                     TO_CHAR (a.intm_no, '09999999') intm_number,
                                     a.assd_no assured_no, b.assd_name assured_name,
                                     c.expiry_date expiry_date,
                                        c.line_cd
                                     || '-'
                                     || c.subline_cd
                                     || '-'
                                     || c.iss_cd
                                     || '-'
                                     || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                     || '-'
                                     || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                     a.prem_amt premium_amt,
                                     DECODE (a.renewal_tag,
                                             'Y', a.prem_renew_amt,
                                             0
                                            ) premium_renew_amt,
                                     DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                                     DECODE (a.renewal_tag,
                                             'Y', c.line_cd
                                              || '-'
                                              || c.iss_cd
                                              || '-'
                                              || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                              || '-'
                                              || LTRIM (TO_CHAR (c.renew_no, '09'))
                                            ) renewal_policy,
                                     c.ref_pol_no
                                FROM giex_ren_ratio_dtl a,
                                     gipi_pack_polbasic c,
                                     giis_assured b,
                                     giis_line f,
                                     giis_subline g,
                                     giis_issource h
                               WHERE 1 = 1
                                 AND h.iss_cd = a.iss_cd
                                 AND f.line_cd = a.line_cd
                                 AND g.subline_cd = a.subline_cd
                                 AND g.line_cd = a.line_cd
                                 AND b.assd_no = a.assd_no
                                 AND c.pack_policy_id = a.policy_id
                                 AND a.YEAR IN (SELECT MAX (YEAR)
                                                  FROM giex_ren_ratio_dtl
                                                 WHERE user_id = p_user_id)
                                 AND a.user_id = p_user_id
                                 AND a.pack_policy_id > 0)
                       WHERE pack_policy_id > 0
                         AND pack_policy_id <> policy_id
                         AND pack_policy_id = p_pack_pol_id
                         AND UPPER(assured_name) LIKE UPPER(NVL(p_assd_name, assured_name))
                         AND UPPER(policy_no) LIKE UPPER(NVL(p_policy_no, policy_no))
                         AND premium_amt = NVL(LTRIM(TO_NUMBER(REPLACE(p_prem_amt, ',', ''))), premium_amt)
                         AND UPPER(NVL(renewal_policy, 'x')) LIKE UPPER(NVL(p_renewal_no, DECODE(renewal_policy, NULL, 'x', renewal_policy)))
                         AND NVL(premium_renew_amt, 0) = NVL(LTRIM(TO_NUMBER(REPLACE(p_renewal_amt, ',', ''))), DECODE(premium_renew_amt, NULL, 0, premium_renew_amt))
                       ORDER BY intm_number,
                                policy_no)
                LOOP
                    v_prem_total := v_prem_total + NVL(m.premium_amt, 0);
                    v_prem_renew_total := v_prem_renew_total + NVL(m.premium_renew_amt, 0);
                    IF m.renewal_policy IS NOT NULL THEN
                        v_renewal_count := v_renewal_count + 1;
                    END IF;
                END LOOP;
                v_pack_details.prem_total := LTRIM(TO_CHAR(v_prem_total, '9,999,999,990.00'));
                v_pack_details.prem_renew_total := LTRIM(TO_CHAR(v_prem_renew_total, '9,999,999,990.00'));
                v_pack_details.renewal_count := v_renewal_count;
                v_prem_total := 0;
                v_prem_renew_total := 0;
                v_renewal_count := 0;
                
            PIPE ROW(v_pack_details);
        END LOOP;
    END;
    
    FUNCTION get_bus_con_line_lov
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT line_cd,
                       line_name,
                       pack_pol_flag
                  FROM GIIS_LINE
                 UNION
                SELECT 'ALL' line_cd,
                       'ALL LINES' line_name,
                       'N' pack_pol_flag
                  FROM dual)
      LOOP
        v_lov.line_cd := a.line_cd;
        v_lov.line_name := a.line_name;
        v_lov.pack_pol_flag := a.pack_pol_flag;
        PIPE ROW(v_lov);
      END LOOP;                  
    END;
    
    FUNCTION get_bus_con_subline_lov(
        p_line_cd       GIIS_LINE.line_cd%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT subline_cd,
                       subline_name
                  FROM GIIS_SUBLINE
                 WHERE line_cd = p_line_cd
                 UNION
                SELECT 'ALL' subline_cd,
                       'ALL SUBLINES' subline_name
                  FROM dual)
      LOOP
        v_lov.subline_cd := a.subline_cd;
        v_lov.subline_name := a.subline_name;
        PIPE ROW(v_lov);
      END LOOP;                  
    END;
    
    FUNCTION get_bus_con_issue_lov
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT iss_cd,
                       iss_name
                  FROM GIIS_ISSOURCE
                 UNION
                SELECT 'ALL' iss_cd,
                       'ALL ISSUE SOURCES' iss_name
                  FROM dual)
      LOOP
        v_lov.iss_cd := a.iss_cd;
        v_lov.iss_name := a.iss_name;
        PIPE ROW(v_lov);
      END LOOP;
    END;
    
    FUNCTION get_bus_con_credit_lov
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT iss_cd,
                       iss_name
                  FROM GIIS_ISSOURCE
                 WHERE cred_br_tag = 'Y'
                 UNION
                SELECT 'ALL' iss_cd,
                       'ALL CREDITING BRANCH' iss_name
                  FROM dual)
      LOOP
        v_lov.iss_cd := a.iss_cd;
        v_lov.iss_name := a.iss_name;
        PIPE ROW(v_lov);
      END LOOP;                  
    END;
    
    FUNCTION get_bus_con_intm_type_lov
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT intm_type,
                       intm_desc
                  FROM GIIS_INTM_TYPE
                 UNION
                SELECT 'ALL' intm_type,
                       'ALL INTM TYPE' intm_desc
                  FROM dual)
      LOOP
        v_lov.intm_type := a.intm_type;
        v_lov.intm_desc := a.intm_desc;
        PIPE ROW(v_lov);
      END LOOP;                  
    END;
    
    FUNCTION get_bus_con_intm_lov(
        p_intm_type      GIIS_INTM_TYPE.intm_type%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT TO_CHAR(intm_no) intm_no,
                       intm_name
                  FROM GIIS_INTERMEDIARY
                 WHERE intm_type = p_intm_type
                 UNION
                SELECT 'ALL' intm_no,
                       'ALL INTERMEDIARIES' intm_name
                  FROM dual)
      LOOP
        v_lov.intm_no := a.intm_no;
        v_lov.intm_name := a.intm_name;
        PIPE ROW(v_lov);
      END LOOP;                  
    END;
    
    FUNCTION get_bus_con_details_line_lov(
      p_user_id            GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT DISTINCT line_cd,
                       line_name
                  FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                               a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                               f.line_name line_name, g.subline_name subline_name,
                               TO_CHAR (a.intm_no, '09999999') intm_number,
                               a.assd_no assured_no, b.assd_name assured_name,
                               c.expiry_date expiry_date,
                                  c.line_cd
                               || '-'
                               || c.subline_cd
                               || '-'
                               || c.iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (c.issue_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                               || '-'
                               || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                               a.prem_amt premium_amt,
                               DECODE (a.renewal_tag,
                                       'Y', a.prem_renew_amt,
                                       0
                                      ) premium_renew_amt,
                               DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                               DECODE (a.renewal_tag,
                                       'Y', c.line_cd
                                        || '-'
                                        || c.iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.renew_no, '09'))
                                      ) renewal_policy,
                               c.ref_pol_no
                          FROM giex_ren_ratio_dtl a,
                               gipi_polbasic c,
                               giis_assured b,
                               giis_line f,
                               giis_subline g,
                               giis_issource h
                         WHERE 1 = 1
                           AND h.iss_cd = a.iss_cd
                           AND f.line_cd = a.line_cd
                           AND g.subline_cd = a.subline_cd
                           AND g.line_cd = a.line_cd
                           AND b.assd_no = a.assd_no
                           AND c.policy_id = a.policy_id
                           AND a.YEAR IN (SELECT MAX (YEAR)
                                            FROM giex_ren_ratio_dtl
                                           WHERE user_id = p_user_id)
                           AND a.user_id = p_user_id
                           AND a.pack_policy_id = 0
               UNION ALL
               SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                               a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                               f.line_name line_name, g.subline_name subline_name,
                               TO_CHAR (a.intm_no, '09999999') intm_number,
                               a.assd_no assured_no, b.assd_name assured_name,
                               c.expiry_date expiry_date,
                                  c.line_cd
                               || '-'
                               || c.subline_cd
                               || '-'
                               || c.iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (c.issue_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                               || '-'
                               || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                               a.prem_amt premium_amt,
                               DECODE (a.renewal_tag,
                                       'Y', a.prem_renew_amt,
                                       0
                                      ) premium_renew_amt,
                               DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                               DECODE (a.renewal_tag,
                                       'Y', c.line_cd
                                        || '-'
                                        || c.iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.renew_no, '09'))
                                      ) renewal_policy,
                               c.ref_pol_no
                          FROM giex_ren_ratio_dtl a,
                               gipi_pack_polbasic c,
                               giis_assured b,
                               giis_line f,
                               giis_subline g,
                               giis_issource h
                         WHERE 1 = 1
                           AND h.iss_cd = a.iss_cd
                           AND f.line_cd = a.line_cd
                           AND g.subline_cd = a.subline_cd
                           AND g.line_cd = a.line_cd
                           AND b.assd_no = a.assd_no
                           AND c.pack_policy_id = a.policy_id
                           AND a.YEAR IN (SELECT MAX (YEAR)
                                            FROM giex_ren_ratio_dtl
                                           WHERE user_id = p_user_id)
                           AND a.user_id = p_user_id
                           AND a.pack_policy_id > 0))
      LOOP
        v_lov.line_cd := a.line_cd;
        v_lov.line_name := a.line_name;
        PIPE ROW(v_lov);
      END LOOP;                  
    END;
    
    FUNCTION get_bus_con_details_iss_lov(
      p_user_id            GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN bus_con_lov_tab PIPELINED AS
        v_lov   bus_con_lov_type;
    BEGIN
      FOR a IN (SELECT DISTINCT iss_cd,
                       iss_name
                  FROM (SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                               a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                               f.line_name line_name, g.subline_name subline_name,
                               TO_CHAR (a.intm_no, '09999999') intm_number,
                               a.assd_no assured_no, b.assd_name assured_name,
                               c.expiry_date expiry_date,
                                  c.line_cd
                               || '-'
                               || c.subline_cd
                               || '-'
                               || c.iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (c.issue_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                               || '-'
                               || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                               a.prem_amt premium_amt,
                               DECODE (a.renewal_tag,
                                       'Y', a.prem_renew_amt,
                                       0
                                      ) premium_renew_amt,
                               DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                               DECODE (a.renewal_tag,
                                       'Y', c.line_cd
                                        || '-'
                                        || c.iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.renew_no, '09'))
                                      ) renewal_policy,
                               c.ref_pol_no
                          FROM giex_ren_ratio_dtl a,
                               gipi_polbasic c,
                               giis_assured b,
                               giis_line f,
                               giis_subline g,
                               giis_issource h
                         WHERE 1 = 1
                           AND h.iss_cd = a.iss_cd
                           AND f.line_cd = a.line_cd
                           AND g.subline_cd = a.subline_cd
                           AND g.line_cd = a.line_cd
                           AND b.assd_no = a.assd_no
                           AND c.policy_id = a.policy_id
                           AND a.YEAR IN (SELECT MAX (YEAR)
                                            FROM giex_ren_ratio_dtl
                                           WHERE user_id = p_user_id)
                           AND a.user_id = p_user_id
                           AND a.pack_policy_id = 0
               UNION ALL
               SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                               a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                               f.line_name line_name, g.subline_name subline_name,
                               TO_CHAR (a.intm_no, '09999999') intm_number,
                               a.assd_no assured_no, b.assd_name assured_name,
                               c.expiry_date expiry_date,
                                  c.line_cd
                               || '-'
                               || c.subline_cd
                               || '-'
                               || c.iss_cd
                               || '-'
                               || LTRIM (TO_CHAR (c.issue_yy, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                               || '-'
                               || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                               a.prem_amt premium_amt,
                               DECODE (a.renewal_tag,
                                       'Y', a.prem_renew_amt,
                                       0
                                      ) premium_renew_amt,
                               DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                               DECODE (a.renewal_tag,
                                       'Y', c.line_cd
                                        || '-'
                                        || c.iss_cd
                                        || '-'
                                        || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                                        || '-'
                                        || LTRIM (TO_CHAR (c.renew_no, '09'))
                                      ) renewal_policy,
                               c.ref_pol_no
                          FROM giex_ren_ratio_dtl a,
                               gipi_pack_polbasic c,
                               giis_assured b,
                               giis_line f,
                               giis_subline g,
                               giis_issource h
                         WHERE 1 = 1
                           AND h.iss_cd = a.iss_cd
                           AND f.line_cd = a.line_cd
                           AND g.subline_cd = a.subline_cd
                           AND g.line_cd = a.line_cd
                           AND b.assd_no = a.assd_no
                           AND c.pack_policy_id = a.policy_id
                           AND a.YEAR IN (SELECT MAX (YEAR)
                                            FROM giex_ren_ratio_dtl
                                           WHERE user_id = p_user_id)
                           AND a.user_id = p_user_id
                           AND a.pack_policy_id > 0))
      LOOP
        v_lov.iss_cd := a.iss_cd;
        v_lov.iss_name := a.iss_name;
        PIPE ROW(v_lov);
      END LOOP;
    END;
    
    FUNCTION populate_giexr111_main (
        p_line_cd           GIEX_REN_RATIO.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO.iss_cd%TYPE,
        p_user_id           GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN giexr111_main_tab PIPELINED AS
        v_main              giexr111_main_type;
        v_pct_differ        NUMBER := 0;
        v_min_year_pct      NUMBER := 0;
        v_max_year_pct      NUMBER := 0;
        v_min_year          NUMBER := 0;
        v_max_year          NUMBER := 0;
        v_grand_nop         NUMBER := 0;
    BEGIN
        FOR i IN (SELECT SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)) pol_premium,
                         SUM(DECODE(a.user_id,p_user_id,a.nop,0)) no_of_policy,
                         a.line_cd line_cd,
                         a.subline_cd subline_cd,
                         a.iss_cd iss_cd,
                         a.year year,
                         SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_renew_amt,0),0)) renew_prem,
                         SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_new_amt,0),0)) new_prem,
                         c.line_name line_name,
                         SUM(nop) sum_nop,
                         SUM(nnp) sum_nnp,
                         SUM(nrp) sum_nrp,
                         SUM(nop)-SUM(nrp) unrenewed,
                         d.subline_name subline_name,
                         e.iss_name iss_name,
                         NVL((SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_renew_amt,0),0))/DECODE(SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)),0,NULL,SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0))))*100,0) pct_differ,
                         NVL((SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0))-(SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0))-SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_renew_amt,0),0))))/DECODE(SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)),0,NULL,SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)))*100,0) pct_differ_unrenewed,
                         SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0))-SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_renew_amt,0),0)) unrenewed_prem
                    FROM GIEX_REN_RATIO a,
                         GIIS_LINE c, 
                         GIIS_SUBLINE d,
                         GIIS_ISSOURCE e
                   WHERE 1 = 1
                     AND a.line_cd     = c.line_cd
                     AND a.line_cd    = d.line_cd
                     AND a.subline_cd = d.subline_cd
                     AND a.iss_cd     = e.iss_cd
                     AND a.iss_cd     = NVL(p_iss_cd,a.iss_cd)
                     AND a.line_cd       = NVL(p_line_cd,a.line_cd)
                     AND a.user_id     = p_user_id
                     AND a.nrp        = 0
                   GROUP BY a.line_cd,a.subline_cd,a.iss_cd,a.YEAR,c.line_name,
                         d.subline_name,e.iss_name)
        LOOP
            v_pct_differ := 0;
            FOR a IN (SELECT sum(prem_renew_amt) sum_ren_prem,
       					     sum(prem_amt) sum_prem,
                             sum(prem_amt)-sum(prem_renew_amt) sum_unren_prem,
                             (SUM(DECODE(user_id,p_user_id,prem_amt,0))-(SUM(DECODE(user_id,p_user_id,prem_amt,0))-SUM(DECODE(user_id,p_user_id,prem_renew_amt,0))))/DECODE(SUM(DECODE(user_id,p_user_id, prem_amt,0)),0,NULL,SUM(DECODE(user_id,p_user_id, prem_amt,0))) unren_prem_pct_differ
                        FROM GIEX_REN_RATIO
                       WHERE 1 = 1
                         AND iss_cd = NVL(i.iss_cd, iss_cd)
                         AND line_cd = NVL(i.line_cd, line_cd)
                         AND subline_cd = NVL(i.subline_cd, subline_cd)
                         AND month <> 0
                       GROUP BY year
                       ORDER BY year desc)
            LOOP
                v_pct_differ := NVL(a.unren_prem_pct_differ,0) - v_pct_differ;
            END LOOP;              
            
            FOR v_year IN (SELECT MIN(year) min_year,
                                  MAX(year) max_year
                             FROM GIEX_REN_RATIO
                            WHERE user_id = p_user_id)
            LOOP
                v_min_year := v_year.min_year;
                v_max_year := v_year.max_year;
            END LOOP;
            
            -- FOR PCT_INC_DEC LINE TOTAL
            BEGIN
                v_min_year_pct := 0;
                v_max_year_pct := 0;
                
              SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                INTO v_min_year_pct
                FROM GIEX_REN_RATIO
               WHERE user_id = p_user_id
                 AND year = v_min_year
                 AND line_cd = nvl(i.line_cd,line_cd)
                 AND iss_cd  = nvl(i.iss_cd,iss_cd)
               GROUP BY iss_cd,line_cd;
                 
              SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                INTO v_max_year_pct
                FROM GIEX_REN_RATIO
               WHERE user_id = p_user_id
                 AND year = v_max_year
                 AND line_cd = nvl(i.line_cd,line_cd)
                 AND iss_cd  = nvl(i.iss_cd,iss_cd)
               GROUP BY iss_cd,line_cd;
            END;
            v_main.line_pct_inc_dec := (v_max_year_pct-v_min_year_pct);
            
            -- FOR PCT_INC_DEC ISSUE TOTAL
            BEGIN
                v_min_year_pct := 0;
                v_max_year_pct := 0;
            
                IF p_line_cd IS NULL THEN
                    SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                      INTO v_min_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year 	 = v_min_year
                       AND iss_cd  = i.iss_cd		     
                     GROUP BY iss_cd;
        		     
                    SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                      INTO v_max_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year    = v_max_year		     
                       AND iss_cd  = i.iss_cd		     
                     GROUP BY iss_cd;   
                ELSE
                    SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                      INTO v_min_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year  = v_min_year
                       AND iss_cd  = i.iss_cd
                       AND line_cd = i.line_cd
                     GROUP BY iss_cd;
        		     
                   SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                     INTO v_max_year_pct
                     FROM GIEX_REN_RATIO
                    WHERE user_id = p_user_id
                      AND year    = v_max_year
                      AND iss_cd  = i.iss_cd 
                      AND line_cd = i.line_cd    
                    GROUP BY iss_cd;   
                END IF;
            END;
            v_main.iss_pct_inc_dec := (v_max_year_pct-v_min_year_pct);
            
            -- FOR PCT_INC_DEC GRAND TOTAL
            BEGIN
                v_min_year_pct := 0;
                v_max_year_pct := 0;
                
                SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                  INTO v_min_year_pct
                  FROM GIEX_REN_RATIO
                 WHERE user_id = p_user_id
                   AND year 	 = v_min_year
                   AND iss_cd  = NVL(p_iss_cd, iss_cd)
                   AND line_cd = NVL(p_line_cd, line_cd); 
                    
                SELECT nvl((SUM(NVL(prem_amt,0))-(SUM(NVL(prem_amt,0))-SUM(NVL(prem_renew_amt,0))))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                  INTO v_max_year_pct
                  FROM GIEX_REN_RATIO
                 WHERE user_id = p_user_id
                   AND year    = v_max_year		     
                   AND iss_cd  = NVL(p_iss_cd, iss_cd)
                   AND line_cd = NVL(p_line_cd, line_cd);
            END;
            v_main.grand_pct_inc_dec := (v_max_year_pct-v_min_year_pct);
            
            v_main.pol_premium := i.pol_premium;
            v_main.no_of_policy := i.no_of_policy;
            v_main.line_cd := i.line_cd;
            v_main.subline_cd := i.subline_cd;
            v_main.iss_cd := i.iss_cd;
            v_main.year := i.year;
            v_main.renew_prem := i.renew_prem;
            v_main.new_prem := i.new_prem;
            v_main.line_name := i.line_name;
            v_main.sum_nop := i.sum_nop;
            v_main.sum_nnp := i.sum_nnp;
            v_main.sum_nrp := i.sum_nrp;
            v_main.unrenewed := i.unrenewed;
            v_main.subline_name := i.subline_name;
            v_main.iss_name := i.iss_name;
            v_main.pct_differ := i.pct_differ;
            v_main.pct_differ_unrenewed := i.pct_differ_unrenewed;
            v_main.unrenewed_prem := i.unrenewed_prem;
            v_main.pct_inc_dec := v_pct_differ;   
            PIPE ROW(v_main);
        END LOOP;
    END;
    
    FUNCTION populate_giexr111_recap (
        p_line_cd           GIEX_REN_RATIO.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO.iss_cd%TYPE,
        p_user_id           GIEX_REN_RATIO.user_id%TYPE
    )
      RETURN giexr111_recap_tab PIPELINED AS
        v_recap             giexr111_recap_type;
        v_sum_prem_amt      NUMBER;
        v_sum_unren_premium NUMBER;
        v_min_year_pct      NUMBER;
        v_max_year_pct      NUMBER;
    BEGIN
        FOR i IN (SELECT MAX(year) max_year,
                         MIN(year) min_year
                    FROM GIEX_REN_RATIO
                   WHERE user_id = p_user_id)
        LOOP
            FOR a IN (SELECT SUM(NoP) sum_nop,
                             SUM(prem_amt) sum_prem_amt,
                             SUM(nop)-SUM(nrp) sum_unren,
                             (SUM(prem_amt)-SUM(prem_renew_amt)) sum_unren_premium,
                             iss_cd
                        FROM GIEX_REN_RATIO
                       WHERE 1 = 1 
                         AND user_id = p_user_id
                         AND line_cd = NVL(p_line_cd,line_cd)
                         AND iss_cd  = NVL(p_iss_cd,iss_cd)      
                         AND year = i.max_year
                       GROUP BY iss_cd)
            LOOP
                BEGIN
                    SELECT iss_name
                      INTO v_recap.iss_name
                      FROM GIIS_ISSOURCE
                     WHERE iss_cd = a.iss_cd;
                END;
                v_recap.max_year := i.max_year;
                v_recap.grand_nop := a.sum_nop;
                v_recap.grand_pol_premium := a.sum_prem_amt;
                v_recap.grand_unrenewed := a.sum_unren;
                v_recap.grand_unrenewed_prem := a.sum_unren_premium;
                IF a.sum_prem_amt = 0 THEN
                    v_recap.grand_pct_differ := 0;
                ELSE
                    v_recap.grand_pct_differ := ((a.sum_prem_amt-a.sum_unren_premium)/a.sum_prem_amt);
                END IF;
                
                BEGIN
                    SELECT SUM(prem_amt) sum_prem_amt,
                           (SUM(prem_amt)-SUM(prem_renew_amt)) sum_unren_premium
                      INTO v_sum_prem_amt,
                           v_sum_unren_premium
                      FROM GIEX_REN_RATIO
                     WHERE 1 = 1 
                       AND user_id = p_user_id
                       AND line_cd = NVL(p_line_cd,line_cd)
                       AND iss_cd  = NVL(p_iss_cd,iss_cd)      
                       AND year = i.max_year;
                    IF v_sum_prem_amt = 0 THEN
                        v_recap.total_pct_differ := 0;
                    ELSE
                        v_recap.total_pct_differ := ((v_sum_prem_amt-v_sum_unren_premium)/v_sum_prem_amt);
                    END IF;
                END;
                
                BEGIN
                    v_min_year_pct := 0;
                    v_max_year_pct := 0;
                
                    SELECT NVL((SUM(NVL(PREM_AMT,0))-(SUM(NVL(PREM_AMT,0))-SUM(NVL(PREM_RENEW_AMT,0))))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0)
                      INTO v_min_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year 	 = i.min_year
                       AND iss_cd  = a.iss_cd
                       AND iss_cd  = NVL(p_iss_cd,iss_cd)
                       AND line_cd = NVL(p_line_cd,line_cd)		     
                     GROUP BY iss_cd;
        		     
                    SELECT NVL((SUM(NVL(PREM_AMT,0))-(SUM(NVL(PREM_AMT,0))-SUM(NVL(PREM_RENEW_AMT,0))))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0)
                      INTO v_max_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year    = i.max_year		     
                       AND iss_cd  = a.iss_cd
                       AND iss_cd  = NVL(p_iss_cd,iss_cd)
                       AND line_cd = NVL(p_line_cd,line_cd)		     		     
                     GROUP BY iss_cd;
                END;
                v_recap.grand_pct_inc_dec := v_max_year_pct-v_min_year_pct;
                BEGIN
                    v_min_year_pct := 0;
                    v_max_year_pct := 0;
                    
                    SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                      INTO v_min_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year = i.min_year
                       AND line_cd = NVL(p_line_cd,line_cd)
                       AND iss_cd  = NVL(p_iss_cd,iss_cd);     
                     
                    SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0)
                      INTO v_max_year_pct
                      FROM GIEX_REN_RATIO
                     WHERE user_id = p_user_id
                       AND year = i.max_year
                       AND line_cd = NVL(p_line_cd,line_cd)
                       AND iss_cd  = NVL(p_iss_cd,iss_cd);
                END;
                v_recap.total_pct_inc_dec := (v_max_year_pct-v_min_year_pct);
                PIPE ROW(v_recap);
            END LOOP;
        END LOOP;
    END;
    
    FUNCTION populate_giexr112_header
      RETURN giexr112_header_tab PIPELINED AS
        v_header            giexr112_header_type;
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO v_header.company_name
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_NAME';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_header.company_name := NULL;
        END;
        
        BEGIN
            SELECT param_value_v
              INTO v_header.company_address
              FROM GIIS_PARAMETERS
             WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_header.company_address := NULL;
        END;
        
        PIPE ROW(v_header);
    END;
    
    FUNCTION populate_giexr112_main (
        p_line_cd           GIEX_REN_RATIO_DTL.line_cd%TYPE,
        p_iss_cd            GIEX_REN_RATIO_DTL.iss_cd%TYPE,
        p_subline_cd        GIEX_REN_RATIO_DTL.subline_cd%TYPE,
        p_policy_id         GIEX_REN_RATIO_DTL.policy_id%TYPE,
        p_assd_no           GIEX_REN_RATIO_DTL.assd_no%TYPE,
        p_intm_no           GIEX_REN_RATIO_DTL.intm_no%TYPE,
        p_starting_date     DATE,
        p_ending_date       DATE,
        p_user_id           GIEX_REN_RATIO_DTL.user_id%TYPE
    )
      RETURN giexr112_main_tab PIPELINED AS
        v_main              giexr112_main_type;
        v_due               NUMBER := 0;
        v_bal               VARCHAR2(1);
        v_claim             VARCHAR2(1);
        v_intm_no           VARCHAR2(2000);
        v_intm_name         VARCHAR2(5000); -- Added by Jerome Bautista 09.08.2015 SR 17460
    BEGIN
        FOR i IN (SELECT DISTINCT a.policy_id,
                         a.pack_policy_id,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd iss_cd2,
                         a.line_cd line_cd2,
                         a.subline_cd subline_cd2,
                         b.issue_yy,
                         b.pol_seq_no,
                         b.renew_no,
                         a.line_cd||'-'||
                         RTRIM(a.subline_cd)||'-'||
                         RTRIM(a.iss_cd)||'-'||
                         LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                         LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||
                         LTRIM(TO_CHAR(b.renew_no,'09')) policy_no,
                         b.tsi_amt,
                         b.prem_amt,
                         c.tax_amt,
                         b.expiry_date,
                         d.line_name,
                         e.subline_name ,
                         get_assd_name(b.assd_no) assd_name
                    FROM GIEX_REN_RATIO_DTL a,
                         GIPI_POLBASIC b,
                         GIPI_INVOICE c,
                         GIIS_LINE d,
                         GIIS_SUBLINE e
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id = c.policy_id 
                     AND a.line_cd = d.line_cd
                     AND a.subline_cd = e.subline_cd   
                     AND a.renewal_tag = 'N'             
                     AND a.policy_id = NVL(p_policy_id, a.policy_id)
                     AND a.assd_no = NVL(p_assd_no, a.assd_no)
                     AND NVL(a.intm_no,0) = NVL(p_intm_no,NVL(a.intm_no,0)) 
                     AND UPPER(a.iss_cd) = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
                     AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
                     AND UPPER(a.line_cd) = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
                     AND NVL(a.pack_policy_id,0) = 0
                     AND a.user_id = p_user_id
                     AND e.line_cd =  b.line_cd
                     AND TRUNC(b.expiry_date) <= TRUNC(NVL(p_ending_date, NVL(p_starting_date, b.expiry_date)))
                     AND TRUNC(b.expiry_date) >= DECODE(p_ending_date, NULL, TRUNC(b.expiry_date), TRUNC(NVL(p_starting_date, b.expiry_date)))
                   UNION ALL
                  SELECT DISTINCT a.policy_id,
                         a.pack_policy_id,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd iss_cd2,
                         a.line_cd line_cd2,
                         a.subline_cd subline_cd2,
                         b.issue_yy,
                         b.pol_seq_no,
                         b.renew_no,
                         a.line_cd||'-'||
                         RTRIM(a.subline_cd)||'-'||
                         RTRIM(a.iss_cd)||'-'||
                         LTRIM(TO_CHAR(b.issue_yy,'09'))||'-'||
                         LTRIM(TO_CHAR(b.pol_seq_no,'0999999'))||'-'||
                         LTRIM(TO_CHAR(b.renew_no,'09')) policy_no,
                         b.tsi_amt,
                         b.prem_amt,
                         c.tax_amt,
                         b.expiry_date,
                         d.line_name,
                         e.subline_name,
                         get_assd_name(b.assd_no) assd_name
                    FROM GIEX_REN_RATIO_DTL a,
                         GIPI_PACK_POLBASIC b,
                         GIPI_INVOICE c,
                         GIIS_LINE d,
                         GIIS_SUBLINE e
                 WHERE a.pack_policy_id       = b.pack_policy_id
                   AND a.policy_id               = c.policy_id 
                   AND a.line_cd               = d.line_cd
                   AND a.subline_cd           = e.subline_cd   
                   AND a.renewal_tag          = 'N'             
                   AND a.pack_policy_id    = NVL(p_policy_id, a.pack_policy_id)
                   AND a.assd_no               = NVL(p_assd_no, a.assd_no)
                   AND NVL(a.intm_no,0)       = NVL(p_intm_no,NVL(a.intm_no,0)) 
                   AND UPPER(a.iss_cd)     = NVL(UPPER(p_iss_cd),UPPER(a.iss_cd))
                   AND UPPER(a.subline_cd) = NVL(UPPER(p_subline_cd),UPPER(a.subline_cd))
                   AND UPPER(a.line_cd)    = NVL(UPPER(p_line_cd),UPPER(a.line_cd))
                   AND ((a.pack_policy_id = a.policy_id AND a.pack_policy_id > 0) OR a.pack_policy_id = 0)
                   AND a.user_id = p_user_id
                   AND TRUNC(b.expiry_date) <=TRUNC(NVL(p_ending_date, NVL(p_starting_date, b.expiry_date)))
                   AND TRUNC(b.expiry_date) >= DECODE(p_ending_date, NULL, TRUNC(b.expiry_date), TRUNC(NVL(p_starting_date, b.expiry_date)))
                 ORDER BY expiry_date, policy_no)
        LOOP
            BEGIN
                SELECT iss_name
                  INTO v_main.iss_name
                  FROM GIIS_ISSOURCE
                 WHERE iss_cd  = i.iss_cd;
            END;
        
            BEGIN
                IF NVL(i.pack_policy_id, 0) > 0 THEN
                    FOR d IN(SELECT SUM(c.balance_amt_due) due
                               FROM GIPI_POLBASIC a,
                                    GIPI_INVOICE b,
                                    GIAC_AGING_SOA_DETAILS c,
                                    GIEX_REN_RATIO_DTL d,
                                    GIPI_PACK_POLBASIC x
                              WHERE a.pack_policy_id = x.pack_policy_id
                                AND a.line_cd     = i.line_cd
                                AND a.subline_cd  = i.subline_cd
                                AND a.iss_cd      = i.iss_cd
                                AND a.issue_yy    = i.issue_yy
                                AND a.pol_seq_no  = i.pol_seq_no
                                AND a.renew_no    = i.renew_no
                                AND a.pol_flag IN ('1','2','3')
                                AND a.policy_id = b.policy_id
                                AND a.policy_id = d.policy_id
                                AND b.iss_cd = c.iss_cd
                                AND b.prem_seq_no = c.prem_seq_no)
                    LOOP
                        v_due := d.due;
                    END LOOP;
                ELSE    
                    FOR d IN(SELECT SUM(c.balance_amt_due) due
                               FROM GIPI_POLBASIC a,
                                    GIPI_INVOICE b,
                                    GIAC_AGING_SOA_DETAILS c,
                                    GIEX_REN_RATIO_DTL d
                              WHERE a.line_cd     = i.line_cd
                                AND a.subline_cd  = i.subline_cd
                                AND a.iss_cd      = i.iss_cd
                                AND a.issue_yy    = i.issue_yy
                                AND a.pol_seq_no  = i.pol_seq_no
                                AND a.renew_no    = i.renew_no
                                AND a.pol_flag IN ('1','2','3')
                                AND a.policy_id = b.policy_id
                                AND a.policy_id = d.policy_id
                                AND b.iss_cd = c.iss_cd
                                AND b.prem_seq_no = c.prem_seq_no)
                    LOOP
                        v_due := d.due;
                    END LOOP;    
                END IF;
                
                IF v_due <> 0 THEN
                    v_bal := '*';
                ELSE
                    v_bal := NULL;
                END IF;
            END;
        
            v_claim := NULL;
            IF NVL(i.pack_policy_id, 0) <> 0 THEN
                FOR a3 IN (SELECT '1'
	                         FROM GICL_CLAIMS x
	                        WHERE clm_stat_cd NOT IN ('CC','WD','DN')
	                          AND EXISTS (SELECT '1' 
	                                        FROM gipi_polbasic a, gipi_pack_polbasic b
	                                       WHERE a.pack_policy_id = b.pack_policy_id
	                                         AND b.line_cd     = i.line_cd
	                                         AND b.subline_cd  = i.subline_cd
	                                         AND b.iss_cd      = i.iss_cd
	                                         AND b.issue_yy    = i.issue_yy
	                                         AND b.pol_seq_no  = i.pol_seq_no
	                                         AND b.renew_no    = i.renew_no
	                                         AND x.line_cd     = a.line_cd
	                                         AND x.subline_cd  = a.subline_cd
	                                         AND x.pol_iss_cd  = a.iss_cd
	                                         AND x.issue_yy    = a.issue_yy
	                                         AND x.pol_seq_no  = a.pol_seq_no
	                                         AND x.renew_no    = a.renew_no))
                 LOOP
                     v_claim := '*';
                     EXIT;
                 END LOOP;
            ELSE
                FOR a3 IN (SELECT '1'
	                         FROM GICL_CLAIMS
	                        WHERE line_cd     = i.line_cd
	                          AND subline_cd  = i.subline_cd
	                          AND pol_iss_cd  = i.iss_cd
	                          AND issue_yy    = i.issue_yy
	                          AND pol_seq_no  = i.pol_seq_no
	                          AND renew_no    = i.renew_no
	                          AND clm_stat_cd NOT IN ('CC','WD','DN'))
	            LOOP
                    v_claim := '*';
                    EXIT;
	            END LOOP;
            END IF;
            
            v_main.ref_pol_no := NULL;
            FOR c IN(SELECT a.ref_pol_no
                       FROM GIPI_POLBASIC a
                      WHERE a.policy_id = i.policy_id 
                        AND a.pack_policy_id = NVL(i.pack_policy_id,0))
            LOOP
                v_main.ref_pol_no := c.ref_pol_no;
                EXIT;
            END LOOP;
            
            FOR c IN(SELECT a.ref_pol_no
                       FROM GIPI_PACK_POLBASIC a
                      WHERE a.pack_policy_id = i.pack_policy_id)
            LOOP
                v_main.ref_pol_no := c.ref_pol_no;
                EXIT;
            END LOOP;
            
            v_intm_no := NULL;
            IF NVL(i.pack_policy_id,0) = 0 THEN
                FOR c IN(SELECT DISTINCT a.intm_no, TO_CHAR(a.intm_no)||'/'||ref_intm_cd v_intm_no, a.intm_name -- intm_name Added by Jerome Bautista 09.08.2015 SR 17460
                           FROM GIIS_INTERMEDIARY a,
                                GIPI_POLBASIC b,
                                GIPI_INVOICE c,
                                GIPI_COMM_INVOICE d
                          WHERE b.policy_id = c.policy_id
                            AND c.iss_cd = d.iss_cd
                            AND c.prem_seq_no = d.prem_seq_no
                            AND c.policy_id = d.policy_id
                            AND b.line_cd = i.line_cd
                            AND b.subline_cd = i.subline_cd
                            AND b.iss_cd = i.iss_cd
                            AND b.issue_yy = i.issue_yy
                            AND b.pol_seq_no = i.pol_seq_no
                            AND b.renew_no = i.renew_no
                            AND a.intm_no = d.intrmdry_intm_no
                          ORDER BY a.intm_no)
                LOOP
                    IF v_intm_no IS NULL THEN
                       v_intm_no := RTRIM(c.v_intm_no,'/');
                       v_intm_name := c.intm_name; -- Added by Jerome Bautista 09.08.2015 SR 17460
                    ELSE
                       v_intm_no := v_intm_no||', '||RTRIM(c.v_intm_no,'/');
                       v_intm_name := c.intm_name; -- Added by Jerome Bautista 09.08.2015 SR 17460
                    END IF;
                END LOOP;
            END IF;
            
            IF NVL(i.pack_policy_id,0) > 0 THEN		
                SELECT SUM(NVL(c.tax_amt,0))
                  INTO v_main.tax_amt 
                  FROM GIEX_REN_RATIO_DTL a,
                       GIPI_POLBASIC b,
                       GIPI_INVOICE c			   
                 WHERE a.policy_id = b.policy_id
                   AND a.policy_id = c.policy_id	   
                   AND a.renewal_tag = 'N'  	   	
                   AND a.pack_policy_id = i.pack_policy_id;
            ELSE
                v_main.tax_amt := NVL(i.tax_amt,0);
            END IF;
        
            v_main.policy_id := i.policy_id;
            v_main.pack_policy_id := i.pack_policy_id;
            v_main.iss_cd := i.iss_cd;
            v_main.line_cd := i.line_cd;
            v_main.subline_cd := i.subline_cd;
            v_main.iss_cd2 := i.iss_cd2;
            v_main.line_cd2 := i.line_cd2;
            v_main.subline_cd1 := i.subline_cd2;
            v_main.issue_yy := i.issue_yy;
            v_main.pol_seq_no := i.pol_seq_no;
            v_main.renew_no := i.renew_no;
            v_main.policy_no := i.policy_no;
            v_main.tsi_amt := i.tsi_amt;
            v_main.prem_amt := NVL(i.prem_amt,0);
            v_main.expiry_date := i.expiry_date;
            v_main.line_name := i.line_name;
            v_main.subline_name := i.subline_name;
            v_main.assd_name := i.assd_name;
            v_main.w_balance := v_bal;
            v_main.w_clm := v_claim;
            v_main.intm_no := v_intm_no;
            v_main.total_due := v_main.prem_amt + v_main.tax_amt;
            v_main.intm_name := v_intm_name; -- Added by Jerome Bautista 09.08.2015 SR 17460
            PIPE ROW(v_main);
        END LOOP;
    END;
    
/******************************************************************************
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/7/2012    Bonok            GIEXR109 FUNCTIONS
******************************************************************************/

   FUNCTION populate_giexr109_main(
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE,
      p_subline_cd      giex_ren_ratio.subline_cd%TYPE,
      p_user_id         giex_ren_ratio.user_id%TYPE
   )
     RETURN giexr109_main_tab PIPELINED AS
      v_details         giexr109_main_type;
   BEGIN
      FOR i IN (SELECT a.line_name, a.line_cd, c.iss_cd, b.subline_cd,
                       b.subline_name, d.year, SUM(d.nop) no_of_policy, 
                       SUM(d.nrp) no_of_renewed,
                       NVL(SUM(d.nnp),0)    no_of_new, c.iss_name,
                       NVL(SUM(d.nrp)/DECODE(SUM(d.nop),0,NULL,SUM(d.nop)),0) pct_renew
                  FROM giis_line a,
                       giis_subline b,
                       giis_issource c,
                       giex_ren_ratio d
                 WHERE d.line_cd    = a.line_cd
                   AND d.line_cd    = b.line_cd
                   AND d.subline_cd = b.subline_cd
                   AND d.iss_cd     = c.iss_cd
                   AND d.iss_cd     = NVL(p_iss_cd,d.iss_cd)
                   AND d.line_cd    = NVL(p_line_cd,d.line_cd)
                   AND d.subline_cd = NVL(p_subline_cd,d.subline_cd)
                   AND d.user_id    = p_user_id
                 GROUP BY a.line_name, a.line_cd, d.year, b.subline_name,
                          c.iss_name, c.iss_cd, b.subline_cd)
      LOOP

            v_details.line_name     := i.line_name;
            v_details.line_cd       := i.line_cd;
            v_details.iss_cd        := i.iss_cd;
            v_details.subline_cd    := i.subline_cd;
            v_details.subline_name  := i.subline_name;
            v_details.year          := i.year;
            v_details.no_of_policy  := i.no_of_policy;
            v_details.no_of_renewed := i.no_of_renewed;
            v_details.no_of_new     := i.no_of_new;
            v_details.iss_name      := i.iss_name;
            v_details.pct_renew     := i.pct_renew;

           
            FOR j IN (SELECT 
            NVL(SUM(nop),0) sum_nop,
	                         NVL(SUM(nrp),0) sum_nrp,
	                         NVL(SUM(nnp),0) sum_nnp,
                             YEAR,iss_cd
                        FROM giex_ren_ratio
                       WHERE 1=1
                         AND user_id= p_user_id
                         AND line_cd = i.line_cd
                         AND iss_cd = i.iss_cd
                         AND subline_cd = i. subline_cd
                         AND year = i.year
                       GROUP BY YEAR,iss_cd, line_cd, subline_cd)
  
            LOOP
                v_details.sum_nop   := j.sum_nop;
                v_details.sum_nrp   := j.sum_nrp;
                v_details.sum_nnp   := j.sum_nnp;
               
            END LOOP; 
            
            FOR k IN (SELECT NVL(SUM(nop),0) g_sum_nop,
	                         NVL(SUM(nrp),0) g_sum_nrp,
	                         NVL(SUM(nnp),0) g_sum_nnp,
          	                 YEAR
                        FROM giex_ren_ratio
                       WHERE 1=1 
                         AND line_cd = NVL(p_line_cd,line_cd)
                         AND iss_cd = NVL(p_iss_cd,iss_cd)
                         AND subline_cd = NVL(p_subline_cd,subline_cd)
                         AND user_id= p_user_id
                       GROUP BY YEAR)                       
  
            LOOP
                v_details.g_sum_nop   := k.g_sum_nop;
                v_details.g_sum_nrp   := k.g_sum_nrp;
                v_details.g_sum_nnp   := k.g_sum_nnp;
            END LOOP;
            
            FOR l IN(SELECT NVL(SUM(DECODE(user_id,p_user_id, NRP,0))/DECODE(SUM(DECODE(user_id,p_user_id, NOP,0)),0,NULL,SUM(DECODE(user_id,p_user_id, NOP,0))),0) pct_diff --modified by A.R.C. 12.20.2004
                       FROM giex_ren_ratio
                      WHERE 1 = 1
                        AND iss_cd = i.iss_cd
                        AND subline_cd = i.subline_cd
                        AND line_cd = i.line_cd
                        AND month <> 0
                      GROUP BY YEAR,subline_cd
                      ORDER BY year DESC) --SR5497 Order changed to DESC jmm
     
            LOOP
                v_details.pct_diff    := l.pct_diff;
                --SR5497 Added If-ElsIf Statement jmm
                IF v_details.pct_diff = v_details.pct_renew THEN
                      v_details.pct_renew_diff := v_details.pct_renew;
                ELSE
                      v_details.pct_renew_diff    :=  v_details.pct_renew - v_details.pct_diff ;
                END IF;
            END LOOP;
            
            
            
            FOR m IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_lcd_pd --line cd pct diff - min year
                       FROM giex_ren_ratio
                      WHERE user_id = p_user_id
                        AND line_cd = i.line_cd
                        AND iss_cd  = i.iss_cd
                        AND year IN (SELECT MIN(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = p_user_id)
                                      GROUP BY iss_cd,line_cd)   
            LOOP
               v_details.min_lcd_pd := m.min_lcd_pd;
            END LOOP;
            
            FOR n IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_lcd_pd --line cd pct diff - max year
                       FROM giex_ren_ratio
                      WHERE user_id = p_user_id
                        AND line_cd = i.line_cd
                        AND iss_cd  = i.iss_cd
                        AND year IN (SELECT MAX(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = p_user_id)
                      GROUP BY iss_cd,line_cd)
                      
            LOOP
               v_details.max_lcd_pd := n.max_lcd_pd;
            END LOOP;
            
            v_details.lcd_pct_diff := v_details.max_lcd_pd - v_details.min_lcd_pd;
            
            FOR o IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_isd_pd --iss cd pct diff - min year
		               FROM giex_ren_ratio
		              WHERE user_id = p_user_id
		                AND iss_cd  = NVL(p_iss_cd, iss_cd)
                        AND line_cd = NVL(p_line_cd, line_cd)
                        AND year IN (SELECT MIN(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = p_user_id)	     
		              GROUP BY iss_cd)
            
            LOOP
               v_details.min_isd_pd := o.min_isd_pd;
            END LOOP;
            
            FOR p IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_isd_pd --iss cd pct diff - max year
		               FROM giex_ren_ratio
		              WHERE user_id = p_user_id
		                AND iss_cd  = NVL(p_iss_cd, iss_cd)
                        AND line_cd = NVL(p_line_cd, line_cd)
                        AND year IN (SELECT MAX(year) 
                                       FROM giex_ren_ratio
             			              WHERE user_id = p_user_id)	     
		              GROUP BY iss_cd)
            
            LOOP
               v_details.max_isd_pd := p.max_isd_pd;
            END LOOP;
            
            v_details.icd_pct_diff  := v_details.max_isd_pd - v_details.min_isd_pd;
            
            FOR q IN(SELECT NVL(SUM(nop),0) sum_nop,
	                        NVL(SUM(nrp),0) sum_nrp,
                            YEAR, iss_cd, line_cd
                       FROM giex_ren_ratio
                      WHERE 1=1  
                        AND user_id= p_user_id
                        AND line_cd = NVL(p_line_cd,line_cd)
                        AND iss_cd = NVL(p_iss_cd,iss_cd)
                        AND subline_cd = NVL(p_subline_cd, subline_cd)
                        AND year = i.year
                      GROUP BY YEAR,iss_cd, line_cd)
                      
            LOOP
               v_details.sum_nop        := q.sum_nop;
               v_details.sum_nrp        := q.sum_nrp;
                  
               IF v_details.sum_nop = 0 OR v_details.sum_nrp = 0 THEN
                  v_details.scd_pct_diff   := 0;
               ELSE
                  v_details.scd_pct_diff   := v_details.sum_nrp/v_details.sum_nop;
               END IF;
                 
            END LOOP; 
  
            FOR r IN(SELECT NVL(SUM(nop),0) sum_nop,
	                        NVL(SUM(nrp),0) sum_nrp,
                            YEAR, iss_cd
                       FROM giex_ren_ratio
                      WHERE 1=1  
                        AND user_id= p_user_id
                        AND iss_cd = NVL(p_iss_cd,iss_cd)
                        AND line_cd = NVL(p_line_cd,line_cd)
                        AND subline_cd = NVL(p_subline_cd,subline_cd)
                        AND year = i.year
                      GROUP BY YEAR,iss_cd)
                      
            LOOP
               v_details.sum_nop        := r.sum_nop;
               v_details.sum_nrp        := r.sum_nrp;
               IF v_details.sum_nop = 0 THEN
                  v_details.isd_pct_diff   := 0;
               ELSE
                  v_details.isd_pct_diff   := v_details.sum_nrp/v_details.sum_nop;
               END IF;
            END LOOP;
            PIPE ROW(v_details);
      END LOOP;
   END;
   
   FUNCTION populate_giexr109_header
   
   RETURN giexr109_header_tab PIPELINED AS
      v_co_details         giexr109_header_type;
   
   BEGIN
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_NAME')
         LOOP
            v_co_details.company_name := i.param_value_v;
         END LOOP;
      END;
      
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
         LOOP
            v_co_details.company_address := i.param_value_v;
         END LOOP;
      END;
        
      PIPE ROW(v_co_details);
   END; 
   
   FUNCTION populate_giexr109_recap (
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE,
      p_subline_cd      giex_ren_ratio.subline_cd%TYPE,
      p_user_id         giex_ren_ratio.user_id%TYPE
   )
     RETURN giexr109_recap_tab PIPELINED AS
      v_recap           giexr109_recap_type;
      
   BEGIN
      FOR i IN(SELECT SUM(a.nop) sum_nop, 
                      SUM(a.nnp) sum_nnp,
                      SUM(a.nrp) sum_nrp,
                      a.year, a.iss_cd, b.iss_name
                 FROM giex_ren_ratio a, giis_issource b
                WHERE 1 = 1 
                  AND a.user_id = p_user_id
                  AND a.iss_cd = b.iss_cd 
                  AND a.line_cd = NVL(p_line_cd,a.line_cd)
                  AND a.iss_cd  = NVL(p_iss_cd,a.iss_cd)
                  AND a.subline_cd = NVL(p_subline_cd,a.subline_cd)
                  AND year IN (SELECT MAX(year) 
                                 FROM giex_ren_ratio
             				    WHERE user_id = p_user_id)
                GROUP BY a.iss_cd, b.iss_name, a.year
                ORDER BY b.iss_name)
      LOOP
         v_recap.year       := i.year;
         v_recap.iss_cd     := i.iss_cd;
         v_recap.iss_name   := i.iss_name;
         v_recap.sum_nop    := i.sum_nop;
         v_recap.sum_nnp    := i.sum_nnp;
         v_recap.sum_nrp    := i.sum_nrp;   
         
         FOR j IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = p_user_id))        	     
         LOOP
            v_recap.min_year_pct := j.min_year_pct;
         END LOOP;    
         
         FOR k IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             			    	   WHERE user_id = p_user_id))		     		        
         LOOP
         v_recap.max_year_pct := k.max_year_pct;
         END LOOP;
         
         /****FOR GRAND TOTAL****/
         
         FOR l IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) g_min_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = p_user_id))        	     
         LOOP
            v_recap.g_min_year_pct := l.g_min_year_pct;
         END LOOP;    
         
         FOR m IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) g_max_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             				       WHERE user_id = p_user_id))		     		        
         LOOP
         v_recap.g_max_year_pct := m.g_max_year_pct;
         END LOOP;
         
         v_recap.g_sum_pct_renew := (v_recap.g_max_year_pct - v_recap.g_min_year_pct);   
         
         v_recap.sum_pct_renew := (v_recap.max_year_pct - v_recap.min_year_pct);
         
         PIPE ROW(v_recap);
      END LOOP;
   END;
   
   FUNCTION populate_giexr109_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_subline_cd      giex_ren_ratio.subline_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
      RETURN giexr109_grand_total_tab PIPELINED AS
         v_grand_total     giexr109_grand_total_type;
      
   BEGIN
      FOR i IN(SELECT NVL(SUM(nop),0) sum_nop,
                      NVL(SUM(nrp),0) sum_nrp,
                      NVL(SUM(nnp),0) sum_nnp,
                      YEAR
                 FROM giex_ren_ratio
                WHERE 1=1 
                  AND line_cd = NVL(p_line_cd,line_cd)
                  AND iss_cd = NVL(p_iss_cd,iss_cd)
                  AND subline_cd = NVL(p_subline_cd,subline_cd)
                  AND user_id= p_user_id
                GROUP BY YEAR)
      LOOP
         v_grand_total.sum_nop  := i.sum_nop;
         v_grand_total.sum_nrp  := i.sum_nrp;
         v_grand_total.sum_nnp  := i.sum_nnp;
         v_grand_total.year     := i.year;
         
         IF v_grand_total.sum_nrp = 0 THEN
		    v_grand_total.grand_pct_renew := 0;
	     ELSE
		    v_grand_total.grand_pct_renew := v_grand_total.sum_nrp/v_grand_total.sum_nop;
	     END IF;
         
         FOR j IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) min_year_pct
                    FROM giex_ren_ratio
                   WHERE user_id = p_user_id
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND iss_cd  = NVL(p_iss_cd,iss_cd)
                     AND year IN (SELECT MIN(year) 
                            FROM giex_ren_ratio
             			   WHERE user_id = p_user_id))
         LOOP
            v_grand_total.min_year_pct  := j.min_year_pct;   
         END LOOP;
         
         FOR k IN(SELECT NVL(SUM(nrp)/DECODE(SUM(nop),0,NULL,SUM(nop)),0) max_year_pct
                    FROM giex_ren_ratio
                   WHERE user_id = p_user_id
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND iss_cd  = NVL(p_iss_cd,iss_cd)
                     AND year IN (SELECT MAX(year) 
                            FROM giex_ren_ratio
             			   WHERE user_id = p_user_id))
         LOOP
            v_grand_total.max_year_pct  := k.max_year_pct;
         END LOOP;
         
         v_grand_total.grand_pct_diff_temp   := v_grand_total.max_year_pct - v_grand_total.min_year_pct;
         
         IF v_grand_total.grand_pct_diff_temp IS NULL THEN
            v_grand_total.grand_pct_diff := 0;
         ELSE
            v_grand_total.grand_pct_diff   := v_grand_total.grand_pct_diff_temp;
         END IF;
         
         PIPE ROW(v_grand_total);
         
      END LOOP;                
   END;
   
/******************************************************************************
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/7/2012    Bonok            GIEXR110 FUNCTIONS
******************************************************************************/

FUNCTION populate_giexr110_main(
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE,
      p_user_id         giex_ren_ratio.user_Id%TYPE
   )
      RETURN giexr110_main_tab PIPELINED AS
         v_details         giexr110_main_type;
   BEGIN
      FOR i IN(SELECT SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)) pol_premium,
                      SUM(DECODE(a.user_id,p_user_id,a.nop,0)) no_of_policy,
                      a.line_cd line_cd,
                      a.subline_cd subline_cd,
                      a.iss_cd iss_cd,
                      a.YEAR YEAR,
                      SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_renew_amt,0),0)) renew_prem,
                      SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_new_amt,0),0)) new_prem,
                      c.line_name line_name,
                      SUM(nop) sum_nop,
                      SUM(nnp) sum_nnp,
                      SUM(nrp) sum_nrp,
                      d.subline_name subline_name,
                      e.iss_name iss_name,
                      (SUM(DECODE(a.user_id,p_user_id,NVL(a.prem_renew_amt,0),0))/DECODE(SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)),0,NULL,SUM(DECODE(a.user_id,p_user_id,a.prem_amt,0)))) pct_differ
                 FROM giex_ren_ratio a,
                      giis_line c,
                      giis_subline d,
                      giis_issource e
                WHERE 1 = 1
                  AND a.line_cd    = c.line_cd
                  AND a.line_cd    = d.line_cd
                  AND a.subline_cd = d.subline_cd
                  AND a.iss_cd     = e.iss_cd
                  AND a.iss_cd     = NVL(p_iss_cd,a.iss_cd)
                  AND a.line_cd    = NVL(p_line_cd,a.line_cd)
                  AND a.user_id     = p_user_id
                GROUP BY a.line_cd,a.subline_cd,a.iss_cd,a.YEAR,c.line_name,
                         d.subline_name,e.iss_name)
      LOOP
         v_details.pol_premium  := i.pol_premium;
         v_details.no_of_policy := i.no_of_policy;
         v_details.line_cd      := i.line_cd;
         v_details.subline_cd   := i.subline_cd;
         v_details.iss_cd       := i.iss_cd;
         v_details.year         := i.year;
         v_details.renew_prem   := i.renew_prem;
         v_details.new_prem     := i.new_prem;
         v_details.iss_name     := i.iss_name;
         v_details.line_name    := i.line_name;
         v_details.subline_name := i.subline_name;
         v_details.sum_nop      := i.sum_nop;
         v_details.sum_nnp      := i.sum_nnp;
         v_details.sum_nrp      := i.sum_nrp;
         v_details.pct_differ   := NVL(i.pct_differ,0);
         
         FOR j IN(SELECT SUM(DECODE(user_id,p_user_id,NVL(prem_renew_amt,0),0)) lcd_renew_prem,
                         SUM(DECODE(user_id,p_user_id,prem_amt,0)) lcd_pol_premium
                    FROM giex_ren_ratio
                   WHERE line_cd = i.line_cd
                     AND year = i.year
                   GROUP BY line_cd)
         LOOP
            v_details.lcd_pol_premium := j.lcd_pol_premium;
            IF v_details.lcd_pol_premium = 0 THEN
               v_details.lcd_pct_diff := 0;
            ELSE
               v_details.lcd_pct_diff    := j.lcd_renew_prem/v_details.lcd_pol_premium;
            END IF;   
         END LOOP;
         
         FOR k IN(SELECT (NVL(SUM(prem_renew_amt),0)/DECODE(SUM(prem_amt),0,NULL,SUM(prem_amt))) premium_pct_differ
                    FROM giex_ren_ratio
                   WHERE user_id=p_user_id
                     AND iss_cd = NVL(p_iss_cd, iss_cd)
                     AND line_cd = NVL(p_line_cd, line_cd)
                     AND year = i.year  
                   GROUP BY iss_cd, year)
         LOOP
            v_details.icd_pct_differ := NVL(k.premium_pct_differ,0);
         END LOOP;
         
         FOR lmax IN(SELECT (NVL(SUM(DECODE(user_id,p_user_id, prem_renew_amt,0)),0)/DECODE(SUM(DECODE(user_id,p_user_id, prem_amt,0)),0,NULL,SUM(DECODE(user_id,p_user_id, prem_amt,0)))) max_scd_pd
                    FROM GIEX_REN_RATIO a
                   WHERE 1 = 1
  		             AND a.iss_cd     = i.iss_cd
  		             AND a.line_cd    = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND month <> 0
                     AND year IN(SELECT MAX(year)
                                   FROM GIEX_REN_RATIO
                                  WHERE user_id = p_user_id)
                   GROUP BY YEAR       
  	               ORDER BY a.YEAR DESC)
                   
         LOOP
            v_details.max_scd_pd := lmax.max_scd_pd;
         END LOOP;
                   
         FOR lmin IN(SELECT (NVL(SUM(DECODE(user_id,p_user_id, prem_renew_amt,0)),0)/DECODE(SUM(DECODE(user_id,p_user_id, prem_amt,0)),0,NULL,SUM(DECODE(user_id,p_user_id, prem_amt,0)))) min_scd_pd
                    FROM GIEX_REN_RATIO a
                   WHERE 1 = 1
  		             AND a.iss_cd     = i.iss_cd
  		             AND a.line_cd    = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND month <> 0
                     AND year IN(SELECT MIN(year)
                                   FROM GIEX_REN_RATIO
                                  WHERE user_id = p_user_id)
                   GROUP BY YEAR       
  	               ORDER BY a.YEAR DESC)
                   
         LOOP
            v_details.min_scd_pd := lmin.min_scd_pd;
         END LOOP;
         
         FOR l IN(SELECT (NVL(SUM(DECODE(user_id,p_user_id, prem_renew_amt,0)),0)/DECODE(SUM(DECODE(user_id,p_user_id, prem_amt,0)),0,NULL,SUM(DECODE(user_id,p_user_id, prem_amt,0)))) scd_pct_differ
                    FROM GIEX_REN_RATIO a
                   WHERE 1 = 1
  		             AND a.iss_cd     = i.iss_cd
  		             AND a.line_cd    = i.line_cd
                     AND a.subline_cd = i.subline_cd
                     AND month <> 0
                   GROUP BY YEAR       
  	               ORDER BY a.YEAR DESC)
         
         LOOP
            IF NVL(v_details.max_scd_pd,0) > NVL(v_details.min_scd_pd,0) THEN
               v_details.scd_pct_differ := NVL(l.scd_pct_differ,0) - 0;
            ELSE
               v_details.scd_pct_differ := 0 - NVL(l.scd_pct_differ,0);
            END IF;   
         END LOOP; 
         
         --LINE_CD PCT DIFF :: LINE - PERCENTAGE INC/DEC
         FOR m IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) min_lcd_pd
                    FROM giex_ren_ratio
                   WHERE user_id = p_user_id
                     AND line_cd = i.line_cd
                     AND iss_cd  = i.iss_cd
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             		               WHERE user_id = p_user_id)   
                   GROUP BY iss_cd,line_cd)
         LOOP
            v_details.min_lcd_pd := m.min_lcd_pd;
         END LOOP;
         
         FOR n IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) max_lcd_pd
                    FROM giex_ren_ratio
                   WHERE user_id = p_user_id
                     AND line_cd = i.line_cd
                     AND iss_cd  = i.iss_cd
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             		               WHERE user_id = p_user_id)   
                   GROUP BY iss_cd,line_cd)
         LOOP
            v_details.max_lcd_pd := n.max_lcd_pd;
         END LOOP;
         
         v_details.line_pct_diff := v_details.max_lcd_pd - v_details.min_lcd_pd; 
         
         --ISS_CD PCT DIFF :: ISSUE SOURCE - PERCENTAGE INC/DEC
         FOR o IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) min_icd_pd
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id		       
		             AND iss_cd = NVL(p_iss_cd,iss_cd)
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
           		                   WHERE user_id = p_user_id)   		     
		           GROUP BY iss_cd)
         LOOP
            v_details.min_icd_pd := o.min_icd_pd;
         END LOOP;
         
         FOR p IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) max_icd_pd
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id		       
		             AND iss_cd = NVL(p_iss_cd,iss_cd)
                     AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
           		                   WHERE user_id = p_user_id)   		     
	               GROUP BY iss_cd)
         LOOP
            v_details.max_icd_pd := p.max_icd_pd;
         END LOOP;
         
         v_details.iss_pct_diff := v_details.max_icd_pd - v_details.min_icd_pd;
         
         PIPE ROW(v_details);
      END LOOP;
   END;
   
   FUNCTION populate_giexr110_header
   
   RETURN giexr110_header_tab PIPELINED AS
      v_co_details         giexr110_header_type;
   
   BEGIN
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_NAME')
         LOOP
            v_co_details.company_name := i.param_value_v;
         END LOOP;
      END;
      
      BEGIN
         FOR i IN (SELECT param_value_v 
                     FROM giis_parameters
                    WHERE UPPER(param_name) = 'COMPANY_ADDRESS')
         LOOP
            v_co_details.company_address := i.param_value_v;
         END LOOP;
      END;
        
      PIPE ROW(v_co_details);
   END; 
   
   FUNCTION populate_giexr110_recap (
      p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
      p_line_cd         giex_ren_ratio.line_cd%TYPE,
      p_user_id         giex_ren_ratio.user_id%TYPE
   )
     RETURN giexr110_recap_tab PIPELINED AS
      v_recap           giexr110_recap_type;
      
   BEGIN
      FOR i IN(SELECT SUM(a.nop) sum_nop,
                      SUM(a.prem_amt) pol_premium,
                      SUM(a.nnp) sum_nnp,
                      SUM(a.nrp) sum_nrp,
                      SUM(a.prem_renew_amt) renew_prem,                               
	                  (NVL(SUM(a.prem_renew_amt),0)/DECODE(SUM(a.prem_amt),0,NULL,SUM(a.prem_amt))) pct_differ,
                      b.iss_name, a.year, a.iss_cd
                 FROM giex_ren_ratio a, giis_issource b
                WHERE 1 = 1 
                  AND a.user_id = p_user_id
                  AND a.iss_cd = b.iss_cd 
                  AND a.line_cd = NVL(p_line_cd,a.line_cd)
                  AND a.iss_cd  = NVL(p_iss_cd,a.iss_cd)
                  AND year IN (SELECT MAX(year) 
                                 FROM giex_ren_ratio
             				    WHERE user_id = p_user_id)
                GROUP BY a.iss_cd, b.iss_name, a.year
                ORDER BY b.iss_name)
      LOOP
         v_recap.year        := i.year;
         v_recap.sum_nop     := i.sum_nop;
         v_recap.pol_premium := i.pol_premium;
         v_recap.sum_nnp     := i.sum_nnp;
         v_recap.sum_nrp     := i.sum_nrp;
         v_recap.renew_prem  := i.renew_prem;
         v_recap.pct_differ  := NVL(i.pct_differ,0);
         v_recap.iss_name    := i.iss_name;
         v_recap.iss_cd      := i.iss_cd;
         
         FOR j IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) min_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = p_user_id)  
                   GROUP BY iss_cd)
                             	     
         LOOP
            v_recap.min_year_pct := j.min_year_pct;
         END LOOP;    
         
         FOR k IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) max_year_pct
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id
		             AND iss_cd  = i.iss_cd
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = p_user_id)  
                   GROUP BY iss_cd)		     		        
         LOOP
            v_recap.max_year_pct := k.max_year_pct;
         END LOOP;
         
         v_recap.iss_pct_diff := v_recap.max_year_pct - v_recap.min_year_pct; 
         
         FOR l IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) min_grand_pd
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id		          
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MIN(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = p_user_id))      
         LOOP
            v_recap.min_grand_pd := l.min_grand_pd;
         END LOOP;
         
          FOR m IN(SELECT NVL(SUM(NVL(PREM_RENEW_AMT,0))/DECODE(SUM(NVL(PREM_AMT,0)),0,NULL,SUM(NVL(PREM_AMT,0))),0) max_grand_pd
		            FROM giex_ren_ratio
		           WHERE user_id = p_user_id		          
		             AND iss_cd  = NVL(p_iss_cd,iss_cd)
		             AND line_cd = NVL(p_line_cd,line_cd)
                     AND year IN (SELECT MAX(year) 
                                    FROM giex_ren_ratio
             			           WHERE user_id = p_user_id))	        
         LOOP
            v_recap.max_grand_pd := m.max_grand_pd;
         END LOOP;
         
         v_recap.grand_pct_diff := v_recap.max_grand_pd - v_recap.min_grand_pd;
         
         PIPE ROW(v_recap);
      END LOOP;
   END;
   
   FUNCTION populate_giexr110_grand_total (
       p_iss_cd          giex_ren_ratio.iss_cd%TYPE,
       p_line_cd         giex_ren_ratio.line_cd%TYPE,
       p_user_id         giex_ren_ratio.user_id%TYPE
    )
      RETURN giexr110_grand_total_tab PIPELINED AS
         v_grand_total     giexr110_grand_total_type;
      
   BEGIN
      FOR i IN(SELECT SUM(prem_amt) grand_pol_premium,
                      YEAR,
                      SUM(prem_renew_amt) grand_renew_prem,
                      (NVL(SUM(prem_renew_amt),0)/DECODE(SUM(prem_amt),0,NULL,SUM(prem_amt))) grand_pct_differ,
                      SUM(nop) sum_nop,
                      SUM(nrp) sum_nrp,
	                  SUM(nnp) sum_nnp
                 FROM giex_ren_ratio
                WHERE user_id=p_user_id
                  AND iss_cd = NVL(p_iss_cd,iss_cd)
                  AND line_cd = NVL(p_line_cd,line_cd)
                GROUP BY YEAR)
      LOOP
         v_grand_total.grand_pol_premium  := i.grand_pol_premium;
         v_grand_total.grand_renew_prem   := i.grand_renew_prem;
         v_grand_total.grand_pct_differ   := i.grand_pct_differ;
         v_grand_total.sum_nop            := i.sum_nop;
         v_grand_total.sum_nrp            := i.sum_nrp;
         v_grand_total.sum_nnp            := i.sum_nnp;
         v_grand_total.year               := i.year;
         
         FOR j IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) min_grand_pd
                 FROM giex_ren_ratio
                WHERE user_id = p_user_id
                  AND line_cd = NVL(p_line_cd,line_cd)
                  AND iss_cd  = NVL(p_iss_cd,iss_cd)
                  AND year IN (SELECT MIN(year) 
                                 FROM giex_ren_ratio
             			        WHERE user_id = p_user_id))
         LOOP
            v_grand_total.min_grand_pd := j.min_grand_pd;
         END LOOP;
      
         FOR k IN(SELECT NVL(SUM(NVL(prem_renew_amt,0))/DECODE(SUM(NVL(prem_amt,0)),0,NULL,SUM(NVL(prem_amt,0))),0) max_grand_pd
                    FROM giex_ren_ratio
                   WHERE user_id = p_user_id
                  AND line_cd = NVL(p_line_cd,line_cd)
                  AND iss_cd  = NVL(p_iss_cd,iss_cd)
                  AND year IN (SELECT MAX(year) 
                                 FROM giex_ren_ratio
             			        WHERE user_id = p_user_id))
         LOOP
            v_grand_total.max_grand_pd := k.max_grand_pd;
         END LOOP;
         
         v_grand_total.grand_pct_diff := v_grand_total.max_grand_pd - v_grand_total.min_grand_pd;
      
         PIPE ROW(v_grand_total);
      END LOOP;            
   END;

END GIEX_BUSINESS_CONSERVATION_PKG;
/


