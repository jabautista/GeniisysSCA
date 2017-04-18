//format currency up to 4 decimal places
//mark jm 10.17.2011 validate first the parameter before using any function
function formatRate(num)	{	
	if (num == null | num == undefined | isNaN(num)) {
		return "";
	}else if(num.toString() == ""){
		return "";
	}
	
	num = num.toString().replace(/\$|\,/g,'');
	return parseFloat(num).toFixed(4);
}