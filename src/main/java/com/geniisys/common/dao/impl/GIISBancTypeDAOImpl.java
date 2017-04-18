package com.geniisys.common.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISBancTypeDAO;
import com.geniisys.common.entity.GIISBancType;
import com.geniisys.common.entity.GIISBancTypeDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBancTypeDAOImpl implements GIISBancTypeDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISBancTypeDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public void valAddRec(String recId) throws SQLException {
		this.getSqlMapClient().update("valAddBancType", recId);
	}
	
	@Override
	public void valAddDtl(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddBancDtl", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss218(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISBancType> delList = (List<GIISBancType>) params.get("delRows");
			for(GIISBancType d: delList){
				log.info("Delete GIISBancType: " + d.getBancTypeCd());
				this.getSqlMapClient().update("delBancType", d.getBancTypeCd());
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISBancType> setList = (List<GIISBancType>) params.get("setRows");
			for(GIISBancType s: setList){
				log.info("Set GIISBancType: " + s.getBancTypeCd());
				this.getSqlMapClient().update("setBancType", s);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISBancTypeDtl> delDtlList = (List<GIISBancTypeDtl>) params.get("delDtlRows");
			for(GIISBancTypeDtl d: delDtlList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("bancTypeCd", d.getBancTypeCd());
				delParams.put("itemNo", d.getItemNo());
				log.info("Delete GIISBancTypeDtl: " + delParams);
				this.getSqlMapClient().update("delBancTypeDtl", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISBancTypeDtl> setDtlList = (List<GIISBancTypeDtl>) params.get("setDtlRows");
			for(GIISBancTypeDtl s: setDtlList){
				log.info("Set GIISBancTypeDtl: " + s.getBancTypeCd() + " - " + s.getItemNo());
				this.getSqlMapClient().update("setBancTypeDtl", s);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public BigDecimal getBancTypeDtlTotal(Map<String, Object> params)
			throws SQLException {
		return (BigDecimal) this.getSqlMapClient().queryForObject("getBancTypeDtlTotal", params);
	}
	
}
