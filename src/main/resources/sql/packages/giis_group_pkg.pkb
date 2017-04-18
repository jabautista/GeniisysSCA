CREATE OR REPLACE PACKAGE BODY CPI.giis_group_pkg
AS
   FUNCTION get_giis_group_list (p_assd_no giis_assured_group.assd_no%TYPE)
      RETURN giis_group_list_tab PIPELINED
   IS
      v_group   giis_group_list_type;
   BEGIN
      FOR i IN (SELECT   a.group_cd, a.group_desc
                    FROM giis_group a
                   WHERE EXISTS (
                            SELECT '1'
                              FROM giis_assured_group b
                             WHERE b.group_cd = a.group_cd
                               AND b.assd_no = p_assd_no)
                ORDER BY UPPER (a.group_desc))
      LOOP
         v_group.group_cd := i.group_cd;
         v_group.group_desc := i.group_desc;
         PIPE ROW (v_group);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_all_giis_group_list
      RETURN giis_group_list_tab PIPELINED
   IS
   	 v_group    giis_group_list_type;
   BEGIN
     FOR i IN (SELECT   a.group_cd, a.group_desc
                 FROM giis_group a
                   /*WHERE EXISTS (
                            SELECT '1'
                              FROM giis_assured_group b
                             WHERE b.group_cd = a.group_cd)*/ --commented by: Nica 05.15.2012 to correct LOV for GIISS006B
                ORDER BY UPPER (a.group_desc))
      LOOP
         v_group.group_cd := i.group_cd;
         v_group.group_desc := i.group_desc;
         PIPE ROW (v_group);
      END LOOP;

      RETURN;
   END;
END;
/


