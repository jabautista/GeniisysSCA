package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACInquiryDAO {

	//GIACS070
	String giacs070WhenNewFormInstance() throws SQLException;
	Integer getOpInfoGiacs070(Integer tranId) throws SQLException;
	Integer chkPaytReqDtl (Integer tranId) throws SQLException;
	Map<String, Object> getDvInfoGiacs070(Map<String, Object> params) throws SQLException;
	String validateFundCdGiacs240(Map<String, Object> params) throws SQLException;
	String validateBranchCdGiacs240(Map<String, Object> params) throws SQLException;
	String validatePayeeClassCdGiacs240(String payeeClassCd) throws SQLException;
	Map<String, Object> validatePayeeNoGiacs240(Map<String, Object> params) throws SQLException;
	//GIACS241
	Map<String, Object> getDvAmount(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGiacs211BillDetails(Map<String, Object> params) throws SQLException; // andrew - 08042015 - SR 19643
}
