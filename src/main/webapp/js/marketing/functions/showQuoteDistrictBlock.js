/**
 * Shows district lov (same as showDistrictBlock)
 * @author emsy
 * @date 12.02.2011
 */
function showQuoteDistrictBlock(regionCd, provinceCd, cityCd, districtNo){
	try{
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISDistrictBlockLOV",
				regionCd : regionCd,
				provinceCd : provinceCd,
				cityCd : cityCd,
				districtNo : districtNo,
				page : 1
			},
			title: "List of District and Block",
			width: 660,
			height: 320,
			columnModel : [	{	id : "districtNo",
								title: "District No.",
								width: '80px'
							},
							{	id : "districtDesc",
								title: "Description",
								width: '200px'
							},
							{	id : "blockNo",
								title: "Block No.",
								width: '80px'
							},
							{	id : "blockDesc",
								title: "Description",
								width: '260px'
							}
						],
			draggable: true,
			onSelect: function(row){
				$("region").value			= row.regionCd;
				$("provinceCd").value		= row.provinceCd;	
				$("province").value			= unescapeHTML2(row.province);	//Gzelle 05222015 SR4112
				$("cityCd").value			= row.cityCd;
				$("city").value				= unescapeHTML2(row.city);	//Gzelle 05222015 SR4112
				$("district").value 		= unescapeHTML2(row.districtDesc); //robert 05.30.2012
				$("districtNo").value 		= row.districtNo;
				$("blockNo").value 			= row.blockNo; //robert 05.30.2012
				$("block").value 			= unescapeHTML2(row.blockDesc); //robert 05.30.2012
				$("blockId").value 			= row.blockId;
				$("eqZone").value 			= row.eqZone;
				$("eqZoneDesc").value 		= unescapeHTML2(row.eqDesc); //robert 05.30.2012
				$("typhoonZone").value 		= row.typhoonZone;
				$("typhoonZoneDesc").value 	= unescapeHTML2(row.typhoonZoneDesc); //robert 05.30.2012
				$("floodZone").value 		= row.floodZone;
				$("floodZoneDesc").value 	= unescapeHTML2(row.floodZoneDesc); //robert 05.30.2012
			}
		});
	}catch(e){
		showErrorMessage("showDistrictBlock", e);
	}
}