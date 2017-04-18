<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>				
<div id="cargoClassDiv" name="cargoClassDiv" style="margin: 10px;" >
	<div class="tableHeader" id="cargoClassTable" name="cargoClassTable">
		<label id="lblCargoClassDesc" style="text-align: left; margin-left: 5px;">Cargo Class</label>
	</div>
	<div id="cargoForDeleteDiv" name="cargoForDeleteDiv" style="visibility: hidden;">
	</div>
	<div id="cargoForInsertDiv" name="cargoForInsertDiv" style="visibility: hidden;">
	</div>
	<div class="tableContainer" id="cargoClassList" name="cargoClassList" style="overflow: scroll; text-align: left;">
		<c:forEach var="cargo" items="${openLiab.openCargos}">
			<div id="cargo${cargo.cargoClassCd}" name="rowCargo" class="tableRow" rowCd="${cargo.cargoClassCd}">
				<input type="hidden" id="cargoClassCd${cargo.cargoClassCd}"   	name="cargoClassCd"     value="${cargo.cargoClassCd}" />
				<input type="hidden" id="cargoClassDesc${cargo.cargoClassCd}" 	name="cargoClassDesc" 	value="${cargo.cargoClassDesc}" />
				<label style="text-align: left; margin-left: 5px;" title="${cargo.cargoClassDesc}" name="description" id="description${cargo.cargoClassCd}">${cargo.cargoClassDesc}</label>
		 	</div>
		</c:forEach>
	</div>
</div>
<div id="cargoClassFormDiv" name="cargoClassFormDiv" style="width: 100%; margin: 10px 0px 5px 0px;">
	<table width="79%">
		<tr>
			<td class="rightAligned" width="12%">Cargo Class</td>
			<td class="leftAligned" width="100%">
			<!--<input type="text" id="cargoClassDisplay" readonly="readonly" class="required" style="width: 100%; display: none;" />
			<div id="cargoClassDisplayDiv" class="required" style="width: 740px; height: 40px; vertical-align: text-bottom; border: solid 1px gray; display: none; white-space: nowrap; overflow-x: scroll;">
			 	<label id="cargoClassDisplay"></label>
			 </div>  
				<select id="inputCargoClass" name="inputCargoClass" style="width: 100%; overflow: scroll;" class="">
					<option value=""></option>
					<c:forEach var="class" items="${classes}">
						<option value="${class.cargoClassCd}" desc="${class.cargoClassDesc}">${class.cargoClassDesc}</option>
					</c:forEach>
				</select>-->
				<input type="hidden" id="inputCargoCd" name="inputCargoCd" value="" />
				<span class="lovSpan" style="width: 100%;">
					<!-- commented and changed by reymon 03122013
					<input type="text" id="inputCargoClass" name="inputCargoClass" readonly="readonly" style="width: 90%; float: left;"/>
					<div style="float: left; margin-left: 2px;">
					<img id="searchCargoClass" name="searchCargoClass" alt="Go" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" style="float: right;" >
					</div> -->
					<input id="inputCargoClass" name="inputCargoClass" type="text" style="border: none; float: left; width: 95%; height: 13px; margin: 0px;" readonly="readonly">
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCargoClass" name="searchCargoClass" alt="Go" style="float: right;"/>
				</span>
			</td>
		</tr>					
	</table>
</div>
<div style="float: left; width: 100%; margin-bottom: 10px;" align="center" >
	<input type="button" class="button" style="width: 60px;" id="btnAddCargoClass" name="btnAddCargoClass" value="Add" />
	<input type="button" class="disabledButton" style="width: 60px;" id="btnDeleteCargoClass" name="btnDeleteCargoClass" value="Delete" disabled="disabled" />
</div>
<script type="text/javascript" defer="defer">
	initializeTable("tableContainer", "rowCargo", "", "");
	checkIfToResizeTable("cargoClassList", "rowCargo");
	checkTableIfEmpty("rowCargo", "cargoClassDiv");
	
	$("btnAddCargoClass").observe("click", addCargoClass);
	$("btnDeleteCargoClass").observe("click", deleteCargoClass);

	$$("div[name='rowCargo']").each(function(row){
		//filterLOV2("inputCargoClass", "rowCargo", "", "id", row.id, "rowCd");
		row.observe("click", function(){
			if (row.hasClassName("selectedRow")) {
				setCargoClassForm(row);
			} else {
				setCargoClassForm(null);
			} 
		});
	});

	$$("label[name='description']").each(function(label){
		label.update(label.innerHTML.truncate(110 ,"..."));
	});

