//format currency up to 2 decimal places
function formatCurrency(num) {
    /* Comment out by Niknok 
     * 09.17.2010
     * 
    if(num ==  "99999999999999.99"){   // compensates for javascript modulo computation's limitation
    	return "99,999,999,999,999.99";
    }else if(num ==  "-99999999999999.99"){   // compensates for javascript modulo computation's limitation
    	return "-99,999,999,999,999.99";
    }
    if(isNaN(num)){    
    	num = "0";
    }
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.5000000000);
    cents = num%100;
    num = Math.floor(num/100).toString();
    if(cents<10){
    	cents = "0" + cents;
    }
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++){
    	num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
    }
    *
    */
    /*
    if(num%100 == 99.984375){
    	cents = 99;
    }
    */
    
	//replace code above by Jerome Orio
	num = num == undefined ? "" :num.toString().replace(/\$|\,/g,'').strip();
    
	if(isNaN(num)){    
    	return num = "0.00";
    }else if (num.empty() || num == undefined){
    	return "";
    }	
	
    sign  = (num == (a = Math.abs(num)));
    cents = num.toString().indexOf(".") == -1 ? "0.00" :"0"+num.toString().substr(num.toString().indexOf("."));
    var centsVal = cents*100; // modified by andrew to fix problem in rounding 0.565
    cents = Math.round(centsVal.toPrecision(2))/100; //(3))/100; changed by robert from 3 to 2 12.09.14
	num   = (num.toString().indexOf(".") == -1 ? num :num.toString().substr(0,num.toString().indexOf("."))).toString().replace(/\$|\,|\-/g,'');;
	num = cents == 1 ? Number(num)+1 :num;
	cents = cents.toString().indexOf(".") == -1 ? "00" :cents.toString().substr(cents.toString().indexOf(".")+1);
	cents = cents.length == 1 ? cents+"0" :cents;
	num = removeLeadingZero(num.toString()); // andrew - 04.01.2011 - to remove the leading zeroes
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++){
    	num = num.substring(0,num.length-(4*i+3))+','+num.substring(num.length-(4*i+3));
    }
	
	//alter num by setting its value to zero if it is empty and cents have value by MAC 12/12/2012
	if (num == "" && cents != null){
		num = "0";
	}
	
    return (((sign)?'':'-') + num + '.' + cents);
}