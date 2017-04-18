/**
Shows list of Reinsurer Names for GIAC Premium Deposit
* @author emsy bolaños
* @date 06.08.2012
* @module GIACS026
*/
function showGIACRiLOV(){
	try{
		LOV.show({
			controller : "AccountingLOVController",
			urlParameters : {action : "getGIISReinsurerLOV4", //change by steven 12/14/2012 from:getGIISReinsurerLOV4  to:getGIISReinsurerLOV3
							},
			title: "Reinsurer List",
			width: 470,
			height: 400,
			columnModel: [
	 			{
					id : 'riCd',
					title: 'Reinsurer No.',
					width : '85px',
					align: 'right'
				},
				{
					id : 'riName',
					title: 'Reinsurer\'s Name',
				    width: '350px',
				    align: 'left'
				}
			],
			draggable: true,
			onSelect: function(row) {
				$("txtRiCd").value = row.riCd;
				$("txtRiName").value = unescapeHTML2(row.riName);
				$("txtDrvRiName").value = unescapeHTML2(row.riCd+" - "+row.riName);
			}
		});
	}catch(e){
		showErrorMessage("showGIACRiLOV",e);
	}
}