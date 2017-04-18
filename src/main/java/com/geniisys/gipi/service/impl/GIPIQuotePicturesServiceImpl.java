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
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.dao.GIPIQuotePicturesDAO;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.service.GIPIQuotePicturesService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIQuotePicturesServiceImpl.
 */
public class GIPIQuotePicturesServiceImpl implements GIPIQuotePicturesService {

	/** The gipi quote pictures dao. */
	private GIPIQuotePicturesDAO gipiQuotePicturesDAO;
	private static Logger log = Logger.getLogger(GIPIQuotePicturesServiceImpl.class);
	
	/**
	 * Gets the gipi quote pictures dao.
	 * 
	 * @return the gipi quote pictures dao
	 */
	public GIPIQuotePicturesDAO getGipiQuotePicturesDAO() {
		return gipiQuotePicturesDAO;
	}

	/**
	 * Sets the gipi quote pictures dao.
	 * 
	 * @param gipiQuotePicturesDAO the new gipi quote pictures dao
	 */
	public void setGipiQuotePicturesDAO(GIPIQuotePicturesDAO gipiQuotePicturesDAO) {
		this.gipiQuotePicturesDAO = gipiQuotePicturesDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#getGIPIQuotePictures(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@Override
	public List<GIPIQuotePictures> getGIPIQuotePictures(GIPIQuotePictures picture)
			throws SQLException {
		return this.getGipiQuotePicturesDAO().getGIPIQuotePictures(picture);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#saveGIPIQuotePictures(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@Override
	public void saveGIPIQuotePictures(GIPIQuotePictures picture)
			throws SQLException {
		this.getGipiQuotePicturesDAO().saveGIPIQuotePictures(picture);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#writeMedia(javax.servlet.http.HttpServletRequest, java.util.List)
	 */
	@Override
	public HttpServletRequest writeMedia(HttpServletRequest request, List<GIPIQuotePictures> media) 
		throws FileNotFoundException, IOException {
		
		List<GIPIQuotePictures> updatedMedia = media;
		Map<Integer, String> mediaSizes = new HashMap<Integer, String>();
		Map<Integer, String> mediaLinks = new HashMap<Integer, String>();
		Map<Integer, String> mediaPath = new HashMap<Integer, String>();
		
		int ctr = 0;
		
		// for display only
		Iterator<GIPIQuotePictures> iter = updatedMedia.iterator();
		@SuppressWarnings("unused")
		GIPIQuotePictures pix = null;
		while(iter.hasNext()){
			pix = iter.next();
		}
		
		for (GIPIQuotePictures picture: updatedMedia) {
			ctr++;
			
			/**
			 * LOOP UPDATED MEDIA
			 */
//System.out.println("UPDATED MEDIA #" + ctr);
			
			// get media real path
			mediaPath.put(ctr, picture.getFileName());
			
			File newFile;
	        try {
	        	FileInputStream fis;
	        	byte[] pdfByte = null;
	        	try {
					fis = new FileInputStream(picture.getFileName()); // cause of error
					pdfByte = new byte[fis.available()];
					fis.read(pdfByte);
					fis.close();
				} catch (Exception e) {
					//e.printStackTrace();
					//log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
					/* SR-5494 JET SEPT-26-2016; continue to next file when file not found */
					mediaSizes.put(ctr, "0");
					
					String slashType = (picture.getFileName().lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
					int startIndex = picture.getFileName().lastIndexOf(slashType);
					String fileName = StringFormatter.replaceQuotes(StringFormatter.replaceTildes(picture.getFileName().substring(startIndex+1)));
					picture.setFileName(fileName);
					picture.setRemarks(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(picture.getRemarks())));
					
					continue; 
				}
				if (!(new File(request.getSession().getServletContext().getRealPath("")+"/"+picture.getQuoteId())).isDirectory())	{
					(new File(request.getSession().getServletContext().getRealPath("")+"/"+picture.getQuoteId())).mkdir();
				}
				
				String slashType = (picture.getFileName().lastIndexOf("\\") > 0) ? "\\" : "/";    // Windows or UNIX
				
				int startIndex = picture.getFileName().lastIndexOf(slashType);
				
				String fileName = StringFormatter.replaceQuotes(StringFormatter.replaceTildes(picture.getFileName().substring(startIndex+1)));
				
				// store media real location for download
				mediaLinks.put(ctr, picture.getQuoteId()+"/"+fileName);
				
				// update file names of media to point them to the temp media in the web server
				picture.setFileName(fileName);
				picture.setRemarks(StringFormatter.replaceTildes(StringFormatter.replaceQuotes(picture.getRemarks())));
				
				newFile = new File(request.getSession().getServletContext().getRealPath("")+"/"+picture.getQuoteId()+"/"+fileName);
				FileOutputStream os = new FileOutputStream(newFile);
				os.write(pdfByte);
				os.flush();
				os.close();
				
				mediaSizes.put(ctr, new Integer(pdfByte.length/1024).toString());
				
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
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#deleteMedia(int)
	 */
	@Override
	public void deleteMedia(int quoteId) throws FileNotFoundException {
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#isFileValid(java.lang.String, int)
	 */
	@Override
	public boolean isFileValid(String file, int index) {
		if (!(file.substring(index+1).equalsIgnoreCase("mp4")) && 
        	!(file.substring(index+1).equalsIgnoreCase("mpg")) &&
        	!(file.substring(index+1).equalsIgnoreCase("mpeg")) &&
        	!(file.substring(index+1).equalsIgnoreCase("avi")) &&
        	!(file.substring(index+1).equalsIgnoreCase("3gp")) &&
        	!(file.substring(index+1).equalsIgnoreCase("3gpp")) &&
        	!(file.substring(index+1).equalsIgnoreCase("wmv")) &&
        	!(file.substring(index+1).equalsIgnoreCase("jpg")) &&
        	!(file.substring(index+1).equalsIgnoreCase("jpeg")) &&
        	!(file.substring(index+1).equalsIgnoreCase("gif")) &&
        	!(file.substring(index+1).equalsIgnoreCase("bmp")) &&
        	!(file.substring(index+1).equalsIgnoreCase("png")) &&
        	!"doc".equalsIgnoreCase(file.substring(index+1)) &&
 		   	!"docx".equalsIgnoreCase(file.substring(index+1)) &&
 		   	!"xls".equalsIgnoreCase(file.substring(index+1)) &&
 		   	!"ppt".equalsIgnoreCase(file.substring(index+1)) &&
 		    !"odt".equalsIgnoreCase(file.substring(index+1)) &&
 		    !"ods".equalsIgnoreCase(file.substring(index+1)) &&
 		   	!"pdf".equalsIgnoreCase(file.substring(index+1)) &&
 		   	!"txt".equalsIgnoreCase(file.substring(index+1))) {
		return false;
		} else {
			return true;
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#getMediaTypes(java.lang.String, int)
	 */
	@Override
	public Map<Integer, String> getMediaTypes(String fileName, int index) {
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

	/* Used to write the media in the web server for display purposes only
     * Media written would be delete after Modalbox is hidden 
     */
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#writeMedia(javax.servlet.http.HttpServletRequest, java.lang.String, int)
	 */
	@Override
	public void writeMedia(HttpServletRequest request, String file, int quoteId)
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
			
			(new File(request.getSession().getServletContext().getRealPath("")+"/"+quoteId)).mkdir();
			newFile = new File(request.getSession().getServletContext().getRealPath("")+"/"+quoteId+"/"+fileName);
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
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#deleteGIPIQuotePicture(com.geniisys.gipi.entity.GIPIQuotePictures)
	 */
	@Override
	public void deleteGIPIQuotePicture(GIPIQuotePictures picture)
			throws SQLException {
		this.getGipiQuotePicturesDAO().deleteGIPIQuotePicture(picture);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotePicturesService#updateRemarks(javax.servlet.http.HttpServletRequest)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void updateRemarks(HttpServletRequest request) throws SQLException {
		int quoteId = Integer.parseInt(request.getParameter("quoteId"));
		System.out.println("QUOTE: " + quoteId);
		int itemNo = Integer.parseInt(request.getParameter("itemNo"));
		System.out.println("ITEMNO: " + itemNo);
		String fileName = request.getParameter("fileName");
		System.out.println("FileName: " + fileName);
		String remarks = request.getParameter("value");
		System.out.println("REMARKS SERVICE: " + remarks);
		String userId = ((GIISUser)((Map<String, Object>)request.getSession().getAttribute("PARAMETERS")).get("USER")).getUserId();
		GIPIQuotePictures picture = new GIPIQuotePictures();
		picture.setQuoteId(quoteId);
		picture.setItemNo(itemNo);
		picture.setFileName(fileName);
		picture.setRemarks(remarks);
		picture.setUserId(userId);
		picture.setLastUpdate(new Date());
		this.gipiQuotePicturesDAO.updateRemarks(picture);
	}

	@Override
	public List<GIPIQuotePictures> getAllGIPIQuotePictures(Integer quoteId)
			throws SQLException {
		return this.getGipiQuotePicturesDAO().getAllGIPIQuotePictures(quoteId);
	}

	@Override
	public List<GIPIQuotePictures> getAllGIPIQuotePicturesForPackQuotation(
			Integer packQuoteId) throws SQLException {
		return this.getGipiQuotePicturesDAO().getAllGIPIQuotePicturesForPackQuotation(packQuoteId);
	}
	
	public boolean deleteItemsAttachment(List<GIPIQuoteItem> delItemRows) throws SQLException {
		if (!delItemRows.isEmpty()) {	
			List<String> files = new ArrayList<String>();
			
			for (GIPIQuoteItem item : delItemRows) {
				// get item attachments
				List<GIPIQuotePictures> attachments = this.getGipiQuotePicturesDAO().getItemAttachments(item);
				
				for (GIPIQuotePictures attachment : attachments) {
					files.add(attachment.getFileName());
				}
			}
			
			// delete item from database
			this.getGipiQuotePicturesDAO().deleteItemsAttachment(delItemRows);

			// delete files from server
			FileUtil.deleteFiles(files);
		}
		
		return true;
	}
}