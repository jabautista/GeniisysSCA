CREATE OR REPLACE PACKAGE CPI.GIACR157_PKG
AS
    TYPE giacr157_booked_type IS RECORD (
        or_pref_suf       VARCHAR2(5),            
        orno              NUMBER(10),
        or_no             VARCHAR2(20),
        incept_date       DATE,
        policy_no         VARCHAR2(50),
        b140_iss_cd       VARCHAR2(2),
        b140_prem_seq_no  NUMBER(12),
        inst_no           NUMBER(2),
        tran_date         DATE,
        collection_amt    NUMBER(12,2),
        tran_flag         VARCHAR2(1),
        posted            NUMBER(12,2),  
        unposted          NUMBER(12,2),
        posting_date      DATE,
        par_id            NUMBER(12),
        assd_no           NUMBER(12),
        assd_name         VARCHAR2(500),
        intm_no           NUMBER(12),
        line_cd           VARCHAR2(2),
        subline_cd        VARCHAR2(7),
        iss_cd            VARCHAR2(2),
        issue_yy          NUMBER(2),
        pol_seq_no        NUMBER(7),
        endt_seq_no       NUMBER(6),
        flag              VARCHAR2(1),
        intm_name         VARCHAR2(250)
    );
    
    TYPE giacr157_booked_tab IS TABLE OF giacr157_booked_type;
    
    FUNCTION get_giacr157_booked_tab(
        p_assd_no         VARCHAR2,
        p_intm_no         VARCHAR2,    
        p_pfrom_date      DATE,
        p_pto_date        DATE,
        p_cfrom_date      DATE,
        p_cto_date        DATE,
        p_or_no           VARCHAR2,
        p_user_id       VARCHAR2
        )
    RETURN giacr157_booked_tab PIPELINED;
    
    TYPE giacr157_unbooked_type IS RECORD (
        or_pref_suf       VARCHAR2(5),            
        orno              NUMBER(10),
        or_no             VARCHAR2(20),
        incept_date       DATE,
        policy_no         VARCHAR2(50),
        b140_iss_cd       VARCHAR2(2),
        b140_prem_seq_no  NUMBER(12),
        inst_no           NUMBER(2),
        tran_date         DATE,
        collection_amt    NUMBER(12,2),
        tran_flag         VARCHAR2(1),
        posted            NUMBER(12,2),  
        unposted          NUMBER(12,2),
        posting_date      DATE,
        par_id            NUMBER(12),
        assd_no           NUMBER(12),
        assd_name         VARCHAR2(500),
        intm_no           NUMBER(12),
        line_cd           VARCHAR2(2),
        subline_cd        VARCHAR2(7),
        iss_cd            VARCHAR2(2),
        issue_yy          NUMBER(2),
        pol_seq_no        NUMBER(7),
        endt_seq_no       NUMBER(6),
        flag              VARCHAR2(1),
        intm_name         VARCHAR2(250)
               
    );
    
    TYPE giacr157_unbooked_tab IS TABLE OF giacr157_unbooked_type;

    FUNCTION get_giacr157_unbooked_tab(
        p_assd_no         VARCHAR2,
        p_intm_no         VARCHAR2,    
        p_cfrom_date      DATE,
        p_cto_date        DATE,
        p_or_no           VARCHAR2,
        p_user_id       VARCHAR2
        )
    RETURN giacr157_unbooked_tab PIPELINED;    
    
    
    TYPE giacr157_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250),
        report_title        VARCHAR2(250),
        p_report_header     VARCHAR2(250),
        c_report_header     VARCHAR2(250),
        v_col_total         NUMBER(16,2),
        v_post_total        NUMBER(16,2),
        v_unpost_total      NUMBER(16,2),
        v_booked_count      NUMBER(10),
        v_unbooked_count    NUMBER(10)
    );
    
    TYPE giacr157_header_tab IS TABLE OF giacr157_header_type;
    
    FUNCTION get_giacr157_header(
        v_report_title    VARCHAR2,
        p_pfrom_date      DATE,
        p_pto_date        DATE,
        p_cfrom_date      DATE,
        p_cto_date        DATE,
        p_assd_no         VARCHAR2,
        p_intm_no         VARCHAR2,
        p_or_no           VARCHAR2,
        p_user_id       VARCHAR2 
    )
        RETURN giacr157_header_tab PIPELINED;
END;
/


