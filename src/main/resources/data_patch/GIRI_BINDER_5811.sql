/* benjo brito 12.15.2016 SR-5811 */
BEGIN
   FOR i IN (SELECT fnl_binder_id
               FROM giri_binder
              WHERE bndr_stat_cd = 'CN' AND reverse_date IS NOT NULL)
   LOOP
      UPDATE giri_binder
         SET bndr_stat_cd = NULL
       WHERE fnl_binder_id = i.fnl_binder_id;
   END LOOP;

   COMMIT;
END;