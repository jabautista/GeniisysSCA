/**
Shows list of SL
* @author s. ramirez
* @date 06.11.2012
* @module GIACS022
*/
function showSlListingByWhtaxIdLOV(whtaxId){
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {action : "getSlListingByWhtaxIdLOV",
						 whtaxId:whtaxId
						},
		title: "SL Listing",
		width: 480,
		height: 380,
		columnModel: [
 			{
				id : 'slCd',
				title: 'SL Code',
				width : '50px',
				align: 'right'
			},
			{
				id : 'slName',
				title: 'SL Name',
			    width: '315px',
			    align: 'left'
			},
			{
				id : 'slTypeCd',
				title: 'SL Type Code',
				width : '80px',
				align: 'left'
			}
		],
		draggable: true,
		onSelect: function(row) {
			$("txtSlCd").value 		= row.slCd;
			$("txtSlName").value 	= unescapeHTML2(row.slName);
			$("txtSlTypeCd").value 	= row.slTypeCd;
		}
	});
}