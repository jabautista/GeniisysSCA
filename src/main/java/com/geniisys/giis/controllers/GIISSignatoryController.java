/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giis.controllers
	File Name: GIISSignatoryController.java
	Author: Computer Professional Inc
	Created By: Reymon
	Created Date: October 15, 2012
	Description: 
*/

package com.geniisys.giis.controllers;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISSignatoryService;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIISSignatoryController", urlPatterns="/GIISSignatoryController")
public class GIISSignatoryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8158777877198061445L;
	private static Logger log = Logger.getLogger(GIISSignatoryController.class);

	@SuppressWarnings("rawtypes")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISSignatoryService giisSignatoryService =  (GIISSignatoryService) APPLICATION_CONTEXT.getBean("GIISSignatoryService");
			if ("getReportSignatory".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS116";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> signatoryMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(signatoryMaintenance);
				
				if("1".equals(request.getParameter("ajax"))){
					params.put("ACTION", "getReportSignatoryDetails");
					Map<String, Object> signatoryDetailMaintenance = TableGridUtil.getTableGrid(request, params);
					JSONObject jsonDetail = new JSONObject(signatoryDetailMaintenance);
					Date date = new Date();
					DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
					request.setAttribute("signatoryMaintenance", json);
					request.setAttribute("signatoryDetailMaintenance", jsonDetail);
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("currDate", format.format(date));
					PAGE = "/pages/underwriting/fileMaintenance/general/signatory/signatory.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("getReportSignatoryDetails".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS116";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("reportId", request.getParameter("reportId"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				Map<String, Object> signatoryDetailMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(signatoryDetailMaintenance);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateSignatoryReport".equals(ACTION)){
				log.info("validating signatory report...");
				message = giisSignatoryService.validateSignatoryReport(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveGIISSignatory".equals(ACTION)){
				giisSignatoryService.saveGIISSignatory(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showAttachPicture".equals(ACTION)){
				request.setAttribute("signatoryId", request.getParameter("signatoryId"));
				PAGE = "/pages/underwriting/fileMaintenance/general/signatory/subPages/browsePicture.jsp";
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
				filePath += "filemaintenance/general/signatory/attached_picture/";
				String uploadPath = "filemaintenance/general/signatory/attached_picture/";
				new File(filePath).mkdirs();
				
				//pol cruz 10.24.2013
				String tempFolder = (String) APPLICATION_CONTEXT.getBean("uploadPath") + "filemaintenance/general/signatory/temp/";
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
								
								//pol cruz 10.24.2013								
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
								FileUtils.deleteDirectory(new File(request.getSession().getServletContext().getRealPath("") + "/uploads/filemaintenance/general/signatory/temp/"));
								log.info("Temporary folders deleted.");
								
								//marco - 05.24.2013 - update filename in table
			                    params.put("signatoryId", request.getParameter("signatoryId"));
			                    params.put("userId", USER.getUserId());
			                    giisSignatoryService.updateFilename(params);
			                    
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
			} else if ("GIISS116DeleteFilesFromServer".equals(ACTION)){
				log.info("Deleting temporary files...");
				new File(getServletContext().getRealPath("") + "/uploads/filemaintenance/general/signatory/attached_picture/").mkdirs();
				FileUtils.cleanDirectory(new File(getServletContext().getRealPath("") + "\\uploads\\filemaintenance\\general\\signatory\\attached_picture\\"));
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("GIISS116WriteFileToServer".equals(ACTION)){
				
				String filePath   = (String) APPLICATION_CONTEXT.getBean("uploadPath");
				filePath += "filemaintenance/general/signatory/attached_picture/";
				
				String fileName = request.getParameter("fileName");	
				
				if(new File(filePath.concat(fileName)).exists()){
					new File(filePath).mkdirs();				
					List<String> files = new ArrayList<String>();				
	                files.add(filePath.concat(fileName));                
					FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
				} else
					System.out.println("FILE NOT FOUND");
			} else if ("getGIISS116UsedSignatories".equals(ACTION)) {
				request.setAttribute("object", giisSignatoryService.getGIISS116UsedSignatories(request));
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}


}
