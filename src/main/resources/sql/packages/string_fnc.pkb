CREATE OR REPLACE PACKAGE BODY CPI.STRING_FNC
IS

   FUNCTION SPLIT (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array 
   IS
   
      i       number :=0;
      pos     number :=0;
      lv_str  varchar2(32000) := p_in_string;
      
   strings t_array;
   
   BEGIN
   
      -- determine first chuck of string  
      pos := instr(lv_str,p_delim,1,1);
   
      -- while there are chunks left, loop 
      WHILE ( pos != 0) LOOP
         
         -- increment counter 
         i := i + 1;
         
         -- create array element for chuck of string 
         strings(i) := substr(lv_str,1,pos);
         
         -- remove chunk from string 
         lv_str := substr(lv_str,pos+1,length(lv_str));
         
         -- determine next chunk 
         pos := instr(lv_str,p_delim,1,1);
         
         -- no last chunk, add to array 
         IF pos = 0 THEN
        
            strings(i+1) := lv_str;
         
         END IF;
      
	      strings(i) := replace(strings(i), ',', '');
      END LOOP;
   
      -- return array 
      RETURN strings;
      
   END SPLIT;

END;
/


