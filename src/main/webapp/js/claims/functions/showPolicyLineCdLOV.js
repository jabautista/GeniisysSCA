/** Show LOV of Policy Line Code for Claim - to use, please add your moduleid on cmp
 *  Reference By: GICLS261 - Claim Payment Module
 *  @author john dolon  
 *  @date 08.01.2013
 * */
function showPolicyLineCdLOV(moduleId, polLineCd) {
	try {
		LOV.show({
					controller : "ClaimsLOVController",
					urlParameters : {
						action : "getClaimLineLOV",
						moduleId : moduleId,
						page : 1,
						lineCd : polLineCd
					},
					title : "Line Code Listing",
					width : 405,
					height : 386,
					columnModel : [ {
						id : "lineCd",
						title : "Line Code",
						width : '100px'
					}, {
						id : "lineName",
						title : "Line Name",
						width : '290px'
					} ],
					draggable : true,
					autoSelectOneRecord : true,																	
					filterText : moduleId == "GICLS261" ? $("txtNbtLineCode").value : $("txtNbtLineCd").value , /*edited by MarkS 7.21.2016 SR5573*/
					onSelect : function(row) {
						if (moduleId == "GICLS261") {
							/* edited txtNbtLineCd as the field was change to txtNbtLineCode and is throwing a javascript error MarkS*/
							$("txtNbtLineCode").enable(); 							/*edited by MarkS 7.21.2016 SR5573 AS  */
							$("txtNbtLineCode").value = unescapeHTML2(row.lineCd); /*edited by MarkS 7.21.2016 SR5573*/
							//showPolicySublineCdLOV($("txtNbtLineCd").value,$("txtNbtSublineCd").value);
							$("txtNbtSublineCd").focus();
							enableToolbarButton('btnToolbarEnterQuery');
						} else if (moduleId == "GICLS255") {
							$("txtNbtLineCd").value = unescapeHTML2(row.lineCd);
							enableToolbarButton('btnToolbarEnterQuery');
							$("txtNbtSublineCd").focus();
						} 
						
					},
					onCancel : function() {
						if (moduleId == "GICLS261") {
							/* edited txtNbtLineCd as the field was change to txtNbtLineCode and is throwing a javascript error MarkS*/
							$("txtNbtLineCode").enable();
							$("txtNbtLineCode").focus();
							//end SR-5573
						} else if (moduleId == "GICLS255") {
							$("txtNbtLineCd").focus();
						}
					},
					onUndefinedRow : function() {
						/* edited txtNbtLineCd as the field was change to txtNbtLineCode and is throwing a javascript error MarkS*/
						customShowMessageBox("No record selected.",
								imgMessage.INFO, moduleId == "GICLS261" ? "txtNbtLineCode": "txtNbtLineCd");
						moduleId == "GICLS261" ? $("txtNbtLineCode").enable() : $("txtNbtLineCd").enable();
						//end SR-5573
					}
				});
	} catch (e) {
		showErrorMessage("showPolicyLineCdLOV", e);
	}
}