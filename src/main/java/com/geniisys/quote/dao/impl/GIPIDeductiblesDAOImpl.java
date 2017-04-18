package com.geniisys.quote.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.quote.dao.GIPIDeductiblesDAO;
import com.geniisys.quote.entity.GIPIDeductibles;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIDeductiblesDAOImpl implements GIPIDeductiblesDAO{
	private Logger log = Logger.getLogger(GIPIDeductiblesDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveDeductibleInfo(Map<String, Object> rowParams,
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving deductible info...");
			
			List<GIPIDeductibles> setRows = (List<GIPIDeductibles>) rowParams.get("setRows");
			List<GIPIDeductibles> delRows = (List<GIPIDeductibles>) rowParams.get("delRows");
			
			for(GIPIDeductibles del:delRows){
				log.info("DELETING: "+del);
				this.getSqlMapClient().delete("deleteDeductibleInfoGIIMM002", del);
			}
			
			for(GIPIDeductibles set:setRows){
				log.info("INSERTING: "+set);
				this.getSqlMapClient().insert("setDeductibleInfoGIIMM002", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving peril info...");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String checkDeductibleText() throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkDeductibleText");
	}
}
