DROP PROCEDURE CPI.CHECK_RISK_NOTE;

CREATE OR REPLACE PROCEDURE CPI.CHECK_RISK_NOTE(
    p_peril_cd          IN  GIPI_WOPEN_PERIL.peril_cd%TYPE,
    p_geog_cd           IN  GIPI_WOPEN_LIAB.geog_cd%TYPE,
    p_line_cd           IN  GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        IN  GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            IN  GIPI_WPOLBAS.iss_cd%TYPE,
    p_pol_seq_no        IN  GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_message           OUT VARCHAR2
)
IS
/*
**  Created by   : Marco Paolo Rebong
**  Date Created : November 13, 2012
**  Reference By : GIPIS078 - Enter Cargo Limit of Liability Endorsement Information
**  Description  : WHEN-VALIDATE-RECORD Trigger for GIPI_WOPEN_PERIL
*/

    v_eff_date          DATE := NULL;
    v_peril_cd          NUMBER(2);
    v_rec_flag          VARCHAR2(1);
BEGIN
    p_message := 'SUCCESS';

    SELECT MAX(b.eff_date),
           a.rec_flag
      INTO v_eff_date,
           v_rec_flag   
      FROM GIPI_OPEN_PERIL_V2 a,
           GIPI_POLBASIC b
     WHERE a.peril_cd = p_peril_cd
       AND a.geog_cd = p_geog_cd
       AND a.line_cd = p_line_cd
       AND a.op_subline_cd = p_subline_cd
       AND a.op_iss_cd = p_iss_cd
       AND a.op_pol_seqno = p_pol_seq_no
       AND a.policy_id = b.policy_id     
     GROUP BY a.rec_flag;
     
    IF v_rec_flag <> 'D' THEN
        p_message := 'There is an existing Risk Note using this peril'; 
    END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN        
      NULL;
END;
/


