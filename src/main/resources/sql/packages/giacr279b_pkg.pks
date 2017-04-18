CREATE OR REPLACE PACKAGE CPI.giacr279b_pkg
AS
    TYPE giacr279b_record_type IS RECORD (
        ri_cd             NUMBER (5),
        ri_name           VARCHAR2 (50),
        line_cd           VARCHAR2 (2),
        line_name         VARCHAR2 (20),
        claim_no          VARCHAR2 (30),
        fla_no            VARCHAR2 (15),
        policy_no         VARCHAR2 (30),
        assd_no           GIAC_LOSS_REC_SOA_EXT.ASSD_NO%TYPE, --CarloR SR-5351 06.27.2016
        assd_name         VARCHAR2 (500),
        fla_date          DATE,
        as_of_date        DATE,
        cut_off_date      DATE,
        payee_type        VARCHAR2 (1),
        amount_due        NUMBER (16, 2),
        currency_cd       NUMBER (2),
        orig_curr_rate    NUMBER (12, 9),
        convert_rate      NUMBER (12, 9),
        short_name        VARCHAR2 (3),
        company_name      VARCHAR2 (200),
        company_address   VARCHAR2 (200),
        loss_exp          VARCHAR2 (20),
        as_of             VARCHAR2 (200),
        cut_off           VARCHAR2 (200),
        amt_due           NUMBER (20,2),
        v_as_of_date      DATE,
        v_cut_off_date    DATE,
        print_band        VARCHAR2(1)
    );

    TYPE giacr279b_record_tab IS TABLE OF giacr279b_record_type;

    FUNCTION get_giacr279b_records (
        p_as_of_date        VARCHAR2, 
        p_cut_off_date      VARCHAR2, 
        p_line_cd           VARCHAR2, 
        p_payee_type        VARCHAR2, 
        p_payee_type2       VARCHAR2, 
        p_ri_cd             VARCHAR2, 
        p_user_id           VARCHAR2
    ) RETURN giacr279b_record_tab PIPELINED;
END;
/


