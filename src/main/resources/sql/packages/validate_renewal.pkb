CREATE OR REPLACE PACKAGE BODY CPI.VALIDATE_RENEWAL
AS
    FUNCTION CHECK_DIST(P_POLICY_ID NUMBER)
        RETURN NUMBER IS
        V_CHECK         NUMBER(1)   :=  0;
        V_SHARE_CD   giuw_policyds_dtl.share_cd%TYPE;

    BEGIN
        FOR A IN (SELECT DISTINCT gpd.POLICY_ID
                                        ,gpd.DIST_NO
                                        ,gid.SHARE_CD, SUM(gid.DIST_SPCT) DIST_SPCT
                            FROM GIUW_POL_DIST gpd, GIUW_POLICYDS_DTL gid
                        WHERE 1=1
                            AND gpd.DIST_NO = gid.DIST_NO
                            AND gpd.DIST_fLAG ='3'
                            AND gpd.policy_id = p_policy_id
                        GROUP BY gpd.POLICY_ID,gpd.DIST_NO,gid.SHARE_CD
                        ORDER BY gpd.POLICY_ID,gpd.DIST_NO,gid.SHARE_CD)
        LOOP
            IF a.dist_spct = 100 THEN
                v_share_cd := a.share_cd;
            END IF;
            EXIT;
        END LOOP;

        IF v_share_cd <> GIISP.N('NET_RETENTION') THEN
            v_check := 0;
        ELSE
            v_check := 1;
        END IF;

    RETURN(v_check);

    END CHECK_DIST;

    FUNCTION POSTING_LIMIT(p_user VARCHAR2
                                                            , p_iss_cd  VARCHAR2
                                                            , p_line_cd VARCHAR2
                                                            , p_tsi_amt VARCHAR2)
        RETURN NUMBER
    IS

  v_return          NUMBER(1);

    BEGIN
        v_return    := 0;
        FOR A IN ( SELECT ALL_AMT_SW
                            , POST_LIMIT
                        FROM   GIIS_POSTING_LIMIT
                        WHERE POSTING_USER    = p_user
                            AND ISS_CD          = p_iss_cd
                            AND LINE_CD         = p_line_cd)
        LOOP
            IF a.all_amt_sw ='Y' OR a.post_limit >= p_tsi_amt THEN
                v_return := 1;
            ELSE
                v_return := 0;
            END IF;
        END LOOP;

    RETURN v_return;

    END POSTING_LIMIT;

END VALIDATE_RENEWAL;
/


