CREATE OR REPLACE PACKAGE CPI.GICLR204F_pkg
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 08.06.2013
    **  Reference By : GICLR204F_PKG - LOSS RATIO BY PERIL
    */
    TYPE giclr204f_type IS RECORD (
            peril_cd NUMBER(5),
            line_cd  VARCHAR2(2),
            loss_ratio_date DATE,
            curr_prem_amt   NUMBER(16,2),
            prem_res_cy     NUMBER(16,2),
            prem_res_py     NUMBER(16,2),
            loss_paid_amt   NUMBER(16,2),
            curr_loss_res   NUMBER(16,2),
            prev_loss_res   NUMBER(16,2),
            premiums_earned NUMBER(16,2),
            losses_incurred  NUMBER(16,2),
                   company_name VARCHAR2(200),
                   address      VARCHAR2(300),
                   as_of        VARCHAR2(100),
                   param_line   VARCHAR2(100),
                   peril_name   VARCHAR2(100),
                   ratio        NUMBEr(16,4),
                        line_name   VARCHAR2(100),
                        subline_name VARCHAR2(100),
                        iss_name    VARCHAR2(100),
                        assd_name   VARCHAR2(300),
                        intm_name   VARCHAR2(100)
                   
    );
    TYPE giclr204f_tab IS TABLE OF giclr204f_type;
    
    FUNCTION get_giclr204f_record (
    p_session_id NUMBER,
    p_date VARCHAR2,
    p_line  VARCHAR2,
    p_subline_cd VARCHAR2,
    p_iss_cd VARCHAR2,
    p_assd_no NUMBER,
    p_intm_no NUMBER
    
    )
    RETURN giclr204f_tab PIPELINED;
END;
/


