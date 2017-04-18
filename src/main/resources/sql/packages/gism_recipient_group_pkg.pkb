CREATE OR REPLACE PACKAGE BODY CPI.GISM_RECIPIENT_GROUP_PKG
AS

   FUNCTION get_gisms004_group_lov
     RETURN recipient_group_tab PIPELINED
   IS
      v_row                      recipient_group_type;
   BEGIN
      FOR i IN(SELECT group_cd, group_name
                 FROM GISM_RECIPIENT_GROUP)
      LOOP
         v_row.group_cd := i.group_cd;
         v_row.group_name := i.group_name;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_gisms004_recipient_lov(
      p_group_cd                 GISM_RECIPIENT_GROUP.group_cd%TYPE,
      p_bday_sw                  GISM_MESSAGES_SENT.bday_sw%TYPE,
      p_from_date                DATE,
      p_to_date                  DATE,
      p_default                  VARCHAR2,
      p_globe                    VARCHAR2,
      p_smart                    VARCHAR2,
      p_sun                      VARCHAR2
   )
     RETURN recipient_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;
      cur                        cur_typ;
      v_row                      recipient_type;
      v_group_name               GISM_RECIPIENT_GROUP.group_name%TYPE;
      v_bday_table               GISM_RECIPIENT_GROUP.bday_table%TYPE;
      ctr                        NUMBER;
      v_type                     VARCHAR2(32000) := NULL;
      v_select				         VARCHAR2(32000) := NULL;
      v_select2                  VARCHAR2(32000) := NULL;
   BEGIN
      FOR i IN(SELECT group_cd, group_name, table_name, name_column, cp_column, bday_column,
                      type_column, type_value, globe_column, smart_column, sun_column, bday_table, pk_column
                 FROM GISM_RECIPIENT_GROUP
                WHERE group_cd = p_group_cd)
      LOOP
         v_group_name := i.group_name;

         IF i.type_column IS NOT NULL THEN
		      v_type  := ' AND '||i.type_column||' = '||''''||i.type_value||''' ';
	      END IF;
         
         IF p_bday_sw = 'Y' AND i.bday_table IS NOT NULL THEN
            v_select :=  ' FROM '|| i.table_name
                      ||' WHERE '|| i.pk_column || ' IN (SELECT ' || i.pk_column
	   		          									||	      ' FROM ' || i.bday_table 
	   		          									||      ' WHERE TO_NUMBER(TO_CHAR('||i.bday_column||',''MMDD''))';
                                                
            IF TO_NUMBER(TO_CHAR(p_from_date,'MMDD')) <= TO_NUMBER(TO_CHAR(p_to_date,'MMDD')) THEN
               v_select := v_select || ' BETWEEN TO_NUMBER(TO_CHAR(TO_DATE('''||p_from_date||''',''DD-MON-RR''),''MMDD''))' 
				    						||        ' AND TO_NUMBER(TO_CHAR(TO_DATE('''||p_to_date||''',''DD-MON-RR''),''MMDD''))'
					                  ||        ' AND ' || i.bday_column || ' IS NOT NULL  '					 
                                 || v_type ||' )';
            ELSE
               v_select := v_select || ' BETWEEN TO_NUMBER(TO_CHAR(TO_DATE('''||p_from_date||''',''DD-MON-RR''),''MMDD''))' 
		 	                        ||        ' AND 1231 OR TO_NUMBER(TO_CHAR('||i.bday_column||',''MMDD''))'
		 	                        ||    ' BETWEEN 0101'
                                 ||        ' AND TO_NUMBER(TO_CHAR(TO_DATE('''||p_to_date||''',''DD-MON-RR''),''MMDD''))'
					                  ||        ' AND ' || i.bday_column || ' IS NOT NULL  '					 
					                  || v_type ||' )';
            END IF;
            
            GISM_RECIPIENT_GROUP_PKG.create_select(v_select, i.name_column, i.cp_column, i.globe_column, i.smart_column, i.sun_column,
                                                   p_default, p_globe, p_smart, p_sun, i.pk_column);
         ELSIF p_bday_sw = 'N' OR p_bday_sw IS NULL THEN
            v_select := ' FROM '||i.table_name
  					 	   ||' WHERE 1=1 '
							||v_type;
                     
            GISM_RECIPIENT_GROUP_PKG.create_select(v_select, i.name_column, i.cp_column, i.globe_column, i.smart_column, i.sun_column,
                                                   p_default, p_globe, p_smart, p_sun, i.pk_column);
         END IF;
      END LOOP;
      
      IF v_select IS NOT NULL THEN
         OPEN cur FOR v_select;
         
         LOOP
            FETCH cur
             INTO v_row.recipient, v_row.cellphone_no, v_row.pk_column_value;
            
            v_row.group_cd := p_group_cd;
            v_row.group_name := v_group_name;
            
            EXIT WHEN cur%NOTFOUND;
            
            PIPE ROW(v_row);
         END LOOP;
         
         CLOSE cur;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   
   PROCEDURE create_select(
      p_select          IN OUT   VARCHAR2,
      p_name_column     IN       VARCHAR2,
      p_cp_column       IN       VARCHAR2,
      p_globe_column    IN       VARCHAR2,
      p_smart_column    IN       VARCHAR2,
      p_sun_column      IN       VARCHAR2,
      p_default         IN       VARCHAR2,
      p_globe           IN       VARCHAR2,
      p_smart           IN       VARCHAR2,
      p_sun             IN       VARCHAR2,
      p_pk_column       IN       VARCHAR2
   )
   IS
      v_select2                  VARCHAR2(32000) := NULL;
   BEGIN
      IF p_default = 'Y' AND p_cp_column IS NOT NULL THEN
         v_select2 := 'SELECT DISTINCT '||p_name_column||' name_column, '||p_cp_column||' cp_column, '||p_pk_column||' pk_column '||
      				    p_select||' AND '||p_cp_column||' IS NOT NULL';
      END IF;
      
      IF p_globe = 'Y' AND p_globe_column IS NOT NULL THEN
         IF v_select2 IS NULL THEN
            v_select2 := 'SELECT DISTINCT '||p_name_column||' name_column, '||p_globe_column||' cp_column, '||p_pk_column||' pk_column '||
	                      p_select||' AND '||p_globe_column||' IS NOT NULL';
         ELSE
  	  	      v_select2 := v_select2||' UNION SELECT DISTINCT '||p_name_column||' name_column, '||p_globe_column||' cp_column, '||p_pk_column||' pk_column '||
  	  	                   p_select||' AND '||p_globe_column||' IS NOT NULL';
         END IF;
      END IF;
      
      IF p_smart = 'Y' AND p_smart_column IS NOT NULL THEN
         IF v_select2 IS NULL THEN
            v_select2 := 'SELECT DISTINCT '||p_name_column||' name_column, '||p_smart_column||' cp_column, '||p_pk_column||' pk_column '||
	                      p_select||' AND '||p_smart_column||' IS NOT NULL';
         ELSE                                                                                
            v_select2 := v_select2||' UNION SELECT DISTINCT '||p_name_column||' name_column, '||p_smart_column||' cp_column, '||p_pk_column||' pk_column '||
  	  	                   p_select||' AND '||p_smart_column||' IS NOT NULL';  	  	 
         END IF;
      END IF;
      
      IF p_sun = 'Y' AND p_sun_column IS NOT NULL THEN
         IF v_select2 IS NULL THEN
            v_select2 := 'SELECT DISTINCT '||p_name_column||' name_column, '||p_sun_column||' cp_column, '||p_pk_column||' pk_column '||
	                      p_select||' AND '||p_sun_column||' IS NOT NULL';
         ELSE                                                                                
            v_select2 := v_select2||' UNION SELECT DISTINCT '||p_name_column||' name_column, '||p_sun_column||' cp_column, '||p_pk_column||' pk_column '||
  	  	                   p_select||' AND '||p_sun_column||' IS NOT NULL';
         END IF;
      END IF;
      
      p_select := v_select2;
   END;

END;
/


