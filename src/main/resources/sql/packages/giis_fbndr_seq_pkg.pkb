CREATE OR REPLACE PACKAGE BODY CPI.giis_fbndr_seq_pkg
AS
/*
     **  Created by       : Anthony Santos
     **  Date Created     : 06.29.2011
     **  Reference By     : (GIRIS026- Post FRPS
     **
     */
   PROCEDURE update_fbndr_seq_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   )
   IS
      v_binder_seq_no   giri_binder.binder_seq_no%TYPE;
      v_binder_yy       NUMBER;
   BEGIN
      SELECT MAX (binder_seq_no)
        INTO v_binder_seq_no
        FROM giri_binder t1, giri_frps_ri t2
       WHERE t1.fnl_binder_id = t2.fnl_binder_id
         AND t2.line_cd = p_line_cd
         AND t2.frps_yy = p_frps_yy
         AND t2.frps_seq_no = p_frps_seq_no;

      SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YY'))
        INTO v_binder_yy
        FROM DUAL;

      --IF v_binder_yy = p_frps_yy --commented out edgar 09/26/2014
      --THEN --commented out edgar 09/26/2014
         FOR a2 IN (SELECT fbndr_seq_no
                      FROM giis_fbndr_seq
                     WHERE line_cd = p_line_cd AND fbndr_yy = v_binder_yy)
         LOOP
            IF a2.fbndr_seq_no < v_binder_seq_no
            THEN
               UPDATE giis_fbndr_seq
                  SET fbndr_seq_no = v_binder_seq_no
                WHERE line_cd = p_line_cd AND fbndr_yy = v_binder_yy;
            END IF;
         END LOOP;
      --END IF; --commented out edgar 09/26/2014
   END update_fbndr_seq_giris026;
   
     /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Get values from GIIS_PARAMETERS and GIIS_FBNDR_SEQ.
     **                     If no record is fetched from GIIS_FBNDR_SEQ,
     **                     create a record for the line being processed.
     */
    PROCEDURE get_parameters_giuts004(
        p_line_cd       IN      giis_fbndr_seq.line_cd%TYPE,
        p_year          OUT     NUMBER,
        p_binder_id     OUT     giri_frps_ri.fnl_binder_id%TYPE,
        p_fbndr_seq_no  OUT     giis_fbndr_seq.fbndr_seq_no%TYPE
    ) 
    IS
    BEGIN
      SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YY'))
        INTO p_year
        FROM dual;


      SELECT binder_id_s.nextval
        INTO p_binder_id
        FROM dual;  

      BEGIN
        SELECT fbndr_seq_no + 1
          INTO p_fbndr_seq_no
          FROM giis_fbndr_seq
         WHERE line_cd  = p_line_cd
           AND fbndr_yy = p_year;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            INSERT INTO giis_fbndr_seq
              (line_cd, fbndr_yy, fbndr_seq_no, 
               user_id, last_update)
            VALUES
              (p_line_cd, p_year, 1,
               USER, SYSDATE);
          p_fbndr_seq_no := 1;
      END;
    END get_parameters_giuts004;
END;
/


