/*
 * Date Author Description ========== ===============
 * ============================== 10.20.2011 mark jm lov for assured listing
 * 05.18.2012 Nica added parameter line code 05.22.2012 Irwin added func
 * parameter to call
 * 12.08.014 Apollo Cruz added filterText
 */
function showAssuredListingTG(lineCd, func, onCancelFunc, filterText) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIISAssuredLOVTG",
				filterText : ( filterText == undefined || filterText == null) ? "" : filterText,
				page : 1
			},
			title : "Search Assured Name",
			width : 600,
			height : 400,
			columnModel : [ {
				id : "assdNo",
				title : lineCd == "SU" ? "Principal No." : "Assured No.",
				width : '120px',
				align : 'right'
			}, {
				id : "assdName",
				title : lineCd == "SU" ? "Principal Name" : "Assured Name",
				width : '440px'
			},
			// comment out by andrew - 02.16.2012
			/*
			 * { id : "birthdate", title : "Birthday", width : '80px', renderer :
			 * function(value){ value = value == "" ? "" : dateFormat(value,
			 * "mm-dd-yyyy"); // added condition because the dateFormat function
			 * returns a system date when the value is null. -irwin return
			 * value; } },
			 */
			/*
			 * { id : "mailAddress1", title : "Address", width : '400px' }
			 */
			],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("assuredNo").value = row.assdNo;
					$("assuredName").value = unescapeHTML2(row.assdName);
					$("address1").value = unescapeHTML2(row.mailAddress1);
					$("address2").value = unescapeHTML2(row.mailAddress2);
					$("address3").value = unescapeHTML2(row.mailAddress3);
					//jmm SR-22834
					globalAddress1 = $("address1").value;
					globalAddress2 = $("address2").value;
					globalAddress3 = $("address3").value;
					globalAssdNo = $("assuredNo").value;
					globalAssdName = $("assuredName").value;
					//end
					if ($("industry") != null || $("indusrty") != undefined) {
						$("industry").value = row.industryCd;
					}

					changeTag = 1;

					if ($("allowMultipleAssuredSw") != null
							|| $("allowMultipleAssuredSw") != undefined) {
						$("allowMultipleAssuredSw").value = "false";
					}
					
					if (func != "" && func != null) {
						func();
					}
				}
			},
			onUndefinedRow: function() {
				showWaitingMessageBox("No record selected.", imgMessage.INFO, onCancelFunc);				
			},
			onCancel: onCancelFunc
		});
	} catch (e) {
		showErrorMessage("showAssuredListingTG", e);
	}
}