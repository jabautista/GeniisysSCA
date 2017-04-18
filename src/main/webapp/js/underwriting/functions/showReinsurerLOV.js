/**
 * Shows reinsurer lov
 * 
 * @author darwin
 * @date 04.28.2011
 */
function showReinsurerLOV(ri, moduleId, notIn) {
	if (notIn == null || notIn == undefined)
		notIn = "";

	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIISReinsurerLOV",
			riName : ri,
			moduleId : moduleId,
			notIn : notIn,
			page : 1
		},
		title : "List of Reinsurers",
		width : 460,
		height : 350,
		columnModel : [ {
			id : "riCd",
			title : "",
			width : '0',
			visible : false
		}, {
			id : "riSname",
			title : "RI Short Name",
			width : '120px'
		}, {
			id : "riName",
			title : "RI Name",
			width : '300px'
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				if (moduleId == "GIPIS153") {
					$("inputCoInsurer").value = nvl(unescapeHTML2(row.riName),
							$F("inputCoInsurer"));
					$("selectedCoRiCd").value = nvl(row.riCd,
							$F("selectedCoRiCd"));
					$("selectedRiSname").value = nvl(
							unescapeHTML2(row.riSname), $F("selectedRiSname"));
				} else if (moduleId == "GIRIS005sname2") {
					$("riSName2").value = unescapeHTML2(nvl(row.riSname));
					$("riSName2").writeAttribute("riCd", row.riCd);
					globalRiCd = row.riCd //jmm SR-22834
					if($("riSName2").readAttribute("lastValidValue") != "" && $F("riSName2") != $("riSName2").readAttribute("lastValidValue")){
						$("btnValidateGIPIWinvoice").click();
					}
				} else if (moduleId == "GIRIS005sname1") {
					$("riSName").value = unescapeHTML2(nvl(row.riSname));
					$("riSName").writeAttribute("writerCd", row.riCd);
				} else if (moduleId == "GICLS014other") {
					$("detRiCd").value == nvl(row.riCd);
					$("detRiName").value == unescapeHTML2(nvl(row.riSname));
				}
				changeTag = 1;
			}
		}
	});
}