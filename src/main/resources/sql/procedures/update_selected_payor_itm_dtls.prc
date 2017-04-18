DROP PROCEDURE CPI.UPDATE_SELECTED_PAYOR_ITM_DTLS;

CREATE OR REPLACE PROCEDURE CPI.update_selected_payor_itm_dtls (
   p_iss_cd                  gipi_polbasic.iss_cd%TYPE,
   p_prem_seq_no             gipi_invoice.prem_seq_no%TYPE,
   p_line_cd                 gipi_polbasic.line_cd%TYPE,
   p_tran_id                 giac_order_of_payts.gacc_tran_id%TYPE,
   p_policy_id               gipi_polbasic.policy_id%TYPE,
   p_intm_no_add             VARCHAR2,
   p_mail_add                VARCHAR2,
   p_particulars_add         VARCHAR2,
   p_payor_add               VARCHAR2,
   p_payor_btn               VARCHAR2,
   p_msg               OUT   VARCHAR2
)
IS
   v_intm_no          NUMBER;
   v_share            NUMBER;
   temp_intm_no       NUMBER;
   temp_share         NUMBER;
   temp_intm_no_k     NUMBER;
   ok_intm_no         NUMBER;
   ok_share           NUMBER;
   c2_intm_no         NUMBER;
   c2_share           NUMBER;
   v_add1             VARCHAR2 (50);
   v_add2             VARCHAR2 (50);
   v_add3             VARCHAR2 (50);
   v_policy_id        NUMBER;
   --V_NAME VARCHAR2(300);
   v_name             giac_order_of_payts.particulars%TYPE;
   rec_intm_no        NUMBER;
   v_last_rec_no      NUMBER;
   ctr                NUMBER                                 := 1;
   a_intm_no          VARCHAR2 (50); --NUMBER;
   a_mail             VARCHAR2 (200);
   a_particulars      VARCHAR2 (500);
   a_gacc_tran_id     NUMBER;
   v_line_cd          gipi_polbasic.line_cd%TYPE;
   v_subline_cd       gipi_polbasic.subline_cd%TYPE;
   v_iss_cd           gipi_polbasic.iss_cd%TYPE;
   v_issue_yy         gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no         gipi_polbasic.renew_no%TYPE;
   v_payor            giac_order_of_payts.payor%TYPE;
   ok_intm_no2        NUMBER;
   c2_policy_id       gipi_comm_invoice.policy_id%TYPE;
   temp_policy_id     gipi_comm_invoice.policy_id%TYPE;
   temp_policy_id_k   gipi_comm_invoice.policy_id%TYPE;
   ok_policy_id       gipi_comm_invoice.policy_id%TYPE;
   
   --added by robert
   v_assd_no          gipi_polbasic.assd_no%TYPE;
   v_assd_name        giac_order_of_payts.payor%TYPE;
   v_assd_name2       giac_order_of_payts.payor%TYPE;
BEGIN
   temp_intm_no := 0;
   temp_share := 0;
   temp_intm_no_k := 999999999;

   FOR c2 IN (SELECT intrmdry_intm_no, share_percentage, policy_id
                FROM gipi_comm_invoice
               WHERE prem_seq_no = p_prem_seq_no AND iss_cd = p_iss_cd)
   LOOP
      v_intm_no := c2.intrmdry_intm_no;
      v_share := c2.share_percentage;
      v_policy_id := c2.policy_id;

      IF v_share > temp_share
      THEN
         temp_intm_no := v_intm_no;
         temp_share := v_share;
         temp_policy_id := v_policy_id;
      ELSE
         IF - (v_intm_no) > - (temp_intm_no)
         THEN
            temp_intm_no := v_intm_no;
            temp_share := v_share;
            temp_policy_id := v_policy_id;
         END IF;
      END IF;

      c2_intm_no := temp_intm_no;
      c2_share := temp_share;
      c2_policy_id := temp_policy_id;
   END LOOP;

   IF - (c2_intm_no) > - (temp_intm_no_k)
   THEN
      temp_intm_no_k := c2_intm_no;
      temp_policy_id_k := c2_policy_id;
   END IF;

   ctr := ctr + 1;
   ok_intm_no := temp_intm_no_k;
   ok_intm_no2 := temp_intm_no_k;
   ok_policy_id := temp_policy_id_k;

 --  END LOOP;
/* NULLS THE INTM TO BE UPDATED, NOT ABOVE COZ POLICY ID IS NEEDED*/
   IF p_intm_no_add = 'ADD_INTM'
   THEN
      ok_intm_no := ok_intm_no;
   ELSE
      ok_intm_no := NULL;
   END IF;

