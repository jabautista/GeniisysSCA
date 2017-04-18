package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface CopyUtilitiesService {

	String summarizePolToPar(HttpServletRequest request, String userId) throws SQLException;
	void checkIfPolicyExists(Map<String, Object> params) throws SQLException;
	void checkPolicy(HttpServletRequest request, String userId) throws SQLException;
	void validateLine(HttpServletRequest request, String userId) throws SQLException;
	void validateIssCd(HttpServletRequest request, String userId) throws SQLException;
	// GIUTS008A start
	String validateLineCdGiuts008a(HttpServletRequest request) throws SQLException;
	String validateIssCdGiuts008a(HttpServletRequest request) throws SQLException;
	String copyPackPolicyGiuts008a(HttpServletRequest request, String userId) throws SQLException;
	void validateParIssCd(HttpServletRequest request, String userId) throws SQLException;
}
