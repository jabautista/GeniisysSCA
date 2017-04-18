package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACBudgetDAO;
import com.geniisys.giac.entity.GIACBudget;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACBudgetDAOImpl implements GIACBudgetDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void valAddBudgetYear(String year) throws SQLException {
		this.sqlMapClient.update("valAddBudgetYear", year);
	}

	@Override
	public void copyBudget(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("copyBudget", params);
			this.sqlMapClient.executeBatch();
			
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
	@SuppressWarnings("unchecked")
	public void saveGiacs510(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACBudget> delList = (List<GIACBudget>) params.get("delRows");
			for(GIACBudget del: delList){
				this.sqlMapClient.update("delBudgetPerYear", del);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACBudget> budgetPerYearList = (List<GIACBudget>) params.get("setRows");
			for(GIACBudget set : budgetPerYearList){					
				this.getSqlMapClient().insert("setBudgetPerYear", set);
			}				
			this.getSqlMapClient().executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteBudgetPerYear(String glAcctId, String year) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("glAcctId", glAcctId);
		params.put("year", year);
		this.sqlMapClient.update("valDeleteBudgetPerYear", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateGLAcctNo(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateGLAcctNo", params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveGIACS510Dtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACBudget> delList = (List<GIACBudget>) params.get("delRows");
			for(GIACBudget del: delList){
				this.sqlMapClient.update("delBudgetDtlPerYear", del);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACBudget> budgetDtlPerYearList = (List<GIACBudget>) params.get("setRows");
			for(GIACBudget set : budgetDtlPerYearList){					
				this.getSqlMapClient().insert("setBudgetDtlPerYear", set);
			}				
			this.getSqlMapClient().executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkExistBeforeExtractGiacs510(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkExistBeforeExtractGiacs510", params);
	}

	@Override
	public HashMap<String, Object> extractGiacs510(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractGiacs510", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
}
