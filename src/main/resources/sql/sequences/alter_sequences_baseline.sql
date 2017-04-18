SET SERVEROUTPUT ON;

DECLARE
    v_cnt       NUMBER := 0;
BEGIN
    FOR i IN (SELECT *
                FROM all_sequences
               WHERE sequence_owner = 'CPI'
                 AND cache_size <> 0
               ORDER BY sequence_name)
    LOOP
        EXECUTE IMMEDIATE ('ALTER SEQUENCE ' || i.sequence_name || ' NOCACHE ');
        DBMS_OUTPUT.PUT_LINE ('Alter sequence: '||i.sequence_name );
                    
        v_cnt := v_cnt + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE (v_cnt || ' sequences altered.');
END;