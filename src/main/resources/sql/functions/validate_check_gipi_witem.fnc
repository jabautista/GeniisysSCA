DROP FUNCTION CPI.VALIDATE_CHECK_GIPI_WITEM;

CREATE OR REPLACE FUNCTION CPI.Validate_Check_Gipi_Witem (	
	P_CHECK_BOTH IN NUMBER,		/* Check FKs validated in BOTH (client */
	P_PAR_ID     IN NUMBER,		/* Item value                          */
	P_ITEM_NO    IN NUMBER 		/* Item value                          */)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Validate that the deletion of the record is permitted
	**					  by checking for the existence of rows in related tables.
	*/
	CG$DUMMY 	VARCHAR2(1);  /* (null) */
	v_result	VARCHAR2(70);
BEGIN
	IF (P_CHECK_BOTH = 1) THEN
		/* Deletion of GIPI_WITEM prevented if GIPI_WCASUALTY_ITEM records */
		/* Foreign key(s): WITEM_WCASUALTY_ITEM_FK                         */
		DECLARE
			CURSOR C IS
				SELECT '1'
				  FROM GIPI_WCASUALTY_ITEM B720
				 WHERE B720.PAR_ID = P_PAR_ID
				   AND B720.ITEM_NO = P_ITEM_NO;
		BEGIN
			OPEN C;
			FETCH C
			INTO CG$DUMMY;
			IF C%FOUND THEN				
				v_result := 'Cannot delete GIPI_WITEM while dependent GIPI_WCASUALTY_ITEM exists';
			END IF;
			CLOSE C;
		EXCEPTION
			WHEN OTHERS THEN
				--CGTE$OTHER_EXCEPTIONS;
				v_result := 'Other Exception Occured';
		END; 		
	END IF;
	RETURN v_result;
END;
/


