package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACBankDAO;
import com.geniisys.giac.entity.GIACBank;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACBankDAOImpl implements GIACBankDAO {
	
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
	public void saveGiacs307(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACBank> delList = (List<GIACBank>) params.get("delRows");
			for(GIACBank d: delList){
				this.sqlMapClient.update("delBank", d.getBankCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACBank> setList = (List<GIACBank>) params.get("setRows");
			for(GIACBank s: setList){
				this.sqlMapClient.update("setBank", s);
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
		this.sqlMapClient.update("valDeleteBank", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddBank", recId);		
	}
}
