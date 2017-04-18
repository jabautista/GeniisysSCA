DROP PROCEDURE CPI.UPDATE_PAR_STATUS2;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_PAR_STATUS2 (
    p_par_id        IN GIPI_PARLIST.par_id%TYPE,
    p_pol_flag        IN GIPI_WPOLBAS.pol_flag%TYPE,
    p_endt_tax_sw    IN VARCHAR2,
    p_par_status    OUT GIPI_PARLIST.par_status%TYPE,
    p_ins_winvoice    OUT VARCHAR2)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 07.29.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure assign correct value to par_status
    **                    : based on the given parameters
    */
    v_invoice_sw     VARCHAR2(1) := 'N';
    v_exist            VARCHAR2(1) := 'N';
    v_perl            VARCHAR2(1) := 'N';
    v_exist1        VARCHAR2(1) := 'N';
    v_perl1            VARCHAR2(1) := 'N';
BEGIN
    IF p_pol_flag = '4' THEN
        p_par_status := 5;
        RETURN;
    END IF;
    
    p_ins_winvoice := 'N';
    
    IF p_endt_tax_sw = 'Y' THEN
        p_par_status := 5;
        p_ins_winvoice := 'Y';
    --ELSIF p_endt_tax_sw = 'X' THEN -- replaced by: Nica 05.10.2012
    ELSE
        FOR b IN (
            SELECT 'a'
              FROM GIPI_WINVOICE
             WHERE par_id = p_par_id
               AND property IS NOT NULL)
        LOOP
            p_par_status := 6;
            v_invoice_sw := 'Y';
            EXIT;
        END LOOP;
        
        IF v_invoice_sw = 'N' THEN
            FOR A1 IN (
                SELECT b480.item_no item
                  FROM GIPI_WITEM b480
                 WHERE b480.par_id = p_par_id
                   AND b480.rec_flag = 'A')
            LOOP
                v_perl := 'N';
                v_exist := 'Y';
                
                FOR A2 IN (
                    SELECT 1
                      FROM GIPI_WITMPERL b490
                     WHERE b490.par_id = p_par_id
                       AND b490.item_no = A1.item)                    
                LOOP
                    v_perl := 'Y';
                    EXIT;
                END LOOP;
                
                IF v_perl = 'Y' THEN
                    EXIT;
                END IF;
            END LOOP;
            
            IF v_exist = 'N' THEN
                FOR A1 IN (
                    SELECT b480.item_no item
                      FROM GIPI_WITEM b480
                     WHERE b480.par_id = p_par_id
                       AND b480.rec_flag <> 'A')
                LOOP
                    v_exist1 := 'Y';
                    
                    FOR A2 IN (
                        SELECT 1
                          FROM GIPI_WITMPERL b490
                         WHERE b490.par_id = p_par_id
                           AND b490.item_no = A1.item)
                    LOOP
                        v_perl1 := 'Y';
                        EXIT;
                    END LOOP;
                END LOOP;
                
                IF v_perl1 = 'Y' THEN
                    p_par_status := 5;
                ELSIF v_exist1 = 'Y' THEN
                    p_par_status := 4;
                ELSE
                    p_par_status := 3;
                END IF;
            ELSE
                IF v_perl = 'N' THEN
                    p_par_status := 4;
                ELSE
                    p_par_status := 5;
                END IF;
            END IF;
        END IF;
    END IF;
    
    IF p_par_status IS NOT NULL THEN
        -- added by andrew - 05.18.2011
        UPDATE GIPI_PARLIST
           SET par_status = p_par_status
         WHERE par_id = p_par_id;
    END IF;
END UPDATE_PAR_STATUS2;
/


