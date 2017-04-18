/**
 * @author d.alcantara 10.17.2011
 * @returns object
 */
function serializeToObject(formName) {
	try {
		var obj = new Object();
		$$('#'+formName+' input').each(function(row) {
			var name = row.getAttribute("name");
			if(row.type == "checkbox") {
				obj[name] = row.checked ? "Y" : "N";
			} else {
				
				obj[name] = row.value;
			}
		});
		
		$$('#'+formName+' textArea').each(function(row) {
			var name = row.getAttribute("name");
			obj[name] = escapeHTML2(row.value);
		});
		
		$$('#'+formName+' select').each(function(row) {
			var name = row.getAttribute("name");
			obj[name] = escapeHTML2(row.value);
		});
		
		return obj;
	} catch(e) {
		showErrorMessage("serializeToObject", e);
	}
}