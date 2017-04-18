/**
 * gets list of lines for posting limit maintenance
 * @author msison
 * @param userId, issCd
 * 12.21.2012
 */
function showLineLOV(userId, issCd, lineName){
	
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGiisPostingLimitLOV",
			            userId : userId,
						 issCd : issCd,
					  lineName : lineName,
						  page : 1},
		title: "Line",
		width: '380',
		height: '340',
		columnModel : [	{	id : "lineCd",
							title: "Line Code",
							width: '100px'
						},
						{	id : "lineName",
							title: "Line Name",
							width: '240px'
						}
					],
		draggable: true,
		onCancel: function() {
			if (isRecordSelected == true && objGiiss207.lineResponse == 'X' || objGiiss207.lineResponse == 'Y') {
				$("txtLineName").value = $("hidLineName").value;
			}else if (objGiiss207.lineResponse == 'X' ||objGiiss207.lineResponse == 'Y') {
				$("txtLineName").value = "";
			}
		},
		onUndefinedRow: function() {
			showMessageBox("No record selected.", imgMessage.INFO);
			if (isRecordSelected == true && objGiiss207.lineResponse == 'X' || objGiiss207.lineResponse == 'Y') {
				$("txtLineName").value = $("hidLineName").value;
			}else if (objGiiss207.lineResponse == 'X' ||objGiiss207.lineResponse == 'Y') {
				$("txtLineName").value = "";
			}				
		},
		autoSelectOneRecord: true,
		filterText:  $("txtLineName").value,
		onSelect: function(row){
			$("txtLineName").value = row.lineName;
			$("hidLineName").value = row.lineName;
			$("hidLineCd").value = row.lineCd;
			isRecordSelected = true;
		}
	});	
}