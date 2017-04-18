CREATE OR REPLACE PACKAGE BODY CPI.giclr277_pkg
AS
/* Formatted on 2013/05/21 16:57 (Formatter Plus v4.8.8) */
 
   FUNCTION cf_comp_nameformula
      RETURN VARCHAR2
   IS
      --V_NAME VARCHAR2(200);
      v_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_name);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
         RETURN (v_name);
      WHEN TOO_MANY_ROWS
      THEN
         v_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
         RETURN (v_name);
   END;

   FUNCTION cf_comp_addformula
      RETURN VARCHAR2
   IS
      --V_ADD VARCHAR2(350);
      v_add   giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_add
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_add);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_add := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
      WHEN TOO_MANY_ROWS
      THEN
         v_add := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
         RETURN (v_add);
   END;

   FUNCTION cf_los_resformula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE,
      p_peril_cd   gicl_clm_reserve.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_los_res   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (loss_reserve) loss_reserve
        INTO v_los_res
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no AND peril_cd = p_peril_cd;

      RETURN (NVL (v_los_res, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_exp_resformula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE,
      p_peril_cd   gicl_clm_reserve.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_res   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (expense_reserve) expense_reserve
        INTO v_exp_res
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no AND peril_cd = p_peril_cd;

      RETURN (NVL (v_exp_res, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_exp_paidformula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE,
      p_peril_cd   gicl_clm_reserve.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_paid   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (expenses_paid) expenses_paid
        INTO v_exp_paid
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no AND peril_cd = p_peril_cd;

      RETURN (NVL (v_exp_paid, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;

   FUNCTION cf_loss_paidformula (
      p_claim_id   gicl_clm_reserve.claim_id%TYPE,
      p_item_no    gicl_clm_reserve.item_no%TYPE,
      p_peril_cd   gicl_clm_reserve.peril_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_los_paid   gicl_clm_reserve.loss_reserve%TYPE;
   BEGIN
      SELECT SUM (losses_paid) expense_reserve
        INTO v_los_paid
        FROM gicl_clm_reserve
       WHERE claim_id = p_claim_id AND item_no = p_item_no AND peril_cd = p_peril_cd;

      RETURN (NVL (v_los_paid, 0));
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END;
   
   
   /* Formatted on 2013/05/24 15:30 (Formatter Plus v4.8.8) */
FUNCTION cf_itemformula(

        p_claim_id  gicl_clm_item.claim_id%TYPE,
        p_item_no   gicl_clm_item.item_no%TYPE

)
   RETURN CHAR
IS
   v_item   VARCHAR2 (775);
BEGIN
   FOR x IN (SELECT DECODE (item_no, NULL, NULL, item_title) item_title
               FROM gicl_clm_item
              WHERE claim_id = p_claim_id AND item_no = p_item_no)
   LOOP
      v_item := x.item_title;
   END LOOP;

   RETURN (v_item);
END;


/* Formatted on 2013/05/24 15:34 (Formatter Plus v4.8.8) */
FUNCTION cf_itemnoformula(

        p_item_no       gicl_clm_item.item_no%TYPE,
        p_cf_item       VARCHAR2

)
   RETURN CHAR
IS
   v_itemno   VARCHAR2 (775);
BEGIN
   SELECT LTRIM (DECODE (p_cf_item,
                         NULL, TO_CHAR (p_item_no, '000009'),
                         TO_CHAR (p_item_no, '000009') || ' - '
                        )
                )
     INTO v_itemno
     FROM DUAL;

   RETURN (v_itemno);
END;

/* Formatted on 2013/05/24 16:40 (Formatter Plus v4.8.8) */
FUNCTION cf_perilformula(

        p_line_cd       giis_peril.line_cd%TYPE,
        p_peril_cd      giis_peril.peril_cd%TYPE

)
   RETURN CHAR
IS
   v_peril   giis_peril.peril_name%TYPE;
BEGIN
   FOR p IN (SELECT peril_name
               FROM giis_peril
              WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd)
   LOOP
      v_peril := p.peril_name;
      EXIT;
   END LOOP;

   RETURN (v_peril);
END;

/* Formatted on 2013/05/24 16:42 (Formatter Plus v4.8.8) */
FUNCTION cf_peril_cdformula(

        p_peril_cd       gicl_clm_item.item_no%TYPE,
        p_cf_peril       VARCHAR2

)
   RETURN CHAR
IS
   v_peril_cd   VARCHAR2 (775);
BEGIN
   SELECT LTRIM (DECODE (p_cf_peril,
                         NULL, TO_CHAR (p_peril_cd, '00009'),
                         TO_CHAR (p_peril_cd, '00009') || ' - '
                        )
                )
     INTO v_peril_cd
     FROM DUAL;

   RETURN (v_peril_cd);
END;
/* Formatted on 2013/05/24 15:15 (Formatter Plus v4.8.8) */
   FUNCTION beforereport (
      p_payee_class_cd   VARCHAR2,
      p_payee_no         NUMBER,
      p_tp_type          VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_from_ldate       VARCHAR2,
      p_to_ldate         VARCHAR2,
      p_as_of_ldate      VARCHAR2
   )
      RETURN VARCHAR2
   IS
      cp_datetype   VARCHAR2 (100);
   BEGIN
      IF p_as_of_date IS NOT NULL
      THEN
         cp_datetype :=
               'Claim File Date As of '
            || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-RRRR'),
                        'fmMonth DD, RRRR'
                       );
      ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL
      THEN
         cp_datetype :=
               'Claim File Date From '
            || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-RRRR'),
                        'fmMonth DD, RRRR'
                       )
            || ' To '
            || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-RRRR'), 'fmMonth DD, RRRR');
      ELSIF p_as_of_ldate IS NOT NULL
      THEN
         cp_datetype :=
               'Loss Date As of '
            || TO_CHAR (TO_DATE (p_as_of_ldate, 'MM-DD-RRRR'),
                        'fmMonth DD, RRRR'
                       );
      ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL
      THEN
         cp_datetype :=
               'Loss Date From '
            || TO_CHAR (TO_DATE (p_from_ldate, 'MM-DD-RRRR'),
                        'fmMonth DD, RRRR'
                       )
            || ' To '
            || TO_CHAR (TO_DATE (p_to_ldate, 'MM-DD-RRRR'),
                        'fmMonth DD, RRRR');
      ELSIF p_as_of_date IS NULL AND p_from_date IS NULL AND p_to_date IS NULL
      THEN
         cp_datetype := ' ';
      --p_as_of_date := SYSDATE;
      ELSIF     p_as_of_ldate IS NULL
            AND p_from_ldate IS NULL
            AND p_to_ldate IS NULL
      THEN
         cp_datetype := ' ';
      --p_as_of_ldate := SYSDATE;
      END IF;

      RETURN (cp_datetype);
   END;


/* Formatted on 2013/05/23 13:36 (Formatter Plus v4.8.8) */
/* Formatted on 2013/05/23 13:51 (Formatter Plus v4.8.8) */
FUNCTION cf_nameformula(
      p_payee_class_cd    giis_payees.payee_class_cd%TYPE,
      p_payee_no          giis_payees.payee_no%TYPE
)
   RETURN CHAR
IS
   v_name   VARCHAR2 (775);
BEGIN
   FOR x IN (SELECT    payee_last_name
                    || ', '
                    || payee_first_name
                    || ' '
                    || payee_middle_name payee
               FROM giis_payees
              WHERE payee_class_cd = p_payee_class_cd AND payee_no = p_payee_no)
   LOOP
      v_name := x.payee;
   END LOOP;

   RETURN (v_name);
END;
   FUNCTION populate_giclr277(
   
      P_PAYEE_CLASS_CD   VARCHAR2,
      P_PAYEE_NO         NUMBER,
      P_TP_TYPE          VARCHAR2,
      P_FROM_DATE        VARCHAR2,
      P_TO_DATE          VARCHAR2,
      P_AS_OF_DATE       VARCHAR2,
      P_FROM_LDATE       VARCHAR2,
      P_TO_LDATE         VARCHAR2,
      P_AS_OF_LDATE      VARCHAR2
   )
   
   
      RETURN giclr277_tab PIPELINED
   AS
      v_rec   giclr277_type;
   BEGIN
      v_rec.company_name := cf_comp_nameformula;
      v_rec.company_address := cf_comp_addformula;
      v_rec.cp_datetype := beforereport(P_PAYEE_CLASS_CD,
                                        P_PAYEE_NO, 
                                        P_TP_TYPE,
                                        P_FROM_DATE,
                                        P_TO_DATE,
                                        P_AS_OF_DATE,
                                        P_FROM_LDATE,
                                        P_TO_LDATE,
                                        P_AS_OF_LDATE);
      PIPE ROW (v_rec);
      RETURN;
   END populate_giclr277;

   FUNCTION populate_giclr277_details (
 
      p_payee_class_cd   VARCHAR2,
      p_payee_no         NUMBER,
      p_tp_type          VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2,
      p_as_of_date       VARCHAR2,
      p_from_ldate       VARCHAR2,
      p_to_ldate         VARCHAR2,
      p_as_of_ldate      VARCHAR2
   )
      RETURN giclr277_details_tab PIPELINED
   AS
      v_rec   giclr277_details_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.claim_id, a.payee_class_cd, a.payee_no,
                          DECODE (a.tp_type,
                                  'T', 'Third Party',
                                  'A', 'Adverse Party',
                                  'B', 'Bodily Injured',
                                  'Property Damage'
                                 ) tp_type,
                             b.line_cd
                          || '-'
                          || b.subline_cd
                          || '-'
                          || b.iss_cd
                          || '-'
                          || LPAD (b.clm_yy, 2, '0')
                          || '-'
                          || LPAD (clm_seq_no, 7, '0') claim_no,
                             b.line_cd
                          || '-'
                          || b.subline_cd
                          || '-'
                          || b.pol_iss_cd
                          || '-'
                          || LPAD (b.issue_yy, 2, '0')
                          || '-'
                          || LPAD (pol_seq_no, 7, '0')
                          || '-'
                          || LPAD (renew_no, 2, '0') policy_no,
                          b.assured_name, b.dsp_loss_date, b.clm_file_date,
                          b.line_cd, c.item_no, c.peril_cd
                     FROM gicl_mc_tp_dtl a,
                          gicl_claims b,
                          gicl_clm_res_hist c
                    WHERE     a.claim_id = b.claim_id
                          AND b.claim_id = c.claim_id(+)
                          AND a.payee_class_cd = p_payee_class_cd
                          AND a.payee_no = p_payee_no                          
                          AND a.tp_type = p_tp_type                          
                          AND b.claim_id IN (
                                 SELECT claim_id
                                   FROM gicl_claims
                                  WHERE check_user_per_line(line_cd,
                                                             iss_cd,
                                                             'GICLS277'
                                                            ) = 1)                                                                                                                                                                                    
                          AND b.clm_stat_cd NOT IN ('DN', 'WD', 'CC')
                          AND  ((       TRUNC (b.clm_file_date) >= TRUNC(TO_DATE (p_from_date, 'MM-DD-RRRR'))
                                        AND TRUNC (b.clm_file_date) <= TRUNC(TO_DATE (p_to_date, 'MM-DD-RRRR'))
                                        OR TRUNC (b.clm_file_date) <= TRUNC(TO_DATE (p_as_of_date, 'MM-DD-RRRR'))
                                        )
                                OR     (TRUNC (b.loss_date) >= TRUNC(TO_DATE (p_from_ldate, 'MM-DD-RRRR')))
                                AND TRUNC (b.loss_date) <= TRUNC(TO_DATE (p_to_ldate, 'MM-DD-RRRR'))
                                OR TRUNC (b.loss_date) <= TRUNC(TO_DATE (p_as_of_ldate, 'MM-DD-RRRR'))
                                ))
      LOOP
         v_rec.claim_id := i.claim_id;
         v_rec.claim_no := i.claim_no;
         v_rec.policy_no := i.policy_no;
         v_rec.tp_type := i.tp_type;
         v_rec.assured_name := i.assured_name;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.peril_cd := i.peril_cd;
         v_rec.loss_reserve :=
                        cf_los_resformula (i.claim_id, i.item_no, i.peril_cd);
         v_rec.losses_paid :=
                      cf_loss_paidformula (i.claim_id, i.item_no, i.peril_cd);
         v_rec.expense_reserve :=
                        cf_exp_resformula (i.claim_id, i.item_no, i.peril_cd);
         v_rec.expense_paid :=
                       cf_exp_paidformula (i.claim_id, i.item_no, i.peril_cd);
         v_rec.v_name := cf_nameformula (i.payee_class_cd, i.payee_no);
         v_rec.v_item := cf_itemformula(i.claim_id, i.item_no);
         v_rec.v_itemno := cf_itemnoformula(i.item_no,v_rec.v_item);
         v_rec.v_peril := cf_perilformula(i.line_cd, i.peril_cd);
         v_rec.v_peril_cd := cf_peril_cdformula(i.peril_cd, v_rec.v_peril);
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
END giclr277_pkg;
/


