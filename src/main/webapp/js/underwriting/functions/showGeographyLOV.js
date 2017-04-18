/**
 * calls the geographies LOV for GIPIS173
 * @author Marie Kris Felipe
 * 01.16.2013
 */
function showGeographyLOV(){
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action: "getGeographyLOV"
			},
		title: "Geographical Description",
		width: 353,
		height: 350,
		columnModel: [
		              	{	id: "geogDesc",
		              		title: "Description",
		              		width: '225px',
		              		filterOption: true,
		              		sortable: true
		              	},
		              	{	id: 'geogType',
		              		title: "Type",
		              		width: '110px',
		              		filterOption: true,
		              		sortable: true
		              	},
		              	{	id: 'geogCd', 
		              		width: '0px',
		              		visible: false
		              	}
		              ],
		draggable: true,
		/*onCancel: function() {
  			objGipis171.setToLastValidValue;
		},
		onUndefinedRow: function() {
			showMessageBox("No record selected.", imgMessage.INFO);
			objGipis171.setToLastValidValue;
		},*/
		//autoSelectOneRecord: true,
		//filterText : geogDesc,
		autoSelectOneRecord: true,
		onSelect : function(row){
			$("inputGeography").value = row.geogDesc;
			$("geogCd").value = row.geogCd;			 
		}
	});
}