CREATE OR REPLACE PROCEDURE CPI.giexs004_process_renewal (
   p_user_id          VARCHAR2,
   p_all_user         VARCHAR2,
   MESSAGE      OUT   VARCHAR2
)
IS
   v_auto_renew_sw   VARCHAR2 (1) := 'N';
   v_par_sw          VARCHAR2 (1) := 'N';
   v_rec_sw          VARCHAR2 (1) := 'N';
   v_switch          VARCHAR2 (1) := 'N';
   v_all_user        VARCHAR2(1)  := 'N'; --added by joanne 06.25.14, default all_user_sw is N
BEGIN
   BEGIN
     SELECT a.all_user_sw
       INTO v_all_user
       FROM giis_users a          
      WHERE a.user_id = p_user_id;
   END;

   FOR a IN (SELECT '1'
               FROM giex_expiries_v                --giex_expiry (gmi 061207)
              WHERE update_flag = 'Y' AND NVL (post_flag, 'N') = 'N')
   LOOP
      v_rec_sw := 'Y';

      -- renew
      FOR a2 IN (SELECT '1'
                   FROM giex_expiries_v            --giex_expiry (gmi 061207)
                  WHERE renew_flag = '2')
      LOOP
         v_par_sw := 'Y';
         EXIT;
      END LOOP;

      EXIT; -- andrew - 09082015 
      
-- comment out by andrew 09082015 - this is not used
--      -- auto renew
--      FOR a2 IN (SELECT '1'
--                   FROM giex_expiries_v             --giex_expiry (gmi 061207)
--                  WHERE renew_flag = '3')
--      LOOP
--         v_auto_renew_sw := 'Y';
--         EXIT;
--      END LOOP;
-- end andrew
   END LOOP;

   IF v_rec_sw = 'Y'
   THEN
      IF v_par_sw = 'Y'
      THEN
         FOR a IN (SELECT '1'
                     FROM giex_expiries_v          --giex_expiry (gmi 061207)
                    WHERE update_flag = 'Y'  -- andrew 09082015 - no need for NVL if only records with Y will be included in the result
                      AND NVL (post_flag, 'N') = 'N'
                      AND balance_flag = 'Y' -- andrew 09082015 - no need for NVL if only records with Y will be included in the result
                      AND processor = p_user_id)
         LOOP
            v_switch := 'Y';
            EXIT;
         END LOOP;

         IF v_switch = 'Y'
         THEN
            MESSAGE := '1';
         END IF;
      END IF;
   -- PROCESS_POST;
   ELSE
      raise_application_error ('-20001',
                               'Geniisys Exception#I#There are no records tagged for processing.'
                              );
   END IF;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX
   THEN
      raise_application_error
         ('-20001',
          'Geniisys Exception#I#Cannot insert record, duplicate records monitored, please call your DBA.'
         );
   WHEN NO_DATA_FOUND
   THEN
      raise_application_error ('-20001',
                               'Geniisys Exception#I#Cannot find record, please call your DBA.'
                              );
END;
/


