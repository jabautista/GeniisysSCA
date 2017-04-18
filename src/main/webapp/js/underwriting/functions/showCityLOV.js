/**
 * Shows city lov
 * 
 * @author andrew
 * @date 04.25.2011
 */
function showCityLOV() {
	LOV.show({
		controller : "UWPolicyIssuanceLOVController",
		urlParameters : {
			action : "getGIISCityLOV",
			provinceCd : escapeHTML2($F("provinceCd")),
			regionCd : $F("region"),
			page : 1
		},
		title : "City",
		width : 460,
		height : 350,
		columnModel : [ {
			id : "cityCd",
			title : "",
			width : '0',
			visible : false
		}, {
			id : "city",
			title : "City",
			width : ($F("province").trim() != "" ? '210px' : '420px')
		}, {
			id : "provinceCd",
			title : "",
			width : '0',
			visible : false
		}, {
			id : "provinceDesc",
			title : "Province",
			width : ($F("province").trim() != "" ? '210px' : '0'),
			visible : ($F("province").trim() != "" ? true : false)
		} ],
		draggable : true,
		onSelect : function(row) {
			$("region").value = row.regionCd;
			$("provinceCd").value = unescapeHTML2(row.provinceCd); // edited by Gab Ramos 07.15.15
			$("province").value = unescapeHTML2(row.provinceDesc);
			$("cityCd").value = unescapeHTML2(row.cityCd);  //jeffdojello 01.28.2014
			$("city").value = unescapeHTML2(row.city);
			$("district").clear(); // bonok :: 9.11.2015 :: UCPB SR 20302
			$("block").clear(); // bonok :: 9.11.2015 :: UCPB SR 20302
		}
	});
}