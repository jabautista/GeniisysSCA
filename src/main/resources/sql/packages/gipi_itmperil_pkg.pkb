CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ITMPERIL_PKG AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    06.08.2010    andrew            Function to retrieve item peril records from the endorsed policy.
    **                              Reference By : (GIPIS097 - Endorsement Item Peril Information)
    **    10.17.2011    mark jm            added ri_comm_rate column
    */

  FUNCTION get_gipi_item_peril(p_par_id IN GIPI_POLBASIC.par_id%TYPE)
    RETURN endt_peril_tab PIPELINED IS
    v_peril         endt_peril_type;
    v_expiry_date   DATE;
  BEGIN
    v_expiry_date := EXTRACT_EXPIRY(p_par_id);

    FOR a1 IN (
      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
        FROM GIPI_WPOLBAS
       WHERE par_id = p_par_id)
    LOOP
      FOR i IN (
        SELECT a.policy_id,
                 c.item_no,         c.line_cd,      c.peril_cd,     c.tarf_cd,
                 c.prem_rt,         c.tsi_amt,      c.prem_amt,     c.ann_tsi_amt,
                 c.ann_prem_amt,    c.comp_rem,     c.discount_sw,  c.prt_flag,
                 c.ri_comm_rate,    c.ri_comm_amt,  c.as_charge_sw, c.surcharge_sw,
                 c.no_of_days,      c.base_amt,     c.aggregate_sw, d.peril_name,
                 c.rec_flag,        d.basc_perl_cd, d.peril_type
            FROM GIPI_POLBASIC a
                ,GIPI_ITEM     b
                ,GIPI_ITMPERIL c
                ,giis_peril    d
          WHERE a.policy_id = b.policy_id
            AND b.policy_id = c.policy_id
            AND b.item_no = c.item_no
            AND c.peril_cd = d.peril_cd
            AND c.line_cd = d.line_cd
            AND a.line_cd    = a1.line_cd
            AND a.subline_cd = a1.subline_cd
            AND a.iss_cd     = a1.iss_cd
            AND a.issue_yy   = a1.issue_yy
            AND a.pol_seq_no = a1.pol_seq_no
            AND a.renew_no   = a1.renew_no
            AND a.pol_flag IN ('1','2','3','X')
            AND TRUNC(a.eff_date) <= TRUNC(a1.eff_date)
            AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date,
                         v_expiry_date, a.endt_expiry_date, a.endt_expiry_date)) >= TRUNC(a1.eff_date)
          ORDER BY endt_seq_no DESC, eff_date DESC
          --ORDER BY a.eff_date DESC       --edited by d.alcantara, 03-28-2012, for SR9144
