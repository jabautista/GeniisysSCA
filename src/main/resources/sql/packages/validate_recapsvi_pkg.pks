CREATE OR REPLACE PACKAGE validate_recapsvi_pkg
AS
/* Created by   : Benjo Brito
** Date Created : 06.01.2015
** Remarks      : Additional package; validation to address GENQA AFPGEN_IMPLEM SR 4150
*/
   PROCEDURE check_records_recapsvi (
      p_user_id     IN       giis_users.user_id%TYPE,
      p_from_date   IN       VARCHAR2,
      p_to_date     IN       VARCHAR2,
      p_error       OUT      VARCHAR2,
      p_message     OUT      VARCHAR2
   );
END validate_recapsvi_pkg;
/