/**
 * Shows Carrier/Conveyance list
 * @author Patrick Cruz
 * @date 02.24.2012
 */
function getCarrierVesselLOV(lineCd, notIn){
	try{
		LOV.show({
			controller : "MarketingLOVController",
			urlContent : true,
			urlParameters : {
				action : "getGIISVesselLOV",
				lineCd : lineCd,
				notIn : notIn,
				page : 1
			},
			title : "Valid values for Carrier",
			width : 500,
			height : 400,
			draggable : true,
			columnModel : [
			               {
			            	   id : "vesselName",
			            	   title : "Carrier",
			            	   width : "230px"
			               },
			               {
			            	   id : "vesselType",
			            	   title : "Vessel Type",
			            	   width : "80px"
			               },
			               {
			            	   id : "motorNo",
			            	   title : "Motor No",
			            	   width : "100px"
			               },
			               {
			            	   id : "plateNo",
			            	   title : "Plate No",
			            	   width : "70px"
			               }
			               ],
			               onSelect : function(row){
								if(row != undefined) {
									/*$("inputVesselDisplay").value = unescapeHTML2(row.vesselName);
									$("inputVesselFlag").value = unescapeHTML2(row.vesselType);
									$("hidVesselCd").value = unescapeHTML2(row.vesselCd);
									$("hidVesselName").value = unescapeHTML2(row.vesselName);
									$("hidVesselFlag").value = unescapeHTML2(row.vesselFlag);
									$("hidVesselType").value = unescapeHTML2(row.vesselType);*/									
									/*$("vesselType").value = unescapeHTML2(row.vesselType);
									$("motorNo").value = unescapeHTML2(row.motorNo);
									$("plateNo").value = unescapeHTML2(row.plateNo);*/
									$("inputVessel").value = unescapeHTML2(row.vesselName);//reymon 02182013 added unescapehtml
									$("hidVesFlag").value = unescapeHTML2(row.vesselFlag);
									$("inputVessel").setAttribute("vesselCd", row.vesselCd);
									$("inputVesselFlag").value = unescapeHTML2(row.vesselType);
								}
			               }
		});
	} catch(e){
		showErrorMessage("getCarrierVesselLOV",e);
	}
}