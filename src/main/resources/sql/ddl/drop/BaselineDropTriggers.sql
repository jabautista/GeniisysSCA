/* Formatted on 2016/10/19 18:02 (Formatter Plus v4.8.8) */
SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 10.19.2016
**  Remarks      : GENQA-SR-5784
*/
BEGIN
   FOR i IN (SELECT trigger_name
               FROM user_triggers
              WHERE trigger_name IN
                       ('TRGI_GIAP', 'GIEX_DEP_PERL', 'TRG1_GAPPD',
                        'TRG1_GIPPD', 'TRG1_ALIAS',
                        'INTM_SPECIAL_RATE_TBXIU',
                        'GIIS_SOLICIT_OFFICIAL_TBXIU', 'TRG1_STAT_INSP',
                        'FIREITEM_TBXXU', 'GIPI_PACK_WPOLNREP_TAXDX',
                        'GIPI_PICTURE_TBXIU2', 'EN_QUOTE_TBXIU',
                        'FI_QUOTE_TBXIU', 'GRPD_TBIUX',
                        'GIPI_USER_EVENTS_HIST_TBXIX',
                        'GIPI_WOPEN_CARGO_TBXIU2',
                        'GIPI_WPACK_LINE_SUBLINE_TAXDX',
                        'GIPI_WPICTURES_TBXIU2', 'GISM_MESSAGES_SENT_TBIXX',
                        'GISM_MESSAGES_SENT_DTL_TBIXX')
                AND table_owner = 'CPI')
   LOOP
      EXECUTE IMMEDIATE ('DROP TRIGGER CPI.' || i.trigger_name);
   END LOOP;
END;