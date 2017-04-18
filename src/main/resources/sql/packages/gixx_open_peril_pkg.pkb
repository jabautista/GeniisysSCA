CREATE OR REPLACE PACKAGE BODY CPI.GIXX_OPEN_PERIL_PKG AS

  FUNCTION get_pol_doc_operil(p_extract_id   GIXX_OPEN_PERIL.extract_id%TYPE)
    RETURN pol_doc_operil_tab PIPELINED IS
	v_operil				  pol_doc_operil_type;
  BEGIN
    FOR i IN (SELECT  A.EXTRACT_ID EXTRACT_ID, 
                	  RTRIM(LTRIM(TO_CHAR(NVL(A.PREM_RATE, 0)))) OPERIL_PREM_RATE,
                	  '- '||LTRIM(TO_CHAR(A.PREM_RATE,'90.999999'))||' %' OPERIL_PREM_RATE2,
               		  B.PERIL_NAME OPERIL_PERIL_NAME,
               		  nvl(B.PERIL_LNAME, B.PERIL_NAME)	OPERIL_LNAME,
			  		  LTRIM(A.REMARKS) REMARKS,
               		  '- '||LTRIM(TO_CHAR(A.PREM_RATE,'90.999999'))||' % '||A.REMARKS RATE_REMARKS					 
   				FROM GIXX_OPEN_PERIL A,GIIS_PERIL B
			   WHERE A.PERIL_CD = B.PERIL_CD
      		     AND A.LINE_CD  = B.LINE_CD
	  			 AND EXTRACT_ID = p_extract_id)
	LOOP
	  v_operil.EXTRACT_ID 		  := i.EXTRACT_ID;
	  v_operil.OPERIL_PREM_RATE   := i.OPERIL_PREM_RATE;
	  v_operil.OPERIL_PREM_RATE2  := i.OPERIL_PREM_RATE2;
	  v_operil.OPERIL_PERIL_NAME  := i.OPERIL_PERIL_NAME;
	  v_operil.OPERIL_LNAME 	  := i.OPERIL_LNAME;
	  v_operil.REMARKS 			  := i.REMARKS;
	  v_operil.RATE_REMARKS 	  := i.RATE_REMARKS;
	  PIPE ROW(v_operil);
	END LOOP;
	RETURN;
  END get_pol_doc_operil;
  
  FUNCTION prem_rate_exists(p_extract_id   GIXX_OPEN_PERIL.extract_id%TYPE) 
    RETURN VARCHAR2 IS
	v_rate		gixx_open_peril.prem_rate%type;
  BEGIN
    FOR a IN (
		    SELECT PREM_RATE
		      FROM GIXX_OPEN_PERIL
		     WHERE (PREM_RATE = 0 OR PREM_RATE IS NULL)
		       AND EXTRACT_ID = p_extract_id
        	)
    LOOP
  	  v_RATE := A.PREM_RATE;
  	  EXIT;
    END LOOP;
    IF v_RATE IS NULL THEN
  	  return ('Y');
    ELSE
  	  RETURN ('N');
    END IF;  	
  END prem_rate_exists;
  
  FUNCTION prem_rate_exists2(p_extract_id   GIXX_OPEN_PERIL.extract_id%TYPE) 
    RETURN VARCHAR2 IS
	v_peril		giis_peril.peril_name%type;	
  BEGIN
	FOR a IN (
  	         SELECT B.PERIL_NAME PREM_RATE
   		       FROM GIXX_OPEN_PERIL A,GIIS_PERIL B
		      WHERE A.PERIL_CD = B.PERIL_CD
     	        AND A.LINE_CD  = B.LINE_CD
     	        AND EXTRACT_ID = p_extract_id)
    LOOP
   	  v_PERIL := a.prem_rate;
      EXIT;
    END LOOP;
    IF v_PERIL IS NULL THEN 
   	  RETURN ('N');
    ELSE	 	
  	  RETURN ('Y');
    END IF;
  END prem_rate_exists2;
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 11, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves open peril list
  */
  FUNCTION get_open_peril_list(
        p_extract_id            gixx_open_peril.extract_id%TYPE,
        p_geog_cd               gixx_open_peril.geog_cd%TYPE
  ) RETURN open_peril_tab PIPELINED
  IS
    v_open_peril    open_peril_type;
  BEGIN
    FOR rec IN (SELECT extract_id, geog_cd,
                       line_cd, peril_cd, 
                       prem_rate, remarks
                  FROM gixx_open_peril
                 WHERE extract_id = p_extract_id
                   AND geog_cd = p_geog_cd)
    LOOP
        v_open_peril.extract_id := rec.extract_id;
        v_open_peril.geog_cd := rec.geog_cd;
        v_open_peril.line_cd := rec.line_cd;
        v_open_peril.peril_cd := rec.peril_cd;
        v_open_peril.prem_rate := rec.prem_rate;
        v_open_peril.remarks := rec.remarks;
        
        FOR a IN (SELECT peril_name, peril_type
                    FROM giis_peril
                   WHERE line_cd = rec.line_cd
                     AND peril_cd = rec.peril_cd)
        LOOP
            v_open_peril.peril_name := a.peril_name;
            v_open_peril.peril_type := a.peril_type;
        END LOOP;
        
        PIPE ROW(v_open_peril);
        
    END LOOP;
    
  END get_open_peril_list;

END GIXX_OPEN_PERIL_PKG;
/


