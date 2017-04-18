package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.framework.util.DAOImpl;
import com.geniisys.giac.controllers.GIACPaytRequestsController;
import com.geniisys.giac.dao.GIACPaytRequestsDAO;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;
import com.geniisys.giac.entity.GIACPaytRequestsDtl;
import com.geniisys.gipi.exceptions.PostingParException;

public class GIACPaytRequestsDAOImpl extends DAOImpl implements GIACPaytRequestsDAO {

	private static Logger log = Logger.getLogger(GIACPaytRequestsDAOImpl.class);

	@Override
	public Object getGiacPaytRequests(Map<String, Object> params)
			throws SQLException {
		return getSqlMapClient().queryForObject("getGiacPaytRequests", params);
	}

	@Override
	public void saveDisbursmentRequest(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			GIACPaytRequests giacPaytRequests = (GIACPaytRequests) params.get("giacPaytRequests");
			GIACPaytRequestsDtl giacPaytRequestsDtl  = (GIACPaytRequestsDtl) params.get("giacPaytRequestsDtl");
			String newRec = (String) params.get("newRec");
			//add_direct_claim_payments
			if (newRec.equals("Y")){
				log.info("Getting new refId..");
				giacPaytRequests.setRefId((Integer) getSqlMapClient().queryForObject("getNewRefId"));
				giacPaytRequests.setWithDv("N");
				log.info("New Ref Ud: "+giacPaytRequests.getRefId());
				giacPaytRequests.setCreateBy((String) params.get("userId"));
				log.info("INSERTING NEW GIAC_PAYT_REQUESTs");
				
				// for new record
				giacPaytRequestsDtl.setReqDtlNo(1);
				giacPaytRequestsDtl.setPaytReqFlag("N");
			}
			getSqlMapClient().update("setGiacPaytRequests", giacPaytRequests);
			getSqlMapClient().executeBatch();
			// get full details after saving
			giacPaytRequests = (GIACPaytRequests) getSqlMapClient().queryForObject("getGiacPaytRequests", giacPaytRequests.getRefId());
			
			giacPaytRequestsDtl.setGprqRefId(giacPaytRequests.getRefId());
			
			if (newRec.equals("Y")){
				//GRQD PRE INSERT
				String label = giacPaytRequests.getDocumentCd()+"-"+giacPaytRequests.getDspBranchName()+"-"+giacPaytRequests.getBranchCd()+"-"+
				(giacPaytRequests.getLineCd() == null ? "" : giacPaytRequests.getLineCd()+"-")+giacPaytRequests.getDocYear()+"-"+giacPaytRequests.getDocMm()+"-"+giacPaytRequests.getDocSeqNo();
				Map<String, Object> preInsertParams = new HashMap<String, Object>();
				preInsertParams.put("fundCd", giacPaytRequests.getFundCd());
				preInsertParams.put("branchCd", giacPaytRequests.getBranchCd());
				preInsertParams.put("refId", giacPaytRequests.getRefId());
				preInsertParams.put("userId", giacPaytRequests.getUserId());
				preInsertParams.put("label", label );
				
				getSqlMapClient().update("giacs016GrqdPreinsert", preInsertParams);
				getSqlMapClient().executeBatch();
				log.info("new tran Id:"+ preInsertParams.get("tranId"));
				giacPaytRequestsDtl.setTranId((Integer) preInsertParams.get("tranId"));
				
				System.out.println("workflowMsgr: "+preInsertParams.get("workflowMsgr"));
				System.out.println("pMessageAlert: "+preInsertParams.get("pMessageAlert"));
				
				GIACPaytRequestsController.workflowMsgr = (String) preInsertParams.get("workflowMsgr") == null ? "" : (String) preInsertParams.get("workflowMsgr");
				log.info("lusot na.");
				if (!(preInsertParams.get("pMessageAlert") == null ? "" : preInsertParams.get("pMessageAlert")).equals("")) {
					log.info("msg alert is not null");
					GIACPaytRequestsController.pMessageAlert = (String) preInsertParams.get("pMessageAlert");
					throw new PostingParException((String) preInsertParams.get("pMessageAlert")); // reuse nlng from postParDao
				}
			}
			
			log.info("INSERTING/UPDATE GIAC_PAYT_REQUESTS_DTL");
			getSqlMapClient().update("setGiacPaytRequestsDtl", giacPaytRequestsDtl);
			this.getSqlMapClient().executeBatch();
			log.info("Saving successful!");
			
			this.getSqlMapClient().getCurrentConnection().commit();
			GIACPaytRequestsController.refId =  giacPaytRequests.getRefId();
		}catch (Exception e) {
			//e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
		
	}

