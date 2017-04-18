DROP PROCEDURE CPI.UPDATE_ALL_PAYOR_ITM_DTLS;

CREATE OR REPLACE PROCEDURE CPI.update_all_payor_itm_dtls (
   p_iss_cd              gipi_polbasic.iss_cd%TYPE,
   p_prem_seq_no         gipi_invoice.prem_seq_no%TYPE,
   p_line_cd             gipi_polbasic.line_cd%TYPE,
   p_tran_id             giac_order_of_payts.gacc_tran_id%TYPE,
   p_policy_id           gipi_polbasic.policy_id%TYPE,
   p_payor_btn           VARCHAR2--,
  -- p_msg             OUT     VARCHAR2
) 
IS
   v_intm_no          giac_order_of_payts.intm_no%TYPE;
   v_share            gipi_comm_invoice.share_percentage%TYPE;
   temp_intm_no       giac_order_of_payts.intm_no%TYPE := 0;
   temp_share         gipi_comm_invoice.share_percentage%TYPE := 0;
   temp_intm_no_k     giac_order_of_payts.intm_no%TYPE;
   ok_intm_no         giac_order_of_payts.intm_no%TYPE;
   ok_share           gipi_comm_invoice.share_percentage%TYPE;
   c2_intm_no         giac_order_of_payts.intm_no%TYPE;
   c2_share           gipi_comm_invoice.share_percentage%TYPE;
   v_add1             giac_order_of_payts.address_1%TYPE;
   v_add2             giac_order_of_payts.address_2%TYPE;
   v_add3             giac_order_of_payts.address_3%TYPE;
   v_policy_id        gipi_comm_invoice.policy_id%TYPE;
   v_name             giac_order_of_payts.particulars%TYPE;
   rec_intm_no        giac_order_of_payts.intm_no%TYPE;
   v_last_rec_no      NUMBER;
   ctr                NUMBER                                    := 1;
   a_intm_no          giac_order_of_payts.intm_no%TYPE;
   a_particulars      giac_order_of_payts.particulars%TYPE;
   a_mail             VARCHAR2 (200);
   a_gacc_tran_id     NUMBER;
   v_line_cd          gipi_polbasic.line_cd%TYPE;
   v_subline_cd       gipi_polbasic.subline_cd%TYPE;
   v_iss_cd           gipi_polbasic.iss_cd%TYPE;
   v_issue_yy         gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no         gipi_polbasic.renew_no%TYPE;
   v_payor            giac_order_of_payts.payor%TYPE;
   c2_policy_id       gipi_comm_invoice.policy_id%TYPE;
   temp_policy_id     gipi_comm_invoice.policy_id%TYPE;
   temp_policy_id_k   gipi_comm_invoice.policy_id%TYPE;
   ok_policy_id       gipi_comm_invoice.policy_id%TYPE;
   v_assd_no          gipi_polbasic.assd_no%TYPE;
   v_assd_name        giac_order_of_payts.payor%TYPE;
   v_assd_name2       giac_order_of_payts.payor%TYPE;
   v_tin              giac_order_of_payts.tin%TYPE;
