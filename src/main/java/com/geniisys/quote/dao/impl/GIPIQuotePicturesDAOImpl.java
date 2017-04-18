package com.geniisys.quote.dao.impl;

import java.io.FileNotFoundException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.util.FileUtil;
import com.geniisys.quote.dao.GIPIQuotePicturesDAO;
import com.geniisys.quote.entity.GIPIQuotePictures;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuotePicturesDAOImpl implements GIPIQuotePicturesDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIPIQuotePicturesDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveQuotationAttachments(Map<String, Object> params)
			throws SQLException {
		List<GIPIQuotePictures> setAttachRows = (List<GIPIQuotePictures>) params.get("setAttachRows");
		List<GIPIQuotePictures> delAttachRows = (List<GIPIQuotePictures>) params.get("delAttachRows");
		
		List<String> filesToDelete = new ArrayList<String>();
		
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("Deleting GUE Attach...");
			for(GIPIQuotePictures delAttach: delAttachRows){
				this.sqlMapClient.delete("deleteQuotationAttachment", delAttach);
				filesToDelete.add(delAttach.getFilePath());
			}
			
			log.info("Inserting/Updating GUE Attach...");
			for(GIPIQuotePictures setAttach: setAttachRows){
				String myFullFileName = setAttach.getFileName();
				int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
				String medType = getMediaTypes(myFullFileName, lastIndexOfPeriod).get(2);
				String remarks = setAttach.getRemarks();  //added by Halley 10.10.13
				setAttach.setFileType(medType);
				setAttach.setFileExt(myFullFileName.substring(lastIndexOfPeriod+1)); 
				setAttach.setRemarks(remarks.replaceAll("&#92;", "\\\\"));  //added by Halley 10.10.13
				this.sqlMapClient.insert("saveQuotationAttachment", setAttach);
			}

			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
			FileUtil.deleteFiles(filesToDelete);
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
	public List<GIPIQuotePictures> getAttachedMedia(Integer quoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getAttachedMedia", quoteId);
	}
	
	public List<GIPIQuotePictures> getAttachmentList2(String quoteId, String itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);	
		return this.getSqlMapClient().queryForList("getAttachmentList2", params);
	}
	
	public void deleteItemAttachments(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.delete("deleteItemAttachments", params);
	}
}
