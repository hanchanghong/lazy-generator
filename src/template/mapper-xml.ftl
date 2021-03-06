<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${mapperPackage}.${table.moduleNameCapi}Mapper">
	<resultMap type="${table.moduleName}Entity" id="${table.moduleName}Map" autoMapping="true">
<#list table.fields as key> 
	<#if key.isPrimaryKey = "1"> 
		<id column="${key.column}" property="${key.field}" />
	<#else> 
		<result column="${key.column}" property="${key.field}" />
	</#if>
</#list>
	</resultMap>
	
<#if table.joinTables??>
 <#list table.joinTables as keys> 
 <#if keys.type=="one-to-one">
	<resultMap type="${table.moduleName}Entity" id="${keys.moduleName}Map" extends="${table.moduleName}Map" autoMapping="true">
		<association property="${keys.moduleName}Entity" ofType="${keys.moduleName}Entity" column="${keys.foreignKey}">
  <#list keys.fields as key> 
	<#if key.isPrimaryKey = "1"> 
		<id column="${key.column}_${keys_index}" property="${key.field}" />
	<#else> 
		<result column="${key.column}_${keys_index}" property="${key.field}" />
	</#if>
  </#list>
		</association>
	</resultMap>
  <#elseif keys.type=="one-to-many">
  	<resultMap type="${table.moduleName}Entity" id="${keys.moduleName}Map" extends="${table.moduleName}Map" autoMapping="true">
		<collection property="${keys.moduleName}List" ofType="${keys.moduleName}Entity" column="${keys.foreignKey}">
  <#list keys.fields as key> 
	<#if key.isPrimaryKey = "1"> 
		<id column="${key.column}_${keys_index}" property="${key.field}" />
	<#else> 
		<result column="${key.column}_${keys_index}" property="${key.field}" />
	</#if>
  </#list>
		</collection>
	</resultMap>
  </#if>
 </#list>
  	<#if (table.joinTables?size>1)>
  	<resultMap type="${table.moduleName}Entity" id="${table.moduleName}AllJoinMap" extends="${table.moduleName}Map" autoMapping="true">
 		<#list table.joinTables as keys> 
 		<#if keys.type=="one-to-one">
		<association property="${keys.moduleName}Entity" ofType="${keys.moduleName}Entity" column="${keys.foreignKey}">
  		<#list keys.fields as key> 
		<#if key.isPrimaryKey = "1"> 
		<id column="${key.column}_${keys_index}" property="${key.field}" />
		<#else> 
		<result column="${key.column}_${keys_index}" property="${key.field}" />
		</#if>
  		</#list>
		</association>
  		<#elseif keys.type=="one-to-many">
		<collection property="${keys.moduleName}List" ofType="${keys.moduleName}Entity" column="${keys.foreignKey}">
  		<#list keys.fields as key> 
		<#if key.isPrimaryKey = "1"> 
		<id column="${key.column}_${keys_index}" property="${key.field}" />
		<#else> 
		<result column="${key.column}_${keys_index}" property="${key.field}" />
		</#if>
  		</#list>
		</collection>
  		</#if>
 		</#list>
	</resultMap>  
   	</#if>
