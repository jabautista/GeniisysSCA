/**
Shows list of Intermediary Names for GIAC Premium Deposit
* @author emsy bolaños
* @date 06.11.2012
* @module GIACS026
*/
function showGIACIntmNameLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {
				action   : "getGiacIntmNameLOV",
				moduleId : "GIACS026",
					page : 1
			},
			title: "Search Intermediary",
			width: 470,
			height: 400,
			columnModel: [
	 			{
					id : 'intmNo',
					title: 'Intermediary No.',
					width : '100px',
					align: 'right',
					titleAlign : 'right'
				},
				{
					id : 'intmName',
					title: 'Intermediary Name',
				    width: '335px',
				    align: 'left'
				}
			],
			draggable: true,
			onSelect: function(row) {
				if(row != undefined){
					if(objSOA.prevParams != null && (objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L")){ // condition added by Kris 05.08.2013
						$("txtIntmNo").value = row.intmNo;
						$("txtIntmName").value = unescapeHTML2(row.intmName); 
						$("txtDrvIntmName").value = unescapeHTML2(row.intmNo + " - " + row.intmName); 
						enableToolbarButton("btnToolbarEnterQuery");	
						objSOA.prevParams.intmOrAssdNo = row.intmNo;
					} else {
						$("txtIntmNo").value = row.intmNo;
						$("txtIntmName").value = unescapeHTML2(row.intmName); //added by steven 12/18/2012
						$("txtDrvIntmName").value = unescapeHTML2(row.intmNo + " - " + row.intmName); //added by steven 12/18/2012
					}
				}
			},
			onCancel: function(){
				if(objSOA.prevParams != null && (objSOA.prevParams.viewType == "I" || objSOA.prevParams.viewType == "L")){ // condition added by Kris 05.08.2013
					$("txtIntmNo").value = "";
					$("txtIntmName").value = ""; 
					$("txtDrvIntmName").value = ""; 
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				}
				$("txtDrvIntmName").focus();				
	  		}
		});
	}catch(e){
		showErrorMessage("showGIACIntmNameLOV",e);
	}
}