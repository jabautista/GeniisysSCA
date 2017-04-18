CREATE OR REPLACE PACKAGE BODY CPI.populate_pla_xol_giclr028_pkg AS

FUNCTION populate_pla_xol_giclr028_UCPB (
   p_pla_seq_no     GICL_ADVS_PLA.PLA_SEQ_NO%TYPE
   )

  RETURN populate_reports_tab PIPELINED AS
  vrep              populate_reports_type;
  v_ri_name         GIIS_REINSURER.ri_name%TYPE;
  v_ri_address      VARCHAR2(200);
  v_pla_no          VARCHAR2(32767);
  v_xortitle        VARCHAR2(2000);


  BEGIN
    SELECT  (line_cd||'-'||to_char(la_yy,'09')||'-'||to_char(pla_seq_no,'00000009')) pla_no
    INTO    v_pla_no
    FROM    GICL_ADVS_PLA
    WHERE   PLA_SEQ_NO = p_pla_seq_no;
        IF (v_pla_no IS NOT NULL) THEN
            SELECT  ri_name,
                    (b.mail_address1||chr(10)||b.mail_address2||chr(10)||b.mail_address3) ri_address
            INTO    v_ri_name,
                    v_ri_address
            FROM    GIIS_REINSURER b, GICL_ADVS_PLA a
            WHERE   A.RI_CD = B.RI_CD;
        END IF;

        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;



  PIPE ROW (vrep);
 END populate_pla_xol_giclr028_UCPB;

 END;
/


