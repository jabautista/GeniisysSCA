CREATE OR REPLACE PACKAGE BODY CPI.populate_fla_xol_giclr033_pkg AS

FUNCTION populate_giclr033_fla_xol_UCPB (
    p_pla_no        GICL_ADVS_PLA.PLA_SEQ_NO%TYPE
    )

    RETURN populate_reports_tab PIPELINED AS

    vrep            populate_reports_type;
    v_fla_no        gicl_advs_fla.fla_title%TYPE;
    v_ri_name       giis_reinsurer.ri_name%TYPE;
    v_ri_address    VARCHAR2(100);
    v_claim_id      VARCHAR2(100);

BEGIN
--select fla_no, ri_name, ri_address
    BEGIN
        SELECT (a.line_id||'-'||to_char(a.la_yy, '09')||to_char(a.pla_no, '0000009')) pla_no, b.ri_name,
               (b.mail_address1||chr(10)||b.mail_address2||chr(10)||b.mail_address3) ri_address, a.CLAIM_ID
              INTO vrep.wrd_pla_no,
                   vrep.wrd.ri_name,
                   vrep.wrd.ri_address,
                   v_claim_id
              FROM gicl_advs_fla a, giis_reinsurer b
             WHERE pla_seq_no = p_pla_no
               AND a.ri_cd = b.ri_cd;
        END;
        PIPE ROW(vrep);
    END populate_giclr033_fla_xol_UCPB;
END;
/

DROP PACKAGE CPI.POPULATE_FLA_XOL_GICLR033_PKG;
