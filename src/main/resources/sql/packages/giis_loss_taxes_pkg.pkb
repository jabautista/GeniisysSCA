CREATE OR REPLACE PACKAGE BODY CPI.GIIS_LOSS_TAXES_PKG AS

    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GIIS_LOSS_TAXES records
    **                  according to tax_type and branch_cd
    */ 
     
     
     FUNCTION get_giis_loss_taxes(p_tax_type     IN  GIIS_LOSS_TAXES.tax_type%TYPE,
                                  p_branch_cd    IN  GIIS_LOSS_TAXES.branch_cd%TYPE,
                                  p_keyword      IN  VARCHAR2)
        RETURN giis_loss_taxes_tab PIPELINED AS
        
        loss_taxes  giis_loss_taxes_type;
        
     BEGIN
        FOR i IN (SELECT loss_tax_id, tax_cd, tax_name, 
                         tax_rate, tax_type, branch_cd,
                         sl_type_cd
                    FROM GIIS_LOSS_TAXES
                   WHERE tax_type  = p_tax_type
                     AND branch_cd = p_branch_cd
                     AND (UPPER(tax_name) LIKE UPPER(NVL(p_keyword, tax_name))
                          OR tax_cd LIKE (NVL(p_keyword, tax_cd))) --added by steven 11/20/2012
                     AND NVL(start_date, SYSDATE) <= SYSDATE  --added by
                     AND NVL(end_date, SYSDATE) >= SYSDATE    --Halley 12.19.13
                  ORDER BY loss_tax_id)
        LOOP
            
            loss_taxes.loss_tax_id  :=  i.loss_tax_id;
            loss_taxes.tax_cd       :=  i.tax_cd;
            loss_taxes.tax_name     :=  i.tax_name;
            loss_taxes.tax_rate     :=  i.tax_rate;
            loss_taxes.tax_type     :=  i.tax_type;
            loss_taxes.branch_cd    :=  i.branch_cd;
            loss_taxes.sl_type_cd   :=  i.sl_type_cd;
            PIPE ROW(loss_taxes);
            
        END LOOP;
     END get_giis_loss_taxes;
 
 END GIIS_LOSS_TAXES_PKG;
/


