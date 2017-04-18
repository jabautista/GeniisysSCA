DROP FUNCTION CPI.FULLNAME;

CREATE OR REPLACE FUNCTION CPI.FullName (x_name varchar2) RETURN varchar2 is
    v_name varchar2(250);
    v_switch boolean;
	v_enclose varchar2(250);
BEGIN
    v_name := upper(x_name);
	IF sign(instr(v_name, ' ,')) = 1 then
	   v_name := replace(v_name, ' ,', ',');
	END IF;
	IF sign(instr(v_name, ',')) = 1 then
	   v_name := replace(v_name, ',', ', ');
	END IF;
	WHILE sign(instr(v_name, '   ')) = 1 LOOP
      v_name := replace(v_name, '   ', ' ');
	END LOOP;
  	WHILE sign(instr(v_name, '  ')) = 1 LOOP
      v_name := replace(v_name, '  ', ' ');
	END LOOP;
    v_switch := FALSE;
	v_enclose := ' ';
	IF (    sign(instr(v_name, ', '    ))) *
	   (1 - sign(instr(v_name, ', INC' ))) *
       (1 - sign(instr(v_name, ', CORP'))) *
       (1 - sign(instr(v_name, ', JR' ))) = 1 then
       v_switch := TRUE;
       v_name := substr(v_name, instr(v_name, ', ') + 2) || ' ' || substr(v_name, 1, instr(v_name, ', ') - 1);
	END IF;
	IF sign(instr(v_name, '(')) * sign(instr(v_name, ')')) = 1 then
       v_switch := TRUE;
	   v_enclose := substr(v_name, instr(v_name, '('), instr(v_name, ')') - instr(v_name, '(') + 1);
	   v_name := replace(v_name, v_enclose, '');
	END IF;
	IF sign(instr(v_name, 'CEBU BRANCH')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, 'CEBU BRANCH', ' ');
	END IF;
	IF sign(instr(v_name, 'DAVAO BRANCH')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, 'DAVAO BRANCH', ' ');
	END IF;
	IF sign(instr(v_name, '*')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, '*', ' ');
	END IF;
	IF sign(instr(v_name, '-')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, '-', ' ');
	END IF;
	IF sign(instr(v_name, 'DONT USE THIS CODE ANYMORE')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, 'DONT USE THIS CODE ANYMORE', ' ');
	END IF;
	IF sign(instr(v_name, 'DON''T USE THIS CODE')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, 'DONT USE THIS CODE ANYMORE', ' ');
	END IF;
	IF sign(instr(v_name, 'DO NOT USE THIS CODE')) = 1 then
       v_switch := TRUE;
	   v_name := replace(v_name, 'DO NOT USE THIS CODE', ' ');
	END IF;
	WHILE sign(instr(v_name, '   ')) = 1 LOOP
      v_name := replace(v_name, '   ', ' ');
	END LOOP;
  	WHILE sign(instr(v_name, '  ')) = 1 LOOP
      v_name := replace(v_name, '  ', ' ');
	END LOOP;
    v_name := rtrim(ltrim(v_name)) || ' ' || v_enclose;
    RETURN v_name;
END;
/


