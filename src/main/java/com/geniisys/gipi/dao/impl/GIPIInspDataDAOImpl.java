package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.gipi.dao.GIPIInspDataDAO;
import com.geniisys.gipi.entity.GIPIInspData;
import com.geniisys.gipi.entity.GIPIInspDataDtl;
import com.geniisys.gipi.entity.GIPIInspDataWc;
import com.geniisys.gipi.entity.GIPIInspReportAttachMedia;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIInspDataDAOImpl implements GIPIInspDataDAO{
	
	private Logger log = Logger.getLogger(GIPIInspDataDAOImpl.class); //put log.info

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public List<GIPIInspData> getGipiInspData1(String keyword)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiInspData1", keyword);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIInspData> getInspDataItemInfo(Integer inspNo)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getInspDataItemInfo", inspNo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGipiInspData(Map<String, Object> inspDataMap, String user)
			throws Exception {
		
		
		//String delInspNo = (String) inspDataMap.get("deletedInspNo");
		//Integer inspNo = "{}".equals(delInspNo) || delInspNo == null ? 0 : Integer.parseInt(delInspNo);
		List<GIPIInspData> inspDeletedItems = (List<GIPIInspData>) inspDataMap.get("deletedItems");
		List<GIPIInspData> inspDataList = (List<GIPIInspData>) inspDataMap.get("inspDataList");
		/*List<GIPIInspDataWc> deletedInspDataWc = (List<GIPIInspDataWc>)inspDataMap.get("deletedInspDataWc"); //removed by john 12.3.2015 :: SR#4019
		List<GIPIInspDataWc> inspDataWc = (List<GIPIInspDataWc>) inspDataMap.get("inspDataWc");*/
		GIPIInspData inspDataListUpdate = (GIPIInspData) inspDataMap.get("inspDataListUpdate");
		GIPIInspDataDtl inspDataDtl = (GIPIInspDataDtl) inspDataMap.get("otherDetails");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			/*if (inspNo != 0){
				log.info("Deleting inspNo : " + inspNo);
				this.getSqlMapClient().delete("deleteGipiInspData", inspNo);
				log.info("Inspection number " + inspNo + " deleted.");
			}*/
			
			if(inspDeletedItems != null){
				for(GIPIInspData s : inspDeletedItems){
					HashMap<String, Object> params = new HashMap<String, Object>();
					log.info("Deleting inspNo : " + s.getInspNo());
					log.info("Deleting itemNo : " + s.getItemNo());
					params.put("inspNo",s.getInspNo());	
					params.put("itemNo",s.getItemNo());
					System.out.println("::::::::::::::::::::::::::  "+params+"  ::::::::::::::::::::::::");
					
					// get item attachments
					List<String> attachments = this.getSqlMapClient().queryForList("getInspItemAttachments", params);
					
					this.getSqlMapClient().delete("deleteInspectionItem",params);	
					
					// delete files
					FileUtil.deleteFiles(attachments);
				}
				this.getSqlMapClient().executeBatch(); //added by robert SR 16550 08.20.15
			}
			
			if (inspDataList != null){
				for (GIPIInspData i : inspDataList){
					log.info("Saving inspNo " + i.getInspNo() + " and itemNo " + i.getItemNo());
					i.setUserId(user);
					i.setAppUser(user); //added by steven 12/11/2012
					this.getSqlMapClient().insert("saveGipiInspData", i);
					log.info("status: " + i.getStatus());
					log.info("InspNo " + i.getInspNo() + " and itemNo " + i.getItemNo() + " saved.");
				}
				this.getSqlMapClient().executeBatch(); //added by robert SR 16550 08.20.15
			}
			
			//block for updating inspection data other details
			if (inspDataListUpdate != null){
				log.info("Updating other details of inspNo " + inspDataListUpdate.getInspNo() + " and itemNo " + inspDataListUpdate.getItemNo());
				inspDataListUpdate.setAppUser(user); //added by steven 12/11/2012
				this.getSqlMapClient().update("setInspOtherDtls", inspDataListUpdate);
				log.info("InspNo " + inspDataListUpdate.getInspNo() + " and itemNo " + inspDataListUpdate.getItemNo() + " updated.");
				this.getSqlMapClient().executeBatch(); //added by robert SR 16550 08.20.15
			}
			
			if (inspDataDtl != null){
				log.info("Updating inspection data detail of inspNo " + inspDataDtl.getInspNo());
				inspDataDtl.setAppUser(user); //added by steven 12/11/2012
				this.getSqlMapClient().update("setInspDataDtl", inspDataDtl);
				log.info("InspNo " + inspDataDtl.getInspNo() + " updated.");
				this.getSqlMapClient().executeBatch(); //added by robert SR 16550 08.20.15
			}
			
			//removed by john 12.3.2015 :: SR#4019
			/*//block for deleting and inserting insp data warranties and clauses
			if (deletedInspDataWc != null){
				for (GIPIInspDataWc i : deletedInspDataWc){
					this.getSqlMapClient().delete("deleteInspDataWc", i);
				}
			}
			//removed by john 12.3.2015 :: SR#4019
			if (inspDataWc != null){
				for (GIPIInspDataWc i : inspDataWc){
					log.info("Inserting warranty " + i.getWcCd() + " for inspNo " + i.getInspNo());
					i.setAppUser(user); //added by steven 12/11/2012
					this.getSqlMapClient().insert("insertInspDataWc", i);
					log.info("Warranty " + i.getWcCd() + " inserted.");
				}
				this.getSqlMapClient().executeBatch(); //added by robert SR 16550 08.20.15
			}*/
			
			log.info("Inspection report saved.");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	
	public String getBlockId(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getBlockId", params);
	}
	
	public Integer generateInspNo() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("generateInspNo");
	}
	
	public GIPIInspData getInspOtherDtls(Map<String, Object> otherParams) throws SQLException {
		return (GIPIInspData) this.getSqlMapClient().queryForObject("getInspOtherDtls", otherParams);
	}
	
/*	@SuppressWarnings("unchecked")
	public List<GIPIInspData> getGipiInspData1TableGrid(Map<String, Object> params)
		throws SQLException {
		return (List<GIPIInspData>) this.getSqlMapClient().queryForList("getGipiInspData1TableGrid", params);
	}*/ //remove by steven 9.20.2013

	@SuppressWarnings("unchecked")
	public List<GIPIInspData> getQuoteInpsList(Map<String, Object>params) 
			throws SQLException {
		log.info("GETTING QUOTATION INSPECITON LIST ASSURED NO.."+params.get("assdNo"));//getQuoteInpsList
		System.out.println(params.get("from"));
		System.out.println(params.get("to"));
		return (List<GIPIInspData>) this.getSqlMapClient().queryForList("getQuoteInpsList", params);
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveInspectionAttachments(Map<String, Object> params,String userId) //added by steven 7.17.2012
			throws SQLException, JSONException {
		List<GIPIInspReportAttachMedia> setAttachRows = (List<GIPIInspReportAttachMedia>) params.get("setAttachRows");
		List<GIPIInspReportAttachMedia> delAttachRows = (List<GIPIInspReportAttachMedia>) params.get("delAttachRows");
		
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("Deleting GUE Attach...");
			for(GIPIInspReportAttachMedia delAttach: delAttachRows){
				this.sqlMapClient.delete("deleteGIPIInspPictures2", delAttach);
			}
			
			log.info("Inserting/Updating GUE Attach...");
			for(GIPIInspReportAttachMedia setAttach: setAttachRows){
				String myFullFileName = setAttach.getFileName();
				int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
				String medType = getMediaTypes(myFullFileName, lastIndexOfPeriod).get(2);
				setAttach.setFileType(medType);
				setAttach.setFileExt(myFullFileName.substring(lastIndexOfPeriod+1));
				setAttach.setUserId(userId);
				this.sqlMapClient.insert("saveGIPIInspPicture2", setAttach);
			}

			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e) {
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally{
			this.sqlMapClient.endTransaction();
		}
	}
	
	private Map<Integer, String> getMediaTypes(String fileName, int index) {
		Map<Integer, String> returns = new HashMap<Integer, String>();
		if (fileName.substring(index+1).equalsIgnoreCase("mp4") || 
            	fileName.substring(index+1).equalsIgnoreCase("mpg") ||
            	fileName.substring(index+1).equalsIgnoreCase("mpeg")||
            	fileName.substring(index+1).equalsIgnoreCase("avi") || 
            	fileName.substring(index+1).equalsIgnoreCase("3gp") || 
            	fileName.substring(index+1).equalsIgnoreCase("wmv") || 
            	fileName.substring(index+1).equalsIgnoreCase("3gpp")) {
            	returns.put(1, "video");
            	returns.put(2, "V");
            } else if ("doc".equalsIgnoreCase(fileName.substring(index+1)) ||
            		   "docx".equalsIgnoreCase(fileName.substring(index+1)) ||
            		   "xls".equalsIgnoreCase(fileName.substring(index+1)) ||
            		   "ppt".equalsIgnoreCase(fileName.substring(index+1)) ||
            		   "pdf".equalsIgnoreCase(fileName.substring(index+1))||
            		   "odt".equalsIgnoreCase(fileName.substring(index+1))||
            		   "ods".equalsIgnoreCase(fileName.substring(index+1))||
            		   "txt".equalsIgnoreCase(fileName.substring(index+1))){
            	returns.put(1, "document");
            	returns.put(2, "D");
            } else {
            	returns.put(1, "image");
            	returns.put(2, "P");
            }
		return returns;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInspectionToPAR(Map<String, Object> params)
			throws SQLException, Exception {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIInspData> inspDataList = this.getSqlMapClient().queryForList("getInspectionRep", params);
			String userId = (String) params.get("userId");
			log.info("No. of items to be converted to PAR - "+inspDataList.size());
			
			for(GIPIInspData insp : inspDataList){
				Map<String, Object> inspParams = new HashMap<String, Object>();
				inspParams.put("parId", params.get("parId"));
				inspParams.put("userId", userId);
				inspParams.put("inspNo", insp.getInspNo());
				inspParams.put("itemNo", insp.getItemNo());
				inspParams.put("itemTitle", insp.getItemTitle());
				inspParams.put("itemDesc", insp.getItemDesc());
				inspParams.put("blockId", insp.getBlockId());
				inspParams.put("inspCd", insp.getInspCd());
				
				this.getSqlMapClient().startBatch();
				log.info("Validate insert item from inspection: "+inspParams);
				String isItemExist = (String) this.getSqlMapClient().queryForObject("isExistGIPIWitem2", inspParams);
				
				if(!(isItemExist.equals("Y"))){
					this.getSqlMapClient().insert("saveParWItemFromInspection", inspParams);
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().insert("saveWfireitmFromInspection", inspParams);
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().insert("saveWpicturesFromInspection", inspParams);
					this.getSqlMapClient().executeBatch();
					
					log.info("Succesfully converted item no. "+insp.getItemNo());
				}
			
			}
			this.getSqlMapClient().update("updateInspNo", params);//added by reymon 05022013
			
			message = "SUCCESS"; 
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@SuppressWarnings("unchecked")
	public void saveWarrAndClauses(Map<String, Object> inspDataMap, String user) throws Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIInspDataWc> deletedInspDataWc = (List<GIPIInspDataWc>)inspDataMap.get("deletedInspDataWc");
			List<GIPIInspDataWc> inspDataWc = (List<GIPIInspDataWc>) inspDataMap.get("inspDataWc");
			
			if (deletedInspDataWc != null){
				for (GIPIInspDataWc i : deletedInspDataWc){
					this.getSqlMapClient().delete("deleteInspDataWc", i);
				}
			}
			if (inspDataWc != null){
				for (GIPIInspDataWc i : inspDataWc){
					log.info("Inserting warranty " + i.getWcCd() + " for inspNo " + i.getInspNo());
					i.setAppUser(user);
					this.getSqlMapClient().insert("insertInspDataWc", i);
					log.info("Warranty " + i.getWcCd() + " inserted.");
				}
				this.getSqlMapClient().executeBatch();
			}
			log.info("Inspection report saved.");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	public void saveInspectionInformation(Map<String, Object> params, String user)
			throws Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updateGipiInspDataParent", params);	
			
			log.info("Inspection Information saved.");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAttachments(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getAttachments", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAttachmentByPar(String parId) throws SQLException {
		return this.getSqlMapClient().queryForList("getAttachmentByPar", parId);
	}
	
	public void updateFileName3(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("updateFileName3", params);
	}
}
