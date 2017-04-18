DROP PROCEDURE CPI.CHANGES_IN_PAR_STATUS2;

CREATE OR REPLACE PROCEDURE CPI.CHANGES_IN_PAR_STATUS2 (
	p_par_id IN gipi_parlist.par_id%TYPE,
	p_dist_no IN giuw_pol_dist.dist_no%TYPE,
	p_line_cd IN gipi_parlist.line_cd%TYPE,
	p_iss_cd IN gipi_parlist.iss_cd%TYPE,
	p_invoice_sw IN VARCHAR2,
	p_item_grp IN gipi_witem.item_grp%TYPE,
	p_par_status OUT gipi_parlist.par_status%TYPE,
	p_v_pack_pol_flag OUT gipi_wpolbas.pack_pol_flag%TYPE,
	p_v_item_tag OUT VARCHAR2)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    08.26.2010    mark jm            This procedure returns message alert text after performing some validation
    **    01.20.2012    mark jm            added ommitted conditionin setting par_status to 5
	**	  05.08.2012    Nica			   commented condition that consider item_grp in retrieving records in gipi_winvoice
    */    
    v_par_status     gipi_parlist.par_status%TYPE;
    v_count            NUMBER;
    v_exist            NUMBER;
    v_exist2        NUMBER := 0;
    v_item_exists    VARCHAR2(1) := 'N';
    
    CURSOR C1 IS
        SELECT item_no
          FROM gipi_witem
         WHERE par_id = p_par_id;
BEGIN
    SELECT par_status
      INTO v_par_status
      FROM gipi_parlist
     WHERE par_id = p_par_id;
    
    SELECT COUNT(*)
      INTO v_count
      FROM gipi_witem
     WHERE par_id = p_par_id;
    
    FOR C1_rec IN C1
    LOOP
        BEGIN
            SELECT DISTINCT 1
              INTO v_exist
              FROM gipi_witmperl
             WHERE par_id = p_par_id
               AND line_cd = p_line_cd
               AND item_no = C1_rec.item_no;
            
            IF SQL%FOUND THEN
                v_exist2 := NVL(v_exist2, 0) + 1;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END LOOP;
    
    /* commented
    IF v_par_status < 3 THEN
        MSG_ALERT('Your status does not allow you to edit this PAR. '||
               'You will exit this form disregarding the changes you have made.', 'E', FALSE);
        :GLOBAL.EXIT_SW := 'Y';
    END IF;
    */
    
    SELECT par_status
      INTO v_par_status
      FROM gipi_parlist
     WHERE par_id = p_par_id;
    
    IF p_invoice_sw = 'Y' THEN
        gipis010_create_invoice_item(p_par_id, p_line_cd, p_iss_cd);
        create_distribution_item2(p_par_id, p_dist_no);
        
        IF v_par_status = 6 THEN
            UPDATE gipi_parlist
               SET par_status = 5
             WHERE par_id = p_par_id;
        END IF;
        
        gipis010_check_peril(p_par_id, p_par_status);    
    END IF;
    
    gipis010_upd_gipi_wpolbas(p_par_id);
    
    IF v_count = 0 THEN
        gipis010_par_status_3(p_par_id, p_v_pack_pol_flag, p_v_item_tag);
    ELSIF v_exist2 = 0 THEN
        p_par_status := 4;
        gipis010_par_status_4(p_par_id, p_v_pack_pol_flag, p_v_item_tag);
    ELSIF v_count = v_exist2 THEN
        SELECT par_status
          INTO v_par_status
          FROM gipi_parlist
         WHERE par_id = p_par_id;
         
        IF v_par_status = 6 THEN
            FOR A IN (
                SELECT property
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
                   --AND item_grp = p_item_grp) commented by: Nica 05.08.2012
            LOOP
                v_item_exists := 'Y';                
                EXIT;
            END LOOP;
            
            IF v_item_exists = 'N' THEN
                p_par_status := 5;
                gipis010_par_status_5(p_par_id);
            END IF;
        ELSE
            p_par_status := 5;
            gipis010_par_status_5(p_par_id);
        END IF;
    ELSE
        p_par_status := 4;
        gipis010_par_status_4(p_par_id, p_v_pack_pol_flag, p_v_item_tag);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END CHANGES_IN_PAR_STATUS2;
/


