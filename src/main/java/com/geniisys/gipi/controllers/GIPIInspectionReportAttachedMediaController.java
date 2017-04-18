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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIInspReportAttachMedia;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.service.GIPIInspDataService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIInspectionReportAttachedMediaController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			FileEntityService fileService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
			GIPIInspDataService inspDataService = (GIPIInspDataService) APPLICATION_CONTEXT.getBean("gipiInspDataService");
			PAGE = "/pages/genericMessage.jsp";
			String uploadMode = request.getParameter("uploadMode");
			String category   = "";
			
			int genericId 	  = Integer.parseInt((request.getParameter("genericId") == null ? "0" : request.getParameter("genericId"))); 
			int itemNo 		  = Integer.parseInt((request.getParameter("itemNo") == null ? "0" : request.getParameter("itemNo")));	
			
			if ("saveInspectionAttachments".equals(ACTION)){
				inspDataService.saveInspectionAttachments(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("writeFilesToServer".equals(ACTION)){
				List<GIPIInspReportAttachMedia> attachments = (List<GIPIInspReportAttachMedia>) JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("files")), USER.getUserId(), GIPIInspReportAttachMedia.class);
				List<String> files = new ArrayList<String>();
				for(GIPIInspReportAttachMedia attach : attachments){
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
			} else if("showAttachMedia".equals(ACTION)){ 
				String slashType;
				int lastIndexOfSlash;
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("genericId", genericId);
				params.put("itemNo", itemNo);
				params.put("ACTION", ACTION);
				
				Map<String, Object> attachMedia = TableGridUtil.getTableGrid(request, params);
				JSONObject objAttachMedia = new JSONObject(attachMedia);
				JSONArray rows = objAttachMedia.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgSketchTag", rows.getJSONObject(i).getString("sketchTag").equals("Y") ? true : false);
					slashType=(rows.getJSONObject(i).getString("fileName").lastIndexOf("\\") > 0 ? "\\" : "/");
					lastIndexOfSlash=rows.getJSONObject(i).getString("fileName").lastIndexOf(slashType);
					rows.getJSONObject(i).put("fileName2", rows.getJSONObject(i).getString("fileName").substring(lastIndexOfSlash+1));
					rows.getJSONObject(i).put("filePath", rows.getJSONObject(i).getString("fileName"));
				}
				
				objAttachMedia.remove("rows");
				objAttachMedia.put("rows", rows);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("objAttachMedia", objAttachMedia);
					PAGE = "/pages/underwriting/utilities/inspectionReport/pop-ups/attachedMedia.jsp";
				}else{
					message = objAttachMedia.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			} else if ("uploadFile".equals(ACTION)){
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
//				StringBuffer sb = new StringBuffer();
				
				List items 			= null;
				FileItem fileItem 	= null;
				String fileName 	= "";
				String saveAs 		= request.getParameter("txtFileName");
//				String remarks 		= request.getParameter("txtRemarks");
				
				String filePath   = (String) APPLICATION_CONTEXT.getBean("uploadPath");
				filePath += category+"/inspection/attachedMedia/"+genericId+"/"+itemNo;
				String uploadPath = "uploads/underwriting/inspection/attachedMedia/"+genericId+"/"+itemNo;
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
								//int lastIndexOfPeriod 	= myFullFileName.lastIndexOf(".");
			                    
			                    // Ignore the path and get the filename
			                    if (!"".equals(saveAs)) {
			                    	fileName = saveAs.replaceAll(" ", "_");
			                    } else {
			                    	fileName = myFullFileName.substring(lastIndexOfSlash+1).replaceAll(" ", "_");
			                    }
			                    
			                    // Create new File object
				                uploadedFile = new File(filePath, fileName);
				                
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    // write media to web server			                    
			                    
			                    Map<String, Object> params = new HashMap<String, Object>();
			                    params.put("fileName", fileName); //fileItem.getName()
			                    params.put("filePath", filePath);
			                    params.put("uploadPath", uploadPath);
			                    params.put("realPath", request.getSession().getServletContext().getRealPath(""));
			                    params.put("message", "SUCCESS");
			                    fileService.writeMedia(params);
			                    	                    
								JSONObject result = new JSONObject(params); 
								message = result.toString();
			                    fileItem.delete();
		                    }else{ // added to handle the upload file if the size is zero byte 
								message = fileItem.getSize()+ " byte";
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
