DROP FUNCTION CPI.GET_MOTORCOVERAGE;

CREATE OR REPLACE FUNCTION CPI.Get_Motorcoverage(v_extract_id 	NUMBER,
                                             v_item_no 	  	NUMBER) RETURN VARCHAR2 IS
  TYPE tpe IS TABLE OF GIIS_PERIL.peril_sname%TYPE;
  d_combo tpe := tpe();
  l_d tpe     := tpe();
  exst BOOLEAN DEFAULT FALSE;

  v_coverage VARCHAR2(50);
  CURSOR cur(extid NUMBER, itmno NUMBER) IS SELECT b.peril_sname
									          FROM GIXX_ITMPERIL a, GIIS_PERIL b
									         WHERE a.line_cd  = b.line_cd
									           AND a.peril_cd = b.peril_cd
									           AND extract_id = extid
									           AND item_no    = itmno;

  FUNCTION getCombo RETURN BOOLEAN IS
      v_boolean BOOLEAN DEFAULT FALSE;
  BEGIN
      FOR i IN l_d.FIRST..l_d.LAST LOOP
          FOR j IN d_combo.FIRST..d_combo.LAST LOOP
              IF l_d(i) = d_combo(j) THEN
                 d_combo.DELETE(j);
                 v_boolean := TRUE;
              ELSE
                 v_boolean := FALSE;
              END IF;
          END LOOP;
      END LOOP;
      d_combo.DELETE;
      RETURN v_boolean;
  END getCombo;

BEGIN
  OPEN cur(v_extract_id, v_item_no);
  FETCH cur BULK COLLECT INTO l_d;

  --CTPL ONLY
  IF l_d.COUNT = 1 THEN
     d_combo.EXTEND(l_d.COUNT);
     d_combo := tpe('CTPL');
     exst := getCombo();
     IF exst THEN
        v_coverage := 'CTPL ONLY';
     END IF;

  ELSIF l_d.COUNT = 2 THEN
     --COMPREHENSIVE 1
     d_combo.EXTEND(l_d.COUNT);
     d_combo := tpe('CTPL', 'ODTH');
     exst := getCombo();
     IF exst THEN
        v_coverage := 'COMPREHENSIVE';
     END IF;
     --VTPL - BI/PD
     IF NOT exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'VTPL - BI/PD';
        END IF;
     END IF;
  ELSIF l_d.COUNT = 3 THEN
     --COMPREHENSIVE W/O CTPL 1
     d_combo.EXTEND(l_d.COUNT);
     d_combo := tpe('V3BI', 'V3PL', 'OD');
     exst := getCombo();
     IF exst THEN
        v_coverage := 'COMPREHENSIVE W/O CTPL';
     END IF;
     --COMPREHENSIVE W/O CTPL 2
     IF NOT exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'ODTH');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE W/O CTPL';
        END IF;
     END IF;
	 --COMPREHENSIVE 4
	 IF NOT exst THEN
	 	d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('ODTH', 'CTPL', 'AUPA');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE';
        END IF;
	 END IF;	 
     --CTPL + VTPL - BI/PD
     IF NOT exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'CTPL');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'CTPL + VTPL - BI/PD';
        END IF;
     END IF;

  ELSIF l_d.COUNT = 4 THEN
     --COMPREHENSIVE 2
     IF exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'OD', 'CTPL');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE';
        END IF;
     END IF;
     --COMPREHENSIVE 3
     IF NOT exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'ODTH', 'CTPL');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE';
        END IF;
     END IF;
	 --COMPREHENSIVE W/O CTPL 3
	 IF NOT exst THEN
	 	d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'ODTH', 'AUPA');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE W/O CTPL';
        END IF;
	 END IF;
	 --COMPREHENSIVE W/O CTPL 4
	 IF NOT exst THEN
	 	d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'OD', 'AUPA');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE W/O CTPL';
        END IF;
	 END IF;
  ELSIF l_d.COUNT = 5 THEN
     --COMPREHENSIVE 5
     IF exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'OD', 'CTPL', 'AUPA');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE';
        END IF;
     END IF;
	 --COMPREHENSIVE 6
     IF exst THEN
        d_combo.EXTEND(l_d.COUNT);
        d_combo := tpe('V3BI', 'V3PL', 'ODTH', 'CTPL', 'AUPA');
        exst := getCombo();
        IF exst THEN
           v_coverage := 'COMPREHENSIVE';
        END IF;
     END IF;
  ELSIF l_d.COUNT = 0 THEN
  	 v_coverage := NULL;
  END IF;

  RETURN v_coverage;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END Get_Motorcoverage;
/


