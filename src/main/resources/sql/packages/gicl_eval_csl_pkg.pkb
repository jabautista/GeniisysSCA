CREATE OR REPLACE PACKAGE BODY CPI.gicl_eval_csl_pkg
AS
/******************************************************************************
   NAME:       gicl_eval_csl_pkg
   PURPOSE:    gicl_eval_csl related functions and procedures

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/29/2012   Irwin Tabisora 1. Created this package.
******************************************************************************/
   FUNCTION get_mc_eval_csl (
      p_eval_id          gicl_eval_csl.eval_id%TYPE,
      p_dsp_class_desc   giis_payee_class.class_desc%TYPE,
      p_payee_name       giis_payees.payee_last_name%TYPE,
      p_base_amt         VARCHAR2,
      p_csl_no           VARCHAR2
   )
      RETURN mc_eval_csl_tab PIPELINED
   IS
      mc_eval_csl   mc_eval_csl_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT   payee_cd, payee_type_cd, eval_id, class_desc,
                           payee_name, csl_no, SUM (base_amt) base_amt,
                           clm_loss_id
                      FROM (SELECT   NVL (a.payt_payee_cd,
                                          a.payee_cd
                                         ) payee_cd,
                                     NVL (a.payt_payee_type_cd,
                                          a.payee_type_cd
                                         ) payee_type_cd,
                                     a.eval_id, b.class_desc,
                                        c.payee_last_name
                                     || DECODE (c.payee_first_name,
                                                NULL, NULL,
                                                ',' || c.payee_first_name
                                               )
                                     || DECODE (c.payee_middle_name,
                                                NULL, NULL,
                                                   ' '
                                                || c.payee_middle_name
                                                || '.'
                                               ) payee_name,
                                     DECODE
                                         (d.subline_cd,
                                          NULL, NULL,
                                             d.subline_cd
                                          || '-'
                                          || d.iss_cd
                                          || '-'
                                          || TRIM (TO_CHAR (d.csl_yy, '09'))
                                          || '-'
                                          || TRIM (TO_CHAR (d.csl_seq_no,
                                                            '00009'
                                                           )
                                                  )
                                         ) csl_no,
                                     SUM (a.part_amt) base_amt, d.clm_loss_id
                                FROM gicl_replace a,
                                     giis_payee_class b,
                                     giis_payees c,
                                     gicl_eval_csl d
                               WHERE 1 = 1
                                 AND NVL (a.payt_payee_type_cd,
                                          a.payee_type_cd
                                         ) = b.payee_class_cd
                                 AND NVL (a.payt_payee_cd, a.payee_cd) =
                                                                    c.payee_no
                                 AND NVL (a.payt_payee_type_cd,
                                          a.payee_type_cd
                                         ) = c.payee_class_cd
                                 AND a.eval_id = d.eval_id(+)
                                 AND NVL (a.payt_payee_type_cd,
                                          a.payee_type_cd
                                         ) = d.payee_type_cd(+)
                                 AND NVL (a.payt_payee_cd, a.payee_cd) = d.payee_cd(+)
                                 AND NVL (b.loa_sw, 'N') = 'N'
                            GROUP BY NVL (a.payt_payee_cd, a.payee_cd),
                                     NVL (a.payt_payee_type_cd,
                                          a.payee_type_cd
                                         ),
                                     a.eval_id,
                                     b.class_desc,
                                        c.payee_last_name
                                     || DECODE (c.payee_first_name,
                                                NULL, NULL,
                                                ',' || c.payee_first_name
                                               )
                                     || DECODE (c.payee_middle_name,
                                                NULL, NULL,
                                                   ' '
                                                || c.payee_middle_name
                                                || '.'
                                               ),
                                     DECODE (d.subline_cd,
                                             NULL, NULL,
                                                d.subline_cd
                                             || '-'
                                             || d.iss_cd
                                             || '-'
                                             || TRIM (TO_CHAR (d.csl_yy, '09'))
                                             || '-'
                                             || TRIM (TO_CHAR (d.csl_seq_no,
                                                               '00009'
                                                              )
                                                     )
                                            ),
                                     d.clm_loss_id
                            UNION ALL
                            SELECT a.payee_cd, a.payee_type_cd, a.eval_id,
                                   b.class_desc,
                                      c.payee_last_name
                                   || DECODE (c.payee_first_name,
                                              NULL, NULL,
                                              ',' || c.payee_first_name
                                             )
                                   || DECODE (c.payee_middle_name,
                                              NULL, NULL,
                                              ' ' || c.payee_middle_name
                                              || '.'
                                             ) payee_name,
                                   DECODE
                                         (e.subline_cd,
                                          NULL, NULL,
                                             e.subline_cd
                                          || '-'
                                          || e.iss_cd
                                          || '-'
                                          || TRIM (TO_CHAR (e.csl_yy, '09'))
                                          || '-'
                                          || TRIM (TO_CHAR (e.csl_seq_no,
                                                            '00009'
                                                           )
                                                  )
                                         ) csl_no,
                                   d.repair_amt base_amt, e.clm_loss_id
                              FROM gicl_repair_hdr a,
                                   giis_payee_class b,
                                   giis_payees c,
                                   gicl_mc_evaluation d,
                                   gicl_eval_csl e
                             WHERE 1 = 1
                               AND a.eval_id = d.eval_id
                               AND a.payee_type_cd = b.payee_class_cd
                               AND a.payee_cd = c.payee_no
                               AND a.payee_type_cd = c.payee_class_cd
                               AND a.eval_id = e.eval_id(+)
                               AND a.payee_type_cd = e.payee_type_cd(+)
                               AND a.payee_cd = e.payee_cd(+)
                               AND NVL (b.loa_sw, 'N') = 'N'
                               AND a.actual_total_amt IS NOT NULL /*added by Jayson 04.06.2011*/)
                  GROUP BY payee_cd,
                           payee_type_cd,
                           eval_id,
                           class_desc,
                           payee_name,
                           csl_no,
                           clm_loss_id)
           WHERE eval_id = p_eval_id
             AND UPPER (class_desc) LIKE
                                    UPPER (NVL (p_dsp_class_desc, class_desc))
             AND UPPER (payee_name) LIKE
                                        UPPER (NVL (p_payee_name, payee_name))
             AND base_amt = NVL (p_base_amt, base_amt)
             AND UPPER (NVL (csl_no, '*')) =
                    UPPER (NVL (p_csl_no, DECODE (csl_no, NULL, '*', csl_no))))
      LOOP
         mc_eval_csl.payee_cd := i.payee_cd;
         mc_eval_csl.payee_type_cd := i.payee_type_cd;
         mc_eval_csl.eval_id := i.eval_id;
         mc_eval_csl.dsp_class_desc := i.class_desc;
         mc_eval_csl.payee_name := i.payee_name;
         mc_eval_csl.csl_no := i.csl_no;
         mc_eval_csl.base_amt := i.base_amt;
         mc_eval_csl.clm_loss_id := i.clm_loss_id;
         PIPE ROW (mc_eval_csl);
      END LOOP;
   END;

   FUNCTION get_mc_eval_csl_dtl (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN mc_eval_csl_dtl_tab PIPELINED
   IS
      mc_csl_dtl   mc_eval_csl_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT a.loss_exp_cd, a.part_amt, b.loss_exp_desc,
                               NVL (a.payt_payee_cd, a.payee_cd) payee_cd,
                               NVL (a.payt_payee_type_cd,
                                    a.payee_type_cd
                                   ) payee_type_cd,
                               a.eval_id
                          FROM gicl_replace a, giis_loss_exp b
                         WHERE 1 = 1
                           AND a.loss_exp_cd = b.loss_exp_cd
                           AND b.line_cd = 'MC'
                           AND NVL (b.part_sw, 'N') = 'Y'
                        UNION
                        SELECT (SELECT param_value_v
                                  FROM giis_parameters b
                                 WHERE param_name = 'LABOR_EVAL_CD'),
                               c.repair_amt,
                               (SELECT a.loss_exp_desc
                                  FROM giis_loss_exp a, giis_parameters b
                                 WHERE a.line_cd = 'MC'
                                   AND a.loss_exp_cd = b.param_value_v
                                   AND b.param_name = 'LABOR_EVAL_CD'),
                               a.payee_cd, a.payee_type_cd, a.eval_id
                          FROM gicl_repair_hdr a, gicl_mc_evaluation c
                         WHERE 1 = 1
                           AND a.actual_total_amt IS NOT NULL
                           /*added by Jayson 04.06.2011*/
                           AND a.eval_id = c.eval_id)
                 WHERE eval_id = p_eval_id
                   AND payee_type_cd = p_payee_type_cd
                   AND payee_cd = p_payee_cd)
      LOOP
         mc_csl_dtl.loss_exp_cd := i.loss_exp_cd;
         mc_csl_dtl.part_amt := i.part_amt;
         mc_csl_dtl.loss_exp_desc := i.loss_exp_desc;
         mc_csl_dtl.payee_cd := i.payee_cd;
         mc_csl_dtl.payee_type_cd := i.payee_type_cd;
         mc_csl_dtl.eval_id := i.eval_id;
         PIPE ROW (mc_csl_dtl);
      END LOOP;
   END;

   FUNCTION get_total_part_amt (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN gicl_replace.part_amt%TYPE
   IS
      v_total_part_amt   gicl_replace.part_amt%TYPE;
   BEGIN
      v_total_part_amt := 0;

      FOR i IN (SELECT *
                  FROM (SELECT a.loss_exp_cd, a.part_amt, b.loss_exp_desc,
                               NVL (a.payt_payee_cd, a.payee_cd) payee_cd,
                               NVL (a.payt_payee_type_cd,
                                    a.payee_type_cd
                                   ) payee_type_cd,
                               a.eval_id
                          FROM gicl_replace a, giis_loss_exp b
                         WHERE 1 = 1
                           AND a.loss_exp_cd = b.loss_exp_cd
                           AND b.line_cd = 'MC'
                           AND NVL (b.part_sw, 'N') = 'Y'
                        UNION
                        SELECT (SELECT param_value_v
                                  FROM giis_parameters b
                                 WHERE param_name = 'LABOR_EVAL_CD'),
                               c.repair_amt,
                               (SELECT a.loss_exp_desc
                                  FROM giis_loss_exp a, giis_parameters b
                                 WHERE a.line_cd = 'MC'
                                   AND a.loss_exp_cd = b.param_value_v
                                   AND b.param_name = 'LABOR_EVAL_CD'),
                               a.payee_cd, a.payee_type_cd, a.eval_id
                          FROM gicl_repair_hdr a, gicl_mc_evaluation c
                         WHERE 1 = 1
                           AND a.actual_total_amt IS NOT NULL
                           /*added by Jayson 04.06.2011*/
                           AND a.eval_id = c.eval_id)
                 WHERE eval_id = p_eval_id
                   AND payee_type_cd = p_payee_type_cd
                   AND payee_cd = p_payee_cd)
      LOOP
         v_total_part_amt := (v_total_part_amt + NVL (i.part_amt, 0));
      END LOOP;

      RETURN v_total_part_amt;
   END;

   PROCEDURE generate_csl (
      p_claim_id        gicl_mc_evaluation.claim_id%TYPE,
      p_item_no         gicl_mc_evaluation.item_no%TYPE,
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_tp_sw           gicl_mc_evaluation.tp_sw%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_iss_cd          gicl_claims.iss_cd%TYPE,
      p_clm_yy          gicl_claims.clm_yy%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE,
      p_remarks         gicl_eval_loa.remarks%TYPE
   )
   IS
      v_cslseq   gicl_csl_sequence.csl_seq_no%TYPE;
   BEGIN
      BEGIN
         SELECT NVL (csl_seq_no, 0) + 1
           INTO v_cslseq
           FROM gicl_csl_sequence
          WHERE subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND csl_yy = TO_CHAR (SYSDATE, 'YY')
            AND ROWNUM = 1;

         UPDATE gicl_csl_sequence
            SET csl_seq_no = v_cslseq
          WHERE subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND csl_yy = TO_CHAR (SYSDATE, 'YY');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_cslseq := 1;

            INSERT INTO gicl_csl_sequence
                        (subline_cd, iss_cd,
                         csl_yy, csl_seq_no
                        )
                 VALUES (p_subline_cd, p_iss_cd,
                         LTRIM (RTRIM (TO_CHAR (SYSDATE, 'YY'))), 1
                        );
      END;

      INSERT INTO gicl_eval_csl
                  (claim_id, item_no, payee_type_cd, payee_cd,
                   eval_id, subline_cd, iss_cd,
                   csl_yy, csl_seq_no, tp_sw, remarks
                  )
           VALUES (p_claim_id, p_item_no, p_payee_type_cd, p_payee_cd,
                   p_eval_id, p_subline_cd, p_iss_cd,
                   TO_CHAR (SYSDATE, 'YY'), v_cslseq, p_tp_sw, p_remarks
                  );
   END;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.28.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Procedure to generate CSL for
    **                  Loss Expense History. 
    */ 

    PROCEDURE generate_csl_from_loss_exp
    (p_claim_id         IN      GICL_CLAIMS.claim_id%TYPE,
     p_subline_cd       IN      GICL_CLAIMS.subline_cd%TYPE,
     p_iss_cd           IN      GICL_CLAIMS.iss_cd%TYPE,
     p_clm_yy           IN      GICL_CLAIMS.clm_yy%TYPE,
     p_item_no          IN      GICL_ITEM_PERIL.item_no%TYPE,
     p_payee_class_cd   IN      GICL_EVAL_CSL.payee_type_cd%TYPE,
     p_payee_cd         IN      GICL_EVAL_CSL.payee_cd%TYPE,
     p_clm_loss_id      IN      GICL_EVAL_CSL.clm_loss_id%TYPE,
     p_tp_sw            IN      GICL_EVAL_CSL.tp_sw%TYPE,
     p_remarks          IN      GICL_EVAL_CSL.remarks%TYPE,
     p_cancel_sw        IN      GICL_EVAL_CSL.cancel_sw%TYPE,
     p_eval_id          IN      GICL_EVAL_CSL.eval_id%TYPE) AS
     
     v_cslseq   GICL_CSL_SEQUENCE.csl_seq_no%TYPE;
     v_csl_no   VARCHAR2(100);
      
    BEGIN

        BEGIN
           SELECT NVL(csl_seq_no,0) + 1
              INTO v_cslSeq
              FROM GICL_CSL_SEQUENCE
           WHERE subline_cd = p_subline_cd
             AND iss_cd     = p_iss_cd
             AND csl_yy     = TO_CHAR(SYSDATE,'YY')
             AND ROWNUM = 1;
                             
                         
            UPDATE GICL_CSL_SEQUENCE
               SET csl_seq_no = v_cslSeq
             WHERE subline_cd = p_subline_cd
               AND iss_cd     = p_iss_cd
               AND csl_yy     = TO_CHAR(SYSDATE,'YY');
                 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_cslSeq := 1;
              INSERT INTO GICL_CSL_SEQUENCE(subline_cd, iss_cd, csl_yy, csl_seq_no)
              VALUES(p_subline_cd, p_iss_cd, TO_CHAR(SYSDATE,'YY'),1);
        END;
                    
        v_csl_no := p_subline_cd||'-'||p_iss_cd||'-'||
                    p_clm_yy||'-'||LTRIM(RTRIM(TO_CHAR(v_cslSeq,'00009'))); 

                      
        INSERT INTO GICL_EVAL_CSL
            (claim_id,      item_no,        payee_type_cd,      payee_cd, 
             clm_loss_id,   subline_cd,     iss_cd,             csl_yy, 
             csl_seq_no,    tp_sw,          remarks,            cancel_sw,          
             eval_id)
        VALUES
            (p_claim_id,    p_item_no,      p_payee_class_cd,   p_payee_cd, 
             p_clm_loss_id, p_subline_cd,   p_iss_cd,           TO_CHAR(SYSDATE,'YY'), 
             v_cslSeq,      p_tp_sw,        p_remarks,          p_cancel_sw,
             p_eval_id); 

    END generate_csl_from_loss_exp;

/**
    CREATED BY: IRWIN TABISORA
    DESCRIPTION: FOR GICLR030 REPORT DETAILS OF GICLS070 AND GICLS030
    DATE: MAY 9, 2012
**/
FUNCTION get_giclr030_details (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         giis_payees.payee_no%TYPE,
      p_eval_id          gicl_eval_payment.eval_id%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_class_desc       giis_payee_class.class_desc%TYPE,
      p_clm_loss_id      gicl_clm_loss_exp.claim_id%TYPE,
      p_peril_cd         gicl_item_peril.peril_cd%TYPE,
      p_item_no          gicl_item_peril.item_no%TYPE,
      p_module_id     VARCHAR2
   )
      RETURN giclr030_cash_settlement_tab PIPELINED
   IS
      v_giclr030     giclr030_cash_settlement_type;
      v_part_amt     gicl_replace.part_amt%TYPE;
      v_repair_amt   gicl_mc_evaluation.repair_amt%TYPE;
      v_dep          gicl_eval_deductibles.ded_amt%TYPE;
      v_ded          gicl_eval_deductibles.ded_amt%TYPE;
      v_disc         gicl_eval_deductibles.ded_amt%TYPE;
      v_totaltag     gicl_claims.total_tag%TYPE;
      v_ctr          NUMBER                               := 0;
   BEGIN
      BEGIN
        v_giclr030.contact_person := ' '; -- prevent null when concating in jasper if the value is null
         -- get wrd_contact_person, wrd_intm, wrd_addressa, wrd_addressb, wrd_addressc
         FOR z IN (SELECT a.assd_no assured, b.policy_id, a.assd_no,
                          c.mail_addr1, c.mail_addr2, c.mail_addr3
                     FROM gicl_claims a, gipi_polbasic b, giis_assured c
                    WHERE a.line_cd = b.line_cd
                      AND a.subline_cd = b.subline_cd
                      AND a.pol_iss_cd = b.iss_cd -- replaced  AND a.iss_cd = b.iss_cd
                      AND a.issue_yy = b.issue_yy
                      AND a.pol_seq_no = b.pol_seq_no
                      AND a.renew_no = b.renew_no
                      AND a.assd_no = c.assd_no
                      AND b.endt_seq_no = 0
                      AND a.claim_id = p_claim_id)
         LOOP
            FOR y IN (SELECT   a.intrmdry_intm_no, b.parent_intm_no,
                               b.contact_pers, b.intm_name, designation,
                               b.mail_addr1, b.mail_addr2, b.mail_addr3
                          FROM gipi_comm_invoice a, giis_intermediary b
                         WHERE a.intrmdry_intm_no = b.intm_no
                           AND a.policy_id = z.policy_id
                      ORDER BY b.parent_intm_no ASC)
            LOOP
               v_giclr030.contact_person := CHR (10) || 'c/o ' || y.intm_name;

               IF z.mail_addr1 IS NOT NULL
               THEN
                  v_giclr030.addressa := z.mail_addr1;
               END IF;

               IF z.mail_addr2 IS NOT NULL
               THEN
                  v_giclr030.addressb := CHR (10) || z.mail_addr2;
               END IF;

               IF z.mail_addr3 IS NOT NULL
               THEN
                  v_giclr030.addressc := CHR (10) || z.mail_addr3;
               END IF;
            END LOOP;
         END LOOP;
         v_giclr030.address := v_giclr030.addressa || v_giclr030.addressb || v_giclr030.addressc;
      END;
    
      SELECT    line_cd
             || '-'
             || subline_cd
             || '-'
             || iss_cd
             || '-'
             || LTRIM (TO_CHAR (clm_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (clm_seq_no, '0999999')) claim_no,
                line_cd
             || '-'
             || subline_cd
             || '-'
             || pol_iss_cd
             || '-'
             || LTRIM (TO_CHAR (issue_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
             || '-'
             || LTRIM (TO_CHAR (renew_no, '09')) policy_no,
             TO_CHAR (loss_date, 'fmMonth dd, RRRR') lossdate
        INTO v_giclr030.claim_no,
             v_giclr030.policy_no,
             v_giclr030.loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      
      FOR i IN (SELECT DECODE (last_name,
                               NULL, assd_name,
                                  first_name
                               || ' '
                               || DECODE(middle_initial,null,'',middle_initial || '. ') --koks 3.26.14
                               || last_name
                              ) assd_name,
                       DECODE (last_name,
                               NULL, 'Sir',
                               DECODE (designation,
                                       NULL, 'Sir',
                                       designation || ' ' || last_name
                                      )
                              ) des
                  FROM giis_assured a
                 WHERE EXISTS (
                           SELECT 1
                             FROM gicl_claims
                            WHERE assd_no = a.assd_no
                                  AND claim_id = p_claim_id))
      LOOP
         v_giclr030.assured_name := i.assd_name;
         v_giclr030.to_name := i.assd_name;
         v_giclr030.dear_to := INITCAP (i.des);
      END LOOP;
      -- get assured name, claim no, policy no, and loss date
      v_giclr030.dlbl := 'Date of Loss';
      v_giclr030.c := ':';

      IF p_payee_class_cd <> 1
      THEN     --if not assured payee, get name from assured maintenance table
         v_giclr030.dlbl :=
                         v_giclr030.dlbl || CHR (10)
                         || INITCAP (p_class_desc);
         v_giclr030.c := v_giclr030.c || CHR (10) || ':';

         BEGIN
            SELECT DECODE (payee_first_name,
                           NULL, payee_last_name,
                              payee_first_name
                           || ' '
                           || DECODE (payee_middle_name,
                                      NULL, payee_last_name,
                                         payee_middle_name
                                      || ' '
                                      || payee_last_name
                                     )
                          ),
                   DECODE (payee_last_name,
                           NULL, 'Sir',
                           DECODE (designation,
                                   NULL, 'Sir',
                                      designation
                                   || ' '
                                   || INITCAP (payee_last_name)
                                  )
                          ) des
              INTO v_giclr030.to_name,
                   v_giclr030.dear_to
              FROM giis_payees
             WHERE payee_no = p_payee_cd AND payee_class_cd = p_payee_class_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error ('-20001',
                                        'Error on retrieving payee details.'
                                       );
         END;
         
         v_giclr030.loss_date :=
                 v_giclr030.loss_date || CHR (10)
                 || UPPER (v_giclr030.to_name);
      END IF;

      IF p_module_id = 'GICLS070'
      THEN
         -- get currency
         FOR z IN (SELECT INITCAP (b.short_name) short_name
                     FROM gicl_mc_evaluation a, giis_currency b
                    WHERE a.currency_cd = b.main_currency_cd
                      AND a.eval_id = p_eval_id)
         LOOP
            v_giclr030.curr := z.short_name;
         END LOOP;
      ELSE
         -- get currency
         FOR z IN (SELECT INITCAP (b.short_name) short_name
                     FROM gicl_clm_loss_exp a, giis_currency b
                    WHERE a.currency_cd = b.main_currency_cd
                      AND a.claim_id = p_claim_id
                      AND a.clm_loss_id = p_clm_loss_id)
         LOOP
            v_giclr030.curr := z.short_name;
         END LOOP;
      END IF;
       -- v_giclr030.curr := v_giclr030.curr; 
      IF p_eval_id IS NOT NULL
      THEN                                          --if dtls are from MC EVAL
         -- get v_part_amt with taxes
         FOR i IN (SELECT z.eval_id, z.payee_type_cd, z.payee_cd,
                          NVL (y.vat_amt + y.base_amt, z.part_amt)
                                                                  gross_part
                     FROM gicl_eval_vat y,
                          (SELECT   a.eval_id, a.payee_type_cd, a.payee_cd,
                                    SUM (a.part_amt) part_amt, 'P' apply_to
                               FROM gicl_replace a
                              WHERE a.eval_id = p_eval_id
                                AND a.payee_type_cd = p_payee_class_cd
                                AND a.payee_cd = p_payee_cd
                           GROUP BY a.eval_id, a.payee_type_cd, a.payee_cd) z
                    WHERE z.eval_id = y.eval_id(+)
                      AND z.payee_type_cd = y.payee_type_cd(+)
                      AND z.payee_cd = y.payee_cd(+)
                      AND z.apply_to = y.apply_to(+)
                      AND z.eval_id = p_eval_id
                      AND z.payee_type_cd = p_payee_class_cd
                      AND z.payee_cd = p_payee_cd)
         LOOP
            v_part_amt := i.gross_part;
         END LOOP;

         -- get v_repair_amt with taxes
         FOR i IN (SELECT z.eval_id, z.payee_type_cd, z.payee_cd,
                          NVL (y.vat_amt + y.base_amt,
                               z.actual_total_amt
                              ) gross_repair
                     FROM gicl_eval_vat y,
                          (SELECT a.eval_id, a.payee_type_cd, a.payee_cd,
                                  a.actual_total_amt, 'L' apply_to
                             FROM gicl_repair_hdr a
                            WHERE a.eval_id = p_eval_id
                              AND a.payee_type_cd = p_payee_class_cd
                              AND a.payee_cd = p_payee_cd
                              AND a.actual_total_amt IS NOT NULL) z
                    WHERE z.eval_id = y.eval_id(+)
                      AND z.payee_type_cd = y.payee_type_cd(+)
                      AND z.payee_cd = y.payee_cd(+)
                      AND z.apply_to = y.apply_to(+)
                      AND z.eval_id = p_eval_id
                      AND z.payee_type_cd = p_payee_class_cd
                      AND z.payee_cd = p_payee_cd)
         LOOP
            v_repair_amt := NVL (v_repair_amt, 0) + i.gross_repair;
         END LOOP;

         -- get depreciation
         FOR i IN (SELECT SUM (ABS (ded_amt)) dep_amt
                     FROM gicl_eval_dep_dtl
                    WHERE eval_id = p_eval_id
                      AND payee_type_cd = p_payee_class_cd
                      AND payee_cd = p_payee_cd)
         LOOP
            v_dep := i.dep_amt;
         END LOOP;

         -- get deductibles
         FOR i IN (SELECT SUM (ABS (ded_amt)) ded_amt
                     FROM gicl_eval_deductibles
                    WHERE 1 = 1
                      AND eval_id = p_eval_id
                      AND payee_cd = p_payee_cd
                      AND payee_type_cd = p_payee_class_cd
                      AND ded_cd <> giisp.v ('CLM DISCOUNT'))
         LOOP
            v_ded := i.ded_amt;
         END LOOP;

         -- get discount
         FOR i IN (SELECT SUM (ABS (ded_amt)) ded_amt
                     FROM gicl_eval_deductibles
                    WHERE 1 = 1
                      AND eval_id = p_eval_id
                      AND payee_cd = p_payee_cd
                      AND payee_type_cd = p_payee_class_cd
                      AND ded_cd = giisp.v ('CLM DISCOUNT'))
         LOOP
            v_disc := i.ded_amt;
         END LOOP;
      ELSE                             --if settlement was created in gicls030
         --net of parts supplied
         FOR amtdue IN (SELECT SUM (a.ded_base_amt) paid_amt
                          FROM gicl_loss_exp_dtl a, giis_loss_exp b
                         WHERE a.claim_id = p_claim_id
                           AND a.clm_loss_id = p_clm_loss_id
                           AND a.loss_exp_cd = b.loss_exp_cd
                           AND a.line_cd = b.line_cd
                           AND b.comp_sw = '+')
         --   AND NVL(b.part_sw,'N') = 'Y') -- commented out by Queenie 051811
         LOOP
            v_part_amt := NVL (v_part_amt, 0) + NVL (amtdue.paid_amt, 0);
         END LOOP;

         -- value added tax
         FOR tax IN (SELECT SUM (tax_amt) amt
                       FROM gicl_loss_exp_tax
                      WHERE claim_id = p_claim_id
                        AND clm_loss_id = p_clm_loss_id
                        AND tax_type = 'I')
         LOOP
            v_part_amt := NVL (v_part_amt, 0) + NVL (tax.amt, 0);
         END LOOP;

         -- withholding tax
         FOR tax IN (SELECT SUM (tax_amt) amt
                       FROM gicl_loss_exp_tax
                      WHERE claim_id = p_claim_id
                        AND clm_loss_id = p_clm_loss_id
                        AND tax_type = 'W')
         LOOP
            v_part_amt := NVL (v_part_amt, 0) - NVL (tax.amt, 0);
         END LOOP;

         --get deductible
         FOR d IN
            (SELECT ABS (SUM (b.dtl_amt)) ded_amt
               FROM gicl_loss_exp_dtl b
              WHERE b.loss_exp_cd NOT IN
                       (giisp.v ('MC_DEPRECIATION_CD'),
                        giisp.v ('CLM DISCOUNT')
                       )
                AND b.claim_id = p_claim_id
                AND b.clm_loss_id = p_clm_loss_id
                AND b.ded_loss_exp_cd IS NOT NULL)
         LOOP
            v_ded := NVL (v_ded, 0) + NVL (d.ded_amt, 0);
         END LOOP;

         --get depreciation
         FOR r IN (SELECT a.loss_exp_desc, b.ded_loss_exp_cd, b.no_of_units,
                            DECODE (NVL (b.ded_rate, 0),
                                    0, 100,
                                    b.ded_rate
                                   )
                          / 100 ded_rate,
                          ABS (b.dtl_amt) dep_amt
                     FROM gicl_loss_exp_dtl b, giis_loss_exp a
                    WHERE b.loss_exp_cd = giisp.v ('MC_DEPRECIATION_CD')
                      AND b.claim_id = p_claim_id
                      AND b.clm_loss_id = p_clm_loss_id
                      AND a.line_cd = b.line_cd
                      AND a.loss_exp_cd = b.loss_exp_cd)
         LOOP
            v_dep := NVL (v_dep, 0) + NVL (r.dep_amt, 0);
         END LOOP;

         --get discount
         FOR r IN (SELECT a.loss_exp_desc, b.ded_loss_exp_cd, b.no_of_units,
                            DECODE (NVL (b.ded_rate, 0),
                                    0, 100,
                                    b.ded_rate
                                   )
                          / 100 ded_rate,
                          ABS (b.dtl_amt) dep_amt
                     FROM gicl_loss_exp_dtl b, giis_loss_exp a
                    WHERE b.loss_exp_cd = giisp.v ('CLM DISCOUNT')
                      AND b.claim_id = p_claim_id
                      AND b.clm_loss_id = p_clm_loss_id
                      AND a.line_cd = b.line_cd
                      AND a.loss_exp_cd = b.loss_exp_cd)
         LOOP
            v_disc := NVL (v_disc, 0) + NVL (r.dep_amt, 0);
         END LOOP;
      END IF;

      v_giclr030.net_claim :=
           NVL (v_part_amt, 0)
         + NVL (v_repair_amt, 0)
         - NVL (v_ded, 0)
         - NVL (v_dep, 0)
         - NVL (v_disc, 0);
      v_giclr030.market_value :=
           NVL (v_part_amt, 0)
         + NVL (v_repair_amt, 0)
         - NVL (v_dep, 0)
         - NVL (v_disc, 0);
         v_giclr030.NET_CLAIM_CHAR := TRIM(TO_CHAR(v_giclr030.NET_CLAIM, '99,999,999,999,999.99'));
       v_giclr030.MARKET_VALUE_CHAR := TRIM(TO_CHAR(v_giclr030.MARKET_VALUE, '99,999,999,999,999.99'))||chr(10)||TO_CHAR(v_ded,'fm999,999,999,990.00')||chr(10)||'------------------------';
      -- determine the signatory
      FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                    FROM giac_documents a,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND b.signatory_id = c.signatory_id
                     AND a.report_id = 'GICLR030'
                     AND a.branch_cd = p_iss_cd
                     AND a.line_cd = p_line_cd
                ORDER BY b.item_no ASC)
      LOOP
         v_giclr030.signatory := z.signatory;
         v_giclr030.designation := z.designation;
         v_giclr030.dept_lbl := z.label;
         EXIT;
      END LOOP;

      IF v_giclr030.signatory IS NULL
      THEN
         FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GICLR030'
                        AND a.branch_cd = p_iss_cd
                        AND a.line_cd IS NULL
                   ORDER BY b.item_no ASC)
         LOOP
            v_giclr030.signatory := z.signatory;
            v_giclr030.designation := z.designation;
            v_giclr030.dept_lbl := z.label;
            EXIT;
         END LOOP;
      END IF;

      IF v_giclr030.signatory IS NULL
      THEN
         FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GICLR030'
                        AND a.branch_cd IS NULL
                        AND a.line_cd = p_line_cd
                   ORDER BY b.item_no ASC)
         LOOP
            v_giclr030.signatory := z.signatory;
            v_giclr030.designation := z.designation;
            v_giclr030.dept_lbl := z.label;
            EXIT;
         END LOOP;
      END IF;

      IF v_giclr030.signatory IS NULL
      THEN
         FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GICLR030'
                        AND a.branch_cd IS NULL
                        AND a.line_cd IS NULL
                   ORDER BY b.item_no ASC)
         LOOP
            v_giclr030.signatory := z.signatory;
            v_giclr030.designation := z.designation;
            v_giclr030.dept_lbl := z.label;
            EXIT;
         END LOOP;
      END IF;

      IF v_giclr030.signatory IS NULL
      THEN
        /*  raise_application_error
                        ('-20001',
                          'No signatories maintained for report id GICLR030.'
                         );*/ NULL;
      END IF;

      --check_total_loss
      BEGIN
         SELECT 'Y'
           INTO v_totaltag
           FROM gicl_item_peril a
          WHERE claim_id = p_claim_id
            AND item_no = p_item_no
            AND peril_cd = p_peril_cd
            AND EXISTS (
                   SELECT 1
                     FROM giis_loss_ctgry
                    WHERE loss_cat_cd = a.loss_cat_cd
                      AND line_cd = p_line_cd
                      AND (   UPPER (loss_cat_des) LIKE '%TOTAL LOSS%'
                           OR UPPER (loss_cat_des) LIKE '%CARNAP%'
                          ));
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_totaltag := 'N';
      END;
        v_giclr030.total_tag := v_totaltag;
      IF v_totaltag = 'Y'
      THEN
         v_giclr030.total_loss := ' computed as follows:' || CHR (10);
         v_giclr030.lbl :=
                         'Fair Market Value' || CHR (10)
                         || 'Less: Deductible';
         v_giclr030.nlabel :='NET CLAIM'; -- v_giclr030.nlabel := CHR (10) || CHR (10) || 'NET CLAIM';
         -- get required docs
         FOR i IN (SELECT INITCAP (b.clm_doc_desc) clm_doc_desc
                     FROM gicl_reqd_docs a, gicl_clm_docs b
                    WHERE a.line_cd = b.line_cd
                      AND a.subline_cd = b.subline_cd
                      AND a.clm_doc_cd = b.clm_doc_cd
                      AND a.claim_id = p_claim_id
                      AND a.doc_cmpltd_dt IS NULL)
         LOOP
            v_ctr := v_ctr + 1;

            IF v_giclr030.reqd_docs IS NULL
            THEN
               v_giclr030.reqd_docs :=
                     'The release of our settlement check is subject to the submission of the following documents:'
                  || CHR (10)
                  || CHR (10)
                  || '       '   --koks 3.26.14
                  || v_ctr
                  || '. '
                  || i.clm_doc_desc ||CHR(10);
            ELSE
               v_giclr030.reqd_docs :=
                     v_giclr030.reqd_docs
                  || CHR (10)
                  || '       '  --koks 3.26.14
                  || v_ctr
                  || '. '
                  || i.clm_doc_desc
                  || CHR (10);
            END IF;
         END LOOP;

         IF v_giclr030.reqd_docs IS NOT NULL
         THEN
            v_giclr030.reqd_docs :=
                  v_giclr030.reqd_docs
               || CHR (10)
               || 'Lastly, the Deed of Absolute Sale must be signed by the Insured at our office when we release the settlement check.';
         ELSE
            v_giclr030.reqd_docs :=
               'Lastly, the Deed of Absolute Sale must be signed by the Insured at our office when we release the settlement check.';
         END IF;
      END IF;

      IF v_giclr030.reqd_docs IS NOT NULL
      THEN
         v_giclr030.reqd_docs :=
                   v_giclr030.reqd_docs || CHR (10) || CHR (10)
                   || 'Thank you.';
      ELSE
         v_giclr030.reqd_docs := 'Thank you.';
      END IF;
      
      pipe row(v_giclr030);   
      END;
END gicl_eval_csl_pkg;
/


