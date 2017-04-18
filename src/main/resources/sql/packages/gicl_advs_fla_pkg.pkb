CREATE OR REPLACE PACKAGE BODY CPI.GICL_ADVS_FLA_PKG AS

    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : March 30, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Gets Final Loss Advice Details
    */
    FUNCTION get_fla_dtls(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_grp_seq_no            GICL_ADVS_FLA.grp_seq_no%TYPE,
        p_share_type            GICL_ADVS_FLA.share_type%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE
    )
    RETURN fla_dtls_tab PIPELINED AS
        v_fla_dtls              fla_dtls_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GICL_ADVS_FLA
                  WHERE claim_id = p_claim_id
                    AND grp_seq_no = p_grp_seq_no
                    AND share_type = p_share_type
                    AND (cancel_tag = 'N' OR cancel_tag IS NULL)
                    AND adv_fla_id IN (SELECT adv_fla_id
                                         FROM GICL_ADVICE
                                        WHERE claim_id = p_claim_id
                                          AND advice_id = p_advice_id))
        LOOP
            BEGIN
                SELECT ri_name
                  INTO v_fla_dtls.ri_name
                  FROM GIIS_REINSURER
                 WHERE ri_cd = i.ri_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_fla_dtls.ri_name := NULL;
            END;
            
            IF i.print_sw = 'Y' THEN
                v_fla_dtls.print_sw := 'true';
            ELSE
                v_fla_dtls.print_sw := 'false';
            END IF;
            
            v_fla_dtls.claim_id := i.claim_id;
            v_fla_dtls.fla_id := i.fla_id;
            v_fla_dtls.fla_no := i.line_cd||'-'||i.la_yy||'-'||LTRIM(TO_CHAR(i.fla_seq_no, '0999999'));
            v_fla_dtls.line_cd := i.line_cd;
            v_fla_dtls.la_yy := i.la_yy;
            v_fla_dtls.fla_seq_no := i.fla_seq_no;
            v_fla_dtls.paid_shr_amt := i.paid_shr_amt;
            v_fla_dtls.net_shr_amt := i.net_shr_amt;
            v_fla_dtls.adv_shr_amt := i.adv_shr_amt;
            v_fla_dtls.fla_title := i.fla_title;
            v_fla_dtls.fla_header := i.fla_header;
            v_fla_dtls.fla_footer := i.fla_footer;
            v_fla_dtls.adv_fla_id := i.adv_fla_id;
            v_fla_dtls.ri_cd := i.ri_cd;
            v_fla_dtls.dsp_ri_name := i.ri_cd||' - '||v_fla_dtls.ri_name;
            v_fla_dtls.share_type := i.share_type;
            v_fla_dtls.grp_seq_no := i.grp_seq_no;
            PIPE ROW(v_fla_dtls);
        END LOOP;
    END;

    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 11, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Set FLA ID
    */
    PROCEDURE generate_fla(
        p_claim_id          GICL_ADVS_FLA.claim_id%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE,
        p_line_cd           GICL_CLAIMS.line_cd%TYPE,
        p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
        p_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE
    )
    AS
    BEGIN
        UPDATE GICL_ADVICE
           SET adv_fla_id = p_adv_fla_id
         WHERE claim_id = p_claim_id
           AND advice_id = p_advice_id;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 11, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Get adv_fla_id for new FLA
    */
    FUNCTION get_adv_fla_id
    RETURN NUMBER
    AS
        v_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE;
    BEGIN
        SELECT NVL(MAX(adv_fla_id),0) + 1
          INTO v_adv_fla_id
          FROM GICL_ADVS_FLA;
        RETURN v_adv_fla_id;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 11, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Insert Generetad FLA
    */
    PROCEDURE clm_fla_grp1(
        p_claim_id          GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd           GICL_ADVS_FLA.line_cd%TYPE,
        p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
        p_vadvice           VARCHAR2
    )
    AS
        v_fla_id            GICL_ADVS_FLA.fla_id%TYPE;
        v_count             NUMBER := 0;
        v_item_no           GICL_ADVS_PLA.pla_seq_no%TYPE;
        v_adv_fla           GICL_ADVS_FLA.adv_fla_id%TYPE;
        v_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE;
        v_fla_title         GICL_ADVS_FLA.fla_title%TYPE;
        v_fla_header        GICL_ADVS_FLA.fla_header%TYPE;
        v_fla_footer        VARCHAR2(2000);
        v_acct_trty_type    GICL_LOSS_EXP_DS.acct_trty_type%TYPE;
    
        CURSOR c IS
            SELECT claim_id, share_type, grp_seq_no,
                   prnt_ri_cd ri_cd, SUM(pd_amt) pd_amt,
                   SUM(net_amt) net_amt,
                   SUM(ADV_AMT) adv_amt
              FROM GICL_FOR_FLA_V
             WHERE claim_id = p_claim_id
               AND share_type <> 4
               AND INSTR(p_vadvice,(','||TO_CHAR(advice_id)||','),1) <> 0
             GROUP BY claim_id, share_type, grp_seq_no, prnt_ri_cd;
             
        CURSOR d IS
            SELECT claim_id, share_type, grp_seq_no,
                   prnt_ri_cd ri_cd, SUM(pd_amt) pd_amt,
                   SUM(net_amt) net_amt,
                   SUM(adv_amt) adv_amt
              FROM GICL_FOR_FLA_V
             WHERE claim_id = p_claim_id
               AND share_type = 4
               AND INSTR(p_vadvice,(','||TO_CHAR(advice_id)||','),1) <> 0
             GROUP BY claim_id, share_type, grp_seq_no, prnt_ri_cd;
    BEGIN
        SELECT NVL(MAX(adv_fla_id), 0) + 1
          INTO v_adv_fla
          FROM GICL_ADVS_FLA;
          
        v_adv_fla_id := v_adv_fla;
        
        SELECT NVL(MAX(fla_seq_no), 0)
          INTO v_item_no
          FROM GICL_ADVS_FLA
         WHERE line_cd = p_line_cd
           AND la_yy = p_clm_yy;
           
        FOR f IN(SELECT param_value_v
                   FROM GIAC_PARAMETERS
                  WHERE param_name = 'FLA_TITLE')
        LOOP
            v_fla_title := f.param_value_v;
        END LOOP;
        
        FOR f IN(SELECT param_value_v
                   FROM GIAC_PARAMETERS
                  WHERE param_name = 'FLA_HEADER')
        LOOP
            v_fla_header := f.param_value_v;
        END LOOP;
        
        FOR f IN(SELECT param_value_v
                   FROM GIAC_PARAMETERS
                  WHERE param_name = 'FLA_FOOTER')
        LOOP
            v_fla_footer := f.param_value_v;
        END LOOP;
        
        v_count := v_item_no + 1;
        
        BEGIN
            SELECT NVL(MAX(fla_id), 0) + 1
              INTO v_fla_id
              FROM GICL_ADVS_FLA;
            IF v_fla_id IS NULL THEN
                v_fla_id := 1;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_fla_id := 1;
        END;
        
        FOR crec IN c
        LOOP
            v_acct_trty_type := get_acct_trty_type(crec.claim_id, crec.share_type, crec.grp_seq_no, crec.ri_cd);
            INSERT INTO GICL_ADVS_FLA(fla_id,       claim_id,       grp_seq_no,      ri_cd,             line_cd,
                                      la_yy,        fla_seq_no,     fla_date,        share_type,        paid_shr_amt,
                                      net_shr_amt,  adv_shr_amt,    print_sw,        adv_fla_id,        fla_title,
                                      fla_header,   fla_footer,     acct_trty_type)
                               VALUES(v_fla_id,     crec.claim_id,  crec.grp_seq_no, crec.ri_cd,        p_line_cd,
                                      p_clm_yy,     v_count,        SYSDATE,         crec.share_type,   crec.pd_amt,
                                      crec.net_amt, crec.adv_amt,   'N',             v_adv_fla,         v_fla_title,
                                      v_fla_header, v_fla_footer,   v_acct_trty_type);
            v_fla_id := v_fla_id + 1;
            v_count := v_count + 1;
        END LOOP;
        
        FOR crec IN d
        LOOP
            v_acct_trty_type := get_acct_trty_type(crec.claim_id, crec.share_type, crec.grp_seq_no, crec.ri_cd);
            INSERT INTO GICL_ADVS_FLA(fla_id,       claim_id,       grp_seq_no,      ri_cd,             line_cd,
                                      la_yy,        fla_seq_no,     fla_date,        share_type,        paid_shr_amt,
                                      net_shr_amt,  adv_shr_amt,    print_sw,        adv_fla_id,        fla_title,
                                      fla_header,   fla_footer,     acct_trty_type)
                               VALUES(v_fla_id,     crec.claim_id,  crec.grp_seq_no, crec.ri_cd,        p_line_cd,
                                      p_clm_yy,     v_count,        SYSDATE,         crec.share_type,   crec.pd_amt,
                                      crec.net_amt, crec.adv_amt,   'N',             v_adv_fla_id,      v_fla_title,
                                      v_fla_header, v_fla_footer,   v_acct_trty_type);
            v_fla_id := v_fla_id + 1;
            v_count := v_count + 1;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_count := 1;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 11, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Insert Generetad FLA (facultative)
    */
    PROCEDURE clm_fla_grp1a(
        p_claim_id          GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd           GICL_ADVS_FLA.line_cd%TYPE,
        p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
        p_vadvice           VARCHAR2
    )
    AS
        v_fla_id            GICL_ADVS_FLA.fla_id%TYPE;
        v_item_no           GICL_ADVS_PLA.pla_seq_no%TYPE;
        v_adv_fla           GICL_ADVS_FLA.adv_fla_id%TYPE;
        v_adv_fla_id        GICL_ADVS_FLA.adv_fla_id%TYPE;
        v_count             NUMBER := 0;
        v_fla_title         GICL_ADVS_FLA.fla_title%TYPE;
        v_fla_header        GICL_ADVS_FLA.fla_header%TYPE;
        v_fla_footer        VARCHAR2(2000);
        v_acct_trty_type    GICL_LOSS_EXP_DS.acct_trty_type%TYPE;
    
        CURSOR c IS
            SELECT claim_id, share_type, grp_seq_no,
                   ri_cd, SUM(pd_amt) pd_amt,
                   SUM(net_amt) net_amt,
                   SUM(adv_amt) adv_amt
              FROM GICL_FOR_FLA_V
             WHERE claim_id = p_claim_id
               AND INSTR(p_vadvice,(','||TO_CHAR(advice_id)||','),1) <> 0
             GROUP BY claim_id, share_type, grp_seq_no, ri_cd;
    BEGIN
        SELECT NVL(MAX(adv_fla_id),0) + 1
          INTO v_adv_fla
          FROM GICL_ADVS_FLA;
          
        v_adv_fla_id := v_adv_fla;
        
        SELECT NVL(MAX(fla_seq_no), 0)
          INTO v_item_no
          FROM GICL_ADVS_FLA
         WHERE line_cd = p_line_cd
           AND la_yy = p_clm_yy;
    
        SELECT param_value_v
          INTO v_fla_title
          FROM GIAC_PARAMETERS
         WHERE param_name = 'FLA_TITLE';
         
        SELECT param_value_v
          INTO v_fla_header
          FROM GIAC_PARAMETERS
         WHERE param_name = 'FLA_HEADER';
        
        SELECT param_value_v
          INTO v_fla_footer
          FROM GIAC_PARAMETERS
         WHERE param_name = 'FLA_FOOTER';
         
        v_count := v_item_no + 1;
        
        BEGIN
            SELECT NVL(MAX(fla_id), 0) + 1
              INTO v_fla_id
              FROM GICL_ADVS_FLA;
            IF v_fla_id IS NULL THEN
                v_fla_id := 1;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_fla_id := 1;
        END;
        
        FOR crec IN c
        LOOP
            v_acct_trty_type := get_acct_trty_type(crec.claim_id, crec.share_type, crec.grp_seq_no, crec.ri_cd);
            INSERT INTO GICL_ADVS_FLA(fla_id, claim_id, grp_seq_no, ri_cd, line_cd, la_yy, fla_seq_no, fla_date, share_type, paid_shr_amt, net_shr_amt,
                                      adv_shr_amt, print_sw, adv_fla_id, fla_title, fla_header, fla_footer, acct_trty_type)
                               VALUES(v_fla_id, crec.claim_id, crec.grp_seq_no, crec.ri_cd, p_line_cd, p_clm_yy, v_count, SYSDATE, crec.share_type, crec.pd_amt,
                                      crec.net_amt, crec.adv_amt, 'N', v_adv_fla_id, v_fla_title, v_fla_header, v_fla_footer, v_acct_trty_type);
            v_fla_id := v_fla_id + 1;
            v_count := v_count + 1;
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_count := 1;
    END;
    
    FUNCTION get_acct_trty_type(
        p_claim_id          NUMBER,
        p_share_type        NUMBER,
        p_grp_seq_no        NUMBER,
        p_prnt_ri_cd        NUMBER
    )
        RETURN NUMBER
    AS
        v_acct_trty_type    GICL_LOSS_EXP_DS.acct_trty_type%TYPE;
        v_advice_id         GICL_CLM_LOSS_EXP.advice_id%TYPE;
    BEGIN
        FOR c1 IN(SELECT advice_id
                    FROM GICL_FOR_FLA_V
                   WHERE claim_id = p_claim_id
                     AND share_type = p_share_type
                     AND grp_seq_no = p_grp_seq_no
                     AND prnt_ri_cd = p_prnt_ri_cd)
        LOOP
            v_advice_id := c1.advice_id;
            EXIT;
        END LOOP;
        
        FOR c1 IN(SELECT b.acct_trty_type
                    FROM GICL_LOSS_EXP_DS b,
                         GICL_CLM_LOSS_EXP a
                   WHERE b.claim_id = a.claim_id
                     AND b.clm_loss_id = a.clm_loss_id
                     AND NVL(b.negate_tag,'N') <> 'Y'
                     AND b.grp_seq_no = p_grp_seq_no
                     AND b.share_type = p_share_type
                     AND a.advice_id = v_advice_id)
        LOOP
            v_acct_trty_type := c1.acct_trty_type;
            EXIT;
        END LOOP;
        RETURN v_acct_trty_type;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 3, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Cancel Final Loss Advice
    */
    PROCEDURE cancel_fla(
        p_claim_id      IN      GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd       IN      GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy         IN      GICL_ADVS_FLA.la_yy%TYPE,
        p_share_type    IN      GICL_ADVS_FLA.share_type%TYPE,
        p_adv_fla_id    IN      GICL_ADVS_FLA.adv_fla_id%TYPE,
        p_message       OUT     VARCHAR2
    )
    AS
        v_collection_amt        NUMBER := 0;
        v_ref_no                VARCHAR2(200) := '';
    BEGIN
        FOR i IN(SELECT SUM(collection_amt) collection_amt
                   FROM GIAC_LOSS_RI_COLLNS a,
                        GIAC_ACCTRANS b
                  WHERE tran_flag <> 'D'
                    AND NOT EXISTS(
                        SELECT gacc_tran_id
                          FROM GIAC_ACCTRANS z,
                               GIAC_REVERSALS t
                         WHERE z.tran_id = t.reversing_tran_id
                           AND z.tran_id = a.gacc_tran_id
                           AND z.tran_flag <> 'D')
                    AND e150_line_cd = p_line_cd
                    AND e150_fla_seq_no IN (SELECT fla_seq_no
                                              FROM GICL_ADVS_FLA
                                             WHERE claim_id = p_claim_id
                                               AND cancel_tag IS NULL)
                    AND e150_la_yy = p_la_yy
                    AND share_type = p_share_type)
        LOOP
            IF NVL(i.collection_amt, 0) > 0 THEN
                v_collection_amt := v_collection_amt + i.collection_amt;
                FOR i IN(SELECT DISTINCT(gacc_tran_id) gacc_tran_id
                           FROM GIAC_LOSS_RI_COLLNS
                          WHERE claim_id = p_claim_id)
                LOOP
                    v_ref_no := v_ref_no||' '||get_ref_no(i.gacc_tran_id)||chr(10);
                END LOOP;
            END IF;
        END LOOP;
        IF NVL(v_collection_amt, 0) > 0 THEN
            p_message := 'Payment is already made for this advice. You can cancel or reverse the payment made in accounting. '||
                          'Your reference number(s): '||v_ref_no;
        ELSE
            UPDATE GICL_ADVS_FLA
               SET cancel_tag = 'Y'
             WHERE claim_id = p_claim_id
               AND adv_fla_id = p_adv_fla_id;
               
            UPDATE GICL_ADVICE
               SET adv_fla_id = NULL
             WHERE claim_id = p_claim_id
               AND adv_fla_id = p_adv_fla_id;
               
            p_message := 'Cancellation Successful.';
        END IF;
    END;
    
    FUNCTION check_gen(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_line_cd               GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy                 GICL_ADVS_FLA.la_yy%TYPE,
        p_fla_seq_no            GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_ri_cd                 GICL_ADVS_FLA.ri_cd%TYPE
    )
    RETURN VARCHAR2 AS
        v_coll_amt              GIAC_ORDER_OF_PAYTS.collection_amt%TYPE;
        v_ref_no                VARCHAR2(200);
    BEGIN
        FOR i IN(SELECT b.e150_line_cd || '-' || b.e150_la_yy || '-' || b.e150_fla_seq_no, b.collection_amt
                   FROM GIAC_LOSS_RI_COLLNS b,
                        GIAC_ACCTRANS c,
                        GIAC_ORDER_OF_PAYTS d
                  WHERE b.e150_line_cd = p_line_cd
                    AND b.e150_la_yy = p_la_yy
                    AND b.e150_fla_seq_no = p_fla_seq_no
                    AND b.a180_ri_cd = p_ri_cd
                    AND c.tran_id = b.gacc_tran_id
                    AND c.tran_id = d.gacc_tran_id
                    AND c.tran_id = 'COL'
                    AND d.or_flag = 'P'
                  UNION
                 SELECT b.e150_line_cd || '-' || b.e150_la_yy || '-' || b.e150_fla_seq_no, b.collection_amt
                   FROM GIAC_LOSS_RI_COLLNS b,
                        GIAC_ACCTRANS c
                  WHERE b.e150_line_cd = p_line_cd
                    AND b.e150_la_yy = p_la_yy
                    AND b.e150_fla_seq_no = p_fla_seq_no
                    AND b.a180_ri_cd = p_ri_cd
                    AND b.gacc_tran_id = c.tran_id
                    AND c.tran_flag IN ('C', 'P')
                    AND c.tran_class IN ('DV', 'JV')
                    AND NOT EXISTS(SELECT 1
                                     FROM GIAC_REVERSALS d
                                    WHERE d.gacc_tran_id = b.gacc_tran_id))
        LOOP
            v_coll_amt := NVL(v_coll_amt, 0) + i.collection_amt;
            FOR i IN (SELECT DISTINCT(gacc_tran_id) gacc_tran_id
                        FROM GIAC_LOSS_RI_COLLNS
                       WHERE claim_id = p_claim_id)
            LOOP
                v_ref_no := v_ref_no || '  ' || get_ref_no(i.gacc_tran_id) ||CHR(10);
            END LOOP;
            IF NVL(v_coll_amt, 0) > 0 THEN
                v_ref_no := v_ref_no;
            ELSE
                v_ref_no := NULL;
            END IF;
        END LOOP;
        RETURN v_ref_no;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 4, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Updates Final Loss Advice
    */
    PROCEDURE update_fla(
        p_claim_id              GICL_ADVS_FLA.claim_id%TYPE,
        p_grp_seq_no            GICL_ADVS_FLA.grp_seq_no%TYPE,
        p_share_type            GICL_ADVS_FLA.share_type%TYPE,
        p_advice_id             GICL_ADVICE.advice_id%TYPE,
        p_fla_seq_no            GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_fla_title             GICL_ADVS_FLA.fla_title%TYPE,
        p_fla_header            GICL_ADVS_FLA.fla_header%TYPE,
        p_fla_footer            GICL_ADVS_FLA.fla_footer%TYPE
    )
    AS
    BEGIN
        UPDATE GICL_ADVS_FLA
           SET fla_title = p_fla_title,
               fla_header = p_fla_header,
               fla_footer = p_fla_footer
         WHERE claim_id = p_claim_id
           AND grp_seq_no = p_grp_seq_no
           AND share_type = p_share_type
           AND fla_seq_no = p_fla_seq_no
           AND (cancel_tag = 'N' OR cancel_tag IS NULL)
           AND adv_fla_id IN (SELECT adv_fla_id
                                FROM GICL_ADVICE
                               WHERE claim_id = p_claim_id
                                 AND advice_id = p_advice_id);
    END;
    
    FUNCTION validate_pd_fla(
        p_user_id       IN      GIIS_USERS.user_id%TYPE,
        p_line_cd       IN      GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy         IN      GICL_ADVS_FLA.la_yy%TYPE,
        p_fla_seq_no    IN      GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_ri_cd         IN      GICL_ADVS_FLA.ri_cd%TYPE,
        p_override      IN      VARCHAR2
    )
    RETURN VARCHAR2 AS
        v_msg_type              VARCHAR2(1);
        v_coll_amt              GIAC_ORDER_OF_PAYTS.collection_amt%TYPE;
    BEGIN
        v_coll_amt := 0;
        
        FOR i IN (SELECT b.e150_line_cd || '-' || b.e150_la_yy || '-' || b.e150_fla_seq_no, b.collection_amt
                    FROM GIAC_LOSS_RI_COLLNS b, GIAC_ACCTRANS c, GIAC_ORDER_OF_PAYTS d
                   WHERE b.e150_line_cd = p_line_cd
                     AND b.e150_la_yy = p_la_yy
                     AND b.e150_fla_seq_no = p_fla_seq_no
                     AND b.a180_ri_cd = p_ri_cd
                     AND c.tran_id = b.gacc_tran_id
                     AND c.tran_id = d.gacc_tran_id
                     AND c.tran_class = 'COL'
                     AND d.or_flag = 'P'
                   UNION   
                  SELECT b.e150_line_cd || '-' || b.e150_la_yy || '-' || b.e150_fla_seq_no, b.collection_amt
                    FROM GIAC_LOSS_RI_COLLNS b, GIAC_ACCTRANS c
                   WHERE b.e150_line_cd = p_line_cd
                     AND b.e150_la_yy = p_la_yy
                     AND b.e150_fla_seq_no = p_fla_seq_no
                     AND b.a180_ri_cd = p_ri_cd
                     AND b.gacc_tran_id = c.tran_id
                     AND c.tran_flag IN ('C', 'P')
                     AND c.tran_class IN ('DV', 'JV')
                     AND NOT EXISTS (SELECT 1
                                      FROM GIAC_REVERSALS d
                                     WHERE d.gacc_tran_id = b.gacc_tran_id))
       LOOP
       	 v_coll_amt := nvl(v_coll_amt, 0) + i.collection_amt;
       END LOOP;
       
       IF v_coll_amt > 0 THEN
            IF NVL(giisp.v('VALIDATE_PD_FLA'), 'N') = 'Y' THEN
                v_msg_type := 'Y';
            ELSIF NVL(giisp.v('VALIDATE_PD_FLA'), 'N') = 'N' THEN
                v_msg_type := 'N';
            ELSIF NVL(giisp.v('VALIDATE_PD_FLA'), 'N') = 'O' THEN
  		        IF p_override = 'N' THEN
                    IF NOT check_user_override_function(p_user_id, 'GICLS033', 'PF') THEN
                        v_msg_type := 'O';
                    END IF;
  		        END IF;
  		    END IF;
       ELSE
        v_msg_type := 'X';
       END IF;
       RETURN v_msg_type;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : April 4, 2012
    ** Referenced by : (GICLS033 - Generate FLA)
    ** Description   : Updates print_sw after printing
    */
    PROCEDURE update_fla_print_sw(
        p_claim_id      IN      GICL_ADVS_FLA.claim_id%TYPE,
        p_share_type    IN      GICL_ADVS_FLA.share_type%TYPE,
        p_ri_cd         IN      GICL_ADVS_FLA.ri_cd%TYPE,
        p_fla_seq_no    IN      GICL_ADVS_FLA.fla_seq_no%TYPE,
        p_line_cd       IN      GICL_ADVS_FLA.line_cd%TYPE,
        p_la_yy         IN      GICL_ADVS_FLA.la_yy%TYPE
    )
    AS
    BEGIN
        UPDATE GICL_ADVS_FLA
           SET print_sw = 'Y'
         WHERE claim_id = p_claim_id
           AND share_type = DECODE(p_share_type, 4, 4, share_type)
           AND ri_cd = p_ri_cd
           AND fla_seq_no = p_fla_seq_no
           AND line_cd = p_line_cd
           AND la_yy = p_la_yy;
    END;
    
    
    /*
    ** Created by    : Marie Kris Felipe
    ** Created date  : August 13, 2013
    ** Referenced by : (GICLS050 - Print PLA/FLA)
    ** Description   : Tag FLA as printed
    */
    PROCEDURE tag_fla_as_printed(
        p_fla   gicl_advs_fla%ROWTYPE
    ) IS
    
    BEGIN
    
        IF p_fla.print_sw = 'N' THEN
        
            IF p_fla.share_type = 4 THEN
            
                UPDATE gicl_advs_fla
                   SET print_sw   = 'Y',
                       fla_header = p_fla.fla_header,
                       fla_footer = p_fla.fla_footer,
                       fla_title  = p_fla.fla_title
                 WHERE claim_id   = p_fla.claim_id
                   AND share_type = 4
                   AND ri_cd      = p_fla.ri_cd
                   AND fla_seq_no = p_fla.fla_seq_no
                   AND line_cd    = p_fla.line_cd
                   AND la_yy      = p_fla.la_yy;
            
                --check_pla_fla_xol_to_print;--vj 030107
            ELSE 
            
                UPDATE gicl_advs_fla
                   SET print_sw   = 'Y',
                       fla_header = p_fla.fla_header,
                       fla_footer = p_fla.fla_footer,
                       fla_title  = p_fla.fla_title
                 WHERE claim_id   = p_fla.claim_id
                   AND grp_seq_no = p_fla.grp_seq_no
                   AND ri_cd      = p_fla.ri_cd
                   AND fla_seq_no = p_fla.fla_seq_no
                   AND line_cd    = p_fla.line_cd
                   AND la_yy      = p_fla.la_yy;
                      
                --check_pla_fla_to_print;
            END IF;
        
        END IF;
    END tag_fla_as_printed;
    
END GICL_ADVS_FLA_PKG;
/


