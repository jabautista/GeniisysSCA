// generate item no for quotation item
function generateQuoteItemNo() {
	var ele; // fills in the unoccupied numbers (ex: {1,3,4,5} -- instead of generating returning '6', it will return '2')
	var ctr = 0;
	var proceed = false;
	
	do{
		proceed = false;
		ctr++;
		ele = $("itemRow" + ctr);
		if(ele == undefined){
			proceed = true;
		}else{
			if(ele.getAttribute("name") == "rowHidden"){
				proceed = true;
			}else{
				proceed = false;
			}
		}
	}while(proceed == false);
	$("txtItemNo").value = ctr;
}