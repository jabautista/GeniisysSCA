/* Created by   : Gab
 * Date Created : 10-13-2016
 * Remarks        : GIPI_ITEM - to set null item_grp inserted in GIPI_ITEM to 1
 */

CREATE OR REPLACE TRIGGER CPI.GIPI_ITEM_TBIU
BEFORE INSERT OR UPDATE ON CPI.GIPI_ITEM FOR EACH ROW
DECLARE
BEGIN
      IF :new.item_grp IS NULL
      THEN
        :new.item_grp := 1;
      
      END IF;
END;