package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIACBankBookTranDAO;
import com.geniisys.common.entity.GIACBankBookTran;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACBankBookTranDAOImpl implements GIACBankBookTranDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddBankBookTran", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs324(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACBankBookTran> delList = (List<GIACBankBookTran>) params.get("delRows");
			for(GIACBankBookTran d : delList){
				this.sqlMapClient.update("delBankBookTran", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIACBankBookTran> setList = (List<GIACBankBookTran>) params.get("setRows");
			for(GIACBankBookTran s: setList){
				this.sqlMapClient.update("setBankBookTran", s);
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
	public void valBookTranCd(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valBookTranCd", params);
	}
}
