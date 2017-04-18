DROP PROCEDURE CPI.CHANGES_IN_PAR_STATUS_ENDT;

CREATE OR REPLACE PROCEDURE CPI.CHANGES_IN_PAR_STATUS_ENDT (
	p_par_id		IN gipi_parlist.par_id%TYPE,
	p_dist_no		IN giuw_pol_dist.dist_no%TYPE,
	p_line_cd		IN gipi_parlist.line_cd%TYPE,
	p_iss_cd		IN gipi_parlist.iss_cd%TYPE,
	p_negate_item	IN VARCHAR2,
	p_prorate_flag	IN gipi_wpolbas.prorate_flag%TYPE,
	p_comp_sw		IN VARCHAR2,
	p_endt_exp_date	IN gipi_wpolbas.endt_expiry_date%TYPE,
	p_eff_date		IN gipi_wpolbas.eff_date%TYPE,
	p_exp_date		IN gipi_wpolbas.expiry_date%TYPE,
    p_short_rt_pct    IN gipi_wpolbas.short_rt_percent%TYPE,
    p_v_endt_tax_sw    OUT gipi_wendttext.endt_tax%TYPE)
AS
    /*
    **  Created by        : Mark JM
    **  Date Created    : 10.07.2010
    **  Reference By    : (GIPIS061 - Item Information - Casualty)
    **  Description     : Perform necessary actions based on the changes
    **                     : made in the gipi_witem table.  Specifically, 
    **                     : perform the necessary adjustments in the invoice
    **                     : tables, distribution tables and ri tables
    */
    v_a_item        VARCHAR2(1) := 'N';
    v_c_item        VARCHAR2(1) := 'N';
    v_a_perl        VARCHAR2(1) := 'N';
    v_c_perl        VARCHAR2(1) := 'N';    
    v_par_status    gipi_parlist.par_status%TYPE;
BEGIN
    FOR A IN (
        SELECT endt_tax
          FROM gipi_wendttext
         WHERE par_id = p_par_id)
    LOOP
        p_v_endt_tax_sw := A.endt_tax;
    END LOOP;
    
    FOR i IN (
        SELECT par_status
          FROM gipi_parlist
         WHERE par_id = p_par_id)
    LOOP
        v_par_status := i.par_status;
    END LOOP;
    
    IF v_par_status < 3 THEN
        RAISE_APPLICATION_ERROR(20000, 'Your status does not allow you to edit this PAR. '||
               'You will exit this form disregarding the changes you have made.');
    END IF;
    
    FOR A1 IN (
        SELECT b480.item_no item_no
          FROM gipi_witem b480
         WHERE b480.par_id = p_par_id
           AND b480.rec_flag = 'A')
    LOOP
        v_a_perl := 'N';
        v_a_item := 'Y';
        
        FOR A2 IN (
            SELECT '1'
              FROM gipi_witmperl b490
             WHERE b490.par_id = p_par_id
               AND b490.item_no = a1.item_no)
        LOOP
            v_a_perl := 'Y';
            EXIT;
        END LOOP;
        
        IF v_a_perl = 'N' THEN
            EXIT;
        END IF;
    END LOOP;
    
    IF v_a_item = 'N' THEN
        FOR A1 IN (
            SELECT '1'
              FROM gipi_witem b480
             WHERE b480.par_id = p_par_id)
        LOOP
            v_c_item := 'Y';
            
            FOR A2 IN (
                SELECT '1'
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id)
            LOOP
                v_c_perl := 'Y';
                EXIT;
            END LOOP;
            EXIT;
        END LOOP;
    END IF;
    
    Gipis010_Create_Invoice_Item(p_par_id, p_line_cd, p_iss_cd);
    Create_Distribution_Item_Endt(p_par_id, p_dist_no);
    
    IF v_a_item = 'N' AND v_c_perl = 'N' AND NVL(p_v_endt_tax_sw, 'N') = 'Y' THEN
        IF v_c_item = 'Y' THEN
            Gipi_Parlist_Pkg.update_par_status(p_par_id, 4);
            p_v_endt_tax_sw := 'N';
        ELSE
            Create_Winvoice1_Endt_Itmperl(p_par_id, p_line_cd, p_iss_cd);
            Gipi_Parlist_Pkg.update_par_status(p_par_id, 5);
        END IF;
    ELSIF v_a_perl = 'Y' OR v_c_perl = 'Y' THEN
        Gipi_Parlist_Pkg.update_par_status(p_par_id, 5);
    ELSIF v_a_item = 'Y' OR v_c_item = 'Y' THEN    
        Gipi_Parlist_Pkg.update_par_status(p_par_id, 4);
    ELSE
        Gipi_Parlist_Pkg.update_par_status(p_par_id, 3);
    END IF;    
    
    Gipis061_Update_Gipi_Wpolbas2(p_par_id, p_negate_item, p_prorate_flag,
        p_comp_sw, p_endt_exp_date, p_eff_date, p_exp_date, p_short_rt_pct);
END CHANGES_IN_PAR_STATUS_ENDT;
/


