/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

// abstract class used by java server faces to pass parameter to a method as map key
/**
 * The Class JSFDummyMap.
 */
@SuppressWarnings("rawtypes")
public abstract class JSFDummyMap implements Map {
        
        /* (non-Javadoc)
         * @see java.util.Map#values()
         */
		public Collection values() {return null;}
        
        /* (non-Javadoc)
         * @see java.util.Map#put(java.lang.Object, java.lang.Object)
         */
        public Object put(Object key, Object value) {return null;}
        
        /* (non-Javadoc)
         * @see java.util.Map#keySet()
         */
        public Set keySet() {return null;}
        
        /* (non-Javadoc)
         * @see java.util.Map#isEmpty()
         */
        public boolean isEmpty() {return false;}
        
        /* (non-Javadoc)
         * @see java.util.Map#size()
         */
        public int size() {return 0;}
        
        /* (non-Javadoc)
         * @see java.util.Map#putAll(java.util.Map)
         */
        public void putAll(Map t) {}
        
        /* (non-Javadoc)
         * @see java.util.Map#clear()
         */
        public void clear() {}
        
        /* (non-Javadoc)
         * @see java.util.Map#containsValue(java.lang.Object)
         */
        public boolean containsValue(Object value) {return false;}
        
        /* (non-Javadoc)
         * @see java.util.Map#remove(java.lang.Object)
         */
        public Object remove(Object key) {return null;  }
        
        /* (non-Javadoc)
         * @see java.util.Map#containsKey(java.lang.Object)
         */
        public boolean containsKey(Object key) {return false;}
        
        /* (non-Javadoc)
         * @see java.util.Map#entrySet()
         */
        public Set entrySet() {return null;}

        // subclasses should override this method call their method with obj as the parameter
        /* (non-Javadoc)
         * @see java.util.Map#get(java.lang.Object)
         */
        public abstract Object get(Object obj);
}