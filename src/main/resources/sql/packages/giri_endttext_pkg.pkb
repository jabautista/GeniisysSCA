CREATE OR REPLACE PACKAGE BODY CPI.giri_endttext_pkg
AS

    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 01.05.2012
    **  Reference By    : (GIUTS024 - Generate Binder (Non-Affecting Endorsement))
    **  Description     :  get reinsurance details of the policy
    */
    FUNCTION get_reinsurance_details(
        p_policy_id   giri_endttext.policy_id%TYPE
    )
    RETURN giri_endttext_tab PIPELINED
    IS
        v_ri_dtls   giri_endttext_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM giri_endttext
                   WHERE policy_id = p_policy_id)
        LOOP
            v_ri_dtls.ri_cd             :=  i.ri_cd;
            v_ri_dtls.fnl_binder_id     :=  i.fnl_binder_id;
            v_ri_dtls.remarks           :=  i.remarks;
            v_ri_dtls.policy_id         :=  i.policy_id;

            BEGIN
                FOR A IN (SELECT ri_name
                            FROM giis_reinsurer
                           WHERE ri_cd = i.ri_cd)
                LOOP
                    v_ri_dtls.dsp_ri_name := a.ri_name;
                    EXIT;
                END LOOP;

                FOR B IN (SELECT endt_text, binder_date
                            FROM giri_binder
                           WHERE fnl_binder_id = i.fnl_binder_id)
                LOOP
                    v_ri_dtls.dsp_endt_text    := b.endt_text;
                    v_ri_dtls.dsp_binder_date := b.binder_date;
                    EXIT;
                END LOOP;

                FOR C IN (SELECT line_cd, binder_yy, binder_seq_no
                            FROM giri_binder
                           WHERE fnl_binder_id = i.fnl_binder_id)
                LOOP
                    v_ri_dtls.dsp_binder_no  := c.line_cd||'-'||to_char(c.binder_yy,'09')||'-'||
                                                     to_char(c.binder_seq_no,'00009');
                    EXIT;
                END LOOP;
            END;
            PIPE ROW (v_ri_dtls);
        END LOOP;
    END;

    /*
    **  Created by       : Robert Virrey
    **  Date Created     : 01.06.2012
    **  Reference By     : (GIUTS024- Generate Binder (Non-Affecting Endorsement))
    **  Description:     : inserts/updates new record to tables giri_endttext, giri_binder
    */
    PROCEDURE update_create_endttext_binder(
        p_policy_id        giri_endttext.policy_id%TYPE,
        p_ri_cd            giri_endttext.ri_cd%TYPE,
        p_dsp_endttext     giri_binder.endt_text%TYPE,
        p_fnl_binder_id    giri_endttext.fnl_binder_id%TYPE,
        p_remarks          giri_endttext.remarks%TYPE,
        p_line_cd          giis_fbndr_seq.line_cd%TYPE,
        p_user_id          giis_fbndr_seq.user_id%TYPE,
        p_eff_date         giri_binder.eff_date%TYPE,
        p_expiry_date      giri_binder.expiry_date%TYPE,
        p_dsp_binder_date  giri_binder.binder_date%TYPE,
        p_iss_cd           giri_binder.iss_cd%TYPE
    )
    IS
        v_exists              VARCHAR2(1) := 'N';
        v_yy                  giis_fbndr_seq.fbndr_yy%TYPE;
        v_fbndr_seq_no        giis_fbndr_seq.fbndr_seq_no%TYPE;
        v_binder_id           giri_binder.fnl_binder_id%TYPE;
        v_attention           giri_binder.attention%TYPE;
    BEGIN
        FOR A IN (SELECT '1'
                    FROM giri_endttext
                   WHERE policy_id = p_policy_id
                     AND ri_cd     = p_ri_cd)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            UPDATE giri_binder
               SET endt_text    = p_dsp_endttext,
                   ri_cd        = p_ri_cd,
                   user_id      = p_user_id,
                   last_update  = SYSDATE
            WHERE fnl_binder_id = p_fnl_binder_id;

            UPDATE giri_endttext
               SET fnl_binder_id = p_fnl_binder_id,
                   remarks       = p_remarks,
                   user_id       = p_user_id,
                   last_update   = SYSDATE
             WHERE policy_id     = p_policy_id
               AND ri_cd         = p_ri_cd;
        ELSE
            SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YY'))--roset, 1/13/2010, changed 'Y' to 'YY'
              INTO    v_yy
              FROM DUAL;
            FOR A IN (SELECT (fbndr_seq_no + 1) fbndr_seq_no
                        FROM giis_fbndr_seq
                       WHERE line_cd = p_line_cd
                         AND fbndr_yy = v_yy)
            LOOP
                v_fbndr_seq_no := a.fbndr_seq_no;
                EXIT;
            END LOOP;
            IF v_fbndr_seq_no IS NULL THEN
                v_fbndr_seq_no := 1;
                INSERT INTO giis_fbndr_seq(line_cd, fbndr_yy, fbndr_seq_no, user_id, last_update)
                                   VALUES (p_line_cd, v_yy, v_fbndr_seq_no, p_user_id, SYSDATE);
            END IF;
            BEGIN
                SELECT binder_id_s.nextval
                  INTO v_binder_id
                  FROM dual;
            END;

            FOR A IN (SELECT attention
                        FROM giis_reinsurer
                       WHERE ri_cd = p_ri_cd)
            LOOP
                v_attention := a.attention;
                EXIT;
            END LOOP;

            INSERT INTO giri_binder(fnl_binder_id,         line_cd,              binder_yy,
                                    binder_seq_no,         ri_cd,                ri_tsi_amt,
                                    ri_shr_pct,            ri_prem_amt,          ri_comm_rt,
                                    ri_comm_amt,           prem_tax,             eff_date,
                                    expiry_date,           binder_date,          create_binder_date,
                                    attention,             endt_text,            policy_id,
                                    iss_cd,                user_id,              last_update )
                            VALUES (v_binder_id,           p_line_cd,            v_yy,
                                    v_fbndr_seq_no,        p_ri_cd,              0,
                                    0,                     0,                    0,
                                    0,                     0,                    p_eff_date,
                                    p_expiry_date,         p_dsp_binder_date,    SYSDATE,
                                    v_attention,           p_dsp_endttext,       p_policy_id,
                                    p_iss_cd,              p_user_id,            SYSDATE );

            INSERT INTO giri_endttext(policy_id,        ri_cd,      fnl_binder_id,
                                      remarks,          user_id,    last_update)
                              VALUES (p_policy_id,      p_ri_cd,    v_binder_id,
                                      p_remarks,        p_user_id,  SYSDATE);

            FOR A2 IN (SELECT fbndr_seq_no
                         FROM giis_fbndr_seq
                        WHERE line_cd = p_line_cd
                          AND fbndr_yy = v_yy)
            LOOP
                IF A2.fbndr_seq_no < v_fbndr_seq_no THEN
                    UPDATE giis_fbndr_seq
                       SET fbndr_seq_no = v_fbndr_seq_no,
                           user_id      = p_user_id,
                           last_update  = SYSDATE
                     WHERE line_cd = p_line_cd
                       AND fbndr_yy = v_yy;
                END IF;
            END LOOP;

        END IF;
    END;

END giri_endttext_pkg;
/


