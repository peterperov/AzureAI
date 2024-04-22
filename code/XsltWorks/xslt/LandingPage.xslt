<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>

	<xsl:output method = "html" encoding="UTF-8" />
	<xsl:param name="arg1"/>

	<xsl:template match="/">

		<html>
			<head>
				<title>Process Report</title>
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
				
				file:///
				<xsl:copy-of select="ArrayOfFileItem" />
-->
				<h1>Azure AI Services</h1>

				<hr />
				<h2>Original Video</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='video']" mode="video">
				</xsl:apply-templates>

				<hr />
				<h2>Extracted Audio</h2>
				<hr />
				<table>
					<xsl:apply-templates select="//FileItem[Type='audio']" mode="audio">
					</xsl:apply-templates>
				</table>
				<hr />
				<h2>Azure Speech Recogniser - Speech to Text Recognition</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='text']" mode="text">
				</xsl:apply-templates>

				<hr />
				<h2>Azure OpenAI ChatGPT Service - Summarization</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='summary_all']" mode="text">
				</xsl:apply-templates>

				<hr />
				<h2>Azure Translator Service - Summary translated</h2>
				<hr />
				<xsl:apply-templates select="//FileItem[Type='translated_summary']" mode="text">
				</xsl:apply-templates>		
				
				<hr />
				<h2>Azure Text to Speech - Summary Audio</h2>
				<hr />
				<table>
					<xsl:apply-templates select="//FileItem[Type='summary_audio']" mode="audio">
					</xsl:apply-templates>
				</table>

				<hr />
				<textarea readonly="true">
					<xsl:copy-of select="."/>
				</textarea>

			</body>

		</html>

	</xsl:template>


	<xsl:template match="FileItem" mode="text">
		<b>
			<xsl:value-of select="Name"/>
		</b>
		<br />

		<textarea rows="10" cols="50">

			<xsl:value-of select="Content"/>
		</textarea>

		<br />
	</xsl:template>

	<xsl:template match="FileItem" mode="audio">

		<tr>
			<td>
				<audio controls="true">
					<source type="audio/wav">
						<xsl:attribute name="src">
							file:///<xsl:value-of select="FileName/text()"/>
						</xsl:attribute>
					</source>
				</audio>
			</td>
			<td>
				<b>
					<xsl:value-of select="Name"/>
				</b>
			</td>

		</tr>

	</xsl:template>

	<xsl:template match="FileItem" mode="video">
		<b>
			<xsl:value-of select="Name"/>
		</b>
		<br />
		<xsl:value-of select="FileName"/>
		<video controls="true" width="600">
			<source type="audio/wav">
				<xsl:attribute name="src">
					file:///<xsl:value-of select="FileName/text()"/>
				</xsl:attribute>
			</source>
		</video>
		<br />

	</xsl:template>


</xsl:stylesheet>


