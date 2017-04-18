package com.geniisys.giri.pack.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.pack.dao.GIRIPackBinderHdrDAO;
import com.geniisys.giri.pack.entity.GIRIPackBinderHdr;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIPackBinderHdrDAOImpl implements GIRIPackBinderHdrDAO{

	private Logger log = Logger.getLogger(GIRIPackBinderHdrDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String savePackageBinderHdr(Map<String, Object> params)
			throws SQLException {
		log.info("Start saving package binder header...");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIRIPackBinderHdr> setRows = (List<GIRIPackBinderHdr>) params.get("setRows");
			
			for(GIRIPackBinderHdr binder: setRows){
				log.info("Inserting/Updating into table : "+binder.getDspPackBinderNo());
				this.getSqlMapClient().insert("setGiriPackbinderHdr", binder);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving package binder header...");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
}
