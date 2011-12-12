<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output omit-xml-declaration="yes"/>
	<xsl:template match="/">
	<xsl:if test=".//@key and .//doi">
		<xsl:value-of select=".//@key"/>|<xsl:value-of select=".//doi"/><xsl:text>
</xsl:text>
</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>

