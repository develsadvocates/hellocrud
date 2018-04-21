{{- $tableNameSingular := .Table.Name | singular -}}
{{- $modelName := $tableNameSingular | titleCase -}}
{{- $modelNameCamel := $tableNameSingular | camelCase -}}
{{- $pkColNames := .Table.PKey.Columns -}}

// SchemaSearch{{$modelName}}Input is the schema search input for {{$modelName}}
var SchemaSearch{{$modelName}}Input = `
# Search{{$modelName}}Input is a search input/arguments type for {{$modelName}} resources
input Search{{$modelName}}Input {
	{{range $column := .Table.Columns }}
	{{- if containsAny $pkColNames $column.Name }}
	{{- else if eq $column.Name "created_by" }}
	{{- else if eq $column.Name "created_at" }}
	{{- else if eq $column.Name "updated_by" }}
	{{- else if eq $column.Name "updated_at" }}
	{{- else if eq $column.Type "[]byte" }}
	  {{camelCase $column.Name}}: String
	{{- else if eq $column.Type "bool" }}
	  {{camelCase $column.Name}}: Boolean
	{{- else if eq $column.Type "float32" }}
	  {{camelCase $column.Name}}: Float
	{{- else if eq $column.Type "float64" }}
	  {{camelCase $column.Name}}: Float
	{{- else if eq $column.Type "int" }}
	  {{camelCase $column.Name}}: Int
	{{- else if eq $column.Type "int16" }}
	  {{camelCase $column.Name}}: Int
	{{- else if eq $column.Type "int64" }}
	  {{camelCase $column.Name}}: Int64
	{{- else if eq $column.Type "null.Bool" }}
	  {{camelCase $column.Name}}: Boolean
	{{- else if eq $column.Type "null.Byte" }}
	  {{camelCase $column.Name}}: string
	{{- else if eq $column.Type "null.Bytes" }}
	  {{camelCase $column.Name}}: string
	{{- else if eq $column.Type "null.Float64" }}
	  {{camelCase $column.Name}}: Float
	{{- else if eq $column.Type "null.Int" }}
	  {{camelCase $column.Name}}: Int
	{{- else if eq $column.Type "null.Int16" }}
	  {{camelCase $column.Name}}: Int
	{{- else if eq $column.Type "null.Int64" }}
	  {{camelCase $column.Name}}: Int64
	{{- else if eq $column.Type "null.JSON" }}
	  {{camelCase $column.Name}}: String
	{{- else if eq $column.Type "null.String" }}
	  {{camelCase $column.Name}}: String
	{{- else if eq $column.Type "null.Time" }}
	  {{camelCase $column.Name}}: Time
	{{- else if eq $column.Type "string" }}
	  {{camelCase $column.Name}}: String
	{{- else if eq $column.Type "time.Time" }}
	  {{camelCase $column.Name}}: Time
	{{- else if eq $column.Type "types.Byte" }}
	  {{camelCase $column.Name}}: String
	{{- else if eq $column.Type "types.JSON" }}
	  {{camelCase $column.Name}}: String
	{{- end -}}
	{{- end }}
}
`

// search{{$modelName}}Input is an object to back {{$modelName}} search arguments input type
type search{{$modelName}}Input struct {
{{range $column := .Table.Columns }}
{{- if containsAny $pkColNames $column.Name }}
{{- else if eq $column.Type "[]byte" }}
  {{titleCase $column.Name}} *[]byte `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "bool" }}
  {{titleCase $column.Name}} *bool `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "float32" }}
  {{titleCase $column.Name}} *float64 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "float64" }}
  {{titleCase $column.Name}} *float64 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "int" }}
  {{titleCase $column.Name}} *int32 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "int16" }}
  {{titleCase $column.Name}} *int32 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "int64" }}
  {{titleCase $column.Name}} *Int64 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Bool" }}
  {{titleCase $column.Name}} *bool `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Byte" }}
  {{titleCase $column.Name}} *byte `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Bytes" }}
  {{titleCase $column.Name}} *[]byte `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Float64" }}
  {{titleCase $column.Name}} *float64 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Int" }}
  {{titleCase $column.Name}} *int32 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Int16" }}
  {{titleCase $column.Name}} *int32 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Int64" }}
  {{titleCase $column.Name}} *Int64 `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.JSON" }}
  {{titleCase $column.Name}} *[]byte `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.String" }}
  {{titleCase $column.Name}} *string `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "null.Time" }}
  {{titleCase $column.Name}} *graphql.Time `json:"{{$column.Name }}"`
{{- else if eq $column.Type "string" }}
  {{titleCase $column.Name}} *string `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "time.Time" }}
  {{titleCase $column.Name}} *graphql.Time `json:"{{$column.Name }}"`
{{- else if eq $column.Type "types.Byte" }}
  {{titleCase $column.Name}} *string `json:"{{$column.Name }}"` 
{{- else if eq $column.Type "types.JSON" }}
  {{titleCase $column.Name}} *string `json:"{{$column.Name }}"` 
{{- end -}}
{{- end }}
}

// QueryMods returns a list of QueryMod based on the struct values
func (s *search{{$modelName}}Input) QueryMods() []qm.QueryMod {
  mods := []qm.QueryMod{}
  // Get reflect value
  v := reflect.ValueOf(s).Elem()
  // Iterate struct fields
  for i := 0; i < v.NumField(); i++ {
    field := v.Type().Field(i) // StructField
    value := v.Field(i) // Value
    if value.IsNil() || !value.IsValid() {
      // Skip if field is nil
      continue
    }

    // Get column name from tags
    column, hasColumnName := field.Tag.Lookup("json")
    // Skip if no DB definition
    if !hasColumnName {
      continue
    }

    operator := "="
    val := value.Elem().Interface()
    if dataType := field.Type.String(); (dataType == "string" || dataType == "*string") &&
      val.(string) != "" {
      operator = "LIKE"
      val = fmt.Sprintf("%%%s%%", val)
    }
    mods = append(mods, qm.And(fmt.Sprintf("%s %s ?", column, operator), val))
  }
  return mods
}
