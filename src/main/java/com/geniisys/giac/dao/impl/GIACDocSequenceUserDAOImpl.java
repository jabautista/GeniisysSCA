package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACDocSequenceUserDAO;
import com.geniisys.giac.entity.GIACDocSequenceUser;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIACDocSequenceUserDAOImpl implements GIACDocSequenceUserDAO {

	private SqlMapClient sqlMapClient;
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs316(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACDocSequenceUser> delList = (List<GIACDocSequenceUser>) params.get("delRows");
			for(GIACDocSequenceUser d: delList){
				d.setBranchCd(StringFormatter.unescapeHTML2(d.getBranchCd()));
				d.setDocCode(StringFormatter.unescapeHTML2(d.getDocCode()));
				d.setDocPref(StringFormatter.unescapeHTML2(d.getDocPref()));
				this.sqlMapClient.update("delDocSequenceUser", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACDocSequenceUser> setList = (List<GIACDocSequenceUser>) params.get("setRows");
			for(GIACDocSequenceUser s: setList){
				this.sqlMapClient.update("setDocSequenceUser", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteDocSequenceUser", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddDocSequenceUser", params);
	}

	@Override
	public void valMinSeqNo(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valMinSeqNo", params);
	}

	@Override
	public void valMaxSeqNo(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valMaxSeqNo", params);
	}

	@Override
	public void valActiveTag(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valActiveTag", params);
	}

}