/*	var options = $("inputCargoClass").options;
	for(var i=0; i<options.length; i++){
		options[i].text = options[i].text.truncate(100, "...");
	}*/
	
	if ($$("div[name='rowCargo']").size() == 0){
		$("cargoClassList").setStyle("height: 0px;");
	}

	$("searchCargoClass").observe("click", function() {
		showOverlayContent2(contextPath+"/GIPIWOpenLiabController?action=showCargoClass", "Cargo Class LOV", 560, "");
	});
	
	function addCargoClass(){
		//var cargoClassCd   = $F("inputCargoClass");
		//var cargoClassDesc = $("inputCargoClass").options[$("inputCargoClass").selectedIndex].getAttribute("desc");
		var cargoClassCd	 = $F("inputCargoCd");
		var cargoClassDesc   = $F("inputCargoClass");
		var exists = false;
		$$("input[name='cargoClassCd']").each(function (c){
			if (c.value == cargoClassCd){
				exists = true;
			}
		});

		if (cargoClassCd == "") {
			showMessageBox("Please select a Cargo Class.");
			$("inputCargoClass").focus();
			return false;
		} else if (exists == true){
			showMessageBox("Cargo Class already exists in the list.");
			$("inputCargoClass").focus();
			return false;
		}
		
		changeTag = 1; //benjo 10.05.2015 GENQA-4994
		var cargoClassDiv  = $("cargoClassList");
		var cargoForInsertDiv = $("cargoForInsertDiv");
		var insertContent  = '<input type="hidden" id="insCargoClassCd'+cargoClassCd+'" name="insCargoClassCd"  value="'+cargoClassCd+'" />';

		var viewContent	   = '<input type="hidden" id="cargoClassCd'+cargoClassCd+'"   	name="cargoClassCd"     value="'+cargoClassCd+'" />'+
							 '<input type="hidden" id="cargoClassDesc'+cargoClassCd+'" 	name="cargoClassDesc" 	value="'+cargoClassDesc+'" />'+
							 '<label style="text-align: left; margin-left: 5px;" title="'+cargoClassDesc+'" name="description" id="description'+cargoClassCd+'">'+cargoClassDesc.truncate(110, "...")+'</label>';
						
		var newDiv = new Element("div");
		newDiv.setAttribute("id", "cargo"+cargoClassCd);
		newDiv.setAttribute("name", "rowCargo");
		newDiv.setAttribute("rowCd", cargoClassCd);
		newDiv.addClassName("tableRow");
		newDiv.setStyle("display: none;");
		newDiv.update(viewContent);

		cargoClassDiv.insert({bottom : newDiv});
			
		cargoForInsertDiv.insert({bottom : insertContent});

		newDiv.observe("mouseover", function ()	{
			newDiv.addClassName("lightblue");
		});
		
		newDiv.observe("mouseout", function ()	{
			newDiv.removeClassName("lightblue");
		});

		newDiv.observe("click", function(){
			// added by jdiago 07.08.2014 to unselect rows previously selected.
			$$("div[name='rowCargo']").each(function(x){
				if(x.readAttribute("id") != newDiv.readAttribute("id"))
					x.removeClassName("selectedRow");
			});
			
			newDiv.toggleClassName("selectedRow");
			if (newDiv.hasClassName("selectedRow"))	{
				setCargoClassForm(newDiv);
			} else {
				setCargoClassForm(null);
			} 
		});
		
		Effect.Appear(newDiv, {
			duration: .5,
			afterFinish: function () {
				setCargoClassForm(null);
			}
		});
		//filterLOV2("inputCargoClass", "rowCargo", "", "id", "cargo"+cargoClassCd, "rowCd");
		checkIfToResizeTable("cargoClassList", "rowCargo");
		checkTableIfEmpty("rowCargo", "cargoClassDiv");
	}

	function deleteCargoClass(){
		$$("div[name='rowCargo']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
			    changeTag = 1; //benjo 10.05.2015 GENQA-4994
				var cargoClassCd   = row.down("input", 0).value;
				var cargoForDeleteDiv = $("cargoForDeleteDiv");
				var deleteContent  = '<input type="hidden" id="delCargoClassCd'+ cargoClassCd +'" name="delCargoClassCd" value="'+ cargoClassCd +'" />';
						
				cargoForDeleteDiv.insert({bottom : deleteContent});

				$$("input[name='insCargoClassCd']").each(function(input){
					var id = input.getAttribute("id");
					if(id == "insCargoClassCd"+cargoClassCd){
						input.remove();
					}
				});
				
				Effect.Fade(row, {
					duration: .5,
					afterFinish: function () {
						//filterLOV2("inputCargoClass", "rowCargo", row.down("input", 0).value, "id", row.id, "rowCd");
						row.remove();
						checkIfToResizeTable("cargoClassList", "rowCargo");
						checkTableIfEmpty("rowCargo", "cargoClassDiv");
						setCargoClassForm(null);
					}
				});
			}
		});
	}

	function setCargoClassForm(row){
		/*if(row == null){
			$("inputCargoClass").selectedIndex = 0;
			$("cargoClassDisplay").clear();
			$("cargoClassDisplayDiv").hide();
			$("cargoClassDisplay").hide();
			$("inputCargoClass").show();
		} else {
			var s = $("inputCargoClass");
			var rowSelected;
			for (var i=0; i < s.length; i++) {
				if (s.options[i].value == row.down("input", 0).value)	{
					s.selectedIndex = i;
					rowSelected = row.down("input", 1).value;
				}
			}
			s.hide();
			$("cargoClassDisplay").value = rowSelected;
			$("cargoClassDisplay").innerHTML = rowSelected;			
			$("cargoClassDisplay").show();
		}*/
		$("inputCargoClass").value = row == null ? "" : row.down("input", 1).value;
		$("inputCargoCd").value = row == null ? "" : row.down("input", 0).value;
		(row == null ? $("searchCargoClass").show() : $("searchCargoClass").hide());
		(row == null ? enableButton("btnAddCargoClass") : disableButton("btnAddCargoClass"));
		(row == null ? disableButton("btnDeleteCargoClass") : enableButton("btnDeleteCargoClass"));
	}	
</script>