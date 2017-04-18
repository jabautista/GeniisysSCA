DROP PROCEDURE CPI.PACK_ENDT_REVERT_FLAT_CANCEL;

CREATE OR REPLACE PROCEDURE CPI.PACK_ENDT_REVERT_FLAT_CANCEL(
    p_pack_par_id        IN GIPI_PACK_PARLIST.pack_par_id%TYPE,
    p_line_cd            IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
    p_subline_cd         IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
    p_iss_cd             IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
    p_issue_yy           IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no         IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no           IN GIPI_PACK_WPOLBAS.renew_no%TYPE,
    p_eff_date           IN GIPI_PACK_WPOLBAS.eff_date%TYPE,
    p_co_insurance_sw    IN GIPI_WPOLBAS.co_insurance_sw%TYPE,
    p_ann_tsi_amt        OUT GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt       OUT GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
    p_msg_alert          OUT VARCHAR2)
AS
    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     :  11.16.2011
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : To revert the processes done when Cancelled(Flat) checkbox was tagged
    */

BEGIN
    FOR par IN (SELECT a.par_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
	               FROM GIPI_WPOLBAS b, GIPI_PARLIST a 
                WHERE 1=1
                  AND b.par_id = a.par_id
                  AND a.pack_par_id = p_pack_par_id
                  AND a.par_status NOT IN (98,99))
    LOOP
        Pack_endt_Delete_Other_Info(par.par_id);
	    Pack_Endt_Delete_Records(par.par_id, par.line_cd, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	                             p_eff_date, p_co_insurance_sw, p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert);
    END LOOP;
    
END PACK_ENDT_REVERT_FLAT_CANCEL;
/


