CREATE OR REPLACE PACKAGE BODY CPI.GICLS253_PKG 
AS
    FUNCTION populate_per_motortype_details(
    p_payee_cd         GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
    p_from_date        VARCHAR2,
    p_to_date          VARCHAR2,
    p_as_of_date       VARCHAR2,
    p_search_by        VARCHAR2
   )
       RETURN clm_list_per_motorshop_tab PIPELINED
    IS
       ntt   clm_list_per_motorshop_type;
    BEGIN
       FOR i IN (SELECT DISTINCT (a.payee_cd) payee_cd,
                    DECODE (c.payee_first_name,NULL,c.payee_last_name,'-',c.payee_last_name,c.payee_last_name||', '||c.payee_first_name||' '|| c.payee_middle_name) payee_name,
                    (b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM (TO_CHAR (b.clm_yy, '09'))||'-'||LTRIM (TO_CHAR (b.clm_seq_no, '0000009'))) claim_number,
                    (b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LTRIM (TO_CHAR (b.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))||'-'||LTRIM (TO_CHAR (b.renew_no, '09'))) policy_number,
                    (b.issue_cd||'-'||LTRIM (TO_CHAR (b.clm_yy2, '09'))||'-'||LTRIM (TO_CHAR (b.loa_seq_no, '0009'))) loa_number,
                    b.assured_name, b.clm_file_date, b.plate_no, b.clm_stat_cd,
                    d.clm_stat_desc, NVL(b.loss_reserve, 0) loss_reserve,
                    b.dsp_loss_date, NVL(b.paid_amt, 0) paid_amt, e.loss_cat_des
               FROM gicl_loss_exp_payees a,
                    gicl_motshop_listing_v b,
                    giis_payees c,
                    giis_clm_stat d,
                    giis_loss_ctgry e,
                    gicl_claims f
              WHERE a.payee_cd = b.payee_cd
                AND a.claim_id = b.claim_id
                AND a.claim_id = f.claim_id
                AND f.line_cd = e.line_cd
                AND f.loss_cat_cd = e.loss_cat_cd
                AND a.payee_class_cd = c.payee_class_cd
                AND b.payee_cd = c.payee_no
                AND a.payee_class_cd IN (SELECT param_value_v
                                           FROM giac_parameters
                                          WHERE param_name = 'MC_PAYEE_CLASS')
                AND b.clm_stat_cd = d.clm_stat_cd
                --AND check_user_per_line (b.line_cd, b.iss_cd, 'GICLS253') = 1
                AND a.payee_cd = NVL (p_payee_cd, a.payee_cd)
                AND ((DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
                          AND (DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
                           OR (DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
                     )
            )
       LOOP
          ntt.payee_cd      := i.payee_cd;
          ntt.payee_name    := i.payee_name;
          ntt.claim_number  := i.claim_number;
          ntt.policy_number := i.policy_number;
          ntt.loa_number    := i.loa_number;
          ntt.assured_name  := i.assured_name;
          ntt.clm_file_date := i.clm_file_date;
          ntt.plate_no      := i.plate_no;
          ntt.clm_stat_cd   := i.clm_stat_cd;
          ntt.clm_stat_desc := i.clm_stat_desc;
          ntt.loss_reserve  := i.loss_reserve;
          ntt.dsp_loss_date := i.dsp_loss_date;
          ntt.paid_amt      := i.paid_amt;
          ntt.loss_cat_des  := i.loss_cat_des;
          
          IF ntt.tot_loss_reserve IS NULL
             AND ntt.tot_paid_amt IS NULL
          THEN
--            FOR j IN (SELECT  SUM(NVL(b.loss_reserve, 0)) tot_loss_reserve, SUM(NVL(b.paid_amt, 0)) tot_paid_amt
--               FROM gicl_loss_exp_payees a,
--                    gicl_motshop_listing_v b,
--                   giis_payees c,
--                    giis_clm_stat d
--              WHERE a.payee_cd = b.payee_cd
--                AND a.claim_id = b.claim_id
--                AND a.payee_class_cd = c.payee_class_cd
--                AND b.payee_cd = c.payee_no
--                AND a.payee_class_cd IN (SELECT param_value_v
--                                           FROM giac_parameters
--                                          WHERE param_name = 'MC_PAYEE_CLASS')
--                AND b.clm_stat_cd = d.clm_stat_cd
--                AND check_user_per_line (line_cd, iss_cd, 'GICLS253') = 1
--                AND a.payee_cd = NVL (p_payee_cd, a.payee_cd)
--                AND ((DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
--                          AND (DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
--                           OR (DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
--                     )
--            )        commented out by gab 09.21.2015
                FOR j IN (SELECT SUM (loss_reserve) tot_loss_reserve, SUM (paid_amt) tot_paid_amt
                 FROM (SELECT DISTINCT a.payee_cd, b.claim_id, a.payee_type,
                        a.payee_class_cd, a.item_no, a.grouped_item_no,
                        NVL (b.loss_reserve, 0) loss_reserve,
                        NVL (b.paid_amt, 0) paid_amt,
                        b.issue_cd, b.clm_yy2, b.loa_seq_no
                   FROM gicl_loss_exp_payees a, gicl_motshop_listing_v b
                  WHERE a.payee_cd = b.payee_cd
                    AND a.claim_id = b.claim_id
                    AND a.payee_class_cd IN (
                                           SELECT param_value_v
                                             FROM giac_parameters
                                            WHERE param_name =
                                                              'MC_PAYEE_CLASS')
                    AND a.payee_cd = NVL (p_payee_cd, a.payee_cd)
                AND ((DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) >= TO_DATE (p_from_date, 'MM-DD-YYYY') )
                          AND (DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) <= TO_DATE (p_to_date, 'MM-DD-YYYY'))
                           OR (DECODE (p_search_by,'lossDate', b.dsp_loss_date,'claimFileDate', b.clm_file_date) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY'))
                     ))) -- added by gab 09.21.2015
            
            LOOP
            
                ntt.tot_loss_reserve := j.tot_loss_reserve;
                ntt.tot_paid_amt     := j.tot_paid_amt;
            END LOOP;
           END IF;
          
          PIPE ROW (ntt);
       END LOOP;

       RETURN;
    END populate_per_motortype_details;
    
    
    FUNCTION validate_motorshop(
        p_payee_name         VARCHAR2
    )
        RETURN VARCHAR2
    IS
        v_temp      VARCHAR2(1);
    BEGIN
        SELECT TO_CHAR(SUM(1))
          INTO v_temp
          FROM(
            SELECT DISTINCT (a.payee_cd) payee_cd,
                    DECODE (c.payee_first_name,NULL,c.payee_last_name,'-',c.payee_last_name,c.payee_last_name||', '||c.payee_first_name||' '|| c.payee_middle_name) payee_name
               FROM gicl_loss_exp_payees a,
                    gicl_motshop_listing_v b,
                    giis_payees c
              WHERE a.payee_cd = b.payee_cd
                AND a.claim_id = b.claim_id
                AND a.payee_class_cd = c.payee_class_cd
                AND b.payee_cd = c.payee_no
                AND a.payee_class_cd IN (SELECT param_value_v
                                           FROM giac_parameters
                                          WHERE param_name = 'MC_PAYEE_CLASS')
                AND check_user_per_line (b.line_cd, b.iss_cd, 'GICLS253') = 1
                AND ( UPPER(c.payee_first_name) LIKE UPPER(NVL(p_payee_name, '%'))
                      OR
                      UPPER(c.payee_last_name) LIKE UPPER(NVL(p_payee_name, '%'))
                      OR
                      UPPER(c.payee_middle_name) LIKE UPPER(NVL(p_payee_name, '%'))
                     ));
                     
                     
          IF v_temp IS NOT NULL
          THEN
            RETURN '1';
          ELSE
            RETURN '0';
          END IF;          
   
    END validate_motorshop;
    
    FUNCTION gicls253_motorshop_lov
        RETURN gicls253_motorshop_lov_tab PIPELINED
    IS
        v_list gicls253_motorshop_lov_type;
    BEGIN
            FOR i IN(
                SELECT payee_no,
                       DECODE (payee_first_name,
                               NULL, payee_last_name,
                                  payee_last_name
                               || ', '
                               || payee_first_name
                               || ' '
                               || payee_middle_name
                              ) payee_name
                  FROM giis_payees
                 WHERE payee_class_cd IN (SELECT param_value_v
                                            FROM giac_parameters
                                           WHERE param_name = 'MC_PAYEE_CLASS')
                 ORDER BY payee_no
            )
            LOOP
                v_list.payee_no   := i.payee_no;
                v_list.payee_name := i.payee_name;
                
            PIPE ROW(v_list);
            END LOOP;
    END gicls253_motorshop_lov;

END;
/
