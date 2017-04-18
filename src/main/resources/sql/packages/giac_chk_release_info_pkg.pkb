CREATE OR REPLACE PACKAGE BODY CPI.giac_chk_release_info_pkg
AS
/******************************************************************************
   NAME:        GIAC_CHK_RELEASE_INFO_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/20/2012   Irwin tabisora 1. Created this package.
******************************************************************************/


   FUNCTION get_giacs016_chk_release_info (
      p_gacc_tran_id   giac_chk_release_info.gacc_tran_id%TYPE,
	  p_item_no   giac_chk_release_info.item_no%TYPE
   )
      RETURN giac_chk_release_info_tab PIPELINED 
      is
      v_chk giac_chk_release_info_type;
      begin
        for i in (
            select check_release_date,check_released_by,check_received_by,or_no,or_date,gacc_tran_id,item_no
            from giac_chk_release_info where gacc_tran_id = p_gacc_tran_id and item_no = p_item_no
        )loop
             v_chk.gacc_tran_id          :=i.gacc_tran_id;
              v_chk.item_no              :=i.item_no;
              v_chk.check_release_date   :=i.check_release_date;
              v_chk.check_released_by    :=i.check_released_by;
              v_chk.check_received_by    :=i.check_received_by;
              v_chk.or_no                :=i.or_no;
              v_chk.or_date              :=i.or_date;
              pipe row(v_chk);
        end loop;
      
      end;
      
      
      
   FUNCTION validate_chk_release(
        p_tran_id           giac_chk_release_info.gacc_tran_id%TYPE,
        p_item_no           giac_chk_release_info.item_no%TYPE,
        p_check_pref_suf    giac_chk_release_info.check_pref_suf%TYPE,
        p_check_no          giac_chk_release_info.check_no%TYPE
   ) RETURN VARCHAR2
   IS
        v_exists        VARCHAR2(1) := 'N';
   BEGIN
        FOR gcri IN (SELECT '1'
                       FROM giac_chk_release_info
                      WHERE gacc_tran_id = p_TRAN_ID
                        AND item_no = p_item_no
                        AND NVL(check_pref_suf, '-') = NVL(p_check_pref_suf, NVL(check_pref_suf, '-'))
                        AND check_no = p_check_no) 
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        
        RETURN (v_exists);
        
   END;
   
  
   FUNCTION get_giacs002_chk_release_info(
        p_gacc_tran_id      giac_chk_release_info.gacc_tran_id%TYPE,
        p_item_no           giac_chk_release_info.item_no%TYPE
   ) RETURN giac_chk_release_info_tab PIPELINED
   IS
        v_info       giac_chk_release_info_type;
   BEGIN
   
        FOR i IN(SELECT gacc_tran_id, item_no, 
                        check_pref_suf, check_no,
                        check_release_date, check_released_by,
                        check_received_by, or_no, or_date,
                        user_id, last_update
                   FROM giac_chk_release_info
                  WHERE gacc_tran_id = p_gacc_tran_id
                    AND item_no = p_item_no)
        LOOP
            v_info.gacc_tran_id         := i.gacc_tran_id;
            v_info.item_no              := i.item_no;
            v_info.check_pref_suf       := i.check_pref_suf;
            v_info.check_no             := i.check_no;
            v_info.check_release_date   := i.check_release_date;
            v_info.check_released_by    := i.check_released_by;
            v_info.check_received_by    := i.check_received_by;
            v_info.or_no                := i.or_no;
            v_info.or_date              := i.or_date;
            v_info.user_id              := i.user_id;
            v_info.last_update          := i.last_update;
            
            PIPE ROW(v_info);
        END LOOP;
   
   END get_giacs002_chk_release_info;
   
   
   -- Kris modified 05.16.2013, used merge instead of insert
   PROCEDURE insert_chk_release_info(
        p_gacc_tran_id          giac_chk_release_info.gacc_tran_id%TYPE,
        p_item_no               giac_chk_release_info.item_no%TYPE,
        p_check_pref_suf       giac_chk_release_info.check_pref_suf%TYPE,
        p_check_no             giac_chk_release_info.check_no%TYPE,
        p_check_received_by    giac_chk_release_info.check_received_by%TYPE,
        p_check_release_date   giac_chk_release_info.check_release_date%TYPE,
        p_or_date              giac_chk_release_info.or_date%TYPE,
        p_check_released_by    giac_chk_release_info.check_released_by%TYPE,
        p_or_no                giac_chk_release_info.or_no%TYPE,
        p_user_id              giac_chk_release_info.user_id%TYPE,
        p_last_update          giac_chk_release_info.last_update%TYPE
   ) IS   
   BEGIN
        MERGE INTO giac_chk_release_info
        USING dual ON (gacc_tran_id = p_gacc_tran_id
                   AND      item_no = p_item_no)
         WHEN NOT MATCHED THEN   
                INSERT (gacc_tran_id,           item_no,
                        check_no,               check_release_date,
                        check_released_by,      check_received_by,
                        check_pref_suf,         or_no,
                        or_date,                user_id,
                        last_update,            clearing_date)
                VALUES (p_gacc_tran_id,           p_item_no,
                        p_check_no,               p_check_release_date,
                        p_check_released_by,      p_check_received_by,
                        p_check_pref_suf,         p_or_no,
                        p_or_date,                p_user_id,
                        SYSDATE,            NULL)
         WHEN MATCHED THEN
              UPDATE 
              SET check_release_date    = p_check_release_date,
                  check_released_by     = p_check_released_by,
                  check_received_by     = p_check_received_by,
                  or_no                 = p_or_no,
                  or_date               = p_or_date,
                  last_update           = SYSDATE,
                  user_id               = p_user_id;
   
   END insert_chk_release_info;
   
    
END giac_chk_release_info_pkg;
/


