package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACDocSequenceDAO;
import com.geniisys.giac.entity.GIACDocSequence;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIACDocSequenceDAOImpl implements GIACDocSequenceDAO {
	
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
	public void saveGiacs322(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACDocSequence> delList = (List<GIACDocSequence>) params.get("delRows");
			for(GIACDocSequence d: delList){
				d.setFundCd((StringFormatter.unescapeHTML2(d.getFundCd())));
				d.setBranchCd(StringFormatter.unescapeHTML2(d.getBranchCd()));
				d.setDocName(StringFormatter.unescapeHTML2(d.getDocName()));
				this.sqlMapClient.update("delDocSequence", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACDocSequence> setList = (List<GIACDocSequence>) params.get("setRows");
			for(GIACDocSequence s: setList){
				this.sqlMapClient.update("setDocSequence", s);
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
	public String valDeleteRec(String repCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteDocSequence", repCd);
	}

	@Override
	public String valAddRec(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valAddDocSequence", params);
	}
}
