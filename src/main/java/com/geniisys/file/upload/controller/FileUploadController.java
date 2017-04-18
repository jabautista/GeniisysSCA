package com.geniisys.file.upload.controller;

import java.io.File;
import java.io.IOException;
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
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.quote.entity.GIPIQuotePictures;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="UploadController", urlPatterns={"/UploadController"})
public class FileUploadController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		try{
			PAGE = "/pages/genericMessage.jsp";
			
			if ("writeFilesToServer".equals(ACTION)){
				List<GIPIQuotePictures> attachments = (List<GIPIQuotePictures>) JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("files")), USER.getUserId(), GIPIQuotePictures.class);
				List<String> files = new ArrayList<String>();
				for(GIPIQuotePictures attach : attachments){
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
		
				List<FileItem> items = null;
				FileItem fileItem = null;
				String fileName = "";
				String fileExt = request.getParameter("hidFileExt");
				String saveAs = request.getParameter("txtFileName");
								
				Integer recordId = Integer.parseInt(request.getParameter("recordId")); // NOTE : recordId could be parId, policyId, quoteId, etc.
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				String module = request.getParameter("module"); // NOTE : module could be underwriting, marketing, claims, accounting
				String subDirectory = null;
				
				if(module.equals("underwriting")){
					subDirectory = "underwriting/policy/attached_media/";
				} else if(module.equals("marketing")){
					subDirectory = "marketing/quotation/attached_media/";
				} else if(module.equals("claims")){
					subDirectory = "claims/attached_media/";
				} else if(module.equals("accounting")){
					subDirectory = "acccounting/attached_media/";
				} else {
					subDirectory = "attached_media/";
				}
								
				StringBuilder filePath = new StringBuilder((String) appContext.getBean("uploadPath"));
				filePath.append(subDirectory);
				filePath.append(recordId);
				filePath.append(itemNo);
				
				StringBuilder uploadPath = new StringBuilder("uploads/");
				uploadPath.append(subDirectory);
				uploadPath.append(recordId);
				uploadPath.append(itemNo);
				
				new File(filePath.toString()).mkdirs();

				// iterate over all uploaded files
				items = upload.parseRequest(request);
				
				try {
					for (Iterator<FileItem> i = items.iterator(); i.hasNext();) {
						fileItem = (FileItem) i.next();
						if (!fileItem.isFormField()) {
							if (fileItem.getSize() > 0) {
								// code that handle uploaded fileItem
								// don't forget to delete uploaded files after you done
								// with them! Use fileItem.delete();
								File uploadedFile = null;
			                    
			                    if (!"".equals(saveAs)) {
			                    	fileName = saveAs;//.replaceAll(" ", "_"); //remove by steven 07.30.2014 it causes an issue when file name had space on it.
			                    	if(fileExt != null){
			                    		fileName = fileName + fileExt;
			                    	}
			                    } else {
			                    	fileName =  fileItem.getName();
			                    }
			                    
			                    // Create new File object
				                //uploadedFile = new File(filePath, fileItem.getName());
				                uploadedFile = new File(filePath.toString(), fileName);
				                
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    // write media to web server			                    
			                    
			                    Map<String, Object> params = new HashMap<String, Object>();
			                    params.put("fileName",fileName); // fileItem.getName()
			                    params.put("filePath", filePath.toString());
			                    params.put("uploadPath", uploadPath.toString());
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
					for (Iterator<FileItem> i = items.iterator(); i.hasNext();) {
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
