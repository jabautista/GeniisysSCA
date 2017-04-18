package com.geniisys.event.listeners;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.ContextParameters;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

public class ContextListener implements ServletContextListener {
	public static boolean isConnectedToDatabase = true;
	Logger logger = Logger.getLogger(ContextListener.class);
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
				
	}

	@Override
	public void contextInitialized(ServletContextEvent servletContextEvent) {
		System.out.println("Context Initialized...");
		//GIISParameterFacadeService paramService = new GIISParameterFacadeServiceImpl();
		try {
			ApplicationContext appContext = ApplicationContextReader.getServletContext(servletContextEvent.getServletContext());
			GIISParameterFacadeService paramService = (GIISParameterFacadeService) appContext.getBean("giisParameterFacadeService");
			Map<String, Object> contextParams = paramService.getContextParameters();
			ContextParameters.setContextParameters(contextParams);
			String realPath = servletContextEvent.getServletContext().getRealPath("images/banner/");
			copyBanner(realPath, ContextParameters.CLIENT_BANNER);
			String path = servletContextEvent.getServletContext().getRealPath("");
			loadJsFunctions(path);
		} catch (SQLException e) {
			if(e.getErrorCode() == 17002) {
				logger.error("Database connection failed. The Network Adapter could not establish the connection.");
				isConnectedToDatabase = false;
			} else if(e.getMessage().contains("Listener refused the connection")){
				isConnectedToDatabase = false;
				logger.error(ExceptionHandler.extractSqlExceptionMessage(e));				
			} else {
				isConnectedToDatabase = false;
				ExceptionHandler.logException(e);
			}
		} catch (IOException e) {
			ExceptionHandler.logException(e);
		}
	}
	
	private void copyBanner(String realPath, String file) throws IOException{
		File newFile = null;
		FileInputStream fis = null;
		FileOutputStream os = null;
		try {
			if(new File(file).isFile()){			
				byte[] fileByte = null;
				try {				
					fis = new FileInputStream(file);
					fileByte = new byte[fis.available()];
					fis.read(fileByte);
				} catch (IOException e) {
					throw e;
				}
	
				String slashType = (file.lastIndexOf("\\") > 0) ? "\\" : "/"; // Windows or UNIX
				int startIndex = file.lastIndexOf(slashType);
				String fileName = file.substring(startIndex + 1);
				
				File dir = new File(realPath); 
				
				if(dir.isDirectory()){
					dir.delete();
				}
				
				dir.mkdirs();
				
				String filePath = realPath + "/" + fileName;
				newFile = new File(filePath);
				System.out.println("Writing banner image to: " + newFile.getPath());
	
				os = new FileOutputStream(newFile);
				os.write(fileByte);
				os.flush();
				
				ContextParameters.CLIENT_BANNER = fileName;
			}
		} finally {
			if(fis != null) {
				fis.close();
			}
			if(os != null){
				os.close();
			}
		}
	}
	
	private void loadJsFunctions(String path){
		File uw = new File(path+"/js/underwriting/functions/");
		File ac = new File(path+"/js/accounting/functions/");
		File cl = new File(path+"/js/claims/functions/");
		File head = new File(path+"/js/loadFunctions.js");
		File cm = new File(path+"/js/functions/");
		File mk = new File(path+"/js/marketing/functions/");
		File sc = new File(path+"/js/security/functions/");
		File wf = new File(path+"/js/workflow/functions/");
		File[] uwFunctions = null;
		File[] acFunctions = null;
		File[] clFunctions = null;
		File[] cmFunctions = null;
		File[] mkFunctions = null;
		File[] scFunctions = null;
		File[] wfFunctions = null;
		
		if (uw.isDirectory()){
			uwFunctions = uw.listFiles();
		}
		if (ac.isDirectory()){
			acFunctions = ac.listFiles();
		}
		if (cl.isDirectory()){
			clFunctions = cl.listFiles();
		}
		if (cm.isDirectory()){
			cmFunctions = cm.listFiles();
		}
		if (mk.isDirectory()){
			mkFunctions = mk.listFiles();
		}
		if (sc.isDirectory()){
			scFunctions = sc.listFiles();
		}
		if (wf.isDirectory()){
			wfFunctions = wf.listFiles();
		}
		
		try{
		    new FileOutputStream(head).close();
		}catch (IOException e) {
		    ExceptionHandler.logException(e);
		}
		
		PrintWriter out = null;
		
		try {
			out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
		    out.println("function loadScript(url) {"
		    		+ " var element = document.getElementById('loadFunctionsHere');"
		    		+ " var script = document.createElement('script');"
		    		+ " script.type = 'text/javascript'; script.src = url;"
		    		+ " element.appendChild(script);}");
		}catch (IOException e) {
		    ExceptionHandler.logException(e);
		} finally {
			if(out != null){
				out.close();	
			}			
		}
		
		if(cmFunctions != null){
			for(int i=0; i<cmFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
				    out.println("loadScript(contextPath+'/js/functions/"+cmFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}
		
		if(mkFunctions != null){
			for(int i=0; i<mkFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
				    out.println("loadScript(contextPath+'/js/marketing/functions/"+mkFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}
		
		if(uwFunctions != null){
			for(int i=0; i<uwFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
				    out.println("loadScript(contextPath+'/js/underwriting/functions/"+uwFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}
		
		if(acFunctions != null){
			for(int i=0; i<acFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
					out.println("loadScript(contextPath+'/js/accounting/functions/"+acFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}

		if(clFunctions != null){
			for(int i=0; i<clFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
					out.println("loadScript(contextPath+'/js/claims/functions/"+clFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}
		
		if(scFunctions != null){
			for(int i=0; i<scFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
				    out.println("loadScript(contextPath+'/js/security/functions/"+scFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}
		
		if(wfFunctions != null){
			for(int i=0; i<wfFunctions.length; i++){
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(head, true)));
				    out.println("loadScript(contextPath+'/js/workflow/functions/"+wfFunctions[i].getName()+"')");
				}catch (IOException e) {
				    ExceptionHandler.logException(e);
				} finally {
					if(out != null){
						out.close();	
					}
				}
			}
		}
	}
}
