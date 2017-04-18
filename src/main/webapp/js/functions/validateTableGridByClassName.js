/*
 * Created by	: Jerome Orio
 * Date			: December 7, 2010
 * Description 	: Validate the value based on className,
 * Parameters	: classList - list of class, space-separated string
 * 				: value - value for validation
 * 				: errorMsg - error message to be show if available
 * Return		: false if invalid else true
 */
function validateTableGridByClassName(classList, value, cmObj){
	var isValid = true;
	var list = $w(classList);
	var errorMsg = cmObj.geniisysErrorMsg || "";
	var minValue = cmObj.geniisysMinValue || "";
	var maxValue = cmObj.geniisysMaxValue || "";
	
	for (var i=0; i<list.length; i++){
		if (list[i] == "integerNoNegativeUnformattedNoComma"){
			isValid = validateIntegerNoNegativeUnformattedNoComma(value);
			if (!isValid){
				$break;
			}
		}else if (list[i] == "money"){
			value = value == undefined ? "" :value.toString().replace(/\$|\,/g,'');
			if (value.empty() || value == undefined){
		    	isValid = true;
		    	$break;
		    }else if(isNaN(value)){    
		    	isValid = false;
				$break;
		    }
		}	
	}	
	
	if(isValid){
		if (minValue != "" && value != ""){
			if (parseFloat(value.toString().replace(/\$|\,/g,'')) < parseFloat(minValue.toString().replace(/\$|\,/g,''))){
				isValid = false;
				$break;
			}	
		}	
		if (maxValue != "" && value != ""){
			if (parseFloat(value.toString().replace(/\$|\,/g,'')) > parseFloat(maxValue.toString().replace(/\$|\,/g,''))){
				isValid = false;
				$break;
			}
		}	
	}
	
	if(!isValid){
		if (errorMsg != ""){
    		showMessageBox(errorMsg, imgMessage.ERROR);
		}
	}	
	
	return isValid;
}	