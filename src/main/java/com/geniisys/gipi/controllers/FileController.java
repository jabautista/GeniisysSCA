/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

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
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.UploadModeException;
import com.geniisys.common.listeners.FileUploadListener;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.entity.FileEntity;
import com.geniisys.gipi.service.FileEntityService;
import com.geniisys.gipi.util.FileUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class FileController.
 */
public class FileController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6613664714368907619L;
	private static Logger log = Logger.getLogger(FileController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			FileEntityService fileService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
			PAGE = "/pages/genericMessage.jsp";
			
			int genericId 	  = Integer.parseInt((request.getParameter("genericId") == null ? "0" : request.getParameter("genericId"))); 
			int itemNo 		  = Integer.parseInt((request.getParameter("itemNo") == null ? "0" : request.getParameter("itemNo")));			
			String filePath   = (String) APPLICATION_CONTEXT.getBean("uploadPath");
			String uploadMode = request.getParameter("uploadMode");
			String category   = "";

			if("par".equals(uploadMode)     || 
			   "policy".equals(uploadMode)	|| 
			   "extract".equals(uploadMode) ||
			   "inspection".equals(uploadMode)) {
				category = "underwriting";
			} else if ("quotation".equals(uploadMode)){
				category = "marketing";
			} else if ("clmItemInfo".equals(uploadMode)){
				category = "claims";
			}
			
			if("showAttachMediaPage".equals(ACTION)){
				List<FileEntity> media = null;
				
				media = fileService.getFiles(genericId, itemNo, uploadMode);
				request = fileService.writeMedia(request, media);

				request.setAttribute("mode", uploadMode);
				PAGE = "/pages/pop-ups/attachedMedia.jsp";
			} else if ("showAttachMediaPage2".equals(ACTION)) {
				// this function is for getting attachment table grid
				
				GIISParameterFacadeService giisParameters = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				Integer maxFileSizeInMB = giisParameters.getParamValueN("ATTACH_FILE_SIZE");
				Integer maxPathSizeInMB = giisParameters.getParamValueN("ATTACH_PATH_SIZE");
				
				request.setAttribute("maxFileSizeInMB", maxFileSizeInMB);
				request.setAttribute("maxPathSizeInMB", maxPathSizeInMB);
				request.setAttribute("uploadMode", uploadMode);
				request.setAttribute("genericId", genericId);
				request.setAttribute("itemNo", itemNo);
				
				FileEntityService fileEntityService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
				request.setAttribute("attachmentTotalSize", fileEntityService.getAttachmentTotalSize(uploadMode, genericId, itemNo));
				
				JSONObject attachmentsJSON = fileEntityService.getAttachments(request);
				
				if (request.getParameter("refresh") == null) {
					request.setAttribute("attachmentsJSON", attachmentsJSON);
					PAGE = "/pages/pop-ups/attachedMedia2.jsp";
				} else {
					message = attachmentsJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("viewAttachMediaPage".equals(ACTION)){
				List<FileEntity> media = null;
				
				media = fileService.getFiles(genericId, itemNo, uploadMode);
				request = fileService.writeMedia(request, media);

				request.setAttribute("mode", uploadMode);
				PAGE = "/pages/pop-ups/viewAttachedMedia.jsp";
			}else if("uploadFile".equals(ACTION)){
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
				String saveAs 		= request.getParameter("saveAs");
				String remarks 		= request.getParameter("remarks");
				
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");				
				
				if ("par".equals(uploadMode) || "policy".equals(uploadMode)) { // for underwriting
					filePath = giisParameterService.getParamValueV2("MEDIA_PATH_UW").replaceAll("\\\\", "/") + "/" + request.getParameter("lineCd") + "/" + request.getParameter("genericNo") + "/" + request.getParameter("itemNo");
				} else if ("clmItemInfo".equals(uploadMode)) { // for claims
					filePath = giisParameterService.getParamValueV2("MEDIA_PATH_CLM").replaceAll("\\\\", "/") + "/" + request.getParameter("lineCd") + "/" + request.getParameter("genericNo") + "/" + request.getParameter("itemNo");
				} else if ("quotation".equals(uploadMode) || "packQuotation".equals(uploadMode)) {
					filePath = giisParameterService.getParamValueV2("MEDIA_PATH_MK").replaceAll("\\\\", "/") + "/" + request.getParameter("lineCd") + "/" + request.getParameter("genericNo") + "/" + request.getParameter("itemNo"); 
				} else if ("inspection".equals(uploadMode)) {
					filePath = giisParameterService.getParamValueV2("MEDIA_PATH_INSP").replaceAll("\\\\", "/") + "/" + request.getParameter("genericId") + "/" + request.getParameter("itemNo");
				} else {
					throw new UploadModeException("Invalid uploadMode: " + uploadMode);
				}
				
				new File(filePath).mkdirs();
				
				//File file = new File(filePath);

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
			                    
			                    // Ignore the path and get the filename
			                    if (!"".equals(saveAs)) {
			                    	//fileName = saveAs.replaceAll(" ", "_") +"."+ myFullFileName.substring(lastIndexOfPeriod+1);  //removed by Halley 10.18.13
			                    	fileName = saveAs;  //Halley 10.18.13
			                    } else {
			                    	fileName = myFullFileName.substring(lastIndexOfSlash+1).replaceAll(" ", "_");
			                    }
			                    
				                // Create new File object
				                uploadedFile = new File(filePath, fileName);
			
			                    // Write the uploaded file to the system
			                    fileItem.write(uploadedFile);
			                    
			                    // write media to web server
			                    fileService.writeMedia(request, filePath+"/"+fileName, genericId);
			                
			                    String fileExtension = myFullFileName.substring(lastIndexOfPeriod+1);
			                    
			                    sb.append(filePath+"/"+fileName+"----"+fileName+"----"+fileExtension+"----"+listener.getBytesRead()+"----"+StringFormatter.replaceTildes(StringFormatter.replaceQuotes(remarks))+"----"+genericId+"----"+"SUCCESS"); 
			                    fileItem.delete();
		                    }
						}
					}
					message = sb.toString();
				} catch (Exception e) {
					message = ExceptionHandler.handleException(e, USER);
					PAGE = "/pages/genericMessage.jsp";
				} finally {
					for (Iterator i = items.iterator(); i.hasNext();) {
						fileItem = (FileItem) i.next();
						fileItem.delete();
					}
					session.removeAttribute("LISTENER");
				}
			} else if ("saveFiles".equals(ACTION)) {
				String[] fileNames 		= request.getParameterValues("hidFileName");
				String[] remarks		= request.getParameterValues("hidRemarks");
				String[] fileTypes		= request.getParameterValues("hidFileType");
				String[] fileExts		= request.getParameterValues("hidFileExt");
				String[] filePaths		= request.getParameterValues("hidFilePath");
				String[] polFileNames	= request.getParameterValues("hidPolFileName");
				String[] arcExtDatas	= request.getParameterValues("hidArcExtData");
							
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("fileNames", fileNames);
				params.put("remarks", remarks);
				params.put("fileTypes", fileTypes);
				params.put("fileExts", fileExts);
				params.put("filePaths", filePaths);
				params.put("polFileNames", polFileNames);
				params.put("arcExtDatas", arcExtDatas);
				params.put("id", genericId);
				params.put("itemNo", itemNo);
				params.put("userId", USER.getUserId());
				
				fileService.saveFiles(params, uploadMode);
				message = "SUCCESS";
			} else if ("saveAttachments".equals(ACTION)) { /* SR-5494 JET OCT-11-2016 */
				fileService.saveAttachments(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("writeFileToServer".equals(ACTION)) {
				List<String> files = new ArrayList<String>();
				files.add(request.getParameter("filePath"));
				
				FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("deleteFilesFromServer".equals(ACTION)) {
				File dir = new File(request.getSession().getServletContext().getRealPath("")+"/"+genericId);
				File[] files = dir.listFiles();

				if (files != null)	{
					for (File file: files) {
						file.delete();
					}
				}
				
				dir.delete();
			} else if ("deleteUpload".equals(ACTION)) {
				String[] delFileNames 	= request.getParameterValues("delFileName");
				
				if(delFileNames != null){
					filePath += category+"/"+uploadMode+"/attachedMedia/"+genericId+"/"+itemNo;
					fileService.deleteFilesFromDisk(filePath, delFileNames);
				}
			} else if ("checkFileSize".equals(ACTION)) { //marco - SR 21674 - 04.04.2016
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				Integer maxFileSizeInMB = giisParameterService.getParamValueN("ATTACH_FILE_SIZE");
				Double fileSize = Double.parseDouble(request.getParameter("fileSize"));
				Double maxFileSizeInBytes = (double) ((maxFileSizeInMB * 1024) * 1024);
				
				message = "SUCCESS";
				if(fileSize > maxFileSizeInBytes){
					message = "Geniisys Exception#E#Upload limit is only " + maxFileSizeInMB + " MB per file.";
				}
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getFileSize".equals(ACTION)) { /* SR-21674 JET SEPT-23-2016 */
				String fileFullPath = request.getParameter("fileFullPath");
				Integer fileSizeInBytes = 0;
				
				FileEntityService fileEntityService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
				
				fileSizeInBytes = fileEntityService.getFileSize(fileFullPath);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fileFullPath", fileFullPath);
				params.put("fileSizeInBytes", fileSizeInBytes);
				
				JSONObject jsonObject = new JSONObject(params);
				request.setAttribute("object", jsonObject);

				message = "SUCCESS";
				PAGE = "/pages/genericObject.jsp";
			} else if ("isFileExists".equals(ACTION)) { /* SR-5494 JET SEPT-26-2016 */
				String fileFullPath = request.getParameter("fileFullPath");
				boolean isFileExists = false;
				
				FileEntityService fileEntityService = (FileEntityService) APPLICATION_CONTEXT.getBean("fileEntityService");
				
				isFileExists = fileEntityService.isFileExists(fileFullPath);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fileFullPath", fileFullPath);
				params.put("isFileExists", isFileExists);
				
				JSONObject jsonObject = new JSONObject(params);
				request.setAttribute("object", jsonObject);
				
				message = "SUCCESS";
				PAGE = "/pages/genericObject.jsp";
			} else if ("cancelAttachments".equals(ACTION)) {
				List<Map<String, Object>> tempAttachments = JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("tempAttachments")));
				List<String> files = new ArrayList<String>();
				
				for (Map<String, Object> tempAttachment : tempAttachments) {
					files.add(tempAttachment.get("path").toString());
				}
				
				FileUtil.deleteFiles(files);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getAllowedFileExt".equals(ACTION)) {
				GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				message = giisParameterFacadeService.getParamValueV2("ALLOWED_FILE_EXT");
				PAGE = "/pages/genericMessage.jsp";
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
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
