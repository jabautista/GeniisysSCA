DROP FUNCTION CPI.GET_FI_QUOTE_FGIC_ITMBRKDWN;

CREATE OR REPLACE FUNCTION CPI.get_fi_quote_fgic_itmbrkdwn(p_quote_id   gipi_quote.quote_id%TYPE)
RETURN VARCHAR2
IS
    v_count                 NUMBER := 0;
    v_item_no				NUMBER;
    v_item_title			gipi_quote_item.item_title%type;
    v_item_tsi_amt			varchar2(25)				:= ' ';
    v_breakdown_tsi			varchar2(50)				:= ' ';

BEGIN
    -- added by kim 110504
-- insert item breakdown (item title and item tsi amount from gipi_quote_item)
    v_count := 0;
    SELECT count(*)
      INTO v_count
      FROM gipi_quote_item
     WHERE quote_id = p_quote_id;

    FOR a IN (SELECT a.item_no, a.item_title item_title, ltrim(to_char((a.tsi_amt * b.currency_rt), '999,999,999,999.99'),' ') item_tsi_amt
             FROM gipi_quote_item a,
                  giis_currency b
            WHERE quote_id = p_quote_id
              AND a.currency_cd = b.main_currency_cd)

    LOOP
     v_item_no         := a.item_no;
     v_item_title      := a.item_title;
     v_item_tsi_amt  := a.item_tsi_amt;
    END LOOP;

    IF v_count = 1 THEN
        v_breakdown_tsi := v_item_title;
    ELSE
        v_breakdown_tsi := v_item_no||' - '||nvl(v_item_title, ' ')||' - '||nvl(v_item_tsi_amt, ' ');
    END IF;

    RETURN v_breakdown_tsi;
END;
/


