DROP PROCEDURE CPI.UPDATE_PACK_PAR_STATUS2;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_PACK_PAR_STATUS2 (
	p_par_id		IN GIPI_PACK_PARLIST.pack_par_id%TYPE,
	p_pol_flag		IN GIPI_PACK_WPOLBAS.pol_flag%TYPE,
	p_endt_tax_sw	IN VARCHAR2,
	p_v_endt		IN VARCHAR2,
	p_par_status	OUT GIPI_PACK_PARLIST.par_status%TYPE,
	p_ins_winvoice	OUT VARCHAR2)
AS
	/*
	**  Created by		: Emman
	**  Date Created 	: 11.26.2010
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	: This procedure assign correct value to par_status
	**					: based on the given parameters
	*/
	v_invoice_sw 	VARCHAR2(1) := 'N';
	v_exist			VARCHAR2(1) := 'N';
	v_perl			VARCHAR2(1) := 'N';
	v_exist1		VARCHAR2(1) := 'N';
	v_perl1			VARCHAR2(1) := 'N';
    variables_par_id GIPI_PARLIST.par_id%TYPE; -- added by andrew 09.05.2011
BEGIN
    FOR c1 IN (SELECT a.par_id  -- andrew 09.02.2011 - added loop, based on pre-commit trigger of gipis031a module
                FROM gipi_parlist a 
               WHERE 1=1
                 AND a.pack_par_id = p_par_id
                 AND a.par_status NOT IN (98,99)) 	
    LOOP  
        variables_par_id := c1.par_id; -- added by andrew 09.05.2011
        
        IF p_pol_flag = '4' THEN
            p_par_status := 5;
            UPDATE gipi_parlist
               SET par_status = 5
             WHERE pack_par_id = p_par_id;
            RETURN;
        END IF;
    	
        p_ins_winvoice := 'N';
    	
        IF p_endt_tax_sw = 'Y' AND p_v_endt = 'Y' THEN
            p_par_status := 5;
             UPDATE gipi_parlist
                SET par_status = 5
              WHERE pack_par_id = p_par_id
                AND par_status NOT IN (98,99);
    		
            p_ins_winvoice := 'Y';
        ELSIF p_endt_tax_sw = 'X' THEN
            FOR b IN (
                SELECT 'a'
                  FROM GIPI_WINVOICE
                 WHERE par_id = variables_par_id -- p_par_id
                   AND property IS NOT NULL)
            LOOP
                p_par_status := 6;
                UPDATE gipi_parlist
                   SET par_status = 6
                 WHERE pack_par_id = p_par_id
                   AND par_status NOT IN (98,99);
                v_invoice_sw := 'Y';
                EXIT;
            END LOOP;
    		
            IF v_invoice_sw = 'N' THEN
                FOR A1 IN (
                    SELECT b480.item_no item
                      FROM GIPI_WITEM b480
                     WHERE b480.par_id = variables_par_id -- p_par_id
                       AND b480.rec_flag = 'A')
                LOOP
                    v_perl := 'N';
                    v_exist := 'Y';
    				
                    FOR A2 IN (
                        SELECT 1
                          FROM GIPI_WITMPERL b490
                         WHERE b490.par_id = variables_par_id -- p_par_id
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
                         WHERE b480.par_id = variables_par_id -- p_par_id
                           AND b480.rec_flag <> 'A')
                    LOOP
                        v_exist1 := 'Y';
    					
                        FOR A2 IN (
                            SELECT 1
                              FROM GIPI_WITMPERL b490
                             WHERE b490.par_id = variables_par_id -- p_par_id
                               AND b490.item_no = A1.item)
                        LOOP
                            v_perl1 := 'Y';
                            EXIT;
                        END LOOP;
                    END LOOP;
    				
                    IF v_perl1 = 'Y' THEN
                        p_par_status := 5;
                        UPDATE gipi_parlist
                           SET par_status = 5
                         WHERE pack_par_id = p_par_id
                           AND par_status NOT IN (98,99);  
                    ELSIF v_exist1 = 'Y' THEN
                        p_par_status := 4;
                         UPDATE gipi_parlist
                            SET par_status = 4
                          WHERE pack_par_id = p_par_id
                            AND par_status NOT IN (98,99);
                    ELSE
                        p_par_status := 3;
                        UPDATE gipi_parlist
                           SET par_status = 3
                         WHERE pack_par_id = p_par_id
                           AND par_status NOT IN (98,99);
                    END IF;
                ELSE
                    IF v_perl = 'N' THEN
                        p_par_status := 4;
                        UPDATE gipi_parlist
                           SET par_status = 4
                         WHERE pack_par_id = p_par_id
                           AND par_status NOT IN (98,99);
                    ELSE
                        p_par_status := 5;
                         UPDATE gipi_parlist
                            SET par_status = 5
                          WHERE pack_par_id = p_par_id
                            AND par_status NOT IN (98,99);
                    END IF;
                END IF;
            END IF;
        END IF;
    END LOOP;    
END UPDATE_PACK_PAR_STATUS2;
/


