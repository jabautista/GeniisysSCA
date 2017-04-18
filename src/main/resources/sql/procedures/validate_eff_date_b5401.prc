DROP PROCEDURE CPI.VALIDATE_EFF_DATE_B5401;

CREATE OR REPLACE PROCEDURE CPI.validate_eff_date_b5401 (
    p_par_id            IN          gipi_wpolbas.par_id%TYPE,
    p_line_cd           IN          gipi_wpolbas.line_cd%TYPE,
    p_subline_cd        IN          gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd            IN          gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy          IN          gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no        IN          gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no          IN          gipi_wpolbas.renew_no%TYPE,
    p_pol_flag          IN          gipi_wpolbas.pol_flag%TYPE,
    p_expiry_date       IN          gipi_wpolbas.expiry_date%TYPE,
    p_incept_date       IN          gipi_wpolbas.incept_date%TYPE,
    p_v_old_date        IN          VARCHAR2,
    p_exp_chg_sw        IN          VARCHAR2,
    p_v_max_eff_date    IN          VARCHAR2,  
    p_endt_yy           IN OUT      gipi_wpolbas.endt_yy%TYPE,
    p_eff_date          IN OUT      VARCHAR2,
    p_v_add_time        IN OUT      NUMBER,   
    p_v_mpl_switch      OUT         VARCHAR2,
    p_message           OUT         VARCHAR2)
    
AS

/*  This validates the effectivity date of the endorsement.                  */
/*  Endorsement effectivity date cannot be less than Policy inception date   */
/*    and the current eff_date can not be earlier than the latest endorsment */

  max_eff_date              DATE;
  NEW_DATE                  DATE;
  addtl_time                VARCHAR2(10);
  p_v_end_of_day            VARCHAR2(2);
  v_eff_date                gipi_wpolbas.eff_date%TYPE;
  
BEGIN
    IF p_pol_flag != '4' THEN
        IF NVL(p_v_old_date, SYSDATE) != p_eff_date THEN
            --get_addtl_time program block
            FOR a1 IN (SELECT a210.subline_time time
                         FROM giis_subline a210
                        WHERE line_cd = p_line_cd
                          AND subline_cd = p_subline_cd)
            LOOP
                p_v_add_time := a1.time;
                EXIT;
            END LOOP;
            
            delete_bill_gipis165(p_par_id);
            p_v_end_of_day := GIIS_SUBLINE_PKG.GET_SUBLINE_TIME_SW(p_line_cd, p_subline_cd);
            
            IF NVL (p_v_end_of_day, 'N') = 'Y' THEN
                NEW_DATE := TO_DATE(p_eff_date, 'MM-DD-YYYY') + 86399 / 86400;
            ELSE 
                NEW_DATE := TO_DATE(p_eff_date, 'MM-DD-YYYY') + p_v_add_time / 86400;
            END IF;
            
            IF NEW_DATE IS NOT NULL THEN
                p_eff_date := TO_CHAR(NEW_DATE, 'MM-DD-YYYY');
            END IF;
        END IF;
        
        p_endt_yy := TO_NUMBER(TO_CHAR(TO_DATE(p_eff_date, 'MM-DD-YYYY'), 'YY'));
        
        IF TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) > TRUNC(p_expiry_date)
            AND p_eff_date IS NOT NULL THEN
            p_v_mpl_switch := 'Y';
            p_message := 'Effectivity date should not be later than the Expiry date of the Bond.';
        END IF;
        
        /*BETH 11/20/98 if expiration date had been changed then valid effectivity date is only those that 
        **              are not later than the maximum effectivity date
        */
        
        IF p_exp_chg_sw = 'Y' THEN
            IF TRUNC(p_eff_date) >= TRUNC(p_v_max_eff_date) THEN
                NULL;
            ELSE
                --p_message := 'Effectivity date should not be earlier than the  effectivity date of the Bond.'; commented out by Gzelle 01092015 As per 3108
                p_message := 'Inception date should not be later than the effectivity date of the Endorsement.';
            END IF;
        END IF;
        
        FOR C1 IN (SELECT  eff_date
                 FROM  gipi_polbasic
                 WHERE  line_cd     = p_line_cd
                   AND  subline_cd  = p_subline_cd
                   AND  iss_cd      = p_iss_cd
                   AND  issue_yy    = p_issue_yy
                   AND  pol_seq_no  = p_pol_seq_no
                   AND  renew_no    = p_renew_no
                   AND  endt_seq_no != 0
                   AND  pol_flag   IN ('1','2','3','X')
                   AND (endt_type   != 'N' 
                    OR  endt_type   IS NULL)
              ORDER BY  eff_date DESC)
        LOOP
            max_eff_date := c1.eff_date;
            EXIT;
        END LOOP;
        
        /*IF TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) > TRUNC(max_eff_date) OR max_eff_date IS NULL THEN   
            IF max_eff_date IS NULL OR TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) < TRUNC(p_incept_date) THEN 
                --p_message := 'Effectivity date should not be earlier than the effectivity date of the Bond.'; commented out by Gzelle 01092015 As per 3108
                p_message := 'Inception date should not be later than the effectivity date of the Endorsement.';
            END IF;*/ -- Dren 11.12.2015 SR-0020642 : Bond Backward Endt.

        IF TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) < TRUNC(p_incept_date) THEN -- Dren 11.12.2015 SR-0020642 : Bond Backward Endt. - Start
            p_message := 'Inception date should not be later than the effectivity date of the Endorsement.';
        ELSIF TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) = TRUNC(max_eff_date) THEN
            p_eff_date := max_eff_date + (1/1440);
        ELSIF TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) >= TRUNC(p_incept_date) AND TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY')) < TRUNC(max_eff_date) THEN         
            p_message := 'Since this is a Backward Endorsement initial information is not the latest record as of entered effectivity date. '||
                         'Changes is about to take place.';
            /*p_message := 'Effectivity date should not be earlier than the effectivity date ('||
                  to_char(max_eff_date, 'fmMonth DD, YYYY')||') of the latest affecting endorsement.';*/  -- Dren 11.12.2015 SR-0020642 : Bond Backward Endt. - End
        END IF;
            
        IF TO_DATE(p_eff_date, 'MM-DD-YYYY') = p_incept_date THEN
             --p_eff_date := p_eff_date + (1/1440);
            v_eff_date := TO_DATE(p_eff_date, 'MM-DD-YYYY')+(1/1440);
            p_eff_date := TO_CHAR(v_eff_date, 'MM-DD-YYYY');
        END IF;
    END IF;
    
END validate_eff_date_b5401;
/


