package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACInwFaculPremCollnsDAO;
import com.geniisys.giac.entity.GIACInwFaculPremCollns;
import com.geniisys.giac.exceptions.InvalidInwardFaculDataException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACInwFaculPremCollnsDAOImpl implements GIACInwFaculPremCollnsDAO{
	
	private static Logger log = Logger.getLogger(GIACInwFaculPremCollnsDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInwFaculPremCollns> getGIACInwFaculPremCollns(Map<String, Object> params) throws SQLException {
		return getSqlMapClient().queryForList("getGIACInwFaculPremCollns", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getInvoiceList(HashMap<String, Object> params) 
		throws SQLException {
		return this.sqlMapClient.queryForList("getInwFaculInvoiceListing", params);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getInvoice(HashMap<String, Object> params) throws SQLException{
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getInvoiceDetails",params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getInstNoList(
			HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getInwFaculInstNoListing", params);
	}

	@Override
	public String validateInvoice(HashMap<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateInvoiceInwFacul", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> validateInstNo(HashMap<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.sqlMapClient.queryForObject("validateInstNoInwFacul", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInwardFacul(Map<String, Object> params) throws SQLException, InvalidInwardFaculDataException {
		String message = "SUCCESS";
		String vCursorExist = "N";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
		
			List<GIACInwFaculPremCollns> inwFaculItems = (List<GIACInwFaculPremCollns>) params.get("inwFaculItems");
			List<GIACInwFaculPremCollns> inwFaculDelItems = (List<GIACInwFaculPremCollns>) params.get("inwFaculDelItems");
			String globalTranSource = (String) params.get("globalTranSource");
			String globalOrFlag = (String) params.get("globalOrFlag");
			Integer gaccTranId = (Integer) params.get("gaccTranId"); 
			String globalGaccBranchCd = (String) params.get("globalGaccBranchCd");
			String globalGaccFundCd = (String) params.get("globalGaccFundCd");
			String userId = (String) params.get("userId");
			
			for(GIACInwFaculPremCollns inwDel:inwFaculDelItems){
				log.info("Pre-delete ADD_RI_SOA_DETAILS for: "+inwDel.getA180RiCd()+","+inwDel.getB140PremSeqNo()+","+inwDel.getInstNo());
				this.getSqlMapClient().insert("addRiSoaDetails", inwDel);
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting Inward Facul Prem Collns: "+inwDel.getGaccTranId()+","+inwDel.getTransactionType()+","+inwDel.getB140IssCd()+","+inwDel.getA180RiCd()+","+inwDel.getB140PremSeqNo()+","+inwDel.getInstNo());
				this.getSqlMapClient().delete("delGIACInwfaculPremCollns", inwDel);
				this.getSqlMapClient().executeBatch();
			}
				
			for(GIACInwFaculPremCollns inw:inwFaculItems){
				if (inw.getSavedItems().equals("N")){
					log.info("Pre-insert SUBT_RI_SOA_DETAILS for: "+inw.getA180RiCd()+","+inw.getB140PremSeqNo()+","+inw.getInstNo());
					this.getSqlMapClient().insert("subtRiSoaDetails", inw);
					this.getSqlMapClient().executeBatch();
					
					log.info("Saving Inward Facul Prem Collns: "+inw.getGaccTranId()+","+inw.getTransactionType()+","+inw.getB140IssCd()+","+inw.getA180RiCd()+","+inw.getB140PremSeqNo()+","+inw.getInstNo());
					this.getSqlMapClient().insert("setGIACInwfaculPremCollns", inw);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			Map<String, Object> slTypeParams = new HashMap<String, Object>();
			slTypeParams = (Map<String, Object>) this.sqlMapClient.queryForObject("getSlTypeParameters", "GIACS008");
			this.getSqlMapClient().executeBatch();
			if (slTypeParams.get("vMsgAlert") != null){
				message = "Error occured. "+(String) slTypeParams.get("vMsgAlert");
				throw new InvalidInwardFaculDataException(message);
			}
			
			//KEY-COMMIT form trigger
			this.getSqlMapClient().executeBatch();
			if (globalTranSource.equals("OP") || globalTranSource.equals("OR")){
				if (!globalOrFlag.equals("P")){
					Map<String, Object> paramsDel = new HashMap<String, Object>();
					paramsDel.put("gaccTranId", gaccTranId);
					paramsDel.put("genType", (String) slTypeParams.get("variablesGenType"));
					log.info("Deleting GIAC_OP_TEXT: "+paramsDel);
					this.getSqlMapClient().delete("deleteGIACOpText", paramsDel);
					this.getSqlMapClient().executeBatch();
					
					this.keyCommitFormTrigger(getGIACInwFaculPremCollns(params), slTypeParams, vCursorExist);
					
					log.info("Deleting GIAC_OP_TEXT where item_amt = 0: "+paramsDel);
					this.getSqlMapClient().delete("deleteGIACOpText2", paramsDel);
					this.getSqlMapClient().executeBatch();
				}
			}else if (globalTranSource.equals("DV")){
				Map<String, Object> updateDvText = new HashMap<String, Object>();
				updateDvText.put("gaccTranId", gaccTranId);
				updateDvText.put("genType", (String) slTypeParams.get("variablesGenType"));
				updateDvText.put("userId", userId);
				log.info("Updating GIAC_DV_TEXT table.");
				this.getSqlMapClient().update("updateGiacDVtextInwfacul", updateDvText);
				this.getSqlMapClient().executeBatch();
			}
			
			//POST-FORM-COMMIT
			this.getSqlMapClient().executeBatch();
			Map<String, Object> paramAeg = new HashMap<String, Object>();
			paramAeg.put("aegTranId", gaccTranId);
			paramAeg.put("aegModuleNm", (String) slTypeParams.get("variablesModuleName"));
			paramAeg.put("aegSlTypeCd1", (String) slTypeParams.get("variablesSlTypeCd1"));
			paramAeg.put("aegSlTypeCd2", (String) slTypeParams.get("variablesSlTypeCd2"));
			paramAeg.put("genType", (String) slTypeParams.get("variablesGenType"));
			paramAeg.put("moduleId", (BigDecimal) slTypeParams.get("variablesModuleId"));
			paramAeg.put("gaccBranchCd", globalGaccBranchCd);
			paramAeg.put("gaccFundCd", globalGaccFundCd);
			paramAeg.put("userId", userId);
			log.info("start aeg_parameters: "+paramAeg);
			this.sqlMapClient.queryForObject("aegParameters2", paramAeg);
			this.getSqlMapClient().executeBatch();
			if (paramAeg.get("vMsgAlert") != null){
				message = "Error occured. "+(String) paramAeg.get("vMsgAlert");
				throw new InvalidInwardFaculDataException(message);
			}
			log.info("Post form commit: aeg_parameters "+paramAeg);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		}catch (com.geniisys.giac.exceptions.InvalidInwardFaculDataException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of Saving Inward Facul Prem Collns.");
		}
		return message;
	}
	
	public void keyCommitFormTrigger(List<GIACInwFaculPremCollns> inwFaculItems, Map<String, Object> slTypeParams,String vCursorExist) throws SQLException{
		for(GIACInwFaculPremCollns inw:inwFaculItems){
			Map<String, Object> paramsOpText = new HashMap<String, Object>();
			paramsOpText.put("a180RiCd", inw.getA180RiCd());
			paramsOpText.put("b140IssCd", inw.getB140IssCd());
			paramsOpText.put("b140PremSeqNo", inw.getB140PremSeqNo());
			paramsOpText.put("instNo", inw.getInstNo());
			paramsOpText.put("gaccTranId", inw.getGaccTranId());
			paramsOpText.put("zeroPremOpText", "Y");
			paramsOpText.put("genType", (String) slTypeParams.get("variablesGenType"));
			paramsOpText.put("evatName", (String) slTypeParams.get("variablesEvatName"));
			paramsOpText.put("userId", inw.getUserId());
			log.info("Generate OP text : "+paramsOpText);
			this.sqlMapClient.queryForObject("genOpTextInwardFacul", paramsOpText);
			this.getSqlMapClient().executeBatch();
			vCursorExist = (String) paramsOpText.get("vCursorExist");
		}
		log.info("cursor exist : "+vCursorExist);
		if (vCursorExist.equals("N")){
			String opText = "Y";
			for(GIACInwFaculPremCollns inw:inwFaculItems){
				Map<String, Object> paramsOpText = new HashMap<String, Object>();
				paramsOpText.put("b140IssCd", inw.getB140IssCd());
				paramsOpText.put("b140PremSeqNo", inw.getB140PremSeqNo());
				paramsOpText.put("premiumAmt", inw.getPremiumAmt());
				paramsOpText.put("txAmount", inw.getTaxAmount());
				paramsOpText.put("commAmt", inw.getCommAmt());
				paramsOpText.put("commVat", inw.getCommVat());
				paramsOpText.put("currenyCd", inw.getCurrencyCd());
				paramsOpText.put("currenyRt", inw.getConvertRate());
				paramsOpText.put("zeroPremOpText", opText);
				paramsOpText.put("gaccTranId", inw.getGaccTranId());
				paramsOpText.put("genType", (String) slTypeParams.get("variablesGenType"));
				paramsOpText.put("evatName", (String) slTypeParams.get("variablesEvatName"));
				paramsOpText.put("a180RiCd", inw.getA180RiCd());
				paramsOpText.put("userId", inw.getUserId());
				log.info("insertUpdateGiacOpText: "+paramsOpText);
				this.getSqlMapClient().update("insertUpdateGiacOpText", paramsOpText);
				this.getSqlMapClient().executeBatch();
				opText = "N";
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInwFaculPremCollns> getRelatedInwFaculPremCollns(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getRelatedInwPremCollns",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getInvoiceListTableGrid(
			HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getInvoiceListTableGrid", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInwFaculPremCollns> getOtherInwFaculPremCollns(Integer gaccTranId)throws SQLException {
		return this.sqlMapClient.queryForList("getOtherInwPremCollns", gaccTranId);
	}
	
	//added john 11.3.2014
	@Override
	public String checkPremPaytForRiSpecial(HashMap<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPremPaytForRiSpecial", params);
	}
	
	//added john 11.3.2014
	@Override
	public String checkPremPaytForCancelled(HashMap<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPremPaytForCancelled", params);
	}
	
	//added john 2.24.2015
	@Override
	public String validateDelete(String gaccTranId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateDeleteGiacs008", Integer.parseInt(gaccTranId));
	}
	
	@Override
	public void updateOrDtls(Map<String, Object> params) throws SQLException { //Deo [01.20.2017]: SR-5909
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("updateOrDtls", params);
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e) {
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public Map<String, Object> getUpdatedOrDtls(HashMap<String, Object> params) throws SQLException { //Deo [01.20.2017]: SR-5909
		this.sqlMapClient.update("getUpdatedOrDtls", params);
		return params;
	}
}
