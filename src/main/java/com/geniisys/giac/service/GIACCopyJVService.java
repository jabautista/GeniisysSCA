package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;

public interface GIACCopyJVService {
	String giacs051CheckCreateTransaction(HttpServletRequest request) throws SQLException;
	String giacs051CopyJV(HttpServletRequest request, String userId) throws SQLException;
	String giacs051ValidateBranchCdFrom(HttpServletRequest request, String userId) throws SQLException;
	String giacs051ValidateDocYear(HttpServletRequest request) throws SQLException;
	String giacs051ValidateDocMm(HttpServletRequest request) throws SQLException;
	Map<String, Object> giacs051ValidateDocSeqNo(HttpServletRequest request) throws SQLException;
	String giacs051ValidateBranchCdTo(HttpServletRequest request, String userId) throws SQLException;
}
