/**
 * Shows the list of values from giis_payees with the given payee_class_cd
 * @author Veronica V. Raymundo
 * 
 * Added Module Id - irwin 12.15.12
 * */
function getGiisPayeesList(payeeClassCd,moduleId){
	try{
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiisPayeeList", 
							payeeClassCd: nvl(payeeClassCd, '')},
			title: "",
			width: 600,
			height: 400,
			columnModel : [	{	id : "payeeNo",
								title: "Payee No",
								width: '60px',
								align: 'right'
							},
							{	id : "designation",
								title: "Designation",
								width: '80px'
							},
							{	id : "nbtPayeeName",
								title: "Payee Name",
								width: '150px'
							},
							{	id : "mailAddress",
								title: "Mail Address",
								width: '150px'
							},
							{	id : "phoneNo",
								title: "Phone No",
								width: '80px'
							},
							{	id : "contactPersons",
								title: "Contact Persons",
								width: '100px'
							}
						],
			draggable: true,
			onSelect: function(row){
				$("payee").value = unescapeHTML2(row.payeeNo +" - "+row.nbtPayeeName);
				$("payee").setAttribute("payeeNo", row.payeeNo);
				$("payee").focus();
				changeTag = 1;
				if(moduleId == "GIACS086"){
					adviceTGurl = "";
					adviceTGurl = "&payeeClassCd=" + row.payeeClassCd +"&payeeCd="+ row.payeeNo+"&condition=2";
					//adviceGrid.url +=  adviceTGurl;
					adviceGrid.url =  specialCSR.originalURL+adviceTGurl;
					adviceGrid._refreshList();
				}else if(moduleId == "GICLS030"){
					$("payee").value = unescapeHTML2(row.nbtPayeeName);
				}
			}
		  });
	}catch(e){
		showErrorMessage("getGiisPayeesList",e);
	}
}