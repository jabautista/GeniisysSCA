CREATE OR REPLACE PACKAGE CPI.VALIDATE_RENEWAL
AS
    /*   NAME:               FUNCTION CHECK_DIST
    **  DESCRIPTION:    This function will check the distribution applied on the original policy
    **                           this will return 1 - 100% Net Retention and 0 - otherwise
    **  MODIFIED:
    */
    FUNCTION CHECK_DIST(p_policy_id  NUMBER)
        RETURN NUMBER;

    /*   NAME:               FUNCTION VALIDATE_POSTING_LIMIT
    **  DESCRIPTION:    This function will check is posting user has an allowable posting limit with that of the policy
    **  MODIFIED:
    */ 
    FUNCTION POSTING_LIMIT(p_user VARCHAR2
                                                            , p_iss_cd  VARCHAR2
                                                            , p_line_cd VARCHAR2
                                                            , p_tsi_amt VARCHAR2)
        RETURN NUMBER;
END VALIDATE_RENEWAL;
/


