CREATE OR REPLACE PACKAGE BODY cpi.csv_big_clms
AS
   /* Modified by Aliza Garza 02.17.2016 SR 5362
   ** Based from CSV printing on CS
   ** This is changed because of the new PIPE syntax required for GenWeb (using one hash key 'REC')
   */
   FUNCTION csv_giclr220 (
      p_session_id   NUMBER,
      p_loss_exp     VARCHAR2,
      p_amt          VARCHAR2
   )
      RETURN giclr220_type PIPELINED
   IS
      v_giclr220       giclr220_rec_type;
      v_count          NUMBER;
      v_date           VARCHAR2 (20);
      v_loss_type      VARCHAR2 (200);
      v_assd           giis_assured.assd_name%TYPE;
      v_intm           VARCHAR2 (1000);
      v_loss           NUMBER                        := 0;
      v_expense        NUMBER                        := 0;
      v_net_ret_loss   NUMBER                        := 0;
      v_net_ret_exp    NUMBER                        := 0;
      v_facul_loss     NUMBER                        := 0;
      v_facul_exp      NUMBER                        := 0;
      v_treaty_loss    NUMBER                        := 0;
      v_treaty_exp     NUMBER                        := 0;
      v_xol_loss       NUMBER                        := 0;
      v_xol_exp        NUMBER                        := 0;
   BEGIN
      IF p_amt = 'O'
      THEN
         IF p_loss_exp = 'L'
         THEN
            v_loss_type := 'OUTSTANDING LOSS,NET_RET, TRTY, XOL, FACUL';
         ELSIF p_loss_exp = 'E'
         THEN
            v_loss_type := 'OUTSTANDING EXPENSE,NET_RET, TRTY, XOL, FACUL';
         ELSE
            v_loss_type := 'OUTSTANDING LOSS, OUTSTANDING EXPENSE,NET RET LOSS, NET RET EXP, TRTY LOSS, TRTY EXP, XOL LOSS, XOL EXP, FACUL LOSS, FACUL EXP';
         END IF;
      ELSIF p_amt = 'R'
      THEN
         IF p_loss_exp = 'L'
         THEN
            v_loss_type := 'LOSS RESERVE,NET_RET, TRTY, XOL, FACUL';
         ELSIF p_loss_exp = 'E'
         THEN
            v_loss_type := 'EXPENSE RESERVE,NET_RET, TRTY, XOL, FACUL';
         ELSE
            v_loss_type := 'LOSS RESERVE,EXPENSE RESERVE,NET RET LOSS, NET RET EXP, TRTY LOSS, TRTY EXP, XOL LOSS, XOL EXP, FACUL LOSS, FACUL EXP';
         END IF;
      ELSIF p_amt = 'S'
      THEN
         IF p_loss_exp = 'L'
         THEN
            v_loss_type := 'LOSS PAID,NET_RET, TRTY, XOL, FACUL';
         ELSIF p_loss_exp = 'E'
         THEN
            v_loss_type := 'EXPENSE PAID,NET_RET, TRTY, XOL, FACUL';
         ELSE
            v_loss_type := 'LOSS PAID,EXPENSE PAID,NET RET LOSS, NET RET EXP, TRTY LOSS, TRTY EXP, XOL LOSS, XOL EXP, FACUL LOSS, FACUL EXP';
         END IF;
      ELSE
         IF p_loss_exp = 'L'
         THEN
            v_loss_type := 'LOSS AMOUNT,NET_RET, TRTY, XOL, FACUL';
         ELSIF p_loss_exp = 'E'
         THEN
            v_loss_type := 'EXPENSE AMOUNT,NET_RET, TRTY, XOL, FACUL';
         ELSE
            v_loss_type := 'LOSS AMOUNT,EXPENSE AMOUNT,NET RET LOSS, NET RET EXP, TRTY LOSS, TRTY EXP, XOL LOSS, XOL EXP, FACUL LOSS, FACUL EXP';
         END IF;
      END IF;
      
      v_giclr220.rec := 'CLAIM NO, POLICY NO, ASSURED NAME, INTM NAME, LOSS DATE, CLM FILE DATE,'|| v_loss_type;         
      PIPE ROW (v_giclr220);      

      -- Details
      FOR i IN (SELECT   ROWNUM, a.claim_id, a.assd_no, a.intm_no,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.clm_seq_no, '0999999')) clm,
                            b.line_cd
                         || '-'
                         || b.subline_cd
                         || '-'
                         || b.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (b.renew_no, '09')) pol,
                         b.pol_iss_cd, loss_amt, expense_amt, a.clm_file_date,
                         a.loss_date,
                         NVL (loss_amt, 0)
                         + NVL (expense_amt, 0) loss_exp_amt,
                         NVL (net_ret_loss, 0) net_ret_loss,
                         NVL (net_ret_exp, 0) net_ret_exp,
                         NVL (facul_loss, 0) facul_loss,
                         NVL (facul_exp, 0) facul_exp,
                         NVL (treaty_loss, 0) treaty_loss,
                         NVL (treaty_exp, 0) treaty_exp,
                         NVL (xol_loss, 0) xol_loss, NVL (xol_exp, 0) xol_exp
                    FROM gicl_clm_summary a, gicl_claims b
                   WHERE a.claim_id = b.claim_id AND session_id = p_session_id
                ORDER BY loss_exp_amt DESC)
      LOOP
         v_intm := NULL;

         FOR j IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = i.assd_no)
         LOOP
            v_assd := j.assd_name;
         END LOOP;

         IF i.pol_iss_cd = 'RI'
         THEN
            FOR j IN (SELECT DISTINCT g.ri_name, a.ri_cd
                                 FROM gicl_claims a, giis_reinsurer g
                                WHERE a.claim_id = i.claim_id
                                  AND a.ri_cd = g.ri_cd(+))
            LOOP
               IF v_intm IS NULL
               THEN
                  v_intm := TO_CHAR (j.ri_cd) || '/' || j.ri_name;
               ELSE
                  v_intm :=
                        v_intm || ',' || TO_CHAR (j.ri_cd) || '/'
                        || j.ri_name;
               END IF;
            END LOOP;
         ELSE
            FOR j IN (SELECT DISTINCT a.intm_no, b.intm_name, b.ref_intm_cd
                                 FROM gicl_intm_itmperil a,
                                      giis_intermediary b
                                WHERE a.intm_no = b.intm_no
                                  AND a.claim_id = i.claim_id)
            LOOP
               IF v_intm IS NULL
               THEN
                  v_intm :=
                        TO_CHAR (j.intm_no)
                     || '/'
                     || j.ref_intm_cd
                     || '/'
                     || j.intm_name;
               ELSE
                  v_intm :=
                        v_intm
                     || ','
                     || TO_CHAR (j.intm_no)
                     || '/'
                     || j.ref_intm_cd
                     || '/'
                     || j.intm_name;
               END IF;
            END LOOP;
         END IF;

         IF p_loss_exp = 'L'
         THEN
            v_giclr220.rec := i.clm ||',' || i.pol ||',"'||v_assd || '","'||v_intm || '",'||i.loss_date || ','||
                              i.clm_file_date || ','||i.loss_amt || ','||i.net_ret_loss || ','||i.treaty_loss || ',' ||
                              i.xol_loss || ','||i.facul_loss;
            PIPE ROW (v_giclr220);
         ELSIF p_loss_exp = 'E'
         THEN
            v_giclr220.rec := i.clm ||',' || i.pol ||',"'||v_assd || '","'||v_intm || '",'||i.loss_date || ','||
                              i.clm_file_date || ','||i.expense_amt || ','||i.net_ret_exp || ','||i.treaty_exp || ',' ||
                              i.xol_exp || ','||i.facul_exp;         
            PIPE ROW (v_giclr220);
         ELSE
            v_giclr220.rec := i.clm ||',' || i.pol ||',"'||v_assd || '","'||v_intm || '",'||i.loss_date || ','||
                              i.clm_file_date || ','|| i.loss_amt|| ','||i.expense_amt || ','||i.net_ret_loss|| ','||
                              i.net_ret_exp || ','||i.treaty_loss || ',' ||i.treaty_exp || ',' ||
                              i.xol_loss ||','||i.xol_exp || ','||i.facul_loss || ','||i.facul_exp;         
            PIPE ROW (v_giclr220);
         END IF;

         /*v_loss := v_loss + NVL (i.loss_amt, 0);
         v_expense := v_expense + NVL (i.expense_amt, 0);
         v_net_ret_loss := v_net_ret_loss + i.net_ret_loss;
         v_net_ret_exp := v_net_ret_exp + i.net_ret_exp;
         v_facul_loss := v_facul_loss + i.facul_loss;
         v_facul_exp := v_facul_exp + i.facul_exp;
         v_treaty_loss := v_treaty_loss + i.treaty_loss;
         v_treaty_exp := v_treaty_exp + i.treaty_exp;
         v_xol_loss := v_xol_loss + i.xol_loss;
         v_xol_exp := v_xol_exp + i.xol_exp;*/
      END LOOP;

      RETURN;
   END;
END;
/