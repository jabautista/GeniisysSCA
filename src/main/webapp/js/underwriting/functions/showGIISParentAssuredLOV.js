/**
 * Shows parent assured list
 * 
 * @author robert
 * @date 07.08.2011
 * 
 */
function showGIISParentAssuredLOV(action, onOkFunction) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : action,
				filterText: $F("parentAssdName") != $("parentAssdName").getAttribute("lastValidValue") ?
							nvl($F("parentAssdName"), "%") : "%",
				page : 1
			},
			title : "List of Parent Assured",
			width : 480,
			height : 388,
			columnModel : [ {
				id : "assdName",
				title : "Parent Assured Name",
				width : '465px'
			} ],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("parentAssdName") != $("parentAssdName").getAttribute("lastValidValue") ?
						nvl($F("parentAssdName"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect: function(row){
				if(row != undefined) {
					onOkFunction(row);
				}
			},
			onCancel: function(){
				$("parentAssdName").value = $("parentAssdName").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("parentAssdName").value = $("parentAssdName").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	} catch (e) {
		showErrorMessage("showGIISParentAssuredLOV", e);
	}
}