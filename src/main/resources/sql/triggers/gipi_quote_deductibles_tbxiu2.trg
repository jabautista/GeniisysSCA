/*
**  Created by       : Nieko B.
**  Date Created     : 04052016
**  Reference By     : UW-SPECS-2015-086 Quotation Deductibles
**  Description      : Set create_user and create_date
*/

CREATE OR REPLACE TRIGGER cpi.gipi_quote_deductibles_tbxiu2
   BEFORE INSERT
   ON cpi.gipi_quote_deductibles
   FOR EACH ROW
DECLARE
BEGIN	

   :NEW.create_user := NVL (giis_users_pkg.app_user, USER);
   :NEW.create_date := SYSDATE;
END;
/