CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ITMPERIL_GROUPED_PKG
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.06.2011
    **  Reference By     : (GIPIS065 - Endt Item Information - Accident)
    **  Description     : Returns records with the given policy_id and item_no
    */
    FUNCTION get_gipi_itmperil_grouped (
        p_policy_id IN gipi_itmperil_grouped.policy_id%TYPE,
        p_item_no IN gipi_itmperil_grouped.item_no%TYPE)
    RETURN gipi_itmperil_grouped_tab PIPELINED
    IS
        v_grouped_items gipi_itmperil_grouped_type;
    BEGIN
        FOR i IN (
            SELECT a.policy_id,        a.item_no,        a.grouped_item_no,
                   a.line_cd,        a.peril_cd,        a.rec_flag,
                   a.no_of_days,    a.prem_rt,        a.tsi_amt,
                   a.prem_amt,        a.ann_tsi_amt,    a.ann_prem_amt,
                   a.aggregate_sw,    a.base_amt,        a.ri_comm_rate,
                   a.ri_comm_amt,    a.arc_ext_data,
                   b.grouped_item_title,
                   c.peril_name,        c.peril_type
              FROM GIPI_ITMPERIL_GROUPED a,
                   GIPI_GROUPED_ITEMS b,
                   GIIS_PERIL c
             WHERE a.policy_id = p_policy_id
               AND a.item_no = p_item_no
               AND a.policy_id = b.policy_id
               AND a.item_no = b.item_no
               AND a.grouped_item_no = b.grouped_item_no
               AND a.peril_cd = c.peril_cd(+)
               AND a.line_cd = c.line_cd(+)
          ORDER BY policy_id, item_no, grouped_item_no)
        LOOP
            v_grouped_items.policy_id                  := i.policy_id;
            v_grouped_items.item_no                 := i.item_no;
            v_grouped_items.grouped_item_no         := i.grouped_item_no;
            v_grouped_items.line_cd                      := i.line_cd;
            v_grouped_items.peril_cd                  := i.peril_cd;
            v_grouped_items.rec_flag                 := i.rec_flag;
            v_grouped_items.no_of_days                := i.no_of_days;
            v_grouped_items.prem_rt                     := i.prem_rt;
            v_grouped_items.tsi_amt                    := i.tsi_amt;
            v_grouped_items.prem_amt                := i.prem_amt;
            v_grouped_items.ann_tsi_amt                  := i.ann_tsi_amt;
            v_grouped_items.ann_prem_amt            := i.ann_prem_amt;
            v_grouped_items.aggregate_sw              := i.aggregate_sw;
            v_grouped_items.base_amt                   := i.base_amt;
            v_grouped_items.ri_comm_rate             := i.ri_comm_rate;
            v_grouped_items.ri_comm_amt                  := i.ri_comm_amt;
            v_grouped_items.arc_ext_data            := i.arc_ext_data;
            v_grouped_items.peril_name                 := i.peril_name;
            v_grouped_items.grouped_item_title         := i.grouped_item_title;
            v_grouped_items.peril_type                := i.peril_type;

            PIPE ROW(v_grouped_items);
        END LOOP;
        RETURN;
    END get_gipi_itmperil_grouped;

    /*
    **  Created by        : Moses Calma
    **  Date Created     : 06.29.2011
    **  Reference By     : GIPIS 100 - View Policy Information
    **  Description     : Returns records with the given policy_id ,item_no and grouped_item_no
    */
    FUNCTION get_itmperil_grouped (
       p_policy_id         gipi_itmperil_grouped.policy_id%TYPE,
       p_item_no           gipi_itmperil_grouped.item_no%TYPE,
       p_grouped_item_no   gipi_itmperil_grouped.grouped_item_no%TYPE
    )
       RETURN itmperil_grouped_tab PIPELINED
    IS
       v_itmperil_grouped      itmperil_grouped_type;
    BEGIN
       FOR i IN (SELECT policy_id, item_no, grouped_item_no, line_cd, peril_cd, rec_flag,
                        prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, aggregate_sw,
                        base_amt, ri_comm_rate, ri_comm_amt, no_of_days
                   FROM gipi_itmperil_grouped
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no
               ORDER BY policy_id, item_no, grouped_item_no)
       LOOP

          v_itmperil_grouped.item_no           := i.item_no;
          v_itmperil_grouped.line_cd           := i.line_cd;
          v_itmperil_grouped.prem_rt           := i.prem_rt;
          v_itmperil_grouped.tsi_amt           := i.tsi_amt;
          v_itmperil_grouped.base_amt          := i.base_amt;
          v_itmperil_grouped.peril_cd          := i.peril_cd;
          v_itmperil_grouped.rec_flag          := i.rec_flag;
          v_itmperil_grouped.prem_amt          := i.prem_amt;
          v_itmperil_grouped.policy_id         := i.policy_id;
          v_itmperil_grouped.no_of_days        := i.no_of_days;
          v_itmperil_grouped.ann_tsi_amt       := i.ann_tsi_amt;
          v_itmperil_grouped.ri_comm_amt       := i.ri_comm_amt;
          v_itmperil_grouped.ann_prem_amt      := i.ann_prem_amt;
          v_itmperil_grouped.aggregate_sw      := i.aggregate_sw;
          v_itmperil_grouped.ri_comm_rate      := i.ri_comm_rate;
          v_itmperil_grouped.grouped_item_no   := i.grouped_item_no;

          BEGIN

            SELECT peril_name
              INTO v_itmperil_grouped.peril_name
              FROM giis_peril
             WHERE line_cd = i.line_cd
               AND peril_cd = i.peril_cd;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_itmperil_grouped.peril_name := '';

          END;

          BEGIN

            SELECT NVL (SUM (b.tsi_amt), 0)
              INTO v_itmperil_grouped.sum_tsi_amt
              FROM gipi_grouped_items a, gipi_itmperil_grouped b, giis_peril c
             WHERE a.policy_id = b.policy_id
               AND a.item_no = b.item_no
               AND a.grouped_item_no = b.grouped_item_no
               AND b.line_cd = c.line_cd
               AND b.peril_cd = c.peril_cd
               AND c.peril_type = 'B'
               AND a.grouped_item_no = i.grouped_item_no
               AND a.policy_id = i.policy_id
               AND a.item_no = i.item_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

            v_itmperil_grouped.sum_tsi_amt := 0;

          END;

          BEGIN

             SELECT NVL (SUM (prem_amt), 0)
               INTO v_itmperil_grouped.sum_prem_amt
               FROM gipi_itmperil_grouped
              WHERE policy_id = i.policy_id
                AND item_no = i.item_no
                AND grouped_item_no = i.grouped_item_no;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_itmperil_grouped.sum_prem_amt := 0;

          END;

          PIPE ROW (v_itmperil_grouped);

       END LOOP;

    END get_itmperil_grouped;

