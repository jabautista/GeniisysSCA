package com.geniisys.gipi.pack.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.pack.controllers.GIPIPackPARListController;
import com.geniisys.gipi.pack.dao.GIPIPackPARListDAO;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;
import com.geniisys.giri.dao.GIRIPackWInPolbasDAO;
import com.geniisys.giri.entity.GIRIPackWInPolbas;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPackPARListDAOImpl implements GIPIPackPARListDAO {

	private SqlMapClient sqlMapClient;
	private GIRIPackWInPolbasDAO giriPackWInPolbasDAO;
	
	private static Logger log = Logger.getLogger(GIPIPackPARListDAOImpl.class);
	
	public SqlMapClient getSqlMapClient(){
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@Override
	public void saveGipiPackPAR(GIPIPackPARList gipipackpar) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving Package PAR at DAO. . .");
			
			this.getSqlMapClient().queryForObject("saveGIPIPackPAR", gipipackpar);
			log.info("Saving successful!");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
	// EDITED BY IRWIN TABISORA. MARCH 2011
	@Override
	public GIPIPackPARList saveGipiPackPAR(Map<String, Object>params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GIPIPackPARList gipiPackPar = (GIPIPackPARList) params.get("preparedPackPar");
			String parameters = (String) params.get("parameters");
			String appUser = (String) params.get("appUser");
			String fromPackQuotation = (String) params.get("fromPackQuotation");
			String alreadySaved = (String) params.get("alreadySaved");
			
			// checks if it is from selected quotation
			/*if (fromPackQuotation.equals("Y") && alreadySaved.equals("N")){
				params.put("packParId", gipiPackPar.getPackParId());
				params.put("lineCd", gipiPackPar.getLineCd());
				params.put("issCd", gipiPackPar.getIssCd());
				params.put("assdNo", gipiPackPar.getAssdNo());
				params.put("appUser", appUser);
				updatePackQuotation(params);
			}*/ // moved by: Nica 06.06.2012
			
			if(fromPackQuotation.equals("Y")){// added seperate condition
				//ASSIGNED PACK QUOTE ID TO QUOTE ID OF gipiPackPar for table gipi_pack_parlist.
				Integer packQuoteId = Integer.parseInt((String) params.get("packQuoteId"));
				gipiPackPar.setQuoteId(packQuoteId);
			}
			
			System.out.println("Already save: "+alreadySaved);
			log.info("Saving Package PAR at DAO. . .");
			System.out.println("quoteId:"+gipiPackPar.getQuoteId());
			System.out.println("remarks: "+gipiPackPar.getRemarks());
			this.getSqlMapClient().queryForObject("saveGIPIPackPAR", gipiPackPar);
			log.info("Saving successful!");
			
			// AFTER THE SAVE PROCEDURE. GET THE FULL DETAILS..
			gipiPackPar = this.getGIPIPackParDetails(gipiPackPar.getPackParId());
			System.out.println("middle save: "+gipiPackPar.getRemarks());
			
			if(!parameters.equals("") || parameters.equals(null)){
				log.info("Preparing LINE/SUBLINE..");
				JSONObject objParameters = new JSONObject(parameters);
				
				log.info("PREPARING DEL PARAMS");
				List<GIPIWPackLineSubline> lineSublineForDelete = this.prepareLineSublineForDelete(new JSONArray(objParameters.getString("delRows")), gipiPackPar.getPackParId(), gipiPackPar.getLineCd());
				/*if(lineSublineForDelete != null){
					for(GIPIWPackLineSubline lineSubline : lineSublineForDelete){
						log.info("deleting LineSubline par Id: "+lineSubline.getParId());
						this.getSqlMapClient().insert("delGIPIWPackLineSubline", lineSubline);
					}
					this.getSqlMapClient().executeBatch();
				}*/
				//added the extra procedures used in pack lineSubline module for deleting linesublines, d.alcantara 01-20-2012
				if(lineSublineForDelete != null){
					for(GIPIWPackLineSubline lineSubline : lineSublineForDelete){
						log.info("LineSubline FOR DELETE HAS ITEMS/PERILS..");
						Map<String, Object>keyDelParams = new HashMap<String, Object>();
						keyDelParams.put("parId", lineSubline.getParId());
						keyDelParams.put("lineCd",  gipiPackPar.getLineCd());
						keyDelParams.put("issCd", gipiPackPar.getIssCd());
						keyDelParams.put("packLineCd", lineSubline.getPackLineCd());
						keyDelParams.put("packSublineCd", lineSubline.getPackSublineCd());
						keyDelParams.put("appUser", appUser);
						this.getSqlMapClient().insert("GIPIWPackLineSublineKeyDelRec", keyDelParams);
						
						System.out.println("deleting LineSubline par Id: "+lineSubline.getParId());
						Map<String, Object> updatePar = new HashMap<String, Object>();
						updatePar.put("appUser", appUser);
						updatePar.put("parId", lineSubline.getParId());
						updatePar.put("parStatus", 99);
						this.getSqlMapClient().queryForObject("updatePARStatus", params);
						this.getSqlMapClient().insert("delGIPIWPackLineSubline", lineSubline);
					}
				}
				
				log.info("PREPARING INSERT PARAMS");
				List<GIPIWPackLineSubline> lineSublineForInsert = this.prepareLineSublineForInsert(new JSONArray(objParameters.getString("addRows")), gipiPackPar.getPackParId(), gipiPackPar.getLineCd());
				if(lineSublineForInsert != null){
					Map<String, Object> postInsertParams = new HashMap<String, Object>();
					for(GIPIWPackLineSubline lineSubline : lineSublineForInsert){
						log.info("INSERTING NEW LineSubline par Id: "+lineSubline.getParId());
						this.getSqlMapClient().insert("setGIPIWPackLineSubline", lineSubline);
						
						// POST INSERT OF DATA BLOCK  GIPI_WPACK_LINE_SUBLINE. MODULE:GIPIS050A 
						// insert to partlist
						postInsertParams.put("appUser", appUser);
						postInsertParams.put("packParId", gipiPackPar.getPackParId());
						postInsertParams.put("parId", lineSubline.getParId());
						postInsertParams.put("lineCd", lineSubline.getPackLineCd());
						postInsertParams.put("issCd", gipiPackPar.getIssCd());
						postInsertParams.put("parYy", gipiPackPar.getParYy());
						postInsertParams.put("quoteSeqNo", gipiPackPar.getQuoteSeqNo());
						postInsertParams.put("parType", gipiPackPar.getParType());
						postInsertParams.put("assignSw", gipiPackPar.getAssignSw());
						postInsertParams.put("parStatus", gipiPackPar.getParStatus());
						postInsertParams.put("assdNo", gipiPackPar.getAssdNo());
						postInsertParams.put("quoteId",null); //change to null. Every new Line/subline that is not from the quotation will have no quote id. Irwin 07.08.11 -----postInsertParams.put("quoteId", gipiPackPar.getQuoteId() == 0 ? null : gipiPackPar.getQuoteId());
						postInsertParams.put("underwriter", gipiPackPar.getUnderwriter());
						postInsertParams.put("remarks", gipiPackPar.getRemarks());
						log.info("INSERTING TO GIPI_PARLIST.."+lineSubline.getParId());
						this.getSqlMapClient().insert("insertPackParList", postInsertParams);
						log.info("INSERTING TO GIPI_PARHIST.."+lineSubline.getParId());
						postInsertParams.put("userId", appUser);
						postInsertParams.put("entrySource", "DB");
						postInsertParams.put("parStatCd", "1");
						this.getSqlMapClient().insert("insertParHistory", postInsertParams);
					}	
					this.getSqlMapClient().executeBatch();
				}
			}
			
			// moved here - Nica 06.06.2012 to prevent changing the par status of the par which originates from a pack quotation
			if (fromPackQuotation.equals("Y") && alreadySaved.equals("N")){
				params.put("packParId", gipiPackPar.getPackParId());
				params.put("lineCd", gipiPackPar.getLineCd());
				params.put("issCd", gipiPackPar.getIssCd());
				params.put("assdNo", gipiPackPar.getAssdNo());
				params.put("appUser", appUser);
				updatePackQuotation(params);
			}
			
			if(alreadySaved.equals("Y")){// Added for the updating of remarks of parlist even after the par has already been saved. - irwin 11.17.11
				log.info("UPDATING REMARKS OF PAR.");
				params.clear();
				params.put("packParId", gipiPackPar.getPackParId());
				params.put("remarks", gipiPackPar.getRemarks());
				this.getSqlMapClient().update("updateParRemarksByPackParId",params);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return gipiPackPar;
		}catch (Exception e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	private void updatePackQuotation(Map<String, Object>params) throws SQLException{
		Integer packQuoteId = Integer.parseInt((String) params.get("packQuoteId"));
		
		log.info("Update pack quote status of quotation id " + packQuoteId);
		this.getSqlMapClient().update("updateGipiPackQuote", packQuoteId);
		
		log.info("PROCESSING PACK QUOTE TO PAR PROCEDURES..");
		this.getSqlMapClient().update("processPackQuoteToPar", params);
		
	}

	@Override
	public Integer getNewPackParId() throws SQLException {
		log.info("Retrieving Package PAR ID. . . ");
		GIPIPackPARList packPar = (GIPIPackPARList) this.getSqlMapClient().queryForObject("getNewPackParId");
		log.info("Package PAR ID" + packPar.getPackParId());
		return packPar.getPackParId();
	}

	@Override
	public GIPIPackPARList getGIPIPackParDetails(Integer packParId) throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		//params.put("parId", parId);
		params.put("packParId", packParId);
		log.info("Retrieving Package PAR details from " + packParId);
		GIPIPackPARList packPar = (GIPIPackPARList) this.getSqlMapClient().queryForObject("getPackParDetailsFromPackParId", params);
		log.info("Package par details retrieved");
		
		return packPar;
	}

	@Override
	public void updatePackStatusFromQuote(Integer quoteId, Integer parStatus) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("parStatus", parStatus);
		this.getSqlMapClient().queryForObject("updatePackStatusFromQuote", params);
		
	}

	@Override
	public String checkPackParQuote(Integer packParId) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("checkPackParQuote", packParId);
	}

	@Override
	public Map<String, Object> checkIfLineSublineExist(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		log.info("Checking line and subline. . . ");
		this.getSqlMapClient().update("checkIfLineSublineExist", params);
		log.info("Line and subline existence checked.");
		return params;
	}

	@Override
	public void createParListWPack(Map<String, Object> params)
			throws SQLException {
		log.info("Executing Par List WPack DAOImpl...");
		try {
			int quoteId = Integer.parseInt(params.get("updateGipiPackQuote").toString());
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateGipiPackQuote", quoteId);			
			this.getSqlMapClient().insert("createParListWPack" , params);
			this.getSqlMapClient().insert("createGipiPackWPolBas", params);
			this.getSqlMapClient().insert("createGIPIWItem", params);
			GIPIPackPARListController.progess = "Creating item information ...";
			this.getSqlMapClient().insert("createParListWPack", params);
			GIPIPackPARListController.progess = "Creating peril and warranties/clauses information ...";
			this.getSqlMapClient().insert("createPerilWc", params);
			GIPIPackPARListController.progess = "Creating distribution/deductibles information ...";
			this.getSqlMapClient().insert("createDistDed", params);
			GIPIPackPARListController.progess = "Creating mortgagee information ...";
			this.getSqlMapClient().insert("createWMortgagee", params);
			//GIPIPackPARListController.progess = "Creating line and subline information ...";
			this.getSqlMapClient().insert("createWPackLineSubline", params);
			GIPIPackPARListController.progess = "Creating invoice...";
			this.getSqlMapClient().insert("createGipiWInvoice", params);
			GIPIPackPARListController.progess = "Creating discount information...";
			this.getSqlMapClient().insert("createDiscounts", params);
			GIPIPackPARListController.progess = "PAR has been successfully created...";
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackPARList> getGipiPackParList(String lineCd, String keyword, 
			String userId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("keyword", keyword);
		return this.getSqlMapClient().queryForList("getGipiPackParList", params);
	}

	@Override
	public void deletePackPar(Map<String, Object> params) throws SQLException,
			Exception {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().delete("deletePARIncludedInPackage", params);
			this.getSqlMapClient().delete("deletePackTables", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			log.info("Successfully deleted Package PAR...");
			
		}catch(SQLException s){
			s.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw s;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public Map<String, Object> checkRITablesBeforeDeletion(Integer packParId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", packParId);
		this.sqlMapClient.update("checkRIBeforeDeletion", params);
		return params;
	}

	@Override
	public void cancelPackPar(Map<String, Object> params) throws SQLException, Exception {
		this.getSqlMapClient().update("cancelPackPar", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackPARList> getGipiEndtPackParList(String lineCd,
			String keyword, String userId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("keyword", keyword);
		params.put("userId", userId);
		return this.getSqlMapClient().queryForList("getGipiEndtPackParList", params);
	}
	
	@Override
	public void updatePackParRemarks(List<GIPIPackPARList> updatedRows)
			throws SQLException {
		log.info("Updating remarks..");
		
		if(updatedRows != null){
			log.info("Updated row: " + updatedRows);
			for(GIPIPackPARList packPar : updatedRows){
				log.info("Updated Remarks for packParId: " + packPar.getPackParId());
				this.getSqlMapClient().update("updatePackParRemarks", packPar);
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackPARList> getGipiPackParListing(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPackPARList> packParList = new ArrayList<GIPIPackPARList>();
		if(params.get("parType").equals("P")){
			packParList = this.getSqlMapClient().queryForList("getGipiPackParList", params); 
		}else if(params.get("parType").equals("E")){
			packParList = this.getSqlMapClient().queryForList("getEndtGipiPackParList", params);
		}
		return packParList;
	}

	private List<GIPIWPackLineSubline> prepareLineSublineForInsert(JSONArray addRows, int packParId, String lineCd) throws SQLException, JSONException{
		List<GIPIWPackLineSubline> lineSublineList = new ArrayList<GIPIWPackLineSubline>();
		GIPIWPackLineSubline lineSubline= null;
		Integer parId;
		for (int i = 0; i < addRows.length(); i++) {
			lineSubline = new GIPIWPackLineSubline();
			lineSubline.setPackParId(packParId);
			log.info("retrieving ParlistParId for new lineSubline.");
			parId = (Integer) this.getSqlMapClient().queryForObject("getParlistParIdNextVal");
			log.info("NEW PAR ID: "+parId);
			lineSubline.setParId(parId);
			lineSubline.setLineCd(lineCd);
			lineSubline.setPackLineCd(addRows.getJSONObject(i).getString("packLineCd"));
			lineSubline.setPackSublineCd(addRows.getJSONObject(i).getString("packSublineCd"));
			lineSubline.setItemTag("N");
			lineSubline.setRemarks((String) (addRows.getJSONObject(i).isNull("remarks") ? null : addRows.getJSONObject(i).get("remarks")));
			//adds to list;
			lineSublineList.add(lineSubline);
		}
		return lineSublineList;
	}
	
	private List<GIPIWPackLineSubline> prepareLineSublineForDelete(JSONArray delRows, int packParId, String lineCd) throws SQLException, JSONException{
		List<GIPIWPackLineSubline> lineSublineList = new ArrayList<GIPIWPackLineSubline>();
		GIPIWPackLineSubline lineSubline= null;
		
		for (int i = 0; i < delRows.length(); i++) {
			lineSubline = new GIPIWPackLineSubline();
			lineSubline.setParId(delRows.getJSONObject(i).getInt("parId"));
			lineSubline.setLineCd(lineCd);
			lineSubline.setPackLineCd(delRows.getJSONObject(i).getString("packLineCd"));
			lineSubline.setPackSublineCd(delRows.getJSONObject(i).getString("packSublineCd"));
			//adds to list;
			lineSublineList.add(lineSubline);
		}
		return lineSublineList;
	}

	@Override
	public Map<String, Object> savePackInitialAcceptance(
			Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer packParId = 0; 
			String mode = (String) params.get("mode");
			String automaticParAssignmentFlag = (String) params.get("automaticParAssignmentFlag");
			GIPIPackPARList gipiPackPARList = (GIPIPackPARList) params.get("preparedRIPackPar");
			packParId = gipiPackPARList.getPackParId();
			if(mode.equals("0")){
				if (packParId == 0) { // means new pack par
					packParId = getNewPackParId();
					log.info("New Pack Par Id : "+packParId);
					log.info("automaticParAssignmentFlag: "+automaticParAssignmentFlag);
					gipiPackPARList.setPackParId(packParId);
					if(automaticParAssignmentFlag.equals("Y")){
						gipiPackPARList.setAssignSw("Y");
						gipiPackPARList.setParStatus(2);
					}else{
						gipiPackPARList.setAssignSw("N");
						gipiPackPARList.setParStatus(1);
					}
				}
				
				Debug.print(gipiPackPARList);
				this.getSqlMapClient().queryForObject("saveGIPIPackPAR", gipiPackPARList);
				this.getSqlMapClient().executeBatch();
				log.info("Saving ri pack par successful!");
			}
			
			GIRIPackWInPolbas giriPackWInPolbas = (GIRIPackWInPolbas) params.get("gipiPackWInPolbas");
			giriPackWInPolbas.setPackParId(packParId);
			if(giriPackWInPolbas.getRiSName().equals("")){
				giriPackWInPolbas.setWriterCd(null);
			}
			if (giriPackWInPolbas.getRiSName2().equals("")) {
				giriPackWInPolbas.setRiCd(null);
			}
			
			String insertSwitch = "";
			
			if (giriPackWInPolbas.getPackAcceptNo() == 0) {// means new record
				giriPackWInPolbas.setPackAcceptNo(getGiriPackWInPolbasDAO().getNewPackAcceptNo());
				System.out.println("new pack acceptno: "+giriPackWInPolbas.getPackAcceptNo());
				getGiriPackWInPolbasDAO().saveGiriPackWInpolbas(giriPackWInPolbas);
				log.info("FINISHED SAVING GIRI_PACK_WINPOLBAS");
				
				insertSwitch = "Y";
				getSqlMapClient().executeBatch();
			}else{ //update
				getGiriPackWInPolbasDAO().saveGiriPackWInpolbas(giriPackWInPolbas);
				log.info("FINISHED SAVING GIRI_PACK_WINPOLBAS");
				
				insertSwitch = "N";
				getSqlMapClient().executeBatch();
			}
			
			// GIPI_WPACK_LINE_SUBLINE
			if(mode.equals("0")){
				if(gipiPackPARList.getParType().equals("P")){
					JSONObject objParameters = new JSONObject((String)params.get("parameters"));
					log.info("PREPARING DEL PARAMS");
					List<GIPIWPackLineSubline> lineSublineForDelete = this.prepareLineSublineForDelete(new JSONArray(objParameters.getString("delRows")), gipiPackPARList.getPackParId(), gipiPackPARList.getLineCd());
					
					for (GIPIWPackLineSubline gipiwPackLineSubline : lineSublineForDelete) {
						getSqlMapClient().delete("delGIPIWPackLineSubline", gipiwPackLineSubline);
					}
					log.info("DELETION COMPLETE");
					
					log.info("PREPARING INSERT PARAMS");
					List<GIPIWPackLineSubline> lineSublineForInsert = this.prepareLineSublineForInsert(new JSONArray(objParameters.getString("addRows")), gipiPackPARList.getPackParId(), gipiPackPARList.getLineCd());
					
					for (GIPIWPackLineSubline gipiwPackLineSubline : lineSublineForInsert) {
						getSqlMapClient().startBatch();
						this.getSqlMapClient().insert("setGIPIWPackLineSubline", gipiwPackLineSubline);
						log.info("INSERT GIPI_WPACK_LINE_SUBLINE SUCCESSFUL");
						Map<String, Object> postInsertParams = new HashMap<String, Object>();
						postInsertParams.put("packParId", gipiPackPARList.getPackParId());
						postInsertParams.put("parId", gipiwPackLineSubline.getParId());
						postInsertParams.put("lineCd", gipiwPackLineSubline.getPackLineCd());
						postInsertParams.put("issCd", gipiPackPARList.getIssCd());
						postInsertParams.put("parYy", gipiPackPARList.getParYy());
						postInsertParams.put("quoteSeqNo", gipiPackPARList.getQuoteSeqNo());
						postInsertParams.put("parType", gipiPackPARList.getParType());
						postInsertParams.put("assignSw", gipiPackPARList.getAssignSw());
						postInsertParams.put("parStatus", gipiPackPARList.getParStatus());
						postInsertParams.put("assdNo", gipiPackPARList.getAssdNo());
						postInsertParams.put("underWriter", gipiPackPARList.getUserId());
						postInsertParams.put("remarks", gipiPackPARList.getRemarks());
						postInsertParams.put("appUser", gipiPackPARList.getUserId());
						log.info("executing post insert procedures - "+postInsertParams);
						getSqlMapClient().insert("giris005AlineSublinePostInsert",postInsertParams);
						
						postInsertParams.clear();
						postInsertParams.put("parId", gipiwPackLineSubline.getParId());
						postInsertParams.put("userId", gipiPackPARList.getUserId());
						postInsertParams.put("entrySource","DB");
						postInsertParams.put("parstatCd","1");
						getSqlMapClient().insert("insertPARHist",postInsertParams);
						
						
						postInsertParams.clear();
						Integer acceptNo = (Integer) getSqlMapClient().queryForObject("getNewAcceptNo");
						postInsertParams.put("acceptNo",acceptNo);
						postInsertParams.put("parId",gipiwPackLineSubline.getParId());
						postInsertParams.put("riCd",giriPackWInPolbas.getRiCd());
						postInsertParams.put("acceptDate",giriPackWInPolbas.getAcceptDate());
						postInsertParams.put("riPolicyNo",giriPackWInPolbas.getRiPolicyNo());
						postInsertParams.put("riEndtNo",giriPackWInPolbas.getRiEndtNo());
						postInsertParams.put("riBinderNo",giriPackWInPolbas.getRiBinderNo());
						postInsertParams.put("writerCd",giriPackWInPolbas.getWriterCd());
						postInsertParams.put("offerDate",giriPackWInPolbas.getOfferDate());
						postInsertParams.put("acceptBy",giriPackWInPolbas.getAcceptBy());
						postInsertParams.put("origTsiAmt",giriPackWInPolbas.getOrigTsiAmt());
						postInsertParams.put("origPremAmt",giriPackWInPolbas.getOrigPremAmt());
						postInsertParams.put("remarks",giriPackWInPolbas.getRemarks());
						postInsertParams.put("refAcceptNo",giriPackWInPolbas.getRefAcceptNo());
						postInsertParams.put("packParId",gipiPackPARList.getPackParId());
						postInsertParams.put("packAcceptNo",giriPackWInPolbas.getPackAcceptNo());
						
						Debug.print("here: "+postInsertParams);
						getSqlMapClient().insert("giris005AlineSublinePostInsert2",postInsertParams);
					             
						getSqlMapClient().executeBatch();
						log.info("FINISHED GIPI_WPACK_LINE_SUBLINE POST INSERT PROCEDURES");
					}
					
				}
			}
			
			
			
			/*moved the post insert/update of giri_pack_winpolbas to after the saving/deleting of gipi_wpack_line_subline
			 *  because some procedures conflicts each other.
			 */
			
			if(insertSwitch.equals("Y")){
				log.info("EXECUTING GIRI_PACK_WINPOLBAS POST INSERT");
				getSqlMapClient().update("giris005aPackWInPolbasPostInsert", gipiPackPARList.getPackParId());
			}else{
				log.info("EXECUTING GIRI_PACK_WINPOLBAS POST UPDATE");
				getSqlMapClient().update("giris005aPackWInPolbasPostUpdate", giriPackWInPolbas);
			}
			getSqlMapClient().executeBatch();
			
			
			// AFTER THE SAVE PROCEDURE. GET THE FULL DETAILS..
			gipiPackPARList = this.getGIPIPackParDetails(gipiPackPARList.getPackParId());
			System.out.println("pack id" +gipiPackPARList.getPackParId());
			giriPackWInPolbas = getGiriPackWInPolbasDAO().getGiriPackWInPolbas(gipiPackPARList.getPackParId());
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			params.clear();
			params.put("gipiPackPARList", gipiPackPARList);
			params.put("giriPackWInPolbas", giriPackWInPolbas);
			return params;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}

	/**
	 * @return the giriPackWInPolbasDAO
	 */
	public GIRIPackWInPolbasDAO getGiriPackWInPolbasDAO() {
		return giriPackWInPolbasDAO;
	}

	/**
	 * @param giriPackWInPolbasDAO the giriPackWInPolbasDAO to set
	 */
	public void setGiriPackWInPolbasDAO(GIRIPackWInPolbasDAO giriPackWInPolbasDAO) {
		this.giriPackWInPolbasDAO = giriPackWInPolbasDAO;
	}

	@Override
	public Integer generatePackParIdGiuts008a() throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("generatePackParIdGiuts008a");
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPackParListGiuts008a(Integer packPolicyId)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getPackParListGiuts008a", packPolicyId);
	}

	@Override
	public void insertPackParListGiuts008a(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().insert("insertPackParListGiuts008a", params);
	}

	@Override
	public void insertParHistGiuts008a(Map<String, Object> params)
			throws SQLException {
		//this.getSqlMapClient().in
	}

	@Override
	public String getPackSharePercentage(Integer packParId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPackSharePercentage", packParId);
	}

	@Override
	public String checkGipis095PackPeril(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGipis095PackPeril",params);
	}
}