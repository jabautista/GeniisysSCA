CREATE OR REPLACE PACKAGE BODY CPI.GICLS540_PKG
AS
     
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 08.02.2013
   **  Reference By : GICLS540
   **  Remarks      : branch list of values for gicls540
   */    
    FUNCTION get_rep_clm_branch_lov(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED
    AS
        v_list  branch_type;
    BEGIN
        FOR q IN(SELECT iss_cd, iss_name 
                   FROM giis_issource a
                  WHERE CHECK_USER_PER_ISS_CD2(NVL(p_line_cd,NULL), a.iss_cd, 'GICLS540', p_user_id) = 1
               ORDER BY iss_cd, iss_name)
        LOOP
            v_list.iss_cd   := q.iss_cd;
            v_list.iss_name := q.iss_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_branch_lov;

    FUNCTION get_rep_clm_line_lov(
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN line_tab PIPELINED
    AS
        v_list  line_type;
    BEGIN
        FOR q IN( SELECT line_cd, line_name 
                    FROM giis_line a
                   WHERE CHECK_USER_PER_ISS_CD2(a.line_cd, NVL(p_iss_cd,NULL), 'GICLS540', p_user_id) = 1
                ORDER BY line_cd, line_name)
        LOOP
            v_list.line_cd   := q.line_cd;
            v_list.line_name := q.line_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_line_lov;

    FUNCTION get_rep_clm_assured_lov
        RETURN assured_tab PIPELINED
    AS
        v_list  assured_type;
    BEGIN
        FOR q IN(SELECT DISTINCT a.assd_no, b.assd_name
                   FROM gicl_claims a, giis_assured b 
                  WHERE a.assd_no = b.assd_no
               ORDER BY b.assd_name)
        LOOP
            v_list.assured_no   := q.assd_no;
            v_list.assured_name := q.assd_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_assured_lov;            
    
    FUNCTION get_rep_clm_intm_lov
        RETURN intm_tab PIPELINED
    AS
        v_list  intm_type;
    BEGIN
        FOR q IN(SELECT intm_no, intm_name
                   FROM giis_intermediary)
        LOOP
            v_list.intm_no   := q.intm_no;
            v_list.intm_name := q.intm_name;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_intm_lov;

    FUNCTION get_rep_clm_stat_lov
        RETURN clm_stat_tab PIPELINED
    AS
        v_list  clm_stat_type;
    BEGIN
        FOR q IN(SELECT clm_stat_cd, clm_stat_desc, clm_stat_type
                   FROM giis_clm_stat
                 UNION
                 SELECT ' ' clm_stat_cd, 'OPEN' clm_stat_desc, 'N' clm_stat_type
                   FROM dual
               ORDER BY clm_stat_cd)
        LOOP
            v_list.clm_stat_cd   := q.clm_stat_cd;
            v_list.clm_stat_desc := q.clm_stat_desc;
            v_list.clm_stat_type := q.clm_stat_type;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_stat_lov;

    FUNCTION get_rep_clm_pol_line_lov(
        p_pol_subline_cd   giis_subline.subline_cd%TYPE,
        p_pol_iss_cd       giis_issource.iss_cd%TYPE,
        p_user_id          giis_users.user_id%TYPE
    )
        RETURN line_tab PIPELINED
    AS
        v_list  line_type;
    BEGIN
        FOR q IN(SELECT DISTINCT(line_cd)
                   FROM gicl_claims
                  WHERE subline_cd LIKE '%' || NVL(p_pol_subline_cd,'') || '%'
                    AND pol_iss_cd LIKE '%' || NVL(p_pol_iss_cd,'') || '%'
                    AND CHECK_USER_PER_ISS_CD2(line_cd,pol_iss_cd,'GICLS540', p_user_id) =  1)
        LOOP
            v_list.pol_line_cd   := q.line_cd;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_pol_line_lov;

    FUNCTION get_rep_clm_pol_subline_lov(
        p_pol_line_cd    giis_line.line_cd%TYPE,
        p_pol_iss_cd     giis_issource.iss_cd%TYPE
    )
        RETURN line_tab PIPELINED
    AS
        v_list  line_type;
    BEGIN
        FOR q IN(SELECT DISTINCT(subline_cd)
                   FROM gicl_claims
                  WHERE line_cd LIKE '%' || NVL(p_pol_line_cd,'') || '%'
                    AND pol_iss_cd LIKE '%' || NVL(p_pol_iss_cd,'') || '%')
        LOOP
            v_list.pol_subline_cd   := q.subline_cd;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_pol_subline_lov;

    FUNCTION get_rep_clm_pol_iss_lov(
        p_pol_subline_cd    giis_subline.subline_cd%TYPE,
        p_pol_line_cd       giis_line.line_cd%TYPE,
        p_user_id           giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED
    AS
        v_list  branch_type;
    BEGIN
        FOR q IN(SELECT DISTINCT(pol_iss_cd)
                   FROM gicl_claims
                  WHERE line_cd LIKE '%' || NVL(p_pol_line_cd,'') || '%'
                    AND subline_cd LIKE '%' || NVL(p_pol_subline_cd,'') || '%'
                    AND CHECK_USER_PER_ISS_CD2(line_cd,pol_iss_cd,'GICLS540',p_user_id) =  1)
        LOOP
            v_list.pol_iss_cd   := q.pol_iss_cd;
            PIPE ROW(v_list);
        END LOOP;
    END get_rep_clm_pol_iss_lov;

    FUNCTION get_sub_agent(
        p_intm_no       giis_intermediary.intm_no%TYPE
    )
        RETURN NUMBER
    IS
        v_parent_intm_no   gicl_basic_intm_v1.parent_intm_no%TYPE; 
    BEGIN
        SELECT DISTINCT DECODE(parent_intm_no, NULL, 0, 1)
          INTO v_parent_intm_no                                                 
          FROM gicl_basic_intm_v1
         WHERE parent_intm_no = p_intm_no;
    RETURN v_parent_intm_no;
    EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_parent_intm_no := 0;          
    RETURN v_parent_intm_no;
    END get_sub_agent;      

/* Start of common functions used by GICLS540 reports
** copied from csv_reported_clms package(used by CS version reports)  
**
*/
    FUNCTION get_loss_amt(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER
    IS
        v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    BEGIN
      --considered item number for peril that exists in more than one item by MAC 11/09/2012.
        FOR item IN (  SELECT DISTINCT b.item_no
                         FROM giis_peril a, gicl_item_peril b
                        WHERE a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd
                          AND b.claim_id = p_claim_id
                          AND b.peril_cd = p_peril_cd  ) 
        LOOP
            v_amount := v_amount + get_loss_amount_per_item_peril(p_claim_id, item.item_no, p_peril_cd, p_loss_exp, p_clm_stat_cd);
        END LOOP;
        RETURN (v_amount);
    END;
   
   /*
   ** Created by   : MAC
   ** Date Created : 11/09/2012
   ** Descriptions : Created a function that will return loss amount per payee type, item code, and peril code.
   */
    FUNCTION get_loss_amount_per_item_peril(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_item_no      gicl_loss_exp_ds.item_no%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER
    IS
        v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_exist        VARCHAR2 (1);
    BEGIN
        IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD' THEN
            v_amount := 0;
        ELSE
            /*FOR i IN (SELECT DISTINCT 1
                        FROM gicl_clm_res_hist
                       WHERE tran_id IS NOT NULL
                         AND NVL(cancel_tag,'N') = 'N' 
                         AND claim_id = p_claim_id
                         AND item_no = p_item_no --considered item number by MAC 11/09/2012.
                         AND peril_cd = p_peril_cd
                         and decode(p_loss_exp,'E',expenses_paid,losses_paid) <> 0)
                          --AND TRUNC(date_paid) BETWEEN p_start_dt AND p_end_dt) jen.20121025 
                          Removed by Carlo Rubenecia 05.27.2017 SR 5403*/
                          
               --Added by Carlo Rubenecia as requested by Mam Aliza 05.27.2017 SR 5403 --start
               FOR i IN (SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = p_loss_exp
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id)
              --end         
            LOOP
                v_exist := 'Y';
            EXIT;
            END LOOP;
                 
        /*Modified by: Jen.20121029 
        ** Get the paid amt if claim has payment, else get the reserve amount.*/
            FOR p IN (SELECT SUM(DECODE (NVL (cancel_tag, 'N'),
                                     'N', DECODE (tran_id,
                                                  NULL, DECODE(p_loss_exp, 'E',NVL (convert_rate * expense_reserve, 0),
                                                               NVL (convert_rate * loss_reserve, 0)), 
                                                  DECODE(p_loss_exp, 'E',NVL (convert_rate * expenses_paid, 0),
                                                         NVL (convert_rate * losses_paid, 0))),
                                     DECODE(p_loss_exp, 'E',NVL (convert_rate * expense_reserve, 0),
                                            NVL (convert_rate * loss_reserve, 0)))) paid
                        FROM gicl_clm_res_hist
                       WHERE claim_id = p_claim_id 
                         AND item_no = p_item_no --considered item number by MAC 11/09/2012.
                         AND peril_cd = p_peril_cd 
                         AND NVL(dist_sw,'!') = DECODE (v_exist, NULL, 'Y',NVL(dist_sw,'!'))               
                         AND NVL(tran_id,-1) = DECODE (v_exist, 'Y', tran_id, -1))               
            LOOP
                v_amount :=  NVL(p.paid,0);
            END LOOP;
        END IF;
        RETURN (v_amount);
    END;
   
   /*
   ** Created by   : MAC
   ** Date Created : 10/31/2012
   ** Descriptions : Created a function that will return loss amount per share type, payee type and peril code..
   */
    FUNCTION amount_per_share_type(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_share_type   gicl_loss_exp_ds.share_type%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER
    IS
        v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
    BEGIN
      --considered item number for peril that exists in more than one item.
        FOR item IN (SELECT DISTINCT b.item_no
                       FROM giis_peril a, gicl_item_peril b
                      WHERE a.line_cd = b.line_cd
                        AND a.peril_cd = b.peril_cd
                        AND b.claim_id = p_claim_id
                        AND b.peril_cd = p_peril_cd) 
        LOOP
            v_amount := v_amount + get_amount_per_item_peril(p_claim_id, item.item_no, p_peril_cd, p_share_type, p_loss_exp, p_clm_stat_cd);
        END LOOP;
        RETURN (v_amount);
    END;
  
   /*
   ** Created by   : MAC
   ** Date Created : 11/09/2012
   ** Descriptions : Created a function that will return loss amount per share type, payee type, item code, and peril code.
   */
    FUNCTION get_amount_per_item_peril(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_item_no      gicl_loss_exp_ds.item_no%TYPE,
        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
        p_share_type   gicl_loss_exp_ds.share_type%TYPE,
        p_loss_exp     VARCHAR2,
        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE
    )
        RETURN NUMBER
    IS
        v_amount       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
        v_exist        VARCHAR2 (1);
    BEGIN
        IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD' THEN
          v_amount := 0;
        ELSE
            BEGIN
                /*SELECT DISTINCT 'x'
                  INTO v_exist
                  FROM gicl_clm_res_hist
                 WHERE tran_id IS NOT NULL
                   AND NVL (cancel_tag, 'N') = 'N'
                   AND claim_id = p_claim_id
                   AND item_no = p_item_no --considered item number
                   AND peril_cd = p_peril_cd
                  --added additional condition to check what particular type has payment
                   AND DECODE (p_loss_exp, 'E', expenses_paid, losses_paid) <> 0;
                   Removed by Carlo Rubenecia SR 5403 05.27.2016*/
                   
                   --Added by Carlo Rubenecia as requested by Mam Aliza 05.27.2017 SR 5403 --start
                       SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                      WHERE a.tran_id IS NOT NULL
                        AND NVL (a.cancel_tag, 'N') = 'N'
                        AND a.claim_id = p_claim_id
                        AND a.peril_cd = p_peril_cd
                        AND b.payee_type = p_loss_exp
                        AND a.claim_id = b.claim_id             
                        AND a.item_no = b.item_no       
                        AND a.peril_cd = b.peril_cd
                        AND a.grouped_item_no = b.grouped_item_no
                        AND a.clm_loss_id = b.clm_loss_id;
                   --End
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_exist := NULL;
            END;

            --get amount per type (Loss or Expense)
            IF v_exist IS NOT NULL THEN
                FOR p IN (SELECT SUM (c.convert_rate * NVL (shr_le_net_amt, 0)) paid
                            FROM gicl_clm_loss_exp a,
                                 gicl_loss_exp_ds b,
                                 gicl_advice c
                           WHERE a.claim_id = b.claim_id
                             AND a.clm_loss_id = b.clm_loss_id
                             AND a.claim_id = c.claim_id
                             AND a.advice_id = c.advice_id
                             AND b.claim_id = p_claim_id
                             AND b.item_no = p_item_no --considered item number
                             AND b.peril_cd = p_peril_cd
                             AND a.tran_id IS NOT NULL
                             AND NVL (b.negate_tag, 'N') = 'N'
                             AND b.share_type = p_share_type
                             AND a.payee_type = DECODE (p_loss_exp, 'L', 'L', 'E') )
                LOOP
                    v_amount := NVL(p.paid,0);
                END LOOP;
            ELSE
                FOR r IN (SELECT DECODE (p_loss_exp,
                                            'L', SUM (  b.convert_rate * NVL (a.shr_loss_res_amt, 0) ),
                                                 SUM (  b.convert_rate * NVL (a.shr_exp_res_amt, 0) )
                                        ) reserve
                            FROM gicl_reserve_ds a, gicl_clm_res_hist b
                           WHERE a.claim_id = b.claim_id
                             AND a.clm_res_hist_id = b.clm_res_hist_id
                             AND b.dist_sw = 'Y'
                             AND a.claim_id = p_claim_id
                             AND b.item_no = p_item_no --considered item number
                             AND a.peril_cd = p_peril_cd
                             AND NVL (a.negate_tag, 'N') = 'N'
                             AND a.share_type = p_share_type)
                LOOP
                v_amount := NVL(r.reserve,0);
                END LOOP;
            END IF;
        END IF;
        RETURN (v_amount);
    END;    
                                  
END GICLS540_pkg;
/
