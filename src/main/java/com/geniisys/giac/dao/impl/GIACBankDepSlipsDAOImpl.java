package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACBankDepSlipsDAO;
import com.geniisys.giac.entity.GIACBankDepSlips;
import com.geniisys.giac.entity.GIACCashDepDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACBankDepSlipsDAOImpl implements GIACBankDepSlipsDAO {
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACBankDepSlipsDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveGbdsBlock(Map<String, Object> allParams)
			throws SQLException {
		
		String message = "SUCCESS";
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			List<GIACBankDepSlips> setRows = (List<GIACBankDepSlips>) allParams.get("setRows");
			List<GIACBankDepSlips> delRows = (List<GIACBankDepSlips>) allParams.get("delRows");
			
			List<GIACCashDepDtl> setGcddRows = (List<GIACCashDepDtl>) allParams.get("setGcddRows");
			List<GIACCashDepDtl> delGcddRows = (List<GIACCashDepDtl>) allParams.get("delGcddRows");
			
			for (GIACBankDepSlips del:delRows){
				log.info("deleting : " + del);
				this.getSqlMapClient().delete("delGbds", del);
			}
			
			for (GIACBankDepSlips set:setRows){
				log.info("inserting: "+ set);
				this.getSqlMapClient().insert("setGbds", set);
			}
					
			if(delGcddRows != null){
				for (GIACCashDepDtl del : delGcddRows){
					log.info("deleting to cash dep : " + del);
					this.getSqlMapClient().delete("delGccd", del);
				}
			}
			
			if(setGcddRows != null){
				for (GIACCashDepDtl set : setGcddRows){
					log.info("inserting to cash dep : " + set);
					this.getSqlMapClient().insert("setGccd", set);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACBankDepSlipsDAO#getGbdsListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGbdsListTableGrid(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGbdsTableGrid", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGcddListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGcddListTableGrid(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGcddTableGrid", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGbdsdListTableGridByGaccTranId(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGbdsdListTableGridByGaccTranId(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGbdsdTableGridByGaccTranId", params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGbdsdListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGbdsdListTableGrid(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGbdsdTableGrid", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getLocErrorAmt(java.util.Map)
	 */
	@Override
	public BigDecimal getLocErrorAmt(Map<String, Object> params)
			throws SQLException {
		String locErrorAmt = (String)this.getSqlMapClient().queryForObject("getLocErrorAmt", params);
		
		System.out.println("Emman locErrorAmt DAO: " + locErrorAmt);
		
		if (locErrorAmt != null) {
			if (locErrorAmt.isEmpty()) {
				locErrorAmt = null;
			}
		}
		
		return (locErrorAmt == null) ? null : new BigDecimal(locErrorAmt);
	}
}
