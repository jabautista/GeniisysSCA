package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACPostEntriesToGLDAO {

	public Integer getGLNo() throws SQLException;
	public Integer getFinanceEnd() throws SQLException;
	public Integer getFiscalEnd() throws SQLException;
	public Integer validateTranYear(String tranYear) throws SQLException;
	public String validateTranMonth(Map<String, Object> params) throws SQLException;
	public void checkIsPrevMonthClosed(Map<String, Object> params) throws SQLException;
	public Map<String, Object> postToGL(Map<String, Object> params) throws SQLException;
}
