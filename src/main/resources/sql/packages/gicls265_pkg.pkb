CREATE OR REPLACE PACKAGE BODY CPI.GICLS265_PKG AS

    FUNCTION get_clm_list_per_cargo (
      p_user_id                 GIIS_USERS.user_id%TYPE,
      p_cargo_class_cd          GIIS_CARGO_CLASS.cargo_class_cd%TYPE,
      p_cargo_type              GIIS_CARGO_TYPE.cargo_type%TYPE,
      p_search_by               VARCHAR2,
      p_as_of_date              VARCHAR2,
      p_from_date               VARCHAR2,   
      p_to_date                 VARCHAR2
    ) 
    RETURN clm_list_per_cargo_tab PIPELINED
    IS
      ntt              clm_list_per_cargo_type;
      p_line_cd        GIIS_LINE.line_cd%TYPE := NULL;
      p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE := NULL;
    BEGIN
        FOR i IN (
            SELECT   a.cargo_class_cd, a.cargo_class_desc,
                     a.cargo_class_cd || ' - ' || a.cargo_class_desc cargo_class,
                     b.cargo_type || ' - ' || b.cargo_type_desc cargo_type_and_desc,
                     SUM (NVL (g.loss_reserve, 0)) loss_reserve,
                     SUM (NVL (g.losses_paid, 0)) losses_paid,
                     SUM (NVL (g.expense_reserve, 0)) exp_reserve,
                     SUM (NVL (g.expenses_paid, 0)) exp_paid, c.item_no, c.claim_id,
                     c.item_title, c.item_no || '-' || c.item_title grouped_item_no,
                     c.vessel_cd,
                        d.line_cd
                     || '-'
                     || d.subline_cd
                     || '-'
                     || d.iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (d.clm_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (d.clm_seq_no, '0000009')) claim_number,
                        d.line_cd
                     || '-'
                     || d.subline_cd
                     || '-'
                     || d.pol_iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (d.issue_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (d.pol_seq_no, '0000009'))
                     || '-'
                     || LTRIM (TO_CHAR (d.renew_no, '09')) policy_number,
                     d.assured_name, d.clm_yy, d.clm_seq_no, d.pol_iss_cd, d.assd_no,
                     e.clm_stat_desc, d.loss_date, d.clm_file_date, f.assd_name
                FROM giis_cargo_class a,
                     giis_cargo_type b,
                     gicl_cargo_dtl c,
                     gicl_claims d,
                     giis_clm_stat e,
                     giis_assured f,
                     gicl_clm_reserve g
               WHERE a.cargo_class_cd = b.cargo_class_cd
                 AND b.cargo_class_cd = c.cargo_class_cd
                 AND b.cargo_type = c.cargo_type
                 AND c.claim_id = d.claim_id
                 AND d.clm_stat_cd = e.clm_stat_cd
                 AND d.assd_no = f.assd_no
                 AND g.claim_id(+) = c.claim_id
                 AND g.item_no(+) = c.item_no
                 AND a.cargo_class_cd IN (
                        SELECT DISTINCT cargo_class_cd
                                   FROM giis_cargo_type
                                  WHERE cargo_class_cd IN (
                                           SELECT DISTINCT cargo_class_cd
                                                      FROM gicl_cargo_dtl
                                                     WHERE claim_id IN (
                                                              SELECT DISTINCT claim_id
                                                                         FROM gicl_claims
                                                                        WHERE check_user_per_line2
                                                                                 (line_cd, iss_cd, 'GICLS265', p_user_id) = 1)))
                 AND c.claim_id IN (
                    SELECT claim_id
                      FROM gicl_claims
                     WHERE check_user_per_line2 (line_cd, iss_cd, 'GICLS265', p_user_id) =1
                     )
                 AND a.cargo_class_cd = p_cargo_class_cd
                 AND b.cargo_type = p_cargo_type
                 AND ((DECODE (p_search_by,'lossDate', TRUNC(d.loss_date),'claimFileDate', TRUNC(d.clm_file_date)) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
                          AND (DECODE (p_search_by,'lossDate', TRUNC(d.loss_date),'claimFileDate', TRUNC(d.clm_file_date)) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
                           OR (DECODE (p_search_by,'lossDate', TRUNC(d.loss_date),'claimFileDate', TRUNC(d.clm_file_date)) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
                     )
            GROUP BY a.cargo_class_cd,
                     a.cargo_class_desc,
                     b.cargo_type,
                     b.cargo_type_desc,
                     d.assured_name,
                     c.claim_id,
                     c.item_no,
                     c.item_title,
                     c.vessel_cd,
                     d.line_cd,
                     d.clm_yy,
                     d.clm_seq_no,
                     d.pol_iss_cd,
                     d.assd_no,
                     d.renew_no,
                     d.loss_date,
                     d.clm_file_date,
                     f.assd_name,
                     e.clm_stat_desc,
                     d.subline_cd,
                     d.iss_cd,
                     d.issue_yy,
                     d.pol_seq_no
                     
        )
        
        LOOP
        
            ntt.item_no             := i.item_no;
            ntt.claim_number        := GET_CLAIM_NUMBER(i.claim_id);
            ntt.claim_id            := i.claim_id;
            ntt.item_title          := i.item_title;
            ntt.grouped_item_no     := i.grouped_item_no;
            ntt.vessel_cd           := i.vessel_cd;
            ntt.policy_number       := i.policy_number;
            ntt.assured_name        := i.assured_name;
            
            ntt.loss_res_amt        := TO_CHAR(i.loss_reserve,'999,999,999,999.99'); -- Dren 10.13.2015 SR 0004937 : improper sorting of records (Loss Reserve, Loss Paid, Expense Reserve, Expense Paid) - Start
            ntt.loss_paid_amt       := TO_CHAR(i.losses_paid,'999,999,999,999.99');
            ntt.exp_res_amt         := TO_CHAR(i.exp_reserve,'999,999,999,999.99');
            ntt.exp_paid_amt        := TO_CHAR(i.exp_paid,'999,999,999,999.99'); -- Dren 10.13.2015 SR 0004937 : improper sorting of records (Loss Reserve, Loss Paid, Expense Reserve, Expense Paid) - End
            
            ntt.loss_date           := i.loss_date;
            ntt.clm_stat_desc       := i.clm_stat_desc;
            ntt.clm_file_date       := i.clm_file_date;
            
            
        IF    ntt.tot_loss_res_amt IS NULL 
          AND ntt.tot_loss_paid_amt IS NULL
          AND ntt.tot_exp_res_amt IS NULL
          AND ntt.tot_exp_paid_amt IS NULL 
        THEN
          FOR b IN(
                SELECT SUM(NVL(e.loss_reserve,0)) loss_reserve, SUM(NVL(e.losses_paid,0)) losses_paid,
                       SUM(NVL(e.expense_reserve,0)) exp_reserve, SUM(NVL(e.expenses_paid,0)) exp_paid
                  FROM giis_cargo_class a,
                       giis_cargo_type b,
                       gicl_cargo_dtl c,
                       gicl_claims d,
                       gicl_clm_reserve e
                 WHERE a.cargo_class_cd = b.cargo_class_cd
                   AND b.cargo_class_cd = c.cargo_class_cd
                   AND b.cargo_type = c.cargo_type
                   AND c.claim_id = d.claim_id
                   AND e.claim_id = c.claim_id
                   AND e.item_no = c.item_no
                   AND c.claim_id IN (
                          SELECT claim_id
                            FROM GICL_CLAIMS
                           WHERE CHECK_USER_PER_LINE2 (p_line_cd,
                                                       p_iss_cd,
                                                       'GICLS265',
                                                       p_user_id
                                                      ) = 1)
                   AND a.cargo_class_cd = p_cargo_class_cd
                   AND b.cargo_type = p_cargo_type
                   AND ((DECODE (p_search_by,'lossDate', TRUNC(d.loss_date),'claimFileDate', TRUNC(d.clm_file_date)) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
                            AND (DECODE (p_search_by,'lossDate', TRUNC(d.loss_date),'claimFileDate', TRUNC(d.clm_file_date)) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
                             OR (DECODE (p_search_by,'lossDate', TRUNC(d.loss_date),'claimFileDate', TRUNC(d.clm_file_date)) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
                     )                     
                  )
          LOOP
            ntt.tot_loss_res_amt     := NVL(b.loss_reserve,0);
            ntt.tot_loss_paid_amt    := NVL(b.losses_paid,0);
            ntt.tot_exp_res_amt      := NVL(b.exp_reserve,0);
            ntt.tot_exp_paid_amt     := NVL(b.exp_paid,0);
          END LOOP;
        END IF;
        
        PIPE ROW(ntt);
        END LOOP;
        RETURN;
    END get_clm_list_per_cargo;
    
    FUNCTION validate_cargo_class(
      p_cargo_class_desc    giis_cargo_class.cargo_class_desc%TYPE
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
        
        BEGIN
        
        SELECT (
            SELECT 'X'
              FROM giis_cargo_class
             WHERE UPPER(cargo_class_desc) LIKE UPPER(p_cargo_class_desc)
             )
          INTO v_temp_x
          FROM DUAL;
            
            IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
            END IF; 
        
        END;
    
    FUNCTION validate_cargo_type(
      p_cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE,
      p_cargo_type_desc    giis_cargo_type.cargo_type_desc%TYPE
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
    BEGIN
    
    SELECT(
        SELECT '1'
          FROM giis_cargo_type
         WHERE cargo_class_cd = p_cargo_class_cd
           AND UPPER(cargo_type_desc) LIKE UPPER(p_cargo_type_desc)
            OR p_cargo_type_desc IS NULL)
      INTO v_temp_x
      FROM DUAL;
    
         IF v_temp_x IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
         END IF; 
    END;
    
    FUNCTION fetch_cargo_type_by_code(
      p_cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE
    )
    RETURN cargo_type_list_tab  PIPELINED
    IS
        ntt       cargo_type_list_type;
        v_count   NUMBER(12);
        
    BEGIN
        
    SELECT ( SELECT COUNT(CARGO_TYPE_DESC)
              FROM giis_cargo_type
             WHERE UPPER(cargo_class_cd) LIKE UPPER(p_cargo_class_cd)
           )
      INTO v_count
      FROM DUAL;
          
        IF v_count = 1
            THEN
                SELECT CARGO_TYPE,CARGO_TYPE_DESC
                  INTO ntt.cargo_type, ntt.cargo_type_desc
                  FROM giis_cargo_type
                 WHERE UPPER(cargo_class_cd) LIKE UPPER(p_cargo_class_cd);
                    
            ELSE
                ntt.cargo_type_desc:= 'F';
        END IF;
            
        PIPE ROW(ntt);
        
    END;
        
    FUNCTION fetch_valid_cargo_class(
        p_module_id         VARCHAR2
    )
        RETURN valid_cargo_class_tab PIPELINED
    IS
        ntt valid_cargo_class_type;
    BEGIN
    
        FOR i IN (
            SELECT   a.cargo_class_cd
                FROM giis_cargo_class a,
                     giis_cargo_type b,
                     gicl_cargo_dtl c,
                     gicl_claims d,
                     giis_clm_stat e,
                     giis_assured f,
                     gicl_clm_reserve g
               WHERE a.cargo_class_cd = b.cargo_class_cd
                 AND b.cargo_class_cd = c.cargo_class_cd
                 AND b.cargo_type = c.cargo_type
                 AND c.claim_id = d.claim_id
                 AND d.clm_stat_cd = e.clm_stat_cd
                 AND d.assd_no = f.assd_no
                 AND g.claim_id(+) = c.claim_id
                 AND g.item_no(+) = c.item_no
                 AND a.cargo_class_cd IN (
                        SELECT DISTINCT cargo_class_cd
                                   FROM giis_cargo_type
                                  WHERE cargo_class_cd IN (
                                           SELECT DISTINCT cargo_class_cd
                                                      FROM gicl_cargo_dtl
                                                     WHERE claim_id IN (
                                                              SELECT DISTINCT claim_id
                                                                         FROM gicl_claims
                                                                        WHERE check_user_per_line
                                                                                 (line_cd,
                                                                                  iss_cd,
                                                                                  p_module_id) = 1)
                                                                                  )
                                          )
                 AND c.claim_id IN (
                                SELECT claim_id
                                  FROM gicl_claims
                                 WHERE check_user_per_line (line_cd, iss_cd, p_module_id) =1)
                 --AND c.cargo_class_cd = 55
            GROUP BY a.cargo_class_cd
            )
            
            LOOP
            
                IF LENGTH(i.cargo_class_cd) > 0
                THEN
                     ntt.cargo_class_cd := i.cargo_class_cd;
                END IF;
            
            PIPE ROW(ntt);
            END LOOP;
            RETURN;
            
            
    END fetch_valid_cargo_class;
    
END;
/


