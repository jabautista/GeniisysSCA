package com.geniisys.giri.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.giri.dao.GIRIWFrpsRiDAO;
import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;
import com.geniisys.giri.entity.GIRIWFrpsRi;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIWFrpsRiDAOImpl implements GIRIWFrpsRiDAO{

	private Logger log = Logger.getLogger(GIRIWFrpsRiDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> getWarrDays(Map<String, Object> params)
			throws SQLException {
		log.info("get warr days: "+params);
		this.sqlMapClient.update("getWarrDaysGIRIS001", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIWFrpsRi> getGIRIWFrpsRiList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting GIRI_WFrps_Ri list...<getGIRIWFrpsRi>");
		return this.getSqlMapClient().queryForList("getGIRIWFrpsRi", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setRiAcceptance(Map<String, Object> params) throws SQLException {

		List<GIRIWFrpsRi> setFrpsRi = (List<GIRIWFrpsRi>) params.get("setWFrpsRi");
		List<Map<String, Object>> setFrperils = (List<Map<String, Object>>) params.get("setFrperil");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating GIRI_WFRPS_RI... "+setFrpsRi.size());
			for(GIRIWFrpsRi ri : setFrpsRi) {
				System.out.println(ri.getRiCommVat()+ " ********");
				System.out.println("Set Ri: "+ri.getLineCd()+"//"+ri.getFrpsYy()+"//"+ri.getFrpsSeqNo()+"//"+
						ri.getRiCd()+"//"+ri.getRiSeqNo());
				this.getSqlMapClient().update("setGIRIWFrpsRiGIRIS002", ri);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("Updating GIRI_WFRPERIL... "+setFrperils.size());
			this.getSqlMapClient().startBatch();
			for(Map<String, Object> p: setFrperils) {
				System.out.println("Set Perils: "+p);
				System.out.println(p.get("riCommVat"));
				this.getSqlMapClient().update("setGIRIFrperil", p);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
	}

	@Override
	public String createBindersGiris002(Map<String, Object> params)
			throws SQLException {
		String param = null;
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			Debug.print("Creating Binders... "+params);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().delete("createBindersGiris002", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("create_wbinder...");
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("createWBindersGiris002", params);
			this.getSqlMapClient().executeBatch();
			param = (String) params.get("riPremVatOld");
			Debug.print("updating wbinder done, old ri prem vat = "+params);
			
			log.info("create_wbinder_peril...");
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("createBinderPerilGiris002", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		return param;
	}

	@Override
	public Map<String, Object> computeRiPremAmt(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("computeRiPremAmtGIRIS001",params);
		return params;
	}

	@Override
	public Map<String, Object> computeRiPremVat1(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("computeRiPremVat1GIRIS001",params);
		return params;
	}

	private void updateRiComm(List<GIRIWFrpsRi> recs, String issCd) throws SQLException {
		for (GIRIWFrpsRi set : recs){
			Map<String,Object> params = new HashMap<String, Object>();
			params.put("userId", set.getUserId());
			params.put("lineCd", set.getLineCd());
			params.put("frpsYy", set.getFrpsYy());
			params.put("frpsSeqNo", set.getFrpsSeqNo());
			params.put("issCd", issCd);
			params.put("riSeqNo", set.getRiSeqNo());
			params.put("reusedBinder", set.getReusedBinder());
			System.out.println("post params:" +params);
			this.sqlMapClient.update("updateRiCommGIRIS001", params);
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveRiPlacement(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving RI Placement.");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GIRIDistFrpsWdistFrpsV giriDistFrpsWdistFrpsV = (GIRIDistFrpsWdistFrpsV) params.get("giriDistFrpsWdistFrpsV");
			List<GIRIWFrpsRi> giriWFrpsRiSetRows = (List<GIRIWFrpsRi>) params.get("giriWFrpsRiSetRows");
			List<GIRIWFrpsRi> giriWFrpsRiDelRows = (List<GIRIWFrpsRi>) params.get("giriWFrpsRiDelRows");
			
			log.info("Saving ri placement: "+ giriDistFrpsWdistFrpsV.getLineCd()+"-"+giriDistFrpsWdistFrpsV.getFrpsYy()+"-"+giriDistFrpsWdistFrpsV.getFrpsSeqNo());
			for (GIRIWFrpsRi del : giriWFrpsRiDelRows){
				log.info("Deleting : "+del.getRiSname());
				this.sqlMapClient.delete("delGiriWFrperil2", del);
				this.getSqlMapClient().executeBatch();
				this.sqlMapClient.delete("delGiriWFrpsRi2", del);
				this.getSqlMapClient().executeBatch();
			}

			for (GIRIWFrpsRi set : giriWFrpsRiSetRows){
				log.info("Inserting : "+set.getRiSname());
				Map<String, Object> preIns = new HashMap<String, Object>();
				preIns.put("userId", params.get("userId"));
				preIns.put("lineCd", set.getLineCd());
				preIns.put("frpsYy", set.getFrpsYy());
				preIns.put("frpsSeqNo", set.getFrpsSeqNo());
				preIns.put("distNo", giriDistFrpsWdistFrpsV.getDistNo());
				preIns.put("riCd", set.getRiCd());
				preIns.put("riPremAmt", set.getRiPremAmt());
				preIns.put("binderId", set.getPreBinderId()); // changed to binderId - irwin 11.27.2012
				preIns.put("riSeqNo", set.getRiSeqNo());
				
				this.sqlMapClient.update("preInsGIRIS001", preIns);	
				this.getSqlMapClient().executeBatch();
				set.setPremTax("".equals((String) preIns.get("premTax")) || (String) preIns.get("premTax") == null ? null :new BigDecimal((String) preIns.get("premTax")));
				set.setRiSeqNo((Integer) preIns.get("riSeqNo"));
				set.setPreBinderId((Integer) preIns.get("binderId"));
				set.setRenewSw((String) preIns.get("renewSw"));
				log.info("pre-insert params: "+preIns);
				System.out.println("here: "+set.getRiCommRt());
				this.sqlMapClient.insert("setGiriWFprsRi", set);
				this.getSqlMapClient().executeBatch();
			}
			
			//post-form-commit
			
			System.out.println("*****");
			System.out.println(giriDistFrpsWdistFrpsV.getDistNo());
			System.out.println(giriDistFrpsWdistFrpsV.getDistSeqNo());
			System.out.println(giriDistFrpsWdistFrpsV.getLineCd());
			System.out.println(giriDistFrpsWdistFrpsV.getFrpsYy());
			System.out.println(giriDistFrpsWdistFrpsV.getFrpsSeqNo());
			
			System.out.println(giriDistFrpsWdistFrpsV.getRiFlag());
			this.sqlMapClient.update("postFormCommitGIRIS001", giriDistFrpsWdistFrpsV);
			this.getSqlMapClient().executeBatch();
			// bonok :: 9.30.2014
			/*this.updateRiComm(giriWFrpsRiDelRows, giriDistFrpsWdistFrpsV.getIssCd());
			this.getSqlMapClient().executeBatch();
			this.updateRiComm(giriWFrpsRiSetRows, giriDistFrpsWdistFrpsV.getIssCd());
			
			this.getSqlMapClient().executeBatch();*/
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("message", "SUCCESS");
		}catch (Exception e) {
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving RI Placement.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String checkDelRecRiPlacement(String preBinderId)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkGiriWbinderExist", preBinderId);
	}

	@Override
	public Map<String, Object> adjustPremVat(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("adjustPremVatGIRIS001", params);
		return params;
	}

	@Override
	public Map<String, Object> adjustPremVatGIRIS002(Map<String, Object> params)
			throws SQLException {
		log.info("Getting params for adjust prem vat GIRIS002...");
		this.getSqlMapClient().update("adjustPremVatGIRIS002", params);
		return params;
	}

	@Override
	public String validateBinderPrinting(Map<String, Object> params)
			throws SQLException {
		log.info("Validating Binders for Printing(GIRIS002)... "+params);
		return (String) this.getSqlMapClient().queryForObject("validateBinderPrinting", params);
	}

	@Override
	public String validateFrpsPosting(Map<String, Object> params)
			throws SQLException {
		log.info("Validating if FRPS Posting allowed(GIRIS002)... "+params);
		return (String) this.getSqlMapClient().queryForObject("validateFrpsPosting", params);
	}
	
	@Override
	public Map<String, Object> getTsiPremAmt(Map<String, Object> params)
			throws SQLException {
		log.info("getting prem amt");
		System.out.println(params);
		this.sqlMapClient.update("getTsiPremAmtGiris002", params);
		System.out.println(params);
		return params;
	}
}
