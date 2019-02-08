 
[
{{~it.Db.TableList.TableInfo :value:index}}
   
   ####_BOF_ filename=api_masterTemplateOutput{{=index}}.html #### 
  
    { "tablename1": "{{=value['TableName']}}" },
  
   ####_EOF_ filename=api_masterTemplateOutput{{=index}}.html #### 

{{~}}
]
