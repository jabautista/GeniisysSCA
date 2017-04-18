CREATE OR REPLACE PACKAGE BODY CPI.GIACR211_PKG
AS
    /*
    **  Created by   :  Maria Gzelle Ison
    **  Date Created : 03.11.2013
    **  Reference By : program units from GIACR211_latest
    */
    
    FUNCTION cf_company_name 
        RETURN VARCHAR2 
    IS
        v_company_name VARCHAR2(100);

    BEGIN
      SELECT param_value_v
        INTO v_company_name
        FROM GIIS_PARAMETERS
       WHERE param_name='COMPANY_NAME';
      RETURN (v_company_name);
    RETURN NULL; 
    EXCEPTION
    WHEN NO_DATA_FOUND 
    THEN 
      RETURN(NULL);
    END;                  
    
    FUNCTION cf_company_address
        RETURN CHAR 
    IS
      v_address VARCHAR2(500);
      
    BEGIN
      SELECT param_value_v
        INTO v_address
        FROM GIIS_PARAMETERS 
       WHERE param_name = 'COMPANY_ADDRESS';
      RETURN (v_address);
    RETURN NULL;
    EXCEPTION
    WHEN NO_DATA_FOUND 
    THEN 
        NULL;
    RETURN(v_address);
    END;

    FUNCTION cf_ref_no(
        p_tran_class    GIAC_ACCTRANS.tran_class%TYPE
    ) 
        RETURN VARCHAR2 
    IS
        v_ref_no	    VARCHAR2(200);
    
    BEGIN

       IF p_tran_class = 'COL' 
       THEN
            v_ref_no := 'Or No.';
       ELSIF p_tran_class = 'DV' 
       THEN
            v_ref_no := 'Check No.';
       ELSE 
            v_ref_no := 'Ref. No.';
       END IF;

       RETURN(v_ref_no);
    END;
    
    FUNCTION cf_tran_flag(
        p_tran_flag     GIAC_ACCTRANS.tran_flag%TYPE
    ) 
        RETURN VARCHAR2 
    IS
        v_tran_flag     CG_REF_CODES.rv_meaning%TYPE;
    
    BEGIN
    
       IF p_tran_flag IS NOT NULL 
       THEN
          FOR record1 IN (SELECT rv_meaning
                            FROM CG_REF_CODES
                           WHERE rv_domain IN ('GIAC_ACCTRANS.TRAN_FLAG')
                             AND rv_low_value = p_tran_flag)
          LOOP
             v_tran_flag := UPPER(record1.rv_meaning);
             EXIT;
          END LOOP;
       ELSE
          v_tran_flag := 'ALL';   
       END IF;
       
       RETURN(v_tran_flag);
    END;    
    
    FUNCTION cf_tran_class(
        p_tran_class    GIAC_ACCTRANS.tran_class%TYPE
    )
        RETURN VARCHAR2 
    IS
        v_tran_class    CG_REF_CODES.rv_meaning%TYPE;

    BEGIN
    
        FOR record2 IN (SELECT rv_meaning
                          FROM CG_REF_CODES
                         WHERE rv_domain IN ('GIAC_ACCTRANS.TRAN_CLASS')
                           AND rv_low_value = P_TRAN_CLASS)
        LOOP
            v_tran_class := UPPER(record2.rv_meaning);
            EXIT;
        END LOOP;

       RETURN(v_tran_class);  
    END;

    FUNCTION cf_cg_ref_codes
        RETURN VARCHAR2 
    IS
        codes VARCHAR2(1000);
    
    BEGIN
        codes := NULL;
        FOR rec IN (SELECT UPPER(SUBSTR(rv_low_value,1,1))||' - '||SUBSTR(rv_meaning,1,25) flag
                      FROM CG_REF_CODES
                     WHERE rv_domain IN ('GIAC_ACCTRANS.TRAN_FLAG'))
        LOOP
            codes := codes||rec.flag||'    ';
        END LOOP;

        RETURN(codes);  
    END;
    
    FUNCTION show_hide_col_amt(
        p_tran_class    GIAC_ACCTRANS.tran_class%TYPE
    ) 
        RETURN VARCHAR2 
    IS
        v_show_hide_col_amt VARCHAR2(10);
    
    BEGIN
    
        IF p_tran_class NOT IN ('COL','DV')
        THEN
            v_show_hide_col_amt := 'FALSE';
        ELSE
            v_show_hide_col_amt := 'TRUE';
        END IF;
        
        RETURN (v_show_hide_col_amt);
    END;
            
            
    FUNCTION show_hide_posting_date(
        p_tran_flag     GIAC_ACCTRANS.tran_flag%TYPE
    ) 
        RETURN VARCHAR2
    IS
        v_show_hide_posting_date VARCHAR2(10);
    
    BEGIN
        
        IF p_tran_flag IN ('D','C','O')
        THEN
            v_show_hide_posting_date := 'FALSE';
        ELSE
            v_show_hide_posting_date := 'TRUE';
        END IF;
        
        RETURN (v_show_hide_posting_date);
    END; 
    
    FUNCTION show_hide_status(
        p_tran_flag  GIAC_ACCTRANS.tran_flag%TYPE
    ) 
        RETURN VARCHAR2
    IS
        v_show_hide_status      varchar2(10);
    BEGIN
        
        IF p_tran_flag IS NULL
        THEN
            v_show_hide_status := 'TRUE';
        ELSE
            v_show_hide_status := 'FALSE';
        END IF;
        
        RETURN (v_show_hide_status);
    END;            

    FUNCTION get_report_detail(
        p_tran_class            GIAC_ACCTRANS.tran_class%TYPE,
        p_tran_flag             GIAC_ACCTRANS.tran_flag%TYPE,
        p_branch_cd             GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        p_from_date             DATE,
        p_to_date               DATE,
        p_user_id               GIIS_USERS.user_id%TYPE
    )
        RETURN report_detail_tab PIPELINED
    IS
        v_detail      report_detail_type;
        v_print  BOOLEAN := TRUE;
    BEGIN
        v_detail.company_name           := cf_company_name;
        v_detail.company_add            := cf_company_address;
        v_detail.header_tran_flag       := cf_tran_flag(p_tran_flag);
        v_detail.header_tran_class      := cf_tran_class(p_tran_class);
        v_detail.header_from_date       := TO_CHAR (p_from_date, 'fmMonth dd, yyyy');
        v_detail.header_to_date         := TO_CHAR (p_to_date, 'fmMon. dd, yyyy');
        
        IF p_tran_class = 'COL'
        THEN
            FOR i IN(SELECT a.tran_id, a.GIBR_BRANCH_CD, 
                            TRUNC(a.tran_date) tran_date, 
                            b.or_pref_suf || DECODE(TO_CHAR(b.or_no), NULL,NULL,'-'||TO_CHAR(b.or_no, 'FM0999999999')) or_no,
                            LTRIM(RTRIM(b.particulars)) particulars,
                            b.collection_amt collection_amt,                           
                            a.posting_date,
                            a.tran_flag
                     FROM   GIAC_ACCTRANS a,
                            GIAC_ORDER_OF_PAYTS b
                      WHERE 1 = 1
                        AND a.tran_id = b.gacc_tran_id
                        AND a.tran_flag =  NVL(p_tran_flag ,a.tran_flag) 
                        AND a.tran_class = NVL(p_tran_class,a.tran_class)
                        AND a.gibr_branch_cd = NVL(p_branch_cd,a.gibr_branch_cd)
--                        AND a.gibr_branch_cd IN (SELECT iss_cd
--                                                   FROM GIIS_ISSOURCE
--                                                  WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS231', p_user_id),
--                                                                            1, iss_cd, NULL)) -- user access already checked in branch lov
                        AND TRUNC(a.tran_date) BETWEEN p_from_date AND p_to_date                                                                   
                   ORDER BY a.gibr_branch_cd, TRUNC(a.tran_date)
            )
            LOOP
                v_print                         := FALSE;
                v_detail.tran_id                := i.tran_id;
                v_detail.gibr_branch_cd         := i.gibr_branch_cd;
                v_detail.tran_date              := i.tran_date;
                v_detail.or_no                  := i.or_no;
                v_detail.particulars            := i.particulars;
                v_detail.collection_amt         := i.collection_amt;
                v_detail.posting_date           := i.posting_date;
                v_detail.tran_flag              := i.tran_flag;
                v_detail.ref_no                 := cf_ref_no(p_tran_class);
                v_detail.codes                  := cf_cg_ref_codes;
                v_detail.show_hide_col_amt      := show_hide_col_amt(p_tran_class);
                v_detail.show_hide_posting_date := show_hide_posting_date(p_tran_flag);
                v_detail.show_hide_status       := show_hide_status(p_tran_flag);
                PIPE ROW(v_detail);
            END LOOP;
        
        ELSIF p_tran_class = 'DV'
        THEN
            FOR i IN (
                SELECT a.tran_id, a.gibr_branch_cd, 
                        TRUNC(a.tran_date) tran_date, 
                        b.check_pref_suf || DECODE(TO_CHAR(b.check_no),NULL,NULL,'-'||TO_CHAR(b.check_no, 'FM0999999999')) or_no,
                        LTRIM(RTRIM(c.particulars)) particulars,
                        b.amount collection_amt,                           
                        a.posting_date,
                        a.tran_flag
                   FROM GIAC_ACCTRANS a,
                        GIAC_CHK_DISBURSEMENT b,
                        GIAC_DISB_VOUCHERS c
                  WHERE 1 = 1
                    AND a.tran_id = b.gacc_tran_id
                    AND b.gacc_tran_id = c.gacc_tran_id
                    AND a.tran_flag =  NVL(p_tran_flag ,a.tran_flag) 
                    AND a.tran_class = NVL(p_tran_class,a.tran_class)
                    AND a.gibr_branch_cd = NVL(p_branch_cd,a.gibr_branch_cd)
                    AND TRUNC(a.tran_date) BETWEEN p_from_date AND p_to_date    
--                    AND a.gibr_branch_cd IN (SELECT iss_cd
--                           FROM GIIS_ISSOURCE
--                          WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS231', p_user_id),
--                                                    1, iss_cd, NULL))  -- user access already checked in branch lov                                                            
               ORDER BY a.gibr_branch_cd, TRUNC(a.tran_date)
            )
            LOOP
                v_print                         := FALSE;
                v_detail.tran_id                := i.tran_id;
                v_detail.gibr_branch_cd         := i.gibr_branch_cd;
                v_detail.tran_date              := i.tran_date;
                v_detail.or_no                  := i.or_no;
                v_detail.particulars            := i.particulars;
                v_detail.collection_amt         := i.collection_amt;
                v_detail.posting_date           := i.posting_date;
                v_detail.tran_flag              := i.tran_flag;
                v_detail.ref_no                 := cf_ref_no(p_tran_class);
                v_detail.codes                  := cf_cg_ref_codes;
                v_detail.show_hide_col_amt      := show_hide_col_amt(p_tran_class);
                v_detail.show_hide_posting_date := show_hide_posting_date(p_tran_flag);
                v_detail.show_hide_status       := show_hide_status(p_tran_flag);
                PIPE ROW(v_detail);
            END LOOP;
         
        ELSE
            FOR i IN (
                SELECT a.tran_id,
                       a.gibr_branch_cd, 
                       TRUNC(a.tran_date) tran_date, 
                       a.tran_class_no or_no,
                       LTRIM(RTRIM(a.particulars))particulars,
                       0 collection_amt,                           
                       a.posting_date,
                       a.tran_flag
                  FROM GIAC_ACCTRANS a
                 WHERE 1 = 1              
                   AND a.tran_flag =  NVL(p_tran_flag ,a.tran_flag)   
                   AND a.tran_class = NVL(p_tran_class,a.tran_class)
                   AND a.gibr_branch_cd = NVL(p_branch_cd,a.gibr_branch_cd)
                   AND TRUNC(a.tran_date) BETWEEN p_from_date AND p_to_date   
--                   AND a.gibr_branch_cd IN (SELECT iss_cd
--                           FROM GIIS_ISSOURCE
--                          WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2 (NULL, iss_cd, 'GIACS231', p_user_id),
--                                                    1, iss_cd, NULL)) -- user access already checked in branch lov                                                                
              ORDER BY a.gibr_branch_cd, TRUNC(a.tran_date)
            )
            LOOP
                v_print                         := FALSE;
                v_detail.tran_id                := i.tran_id;
                v_detail.gibr_branch_cd         := i.gibr_branch_cd;
                v_detail.tran_date              := i.tran_date;
                v_detail.or_no                  := i.or_no;
                v_detail.particulars            := i.particulars;
                v_detail.collection_amt         := i.collection_amt;
                v_detail.posting_date           := i.posting_date;
                v_detail.tran_flag              := i.tran_flag;
                v_detail.ref_no                 := cf_ref_no(p_tran_class);
                v_detail.codes                  := cf_cg_ref_codes;
                v_detail.show_hide_col_amt      := show_hide_col_amt(p_tran_class);
                v_detail.show_hide_posting_date := show_hide_posting_date(p_tran_flag);
                v_detail.show_hide_status       := show_hide_status(p_tran_flag);
                PIPE ROW(v_detail);
            END LOOP;
            
        END IF;
        
        IF v_print
        THEN
            v_detail.dummy := 'T';
            PIPE ROW (v_detail);
        END IF;
        
    END;

END GIACR211_PKG;
/