</#if>

	<sql id="example_where_sql">
	    <where>
	      <foreach collection="example.criteriaList" item="criteria" separator="or">
	        <if test="criteria.valid">
	          <trim prefix="(" prefixOverrides="and" suffix=")">
	            <foreach collection="criteria.criteria" item="criterion">
	              <choose>
	                <when test="criterion.valueType=='noValue'">
	                  and t.${r"${criterion.condition}"}
	                </when>
	                <when test="criterion.valueType=='singleValue'">
	                  and t.${r"${criterion.condition}"} ${r"#{criterion.value}"}
	                </when>
	                <when test="criterion.valueType=='fieldValue'">
	                  and t.${r"${criterion.condition}"} t.${r"${criterion.value}"}
	                </when>
	                <when test="criterion.valueType=='betweenValue'">
	                  and t.${r"${criterion.condition}"} ${r"#{criterion.value}"} and ${r"#{criterion.secondValue}"}
	                </when>
	                <when test="criterion.valueType=='listValue'">
	                  and t.${r"${criterion.condition}"}
	                  <foreach close=")" collection="criterion.value" item="listItem" open="(" separator=",">
	                    ${r"#{listItem}"}
	                  </foreach>
	                </when>
	              </choose>
	            </foreach>
	          </trim>
	        </if>
	      </foreach>
	    </where>
  	</sql>
  	<#if table.joinTables??>
	<sql id="join_example_where_sql">
      <trim prefix="and ">
      <foreach collection="joinExample.criteriaList" item="criteria" separator="or">
        <if test="criteria.valid">
          <trim prefix="(" prefixOverrides="and" suffix=")">
            <foreach collection="criteria.criteria" item="criterion">
              <choose>
                <when test="criterion.valueType=='noValue'">
                  and t1.${r"${criterion.condition}"}
                </when>
                <when test="criterion.valueType=='singleValue'">
                  and t1.${r"${criterion.condition}"} ${r"#{criterion.value}"}
                </when>
                <when test="criterion.valueType=='fieldValue'">
                  and t1.${r"${criterion.condition}"} t1.${r"${criterion.value}"}
                </when>                
                <when test="criterion.valueType=='betweenValue'">
                  and t1.${r"${criterion.condition}"} ${r"#{criterion.value}"} and ${r"#{criterion.secondValue}"}
                </when>
                <when test="criterion.valueType=='listValue'">
                  and t1.${r"${criterion.condition}"}
                  <foreach close=")" collection="criterion.value" item="listItem" open="(" separator=",">
                    ${r"#{listItem}"}
                  </foreach>
                </when>
              </choose>
            </foreach>
          </trim>
        </if>
      </foreach>
      </trim>
  	</sql>
  	</#if>
	<insert id="save" useGeneratedKeys="true" keyProperty="${primaryKey.field}" parameterType="${entityPackage}.${table.moduleNameCapi}Entity">
		insert into ${table.tableName} (
	  	<#list table.fields as key>
	  	  <#if key.extra != "auto_increment">
			${key.columnDelimit}<#if key_has_next>,</#if>
		  </#if>
		</#list>
	    )values (
	    <#list table.fields as key>
	      <#if key.extra != "auto_increment">
	        ${r"#{"}${key.field}${r"}"}<#if key_has_next>,</#if>
	      </#if>
		</#list>
	    )
	</insert>
	
	<insert id="saveSelective" useGeneratedKeys="true" keyProperty="${primaryKey.field}" parameterType="${entityPackage}.${table.moduleNameCapi}Entity">
		insert into ${table.tableName} (
		<trim suffixOverrides=",">
	  	<#list table.fields as key>
	  	  <#if key.extra != "auto_increment">
	  	   <if test="${key.field} != null">
			${key.columnDelimit}<#if key_has_next>,</#if>
		   </if>
		  </#if>
		</#list>
		</trim>
	    )values (
	    <trim suffixOverrides=",">
	    <#list table.fields as key>
	    <#if key.extra != "auto_increment">
	      <if test="${key.field} != null">
	       ${r"#{"}${key.field}${r"}"}<#if key_has_next>,</#if>
		   </if>
		  </#if>
		</#list>
		</trim>
	    )
	</insert>
	
	<delete id="deleteByPrimaryKey" parameterType="java.lang.String">
		 delete from ${table.tableName}
         where ${primaryKey.field} = ${r"#{"}${primaryKey.field}${r"}"}
	</delete>
	
	<delete id="deleteByExample" parameterType="map">
		 delete from ${table.tableName} t
    <if test="example != null">
      <include refid="example_where_sql" />
    </if>
	</delete>
	
	<update id="updateByPrimaryKey" parameterType="${entityPackage}.${table.moduleNameCapi}Entity">
		update 	${table.tableName} t set 
		<choose>
           <when test="updateColumns != null"> 
           	${r"${updateColumns}"}
           </when>
           <otherwise>
			<#list table.fields as key> 
			<#if key.isPrimaryKey != "1">
				t.${key.column} = ${r"#{"}${key.field}${r"}"}<#if key_has_next>,</#if>
			</#if>
			</#list>
		   </otherwise>
        </choose>
		 where ${primaryKey.column} = ${r"#{"}${primaryKey.field}${r"}"}
	</update>
	
	<update id="updateByPrimaryKeySelective" parameterType="${entityPackage}.${table.moduleNameCapi}Entity">
		update 	${table.tableName} t
		<choose>
           <when test="updateColumns != null"> 
           	set ${r"${updateColumns}"}
           </when>
          <otherwise>
	        <set> 
			<#list table.fields as key> 
			<#if key.isPrimaryKey != "1">
		  	   <if test="${key.field} != null">
				t.${key.column} = ${r"#{"}${key.field}${r"}"},
			   </if>
			</#if>
			</#list>
			</set>
		  </otherwise>
        </choose>
        where ${primaryKey.column} = ${r"#{"}${primaryKey.field}${r"}"}
	</update>
	
	<update id="updateByExample" parameterType="map">
		update 	${table.tableName} t set 
		<choose>
           <when test="entity != null and entity.updateColumns != null"> 
           	${r"${entity.updateColumns}"}
           </when>
           <otherwise>
			<#list table.fields as key> 
			<#if key.isPrimaryKey != "1">
				t.${key.column} = ${r"#{entity."}${key.field}${r"}"}<#if key_has_next>,</#if>
			</#if>
			</#list>
		   </otherwise>
        </choose>
    <if test="example != null">
      <include refid="example_where_sql" />
    </if>
	</update>

	<update id="updateByExampleSelective" parameterType="map">
		update 	${table.tableName} t
		<choose>
           <when test="entity != null and entity.updateColumns != null"> 
           	set ${r"${entity.updateColumns}"}
           </when>
          <otherwise>
	        <set> 
			<#list table.fields as key> 
			<#if key.isPrimaryKey != "1">
		  	   <if test="entity.${key.field} != null">
				t.${key.column} = ${r"#{entity."}${key.field}${r"}"},
			   </if>
			</#if>
			</#list>
			</set>
		  </otherwise>
        </choose>		
	    <if test="example != null">
	      <include refid="example_where_sql" />
	    </if>
	</update>

	<select id="countByExample"  parameterType="map" resultType="java.lang.Integer">
	    select count(*) from ${table.tableName} t
    <if test="example != null">
      <include refid="example_where_sql" />
    </if>
	</select>
	
	<select id="queryByPrimaryKey"  parameterType="java.lang.String" resultMap="${table.moduleName}Map">
	    select *		
 		from ${table.tableName}
 		where ${primaryKey.column} = ${r"#{"}${primaryKey.field}${r"}"}
	</select>
	
	<select id="queryByExample"  parameterType="${entityPackage}.${table.moduleNameCapi}Example" resultMap="${table.moduleName}Map">
	    select 
		<choose>
            <when test="example.selectColumns != null"> ${r"${example.selectColumns}"}</when>
            <otherwise> * </otherwise>
         </choose>
 		from ${table.tableName} t
	<if test="example != null">
      <include refid="example_where_sql" />
	  <if test="example.orderBy!=null">
	    	order by
	    	<foreach collection="example.orderBy.keys" item="k" separator=",">   
			   ${r"t.${k} ${example.orderBy[k]}"}
			</foreach>   
	   </if>	    
	   <if test="example.start !=null and example.size != null">
			limit ${r"#{example.start},#{example.size}"}
		</if>
    </if>
	</select>