	@Override
	public String getClosedTag(Map<String, Object> params) throws SQLException {
		log.info("checking for closed tag");
		return (String) this.getSqlMapClient().queryForObject("getClosedTagGIACS016", params);
	}

	@Override
	public Map<String, Object> getFundBranchDesc(Map<String, Object> params)
			throws SQLException {
		getSqlMapClient().update("getFundBranchDesc", params);
		return params;
	}

	@Override
	public void valAmtBeforeClosing(Map<String, Object> params)
			throws SQLException {
		try{
			log.info("Validating payt amount : "+params);
			getSqlMapClient().update("valAmtBeforeClosing",params);
		}catch(SQLException e){
			throw e;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> populateChkTags(Map<String, Object> params)
			throws SQLException {
		log.info("populateChkTags :"+params);
		return (Map<String, Object>) getSqlMapClient().queryForObject("populateChkTags",params);
	}

	@Override
	public void closeRequest(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Closing disbursemetn Requests..");
			log.info("params: "+params);
			getSqlMapClient().update("closeDisbursementRequest", params);
			this.getSqlMapClient().executeBatch();
			
			if (!(params.get("pMessageAlert") == null ? "" : params.get("pMessageAlert")).equals("")) {
				log.info("msg alert is not null");
				GIACPaytRequestsController.pMessageAlert = (String) params.get("pMessageAlert");
				throw new PostingParException((String) params.get("pMessageAlert")); // reuse nlng from postParDao
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public void cancelPaymentRequest(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Cancel Payment Request params: "+params);
			getSqlMapClient().update("cancelPaymentRequest", params);
			getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getPaymentLinesList(Map<String, Object> params) throws SQLException {
		log.info("Retrieving line_cd list...");
		return this.getSqlMapClient().queryForList("getPaymentLinesList", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPaytRequests> getPaymentDocYear(Map<String, Object> params) throws SQLException {
		log.info("Retrieving doc_year list...");
		return this.getSqlMapClient().queryForList("getDocYearList", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPaytRequests> getPaymentDocMm(Map<String, Object> params) throws SQLException {
		log.info("Retrieving doc_mm list...");
		return this.getSqlMapClient().queryForList("getDocMmList", params);
	}

	@Override
	public GIACPaytRequests validateDocSeqNo(Map<String, Object> params) throws SQLException {
		log.info("Validating Document Sequence No...");
		return (GIACPaytRequests) this.getSqlMapClient().queryForObject("validateDocSeqNo", params);
	}

	@Override
	public void validatePaytLineCd(Map<String, Object> params) throws SQLException {
		log.info("Validating payment line code...");
		this.getSqlMapClient().queryForObject("validatePaytLineCd", params);
		
	}

	@Override
	public void validatePaytDocYear(Map<String, Object> params) throws SQLException {
		log.info("Validating document year...");
		this.getSqlMapClient().queryForObject("validatePaytDocYy", params);
	}

	@Override
	public void validatePaytDocMm(Map<String, Object> params) throws SQLException {
		log.info("Validating document month...");
		this.getSqlMapClient().queryForObject("validatePaytDocMm", params);		
	}

	@Override
	public void getGIACS016PaytReqOtherDetails(Map<String, Object> params)
			throws SQLException {
		log.info("Getting Payment Request Other Details...");
		this.getSqlMapClient().queryForObject("giacs016DrDetailsPostQuery", params);		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPaytReqDocs> getGIACPaytReqDocsList(
			Map<String, Object> params) throws SQLException {
		log.info("getting giac doc list: "+ params);
		params.put("from", "1");
		params.put("to", "10");
		List<GIACPaytReqDocs> list= getSqlMapClient().queryForList((String) params.get("docLovAction"), params);
		return list;
	}

	@Override
	public void extractCommFund(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting Comm Fund Slip...");
			this.getSqlMapClient().update("extractCommFund", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkCommFundSlip(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Checking Comm Fund Slip...");
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			String userId = (String)params.get("userId");
			String inRecId = "";
			for(Map<String, Object> row : rows){
				row.put("userId", userId);
				params.put("intmNo", row.get("intmNo"));//added by reymon 06182013
				inRecId += "," + row.get("recId");
				this.getSqlMapClient().queryForObject("updateGiacCommFund", row);
			}
			this.getSqlMapClient().executeBatch();
			
			inRecId = inRecId.equals("") ? null : inRecId.replaceFirst(",", "");
			params.put("inRecId", inRecId);
			System.out.println("checkCommFundSlip params: "+params.toString());
			this.getSqlMapClient().update("checkCommFundSlip", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * Added by reymon 06182013
	 * process after printing comm fund slip
	 */
	@Override
	public void processAfterPrinting(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Processing After Printing...");
			this.getSqlMapClient().update("processAfterPrinting", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
