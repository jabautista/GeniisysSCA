package com.geniisys.gipi.controllers;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.MediaAlreadyExistingException;
import com.geniisys.common.exceptions.UploadSizeLimitExceededException;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIErrorLog;
import com.geniisys.gipi.exceptions.InvalidUploadEnrolleesDataException;
import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;
import com.geniisys.gipi.service.GIPIErrorLogService;
import com.geniisys.gipi.service.GIPIUploadTempService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

public class UploadEnrolleesController extends HttpServlet {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -4273547948845186518L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(UploadEnrolleesController.class);
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		HttpSession session = null;
		FileUploadListener listener = null;
		long contentLength = 0;

		if (((session = request.getSession()) == null)
				|| ((listener = (FileUploadListener) session
						.getAttribute("LISTENER")) == null)
				|| ((contentLength = listener.getContentLength()) < 1)) {
			out.write("");
			out.close();
			return;
		}

		response.setContentType("text/html");
		long percentComplite = ((100 * listener.getBytesRead()) / contentLength);
		out.print(percentComplite);
		out.close();
	}
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	@SuppressWarnings({ "unchecked", "rawtypes" })
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");
		Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null != sessionParameters){
			USER = (GIISUser) sessionParameters.get("USER");
		}
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		if ("uploadFile".equals(action)) {
			GIPIUploadTempService gipiUploadTempService = (GIPIUploadTempService) APPLICATION_CONTEXT.getBean("gipiUploadTempService");
			
			int parId = Integer.parseInt((null == request.getParameter("parId") || "".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId")));
			String filePath = (String) APPLICATION_CONTEXT.getBean("uploadPath");
			
			System.out.println("filePath : " + filePath);
			
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
			
			try {
				(new File(filePath+"/"+parId)).mkdir();
				filePath = filePath + "/" + parId;
				
				// iterate over all uploaded files
				items = upload.parseRequest(request);
				File uploadedFile = null;
				for (Iterator i = items.iterator(); i.hasNext();) {
					fileItem = (FileItem) i.next();
					if (!fileItem.isFormField()) {
						if (fileItem.getSize() > 0) {
							// code that handle uploaded fileItem
							// don't forget to delete uploaded files after you done
							// with them! Use fileItem.delete();
							String myFullFileName = fileItem.getName();
		                    
							String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
							int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
		                    int lastIndexOfPeriod = myFullFileName.lastIndexOf(".");
		                    
		                    // Ignore the path and get the filename
	                    	myFileName = myFullFileName.substring(lastIndexOfSlash+1);
		                    
		                    if (!FileUtil.isExcelFile(myFullFileName, lastIndexOfPeriod)) {
		                    	fileItem.delete();
		                    	throw new FileUploadException("The file you are trying to upload is not supported.");
		                    } else if (listener.getBytesRead() > 1048576) {
		                    	fileItem.delete();
		                    	throw new UploadSizeLimitExceededException("Upload limit is only 1 MB per file.");
		                    } else {
			                    // Create new File object
			                    uploadedFile = new File(filePath, myFileName);
			                    //if (uploadedFile.isFile()) {
			                    //	throw new MediaAlreadyExistingException("Media already exists!");
			                    //}
		
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    Map<String, Object> params = new HashMap<String, Object>();
			                    //marco - 11.26.2012 - replaced with readAndPrepareRecords2
			                    //params = gipiUploadTempService.readAndPrepareRecords(uploadedFile, USER.getUserId(), myFileName); 
			                    params = gipiUploadTempService.readAndPrepareRecords2(uploadedFile, USER.getUserId(), myFileName);
		                    	gipiUploadTempService.setGipiEnrolleeUpload(params);
		                    	
			                    sb.append("SUCCESS-" + gipiUploadTempService.getUploadCount((String)params.get("uploadNo")) + "-" + params.get("enrolleeUploadsCount"));
		                    }
						}
					}
				}
				log.info("Reading and saving of uploaded enrollees data is successful!");
				System.gc();
				response.getWriter().write(sb.toString());
			} catch (InvalidUploadEnrolleesDataException e) {
				e.printStackTrace();
				response.getWriter().write("ERROR - There was an error in the file you are trying to upload, please check the file.");
			} catch (InvalidUploadFeetDataException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - " + e.getMessage());
			} catch (MediaAlreadyExistingException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - "+e.getMessage());
			} catch (FileUploadException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - "+e.getMessage());
			} catch (UploadSizeLimitExceededException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - "+e.getMessage());
			} catch (SQLException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - There was an error in the file you are trying to upload, please check the file.");
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - There was an error in the file you are trying to upload, please check the file.");
			} finally {
				session.removeAttribute("LISTENER");
				FileUtil.deleteDirectory(filePath);
			}
		} else if ("viewErrorLog".equals(action)) {
			String PAGE = "/pages/genericMessage.jsp";
			String message = "SUCCESS";
			try {
				GIPIErrorLogService errorLogService = (GIPIErrorLogService) APPLICATION_CONTEXT.getBean("gipiErrorLogService");
				String fileName = request.getParameter("fileName");
				String myFullFileName = fileName;
                
				String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
				int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
                
                // Ignore the path and get the filename
				List<GIPIErrorLog> gipiErrorlog = errorLogService.getGipiErrorLog(myFullFileName.substring(lastIndexOfSlash+1).substring(0, fileName.indexOf(".")));
				System.out.println("Filename: "+ myFullFileName.substring(lastIndexOfSlash+1).substring(0, fileName.indexOf(".")));
            	System.out.println("Error Size: " + gipiErrorlog.size());
				request.setAttribute("errors", gipiErrorlog);
				request.setAttribute("errorSize", gipiErrorlog.size());
				PAGE = "/pages/underwriting/overlay/subPages/errorLogEnrollees.jsp";
		 	} catch (SQLException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
		 	}
		 	request.setAttribute("message", message);
		 	this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
		} else if("viewErrorLogTG".equals(action)){
			String PAGE = "/pages/genericMessage.jsp";
			String message = "SUCCESS";
			
			try{
				String fileName = request.getParameter("fileName");
				String myFullFileName = fileName;
				String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
				int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
				
				Map<String, Object> tgErrorLog = new HashMap<String, Object>();
				
				tgErrorLog.put("ACTION", "getGIPIErrorLogTG");
				tgErrorLog.put("filename", myFullFileName.substring(lastIndexOfSlash+1).substring(0, fileName.indexOf(".")));
				tgErrorLog = TableGridUtil.getTableGrid2(request, tgErrorLog);
				
				if("1".equals(request.getParameter("refresh"))){
					message = (new JSONObject(tgErrorLog)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("tgErrorLog", new JSONObject(tgErrorLog));					
					PAGE = "/pages/underwriting/overlay/enrollees/subPages/errorLogsTableGridListing.jsp";
				}				
			} catch(SQLException e){
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			} catch (JSONException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			} catch(Exception e){
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			}finally{
				request.setAttribute("message", message);
				this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
			}
		} else if ("validateUploadFile".equals(action)) {
			GIPIUploadTempService gipiUploadTempService = (GIPIUploadTempService) APPLICATION_CONTEXT.getBean("gipiUploadTempService");
			String fileName = request.getParameter("fileName");
			String myFullFileName = fileName;
			String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
			int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
			String PAGE = "/pages/genericMessage.jsp";
			String message = "";
			try {
				String isExist = gipiUploadTempService.validateUploadFile(myFullFileName.substring(lastIndexOfSlash+1));
				if (!"".equals(isExist) || isExist!=null) {
					message = isExist;
					System.out.println(message);
				}
			} catch (SQLException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			}finally {
				request.setAttribute("message", message);
				this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
			}
		}
	}
}
