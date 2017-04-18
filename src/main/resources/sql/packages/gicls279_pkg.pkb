CREATE OR REPLACE PACKAGE BODY CPI.GICLS279_PKG AS
/*  Created by : Windell Valle
 *  Date Created: 06/06/13
 *  Reference By: GICLS279
 *  Description: Package for Claim Listing Per Block
 */
    FUNCTION get_clm_list_per_block (
      p_user_id             GIIS_USERS.user_id%TYPE,
      p_district_no         GIIS_BLOCK.district_no%TYPE,
      p_block_no            GIIS_BLOCK.block_no%TYPE,
      p_search_by           VARCHAR2,
      p_as_of_date          VARCHAR2,
      p_from_date           VARCHAR2,   
      p_to_date             VARCHAR2
    ) 
        RETURN clm_list_per_block_tab PIPELINED
    IS
      v_list clm_list_per_block_type;
      p_line_cd        GIIS_LINE.line_cd%TYPE := NULL;  
      p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE := NULL;
    BEGIN
      FOR i IN (SELECT c003.claim_id, TO_CHAR (gcr.item_no, '000000009') item_no,
                       get_gpa_item_title (gcr.claim_id,
                                           c003.line_cd,
                                           gcr.item_no,
                                           gcr.grouped_item_no
                                          ) AS item_title,
                       NVL (gcr.loss_reserve, 0.00) AS loss_res_amt,
                       NVL (gcr.losses_paid, 0.00) AS loss_paid_amt,
                       NVL (gcr.expense_reserve, 0.00) AS exp_res_amt,
                       NVL (gcr.expenses_paid, 0.00) AS exp_paid_amt,
                          c003.line_cd
                       || '-'
                       || c003.subline_cd
                       || '-'
                       || c003.pol_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (c003.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (c003.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (c003.renew_no, '09')) policy_no,
                       c003.assured_name assd_name, c003.clm_stat_desc, c003.loss_date,
                       c003.clm_file_date, gfd.block_id
                  FROM (SELECT   *
                            FROM (SELECT DISTINCT a.district_no, a.block_id, a.block_no,
                                                  b.block_desc, b.district_desc
                                             FROM gicl_fire_dtl a, giis_block b
                                            WHERE a.block_id = b.block_id)
                        ORDER BY district_no, district_desc, block_no, block_desc) gfd,
                        --
                       (SELECT   *
                            FROM (SELECT DISTINCT a.claim_id, a.block_id, b.loss_date,
                                                  b.clm_file_date, b.line_cd, b.subline_cd,
                                                  b.line_cd line_cd1,
                                                  b.subline_cd subline_cd1, b.issue_yy,
                                                  b.pol_seq_no, b.renew_no, b.pol_iss_cd,
                                                  b.clm_yy, b.clm_seq_no, b.iss_cd, b.assd_no,
                                                  b.clm_stat_cd, b.assured_name,
                                                  c.clm_stat_desc
                                             FROM gicl_fire_dtl a,
                                                  gicl_claims b,
                                                  giis_clm_stat c
                                            WHERE a.claim_id = b.claim_id
                                              AND b.clm_stat_cd = c.clm_stat_cd)
                        ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no, line_cd1, subline_cd1,
                                 pol_iss_cd,issue_yy, pol_seq_no,renew_no, assured_name, loss_date) c003,
                       --
                       (SELECT   *
                            FROM (SELECT   claim_id, item_no, grouped_item_no,
                                           SUM (loss_reserve) loss_reserve,
                                           SUM (losses_paid) losses_paid,
                                           SUM (expense_reserve) expense_reserve,
                                           SUM (expenses_paid) expenses_paid
                                      FROM gicl_clm_reserve
                                  GROUP BY claim_id, item_no, grouped_item_no)
                                  ORDER BY item_no) gcr
                 WHERE gfd.block_id = c003.block_id
                   AND c003.claim_id = gcr.claim_id
                   AND gcr.item_no IN (SELECT item_no
                                         FROM gicl_fire_dtl
                                        WHERE block_id = gfd.block_id
                                          AND claim_id = c003.claim_id
                                                                )
                   AND gfd.district_no = p_district_no
                   AND gfd.block_no = NVL(p_block_no,gfd.block_no)        
                   --
                   AND item_no in (SELECT DISTINCT item_no 
                                     FROM gicl_clm_item
                                    WHERE UPPER(item_title) LIKE UPPER(get_gpa_item_title (gcr.claim_id,
                                                                                           c003.line_cd,
                                                                                           gcr.item_no,
                                                                                           gcr.grouped_item_no
                                                                                          ))
                                      AND claim_id = C003.claim_id) 
                   AND ((DECODE (p_search_by,
                                           'lossDate', TRUNC(c003.loss_date),
                                           'claimFileDate', TRUNC(c003.clm_file_date)) >= TRUNC(TO_DATE(p_from_date, 'MM-DD-YYYY')))
                                   AND (DECODE (p_search_by,
                                                'lossDate', TRUNC(c003.loss_date),
                                                'claimFileDate', TRUNC(c003.clm_file_date)) <= TRUNC(TO_DATE(p_to_date, 'MM-DD-YYYY')))
                                   OR (DECODE (p_search_by,
                                                'lossDate', TRUNC(c003.loss_date),
                                                'claimFileDate', TRUNC(c003.clm_file_date)) <= TRUNC(TO_DATE(p_as_of_date, 'MM-DD-YYYY')))
                                 )
      )
      
      LOOP
        v_list.claim_id         := i.claim_id;
        v_list.item_no          := i.item_no;
        v_list.item_title       := i.item_title;
        v_list.claim_number     := GET_CLAIM_NUMBER(i.claim_id);
        v_list.loss_res_amt     := i.loss_res_amt;
        v_list.loss_paid_amt    := i.loss_paid_amt;
        v_list.exp_res_amt      := i.exp_res_amt;
        v_list.exp_paid_amt     := i.exp_paid_amt;
        v_list.policy_no        := i.policy_no;
        v_list.assd_name        := i.assd_name;
        v_list.clm_stat_desc    := i.clm_stat_desc;
        v_list.loss_date        := i.loss_date;
        v_list.clm_file_date    := i.clm_file_date;        
        v_list.block_id         := i.block_id; 
        
        IF v_list.tot_loss_res_amt IS NULL 
          AND v_list.tot_loss_paid_amt IS NULL
          AND v_list.tot_exp_res_amt IS NULL
          AND v_list.tot_exp_paid_amt IS NULL 
        THEN
          FOR b IN(
                SELECT SUM(NVL(b.loss_reserve,0)) loss_reserve, SUM(NVL(b.losses_paid,0)) losses_paid,
                       SUM(NVL(b.expense_reserve,0)) exp_reserve, SUM(NVL(b.expenses_paid,0)) exp_paid
                  FROM GICL_FIRE_DTL a,
                       GICL_CLM_RESERVE b,
                       GICL_CLAIMS c
                 WHERE b.claim_id = a.claim_id
                   AND b.item_no = a.item_no
                   AND c.claim_id = a.claim_id
                   AND a.claim_id IN (
                          SELECT claim_id
                            FROM GICL_CLAIMS
                           WHERE CHECK_USER_PER_LINE2 (p_line_cd,
                                                       p_iss_cd,
                                                       'GICLS279',
                                                       p_user_id
                                                      ) = 1)
                   AND a.district_no = p_district_no
                   AND a.block_no = p_block_no
                   AND ((DECODE (p_search_by,
                                 'lossDate', c.loss_date,
                                 'claimFileDate', c.clm_file_date) >= TO_DATE(p_from_date, 'MM-DD-YYYY'))
                         AND (DECODE (p_search_by,
                                      'lossDate', c.loss_date,
                                      'claimFileDate', c.clm_file_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                         OR (DECODE (p_search_by,
                                     'lossDate', c.loss_date,
                                     'claimFileDate', c.clm_file_date) <= TO_DATE(p_as_of_date, 'MM-DD-YYYY'))
                       )                  
                  )
          LOOP
            v_list.tot_loss_res_amt     := NVL(b.loss_reserve,0);
            v_list.tot_loss_paid_amt    := NVL(b.losses_paid,0);
            v_list.tot_exp_res_amt      := NVL(b.exp_reserve,0);
            v_list.tot_exp_paid_amt     := NVL(b.exp_paid,0);
          END LOOP;
         
        END IF;
        
        PIPE ROW(v_list);
        
      END LOOP;
      
      RETURN;
    
    END get_clm_list_per_block;    
    
    
    FUNCTION validate_district_per_block(
        p_block_no           GIIS_BLOCK.block_no%TYPE,
        p_district           GIIS_BLOCK.district_desc%TYPE
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
      
    BEGIN
       
    SELECT(SELECT 'X'
             FROM GIIS_BLOCK
            WHERE block_no = NVL(p_block_no, block_no)
              AND UPPER(TRIM(district_desc)) LIKE UPPER((NVL(p_district, '%')))
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
         
    FUNCTION validate_block_per_block(
        p_block        GIIS_BLOCK.block_desc%TYPE
    )
    RETURN VARCHAR2
    IS
        v_temp_x    VARCHAR2(1);
      
    BEGIN
       
    SELECT(SELECT DISTINCT 'X'
             FROM GIIS_BLOCK
            WHERE UPPER(TRIM(block_desc)) LIKE UPPER((NVL(p_block, '%')))
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
    
    FUNCTION get_block_by_district(
      p_district_no       GIIS_BLOCK.district_no%TYPE)
    RETURN block_list_tab PIPELINED
    IS
        ntt       block_list_type;
        v_count   NUMBER(12);
        
    BEGIN
        
    SELECT ( SELECT COUNT(block_desc)
              FROM giis_block
             WHERE UPPER(district_no) LIKE UPPER(p_district_no)
           )
      INTO v_count
      FROM DUAL;
          
        IF v_count = 1 THEN
            SELECT block_no,block_desc
              INTO ntt.block_no, ntt.block_desc
              FROM giis_block
             WHERE UPPER(district_no) LIKE UPPER(p_district_no);
                    
        ELSE
            ntt.block_desc:= 'F';
        END IF;
            
        PIPE ROW(ntt);
        
    END;
   
      
END;
/


