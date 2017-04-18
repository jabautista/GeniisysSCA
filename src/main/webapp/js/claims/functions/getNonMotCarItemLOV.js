/**
 * Shows Non Motor Car Item LOV
 * @author robert
 * @date 12.13.2011
 */
function getNonMotCarItemLOV(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getNonMotCarItemLOV", 
						lineCd : lineCd,
						sublineCd: sublineCd,
						issCd: issCd,
						issueYy: issueYy,
						polSeqNo: polSeqNo,
						renewNo: renewNo,
						page : 1},
		title: "Item",
		width: 350,
		height: 300,
		columnModel : [	
		               	{	id : "itemNo",
							title: "Item No",
							width: '100px',
							titleAlign: 'right',
							align: 'right',
							renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
							}
						} ,
						{	id : "itemTitle",
							title: "Item Title",
							width: '235px'
						} 
					],
		draggable: true,
		onSelect: function(row){
			$("txtItemNo").value = formatNumberDigits(row.itemNo,5);
			$("txtItemTitle").value = unescapeHTML2(row.itemTitle);
			enableButton("btnActivate");
		},
  		onCancel: function(){
			$("txtItemNo").focus();
  		}
	  });
}