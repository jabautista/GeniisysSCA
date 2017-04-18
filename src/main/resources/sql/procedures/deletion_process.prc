DROP PROCEDURE CPI.DELETION_PROCESS;

CREATE OR REPLACE PROCEDURE CPI.DELETION_PROCESS(
    p_peril_cd          IN      GIPI_WITMPERL.peril_cd%TYPE,
    p_line_cd           IN      GIEX_EXPIRY.line_cd%TYPE,
    p_subline_cd        IN      GIEX_EXPIRY.subline_cd%TYPE,
    p_nbt_prorate_flag  IN      GIPI_POLBASIC.prorate_flag%TYPE,
    p_endt_expiry_date  IN      GIPI_POLBASIC.endt_expiry_date%TYPE,
    p_eff_date          IN      GIPI_POLBASIC.eff_date%TYPE,
    p_short_rt_percent  IN      GIPI_POLBASIC.short_rt_percent%TYPE,
    p_tsi_amt           IN      GIPI_WITMPERL.tsi_amt%TYPE,     --  :b490.tsi_amt;
    p_prem_amt          IN      GIPI_WITMPERL.prem_amt%TYPE,    --  :b490.prem_amt;
    p_prem_rt           IN      GIPI_WITMPERL.prem_rt%TYPE,     --  :b490.prem_rt;
    i_tsi_amt           IN OUT  GIPI_WITEM.tsi_amt%TYPE,        --  :b480.tsi_amt;
    i_prem_amt          IN OUT  GIPI_WITEM.prem_amt%TYPE,       --  :b480.prem_amt;
    i_nbt_tsi_amt       IN OUT  GIPI_WITEM.ann_tsi_amt%TYPE,    --  :b480.nbt_tsi_amt;
    i_nbt_prem_amt      IN OUT  GIPI_WITEM.ann_prem_amt%TYPE,   --  :b480.nbt_prem_amt;
    i_ann_tsi_amt          OUT  GIPI_WITEM.ann_tsi_amt%TYPE,
    i_ann_prem_amt         OUT  GIPI_WITEM.ann_prem_amt%TYPE,
    p_msg                  OUT  VARCHAR2
) 
IS
    /*
    **  Created by     : Robert Virrey
    **  Date Created   : 03.06.2012
    **  Reference By   : (GIEXS007 - Edit Peril Information)
    **  Description    : DELETION_PROCESS program unit
	*/
    v_peril_type            GIIS_PERIL.peril_type%TYPE;
    v_diff_prem             NUMBER(12,2);
    v_prorate               NUMBER;
BEGIN
    /*FOR A1 IN (
            SELECT   sum(NVL(disc_amt,0))  disc_amt
              FROM   gipi_wperil_discount
             WHERE   par_id    =  :b240.par_id
               AND   item_no   =  :b480.item_no
               AND   line_cd   =  :b240.line_cd
               AND   peril_cd  =  :b490.peril_cd) LOOP
         v_diff_prem    :=  NVL(A1.disc_amt,0);
         EXIT; 
    END LOOP;*/
    FOR A1 IN (
         SELECT    peril_type
           FROM    giis_peril
          WHERE    peril_cd     =  p_peril_cd
            AND    line_cd      =  p_line_cd
            AND   (subline_cd   =  p_subline_cd
                   OR subline_cd IS NULL)) 
    LOOP
              v_peril_type  := A1.peril_type;
              EXIT;
    END LOOP;
    IF v_peril_type='B' THEN
           i_tsi_amt :=     NVL(i_tsi_amt,0)     - NVL(p_tsi_amt,0);
           i_ann_tsi_amt := NVL(i_nbt_tsi_amt,0) - NVL(p_tsi_amt,0);
           i_nbt_tsi_amt := NVL(i_nbt_tsi_amt,0) - NVL(p_tsi_amt,0);
    END IF;
    i_prem_amt     := NVL(i_prem_amt,0)        - NVL(p_prem_amt,0);
    /* The process of subtracting an amount from the annualized premium
    ** should cohere with the prorate flag of the policy being endorsed.
    ** It should be kept in mind that there are three existing conditions
    ** whenever we consider the prorate flag -- 1,2 and 3. We have to determine
    ** if both the premium and tsi is zero or not.
    */
    /*IF ((NVL(p_prem_rt,0) = 0) 
    AND (NVL(p_tsi_amt,0) = 0)) THEN*/
    IF NVL(p_tsi_amt,0) = 0 THEN
        IF p_nbt_prorate_flag = '1' THEN
          IF p_endt_expiry_date <= p_eff_date THEN
             p_msg := 'Your endorsement expiry date is equal to or less than your effectivity date.'||
                       ' Restricted condition.';
             RETURN;
          ELSE
             v_prorate  :=  TRUNC( p_endt_expiry_date - p_eff_date ) /
                             (ADD_MONTHS(p_eff_date,12) - p_eff_date);
          END IF;
          i_ann_prem_amt := NVL(i_nbt_prem_amt,0)    - 
                                    (NVL(p_prem_amt,0)/v_prorate);
          i_nbt_prem_amt := NVL(i_nbt_prem_amt,0)    - 
                                    (NVL(p_prem_amt,0)/v_prorate);                          
        ELSIF p_nbt_prorate_flag = '2' THEN
          i_ann_prem_amt := NVL(i_nbt_prem_amt,0)    -
                                    NVL(p_prem_amt,0);
          i_nbt_prem_amt := NVL(i_nbt_prem_amt,0)    -
                                    NVL(p_prem_amt,0);                          
        ELSE  
          i_ann_prem_amt := NVL(i_nbt_prem_amt,0)    -
                                    (NVL(p_prem_amt,0)/
                                     (NVL(p_short_rt_percent,1)/100));
          i_nbt_prem_amt := NVL(i_nbt_prem_amt,0)    -
                                    (NVL(p_prem_amt,0)/
                                     (NVL(p_short_rt_percent,1)/100));                           
        END IF;
    ELSE   
          i_ann_prem_amt := NVL(i_nbt_prem_amt,0)    -
                                   (NVL(p_prem_rt,0) * NVL(p_tsi_amt,0) /
                                    100); 
          i_nbt_prem_amt := NVL(i_nbt_prem_amt,0)    -
                                   (NVL(p_prem_rt,0) * NVL(p_tsi_amt,0) /
                                    100);                           
   END IF;
END;
/


