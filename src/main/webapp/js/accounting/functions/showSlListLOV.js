//modified by Christian Santos 05.31.2012
function showSlListLOV(slTypeCd, moduleId) {
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getGIACSlListsLOV",
						slTypeCd: slTypeCd,
						page: 1},
		title: "Sl List",
		width: 460,
		height: 300,
		columnModel : [
		               {
		            	   id : "slCd",
		            	   title: "Sl Cd",
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
			if(moduleId == "GIACS030") {
				$("hiddenSlCd").value = row.slCd;
				$("inputSlName").value = unescapeHTML2(row.slName);
				if ($F("txtLedgerCd") != "") $("txtSlCd").value = row.slCd;		//Gzelle 11062015 KB#132 AP/AR ENH
			}
		}
	});
}