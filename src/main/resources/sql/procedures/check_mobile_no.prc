DROP PROCEDURE CPI.CHECK_MOBILE_NO;

CREATE OR REPLACE PROCEDURE CPI.check_mobile_no(p_cell_no  IN     VARCHAR2,
                                             p_msg      OUT    VARCHAR2,
                                             p_network  OUT    VARCHAR2)

IS
    v_msg           varchar2(100) := '';
    v_def_check     number;
    
BEGIN
     --p_msg := 'SUCCESS';
     validate_mobile_no('SUN_NUMBER', p_cell_no , 'all', v_msg, v_def_check);
     IF v_msg != 'SUCCESS' THEN
        p_msg := v_msg;
        RETURN;        
     ELSIF v_def_check = 0 THEN
        validate_mobile_no('GLOBE_NUMBER', p_cell_no , 'all', v_msg, v_def_check);
        IF v_msg != 'SUCCESS' THEN
            p_msg := v_msg;
            RETURN;  
        ELSIF v_def_check = 0 THEN
            validate_mobile_no('SMART_NUMBER', p_cell_no , 'all', v_msg, v_def_check);
            IF v_msg != 'SUCCESS' THEN
                p_msg := v_msg;
                RETURN;  
            ELSIF v_def_check = 1 THEN
                p_msg := 'SUCCESS';
                p_network := 'SMART';
            END iF; 
        ELSIF v_def_check = 1 THEN
            p_msg := 'SUCCESS';
            p_network := 'GLOBE';
        END iF; 
     ELSIF v_def_check = 1 THEN
        p_msg := 'SUCCESS';
        p_network := 'SUN';
     END IF;
     
     RETURN;
END;
/


