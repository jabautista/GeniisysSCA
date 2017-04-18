/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.MediaAlreadyExistingException;
import com.geniisys.common.exceptions.UploadSizeLimitExceededException;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.service.GIPIQuotePicturesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * Handles File Uploads in the Attached Media Module of Quotation Information
 * @author Marnel J. Rodriguez
 * 
 */
public class FileUploadController extends javax.servlet.http.HttpServlet
		implements javax.servlet.Servlet {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 9139080380555987199L;
	
	/** The log. */
	private Logger log = Logger.getLogger(FileUploadController.class);
	
	/**
	 * Instantiates a new file upload controller.
	 */
	public FileUploadController() {
		super();
	}
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		String action = request.getParameter("action");
		
		if ("showAttachedMediaPage".equals(action)) {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			//HttpSession session = request.getSession();
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			//Map<String, Object> SESSION_PARAMETERS = (Map<String, Object>) session.getAttribute("PARAMETERS");
			//String env = (String) SESSION_PARAMETERS.get("environment");
			
			
			System.out.println("quoteID:<" + request.getParameter("quoteId") + ">");
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			/*end of default attributes*/

			GIPIQuotePicturesService pictureService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService"); // +env
			request.setAttribute("quoteId", quoteId);
			int itemNo = Integer.parseInt(request.getParameter("itemNo").equals("") ? "0" : request.getParameter("itemNo"));
			request.setAttribute("mediaItemNo", itemNo);
			
			List<GIPIQuotePictures> media = null;
			try {
				//media = pictureService.getGIPIQuotePictures(new GIPIQuotePictures(quoteId, itemNo)); replaced by Nica 05.10.2011
				media = pictureService.getAllGIPIQuotePictures(quoteId);
				request = pictureService.writeMedia(request, media); // copy to server installation directory
			} catch (SQLException e){
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (FileNotFoundException e){
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (IOException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			//this.getServletContext().getRequestDispatcher("/pages/marketing/quotation/pop-ups/attachedMedia.jsp").forward(request, response); replaced by: Nica 05.11.2011
			this.getServletContext().getRequestDispatcher("/pages/marketing/quotation/subPages/quotationInformation/quoteAttachedMedia.jsp").forward(request, response);
		
		}else if("showAttachedMediaPageForPackQuotation".equals(action)){
			try {
				
				ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
				GIPIQuotePicturesService pictureService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService");
				
				List<GIPIQuotePictures> media = null;
				Integer packQuoteId = Integer.parseInt((request.getParameter("packQuoteId") == null) ? "0" : request.getParameter("packQuoteId"));
				media = pictureService.getAllGIPIQuotePicturesForPackQuotation(packQuoteId);
				request = pictureService.writeMedia(request, media);
			
			} catch (SQLException e){
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (FileNotFoundException e){
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (IOException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			this.getServletContext().getRequestDispatcher("/pages/marketing/quotation-pack/quotationInformation-pack/subPages/quotationAttachedMedia.jsp").forward(request, response);
		
		}else {
			HttpSession session = null;
			FileUploadListener listener = null;
			long contentLength = 0;
	
			if (((session = request.getSession()) == null) || ((listener = (FileUploadListener) session.getAttribute("LISTENER")) == null)
					|| ((contentLength = listener.getContentLength()) < 1)) {
				out.write("");
				out.close();
				return;
			}
			
			response.setContentType("text/html");
			long percentComplete = ((100 * listener.getBytesRead()) / contentLength);
			out.print(percentComplete);
			out.close();
		}
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");
		//String env = "";
		Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null != sessionParameters){
			USER = (GIISUser) sessionParameters.get("USER");
			//env = (String) sessionParameters.get("environment");
		}
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIQuotePicturesService pictureService = (GIPIQuotePicturesService) APPLICATION_CONTEXT.getBean("gipiQuotePicturesService"); // +env
		
		int quoteId = Integer.parseInt((null == request.getParameter("quoteId") || "".equals(request.getParameter("quoteId")) ? "0" : request.getParameter("quoteId")));
		//int itemNo 	= Integer.parseInt(null == request.getParameter("itemNo") || "".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
		int itemNo 	= Integer.parseInt(null == request.getParameter("mediaItemNo") || "".equals(request.getParameter("mediaItemNo")) ? "0" : request.getParameter("mediaItemNo"));
		String filePath = APPLICATION_CONTEXT.getBean("uploadPath").toString() +"/marketing/quotation/attached_media";
		
		System.out.println("ACTION: " + action);
		
		if ("saveMedia".equals(action)) {
			response.setContentType("text/html");
	
			// create file upload factory and upload servlet
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			
			// set file upload progress listener
			FileUploadListener listener = new FileUploadListener();
			HttpSession session = request.getSession();
			session.setAttribute("LISTENER", listener);
			// upload servlet allows to set upload listener
			upload.setProgressListener(listener);
	
			// to be used to write response
			StringBuffer sb = new StringBuffer();
			
			List items = null;
			FileItem fileItem = null;
			String myFileName = "";
			String mediaItemNo = null;
			
			if(request.getParameter("mediaItemNo")!=null) {
				mediaItemNo = request.getParameter("mediaItemNo");
				System.out.println("mediaItemNo = " + mediaItemNo);
			} else {
				System.out.println("NULL item NO");
			}
			
			String saveAs 	= request.getParameter("saveAs");
			String remarks 	= request.getParameter("remarks");
			
//			System.out.println("***************-----------************---------***********");
//			System.out.println("save as: " + saveAs);
//			System.out.println("REMARKS: " + remarks);
			
			try {
				(new File(filePath+"/"+request.getParameter("quoteId"))).mkdir();
				filePath = filePath + "/" + quoteId;
				
				File dir = new File(filePath);
				File[] files = dir.listFiles();
				
				long totalSize = 0L;
				if (files != null) {
					for (File f: files) {
						totalSize += f.length();
					}
//					System.out.println("totalSize: " + totalSize);
				}
				if (totalSize > 3145728L) {
					throw new UploadSizeLimitExceededException("You've exceeded your maximum allowable upload of 3MB.");
				}
				
				// iterate over all uploaded files
				items = upload.parseRequest(request);
				int c = 0;
				for (Iterator i = items.iterator(); i.hasNext();) {
					c++;
					System.out.println("iterator: " + c);
					
					fileItem = (FileItem) i.next();
					if (!fileItem.isFormField()) {
						if (fileItem.getSize() > 0) {
							// code that handle uploaded fileItem
							// don't forget to delete uploaded files after you done
							// with them! Use fileItem.delete();
							File uploadedFile = null;
							String myFullFileName = fileItem.getName();
		                    
							String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
							int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
		                    int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
		                    
		                    // Ignore the path and get the filename
		                    if (!"".equals(saveAs)) {
		                    	myFileName = saveAs+"."+ myFullFileName.substring(lastIndexOfPeriod+1);
		                    } else {
		                    	myFileName = myFullFileName.substring(lastIndexOfSlash+1);
		                    }
		                    
		                    /*if (new File(filePath+"/"+myFileName).isFile()) {
		                    	throw new MediaAlreadyExistingException("Picture/Video already existing.");
		                    } else */
		                    /*if (!pictureService.isFileValid(myFullFileName, lastIndexOfPeriod)) {
		                    	fileItem.delete();
		                    	throw new FileUploadException("The file you are trying to upload is not supported.");
		                    }/else if (listener.getBytesRead() > 1048576) {
		                    	fileItem.delete();
		                    	throw new UploadSizeLimitExceededException("Upload limit is only 1MB");
		                    } else {*/
			                // Create new File object
			                uploadedFile = new File(filePath, myFileName);
			                if (uploadedFile.isFile()) {
			                	throw new MediaAlreadyExistingException("Media already exists!");
			                }

			                // Write the uploaded file to the system
			                fileItem.write(uploadedFile);

			                String mediaType = pictureService.getMediaTypes(myFullFileName, lastIndexOfPeriod).get(1);
			                String medType = pictureService.getMediaTypes(myFullFileName, lastIndexOfPeriod).get(2);

			                sb.append(filePath+"/"+myFileName+"----"+myFileName+"----"+mediaType+"----"+listener.getBytesRead()+"----"+StringFormatter.replaceTildes(StringFormatter.replaceQuotes(remarks))+"----"+quoteId+"----"+"SUCCESS");
			                fileItem.delete();

			                // save the data to the database
			                pictureService.saveGIPIQuotePictures(new GIPIQuotePictures(quoteId, itemNo,
			                		filePath+"/"+myFileName, medType,
			                		myFullFileName.substring(lastIndexOfPeriod+1),
			                		remarks, USER.getUserId()));

			                // write media to web server
			                pictureService.writeMedia(request, filePath+"/"+myFileName, quoteId);
		                    //}
						}
					}
				}
				
				response.getWriter().write(sb.toString());
			
			} catch (MediaAlreadyExistingException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR----"+e.getMessage());
			} catch (FileUploadException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR----"+e.getMessage());
			} catch (UploadSizeLimitExceededException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR----"+e.getMessage());
			} catch (SQLException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR----"+e.getMessage());
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR----"+e.getMessage());
			} finally {
				session.removeAttribute("LISTENER");
			}
		}
		else if("saveAllMedia".equals(action)){
			response.setContentType("text/html");
			
			// create file upload factory and upload servlet
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
	
			// set file upload progress listener
			FileUploadListener listener = new FileUploadListener();
			HttpSession session = request.getSession();
			session.setAttribute("LISTENER", listener);
			// upload servlet allows to set upload listener
			upload.setProgressListener(listener);
	
			// to be used to write response
			StringBuffer sb = new StringBuffer();
			
			List items = null;	FileItem fileItem = null;	String myFileName = "";		String mediaItemNo = null;
			
			if(request.getParameter("itemNo")!=null){
				mediaItemNo = request.getParameter("itemNo");
				System.out.println("mediaItemNo = " + mediaItemNo);
			} else {
				System.out.println("NULL item NO");
			}
			
			String saveAs = request.getParameter("saveAs");
			String remarks = request.getParameter("remarks");
			
			try {
				(new File(filePath+"/"+request.getParameter("quoteId"))).mkdir();
				filePath = filePath + "/" + quoteId;
				
				File dir = new File(filePath);		
				File[] files = dir.listFiles();		
				
				long totalSize = 0L;
				if (files != null) {				// loop among the files contained in the server installation directory
					for (File f: files) {			// get the total of all the files in the directory
						totalSize += f.length();
					}
				}
				if (totalSize > 3145728L) {			//  filePath - server installation directory
					throw new UploadSizeLimitExceededException("You've exceeded your maximum allowable upload of 3MB.");
				}
				
				// iterate over all uploaded files
				items = upload.parseRequest(request);
				for (Iterator i = items.iterator(); i.hasNext();) {
					fileItem = (FileItem) i.next();
					if (!fileItem.isFormField()) {
						if (fileItem.getSize() > 0) {

						// code that handle uploaded fileItem
						// don't forget to delete uploaded files after you done
						// with them! Use fileItem.delete();
						File uploadedFile = null;
						String myFullFileName = fileItem.getName();
		                    
						String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
						int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
		                int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
		                    
		                // Ignore the path and get the filename
		                if (!"".equals(saveAs)) {
		                	myFileName = saveAs +"."+ myFullFileName.substring(lastIndexOfPeriod+1);
		                } else {
		                	myFileName = myFullFileName.substring(lastIndexOfSlash+1);
		                }
		                    
		                uploadedFile = new File(filePath, myFileName);

			            if (uploadedFile.isFile()) {
			               	throw new MediaAlreadyExistingException("Media already exists!");
			            }

			            // Write the uploaded file to the system
			            fileItem.write(uploadedFile);
			            
			            String mediaType = pictureService.getMediaTypes(myFullFileName, lastIndexOfPeriod).get(1);
			            String medType = pictureService.getMediaTypes(myFullFileName, lastIndexOfPeriod).get(2);
			            
			            sb.append(filePath+"/"+myFileName+"----"+myFileName+"----"+mediaType+"----"+listener.getBytesRead()+"----"+StringFormatter.replaceTildes(StringFormatter.replaceQuotes(remarks))+"----"+quoteId+"----"+"SUCCESS");
			            fileItem.delete();
			                    
			            // save the data to the database
			            pictureService.saveGIPIQuotePictures(new GIPIQuotePictures(quoteId, itemNo,
			               		filePath+"/"+myFileName, medType,
			               		myFullFileName.substring(lastIndexOfPeriod+1),
			                   	remarks, USER.getUserId()));
			            
			            // write media to web server
			            pictureService.writeMedia(request, filePath+"/"+myFileName, quoteId);
		                //}
						}
					}
				}
				response.getWriter().write(sb.toString());
			
			} catch (MediaAlreadyExistingException e) {		response.getWriter().write("ERROR----" + e.getMessage());
			} catch (FileUploadException e) {				response.getWriter().write("ERROR----" + e.getMessage());
			} catch (UploadSizeLimitExceededException e) {	response.getWriter().write("ERROR----" + e.getMessage());
			} catch (SQLException e) {						response.getWriter().write("ERROR----" + e.getMessage());
			} catch (Exception e) {							response.getWriter().write("ERROR----" + e.getMessage());
			} finally {
				session.removeAttribute("LISTENER");
			}
			
		}//*******************************************************************************************************XXXXXXXXXXXXXX
		else if("deleteMedia".equals(action)) { 
			try {
				log.info("Deleting gipiQuotePicture with quoteId=" + quoteId + ", itemNo=" + itemNo + ", fileName=" + request.getParameter("fileName"));
				pictureService.deleteGIPIQuotePicture(new GIPIQuotePictures(quoteId, itemNo, request.getParameter("fileName")));
				File dir = new File(request.getSession().getServletContext().getRealPath("")+"/"+quoteId);
				File[] files = dir.listFiles();
				if (files != null)	{
					for (File file: files) {
						if (file.getName().equals(request.getParameter("shortFileName"))) {
							file.delete();
						}
					}
				}
				
				// delete main directory in the web server if it is empty
				if (files.length < 1) {
					if (dir.isDirectory()) {
						dir.delete();
					}
				}
				
				File mainDir = new File(filePath+"/"+quoteId);
				File[] mainDirFiles = mainDir.listFiles();
				if (mainDirFiles != null) {
					for (File f: mainDirFiles) {
						if (f.getName().equals(request.getParameter("shortFileName"))) {
							f.delete();
						}
					}
					
					// delete main directory in drive if it is empty
					if (mainDirFiles.length < 1) {
						if (mainDir.isDirectory()) {
							mainDir.delete();
						}
					}
				}
				
				request.setAttribute("message", "SUCCESS");
			} catch (SQLException e) {
				request.setAttribute("message", "ERROR");
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			
			this.getServletContext().getRequestDispatcher("/pages/genericMessage.jsp").forward(request, response);
		} else if ("deleteAllMedia".equals(action)) {
			try	{
				File dir = new File(request.getSession().getServletContext().getRealPath("")+"/"+quoteId);
				File[] files = dir.listFiles();
				if (files != null)	{
					for (File file: files) {
						file.delete();
					}
				}
				dir.delete();
			} catch (Exception e) {
				response.getWriter().write("ERROR----"+e.getMessage());
			}
		} else if ("updateRemarks".equals(action)) {
			try {
				pictureService.updateRemarks(request);
			} catch (SQLException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
			PrintWriter writer = response.getWriter();
			writer.write(request.getParameter("value"));
			writer.flush();
			writer.close();
		}
	}
}