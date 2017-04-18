package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.entity.GIACWholdingTaxes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACWholdingTaxesDAOImpl implements
		com.geniisys.giac.dao.GIACWholdingTaxesDAO {

	/** The logger **/
	private static Logger log = Logger.getLogger(GIACWholdingTaxesDAOImpl.class);
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACWholdingTaxes#validateGiacs022WhtaxCode(java.util.Map)
	 */
	@Override
	public void validateGiacs022WhtaxCode(Map<String, Object> params)
			throws SQLException {
		log.info("");
		this.getSqlMapClient().update("validateGIACS022WhtaxCode", params);
	}

	@Override
	public String validateItemNo(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateItemNoGIACS022",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs318(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACWholdingTaxes> delList = (List<GIACWholdingTaxes>) params.get("delRows");
			for(GIACWholdingTaxes d: delList){
				this.sqlMapClient.update("delWhtax", d.getWhtaxId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACWholdingTaxes> setList = (List<GIACWholdingTaxes>) params.get("setRows");
			for(GIACWholdingTaxes s: setList){
				this.sqlMapClient.update("setWhtax", s);
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
	public void valDeleteWhtax(Integer whtaxId) throws SQLException {
		this.sqlMapClient.update("valDeleteWhtax", whtaxId);
	}
}
