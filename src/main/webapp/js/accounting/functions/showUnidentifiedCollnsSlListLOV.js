/**
* SL List
* @author Christian Santos
* @date 05.03.2012
* @module GIACS014
*/
function showUnidentifiedCollnsSlListLOV(slTypeCd, fundCd) {
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getSlListUnidentifiedCollnsLOV",
						slTypeCd: slTypeCd,
						fundCd: fundCd},
		title: "Sl List",
		width: 460,
		height: 300,
		columnModel : [
		               {
		            	   id : "slCd",
		            	   title: "Sl Code",
		            	   width: '100px'
		               },
		               {
		            	   id: "slName",
		            	   title: "Sl Name",
		            	   width: '435px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			$("ucSlName").value = row.slName;
			$("ucHiddenSlCd").value = row.slCd;		
		}
	});
}