/*CHECKS IF ADDRESS IS STILL NEEDED*/
   IF p_mail_add = 'ADD_MAIL'
   THEN
      FOR c3 IN (SELECT address1 add1, address2 add2, address3 add3
                   FROM gipi_polbasic
                  WHERE policy_id = v_policy_id)
      LOOP
         v_add1 := c3.add1;
         v_add2 := c3.add2;
         v_add3 := c3.add3;
      END LOOP;
   END IF;

/*CHECKS IF PARTICULARS WILL BE ADDED*/
   IF p_particulars_add = 'ADD_PART'
   THEN
      IF giacp.v ('SU_PARTICULARS') = 'Y' AND p_line_cd = 'SU'
      THEN
         --v_name := 'GET_SU_PARTICULARS'; robert 08.30.2012
         --v_name := GET_SU_PARTICULARS(p_tran_id); 
         v_name := GET_SU_PARTICULARS(p_tran_id, p_iss_cd, p_prem_seq_no); --marco - 09.12.2014
      ELSE
         --v_name := 'GET_PARTICULARS'; robert 08.30.2012
         --v_name := GET_PARTICULARS(p_tran_id);
         v_name := GET_PARTICULARS(p_tran_id, p_iss_cd, p_prem_seq_no); --marco - 09.12.2014
      END IF;
   END IF;

/* if payor will be updated or not */
   SELECT payor
     INTO v_payor
     FROM giac_order_of_payts
    WHERE gacc_tran_id = p_tran_id;

   IF v_payor = '-'
   THEN
      IF p_payor_add = 'ADD_PAYOR'
      THEN
         IF p_payor_btn = 'A'
         THEN
--            SELECT insured
--              INTO v_payor
--              FROM gipi_invoice
--             WHERE policy_id = ok_policy_id;
             SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                    renew_no
               INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
                    v_renew_no
               FROM gipi_polbasic
              WHERE policy_id = ok_policy_id;

             v_assd_no :=
                get_latest_assured_no2 (v_line_cd,
                                        v_subline_cd,
                                        v_iss_cd,
                                        v_issue_yy,
                                        v_pol_seq_no,
                                        v_renew_no
                                       );

             FOR c IN (SELECT assd_name, assd_name2
                         FROM giis_assured
                        WHERE assd_no = v_assd_no)
             LOOP
                v_assd_name := c.assd_name;
                v_assd_name2 := c.assd_name2;

                IF v_assd_name2 IS NOT NULL
                THEN
                   v_payor := v_assd_name || v_assd_name2;
                ELSE
                   v_payor := v_assd_name;
                END IF;
             END LOOP;
         ELSE
            SELECT intm_name
              INTO v_payor
              FROM giis_intermediary
             WHERE intm_no = ok_intm_no2;
         END IF;
      END IF;
   END IF;

/* UPDATE THE RECORD IN GIAC_ORDER_OF_PAYTS*/
   FOR a IN (SELECT gacc_tran_id, payor, particulars
               FROM giac_order_of_payts
              WHERE gacc_tran_id = p_tran_id)
   LOOP
      UPDATE giac_order_of_payts
         SET address_1 = NVL (v_add1, address_1),
             address_2 = NVL (v_add2, address_2),
             address_3 = NVL (v_add3, address_3),
             intm_no = NVL (ok_intm_no, intm_no),
             particulars = NVL (v_name, particulars),
             payor = v_payor
       WHERE gacc_tran_id = a.gacc_tran_id;
   END LOOP;

   COMMIT;

   SELECT gacc_tran_id, to_char(intm_no), /*PARTICULARS,*/
          address_1 || ' ' || address_2 || ' ' || address_3 mail_add
     INTO a_gacc_tran_id, a_intm_no, /*A_PARTICULARS,*/
          a_mail
     FROM giac_order_of_payts
    WHERE gacc_tran_id = p_tran_id;

   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
          renew_no
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
          v_renew_no
     FROM gipi_polbasic
    WHERE policy_id = p_policy_id;
    
    --added by robert
     IF a_mail != '  ' then
        a_mail := ', ' || a_mail;
     END IF;
     
     IF a_intm_no is not null then
        a_intm_no := ', ' || a_intm_no;
     END IF;
     
   p_msg :=
      (   'Transaction No. '
       || TO_CHAR (a_gacc_tran_id)
       || ' was updated to '
       || /*A_PARTICULARS*/ v_line_cd
       || '-'
       || v_subline_cd
       || '-'
       || v_iss_cd
       || '-'
       || LPAD (v_issue_yy, 2, '0')
       || '-'
       || LPAD (v_pol_seq_no, 7, '0')
       || '-'
       || LPAD (v_renew_no, 2, '0')
--       || ', '
       || a_mail
--       || ', '
       || (a_intm_no)
      );
END;
/


