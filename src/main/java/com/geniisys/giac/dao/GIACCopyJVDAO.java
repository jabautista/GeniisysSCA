package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACCopyJVDAO {
	String giacs051CheckCreateTransaction(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs051CopyJV(Map<String, Object> params) throws SQLException;
	String giacs051ValidateBranchCdFrom(Map<String, Object> params) throws SQLException;
	String giacs051ValidateDocYear(Map<String, Object> params) throws SQLException;
	String giacs051ValidateDocMm(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs051ValidateDocSeqNo(Map<String, Object> params) throws SQLException;
	String giacs051ValidateBranchCdTo(Map<String, Object> params) throws SQLException;
}
