CREATE OR REPLACE PACKAGE CPI.Giis_Motortype_Pkg AS

  TYPE motortype_list_type IS RECORD
    (type_cd                 GIIS_MOTORTYPE.type_cd%TYPE,
     motor_type_desc         GIIS_MOTORTYPE.motor_type_desc%TYPE,
     subline_cd         	 GIIS_MOTORTYPE.subline_cd%TYPE,
     unladen_wt				 GIIS_MOTORTYPE.unladen_wt%TYPE);
  
  TYPE motortype_list_tab IS TABLE OF motortype_list_type; 
        
  FUNCTION get_motortype_list (p_subline    GIIS_SUBLINE.subline_cd%TYPE, p_find_text IN VARCHAR2) 
    RETURN motortype_list_tab PIPELINED;
    
  FUNCTION get_all_motortype_list 
    RETURN motortype_list_tab PIPELINED;
  
END Giis_Motortype_Pkg;
/


