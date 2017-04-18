DROP PROCEDURE CPI.CHECK_ADDTL_INFO;

CREATE OR REPLACE PROCEDURE CPI.check_addtl_info(p_par_id IN gipi_parlist.par_id%TYPE,
                                  p_pack_pol_flag IN GIPI_WPOLBAS.pack_pol_flag%TYPE) IS
                                  

   CURSOR A IS
       SELECT  a.item_no          a1_item_no,
               NVL(b.item_no, 0)  a2_item_no
         FROM  gipi_witem a, gipi_wfireitm b
        WHERE  a.item_no = b.item_no(+)
          AND  a.par_id = b.par_id (+)
          AND  a.ann_tsi_amt IS NULL
          AND  a.par_id = p_par_id;

   CURSOR B IS
       SELECT  a.item_no          a1_item_no,
               NVL(b.item_no, 0)  a2_item_no
         FROM  gipi_witem a, gipi_wfireitm b
        WHERE  a.item_no = b.item_no(+)
          AND  a.par_id = b.par_id (+)
          AND  upper(a.pack_line_cd) = 'FI'
          AND  a.ann_tsi_amt IS NULL
          AND  a.par_id = p_par_id;

   CURSOR ITEM IS 
          SELECT  item_no,rec_flag
            FROM  gipi_witem
           WHERE  par_id  = p_par_id;

   CURSOR FIRE (p_item_no  number) IS 
          SELECT  '1'
            FROM  gipi_wfireitm
           WHERE  par_id  = p_par_id
             AND  item_no = p_item_no;

   a_exist     VARCHAR2(1)   :=  'Y';
   a_no_exist  VARCHAR2(50)  :=  null;
   p_exists    VARCHAR2(1)   :=  'N';
BEGIN
  IF p_pack_pol_flag != 'Y' THEN
    FOR A1 IN A LOOP
      IF a1.a1_item_no != a1.a2_item_no THEN
         a_exist := 'N';
         a_no_exist := a_no_exist || TO_CHAR(a1.a1_item_no)|| ', ';
      END IF;
    END LOOP;
  ELSE
    FOR A IN ITEM LOOP
        p_exists := 'N';
        FOR B IN FIRE(a.item_no) LOOP
            p_exists := 'Y';
        END LOOP;
            if p_exists = 'N' and a.rec_flag = 'A' then
               a_no_exist := a_no_exist || TO_CHAR(a.item_no) || ', ';
            end if;
    END LOOP;
 
 END IF;
 
  IF a_no_exist is not null THEN
    RAISE_APPLICATION_ERROR('GENIISYS', 'Item(s) '||SUBSTR(a_no_exist,1, NVL(LENGTH(a_no_exist), 0)-2)||
              '  has no additional information.'||
              ' Please do the necessary changes.');
  END IF;
END;
/


