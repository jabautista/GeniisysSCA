package com.geniisys.common.controllers;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;

@WebServlet (name="PurgeLogsController", urlPatterns={"/PurgeLogsController"})
public class PurgeLogsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5009655964945746809L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			if("showPurgeLogsPage".equals(ACTION)){
				File dir = new File("C:/GENIISYS_WEB/LOGS/");
				File[] files = dir.listFiles();
				File latest = files[files.length-1];
				File oldest = files[1];
				System.out.println("latest : " + latest.getName().substring(latest.getName().lastIndexOf(".")+1, latest.getName().length()));
				System.out.println("oldest : " + oldest.getName().substring(oldest.getName().lastIndexOf(".")+1, oldest.getName().length()));
				
				SimpleDateFormat parser = new SimpleDateFormat("yyyy-MM-dd");				
				SimpleDateFormat formatter = new SimpleDateFormat("MM-dd-yyyy");
				
				request.setAttribute("to", formatter.format(parser.parse(latest.getName().substring(latest.getName().lastIndexOf(".")+1, latest.getName().length()))));
				request.setAttribute("from", formatter.format(parser.parse(oldest.getName().substring(oldest.getName().lastIndexOf(".")+1, oldest.getName().length()))));
				/*for (final File fileEntry : dir.listFiles()) {
			        if (fileEntry.isFile()) {	            
			            System.out.println(fileEntry.getName());
			        }
			    }*/
				PAGE = "/pages/purgeLogs.jsp";
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			this.doDispatch(request, response, PAGE);
		}
	}

}
