package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.log4j.Logger;

import com.geniisys.gipi.controllers.PostParController;
import com.geniisys.gipi.dao.PostParDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.exceptions.PostingParException;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.ibatis.sqlmap.client.SqlMapClient;

public class PostParDAOImpl implements PostParDAO{
	
	protected static String message = "";
	private static Logger log = Logger.getLogger(PostParDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String postPar(Map<String, Object> params)
			throws SQLException, PostingParException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			
			
			Integer parId = (Integer) params.get("parId");
			String lineCd = (String) params.get("lineCd");
			String issCd = (String) params.get("issCd");
			String userId = (String) params.get("userId");
			String backEndt = (String) params.get("backEndt");
			String credBranchConf = (String) params.get("credBranchConf"); // added by andrew - 07.22.2010 - for null crediting branch confirmation
			String chkDfltIntmSw = (String) params.get("chkDfltIntmSw"); //benjo 09.07.2016 SR-5604
			Integer limit = 10;
			
			//belle 11.21.2012 added validation for unequal amt in gipi_winvoice and gipi_winstallment as per mam VJ
			Map<String, Object> paramsInstallment = new HashMap<String, Object>();
			paramsInstallment.put("parId", parId);
			log.info("Validating installment...");
			this.getSqlMapClient().update("validateInstallment", paramsInstallment);
			this.checkReturnMsg(paramsInstallment);
			
			log.info("Start of posting details...");
			log.info("PAR ID: "+parId);
			log.info("USER ID: "+userId);
			PostParController.percentStatus = getRandomNumber(limit)+"%";
			PostParController.messageStatus = "Checking details...";
			
			Map<String, Object> paramsIn = new HashMap<String, Object>();
			paramsIn.put("parId", parId.toString());
			paramsIn.put("lineCd", lineCd);
			paramsIn.put("issCd", issCd);
			paramsIn.put("userId",userId);
			paramsIn.put("credBranchConf", credBranchConf); // added by andrew - 07.22.2010 - for null crediting branch confirmation
			paramsIn.put("chkDfltIntmSw", chkDfltIntmSw); //benjo 09.07.2016 SR-5604
			this.getSqlMapClient().update("whenPostBtn", paramsIn);
			this.getSqlMapClient().executeBatch();
			PostParController.bookingMsg = (String) paramsIn.get("bookingMsg") == null || "".equals((String) paramsIn.get("bookingMsg")) ? "" :(String) paramsIn.get("bookingMsg");
			log.info("whenPostBtn post parameters : "+paramsIn);
			this.checkReturnMsg(paramsIn);
			
			
			log.info("Start of Posting...");
			PostParController.messageStatus = "Validating PAR...";
			PostParController.percentStatus = 11+getRandomNumber(limit)+"%";
			Map<String, Object> paramsA = new HashMap<String, Object>();
			paramsA.put("userId",userId);
			paramsA.put("parId", parId.toString());
			this.getSqlMapClient().update("postingProcessA", paramsA);
			this.getSqlMapClient().executeBatch();
			log.info("postingProcessA post parameters : "+paramsA);
			this.checkReturnMsg(paramsA);
			
			if(params.containsKey("authenticateCOC") && params.get("authenticateCOC").equals("Y")){
				Map<String, Object> cocParamsMap = new HashMap<String, Object>();
				cocParamsMap.put("parId", parId.toString());
				cocParamsMap.put("userId", userId);
				cocParamsMap.put("useDefaultTin", params.get("useDefaultTin"));
				log.info("Checking details for COC authentication for "+cocParamsMap);
				this.getSqlMapClient().update("validateCOCAuthentication", cocParamsMap);
				this.getSqlMapClient().executeBatch();
				this.checkReturnMsg(cocParamsMap);
			}
			
			log.info("Post pol par...");
			PostParController.messageStatus = "Post pol PAR...";
			PostParController.percentStatus = 21+getRandomNumber(limit)+"%";
			Map<String, Object> paramsPostPol = new HashMap<String, Object>();
			paramsPostPol.put("parId", parId.toString());
			paramsPostPol.put("lineCd", lineCd);
			paramsPostPol.put("issCd", issCd);
			paramsPostPol.put("userId",userId);
			paramsPostPol.put("changeStat",paramsIn.get("changeStat"));
			this.getSqlMapClient().update("postPolPar", paramsPostPol);
			this.getSqlMapClient().executeBatch();
			log.info("postPolPar post parameters : "+paramsPostPol);
			this.checkReturnMsg(paramsPostPol);
			PostParController.policyId = (String) paramsPostPol.get("policyId");
			PostParController.userId = (String) paramsPostPol.get("outUserId");
			
			log.info("Posting process B...");
			PostParController.messageStatus = "Updating Back Endt...";
			PostParController.percentStatus = 31+getRandomNumber(limit)+"%";
			Map<String, Object> paramsB = new HashMap<String, Object>();
			paramsB.put("parId", parId.toString());
			paramsB.put("userId",userId);
			this.getSqlMapClient().update("postingProcessB", paramsB);
			this.getSqlMapClient().executeBatch();
			log.info("postingProcessB post parameters : "+paramsB);
			this.checkReturnMsg(paramsB);
			
			log.info("Posting process C...");
			PostParController.messageStatus = "Process Distribution...";
			PostParController.percentStatus = 41+getRandomNumber(limit)+"%";
			Map<String, Object> paramsC = new HashMap<String, Object>();
			paramsC.put("parId", parId.toString());
			paramsC.put("lineCd", lineCd);
			paramsC.put("issCd", issCd);
			paramsC.put("policyId", paramsPostPol.get("policyId"));
			paramsC.put("userId",userId);
			this.getSqlMapClient().update("postingProcessC", paramsC);
			this.getSqlMapClient().executeBatch();
			log.info("postingProcessC post parameters : "+paramsC);
			this.checkReturnMsg(paramsC);
			
			log.info("Updating Quote...");
			PostParController.messageStatus = "Updating Quote...";
			PostParController.percentStatus = 51+getRandomNumber(limit)+"%";
			Map<String, String> paramUpdQuote = new HashMap<String, String>();
			paramUpdQuote.put("parId", parId.toString());
			paramUpdQuote.put("userId",userId);
			this.getSqlMapClient().update("updateQuote", paramUpdQuote);
			this.getSqlMapClient().executeBatch();
			log.info("updateQuote post parameters : "+paramUpdQuote);
			
			log.info("Deleting PAR...");
			PostParController.messageStatus = "Deleting PAR...";
			PostParController.percentStatus = 61+getRandomNumber(limit)+"%";
			Map<String, String> paramDelPar = new HashMap<String, String>();
			paramDelPar.put("userId",userId);
			paramDelPar.put("parId", parId.toString());
			paramDelPar.put("lineCd", lineCd);
			paramDelPar.put("issCd", issCd);
			this.getSqlMapClient().update("deletePar", paramDelPar);
			this.getSqlMapClient().executeBatch();
			log.info("deletePar post parameters : "+paramDelPar);
			
			log.info("Deleting Workflow...");
			PostParController.messageStatus = "Deleting Workflow...";
			PostParController.percentStatus = 71+getRandomNumber(limit)+"%";
			this.getSqlMapClient().update("postingProcessD", paramUpdQuote);
			log.info("postingProcessD post parameters : "+paramUpdQuote);
			
			log.info("Creating Workflow...");
			PostParController.messageStatus = "Creating Workflow...";
			PostParController.percentStatus = 81+getRandomNumber(limit)+"%";
			Map<String, Object> paramsE = new HashMap<String, Object>();
			paramsE.put("parId", parId.toString());
			paramsE.put("userId",userId);
			this.getSqlMapClient().update("postingProcessE", paramsE);
			this.getSqlMapClient().executeBatch();
			log.info("postingProcessE post parameters : "+paramsE);
			this.checkReturnMsg(paramsE);
			System.out.println("WORKFLOW MSGR: "+paramsE.get("workflowMsgr"));
			PostParController.workflowMsgr = (String) ((paramsE.get("workflowMsgr") == null) ? "" : paramsE.get("workflowMsgr"));

			log.info("Updating backstat...");
			PostParController.messageStatus = "Updating backstat...";
			PostParController.percentStatus = 91+getRandomNumber(9)+"%";
			Map<String, String> paramsF = new HashMap<String, String>();
			paramsF.put("userId",userId);
			paramsF.put("parId", parId.toString());
			paramsF.put("backEndt", backEndt);
			this.getSqlMapClient().update("postingProcessF", paramsF);
			this.getSqlMapClient().executeBatch();
			log.info("postingProcessF post parameters : "+paramsF);
			
			PostParController.messageStatus = "Posting record Successful.";
			PostParController.percentStatus = "100%";
			
			log.info("PAR ID: "+parId);
			log.info("USER ID: "+PostParController.userId);
			log.info("POLICY ID: "+PostParController.policyId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();						
			//use rollback for testing
		} catch (com.geniisys.gipi.exceptions.PostingParException e) {
			System.out.println("here exception");
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) { //added SQLException edgar 12/12/2014
			System.out.println("here SQLexception");
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			System.out.println("here exception");
			PostParController.errorStatus = "Error exception occured."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		log.info("Done posting details...");
		
		System.out.println(PostParController.percentStatus);
		return message;
	}

	@Override
	public Map<String, String> checkBackEndt(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("checkBackEndt", params);
		return params;
	}

	@Override
	public Map<String, Object> validateMC(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateMcGIPIS055", params);
		return params;
	}

	@Override
	public String postFrps(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Random generator = new Random();
			int rn = generator.nextInt(10);
			PostParController.percentStatus = rn+"%";
			PostParController.messageStatus = "Checking details...";
			
			// bonok :: 09.30.2014 :: as per Mam Jhing, records from final tables should not be deleted
			/*log.info("POSTING is now in progress. ");
			log.info("Deleting binder records.");
			this.getSqlMapClient().delete("deleteMrecordsGiris026", params);
			this.getSqlMapClient().executeBatch();*/
			
			log.info("Creating records in giri_distfrps.");
			PostParController.messageStatus = "Creating records in giri_distfrps.";
			int rn1 = generator.nextInt(10);
			PostParController.percentStatus = (21+rn1)+"%";
			
			this.getSqlMapClient().insert("createGiriDistfrpsGiris026", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Creating records in giri_frps_ri.");
			PostParController.messageStatus = "Creating records in giri_frps_ri.";
			int rn2 = generator.nextInt(10);
			PostParController.percentStatus = (41+rn2)+"%";
			this.getSqlMapClient().insert("createFrpsPerilGrpGiris026", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("createGiriFrpsRiBinder", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Creating records in giri_frperil.");
			PostParController.messageStatus = "Creating records in giri_frperil.";
			int rn3 = generator.nextInt(10);
			PostParController.percentStatus = (61+rn3)+"%";
			this.getSqlMapClient().insert("createGiriFrperilGiris026", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Creating records in giri_binder_peril.");
			PostParController.messageStatus = "Creating records in giri_binder_peril.";
			int rn4 = generator.nextInt(10);
			PostParController.percentStatus = (81+rn4)+"%";
			this.getSqlMapClient().insert("createBinderPerilGiris026", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("updateFbndrSeqGiris026", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Deleting binder records.");
			PostParController.messageStatus = "Deleting binder records.";
			int rn5 = generator.nextInt(10);
			PostParController.percentStatus = (91+rn5)+"%";
			this.getSqlMapClient().delete("deleteRecordsGiris026", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("completeRiPosting", params);
			this.getSqlMapClient().executeBatch();
			log.info("Posting complete.");
			PostParController.messageStatus = "Posting complete.";
			PostParController.percentStatus = "100%";
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit(); // SET MUNA SA ROLLBACK FOR TESTING
			
			return PostParController.messageStatus;
		}catch (Exception e){
			PostParController.errorStatus = "Error exception occured."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return PostParController.messageStatus;
	}

	private void checkReturnMsg(Map<String, Object> params) throws PostingParException{
		message = (String) ((params.get("msgAlert") == null) ? "Posting record Successful." : params.get("msgAlert"));
		if (params.get("msgType") != null && params.get("msgType").toString().equals("confirm")){
			PostParController.errorStatus = (String) params.get("msgType");
			throw new PostingParException(message);
		}else if (!message.equals("Posting record Successful.")){
			log.info("Error on Checking details...");
			PostParController.errorStatus = message;
			throw new PostingParException(message);
		}
	}
	
	private int getRandomNumber(Integer limit){
		Random generator = new Random();
		int rn = generator.nextInt(limit);
		return rn;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public String postpackPar(Map<String, Object> params) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer packParId = (Integer) params.get("packParId");
			GIPIPackPARList pack = (GIPIPackPARList) this.sqlMapClient.queryForObject("getPackParDetailsFromPackParId", packParId);
			params.put("lineCd", pack.getLineCd());
			params.put("issCd", pack.getIssCd());
			params.put("parType", pack.getParType());
			
			List<GIPIPARList> gipiParlist =  (List<GIPIPARList>) params.get("gipiParList");
			String userId = (String) params.get("userId");
			//String backEndt = (String) params.get("backEndt");
			
			//belle 11.21.2012 added validation for unequal amt in gipi_winvoice and gipi_winstallment as per mam VJ
			Map<String, Object> paramsInstallment = new HashMap<String, Object>();
			paramsInstallment.put("packParId", packParId);
			log.info("Validating pack installment...");
			this.getSqlMapClient().update("validateInstallmentPack", paramsInstallment);
			this.checkReturnMsg(paramsInstallment);
						
			log.info("Start of posting package details...");
			log.info("PACK PAR ID: "+packParId);
			log.info("USER ID: "+userId);
			log.info("Size: "+gipiParlist.size());
			
			log.info("postPackagePar parameters: "+ params);
			PostParController.percentStatus = getRandomNumber(3)+"%";
			PostParController.messageStatus = "Checking details...";
			this.getSqlMapClient().update("postPackagePar", params);
			this.getSqlMapClient().executeBatch();
			this.checkReturnMsg(params);
			
			log.info("Per Par parameters: "+ params);
			PostParController.percentStatus = (3+getRandomNumber(8))+"%";
			PostParController.messageStatus = "Checking details per PAR...";
			this.getSqlMapClient().update("postPackagePerPar", params);
			this.getSqlMapClient().executeBatch();
			PostParController.bookingMsg = (String) params.get("bookingMsg") == null || "".equals((String) params.get("bookingMsg")) ? "" :(String) params.get("bookingMsg");
			this.checkReturnMsg(params);
			
			if(params.containsKey("authenticateCOC") && params.get("authenticateCOC").equals("Y")){
				Map<String, Object> cocParamsMap = new HashMap<String, Object>();
				cocParamsMap.put("packParId", packParId.toString());
				cocParamsMap.put("userId", userId);
				cocParamsMap.put("useDefaultTin", params.get("useDefaultTin"));
				log.info("Checking details for COC authentication for "+cocParamsMap);				
				this.getSqlMapClient().update("validatePackCOCAuthentication", cocParamsMap);
				this.getSqlMapClient().executeBatch();
				this.checkReturnMsg(cocParamsMap);
			}
						
			//POST_PACK part 
			log.info("copyPackPolWPolbas parameters: "+ params);
			PostParController.percentStatus = (11+getRandomNumber(10))+"%";
			PostParController.messageStatus = "Finalising Package Basic info...";
			this.getSqlMapClient().update("copyPackPolWPolbas", params);	
			this.getSqlMapClient().executeBatch();
			this.checkReturnMsg(params);
			PostParController.policyId = (String) params.get("packPolicyId");
			
			log.info("copyPackPolWPolgenin parameters: "+ params);
			PostParController.percentStatus = (21+getRandomNumber(9))+"%";
			PostParController.messageStatus = "Finalising Package General info...";
			this.getSqlMapClient().update("copyPackPolWPolgenin", params);	
			this.getSqlMapClient().executeBatch();
			this.checkReturnMsg(params);
			
			log.info("copyPackPolWPolnrep parameters: "+ params);
			PostParController.percentStatus = (30+getRandomNumber(8))+"%";
			PostParController.messageStatus = "Finalising Package Policy History info...";
			this.getSqlMapClient().update("copyPackPolWPolnrep", params);	
			this.getSqlMapClient().executeBatch();
			
			log.info("copyPackPolWInpolbas parameters: "+ params);
			PostParController.percentStatus = (38+getRandomNumber(7))+"%";
			PostParController.messageStatus = "Finalising Package Re-insurance info...";
			this.getSqlMapClient().update("copyPackPolWInpolbas", params);	
			this.getSqlMapClient().executeBatch();
			//post_pack
			
			log.info("insertPackParhist parameters: "+ params);
			PostParController.percentStatus = (45+getRandomNumber(7))+"%";
			PostParController.messageStatus = "Updating Package PAR history...";
			this.getSqlMapClient().update("insertPackParhist", params);	
			this.getSqlMapClient().executeBatch();
			
			log.info("updatePackParStatus2 parameters: "+ params);
			PostParController.percentStatus = (52+getRandomNumber(7))+"%";
			PostParController.messageStatus = "Updating Package PAR status...";
			this.getSqlMapClient().update("updatePackParStatus2", params);	
			this.getSqlMapClient().executeBatch();
			
			//INITIALIZE_PACK_GLOBAL
			log.info("postPackage parameters: "+ params);
			PostParController.percentStatus = (59+getRandomNumber(10))+"%";
			PostParController.messageStatus = "Posting Package info...";
			this.getSqlMapClient().update("postPackage", params);	
			this.getSqlMapClient().executeBatch();
			this.checkReturnMsg(params);
			
			log.info("postParPackage parameters: "+ params);
			PostParController.percentStatus = (69+getRandomNumber(10))+"%";
			PostParController.messageStatus = "Posting PAR info...";
			this.getSqlMapClient().update("postParPackage", params);	
			this.getSqlMapClient().executeBatch();
			this.checkReturnMsg(params);
			
			log.info("copyPackPolWInvoice parameters: "+ params);
			PostParController.percentStatus = (79+getRandomNumber(9))+"%";
			PostParController.messageStatus = "Finalising Bill info...";
			this.getSqlMapClient().update("copyPackPolWInvoice", params);	
			this.getSqlMapClient().executeBatch();
			this.checkReturnMsg(params);
			
			log.info("deletePack parameters: "+ params);
			PostParController.percentStatus = 88+getRandomNumber(8)+"%";
			PostParController.messageStatus = "Deleting Package related records...";
			this.getSqlMapClient().delete("deletePack", params);	
			this.getSqlMapClient().executeBatch();
			
			log.info("FINAL POST PACKAGE PARAMETERS: "+ params);
			PostParController.messageStatus = "Posting record Successful.";
			PostParController.percentStatus = "100%";
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (com.geniisys.gipi.exceptions.PostingParException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			PostParController.errorStatus = "Error exception occured."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		log.info("Done posting package details...");
		
		System.out.println(PostParController.percentStatus);
		return message;
	}

	@Override
	public String checkBackEndtPack(Integer packParId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkBackEndtPack", packParId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getParCancellationMsg(Integer parId) throws SQLException {
		return this.sqlMapClient.queryForList("cancellationMsgPostPar", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getParCancellationMsg2(Integer packParId)
			throws SQLException {
		return this.sqlMapClient.queryForList("cancellationMsgPostPackPar", packParId);
	}

	@Override
	public void validateInstallment(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.queryForObject("validateInstallment", params);
	}
	
	//COC Authentication
	@Override
	public String checkCOCAuthentication(Map<String, Object> params)
			throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("checkCOCAuthentication", params);
	}

	@Override
	public String checkPackCOCAuthentication(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkPackCOCAuthentication", params);
	}
	
}
