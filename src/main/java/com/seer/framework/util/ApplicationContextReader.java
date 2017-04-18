/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.codehaus.xfire.transport.http.XFireServletController;
import org.quartz.JobExecutionContext;
import org.quartz.SchedulerException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;


/**
 * The Class ApplicationContextReader.
 */
public class ApplicationContextReader {
    
    /** The logger. */
    Logger logger = Logger.getLogger("com.seer.framework.util");
//    private static String configLocations="/WEB-INF/applicationContext.xml";
    /** The config locations. */
private static String configLocations="/WEB-INF/applicationContext.xml";

    /**
     * Instantiates a new application context reader.
     */
    public ApplicationContextReader() {
    }
    
   
    /**
     * Gets the class path xml context.
     * 
     * @return the class path xml context
     */
    public static ApplicationContext getClassPathXmlContext()
    {
        ApplicationContext  ac = new ClassPathXmlApplicationContext(getConfigLocations());        
        return ac;
    }

    /**
     * Load class path xml context.
     * 
     * @param name the name
     * 
     * @return the object
     */
    public static Object loadClassPathXmlContext(String name) 
    {
        Object obj=null;
        ApplicationContext ac = getClassPathXmlContext();
        obj = ac.getBean(name);        
        return obj;
    }
    
    
    /**
     * Gets the scheduler context.
     * 
     * @param ctx the ctx
     * 
     * @return the scheduler context
     * 
     * @throws SchedulerException the scheduler exception
     */
    public static ApplicationContext getSchedulerContext(JobExecutionContext ctx) throws SchedulerException
    {        
        ApplicationContext ac = (ApplicationContext) ctx.getScheduler().getContext().get("applicationContext");        
        return ac;
    }
    
    
    /**
     * Gets the x fire context.
     * 
     * @return the x fire context
     */
    public static ApplicationContext getXFireContext()
    {
        HttpServletRequest req = XFireServletController.getRequest();       
        ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(req.getSession().getServletContext());        
        return ac;
    }

    /**
     * Gets the servlet context.
     * 
     * @param sc the sc
     * 
     * @return the servlet context
     */
    public static ApplicationContext getServletContext(ServletContext sc)
    {        
        ApplicationContext ac = WebApplicationContextUtils.getWebApplicationContext(sc);        
        return ac;
    }
    
    /**
     * Load servlet context.
     * 
     * @param sc the sc
     * @param name the name
     * 
     * @return the object
     */
    public static Object loadServletContext(ServletContext sc, String name) 
    {
        Object obj=null;
        ApplicationContext ac = getServletContext(sc);        
        obj = ac.getBean(name);        
        return obj;
    }    
    
    /**
     * Gets the config locations.
     * 
     * @return Returns the configLocations.
     */
    public static String getConfigLocations()
    {
        return configLocations;
    }

    /**
     * Sets the config locations.
     * 
     * @param configLocations The configLocations to set.
     */
    public static void setConfigLocations(String configLocations)
    {
        ApplicationContextReader.configLocations = configLocations;
    }
    
   
}
