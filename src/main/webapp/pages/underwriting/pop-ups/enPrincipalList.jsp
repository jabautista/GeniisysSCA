<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% 	
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="principalMainDiv" name="principalMainDiv">
	<div id="enPrincipalsDiv${pType}" name="enPrincipalsDiv${pType}" style="margin: 10px; width: 500px;"  changeTagAttr="true">
		<div class="tableHeader" id="carrierInfoTable" name="carrierInfoTable">
			<label style="width: 120px; text-align: left; margin-left: 5px;">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor Code</c:when>
					<c:otherwise>Principal</c:otherwise>
				</c:choose>
			</label>
			<label style="width: 320px; text-align: left; margin-left: 5px;">
				<c:choose>	
					<c:when test="${pType=='C'}">Contractor Name</c:when>
					<c:otherwise>Principal Name</c:otherwise>
				</c:choose>
			</label>
			<label style="width: 20px; text-align: center; margin-left: 5px;"><c:if test="${pType=='C'}">S</c:if></label>
		</div>
		<div id="forDeleteDiv${pType}" name="forDeleteDiv${pType}" style="visibility: hidden;">
		</div>
		<div id="forInsertDiv${pType}" name="forInsertDiv${pType}" style="visibility: hidden;">
		</div> 
		<div id="enPrincipalTable${pType}" name="enPrincipalTable${pType}" class="tableContainer">
		</div>
	</div>
	
	<div id="enPrincipalFormFiv" name="enPrincipalFormDiv" style="width: 100%; margin: 10px 0px 5px 0px">
		<table align="center" style="width: 420px;">
			<tr>
				<td class="rightAligned" width="20%">
					<c:choose>	
						<c:when test="${pType=='C'}">Contractor</c:when>
						<c:otherwise>Principal</c:otherwise>
					</c:choose>
				</td>
				<td class="leftAligned" width="80%">
					<select id="inputPrincipal${pType}" name="inputPrincipal${pType}" style="width: 98%;"></select>
				</td>
			</tr>
			<c:if test="${pType=='C'}">
				<tr>
					<td class="rightAligned" width="20%">Subcon SW</td>
					<td class="leftAligned" width="80%">
						<input type="checkbox" id="chkSubconSw${pType}" name="chkSubconSw${pType}" value="N"/>
					</td>
				</tr>
			</c:if>
		</table>		
	</div>
	
	<div style="margin-bottom: 10px;">
		<input type="button" class="button" style="width: 60px;" id="btnAdd${pType}" name="btnAdd${pType}" value="Add" />
		<input type="button" class="disabledButton" style="width: 60px;" disabled="disabled" id="btnDel${pType}" name="btnDel${pType}" value="Delete" />
	</div>
</div>


