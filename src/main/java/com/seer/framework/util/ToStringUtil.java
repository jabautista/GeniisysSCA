/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;

/**
 * Implements the <tt>toString</tt> method for some common cases.
 * 
 * <P>This class is intended only for cases where <tt>toString</tt> is used in
 * an informal manner (usually for logging and stack traces). It is especially
 * suited for <tt>public</tt> classes which model domain objects.
 * 
 * Here is an example of a return value of the {@link #getText} method :
 * <PRE>
 */

//PRIVATE //

/*
* Names of methods in the <tt>Object</tt> class which are ignored.
*/
/*
* Previous versions of this class indented the data within a block. 
* That style breaks when one object references another. The indentation
* has been removed, but this variable has been retained, since others might 
* prefer the indentation anyway.
*/
public final class ToStringUtil {

  /** Return an informal textual description of an object. <P>It is highly recommened that the caller <em>not</em> rely on details of the returned <tt>String</tt>. See class description for examples of return values.  <P><span class="highlight">WARNING</span>: If two classes have cyclic references (that is, each has a reference to the other), then infinite looping will result if <em>both</em> call this method! To avoid this problem, use <tt>getText</tt> for one of the classes, and {@link #getTextAvoidCyclicRefs} for the other class.  <P>The only items which contribute to the result are the class name, and all no-argument <tt>public</tt> methods which return a value. As well, methods defined by the <tt>Object</tt> class, and factory methods which return an <tt>Object</tt> of the native class ("<tt>getInstance</tt>" methods) do not contribute. Items are converted to a <tt>String</tt> simply by calling their <tt>toString method</tt>; the only exception is arrays, for which {@link ArrayToString} is used instead.    <P>If the method name follows the pattern <tt>getXXX</tt>, then the word 'get' is removed from the presented result. */
    
   private static final String fINDENT = "";
   
   /** The aVOI d_ circula r_ references. */
   private static final String fAVOID_CIRCULAR_REFERENCES = "[circular reference]";


   /** The sTAR t_ char. */
   private static final String fSTART_CHAR = "[";
   
   /** The eN d_ char. */
   private static final String fEND_CHAR = "]";
   
   /** The sEPARATOR. */
   private static final String fSEPARATOR = ", ";
   
   /** The nULL. */
   private static final String fNULL = "null";
   
   /** The gE t_ class. */
   private static final String fGET_CLASS = "getClass";
   
   /** The cLONE. */
   private static final String fCLONE = "clone";
   
   /** The hAS h_ code. */
   private static final String fHASH_CODE = "hashCode";
   
   /** The t o_ string. */
   private static final String fTO_STRING = "toString";

   /** The gET. */
   private static final String fGET = "get";
   
   /** The n o_ args. */
   private static final Object[] fNO_ARGS = new Object[0];
   
   /** The n o_ params. */
   @SuppressWarnings({ "rawtypes" })
private static final java.lang.Class[] fNO_PARAMS = new Class[0];
   
   /** The Constant NEW_LINE. */
   private static final String NEW_LINE = "\n";
   
   /** The Constant SEPARATOR. */
   private static final String SEPARATOR = "|";
   
   /** The log. */
   private static Logger log = Logger.getLogger(ToStringUtil.class);
    
  /**
   * Gets the text.
   * 
   * @param aObject the a object
   * 
   * @return the text
   */
  public static String getText(Object aObject) {
    return getTextAvoidCyclicRefs(aObject, null, null);
  }

  /**
   * As in {@link #getText}, but, for return values which are instances of
   * <tt>aSpecialClass</tt>, then call <tt>aMethodName</tt> instead of <tt>toString</tt>.
   * 
   * <P> If <tt>aSpecialClass</tt> and <tt>aMethodName</tt> are <tt>null</tt>, then the
   * behavior is exactly the same as calling {@link #getText}.
   * 
   * @param aObject the a object
   * @param aSpecialClass the a special class
   * @param aMethodName the a method name
   * 
   * @return the text avoid cyclic refs
   */
public static String getTextAvoidCyclicRefs(
    Object aObject, java.lang.Class aSpecialClass, 
    String aMethodName
  ) {
    StringBuffer result = new StringBuffer();
    addStartLine(aObject, result);

    List methods = Arrays.asList( aObject.getClass().getDeclaredMethods() );
    Iterator methodsIter = methods.iterator();
    while ( methodsIter.hasNext() ) {
      Method method = (Method)methodsIter.next();
      if ( isContributingMethod(method, aObject.getClass()) ){
        addLineForGetXXXMethod(aObject, method, result, aSpecialClass, aMethodName);
      }
    }

    addEndLine(result);
    return result.toString();
  }
  
  
      