<#if table.joinTables??>
 <#list table.joinTables as keys>
	<select id="query${keys.moduleNameCapi}ByPrimaryKey"  parameterType="map" resultMap="${keys.moduleName}Map">
	    select t.*,
  <#list keys.fields as key>
  			t${keys_index+1}.${key.column} ${key.column}_${keys_index} <#if key_has_next>,</#if>
  </#list>  
 		from ${table.tableName} t
 		left join ${keys.tableName} t1  on t.${primaryKey.field} = t1.${keys.foreignKey}
	 	<if test="joinExample != null">
	    	<include refid="join_example_where_sql" />
	    </if>
 		where t.${primaryKey.field} = ${r"#{primaryKey}"}
	</select>
	
	<select id="query${keys.moduleNameCapi}ByExample"  parameterType="map" resultMap="${keys.moduleName}Map">
	    select t.*,
  			<#list keys.fields as key>
  			t1.${key.column} ${key.column}_${keys_index} <#if key_has_next>,</#if>
  			</#list>  
 		from ${table.tableName} t
 		left join ${keys.tableName} t1  on t.${primaryKey.field} = t1.${keys.foreignKey}
	 	<if test="joinExample != null">
	    	<include refid="join_example_where_sql" />
	    </if>
	    <if test="example != null">
			<include refid="example_where_sql" />
			<if test="example.orderBy!=null">
				order by
				<foreach collection="example.orderBy.keys" item="k" separator=",">
					${r"t.${k} ${example.orderBy[k]}"}
				</foreach>
			</if>
			<if test="example.start !=null and example.size != null">
				limit ${r"#{example.start},#{example.size}"}
			</if>	
	    </if>
    
	</select>
 </#list>
 	<#if (table.joinTables?size>1)>
	<select id="queryAllJoinByPrimaryKey"  parameterType="map" resultMap="${table.moduleName}AllJoinMap">
	    select t.*,
	  <#list table.joinTables as keys>
		  <#list keys.fields as key>t${keys_index+1}.${key.column} ${key.column}_${keys_index}<#if key_has_next>,</#if>
		  </#list> <#if keys_has_next>,</#if>
	  </#list>
 		from ${table.tableName} t
 		<#list table.joinTables as keys>		
 		left join ${keys.tableName} t${keys_index+1}  on t.${primaryKey.field} = t${keys_index+1}.${keys.foreignKey}
	 	<if test="${keys.moduleName}Example != null">
          <trim prefix="and ">
           <foreach collection="${keys.moduleName}Example.criteriaList" item="criteria" separator="or">
	        <if test="criteria.valid">
	          <trim prefix="(" prefixOverrides="and" suffix=")">
	            <foreach collection="criteria.criteria" item="criterion">
	              <choose>
	                <when test="criterion.noValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"}
	                </when>
	                <when test="criterion.singleValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"} ${r"#{criterion.value}"}
	                </when>
	                <when test="criterion.betweenValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"} ${r"#{criterion.value}"} and ${r"#{criterion.secondValue}"}
	                </when>
	                <when test="criterion.listValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"}
	                  <foreach close=")" collection="criterion.value" item="listItem" open="(" separator=",">
	                    ${r"#{listItem}"}
	                  </foreach>
	                </when>
	              </choose>
	            </foreach>
	          </trim>
	        </if>
	      </foreach>
	      </trim>
	    </if>
 		</#list>	    
 		where t.${primaryKey.field} = ${r"#{primaryKey}"}
	</select>
	<select id="queryAllJoinByExample"  parameterType="map" resultMap="${table.moduleName}AllJoinMap">
	    select t.*,
	  	<#list table.joinTables as keys>
		  <#list keys.fields as key>t${keys_index+1}.${key.column} ${key.column}_${keys_index}<#if key_has_next>,</#if>
		  </#list> <#if keys_has_next>,</#if>
	  	</#list>
 		from ${table.tableName} t
 		<#list table.joinTables as keys>		
 		left join ${keys.tableName} t${keys_index+1}  on t.${primaryKey.field} = t${keys_index+1}.${keys.foreignKey}
	 	<if test="${keys.moduleName}Example != null">
	 	<trim prefix="and ">
           <foreach collection="${keys.moduleName}Example.criteriaList" item="criteria" separator="or">
	        <if test="criteria.valid">
	          <trim prefix="(" prefixOverrides="and" suffix=")">
	            <foreach collection="criteria.criteria" item="criterion">
	              <choose>
	                <when test="criterion.noValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"}
	                </when>
	                <when test="criterion.singleValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"} ${r"#{criterion.value}"}
	                </when>
	                <when test="criterion.betweenValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"} ${r"#{criterion.value}"} and ${r"#{criterion.secondValue}"}
	                </when>
	                <when test="criterion.listValue">
	                  and t${keys_index+1}.${r"${criterion.condition}"}
	                  <foreach close=")" collection="criterion.value" item="listItem" open="(" separator=",">
	                    ${r"#{listItem}"}
	                  </foreach>
	                </when>
	              </choose>
	            </foreach>
	          </trim>
	        </if>
	      </foreach>
	     </trim>
	    </if>
 		</#list>	    
 		<if test="example != null">
	      <include refid="example_where_sql" />
		  <if test="example.orderBy!=null">
		    	order by
		    	<foreach collection="example.orderBy.keys" item="k" separator=",">   
				    ${r"t.${k} ${example.orderBy[k]}"}
				</foreach>   
		   </if>	    
		   <if test="example.start !=null and example.size != null">
				limit ${r"#{example.start},#{example.size}"}
			</if>
	    </if>
	</select>
	</#if>
</#if>



</mapper>