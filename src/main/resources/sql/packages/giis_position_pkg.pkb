CREATE OR REPLACE PACKAGE BODY CPI.Giis_Position_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011
  RECORD GROUP NAME: CGFK$B975_CAPACITY_CD
***********************************************************************************/

  FUNCTION get_position_list
    RETURN position_list_tab PIPELINED IS

	v_position		position_list_type;

  BEGIN
    FOR i IN (
		SELECT position, position_cd
		  FROM GIIS_POSITION
		 ORDER BY position)
	LOOP
		v_position.position		:= i.position;
		v_position.position_cd	:= i.position_cd;
	  PIPE ROW(v_position);
	END LOOP;

    RETURN;
  END;

  /*
  **  Created by    : Robert John Virrey
  **  Date Created  : May 14, 2012
  **  Reference By  : GIIMM002 - Enter Quotation Information
  **  Description   : CAPACITY LOV
  */
  FUNCTION get_capacity_lov
     RETURN position_list_tab PIPELINED
  IS
     v_position   position_list_type;
  BEGIN
     FOR i IN (SELECT position_cd, position
                 FROM giis_position)
     LOOP
        v_position.POSITION := i.POSITION;
        v_position.position_cd := i.position_cd;
        PIPE ROW (v_position);
     END LOOP;
     RETURN;
  END;

END Giis_Position_Pkg;
/


