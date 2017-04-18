CREATE OR REPLACE PROCEDURE CPI.validate_coc_authentication
    (p_par_id    IN GIPI_PARLIST.par_id%TYPE, 
     p_use_default_tin IN VARCHAR2,
     p_msg_alert OUT VARCHAR2) AS
     
   v_assd_no        GIPI_WPOLBAS.assd_no%TYPE;
   v_incept_date    GIPI_WPOLBAS.incept_date%TYPE;
   v_expiry_date    GIPI_WPOLBAS.expiry_date%TYPE;
   v_line_cd        GIPI_WPOLBAS.line_cd%TYPE;
   v_assd_tin       GIIS_ASSURED.assd_tin%TYPE;
   v_no_assd_tin_msg VARCHAR2(1000);
   
   
   /*
   **  Created by   : Veronica V. Raymundo
   **  Date Created : October 29, 2012
   **  Reference By : (GIPIS055 - POST PAR)
   **  Description  : Validates if values for required fields in 
   **                 COC authentication if missing.
   */
     
BEGIN
    BEGIN
        SELECT assd_no, incept_date, expiry_date, line_cd
        INTO v_assd_no, v_incept_date, v_expiry_date, v_line_cd
        FROM GIPI_WPOLBAS
        WHERE par_id = p_par_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        raise_application_error(-20001, 'Geniisys Exception#I#No Data found in GIPI_WPOLBAS.');        
    END;
    
    
    BEGIN
        SELECT assd_no, assd_tin 
        INTO v_assd_no, v_assd_tin
        FROM GIIS_ASSURED
        WHERE assd_no  = v_assd_no;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        raise_application_error(-20001, 'Geniisys Exception#I#Assured is not existing in GIIS_ASSURED.');  
    END;
    
    IF v_assd_tin IS NULL AND p_use_default_tin <> 'Y'
    THEN                       
        IF GIISP.V('DEFAULT_COCAF_ASSD_TIN') IS NOT NULL THEN
            v_no_assd_tin_msg := 'Geniisys Exception#COC_NO_TIN#The assured has no TIN, please enter TIN for the assured in Assured Maintenance '
                                 || ' or press Proceed button to use the default TIN for COC Authentication.';
        ELSE
            v_no_assd_tin_msg := 'Geniisys Exception#I#The assured has no TIN, please enter TIN for the assured in Assured Maintenance.';
        END IF;
        
        raise_application_error(-20001, v_no_assd_tin_msg);
        RETURN;
    END IF;
    
    
    FOR i IN (SELECT a.item_no 
              FROM GIPI_WITEM a,
                   GIPI_WITMPERL b
            WHERE a.par_id = p_par_id
              AND a.par_id = b.par_id
              AND a.item_no = b.item_no
              AND NVL(b.rec_flag, 'A') = 'A'
              AND b.line_cd = v_line_cd
              AND b.peril_cd = GIISP.n('CTPL'))
    LOOP
        FOR m IN (SELECT item_no, coc_type, coc_serial_no, coc_yy,  
                         motor_no, serial_no, plate_no, mv_file_no, 
                         reg_type, mv_type, mv_prem_type--,tax_type 
                    FROM GIPI_WVEHICLE
                   WHERE par_id = p_par_id
                     AND item_no = i.item_no)
        LOOP
            IF m.reg_type IS NULL THEN
              raise_application_error(-20001, 'Geniisys Exception#I#Please enter value for Registration Type in Item Information to proceed with COC authentication. '
                                           || 'If you wish to continue with policy posting only, please uncheck the COC Authentication option.');             
            ELSIF m.reg_type = 'N' THEN
              IF (m.coc_type IS NULL OR 
                  m.coc_serial_no IS NULL OR 
                  m.coc_yy IS NULL OR
                  m.motor_no IS NULL OR 
                  m.serial_no IS NULL OR
                  m.mv_type IS NULL OR
                  m.mv_prem_type IS NULL
                )THEN
                    raise_application_error(-20001, 'Geniisys Exception#I#The following fields are required in COC authentication of new registration. '
                                                    || 'Please check if value for these fields are existing in items which will be authenticated. '
                                                    || '<ul><li>COC No.</li><li>MV Type</li><li>MV Prem Type</li>'
                                                    || '<li>Chassis/Serial No</li><li>Motor/Eng No.</li></ul>'
                                                    || 'If you wish to continue with policy posting only, please uncheck the COC Authentication option.');
              END IF;             
            ELSIF m.reg_type = 'R' THEN
              IF (m.coc_type IS NULL OR 
                  m.coc_serial_no IS NULL OR 
                  m.coc_yy IS NULL OR
                  m.motor_no IS NULL OR 
                  m.serial_no IS NULL OR
                  m.plate_no IS NULL OR
                  m.mv_file_no IS NULL OR
                  m.mv_type IS NULL OR
                  m.mv_prem_type IS NULL
                )THEN
                    raise_application_error(-20001, 'Geniisys Exception#I#The following fields are required in COC authentication of renewal registration. '
                                                    || 'Please check if value for these fields are existing in items which will be authenticated. '
                                                    || '<ul><li>COC No.</li><li>Plate No.</li><li>MV File No.</li><li>MV Type</li><li>MV Prem Type</li>'
                                                    || '<li>Chassis/Serial No</li><li>Motor/Eng No.</li></ul> '                                                    
                                                    || 'If you wish to continue with policy posting only, please uncheck the COC Authentication option.');
            END IF; 
          END IF;                        
        END LOOP;
        
    END LOOP;
    
END; 
/

