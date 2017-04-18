package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACPdcChecksDAO;
import com.geniisys.giac.entity.GIACCollectionDtl;
import com.geniisys.giac.entity.GIACPdcPayts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPdcChecksDAOImpl implements GIACPdcChecksDAO {

	private SqlMapClient sqlMapClient;
	
	@Override
	public Map<String, Object> checkDateForDeposit(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("checkDateForDeposit", params);
		return params;
	}
	
	public void saveForDeposit(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.insert("saveForDeposit", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveReplacePDC(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACCollectionDtl> setList = (List<GIACCollectionDtl>) params.get("setRows");
			for(GIACCollectionDtl s: setList){
				Map<String, Object> params2 = new HashMap<String, Object>();
				
				params2.put("payMode", s.getPayMode());
				params2.put("checkClass", s.getCheckClass());
				params2.put("checkNo", s.getCheckNo());
				params2.put("checkDate", s.getCheckDate());
				params2.put("amt", s.getAmt());
				params2.put("grossAmt", s.getGrossAmt());
				params2.put("commAmt", s.getCommAmt());
				params2.put("vatAmt", s.getVatAmt());
				params2.put("gaccTranId", s.getGaccTranId());
				params2.put("itemNo", s.getItemNo());
				params2.put("dueDcbNo", s.getDueDcbNo());
				params2.put("dueDcbDate", s.getDueDcbDate());
				params2.put("currencyRt", s.getCurrencyRt());
				params2.put("currencyCd", s.getCurrencyCd());
				params2.put("bankCd", s.getBankCd());
				params2.put("userId", s.getUserId());
				
				params2.put("appUser", params.get("appUser"));
				params2.put("fundCd", params.get("fundCd"));
				params2.put("branchCd", params.get("branchCd"));
				params2.put("oldAmt", params.get("oldAmt"));
				params2.put("itemId", params.get("itemId"));
				this.sqlMapClient.update("saveReplacePDC", params2);
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRecGiacs031", params);		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs031(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACPdcPayts> delList = (List<GIACPdcPayts>) params.get("delRows");
			for(GIACPdcPayts d: delList){
				this.sqlMapClient.update("delGiacs031", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACPdcPayts> setList = (List<GIACPdcPayts>) params.get("setRows");
			for(GIACPdcPayts s: setList){
				this.sqlMapClient.update("setGiacs031", s);
			}
			
			this.sqlMapClient.update("giacs031PostFormCommit", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	public Map<String, Object> applyPDC(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("applyPdcPayts", params);
		return params;
	}
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
}
