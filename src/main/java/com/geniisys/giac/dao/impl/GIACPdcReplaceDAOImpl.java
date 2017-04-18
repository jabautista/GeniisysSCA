package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACPdcReplaceDAO;
import com.geniisys.giac.entity.GIACPdcReplace;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPdcReplaceDAOImpl implements GIACPdcReplaceDAO{

	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIACPdcReplaceDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPdcReplaceDAO#getPdcRepDtls(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	public List<GIACPdcReplace> getPdcRepDtls(Map<String, Object> params) 
		throws SQLException {
		log.info("getPdcRepDtls");
		return this.sqlMapClient.queryForList("getPdcRepDtls", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIACPdcReplace(Map<String, Object> params)
			throws SQLException {
		try {
			List<GIACPdcReplace> rows = (List<GIACPdcReplace>) params.get("setRows");
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);			
			this.sqlMapClient.startBatch();
			
			Map<String, Object> statParam = new HashMap<String, Object>();
			statParam.put("pdcId", rows.get(0).getPdcId());
			statParam.put("checkFlag", "R");
			statParam.put("appUser", params.get("userId"));
			this.sqlMapClient.update("updateApdcPaytDtlStatus", statParam);
			
			for(GIACPdcReplace rep : rows){
				this.sqlMapClient.insert("insertGiacPdcReplace", rep);	
			}			
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
}
