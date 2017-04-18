/* Created by   : Gab
 * Date Created : 10-13-2016
 * Remarks        : GIPI_WITEM - to set null item_grp inserted in GIPI_WITEM to 1
 */

CREATE OR REPLACE TRIGGER CPI.GIPI_WITEM_TBIU
BEFORE INSERT OR UPDATE ON CPI.GIPI_WITEM FOR EACH ROW
DECLARE
BEGIN
      IF :new.item_grp IS NULL
      THEN
        :new.item_grp := 1;
      
      END IF;
END;