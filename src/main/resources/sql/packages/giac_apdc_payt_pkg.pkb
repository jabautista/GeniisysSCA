CREATE OR REPLACE PACKAGE BODY CPI.giac_apdc_payt_pkg
AS

   FUNCTION get_giac_apdc_payt(p_apdc_id GIAC_APDC_PAYT.apdc_id%TYPE)
   RETURN giac_apdc_payt_tab PIPELINED
   IS
      v_giac_apdc_payt          giac_apdc_payt_type;
      
   BEGIN
           FOR i IN (SELECT a.apdc_id,   a.fund_cd,     a.branch_cd,   a.apdc_date,   a.apdc_pref,
                            a.apdc_no,   a.cashier_cd,  a.payor,       a.apdc_flag,   UPPER(b.rv_meaning) apdc_flag_meaning,
                            a.user_id,   a.last_update, a.particulars, a.ref_apdc_no, a.cic_print_tag,
                            a.address_1, a.address_2,   a.address_3
                       FROM giac_apdc_payt a
                           ,cg_ref_codes b
                      WHERE a.apdc_flag = b.rv_low_value
                        AND b.rv_domain = 'GIAC_APDC_PAYT.APDC_FLAG'
                        AND apdc_id = p_apdc_id

            )
        LOOP
            v_giac_apdc_payt.apdc_id           := i.apdc_id;
            v_giac_apdc_payt.fund_cd           := i.fund_cd;
            v_giac_apdc_payt.branch_cd         := i.branch_cd;
            v_giac_apdc_payt.apdc_date         := i.apdc_date;
            v_giac_apdc_payt.apdc_pref         := i.apdc_pref;
            v_giac_apdc_payt.apdc_no           := i.apdc_no;
            v_giac_apdc_payt.cashier_cd        := i.cashier_cd;
            v_giac_apdc_payt.payor             := i.payor;
            v_giac_apdc_payt.apdc_flag         := i.apdc_flag;
            v_giac_apdc_payt.apdc_flag_meaning := i.apdc_flag_meaning;
            v_giac_apdc_payt.user_id           := i.user_id;
            v_giac_apdc_payt.last_update       := i.last_update;
            v_giac_apdc_payt.particulars       := i.particulars;
            v_giac_apdc_payt.ref_apdc_no       := i.ref_apdc_no;
            v_giac_apdc_payt.cic_print_tag       := i.cic_print_tag;
            v_giac_apdc_payt.address_1           := i.address_1;
            v_giac_apdc_payt.address_2           := i.address_2;
            v_giac_apdc_payt.address_3           := i.address_3;
            
            PIPE ROW (v_giac_apdc_payt);
        END LOOP;
        RETURN;
    END get_giac_apdc_payt;
    
    PROCEDURE pop_apdc(
       p_fund_cd        IN        GIAC_BRANCHES.gfun_fund_cd%TYPE,
          p_branch_cd        IN        GIAC_BRANCHES.branch_cd%TYPE,
       p_apdc_flag        IN        GIAC_APDC_PAYT.apdc_flag%TYPE,
       p_doc_pref_suf    OUT        GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
       p_dsp_status        OUT        VARCHAR2,
       p_default_currency OUT   GIIS_CURRENCY.main_currency_cd%TYPE,
       p_or_particulars_text OUT GIAC_PARAMETERS.param_value_v%TYPE,
       p_prem_tax_priority OUT  GIAC_PARAMETERS.param_value_v%TYPE
    )
    
    IS
    
    BEGIN
      BEGIN
         SELECT doc_pref_suf
           INTO p_doc_pref_suf
           FROM giac_doc_sequence
          WHERE doc_name = 'APDC'
            AND branch_cd = p_branch_cd
            AND fund_cd = p_fund_cd;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_doc_pref_suf := null;
      END;
            
         SELECT rv_meaning
           INTO p_dsp_status
           FROM cg_ref_codes
          WHERE rv_low_value = p_apdc_flag
            AND rv_domain = 'GIAC_APDC_PAYT.APDC_FLAG';    
                        
         p_default_currency := giacp.n('CURRENCY_CD');         
         p_prem_tax_priority := giacp.v('PREM_TAX_PRIORITY');
         p_or_particulars_text := giacp.v('OR_PARTICULARS_TEXT');                               
    END pop_apdc;
    
    PROCEDURE set_giac_apdc_payt(
       p_apdc_id                 GIAC_APDC_PAYT.apdc_id%TYPE,
       p_fund_cd                 GIAC_APDC_PAYT.fund_cd%TYPE,
       p_branch_cd                 GIAC_APDC_PAYT.branch_cd%TYPE,
       p_apdc_date                 GIAC_APDC_PAYT.apdc_date%TYPE,
       p_apdc_pref                 GIAC_APDC_PAYT.apdc_pref%TYPE,
       p_apdc_no                 GIAC_APDC_PAYT.apdc_no%TYPE,
       p_cashier_cd                 GIAC_APDC_PAYT.cashier_cd%TYPE,
       p_payor                     GIAC_APDC_PAYT.payor%TYPE,
       p_apdc_flag                 GIAC_APDC_PAYT.apdc_flag%TYPE,
       p_particulars             GIAC_APDC_PAYT.particulars%TYPE,
       p_ref_apdc_no             GIAC_APDC_PAYT.ref_apdc_no%TYPE,
       p_address_1                 GIAC_APDC_PAYT.address_1%TYPE,
       p_address_2                 GIAC_APDC_PAYT.address_2%TYPE,
       p_address_3                 GIAC_APDC_PAYT.address_3%TYPE,
       p_cic_print_tag             GIAC_APDC_PAYT.cic_print_tag%TYPE
    )
    
    IS
        v_particulars               GIAC_APDC_PAYT.particulars%TYPE;
    BEGIN
        -- marco - UCPB SR 20752 - 11.12.2015 
        IF LENGTH(p_particulars) > 500 THEN
            v_particulars := GIACP.v('OR_PARTICULARS_TEXT') || ' various policies';
        ELSE
            v_particulars := p_particulars;
        END IF;
        
        MERGE INTO GIAC_APDC_PAYT
        USING DUAL ON (apdc_id = p_apdc_id)
        WHEN NOT MATCHED THEN
             INSERT (apdc_id, fund_cd, branch_cd, apdc_date, apdc_pref, apdc_no,
                        cashier_cd, payor, apdc_flag, user_id, last_update, particulars, ref_apdc_no,
                     address_1, address_2, address_3, cic_print_tag) 
             VALUES (p_apdc_id, p_fund_cd, p_branch_cd, p_apdc_date, p_apdc_pref, p_apdc_no,
                      p_cashier_cd, p_payor, p_apdc_flag, USER, SYSDATE, v_particulars, p_ref_apdc_no,
                     p_address_1, p_address_2, p_address_3, p_cic_print_tag)
        WHEN MATCHED THEN
           UPDATE SET fund_cd           = p_fund_cd,
                           branch_cd          = p_branch_cd,
                      apdc_date        = p_apdc_date,
                      apdc_pref        = p_apdc_pref,
                      apdc_no        = p_apdc_no,
                      cashier_cd    = p_cashier_cd,
                      payor            = p_payor,
                      apdc_flag        = p_apdc_flag,
                      user_id        = USER,
                      last_update    = SYSDATE,
                      particulars    = v_particulars,
                      ref_apdc_no     = p_ref_apdc_no,
                      address_1        = p_address_1,
                      address_2        = p_address_2,
                      address_3        = p_address_3,
                      cic_print_tag    = p_cic_print_tag;             
    END set_giac_apdc_payt;
    
    PROCEDURE delete_giac_apdc_payt (
       p_apdc_id            GIAC_APDC_PAYT.apdc_id%TYPE
    )
    
    IS
    
    BEGIN
       
       FOR i IN (
         SELECT pdc_id
           FROM giac_apdc_payt_dtl
          WHERE apdc_id = p_apdc_id)
       LOOP
         DELETE
           FROM giac_pdc_prem_colln
          WHERE pdc_id = i.pdc_id;
          
         DELETE  --added delete - Halley 11.14.13
           FROM giac_pdc_replace
          WHERE pdc_id = i.pdc_id; 
       END LOOP;
    
       DELETE 
         FROM giac_apdc_payt_dtl
        WHERE apdc_id = p_apdc_id;
    
       DELETE
         FROM giac_apdc_payt
        WHERE apdc_id = p_apdc_id;
         
    END delete_giac_apdc_payt;

    FUNCTION verify_apdc_no(
        p_apdc_no            GIAC_APDC_PAYT.apdc_no%TYPE,
        p_apdc_pref            GIAC_APDC_PAYT.apdc_pref%TYPE,
        p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
        p_fund_cd            GIAC_BRANCHES.gfun_fund_cd%TYPE
    ) RETURN VARCHAR2
    
    IS
      
      v_message         VARCHAR2(100);
      v_exists         VARCHAR2(1);
      
    BEGIN
         FOR rec IN (
              SELECT 1
               FROM giac_apdc_payt
              WHERE apdc_no = p_apdc_no
                  AND apdc_pref = p_apdc_pref
                AND branch_cd = p_branch_cd
                AND fund_cd = p_fund_cd
         ) 
         
         LOOP
              v_exists := 'Y';
             EXIT;
         END LOOP;
         
         IF v_exists = 'Y' THEN
             v_message := 'This APDC Number already exists.';
         ELSE
             v_message := 'Success';
         END IF;
         
         RETURN (v_message);
    END verify_apdc_no;  
    
    PROCEDURE get_doc_seq_no(
        p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
        p_fund_cd            GIAC_BRANCHES.gfun_fund_cd%TYPE,
        p_doc_seq_no        OUT GIAC_APDC_PAYT.apdc_no%TYPE
    )
    
    IS
      
      v_apdc_seq_no            NUMBER(10);
      
    BEGIN
         SELECT doc_seq_no
           INTO p_doc_seq_no    
           FROM giac_doc_sequence 
          WHERE doc_name = 'APDC'
            AND branch_cd = p_branch_cd
            AND fund_cd = p_fund_cd
          FOR UPDATE NOWAIT;
          
         --RETURN (v_apdc_seq_no);
    END get_doc_seq_no;
      
    PROCEDURE save_print_changes(
        p_apdc_id                 GIAC_APDC_PAYT.apdc_id%TYPE,
        p_apdc_no                 GIAC_APDC_PAYT.apdc_no%TYPE,
        p_new_seq_no             GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_branch_cd                 GIAC_BRANCHES.branch_cd%TYPE,
        p_fund_cd                 GIAC_BRANCHES.gfun_fund_cd%TYPE,
        p_cic_print_tag         giac_apdc_payt.cic_print_tag%TYPE
    )
    
    IS
    
    BEGIN
          UPDATE giac_doc_sequence 
              SET doc_seq_no = p_new_seq_no
          WHERE doc_name = 'APDC'
               AND branch_cd = p_branch_cd
            AND fund_cd = p_fund_cd;
            
         UPDATE giac_apdc_payt
            SET apdc_flag = 'P',
                apdc_no = p_apdc_no,
                cic_print_tag = p_cic_print_tag -- andrew - 08.13.2012 - added update for cic_print_tag
          WHERE apdc_id = p_apdc_id;      
    END save_print_changes;
    
 FUNCTION get_apdc_ref_no(
        p_tran_id            giac_acctrans.tran_id%TYPE
    ) RETURN VARCHAR2
    
    IS
      
       v_apdc_ref_no    VARCHAR2(50);
      
    BEGIN
        SELECT apdc_pref||'-'||apdc_no ref_no
        into v_apdc_ref_no
               FROM giac_apdc_payt
              WHERE apdc_id = p_tran_id;
         
         RETURN (v_apdc_ref_no);
    END get_apdc_ref_no;    

