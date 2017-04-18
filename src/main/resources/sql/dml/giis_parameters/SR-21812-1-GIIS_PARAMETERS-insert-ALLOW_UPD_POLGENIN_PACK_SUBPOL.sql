SET SERVEROUTPUT ON;

DECLARE
    v_exists NUMBER(1) := 0;
BEGIN
    SELECT 1
      INTO v_exists
      FROM cpi.giis_parameters
     WHERE param_name = 'ALLOW_UPD_POLGENIN_PACK_SUBPOL';
     
     DBMS_OUTPUT.PUT_LINE('ALLOW_UPD_POLGENIN_PACK_SUBPOL already exists in GIIS_PARAMETERS');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    INSERT INTO cpi.giis_parameters(
        param_type,
        param_name,
        param_value_v,
        user_id,
        last_update,
        remarks
    ) VALUES(
        'V',
        'ALLOW_UPD_POLGENIN_PACK_SUBPOL',
        'N',
        USER,
        SYSDATE,
        'This parameter will indicate if the clients allows update of text info (initial/general/endt) of sub-policies of a package policy.'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ALLOW_UPD_POLGENIN_PACK_SUBPOL is successfully inserted to GIIS_PARAMETERS');
END;
