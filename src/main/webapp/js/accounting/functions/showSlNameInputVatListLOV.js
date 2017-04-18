/**
Shows list of giac sl names and codes
* @author m. cadwising
* @date 03.22.2012
* @module GIACS039
*/
//added sw by reymon 10292013
function showSlNameInputVatListLOV(slTypeCd, sw){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getSlNameInputVatListsLOV",
						slTypeCd: slTypeCd},
		title: "Sl List",
		width: 455,
		height: 388,
		columnModel : [
		               {
		            	   id : "slCd",
		            	   title: "SL Code",
		            	   width: '120px',
		            	   titleAlign: 'right',
		            	   align: 'right'
		               },
		               {
		            	   id: "slName",
		            	   title: "Sl Name",
		            	   width: '319px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			if (sw == 0){
				$("hidSlCdInputVat").value = row.slCd;
				$("txtSlNameInputVat").value = unescapeHTML2(row.slName);
			}else if (sw == 1){
				$("hidVatSlCd").value = row.slCd;
				$("selVatSlCdInputVat").value = unescapeHTML2(row.slName);
			}
		}
	});
}