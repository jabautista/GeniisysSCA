/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;

import com.seer.framework.db.DBPropertyReader;
import com.seer.framework.db.DBSequenceUtil;



/**
 * The Class BaseFacade.
 */
public class BaseFacade
{
    
    /** The log. */
    protected static Logger log = Logger.getLogger(BaseFacade.class);
    
    /** The db sequence util. */
    protected DBSequenceUtil dbSequenceUtil;
    
    /** The messages. */
    private MessageSource messages;
    
    /** The db properties. */
    private DBPropertyReader dbProperties;
    
    /**
     * Instantiates a new base facade.
     */
    public BaseFacade()
    {
    }
    
    /**
     * Sets the messages.
     * 
     * @param messages the new messages
     */
    public void setMessages(MessageSource messages)
    {
        this.messages = messages;
    }
    
    /**
     * Gets the message.
     * 
     * @param key the key
     * @param args the args
     * 
     * @return the message
     */
    public String getMessage(String key, Object[] args)
    {
        if (this.messages == null)
            return "No Message Source Defined";
        String message = this.messages.getMessage(key, args, null);
        System.out.println(message);
        return message;
    }
    
    /**
     * Gets the db sequence util.
     * 
     * @return the db sequence util
     */
    public DBSequenceUtil getDbSequenceUtil()
    {
        return dbSequenceUtil;
    }
    
    /**
     * Sets the db sequence util.
     * 
     * @param dbSequenceUtil the new db sequence util
     */
    public void setDbSequenceUtil(DBSequenceUtil dbSequenceUtil)
    {
        this.dbSequenceUtil = dbSequenceUtil;
    }
    
    /**
     * Gets the db properties.
     * 
     * @return the db properties
     */
    public DBPropertyReader getDbProperties()
    {
        return dbProperties;
    }
    
    /**
     * Sets the db properties.
     * 
     * @param dbProperties the new db properties
     */
    public void setDbProperties(DBPropertyReader dbProperties)
    {
        this.dbProperties = dbProperties;
    }
    
}
