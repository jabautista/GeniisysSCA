CREATE OR REPLACE PACKAGE CPI.giacr286_pkg AS

--Created by Benedict Castillo
TYPE giacr286_type IS RECORD(
    company_name            VARCHAR2(100),        
    company_address         giis_parameters.param_value_v%TYPE/*VARCHAR2(100)*/, --Deo [01.27.2017]: change data type (SR-23741)
    from_to                 VARCHAR2(100),
    flag                    VARCHAR2(2),
    iss_cd                  VARCHAR2(100),
    line                    VARCHAR2(100),
    intm                    VARCHAR2(1000),
    ref_date                giac_premium_colln_v.tran_date%TYPE,
    --ref_no                  giac_premium_colln_v.ref_no%TYPE,-- jhing GENQA 5298,5299 - 04.06.2016 replaced with: 
    ref_no                  VARCHAR2(500),
    policy_no               VARCHAR2(100),
    assd_name               giis_assured.assd_name%TYPE,
    incept_date             gipi_polbasic.incept_date%TYPE,
    bill_no                 VARCHAR2(100),
    collection_amt          giac_premium_colln_v.collection_amt%TYPE,
    premium_amt             giac_premium_colln_v.premium_amt%TYPE,
    tax_amt                 giac_premium_colln_v.tax_amt%TYPE
);
TYPE giacr286_tab IS TABLE OF giacr286_type;

FUNCTION populate_giacr286(
    p_cut_off_param     VARCHAR2,
    p_from_date         VARCHAR2,
    p_to_date           VARCHAR2,
    p_intm_no           VARCHAR2,
    p_line_cd           VARCHAR2,
    p_branch_cd         VARCHAR2,
    p_module_id         VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr286_tab PIPELINED;


END giacr286_pkg;
/


