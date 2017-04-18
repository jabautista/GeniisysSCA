/**
 * Shows city lov
 * @author andrew
 * @date 04.25.2011
 */
function showQuoteCityLOV(){
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIISCityLOV",
						provinceCd : $F("provinceCd"),
						regionCd : $F("region"), // ~ emsy 12.02.2011
						page : 1},
		title: "City",
		width: 460,
		height: 350,
		columnModel : [
						{
							id : "cityCd",
							title: "",
							width: '0',
							visible: false
						},
						{
							id : "city",
							title: "City",
							width: ($F("province").trim() != "" ? '210px' : '420px')
						},
						{
							id : "provinceCd",
							title: "",
							width: '0',
							visible: false
						},
						{
							id : "provinceDesc",
							title: "Province",
							width: ($F("province").trim() != "" ? '210px' : '0'),
							visible: ($F("province").trim() != "" ? true : false)
						}
					],
		draggable: true,
	/* ~ emsy 12.02.2011
	 * onOk: function(row){
			$("cityCd").value = row.cityCd;
			$("city").value = row.city;
		},
		onRowDoubleClick: function(row){
			$("cityCd").value = row.cityCd;
			$("city").value = row.city;
		}
	  });
	*/
		onSelect: function(row){
			$("region").value		= row.regionCd;
			$("provinceCd").value	= row.provinceCd;
			$("province").value		= unescapeHTML2(row.provinceDesc); //robert 05.30.2012
			$("cityCd").value 		= row.cityCd;
			$("city").value 		= unescapeHTML2(row.city); //robert 05.30.2012
		}
	  });
}