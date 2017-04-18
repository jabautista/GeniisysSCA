DROP PROCEDURE CPI.VALIDATE_MOBILE_NO;

CREATE OR REPLACE PROCEDURE CPI.validate_mobile_no (param IN varchar2,
                                                field IN varchar2,
                                                ctype IN varchar2,
                                                p_msg OUT varchar2,
                                                p_def_check OUT NUMBER) 
IS
    v_msg                      varchar2(100)         := 'SUCCESS';
    v_def_check                NUMBER;                                                                                                                                                                                                                   /*COMMENTS:*/    
    v_length                   number                := validate_mobile_prefix(field);                                                                             --checks if the prefix given is valid starts with either 09, or 639 or +639
    v_prefix                   varchar2(50)          := (substr(field,nvl(instr(substr(field,1,length(field)-7),'9'),0),3)); --input cell no's prefix
    v_prefix_motype            varchar2(50);                                                                                                                                                     --passes the valid smart prefixes
    v_flag                     boolean               := false;                                                                                                                                --serves as flag to check if the input cell no is valid
    v_val                      varchar2(50)           := null;                                                                                                                                 --checking of character
    a                          number;
BEGIN
  IF INSTR(field,'+')=1 THEN
       a := 2;
  ELSE
       a := 1;
  END IF;
  
    FOR i in a..length(field)                                                                                                                                                                  --checks the entered cell no for invalid characters
    LOOP
         v_val := substr(field,i,1);
         IF ascii(v_val) not between 48 and 57 then
               v_msg := 'Invalid mobile number';
         END IF;
    END LOOP;
    
    IF LENGTH(field) <> v_length THEN --NVL(v_length,length(field)+1) THEN                                                                        --checks the length of cell number if valid
       v_msg := 'Invalid mobile number';
       --msg_alert('Invalid mobile number','I',true);
    ELSE
        /*SELECT param_value_v 
      INTO v_prefix_motype
      FROM GIIS_PARAMETERS
      WHERE PARAM_NAME LIKE param ;    --retrieves the possible prefixes of globe/sun/smart lines

        LOOP
            IF NOT (v_prefix = substr(v_prefix_motype,1,3)) THEN
                 v_flag := FALSE; --entered cell number did not satisfy the given possible prefixes of a mobile co.
             ELSIF v_prefix = substr(v_prefix_motype,1,3) THEN
               v_flag := TRUE; --entered cell number satisfies the given possible prefixes of a mobile co.
            END IF;

          v_prefix_motype:= substr(v_prefix_motype,5,LENGTH(v_prefix_motype));
          EXIT WHEN v_prefix_motype IS NULL or v_flag = TRUE;

        END LOOP; */  --emcy da072905te: commented, replaced with:
        FOR i IN (SELECT INSTR(param_value_v,v_prefix)
                              FROM giis_parameters
                             WHERE param_name LIKE param
                               AND INSTR(param_value_v,v_prefix) <> 0)
        LOOP
            v_flag := TRUE;                                                                                                                                                                           --entered cell number satisfies the given possible prefixes of a mobile network.
        END LOOP;
        
        IF v_flag = FALSE THEN
             IF ctype <> 'all' THEN
                    v_def_check:=2;               
                    v_msg := 'Invalid ' || ctype || ' mobile number';    
             ELSIF ctype = 'all' THEN
                  v_def_check:=0;
             END IF;
        ELSIF v_flag = TRUE THEN
           v_def_check := 1;      
        END IF;
        p_msg := v_msg;
        p_def_check := v_def_check;
                
    END IF;
END;
/