--          SELECT a.policy_id,
--                 c.item_no,         c.line_cd,      c.peril_cd,     c.tarf_cd,
--                 c.prem_rt,         c.tsi_amt,      c.prem_amt,     c.ann_tsi_amt,
--                 c.ann_prem_amt,    c.comp_rem,     c.discount_sw,  c.prt_flag,
--                 c.ri_comm_rate,    c.ri_comm_amt,  c.as_charge_sw, c.surcharge_sw,
--                 c.no_of_days,      c.base_amt,     c.aggregate_sw, d.peril_name,
--                 c.rec_flag,        d.basc_perl_cd, d.peril_type
--            FROM GIPI_POLBASIC a
--                ,GIPI_ITEM     b
--                ,GIPI_ITMPERIL c
--                ,giis_peril    d
--          WHERE a.line_cd    = a1.line_cd
--            AND a.subline_cd = a1.subline_cd
--            AND a.iss_cd     = a1.iss_cd
--            AND a.issue_yy   = a1.issue_yy
--            AND a.pol_seq_no = a1.pol_seq_no
--            AND a.renew_no   = a1.renew_no
--            AND a.pol_flag NOT IN ('4','5')
--            AND a.policy_id  = b.policy_id
--            AND b.policy_id  = c.policy_id
--            AND b.item_no    = c.item_no
--            AND c.peril_cd   = d.peril_cd
--            AND c.line_cd    = d.line_cd
--            AND NVL(c.ann_tsi_amt,0) != 0
--            AND TRUNC(a1.eff_date) BETWEEN TRUNC(NVL(from_date,eff_date))
--                              AND NVL(to_date,NVL(endt_expiry_date,expiry_date))
--       ORDER BY d.peril_name
            )
      LOOP
        v_peril.policy_id     := i.policy_id;
        v_peril.item_no       := i.item_no;
        v_peril.line_cd       := i.line_cd;
        v_peril.peril_cd      := i.peril_cd;
        v_peril.peril_name    := i.peril_name;
        v_peril.tarf_cd       := i.tarf_cd;
        v_peril.prem_rt       := i.prem_rt;
        v_peril.tsi_amt       := i.tsi_amt;
        v_peril.prem_amt      := i.prem_amt;
        v_peril.ann_tsi_amt   := i.ann_tsi_amt;
        v_peril.ann_prem_amt  := i.ann_prem_amt;
        v_peril.comp_rem      := i.comp_rem;
        v_peril.discount_sw   := i.discount_sw;
        v_peril.prt_flag      := i.prt_flag;
        v_peril.rec_flag      := i.rec_flag;
        v_peril.ri_comm_amt   := i.ri_comm_amt;
        v_peril.ri_comm_rate  := i.ri_comm_rate;
        v_peril.as_charge_sw  := i.as_charge_sw;
        v_peril.surcharge_sw  := i.surcharge_sw;
        v_peril.no_of_days    := i.no_of_days;
        v_peril.base_amt      := i.base_amt;
        v_peril.aggregate_sw  := i.aggregate_sw;
        v_peril.basc_perl_cd  := i.basc_perl_cd;
        v_peril.peril_type    := i.peril_type;
        PIPE ROW(v_peril);
      END LOOP;

      RETURN;
    END LOOP;

  END get_gipi_item_peril;

  /*
**  Created by   : Bryan Joseph G. Abuluyan
**  Date Created : December 6, 2010
**  Reference By : (GIPIS091- Regenerate Policy Documents)
*/
  FUNCTION check_compulsory_death(p_policy_id   GIPI_ITMPERIL.policy_id%TYPE)
    RETURN VARCHAR2
    IS
    v_compulsary_death  VARCHAR2(1) := 'N';
  BEGIN
    FOR cd IN (SELECT '1'
                 FROM GIIS_PARAMETERS a, GIIS_PERIL c, GIPI_ITMPERIL b
                WHERE a.param_name = 'COMPULSORY DEATH/BI'
                  AND a.param_type = 'V'
                  AND c.peril_sname = a.param_value_v
                  AND b.tsi_amt > 0
                  AND b.peril_cd = c.peril_cd
                  AND  b.policy_id = p_policy_id)
    LOOP
      v_compulsary_death := 'Y';
    END LOOP;
    RETURN v_compulsary_death;
  END check_compulsory_death;

    /*
    **  Created by   : Bryan Joseph G. Abuluyan
    **  Date Created : December 6, 2010
    **  Reference By : (GIPIS091- Regenerate Policy Documents)
    */
  FUNCTION get_item_peril_count(p_policy_id   GIPI_ITMPERIL.policy_id%TYPE)
    RETURN NUMBER
    IS
    v_count NUMBER(8) := 0;
  BEGIN
    FOR i IN (SELECT COUNT(1) num
                FROM GIPI_ITMPERIL
               WHERE policy_id = p_policy_id)
    LOOP
      v_count := i.num;
    END LOOP;
    RETURN v_count;
  END get_item_peril_count;

  FUNCTION get_gipir915_itmperil(
     p_policy_id        gipi_itmperil.policy_id%TYPE,
     p_item_no            gipi_itmperil.item_no%TYPE
  )
     RETURN gipir915_itmperil_tab PIPELINED
  IS
     v_gipir915_itmperil    gipir915_itmperil_type;
  BEGIN
         FOR i IN (SELECT POLICY_ID ITMPERIL_POLICY_ID,
                           ITEM_NO ITMPERIL_ITEM_NO,
                           TSI_AMT TSI_AMT,
                           PREM_AMT PREM_AMT
                      FROM GIPI_ITMPERIL
                  WHERE POLICY_ID = p_policy_id
                    AND ITEM_NO = p_item_no
                    AND PERIL_CD = (SELECT PARAM_VALUE_N
                                        FROM GIIS_PARAMETERS
                                     WHERE ROWNUM        = 1
                                           AND PARAM_NAME = 'CTPL')
                       )
      LOOP
            v_gipir915_itmperil.itmperil_policy_id := i.itmperil_policy_id;
          v_gipir915_itmperil.itmperil_item_no   := i.itmperil_item_no;
          v_gipir915_itmperil.tsi_amt             := i.tsi_amt;
          v_gipir915_itmperil.prem_amt             := i.prem_amt;
          PIPE ROW(v_gipir915_itmperil);
      END LOOP;
  END;

   FUNCTION get_gipi_itmperil(p_policy_id    GIPI_ITEM.policy_id%TYPE,
                              p_item_no      GIPI_ITEM.item_no%TYPE)

      RETURN gipi_itmperil_tab PIPELINED

   IS
      v_itm_peril       gipi_itmperil_type;
      v_line_cd         GIPI_POLBASIC.line_cd%TYPE;
      v_pack_pol_flag   GIPI_POLBASIC.pack_pol_flag%TYPE;


   BEGIN

      FOR i IN (SELECT policy_id,item_no,peril_cd,
                       prem_rt,tsi_amt,prem_amt,
                       surcharge_sw,discount_sw,
                       aggregate_sw,comp_rem,
                       ri_comm_rate,ri_comm_amt
                  FROM GIPI_ITMPERIL
                 WHERE policy_id = p_policy_id
                   AND item_no = p_item_no)
      LOOP

        v_itm_peril.policy_id      := i.policy_id;
        v_itm_peril.item_no        := i.item_no;
        v_itm_peril.peril_cd       := i.peril_cd;
        v_itm_peril.prem_rt        := i.prem_rt;
        v_itm_peril.tsi_amt        := i.tsi_amt;
        v_itm_peril.prem_amt       := i.prem_amt;
        v_itm_peril.surcharge_sw   := i.surcharge_sw;
        v_itm_peril.discount_sw    := i.discount_sw;
        v_itm_peril.aggregate_sw   := i.aggregate_sw;
        v_itm_peril.comp_rem       := i.comp_rem;
        v_itm_peril.ri_comm_rate   := i.ri_comm_rate;
        v_itm_peril.ri_comm_amt    := i.ri_comm_amt;

        SELECT pack_pol_flag,line_cd
          INTO v_pack_pol_flag,v_line_cd
          FROM GIPI_POLBASIC
         WHERE policy_id = i.policy_id;


        IF v_pack_pol_flag = 'Y' THEN

           FOR x IN (SELECT pack_line_cd
                       FROM GIPI_ITEM
                      WHERE policy_id = i.policy_id)
           LOOP
               v_line_cd := x.pack_line_cd;
           END LOOP;


        END IF;

        SELECT peril_name
          INTO v_itm_peril.peril_name
          FROM GIIS_PERIL
         WHERE line_cd = v_line_cd
           AND peril_cd = i.peril_cd;

         PIPE ROW (v_itm_peril);

      END LOOP;

   END get_gipi_itmperil;

   /*
    **  Created by   : Moses Brian C. Calma
    **  Date Created : April 20, 2011
    **  Reference By : GIPIS100
  */


  /*
    **  Created by   : D. Alcantara
    **  Date Created : 06/16/2011
    **  Reference By : GIPIS091
  */
  FUNCTION check_ctpl_coc_printing (
    p_item_no       GIPI_ITEM.item_no%TYPE,
    p_policy_id     GIPI_ITMPERIL.policy_id%TYPE
  ) RETURN VARCHAR2
  IS
    v_ctpl  VARCHAR2(2);
  BEGIN
    v_ctpl := 'N';
     FOR C1 IN ( SELECT a.param_name
          FROM giis_parameters a
            , giis_peril c
            , gipi_itmperil b
         WHERE a.param_name = 'COMPULSORY DEATH/BI'
           AND a.param_type = 'V'
           AND c.peril_sname = a.param_value_v
           AND B.TSI_AMT > 0
           AND B.PERIL_CD = c.peril_cd
           AND B.ITEM_NO = p_item_no
                   AND B.POLICY_ID = p_policy_id
            ) LOOP
                 IF C1.param_name = 'COMPULSORY DEATH/BI' then
                   v_ctpl := 'Y';
                  -- rec_grp_insert;
                 end if;
          EXIT;
     END LOOP;
     RETURN v_ctpl;
  END check_ctpl_coc_printing;

  PROCEDURE get_endt_ri_comm_rate_amt (
       p_par_id        IN   gipi_parlist.par_id%TYPE,
       p_prem_amt      IN   gipi_witmperl.prem_amt%TYPE,
       p_item_no       IN   gipi_witmperl.item_no%TYPE,
       p_peril_cd      IN   gipi_witmperl.peril_cd%TYPE,
       p_ri_comm_rate  OUT  gipi_witmperl.ri_comm_rate%TYPE,
       p_ri_comm_amt   OUT  gipi_witmperl.ri_comm_amt%TYPE)
    IS
       v_policy_id    gipi_polbasic.policy_id%TYPE;
       v_line_cd      gipi_polbasic.line_cd%TYPE;
       v_subline_cd   gipi_polbasic.subline_cd%TYPE;
       v_issue_yy     gipi_polbasic.issue_yy%TYPE;
       v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
    BEGIN
       FOR i IN (
         SELECT line_cd, subline_cd, issue_yy, pol_seq_no
           FROM gipi_wpolbas
          WHERE par_id = p_par_id)
       LOOP
         v_line_cd := i.line_cd;
         v_subline_cd := i.subline_cd;
         v_issue_yy := i.issue_yy;
         v_pol_seq_no := i.pol_seq_no;
       END LOOP;

       SELECT policy_id
         INTO v_policy_id
         FROM gipi_polbasic
        WHERE 1 = 1
          AND line_cd = v_line_cd
          AND subline_cd = v_subline_cd
          AND iss_cd = 'RI'
          AND issue_yy = v_issue_yy
          AND pol_seq_no = v_pol_seq_no
          AND pol_flag <> '5'
          AND eff_date IN (
                 SELECT MAX (eff_date)
                   FROM gipi_polbasic
                  WHERE 1 = 1
                    AND line_cd = v_line_cd
                    AND subline_cd = v_subline_cd
                    AND iss_cd = 'RI'
                    AND issue_yy = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND (TRUNC(eff_date) = TRUNC(SYSDATE) OR TRUNC(eff_date) < TRUNC(SYSDATE)));
    EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          NULL;

          FOR d IN (SELECT ri_comm_rate
                      FROM gipi_itmperil
                     WHERE policy_id = v_policy_id
                       AND line_cd = v_line_cd
                       AND item_no = p_item_no
                       AND peril_cd = p_peril_cd)
          LOOP
             p_ri_comm_rate := d.ri_comm_rate;
             p_ri_comm_amt := (NVL (p_ri_comm_rate, 0) * NVL (p_prem_amt, 0)) / 100;
             EXIT;
          END LOOP;
    END;

END GIPI_ITMPERIL_PKG;
/