BEGIN

   FOR c2 IN (SELECT i.intrmdry_intm_no, i.share_percentage, i.policy_id
                FROM (SELECT intrmdry_intm_no, share_percentage, policy_id
                        FROM gipi_comm_invoice
                       WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no
                      UNION
                      -- get the intm_no of the endt's mother policy, for endt of tax
                      SELECT c.intrmdry_intm_no, c.share_percentage,
                             b.policy_id
                        FROM gipi_polbasic a,
                             gipi_polbasic b,
                             gipi_comm_invoice c
                       WHERE b.policy_id = c.policy_id
                         AND a.line_cd = b.line_cd
                         AND a.subline_cd = b.subline_cd
                         AND a.iss_cd = b.iss_cd
                         AND a.issue_yy = b.issue_yy
                         AND a.pol_seq_no = b.pol_seq_no
                         AND a.renew_no = b.renew_no
                         AND a.endt_seq_no <> 0
                         AND b.endt_seq_no = 0
                         AND a.policy_id IN (
                                SELECT policy_id
                                  FROM gipi_invoice
                                 WHERE iss_cd = p_iss_cd
                                   AND prem_seq_no = p_prem_seq_no)) i)
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

      --C2_INTM_NO := TEMP_INTM_NO;
      c2_intm_no := NVL (temp_intm_no, v_intm_no);
      c2_share := temp_share;
      c2_policy_id := temp_policy_id;
   END LOOP;                                                 -- end of loop C2

   /*THIS GETS THE LEAST INTM_NO*/   --this also gets the policy_id of the record w/ the least intm_no
   IF - (c2_intm_no) > - (temp_intm_no_k)
   THEN
      temp_intm_no_k := c2_intm_no;
      temp_policy_id_k := c2_policy_id;
   END IF;

   ctr := ctr + 1;
   --OK_INTM_NO := TEMP_INTM_NO_K;
   ok_intm_no := NVL (temp_intm_no_k, c2_intm_no);
   --OK_POLICY_ID := TEMP_POLICY_ID_K;
   ok_policy_id := NVL (temp_policy_id_k, c2_policy_id);

   --END LOOP; -- end of loop K
   <<address>>
   FOR c3 IN (SELECT   address1 add1, address2 add2, address3 add3
                  FROM gipi_polbasic
                 WHERE (line_cd,
                        subline_cd,
                        iss_cd,
                        issue_yy,
                        pol_seq_no,
                        renew_no
                       ) =
                          (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                                  pol_seq_no, renew_no
                             FROM gipi_polbasic
                            WHERE policy_id = v_policy_id)
                   AND address1 IS NOT NULL
              ORDER BY endt_seq_no DESC)
   LOOP
      IF NVL (LENGTH (c3.add1), 0) > 1
      THEN
         v_add1 := c3.add1;
         v_add2 := c3.add2;
         v_add3 := c3.add3;
         EXIT address;
      END IF;
   END LOOP address;                                         -- end of loop C3

   IF giacp.v ('SU_PARTICULARS') = 'Y' AND p_line_cd = 'SU'
   THEN
      --v_name := 'GET_SU_PARTICULARS'; robert 08.30.2012
      --v_name := GET_SU_PARTICULARS(p_tran_id);
      v_name := GET_SU_PARTICULARS(p_tran_id, p_iss_cd, p_prem_seq_no); --marco - 09.12.2014
   ELSE
      --v_name := GET_PARTICULARS(p_tran_id);
      v_name := GET_PARTICULARS(p_tran_id, p_iss_cd, p_prem_seq_no); --09.12.2014
   END IF;

--if payor = '-', it will be updated else it will remain the same
   SELECT payor
     INTO v_payor
     FROM giac_order_of_payts
    WHERE gacc_tran_id = p_tran_id;

   IF v_payor = '-'
   THEN
      IF p_payor_btn = 'A'
      THEN
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
         --modified by robert
         BEGIN
             SELECT assd_tin
               INTO v_tin
               FROM giis_assured
              WHERE assd_no = (SELECT assd_no
                                 FROM gipi_polbasic
                                WHERE policy_id = p_policy_id);
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_tin := NULL;
          END;
      ELSE
--         SELECT intm_name
--           INTO v_payor
--           FROM giis_intermediary
--          WHERE intm_no = ok_intm_no;
--modified by robert
        SELECT intm_name, tin, mail_addr1, mail_addr2, mail_addr3
          INTO v_payor, v_tin, v_add1, v_add2, v_add3
          FROM giis_intermediary
         WHERE intm_no = ok_intm_no;
      END IF;

--modified by robert
--      BEGIN
--         SELECT assd_tin
--           INTO v_tin
--           FROM giis_assured
--          WHERE assd_no = (SELECT assd_no
--                             FROM gipi_polbasic
--                            WHERE policy_id = p_policy_id);
--      EXCEPTION
--         WHEN NO_DATA_FOUND
--         THEN
--            v_tin := NULL;
--      END;
   --end r
   END IF;

    ---
   /* UPDATE THE RECORD IN GIAC_ORDER_OF_PAYTS*/
   FOR a IN (SELECT gacc_tran_id, payor, particulars
               FROM giac_order_of_payts
              WHERE gacc_tran_id = p_tran_id)
   LOOP
      UPDATE giac_order_of_payts
         SET address_1 = NVL (v_add1, NULL),
             address_2 = NVL (v_add2, NULL),
             address_3 = NVL (v_add3, NULL),
             intm_no = NVL (ok_intm_no, intm_no),
             particulars = NVL (v_name, particulars),
             payor = v_payor,
             tin = v_tin
       WHERE gacc_tran_id = a.gacc_tran_id;
   END LOOP;                                                  -- end of loop A                                           
END;
/


