CREATE OR REPLACE PACKAGE BODY CPI.gipir902a_pkg
AS
   FUNCTION get_gipir902a (
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN gipir902a_tab PIPELINED
   IS
      v gipir902a_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, c.line_name, a.range_from,
                         a.range_to, a.policy_count, a.claim_count,
                         (  NVL (a.treaty_tsi, 0)
                          + NVL (a.treaty2_tsi, 0)
                          + NVL (a.treaty3_tsi, 0)
                          + NVL (a.treaty4_tsi, 0)
                          + NVL (a.treaty5_tsi, 0)
                          + NVL (a.treaty6_tsi, 0)
                          + NVL (a.treaty7_tsi, 0)
                          + NVL (a.treaty8_tsi, 0)
                          + NVL (a.treaty9_tsi, 0)
                          + NVL (a.treaty10_tsi, 0)
                          + NVL (a.facultative_tsi, 0)
                          + NVL (a.net_retention_tsi, 0)
                          + NVL (a.sec_net_retention_tsi, 0)
                          + NVL (a.quota_share_tsi, 0)
                         ) gross_tsi,
                         (  NVL (a.treaty, 0)
                          + NVL (a.treaty_prem, 0)
                          + NVL (a.treaty2_prem, 0)
                          + NVL (a.treaty3_prem, 0)
                          + NVL (a.treaty4_prem, 0)
                          + NVL (a.treaty5_prem, 0)
                          + NVL (a.treaty6_prem, 0)
                          + NVL (a.treaty7_prem, 0)
                          + NVL (a.treaty8_prem, 0)
                          + NVL (a.treaty9_prem, 0)
                          + NVL (a.treaty10_prem, 0)
                          + NVL (a.net_retention, 0)
                          + NVL (a.quota_share, 0)
                          + NVL (a.facultative, 0)
                         ) gross_prem,
--                         (  NVL (b.net_retention, 0)
--                          + NVL (b.quota_share, 0)
--                          + NVL (b.treaty, 0)
--                          + NVL (b.facultative, 0)
--                          + NVL (b.treaty2_loss, 0)
--                          + NVL (b.treaty3_loss, 0)
--                          + NVL (b.treaty4_loss, 0)
--                          + NVL (b.treaty5_loss, 0)
--                          + NVL (b.treaty6_loss, 0)
--                          + NVL (b.treaty7_loss, 0)
--                          + NVL (b.treaty8_loss, 0)
--                          + NVL (b.treaty9_loss, 0)
--                          + NVL (b.treaty10_loss, 0)
--                          + NVL (b.treaty1_loss, 0)
--                          + NVL (b.sec_net_retention_loss, 0)
--                         ) gross_loss, --commented out by gab 06.22.2016 SR 21538
                         a.net_retention_tsi retention_tsi,
                         a.net_retention retention_prem,
                         b.net_retention retention_loss,
                         (  NVL (a.treaty_tsi, 0)
                          + NVL (a.quota_share_tsi, 0)
                          + NVL (a.treaty2_tsi, 0)
                          + NVL (a.treaty3_tsi, 0)
                          + NVL (a.treaty4_tsi, 0)
                          + NVL (a.treaty5_tsi, 0)
                          + NVL (a.treaty6_tsi, 0)
                          + NVL (a.treaty7_tsi, 0)
                          + NVL (a.treaty8_tsi, 0)
                          + NVL (a.treaty9_tsi, 0)
                          + NVL (a.treaty10_tsi, 0)
                         ) treaty_tsi,
                         (  NVL (a.treaty, 0)
                          + NVL (a.quota_share, 0)
                          + NVL (a.treaty_prem, 0)
                          + NVL (a.treaty2_prem, 0)
                          + NVL (a.treaty3_prem, 0)
                          + NVL (a.treaty4_prem, 0)
                          + NVL (a.treaty5_prem, 0)
                          + NVL (a.treaty6_prem, 0)
                          + NVL (a.treaty7_prem, 0)
                          + NVL (a.treaty8_prem, 0)
                          + NVL (a.treaty9_prem, 0)
                          + NVL (a.treaty10_prem, 0)
                         ) treaty_prem,
                         (b.treaty + b.quota_share + b.xol_treaty
                         ) treaty_loss,
                         a.facultative_tsi facultative_tsi,
                         a.facultative facultative_prem,
                         b.facultative facultative_loss,
                         ( NVL(b.facultative, 0)
                         + NVL(b.treaty, 0) 
                         + NVL(b.quota_share, 0) 
                         + NVL(b.xol_treaty, 0)
                         + NVL(b.net_retention, 0)) gross_loss --added by gab 06.22.2016 
                    FROM gipi_risk_loss_profile a, gicl_risk_loss_profile b,
                         giis_line c
                   WHERE 1 = 1
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.line_cd = b.line_cd
                     AND a.line_cd = c.line_cd                     
                     AND NVL (a.subline_cd, '@@@') = NVL (b.subline_cd, '@@@')
                     AND NVL (a.subline_cd, '***') = NVL (p_subline_cd, '***')
                     AND a.user_id = b.user_id
                     AND a.user_id = UPPER (p_user_id)
                     AND a.date_from = b.date_from
                     AND a.date_from = TO_DATE(p_date_from, 'mm-dd-yyyy')
                     AND a.date_to = b.date_to
                     AND a.date_to = TO_DATE(p_date_to, 'mm-dd-yyyy')
                     AND a.all_line_tag IN ('Y', 'N')
                     AND a.loss_date_from = b.loss_date_from
                     AND a.loss_date_from = TO_DATE(p_loss_date_from, 'mm-dd-yyyy')
                     AND a.loss_date_to = b.loss_date_to
                     AND a.loss_date_to = TO_DATE(p_loss_date_to, 'mm-dd-yyyy')
                     AND a.range_from = b.range_from
                     AND a.range_to = b.range_to
                ORDER BY a.range_from ASC)
      LOOP         
         v.treaty_prem := NVL(i.treaty_prem, 0);
         v.line_cd := i.line_cd;
         v.line_name := i.line_name;
         v.range_from := i.range_from;
         v.range_to := i.range_to;
         v.policy_count := NVL(i.policy_count, 0);
         v.claim_count := NVL(i.claim_count, 0);
         v.gross_tsi := NVL(i.gross_tsi, 0);
         v.gross_prem := NVL(i.gross_prem, 0);
         v.gross_loss := NVL(i.gross_loss, 0);
         v.retention_tsi := NVL(i.retention_tsi, 0);
         v.retention_loss := NVL(i.retention_loss, 0);
         v.treaty_tsi := NVL(i.treaty_tsi, 0);
         v.retention_prem := NVL(i.retention_prem, 0);
         v.treaty_loss := NVL(i.treaty_loss, 0);
         v.facultative_tsi := NVL(i.facultative_tsi, 0);
         v.facultative_prem := NVL(i.facultative_prem, 0);
         v.facultative_loss := NVL(i.facultative_loss, 0);
         
         v.date_from := TRIM(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.date_to := TRIM(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_from := TRIM(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'YYYY');
         v.loss_date_to := TRIM(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'YYYY');
         
         IF TO_CHAR(i.range_to,'99,999,999,999,999.99') != TO_CHAR(99999999999999.99,'99,999,999,999,999.99') THEN
            v.cf_from := NULL;
         ELSE
            v.cf_from := 'OVER ';
         END IF;
         
         BEGIN
            SELECT MAX (range_to)
              INTO v.cf_to
              FROM gicl_loss_profile
             WHERE line_cd = p_line_cd
               AND NVL (subline_cd, '***') = UPPER (NVL (p_subline_cd, '***'))
               AND user_id = p_user_id
               AND range_to != 99999999999999.99;               
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
         
	      IF TO_CHAR(i.range_to, '99,999,999,999,999.99') != TO_CHAR(99999999999999.99,'99,999,999,999,999.99') THEN
   	      v.cf_to := NULL;   
	      END IF;
      
         PIPE ROW(v);
      END LOOP;
   END get_gipir902a;
END;
/


