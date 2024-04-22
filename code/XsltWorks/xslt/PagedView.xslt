<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
	<xsl:import href="pager.xslt"/>
	<xsl:import href="scripts.xslt"/>

	<xsl:output method = "html" encoding="UTF-8" />

	<xsl:param name="arg1"/>


	<xsl:template match="/">

		<xsl:variable name="currentPage">
			<xsl:value-of select="number(//XsltPagerInfo/CurrentPage/text())"/>
		</xsl:variable>
		<xsl:variable name="pageSize">
			<xsl:value-of select="number(//XsltPagerInfo/PageSize/text())"/>
		</xsl:variable>

		<xsl:variable name="startCounter">
			<xsl:value-of select="number(//XsltPagerInfo/StartCounter/text())"/>
		</xsl:variable>

		<html>
			<head>
				<title>ThumbPageBrowser</title>
				<meta charset="UTF-8"/>
				<style>
					BODY
					{
					FONT-FAMILY: Calibri;
					}
					td
					{
					margin: 2px;
					padding: 2px;
					}
					.gray
					{
					background-color: #e8e8e8;
					}
				</style>
				<script>
					function btnClickAction(name)
					{
						window.chrome.webview.postMessage(name);
					}
				</script>				
			</head>
			<body>
				<!--
				<h2>arg1 : <xsl:value-of select="$arg1"/></h2>
				
				currentPage <xsl:value-of select="$currentPage"/>,
				pageSize <xsl:value-of select="$pageSize"/>,
				startCounter <xsl:value-of select="$startCounter"/>, 			
				
-->

				<!-- Pager here 
				<a href="file:///S:/PicWalkerTemp/folder_1030.html">folder</a>
				-->
				<br />
				<xsl:apply-templates select="//XsltPagerInfo"/>
				<br />

				<xsl:apply-templates select="/ArrayOfFileItem/FileItem">
					<xsl:with-param name="startCounter" select="$startCounter"/>

				</xsl:apply-templates>
				<br />
				<xsl:apply-templates select="//XsltPagerInfo"/>
				<br />
			</body>

			<xsl:call-template name="script" />
		</html>

	</xsl:template>

<!-- 
	width="400"
	;width:100%

-->

	<xsl:template match="FileItem">

		<xsl:param name="startCounter" />
		<xsl:variable name="id"><xsl:value-of select="FileId"/></xsl:variable>		
		
		<a href="#" onclick="btnClickAction('image {ID/text()}');return false;">
			<img style="max-width:400px;max-height:300px" >
				<xsl:attribute name="src">
					file:///<xsl:value-of select="FullName/text()"/>
				</xsl:attribute>
			</img>
		</a>
	</xsl:template>



</xsl:stylesheet>
