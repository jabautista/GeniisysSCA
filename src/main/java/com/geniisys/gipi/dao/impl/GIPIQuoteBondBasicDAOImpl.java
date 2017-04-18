package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIQuoteBondBasicDAO;
import com.geniisys.gipi.entity.GIPIQuoteBondBasic;
import com.geniisys.gipi.entity.GIPIQuoteCosign;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteBondBasicDAOImpl implements GIPIQuoteBondBasicDAO{

	private Logger log = Logger.getLogger(GIPIQuoteBondBasicDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIQuoteBondBasic getGIPIQuoteBondBasic(Integer quoteId)
			throws SQLException {
		return (GIPIQuoteBondBasic) this.sqlMapClient.queryForObject("getGIPIQuoteBondBasic", quoteId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveBondPolicyData(Map<String, Object> params)
			throws SQLException {
		log.info("Saving Bond Policy Data ... ");	
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			/* for Bond Basic Information */
			GIPIQuoteBondBasic bondPolicy = (GIPIQuoteBondBasic) params.get("bondPolicy");
			this.sqlMapClient.insert("setGIPIQuoteBondBasic", bondPolicy);
			
			/* for Co-Signor's */
			List<GIPIQuoteCosign> setRows = (List<GIPIQuoteCosign>) params.get("setRows");
			List<GIPIQuoteCosign> delRows = (List<GIPIQuoteCosign>) params.get("delRows");
			for(GIPIQuoteCosign del:delRows){
				this.getSqlMapClient().delete("delGIPIQuoteCosign", del);
			}
			
			for(GIPIQuoteCosign ins:setRows){
				this.getSqlMapClient().insert("setGIPIQuoteCosign", ins);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			message = "SQL Exception occured...<br />"+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
}
