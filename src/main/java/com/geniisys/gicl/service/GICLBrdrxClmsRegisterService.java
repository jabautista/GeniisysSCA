package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.text.ParseException;
import javax.servlet.http.HttpServletRequest;

public interface GICLBrdrxClmsRegisterService {

	String whenNewFormInstanceGicls202(HttpServletRequest request) throws SQLException;
	String whenNewBlockE010Gicls202(HttpServletRequest request, String userId) throws SQLException;
	String getPolicyNumberGicls202(HttpServletRequest request, String userId) throws SQLException;
	String extractGicls202(HttpServletRequest request, String userId) throws SQLException, ParseException;
	String validateLineCd2GIcls202(HttpServletRequest request) throws SQLException;
	String validateSublineCd2Gicls202(HttpServletRequest request) throws SQLException;
	String validateIssCd2Gicls202(HttpServletRequest request) throws SQLException;
	String validateLineCdGIcls202(HttpServletRequest request) throws SQLException;
	String validateSublineCdGicls202(HttpServletRequest request) throws SQLException;
	String validateIssCdGicls202(HttpServletRequest request) throws SQLException;
	String validateLossCatCdGicls202(HttpServletRequest request) throws SQLException;
	String validatePerilCdGicls202(HttpServletRequest request) throws SQLException;
	String validateIntmNoGicls202(HttpServletRequest request) throws SQLException;
	String validateControlTypeCdGicls202(HttpServletRequest request) throws SQLException;
	String printGicls202(HttpServletRequest request, String userId) throws SQLException;
	
}
