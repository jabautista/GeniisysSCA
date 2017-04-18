CREATE OR REPLACE PACKAGE BODY CPI.gicl_eval_loa_pkg
AS
/******************************************************************************
   NAME:       gicl_eval_loa_pkg
   PURPOSE:    gicl_eval_loa related functions and procedures

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/27/2012   Irwin Tabisora 1. Created this package.
******************************************************************************/
   FUNCTION get_mc_eval_loa (
      p_eval_id          gicl_eval_loa.eval_id%TYPE,
      p_dsp_class_desc   giis_payee_class.class_desc%TYPE,
      p_payee_name       giis_payees.payee_last_name%TYPE,
      p_base_amt         VARCHAR2,
      p_loa_no           VARCHAR2
   )
      RETURN mc_eval_loa_tab PIPELINED
   IS
      mc_loa      mc_eval_loa_type;
      v_ded_amt   gicl_eval_deductibles.ded_amt%TYPE;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT   payee_cd, payee_type_cd, eval_id, class_desc,
                           payee_name, loa_no, SUM (base_amt) base_amt,
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
                                          || TRIM (TO_CHAR (d.loa_yy, '09'))
                                          || '-'
                                          || TRIM (TO_CHAR (d.loa_seq_no,
                                                            '00009'
                                                           )
                                                  )
                                         ) loa_no,
                                     SUM (a.part_amt) base_amt, d.clm_loss_id
                                FROM gicl_replace a,
                                     giis_payee_class b,
                                     giis_payees c,
                                     gicl_eval_loa d
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
                                 AND b.loa_sw = 'Y'
                                 AND NVL (d.cancel_sw, 'N') = 'N'
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
                                             || TRIM (TO_CHAR (d.loa_yy, '09'))
                                             || '-'
                                             || TRIM (TO_CHAR (d.loa_seq_no,
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
                                          || TRIM (TO_CHAR (e.loa_yy, '09'))
                                          || '-'
                                          || TRIM (TO_CHAR (e.loa_seq_no,
                                                            '00009'
                                                           )
                                                  )
                                         ) loa_no,
                                   d.repair_amt base_amt, e.clm_loss_id
                              FROM gicl_repair_hdr a,
                                   giis_payee_class b,
                                   giis_payees c,
                                   gicl_mc_evaluation d,
                                   gicl_eval_loa e
                             WHERE 1 = 1
                               AND a.eval_id = d.eval_id
                               AND a.payee_type_cd = b.payee_class_cd
                               AND a.payee_cd = c.payee_no
                               AND a.payee_type_cd = c.payee_class_cd
                               AND a.eval_id = e.eval_id(+)
                               AND a.payee_type_cd = e.payee_type_cd(+)
                               AND a.payee_cd = e.payee_cd(+)
                               AND b.loa_sw = 'Y'
                               AND NVL (e.cancel_sw, 'N') = 'N')
                  GROUP BY payee_cd,
                           payee_type_cd,
                           eval_id,
                           class_desc,
                           payee_name,
                           loa_no,
                           clm_loss_id)
           WHERE eval_id = p_eval_id
             AND UPPER (class_desc) LIKE
                                    UPPER (NVL (p_dsp_class_desc, class_desc))
             AND UPPER (payee_name) LIKE
                                        UPPER (NVL (p_payee_name, payee_name))
             AND base_amt = NVL (p_base_amt, base_amt)
             AND UPPER (NVL (loa_no, '*')) =
                    UPPER (NVL (p_loa_no, DECODE (loa_no, NULL, '*', loa_no))))
      LOOP
         mc_loa.payee_cd := i.payee_cd;
         mc_loa.payee_type_cd := i.payee_type_cd;
         mc_loa.eval_id := i.eval_id;
         mc_loa.dsp_class_desc := i.class_desc;
         mc_loa.payee_name := i.payee_name;
         mc_loa.loa_no := i.loa_no;
         --mc_loa.base_amt := i.base_amt;
         mc_loa.clm_loss_id := i.clm_loss_id;
         v_ded_amt := 0;

         BEGIN
            SELECT SUM (ded_amt) ded_amt
              INTO v_ded_amt
              FROM (SELECT SUM (ded_amt) ded_amt
                      FROM gicl_eval_deductibles
                     WHERE eval_id = i.eval_id
                       AND payee_type_cd = i.payee_type_cd
                       AND payee_cd = i.payee_cd
                    UNION ALL
                    SELECT SUM (ded_amt) ded_amt
                      FROM gicl_eval_dep_dtl
                     WHERE eval_id = i.eval_id
                       AND payee_type_cd = i.payee_type_cd
                       AND payee_cd = i.payee_cd);
         --:master_loa_blk.base_amt := v_tot_base_amt;
         END;

         mc_loa.base_amt := NVL (i.base_amt, 0) - NVL (v_ded_amt, 0);

         BEGIN
            SELECT remarks
              INTO mc_loa.remarks
              FROM gicl_eval_loa
             WHERE eval_id = i.eval_id
               AND payee_cd = i.payee_cd
               AND payee_type_cd = i.payee_type_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               mc_loa.remarks := '';
         END;

         PIPE ROW (mc_loa);
      END LOOP;
   END;

   FUNCTION get_mc_eval_loa_dtl (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN mc_eval_loa_dtl_tab PIPELINED
   IS
      v_loa_dtl   mc_eval_loa_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT a.loss_exp_cd, a.part_amt, b.loss_exp_desc,
                               a.payee_cd, a.payee_type_cd, a.eval_id
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
                         WHERE 1 = 1 AND a.eval_id = c.eval_id)
                 WHERE eval_id = p_eval_id
                   AND payee_type_cd = p_payee_type_cd
                   AND payee_cd = p_payee_cd)
      LOOP
         v_loa_dtl.loss_exp_cd := i.loss_exp_cd;
         v_loa_dtl.part_amt := i.part_amt;
         v_loa_dtl.loss_exp_desc := i.loss_exp_desc;
         v_loa_dtl.payee_cd := i.payee_cd;
         v_loa_dtl.payee_type_cd := i.payee_type_cd;
         v_loa_dtl.eval_id := i.eval_id;
         PIPE ROW (v_loa_dtl);
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
      v_temp             gicl_replace.part_amt%TYPE;
   BEGIN
      v_total_part_amt := 0;

      FOR i IN (SELECT *
                  FROM (SELECT a.loss_exp_cd, a.part_amt, b.loss_exp_desc,
                               a.payee_cd, a.payee_type_cd, a.eval_id
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
                         WHERE 1 = 1 AND a.eval_id = c.eval_id)
                 WHERE eval_id = p_eval_id
                   AND payee_type_cd = p_payee_type_cd
                   AND payee_cd = p_payee_cd)
      LOOP
         -- v_temp := i.part_amt;
         v_total_part_amt := (v_total_part_amt + NVL (i.part_amt, 0));
      END LOOP;

      RETURN v_total_part_amt;
   END;

   PROCEDURE generate_loa (
       p_claim_id        gicl_mc_evaluation.claim_id%TYPE,
      p_item_no         gicl_mc_evaluation.item_no%TYPE,
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_tp_sw           gicl_mc_evaluation.tp_sw%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_iss_cd          gicl_claims.iss_cd%TYPE,
      p_clm_yy          gicl_claims.clm_yy%type,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE,
      p_remarks         gicl_eval_loa.remarks%TYPE
   )
   IS
      v_loaseq   gicl_loa_sequence.loa_seq_no%TYPE;
      v_loa_no   varchar2(100);
   BEGIN
      BEGIN
         SELECT NVL (loa_seq_no, 0) + 1 loa_seq
           INTO v_loaseq
           FROM gicl_loa_sequence
          WHERE subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND loa_yy = TO_CHAR (SYSDATE, 'YY')
            AND ROWNUM = 1;

         UPDATE gicl_loa_sequence
            SET loa_seq_no = v_loaseq
          WHERE subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND loa_yy = TO_CHAR (SYSDATE, 'YY');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_loaseq := 1;

            INSERT INTO gicl_loa_sequence
                        (subline_cd, iss_cd, loa_yy, loa_seq_no
                        )
                 VALUES (p_subline_cd, p_iss_cd, TO_CHAR (SYSDATE, 'YY'), 1
                        );
      END;
      
      v_loa_no := p_subline_cd||'-'||p_iss_cd||'-'||
					                              p_clm_yy||'-'||ltrim(rtrim(to_char(v_loaSeq,'00009')));
                                                  	INSERT INTO gicl_eval_loa(claim_id,item_no,payee_Type_cd, 
																		payee_cd, eval_id, subline_cd, 
																		iss_cd, loa_yy,loa_seq_no, 
																		tp_sw, remarks)
					VALUES(p_claim_id,p_item_no,p_payee_type_cd,
					       p_payee_cd, p_eval_id, p_subline_cd,
					       p_iss_cd, to_char(SYSDATE,'YY'), v_loaSeq, 
					       p_tp_sw, p_remarks);
   END;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.28.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if LOA with the given parameters
    **                  is already generated.
    */ 

    FUNCTION check_if_loa_generated(p_claim_id      IN  GICL_CLAIMS.claim_id%TYPE,
                                    p_clm_loss_id   IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
                                    p_nbt_tp_sw     IN  GICL_EVAL_LOA.tp_sw%TYPE) 
    RETURN VARCHAR2 AS
        
    v_loaGen        VARCHAR2(1) := 'N';

    BEGIN
        FOR i IN (SELECT 1
                    FROM GICL_EVAL_LOA
                   WHERE claim_id = p_claim_id
                     AND clm_loss_id = p_clm_loss_id
                     AND NVL(cancel_sw,'N') = 'N'
                     AND NVL(TP_SW,'N') = NVL(p_nbt_tp_sw,'N'))
        LOOP
            v_loaGen := 'Y';
        END LOOP;
        
        RETURN v_loaGen;
        
    END check_if_loa_generated;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.28.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Procedure to generate LOA for
    **                  Loss Expense History. 
    */ 

    PROCEDURE generate_loa_from_loss_exp
        (p_claim_id         IN    GICL_CLAIMS.claim_id%TYPE,
         p_subline_cd       IN    GICL_CLAIMS.subline_cd%TYPE,
         p_iss_cd           IN    GICL_CLAIMS.iss_cd%TYPE,
         p_clm_yy           IN    GICL_CLAIMS.clm_yy%TYPE,
         p_item_no          IN    GICL_ITEM_PERIL.item_no%TYPE,
         p_payee_class_cd   IN    GICL_EVAL_LOA.payee_type_cd%TYPE,
         p_payee_cd         IN    GICL_EVAL_LOA.payee_cd%TYPE,
         p_clm_loss_id      IN    GICL_EVAL_LOA.clm_loss_id%TYPE,
         p_tp_sw            IN    GICL_EVAL_LOA.tp_sw%TYPE,
         p_remarks          IN    GICL_EVAL_LOA.remarks%TYPE,
         p_cancel_sw        IN    GICL_EVAL_LOA.cancel_sw%TYPE,
         p_eval_id          IN    GICL_EVAL_LOA.eval_id%TYPE) AS
      
     v_loaSeq   GICL_LOA_SEQUENCE.loa_seq_no%TYPE;
     v_loa_no   VARCHAR2(100);
      
    BEGIN
        BEGIN
           SELECT NVL(loa_seq_no,0) + 1 loa_seq
             INTO v_loaSeq
             FROM GICL_LOA_SEQUENCE
            WHERE subline_cd = p_subline_cd
              AND iss_cd     = p_iss_cd
              AND loa_yy     = TO_CHAR(SYSDATE,'YY')
              AND ROWNUM = 1;
                                 
           UPDATE GICL_LOA_SEQUENCE
              SET loa_seq_no = v_loaSeq
            WHERE subline_cd = p_subline_cd
              AND iss_cd     = p_iss_cd
              AND loa_yy     = TO_CHAR(SYSDATE,'YY');
       EXCEPTION
             WHEN NO_DATA_FOUND THEN
               v_loaSeq := 1;
               INSERT INTO GICL_LOA_SEQUENCE(subline_cd, iss_cd, loa_yy, loa_seq_no)
               VALUES(p_subline_cd, p_iss_cd, TO_CHAR(SYSDATE,'YY'),1);
       END;
        
         v_loa_no := p_subline_cd||'-'||p_iss_cd||'-'||
                     p_clm_yy||'-'||LTRIM(RTRIM(TO_CHAR(v_loaSeq,'00009')));
                        
               
         INSERT INTO GICL_EVAL_LOA
            (claim_id,      item_no,        payee_type_cd,          payee_cd,       clm_loss_id,    
             subline_cd,    iss_cd,         loa_yy,                 loa_seq_no,     tp_sw,              
             remarks,       cancel_sw,      eval_id,                date_gen)
         VALUES
            (p_claim_id,    p_item_no,      p_payee_class_cd,       p_payee_cd,     p_clm_loss_id,  
            p_subline_cd,   p_iss_cd,       TO_CHAR(SYSDATE,'YY'),  v_loaSeq,       p_tp_sw, 
            p_remarks,      p_cancel_sw,    p_eval_id,              SYSDATE);

    END generate_loa_from_loss_exp;
    
	 /**
      CREATED BY: IRWIN TABISORA
      DESCRIPTION: FOR GICLR027 REPORT DETAILS OF GICLS070 AND GICLS030
      DATE: MAY 10, 2012
       CLARIFICATION:

        p_payee_class_cd      =    GICLS070 : master_loa_blk.payee_type_cd / GICLS030: :master_loa_blk.payee_type_cd
         p_payee_cd            =  GICLS070 : master_loa_blk.payee_cd / GICLS030: :master_loa_blk.payee_cd
         p_main_payee_class_cd  =  GICLS070 : gicl_mc_evaluation.payee_class_cd / GICLS030: :master_loa_blk.tp_payeeclasscd
         p_main_payee_no        =  GICLS070 : gicl_mc_evaluation.payee_no / GICLS030: :master_loa_blk.tp_payeeno

   **/
   FUNCTION get_gicl_r027_details (
      p_claim_id              gicl_claims.claim_id%TYPE,
      p_payee_class_cd        giis_payees.payee_class_cd%TYPE,
      p_payee_cd              giis_payees.payee_no%TYPE,
      p_main_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_main_payee_no         giis_payees.payee_no%TYPE,
      p_eval_id               gicl_eval_payment.eval_id%TYPE,
      p_iss_cd                gicl_claims.iss_cd%TYPE,
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_loa_no                VARCHAR2,
      p_tp_sw                 VARCHAR2,
      p_clm_loss_id           gicl_clm_loss_exp.claim_id%TYPE,
      p_item_no               gicl_item_peril.item_no%TYPE,
      p_user_id               VARCHAR2,
      p_module_id          VARCHAR2
   )
       RETURN giclr027_loa_tab PIPELINED
   IS
      v_loa   giclr027_loa_type;
   BEGIN
      --retrieves LOA No
      v_loa.loa_no := p_loa_no;

      --retrieves motorshop, contact person
      FOR c IN (SELECT payee_last_name, contact_pers
                  FROM giis_payees
                 WHERE payee_class_cd = p_payee_class_cd
                   AND payee_no = p_payee_cd)
      LOOP
         v_loa.motshop := c.payee_last_name;
         v_loa.cntct_prsn := c.contact_pers;
      END LOOP;

      IF p_module_id = 'GICLS070'
      THEN
         --retrieves assured, claim no, policy no and loss date
         FOR a IN (SELECT assured_name,
                             line_cd
                          || '-'
                          || subline_cd
                          || '-'
                          || iss_cd
                          || '-'
                          || '-'
                          || LTRIM (TO_CHAR (clm_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (clm_seq_no, '0999999'))
                                                                    claim_no,
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
                          TO_CHAR (loss_date, 'fmMonth DD, YYYY')
                                                                 a_loss_date
                     FROM gicl_claims
                    WHERE claim_id = p_claim_id)
         LOOP
            v_loa.assured := a.assured_name;
            v_loa.claim_no := a.claim_no;
            v_loa.policy_no := a.policy_no;
            v_loa.loss_date := a.a_loss_date;
         END LOOP;
      ELSE
         --retrieves assured, claim no, policy no and loss date
         FOR i IN (SELECT DECODE (last_name,
                                  NULL, assd_name,
                                     first_name
                                  || ' '
                                  || middle_initial
                                  || '. '
                                  || last_name
                                 ) assd_name
                     FROM giis_assured a
                    WHERE EXISTS (
                             SELECT 1
                               FROM gicl_claims
                              WHERE assd_no = a.assd_no
                                AND claim_id = p_claim_id))
         LOOP
            v_loa.assured := i.assd_name;
         END LOOP;

         FOR a IN (SELECT    line_cd
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
                          TO_CHAR (loss_date, 'fmMonth DD, YYYY') a_loss_date
                     FROM gicl_claims
                    WHERE claim_id = p_claim_id)
         LOOP
            v_loa.claim_no := a.claim_no;
            v_loa.policy_no := a.policy_no;
            v_loa.loss_date := a.a_loss_date;
         END LOOP;
      END IF;

      --retrieves information for third party, vehicle, and plate no
      IF p_tp_sw = 'Y'
      THEN
         FOR z IN (SELECT    b.payee_last_name
                          || DECODE (b.payee_first_name,
                                     NULL, '',
                                     ', ' || b.payee_first_name
                                    )
                          || DECODE (b.payee_first_name,
                                     NULL, DECODE (b.payee_middle_name,
                                                   NULL, '',
                                                   ', ' || b.payee_middle_name
                                                  ),
                                     ' ' || b.payee_middle_name
                                    ) tp_name,
                             a.model_year
                          || DECODE (a.model_year, NULL, '', ' ')
                          || c.car_company
                          || DECODE (c.car_company, NULL, '', ' ')
                          || d.make tp_vehicle,
                          a.plate_no
                     FROM gicl_mc_tp_dtl a,
                          giis_payees b,
                          giis_mc_car_company c,
                          giis_mc_make d
                    WHERE a.payee_class_cd = b.payee_class_cd
                      AND a.payee_no = b.payee_no
                      AND a.motorcar_comp_cd = c.car_company_cd(+)
                      AND a.motorcar_comp_cd = d.car_company_cd(+)
                      AND a.make_cd = d.make_cd(+)
                      AND a.payee_class_cd = p_main_payee_class_cd
                      AND a.payee_no = p_main_payee_no
                      AND a.claim_id = p_claim_id
                      AND a.item_no = p_item_no)
         LOOP
            v_loa.mk_type_t := z.tp_name;
            v_loa.mk_type_a := z.tp_vehicle;
            v_loa.plate_no := z.plate_no;
         END LOOP;
      ELSIF p_tp_sw = 'N'
      THEN
         v_loa.mk_type_t := ' ';

         FOR d IN (SELECT item_title, plate_no
                     FROM gicl_motor_car_dtl
                    WHERE claim_id = p_claim_id)
         LOOP
            v_loa.mk_type_a := d.item_title;
            v_loa.plate_no := d.plate_no;
         END LOOP;
      END IF;-- added by Kris 03.26.2014: if condition should end here to fetch the other details when tp_sw = Y
      
         IF P_MODULE_ID = 'GICLS070'
         THEN
            -- get currency
            FOR z IN (SELECT INITCAP (b.short_name) short_name
                        FROM gicl_mc_evaluation a, giis_currency b
                       WHERE a.currency_cd = b.main_currency_cd
                         AND a.eval_id = p_eval_id)
            LOOP
               v_loa.curr := z.short_name;
            END LOOP;
         ELSE
            FOR z IN (SELECT INITCAP (b.short_name) short_name
                        FROM gicl_clm_loss_exp a, giis_currency b
                       WHERE a.currency_cd = b.main_currency_cd
                         AND a.claim_id = p_claim_id
                         AND a.clm_loss_id = p_clm_loss_id)
            LOOP
               v_loa.curr := z.short_name;
            END LOOP;
         END IF;

         IF P_MODULE_ID = 'GICLS070'
         THEN
            -- get v_part_amt with taxes
            FOR i IN (SELECT NVL (y.vat_amt + y.base_amt,
                                  z.part_amt
                                 ) gross_part
                        FROM (SELECT   a.eval_id, a.payee_type_cd, a.payee_cd,
                                       SUM (a.part_amt) part_amt,
                                       'P' apply_to
                                  FROM gicl_replace a
                                 WHERE a.eval_id = p_eval_id
                                   AND a.payee_type_cd = p_payee_class_cd
                                   AND a.payee_cd = p_payee_cd
                              GROUP BY a.eval_id, a.payee_type_cd, a.payee_cd) z,
                             gicl_eval_vat y
                       WHERE z.eval_id = y.eval_id(+)
                         AND z.payee_type_cd = y.payee_type_cd(+)
                         AND z.payee_cd = y.payee_cd(+)
                         AND z.apply_to = y.apply_to(+)
                         AND z.eval_id = p_eval_id
                         AND z.payee_type_cd = p_payee_class_cd
                         AND z.payee_cd = p_payee_cd)
            LOOP
               v_loa.repair_cost :=
                            NVL (v_loa.repair_cost, 0)
                            + NVL (i.gross_part, 0);
            END LOOP;

            -- get v_repair_amt with taxes
            FOR i IN
               (SELECT NVL (y.vat_amt + y.base_amt,
                            z.actual_total_amt
                           ) gross_repair
                  FROM (SELECT a.eval_id, a.payee_type_cd, a.payee_cd,
                                 NVL (a.actual_total_amt, 0)
                               + NVL (a.other_labor_amt, 0) actual_total_amt,
                               'L' apply_to
                          FROM gicl_repair_hdr a
                         WHERE a.eval_id = p_eval_id
                           AND a.payee_type_cd = p_payee_class_cd
                           AND a.payee_cd = p_payee_cd
                           AND   NVL (a.actual_total_amt, 0)
                               + NVL (a.other_labor_amt, 0) != 0) z,
                       -- abie 07222011 replaced the condition a.actual_total_amt IS NOT NULL
                       gicl_eval_vat y
                 WHERE z.eval_id = y.eval_id(+)
                   AND z.payee_type_cd = y.payee_type_cd(+)
                   AND z.payee_cd = y.payee_cd(+)
                   AND z.apply_to = y.apply_to(+)
                   AND z.eval_id = p_eval_id
                   AND z.payee_type_cd = p_payee_class_cd
                   AND z.payee_cd = p_payee_cd)
            LOOP
               v_loa.repair_cost :=
                          NVL (v_loa.repair_cost, 0)
                          + NVL (i.gross_repair, 0);
            END LOOP;

            -- get deductible
            FOR z IN
               (SELECT SUM (ABS (ded_amt)) ded_amt
                  FROM gicl_eval_deductibles a
                 WHERE 1 = 1
                   AND eval_id = p_eval_id
                   AND payee_cd = p_payee_cd
                   AND payee_type_cd = p_payee_class_cd
                   AND NOT EXISTS (
                          SELECT 1
                            FROM giis_loss_exp
                           WHERE (   line_cd = giisp.v ('LINE_CODE_MC')
                                  OR line_cd =
                                         (SELECT NVL (menu_line_cd, line_cd)
                                            FROM giis_line
                                           WHERE line_cd = p_line_cd)
                                 )
                             AND loss_exp_cd = a.ded_cd
                             AND UPPER (loss_exp_desc) =
                                                    'EXCESS OVER POLICY LIMIT'))
            LOOP
               v_loa.deductible := NVL (z.ded_amt, 0);
               v_loa.LESS := v_loa.LESS + NVL (z.ded_amt, 0);
            END LOOP;

            FOR i IN (SELECT SUM (ABS (ded_amt)) ded_amt
                        FROM gicl_eval_deductibles a
                       WHERE 1 = 1
                         AND eval_id = p_eval_id
                         AND payee_cd = p_payee_cd
                         AND payee_type_cd = p_payee_class_cd
                         AND EXISTS (
                                SELECT 1
                                  FROM giis_loss_exp
                                 WHERE (   line_cd = giisp.v ('LINE_CODE_MC')
                                        OR line_cd =
                                              (SELECT NVL (menu_line_cd,
                                                           line_cd
                                                          )
                                                 FROM giis_line
                                                WHERE line_cd = p_line_cd)
                                       )
                                   AND loss_exp_cd = a.ded_cd
                                   AND UPPER (loss_exp_desc) =
                                                    'EXCESS OVER POLICY LIMIT'))
            LOOP
               v_loa.eop := NVL (i.ded_amt, 0);
               v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (i.ded_amt, 0);
            END LOOP;

            -- get depreciation
            FOR z IN (SELECT b.loss_exp_desc, a.ded_amt, a.ded_rt
                        FROM gicl_eval_dep_dtl a, giis_loss_exp b
                       WHERE 1 = 1
                         AND a.loss_exp_cd = b.loss_exp_cd
                         AND b.line_cd = 'MC'
                         AND b.loss_exp_type = 'L'
                         AND b.comp_sw = '+'
                         AND NVL (b.part_sw, 'N') = 'Y'
                         AND a.eval_id = p_eval_id
                         AND a.payee_type_cd = p_payee_class_cd
                         AND a.payee_cd = p_payee_cd)
            LOOP
               v_loa.LESS := v_loa.LESS + z.ded_amt;

               IF UPPER (z.loss_exp_desc) = 'BATTERY'
               THEN
                  v_loa.battery := NVL (v_loa.battery, 0)
                                   + NVL (z.ded_amt, 0);
                  v_loa.bat_rt := z.ded_rt;
               ELSIF UPPER (z.loss_exp_desc) = 'TIRE'
               THEN
                  v_loa.tire := NVL (v_loa.tire, 0) + NVL (z.ded_amt, 0);
                  v_loa.tire_rt := z.ded_rt;
               ELSE
                  IF v_loa.dep_others = 0
                  THEN
                     v_loa.dep_others :=
                                NVL (v_loa.dep_others, 0)
                                + NVL (z.ded_amt, 0);
                     v_loa.other_rt := z.ded_rt;
                  ELSE
                     IF v_loa.other_rt = z.ded_rt
                     THEN
                        -- if same rate, add to dep others 1, else dep others 2
                        v_loa.dep_others :=
                                NVL (v_loa.dep_others, 0)
                                + NVL (z.ded_amt, 0);
                     ELSE
                        v_loa.dep_others2 :=
                               NVL (v_loa.dep_others2, 0)
                               + NVL (z.ded_amt, 0);
                        v_loa.other_rt2 := z.ded_rt;
                     END IF;
                  END IF;
               END IF;
            END LOOP;

            -- get v_net_liability
            v_loa.net_liability := v_loa.repair_cost - v_loa.LESS;
         ELSE
            IF p_eval_id IS NOT NULL
            THEN                                   --if dtls are from MC EVAL
               -- get v_part_amt with taxes
               FOR i IN (SELECT NVL (y.vat_amt + y.base_amt,
                                     z.part_amt
                                    ) gross_part
                           FROM gicl_eval_vat y,
                                (SELECT   a.eval_id, a.payee_type_cd,
                                          a.payee_cd,
                                          SUM (a.part_amt) part_amt,
                                          'P' apply_to
                                     FROM gicl_replace a
                                    WHERE a.eval_id = p_eval_id
                                      AND a.payee_type_cd = p_payee_class_cd
                                      AND a.payee_cd = p_payee_cd
                                 GROUP BY a.eval_id,
                                          a.payee_type_cd,
                                          a.payee_cd) z
                          WHERE z.eval_id = y.eval_id(+)
                            AND z.payee_type_cd = y.payee_type_cd(+)
                            AND z.payee_cd = y.payee_cd(+)
                            AND z.apply_to = y.apply_to(+)
                            AND z.eval_id = p_eval_id
                            AND z.payee_type_cd = p_payee_class_cd
                            AND z.payee_cd = p_payee_cd)
               LOOP
                  v_loa.repair_cost :=
                            NVL (v_loa.repair_cost, 0)
                            + NVL (i.gross_part, 0);
               END LOOP;

               -- get v_repair_amt with taxes
               FOR i IN (SELECT NVL (y.vat_amt + y.base_amt,
                                     z.actual_total_amt
                                    ) gross_repair
                           FROM (SELECT a.eval_id, a.payee_type_cd,
                                        a.payee_cd, a.actual_total_amt,
                                        'L' apply_to
                                   FROM gicl_repair_hdr a
                                  WHERE a.eval_id = p_eval_id
                                    AND a.payee_type_cd = p_payee_class_cd
                                    AND a.payee_cd = p_payee_cd
                                    AND a.actual_total_amt IS NOT NULL) z,
                                gicl_eval_vat y
                          WHERE z.eval_id = y.eval_id(+)
                            AND z.payee_type_cd = y.payee_type_cd(+)
                            AND z.payee_cd = y.payee_cd(+)
                            AND z.apply_to = y.apply_to(+)
                            AND z.eval_id = p_eval_id
                            AND z.payee_type_cd = p_payee_class_cd
                            AND z.payee_cd = p_payee_cd)
               LOOP
                  v_loa.repair_cost :=
                          NVL (v_loa.repair_cost, 0)
                          + NVL (i.gross_repair, 0);
               END LOOP;

               -- get deductible
               FOR z IN
                  (SELECT SUM (ABS (ded_amt)) ded_amt
                     FROM gicl_eval_deductibles a
                    WHERE 1 = 1
                      AND eval_id = p_eval_id
                      AND payee_cd = p_payee_cd
                      AND payee_type_cd = p_payee_class_cd
                      AND NOT EXISTS (
                             SELECT 1
                               FROM giis_loss_exp
                              WHERE (   line_cd = giisp.v ('LINE_CODE_MC')
                                     OR line_cd =
                                           (SELECT NVL (menu_line_cd, line_cd)
                                              FROM giis_line
                                             WHERE line_cd = p_line_cd)
                                    )
                                AND loss_exp_cd = a.ded_cd
                                AND UPPER (loss_exp_desc) =
                                                    'EXCESS OVER POLICY LIMIT'))
               LOOP
                  v_loa.deductible := NVL (z.ded_amt, 0);
                  v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (z.ded_amt, 0);
               END LOOP;

               FOR i IN
                  (SELECT SUM (ABS (ded_amt)) ded_amt
                     FROM gicl_eval_deductibles a
                    WHERE 1 = 1
                      AND eval_id = p_eval_id
                      AND payee_cd = p_payee_cd
                      AND payee_type_cd = p_payee_class_cd
                      AND EXISTS (
                             SELECT 1
                               FROM giis_loss_exp
                              WHERE (   line_cd = giisp.v ('LINE_CODE_MC')
                                     OR line_cd =
                                           (SELECT NVL (menu_line_cd, line_cd)
                                              FROM giis_line
                                             WHERE line_cd = p_line_cd)
                                    )
                                AND loss_exp_cd = a.ded_cd
                                AND UPPER (loss_exp_desc) =
                                                    'EXCESS OVER POLICY LIMIT'))
               LOOP
                  v_loa.eop := NVL (i.ded_amt, 0);
                  v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (i.ded_amt, 0);
               END LOOP;

               -- get depreciation
               FOR z IN (SELECT b.loss_exp_desc, a.ded_amt, a.ded_rt
                           FROM gicl_eval_dep_dtl a, giis_loss_exp b
                          WHERE 1 = 1
                            AND a.loss_exp_cd = b.loss_exp_cd
                            AND b.line_cd = 'MC'
                            AND b.loss_exp_type = 'L'
                            AND b.comp_sw = '+'
                            AND NVL (b.part_sw, 'N') = 'Y'
                            AND a.eval_id = p_eval_id
                            AND a.payee_type_cd = p_payee_class_cd
                            AND a.payee_cd = p_payee_cd)
               LOOP
                  v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (z.ded_amt, 0);

                  IF UPPER (z.loss_exp_desc) = 'BATTERY'
                  THEN
                     v_loa.battery :=
                                   NVL (v_loa.battery, 0)
                                   + NVL (z.ded_amt, 0);
                     v_loa.bat_rt := z.ded_rt;
                  ELSIF UPPER (z.loss_exp_desc) = 'TIRE'
                  THEN
                     v_loa.tire := NVL (v_loa.tire, 0) + NVL (z.ded_amt, 0);
                     v_loa.tire_rt := z.ded_rt;
                  ELSE
                     IF v_loa.dep_others = 0
                     THEN
                        v_loa.dep_others :=
                                NVL (v_loa.dep_others, 0)
                                + NVL (z.ded_amt, 0);
                        v_loa.other_rt := z.ded_rt;
                     ELSE
                        IF v_loa.other_rt = z.ded_rt
                        THEN
                           -- if same rate, add to dep others 1, else dep others 2
                           v_loa.dep_others :=
                                NVL (v_loa.dep_others, 0)
                                + NVL (z.ded_amt, 0);
                        ELSE
                           v_loa.dep_others2 :=
                               NVL (v_loa.dep_others2, 0)
                               + NVL (z.ded_amt, 0);
                           v_loa.other_rt2 := z.ded_rt;
                        END IF;
                     END IF;
                  END IF;
               END LOOP;

               -- get v_net_liability
               v_loa.net_liability := v_loa.repair_cost - v_loa.LESS;
            ELSE                       --if settlement was created in gicls030
               --get deductible
               FOR d IN
                  (SELECT SUM (ABS (ded_amt)) ded_amt
                     FROM gicl_loss_exp_ded_dtl a, giis_loss_exp b
                    WHERE a.loss_exp_cd <> giisp.v ('MC_DEPRECIATION_CD')
                      AND NOT EXISTS (
                             SELECT 1
                               FROM giis_loss_exp c
                              WHERE c.loss_exp_cd = a.loss_exp_cd
                                AND UPPER (loss_exp_desc) =
                                                    'EXCESS OVER POLICY LIMIT')
                      AND a.ded_cd = b.loss_exp_cd
                      AND claim_id = p_claim_id
                      AND clm_loss_id = p_clm_loss_id)
               LOOP
                  v_loa.deductible := NVL (d.ded_amt, 0);
                  v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (d.ded_amt, 0);
               END LOOP;

               FOR d IN (SELECT SUM (ABS (ded_amt)) ded_amt
                           FROM gicl_loss_exp_ded_dtl a, giis_loss_exp b
                          WHERE a.loss_exp_cd <>
                                                giisp.v ('MC_DEPRECIATION_CD')
                            AND EXISTS (
                                   SELECT 1
                                     FROM giis_loss_exp c
                                    WHERE c.loss_exp_cd = a.loss_exp_cd
                                      AND UPPER (loss_exp_desc) =
                                                    'EXCESS OVER POLICY LIMIT')
                            AND a.ded_cd = b.loss_exp_cd
                            AND claim_id = p_claim_id
                            AND clm_loss_id = p_clm_loss_id)
               LOOP
                  v_loa.eop := NVL (d.ded_amt, 0);
                  v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (d.ded_amt, 0);
               END LOOP;

               --get depreciation
               FOR dep IN (SELECT ABS (ded_amt) ded_amt,
                                  UPPER (loss_exp_desc) loss_exp_desc
                             FROM gicl_loss_exp_ded_dtl a, giis_loss_exp b
                            WHERE a.loss_exp_cd =
                                                giisp.v ('MC_DEPRECIATION_CD')
                              AND a.ded_cd = b.loss_exp_cd
                              AND claim_id = p_claim_id
                              AND clm_loss_id = p_clm_loss_id)
               LOOP
                  v_loa.LESS := NVL (v_loa.LESS, 0) + NVL (dep.ded_amt, 0);
                  v_loa.dep_total := v_loa.dep_total + NVL (dep.ded_amt, 0);

                  IF dep.loss_exp_desc = 'BATTERY'
                  THEN
                     v_loa.battery :=
                                 NVL (v_loa.battery, 0)
                                 + NVL (dep.ded_amt, 0);
                  ELSIF dep.loss_exp_desc = 'TIRE'
                  THEN
                     v_loa.tire := NVL (v_loa.tire, 0) + NVL (dep.ded_amt, 0);
                  ELSE
                     v_loa.dep_others2 :=
                             NVL (v_loa.dep_others2, 0)
                             + NVL (dep.ded_amt, 0);
                  END IF;
               END LOOP;

               --get dep rate
               FOR i IN (SELECT NVL (dtl_amt, 0) dtl_amt,
                                UPPER (loss_exp_desc) loss_exp_desc
                           FROM gicl_loss_exp_dtl a, giis_loss_exp b
                          WHERE claim_id = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND ded_loss_exp_cd IS NULL
                            AND a.loss_exp_cd = b.loss_exp_cd)
               LOOP
                  IF i.loss_exp_desc = 'BATTERY'
                  THEN
                     v_loa.bat_rt := (v_loa.battery / i.dtl_amt) * 100;
                  ELSIF i.loss_exp_desc = 'TIRE'
                  THEN
                     v_loa.tire_rt := (v_loa.tire / i.dtl_amt) * 100;
                  ELSE
                     v_loa.other_total := v_loa.other_total + i.dtl_amt;
                  END IF;
               END LOOP;

               -- added by Kris 03.26.2014: to handle division by zero
               SELECT DECODE(v_loa.other_total,0,1,v_loa.other_total)
                 INTO v_loa.other_total
                 FROM dual;
                 
               v_loa.other_rt2 :=
                                 (v_loa.dep_others2 / v_loa.other_total) * 100;

               -- get v_net_liability
               FOR i IN (SELECT paid_amt
                           FROM gicl_clm_loss_exp
                          WHERE claim_id = p_claim_id
                            AND clm_loss_id = p_clm_loss_id)
               LOOP
                  v_loa.net_liability := i.paid_amt;
               END LOOP;

               --net of parts supplied
               v_loa.repair_cost :=
                       NVL (v_loa.net_liability, 0)
                       + ABS (NVL (v_loa.LESS, 0));
            END IF;
         END IF;
      --END IF;  -- commented out by Kris 03.26.2014

      -- get prepared by
      SELECT user_name
        INTO v_loa.prepared
        FROM giis_users
       WHERE user_id = p_user_id;

      -- determine the signatory
      FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                    FROM giac_documents a,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND b.signatory_id = c.signatory_id
                     AND a.report_id = 'GICLR027'
                     AND a.branch_cd = p_iss_cd                      --IS NULL
                     AND a.line_cd = p_line_cd                       --IS NULL
                ORDER BY b.item_no ASC)
      LOOP
         v_loa.approved := z.signatory;
         EXIT;
      END LOOP;

      IF v_loa.approved IS NULL
      THEN
         FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GICLR027'
                        AND a.branch_cd = p_iss_cd
                        AND a.line_cd IS NULL
                   ORDER BY b.item_no ASC)
         LOOP
            v_loa.approved := z.signatory;
            EXIT;
         END LOOP;
      END IF;

      IF v_loa.approved IS NULL
      THEN
         FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GICLR027'
                        AND a.branch_cd IS NULL
                        AND a.line_cd = p_line_cd
                   ORDER BY b.item_no ASC)
         LOOP
            v_loa.approved := z.signatory;
            EXIT;
         END LOOP;
      END IF;

      IF v_loa.approved IS NULL
      THEN
         FOR z IN (SELECT   b.item_no, b.label, c.signatory, c.designation
                       FROM giac_documents a,
                            giac_rep_signatory b,
                            giis_signatory_names c
                      WHERE a.report_no = b.report_no
                        AND b.signatory_id = c.signatory_id
                        AND a.report_id = 'GICLR027'
                        AND a.branch_cd IS NULL
                        AND a.line_cd IS NULL
                   ORDER BY b.item_no ASC)
         LOOP
            v_loa.approved := z.signatory;
            EXIT;
         END LOOP;
      END IF;
	  PIPE ROW(V_loa);
   END;
END gicl_eval_loa_pkg;
/


