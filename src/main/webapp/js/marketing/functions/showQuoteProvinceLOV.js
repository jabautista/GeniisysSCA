/**
 * Shows province lov
 * @author andrew
 * @date 04.20.2011
 */
function showQuoteProvinceLOV(){
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIISProvinceLOV", 
						page : 1},
		title: "Province",
		width: 458,
		height: 350,
		columnModel : [
						{
							id : "provinceCd",
							title: "Code",
							width: '0',
							visible: false
						},
						{
							id : "provinceDesc",
							title: "Province",
							width: '420px'
						}
					],
		draggable: true,
		/* ~ emsy 12.02.2011
		 onOk: function(row){
			selectQuoteProvince(row);
		},
		onRowDoubleClick: function(row){
			selectQuoteProvince(row);
		}
	  	});
	  */
		onSelect: function(row){
			selectProvince(row);
		}
	  });
}