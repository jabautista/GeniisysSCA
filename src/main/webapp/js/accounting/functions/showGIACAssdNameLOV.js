/**
Shows list of Assured Names for GIAC Premium Deposit
* @author emsy bolaños
* @date 06.11.2012
* @module GIACS026
*/
function showGIACAssdNameLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action   : "getGiacAssdNameLOV",
				moduleId : "GIACS026",
					page : 1
			},
			title: "Search Assured Name",
			width: 470,
			height: 400,
			columnModel: [
	 			{
					id : 'assdNo',
					title: 'Assured No',
					width : '85px',
					align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'assuredName',
					title: 'Assured Name',
				    width: '335px',
				    align: 'left'
				}
			],
			draggable: true,
			onSelect: function(row) {
				if(row != undefined){
					if(objSOA.prevParams != null && objSOA.prevParams.viewType == "A"){ // condition added by Kris 05.08.2013
						$("txtAssdNo").value = row.assdNo;
						$("txtDrvAssuredName").value =  unescapeHTML2(row.assdNo + " - " +  row.assuredName); 
						$("txtAssuredName").value = unescapeHTML2(row.assuredName); 
						disableToolbarButton("btnToolbarEnterQuery");
						objSOA.prevParams.intmOrAssdNo = row.assdNo;
					} else {
						$("txtAssdNo").value = row.assdNo;
						$("txtDrvAssuredName").value =  unescapeHTML2(row.assdNo + " - " +  row.assuredName); //added by steven 12/18/2012
						$("txtAssuredName").value = unescapeHTML2(row.assuredName); //added by steven 12/18/2012
						
						$("txtLineCd").clear();
						$("txtSublineCd").clear();
						$("txtIssCd").clear();
						$("txtIssueYy").clear();
						$("txtPolSeqNo").clear();
						$("txtRenewNo").clear();
						$("txtPolicyNo").clear();
						
						$("txtParNo").clear();
						$("txtParLineCd").clear();
						$("txtParIssCd").clear();
						$("txtParYy").clear();
						$("txtParSeqNo").clear();
						$("txtQuoteSeqNo").clear();
					}	
				}
			},
			onCancel: function(){
	  			$("txtDrvAssuredName").focus();
	  		}
		});
	}catch(e){
		showErrorMessage("showGIACAssdNameLOV",e);
	}
}