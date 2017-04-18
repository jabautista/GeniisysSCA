package com.geniisys.gipi.controllers;

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
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.entity.GUEAttach;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.service.GUEAttachService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GUEAttachController", urlPatterns={"/GUEAttachController"})
public class GUEAttachController extends BaseController {

	private static final long serialVersionUID = -5150723025405431626L;

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		
		try {
			PAGE = "/pages/genericMessage.jsp";
			
			if("getWorkflowAttachmentList".equals(ACTION)){
				PAGE = "/pages/workflow/workflow/subPages/attachment.jsp";
			} else if ("saveGUEAttachments".equals(ACTION)){
				GUEAttachService gueAttachService = (GUEAttachService) appContext.getBean("gueAttachService");
				gueAttachService.saveGUEAttachments(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("writeFilesToServer".equals(ACTION)){
				List<GUEAttach> attachments = (List<GUEAttach>) JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("files")), USER.getUserId(), GUEAttach.class);
				List<String> files = new ArrayList<String>();
				for(GUEAttach attach : attachments){
					files.add(attach.getFilePath());
				}
				FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("deleteFileDirectoryFromServer".equals(ACTION)){
				String initialFilePath = request.getParameter("directory");				
				FileUtil.deleteFileDirectoryFromServer(getServletContext().getRealPath(""), initialFilePath);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("uploadFile".equals(ACTION)){
				FileEntityService fileService = (FileEntityService) appContext.getBean("fileEntityService");
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
				
				List items 			= null;
				FileItem fileItem 	= null;
				String fileName 	= "";
				String saveAs 		= request.getParameter("txtFileName");
				String remarks 		= request.getParameter("txtRemarks");
				
				String filePath   = (String) appContext.getBean("uploadPath");
				filePath += "workflow/attachment";
				String uploadPath = "uploads/workflow/attachment";
				new File(filePath).mkdirs();

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
								String myFullFileName = fileItem.getName();
															
								String slashType 		= (myFullFileName.lastIndexOf("\\") > 0) ? "\\" : "/";// Windows or UNIX 
								int lastIndexOfSlash 	= myFullFileName.lastIndexOf(slashType);
			                    int lastIndexOfPeriod 	= myFullFileName.lastIndexOf(".");
			                    		                    
				                // Create new File object
				                uploadedFile = new File(filePath, fileItem.getName());
			
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    // write media to web server			                    
			                    
			                    Map<String, Object> params = new HashMap<String, Object>();
			                    params.put("fileName", fileItem.getName());
			                    params.put("filePath", filePath);
			                    params.put("uploadPath", uploadPath);
			                    params.put("realPath", request.getSession().getServletContext().getRealPath(""));
			                    params.put("message", "SUCCESS");
			                    fileService.writeMedia(params);
			                    	                    
								JSONObject result = new JSONObject(params); 
								message = result.toString();
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
			} else {
				HttpSession session = null;
				FileUploadListener listener = null;
				long contentLength = 0;
				
				if (((session = request.getSession()) == null)
						|| ((listener = (FileUploadListener) session.getAttribute("LISTENER")) == null)
						|| ((contentLength = listener.getContentLength()) < 1)) {
					return;
				}
				
				long percent = ((100 * listener.getBytesRead()) / contentLength);
				message = String.valueOf(percent);
				System.out.println("Message: " + message);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (FileUploadException e) {
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
