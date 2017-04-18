CREATE OR REPLACE PACKAGE BODY CPI.GICL_CLM_RES_HIST_PKG
AS
    /*
    **  Created by   :  Niknok Orio
    **  Date Created :  February 16, 2012 
    **  Reference By :  GICLS028 - Preliminary Loss Advice 
    **  Description :   get Reserve details for PLA 
    */
    FUNCTION get_gicl_clm_res_hist(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_line_cd      gicl_claims.line_cd%TYPE)
    RETURN gicl_clm_res_hist_tab PIPELINED IS
      v_list    gicl_clm_res_hist_type;
    BEGIN
        FOR i IN (SELECT a.claim_id, a.clm_res_hist_id, a.item_no,
                         a.peril_cd, a.hist_seq_no, a.convert_rate, 
                         a.loss_reserve, a.expense_reserve, a.currency_cd,
                         a.grouped_item_no 
                    FROM gicl_clm_res_hist a
                   WHERE a.hist_seq_no in (SELECT DISTINCT hist_seq_no
                                             FROM gicl_reserve_ds
                                            WHERE (negate_tag = 'N' OR negate_tag IS NULL)
                                              AND claim_id = p_claim_id) 
                     AND a.dist_sw = 'Y'
                     AND a.claim_id = p_claim_id)
        LOOP
            v_list.claim_id                := i.claim_id; 
            v_list.clm_res_hist_id        := i.clm_res_hist_id; 
            v_list.item_no                := i.item_no;
            v_list.peril_cd                := i.peril_cd; 
            v_list.hist_seq_no            := i.hist_seq_no;
            v_list.convert_rate            := i.convert_rate; 
            v_list.loss_reserve            := i.loss_reserve; 
            v_list.expense_reserve        := i.expense_reserve; 
            v_list.currency_cd            := i.currency_cd;
            v_list.grouped_item_no        := i.grouped_item_no; 
            v_list.dsp_currency_desc    := null;
            
            BEGIN
              SELECT peril_sname
                INTO v_list.dsp_peril_name
                FROM giis_peril
               WHERE line_cd = p_line_cd
                 AND peril_cd = i.peril_cd;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.dsp_peril_name := null;
            END;
            
            FOR REC IN (SELECT currency_desc
                          FROM giis_currency
                         WHERE main_currency_cd = i.currency_cd)
            LOOP
                v_list.dsp_currency_desc := rec.currency_desc;
            END LOOP;
            
            BEGIN
              SELECT DISTINCT 'X'
                INTO v_list.gicl_reserve_rids_exist
                FROM gicl_reserve_rids
               WHERE claim_id = p_claim_id
                 AND clm_res_hist_id = i.clm_res_hist_id
                 AND pla_id IS NOT NULL;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_list.gicl_reserve_rids_exist := null;
            END;
            
            PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.21.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Validates if loss/expense reserve 
    **                  was set-up for the claim
    */

    PROCEDURE get_loss_exp_reserve
    (p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
     p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
     p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE,
     p_loss_reserve     OUT GICL_CLM_RES_HIST.loss_reserve%TYPE,
     p_expense_reserve  OUT GICL_CLM_RES_HIST.expense_reserve%TYPE) AS
     
     v_loss_reserve         GICL_CLM_RES_HIST.loss_reserve%TYPE;
     v_expense_reserve      GICL_CLM_RES_HIST.expense_reserve%TYPE;
     
    BEGIN
        FOR m IN
          (SELECT loss_reserve, expense_reserve
               FROM GICL_CLM_RES_HIST
              WHERE claim_id = p_claim_id
                AND dist_sw  = 'Y'
                AND item_no  = p_item_no
                AND peril_cd = p_peril_cd) 
        LOOP
            v_loss_reserve := NVL(m.loss_reserve,0);
            v_expense_reserve := NVL(m.expense_reserve,0);
        END LOOP;
        
        p_loss_reserve    := NVL(v_loss_reserve,0);
        p_expense_reserve := NVL(v_expense_reserve,0);
        
        RETURN;
        
    END get_loss_exp_reserve;
    
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.27.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Returns 'Y' if reserve of the claim is 
    **                  distributed by risk or location
    */
    
    FUNCTION dist_by_risk_loc (
       v_claim_id   GICL_CLAIMS.claim_id%TYPE,
       v_item_no    GICL_CLM_RES_HIST.item_no%TYPE,
       v_peril_cd   GICL_CLM_RES_HIST.peril_cd%TYPE
    )
       RETURN VARCHAR2 IS
       
       v_exist  VARCHAR2(1) := 'N';
       
    BEGIN
       FOR a IN (SELECT '1'
                   FROM GICL_CLM_RES_HIST
                  WHERE dist_sw = 'Y'
                    AND peril_cd = v_peril_cd
                    AND item_no =  v_item_no
                    AND claim_id = v_claim_id
                    AND dist_type IN (2, 3))
       LOOP
          v_exist := 'Y';
       END LOOP;

       RETURN v_exist;
       
    END;
    
    FUNCTION get_gicl_clm_res_hist2 (
       p_claim_id   GICL_CLAIMS.claim_id%TYPE,
       p_item_no    GICL_CLM_RES_HIST.item_no%TYPE,
       p_peril_cd   GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab2 PIPELINED IS
        v gicl_clm_res_hist_type2;
        v_cancel_field VARCHAR2(100);
        v_distribution_type VARCHAR2(100);
    BEGIN
        FOR i IN (
            SELECT claim_id, clm_res_hist_id, hist_seq_no, item_no, peril_cd, user_id, 
                    booking_month, booking_year, remarks, last_update, 
                    currency_cd, convert_rate, tran_id, cancel_tag, dist_sw, dist_type,
                    grouped_item_no
              FROM gicl_clm_res_hist
             WHERE claim_id = p_claim_id
               AND item_no = p_item_no
               --AND peril_cd = p_peril_cd
        )LOOP
            v.claim_id := i.claim_id;
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.hist_seq_no := i.hist_seq_no;
            v.currency_cd := i.currency_cd;
            v.convert_rate := i.convert_rate;
            v.dist_sw := i.dist_sw;
            v.item_no := i.item_no;
            v.peril_cd := i.peril_cd;
            v.last_update := i.last_update;
            v.user_id := i.user_id;
            v.booking_month := i.booking_month;
            v.booking_year := i.booking_year;
            v.remarks := i.remarks;
            v.grouped_item_no := i.grouped_item_no;
            BEGIN
                SELECT currency_desc
                  INTO v.currency_desc 
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd; 
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN NULL;
            END;
           
            IF i.tran_id IS NOT NULL THEN
                 IF nvl(i.cancel_tag,'N') = 'Y' THEN
                    v_cancel_field := 'CANCELLED PAYMENT';
                    v_distribution_type := v_cancel_field;
                 END IF;
              ELSIF NVL(i.dist_sw, 'N') = 'Y' THEN
                 v_cancel_field := 'DISTRIBUTED';
                     IF v_cancel_field = 'DISTRIBUTED' THEN
                        FOR rv IN (
                            SELECT rv_meaning
                              FROM cg_ref_codes
                             WHERE rv_low_value = NVL(i.dist_type,1)
                               AND rv_domain LIKE 'GICL_CLM_RES_HIST.DIST_TYPE' 
                               AND rv_type LIKE 'CG') 
                        LOOP    
                            v_distribution_type:=rv.rv_meaning;
                        END LOOP;            
                    ELSE
                        v_distribution_type := v_cancel_field;
                    END IF;
            END IF;
            
            v.distribution_desc := v_distribution_type; 
            
            PIPE ROW(v);
        END LOOP;
        RETURN;
    END;
    
    FUNCTION get_gicl_clm_res_hist3 (
       p_claim_id   GICL_CLAIMS.claim_id%TYPE,
       p_item_no    GICL_CLM_RES_HIST.item_no%TYPE,
       p_peril_cd   GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab3 PIPELINED IS
        v gicl_clm_res_hist_type3;
    BEGIN
        FOR i IN (
            SELECT claim_id,hist_seq_no, loss_reserve, expense_reserve, convert_rate, grouped_item_no, 
                    booking_year, booking_month, dist_sw, remarks, user_id, clm_res_hist_id,
                    last_update 
              FROM gicl_clm_res_hist 
             WHERE claim_id=p_claim_id 
               AND peril_cd = p_peril_cd 
               AND item_no = p_item_no 
               AND tran_id IS NULL
        )LOOP
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.grouped_item_no := i.grouped_item_no;
            v.hist_seq_no := i.hist_seq_no;
            v.loss_reserve := i.loss_reserve;
            v.expense_reserve := i.expense_reserve; 
            v.claim_id := i.claim_id;
            v.convert_rate := i.convert_rate;
            v.booking_year := i.booking_year;
            v.booking_month := i.booking_month;
            v.dist_sw := i.dist_sw;
            v.remarks := i.remarks;
            v.user_id := i.user_id;
            v.last_update := i.last_update;
            PIPE ROW(v);
        END LOOP;
        RETURN;
    END;
    
    /*
    **  Created by   :  Udel Dela Cruz Jr.
    **  Date Created :  04.13.2012
    **  Reference By :  GICLS024 - Claim Reserve 
    **  Description :   get payment history 
    */
    FUNCTION get_payment_history (
        p_claim_id        gicl_clm_res_hist.claim_id%TYPE,
        p_item_no         gicl_clm_res_hist.item_no%TYPE,
        p_peril_cd        gicl_clm_res_hist.peril_cd%TYPE,
        p_grouped_item_no gicl_clm_res_hist.grouped_item_no%TYPE
    ) RETURN payment_history_tab PIPELINED IS
        v_list  payment_history_type;
    BEGIN
        FOR rec IN (SELECT a.claim_id, a.clm_res_hist_id, a.hist_seq_no, a.losses_paid, a.expenses_paid, a.convert_rate, a.date_paid, a.cancel_tag,
                           a.payee_class_cd, b.class_desc, a.payee_cd, a.remarks, a.user_id, a.last_update,
                           decode(c.payee_first_name, null, c.payee_last_name,
                            c.payee_last_name||','||c.payee_first_name||' '||c.payee_middle_name) payee
                      FROM gicl_clm_res_hist a, giis_payee_class b, giis_payees c
                     WHERE 1=1
                       AND a.payee_class_cd     = b.payee_class_cd
                       AND a.payee_class_cd     = c.payee_class_cd
                       AND a.payee_cd           = c.payee_no 
                       AND a.claim_id           = p_claim_id
                       AND a.item_no            = p_item_no
                       AND a.peril_cd           = p_peril_cd
                       AND a.grouped_item_no    = p_grouped_item_no
                       AND a.tran_id IS NOT NULL)
        LOOP
            v_list.claim_id            := rec.claim_id;
            v_list.clm_res_hist_id     := rec.clm_res_hist_id;
            v_list.hist_seq_no         := rec.hist_seq_no;
            v_list.losses_paid         := rec.losses_paid;
            v_list.expenses_paid       := rec.expenses_paid;
            v_list.convert_rate        := rec.convert_rate;
            v_list.date_paid           := rec.date_paid;
            v_list.cancel_tag          := rec.cancel_tag;
            v_list.payee_class_cd      := rec.payee_class_cd;
            v_list.class_desc          := rec.class_desc;
            v_list.payee_cd            := rec.payee_cd;
            v_list.payee               := rec.payee;
            v_list.remarks             := rec.remarks;
			v_list.user_id             := rec.user_id;
			v_list.last_update         := rec.last_update;
            
            PIPE ROW(v_list);
        END LOOP;
    END get_payment_history;
    
    PROCEDURE update_res_hist_remarks(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE,
        p_remarks          IN  GICL_CLM_RES_HIST.remarks%TYPE
    ) AS
    BEGIN
        UPDATE gicl_clm_res_hist
           SET remarks = p_remarks,
               last_update = SYSDATE 
         WHERE claim_id = p_claim_id
           AND item_no = p_item_no
           AND peril_cd = p_peril_cd; 
    END update_res_hist_remarks;
    
	FUNCTION get_last_clm_res_hist(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab2 PIPELINED IS
        v gicl_clm_res_hist_type2;
        v_cancel_field VARCHAR2(100);
        v_distribution_type VARCHAR2(100);
    BEGIN
        FOR i IN (
        SELECT * 
          FROM gicl_clm_res_hist
         WHERE claim_id = p_claim_id-- 917
           AND item_no = p_item_no --1
           AND peril_cd = p_peril_cd --35
             AND clm_res_hist_id = (
                SELECT max(clm_res_hist_id) 
                    FROM gicl_clm_res_hist 
                  WHERE claim_id = p_claim_id --917
                      AND item_no = p_item_no)
        )LOOP
            v.claim_id := i.claim_id;
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.hist_seq_no := i.hist_seq_no;
            v.currency_cd := i.currency_cd;
            v.convert_rate := i.convert_rate;
            v.dist_sw := i.dist_sw;
            v.item_no := i.item_no;
            v.peril_cd := i.peril_cd;
            v.last_update := i.last_update;
            v.user_id := i.user_id;
            v.booking_month := i.booking_month;
            v.booking_year := i.booking_year;
            v.remarks := i.remarks;
            v.grouped_item_no := i.grouped_item_no;
            BEGIN
                SELECT currency_desc
                  INTO v.currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;

            IF i.tran_id IS NOT NULL THEN
                 IF nvl(i.cancel_tag,'N') = 'Y' THEN
                    v_cancel_field := 'CANCELLED PAYMENT';
                    v_distribution_type := v_cancel_field;
                 END IF;
              ELSIF NVL(i.dist_sw, 'N') = 'Y' THEN
                 v_cancel_field := 'DISTRIBUTED';
                     IF v_cancel_field = 'DISTRIBUTED' THEN
                        FOR rv IN (
                            SELECT rv_meaning
                              FROM cg_ref_codes
                             WHERE rv_low_value = NVL(i.dist_type,1)
                               AND rv_domain LIKE 'GICL_CLM_RES_HIST.DIST_TYPE'
                               AND rv_type LIKE 'CG')
                        LOOP
                            v_distribution_type:=rv.rv_meaning;
                        END LOOP;
                    ELSE
                        v_distribution_type := v_cancel_field;
                    END IF;
            END IF;
            v.distribution_desc := v_distribution_type;
            PIPE ROW(v);
        END LOOP;       
    END get_last_clm_res_hist;
    
    FUNCTION get_gicl_clm_res_hist4(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab4 PIPELINED IS
        v gicl_clm_res_hist_type4;
        v_cancel_field VARCHAR2(100);
        v_distribution_type VARCHAR2(100);
    BEGIN
        FOR i IN (
        SELECT * 
          FROM gicl_clm_res_hist
         WHERE claim_id = p_claim_id
           AND item_no = p_item_no
           AND peril_cd = p_peril_cd
         --ORDER BY NVL(DIST_SW, 'N') DESC, hist_seq_no DESC
        )LOOP
            v.claim_id := i.claim_id;
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.hist_seq_no := i.hist_seq_no;
            v.currency_cd := i.currency_cd;
            v.convert_rate := i.convert_rate;
            v.dist_sw := i.dist_sw;
            v.item_no := i.item_no;
            v.peril_cd := i.peril_cd;
            v.last_update := i.last_update;
            v.user_id := i.user_id;
            v.booking_month := i.booking_month;
            v.booking_year := i.booking_year;
            v.remarks := i.remarks;
            v.grouped_item_no := i.grouped_item_no;
            v.loss_reserve  := i.loss_reserve;
            v.expense_reserve  := i.expense_reserve;
            v.tran_id := i.tran_id;
            v.sdf_last_update := TO_CHAR(i.last_update,'MM-DD-YYYY HH:MI:SS AM'); --added by steven 06.03.2013
            v.setup_date := TO_CHAR(i.setup_date,'MM-DD-YYYY HH:MI:SS AM');
            v.setup_by := i.setup_by;
            BEGIN
                SELECT currency_desc
                  INTO v.currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            v.distribution_desc := GICL_CLM_RES_HIST_PKG.get_dist_type(i.tran_id, i.cancel_tag, i.dist_sw, i.dist_type);
            PIPE ROW(v);
        END LOOP;       
    END get_gicl_clm_res_hist4;
    
    FUNCTION get_dist_type (
        p_tran_id       GICL_CLM_RES_HIST.TRAN_ID%TYPE,
        p_cancel_tag    gicl_clm_res_hist.cancel_tag%TYPE,
        p_dist_sw       gicl_clm_res_hist.dist_sw%TYPE,
        p_dist_type     gicl_clm_res_hist.dist_type%TYPE
    )
       RETURN VARCHAR2
    AS
       v_distribution_desc   VARCHAR2 (30);
    BEGIN
       IF p_tran_id IS NOT NULL THEN
          IF NVL (p_cancel_tag, 'N') = 'Y' THEN
             v_distribution_desc := 'CANCELLED PAYMENT';
          END IF;
       ELSIF NVL (p_dist_sw, 'N') = 'Y' THEN
         FOR rv IN (SELECT rv_meaning
                      FROM cg_ref_codes
                     WHERE rv_low_value = NVL (p_dist_type, 1)
                       AND rv_domain LIKE 'GICL_CLM_RES_HIST.DIST_TYPE'
                       AND rv_type LIKE 'CG')
         LOOP
            v_distribution_desc := rv.rv_meaning;
         END LOOP;
       END IF;

       RETURN (v_distribution_desc);
    END;
    
    FUNCTION get_last_clm_res_hist2(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab4 PIPELINED IS
        v gicl_clm_res_hist_type4;
        v_cancel_field VARCHAR2(100);
        v_distribution_type VARCHAR2(100);
    BEGIN
        FOR i IN (
        SELECT * 
          FROM gicl_clm_res_hist
         WHERE claim_id = p_claim_id
           AND item_no = p_item_no
           AND peril_cd = p_peril_cd
         ORDER BY NVL(DIST_SW, 'N') DESC, hist_seq_no DESC
        )LOOP
            v.claim_id := i.claim_id;
            v.clm_res_hist_id := i.clm_res_hist_id;
            v.hist_seq_no := i.hist_seq_no;
            v.currency_cd := i.currency_cd;
            v.convert_rate := i.convert_rate;
            v.dist_sw := i.dist_sw;
            v.item_no := i.item_no;
            v.peril_cd := i.peril_cd;
            v.last_update := i.last_update;
            v.user_id := i.user_id;
            v.booking_month := i.booking_month;
            v.booking_year := i.booking_year;
            v.remarks := i.remarks;
            v.grouped_item_no := i.grouped_item_no;
            v.loss_reserve  := i.loss_reserve;
            v.expense_reserve  := i.expense_reserve;
            v.tran_id := i.tran_id;
            v.sdf_last_update := TO_CHAR(i.last_update,'MM-DD-YYYY HH:MI:SS AM'); --added by steven 06.03.2013
            BEGIN
                SELECT currency_desc
                  INTO v.currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = i.currency_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
            
            v.distribution_desc := GICL_CLM_RES_HIST_PKG.get_dist_type(i.tran_id, i.cancel_tag, i.dist_sw, i.dist_type);
            EXIT;
        END LOOP;
        PIPE ROW(v);
    END get_last_clm_res_hist2;
	
END GICL_CLM_RES_HIST_PKG;
/


