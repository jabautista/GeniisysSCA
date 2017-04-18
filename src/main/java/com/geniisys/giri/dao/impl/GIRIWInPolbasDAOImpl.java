package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.entity.GIPICoInsurer;
import com.geniisys.giri.dao.GIRIWInPolbasDAO;
import com.geniisys.giri.entity.GIRIWInPolbas;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIWInPolbasDAOImpl implements GIRIWInPolbasDAO{
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPICoInsurer.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public void saveGIRIWInPolbas(Map<String, Object> giriWInPolbas)
			throws SQLException {
		log.info("Saving records to GIRI_WINPOLBAS...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Save ri par map content - "+giriWInPolbas);
			this.getSqlMapClient().update("setGIRIWInPolbas", giriWInPolbas);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public GIRIWInPolbas getGIRIWInPolbasForPAR(int parId) throws SQLException {
		log.info("Getting GIRI_WINPOLBAS records for "+parId+"...");
		return (GIRIWInPolbas) this.getSqlMapClient().queryForObject("getGIRIWInPolbasRecords", parId);
	}

	@Override
	public Integer generateAcceptNo() throws SQLException {
		log.info("Getting accept no...");
		return (Integer) this.getSqlMapClient().queryForObject("getNewAcceptNo");
	}

}
