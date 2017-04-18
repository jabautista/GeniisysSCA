package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.jfree.util.Log;

import com.geniisys.common.dao.GIISTariffRatesHdrDAO;
import com.geniisys.common.entity.GIISTariffRatesDtl;
import com.geniisys.common.entity.GIISTariffRatesHdr;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTariffRatesHdrDAOImpl implements GIISTariffRatesHdrDAO{

	private SqlMapClient sqlMapClient;
	
	@Override
	public GIISTariffRatesHdr getTariffDetailsFI(Map<String, Object> params)
			throws SQLException {
		return (GIISTariffRatesHdr) getSqlMapClient().queryForObject("getTariffDetailsFI", params);
	}
	
	@Override
	public GIISTariffRatesHdr getTariffDetailsMC(Map<String, Object> params)
			throws SQLException {
		return (GIISTariffRatesHdr) getSqlMapClient().queryForObject("getTariffDetailsMC", params);
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

//	@SuppressWarnings("unchecked")
//	public Map<String, Object> getGiiss106WithCompDtl(String tariffCd) throws SQLException{
//		return (Map<String, Object>) this.sqlMapClient.queryForObject("getGiiss106WithCompDtl", tariffCd);
//	}
//	
//	@SuppressWarnings("unchecked")
//	public Map<String, Object> getGiiss106FixedPremDtl(String tariffCd) throws SQLException{
//		return (Map<String, Object>) this.sqlMapClient.queryForObject("getGiiss106FixedPremDtl", tariffCd);
//	}
	
	@Override
	public void valAddHdrRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddTariffRatesHdr", params);		
	}
	
	@Override
	public void valDeleteHdrRec(String tariffCd) throws SQLException {
		this.sqlMapClient.update("valDeleteTariffRatesHdr", tariffCd);
	}
	
	public Integer getTariffCdNoSequence() throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("getTariffCdNoSequence");
	}
		
	@Override
	public void valTariffRatesFixedSIRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valTariffRatesFixedSIRec", params);		
	}
	
//	@SuppressWarnings("unchecked")
//	public Map<String, Object> getGiiss106MinMaxAmt(Integer tariffCd) throws SQLException{
//		return (Map<String, Object>) this.sqlMapClient.queryForObject("getGiiss106MinMaxAmt", tariffCd);
//	}
	
	/*public Integer getNextTariffDtlCd(Integer tariffCd) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("getNextTariffDtlCd", tariffCd);
	}*/
	
	public void valAddDtlRec(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("valAddRecDtl", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss106(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTariffRatesHdr> delList = (List<GIISTariffRatesHdr>) params.get("delRows");
			if(delList != null){
				Log.info("*****deleting GIISTariffRatesHdr...");
				for(GIISTariffRatesHdr d: delList){
					this.sqlMapClient.update("delTariffRatesHdr", d);
				}
				this.sqlMapClient.executeBatch();
				Log.info("finished.");
			}
			List<GIISTariffRatesHdr> setList = (List<GIISTariffRatesHdr>) params.get("setRows");
			if(setList != null){
				Log.info("*****adding/updating GIISTariffRatesHdr...");
				for(GIISTariffRatesHdr s: setList){
					this.sqlMapClient.update("setTariffRatesHdr", s);
				}
				this.sqlMapClient.executeBatch();
				Log.info("finished.");
			}
			
			List<GIISTariffRatesDtl> delList2 = (List<GIISTariffRatesDtl>) params.get("delDtlRows");
			if(delList2 != null){
				Log.info("*****deleting GIISTariffRatesDtl...");
				for(GIISTariffRatesDtl d: delList2){
					this.sqlMapClient.update("delTariffRatesDtl", d);
				}
				this.sqlMapClient.executeBatch();
				Log.info("finished.");
			}
			List<GIISTariffRatesDtl> setList2 = (List<GIISTariffRatesDtl>) params.get("setDtlRows");
			if(setList2 != null){
				Log.info("*****adding/updating GIISTariffRatesDtl...");
				for(GIISTariffRatesDtl child: setList2){
					if (child.getTariffCd() == null) {
						for (GIISTariffRatesHdr parent : setList) {
							List<GIISTariffRatesDtl> setGIISTariffRatesDtl = (List<GIISTariffRatesDtl>) parent.getGiisTariffRatesDtl();
							if (setGIISTariffRatesDtl != null) {
								for (GIISTariffRatesDtl child2 : setGIISTariffRatesDtl) {
									child2.setTariffCd(parent.getTariffCd());
									this.sqlMapClient.update("setTariffRatesDtl", child2);
								}
							}
						}
						break;
					} else {
						this.sqlMapClient.update("setTariffRatesDtl", child);
					}
				}
				this.sqlMapClient.executeBatch();
				Log.info("finished.");
			}
			
			/*List<GIISTariffRatesDtl> delDtlList = (List<GIISTariffRatesDtl>) params.get("delDtlRows");
			for(GIISTariffRatesDtl d: delDtlList){				
				Log.info("Deleting Tariff Rates Dtl : tariff_cd - " + d.getTariffCd() + "; tariff_dtl_cd - " + d.getTariffDtlCd());				
				this.sqlMapClient.update("delTariffRatesDtl", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTariffRatesDtl> setDtlList = (List<GIISTariffRatesDtl>) params.get("setDtlRows");
			for(GIISTariffRatesDtl s: setDtlList){
				System.out.println("Inserting/Updating Tariff Rates Dtl : tariff_cd - " + s.getTariffCd() + "; tariff_dtl_cd - " + s.getTariffDtlCd());
				this.sqlMapClient.update("setTariffRatesDtl", s);
			}
			
			//------------------------------------------------------------------//
			
			List<GIISTariffRatesHdr> delList = (List<GIISTariffRatesHdr>) params.get("delRows");
			for(GIISTariffRatesHdr d: delList){
				Log.info("Deleting Tariff Rates Hdr : " + d.getTariffCd());
				this.sqlMapClient.update("delTariffRatesHdr", d.getTariffCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTariffRatesHdr> setList = (List<GIISTariffRatesHdr>) params.get("setRows");
			for(GIISTariffRatesHdr s: setList){
				System.out.println("Inserting/Updating Tariff Rates Hdr : " + s.getTariffCd());
				this.sqlMapClient.update("setTariffRatesHdr", s);
			}*/
			
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
