package com.geniisys.giac.dao.impl;


import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.dao.GIACDisbursementUtilitiesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACDisbursementUtilitiesDAOImpl implements GIACDisbursementUtilitiesDAO{
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIACDisbursementUtilitiesDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public Map<String, Object> validateRequestNo(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().update("giacs045ValidateRequestNo", params);
			return params;
		} catch (SQLException e) {
			throw e;
		}
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getBillInformationDtls(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIACS408BillInfoDtls", params);
	}
	
	@Override
	public Map<String, Object> giacs408ValidateBillNo(Map<String, Object> params)
			throws SQLException {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("row", this.getSqlMapClient().queryForObject("giacs408ValidateBillNo", params));
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getGiacs408PerilList(Map<String, Object> params) throws SQLException{
		log.info("Retrieving all peril..."+params.toString());
		return this.sqlMapClient.queryForList("getGiacs408PerilList", params);
	}
	
	@Override
	public Map<String, Object> copyPaymentRequest(Map<String, Object> params)throws SQLException {
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("giacs045checkCreateTransaction", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045InsertIntoAcctrans", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045CopyPaymentRequest", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> copyPaymentRequest2(Map<String, Object> params) throws SQLException {
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("giacs045checkCreateTransaction", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045InsertIntoAcctrans", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045CopyPaymentRequest", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045CopyWithHolding", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045CopyInputVat", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs045CopyAcctgEntriesLooper", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public String giacs045ValidateDocumentCd(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs045ValidateDocumentCd", params);
	}
	@Override
	public String giacs045ValidateBranchCdFrom(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs045ValidateBranchCdFrom", params);
	}
	@Override
	public String giacs045ValidateLineCd(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs045ValidateLineCd", params);
	}
	@Override
	public String giacs045ValidateDocYear(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs045ValidateDocYear", params);
	}
	@Override
	public String giacs045ValidateDocMm(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs045ValidateDocMm", params);
	}
	@Override
	public String giacs045ValidateBranchCdTo(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs045ValidateBranchCdTo", params);
	}
	
	@Override
	public Map<String, Object> giacs408ChkBillNoOnSelect(Map<String, Object> params) throws SQLException {
		System.out.println("giacs408ChkBillNoOnSelect pre: "+params);
		this.sqlMapClient.update("giacs408ChkBillNoOnSelect", params);
		System.out.println("giacs408ChkBillNoOnSelect post: "+params);
		return params;
	}
	@Override
	public void populateInvoiceCommPeril(Map<String, Object> params)
			throws SQLException {
		try{
			System.out.println("populateInvoiceCommPeril params " + params.toString());
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("populateInvoiceCommPeril", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	public Map<String, Object> validateInvCommShare(Map<String, Object> params)
			throws SQLException {
		System.out.println("validateInvCommShare params " + params.toString());
		this.getSqlMapClient().update("validateInvCommShare", params);
		return params;
	}
	
	public Map<String, Object> validatePerilCommRt(Map<String, Object> params)
			throws SQLException {
		System.out.println("validatePerilCommRt params " + params.toString());
		this.getSqlMapClient().update("validatePerilCommRt", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>>  getObjInsertUpdateInvperl(Map<String, Object> params) throws SQLException {
		System.out.println("getObjInsertUpdateInvperl "+params.toString());
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getObjInsertUpdateInvperl", params);
	}
	
	@Override
	public BigDecimal recomputeCommissionRt(Map<String, Object> params)
			throws SQLException {
		BigDecimal commissionRt = null;	
		commissionRt = (BigDecimal)this.getSqlMapClient().queryForObject("giacs408RecomputeCommissionRt", params);
		commissionRt = commissionRt == null ? new BigDecimal(0) : commissionRt;
		return commissionRt;
	}
	
	@Override
	public BigDecimal recomputeWtaxRate(Integer intmNo)
			throws SQLException {
		BigDecimal wtaxRate = null;	
		wtaxRate = (BigDecimal)this.getSqlMapClient().queryForObject("giacs408RecomputeWtaxRate", intmNo);
		wtaxRate = wtaxRate == null ? new BigDecimal(0) : wtaxRate;
		return wtaxRate;
	}
	@Override
	public void cancelInvoiceCommission(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("cancelInvoiceCommission params " + params.toString());
			this.getSqlMapClient().update("cancelInvoiceCommission", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@SuppressWarnings("unchecked")
	@Override
	public String saveInvoiceCommission(Map<String, Object> params)
			throws SQLException, ParseException {
		log.info("Start of saving Recovery Distribution.");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> setPerilInfo = (List<Map<String, Object>>) params.get("setPerilInfo");
			List<Map<String, Object>> setInvComm = (List<Map<String, Object>>) params.get("setInvComm");
			List<Map<String, Object>> delInvComm = (List<Map<String, Object>>) params.get("delInvComm");
			
			log.info("...");
			Map<String, Object> delInvCommParam = new HashMap<String, Object>();
			for(int i=0; i<delInvComm.size(); i++){
				delInvCommParam.clear();
				delInvCommParam.put("fundCd", delInvComm.get(i).get("fundCd"));
				delInvCommParam.put("branchCd", delInvComm.get(i).get("branchCd"));
				delInvCommParam.put("commRecId", Integer.parseInt(delInvComm.get(i).get("commRecId").toString()));
				delInvCommParam.put("intmNo", Integer.parseInt(delInvComm.get(i).get("intmNo").toString()));
				System.out.println("delInvCommParam "+ delInvCommParam.toString());
				this.getSqlMapClient().update("giacs408DeleteCommInv", delInvCommParam);
			}
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> setInvCommParam = new HashMap<String, Object>();
			for(int i=0; i<setInvComm.size(); i++) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				setInvCommParam.clear();
				setInvCommParam.put("fundCd", setInvComm.get(i).get("fundCd"));
				setInvCommParam.put("branchCd", setInvComm.get(i).get("branchCd"));
				setInvCommParam.put("commRecId", Integer.parseInt(setInvComm.get(i).get("commRecId").toString()));
				setInvCommParam.put("intmNo", Integer.parseInt(setInvComm.get(i).get("intmNo").toString()));
				setInvCommParam.put("issCd", setInvComm.get(i).get("issCd"));
				setInvCommParam.put("premSeqNo", Integer.parseInt(setInvComm.get(i).get("premSeqNo").toString()));
				setInvCommParam.put("policyId", Integer.parseInt(setInvComm.get(i).get("policyId").toString()));
				setInvCommParam.put("sharePercentage", new BigDecimal(setInvComm.get(i).get("sharePercentage").toString()));
				setInvCommParam.put("premiumAmt", new BigDecimal(setInvComm.get(i).get("premiumAmt").toString()));
				setInvCommParam.put("commissionAmt", new BigDecimal(setInvComm.get(i).get("commissionAmt").toString()));
				setInvCommParam.put("wholdingTax", new BigDecimal(setInvComm.get(i).get("wholdingTax").toString()));
				setInvCommParam.put("tranDate", setInvComm.get(i).get("tranDate") == null ? null : sdf.parse((String) setInvComm.get(i).get("tranDate")));
				setInvCommParam.put("tranFlag", setInvComm.get(i).get("tranFlag"));
				setInvCommParam.put("tranNo", Integer.parseInt(setInvComm.get(i).get("tranNo").toString()));
				setInvCommParam.put("deleteSw", setInvComm.get(i).get("deleteSw"));
				setInvCommParam.put("remarks", setInvComm.get(i).get("remarks"));
				setInvCommParam.put("userId", params.get("userId"));
				System.out.println("setInvCommParam "+ setInvCommParam.toString());
				this.getSqlMapClient().update("giacs408UpdateCommInv", setInvCommParam);
			}
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> setPerilParam = new HashMap<String, Object>();
			for(int i=0; i<setPerilInfo.size(); i++) {
				setPerilParam.clear();
				setPerilParam.put("fundCd", setPerilInfo.get(i).get("fundCd"));
				setPerilParam.put("branchCd", setPerilInfo.get(i).get("branchCd"));
				setPerilParam.put("commRecId", Integer.parseInt(setPerilInfo.get(i).get("commRecId").toString()));
				setPerilParam.put("intmNo", Integer.parseInt(setPerilInfo.get(i).get("intmNo").toString()));
				setPerilParam.put("commPerilId", Integer.parseInt(setPerilInfo.get(i).get("commPerilId").toString()));
				//setPerilParam.put("commissionRt", (setPerilInfo.get(i).get("commissionRt") == null ? null : new BigDecimal(setPerilInfo.get(i).get("commissionRt").toString())));
				setPerilParam.put("commissionRt", setPerilInfo.get(i).get("commissionRt").toString());
				setPerilParam.put("premiumAmt", new BigDecimal(setPerilInfo.get(i).get("premiumAmt").toString()));
				setPerilParam.put("commissionAmt", new BigDecimal(setPerilInfo.get(i).get("commissionAmt").toString()));
				setPerilParam.put("wholdingTax", new BigDecimal(setPerilInfo.get(i).get("wholdingTax").toString()));
				setPerilParam.put("deleteSw", setPerilInfo.get(i).get("deleteSw"));
				setPerilParam.put("tranNo", Integer.parseInt(setPerilInfo.get(i).get("tranNo").toString()));
				setPerilParam.put("tranFlag", setPerilInfo.get(i).get("tranFlag"));
				setPerilParam.put("perilCd", Integer.parseInt(setPerilInfo.get(i).get("perilCd").toString()));
				setPerilParam.put("premSeqNo", Integer.parseInt(setPerilInfo.get(i).get("premSeqNo").toString()));
				setPerilParam.put("issCd", setPerilInfo.get(i).get("issCd"));

				System.out.println("setPerilParam: "+ setPerilParam.toString());
				this.getSqlMapClient().update("giacs408UpdateCommInvPeril", setPerilParam);
			}
			this.getSqlMapClient().executeBatch();

			//keyCommit
			Map<String, Object> keyCommitParams = new HashMap<String, Object>();
			keyCommitParams.put("issCd", params.get("issCd"));
			keyCommitParams.put("premSeqNo", Integer.parseInt(params.get("premSeqNo").toString()));
			keyCommitParams.put("fundCd", params.get("fundCd"));
			keyCommitParams.put("branchCd", params.get("branchCd"));
			
			this.getSqlMapClient().update("keyCommitGIACS408", keyCommitParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {			
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving Invoice Commission.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@Override
	public String checkInvoicePayt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("checkInvPytGIACS408", params);
		return (String) params.get("message");
	}
	
	@Override
	public Map<String, Object> checkRecord(Map<String, Object> params) throws SQLException {
		System.out.println("checkRecord params " + params);
		this.getSqlMapClient().queryForObject("checkRecordGIACS408", params);
		System.out.println("checkRecord result " + params);
		return params;
	}
	
	@Override
	public String keyDelRecGIACS408(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("keyDelRecGIACS408", params);
		return (String) params.get("message");
	}
	
	@Override
	public String postInvoiceCommission(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Start of posting Invoice Commission.");
		String message = "Bill No. "+ params.get("issCd") + " - "+ params.get("premSeqNo") +" has been Posted.";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("postInvoiceCommission params " + params.toString());
			this.getSqlMapClient().update("postInvCommGIACS408", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> showBancAssurance(Integer policyId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGiacs408BancType", policyId);
	}
	@Override
	public Map<String, Object> checkBancAssurance(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("checkBancAssurance", params);
		return params;
	}
	@SuppressWarnings("unchecked")
	@Override
	public String applyBancAssurance(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String vModBtyp = (String) params.get("vModBtyp");
			
			Map<String, Object> applyParams = new HashMap<String, Object>();
			applyParams.put("vModBtyp", params.get("vModBtyp"));
			applyParams.put("fundCd", params.get("fundCd"));
			applyParams.put("branchCd", params.get("branchCd"));
			applyParams.put("bancaNbtBancTypeCd", params.get("bancaNbtBancTypeCd"));
			applyParams.put("b140PolicyId", Integer.parseInt(params.get("b140PolicyId").toString()));
			applyParams.put("b140IssCd", params.get("b140IssCd"));
			applyParams.put("b140PremSeqNo", Integer.parseInt(params.get("b140PremSeqNo").toString()));
			
			this.getSqlMapClient().update("applyBancAssurance", applyParams);
			this.getSqlMapClient().executeBatch();
			System.out.println("applyBancAssurance "+applyParams);
			
			if(vModBtyp.equals("Y")){
				List<Map<String, Object>> setBancaInfo = (List<Map<String, Object>>) params.get("setBancAssurance");
				Map<String, Object> setBancaParam = new HashMap<String, Object>();
				
				for(int i=0; i<setBancaInfo.size(); i++) {
					setBancaParam.clear();
					setBancaParam.put("userId", params.get("userId"));
					setBancaParam.put("b140PremAmt", new BigDecimal(params.get("b140PremAmt").toString()));
					setBancaParam.put("b140NbtLineCd", params.get("b140NbtLineCd"));
					setBancaParam.put("b140IssCd", params.get("b140IssCd"));
					setBancaParam.put("b140PremSeqNo", Integer.parseInt(params.get("b140PremSeqNo").toString()));
					setBancaParam.put("bancaNbtBancTypeCd", params.get("bancaNbtBancTypeCd"));
					setBancaParam.put("fundCd", params.get("fundCd"));
					setBancaParam.put("branchCd", params.get("branchCd"));
					setBancaParam.put("b140PolicyId", Integer.parseInt(params.get("b140PolicyId").toString()));
					setBancaParam.put("sharePercentage", new BigDecimal(setBancaInfo.get(i).get("sharePercentage").toString()));
					setBancaParam.put("intmNo", Integer.parseInt(setBancaInfo.get(i).get("intmNo").toString()));
					
					System.out.println(i +" setBancaParam vModBtyp = Y: "+ setBancaParam.toString());
					this.getSqlMapClient().update("insInvTab", setBancaParam);
				}
				this.getSqlMapClient().executeBatch();
			}else{
				List<Map<String, Object>> setBancaInfoN = (List<Map<String, Object>>) params.get("setBancAssurance");
				Map<String, Object> setBancaParamN = new HashMap<String, Object>();
				
				for(int i=0; i<setBancaInfoN.size(); i++) {
					setBancaParamN.clear();
					setBancaParamN.put("userId", params.get("userId"));
					setBancaParamN.put("b140PremAmt", new BigDecimal(params.get("b140PremAmt").toString()));
					setBancaParamN.put("b140NbtLineCd", params.get("b140NbtLineCd"));
					setBancaParamN.put("b140IssCd", params.get("b140IssCd"));
					setBancaParamN.put("b140PremSeqNo", Integer.parseInt(params.get("b140PremSeqNo").toString()));
					setBancaParamN.put("bancaNbtBancTypeCd", params.get("bancaNbtBancTypeCd"));
					setBancaParamN.put("fundCd", params.get("fundCd"));
					setBancaParamN.put("branchCd", params.get("branchCd"));
					setBancaParamN.put("b140PolicyId", Integer.parseInt(params.get("b140PolicyId").toString()));
					setBancaParamN.put("sharePercentage", new BigDecimal(setBancaInfoN.get(i).get("sharePercentage").toString()));
					setBancaParamN.put("intmNo", Integer.parseInt(setBancaInfoN.get(i).get("intmNo").toString()));
					setBancaParamN.put("modTag", params.get("modTag"));
					
					System.out.println(i +" setBancaParam vModBtyp = N: "+ setBancaParamN.toString());
					this.getSqlMapClient().update("applyBancAssuranceN", setBancaParamN);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			//this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving Invoice Commission.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> recomputeCommRateGiacs408(Map<String, Object> params) throws SQLException {
		Map<String, Object> setReCommRtParam = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> setReCommRt = (List<Map<String, Object>>) params.get("setReCommRt");
			
			System.out.println("before loop "+setReCommRt);
			for(int i=0; i<setReCommRt.size(); i++) {
				setReCommRtParam.put("lineCd", params.get("lineCd"));
				setReCommRtParam.put("sublineCd", params.get("sublineCd"));
				setReCommRtParam.put("b140IssCd", params.get("b140IssCd"));
				setReCommRtParam.put("b140PremSeqNo", Integer.parseInt(params.get("b140PremSeqNo").toString()));
				setReCommRtParam.put("b140PolicyId", Integer.parseInt(params.get("b140PolicyId").toString()));
				setReCommRtParam.put("perilCd", Integer.parseInt(setReCommRt.get(i).get("perilCd").toString()));
				setReCommRtParam.put("intmNo", Integer.parseInt(setReCommRt.get(i).get("intmNo").toString()));
				setReCommRtParam.put("premiumAmt", new BigDecimal(setReCommRt.get(i).get("premiumAmt").toString()));
				setReCommRtParam.put("wTaxRate", new BigDecimal(params.get("wTaxRate").toString()));
				
				System.out.println(i +" setReCommRtParam: "+ setReCommRtParam.toString());
				this.getSqlMapClient().update("recomputeCommRate", setReCommRtParam);
				this.getSqlMapClient().executeBatch();
				
				list.add(setReCommRtParam);
			}
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (SQLException e) {			
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving Invoice Commission.");
			this.getSqlMapClient().endTransaction();
		}
		return list;
	}
	@Override
	public JSONObject getAdjustedPremAmt(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Adjusting the Premium Amout...");
			log.info("Parameters:" + params);
			this.getSqlMapClient().update("getAdjustedPremAmt", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {			
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return new JSONObject(params);
	}
	
	public List<Map<String, Object>> getGIACS408InvoiceCommList(Map<String, Object> params) throws SQLException{
		log.info("Retrieving all invoice comm..."+params.toString());
		return this.sqlMapClient.queryForList("getGIACS408InvoiceCommList", params);
	}
}