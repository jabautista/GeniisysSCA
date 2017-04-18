CREATE OR REPLACE PROCEDURE CPI.LSP_SL_CODE (
    v_claim_sl_cd    IN  giac_parameters.param_value_n%type,
    v_line_cd        IN  giis_line.line_cd%type,
    v_subline_cd     IN  giis_subline.subline_cd%type,
    v_peril_cd       IN  giis_peril.peril_cd%type,
    v_sl_cd         OUT  giac_sl_lists.sl_cd%type
) 
IS
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup,
                           GICLS032 - Generate Advice)
    **  Description     :  LSP_SL_CODE program unit;
    */
BEGIN
  SELECT DECODE(v_claim_sl_cd, 
            '1', a.acct_line_cd,
            '2', (a.acct_line_cd * 100) + b.acct_subline_cd,
            '3', (a.acct_line_cd * 100000) + (b.acct_subline_cd * 1000) + v_peril_cd) sl_cd --Modified by Jerome 09.27.2016 SR 5675
    INTO v_sl_cd
    FROM giis_line a, giis_subline b
   WHERE b.subline_cd = v_subline_cd
     AND b.line_cd    = a.line_cd
     AND a.line_cd    = v_line_cd;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN
   --MSG_ALERT(V_LINE_CD || v_subline_cd ||v_peril_cd,'I', FALSE);
   --MSG_ALERT('No existing link to GIIS_LINE/GIIS_SUBLINE. LSP_SL_CODE (program unit)...', 'I', TRUE);
   raise_application_error('-20001', 'No existing link to GIIS_LINE/GIIS_SUBLINE. LSP_SL_CODE (program unit)...');
END;
/


