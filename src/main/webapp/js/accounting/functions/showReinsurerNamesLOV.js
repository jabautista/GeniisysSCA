/**
Shows list of OutFaculPremPayts Reinsurer names
* @author s. ramirez
* @date 05.17.2012
* @module GIACS019
*/
function showReinsurerNamesLOV(moduleId){ //added by steven 11.27.2014; added a parameter base on SR 3786
	//added by steven 11.27.2014 base on SR 3786
	/*var riCd = null;                          //edited by MarkS for SR-5484 
	if(nvl(moduleId,null) == "GIACS019" && objACGlobal.tranSource == "DV"){
		rows = outFaculPremPaytsTableGrid.geniisysRows;
		for ( var i = 0; i < rows.length; i++) {
			if (rows[i].recordStatus != -1) {
				riCd = rows[i].riCd;
				break;
			}
		}
	}*/ //end  SR-5484 to allow multiple binders with different reinsurers. 
	//end
	LOV.show({
		controller : "ACGeneralDisbursementsTransactionsLOVController" , //"AccountingLOVController",	// SR-19792, 19840 : shan 08.06.2015
		urlParameters : {action : "getGIISReinsurerLOV3"
						},
		title: "Reinsurer List",
		width: 470,
		height: 400,
		columnModel: [
 			{
				id : 'riCd',
				title: 'RI Code',
				width : '70px',
				align: 'right'
			},
			{
				id : 'riName',
				title: 'Reinsurer',
			    width: '350px',
			    align: 'left'
			}
		],
		draggable: true,
		autoSelectOneRecord: true,
		onSelect: function(row) {
			//if (riCd == null || riCd == row.riCd) {  //edited by MarkS for SR-5484 
				$("assuredName").clear();
				$("policyNo").clear();
				$("remarks").clear();
				$("amount").clear();
				$("faculPremLineCd").clear();
				$("faculPremBinderYY").clear();
				$("binderSeqNo").clear();
				$("hiddenRiCd").value =row.riCd;
				$("reinsurer").value = unescapeHTML2(row.riName);
			/*} else if(riCd != row.riCd) { 
				showMessageBox("Only one reinsurer is allowed.","I");
			}*/
			//end SR-5484 
		}
	});
}