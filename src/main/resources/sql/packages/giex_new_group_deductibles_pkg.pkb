CREATE OR REPLACE PACKAGE BODY CPI.giex_new_group_deductibles_pkg
AS

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 03.14.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves DEDUCTIBLES data block
    */
    FUNCTION populate_deductibles (p_policy_id   giex_new_group_tax.policy_id%TYPE)
    RETURN new_group_deductibles_tab PIPELINED
    IS
        v_tab       new_group_deductibles_type;
        v_line_cd 	 gipi_polbasic.line_cd%TYPE;
        v_subline_cd gipi_polbasic.subline_cd%TYPE;
        v_iss_cd 	 gipi_polbasic.iss_cd%TYPE;
        v_issue_yy 	 gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no 	 gipi_polbasic.renew_no%TYPE;
        v_currency   giex_itmperil.currency_rt%TYPE; --added by joanne 06.05.14
    BEGIN
     SELECT line_cd,subline_cd,iss_cd,issue_yy, pol_seq_no, renew_no
       INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
       FROM gipi_polbasic
      WHERE policy_id = p_policy_id;

      --added by joanne 06.05.2014, deductible should be displayed into policy currency
      FOR x IN (SELECT DISTINCT currency_rt
            FROM giex_itmperil
            WHERE policy_id = p_policy_id
            order by currency_rt desc)
      LOOP
        v_currency := x.currency_rt;
      END LOOP;

      FOR i IN (SELECT DISTINCT  gogd.policy_id    ,gogd.line_cd       ,gogd.subline_cd
                                ,gogd.item_no      ,gogd.peril_cd      ,decode(gogd.peril_cd, 0, null, peril_name) peril_name
                                ,ded_deductible_cd ,gogd.deductible_rt ,gogd.deductible_amt
                                ,deductible_text   ,gdd.ded_type, gdd.deductible_title
                FROM (SELECT * FROM giex_new_group_deductibles
                       UNION
                      SELECT * FROM giex_old_group_deductibles
                        WHERE NOT EXISTS (SELECT DISTINCT 1
                                            FROM giex_new_group_deductibles
                                           WHERE policy_id = p_policy_id)
                          AND policy_id = p_policy_id) gogd
                      ,giis_deductible_desc gdd
                      ,giis_peril gp
               WHERE gdd.line_cd       = gogd.line_cd
                 AND gdd.subline_cd    = gogd.subline_cd
                 AND gdd.deductible_cd = gogd.ded_deductible_cd
                 AND gp.line_cd        = gdd.line_cd
                 AND (gp.peril_cd      = gogd.peril_cd OR
                      gogd.peril_cd    = 0)
                 AND gogd.policy_id    = p_policy_id)
        LOOP
            v_tab.policy_id         := i.policy_id;
            v_tab.line_cd           := i.line_cd;
            v_tab.subline_cd        := i.subline_cd;
            v_tab.item_no           := i.item_no;
            v_tab.peril_cd          := i.peril_cd;
            v_tab.dsp_peril_name    := i.peril_name;
            v_tab.ded_deductible_cd := i.ded_deductible_cd;
            v_tab.deductible_rt     := i.deductible_rt;
            v_tab.deductible_amt    := ROUND(i.deductible_amt/v_currency,2); --modified by joanne 06.05.14
            v_tab.deductible_local_amt    := i.deductible_amt; --added by joanne 06.05.14
            v_tab.deductible_text   := i.deductible_text;
            v_tab.ded_type          := i.ded_type;
            v_tab.deductible_title  := i.deductible_title; -- added by andrew - 12.10.2012
            v_tab.item_title        := giex_itmperil_pkg.get_latest_item_title(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no, i.item_no);

            PIPE ROW (v_tab);
        END LOOP;
    END populate_deductibles;

    PROCEDURE set_deductibles_dtls (
        p_policy_id             giex_new_group_deductibles.policy_id%TYPE,
        p_item_no               giex_new_group_deductibles.item_no%TYPE,
        p_peril_cd              giex_new_group_deductibles.peril_cd%TYPE,
        p_ded_deductible_cd     giex_new_group_deductibles.ded_deductible_cd%TYPE,
        p_line_cd               giex_new_group_deductibles.line_cd%TYPE,
        p_subline_cd            giex_new_group_deductibles.subline_cd%TYPE,
        p_deductible_rt         giex_new_group_deductibles.deductible_rt%TYPE,
        p_deductible_amt        giex_new_group_deductibles.deductible_amt%TYPE
    )
    IS
    BEGIN
        MERGE INTO giex_new_group_deductibles
        USING dual ON (policy_id            = p_policy_id    AND
                       item_no              = p_item_no      AND
                       peril_cd             = p_peril_cd     AND
                       ded_deductible_cd    = p_ded_deductible_cd)
         WHEN NOT MATCHED THEN
            INSERT (
                policy_id,      item_no,            peril_cd,           ded_deductible_cd,
                line_cd,        subline_cd,         deductible_rt,      deductible_amt
            )
            VALUES (
                p_policy_id,    p_item_no,          p_peril_cd,         p_ded_deductible_cd,
                p_line_cd,      p_subline_cd,       p_deductible_rt,    p_deductible_amt
            )
            WHEN MATCHED THEN
            UPDATE SET  line_cd             = p_line_cd,
                        subline_cd          = p_subline_cd,
                        deductible_rt       = p_deductible_rt,
                        deductible_amt      = p_deductible_amt;
    END set_deductibles_dtls;


        /*
    **  Created by       : Andrew Robes
    **  Date Created     : 01.11.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Insert record to giex_new_group_deductibles from giex_old_group_deductibles
    */
    PROCEDURE ins_new_group_deductibles(p_policy_id giex_new_group_deductibles.policy_id%TYPE)
    AS
      v_count NUMBER;
    BEGIN
      SELECT COUNT(*)
        INTO v_count
        FROM giex_new_group_deductibles
       WHERE policy_id = p_policy_id;

      IF v_count = 0 THEN
        INSERT
          INTO GIEX_NEW_GROUP_DEDUCTIBLES
        SELECT *
          FROM GIEX_OLD_GROUP_DEDUCTIBLES
         WHERE policy_id = p_policy_id;
      END IF;
    END;

        /*
    **  Created by       : Andrew Robes
    **  Date Created     : 01.11.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : validates if the deductible to be added already exists
    */
    FUNCTION val_if_deductible_exists(
      p_policy_id             giex_new_group_deductibles.policy_id%TYPE,
      p_item_no               giex_new_group_deductibles.item_no%TYPE,
      p_peril_cd              giex_new_group_deductibles.peril_cd%TYPE,
      p_ded_deductible_cd     giex_new_group_deductibles.ded_deductible_cd%TYPE)
    RETURN NUMBER
    AS
      v_count NUMBER;
      v_count_result NUMBER;
    BEGIN
      SELECT COUNT(*)
        INTO v_count
        FROM giex_new_group_deductibles
       WHERE policy_id = p_policy_id;

      IF v_count = 0 THEN
        SELECT COUNT(*)
          INTO v_count_result
		  FROM GIEX_NEW_GROUP_DEDUCTIBLES
		 WHERE policy_id = p_policy_id
		   AND item_no = p_item_no
		   AND peril_cd = p_peril_cd
		   AND ded_deductible_cd = p_ded_deductible_cd;
      ELSE
        SELECT COUNT(*)
          INTO v_count_result
		  FROM GIEX_OLD_GROUP_DEDUCTIBLES
		 WHERE policy_id = p_policy_id
		   AND item_no = p_item_no
		   AND peril_cd = p_peril_cd
		   AND ded_deductible_cd = p_ded_deductible_cd;
      END IF;

      RETURN v_count_result;
    END;

    /*Added by Joanne, 112513, delete ded in table giex_new_group_deductibles*/
    PROCEDURE delete_deductibles (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE,
       p_item_no     giex_new_group_deductibles.item_no%TYPE,
       p_peril_cd    giex_new_group_deductibles.peril_cd%TYPE
    )
    AS
       v_count   NUMBER;
    BEGIN
       SELECT COUNT (*)
         INTO v_count
         FROM giex_itmperil
        WHERE policy_id = p_policy_id
         AND item_no = p_item_no;

       IF v_count = 0
       THEN
          DELETE giex_new_group_deductibles
                WHERE policy_id = p_policy_id
                  AND item_no = p_item_no;
       ELSE
          DELETE giex_new_group_deductibles
                WHERE policy_id = p_policy_id
                  AND item_no = p_item_no
                  AND peril_cd = p_peril_cd;
       END IF;
    END;

   /*Added by Joanne
   **Date: 041514
   **Desc: To recompute and update % TSI deductibles during save*/
   PROCEDURE update_deductibles (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE
   )
   AS
       v_tsi_amt          giex_itmperil.tsi_amt%TYPE;
       v_itm_tsi_amt      giex_itmperil.tsi_amt%TYPE;
       v_perl_tsi_amt     giex_itmperil.tsi_amt%TYPE;
       v_ded_amt          giex_new_group_deductibles.deductible_amt%TYPE;
       v_deductible_amt   giex_new_group_deductibles.deductible_amt%TYPE;
       v_line_cd          gipi_polbasic.line_cd%TYPE;
       v_subline_cd       gipi_polbasic.subline_cd%TYPE;
       v_iss_cd           gipi_polbasic.iss_cd%TYPE;
       v_issue_yy         gipi_polbasic.issue_yy%TYPE;
       v_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE;
       v_renew_no         gipi_polbasic.renew_no%TYPE;
       v_summary_sw       giex_expiry.summary_sw%TYPE;
    BEGIN
       SELECT summary_sw
        INTO v_summary_sw
         FROM giex_expiry
       WHERE policy_id = p_policy_id;

       SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no
         FROM gipi_polbasic
       WHERE policy_id = p_policy_id
        AND endt_seq_no = 0;


       IF NVL (giisp.v ('INCLUDE_DEDUCTIBLE_EXPIRY'), 'N') = 'Y'
       THEN
           SELECT SUM (tsi_amt * currency_rt)
                    --joanne 052914 added currency_rt
            INTO v_tsi_amt
            FROM giex_itmperil a,
                 giis_peril b
              WHERE a.policy_id = p_policy_id
               AND a.line_cd = b.line_cd
                AND a.peril_cd = b.peril_cd
                AND b.peril_type = 'B';

          ---POLICY LEVEL computation of deductible amount-----
          FOR pol IN (SELECT a.ded_deductible_cd, b.deductible_rt,
                             b.min_amt, b.max_amt, b.range_sw
                        FROM gipi_deductibles a,
                             giis_deductible_desc b
                       WHERE a.ded_line_cd = b.line_cd
                         AND a.ded_subline_cd = b.subline_cd
                         AND a.ded_deductible_cd = b.deductible_cd
                         AND b.ded_type = 'T'
                         AND a.policy_id IN (SELECT policy_id
                                              FROM gipi_polbasic
                                             WHERE line_cd = v_line_cd
                                               AND subline_cd = v_subline_cd
                                               AND iss_cd = v_iss_cd
                                               AND issue_yy = v_issue_yy
                                               AND pol_seq_no = v_pol_seq_no
                                               AND renew_no = v_renew_no
                                               AND (pol_flag = DECODE(v_summary_sw, 'Y', '1', pol_flag)
                                                OR pol_flag = DECODE(v_summary_sw, 'Y', '2', pol_flag)
                                                OR pol_flag = DECODE(v_summary_sw, 'Y', '3', pol_flag))
                                               AND endt_seq_no = DECODE(v_summary_sw, 'N', 0, endt_seq_no))
                         AND a.item_no = 0
                         AND a.peril_cd = 0)
          LOOP
            v_ded_amt :=
                    v_tsi_amt
                    * (NVL (pol.deductible_rt, 0) / 100);

            IF pol.deductible_rt IS NOT NULL
               AND pol.min_amt IS NOT NULL
               AND pol.max_amt IS NOT NULL
            THEN
               IF pol.range_sw = 'H'
               THEN
                  v_ded_amt := GREATEST (v_ded_amt, pol.min_amt);
                  v_deductible_amt :=
                                   LEAST (v_ded_amt, pol.max_amt);
               ELSIF pol.range_sw = 'L'
               THEN
                  v_ded_amt := LEAST (v_ded_amt, pol.min_amt);
                  v_deductible_amt :=
                                   LEAST (v_ded_amt, pol.max_amt);
               ELSE
                  v_deductible_amt := pol.max_amt;
               END IF;
            ELSIF     pol.deductible_rt IS NOT NULL
                  AND pol.min_amt IS NOT NULL
            THEN
               v_deductible_amt :=
                                GREATEST (v_ded_amt, pol.min_amt);
            ELSIF     pol.deductible_rt IS NOT NULL
                  AND pol.max_amt IS NOT NULL
            THEN
               v_deductible_amt := LEAST (v_ded_amt, pol.max_amt);
            ELSE
               IF pol.deductible_rt IS NOT NULL
               THEN
                  v_deductible_amt := v_ded_amt;
               ELSIF pol.min_amt IS NOT NULL
               THEN
                  v_deductible_amt := pol.min_amt;
               ELSIF pol.max_amt IS NOT NULL
               THEN
                  v_deductible_amt := pol.max_amt;
               END IF;
            END IF;

             UPDATE giex_new_group_deductibles
                SET deductible_amt = v_deductible_amt
              WHERE policy_id = p_policy_id
                AND item_no = 0
                AND peril_cd = 0
                AND ded_deductible_cd = pol.ded_deductible_cd;

             v_deductible_amt := 0;
             v_ded_amt := 0;
          END LOOP;

          ------- ITEM LEVEL computation of deductible amount------------
          FOR item IN (SELECT   a.item_no,
                                SUM (a.tsi_amt * currency_rt) tsi_amt
                                --joanne 052914 added currency_rt
                           FROM giex_itmperil a,
                                giis_peril b
                          WHERE a.policy_id = p_policy_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND b.peril_type = 'B'
                       GROUP BY a.item_no
                       ORDER BY a.item_no)
          LOOP
             v_itm_tsi_amt := item.tsi_amt;

             FOR deduc IN (SELECT a.item_no, a.ded_deductible_cd, b.deductible_rt,
                                  b.min_amt, b.max_amt, b.range_sw
                             FROM gipi_deductibles a,
                                  giis_deductible_desc b
                            WHERE a.ded_line_cd = b.line_cd
                              AND a.ded_subline_cd = b.subline_cd
                              AND a.ded_deductible_cd = b.deductible_cd
                              AND b.ded_type = 'T'
                              AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE line_cd = v_line_cd
                                                   AND subline_cd = v_subline_cd
                                                   AND iss_cd = v_iss_cd
                                                   AND issue_yy = v_issue_yy
                                                   AND pol_seq_no = v_pol_seq_no
                                                   AND renew_no = v_renew_no
                                                   AND (pol_flag = DECODE(v_summary_sw, 'Y', '1', pol_flag)
                                                    OR pol_flag = DECODE(v_summary_sw, 'Y', '2', pol_flag)
                                                    OR pol_flag = DECODE(v_summary_sw, 'Y', '3', pol_flag))
                                                   AND endt_seq_no = DECODE(v_summary_sw, 'N', 0, endt_seq_no))
                              AND a.item_no = item.item_no
                              AND a.peril_cd = 0)
             LOOP
                v_ded_amt :=
                     v_itm_tsi_amt
                   * (NVL (deduc.deductible_rt, 0) / 100);

               IF     deduc.deductible_rt IS NOT NULL
                  AND deduc.min_amt IS NOT NULL
                  AND deduc.max_amt IS NOT NULL
               THEN
                  IF deduc.range_sw = 'H'
                  THEN
                     v_ded_amt :=
                              GREATEST (v_ded_amt, deduc.min_amt);
                     v_deductible_amt :=
                                 LEAST (v_ded_amt, deduc.max_amt);
                  ELSIF deduc.range_sw = 'L'
                  THEN
                     v_ded_amt :=
                                 LEAST (v_ded_amt, deduc.min_amt);
                     v_deductible_amt :=
                                 LEAST (v_ded_amt, deduc.max_amt);
                  ELSE
                     v_deductible_amt := deduc.max_amt;
                  END IF;
               ELSIF     deduc.deductible_rt IS NOT NULL
                     AND deduc.min_amt IS NOT NULL
               THEN
                  v_deductible_amt :=
                              GREATEST (v_ded_amt, deduc.min_amt);
               ELSIF     deduc.deductible_rt IS NOT NULL
                     AND deduc.max_amt IS NOT NULL
               THEN
                  v_deductible_amt :=
                                 LEAST (v_ded_amt, deduc.max_amt);
               ELSE
                  IF deduc.deductible_rt IS NOT NULL
                  THEN
                     v_deductible_amt := v_ded_amt;
                  ELSIF deduc.min_amt IS NOT NULL
                  THEN
                     v_deductible_amt := deduc.min_amt;
                  ELSIF deduc.max_amt IS NOT NULL
                  THEN
                     v_deductible_amt := deduc.max_amt;
                  END IF;
               END IF;

                 UPDATE giex_new_group_deductibles
                    SET deductible_amt = v_deductible_amt
                  WHERE policy_id = p_policy_id
                    AND item_no = item.item_no
                    AND peril_cd = 0
                    AND ded_deductible_cd = deduc.ded_deductible_cd;

                 v_deductible_amt := 0;
                 v_ded_amt := 0;
             END LOOP;
          END LOOP;

          ----- PERIL LEVEL computation of deductibles------
          FOR perl IN (SELECT   a.item_no, a.peril_cd,
                               (a.tsi_amt * currency_rt) tsi_amt
                               --joanne 052914 added currency_rt
                           FROM giex_itmperil a
                          WHERE a.policy_id = p_policy_id
                       ORDER BY a.item_no, a.peril_cd)
          LOOP
             v_perl_tsi_amt := perl.tsi_amt;

             FOR deduct IN (SELECT a.item_no, a.ded_deductible_cd, b.deductible_rt,
                                   b.min_amt, b.max_amt, b.range_sw, a.peril_cd
                              FROM gipi_deductibles a,
                                   giis_deductible_desc b
                             WHERE a.ded_line_cd = b.line_cd
                               AND a.ded_subline_cd = b.subline_cd
                               AND a.ded_deductible_cd = b.deductible_cd
                               AND b.ded_type = 'T'
                               AND a.policy_id IN (SELECT policy_id
                                                  FROM gipi_polbasic
                                                 WHERE line_cd = v_line_cd
                                                   AND subline_cd = v_subline_cd
                                                   AND iss_cd = v_iss_cd
                                                   AND issue_yy = v_issue_yy
                                                   AND pol_seq_no = v_pol_seq_no
                                                   AND renew_no = v_renew_no
                                                   AND (pol_flag = DECODE(v_summary_sw, 'Y', '1', pol_flag)
                                                    OR pol_flag = DECODE(v_summary_sw, 'Y', '2', pol_flag)
                                                    OR pol_flag = DECODE(v_summary_sw, 'Y', '3', pol_flag))
                                                   AND endt_seq_no = DECODE(v_summary_sw, 'N', 0, endt_seq_no))
                               AND a.item_no = perl.item_no
                               AND a.peril_cd = perl.peril_cd)
             LOOP
               v_ded_amt :=
                    v_perl_tsi_amt
                  * (NVL (deduct.deductible_rt, 0) / 100);

               IF     deduct.deductible_rt IS NOT NULL
                  AND deduct.min_amt IS NOT NULL
                  AND deduct.max_amt IS NOT NULL
               THEN
                  IF deduct.range_sw = 'H'
                  THEN
                     v_ded_amt :=
                             GREATEST (v_ded_amt, deduct.min_amt);
                     v_deductible_amt :=
                                LEAST (v_ded_amt, deduct.max_amt);
                  ELSIF deduct.range_sw = 'L'
                  THEN
                     v_ded_amt :=
                                LEAST (v_ded_amt, deduct.min_amt);
                     v_deductible_amt :=
                                LEAST (v_ded_amt, deduct.max_amt);
                  ELSE
                     v_deductible_amt := deduct.max_amt;
                  END IF;
               ELSIF     deduct.deductible_rt IS NOT NULL
                     AND deduct.min_amt IS NOT NULL
               THEN
                  v_deductible_amt :=
                             GREATEST (v_ded_amt, deduct.min_amt);
               ELSIF     deduct.deductible_rt IS NOT NULL
                     AND deduct.max_amt IS NOT NULL
               THEN
                  v_deductible_amt :=
                                LEAST (v_ded_amt, deduct.max_amt);
               ELSE
                  IF deduct.deductible_rt IS NOT NULL
                  THEN
                     v_deductible_amt := v_ded_amt;
                  ELSIF deduct.min_amt IS NOT NULL
                  THEN
                     v_deductible_amt := deduct.min_amt;
                  ELSIF deduct.max_amt IS NOT NULL
                  THEN
                     v_deductible_amt := deduct.max_amt;
                  END IF;
               END IF;

               UPDATE giex_new_group_deductibles
                    SET deductible_amt = v_deductible_amt
                  WHERE policy_id = p_policy_id
                    AND item_no = deduct.item_no
                    AND peril_cd = deduct.peril_cd
                    AND ded_deductible_cd = deduct.ded_deductible_cd;

                v_deductible_amt := 0;
                v_ded_amt := 0;
             END LOOP;
          END LOOP;
       END IF;
    END;

   /*Added by Joanne
   **Date: 041514
   **Desc: To check if policy have % TSI deductibles*/
    FUNCTION count_tsi_ded (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE
    )
    RETURN NUMBER
    AS
      v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
          INTO v_count
		  FROM GIEX_NEW_GROUP_DEDUCTIBLES a, giis_deductible_desc b
		 WHERE a.policy_id = p_policy_id
           AND a.ded_deductible_cd = b.deductible_cd
           AND a.line_cd=b.line_cd
           AND a.subline_cd=b.subline_cd
           AND b.ded_type='T';

      RETURN v_count;
    END;

    /*Added by Joanne
   **Date: 06.06.14
   **Desc: To get policy currency*/
    FUNCTION get_deductible_currency (
       p_policy_id   giex_new_group_deductibles.policy_id%TYPE
    )
    RETURN NUMBER
    AS
      v_currency_rt NUMBER;
    BEGIN
      FOR x IN (SELECT DISTINCT currency_rt
            FROM giex_itmperil
            WHERE policy_id = p_policy_id
            order by currency_rt desc)
      LOOP
        v_currency_rt := x.currency_rt;
      END LOOP;

      RETURN v_currency_rt;
    END;
END;
/


