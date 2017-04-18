package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACProdBudgetDAO;
import com.geniisys.giac.entity.GIACProdBudget;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACProdBudgetDAOImpl implements GIACProdBudgetDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs360(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACProdBudget> delList = (List<GIACProdBudget>) params.get("delRows");
			for(GIACProdBudget d: delList){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("year", d.getYear());
				param.put("month", d.getMonth());
				param.put("issCd", d.getIssCd());
				param.put("lineCd", d.getLineCd());
				this.sqlMapClient.update("delBudget", param);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACProdBudget> setList = (List<GIACProdBudget>) params.get("setRows");
			for(GIACProdBudget s: setList){
				this.sqlMapClient.update("setBudget", s);
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
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteBudget", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddBudget", params);		
	}
	
	@Override
	public void valAddYearRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddYearBudget", params);		
	}
}
