// generate sequence no for a particular table
// parameters
// param: name of div/divs to be counted
// seqField: field to be filled out with the generated sequence no
function generateSequence(param, seqField) {
	var itemNo = $$("div[name='"+param+"']").size();
	for(i = 1; i < itemNo+1; i++) {			
    	if($(param+i)){		 
	    	continue;   	
    	} else {
	    	$(seqField).value = i;	
    	}
    }
	$(seqField).value = itemNo+1;
}