<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="colorThemeMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left; height: 85px;" id="">
		<div style="float: left; margin: 10px; height: 100px;">
			<div id="colorContainer2" style="float: left;">
				<span class="color" id="darkblue" style="background-color: #2c4762;"></span>
				<span class="color" id="blue" style="background-color: #0066CC;"></span>			
				<span class="color" id="gray" style="background-color: #A0A0A0;"></span>
				<span class="color" id="purple" style="background-color: #45008A;"></span>
				<span class="color" id="maroon" style="background-color: #800000;"></span>
				<span class="color" id="green" style="background-color: #007D47;"></span>
			</div>
		</div>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnClose" name="btnClose" value="Close" style="width: 80px;">	
	</div>	
</div>
<script type="text/javascript">
	$("btnClose").observe("click", function(){
		ovlColorTheme.close();
		delete ovlColorTheme;
	});

 	function changeColorTheme(color) {
		$("commonCss").href = contextPath+"/css/color_theme/common-"+color+".css";
		$("menuCss").href = contextPath+"/css/color_theme/ddsmoothmenu-"+color+".css";
		$("alphacube").href = contextPath+"/css/themes/alphacube-"+color+".css";
		checkImgSrc = contextPath+"/css/image_themes/check-"+color+".gif";

		changeCheckImageColor();

		//$("imgBanner").src = contextPath+"/css/color_theme/images/backgrounds/"+color+"/geniisys.gif";
	}

	$$(".color").each(function (c) {
		c.observe("click", function () {
			c.toggleClassName("selectedColor");
			changeColorTheme(c.readAttribute("id"));
		});
	});
</script>