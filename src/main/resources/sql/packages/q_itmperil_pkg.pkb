CREATE OR REPLACE PACKAGE BODY CPI.Q_ITMPERIL_PKG
AS
    FUNCTION get_records (
        p_extract_id IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id  IN GIIS_DOCUMENT.report_id%TYPE,
        p_item_no    IN GIXX_ITMPERIL.item_no%TYPE)
    RETURN item_peril_tab PIPELINED
    IS
        v_item_peril_table     item_peril_type;
        CURSOR G_EXTRACT_ID10 IS
            SELECT ALL peril.SEQUENCE, ITMPERIL.EXTRACT_ID, 
                   ITMPERIL.ITEM_NO ITEM_NO,
                   ITMPERIL.LINE_CD LINE_CD, 
                   ITMPERIL.PERIL_CD PERIL_CD,       
                   ITMPERIL.COMP_REM COMP_REM,
                   PERIL.PERIL_SNAME PERIL_SNAME,
                   NVL(PERIL.PERIL_LNAME, PERIL.PERIL_NAME) PERIL_LNAME, 
                   NVL(ITMPERIL.TSI_AMT, 0) TSI_AMT, 
                   NVL(ITMPERIL.PREM_AMT, 0) PREM_AMT, 
                   NVL(ITMPERIL.PREM_RT,0) PREM_RT, 
                   PERIL_TYPE PERIL_TYPE,
                   PERIL.PERIL_NAME PERIL_NAME
              FROM GIXX_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_POLBASIC POL
             WHERE ITMPERIL.PERIL_CD = PERIL.PERIL_CD
               AND ITMPERIL.LINE_CD = PERIL.LINE_CD
               AND ITMPERIL.EXTRACT_ID = p_extract_id
               AND ITMPERIL.EXTRACT_ID = POL.EXTRACT_ID
               AND pol.co_insurance_sw IN ('1','3')
               AND ITMPERIL.ITEM_NO = p_item_no
            UNION
            SELECT ALL peril.SEQUENCE, ITMPERIL.EXTRACT_ID, 
                   ITMPERIL.ITEM_NO ITEM_NO,
                   ITMPERIL.LINE_CD LINE_CD, 
                   ITMPERIL.PERIL_CD PERIL_CD,       
                   ITMPERIL.COMP_REM ICOMP_REM,
                   PERIL.PERIL_SNAME PERIL_SNAME, 
                   NVL(PERIL.PERIL_LNAME, PERIL.PERIL_NAME) PERIL_LNAME, 
                   NVL(ITMPERIL.TSI_AMT, 0) TSI_AMT, 
                   NVL(ITMPERIL.PREM_AMT, 0) PREM_AMT, 
                   NVL(ITMPERIL.PREM_RT, 0) PREM_RT,
                   PERIL_TYPE PERIL_TYPE,
                   PERIL.PERIL_NAME PERIL_NAME
              FROM GIXX_ORIG_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_POLBASIC POL
             WHERE ITMPERIL.PERIL_CD = PERIL.PERIL_CD
               AND ITMPERIL.LINE_CD = PERIL.LINE_CD
               AND ITMPERIL.EXTRACT_ID = p_extract_id
               AND ITMPERIL.EXTRACT_ID = POL.EXTRACT_ID
               AND POL.CO_INSURANCE_SW = '2'
               AND ITMPERIL.ITEM_NO = p_item_no
            ORDER BY 1;
    BEGIN
        FOR i IN G_EXTRACT_ID10
        LOOP
            v_item_peril_table.extract_id    := i.extract_id;
            v_item_peril_table.item_no       := i.item_no;
            v_item_peril_table.line_cd       := i.line_cd;
            v_item_peril_table.peril_cd      := i.peril_cd;
            v_item_peril_table.comp_rem      := i.comp_rem;
            v_item_peril_table.peril_sname   := i.peril_sname;
            v_item_peril_table.peril_lname   := i.peril_lname;
            v_item_peril_table.tsi_amt       := i.tsi_amt;
            v_item_peril_table.prem_amt      := i.prem_amt;
            v_item_peril_table.prem_rt       := i.prem_rt;
            v_item_peril_table.peril_type    := i.peril_type;
            v_item_peril_table.peril_name    := i.peril_name;

            v_item_peril_table.f_peril_name  := Q_ITMPERIL_PKG.get_peril_name(p_report_id, i.peril_lname, i.peril_sname, i.peril_name);
            v_item_peril_table.f_tsi_amt     := Q_ITMPERIL_PKG.get_tsi_amt(p_extract_id, i.item_no, i.tsi_amt);
            v_item_peril_table.f_prem_amt    := Q_ITMPERIL_PKG.get_premium_amt(p_extract_id, i.item_no, i.prem_amt);
            
            v_item_peril_table.f_item_prem_amt := Q_ITMPERIL_PKG.get_item_premium_amt(p_extract_id, i.item_no);
            
            v_item_peril_table.f_item_short_name := Giis_Currency_Pkg.get_item_short_name(p_extract_id);
            v_item_peril_table.f_item_peril_short_name := Giis_Currency_Pkg.get_item_short_name2(p_extract_id, i.item_no);            
            
            PIPE ROW(v_item_peril_table);
        END LOOP;
    END get_records;
    
    FUNCTION get_records2 (
        p_extract_id   IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id    IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN item_peril_tab PIPELINED
    IS
        v_item_peril_table     item_peril_type;
        CURSOR G_EXTRACT_ID10 IS
            SELECT ALL peril.SEQUENCE, ITMPERIL.EXTRACT_ID, 
                   ITMPERIL.ITEM_NO ITEM_NO,
                   ITMPERIL.LINE_CD LINE_CD, 
                   ITMPERIL.PERIL_CD PERIL_CD,       
                   ITMPERIL.COMP_REM COMP_REM,
                   PERIL.PERIL_SNAME PERIL_SNAME,
                   NVL(PERIL.PERIL_LNAME, PERIL.PERIL_NAME) PERIL_LNAME, 
                   NVL(ITMPERIL.TSI_AMT, 0) TSI_AMT, 
                   NVL(ITMPERIL.PREM_AMT, 0) PREM_AMT, 
                   NVL(ITMPERIL.PREM_RT,0) PREM_RT, 
                   PERIL_TYPE PERIL_TYPE,
                   PERIL.PERIL_NAME PERIL_NAME
              FROM GIXX_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_POLBASIC POL
             WHERE ITMPERIL.PERIL_CD = PERIL.PERIL_CD
               AND ITMPERIL.LINE_CD = PERIL.LINE_CD
               AND ITMPERIL.EXTRACT_ID = p_extract_id
               AND ITMPERIL.EXTRACT_ID = POL.EXTRACT_ID
               AND pol.co_insurance_sw IN ('1','3')
            UNION
            SELECT ALL peril.SEQUENCE, ITMPERIL.EXTRACT_ID, 
                   ITMPERIL.ITEM_NO ITEM_NO,
                   ITMPERIL.LINE_CD LINE_CD, 
                   ITMPERIL.PERIL_CD PERIL_CD,       
                   ITMPERIL.COMP_REM ICOMP_REM,
                   PERIL.PERIL_SNAME PERIL_SNAME, 
                   NVL(PERIL.PERIL_LNAME, PERIL.PERIL_NAME) PERIL_LNAME, 
                   NVL(ITMPERIL.TSI_AMT, 0) TSI_AMT, 
                   NVL(ITMPERIL.PREM_AMT, 0) PREM_AMT, 
                   NVL(ITMPERIL.PREM_RT, 0) PREM_RT,
                   PERIL_TYPE PERIL_TYPE,
                   PERIL.PERIL_NAME PERIL_NAME
              FROM GIXX_ORIG_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_POLBASIC POL
             WHERE ITMPERIL.PERIL_CD = PERIL.PERIL_CD
               AND ITMPERIL.LINE_CD = PERIL.LINE_CD
               AND ITMPERIL.EXTRACT_ID = p_extract_id
               AND ITMPERIL.EXTRACT_ID = POL.EXTRACT_ID
               AND POL.CO_INSURANCE_SW = '2'
            ORDER BY 1;
    BEGIN
        FOR i IN G_EXTRACT_ID10
        LOOP
            v_item_peril_table.extract_id    := i.extract_id;
            v_item_peril_table.item_no       := i.item_no;
            v_item_peril_table.line_cd       := i.line_cd;
            v_item_peril_table.peril_cd      := i.peril_cd;
            v_item_peril_table.comp_rem      := i.comp_rem;
            v_item_peril_table.peril_sname   := i.peril_sname;
            v_item_peril_table.peril_lname   := i.peril_lname;
            v_item_peril_table.tsi_amt       := i.tsi_amt;
            v_item_peril_table.prem_amt      := i.prem_amt;
            v_item_peril_table.prem_rt       := i.prem_rt;
            v_item_peril_table.peril_type    := i.peril_type;
            v_item_peril_table.peril_name    := i.peril_name;

            v_item_peril_table.f_peril_name  := Q_ITMPERIL_PKG.get_peril_name(p_report_id, i.peril_lname, i.peril_sname, i.peril_name);
            v_item_peril_table.f_tsi_amt     := Q_ITMPERIL_PKG.get_tsi_amt(p_extract_id, i.item_no, i.tsi_amt);
            v_item_peril_table.f_prem_amt    := Q_ITMPERIL_PKG.get_premium_amt(p_extract_id, i.item_no, i.prem_amt);
            
            v_item_peril_table.f_item_prem_amt := Q_ITMPERIL_PKG.get_item_premium_amt(p_extract_id, i.item_no);
            
            v_item_peril_table.f_item_short_name := Giis_Currency_Pkg.get_item_short_name(p_extract_id);
            v_item_peril_table.f_item_peril_short_name := Giis_Currency_Pkg.get_item_short_name2(p_extract_id, i.item_no);            
            
            PIPE ROW(v_item_peril_table);
        END LOOP;
    END get_records2;
    
    /* peril_name */
    FUNCTION get_peril_name (
        p_report_id       IN GIIS_DOCUMENT.report_id%TYPE,
        p_peril_lname     IN GIIS_PERIL.peril_lname%TYPE,
        p_peril_sname     IN GIIS_PERIL.peril_sname%TYPE,
        p_peril_name      IN GIIS_PERIL.peril_name%TYPE)
    RETURN VARCHAR2
    IS
        v_text             GIIS_DOCUMENT.text%TYPE;
        v_peril_name    VARCHAR2(500);
    BEGIN
        FOR a IN (
            SELECT text 
              FROM GIIS_DOCUMENT
             WHERE title = 'PRINT_PERIL_LONG_NAME'
               AND report_id = p_report_id)
        LOOP
            v_text := a.text;
        END LOOP;
        
        IF v_text = 'Y' THEN
            v_peril_name := p_peril_lname;
        ELSE
            FOR a IN (
                SELECT text 
                  FROM GIIS_DOCUMENT
                 WHERE title = 'PRINT_SNAME'
                   AND report_id = p_report_id)
            LOOP
                v_text := a.text;
            END LOOP;
            
            IF v_text = 'Y' THEN
                v_peril_name := p_peril_sname;
            ELSE
                v_peril_name := p_peril_name;
            END IF;
        END IF;
        
        RETURN (v_peril_name);
    END;
    
    /* f_tsi_amt */
    FUNCTION get_tsi_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_tsi_amt        IN GIXX_ITMPERIL.tsi_amt%TYPE) 
    RETURN NUMBER
    IS
        v_currency_rt        GIPI_ITEM.currency_rt%TYPE;
        v_policy_currency    GIXX_INVOICE.policy_currency%TYPE;
    BEGIN
        FOR A IN (        
            SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
              FROM GIXX_ITEM b,
                   GIXX_INVOICE a,
                   GIXX_POLBASIC c 
             WHERE a.extract_id = b.extract_id
               AND a.extract_id = c.extract_id
               AND c.co_insurance_sw IN ('1','3')
               AND a.extract_id = p_extract_id
               AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp --added by steven 1.23.2013; for multiple items and different currency
             UNION
            SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
              FROM GIXX_ITEM b,
                   GIXX_ORIG_INVOICE a,
                   GIXX_POLBASIC c 
             WHERE a.extract_id = b.extract_id
               AND a.extract_id = c.extract_id
               AND c.co_insurance_sw = '2'
               AND a.extract_id = p_extract_id
               AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp) --added by steven 1.23.2013; for multiple items and different currency
        LOOP
            v_currency_rt := A.currency_rt;
            v_policy_currency := A.policy_currency; 
        END LOOP;  
  
        IF NVL(v_policy_currency,'N') = 'Y' THEN
            RETURN(NVL(p_tsi_amt , 0));
        ELSE
            RETURN(NVL((p_tsi_amt * NVL(v_currency_rt,1)), 0));
        END IF;  
    END get_tsi_amt;
    
    /* f_prem_amt */
    FUNCTION get_premium_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_prem_amt       IN GIXX_ITMPERIL.prem_amt%TYPE) 
    RETURN NUMBER
    IS
        v_currency_rt       GIPI_ITEM.currency_rt%TYPE;
        v_policy_currency   GIXX_INVOICE.policy_currency%TYPE;        
    BEGIN
        FOR A IN (        
            SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
              FROM GIXX_ITEM b,
                   GIXX_INVOICE a,
                   GIXX_POLBASIC c
             WHERE a.extract_id = b.extract_id
               AND a.extract_id = c.extract_id
               AND c.co_insurance_sw IN ('1','3')
               AND a.extract_id = p_extract_id
               AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp --added by steven 1.23.2013; for multiple items and different currency
             UNION
            SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
              FROM GIXX_ITEM b,
                   GIXX_ORIG_INVOICE a,
                   GIXX_POLBASIC c
             WHERE a.extract_id = b.extract_id
               AND a.extract_id = c.extract_id
               AND c.co_insurance_sw = '2'
               AND a.extract_id = p_extract_id
               AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp) --added by steven 1.23.2013; for multiple items and different currency
        LOOP
            v_currency_rt := A.currency_rt;
            v_policy_currency := A.policy_currency; 
        END LOOP;  
  
        IF NVL(v_policy_currency,'N') = 'Y' THEN
            RETURN(NVL(p_prem_amt , 0));
        ELSE
            RETURN(NVL((p_prem_amt * NVL(v_currency_rt,1)), 0));
        END IF;  
    END get_premium_amt;
    
    /* f_item_prem_amt */
    FUNCTION get_item_premium_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE) 
    RETURN NUMBER
    IS
        v_currency_rt       GIPI_ITEM.currency_rt%TYPE;
        v_policy_currency   GIXX_INVOICE.policy_currency%TYPE;
        v_prem_amt          GIXX_ITMPERIL.prem_amt%TYPE;
    BEGIN
        FOR A IN (        
            SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
              FROM GIXX_ITEM b,
                   GIXX_INVOICE a,
                   GIXX_POLBASIC c
             WHERE a.extract_id = b.extract_id
               AND a.extract_id = c.extract_id
               AND c.co_insurance_sw IN ('1','3')
               AND a.extract_id = p_extract_id
               AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp --added by steven 1.23.2013; for multiple items and different currency
             UNION
            SELECT a.currency_rt,NVL(policy_currency,'N') policy_currency
              FROM GIXX_ITEM b,
                   GIXX_ORIG_INVOICE a,
                   GIXX_POLBASIC c
             WHERE a.extract_id = b.extract_id
               AND a.extract_id = c.extract_id
               AND c.co_insurance_sw = '2'
               AND a.extract_id = p_extract_id
               AND b.item_no    = p_item_no
			   AND a.item_grp = b.item_grp) --added by steven 1.23.2013; for multiple items and different currency
        LOOP
            v_currency_rt := A.currency_rt;
            v_policy_currency := A.policy_currency; 
        END LOOP;  
  
        IF NVL(v_policy_currency,'N') = 'Y' THEN
            FOR i IN (
                SELECT SUM(NVL(prem_amt, 0)) prem_amt                  
                  FROM GIXX_ITMPERIL
                 WHERE extract_id = p_extract_id
                   AND item_no = p_item_no)
            LOOP
                v_prem_amt := i.prem_amt;
            END LOOP;            
        ELSE
            FOR i IN (
                SELECT SUM(NVL(prem_amt, 0) * v_currency_rt) prem_amt                  
                  FROM GIXX_ITMPERIL
                 WHERE extract_id = p_extract_id
                   AND item_no = p_item_no)
            LOOP
                v_prem_amt := i.prem_amt;
            END LOOP;            
        END IF;
        
        RETURN(v_prem_amt);
    END get_item_premium_amt;
    
    FUNCTION get_pack_peril_records (
        p_extract_id    IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id     IN GIIS_DOCUMENT.report_id%TYPE,
        p_item_no       IN GIXX_ITMPERIL.item_no%TYPE)
    RETURN item_peril_tab PIPELINED
    IS
        v_item_peril_table     item_peril_type;
        
        CURSOR G_EXTRACT_ID10 IS
            SELECT ALL peril.SEQUENCE, ITMPERIL.extract_id, 
                   ITMPERIL.item_no ITEM_NO,
                   ITMPERIL.policy_id POLICY_ID,
                   ITMPERIL.line_cd LINE_CD, 
                   ITMPERIL.peril_cd PERIL_CD,       
                   ITMPERIL.comp_rem COMP_REM,
                   PERIL.peril_sname PERIL_SNAME,
                   NVL(PERIL.peril_lname, PERIL.peril_name) PERIL_LNAME, 
                   NVL(ITMPERIL.tsi_amt, 0) TSI_AMT, 
                   NVL(ITMPERIL.prem_amt, 0) PREM_AMT, 
                   NVL(ITMPERIL.prem_rt,0) PREM_RT, 
                   peril_type PERIL_TYPE,
                   PERIL.peril_name PERIL_NAME
              FROM GIXX_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_PACK_POLBASIC POL
             WHERE ITMPERIL.peril_cd = PERIL.peril_cd
               AND ITMPERIL.line_cd = PERIL.line_cd
               AND ITMPERIL.extract_id = p_extract_id
               AND ITMPERIL.extract_id = POL.extract_id
               AND pol.co_insurance_sw IN ('1','3')
               AND ITMPERIL.item_no = p_item_no
            UNION
            SELECT ALL peril.SEQUENCE, ITMPERIL.extract_id, 
                   ITMPERIL.item_no ITEM_NO,
                   ITMPERIL.policy_id POLICY_ID,
                   ITMPERIL.line_cd LINE_CD, 
                   ITMPERIL.peril_cd PERIL_CD,       
                   ITMPERIL.comp_rem ICOMP_REM,
                   PERIL.peril_sname PERIL_SNAME, 
                   NVL(PERIL.peril_lname, PERIL.peril_name) PERIL_LNAME, 
                   NVL(ITMPERIL.tsi_amt, 0) TSI_AMT, 
                   NVL(ITMPERIL.prem_amt, 0) PREM_AMT, 
                   NVL(ITMPERIL.prem_rt, 0) PREM_RT,
                   peril_type PERIL_TYPE,
                   PERIL.peril_name PERIL_NAME
              FROM GIXX_ORIG_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_PACK_POLBASIC POL
             WHERE ITMPERIL.peril_cd = PERIL.peril_cd
               AND ITMPERIL.line_cd = PERIL.line_cd
               AND ITMPERIL.extract_id = p_extract_id
               AND ITMPERIL.extract_id = POL.extract_id
               AND POL.co_insurance_sw = '2'
               AND ITMPERIL.item_no = p_item_no
            ORDER BY 1;
    BEGIN
        FOR i IN G_EXTRACT_ID10
        LOOP
            v_item_peril_table.extract_id     := i.extract_id;
            v_item_peril_table.item_no        := i.item_no;
            v_item_peril_table.line_cd        := i.line_cd;
            v_item_peril_table.peril_cd       := i.peril_cd;
            v_item_peril_table.comp_rem       := i.comp_rem;
            v_item_peril_table.peril_sname    := i.peril_sname;
            v_item_peril_table.peril_lname    := i.peril_lname;
            v_item_peril_table.tsi_amt        := i.tsi_amt;
            v_item_peril_table.prem_amt       := i.prem_amt;
            v_item_peril_table.prem_rt        := i.prem_rt;
            v_item_peril_table.peril_type     := i.peril_type;
            v_item_peril_table.peril_name     := i.peril_name;

            v_item_peril_table.f_peril_name   := Q_ITMPERIL_PKG.get_peril_name(p_report_id, i.peril_lname, i.peril_sname, i.peril_name);
            v_item_peril_table.f_tsi_amt      := Q_ITMPERIL_PKG.get_pack_tsi_amt(p_extract_id, i.item_no, i.policy_id, i.tsi_amt);
            v_item_peril_table.f_prem_amt     := Q_ITMPERIL_PKG.get_pack_premium_amt(p_extract_id, i.item_no,i.policy_id, i.prem_amt);
            
            v_item_peril_table.f_item_prem_amt := Q_ITMPERIL_PKG.get_item_premium_amt(p_extract_id, i.item_no);
            
            v_item_peril_table.f_item_short_name := Giis_Currency_Pkg.get_pack_item_short_name(p_extract_id);
            v_item_peril_table.f_item_peril_short_name := Giis_Currency_Pkg.get_item_short_name2(p_extract_id, i.item_no);            
            
            PIPE ROW(v_item_peril_table);
        END LOOP;
    END get_pack_peril_records;
    
    FUNCTION get_pack_item_peril_records (
        p_extract_id    IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id     IN GIIS_DOCUMENT.report_id%TYPE,
        p_item_no       IN GIXX_ITMPERIL.item_no%TYPE,
        p_policy_id     IN GIXX_PACK_POLBASIC.policy_id%TYPE)
    RETURN item_peril_tab PIPELINED
    IS
        v_item_peril_table     item_peril_type;
        
        CURSOR G_EXTRACT_ID10 IS
            SELECT ALL peril.SEQUENCE, ITMPERIL.extract_id, 
                   ITMPERIL.item_no ITEM_NO,
                   ITMPERIL.policy_id POLICY_ID,
                   ITMPERIL.line_cd LINE_CD, 
                   ITMPERIL.peril_cd PERIL_CD,       
                   ITMPERIL.comp_rem COMP_REM,
                   PERIL.peril_sname PERIL_SNAME,
                   NVL(PERIL.peril_lname, PERIL.peril_name) PERIL_LNAME, 
                   NVL(ITMPERIL.tsi_amt, 0) TSI_AMT, 
                   NVL(ITMPERIL.prem_amt, 0) PREM_AMT, 
                   NVL(ITMPERIL.prem_rt,0) PREM_RT, 
                   peril_type PERIL_TYPE,
                   PERIL.peril_name PERIL_NAME
              FROM GIXX_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_PACK_POLBASIC POL
             WHERE ITMPERIL.peril_cd = PERIL.peril_cd
               AND ITMPERIL.line_cd = PERIL.line_cd
               AND ITMPERIL.extract_id = p_extract_id
               AND ITMPERIL.extract_id = POL.extract_id
               AND pol.co_insurance_sw IN ('1','3')
               AND ITMPERIL.item_no = p_item_no
               AND ITMPERIL.policy_id = p_policy_id
            UNION
            SELECT ALL peril.SEQUENCE, ITMPERIL.extract_id, 
                   ITMPERIL.item_no ITEM_NO,
                   ITMPERIL.policy_id POLICY_ID,
                   ITMPERIL.line_cd LINE_CD, 
                   ITMPERIL.peril_cd PERIL_CD,       
                   ITMPERIL.comp_rem ICOMP_REM,
                   PERIL.peril_sname PERIL_SNAME, 
                   NVL(PERIL.peril_lname, PERIL.peril_name) PERIL_LNAME, 
                   NVL(ITMPERIL.tsi_amt, 0) TSI_AMT, 
                   NVL(ITMPERIL.prem_amt, 0) PREM_AMT, 
                   NVL(ITMPERIL.prem_rt, 0) PREM_RT,
                   peril_type PERIL_TYPE,
                   PERIL.peril_name PERIL_NAME
              FROM GIXX_ORIG_ITMPERIL ITMPERIL, 
                   GIIS_PERIL PERIL,
                   GIXX_PACK_POLBASIC POL
             WHERE ITMPERIL.peril_cd = PERIL.peril_cd
               AND ITMPERIL.line_cd = PERIL.line_cd
               AND ITMPERIL.extract_id = p_extract_id
               AND ITMPERIL.extract_id = POL.extract_id
               AND POL.co_insurance_sw = '2'
               AND ITMPERIL.item_no = p_item_no
               AND ITMPERIL.policy_id = p_policy_id
            ORDER BY 1;
    BEGIN
        FOR i IN G_EXTRACT_ID10
        LOOP
            v_item_peril_table.extract_id    := i.extract_id;
            v_item_peril_table.item_no       := i.item_no;
            v_item_peril_table.line_cd       := i.line_cd;
            v_item_peril_table.peril_cd      := i.peril_cd;
            v_item_peril_table.comp_rem      := i.comp_rem;
            v_item_peril_table.peril_sname   := i.peril_sname;
            v_item_peril_table.peril_lname   := i.peril_lname;
            v_item_peril_table.tsi_amt       := i.tsi_amt;
            v_item_peril_table.prem_amt      := i.prem_amt;
            v_item_peril_table.prem_rt       := i.prem_rt;
            v_item_peril_table.peril_type    := i.peril_type;
            v_item_peril_table.peril_name    := i.peril_name;

            v_item_peril_table.f_peril_name  := Q_ITMPERIL_PKG.get_peril_name(p_report_id, i.peril_lname, i.peril_sname, i.peril_name);
            v_item_peril_table.f_tsi_amt     := Q_ITMPERIL_PKG.get_pack_tsi_amt(p_extract_id, i.item_no, p_policy_id, i.tsi_amt);
            v_item_peril_table.f_prem_amt    := Q_ITMPERIL_PKG.get_pack_premium_amt(p_extract_id, i.item_no, p_policy_id, i.prem_amt);
            
            v_item_peril_table.f_item_prem_amt := Q_ITMPERIL_PKG.get_pack_item_tsi_amt2(p_extract_id, i.item_no, i.peril_type, p_policy_id, i.tsi_amt); --change by steven 2.4.2013
            
            v_item_peril_table.f_item_short_name := Giis_Currency_Pkg.get_pack_item_short_name(p_extract_id);
            v_item_peril_table.f_item_peril_short_name := Giis_Currency_Pkg.get_item_short_name2(p_extract_id, i.item_no);            
            
            PIPE ROW(v_item_peril_table);
        END LOOP;
    END get_pack_item_peril_records;
    
    FUNCTION get_pack_tsi_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_policy_id      IN GIXX_PACK_POLBASIC.policy_id%TYPE,
        p_tsi_amt        IN GIXX_ITMPERIL.tsi_amt%TYPE) 
    
    RETURN NUMBER
    
    IS
    
        v_currency_rt       GIPI_ITEM.CURRENCY_RT%TYPE;
        v_policy_currency   GIXX_PACK_INVOICE.policy_currency%TYPE;
    
    BEGIN
    
        FOR A IN (SELECT a.currency_rt,NVL(a.policy_currency,'N') policy_currency
                  FROM GIXX_ITEM b,
                       GIXX_INVOICE a,
                       GIXX_PACK_POLBASIC c
                 WHERE a.extract_id = b.extract_id
                   AND a.extract_id = c.extract_id
                   AND a.extract_id = p_extract_id
				   AND a.policy_id  = b.policy_id --added by steven 02.04.2013; for different currency.
                   AND b.item_no    = p_item_no
				   AND b.item_grp   = a.item_grp --added by steven 02.04.2013; for different currency.
                   AND b.policy_id  = p_policy_id  
            )
        LOOP
          v_currency_rt := A.currency_rt;
          V_policy_currency := a.policy_currency; 
        END LOOP;  
      
        IF NVL(v_policy_currency,'N') = 'Y' THEN
            RETURN(NVL(p_tsi_amt , 0));
        ELSE
            RETURN(NVL((p_tsi_amt  * NVL(v_currency_rt,1)), 0));
        END IF;  
    END;
    
    FUNCTION get_pack_premium_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_policy_id      IN GIXX_PACK_POLBASIC.policy_id%TYPE,
        p_prem_amt       IN GIXX_ITMPERIL.prem_amt%TYPE) 
    RETURN NUMBER
    
    IS
    
        v_currency_rt        GIPI_ITEM.CURRENCY_RT%TYPE;
        v_policy_currency    GIXX_PACK_INVOICE.policy_currency%TYPE;
    
    BEGIN
    
        FOR A IN (SELECT a.currency_rt,NVL(a.policy_currency,'N') policy_currency
                  FROM GIXX_ITEM b,
                       GIXX_INVOICE a,
                       GIXX_PACK_POLBASIC c
                 WHERE a.extract_id = b.extract_id
                   AND a.extract_id = c.extract_id
                   AND a.extract_id = p_extract_id
				   AND a.policy_id  = b.policy_id --added by steven 02.04.2013; for different currency.
                   AND b.item_no    = p_item_no
				   AND b.item_grp   = a.item_grp --added by steven 02.04.2013; for different currency.
                   AND b.policy_id  = p_policy_id  
            )
        LOOP
          v_currency_rt := A.currency_rt;
          V_policy_currency := a.policy_currency; 
        END LOOP;  
      
        IF NVL(v_policy_currency,'N') = 'Y' THEN
            RETURN(NVL(p_prem_amt , 0));
        ELSE
            RETURN(NVL((p_prem_amt  * NVL(v_currency_rt,1)), 0));
        END IF;  
    END;
    
   FUNCTION get_pack_item_tsi_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_peril_type	IN GIIS_PERIL.peril_type%TYPE,
		p_tsi_amt		IN GIXX_ITMPERIL.tsi_amt%TYPE) 
	
    RETURN NUMBER
    
    IS
    
    	v_currency_rt		GIPI_ITEM.CURRENCY_RT%TYPE;
        v_policy_currency   GIXX_PACK_INVOICE.policy_currency%TYPE;
    
    BEGIN
		IF p_peril_type = 'B' THEN
			FOR A IN (SELECT a.currency_rt,NVL(a.policy_currency,'N') policy_currency  
                        FROM GIXX_ITEM b,
                             GIXX_PACK_INVOICE a
                       WHERE a.extract_id = b.extract_id
                         AND a.extract_id = p_extract_id
                         AND b.item_no    = p_item_no)
			LOOP
			  v_currency_rt := A.currency_rt;
			  V_policy_currency := a.policy_currency; 
			END LOOP;  
		  
			IF NVL(v_policy_currency,'N') = 'Y' THEN
				RETURN(NVL(p_tsi_amt , 0));
			ELSE
				RETURN(NVL((p_tsi_amt  * NVL(v_currency_rt,1)), 0));
			END IF;
		ELSE
			RETURN (NULL);
		END IF;
    END;
	
	/*created by: steven
	* date: 02.04.2013
	* description: to get the exact currency rate depending on the policy_id 			
	*/
	FUNCTION get_pack_item_tsi_amt2 (
		p_extract_id 	GIXX_INVOICE.extract_id%TYPE,
		p_item_no		GIXX_ITEM.item_no%TYPE,
		p_peril_type	GIIS_PERIL.peril_type%TYPE,
		p_policy_id     GIXX_PACK_POLBASIC.policy_id%TYPE,
		p_tsi_amt		GIXX_ITMPERIL.tsi_amt%TYPE) 
	
    RETURN NUMBER
    
    IS
    
    	v_currency_rt		GIPI_ITEM.CURRENCY_RT%TYPE;
        v_policy_currency   GIXX_PACK_INVOICE.policy_currency%TYPE;
    
    BEGIN
		IF p_peril_type = 'B' THEN
			FOR A IN (SELECT a.currency_rt,NVL(a.policy_currency,'N') policy_currency  
                        FROM GIXX_ITEM b,
                             GIXX_INVOICE a
                       WHERE a.extract_id = b.extract_id
                         AND a.extract_id = p_extract_id
                         AND b.item_no    = p_item_no
						 AND b.item_grp   = a.item_grp
						 AND a.policy_id  = b.policy_id
						 AND b.policy_id  = p_policy_id)
			LOOP
			  v_currency_rt := A.currency_rt;
			  V_policy_currency := a.policy_currency; 
			END LOOP;  
		  
			IF NVL(v_policy_currency,'N') = 'Y' THEN
				RETURN(NVL(p_tsi_amt , 0));
			ELSE
				RETURN(NVL((p_tsi_amt  * NVL(v_currency_rt,1)), 0));
			END IF;
		ELSE
			RETURN (NULL);
		END IF;
    END;
    
END Q_ITMPERIL_PKG;
/