/*
**  Created by    : Belle Bebing
**  Date Created  : 01.12.2011
**  Reference By  : (GICLS017 - Personal Accident Information)
**  Description   : check if item-peril exist in grouped item
*/
FUNCTION get_itmperil_grouped_exist(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_item_no               gipi_itmperil.item_no%TYPE,
        p_grouped_item_no       gipi_itmperil_grouped.grouped_item_no%TYPE

    )
    RETURN VARCHAR2 IS
      v_exists     VARCHAR2(2):= 'N';
    BEGIN
        FOR a IN (SELECT 1
                    FROM gipi_itmperil_grouped a
                   WHERE EXISTS (SELECT 1
                                   FROM gipi_polbasic
                                  WHERE line_cd = p_line_cd
                                    AND subline_cd = p_subline_cd
                                    AND iss_cd = p_pol_iss_cd
                                    AND issue_yy = p_issue_yy
                                    AND pol_seq_no = p_pol_seq_no
                                    AND renew_no = p_renew_no
                                    AND policy_id = a.policy_id)
                     AND item_no = p_item_no
                     AND grouped_item_no = p_grouped_item_no)
        LOOP
            v_exists := 'Y';
        END LOOP;
    RETURN v_exists;
    END;

	/*
    **  Created by    : d.alcantara
    **  Date Created  : 05.22.2012
    **  Reference By  : (GIPIS065 - Endt. Accident Item Info.)
    **  Description   : retrieves gipi_itmperil_grouped of endorsed policy
    */
    FUNCTION get_pol_itmperil_grouped (
        p_par_id                gipi_parlist.par_id%TYPE
    ) RETURN gipi_itmperil_grouped_tab PIPELINED IS
        v_grouped_items gipi_itmperil_grouped_type;
        v_expiry_date   DATE;
    BEGIN
        v_expiry_date := EXTRACT_EXPIRY(p_par_id);

        FOR a1 IN (
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id)
        LOOP
            FOR i IN (
                SELECT a.policy_id,        a.item_no,        a.grouped_item_no,
                       a.line_cd,        a.peril_cd,        a.rec_flag,
                       a.no_of_days,    a.prem_rt,        a.tsi_amt,
                       a.prem_amt,        a.ann_tsi_amt,    a.ann_prem_amt,
                       a.aggregate_sw,    a.base_amt,        a.ri_comm_rate,
                       a.ri_comm_amt,     c.peril_name,      c.peril_type
                  FROM gipi_itmperil_grouped a,
                       gipi_polbasic b,
                       GIIS_PERIL c
                 WHERE a.policy_id  = b.policy_id
                   AND a.line_cd    = b.line_cd
                   AND b.line_cd    = a1.line_cd
                   AND b.subline_cd = a1.subline_cd
                   AND b.iss_cd     = a1.iss_cd
                   AND b.issue_yy   = a1.issue_yy
                   AND b.pol_seq_no = a1.pol_seq_no
                   AND b.renew_no   = a1.renew_no
                   AND b.pol_flag IN ('1','2','3','X')
                   AND TRUNC(b.eff_date) <= TRUNC(a1.eff_date)
                   AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                             v_expiry_date, b.endt_expiry_date, b.endt_expiry_date)) >= TRUNC(a1.eff_date)
                   AND a.peril_cd = c.peril_cd(+)
                   AND a.line_cd = c.line_cd(+)
                 ORDER BY endt_seq_no DESC, eff_date DESC
            ) LOOP
                v_grouped_items.policy_id                  := i.policy_id;
                v_grouped_items.item_no                 := i.item_no;
                v_grouped_items.grouped_item_no         := i.grouped_item_no;
                v_grouped_items.line_cd                      := i.line_cd;
                v_grouped_items.peril_cd                  := i.peril_cd;
                v_grouped_items.rec_flag                 := i.rec_flag;
                v_grouped_items.no_of_days                := i.no_of_days;
                v_grouped_items.prem_rt                     := i.prem_rt;
                v_grouped_items.tsi_amt                    := i.tsi_amt;
                v_grouped_items.prem_amt                := i.prem_amt;
                v_grouped_items.ann_tsi_amt                  := i.ann_tsi_amt;
                v_grouped_items.ann_prem_amt            := i.ann_prem_amt;
                v_grouped_items.aggregate_sw              := i.aggregate_sw;
                v_grouped_items.base_amt                   := i.base_amt;
                v_grouped_items.ri_comm_rate             := i.ri_comm_rate;
                v_grouped_items.ri_comm_amt                  := i.ri_comm_amt;
                v_grouped_items.peril_name                 := i.peril_name;
                v_grouped_items.peril_type                := i.peril_type;

                PIPE ROW(v_grouped_items);
            END LOOP;
        END LOOP;
    END get_pol_itmperil_grouped;
END GIPI_ITMPERIL_GROUPED_PKG;
/


