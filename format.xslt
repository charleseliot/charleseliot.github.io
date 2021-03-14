<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

<xsl:template match="/">
  <html>
	<head>
		<link rel="stylesheet" type="text/css" href="style.css" />
	</head>
    <body>
      <h1>The Changeling</h1>
      <xsl:apply-templates select="//castList"/>
      <xsl:apply-templates select="//text/body"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="castList">
  <h2>Cast List</h2>
  <div class="castlist">
		<xsl:apply-templates select="castGroup/castItem"/>
  </div>
</xsl:template>

<xsl:template match="role">
	<xsl:apply-templates select="name"/>
</xsl:template>

<xsl:template match="role/name">
	<div class="rolename">
		<xsl:apply-templates select="*"/>
	</div>
</xsl:template>

<xsl:template match="roleDesc">
	<div class="roledecription">
		<i>
			<xsl:apply-templates select="*"/>
		</i>
	</div>
</xsl:template>

<xsl:template match="text/body">
  <xsl:apply-templates select="*/div[@type = 'act'] | div[@type = 'epilogue']"/>
</xsl:template>


<xsl:template match="div">
	<div class="act">
		<xsl:apply-templates select="head | sp | stage"/>
		<br/>
	</div>
</xsl:template>

<xsl:comment>
sp tags come in two flavors:

sp
  speaker
	  ab
  	  stuff
	  	stuff
		  stuff

and

sp
  speaker
	  ab
		  seg
			  stuff
				stuff
				stuff
	
	
</xsl:comment>


<xsl:template match="sp">
	<xsl:apply-templates select="speaker"/>
	<xsl:apply-templates select="ab"/>
	<div class="linenumber">&#160;</div>
	<div class="line">&#160;</div>
</xsl:template>

<xsl:template match="speaker">
	<div class="linenumber"> </div>
	<div class="speaker">
		<b><xsl:apply-templates select="*"/></b>
	</div>
</xsl:template>

<xsl:template match="stage">
	<div class="stage">
		<br/>
		<i><xsl:apply-templates select="*" mode="stage"/></i>
		<br/>
		<br/>
	</div>
</xsl:template>

<xsl:template match="stage[@rend = 'inline']">
	<i><xsl:apply-templates select="*"/></i>
</xsl:template>

<xsl:comment>
Ridiculously complex bit here for dealing with speech text.
</xsl:comment>

<xsl:template match="ab">
	<xsl:call-template name="line-builder"/>
</xsl:template>


<xsl:template name="line-builder">
	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="local-name() = 'seg'">
				<xsl:call-template name="line-builder"/>
			</xsl:when>
			<xsl:when test="local-name() = 'milestone'">
				<xsl:if test="position() != 1">
					<xsl:text disable-output-escaping="yes"><![CDATA[</div>]]></xsl:text>
				</xsl:if>
				<div class="linenumber">
					  <xsl:value-of select="number(substring(@xml:id,5))"/>
				</div>
				<xsl:text disable-output-escaping="yes"><![CDATA[<div class="line">]]></xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:if test="milestone">
		<xsl:text disable-output-escaping="yes"><![CDATA[</div>]]></xsl:text>
	</xsl:if>
</xsl:template>




<xsl:template match="c">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="w">
  <xsl:value-of select="choice/reg[contains(@resp, '#SHC')]"/>
</xsl:template>

<xsl:template match="speaker/w">
  <xsl:value-of select="choice/reg[contains(@resp, '#EMED')]"/>
</xsl:template>

<xsl:template match="pc">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="lb[@n and (not(@break) or @break!='no')]">
  <br/>
</xsl:template>

<xsl:template match="metamark[@rend = 'turnunder' or @rend = 'turnover']" xml:space="preserve"> </xsl:template>

<xsl:template match="milestone[@unit = 'wln' and not(@ana = 'turnover' or @ana = 'turnunder')]">
	<div class="linenumber">
		xxx
	</div>
</xsl:template>

<xsl:template match="fw">
</xsl:template>

<xsl:template match="gap">
  <i>[gap]</i>
</xsl:template>

<xsl:template match="note">
  <i>[note]</i>
</xsl:template>

<xsl:comment>
Templates for rendering stage instructions
</xsl:comment>

<xsl:template match="w" mode = "stage">
  <xsl:value-of select="choice/reg[contains(@resp, '#EMED')]"/>
</xsl:template>

<xsl:template match="c" mode = "stage">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="pc" mode = "stage">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="metamark[@rend = 'turnunder' or @rend = 'turnover']" xml:space="preserve" mode = "stage"> </xsl:template>


<xsl:template match="head">
	<div class="stage">
		<h2><xsl:apply-templates select="*"/></h2>
	</div>
</xsl:template>


</xsl:stylesheet>
