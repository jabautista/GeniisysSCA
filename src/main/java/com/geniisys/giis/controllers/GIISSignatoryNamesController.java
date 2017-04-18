package com.geniisys.giis.controllers;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giis.service.GIISSignatoryNamesService;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIISSignatoryNamesController", urlPatterns="/GIISSignatoryNamesController")
public class GIISSignatoryNamesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIISSignatoryNamesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISSignatoryNamesService giisSignatoryNamesService =  (GIISSignatoryNamesService) APPLICATION_CONTEXT.getBean("giisSignatoryNamesService");
			
			if ("showGiiss071".equals(ACTION)){
				JSONObject jsonSignatoryNames = giisSignatoryNamesService.showGiiss071(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonSignatoryNamesList", jsonSignatoryNames);
					PAGE = "/pages/underwriting/fileMaintenance/general/signatoryNames/signatoryNames.jsp";
				} else {
					message = jsonSignatoryNames.toString();
					PAGE = "/pages/genericMessage.jsp";
				}				
			}else if ("valDeleteRec".equals(ACTION)){
				giisSignatoryNamesService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisSignatoryNamesService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valUpdateRec".equals(ACTION)){
				giisSignatoryNamesService.valUpdateRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiiss071".equals(ACTION)) {
				giisSignatoryNamesService.saveGiiss071(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getFilename".equals(ACTION)){
				message = giisSignatoryNamesService.getFilename(Integer.parseInt(request.getParameter("signatoryId")));
				PAGE = "/pages/genericMessage.jsp";
				
			/* begin : patterned from signatory maintenance */
			}else if ("showAttachPicture".equals(ACTION)){
				request.setAttribute("signatoryId", request.getAttribute("signatoryId"));
				PAGE = "/pages/underwriting/fileMaintenance/general/signatoryNames/popup/browsePicture.jsp";
			}else if("uploadFile".equals(ACTION)){
				FileEntityService fileService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
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
				List items 			= null;
				FileItem fileItem 	= null;
				//Integer signatoryId = Integer.parseInt(request.getParameter("txtSignatoryId"));
				
				String filePath   = (String) APPLICATION_CONTEXT.getBean("uploadPath");
				filePath += "filemaintenance/general/signatoryNames/attached_picture/";
				String uploadPath = "filemaintenance/general/signatoryNames/attached_picture/";
				new File(filePath).mkdirs();
				
				String tempFolder = APPLICATION_CONTEXT.getBean("uploadPath").toString() + "filemaintenance/general/signatoryNames/temp/";
				new File(tempFolder).mkdirs();

				// iterate over all uploaded files
				items = upload.parseRequest(request);
				
				try {
					for (Iterator i = items.iterator(); i.hasNext();) {
						fileItem = (FileItem) i.next();
						if (!fileItem.isFormField()) {
							if (fileItem.getSize() > 0) {
								// code that handle uploaded fileItem
								// don't forget to delete uploaded files after you done
								// with them! Use fileItem.delete();
								File uploadedFile = null;
								//String myFullFileName = fileItem.getName();
								
															
								//String slashType 		= (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
								//int lastIndexOfSlash 	= myFullFileName.lastIndexOf(slashType);
			                    //int lastIndexOfPeriod 	= myFullFileName.lastIndexOf(".");
			                    
			                    // Create new File object
								//uploadedFile = new File(filePath, fileItem.getName());
								
								uploadedFile = new File(tempFolder, fileItem.getName());
				                
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    String newFileName = "img" + request.getParameter("signatoryId") + ".png";
			                    File renamedFile = new File(filePath, newFileName);
			                    if(renamedFile.exists()) {
			                    	log.info("File exists, deleting file...");
			                    	renamedFile.delete();
			                    	log.info("File deleted, renaming file...");
			                    	uploadedFile.renameTo(renamedFile);
			                    	log.info("File renamed.");
			                    } else {
			                    	uploadedFile.renameTo(renamedFile);
			                    	log.info("File created.");			                    	
			                    }
			                    
			                    // write media to web server		                    
			                    
			                    Map<String, Object> params = new HashMap<String, Object>();
			                    params.put("fileName", newFileName);
			                    params.put("filePath", filePath);
			                    params.put("uploadPath", uploadPath);
			                    params.put("realPath", request.getSession().getServletContext().getRealPath(""));
			                    params.put("message", "SUCCESS");
			                    //fileService.writeMedia(params);                   
			                    
			                    List<String> files = new ArrayList<String>();
			                    //files.add(filePath.concat(fileItem.getName()));
			                    files.add(filePath.concat(newFileName));
			                    FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
								JSONObject result = new JSONObject(params); 
								message = result.toString();
								
								log.info("Deleting temporary folders...");
								FileUtils.deleteDirectory(new File(tempFolder));
								FileUtils.deleteDirectory(new File(request.getSession().getServletContext().getRealPath("") + "/uploads/filemaintenance/general/signatoryNames/temp/"));
								log.info("Temporary folders deleted.");
								
								params.put("signatoryId", request.getParameter("signatoryId"));
			                    params.put("userId", USER.getUserId());
			                    System.out.println("==== PARAMS : " + params.toString());
			                    giisSignatoryNamesService.updateFilename(params);
			                    
			                    PAGE = "/pages/genericMessage.jsp";
								//message = "SUCCESS";
			                    fileItem.delete();
		                    }
						} 
					} 									
				} catch (Exception e) {
					message = ExceptionHandler.handleException(e, USER);
				} finally {
					for (Iterator i = items.iterator(); i.hasNext();) {
						fileItem = (FileItem) i.next();
						fileItem.delete();
					}
					session.removeAttribute("LISTENER");
				}
			} 	else if ("GIISS071DeleteFilesFromServer".equals(ACTION)){
				log.info("Deleting temporary files...");
				new File(getServletContext().getRealPath("") + "/uploads/filemaintenance/general/signatoryNames/attached_picture/").mkdirs();
				FileUtils.cleanDirectory(new File(getServletContext().getRealPath("") + "\\uploads\\filemaintenance\\general\\signatoryNames\\attached_picture\\"));
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("GIISS071WriteFileToServer".equals(ACTION)){
				
				String filePath   = (String) APPLICATION_CONTEXT.getBean("uploadPath");
				filePath += "filemaintenance/general/signatoryNames/attached_picture/";
				
				String fileName = request.getParameter("fileName");	
				
				if(new File(filePath.concat(fileName)).exists()){
					new File(filePath).mkdirs();				
					List<String> files = new ArrayList<String>();				
	                files.add(filePath.concat(fileName));                
					FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
				} else {
					System.out.println("FILE NOT FOUND");
					message = "Geniisys Exception#I#The file " + filePath.concat(fileName) + " does not exist."; //marco - 12.21.2015 - SR 5013
				}
			}				
			/* end : patterned from signatory maintenance */
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}


}