  /**
   * Adds the start line.
   * 
   * @param aObject the a object
   * @param aResult the a result
   */
  private static void addStartLine(Object aObject, StringBuffer aResult){
    aResult.append( aObject.getClass().getName() );
    aResult.append(" {");
    aResult.append(NEW_LINE);
  }

  /**
   * Adds the end line.
   * 
   * @param aResult the a result
   */
  private static void addEndLine(StringBuffer aResult){
    aResult.append("}");
    aResult.append(NEW_LINE);
  }

  /**
   * Return <tt>true</tt> only if <tt>aMethod</tt> is public, takes no args,
   * returns a value whose class is not the native class, is not a method of
   * <tt>Object</tt>.
   * 
   * @param aMethod the a method
   * @param aNativeClass the a native class
   * 
   * @return true, if checks if is contributing method
   */
  @SuppressWarnings("unchecked")
private static boolean isContributingMethod(Method aMethod, java.lang.Class aNativeClass){
    boolean isPublic = Modifier.isPublic( aMethod.getModifiers() );
    boolean hasNoArguments = aMethod.getParameterTypes().length == 0;
    boolean hasReturnValue = aMethod.getReturnType() != Void.TYPE;
    boolean returnsNativeObject = aMethod.getReturnType() == aNativeClass;
    boolean isMethodOfObjectClass = 
      aMethod.getName().equals(fCLONE) || 
      aMethod.getName().equals(fGET_CLASS) || 
      aMethod.getName().equals(fHASH_CODE) || 
      aMethod.getName().equals(fTO_STRING)
   ;
    return 
      isPublic && 
      hasNoArguments && 
      hasReturnValue && 
      ! isMethodOfObjectClass && 
      ! returnsNativeObject;
  }

  /**
   * Adds the line for get xxx method.
   * 
   * @param aObject the a object
   * @param aMethod the a method
   * @param aResult the a result
   * @param aCircularRefClass the a circular ref class
   * @param aCircularRefMethodName the a circular ref method name
   */
private static void addLineForGetXXXMethod(
    Object aObject,
    Method aMethod,
    StringBuffer aResult,
    java.lang.Class aCircularRefClass, 
    String aCircularRefMethodName
  ){
    aResult.append(fINDENT);
    aResult.append( getMethodNameMinusGet(aMethod) );
    aResult.append(": ");
    Object returnValue = getMethodReturnValue(aObject, aMethod);
    if ( returnValue != null && returnValue.getClass().isArray() ) {
      aResult.append( arrayToString(returnValue) );
    }
    else {
      if (aCircularRefClass == null) {
        aResult.append( returnValue );
      }
      else {
        if (aCircularRefClass == returnValue.getClass()) {
          Method method = getMethodFromName(aCircularRefClass, aCircularRefMethodName);
          if ( isContributingMethod(method, aCircularRefClass)){
            returnValue = getMethodReturnValue(returnValue, method);
            aResult.append( returnValue );
          }
          else {
            aResult.append(fAVOID_CIRCULAR_REFERENCES);
          }
        }
      }
    }
    aResult.append( SEPARATOR );
  }

  /**
   * Gets the method name minus get.
   * 
   * @param aMethod the a method
   * 
   * @return the method name minus get
   */
  private static String getMethodNameMinusGet(Method aMethod){
    String result = aMethod.getName();
    if (result.startsWith(fGET) ) {
      result = result.substring(fGET.length());
    }
    return result;
  }

  /**
   * Return value is possibly-null.
   * 
   * @param aObject the a object
   * @param aMethod the a method
   * 
   * @return the method return value
   */
  private static Object getMethodReturnValue(Object aObject, Method aMethod){
    Object result = null;
    try {
      result = aMethod.invoke(aObject, fNO_ARGS);
    }
    catch (IllegalAccessException ex){
      vomit(aObject, aMethod);
    }
    catch (InvocationTargetException ex){
      vomit(aObject, aMethod);
    }
    return result;
  }
  
  /**
   * Gets the method from name.
   * 
   * @param aSpecialClass the a special class
   * @param aMethodName the a method name
   * 
   * @return the method from name
   */
  @SuppressWarnings("unchecked")
private static Method getMethodFromName(java.lang.Class aSpecialClass, String aMethodName){
    Method result = null;
    try {
      result = aSpecialClass.getMethod(aMethodName, fNO_PARAMS);
    }
    catch ( NoSuchMethodException ex){
      vomit(aSpecialClass, aMethodName);
    }
    return result;
  }
  

