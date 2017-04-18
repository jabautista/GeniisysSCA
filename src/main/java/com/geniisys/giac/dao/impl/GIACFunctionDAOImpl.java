package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACFunctionDAO;
import com.geniisys.giac.entity.GIACFunction;
import com.geniisys.giac.entity.GIACFunctionColumns;
import com.geniisys.giac.entity.GIACFunctionDisplay;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACFunctionDAOImpl implements GIACFunctionDAO {

	private SqlMapClient sqlMapClient;
	
	@Override
	public String getFunctionName(Map<String, Object> params)
			throws SQLException {		
		return (String) this.sqlMapClient.queryForObject("getFunctionName", params);
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs314(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACFunction> delList = (List<GIACFunction>) params.get("delRows");
			for(GIACFunction d: delList){
				this.sqlMapClient.update("delAccountingFunction", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACFunction> setList = (List<GIACFunction>) params.get("setRows");
			for(GIACFunction s: setList){
				this.sqlMapClient.update("setAccountingFunction", s);
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

	@Override
	public String valDeleteRec(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteAccountingFunction", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddAccountingFunction", params);		
	}
	
	public Map<String, Object> validateGiacs314Module(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiacs314Module", params);
		return params;
	}
	
	public Map<String, Object> validateGiacs314Table(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiacs314Table", params);
		return params;
	}
	
	public Map<String, Object> validateGiacs314Column(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiacs314Column", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveFunctionColumn(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACFunctionColumns> delList = (List<GIACFunctionColumns>) params.get("delRows");
			for(GIACFunctionColumns d: delList){
				this.sqlMapClient.update("delFunctionColumn", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACFunctionColumns> setList = (List<GIACFunctionColumns>) params.get("setRows");
			for(GIACFunctionColumns s: setList){
				this.sqlMapClient.update("setFunctionColumn", s);
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
	
	@Override
	public void valAddFunctionColumn(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddFunctionColumn", params);		
	}
	
	public Map<String, Object> validateGiacs314Display(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiacs314Display", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveColumnDisplay(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACFunctionDisplay> delList = (List<GIACFunctionDisplay>) params.get("delRows");
			for(GIACFunctionDisplay d: delList){
				this.sqlMapClient.update("delColumnDisplay", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACFunctionDisplay> setList = (List<GIACFunctionDisplay>) params.get("setRows");
			for(GIACFunctionDisplay s: setList){
				this.sqlMapClient.update("setColumnDisplay", s);
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
	
	@Override
	public void valAddColumnDisplay(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddColumnDisplay", params);		
	}

	@Override
	public String checkFuncExists(Map<String, Object> params) //Added by Jerome Bautista 05.28.2015 SR 4225
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkAccountingFunction",params);
	}

}
