/**
 * Shows Motor Car Item LOV
 * @author robert
 * @date 12.13.2011
 */
function getMotCarItemLOV(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo){
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getMotCarItemLOV", 
						lineCd : lineCd,
						sublineCd: sublineCd,
						issCd: issCd,
						issueYy: issueYy,
						polSeqNo: polSeqNo,
						renewNo: renewNo,
						page : 1},
		title: "Item",
		width: 405,
		height: 404,
		columnModel : [	
		               	{	id : "itemNo",
							title: "Item No",
							titleAlign: 'right',
							align: 'right',
							width: '50px'
						} ,
						{	id : "itemTitle",
							title: "Item Title",
							width: '200px'
						}  ,
						{	id : "modelYear",
							title: "Model Year",
							titleAlign: 'right',
							align: 'right',
							width: '100px'
						}  ,
						{	id : "carCompanyCd",
							title: "Company Cd",
							titleAlign: 'right',
							align: 'right',
							width: '100px'
						}  ,
						{	id : "carCompany",
							title: "Car Company",
							width: '100px'
						}  ,
						{	id : "makeCd",
							title: "Make Cd",
							width: '80px'
						}  ,
						{	id : "make",
							title: "Make",
							width: '100px'
						}  ,
						{	id : "motorNo",
							title: "Motor No",
							width: '100px'
						}  ,
						{	id : "serialNo",
							title: "Serial No",
							width: '100px'
						}  ,
						{	id : "plateNo",
							title: "Plate No",
							width: '100px'
						}  ,
						{	id : "basicColorCd",
							title: "Basic Color Cd",
							width: '100px'
						}  ,
						{	id : "basicColor",
							title: "Basic Color",
							width: '120px'
						}  ,
						{	id : "colorCd",
							title: "Color Cd",
							width: '80px'
						}  ,
						{	id : "color",
							title: "Color",
							width: '120px'
						}
						
					],
		draggable: true,
		onSelect: function(row){
			$("txtItemTitle").value = unescapeHTML2(row.itemTitle);
			$("txtCompany").value = unescapeHTML2(row.carCompany);
			$("txtMake").value = unescapeHTML2(row.make);
			$("txtMotorNo").value = unescapeHTML2(row.motorNo);
			$("txtSerialNo").value = unescapeHTML2(row.serialNo);
			$("txtPlateNo").value = unescapeHTML2(row.plateNo);
			$("txtBasicColor").value = unescapeHTML2(row.basicColor);
			$("txtColor").value = unescapeHTML2(row.color);
			$("txtModelYear").value = unescapeHTML2(row.modelYear);
			$("txtMotcarCompCd").value = unescapeHTML2(row.carCompanyCd);
			$("txtMakeCd").value = unescapeHTML2(row.makeCd);
			$("txtItemNo").value = formatNumberDigits(row.itemNo,5);
			$("txtBasicColorCd").value = unescapeHTML2(row.basicColorCd);
			$("txtColorCd").value = unescapeHTML2(row.colorCd);
			enableButton("btnActivate");
		},
  		onCancel: function(){
			$("txtItemNo").focus();
  		}
	  });
}