  /**
   * Vomit.
   * 
   * @param aObject the a object
   * @param aMethod the a method
   */
  private static void vomit(Object aObject, Method aMethod){
    log.fatal(
      "Cannot get return value using reflection. Class: " +
      aObject.getClass().getName() +
      " Method: " +
      aMethod.getName()
    );
  }
  
  /**
   * Vomit.
   * 
   * @param aSpecialClass the a special class
   * @param aMethodName the a method name
   */
private static void vomit(java.lang.Class aSpecialClass, String aMethodName){
    log.fatal(
      "Reflection fails to get no-arg method named: " +
      aMethodName +
      " for class: " +
      aSpecialClass.getName()
    );
  }
  
  /**
   * <code>aArray</code> is a possibly-null array whose elements are
   * primitives or objects; arrays of arrays are also valid, in which case
   * <code>aArray</code> is rendered in a nested, recursive fashion.
   * 
   * @param aArray the a array
   * 
   * @return the string
   */  
  public static String arrayToString(Object aArray){
      if ( aArray == null ) return fNULL;
      checkObjectIsArray(aArray);

      StringBuffer result = new StringBuffer( fSTART_CHAR );
      int length = Array.getLength(aArray);
      for ( int idx = 0 ; idx < length ; ++idx ) {
        Object item = Array.get(aArray, idx);
        if ( isNonNullArray(item) ){
          //recursive call!
          result.append( arrayToString(item) );
        }
        else{
          result.append( item );
        }
        if ( ! isLastItem(idx, length) ) {
          result.append(fSEPARATOR);
        }
      }
      result.append(fEND_CHAR);
      return result.toString();
    }
  

  /**
   * Check object is array.
   * 
   * @param aArray the a array
   */
  private static void checkObjectIsArray(Object aArray){
      if ( ! aArray.getClass().isArray() ) {
        throw new IllegalArgumentException("Object is not an array.");
      }
    }

    /**
     * Checks if is non null array.
     * 
     * @param aItem the a item
     * 
     * @return true, if is non null array
     */
    private static boolean isNonNullArray(Object aItem){
      return aItem != null && aItem.getClass().isArray();
    }

    /**
     * Checks if is last item.
     * 
     * @param aIdx the a idx
     * @param aLength the a length
     * 
     * @return true, if is last item
     */
    private static boolean isLastItem(int aIdx, int aLength){
      return (aIdx == aLength - 1);
    }

  /*
  * Two informal classes with cyclic references, used for testing. 
  */
  /**
   * The Class Ping.
   */
  private static final class Ping {
    
    /**
     * Sets the pong.
     * 
     * @param aPong the new pong
     */
    public void setPong(Pong aPong){fPong = aPong; }
    
    /**
     * Gets the pong.
     * 
     * @return the pong
     */
    @SuppressWarnings("unused")
	public Pong getPong(){ return fPong; }
    
    /**
     * Gets the id.
     * 
     * @return the id
     */
    @SuppressWarnings("unused")
	public Integer getId() { return new Integer(123); }
    
    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
	public String toString() {
      return getText(this);
    }
    
    /** The pong. */
    private Pong fPong;
  }
  
  /**
   * The Class Pong.
   */
  private static final class Pong {
    
    /**
     * Sets the ping.
     * 
     * @param aPing the new ping
     */
    public void setPing(Ping aPing){ fPing = aPing; }
    
    /**
     * Gets the ping.
     * 
     * @return the ping
     */
    @SuppressWarnings("unused")
	public Ping getPing() { return fPing; }
    
    /* (non-Javadoc)
     * @see java.lang.Object#toString()
     */
    @Override
	public String toString() {
      return getTextAvoidCyclicRefs(this, Ping.class, "getId");
      //to see the infinite looping, use this instead :
      //return getText(this);
    }
    
    /** The ping. */
    private Ping fPing;
  }
  
  /**
   * Informal test harness.
   * 
   * @param args the args
   */
  @SuppressWarnings({ "unused", "unchecked" })
private static void main (String[] args) {
    List list = new ArrayList();
    list.add("blah");
    list.add("blah");
    list.add("blah");
    System.out.println( ToStringUtil.getText(list) );
    
    StringTokenizer parser = new StringTokenizer("This is the end.");
    System.out.println( ToStringUtil.getText(parser) );
    
    Ping ping = new Ping();
    Pong pong = new Pong();
    ping.setPong(pong);
    pong.setPing(ping);
    System.out.println( ping );
    System.out.println( pong );
  }
}