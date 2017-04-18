CREATE OR REPLACE PACKAGE CPI.giclr276_pkg
AS
    TYPE giclr276_report_type IS RECORD(
        company_name       VARCHAR2(500),
        company_address    VARCHAR2(500),
        report_title       VARCHAR2(50),
        date_title         VARCHAR2(100),
        lawyer             VARCHAR2(600),
        claim_no           VARCHAR2(30),
        policy_no          VARCHAR2(30),
        assured_name       VARCHAR2(500),
        dsp_loss_date      DATE,
        clm_file_date      DATE,
        rec_no             VARCHAR2(30),
        case_no            VARCHAR2(100),
        court              VARCHAR2(200),
        rec_status         VARCHAR2(20),
        recoverable_amt    NUMBER(16,2),
        recovered_amt      NUMBER(16,2)
    );
    TYPE giclr276_report_tab IS TABLE OF giclr276_report_type;
    FUNCTION populate_giclr276 (
         p_rec_type_cd     VARCHAR2,
         p_search_by       NUMBER,
         p_as_of_date      VARCHAR2,
         p_from_date       VARCHAR2,
         p_to_date         VARCHAR2,
         p_lawyer_cd       NUMBER,
         p_lawyer_class_cd VARCHAR2,
         p_user_id         VARCHAR2
    )
    RETURN giclr276_report_tab PIPELINED;
END;
/


