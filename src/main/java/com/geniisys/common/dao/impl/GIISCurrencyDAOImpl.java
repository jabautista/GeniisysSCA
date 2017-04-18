package com.geniisys.common.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISCurrencyDAO;
import com.geniisys.common.entity.GIISCurrency;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCurrencyDAOImpl implements GIISCurrencyDAO {
	
	/** The SQL Map Client**/
	private SqlMapClient sqlMapClient;
	
	/** The logger **/
	private static Logger log = Logger.getLogger(GIISCurrencyDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISCurrency> getGiisCurrencyLOV(String keyword)
			throws SQLException {
		log.info("getGiisCurrencyLOV(keyword=" + keyword + ")");
		return this.getSqlMapClient().queryForList("getGiisCurrencyLOVListing", keyword);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISCurrencyDAO#getDCBCurrencyLOV(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISCurrency> getDCBCurrencyLOV(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getDCBCurrencyLOV", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISCurrencyDAO#getCurrencyLOVByShortName(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISCurrency> getCurrencyLOVByShortName(String shortName)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getCurrencyLOVByShortName", shortName);
	}

	@Override
	public BigDecimal getCurrencyByShortname(String shortname)
			throws SQLException {
		log.info("GETTING CURRENCY RATE FOR SHORTNAME: "+shortname);
		BigDecimal currencyRt = (BigDecimal) getSqlMapClient().queryForObject("getCurrencyByShortname", shortname);
		log.info("rate is : "+currencyRt);
		return currencyRt;
	}

	@Override
	public String validateDeleteCurrency(Map<String, Object> params)
			throws SQLException {
		log.info("validating currency...");
		return (String) this.getSqlMapClient().queryForObject("validateDeleteCurrency", params);
	}

	@Override
	public String validateMainCurrencyCd(Map<String, Object> params)
			throws SQLException {
		log.info("validating currency code...");
		return (String) this.getSqlMapClient().queryForObject("validateMainCurrencyCd", params);
	}

	@Override
	public String validateShortName(Map<String, Object> params)
			throws SQLException {
		log.info("validating currency short name..." + params);
		return (String) this.getSqlMapClient().queryForObject("validateShortName", params);
	}

	@Override
	public String validateCurrencyDesc(Map<String, Object> params)
			throws SQLException {
		log.info("validating currency description..." + params);
		return (String) this.getSqlMapClient().queryForObject("validateCurrencyDesc", params);
	}

	@Override
	public String saveCurrency(Map<String, Object> allParams)
			throws SQLException {
		String message = "SUCCESS";
		@SuppressWarnings("unchecked")
		List<GIISCurrency> setRows = (List<GIISCurrency>) allParams.get("setRows");
		@SuppressWarnings("unchecked")
		List<GIISCurrency> delRows= (List<GIISCurrency>) allParams.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			log.info("Saving GIIS Currency...");
			for(GIISCurrency del : delRows){
				this.getSqlMapClient().delete("deleteGIISCurrency", del);
			}
			log.info(delRows.size() + " GIIS Currency/s deleted.");
			for(GIISCurrency set : setRows){
				this.sqlMapClient.insert("setGIISCurrency", set);
				this.getSqlMapClient().executeBatch();
			}
			log.info(setRows.size() + " GIIS Currency/s inserted/updated.");			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteCurrency", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss009(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISCurrency> delList = (List<GIISCurrency>) params.get("delRows");
			for(GIISCurrency d : delList){
				this.sqlMapClient.update("deleteGIISCurrency", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISCurrency> setList = (List<GIISCurrency>) params.get("setRows");
			for(GIISCurrency s: setList){
				this.sqlMapClient.update("setGIISCurrency", s);
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
