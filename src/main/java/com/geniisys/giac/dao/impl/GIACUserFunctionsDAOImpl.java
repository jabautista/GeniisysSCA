package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACUserFunctionsDAO;
import com.geniisys.giac.entity.GIACUserFunctions;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACUserFunctionsDAOImpl implements GIACUserFunctionsDAO {
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIACUserFunctionsDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACUserFunctionsDAO#checkIfUserHasFunction(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String checkIfUserHasFunction(String functionCd, String moduleName,
			String userId) throws SQLException {
		log.info("checkIfUserHasFunction");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("functionCd", functionCd);
		params.put("moduleName", moduleName);
		params.put("userId", userId);
		
		return (String)this.getSqlMapClient().queryForObject("checkIfUserHasFunction", params);
	}

	@Override
	public String checkOverdueUser(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkOverdueUser", params);
	}

	@Override
	public String checkIfUserHasFunction3(Map<String, Object> params)
			throws SQLException {
		return (String) getSqlMapClient().queryForObject("checkIfUserHasFunction3", params);
	}
	
	
	public String getScrnRepName(Integer moduleId) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getScrnRepNameGiacs315", moduleId);
	}
	
	public Integer getUserFunctionsSeq() throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("getUserFunctionsSeq");
	}
	
	 @SuppressWarnings("unchecked")
	@Override
	public void saveGiacs315(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACUserFunctions> delList = (List<GIACUserFunctions>) params.get("delRows");
			for(GIACUserFunctions d: delList){
				System.out.println("DEL userId: " + d.getUserId());
				this.sqlMapClient.update("delUserFunction", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACUserFunctions> setList = (List<GIACUserFunctions>) params.get("setRows");
			for(GIACUserFunctions s: setList){
				System.out.println("SET userFunctionId: " + s.getUserFunctionId());
				this.sqlMapClient.update("setUserFunction", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	 
	public Map<String, Object> checkUserFunctionValidity(Map<String, Object> params)
				throws SQLException {
			this.getSqlMapClient().update("checkUserFunctionValidity", params);
			return params;
	}

	/*@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteDCBUser", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddDCBUser", params);		
	}
	*/
}
