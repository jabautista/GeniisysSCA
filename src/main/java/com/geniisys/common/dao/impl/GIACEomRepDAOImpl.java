package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIACEomRepDAO;
import com.geniisys.common.entity.GIACEomRep;
import com.geniisys.common.entity.GIACEomRepDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACEomRepDAOImpl implements GIACEomRepDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddEomRep", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelEomRep", params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveGiacs350(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACEomRep> delList = (List<GIACEomRep>) params.get("delRows");
			for(GIACEomRep d : delList){
				this.sqlMapClient.update("delEomRep", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIACEomRep> setList = (List<GIACEomRep>) params.get("setRows");
			for(GIACEomRep s: setList){
				this.sqlMapClient.update("setEomRep", s);
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
	public void validateGLAcctNo(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateGLAcctNoGiacs351", params);
	}

	@Override
	public void valAddDtlRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddDtlRecGiacs351", params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveGiacs351(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACEomRepDtl> delList = (List<GIACEomRepDtl>) params.get("delRows");
			for(GIACEomRepDtl d : delList){
				this.sqlMapClient.update("delEomRepDtl", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIACEomRepDtl> setList = (List<GIACEomRepDtl>) params.get("setRows");
			for(GIACEomRepDtl s: setList){
				this.sqlMapClient.update("setEomRepDtl", s);
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
	
}
