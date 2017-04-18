DROP FUNCTION CPI.GET_TAX_PERIL_CD;

CREATE OR REPLACE FUNCTION CPI.GET_TAX_PERIL_CD
(p_line_cd      GIIS_TAX_PERIL.line_cd%TYPE,
 p_iss_cd       GIIS_TAX_PERIL.iss_cd%TYPE,
 p_tax_cd       GIIS_TAX_PERIL.tax_cd%TYPE,
 p_peril_sw     GIIS_TAX_CHARGES.peril_sw%TYPE)
 
 RETURN GIIS_TAX_PERIL.peril_cd%TYPE
 
 AS
 
 v_peril_cd         GIIS_TAX_PERIL.peril_cd%TYPE;     
 
 BEGIN
 
    IF p_peril_sw = 'Y' THEN    
        
        FOR v IN (SELECT peril_cd                                       
                  FROM GIIS_TAX_PERIL
                  WHERE iss_cd = p_iss_cd
                    AND line_cd = p_line_cd
                    AND tax_cd = p_tax_cd)
        LOOP
            v_peril_cd  := v.peril_cd;
        END LOOP;
           
    END IF;
    
    RETURN v_peril_cd;
 
 END;
/


