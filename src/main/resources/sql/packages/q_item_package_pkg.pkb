CREATE OR REPLACE PACKAGE BODY CPI.Q_ITEM_PACKAGE_PKG

AS

    FUNCTION get_q_item_package_records(p_extract_id    GIXX_ITEM.extract_id%TYPE)

    RETURN q_item_tab PIPELINED

    IS
        v_item_pack         q_item_type;

    BEGIN
        FOR i IN(SELECT  B480.extract_id       extract_id
                        ,B480.policy_id        policy_id
                        ,B480.pack_line_cd     line_cd
                        ,B480.item_no          item_item_no
                        ,B480.item_no||' - '||B480.item_title   item_item_title
                        ,B480.item_title       item_item_title2
                        ,B480.item_desc        item_desc
                        ,B480.item_desc2       item_desc2
                        ,B480.coverage_cd      item_coverage_cd
                        ,B110.currency_desc    item_currency_desc
                        ,B480.other_info       item_other_info
                        ,B480.from_date        item_from_date
                        ,B480.to_date          item_to_date
                        ,B480.currency_rt      item_currency_rt
                        ,B480.pack_line_cd     pack_line_cd
                        ,'Risk '||B480.risk_no||' Item '||B480.risk_item_no risk
                        ,B480.tsi_amt          tsi_amt
                        ,B480.risk_item_no     risk_item_no
                        ,B480.risk_no          risk_no
                FROM    GIXX_ITEM     B480,
                        GIIS_CURRENCY B110
                WHERE B110.main_currency_cd = B480.currency_cd
                   AND B480.extract_id = p_extract_id
                ORDER BY ITEM_ITEM_NO)
        LOOP
            v_item_pack.extract_id       := i.extract_id;
            v_item_pack.policy_id        := i.policy_id;
            v_item_pack.line_cd          := i.line_cd;
            v_item_pack.item_no          := i.item_item_no;
            v_item_pack.item_item_title  := i.item_item_title;
            v_item_pack.item_title       := i.item_item_title2;
            v_item_pack.item_desc        := i.item_desc;
            v_item_pack.item_desc2       := i.item_desc2;
            v_item_pack.coverage_cd      := i.item_coverage_cd;
            v_item_pack.currency_desc    := i.item_currency_desc;
            v_item_pack.other_info       := i.item_other_info;
            v_item_pack.from_date        := i.item_from_date;
            v_item_pack.to_date          := i.item_to_date;
            v_item_pack.currency_rt      := i.item_currency_rt;
            v_item_pack.pack_line_cd     := i.pack_line_cd;
            v_item_pack.risk             := i.risk;
            v_item_pack.tsi_amt          := i.tsi_amt;
            v_item_pack.risk_item_no     := i.risk_item_no;
            v_item_pack.risk_no          := i.risk_no;
            v_item_pack.show_deductible  := Q_ITEM_PACKAGE_PKG.check_deductible_display(p_extract_id, i.line_cd, i.policy_id);

        PIPE ROW(v_item_pack);

        END LOOP;

        RETURN;

    END get_q_item_package_records;


    FUNCTION check_deductible_display (p_extract_id    GIXX_ITEM.extract_id%TYPE,
                                       p_line_cd       GIXX_ITEM.pack_line_cd%TYPE,
                                       p_policy_id     GIXX_ITEM.policy_id%TYPE)
    RETURN VARCHAR2

    IS

        v_show_deductible       VARCHAR2(1);
        v_total                 NUMBER;
        v_cnt                   NUMBER;

    BEGIN
        FOR x in (SELECT COUNT(*) cnt
                   FROM GIXX_DEDUCTIBLES
                   WHERE extract_id = p_extract_id
                     AND policy_id = p_policy_id)
        LOOP
            v_total := x.cnt;
            EXIT;
        END LOOP;

        IF(p_line_cd = GIISP.V('LINE_CODE_FI')) THEN
           FOR y IN (SELECT count(*)cnt
                     FROM GIXX_DEDUCTIBLES
                     WHERE extract_id = p_extract_id
                       AND policy_id = p_policy_id
                       AND UPPER(deductible_text) IN ('F0') )
           LOOP
            v_cnt := y.cnt;
            EXIT;
           END LOOP;

        ELSIF (p_line_cd = GIISP.V('LINE_CODE_MC')) THEN
           FOR y IN (SELECT count(*)cnt
                     FROM GIXX_DEDUCTIBLES
                     WHERE extract_id = p_extract_id
                     AND policy_id = p_policy_id
                     AND UPPER(deductible_text) IN ('DD0') )
           LOOP
            v_cnt := y.cnt;
            EXIT;
           END LOOP;
        ELSE
           FOR y IN (SELECT count(*)cnt
                     FROM GIXX_DEDUCTIBLES
                     WHERE extract_id = p_extract_id
                     AND policy_id = p_policy_id
                     AND UPPER(deductible_text) IN ('ZERO DEDUCTIBLE','NOT APPLICABLE'))
           LOOP
            v_cnt := y.cnt;
            EXIT;
           END LOOP;

        END IF;

        IF v_total = v_cnt  THEN
              v_show_deductible := 'N';
        ELSE
            v_show_deductible := 'Y';
        END IF;

        RETURN(v_show_deductible);

    END check_deductible_display;

END;
/


