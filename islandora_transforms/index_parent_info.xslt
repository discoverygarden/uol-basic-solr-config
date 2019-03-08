<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:string="xalan://java.lang.String"
  xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:mods="http://www.loc.gov/mods/v3">

  <xsl:template name="perform_ri_query">
    <xsl:param name="PID"/>
    <xsl:param name="risearch">http://localhost:8080/fedora/risearch</xsl:param>
    <xsl:param name="query"/>
    <xsl:param name="lang">sparql</xsl:param>
    <xsl:param name="additional_params"/>

    <xsl:variable name="encoded_query" select="encoder:encode(normalize-space(string:replaceAll($query, '%PID%', $PID)))"/>
    <xsl:variable name="query_url" select="concat($risearch, '?query=', $encoded_query, '&amp;lang=', $lang, $additional_params)"/>

    <xsl:copy-of select="document($query_url)"/>
  </xsl:template>

  <!-- Templates for indexing pinpointed info from parents. These have many-to-
       one and/or many-to-many relationships with documents, so ignoring the
       standard MODS indexing to ensure only multivalued fields are used. -->

   <xsl:template name="displayLabel_writer">
     <xsl:param name="content"/>
     <xsl:param name="prefix"/>
     <xsl:param name="suffix">_ms</xsl:param>
     <!-- Display Label. -->
     <xsl:for-each select="$content/mods:accessCondition/mods:displayLabel">
       <field>
         <xsl:attribute name="name">
           <xsl:value-of select="concat($prefix, 'mods_accessCondition_displayLabel', $suffix)"/>
         </xsl:attribute>
         <xsl:value-of select="text()"/>
       </field>
     </xsl:for-each>
   </xsl:template>


  <xsl:template name="type_writer">
    <xsl:param name="content"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix">_ms</xsl:param>
    <!-- AccessCondition: type. -->
    <xsl:for-each select="$content/mods:accessCondition/mods:type">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'mods_accessCondition_type', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="dateOther_writer">
    <xsl:param name="content"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix">_ms</xsl:param>
    <!-- OriginInfo: dateOther. -->
    <xsl:for-each select="$content/mods:originInfo/mods:dateOther[@encoding='w3cdtf' and @type='embargo']">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, 'mods_originInfo_dateOther_encoding_embargo', $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </field>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

