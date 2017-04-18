DROP FUNCTION CPI.GET_INTM_NO_NAME;

CREATE OR REPLACE FUNCTION CPI.get_intm_no_name(p_intm_no giis_intermediary.intm_no%type)
  RETURN VARCHAR2 AS
/*
**  Created by :    Benedick Espera
**  Date Created:   07-28-2014
**  Purpose:        Retrieves the agent/intermediary details (concatenation of INTM_NO AND INTM_NAME)
*/

  v_intm_name          giis_intermediary.intm_name%type;
  v_parent_intm_name   giis_intermediary.intm_name%type;
  v_parent_intm_no     giis_intermediary.parent_intm_no%type;
  v_lic_tag            giis_intermediary.lic_tag%type;
  v_intm_no_name       VARCHAR2(500);

BEGIN

  FOR i IN (select lic_tag, parent_intm_no, intm_name
              from giis_intermediary
             where intm_no = p_intm_no)
  LOOP
    v_lic_tag := i.lic_tag;
    v_parent_intm_no := i.parent_intm_no;
    v_intm_name := i.intm_name;
  END LOOP;

  /* If parent_intm_no is not equal to the specified intm_no and is not null,
  ** display parent_intm_no and corresponding intm_name / specified intm_no and corresponding intm_name
  ** else, specified intm_no and corresponding intm_name only
  */
  if v_lic_tag = 'N' and v_parent_intm_no is not null then
     
     FOR x IN (select intm_name 
                 from giis_intermediary
                where intm_no = v_parent_intm_no)
               
     LOOP
        v_parent_intm_name := x.intm_name;
     END LOOP; 
       
        v_intm_no_name := (v_parent_intm_no || ' - ' || v_parent_intm_name || ' / ' ||
                           p_intm_no || ' - ' || v_intm_name);
                           
  else
        v_intm_no_name := (p_intm_no || ' - ' || v_intm_name);
   
  end if;
 
  return(v_intm_no_name);
    
END;
/


