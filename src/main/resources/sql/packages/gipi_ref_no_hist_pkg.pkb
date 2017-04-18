CREATE OR REPLACE PACKAGE BODY CPI.gipi_ref_no_hist_pkg
AS  

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  11-15-2010 
    **  Reference By : (GIACS002 - Basic Information)  
    **  Description  :  BANK_REF_NO_RG record group 
    */  
    FUNCTION get_bank_ref_no_list(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_keyword       VARCHAR2)
    RETURN bank_ref_no_tab PIPELINED IS
      v_list    bank_ref_no_type;
    BEGIN
        FOR i IN (SELECT lpad(acct_iss_cd,2,0) acct_iss_cd, 
                         lpad(branch_cd,4,0) branch_cd, 
                         lpad(ref_no,7,0) ref_no, 
                         lpad(mod_no,2,0) mod_no, 
                         bank_ref_no
                    FROM gipi_ref_no_hist b
                   WHERE NOT EXISTS (
                           SELECT bank_ref_no
                             FROM gipi_wpolbas a
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_polbasic
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_quote
                            WHERE bank_ref_no = b.bank_ref_no)
                     AND branch_cd <> 0
                     AND branch_cd = DECODE (p_branch_cd,
                                             0, branch_cd,
                                             NULL, branch_cd,
                                             p_branch_cd
                                             )
                     AND acct_iss_cd = DECODE (p_branch_cd,
                                               0, acct_iss_cd,
                                               NULL, acct_iss_cd,
                                               p_acct_iss_cd
                                               )
                     AND bank_ref_no LIKE NVL('%'||p_keyword||'%','%')
                ORDER BY bank_ref_no)
        LOOP
            v_list.acct_iss_cd      := i.acct_iss_cd;
            v_list.branch_cd        := i.branch_cd;    
            v_list.ref_no           := i.ref_no;
            v_list.mod_no           := i.mod_no;
            v_list.bank_ref_no      := i.bank_ref_no;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    /*
    **  Created by   :  Veronica V. Raymundo
    **  Date Created :  September 7, 2011 
    **  Reference By : (GIPIS002A - Package PAR Basic Information)  
    **  Description  :  Retrieves of list of valid bank_ref_no for a Package PAR 
    */  
    FUNCTION get_bank_ref_no_list_for_pack(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_keyword       VARCHAR2)
    RETURN bank_ref_no_tab PIPELINED IS
      v_list    bank_ref_no_type;
    BEGIN
        FOR i IN (SELECT lpad(acct_iss_cd,2,0) acct_iss_cd, 
                         lpad(branch_cd,4,0) branch_cd, 
                         lpad(ref_no,7,0) ref_no, 
                         lpad(mod_no,2,0) mod_no, 
                         bank_ref_no
                    FROM gipi_ref_no_hist b
                   WHERE NOT EXISTS (
                           SELECT bank_ref_no
                             FROM gipi_wpolbas
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_pack_wpolbas
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_polbasic
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_pack_polbasic
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_quote
                            WHERE bank_ref_no = b.bank_ref_no
                           UNION
                           SELECT bank_ref_no
                             FROM gipi_pack_quote
                            WHERE bank_ref_no = b.bank_ref_no)
                     AND branch_cd <> 0
                     AND branch_cd = DECODE (p_branch_cd,
                                             0, branch_cd,
                                             NULL, branch_cd,
                                             p_branch_cd
                                             )
                     AND acct_iss_cd = DECODE (p_branch_cd,
                                               0, acct_iss_cd,
                                               NULL, acct_iss_cd,
                                               p_acct_iss_cd
                                               )
                     AND bank_ref_no LIKE NVL('%'||p_keyword||'%','%')
                ORDER BY bank_ref_no)
        LOOP
            v_list.acct_iss_cd      := i.acct_iss_cd;
            v_list.branch_cd        := i.branch_cd;    
            v_list.ref_no           := i.ref_no;
            v_list.mod_no           := i.mod_no;
            v_list.bank_ref_no      := i.bank_ref_no;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    FUNCTION get_ref_no_hist_list_by_user(
        p_user_id       GIPI_REF_NO_HIST.user_id%TYPE,
        p_acct_iss_cd   GIPI_REF_NO_HIST.acct_iss_cd%TYPE,
        p_branch_cd     GIPI_REF_NO_HIST.branch_cd%TYPE,
        p_ref_no        GIPI_REF_NO_HIST.ref_no%TYPE,
        p_mod_no        GIPI_REF_NO_HIST.mod_no%TYPE,
        p_remarks       GIPI_REF_NO_HIST.remarks%TYPE,
        p_last_update   VARCHAR2
    )
      RETURN ref_no_hist_tab PIPELINED
    IS
        v_row           ref_no_hist_type;
    BEGIN
       FOR i IN(SELECT *
                  FROM GIPI_REF_NO_HIST
                 WHERE user_id = p_user_id
                   AND acct_iss_cd = NVL(p_acct_iss_cd, acct_iss_cd)
                   AND branch_cd = NVL(p_branch_cd, branch_cd)
                   AND ref_no = NVL(p_ref_no, ref_no)
                   AND mod_no = NVL(p_mod_no, mod_no)
                   AND UPPER(NVL(remarks, '%')) LIKE UPPER(NVL(p_remarks, NVL(remarks, '%')))
                   AND TRUNC(last_update) = TRUNC(NVL(TO_DATE(p_last_update, 'mm-dd-yyyy'), last_update))
                 ORDER BY last_update DESC, bank_ref_no DESC)
       LOOP
          v_row.acct_iss_cd := LTRIM(TO_CHAR(i.acct_iss_cd, '09'));
          v_row.branch_cd := LTRIM(TO_CHAR(i.branch_cd, '0999'));
          v_row.ref_no := LTRIM(TO_CHAR(i.ref_no, '0999999'));
          v_row.mod_no := LTRIM(TO_CHAR(i.mod_no, '09'));
          v_row.remarks := i.remarks;
          v_row.user_id := i.user_id;
          v_row.last_update := LTRIM(TO_CHAR(i.last_update, 'mm-dd-yyyy'));
          
          PIPE ROW(v_row);
       END LOOP;
    END;
    
    FUNCTION get_mod_no(
        p_acct_iss_cd   GIPI_REF_NO_HIST.acct_iss_cd%TYPE,
        p_branch_cd     GIPI_REF_NO_HIST.branch_cd%TYPE,
        p_ref_no        GIPI_REF_NO_HIST.ref_no%TYPE
    )
      RETURN NUMBER
    IS
        v_mod_no        GIPI_REF_NO_HIST.mod_no%TYPE;
    BEGIN
        SELECT LPAD(mod_no, 2, 0)
          INTO v_mod_no
          FROM GIPI_REF_NO_HIST
         WHERE acct_iss_cd = p_acct_iss_cd
           AND branch_cd = p_branch_cd
           AND ref_no = p_ref_no;
           
        RETURN v_mod_no;
    EXCEPTION
        WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
            RETURN NULL;
    END;
    
    FUNCTION get_unused_ref_no(
        p_user_id       GIPI_REF_NO_HIST.user_id%TYPE,
        p_range         NUMBER,
        p_exact_date    VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
      RETURN ref_no_hist_tab PIPELINED
    IS
        v_row           ref_no_hist_type;
    BEGIN
        FOR i IN(SELECT b.*
                   FROM gipi_ref_no_hist b
                  WHERE user_id = p_user_id
                    AND TRUNC(last_update) = TRUNC(DECODE(p_range, 1, TO_DATE(p_exact_date, 'mm-dd-yyyy'), last_update))
                    AND TRUNC(last_update) <= TRUNC(DECODE(p_range, 2, TO_DATE(p_as_of_date, 'mm-dd-yyyy'), last_update))
                    AND TRUNC(last_update) BETWEEN TRUNC(DECODE(p_range, 3, TO_DATE(p_from_date, 'mm-dd-yyyy'), last_update))
                    AND TRUNC(DECODE(p_range, 3, TO_DATE(p_to_date, 'mm-dd-yyyy'), last_update))
                    AND NOT EXISTS (
                            SELECT bank_ref_no
                              FROM gipi_wpolbas
                             WHERE bank_ref_no = b.bank_ref_no
                            UNION
                            SELECT bank_ref_no
                              FROM gipi_pack_wpolbas
                             WHERE bank_ref_no = b.bank_ref_no
                            UNION           
                            SELECT bank_ref_no
                              FROM gipi_polbasic
                             WHERE bank_ref_no = b.bank_ref_no
                            UNION
                            SELECT bank_ref_no
                              FROM gipi_pack_polbasic
                             WHERE bank_ref_no = b.bank_ref_no
                            UNION           
                            SELECT bank_ref_no
                              FROM gipi_quote
                             WHERE bank_ref_no = b.bank_ref_no
                             UNION
                            SELECT bank_ref_no
                              FROM gipi_pack_quote
                             WHERE bank_ref_no = b.bank_ref_no))
        LOOP
            v_row.acct_iss_cd := i.acct_iss_cd;
            v_row.branch_cd := i.branch_cd;
            v_row.ref_no := i.ref_no;
            v_row.mod_no := i.mod_no;
            v_row.remarks := i.remarks;
            v_row.user_id := i.user_id;
            v_row.bank_ref_no := i.bank_ref_no;
            v_row.last_update := TO_CHAR(i.last_update, 'mm-dd-yyyy');
            PIPE ROW(v_row);
        END LOOP;
    END;
    
END;
/