/**
 *  Created By:     Andrew Robes
 *  Date:           10.29.2011
 *  Module:         (GIACS090 - Acknowledgment Receipt)
 *  Description:    Function to retrive giac_apdc_payt records
 */
   FUNCTION get_giac_apdc_payt_listing(
         p_fund_cd                GIAC_BRANCHES.gfun_fund_cd%TYPE,
         p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
         p_apdc_date            VARCHAR2,
      p_apdc_no             VARCHAR2,
      p_payor               VARCHAR2,
      p_ref_apdc_no         VARCHAR2,
      p_particulars         VARCHAR2,
      p_status              VARCHAR2,
      p_apdc_flag           giac_apdc_payt.apdc_flag%TYPE --benjo 11.08.2016 SR-5802
   )RETURN giac_apdc_payt_tab PIPELINED
   
   IS
      v_giac_apdc_payt          giac_apdc_payt_type;
      
   BEGIN
           FOR i IN (SELECT a.apdc_id,     a.fund_cd,            a.branch_cd,     a.apdc_date,     a.apdc_pref,
                            a.apdc_no,     a.cashier_cd,      a.payor,           a.apdc_flag,     UPPER(b.rv_meaning) apdc_flag_meaning,
                         a.user_id,     a.last_update,      a.particulars,    a.ref_apdc_no,  a.cic_print_tag,
                         a.address_1,    a.address_2,     a.address_3
                     FROM giac_apdc_payt a, cg_ref_codes b
                      WHERE a.apdc_flag = b.rv_low_value
                        AND b.rv_domain = 'GIAC_APDC_PAYT.APDC_FLAG'
                     AND fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd
                     AND TRUNC(apdc_date) = NVL(TO_DATE(p_apdc_date, 'MM-DD-YYYY'), TRUNC(apdc_date))
                     AND UPPER(apdc_pref || '-' || apdc_no) LIKE NVL(UPPER(p_apdc_no), '%')
                     AND UPPER(payor) LIKE NVL(UPPER(p_payor), '%')
                     AND NVL(UPPER(ref_apdc_no), '%') LIKE NVL(UPPER(p_ref_apdc_no), '%')
                     AND NVL(UPPER(particulars), '%') LIKE NVL(UPPER(p_particulars), '%')
                     AND UPPER(b.rv_meaning) LIKE NVL(UPPER(p_status), '%')
                     AND NVL(a.apdc_flag, 'N') = NVL(p_apdc_flag, 'N') --benjo 11.08.2016 SR-5802
                   ORDER BY apdc_no DESC, apdc_date DESC
            )
        LOOP
            v_giac_apdc_payt.apdc_id                           := i.apdc_id;
            v_giac_apdc_payt.fund_cd                      := i.fund_cd;
            v_giac_apdc_payt.branch_cd                      := i.branch_cd;
            v_giac_apdc_payt.apdc_date                      := i.apdc_date;
            v_giac_apdc_payt.apdc_pref                      := i.apdc_pref;
            v_giac_apdc_payt.apdc_no                      := i.apdc_no;
            v_giac_apdc_payt.cashier_cd                      := i.cashier_cd;
            v_giac_apdc_payt.payor                          := i.payor;
            v_giac_apdc_payt.apdc_flag                      := i.apdc_flag;
            v_giac_apdc_payt.apdc_flag_meaning              := i.apdc_flag_meaning;
            v_giac_apdc_payt.user_id                      := i.user_id;
            v_giac_apdc_payt.last_update                  := i.last_update;
            v_giac_apdc_payt.particulars                  := i.particulars;
            v_giac_apdc_payt.ref_apdc_no                  := i.ref_apdc_no;
            v_giac_apdc_payt.cic_print_tag                  := i.cic_print_tag;
            v_giac_apdc_payt.address_1                      := i.address_1;
            v_giac_apdc_payt.address_2                      := i.address_2;
            v_giac_apdc_payt.address_3                      := i.address_3;
            
            PIPE ROW (v_giac_apdc_payt);
        END LOOP;
        RETURN;
    END get_giac_apdc_payt_listing;


