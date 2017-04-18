/**
 * Automatically builds the not in param completely
 * @param tablegrid - what tablegrid object will the notIn para will be derive from
 * @param property - property in the tablegrid needed to create the notIn
 * @author Irwin Tabisora
 */
function createCompletedNotInParam(tablegrid, property){
	try{
		var initialNotIn = tablegrid.createNotInParam(property);
		var finalNotIn = '';
		if(initialNotIn != ''){
			var tempArr = initialNotIn.split(',');
			finalNotIn = '(';
			for ( var i = 0; i < tempArr.length; i++) {
				finalNotIn = finalNotIn +"'"+tempArr[i]+"'"+( (i+1) == tempArr.length ? "" : ",");
			}
			finalNotIn = finalNotIn + ')';	
		}
		return finalNotIn;
	}catch(e){
		showErrorMessage("createCompletedNotInParam",e);
	}
}