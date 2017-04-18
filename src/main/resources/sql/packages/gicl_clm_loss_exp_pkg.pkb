CREATE OR REPLACE PACKAGE BODY CPI.GICL_CLM_LOSS_EXP_PKG AS
  FUNCTION get_clm_loss(
            p_line_cd        GIIS_PERIL.line_cd%TYPE,
            p_advice_id        GICL_CLM_LOSS_EXP.advice_id%TYPE, 
            p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
            p_claim_loss_id GICL_CLM_LOSS_EXP.clm_loss_id%TYPE
   )RETURN clm_loss_subtype IS
           v_clm_loss                   clm_loss_subtype;
   BEGIN
     /*SELECT a.clm_loss_id claim_loss_id,     a.payee_type,    decode(a.payee_type,'L','Loss','E','Expense') p_type, 
            a.payee_class_cd,                 a.payee_cd,        decode(b.payee_first_name, NULL, b.payee_last_name, b.payee_last_name||','||b.payee_first_name||' '||b.payee_middle_name) payee, 
                 a.peril_cd,                 c.peril_sname, 
                (a.net_amt * nvl(d.convert_rate,1)) net_amt, 
                a.paid_amt,                 a.advise_amt advice_amt
          INTO v_clm_loss
         FROM gicl_clm_loss_exp a, giis_payees b, giis_peril c, gicl_advice d 
         WHERE a.payee_cd   = b.payee_no 
           AND a.payee_class_cd = b.payee_class_cd 
           AND a.claim_id   = d.claim_id 
           AND a.advice_id  = d.advice_id 
           AND c.line_cd       = p_line_cd
           AND a.peril_cd   = c.peril_cd
              AND a.claim_id     = p_claim_id
           AND a.advice_id     = p_advice_id
           AND a.clm_loss_id = p_claim_loss_id 
           AND a.advice_id IS NOT NULL 
           AND a.tran_id IS NULL;
           */
        
        SELECT  i.clm_loss_id claim_loss_id,   
                i.payee_type, decode(i.payee_type,'L','Loss','E','Expense') payee_type_desc,
                c.payee_class_cd,          c.payee_cd,   decode(h.payee_first_name, NULL, h.payee_last_name, h.payee_last_name||','||h.payee_first_name||' '||h.payee_middle_name) payee,
                c.peril_cd, d.peril_sname, (c.net_amt * nvl(f.convert_rate,1)) net_amt, c.paid_amt, c.advise_amt
          INTO v_clm_loss     
          FROM giac_direct_claim_payts i, gicl_claims b, gicl_clm_loss_exp c, giis_peril d, giis_payees h, gicl_advice f
         WHERE i.transaction_type = 1
           AND i.claim_id = p_claim_id --47--13
           AND i.claim_id = b.claim_id 
           AND i.claim_id = c.claim_id 
           AND i.claim_id = f.claim_id 
           AND c.peril_cd = d.peril_cd 
           AND i.advice_id = p_advice_id --4--17
           AND i.payee_cd = c.payee_cd 
           AND i.payee_cd = h.payee_no 
           and d.line_cd = p_line_cd; --'FI'
          
    RETURN v_clm_loss;       
  END get_clm_loss;
  
  FUNCTION get_clm_loss2(
            p_line_cd        GIIS_PERIL.line_cd%TYPE,
            p_advice_id        GICL_CLM_LOSS_EXP.advice_id%TYPE,
            p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
            p_claim_loss_id GICL_CLM_LOSS_EXP.clm_loss_id%TYPE
   )RETURN clm_loss_subtype IS
           v_clm_loss                   clm_loss_subtype;
   BEGIN
         SELECT a.clm_loss_id,                  a.payee_type, 
                decode(a.payee_type,'L','Loss','E','Expense') p_type, 
                a.payee_class_cd,             a.payee_cd, 
                 decode(b.payee_first_name, NULL, b.payee_last_name, b.payee_last_name||','||b.payee_first_name||' '||b.payee_middle_name) payee, 
                 a.peril_cd,                 c.peril_sname, 
                (a.net_amt * nvl(d.convert_rate,1)) net_amt, 
                a.paid_amt,                 a.advise_amt 
          INTO v_clm_loss
         FROM gicl_clm_loss_exp a, giis_payees b, giis_peril c, gicl_advice d 
         WHERE a.payee_cd   = b.payee_no 
           AND a.payee_class_cd = b.payee_class_cd 
           AND a.claim_id   = d.claim_id 
           AND a.advice_id  = d.advice_id 
           AND c.line_cd       = p_line_cd
           AND a.peril_cd   = c.peril_cd
              AND a.claim_id     = p_claim_id
           AND a.advice_id     = p_advice_id
           AND a.clm_loss_id = p_claim_loss_id 
           AND a.advice_id IS NOT NULL 
           AND a.tran_id IS NULL;
           
    RETURN v_clm_loss;       
  END get_clm_loss2;
  
  PROCEDURE set_clm_loss_exp(
        p_clm_loss_exp      IN GICL_CLM_LOSS_EXP%ROWTYPE
        /*p_claim_id          IN GICL_CLAIMS.claim_id%TYPE,        p_clm_loss_id         IN GICL_CLM_LOSS_EXP.clm_loss_id%TYPE, 
        p_hist_seq_no         IN GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,        p_item_no             IN GICL_CLM_LOSS_EXP.item_no%TYPE,
        p_peril_cd            IN GICL_CLM_LOSS_EXP.peril_cd%TYPE,        p_item_stat_cd        IN GICL_CLM_LOSS_EXP.item_stat_cd%TYPE,
        p_payee_type          IN GICL_CLM_LOSS_EXP.payee_type%TYPE,        p_payee_cd            IN GICL_CLM_LOSS_EXP.payee_cd%TYPE,
        p_payee_class_cd      IN GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,        p_ex_gratia_sw        IN GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,
        p_user_id             IN GICL_CLM_LOSS_EXP.user_id%TYPE,        p_last_update         IN GICL_CLM_LOSS_EXP.last_update%TYPE,
        p_dist_sw             IN GICL_CLM_LOSS_EXP.dist_sw%TYPE,        p_paid_amt            IN GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        p_net_amt             IN GICL_CLM_LOSS_EXP.net_amt%TYPE,        p_advice_amt          IN GICL_CLM_LOSS_EXP.advise_amt%TYPE,
        p_cpi_rec_no          IN GICL_CLM_LOSS_EXP.cpi_rec_no%TYPE,        p_cpi_branch_cd       IN GICL_CLM_LOSS_EXP.cpi_branch_cd%TYPE,
        p_remarks             IN GICL_CLM_LOSS_EXP.remarks%TYPE,        p_cancel_sw           IN GICL_CLM_LOSS_EXP.cancel_sw%TYPE,
        p_advice_id           IN GICL_CLM_LOSS_EXP.advice_id%TYPE,        p_tran_id             IN GICL_CLM_LOSS_EXP.tran_id%TYPE,
        p_dist_type           IN GICL_CLM_LOSS_EXP.dist_type%TYPE,        p_clm_clmnt_no        IN GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,
        p_final_tag           IN GICL_CLM_LOSS_EXP.final_tag%TYPE,        p_tran_date           IN GICL_CLM_LOSS_EXP.tran_date%TYPE,
        p_currency_cd         IN GICL_CLM_LOSS_EXP.currency_cd%TYPE,        p_currency_rate       IN GICL_CLM_LOSS_EXP.currency_rate%TYPE,
        p_grouped_item_no     IN GICL_CLM_LOSS_EXP.grouped_item_no%TYPE*/       
   ) IS
   BEGIN
        
        MERGE INTO gicl_clm_loss_exp
        USING dual ON (     claim_id    = p_clm_loss_exp.claim_id
                        AND clm_loss_id = p_clm_loss_exp.clm_loss_id
                        )
        WHEN NOT MATCHED THEN
            INSERT(
                claim_id, clm_loss_id, hist_seq_no, item_no, peril_cd, item_stat_cd, payee_type,
                payee_cd, payee_class_cd, ex_gratia_sw, user_id, last_update, dist_sw, paid_amt,
                net_amt, advise_amt, cpi_rec_no, cpi_branch_cd, remarks, cancel_sw, advice_id,
                tran_id, dist_type, clm_clmnt_no, final_tag, tran_date, currency_cd,
                currency_rate,grouped_item_no
            )
            VALUES(
                p_clm_loss_exp.claim_id, p_clm_loss_exp.clm_loss_id, p_clm_loss_exp.hist_seq_no, p_clm_loss_exp.item_no, p_clm_loss_exp.peril_cd, p_clm_loss_exp.item_stat_cd, p_clm_loss_exp.payee_type,
                p_clm_loss_exp.payee_cd, p_clm_loss_exp.payee_class_cd, p_clm_loss_exp.ex_gratia_sw, p_clm_loss_exp.user_id, p_clm_loss_exp.last_update, p_clm_loss_exp.dist_sw, p_clm_loss_exp.paid_amt,
                p_clm_loss_exp.net_amt, p_clm_loss_exp.advise_amt, p_clm_loss_exp.cpi_rec_no, p_clm_loss_exp.cpi_branch_cd, p_clm_loss_exp.remarks, p_clm_loss_exp.cancel_sw, p_clm_loss_exp.advice_id,
                p_clm_loss_exp.tran_id, p_clm_loss_exp.dist_type, p_clm_loss_exp.clm_clmnt_no, p_clm_loss_exp.final_tag, p_clm_loss_exp.tran_date, p_clm_loss_exp.currency_cd,
                p_clm_loss_exp.currency_rate,p_clm_loss_exp.grouped_item_no
            )
        WHEN MATCHED THEN 
            UPDATE SET
                hist_seq_no     = p_clm_loss_exp.hist_seq_no,
                item_no         = p_clm_loss_exp.item_no,
                peril_cd        = p_clm_loss_exp.peril_cd,
                item_stat_cd    = p_clm_loss_exp.item_stat_cd,
                payee_type      = p_clm_loss_exp.payee_type,
                payee_cd        = p_clm_loss_exp.payee_cd,
                payee_class_cd  = p_clm_loss_exp.payee_class_cd,
                ex_gratia_sw    = p_clm_loss_exp.ex_gratia_sw,
                user_id         = p_clm_loss_exp.user_id,
                last_update     = SYSDATE,
                dist_sw         = p_clm_loss_exp.dist_sw,
                paid_amt        = p_clm_loss_exp.paid_amt,
                net_amt         = p_clm_loss_exp.net_amt,
                advise_amt      = p_clm_loss_exp.advise_amt,
                cpi_rec_no      = p_clm_loss_exp.cpi_rec_no,
                cpi_branch_cd   = p_clm_loss_exp.cpi_branch_cd,
                remarks         = p_clm_loss_exp.remarks,
                cancel_sw       = p_clm_loss_exp.cancel_sw,
                advice_id       = p_clm_loss_exp.advice_id,
                tran_id         = p_clm_loss_exp.tran_id,
                dist_type       = p_clm_loss_exp.dist_type,
                clm_clmnt_no    = p_clm_loss_exp.clm_clmnt_no,
                final_tag       = p_clm_loss_exp.final_tag,
                tran_date       = p_clm_loss_exp.tran_date,
                currency_cd     = p_clm_loss_exp.currency_cd,
                currency_rate   = p_clm_loss_exp.currency_rate,
                grouped_item_no = p_clm_loss_exp.grouped_item_no;
        /*INSERT INTO GICL_CLM_LOSS_EXP(
            claim_id, clm_loss_id, hist_seq_no, item_no, peril_cd, item_stat_cd, payee_type,
            payee_cd, payee_class_cd, ex_gratia_sw, user_id, last_update, dist_sw, paid_amt,
            net_amt, advise_amt, cpi_rec_no, cpi_branch_cd, remarks, cancel_sw, advice_id,
            tran_id, dist_type, clm_clmnt_no, final_tag, tran_date, currency_cd,
            currency_rate,grouped_item_no
        )VALUES(
            p_claim_id, p_clm_loss_id, p_hist_seq_no, p_item_no, p_peril_cd, p_item_stat_cd, p_payee_type,
            p_payee_cd, p_payee_class_cd, p_ex_gratia_sw, p_user_id, p_last_update, p_dist_sw, p_paid_amt,
            p_net_amt, p_advice_amt, p_cpi_rec_no, p_cpi_branch_cd, p_remarks, p_cancel_sw, p_advice_id,
            p_tran_id, p_dist_type, p_clm_clmnt_no, p_final_tag, p_tran_date, p_currency_cd,
            p_currency_rate,p_grouped_item_no
        );*/
   END;
   
    /*
   **  Created by   : Belle Bebing
   **  Date Created : 09.23.2011
   **  Reference By : (GICLS041 - Print Claims Documents)
   **  Description  : Get claim history info records 
   */ 
   FUNCTION get_clm_hist_info (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE,
        p_dsp_item_no   GICL_CLM_LOSS_EXP.item_no%TYPE,
        p_dsp_peril_cd  GICL_CLM_LOSS_EXP.peril_cd%TYPE
    )
    RETURN clm_loss_exp_tab PIPELINED 
  IS 
    v_hist      clm_loss_exp_type;

    BEGIN
        FOR i IN (SELECT claim_id, clm_loss_id, LTRIM(TO_CHAR(hist_seq_no, '0009'))hist_seq_no, item_no, peril_cd,
                         item_stat_cd, payee_type, payee_class_cd,LTRIM(TO_CHAR(payee_cd, '000000009999'))payee_cd,
                         tran_id,advice_id           
                    FROM gicl_clm_loss_exp
                   WHERE dist_sw = 'Y' 
                     AND nvl(cancel_sw,'N') = 'N'
                     AND claim_id = p_claim_id
                     AND item_no  = p_dsp_item_no
                     AND peril_cd = p_dsp_peril_cd) 
        LOOP
            v_hist.claim_id      := i.claim_id;
            v_hist.clm_loss_id   := i.clm_loss_id;
            v_hist.hist_seq_no   := i.hist_seq_no;
            v_hist.item_no       := i.item_no;
            v_hist.peril_cd      := i.peril_cd;
            v_hist.item_stat_cd  := i.item_stat_cd;
            v_hist.payee_type    := i.payee_type;
            v_hist.payee_class_cd := i.payee_class_cd;
            v_hist.payee_cd      := i.payee_cd;
            v_hist.tran_id       := i.tran_id;
            v_hist.advice_id     := i.advice_id;
            
            BEGIN
              SELECT a.document_cd||'-'||a.line_cd||'-'||ltrim(to_char(a.doc_year),' ')||'-'|| 
                     ltrim(to_char(a.doc_mm),' ')||'-'||ltrim(to_char(a.doc_seq_no,'0000009'),' ') csr_no 
                INTO v_hist.csr_no
                FROM giac_payt_requests_dtl b, giac_payt_requests a, gicl_clm_loss_exp c 
               WHERE c.tran_id = b.tran_id 
                 AND b.req_dtl_no >= 0 
                 AND b.gprq_ref_id = a.ref_id 
                 AND c.claim_id = p_claim_id
                 AND c.clm_loss_id = i.clm_loss_id 
                 AND c.tran_id = i.tran_id;
            EXCEPTION
              when NO_DATA_FOUND then
                v_hist.csr_no := null;
              when TOO_MANY_ROWS then
                v_hist.csr_no := null;
            END;
             -- added by JEROME.O 11.17.08
            BEGIN
                FOR j IN (SELECT paid_amt 
                            FROM gicl_clm_loss_exp
                           WHERE claim_id = p_claim_id
                             AND clm_loss_id = i.clm_loss_id 
                             AND item_no = p_dsp_item_no
                             AND peril_cd = p_dsp_peril_cd)
                LOOP
                  v_hist.paid_amt := j.paid_amt;
                END LOOP;            
            END;    
             --end JEROME.O
            IF i.payee_type = 'L' then
               v_hist.payee_type_desc := 'LOSS';
            ELSIF i.payee_type = 'E' then
               v_hist.payee_type_desc := 'EXPENSE';
            END IF;

            BEGIN
              SELECT class_desc
                INTO v_hist.payee_class_desc
                FROM giis_payee_class
               WHERE payee_class_cd = i.payee_class_cd;
            EXCEPTION
              when NO_DATA_FOUND then
                null;
              when TOO_MANY_ROWS then
                null;
            END;

            BEGIN
              SELECT payee_last_name||decode(payee_first_name,NULL,NULL,', '||payee_first_name)||decode(payee_middle_name,NULL,NULL,' '||substr(payee_middle_name,1,1)||'.')
                INTO v_hist.payee_last_name
                FROM giis_payees
               WHERE payee_class_cd = i.payee_class_cd
                 AND payee_no = i.payee_cd; 
            EXCEPTION
              when NO_DATA_FOUND then
                null;
              when TOO_MANY_ROWS then
                null;
            END;

            BEGIN
              SELECT check_pref_suf ||'-'|| to_char(check_no) check_no,
                     check_date
                INTO v_hist.check_no, v_hist.check_date
                FROM giac_chk_disbursement
               WHERE gacc_tran_id = i.tran_id;
            EXCEPTION
              when NO_DATA_FOUND then
                null;
              when TOO_MANY_ROWS then
                null;
            END; 
           PIPE ROW(v_hist);
        END LOOP;
        RETURN;
     END;
    
    /*
    **  Created by    : Andrew Robes
    **  Date Created  : 01.20.2012
    **  Reference By  : GICLS032 - Claim Advice
    **  Description   : Function to retrieve gicl_clm_loss_exp records by claim_id, advice_id and line_cd
    */     
   FUNCTION get_gicl_clm_loss_exp_list(
      p_claim_id  GICL_CLM_LOSS_EXP.claim_id%TYPE
     ,p_advice_id GICL_CLM_LOSS_EXP.advice_id%TYPE
     ,p_line_cd   GICL_ADVICE.line_cd%TYPE
   ) RETURN gicl_clm_loss_exp_tab PIPELINED IS
   
     TYPE cur_typ IS REF CURSOR;
     c          cur_typ;
     v_loss     gicl_clm_loss_exp_type;
     v_query    VARCHAR2(3000);
     v_where    VARCHAR2(4000); --increase size by MAC 02/19/2013
   BEGIN
     v_query := 'SELECT a.claim_id, a.advice_id, a.clm_loss_id, a.tran_id, a.payee_cd, a.hist_seq_no, a.item_no, a.grouped_item_no, d.item_title, 
                       a.peril_cd, b.peril_sname, b.peril_name, a.item_stat_cd, a.currency_cd, a.currency_rate, a.payee_type, 
                       a.payee_class_cd, a.dist_sw, a.paid_amt, a.net_amt, a.advise_amt, c.payee_last_name,
                       c.payee_last_name||'' ''||c.payee_first_name||'' ''|| c.payee_middle_name payee_name,
                       NVL(e.close_flag, ''AP'') close_flag, NVL(e.close_flag2, ''AP'') close_flag2     
                  FROM gicl_clm_loss_exp a
                      ,giis_peril b
                      ,giis_payees c
                      ,gicl_clm_item d
					  ,gicl_item_peril e'; --added gicl_item_peril to get close_flag (Loss status) and close_flag2(Expense status) by MAC 02/19/2013.
                      
     v_where := ' WHERE a.claim_id = :p_claim_id
                    AND d.claim_id = a.claim_id
                    AND d.item_no = a.item_no
                    AND b.line_cd = :p_line_cd
                    AND b.peril_cd = a.peril_cd
                    AND c.payee_class_cd = a.payee_class_cd  
                    AND c.payee_no = a.payee_cd
                    AND a.claim_id = e.claim_id
                    AND a.item_no = e.item_no
                    AND a.peril_cd = e.peril_cd
                    AND a.grouped_item_no = e.grouped_item_no';
                                         
     IF p_advice_id IS NOT NULL THEN
       v_where := v_where || ' AND a.advice_id = :p_advice_id';
       v_query := v_query || v_where || ' ORDER BY hist_seq_no, item_no, peril_cd';
       
       OPEN c FOR v_query USING p_claim_id, p_line_cd, p_advice_id;
     ELSE 
       v_where := v_where || ' AND a.advice_id IS NULL AND NVL(cancel_sw, ''N'') = ''N''';
       v_query := v_query || v_where || ' ORDER BY hist_seq_no, item_no, peril_cd';
       
       OPEN c FOR v_query USING p_claim_id, p_line_cd;
     END IF;                                                       

     LOOP
       FETCH c
        INTO v_loss.claim_id, v_loss.advice_id, v_loss.clm_loss_id, v_loss.tran_id, v_loss.payee_cd, v_loss.hist_seq_no,
             v_loss.item_no, v_loss.grouped_item_no, v_loss.dsp_item_title, v_loss.peril_cd, v_loss.dsp_peril_sname, v_loss.dsp_peril_name,
             v_loss.item_stat_cd, v_loss.currency_cd, v_loss.currency_rate, v_loss.payee_type, v_loss.payee_class_cd, v_loss.dist_sw,
             v_loss.paid_amt, v_loss.net_amt, v_loss.advise_amt, v_loss.dsp_payee_last_name, v_loss.dsp_payee_name,
             v_loss.close_flag, v_loss.close_flag2; --get close_flag (Loss status) and close_flag2(Expense status) by MAC 02/19/2013.
             
             --comment out by MAC 02/19/2013
             --v_loss.close_flag := gicl_item_peril_pkg.gicls032_check_peril_status(v_loss.claim_id, v_loss.item_no, v_loss.peril_cd, v_loss.grouped_item_no);
             
        EXIT WHEN c%NOTFOUND;
        
        PIPE ROW(v_loss);
     END LOOP;      
     RETURN;
   END get_gicl_clm_loss_exp_list;
   
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 01.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_CLM_LOSS_EXP records
    */ 

    FUNCTION get_clm_loss_exp_list
        (p_claim_id        IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,   
         p_payee_type      IN   GICL_CLM_LOSS_EXP.payee_type%TYPE,
         p_payee_class_cd  IN   GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
         p_payee_cd        IN   GICL_CLM_LOSS_EXP.payee_cd%TYPE,
         p_item_no         IN   GICL_CLM_LOSS_EXP.item_no%TYPE,
         p_peril_cd        IN   GICL_CLM_LOSS_EXP.peril_cd%TYPE,
         p_clm_clmnt_no    IN   GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,
         p_grouped_item_no IN   GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
         p_hist_seq_no     IN   GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
         p_le_stat_desc    IN   GICL_LE_STAT.le_stat_desc%TYPE,
         p_advice_amt      IN   GICL_CLM_LOSS_EXP.advise_amt%TYPE,
         p_net_amt         IN   GICL_CLM_LOSS_EXP.net_amt%TYPE,
         p_paid_amt        IN   GICL_CLM_LOSS_EXP.paid_amt%TYPE,
         p_remarks         IN   GICL_CLM_LOSS_EXP.remarks%TYPE)
         
    RETURN clm_loss_exp_tab PIPELINED AS
        
        v_list           clm_loss_exp_type;

    BEGIN

        FOR i IN(SELECT c011.claim_id,     c011.clm_loss_id,    c011.hist_seq_no,    
                        c011.item_no,      c011.peril_cd,       c011.grouped_item_no,
                        c011.clm_clmnt_no, c011.item_stat_cd,   stat.le_stat_desc,    
                        c011.payee_type,   c011.payee_cd,       c011.payee_class_cd, 
                        c011.ex_gratia_sw, c011.dist_sw,        c011.cancel_sw,
                        c011.paid_amt,     c011.net_amt,        c011.advise_amt,             
                        c011.remarks,      c011.final_tag,      c011.advice_id,
						c011.user_id,	   c011.last_update      
                 FROM GICL_CLM_LOSS_EXP c011,
                      GICL_LE_STAT stat
                WHERE stat.le_stat_cd = c011.item_stat_cd
                  AND c011.claim_id = p_claim_id 
                  AND c011.payee_type = p_payee_type 
                  AND c011.payee_class_cd = p_payee_class_cd 
                  AND c011.payee_cd = p_payee_cd 
                  AND c011.item_no = p_item_no 
                  AND c011.peril_cd = p_peril_cd 
                  AND c011.clm_clmnt_no = p_clm_clmnt_no 
                  AND c011.grouped_item_no = p_grouped_item_no
                  AND UPPER (c011.hist_seq_no) LIKE UPPER (NVL (p_hist_seq_no, c011.hist_seq_no))
                  AND UPPER (stat.le_stat_desc) LIKE UPPER (NVL (p_le_stat_desc, stat.le_stat_desc))
                  AND UPPER (NVL(c011.advise_amt,0)) LIKE UPPER (NVL (p_advice_amt, NVL(c011.advise_amt,0)))
                  AND UPPER (NVL(c011.net_amt,0)) LIKE UPPER (NVL (p_net_amt, NVL(c011.net_amt,0)))
                  AND UPPER (NVL(c011.paid_amt,0)) LIKE UPPER (NVL (p_paid_amt, NVL(c011.paid_amt,0)))
                  AND UPPER (NVL(c011.remarks, '*')) LIKE UPPER (NVL (p_remarks, NVL(c011.remarks, '*')))
                 ORDER BY C011.hist_seq_no )
                  
        LOOP
            v_list.claim_id         :=  i.claim_id;
            v_list.clm_loss_id      :=  i.clm_loss_id;
            v_list.hist_seq_no      :=  i.hist_seq_no;
            v_list.item_no          :=  i.item_no;
            v_list.peril_cd         :=  i.peril_cd;
            v_list.grouped_item_no  :=  i.grouped_item_no;
            v_list.clm_clmnt_no     :=  i.clm_clmnt_no;
            v_list.item_stat_cd     :=  i.item_stat_cd;
            v_list.le_stat_desc     :=  i.le_stat_desc;
            v_list.payee_type       :=  i.payee_type;
            v_list.payee_cd         :=  i.payee_cd;
            v_list.payee_class_cd   :=  i.payee_class_cd;
            v_list.ex_gratia_sw     :=  i.ex_gratia_sw;
            v_list.dist_sw          :=  i.dist_sw;
            v_list.cancel_sw        :=  i.cancel_sw;
            v_list.paid_amt         :=  i.paid_amt;
            v_list.net_amt          :=  i.net_amt;
            v_list.advice_amt       :=  i.advise_amt;
            v_list.remarks          :=  i.remarks;
            v_list.final_tag        :=  i.final_tag;
            v_list.advice_id        :=  i.advice_id;
			v_list.user_id        	:=  i.user_id;
            v_list.last_update      :=  i.last_update;
            v_list.exist_loss_exp_dtl  := GICL_LOSS_EXP_DTL_PKG.check_exist_loss_exp_dtl(i.claim_id, i.clm_loss_id);
            v_list.exist_loss_exp_ds   := GICL_LOSS_EXP_DS_PKG.check_exist_gicl_loss_exp_ds(i.claim_id, i.clm_loss_id);
            v_list.exist_le_ds_not_neg := GICL_LOSS_EXP_DS_PKG.check_loss_exp_ds_not_negated(i.claim_id, i.clm_loss_id);
            v_list.exist_loss_exp_tax  := GICL_LOSS_EXP_TAX_PKG.check_exist_loss_exp_tax(i.claim_id, i.clm_loss_id);
            v_list.exist_gicl_advice   := GICL_ADVICE_PKG.check_exist_gicl_advice(i.claim_id );
            v_list.exist_eval_payment  := GICL_EVAL_PAYMENT_PKG.check_exist_eval_payment(i.claim_id, i.clm_loss_id);
            v_list.exist_depreciation  := GICL_LOSS_EXP_DTL_PKG.check_exist_depreciation(i.claim_id, i.clm_loss_id);
            PIPE ROW(v_list);
        END LOOP;  

    END get_clm_loss_exp_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 01.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if records exist in GICL_CLM_LOSS_EXP
    **                  with the given parameters
    */ 
        
    FUNCTION check_exist_clm_loss_exp
        (p_claim_id             GICL_CLM_LOSS_EXP.claim_id%TYPE,
         p_item_no              GICL_CLM_LOSS_EXP.item_no%TYPE,
         p_peril_cd             GICL_CLM_LOSS_EXP.peril_cd%TYPE,
         p_grouped_item_no      GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,
         p_payee_type           GICL_CLM_LOSS_EXP.payee_type%TYPE,
         p_payee_class_cd       GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
         p_payee_cd             GICL_CLM_LOSS_EXP.payee_cd%TYPE)
         
    RETURN VARCHAR2 AS

        v_exist        VARCHAR2(1) := 'N';
     
        BEGIN
            FOR i IN (SELECT DISTINCT 'Y'
                        FROM GICL_CLM_LOSS_EXP
                       WHERE claim_id       = p_claim_id
                         AND item_no        = p_item_no
                         AND peril_cd       = p_peril_cd
                         AND grouped_item_no  = p_grouped_item_no 
                         AND payee_type     = p_payee_type 
                         AND payee_class_cd = p_payee_class_cd
                         AND payee_cd       = p_payee_cd)
            LOOP
                v_exist := 'Y';
            END LOOP;
            
            RETURN v_exist;
            
        END check_exist_clm_loss_exp;
        
  /*
  **  Created by    : Veronica V. Raymundo
  **  Date Created  : 02.08.2012
  **  Reference By  : GICLS030 - Loss/Expense History
  **  Description   : Gets the next value of clm_loss_id
  */ 

    FUNCTION get_next_clm_loss_id(p_claim_id   IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN NUMBER AS

    v_clm_loss_id		GICL_CLM_LOSS_EXP.clm_loss_id%TYPE;

    BEGIN
        FOR i IN (SELECT NVL(MAX(clm_loss_id),0) + 1 clm_loss_id
                    FROM GICL_CLM_LOSS_EXP
                   WHERE claim_id = p_claim_id)
        
        LOOP
            v_clm_loss_id := i.clm_loss_id;        
        END LOOP;
        
        RETURN v_clm_loss_id;
        
    END get_next_clm_loss_id;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.09.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Inserts or updates record on GICL_CLM_LOSS_EXP table
    */ 

    PROCEDURE set_clm_loss_exp_2
    (p_claim_id          IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,                   
     p_clm_loss_id       IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,       
     p_hist_seq_no       IN  GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,       
     p_item_no           IN  GICL_CLM_LOSS_EXP.item_no%TYPE,            
     p_peril_cd          IN  GICL_CLM_LOSS_EXP.peril_cd%TYPE,          
     p_grouped_item_no   IN  GICL_CLM_LOSS_EXP.grouped_item_no%TYPE,   
     p_clm_clmnt_no      IN  GICL_CLM_LOSS_EXP.clm_clmnt_no%TYPE,      
     p_item_stat_cd      IN  GICL_CLM_LOSS_EXP.item_stat_cd%TYPE,      
     p_payee_type        IN  GICL_CLM_LOSS_EXP.payee_type%TYPE,        
     p_payee_cd          IN  GICL_CLM_LOSS_EXP.payee_cd%TYPE,          
     p_payee_class_cd    IN  GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,    
     p_ex_gratia_sw      IN  GICL_CLM_LOSS_EXP.ex_gratia_sw%TYPE,      
     p_dist_sw           IN  GICL_CLM_LOSS_EXP.dist_sw%TYPE,           
     p_cancel_sw         IN  GICL_CLM_LOSS_EXP.cancel_sw%TYPE,         
     p_paid_amt          IN  GICL_CLM_LOSS_EXP.paid_amt%TYPE,          
     p_net_amt           IN  GICL_CLM_LOSS_EXP.net_amt%TYPE,           
     p_advise_amt        IN  GICL_CLM_LOSS_EXP.advise_amt%TYPE,        
     p_remarks           IN  GICL_CLM_LOSS_EXP.remarks%TYPE,           
     p_final_tag         IN  GICL_CLM_LOSS_EXP.final_tag%TYPE,         
     p_user_id           IN  GICL_CLM_LOSS_EXP.user_id%TYPE) 
     
     AS
     
     BEGIN
        MERGE INTO GICL_CLM_LOSS_EXP
        USING dual ON ( claim_id    = p_claim_id
                    AND clm_loss_id = p_clm_loss_id
                        )
        WHEN NOT MATCHED THEN
            INSERT(
                claim_id,        clm_loss_id,      hist_seq_no,       item_no,      
                peril_cd,        grouped_item_no,  clm_clmnt_no,      item_stat_cd,     
                payee_type,      payee_cd,         payee_class_cd,    ex_gratia_sw,    
                dist_sw,         cancel_sw,        paid_amt,          net_amt,           
                advise_amt,      remarks,          final_tag,         user_id,
                last_update
            )
            VALUES(
                p_claim_id,      p_clm_loss_id,     p_hist_seq_no,    p_item_no,    
                p_peril_cd,      p_grouped_item_no, p_clm_clmnt_no,   p_item_stat_cd,   
                p_payee_type,    p_payee_cd,        p_payee_class_cd, p_ex_gratia_sw,  
                p_dist_sw,       p_cancel_sw,       p_paid_amt,       p_net_amt,         
                p_advise_amt,    p_remarks,         p_final_tag,      p_user_id,
                SYSDATE
            )
        WHEN MATCHED THEN 
            UPDATE SET      
                hist_seq_no     = p_hist_seq_no,             
                item_stat_cd    = p_item_stat_cd,     
                payee_type      = p_payee_type,      
                payee_cd        = p_payee_cd,         
                payee_class_cd  = p_payee_class_cd,    
                ex_gratia_sw    = p_ex_gratia_sw,    
                dist_sw         = p_dist_sw,         
                cancel_sw       = p_cancel_sw,        
                paid_amt        = p_paid_amt,          
                net_amt         = p_net_amt,           
                advise_amt      = p_advise_amt,      
                remarks         = p_remarks,          
                final_tag       = p_final_tag,         
                user_id         = p_user_id,
                last_update     = SYSDATE;            
     END;
     
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.09.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes record from GICL_CLM_LOSS_EXP table
    */
     
    PROCEDURE delete_clm_loss_exp(p_claim_id    IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                  p_clm_loss_id IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    AS

    BEGIN
        
        DELETE FROM GICL_CLM_LOSS_EXP
           WHERE claim_id = p_claim_id
           AND clm_loss_id = p_clm_loss_id;
           
    END delete_clm_loss_exp;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_CLM_LOSS_EXP records
    **                  for View History of Loss/Expense History
    */ 
    FUNCTION get_view_hist_clm_loss_exp( 
     p_line_cd         IN   GIIS_LINE.line_cd%TYPE,
     p_claim_id        IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_item_no         IN   GICL_CLM_LOSS_EXP.item_no%TYPE,
     p_peril_cd        IN   GICL_CLM_LOSS_EXP.peril_cd%TYPE,   
     p_payee_type      IN   GICL_CLM_LOSS_EXP.payee_type%TYPE,
     p_payee_class_cd  IN   GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
     p_payee_cd        IN   GICL_CLM_LOSS_EXP.payee_cd%TYPE,
     p_hist_seq_no     IN   GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
     p_le_stat_desc    IN   GICL_LE_STAT.le_stat_desc%TYPE,
     p_peril_sname     IN   GIIS_PERIL.peril_sname%TYPE,
     p_payee_name      IN   GIIS_PAYEES.payee_last_name%TYPE,
     p_advice_amt      IN   GICL_CLM_LOSS_EXP.advise_amt%TYPE,
     p_net_amt         IN   GICL_CLM_LOSS_EXP.net_amt%TYPE,
     p_paid_amt        IN   GICL_CLM_LOSS_EXP.paid_amt%TYPE)
     
     RETURN clm_loss_exp_tab PIPELINED AS
            
     v_list           clm_loss_exp_type;
     
     BEGIN
        FOR i IN (SELECT a.claim_id,      a.clm_loss_id,      a.peril_cd,     b.peril_sname, 
                         a.item_stat_cd,  c.le_stat_desc,     a.payee_cd,     d.payee_last_name,  
                         a.payee_type,    a.payee_class_cd,   a.hist_seq_no,  NVL(a.dist_sw, 'N') dist_sw, 
                         a.item_no,       a.paid_amt,         a.net_amt,      a.advise_amt,
                         a.clm_clmnt_no,  a.ex_gratia_sw,     a.user_id,      a.last_update
                    FROM GICL_CLM_LOSS_EXP a,
                         GIIS_PERIL b,
                         GICL_LE_STAT c,
                         GIIS_PAYEES d
                    WHERE c.le_stat_cd  = a.item_stat_cd
                      AND a.peril_cd    = b.peril_cd
                      AND d.payee_class_cd = a.payee_class_cd
                      AND d.payee_no    = a.payee_cd
                      AND b.line_cd     = p_line_cd
                      AND a.claim_id    = p_claim_id 
                      AND a.item_no     = p_item_no 
                      AND a.peril_cd    = p_peril_cd 
                      AND a.payee_type  = p_payee_type
                      AND a.payee_class_cd = p_payee_class_cd 
                      AND a.payee_cd    = p_payee_cd
                      AND UPPER (a.hist_seq_no) LIKE UPPER (NVL (p_hist_seq_no, a.hist_seq_no))
                      AND UPPER (c.le_stat_desc) LIKE UPPER (NVL (p_le_stat_desc, c.le_stat_desc))
                      AND UPPER (b.peril_sname) LIKE UPPER (NVL (p_peril_sname, b.peril_sname))
                      AND UPPER (NVL(d.payee_last_name, '*')) LIKE UPPER (NVL (p_payee_name, NVL(d.payee_last_name, '*')))
                      AND UPPER (NVL(a.advise_amt,0)) LIKE UPPER (NVL (p_advice_amt, NVL(a.advise_amt,0)))
                      AND UPPER (NVL(a.net_amt,0)) LIKE UPPER (NVL (p_net_amt, NVL(a.net_amt,0)))
                      AND UPPER (NVL(a.paid_amt,0)) LIKE UPPER (NVL (p_paid_amt, NVL(a.paid_amt,0)))
              ORDER BY a.hist_seq_no)
                      
         
        LOOP
            v_list.claim_id         :=  i.claim_id;
            v_list.clm_loss_id      :=  i.clm_loss_id;
            v_list.peril_cd         :=  i.peril_cd;
            v_list.peril_sname      :=  i.peril_sname;    
            v_list.item_stat_cd     :=  i.item_stat_cd;
            v_list.le_stat_desc     :=  i.le_stat_desc;    
            v_list.payee_cd         :=  i.payee_cd;
            v_list.payee_last_name  :=  i.payee_last_name;    
            v_list.payee_type       :=  i.payee_type;
            v_list.payee_class_cd   :=  i.payee_class_cd;
            v_list.hist_seq_no      :=  i.hist_seq_no;
            v_list.dist_sw          :=  i.dist_sw;
            v_list.item_no          :=  i.item_no;    
            v_list.paid_amt         :=  i.paid_amt;
            v_list.net_amt          :=  i.net_amt;
            v_list.advice_amt       :=  i.advise_amt;
            v_list.clm_clmnt_no     :=  i.clm_clmnt_no;    
            v_list.ex_gratia_sw     :=  i.ex_gratia_sw;    
            v_list.user_id          :=  i.user_id;
            v_list.last_update      :=  i.last_update;
            PIPE ROW(v_list);
            
        END LOOP;
     
     END get_view_hist_clm_loss_exp;
 
 
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Update the cancel_sw to 'Y' of GICL_CLM_LOSS_EXP table
    */

    PROCEDURE cancel_clm_loss_exp
    (p_claim_id       IN   GICL_CLAIMS.claim_id%TYPE,
     p_hist_seq_no    IN   GICL_CLM_LOSS_EXP.hist_seq_no%TYPE,
     p_item_no        IN   GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd       IN   GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type     IN   GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_class_cd IN   GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
     p_payee_cd       IN   GICL_LOSS_EXP_PAYEES.payee_cd%TYPE) AS

    BEGIN
        
        UPDATE GICL_CLM_LOSS_EXP
         SET cancel_sw = 'Y'
        WHERE claim_id = p_claim_id
          AND hist_seq_no = p_hist_seq_no
          AND item_no = p_item_no
          AND peril_cd = p_peril_cd
          AND payee_type = p_payee_type
          AND payee_class_cd = p_payee_class_cd
          AND payee_cd = p_payee_cd;
          
    END cancel_clm_loss_exp;
    
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Update the paid_amt, net_amt, advise_amt columns 
    **                  of GICL_CLM_LOSS_EXP table
    */

    PROCEDURE update_clm_loss_exp_amts
    (p_claim_id     IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_advise_amt   IN  GICL_CLM_LOSS_EXP.advise_amt%TYPE,
     p_paid_amt     IN  GICL_CLM_LOSS_EXP.paid_amt%TYPE,
     p_net_amt      IN  GICL_CLM_LOSS_EXP.net_amt%TYPE,
     p_user_id      IN  GIIS_USERS.user_id%TYPE) AS
     
    BEGIN

        UPDATE GICL_CLM_LOSS_EXP
           SET advise_amt = p_advise_amt,
               paid_amt   = p_paid_amt,
               net_amt    = p_net_amt,
               user_id    = p_user_id,
               last_update = SYSDATE
        WHERE claim_id = p_claim_id
          AND clm_loss_id = p_clm_loss_id;
               
    END update_clm_loss_exp_amts;
 
    /*
    **  Created by    : Andrew Robes
    **  Date Created  : 02.21.2012
    **  Reference By  : GICLS032 - Generate Advice
    **  Description   : Update the advice_id of the clm_loss_exp record based on claim_id and clm_loss_id
    */
    PROCEDURE UPDATE_CLM_LOSS_EXP_ADVICE_ID(
      p_advice_id  GICL_ADVICE.advice_id%TYPE,
      p_claim_id   GICL_ADVICE.claim_id%TYPE,
      p_clm_loss_id GICL_CLM_LOSS_EXP.clm_loss_id%TYPE
    ) IS
    BEGIN
      UPDATE gicl_clm_loss_exp
         SET advice_id = p_advice_id
       WHERE claim_id = p_claim_id
         AND clm_loss_id = p_clm_loss_id;
    END UPDATE_CLM_LOSS_EXP_ADVICE_ID;
    
    /*
    **  Created by    : Andrew Robes
    **  Date Created  : 02.27.2012
    **  Reference By  : GICLS032 - Generate Advice
    **  Description   : Function to retrieve gicl_clm_loss_exp records to be used in generate acc entries
    */
  FUNCTION get_gen_acc_clm_loss (
    p_claim_id GICL_CLM_LOSS_EXP.claim_id%TYPE,
    p_advice_id GICL_CLM_LOSS_EXP.advice_id%TYPE
  ) RETURN gen_acc_clm_loss_tab PIPELINED IS
    v_gen gen_acc_clm_loss_type;
    v_local_currency NUMBER := giacp.n('CURRENCY_CD');
  BEGIN
    FOR i IN(
         SELECT b.payee_cd, b.payee_class_cd, sum(b.paid_amt * decode (NVL(a.orig_curr_cd, v_local_currency),v_local_currency,1,NVL(a.orig_curr_rate,1))) payee_amount
          FROM gicl_advice a, gicl_clm_loss_exp b
         WHERE a.claim_id = b.claim_id
           AND a.advice_id = b.advice_id
           AND a.advice_flag = 'Y'
           AND a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id
        GROUP BY payee_cd, payee_class_cd)
    LOOP
      v_gen.payee_cd := i.payee_cd;
      v_gen.payee_class_cd := i.payee_class_cd;
      v_gen.payee_amount := i.payee_amount;
      PIPE ROW(v_gen);
    END LOOP;
    RETURN;
  END get_gen_acc_clm_loss;

    /*
    **  Created by    : Andrew Robes
    **  Date Created  : 02.27.2012
    **  Reference By  : GICLS032 - Generate Advice
    **  Description   : Procedure to check if there is WITHHOLDING_TAX record, to be used in generate acc entries
    */
  PROCEDURE val_clm_loss_exp_tax(
    p_claim_id gicl_clm_loss_exp.claim_id%TYPE,
    p_advice_id gicl_clm_loss_exp.advice_id%TYPE,
    p_count OUT NUMBER,
    p_message OUT VARCHAR2
  ) IS
  BEGIN
    BEGIN
        SELECT count('x')
          INTO p_count
          FROM gicl_clm_loss_exp a, gicl_loss_exp_tax b
         WHERE a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id
           AND b.tax_type = 'W';   
    EXCEPTION
      WHEN NO_DATA_FOUND THEN        
        RAISE_APPLICATION_ERROR(-20001, 'No WITHHOLDING_TAX in giac_parameters.');
    END;    
  END val_clm_loss_exp_tax;
  
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.07.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Update the paid_amt, net_amt, advise_amt columns 
    **                  of GICL_CLM_LOSS_EXP table with exclusive taxes only
    */

    PROCEDURE upd_clm_loss_exp_amts_with_tax
    (p_claim_id     IN  GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_user_id      IN  GIIS_USERS.user_id%TYPE) AS
     
     v_tax_amt1    	    GICL_LOSS_EXP_TAX.tax_amt%TYPE;
     v_tax_amt2    	    GICL_LOSS_EXP_TAX.tax_amt%TYPE;
     v_tax_amt3    	    GICL_LOSS_EXP_TAX.tax_amt%TYPE;
     v_paid_amt         NUMBER;
     v_net_amt          NUMBER;
     v_advise_amt       NUMBER;
     
    BEGIN

	--FOR i IN(SELECT NVL(SUM(tax_amt),0) tax_amt--commented out by aliza g. 07/06/2015
        FOR i IN(SELECT NVL(SUM(DECODE(tax_type, 'W',tax_amt*-1, tax_amt)),0) tax_amt --replaced code above for SR 19617

  			       FROM GICL_LOSS_EXP_TAX	
           	      WHERE claim_id = p_claim_id
           		    AND clm_loss_id = p_clm_loss_id
           		    AND NVL(w_tax,'N') = 'N') --jen.04272007 will select exclusive taxes only
        LOOP 
  	        v_tax_amt1 := i.tax_amt;
        END LOOP;
        
        FOR update_main IN(SELECT SUM(NVL(dtl_amt,0)) tot_amt
                             FROM GICL_LOSS_EXP_DTL
                            WHERE claim_id = p_claim_id
                              AND clm_loss_id = p_clm_loss_id)
        LOOP
          v_paid_amt   := NVL(update_main.tot_amt,0) + NVL(v_tax_amt1,0);
          v_net_amt    := NVL(update_main.tot_amt,0) + NVL(v_tax_amt2,0);
          v_advise_amt := NVL(update_main.tot_amt,0) + NVL(v_tax_amt3,0);
          
          GICL_CLM_LOSS_EXP_PKG.update_clm_loss_exp_amts(p_claim_id, p_clm_loss_id, v_advise_amt, v_paid_amt, v_net_amt, p_user_id);
          
        END LOOP;
               
    END upd_clm_loss_exp_amts_with_tax;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.26.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_CLM_LOSS_EXP records
    **                  for LOA Printing
    */ 
    
    FUNCTION get_loa_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN loa_csl_tab PIPELINED AS

      v_loa       loa_csl_type;

    BEGIN
        FOR i IN (/*from mceval report, loa generated in gicls030*/ 
            ((/*from mceval report, loa generated in gicls030*/ 
                SELECT e.payee_cd payee_cd, e.payee_class_cd payee_class_cd, b.class_desc class_desc, e.paid_amt paid_amt, 
                       c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,', '||c.payee_first_name) ||
                       DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name) payee_name, 
                       e.claim_id claim_id, e.clm_loss_id clm_loss_id, e.hist_seq_no hist_seq_no, e.remarks remarks, g.eval_id eval_id, 
                       DECODE(NVL(f.cancel_sw,'N'),'N',f.subline_cd||'-'||f.iss_cd||'-'||LTRIM(TO_CHAR(f.loa_yy,'09'))|| '-'||
                       LTRIM(TO_CHAR(f.loa_seq_no,'00009')),'Y',NULL) loa_no, 
                       h.tp_sw tp_sw,h.payee_class_cd tp_payee_class_cd, h.payee_no tp_payee_no 
                  FROM GIIS_PAYEE_CLASS b, 
                       GIIS_PAYEES c, 
                       GICL_CLM_LOSS_EXP e, 
                       GICL_EVAL_PAYMENT g, 
                       GICL_EVAL_LOA f, 
                       GICL_MC_EVALUATION h 
                 WHERE 1=1 
                   AND e.claim_id = g.claim_id 
                   AND e.clm_loss_id = g.clm_loss_id 
                   AND g.eval_id = f.eval_id 
                   AND e.payee_class_cd = f.payee_type_cd 
                   AND e.payee_cd = f.payee_cd 
                   AND e.payee_class_cd = b.payee_class_cd 
                   AND e.payee_cd = c.payee_no 
                   AND e.payee_class_cd = c.payee_class_cd 
                   AND g.claim_id = e.claim_id 
                   AND g.eval_id = h.eval_id 
                   AND NVL(b.loa_sw,'N') = 'Y' 
                   AND NVL(e.dist_sw,'N') = 'Y'
                   AND e.claim_id = p_claim_id 
                UNION ALL /*from mc eval, has loss/exp history and loa not yet generated*/ 
                  SELECT e.payee_cd payee_cd, e.payee_class_cd payee_class_cd, b.class_desc class_desc, e.paid_amt paid_amt, 
                         c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,', '||c.payee_first_name) ||
                         DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name) payee_name,
                          e.claim_id claim_id, e.clm_loss_id clm_loss_id, e.hist_seq_no hist_seq_no, e.remarks remarks, g.eval_id eval_id, 
                          '' loa_no, d.tp_sw tp_sw, d.payee_class_cd tp_payee_class_cd, d.payee_no tp_payee_no 
                    FROM GIIS_PAYEE_CLASS b, 
                         GIIS_PAYEES c, 
                         GICL_MC_EVALUATION d, 
                         GICL_CLM_LOSS_EXP e, 
                         GICL_EVAL_PAYMENT g 
                   WHERE 1=1 
                     AND e.claim_id = g.claim_id 
                     AND e.clm_loss_id = g.clm_loss_id 
                     AND e.payee_class_cd = b.payee_class_cd 
                     AND e.payee_cd = c.payee_no 
                     AND e.payee_class_cd = c.payee_class_cd 
                     AND g.claim_id = e.claim_id 
                     AND g.eval_id = d.eval_id 
                     AND NVL(b.loa_sw,'N') = 'Y' 
                     AND NVL(e.dist_sw,'N') = 'Y'
                     AND e.claim_id = p_claim_id 
                     AND NOT EXISTS (SELECT 1 
                                       FROM GICL_EVAL_LOA 
                                     WHERE eval_id = g.eval_id)) 
                UNION /*generated from gicls030*/ 
                  SELECT e.payee_cd payee_cd, e.payee_class_cd payee_class_cd, b.class_desc class_desc, e.paid_amt paid_amt, 
                         c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,', '||c.payee_first_name) ||
                         DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name) payee_name, 
                         e.claim_id claim_id, e.clm_loss_id clm_loss_id, e.hist_seq_no hist_seq_no, e.remarks remarks, NULL eval_id, f.loa_no loa_no, 
                         NULL tp_sw,NULL tp_payee_class_cd, NULL tp_payee_cd 
                    FROM GIIS_PAYEE_CLASS b, 
                         GIIS_PAYEES c, 
                         GICL_CLM_LOSS_EXP e, 
                         (SELECT DECODE(NVL(g.cancel_sw,'N'),'N',g.subline_cd||DECODE(g.subline_cd,NULL,'','-')||g.iss_cd|| 
                                 DECODE(g.subline_cd,NULL,'','-')||LTRIM(TO_CHAR(g.loa_yy,'09'))|| DECODE(g.subline_cd,NULL,'','-')||
                                 LTRIM(TO_CHAR(g.loa_seq_no,'00009')),'Y',NULL) loa_no, claim_id, clm_loss_id 
                            FROM GICL_EVAL_LOA g 
                           WHERE NVL(cancel_sw,'N') = 'N') f 
                   WHERE 1=1 
                     AND e.claim_id = f.claim_id(+) 
                     AND e.clm_loss_id = f.clm_loss_id(+) 
                     AND e.payee_class_cd = b.payee_class_cd 
                     AND e.payee_cd = c.payee_no 
                     AND e.payee_class_cd = c.payee_class_cd 
                     AND NVL(b.loa_sw,'N') = 'Y' 
                     AND NVL(e.dist_sw,'N') = 'Y'
                     AND e.claim_id = p_claim_id 
                     AND NOT EXISTS (SELECT 'a' 
                                       FROM GICL_EVAL_PAYMENT 
                                      WHERE claim_id = e.claim_id 
                                        AND clm_loss_id = e.clm_loss_id)))
        
        LOOP
            v_loa.payee_cd          := i.payee_cd;            
            v_loa.payee_class_cd    := i.payee_class_cd; 
            v_loa.class_desc        := i.class_desc;
            v_loa.paid_amt          := i.paid_amt; 
            v_loa.payee_name        := i.payee_name;
            v_loa.claim_id          := i.claim_id;  
            v_loa.clm_loss_id       := i.clm_loss_id;  
            v_loa.hist_seq_no       := i.hist_seq_no;  
            v_loa.remarks           := i.remarks;  
            v_loa.eval_id           := i.eval_id;  
            v_loa.loa_no            := i.loa_no;  
            v_loa.tp_sw             := i.tp_sw;  
            v_loa.tp_payee_class_cd := i.tp_payee_class_cd;  
            v_loa.tp_payee_no       := i.tp_payee_no;
            PIPE ROW(v_loa);
                    
        END LOOP;
    END get_loa_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.26.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_CLM_LOSS_EXP records
    **                  for CSL Printing
    */ 
    
    FUNCTION get_csl_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN loa_csl_tab PIPELINED AS

      v_csl       loa_csl_type;

    BEGIN
        FOR i IN (/*from mceval report, loa generated in gicls030*/ 
            SELECT e.payee_cd payee_cd, e.payee_class_cd payee_class_cd, b.class_desc class_desc, e.paid_amt paid_amt, 
                   c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,','||c.payee_first_name) ||
                   decode(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name||'.') payee_name, 
                   e.claim_id claim_id, e.clm_loss_id clm_loss_id, e.hist_seq_no hist_seq_no, e.remarks remarks, g.eval_id eval_id, 
                   f.subline_cd||'-'||f.iss_cd||'-'||LTRIM(TO_CHAR(f.csl_yy,'09')) ||'-'||LTRIM(TO_CHAR(f.csl_seq_no,'00009')) csl_no, 
                   f.tp_sw tp_sw, h.payee_class_cd tp_payee_class_cd, h.payee_no tp_payee_no 
              FROM GIIS_PAYEE_CLASS b, 
                   GIIS_PAYEES c, 
                   GICL_CLM_LOSS_EXP e, 
                   GICL_EVAL_PAYMENT g, 
                   GICL_EVAL_CSL f, 
                   GICL_MC_EVALUATION h 
             WHERE 1=1 
               AND e.claim_id = g.claim_id 
               AND e.clm_loss_id = g.clm_loss_id 
               AND g.eval_id = f.eval_id 
               AND e.payee_class_cd = f.payee_type_cd 
               AND e.payee_cd = f.payee_cd 
               AND e.payee_class_cd = b.payee_class_cd 
               AND e.payee_cd = c.payee_no 
               AND e.payee_class_cd = c.payee_class_cd 
               AND g.claim_id = e.claim_id 
               AND g.eval_id = h.eval_id 
               AND NVL(b.loa_sw,'N') = 'N' 
               AND NVL(e.dist_sw,'N') = 'Y'
               AND e.claim_id = p_claim_id 
            UNION ALL 
            /*from mc eval, has loss/exp hist, loa not yet generated*/ 
              SELECT e.payee_cd payee_cd, e.payee_class_cd payee_class_cd, b.class_desc class_desc, e.paid_amt paid_amt, 
                     c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,','||c.payee_first_name) ||
                     DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name||'.') payee_name, 
                     e.claim_id claim_id, e.clm_loss_id clm_loss_id, e.hist_seq_no hist_seq_no, e.remarks remarks, g.eval_id eval_id, 
                     NULL csl_no, d.tp_sw tp_sw, d.payee_class_cd tp_payee_class_cd, d.payee_no tp_payee_no
                FROM GIIS_PAYEE_CLASS b, 
                     GIIS_PAYEES c, 
                     GICL_MC_EVALUATION d, 
                     GICL_CLM_LOSS_EXP e, 
                     GICL_EVAL_PAYMENT g 
               WHERE 1=1 
                 AND e.claim_id = g.claim_id 
                 AND e.clm_loss_id = g.clm_loss_id 
                 AND e.payee_class_cd = b.payee_class_cd 
                 AND e.payee_cd = c.payee_no 
                 AND e.payee_class_cd = c.payee_class_cd 
                 AND g.claim_id = e.claim_id 
                 AND g.eval_id = d.eval_id 
                 AND NVL(b.loa_sw,'N') = 'N' 
                 AND NVL(e.dist_sw,'N') = 'Y'
                 AND e.claim_id = p_claim_id 
                 AND NOT EXISTS (SELECT 1 
                                   FROM GICL_EVAL_CSL 
                                 WHERE eval_id = g.eval_id) 
            UNION 
            /*generated from gicls030*/ 
            SELECT e.payee_cd payee_cd, e.payee_class_cd payee_class_cd, b.class_desc class_desc, e.paid_amt paid_amt, 
                   c.payee_last_name||DECODE(c.payee_first_name,NULL,NULL,','||c.payee_first_name) ||
                   DECODE(c.payee_middle_name,NULL,NULL,' '||c.payee_middle_name||'.') payee_name, 
                   e.claim_id claim_id, e.clm_loss_id clm_loss_id, e.hist_seq_no hist_seq_no, e.remarks remarks, NULL eval_id, 
                   f.subline_cd||DECODE(f.subline_cd,NULL,'','-')||f.iss_cd||DECODE(f.subline_cd,NULL,'','-') ||
                   LTRIM(TO_CHAR(f.csl_yy,'09'))||DECODE(f.subline_cd,NULL,'','-')|| LTRIM(TO_CHAR(f.csl_seq_no,'00009')) csl_no,
                   NULL tp_sw,NULL tp_payee_class_cd,NULL tp_payee_no 
              FROM GIIS_PAYEE_CLASS b, 
                   GIIS_PAYEES c, 
                   GICL_CLM_LOSS_EXP e, 
                   GICL_EVAL_CSL f 
             WHERE 1=1 
               AND e.claim_id = f.claim_id(+) 
               AND e.clm_loss_id = f.clm_loss_id(+) 
               AND e.payee_class_cd = b.payee_class_cd 
               AND e.payee_cd = c.payee_no 
               AND e.payee_class_cd = c.payee_class_cd 
               AND NVL(b.loa_sw,'N') = 'N' 
               AND NVL(e.dist_sw,'N') = 'Y'
               AND NVL(f.cancel_sw (+),'N') = 'N' --considered cancel sw of CSL before printing to allow generation of new CSL Number by MAC 04/06/2013
               AND e.claim_id = p_claim_id)
        LOOP
            v_csl.payee_cd          := i.payee_cd;            
            v_csl.payee_class_cd    := i.payee_class_cd; 
            v_csl.class_desc        := i.class_desc;
            v_csl.paid_amt          := i.paid_amt; 
            v_csl.payee_name        := i.payee_name;
            v_csl.claim_id          := i.claim_id;  
            v_csl.clm_loss_id       := i.clm_loss_id;  
            v_csl.hist_seq_no       := i.hist_seq_no;  
            v_csl.remarks           := i.remarks;  
            v_csl.eval_id           := i.eval_id;  
            v_csl.csl_no            := i.csl_no;  
            v_csl.tp_sw             := i.tp_sw;  
            v_csl.tp_payee_class_cd := i.tp_payee_class_cd;  
            v_csl.tp_payee_no       := i.tp_payee_no;
            PIPE ROW(v_csl);
        END LOOP;
    END get_csl_list;
      
    /*
    **  Created by    : Andrew Robes
    **  Date Created  : 03.26.2012
    **  Reference By  : GICLS032 - Generate Advice
    **  Description   : Function to retrieve the payee_cd from gicl_clm_loss_exp of the given claim_id and payee_class_cd
    */         
    FUNCTION get_payee_cd (
      p_claim_id IN gicl_clm_loss_exp.claim_id%TYPE, 
      p_payee_class_cd IN gicl_clm_loss_exp.payee_class_cd%TYPE)
       RETURN gicl_clm_loss_exp.payee_cd%TYPE
    AS
      v_payee_cd gicl_clm_loss_exp.payee_cd%TYPE;
    BEGIN
       FOR c IN (SELECT payee_cd
                   FROM gicl_clm_loss_exp
                  WHERE claim_id = p_claim_id 
                    AND payee_class_cd = p_payee_class_cd)
       LOOP
          v_payee_cd := c.payee_cd;
       END LOOP;
       RETURN v_payee_cd;
    END get_payee_cd;
    
    /*
    **  Created by    : Marco Paolo Rebong
    **  Date Created  : 03.30.2012
    **  Reference By  : GICLS033 - Generate Final Loss Advice
    **  Description   : Function to retrieve the FLA distribution details
    */     
    FUNCTION get_gicls033_dist_dtls(
        p_claim_id              GICL_CLM_LOSS_EXP.claim_id%TYPE,
        p_advice_id             GICL_CLM_LOSS_EXP.advice_id%TYPE,
        p_line_cd               GIIS_DIST_SHARE.line_cd%TYPE
    )
    RETURN gicls033_dist_dtls_tab PIPELINED AS
        v_dist                  gicls033_dist_dtls_type;
    BEGIN
        FOR i IN(SELECT A.claim_id, A.advice_id, B.line_cd, B.share_type, B.grp_seq_no, 
                        SUM(B.shr_le_pd_amt) paid_amt, SUM(B.shr_le_net_amt) net_amt, SUM(B.shr_le_adv_amt) adv_amt
                   FROM GICL_CLM_LOSS_EXP A,
                        GICL_LOSS_EXP_DS B
                  WHERE A.claim_id = B.claim_id
                    AND A.clm_loss_id = B.clm_loss_id
                    AND NVL(B.negate_tag,'N') = 'N'
                    AND A.claim_id = p_claim_id
                    AND A.advice_id = p_advice_id
                    AND B.share_type <> 1
                  GROUP BY A.claim_id, A.advice_id,
                        B.line_cd, B.share_type, B.grp_seq_no)
        LOOP
            BEGIN
                SELECT trty_name
                  INTO v_dist.trty_name
                  FROM GIIS_DIST_SHARE
                 WHERE line_cd = p_line_cd
                   AND share_cd = i.grp_seq_no;
            END;
        
            v_dist.claim_id := i.claim_id;
            v_dist.advice_id := i.advice_id;
            v_dist.line_cd := i.line_cd;
            v_dist.share_type := i.share_type;
            v_dist.grp_seq_no := i.grp_seq_no;
            v_dist.paid_amt := i.paid_amt;
            v_dist.net_amt := i.net_amt;
            v_dist.adv_amt := i.adv_amt;
            PIPE ROW(v_dist);
        END LOOP;
    END;

   PROCEDURE check_hist_seq_no (--kenneth 06162015 ST 3616
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_item_no           gicl_clm_loss_exp.item_no%TYPE,
      p_peril_cd          gicl_clm_loss_exp.peril_cd%TYPE,
      p_grouped_item_no   gicl_clm_loss_exp.grouped_item_no%TYPE,
      p_payee_type        gicl_clm_loss_exp.payee_type%TYPE,
      p_payee_class_cd    gicl_clm_loss_exp.payee_class_cd%TYPE,
      p_payee_cd          gicl_clm_loss_exp.payee_cd%TYPE,
      p_hist_seq_no       gicl_clm_loss_exp.hist_seq_no%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT DISTINCT '1'
                           FROM gicl_clm_loss_exp
                          WHERE claim_id = p_claim_id
                            AND item_no = p_item_no
                            AND peril_cd = p_peril_cd
                            AND grouped_item_no = p_grouped_item_no
                            AND payee_type = p_payee_type
                            AND payee_class_cd = p_payee_class_cd
                            AND payee_cd = p_payee_cd
                            AND hist_seq_no = p_hist_seq_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same hist_seq_no.');
      END IF;
   END;
END gicl_clm_loss_exp_pkg;
/
