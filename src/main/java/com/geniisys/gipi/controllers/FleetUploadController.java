/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.awt.Desktop;
import java.awt.Desktop.Action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
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
import com.geniisys.gipi.entity.GIPIMCUpload;
import com.geniisys.gipi.exceptions.InvalidUploadFeetDataException;
import com.geniisys.gipi.service.GIPIMCErrorLogService;
import com.geniisys.gipi.service.GIPIMCUploadService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

/**
 * The Class FleetUploadController.
 */
public class FleetUploadController extends HttpServlet {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -4273547948845186518L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(FleetUploadController.class);
	
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
			GIPIMCUploadService mcUploadService = (GIPIMCUploadService) APPLICATION_CONTEXT.getBean("gipiMCUploadService");
			
			int parId = Integer.parseInt((null == request.getParameter("parId") || "".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId")));
			String filePath = (String) APPLICATION_CONTEXT.getBean("uploadPath");
			
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
		                    	throw new UploadSizeLimitExceededException("Upload limit is only 1MB");
		                    } else {
			                    // Create new File object
			                    uploadedFile = new File(filePath, myFileName);
			                    /*if (uploadedFile.isFile()) {
			                    	throw new MediaAlreadyExistingException("Media already exists!");
			                    }*/
		
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    sb.append("SUCCESS");
			                    
			                    // write media to drive c:
			                    if ("".equals(mcUploadService.validateUploadFile(myFileName))) {
			                    	throw new MediaAlreadyExistingException("The fleet data you are trying to upload is already existing!");
			                    }
			                    List<GIPIMCUpload> mcUploads = mcUploadService.readAndPrepareRecords(uploadedFile, USER.getUserId(), myFileName);
			                    mcUploadService.setGipiMCUpload(mcUploads);
		                    }
						}
					}
				}
				log.info("Reading and saving of fleet data is successful!");
				System.gc();
				response.getWriter().write(sb.toString());
			
			} catch (InvalidUploadFeetDataException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - " +e.getMessage());
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
				response.getWriter().write("ERROR - "+e.getMessage());
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - "+e.getMessage());
			} finally {
				session.removeAttribute("LISTENER");
				FileUtil.deleteDirectory(filePath);
			}
		} else if ("viewErrorLog".equals(action)) {
			String PAGE = "/pages/genericMessage.jsp";
			String message = "SUCCESS";
			try {
				GIPIMCErrorLogService errorLogService = (GIPIMCErrorLogService) APPLICATION_CONTEXT.getBean("gipiMCErrorLogService");
				String fileName = request.getParameter("fileName");
				String myFullFileName = fileName;
                
				String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
				int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
                
                // Ignore the path and get the filename
            	System.out.println("Error Size: " + errorLogService.getGipiMCErrorList(myFullFileName.substring(lastIndexOfSlash+1)).size());
				request.setAttribute("errors", errorLogService.getGipiMCErrorList(myFullFileName.substring(lastIndexOfSlash+1)));
				PAGE = "/pages/underwriting/overlay/subPages/errorLog.jsp";
		 	} catch (SQLException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
		 	}
		 	request.setAttribute("message", message);
		 	this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
		} else if ("viewErrorLog2".equals(action)) {
			String message = "SUCCESS";
			String PAGE = "/pages/underwriting/overlay/fleetData/errorLog.jsp";
			
			try {
				GIPIMCErrorLogService errorLogService = (GIPIMCErrorLogService) APPLICATION_CONTEXT.getBean("gipiMCErrorLogService");
				JSONObject jsonGIPIS198ErrorLog = errorLogService.getGipiMCErrorList2(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonGIPIS198ErrorLog.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{					
					request.setAttribute("jsonGIPIS198ErrorLog", jsonGIPIS198ErrorLog);
					PAGE = "/pages/underwriting/overlay/fleetData/errorLog.jsp";
				}
				
			} catch (SQLException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";	
			} catch (JSONException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";		
			} catch (ParseException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";	
			} finally {
				request.setAttribute("message", message);
				this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
			}
			
			
		} else if ("validateUploadFleet".equals(action)) {
			GIPIMCUploadService mcUploadService = (GIPIMCUploadService) APPLICATION_CONTEXT.getBean("gipiMCUploadService");
			String fileName = request.getParameter("fileName");
			String myFullFileName = fileName;
			String slashType = (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
			int lastIndexOfSlash = myFullFileName.lastIndexOf(slashType);
			String PAGE = "/pages/genericMessage.jsp";
			String message = "";
			System.out.println("Validating file if exists - "+myFullFileName.substring(lastIndexOfSlash+1));
			try {
				String isExist = mcUploadService.validateUploadFile(myFullFileName.substring(lastIndexOfSlash+1));
				if (!("".equals(isExist)) && isExist != null) {
					message = isExist;
					System.out.println("validateUpload message: "+isExist);
				}
			} catch(SQLException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			} finally {
				request.setAttribute("message", message);
				this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
			}
		} else if ("uploadFleet".equals(action)) {
			GIPIMCUploadService mcUploadService = (GIPIMCUploadService) APPLICATION_CONTEXT.getBean("gipiMCUploadService");
			
			
			Integer parId = Integer.parseInt((null == request.getParameter("parId") || "".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId")));
			String sublineCd = request.getParameter("sublineCd");
			String filePath = (String) APPLICATION_CONTEXT.getBean("uploadPath");
			
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
			
			Map<String, Object> params = new HashMap<String, Object>();
			
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
		                    	throw new UploadSizeLimitExceededException("Upload limit is only 1MB");
		                    } else {
			                    // Create new File object
			                    uploadedFile = new File(filePath, myFileName);
			                    /*if (uploadedFile.isFile()) {
			                    	throw new MediaAlreadyExistingException("Media already exists!");
			                    }*/
		
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    // write media to drive c:
			                    if ("".equals(mcUploadService.validateUploadFile(myFileName))) {
			                    	throw new MediaAlreadyExistingException("The fleet data you are trying to upload is already existing!");
			                    }
			                   
			                    //belle 11.20.2012
			                    Map<String, Object> fileParams = new HashMap<String, Object>();
			                    fileParams.put("uploadedFile", uploadedFile);
			                    fileParams.put("userId", USER.getUserId());
			                    fileParams.put("myFileName", myFileName);
			                    fileParams.put("parId", parId);
			                    fileParams.put("sublineCd",sublineCd);
			                    fileParams.put("lineCd", request.getParameter("lineCd"));
			                    fileParams.put("packPolFlag", request.getParameter("packPolFlag"));
			                    
			                   // params = mcUploadService.readAndPrepareFleetMC(uploadedFile, USER.getUserId(), myFileName, parId, sublineCd);
			                    params = mcUploadService.readAndPrepareFleetMC(fileParams);
			                    if (params.get("checkRequiredFields").equals(null) ? false : (Boolean) params.get("checkRequiredFields")) {	//added by Gzelle 09232014
			                    	log.info("Required fields must be complete.");	
									throw new SQLException("--Missing mandatory fields in file.");
								}	   
			                    params.put("parId", parId);
			                    mcUploadService.setUploadedFleet(params);
			                    
			                    Integer totalErrors = params.get("totalErrors") == null || params.get("totalErrors") == "" ? 0 : Integer.parseInt(params.get("totalErrors").toString());
			                    if(totalErrors > 0) {
			                    	sb.append(totalErrors.toString() + " records were not uploaded.");
			                    	sb.append("-" + params.get("recordsUploaded"));	//marco - 02.01.2013
			                    	sb.append("-" + params.get("totalRecords"));	//
			                    } else {
			                    	sb.append("SUCCESS");
			                    	sb.append("-" + params.get("recordsUploaded")); //marco - 02.01.2013
			                    	sb.append("-" + params.get("totalRecords"));	//
			                    }
		                    }
						}
					}
				}
				log.info("Reading and saving of fleet data is successful!");
				
				System.gc();
				response.getWriter().write(sb.toString());
			
			} catch (InvalidUploadFeetDataException e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - " +e.getMessage());
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
				response.getWriter().write("ERROR - "+e.getMessage());
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				response.getWriter().write("ERROR - "+e.getMessage());
			} finally {
				session.removeAttribute("LISTENER");
				FileUtil.deleteDirectory(filePath);
			}
		} else if ("openFileInApp".equals(action)) {
			String PAGE = "/pages/genericMessage.jsp";
			String message = "";
			String fileName = request.getParameter("fileName");
			System.out.println("filename: "+fileName);
			try {
				if(!Desktop.isDesktopSupported()) {
					message = "Desktop not supported.";
				}
				
				Desktop dt = Desktop.getDesktop();
				if(!dt.isSupported(Action.OPEN)) {
					message = "Cannot open file.";
				}
				File file = new File(fileName);
				//dt.open(file);
				Process p = Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + fileName);
				
			} catch(Exception e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			}/* catch(IOException e) {
				message = ExceptionHandler.handleException(e, USER);
				PAGE = "/pages/genericMessage.jsp";
			} */finally {
				request.setAttribute("message", message);
				this.getServletContext().getRequestDispatcher(PAGE).forward(request, response);
			}
		}
	}
}
