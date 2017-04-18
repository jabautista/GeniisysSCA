CREATE OR REPLACE PACKAGE CPI.GIACR512_PKG
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.01.2013
    **  Reference By : GIACR512_PKG - PAID PREMIUM
    */
    TYPE giacr512_record_type IS RECORD(
        intermediary_no         NUMBER(12),
        policy_id               NUMBER(12),
        policy_no               VARCHAR2(4000),
        prem_seq_no             VARCHAR(20),
        acct_ent_date           DATE,
        line_cd                 VARCHAR2(2),
        peril_cd                NUMBER(5),
        prem_amt                NUMBER(12,2),
        comm_amt                NUMBER(12,2),
        FACUL_PCT               NUMBER(10,7),
        facul_prem              NUMBER(38),
        facul_comm              NUMBER(38),
        tran_id                 NUMBER(12),
        tran_doc                VARCHAR2(20),
        tran_date               DATE,
        intm_name               VARCHAR2(300),
        polbasic                VARCHAR2(300),
        peril                   VARCHAR2(100),
        company_name            giis_parameters.param_value_v%TYPE,
        company_address         VARCHAR2(4000),
        cf_year                 VARCHAR2(300),
        cf_iss_cd               VARCHAR2(300),
        cp_assd_name            VARCHAR2(500),
        cp_eff_date             DATE,
        cp_prem_amt             gipi_polbasic.prem_amt%TYPE,
        intermediary_no1        NUMBER(12),
        line_cd1                VARCHAR2(2), 
        peril_cd1               NUMBER(5),
        peril_name1             VARCHAR2(20),
        prem_amt_sum            NUMBER(38,2),
        comm_amt_sum            NUMBER(38,2),
        facul_prem_sum          NUMBER(38,2),
        facul_comm_sum          NUMBER(38,2),
        intm_name1              VARCHAR(300)           
    );
    
    TYPE giacr512_record_tab IS TABLE OF giacr512_record_type;
    
    FUNCTION get_giacr512_record(
        p_tran_year     VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_intm_no       NUMBER,
        p_user_id   giis_users.user_id%TYPE
    ) RETURN giacr512_record_tab PIPELINED;
    
    FUNCTION get_giacr512_record1(
        p_tran_year     VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_intm_no       NUMBER,
        p_user_id   giis_users.user_id%TYPE
    ) RETURN giacr512_record_tab PIPELINED;    

END;
/


