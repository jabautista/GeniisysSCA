<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div class="sectionDiv" style="width: 498px; margin-top: 5px;">
	<table align="center" style="margin-top: 10px;">
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Province</td>
			<td class="leftAligned">
				<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
					<input type="text" id="txtProvinceCd" ignoreDelKey="true" style="width: 55px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="6"/> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgProvinceCd" alt="Go" style="float: right;"/>
				</span>
				<input id="txtProvinceDesc" type="text" style="width: 300px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
			</td>
		</tr>
		
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">City</td>
			<td class="leftAligned">
				<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
					<input type="text" id="txtCityCd" ignoreDelKey="true" style="width: 55px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="6"/> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgCityCd" alt="Go" style="float: right;"/>
				</span>
				<input id="txtCity" type="text" style="width: 300px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">District</td>
			<td class="leftAligned">
				<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
					<input type="text" id="txtDistrictNo" ignoreDelKey="true" style="width: 55px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="6"/> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDistrictNo" alt="Go" style="float: right;"/>
				</span>
				<input id="txtDistrictDesc" type="text" style="width: 300px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Block</td>
			<td class="leftAligned">
				<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
					<input type="text" id="txtBlockNo" ignoreDelKey="true" style="width: 55px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="6"/> 
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBlockNo" alt="Go" style="float: right;"/>
				</span>
				<input id="txtBlockDesc" type="text" style="width: 300px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
			</td>
		</tr>
	</table>
	<div style="text-align: center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px; margin: 10px auto;"/>
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("txtProvinceCd").value = unescapeHTML2(objFireDetails.provinceCd);
		$("txtProvinceDesc").value = unescapeHTML2(objFireDetails.provinceDesc);
		$("txtProvinceCd").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.provinceCd));
		$("txtProvinceDesc").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.provinceDesc));
		
		$("txtCityCd").value = unescapeHTML2(objFireDetails.cityCd);
		$("txtCity").value = unescapeHTML2(objFireDetails.city);
		$("txtCityCd").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.cityCd));
		$("txtCity").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.city));
		
		$("txtDistrictNo").value = unescapeHTML2(objFireDetails.districtNo);
		$("txtDistrictDesc").value = unescapeHTML2(objFireDetails.districtDesc);
		$("txtDistrictNo").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.districtNo));
		$("txtDistrictDesc").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.districtDesc));
		
		$("txtBlockNo").value = unescapeHTML2(objFireDetails.blockNo);
		$("txtBlockDesc").value = unescapeHTML2(objFireDetails.blockDesc);
		$("txtBlockNo").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.blockNo));
		$("txtBlockDesc").setAttribute("lastValidValue", unescapeHTML2(objFireDetails.blockDesc));
		
		function getProvinceLov() {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls056ProvinceLov",
					filterText : ($("txtProvinceCd").value != $("txtProvinceCd").readAttribute("lastValidValue") ? $("txtProvinceCd").value : ""),
					page : 1,
					moduleId : "GICLS056"
				},
				title : "List of Provinces",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "provinceCd",
					title : "Code",
					width : 120,
				}, {
					id : "provinceDesc",
					title : "Description",
					width : 345
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  ($("txtProvinceCd").value != $("txtProvinceCd").readAttribute("lastValidValue") ? $("txtProvinceCd").value : ""),
				onSelect : function(row) {
					
					if(unescapeHTML2(row.provinceCd) != $("txtProvinceCd").readAttribute("lastValidValue")){
						$("txtCityCd").clear();
						$("txtCity").clear();
						$("txtCityCd").setAttribute("lastValidValue", "");
						$("txtCity").setAttribute("lastValidValue", "");
						
						$("txtDistrictNo").clear();
						$("txtDistrictDesc").clear();
						$("txtDistrictNo").setAttribute("lastValidValue", "");
						$("txtDistrictDesc").setAttribute("lastValidValue", "");
						
						$("txtBlockNo").clear();
						$("txtBlockDesc").clear();
						$("txtBlockNo").setAttribute("lastValidValue", "");
						$("txtBlockDesc").setAttribute("lastValidValue", "");
						
						objFireDetails.cityCd = "";
						objFireDetails.city = "";
						objFireDetails.districtNo = "";
						objFireDetails.districtDesc = "";
						objFireDetails.blockNo = "";
						objFireDetails.blockDesc = "";
					}
					
					$("txtProvinceCd").value = unescapeHTML2(row.provinceCd);
					$("txtProvinceDesc").value = unescapeHTML2(row.provinceDesc);
					$("txtProvinceCd").setAttribute("lastValidValue", $F("txtProvinceCd"));
					$("txtProvinceDesc").setAttribute("lastValidValue", $F("txtProvinceDesc"));
					
					objFireDetails.provinceCd =  unescapeHTML2(row.provinceCd);
					objFireDetails.provinceDesc = unescapeHTML2(row.provinceDesc);
				},
				onCancel : function () {
					$("txtProvinceCd").value = $("txtProvinceCd").readAttribute("lastValidValue");
					$("txtProvinceDesc").value = $("txtProvinceDesc").readAttribute("lastValidValue");
					$("txtProvinceCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtProvinceCd");
					$("txtProvinceCd").value = $("txtProvinceCd").readAttribute("lastValidValue");
					$("txtProvinceDesc").value = $("txtProvinceDesc").readAttribute("lastValidValue");
					$("txtProvinceCd").focus();
					
				}
			});
		}
		
		$("imgProvinceCd").observe("click", getProvinceLov);
		
		function getCityLov() {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls056CityLov",
					filterText : ($("txtCityCd").value != $("txtCityCd").readAttribute("lastValidValue") ? $("txtCityCd").value : ""),
					provinceCd : $("txtProvinceCd").value,
					page : 1,
					moduleId : "GICLS056"
				},
				title : "List of Cities",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "cityCd",
					title : "Code",
					width : '120px',
				}, {
					id : "city",
					title : "Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  ($("txtCityCd").value != $("txtCityCd").readAttribute("lastValidValue") ? $("txtCityCd").value : ""),
				onSelect : function(row) {
					
					if(unescapeHTML2(row.cityCd) != $("txtCityCd").readAttribute("lastValidValue")){						
						$("txtDistrictNo").clear();
						$("txtDistrictDesc").clear();
						$("txtDistrictNo").setAttribute("lastValidValue", "");
						$("txtDistrictDesc").setAttribute("lastValidValue", "");
						
						$("txtBlockNo").clear();
						$("txtBlockDesc").clear();
						$("txtBlockNo").setAttribute("lastValidValue", "");
						$("txtBlockDesc").setAttribute("lastValidValue", "");
						
						objFireDetails.districtNo = "";
						objFireDetails.districtDesc = "";
						objFireDetails.blockNo = "";
						objFireDetails.blockDesc = "";
					}
					
					$("txtCityCd").value = unescapeHTML2(row.cityCd);
					$("txtCity").value = unescapeHTML2(row.city);
					$("txtCityCd").setAttribute("lastValidValue", $F("txtCityCd"));
					$("txtCity").setAttribute("lastValidValue", $("txtCity"));
					
					objFireDetails.cityCd =row.cityCd;
					objFireDetails.city = row.city;
				},
				onCancel : function () {
					$("txtCityCd").value = $("txtCityCd").readAttribute("lastValidValue");
					$("txtCity").value = $("txtCity").readAttribute("lastValidValue");
					$("txtCityCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCityCd");
					$("txtCityCd").value = $("txtCityCd").readAttribute("lastValidValue");
					$("txtCity").value = $("txtCity").readAttribute("lastValidValue");
					$("txtCityCd").focus();
					
				}
			});
		}
		
		$("imgCityCd").observe("click", getCityLov);
		
		function getDistrictLov() {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls056DistrictLov",
					filterText : ($("txtDistrictNo").value != $("txtDistrictNo").readAttribute("lastValidValue") ? $("txtDistrictNo").value : ""),
					cityCd : $("txtCityCd").value,
					provinceCd : $("txtProvinceCd").value,
					page : 1,
					moduleId : "GICLS056"
				},
				title : "List of Districts",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "districtNo",
					title : "Number",
					width : '120px',
				}, {
					id : "districtDesc",
					title : "Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($("txtDistrictNo").value != $("txtDistrictNo").readAttribute("lastValidValue") ? $("txtDistrictNo").value : ""),
				onSelect : function(row) {
					
					if(unescapeHTML2(row.districtNo) != $("txtDistrictNo").readAttribute("lastValidValue")){
						$("txtBlockNo").clear();
						$("txtBlockDesc").clear();
						$("txtBlockNo").setAttribute("lastValidValue", "");
						$("txtBlockDesc").setAttribute("lastValidValue", "");
						
						objFireDetails.blockNo = "";
						objFireDetails.blockDesc = "";
					}
					
					$("txtDistrictNo").value = unescapeHTML2(row.districtNo);
					$("txtDistrictDesc").value = unescapeHTML2(row.districtDesc);
					$("txtDistrictNo").setAttribute("lastValidValue", $F("txtDistrictNo"));
					$("txtDistrictDesc").setAttribute("lastValidValue", $F("txtDistrictDesc"));
					
					objFireDetails.districtNo = row.districtNo;
					objFireDetails.districtDesc = row.districtDesc;
				},
				onCancel : function () {
					$("txtDistrictNo").value = $("txtDistrictNo").readAttribute("lastValidValue");
					$("txtDistrictDesc").value = $("txtDistrictDesc").readAttribute("lastValidValue");
					$("txtDistrictNo").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDistrictNo");
					$("txtDistrictNo").value = $("txtDistrictNo").readAttribute("lastValidValue");
					$("txtDistrictDesc").value = $("txtDistrictDesc").readAttribute("lastValidValue");
					$("txtDistrictNo").focus();
				}
			});
		}
		
		$("imgDistrictNo").observe("click", getDistrictLov);
		
		function getBlockLov() {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGicls056BlockLov",
					filterText : ($("txtBlockNo").value != $("txtBlockNo").readAttribute("lastValidValue") ? $("txtBlockNo").value : ""),
					cityCd : $("txtCityCd").value,
					provinceCd : $("txtProvinceCd").value,
					districtNo : $("txtDistrictNo").value,
					page : 1,
					moduleId : "GICLS056"
				},
				title : "List of Blocks",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "blockNo",
					title : "Number",
					width : '120px',
				}, {
					id : "blockDesc",
					title : "Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($("txtBlockNo").value != $("txtBlockNo").readAttribute("lastValidValue") ? $("txtBlockNo").value : ""),
				onSelect : function(row) {
					$("txtBlockNo").value = unescapeHTML2(row.blockNo);
					$("txtBlockDesc").value = unescapeHTML2(row.blockDesc);
					$("txtBlockNo").setAttribute("lastValidValue", $F("txtBlockNo"));
					$("txtBlockDesc").setAttribute("lastValidValue", $F("txtBlockDesc"));
					
					objFireDetails.blockNo = row.blockNo;
					objFireDetails.blockDesc = row.blockDesc;
				},
				onCancel : function () {
					$("txtBlockNo").value = $("txtBlockNo").readAttribute("lastValidValue");
					$("txtBlockDesc").value = $("txtBlockDesc").readAttribute("lastValidValue");
					$("txtBlockNo").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBlockNo");
					$("txtBlockNo").value = $("txtBlockNo").readAttribute("lastValidValue");
					$("txtBlockDesc").value = $("txtBlockDesc").readAttribute("lastValidValue");
					$("txtBlockNo").focus();					
				}
			});
		}
		
		$("imgBlockNo").observe("click", getBlockLov);
		
		$("btnReturn").observe("click", function(){
			
			objFireDetails.provinceCd = $F("txtProvinceCd");
			objFireDetails.provinceDesc = $F("txtProvinceDesc");
			objFireDetails.cityCd = $F("txtCityCd");
			objFireDetails.city = $F("txtCity");
			objFireDetails.districtNo = $F("txtDistrictNo");
			objFireDetails.districtDesc = $F("txtDistrictDesc");
			objFireDetails.blockNo = $F("txtBlockNo");
			objFireDetails.blockDesc = $F("txtBlockDesc");
			
			overlayFireInfo.close();
			delete overlayFireInfo;
		});
		
		$("txtProvinceCd").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtProvinceCd").clear();
				$("txtProvinceDesc").clear();
				$("txtProvinceCd").setAttribute("lastValidValue", "");
				$("txtProvinceDesc").setAttribute("lastValidValue", "");
				
				$("txtCityCd").clear();
				$("txtCity").clear();
				$("txtCityCd").setAttribute("lastValidValue", "");
				$("txtCity").setAttribute("lastValidValue", "");
				
				$("txtDistrictNo").clear();
				$("txtDistrictDesc").clear();
				$("txtDistrictNo").setAttribute("lastValidValue", "");
				$("txtDistrictDesc").setAttribute("lastValidValue", "");
				
				$("txtBlockNo").clear();
				$("txtBlockDesc").clear();
				$("txtBlockNo").setAttribute("lastValidValue", "");
				$("txtBlockDesc").setAttribute("lastValidValue", "");
				
				objFireDetails.provinceCd = "";
				objFireDetails.provinceDesc = "";
				objFireDetails.cityCd = "";
				objFireDetails.city = "";
				objFireDetails.districtNo = "";
				objFireDetails.districtDesc = "";
				objFireDetails.blockNo = "";
				objFireDetails.blockDesc = "";
			} else
				getProvinceLov();
		});
		
		$("txtCityCd").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtCityCd").clear();
				$("txtCity").clear();
				$("txtCityCd").setAttribute("lastValidValue", "");
				$("txtCity").setAttribute("lastValidValue", "");
				
				$("txtDistrictNo").clear();
				$("txtDistrictDesc").clear();
				$("txtDistrictNo").setAttribute("lastValidValue", "");
				$("txtDistrictDesc").setAttribute("lastValidValue", "");
				
				$("txtBlockNo").clear();
				$("txtBlockDesc").clear();
				$("txtBlockNo").setAttribute("lastValidValue", "");
				$("txtBlockDesc").setAttribute("lastValidValue", "");
				
				objFireDetails.cityCd = "";
				objFireDetails.city = "";
				objFireDetails.districtNo = "";
				objFireDetails.districtDesc = "";
				objFireDetails.blockNo = "";
				objFireDetails.blockDesc = "";
			} else
				getCityLov();
		});
		
		$("txtDistrictNo").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtDistrictNo").clear();
				$("txtDistrictDesc").clear();
				$("txtDistrictNo").setAttribute("lastValidValue", "");
				$("txtDistrictDesc").setAttribute("lastValidValue", "");
				
				$("txtBlockNo").clear();
				$("txtBlockDesc").clear();
				$("txtBlockNo").setAttribute("lastValidValue", "");
				$("txtBlockDesc").setAttribute("lastValidValue", "");
				
				objFireDetails.districtNo = "";
				objFireDetails.districtDesc = "";
				objFireDetails.blockNo = "";
				objFireDetails.blockDesc = "";
			} else
				getDistrictLov();
		});
		
		$("txtBlockNo").observe("change", function(){
			if(this.value.trim() == ""){
				$("txtBlockNo").clear();
				$("txtBlockDesc").clear();
				$("txtBlockNo").setAttribute("lastValidValue", "");
				$("txtBlockDesc").setAttribute("lastValidValue", "");
				
				objFireDetails.blockNo = "";
				objFireDetails.blockDesc = "";
			} else
				getBlockLov();
		});
		
		initializeAll();
		
		if($F("txtCatastrophicCd") != ""){
			$("txtProvinceCd").readOnly = true;
			$("txtCityCd").readOnly = true;
			$("txtDistrictNo").readOnly = true;
			$("txtBlockNo").readOnly = true;
			
			disableSearch("imgProvinceCd");
			disableSearch("imgCityCd");
			disableSearch("imgDistrictNo");
			disableSearch("imgBlockNo");
		}
	} catch (e) {
		showErrorMessage("Fire Details", e);
	}
</script>