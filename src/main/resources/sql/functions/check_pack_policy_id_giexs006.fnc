DROP FUNCTION CPI.CHECK_PACK_POLICY_ID_GIEXS006;

CREATE OR REPLACE FUNCTION CPI.check_pack_policy_id_giexs006(
    p_pack_policy_id  giex_pack_expiry.pack_policy_id%TYPE
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
END;
/