/**
 *  Created By:     Andrew Robes
 *  Date:           11.18.2011
 *  Module:         (GIACS090 - Acknowledgment Receipt)
 *  Description:    Procedure to cancel apdc_payt record
 */      
    PROCEDURE cancel_apdc_payt(p_apdc_id IN GIAC_APDC_PAYT.apdc_id%TYPE)
    IS
    BEGIN 
      UPDATE giac_apdc_payt
         SET apdc_flag = 'C'
       WHERE apdc_id = p_apdc_id;

      UPDATE giac_apdc_payt_dtl
         SET check_flag = 'C'
       WHERE apdc_id = p_apdc_id;

      FOR i IN (SELECT a.pdc_id
                  FROM giac_pdc_prem_colln a,
                       giac_apdc_payt_dtl b,
                       giac_apdc_payt c
                 WHERE a.pdc_id = b.pdc_id
                   AND b.apdc_id = c.apdc_id
                   AND b.apdc_id = p_apdc_id)
      LOOP
         DELETE FROM giac_pdc_prem_colln
               WHERE pdc_id = i.pdc_id;
      END LOOP;   
    END;    
    
/**
 *  Created By:     Andrew Robes
 *  Date:           1.17.2012
 *  Module:         (GIACS090 - Acknowledgment Receipt)
 *  Description:    Procedure to execute post commit processes.
 */       
    PROCEDURE giacs090_post_commit(p_apdc_id GIAC_APDC_PAYT.apdc_id%TYPE)
    AS
      v_count NUMBER;
    BEGIN
      FOR i IN (
        SELECT pdc_id
          FROM giac_apdc_payt_dtl
         WHERE apdc_id = p_apdc_id
      ) 
      LOOP
        v_count := 0;
        
        FOR x IN (
            SELECT 1
              FROM giac_pdc_prem_colln
             WHERE pdc_id = i.pdc_id)
        LOOP
          v_count := 1;
          EXIT;
        END LOOP;
         
         IF v_count = 0 THEN
           UPDATE giac_apdc_payt_dtl
              SET --payor = NULL,
                  --address_1 = NULL,
                  --address_2 = NULL,
                  --address_3 = NULL,
                  --tin = NULL,
                  --intm_no = NULL,
                  --particulars = NULL, - marco - 04.19.2013 - comment out (SR# 12501)
                  check_flag = 'N'
            WHERE apdc_id = p_apdc_id
              AND pdc_id = i.pdc_id;
         END IF;
      END LOOP;
    END;
    
END giac_apdc_payt_pkg;
/


