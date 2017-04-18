CREATE OR REPLACE PACKAGE BODY CPI.GIACR222A_PKG
AS

    FUNCTION get_report_details(
        p_line_cd       giac_treaty_perils.line_cd%TYPE,
        p_trty_yy       giac_treaty_perils.trty_yy%TYPE,
        p_share_cd      giac_treaty_perils.sharE_cd%TYPE,
       --p_ri_cd         giac_treaty_perils.ri_cd%TYPE,
        p_proc_year     giac_treaty_perils.proc_year%TYPE,
        p_proc_qtr      giac_treaty_perils.proc_qtr%TYPE
    ) RETURN giacr222a_tab PIPELINED
    IS
        v_dtl       giacr222a_type;
        v_count     NUMBER(1) := 0;
    BEGIN
    
        BEGIN
           SELECT param_value_v 
             INTO v_dtl.company_name
             FROM giis_parameters
            WHERE param_name LIKE 'COMPANY_NAME';
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_dtl.company_name := NULL;
        END;
        
        BEGIN
           SELECT param_value_v 
             INTO v_dtl.company_address
             FROM giis_parameters
            WHERE param_name LIKE 'COMPANY_ADDRESS';
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_dtl.company_address := NULL;
        END;
    
        FOR rec IN (SELECT SUM(giactp.commission_amt) commission_amt
                           , gperil.peril_name
                           , greinsr.ri_name
                           , gdshre.trty_name 
                           , SUM(nvl(gtqs.prem_resv_retnd_amt, 0.00)) retain_amt
                           , SUM(nvl(gtqs.wht_tax_amt, 0.00)) tax_amt 
                           , TO_CHAR(TO_DATE(giactp.proc_qtr,'j'),'Jspth') || ' Quarter, ' || TO_CHAR(giactp.proc_year) period1
                           , giactp.line_cd
                           , giactp.ri_cd
                           , giactp.peril_cd
                           , giactp.sharE_cd
                           , giactp.trty_yy
                           , giactp.proc_year
                           , giactp.proc_qtr
                      FROM   giac_treaty_perils giactp
                           , giis_peril  gperil
                           , giis_reinsurer greinsr
                           , giis_dist_share gdshre 
                           , giac_treaty_qtr_summary gtqs
                     WHERE giactp.line_cd   = gperil.line_cd 
                       AND giactp.ri_cd     = greinsr.ri_cd  
                       AND giactp.peril_cd  = gperil.peril_cd
                       AND giactp.share_cd  = gdshre.share_cd
                       AND giactp.trty_yy   = gdshre.trty_yy
                       AND giactp.line_cd   = gdshre.line_cd
                       AND giactp.line_cd   = NVL(p_line_cd, giactp.line_cd)
                       AND giactp.trty_yy   = NVL(p_trty_yy, giactp.trty_yy)
                       AND giactp.share_cd  = NVL(p_share_cd, giactp.share_cd)
                       --AND giactp.ri_cd     = NVL(p_ri_cd, giactp.ri_cd)
                       AND giactp.proc_year = NVL(p_proc_year,giactp.proc_year)
                       AND giactp.proc_qtr  = NVL(p_proc_qtr, giactp.proc_qtr)
                       AND giactp.line_cd   = gtqs.line_cd 
                       AND giactp.ri_cd     = gtqs.ri_cd  
                       AND giactp.share_cd  = gtqs.share_cd
                       AND giactp.trty_yy   = gtqs.trty_yy
                       AND giactp.proc_qtr  = gtqs.proc_qtr
                       AND giactp.proc_year = gtqs.proc_year
                     GROUP BY gperil.peril_name
                           , greinsr.ri_name
                           , gdshre.trty_name
                           , TO_CHAR(TO_DATE(giactp.proc_qtr,'j'),'Jspth') || ' Quarter, ' || TO_CHAR(giactp.proc_year)
                           , giactp.line_cd, giactp.ri_cd, giactp.peril_cd, giactp.share_cd, giactp.trty_yy, giactp.proc_year, giactp.proc_qtr
                     ORDER BY trty_name, ri_name, peril_name)
        LOOP
            v_count := 1;
            v_dtl.line_cd        := rec.line_cd;
            v_dtl.ri_cd          := rec.ri_cd;
            v_dtl.share_cd       := rec.share_cd;
            v_dtl.trty_yy        := rec.trty_yy;
            v_dtl.proc_qtr       := rec.proc_qtr;
            v_dtl.proc_year      := rec.proc_year;            
            v_dtl.commission_amt := rec.commission_amt;
            v_dtl.peril_name     := rec.peril_name;
            v_dtl.ri_name        := rec.ri_name;
            v_dtl.trty_name      := rec.trty_name;
            v_dtl.retain_amt     := rec.retain_amt;
            v_dtl.tax_amt        := rec.tax_amt;
            v_dtl.period         := rec.period1;
            
            PIPE ROW(v_dtl);
        END LOOP;
        
        
        IF v_count = 0 THEN
            PIPE ROW(v_dtl);
        END IF;
    
    END get_report_details;

END GIACR222A_PKG;
/


