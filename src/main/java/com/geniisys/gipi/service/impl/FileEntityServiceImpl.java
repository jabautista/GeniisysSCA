/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.commons.lang.StringEscapeUtils;

import com.geniisys.common.exceptions.UploadModeException;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.FileEntityDAO;
import com.geniisys.gipi.entity.FileEntity;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.StringFormatter;

import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * The Class FileEntityServiceImpl.
 */
public class FileEntityServiceImpl implements FileEntityService{


	/** The file entity dao. */
	private FileEntityDAO fileEntityDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(FileEntityServiceImpl.class);	
	
	/* Used to write the media in the web server for display purposes only
     * Media written would be delete after Modalbox is hidden 
     */
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.FileEntityService#writeMedia(javax.servlet.http.HttpServletRequest, java.lang.String, int)
	 */
	public void writeMedia(HttpServletRequest request, String file, int genericId)
			throws FileNotFoundException, IOException {
		File newFile;
        try {
        	FileInputStream fis;
        	byte[] pdfByte = null;
        	try {
				fis = new FileInputStream(file);
				pdfByte = new byte[fis.available()];
				fis.read(pdfByte);
				fis.close();
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			
			String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
			int startIndex = file.lastIndexOf(slashType);
			String fileName = file.substring(startIndex+1);
			
			(new File(request.getSession().getServletContext().getRealPath("")+"/"+genericId)).mkdirs();
			newFile = new File(request.getSession().getServletContext().getRealPath("")+"/"+genericId+"/"+fileName);
			System.out.println("Writing to: " + newFile.getPath());
			FileOutputStream os = new FileOutputStream(newFile);
			os.write(pdfByte);
			os.flush();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.FileEntityService#writeMedia(javax.servlet.http.HttpServletRequest, java.util.List)
	 */
	public HttpServletRequest writeMedia(HttpServletRequest request, List<FileEntity> media) 
		throws FileNotFoundException, IOException {
					
		List<FileEntity> updatedMedia = media;
		Map<Integer, String> mediaSizes = new HashMap<Integer, String>();
		Map<Integer, String> mediaLinks = new HashMap<Integer, String>();
		Map<Integer, String> mediaPath = new HashMap<Integer, String>();
		int ctr = 0;
		for (FileEntity fileEntity: updatedMedia) {
			ctr++;
			
			// get media real path
			mediaPath.put(ctr, fileEntity.getFileName());
			
			File newFile;
	        try {
	        	FileInputStream fis;
	        	byte[] pdfByte = null;
	        	try {
					fis = new FileInputStream(fileEntity.getFileName());
					pdfByte = new byte[fis.available()];
					fis.read(pdfByte);
					fis.close();
				} catch (Exception e) {
					String slashType = (fileEntity.getFileName().lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
					int startIndex = fileEntity.getFileName().lastIndexOf(slashType);
					String fileName = StringFormatter.replaceQuotes(StringFormatter.replaceTildes(fileEntity.getFileName().substring(startIndex+1)));
					mediaLinks.put(ctr, fileEntity.getId()+"/"+fileName);
					fileEntity.setFileName(fileName);
					fileEntity.setRemarks(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(fileEntity.getRemarks())));
					mediaSizes.put(ctr, "0");
					continue; // SR-21674 JET SEPT-26-2016
					//e.printStackTrace();
					//log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				}
				if (!(new File(request.getSession().getServletContext().getRealPath("")+"/"+fileEntity.getId())).isDirectory())	{
					(new File(request.getSession().getServletContext().getRealPath("")+"/"+fileEntity.getId())).mkdir();
				}
				
				String slashType = (fileEntity.getFileName().lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
				
				int startIndex = fileEntity.getFileName().lastIndexOf(slashType);
				
				String fileName = StringFormatter.replaceQuotes(StringFormatter.replaceTildes(fileEntity.getFileName().substring(startIndex+1)));
				
				// store media real location for download
				mediaLinks.put(ctr, fileEntity.getId()+"/"+fileName);
				
				// update file names of media to point them to the temp media in the web server
				fileEntity.setFileName(fileName);
				fileEntity.setRemarks(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(fileEntity.getRemarks())));
				
				newFile = new File(request.getSession().getServletContext().getRealPath("")+"/"+fileEntity.getId()+"/"+fileName);
				FileOutputStream os = new FileOutputStream(newFile);
				os.write(pdfByte);
				os.flush();
				os.close();
				
				mediaSizes.put(ctr, String.valueOf(pdfByte.length));
				
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
		}
		
		request.setAttribute("media", updatedMedia);
		request.setAttribute("mediaSizes", mediaSizes);
		request.setAttribute("mediaLinks", mediaLinks);
		request.setAttribute("mediaPath", mediaPath);
				
		return request;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.FileEntityService#getFiles(int, int, java.lang.String)
	 */
	@Override
	public List<FileEntity> getFiles(int id, int itemNo, String mode)
			throws SQLException {
		
		List<FileEntity> files = null;
		
		if("par".equals(mode)) {
			log.info("Retrieving Par Pictures...");
			files = this.getFileEntityDAO().getGIPIWPictures(id, itemNo);
			log.info("Par Pictures retrieved. size: " + files.size());
		} else if ("policy".equals(mode)){
			log.info("Retrieving Policy Pictures...");
			files = this.getFileEntityDAO().getGIPIPictures(id, itemNo);
			log.info("Policy Pictures retrieved. size: " + files.size());
		} else if ("extract".equals(mode)) {
			log.info("Retrieving Extract Pictures...");
			files = this.getFileEntityDAO().getGIXXPictures(id, itemNo);
			log.info("Extract Pictures retrieved. size: " + files.size());
		} else if ("inspection".equals(mode)) {
			log.info("Retrieving Inspection Pictures...");
			files = this.getFileEntityDAO().getGIPIInspPictures(id, itemNo);
			log.info("Inspection pictures retrieved.size: " + files.size());
		} else if ("clmItemInfo".equals(mode)){
			log.info("Retrieving Claim Iten Information Pictures...");
			files = this.getFileEntityDAO().getGICLPictures(id, itemNo);
			log.info("Claim Iten Information pictures retrieved.size: " + files.size());
		}
		
		return files;
	}


	/**
	 * Sets the file entity dao.
	 * 
	 * @param fileEntityDAO the new file entity dao
	 */
	public void setFileEntityDAO(FileEntityDAO fileEntityDAO) {
		this.fileEntityDAO = fileEntityDAO;
	}


	/**
	 * Gets the file entity dao.
	 * 
	 * @return the file entity dao
	 */
	public FileEntityDAO getFileEntityDAO() {
		return fileEntityDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.FileEntityService#deleteFiles(int, int, java.lang.String)
	 */
	@Override
	public boolean deleteFiles(int id, int itemNo, String mode)
			throws SQLException {
		
		if("par".equals(mode)){
			log.info("Deleting All Par Picture of parId: " + id + " and itemNo: " + itemNo);
			this.getFileEntityDAO().deleteGIPIWPictures(id, itemNo);
			log.info("Par Pictures deleted.");
		} else if ("policy".equals(mode)){
			log.info("Deleting All Policy Picture of policyId: " + id + " and itemNo: " + itemNo);
			this.getFileEntityDAO().deleteGIPIPictures(id, itemNo);
			log.info("Policy Pictures deleted.");
		} else if ("extract".equals(mode)){
			log.info("Deleting All Extract Picture of policyId: " + id + " and itemNo: " + itemNo);
			this.getFileEntityDAO().deleteGIPIPictures(id, itemNo);
			log.info("Extract Pictures deleted.");
		} else if ("inspection".equals(mode)){
			log.info("Deleting All Inspection Picture of inspNo: " + id + " and itemNo: " + itemNo);
			this.getFileEntityDAO().deleteGIPIInspPicture(id, itemNo);
			log.info("Inspection Pictures deleted.");
		} else if ("clmItemInfo".equals(mode)){
			log.info("Deleting All Claims item Picture of claimId: " + id + " and itemNo: " + itemNo);
			this.getFileEntityDAO().deleteGICLPictures(id, itemNo);
			log.info("Claims item Pictures deleted.");
		}
		return true;
	}


	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.FileEntityService#saveFiles(java.util.Map, java.lang.String)
	 */
	@Override
	public boolean saveFiles(Map<String, Object> params, String mode)
			throws SQLException {
		String[] fileNames 	 	= (String[]) params.get("fileNames");
		String[] fileTypes 		= (String[]) params.get("fileTypes");
		String[] fileExts 		= (String[]) params.get("fileExts");
		String[] filePaths 		= (String[]) params.get("filePaths");
		String[] remarks		= (String[]) params.get("remarks");
		String[] polFileNames	= (String[]) params.get("polFileNames");
		String[] arcExtDatas	= (String[]) params.get("arcExtDatas");
		int id					= (Integer) params.get("id");
		int itemNo				= (Integer) params.get("itemNo");
		String userId			= (String) params.get("userId");
		
		FileEntity file = null;

		this.deleteFiles(id, itemNo, mode);
			
		if(null != fileNames){
			log.info("Saving " + mode + " Pictures...");
			for(int i=0; i < fileNames.length; i++){
				file = new FileEntity();
	
				file.setId(id);
				file.setItemNo(itemNo);
				file.setUserId(userId);
				file.setAppUser(userId);
				file.setFileName(filePaths[i]);
				file.setFileType(fileTypes[i]);
				file.setFileExt(fileExts[i]);
				file.setRemarks(remarks[i]);

				if ("extract".equals(mode) || "policy".equals(mode)){
					file.setPolFileName(polFileNames[i]);
				}
				
				if ("policy".equals(mode)){
					file.setArcExtData(arcExtDatas[i]);
				}
				
				if ("par".equals(mode)){
					this.getFileEntityDAO().saveGIPIWPicture(file);
				} else if ("policy".equals(mode)) {
					this.getFileEntityDAO().saveGIPIPicture(file);
				} else if ("extract".equals(mode)) {
					this.getFileEntityDAO().saveGIXXPicture(file);
				} else if ("inspection".equals(mode)){
					this.getFileEntityDAO().saveGIPIInspPicture(file);
				} else if ("clmItemInfo".equals(mode)){
					this.getFileEntityDAO().saveGICLPictures(file);
				}
			}
			log.info(mode + " Pictures saved.");
		}
		
		return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.FileEntityService#deleteFilesFromDisk(java.lang.String, java.lang.String[])
	 */
	public boolean deleteFilesFromDisk(String filePath, String[] fileNames){		
		File mainDir = new File(filePath);
		File[] mainDirFiles = mainDir.listFiles();
		
		if (mainDirFiles != null) {
			for (File f: mainDirFiles) {
				for(int i = 0; i < fileNames.length; i++) {
					if (f.getName().equals(fileNames[i])) {
						f.delete();
					}
				}
			}
		}
		
		// delete main directory in drive if it is empty
		if (mainDirFiles.length < 1) {
			if (mainDir.isDirectory()) {
				mainDir.delete();
			}
		}
		
		return true;
	}
	
	public void writeMedia(Map<String, Object> params) throws Exception {
		File newFile;
		FileOutputStream os = null;
		try {
			String realPath = (String) params.get("realPath");
			String filePath = (String) params.get("filePath");
			String uploadPath = (String) params.get("uploadPath");
			String fileName = (String) params.get("fileName");
			
			FileInputStream fis = null;
			byte[] pdfByte = null;
			try {
				fis = new FileInputStream(filePath+"/"+fileName);
				pdfByte = new byte[fis.available()];
				fis.read(pdfByte);
			} catch (Exception e) {
				ExceptionHandler.logException(e);	
				throw e;
			} finally {
				if(fis != null){
					fis.close();
				}
			}

			//String slashType = (filePath.lastIndexOf("\\") > 0) ? "\\" : "/"; // Windows
																			  // or
																			  // UNIX
			//int startIndex = filePath.lastIndexOf(slashType);
			//String fileName = filePath.substring(startIndex + 1);
			(new File(realPath + "/" + uploadPath)).mkdirs();
			newFile = new File(realPath	+ "/" + uploadPath + "/" + fileName);
			System.out.println("Writing to: " + newFile.getPath());
			os = new FileOutputStream(newFile);
			os.write(pdfByte);
			os.flush();
		} catch (Exception e) {
			ExceptionHandler.logException(e);
			throw e;
		} finally {
			if(os != null){
				os.close();
			}
		}
	}
	
	public Integer getFileSize(String fileFullPath) throws IOException {
		Integer fileSizeInBytes = 0;
		
		if (fileFullPath != null) {
			try {
				FileInputStream fis = new FileInputStream(fileFullPath);
				byte[] fileByte = new byte[fis.available()];
			
				fis.read(fileByte);
				fis.close();
				
				fileSizeInBytes = fileByte.length;
			} catch (FileNotFoundException e) {
				fileSizeInBytes = 0;
			} catch (Exception e) {
				ExceptionHandler.logException(e);
				throw e;
			}
		}
		
		return fileSizeInBytes;
	}
	
	public boolean isFileExists(String fileFullPath) {
		boolean isFileExists = false;
		
		if (fileFullPath != null && !fileFullPath.equals("")) {
			try {
				FileInputStream fis = new FileInputStream(StringEscapeUtils.unescapeHtml(fileFullPath));
				byte[] fileByte = new byte[fis.available()];
				
				fis.read(fileByte);
				fis.close();
				
				isFileExists = true;
			} catch (IOException e) {
				isFileExists = false;
			}
		}
		return isFileExists;
	}
	
	public JSONObject getAttachments(HttpServletRequest request) throws SQLException, JSONException, UploadModeException {
		String uploadMode = request.getParameter("uploadMode");
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		if ("par".equals(uploadMode)) {
			params.put("ACTION", "selectGIPIWPicture2");
			params.put("parId", request.getParameter("genericId"));
		} else if ("policy".equals(uploadMode)) {
			params.put("ACTION", "selectGIPIPicture2");
			params.put("policyId", request.getParameter("genericId"));
		} else if ("clmItemInfo".equals(uploadMode)) {
			params.put("ACTION", "selectGICLPictures2");
			params.put("claimId", request.getParameter("genericId"));
		} else if ("quotation".equals(uploadMode) || "packQuotation".equals(uploadMode)) {
			params.put("ACTION", "selectGipiQuotePicturesTG");
			params.put("quoteId", request.getParameter("genericId"));
		} else if ("inspection".equals(uploadMode)) {
			params.put("ACTION", "selectGipiInspPicturesTG");
			params.put("inspNo", request.getParameter("genericId"));
		} else {
			throw new UploadModeException("Invalid uploadMode: " + uploadMode);
		}
		
		params.put("itemNo", request.getParameter("itemNo"));
		
		Map<String, Object> attachments = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(attachments);
	}
	
	@SuppressWarnings("unchecked")
	public void saveAttachments(HttpServletRequest request, String userId) throws SQLException, JSONException, UploadModeException {
		String uploadMode = request.getParameter("uploadMode");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, FileEntity.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, FileEntity.class));
		
		List<FileEntity> setList = (List<FileEntity>) params.get("setRows");
		List<FileEntity> delList = (List<FileEntity>) params.get("delRows");
		
		if ("par".equals(uploadMode)) {
			this.getFileEntityDAO().deleteGIPIWPicture2(delList);
			this.getFileEntityDAO().saveGIPIWPicture2(setList);
		} else if ("policy".equals(uploadMode)) {
			this.getFileEntityDAO().deleteGIPIPicture2(delList);
			this.getFileEntityDAO().saveGIPIPicture2(setList);
		} else if ("clmItemInfo".equals(uploadMode)) {
			this.getFileEntityDAO().deleteGICLPicture2(delList);
			this.getFileEntityDAO().saveGICLPicture2(setList);
		} else if ("quotation".equals(uploadMode) || "packQuotation".equals(uploadMode)) {
			this.getFileEntityDAO().deleteGipiQuotePictures(delList);
			this.getFileEntityDAO().saveGipiQuotePictures(setList);
		} else if ("inspection".equals(uploadMode)) {
			this.getFileEntityDAO().deleteGipiInspPictures2(delList);
			this.getFileEntityDAO().saveGipiInspPictures(setList);
		} else {
			throw new UploadModeException("Invalid uploadMode: " + uploadMode);
		}
		
		List<String> files = new ArrayList<String>();
		for (FileEntity file : delList) {
			files.add(file.getFileName());
		}
		FileUtil.deleteFiles(files);
	}
	
	public Integer getAttachmentTotalSize(String uploadMode, Integer genericId, Integer itemNo) throws SQLException, IOException, UploadModeException {
		Integer attachmentTotalSize = 0;
		
		List<FileEntity> attachments = null;
		
		if ("par".equals(uploadMode)) {
			attachments = this.getFileEntityDAO().getGIPIWPictures(genericId, itemNo);
		} else if ("policy".equals(uploadMode)) {
			attachments = this.getFileEntityDAO().getGIPIPictures(genericId, itemNo);
		} else if ("clmItemInfo".equals(uploadMode)) {
			attachments = this.getFileEntityDAO().getGICLPictures(genericId, itemNo);
		} else if ("quotation".equals(uploadMode) || "packQuotation".equals(uploadMode)) {
			attachments = this.getFileEntityDAO().getGipiQuotePictures(genericId, itemNo);
		} else if ("inspection".equals(uploadMode)) {
			attachments = this.getFileEntityDAO().getGIPIInspPictures(genericId, itemNo);
		} else {
			throw new UploadModeException("Invalid uploadMode: " + uploadMode);
		}
		
		for (FileEntity attachment  : attachments) {
			try {
				FileInputStream fis = new FileInputStream(attachment.getFileName());
				byte[] file = new byte[fis.available()];
				fis.read(file);
				fis.close();
				attachmentTotalSize += file.length;
			} catch (FileNotFoundException e) {
				continue; // when file not found, continue to next file
			}
		}
		
		return attachmentTotalSize;
	}
}
