DROP FUNCTION CPI.CALC_PREM_DEP;

CREATE OR REPLACE FUNCTION CPI.calc_prem_dep (
   p_par_id            NUMBER,
   calc_dep_line_cd    VARCHAR2,
   calc_dep_peril_cd   NUMBER,
   n_terms             NUMBER,
   takeup_val          NUMBER,
   amount_in           NUMBER
)
   RETURN NUMBER
IS

   amount_out           NUMBER := 0;

   FUNCTION get_perl_dep_rate (
      v_dep_line_cd    IN   VARCHAR2,
      v_dep_peril_cd   IN   NUMBER
   )
      RETURN NUMBER
   IS
      v_perl_dep_rate   NUMBER := 1;
   BEGIN
      BEGIN
         SELECT NVL (rate / 100, 1)
           INTO v_perl_dep_rate
           FROM giex_dep_perl
          WHERE line_cd = v_dep_line_cd AND peril_cd = v_dep_peril_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_perl_dep_rate := 1;
      END;

      RETURN (v_perl_dep_rate);
   END;

   FUNCTION depreciation_applied (
      p_par_id   IN   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_dep_applied   VARCHAR2(1):= 'N';
   BEGIN
      BEGIN
         SELECT NVL(dep_flag,'N')
           INTO v_dep_applied
           FROM gipi_wpolbas
          WHERE par_id = p_par_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_dep_applied := 'N';
      END;

      RETURN (v_dep_applied);
   END;
BEGIN
   IF get_perl_dep_rate (calc_dep_line_cd, calc_dep_peril_cd) = 1 OR depreciation_applied(p_par_id)='N'
   THEN

         amount_out := amount_in / n_terms; -- prem divided by no_of_take_up  if no depreciation

   ELSE --else depreciate the pemium

         amount_out :=
              (  amount_in
               * get_perl_dep_rate (calc_dep_line_cd, calc_dep_peril_cd)
               / (  1
                  - POWER (  1
                           - get_perl_dep_rate (calc_dep_line_cd,
                                                calc_dep_peril_cd
                                               ),
                           n_terms
                          )
                 )
              )
            * (POWER (  1
                      - get_perl_dep_rate (calc_dep_line_cd,
                                           calc_dep_peril_cd),
                      takeup_val - 1
                     )
              );

   END IF;

   RETURN (amount_out);
END calc_prem_dep;
/