<script type="text/javascript" defer="defer">

	var pType = '${pType}';
	var addBtn = $("btnAdd"+pType);
	var delBtn = $("btnDel"+pType);
	var objPrincipalListing = JSON.parse('${principals}'.replace(/\\/g, '\\\\'));
	var objENPrincipals = JSON.parse('${enPrincipals}'.replace(/\\/g, '\\\\'));
	var selectedPrn;
	
	addStyleToInputs();
	
	setPrincipalListing(objPrincipalListing, objENPrincipals);
	showPrincipals(objENPrincipals);

	addBtn.observe("click", function() {
		if(addBtn.value == "Update") {
			addPrincipal(selectedPrn);
		} else {
			addPrincipal(null);
		}
	});
	delBtn.observe("click", function() {		
		delPrincipal(selectedPrn);
	});
	
	function setPrincipalListing(objLOV, objItems) {
		$("inputPrincipal"+pType).update('<option principalCd="" value=""></option>');
		var options = "";
		var exists;
		for(var i=0; i<objLOV.length; i++) {
			exists = false;
			for(var j=0; j<objItems.length; j++) {
				if(objItems[j].principalCd == objLOV[i].principalCd) {
					exists = true;
				}
			}
			if(exists == false) {
				options = '<option value="'+objLOV[i].principalCd+'" principalType="'+objLOV[i].principalType+'" >'+objLOV[i].principalName+'</option>';
			} else {
				options = '<option value="'+objLOV[i].principalCd+'" principalType="'+objLOV[i].principalType+'" style="display: none" disabled="disabled">'+objLOV[i].principalName+'</option>';	
			}
			$("inputPrincipal"+pType).insert({bottom: options});	
		}
		$("inputPrincipal"+pType).selectedIndex = 0;
	}

	function showPrincipals(objArray) {
		try {
			var prnTable = $("enPrincipalTable"+pType);

			for(var i=0; i<objArray.length; i++ ) {
				var content = preparePrincipalInfo(objArray[i]);
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "prn"+pType+objArray[i].principalCd);
				newDiv.setAttribute("name", "prn"+pType);
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				prnTable.insert({bottom: newDiv});
				
				checkIfToResizeTable("enPrincipalTable"+pType, "prn"+pType);
				checkTableIfEmpty("prn"+pType, "enPrincipalsDiv"+pType);
			}
		} catch(e) {
			showErrorMessage("showPrincipals", e);
			//showMessageBox("showPrincipals: " + e.message);
		}
	}

	function preparePrincipalInfo(obj) {
		try {
			var principal = '<label style="width: 120px; text-align: left; margin-left: 5px;" name="principalCd'+pType+'" title="'+ obj.principalCd +'">'+ obj.principalCd +'</label>' +
							'<label style="width: 320px; text-align: left; margin-left: 5px;" name="principalName'+pType+'" title="'+ obj.principalName +'">'+ obj.principalName.truncate(45, "...") +'</label>';
			if(pType=="C") {
				//principal+= '<label style="width: 20px; text-align: center; margin-left: 5px;" name="subconSW'+pType+'">'+obj.subconSW+'</label>';
				var subcon = obj.subconSW == null ? "N" : obj.subconSW;
				if(subcon == "Y") {
					principal+='<img name="checkedImg" class="printCheck" src="'+ checkImgSrc +'" style="width: 10px; height: 10px; text-align: center; display: block; margin-left: 10px;"/>';
				}
			}
			return principal;
		} catch(e) {
			showErrorMessage("preparePrincipalInfo", e);
			//showMessageBox("preparePrincipalInfo: " + e.message);
		}
	}


	/* checkbox
	<c:if test="${'N' eq cov.aggregateSw or empty cov.aggregateSw}">
		<span style='width: 10px; height: 10px; text-align: left; display: block;' ></span>
	</c:if>
	<c:if test="${'Y' eq cov.subconSW}">
		<img name='checkedImg' class='printCheck' style='width: 10px; height: 10px; text-align: center; display: block; margin-left: 10px;'/>
	</c:if>
	*/

	$$("div#enPrincipalsDiv"+pType+" div[name='prn"+pType+"']").each(function(row) {
		row.observe("mouseover", function() {
			row.addClassName("lightblue");
		});

		row.observe("mouseout", function() {
			row.removeClassName("lightblue");
		});

		row.observe("click", function() {
			clickPrn(row);
		});
	});

	function clickPrn(row) {
		selectedPrn = null;
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")) {
			var tempPrn = row.down("label", 0).innerHTML;
			
			for(var i=0; i<objENPrincipals.length; i++) {
				if(objENPrincipals[i].principalCd == tempPrn) {
					selectedPrn = objENPrincipals[i];
					break;
				}
			}
			setPrincipalForm(selectedPrn);

			$$("div#enPrincipalsDiv"+pType+" div[name='prn"+pType+"']").each(function(p) {
				if(row.getAttribute("id") != p.getAttribute("id")) {
					p.removeClassName("selectedRow");
				}
			});
		} else {
			setPrincipalForm(null);
		}		
	}

	function setPrincipalForm(obj) {
		try {
			if(obj==null) {
				$("inputPrincipal"+pType).selectedIndex = 0;
			} else {
				var principals = $("inputPrincipal"+pType);
				for(var i=0; i<=objPrincipalListing.length; i++) {
					if(principals.options[i].value == obj.principalCd) {
						principals.selectedIndex = i;
					}
				}
			}
			if(pType=="C") {
				$("chkSubconSw"+pType).checked = obj == null ? false : (obj.subconSW == "Y" ? true : false);
			}
			
			$("inputPrincipal"+pType).value = (obj == null ? "" : obj.principalName);
			addBtn.value = (obj == null ? "Add" : "Update");
			(obj == null ? disableButton(delBtn) : enableButton(delBtn));
		} catch(e) {
			showErrorMessage("setPrincipalForm", e);
			//showMessageBox("setPrincipalForm: " + e.message);
		}
	}

	function addPrincipal(obj) {
		try {
			var newObj = setPrincipal();
			var content = preparePrincipalInfo(newObj);
			var objItemTemp;
			
			if($("inputPrincipal"+pType).value == "" && pType == "P") {
				showMessageBox("Please select a Principal first");
				$("inputPrincipal"+pType).focus();
				return false;
			} else if ($("inputPrincipal"+pType).value == "" && pType == "C") {
				showMessageBox("Please select a Contractor first");
				$("inputPrincipal"+pType).focus();
				return false;
			} else {
				if(obj == null) {
					newObj.status = 0;
					var prnTable = $("enPrincipalTable"+pType);
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "prn"+pType+newObj.principalCd);
					newDiv.writeAttribute("new");
					newDiv.setAttribute("name", "prn"+pType);
					newDiv.addClassName("tableRow");

					newDiv.update(content);
					prnTable.insert({bottom : newDiv});

					newDiv.observe("mouseover", function(){
						newDiv.addClassName("lightblue");
					});

					newDiv.observe("mouseout", function(){
						newDiv.removeClassName("lightblue");
					});

					newDiv.observe("click", function() {
						clickPrn(newDiv);
					});
				} else {
					if(obj.principalCd == newObj.principalCd) {
						$("prn"+pType+obj.principalCd).update(content);
						setENPrincipalObj(obj, 0);
					} else {
						delPrincipal(obj);
						addPrincipal(null);
					}
				}
				changeTag = 1;
				setPrincipalForm(null);
				checkIfToResizeTable("enPrincipalTable"+pType, "prn"+pType);
				checkTableIfEmpty("prn"+pType, "enPrincipalsDiv"+pType);
				addToPrnList(newObj);
				setENPrincipalObj(newObj, 1);
				setPrincipalListing(objPrincipalListing, objENPrincipals);
			}	
		} catch(e) {
			showErrorMessage("addPrincipal", e);
			//showMessageBox("addPrincipal: " + e.message);
		}	
	}

	function addToPrnList(newObj) {
		var exists = false;
		for(var i=0; i<objENPrincipals.length; i++) {
			if(objENPrincipals[i].principalCd == newObj.principalCd) {
				exists = true;
			}
		}
		if(exists == false) {
			objENPrincipals.push(newObj);
		}
	}

	function removeItem(obj) {
		for(var i=0; i<objENPrincipals.length; i++) {
			if(objENPrincipals[i].principalCd == obj.principalCd) {
				objENPrincipals.splice(i,1);
			}
		}
	}

	function delPrincipal(delObj) {
		try {
			var prnCd = delObj.principalCd;
			$$("div#enPrincipalsDiv"+pType+" div[name='prn"+pType+"']").each(function(row) {
				if(row.down("label", 0).innerHTML == prnCd) {
					Effect.Fade(row, {
						duration: .2,
						afterFinish: function() {
							row.remove();
							delObj.status = -1;
							setENPrincipalObj(delObj, 0);
							removeItem(delObj);
							setPrincipalListing(objPrincipalListing, objENPrincipals);
							setPrincipalForm(null);
							checkIfToResizeTable("enPrincipalTable"+pType, "prn"+pType);
							checkTableIfEmpty("prn"+pType, "enPrincipalsDiv"+pType);
						}
					});
					changeTag = 1;
				}
			});
			
		} catch(e) {
			showErrorMessage("delPrincipal", e);
			//showMessagebox("Delete Principal: " + e.message);
		}
	}

	function setPrincipal() {
		try {
			var newObj = new Object();

			var subconChecked = nvl($("chkSubconSw"+pType), false) == false ? "N" :
								($("chkSubconSw"+pType).checked == true ? "Y" : "N");
			
			newObj.principalCd = $F("inputPrincipal"+pType);
			newObj.principalName = $("inputPrincipal"+pType).options[$("inputPrincipal"+pType).selectedIndex].text;
			newObj.subconSW = subconChecked;
			return newObj;
		} catch(e) {
			showErrorMessage("setPrincipal", e);
			//showMessageBox("set new principal object: " + e.message);
		}
	}

</script>